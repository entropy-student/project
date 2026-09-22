import socket
from types import SimpleNamespace

import pytest

from app.security import (
    validate_url_syntax,
    validate_resolved_ips,
    resolve_and_validate,
    choose_pinned_ip,
    UnsafeTarget,
)
from app.crawlers.pinning import clear, get, pin
from app.crawlers.safety_middleware import SafeURLMiddleware


@pytest.mark.parametrize("url", [
    "https://example.com", "http://example.com/path", "https://example.com:443", "http://example.com:80",
    "https://EXAMPLE.com./x", "https://bücher.example/path",
])
def test_public_url_syntax_allowed(url):
    validate_url_syntax(url)


@pytest.mark.parametrize("url", [
    "ftp://example.com/a", "file:///etc/passwd", "http://localhost", "http://a.localhost",
    "http://127.0.0.1", "http://10.0.0.1", "http://192.168.1.1", "http://169.254.169.254/latest/meta-data",
    "http://[::1]/", "http://[fc00::1]/", "http://[fe80::1]/", "http://0.0.0.0/",
    "https://example.com:8443", "https://metadata.google.internal", "https://user:pass@example.com",
    # Legacy numeric spellings commonly accepted by system resolvers.
    "http://2130706433/", "http://0x7f000001/", "http://017700000001/",
])
def test_unsafe_syntax_rejected(url):
    with pytest.raises(UnsafeTarget):
        validate_url_syntax(url)


def test_overlong_url_rejected():
    with pytest.raises(UnsafeTarget):
        validate_url_syntax("https://example.com/" + "a" * 3000)


def test_public_resolution_allowed():
    assert validate_resolved_ips(["8.8.8.8", "1.1.1.1"])


@pytest.mark.parametrize("ips", [
    ["127.0.0.1"], ["10.0.0.1"], ["169.254.169.254"], ["8.8.8.8", "127.0.0.1"],
    ["::1"], ["fc00::1"], ["fe80::1"], ["0.0.0.0"], [],
])
def test_unsafe_resolution_rejected(ips):
    with pytest.raises(UnsafeTarget):
        validate_resolved_ips(ips)


def test_dns_rebinding_simulation_pins_first_validated_public_answer(monkeypatch):
    clear()
    calls = {"n": 0}

    def fake_getaddrinfo(host, port, type=0):
        calls["n"] += 1
        ip = "8.8.8.8" if calls["n"] == 1 else "127.0.0.1"
        return [(socket.AF_INET, socket.SOCK_STREAM, 6, "", (ip, port))]

    monkeypatch.setattr(socket, "getaddrinfo", fake_getaddrinfo)
    middleware = SafeURLMiddleware()
    req = SimpleNamespace(url="https://example.com/path", meta={})
    middleware.process_request(req, None)
    assert get("example.com") == "8.8.8.8"
    # Later DNS answer changes to private, but connection resolver consumes the frozen pin.
    assert fake_getaddrinfo("example.com", 443)[0][4][0] == "127.0.0.1"
    assert get("example.com") == "8.8.8.8"


def test_redirect_target_private_is_rejected_by_same_url_gate():
    with pytest.raises(UnsafeTarget):
        validate_url_syntax("http://169.254.169.254/latest/meta-data")
