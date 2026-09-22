from app.config import SETTINGS


def test_g2_resource_limits_are_frozen():
    assert SETTINGS.max_pages == 6
    assert SETTINGS.max_depth == 1
    assert SETTINGS.max_redirects == 5
    assert SETTINGS.max_response_bytes == 5 * 1024 * 1024
    assert SETTINGS.max_runtime_seconds == 45
    assert SETTINGS.max_browser_pages == 2
    assert SETTINGS.max_concurrent_jobs == 1
    assert SETTINGS.max_queued_jobs == 5
    assert SETTINGS.max_interactive_actions == 1
