from __future__ import annotations

import ipaddress
import socket
from dataclasses import dataclass
from urllib.parse import urlsplit

ALLOWED_SCHEMES = {"http", "https"}
ALLOWED_PORTS = {None, 80, 443}
BLOCKED_HOSTNAMES = {
    "localhost",
    "localhost.localdomain",
    "metadata",
    "metadata.google.internal",
    "instance-data",
}


class UnsafeTarget(ValueError):
    def __init__(self, reason: str):
        super().__init__(reason)
        self.reason = reason


@dataclass(frozen=True)
class ValidatedTarget:
    url: str
    hostname: str
    port: int | None
    resolved_ips: tuple[str, ...] = ()


def classify_ip(value: str) -> str:
    ip = ipaddress.ip_address(value)
    if ip.is_loopback:
        return "LOOPBACK"
    if ip.is_private:
        return "PRIVATE"
    if ip.is_link_local:
        return "LINK_LOCAL"
    if ip.is_multicast:
        return "MULTICAST"
    if ip.is_reserved:
        return "RESERVED"
    if ip.is_unspecified:
        return "UNSPECIFIED"
    return "PUBLIC"


def _legacy_ipv4(host: str) -> str | None:
    """Normalize inet_aton-style numeric IPv4 forms (decimal/hex/octal/short)."""
    try:
        packed = socket.inet_aton(host)
    except OSError:
        return None
    return socket.inet_ntoa(packed)


def _normalize_hostname(raw: str) -> str:
    host = raw.rstrip(".").lower()
    try:
        return host.encode("idna").decode("ascii")
    except UnicodeError as exc:
        raise UnsafeTarget("IDNA_INVALID") from exc


def validate_url_syntax(url: str) -> ValidatedTarget:
    if not isinstance(url, str) or not url or len(url) > 2048:
        raise UnsafeTarget("URL_LENGTH_INVALID")
    try:
        p = urlsplit(url)
        port = p.port
    except ValueError as exc:
        raise UnsafeTarget("MALFORMED_URL") from exc
    scheme = p.scheme.lower()
    if scheme not in ALLOWED_SCHEMES:
        raise UnsafeTarget("SCHEME_BLOCKED")
    if p.username or p.password:
        raise UnsafeTarget("URL_CREDENTIALS_BLOCKED")
    if not p.hostname:
        raise UnsafeTarget("HOST_MISSING")
    if port not in ALLOWED_PORTS:
        raise UnsafeTarget("PORT_BLOCKED")
    host = _normalize_hostname(p.hostname)
    if host in BLOCKED_HOSTNAMES or host.endswith(".localhost"):
        raise UnsafeTarget("HOST_BLOCKED")

    # Strict IP literals, including IPv6.
    try:
        cls = classify_ip(host)
    except ValueError:
        cls = None
    if cls and cls != "PUBLIC":
        raise UnsafeTarget(f"IP_{cls}_BLOCKED")

    # Legacy numeric IPv4 spellings accepted by OS resolvers, e.g. 2130706433 or 0x7f000001.
    legacy = _legacy_ipv4(host)
    if legacy is not None:
        cls = classify_ip(legacy)
        if cls != "PUBLIC":
            raise UnsafeTarget(f"IP_{cls}_BLOCKED")
        host = legacy

    return ValidatedTarget(url=url, hostname=host, port=port)


def validate_resolved_ips(ips: list[str] | tuple[str, ...]) -> tuple[str, ...]:
    if not ips:
        raise UnsafeTarget("DNS_EMPTY")
    clean: list[str] = []
    for raw in ips:
        try:
            ip = ipaddress.ip_address(raw)
            cls = classify_ip(str(ip))
        except ValueError as exc:
            raise UnsafeTarget("DNS_INVALID_IP") from exc
        if cls != "PUBLIC":
            raise UnsafeTarget(f"RESOLVED_{cls}_BLOCKED")
        clean.append(str(ip))
    return tuple(sorted(set(clean)))


def resolve_and_validate(target: ValidatedTarget) -> ValidatedTarget:
    scheme = urlsplit(target.url).scheme.lower()
    port = target.port or (443 if scheme == "https" else 80)
    try:
        records = socket.getaddrinfo(target.hostname, port, type=socket.SOCK_STREAM)
    except socket.gaierror as exc:
        raise UnsafeTarget("DNS_FAILURE") from exc
    ips = [r[4][0] for r in records]
    validated = validate_resolved_ips(ips)
    return ValidatedTarget(url=target.url, hostname=target.hostname, port=target.port, resolved_ips=validated)


def choose_pinned_ip(ips: tuple[str, ...]) -> str:
    """Prefer IPv4 for broad Twisted compatibility, else use the first validated IPv6."""
    if not ips:
        raise UnsafeTarget("DNS_EMPTY")
    for value in ips:
        if ipaddress.ip_address(value).version == 4:
            return value
    return ips[0]
