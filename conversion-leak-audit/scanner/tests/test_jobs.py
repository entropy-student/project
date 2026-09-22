import pytest

from app.jobs import SQLiteJobStore, QueueFull
from app.models import JobStatus, ScanResult


@pytest.mark.asyncio
async def test_sqlite_job_lifecycle_cancel_and_restart_readback(tmp_path):
    path = tmp_path / "jobs.sqlite3"
    store = SQLiteJobStore(path, max_records=10, max_queued=5)
    job = await store.create("https://example.com")
    assert job.status == JobStatus.QUEUED
    run = await store.update(job.id, status=JobStatus.RUNNING)
    assert run.status == JobStatus.RUNNING
    result = ScanResult(requested_url=job.requested_url, final_url="https://example.com", access_state="ACCESS_OK")
    done = await store.update(job.id, status=JobStatus.SUCCEEDED, result=result)
    assert done.result is not None

    # New store instance proves persistence across process/store restart.
    reopened = SQLiteJobStore(path, max_records=10, max_queued=5)
    readback = await reopened.get(job.id)
    assert readback.status == JobStatus.SUCCEEDED
    assert readback.result.final_url == "https://example.com"


@pytest.mark.asyncio
async def test_queue_limit(tmp_path):
    store = SQLiteJobStore(tmp_path / "jobs.sqlite3", max_queued=5)
    for i in range(5):
        await store.create(f"https://example.com/{i}")
    with pytest.raises(QueueFull):
        await store.create("https://example.com/overflow")
