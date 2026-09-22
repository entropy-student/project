from __future__ import annotations

import re
from pathlib import Path

from fastapi import FastAPI, HTTPException, status

from . import __version__
from .config import SETTINGS
from .jobs import SQLiteJobStore, JobNotFound, QueueFull
from .models import ScanCreate, ScanJob, JobStatus, ScanResult
from .security import validate_url_syntax, UnsafeTarget
from .services.runner import ScanRunner

JOB_ID_RE = re.compile(r"^[0-9a-f]{32}$")


def _valid_job_id(value: str) -> bool:
    return bool(JOB_ID_RE.fullmatch(value))


def create_app(*, store: SQLiteJobStore | None = None, runner=None, database_path: str | None = None) -> FastAPI:
    db = database_path or SETTINGS.database_path
    store = store or SQLiteJobStore(db, max_records=SETTINGS.max_job_records, max_queued=SETTINGS.max_queued_jobs)
    runner = runner or ScanRunner(store)
    app = FastAPI(title="Conversion Leak Audit Scanner", version=__version__)
    app.state.store = store
    app.state.runner = runner

    @app.get("/healthz")
    async def healthz():
        return {
            "status": "ok",
            "version": __version__,
            "scope": "local-test-v0",
            "production_egress_enforcement_ready": SETTINGS.production_egress_enforcement_ready,
        }

    @app.post("/v1/scans", response_model=ScanJob, status_code=status.HTTP_202_ACCEPTED)
    async def create_scan(body: ScanCreate):
        try:
            validate_url_syntax(body.url)
        except UnsafeTarget as exc:
            raise HTTPException(status_code=400, detail={"code": "UNSAFE_TARGET", "reason": exc.reason})
        try:
            job = await store.create(body.url)
        except QueueFull:
            raise HTTPException(status_code=429, detail={"code": "QUEUE_FULL"})
        runner.schedule(job.id, body.url)
        return job

    @app.get("/v1/scans/{job_id}", response_model=ScanJob)
    async def get_scan(job_id: str):
        if not _valid_job_id(job_id):
            raise HTTPException(status_code=404, detail={"code": "JOB_NOT_FOUND"})
        try:
            return await store.get(job_id)
        except JobNotFound:
            raise HTTPException(status_code=404, detail={"code": "JOB_NOT_FOUND"})

    @app.get("/v1/scans/{job_id}/report", response_model=ScanResult)
    async def get_report(job_id: str):
        if not _valid_job_id(job_id):
            raise HTTPException(status_code=404, detail={"code": "JOB_NOT_FOUND"})
        try:
            job = await store.get(job_id)
        except JobNotFound:
            raise HTTPException(status_code=404, detail={"code": "JOB_NOT_FOUND"})
        if job.result is None or job.status not in {JobStatus.SUCCEEDED, JobStatus.AUDIT_INCOMPLETE}:
            raise HTTPException(status_code=409, detail={"code": "REPORT_NOT_READY"})
        return job.result

    @app.delete("/v1/scans/{job_id}", response_model=ScanJob)
    async def cancel_scan(job_id: str):
        if not _valid_job_id(job_id):
            raise HTTPException(status_code=404, detail={"code": "JOB_NOT_FOUND"})
        try:
            job = await store.cancel(job_id)
            await runner.cancel(job_id)
            return job
        except JobNotFound:
            raise HTTPException(status_code=404, detail={"code": "JOB_NOT_FOUND"})

    return app


app = create_app()
