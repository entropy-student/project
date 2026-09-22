import sys
from pathlib import Path

import pytest

SCANNER_ROOT = Path(__file__).resolve().parents[2] / "scanner"
sys.path.insert(0, str(SCANNER_ROOT))

from app.jobs import SQLiteJobStore
from app.models import JobStatus
from app.services.runner import ScanRunner


class FakeRunner(ScanRunner):
    async def _scrapy(self, url, seconds):
        return {
            "access_state": "ACCESS_OK",
            "pages": [{
                "requested_url": url,
                "final_url": url,
                "status": 200,
                "html": "<html><body><nav>Home</nav><p>Example public page</p></body></html>",
            }],
        }

    async def _browser(self, url, seconds):
        raise AssertionError("browser fallback is not part of this phase test")


@pytest.mark.asyncio
async def test_real_prioritizing_state_is_persisted_before_complete(tmp_path, monkeypatch):
    store = SQLiteJobStore(tmp_path / "jobs.sqlite3")
    job = await store.create("https://example.com")
    runner = FakeRunner(store)
    phases = []
    original_update = store.update

    async def recording_update(job_id, **kwargs):
        if kwargs.get("phase"):
            phases.append(kwargs["phase"])
        return await original_update(job_id, **kwargs)

    monkeypatch.setattr(store, "update", recording_update)
    monkeypatch.setattr("app.services.runner.resolve_and_validate", lambda target: target)
    await runner._run(job.id, job.requested_url)

    readback = await original_update(job.id)
    assert readback.status == JobStatus.SUCCEEDED
    assert phases == ["CHECKING_ACCESS", "READING_PAGES", "MATCHING_EVIDENCE", "PRIORITIZING", "COMPLETE"]
