"""Pinned HTTPS requests through an explicit loopback HTTP CONNECT proxy."""
from __future__ import annotations

import hashlib
import http.client
import ipaddress
import json
import re
import socket
import ssl
from contextlib import contextmanager
from urllib.parse import parse_qsl, quote, urlencode, urlsplit

DOH_IP = "1.1.1.1"
DOH_HOST = "cloudflare-dns.com"
MAX_DNS_BYTES = 65_536
_DNS_LABEL = re.compile(r"(?=^.{1,253}$)(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?)(?:\.(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?))*$", re.I)


class SafeProxyError(RuntimeError):
    def __init__(self, code: str):
        super().__init__(code)
        self.code = code


def validate_https_url(url: str):
    if not isinstance(url, str) or not url or any(ord(ch) < 33 or ord(ch) > 126 for ch in url) or "\\" in url:
        raise SafeProxyError("SAFE_URL_INVALID")
    try:
        parsed = urlsplit(url)
    except ValueError as exc:
        raise SafeProxyError("SAFE_URL_INVALID") from exc
    if (parsed.scheme.lower() != "https" or not parsed.netloc or parsed.username is not None
            or parsed.password is not None or parsed.fragment or "%" in parsed.netloc):
        raise SafeProxyError("SAFE_URL_INVALID")
    try:
        port = parsed.port
        host = (parsed.hostname or "").lower().rstrip(".")
    except ValueError as exc:
        raise SafeProxyError("SAFE_URL_INVALID") from exc
    try:
        ipaddress.ip_address(host)
    except ValueError:
        pass
    else:
        raise SafeProxyError("SAFE_URL_IP_LITERAL_REJECTED")
    if not host.isascii() or not _DNS_LABEL.fullmatch(host):
        raise SafeProxyError("SAFE_URL_HOST_INVALID")
    if host == "localhost" or host.endswith((".localhost", ".local", ".internal", ".home.arpa")):
        raise SafeProxyError("SAFE_URL_LOCAL_HOST_REJECTED")
    if port not in (None, 443):
        raise SafeProxyError("SAFE_URL_PORT_REJECTED")
    for key, _ in parse_qsl(parsed.query, keep_blank_values=True):
        key = key.lower()
        if any(term in key for term in ("token", "signature", "secret", "auth", "credential", "cookie", "key")):
            raise SafeProxyError("SAFE_URL_SENSITIVE_QUERY_REJECTED")
    return parsed._replace(scheme="https", netloc=host, path=parsed.path or "/")


def validate_loopback_proxy(proxy: str | None) -> tuple[str, int]:
    if not proxy:
        raise SafeProxyError("SAFE_PROXY_REQUIRED")
    parsed = urlsplit(proxy)
    try:
        host = parsed.hostname or ""
        address = ipaddress.ip_address(host)
        port = parsed.port
    except ValueError as exc:
        raise SafeProxyError("SAFE_PROXY_MUST_BE_LOOPBACK_HTTP") from exc
    if (parsed.scheme.lower() != "http" or not address.is_loopback or not port or "%" in parsed.netloc
            or parsed.username or parsed.password or parsed.path not in ("", "/")
            or parsed.query or parsed.fragment):
        raise SafeProxyError("SAFE_PROXY_MUST_BE_LOOPBACK_HTTP")
    return address.compressed, port


def _target_authority(address: str) -> str:
    ip = ipaddress.ip_address(address)
    return f"[{ip.compressed}]:443" if ip.version == 6 else f"{ip.compressed}:443"


