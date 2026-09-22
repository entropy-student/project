import asyncio
from pathlib import Path

from fastapi.testclient import TestClient

from app.main import create_app
from app.jobs import SQLiteJobStore
from app.models import JobStatus, ScanResult


class NoopRunner:
    def schedule(self, job_id, url):
        return None

    async def cancel(self, job_id):
        return None


def make_client(tmp_path: Path):
    store = SQLiteJobStore(tmp_path / "jobs.sqlite3", max_queued=5)
    return store, TestClient(create_app(store=store, runner=NoopRunner()))


def test_healthz_and_private_url_rejection(tmp_path):
    store, client = make_client(tmp_path)
    h = client.get("/healthz")
    assert h.status_code == 200
    assert h.json()["production_egress_enforcement_ready"] is False
    r = client.post("/v1/scans", json={"url": "http://127.0.0.1/admin"})
    assert r.status_code == 400
    assert r.json()["detail"]["code"] == "UNSAFE_TARGET"


def test_scan_job_created_queryable_and_report_not_ready(tmp_path):
    store, client = make_client(tmp_path)
    r = client.post("/v1/scans", json={"url": "https://example.com"})
    assert r.status_code == 202
    job_id = r.json()["id"]
    q = client.get(f"/v1/scans/{job_id}")
    assert q.status_code == 200
    assert q.json()["requested_url"] == "https://example.com"
    report = client.get(f"/v1/scans/{job_id}/report")
    assert report.status_code == 409
    assert report.json()["detail"]["code"] == "REPORT_NOT_READY"


def test_report_ready_and_invalid_job_id_does_not_leak(tmp_path):
    store, client = make_client(tmp_path)
    job = asyncio.run(store.create("https://example.com"))
    result = ScanResult(requested_url=job.requested_url, final_url="https://example.com", access_state="ACCESS_OK")
    asyncio.run(store.update(job.id, status=JobStatus.SUCCEEDED, result=result))
    report = client.get(f"/v1/scans/{job.id}/report")
    assert report.status_code == 200
    assert report.json()["access_state"] == "ACCESS_OK"
    bad = client.get("/v1/scans/../../etc/passwd")
    assert bad.status_code in {404, 405}
    body = bad.text.lower()
    assert "/mnt/" not in body and "traceback" not in body


def test_queue_limit_is_five(tmp_path):
    store, client = make_client(tmp_path)
    ids = []
    for i in range(5):
        r = client.post("/v1/scans", json={"url": f"https://example.com/?n={i}"})
        assert r.status_code == 202
        ids.append(r.json()["id"])
    sixth = client.post("/v1/scans", json={"url": "https://example.com/?n=6"})
    assert sixth.status_code == 429
    assert sixth.json()["detail"]["code"] == "QUEUE_FULL"
