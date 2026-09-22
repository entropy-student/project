from app.crawlers.browser_worker import browser_request_allowed


def test_browser_request_guard_rejects_private_and_cross_host_targets():
    host = "example.com"
    assert browser_request_allowed("https://example.com/a", host) is True
    assert browser_request_allowed("http://127.0.0.1/x", host) is False
    assert browser_request_allowed("http://169.254.169.254/latest/meta-data", host) is False
    assert browser_request_allowed("https://cdn.example.net/x.js", host) is False
    assert browser_request_allowed("data:text/plain,ok", host) is True