def _open_tls_tunnel(host: str, target_ip: str, proxy: str, timeout: float):
    proxy_host, proxy_port = validate_loopback_proxy(proxy)
    address = ipaddress.ip_address(target_ip)
    if not address.is_global:
        raise SafeProxyError("SAFE_PROXY_TARGET_NOT_PUBLIC")
    raw = None
    try:
        raw = socket.create_connection((proxy_host, proxy_port), timeout=timeout)
        raw.settimeout(timeout)
        authority = _target_authority(address.compressed)
        raw.sendall((f"CONNECT {authority} HTTP/1.1\r\nHost: {authority}\r\n"
                     "Proxy-Connection: keep-alive\r\n\r\n").encode("ascii"))
        header = bytearray()
        while not header.endswith(b"\r\n\r\n") and len(header) <= 8192:
            part = raw.recv(1)
            if not part:
                raise SafeProxyError("SAFE_PROXY_CONNECT_CLOSED")
            header.extend(part)
        if not header.endswith(b"\r\n\r\n"):
            raise SafeProxyError("SAFE_PROXY_CONNECT_HEADER_TOO_LARGE")
        first = bytes(header).split(b"\r\n", 1)[0]
        match = re.fullmatch(rb"HTTP/1\.[01] 200(?: .*)?", first)
        if not match:
            raise SafeProxyError("SAFE_PROXY_CONNECT_REJECTED")
        context = ssl.create_default_context()
        context.check_hostname = True
        context.verify_mode = ssl.CERT_REQUIRED
        context.minimum_version = ssl.TLSVersion.TLSv1_2
        tls = context.wrap_socket(raw, server_hostname=host)
        cert = tls.getpeercert(binary_form=True)
        proof = {"proxy_mode": "LOOPBACK_HTTP_CONNECT", "connect_authority": authority,
                 "tls_server_hostname": host, "tls_certificate_verified": True,
                 "tls_version": tls.version(), "tls_cipher": tls.cipher()[0] if tls.cipher() else None,
                 "peer_certificate_sha256": hashlib.sha256(cert).hexdigest()}
        return tls, proof
    except SafeProxyError:
        if raw:
            raw.close()
        raise
    except ssl.SSLCertVerificationError as exc:
        if raw:
            raw.close()
        raise SafeProxyError("SAFE_TLS_CERTIFICATE_REJECTED") from exc
    except (OSError, ssl.SSLError, TimeoutError) as exc:
        if raw:
            raw.close()
        raise SafeProxyError("SAFE_PROXY_CONNECT_FAILED") from exc


def _send_request(tls, host: str, parsed, method: str, headers: dict[str, str]):
    if method not in ("GET", "HEAD"):
        raise SafeProxyError("SAFE_HTTP_METHOD_REJECTED")
    path = quote(parsed.path or "/", safe="/%:@!$&'()*+,;=-._~")
    if parsed.query:
        path += "?" + parsed.query
    lines = [f"{method} {path} HTTP/1.1", f"Host: {host}",
             "User-Agent: CWS-MEDIA-SAFE-PROXY/1", "Accept-Encoding: identity", "Connection: close"]
    for key, value in headers.items():
        if key.lower() not in ("accept", "range") or any(ch in key + value for ch in "\r\n"):
            raise SafeProxyError("SAFE_HTTP_HEADER_REJECTED")
        lines.append(f"{key}: {value}")
    tls.sendall(("\r\n".join(lines) + "\r\n\r\n").encode("ascii"))
    response = http.client.HTTPResponse(tls)
    response.begin()
    return response


def _read_limited(response, limit: int) -> bytes:
    if limit < 0:
        raise SafeProxyError("SAFE_RESPONSE_LIMIT_INVALID")
    encoding = (response.getheader("Content-Encoding") or "identity").lower()
    if encoding not in ("", "identity"):
        raise SafeProxyError("SAFE_CONTENT_ENCODING_REJECTED")
    length = response.getheader("Content-Length")
    if length is not None:
        if not length.isdigit():
            raise SafeProxyError("SAFE_CONTENT_LENGTH_INVALID")
        if int(length) > limit:
            raise SafeProxyError("SAFE_RESPONSE_SIZE_LIMIT")
    chunks = bytearray()
    while True:
        try:
            block = response.read(min(65_536, limit + 1 - len(chunks)))
        except http.client.IncompleteRead as exc:
            raise SafeProxyError("SAFE_RESPONSE_TRUNCATED") from exc
        if not block:
            break
        chunks.extend(block)
        if len(chunks) > limit:
            raise SafeProxyError("SAFE_RESPONSE_SIZE_LIMIT")
    if length is not None and len(chunks) != int(length):
        raise SafeProxyError("SAFE_RESPONSE_TRUNCATED")
    return bytes(chunks)


