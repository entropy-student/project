import socket
import ssl
import sys
import unittest
from unittest.mock import patch
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import safe_proxy as p


class SafeProxyTests(unittest.TestCase):
    def test_url_policy_rejects_non_https_private_and_ambiguous_authorities(self):
        rejected = (
            "http://example.org/a.mp4", "https://127.0.0.1/a.mp4",
            "https://[::1]/a.mp4", "https://example.org:8443/a.mp4",
            "https://user@example.org/a.mp4", "https://example.org\\@127.0.0.1/a.mp4",
            "https://%65xample.org/a.mp4", "https://münich.example/a.mp4",
            "https://example.org/a.mp4?signature=secret", "https://example.org/a.mp4?%73ignature=secret",
            "https://media.local/video.mp4", "https://metadata.internal/video.mp4",
            "https://example.org/a.mp4#fragment",
        )
        for url in rejected:
            with self.subTest(url=url), self.assertRaises(p.SafeProxyError):
                p.validate_https_url(url)

    def test_url_policy_accepts_only_https_default_port_domain(self):
        parsed = p.validate_https_url("https://EXAMPLE.org:443/video.mp4")
        self.assertEqual(parsed.hostname, "example.org")
        self.assertEqual(parsed.path, "/video.mp4")
        self.assertEqual(p._target_authority("2001:4860:4860::8888"), "[2001:4860:4860::8888]:443")

    def test_proxy_must_be_an_explicit_numeric_loopback_http_listener(self):
        self.assertEqual(p.validate_loopback_proxy("http://127.0.0.1:12345"), ("127.0.0.1", 12345))
        for value in (None, "socks5://127.0.0.1:12345", "http://localhost:12345",
                      "http://192.168.1.10:12345", "http://user:pass@127.0.0.1:12345",
                      "http://127.0.0.1", "http://127.0.0.1:12345/path"):
            with self.subTest(value=value), self.assertRaises(p.SafeProxyError):
                p.validate_loopback_proxy(value)

    def test_public_doh_answers_are_pinned_and_sorted(self):
        def doh(name, kind, *_):
            if kind == "A":
                return [{"type": 1, "data": "93.184.216.34"}]
            return [{"type": 28, "data": "2606:4700:4700::1111"}]
        with patch.object(p, "_doh_query", side_effect=doh):
            result = p.resolve_public_addresses("media.example", "http://127.0.0.1:12345")
        self.assertEqual(result[0], "93.184.216.34")
        self.assertEqual(set(result), {"93.184.216.34", "2606:4700:4700::1111"})

    def test_mixed_or_reserved_dns_answer_fails_closed(self):
        def doh(_name, kind, *_):
            return ([{"type": 1, "data": "93.184.216.34"}] if kind == "A"
                    else [{"type": 28, "data": "fd00::1"}])
        with patch.object(p, "_doh_query", side_effect=doh):
            with self.assertRaisesRegex(p.SafeProxyError, "SAFE_DNS_NON_PUBLIC_ADDRESS"):
                p.resolve_public_addresses("media.example", "http://127.0.0.1:12345")

    def test_cname_to_nonpublic_and_rebinding_answers_are_rejected(self):
        def cname_private(name, kind, *_):
            if name == "media.example":
                return [{"type": 5, "data": "private.example."}] if kind == "A" else []
            return [{"type": 1, "data": "10.0.0.4"}] if kind == "A" else []
        with patch.object(p, "_doh_query", side_effect=cname_private):
            with self.assertRaisesRegex(p.SafeProxyError, "SAFE_DNS_NON_PUBLIC_ADDRESS"):
                p.resolve_public_addresses("media.example", "http://127.0.0.1:12345")
        calls = {"count": 0}
        def rebind(_name, kind, *_):
            if kind == "AAAA":
                return []
            calls["count"] += 1
            value = "93.184.216.34" if calls["count"] == 1 else "127.0.0.1"
            return [{"type": 1, "data": value}]
        with patch.object(p, "_doh_query", side_effect=rebind):
            p.resolve_public_addresses("media.example", "http://127.0.0.1:12345")
            with self.assertRaisesRegex(p.SafeProxyError, "SAFE_DNS_NON_PUBLIC_ADDRESS"):
                p.resolve_public_addresses("media.example", "http://127.0.0.1:12345")

    def test_connect_uses_resolved_numeric_ip_and_tls_uses_original_hostname(self):
        class RawSocket:
            def __init__(self):
                self.sent = bytearray()
                self.input = bytearray(b"HTTP/1.1 200 Connection established\r\n\r\n")
                self.closed = False
            def settimeout(self, _): pass
            def sendall(self, data): self.sent.extend(data)
            def recv(self, _):
                value = bytes(self.input[:1]); del self.input[:1]; return value
            def close(self): self.closed = True
        class TlsSocket:
            def getpeercert(self, binary_form=False): return b"test-cert"
            def version(self): return "TLSv1.3"
            def cipher(self): return ("TLS_AES_128_GCM_SHA256", "TLSv1.3", 128)
            def close(self): pass
        class Context:
            check_hostname = False
            verify_mode = ssl.CERT_NONE
            minimum_version = ssl.TLSVersion.TLSv1
            def wrap_socket(self, raw, server_hostname):
                self.raw = raw; self.server_hostname = server_hostname
                return TlsSocket()
        raw, context = RawSocket(), Context()
        with patch.object(p.socket, "create_connection", return_value=raw) as connect, \
             patch.object(p.ssl, "create_default_context", return_value=context):
            tls, proof = p._open_tls_tunnel("media.example", "93.184.216.34", "http://127.0.0.1:12345", 5)
        request = raw.sent.decode("ascii")
        self.assertIn("CONNECT 93.184.216.34:443 HTTP/1.1", request)
        self.assertNotIn("CONNECT media.example", request)
        self.assertEqual(context.server_hostname, "media.example")
        self.assertTrue(context.check_hostname)
        self.assertEqual(context.verify_mode, ssl.CERT_REQUIRED)
        self.assertEqual(proof["connect_authority"], "93.184.216.34:443")
        self.assertTrue(proof["tls_certificate_verified"])
        self.assertEqual(connect.call_args.args[0], ("127.0.0.1", 12345))
        tls.close()

    def test_media_request_pins_the_selected_dns_address_without_local_hostname_resolution(self):
        class Tls:
            def close(self): pass
        class Response:
            status = 200
        proof = {"connect_authority": "93.184.216.34:443", "tls_certificate_verified": True}
        with patch.object(p, "resolve_public_addresses", return_value=["93.184.216.34", "2606:4700:4700::1111"]), \
             patch.object(p, "_open_tls_tunnel", return_value=(Tls(), proof)) as connect, \
             patch.object(p, "_send_request", return_value=Response()), \
             patch.object(p.socket, "getaddrinfo", side_effect=AssertionError("system DNS must not resolve media host")):
            with p.open_response("https://media.example/video.mp4", "http://127.0.0.1:12345") as (response, evidence):
                self.assertEqual(response.status, 200)
        self.assertEqual(connect.call_args.args[:2], ("media.example", "93.184.216.34"))
        self.assertEqual(evidence["selected_connect_ip"], "93.184.216.34")

    def test_tls_identity_failure_is_not_bypassed(self):
        class RawSocket:
            def __init__(self): self.input = bytearray(b"HTTP/1.1 200 OK\r\n\r\n")
            def settimeout(self, _): pass
            def sendall(self, _): pass
            def recv(self, _):
                value = bytes(self.input[:1]); del self.input[:1]; return value
            def close(self): pass
        class BadContext:
            check_hostname = False
            verify_mode = ssl.CERT_NONE
            minimum_version = ssl.TLSVersion.TLSv1
            def wrap_socket(self, *_args, **_kwargs):
                raise ssl.SSLCertVerificationError("wrong host")
        with patch.object(p.socket, "create_connection", return_value=RawSocket()), \
             patch.object(p.ssl, "create_default_context", return_value=BadContext()):
            with self.assertRaisesRegex(p.SafeProxyError, "SAFE_TLS_CERTIFICATE_REJECTED"):
                p._open_tls_tunnel("media.example", "93.184.216.34", "http://127.0.0.1:12345", 5)

    def test_bad_proxy_is_rejected_before_socket_creation(self):
        with patch.object(p.socket, "create_connection") as connect:
            with self.assertRaises(p.SafeProxyError):
                p._open_tls_tunnel("media.example", "93.184.216.34", "http://10.0.0.1:12345", 5)
            connect.assert_not_called()

    def test_size_encoding_and_truncation_fail_closed(self):
        class Response:
            def __init__(self, headers, body): self.headers = headers; self.body = body
            def getheader(self, key): return self.headers.get(key)
            def read(self, count):
                value = self.body[:count]; self.body = self.body[count:]; return value
        with self.assertRaisesRegex(p.SafeProxyError, "SAFE_RESPONSE_SIZE_LIMIT"):
            p._read_limited(Response({"Content-Length": "9"}, b"123456789"), 8)
        with self.assertRaisesRegex(p.SafeProxyError, "SAFE_RESPONSE_TRUNCATED"):
            p._read_limited(Response({"Content-Length": "5"}, b"1234"), 8)
        with self.assertRaisesRegex(p.SafeProxyError, "SAFE_CONTENT_ENCODING_REJECTED"):
            p._read_limited(Response({"Content-Encoding": "gzip"}, b"data"), 8)


if __name__ == "__main__":
    unittest.main()
