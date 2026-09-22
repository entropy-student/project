import pytest

from app.jobs import SQLiteJobStore
from app.models import JobStatus
from app.services.runner import ScanRunner


class FakeRunner(ScanRunner):
    def __init__(self, store, static_payload, browser_payload=None):
        super().__init__(store)
        self.static_payload = static_payload
        self.browser_payload = browser_payload or {"access_state": "AUDIT_INCOMPLETE", "pages": []}
        self.browser_calls = 0

    async def _scrapy(self, url, seconds):
        return self.static_payload

    async def _browser(self, url, seconds):
        self.browser_calls += 1
        return self.browser_payload


@pytest.mark.asyncio
@pytest.mark.parametrize("payload", [
    {"access_state": "AUDIT_INCOMPLETE", "error_code": "RATE_LIMITED", "pages": [{"requested_url": "https://example.com", "final_url": "https://example.com", "status": 429}]},
    {"access_state": "AUDIT_INCOMPLETE", "error_code": "ACCESS_BLOCKED", "pages": [{"requested_url": "https://example.com", "final_url": "https://example.com", "status": 403}]},
    {"access_state": "AUDIT_INCOMPLETE", "error_code": "ROBOTS_DENIED", "pages": []},
])
async def test_explicit_blocks_never_trigger_browser_fallback(tmp_path, monkeypatch, payload):
    store = SQLiteJobStore(tmp_path / "jobs.sqlite3")
    job = await store.create("https://example.com")
    runner = FakeRunner(store, payload)
    # Avoid live DNS in a pure orchestration test.
    monkeypatch.setattr("app.services.runner.resolve_and_validate", lambda target: target)
    await runner._run(job.id, job.requested_url)
    readback = await store.get(job.id)
    assert readback.status == JobStatus.AUDIT_INCOMPLETE
    assert runner.browser_calls == 0


@pytest.mark.asyncio
async def test_dynamic_incomplete_can_use_one_browser_fallback_and_bound_pages(tmp_path, monkeypatch):
    store = SQLiteJobStore(tmp_path / "jobs.sqlite3")
    job = await store.create("https://example.com")
    static = {"access_state": "AUDIT_INCOMPLETE", "error_code": "JS_INCOMPLETE", "pages": []}
    html = "<html><body><p>$49</p><button>Add to cart</button></body></html>"
    browser = {
        "access_state": "ACCESS_OK",
        "pages": [
            {"requested_url": "https://example.com", "final_url": "https://example.com", "status": 200, "html": html}
            for _ in range(10)
        ],
    }
    runner = FakeRunner(store, static, browser)
    monkeypatch.setattr("app.services.runner.resolve_and_validate", lambda target: target)
    await runner._run(job.id, job.requested_url)
    readback = await store.get(job.id)
    assert runner.browser_calls == 1
    assert readback.status == JobStatus.SUCCEEDED
    assert len(readback.result.pages) <= 6
    assert all("body_text" not in p.facts for p in readback.result.pages)
    assert all(d.fact_refs for d in readback.result.decisions if d.result == "ISSUE")