def _doh_query(name: str, kind: str, proxy: str, timeout: float) -> list[dict]:
    query = urlencode({"name": name, "type": kind})
    parsed = urlsplit(f"https://{DOH_HOST}/dns-query?{query}")
    tls, _proof = _open_tls_tunnel(DOH_HOST, DOH_IP, proxy, timeout)
    try:
        response = _send_request(tls, DOH_HOST, parsed, "GET", {"Accept": "application/dns-json"})
        if response.status != 200:
            raise SafeProxyError("SAFE_DOH_HTTP_FAILED")
        content_type = (response.getheader("Content-Type") or "").split(";", 1)[0].lower()
        if content_type not in ("application/dns-json", "application/json"):
            raise SafeProxyError("SAFE_DOH_CONTENT_TYPE_REJECTED")
        data = json.loads(_read_limited(response, MAX_DNS_BYTES))
        if data.get("Status") != 0 or not isinstance(data.get("Answer", []), list):
            raise SafeProxyError("SAFE_DOH_LOOKUP_FAILED")
        return data.get("Answer", [])
    except SafeProxyError:
        raise
    except (OSError, ValueError, http.client.HTTPException) as exc:
        raise SafeProxyError("SAFE_DOH_RESPONSE_INVALID") from exc
    finally:
        tls.close()


def resolve_public_addresses(host: str, proxy: str, timeout: float = 8) -> list[str]:
    if not ipaddress.ip_address(DOH_IP).is_global:
        raise SafeProxyError("SAFE_DOH_BOOTSTRAP_INVALID")
    pending = [(host, ())]
    queried = set()
    addresses = set()
    while pending:
        name, chain = pending.pop()
        if name in chain:
            raise SafeProxyError("SAFE_DNS_CNAME_LOOP")
        if name in queried:
            continue
        if len(queried) >= 8:
            raise SafeProxyError("SAFE_DNS_CNAME_LIMIT")
        queried.add(name)
        cnames = set()
        for kind in ("A", "AAAA"):
            for row in _doh_query(name, kind, proxy, timeout):
                if not isinstance(row, dict) or row.get("type") not in (1, 28, 5):
                    continue
                if row["type"] == 5:
                    target = str(row.get("data", "")).rstrip(".").lower()
                    if not target.isascii() or not _DNS_LABEL.fullmatch(target):
                        raise SafeProxyError("SAFE_DNS_CNAME_INVALID")
                    cnames.add(target)
                else:
                    try:
                        address = ipaddress.ip_address(row.get("data", ""))
                    except ValueError as exc:
                        raise SafeProxyError("SAFE_DNS_ADDRESS_INVALID") from exc
                    if address.version not in (4, 6) or not address.is_global:
                        raise SafeProxyError("SAFE_DNS_NON_PUBLIC_ADDRESS")
                    addresses.add(address.compressed)
        for target in cnames:
            pending.append((target, chain + (name,)))
    if not addresses:
        raise SafeProxyError("SAFE_DNS_NO_ADDRESS")
    return sorted(addresses, key=lambda value: (ipaddress.ip_address(value).version != 4,
                                                int(ipaddress.ip_address(value))))


@contextmanager
def open_response(url: str, proxy: str, method: str = "GET", headers: dict[str, str] | None = None,
                  timeout: float = 15):
    parsed = validate_https_url(url)
    host = parsed.hostname or ""
    addresses = resolve_public_addresses(host, proxy, timeout=min(timeout, 8))
    target_ip = addresses[0]
    tls, proof = _open_tls_tunnel(host, target_ip, proxy, timeout)
    try:
        try:
            response = _send_request(tls, host, parsed, method, headers or {})
        except (OSError, http.client.HTTPException) as exc:
            raise SafeProxyError("SAFE_HTTP_RESPONSE_INVALID") from exc
        proof = {**proof, "verified_dns_addresses": addresses, "selected_connect_ip": target_ip}
        yield response, proof
    finally:
        tls.close()
