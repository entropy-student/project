from __future__ import annotations

import asyncio
import json
import sqlite3
from datetime import datetime, timezone
from pathlib import Path
from uuid import uuid4

from .models import ScanJob, JobStatus, ScanResult


class JobNotFound(KeyError):
    pass


class QueueFull(RuntimeError):
    pass


TERMINAL = {JobStatus.SUCCEEDED, JobStatus.AUDIT_INCOMPLETE, JobStatus.FAILED, JobStatus.CANCELLED}


class SQLiteJobStore:
    def __init__(self, path: str | Path, *, max_records: int = 500, max_queued: int = 5):
        self.path = str(path)
        self.max_records = max_records
        self.max_queued = max_queued
        self._lock = asyncio.Lock()
        self._init_db()

    def _connect(self):
        conn = sqlite3.connect(self.path, timeout=5)
        conn.row_factory = sqlite3.Row
        return conn

    def _init_db(self):
        Path(self.path).parent.mkdir(parents=True, exist_ok=True)
        with self._connect() as c:
            c.execute("PRAGMA journal_mode=WAL")
            c.execute("""
                CREATE TABLE IF NOT EXISTS scan_jobs (
                    id TEXT PRIMARY KEY,
                    requested_url TEXT NOT NULL,
                    status TEXT NOT NULL,
                    phase TEXT,
                    created_at TEXT NOT NULL,
                    updated_at TEXT NOT NULL,
                    result_json TEXT,
                    error_code TEXT,
                    error_detail TEXT
                )
            """)
            columns = {row[1] for row in c.execute("PRAGMA table_info(scan_jobs)").fetchall()}
            if "phase" not in columns:
                c.execute("ALTER TABLE scan_jobs ADD COLUMN phase TEXT")
            c.commit()

    def _row_to_job(self, row) -> ScanJob:
        result = ScanResult.model_validate_json(row["result_json"]) if row["result_json"] else None
        return ScanJob(
            id=row["id"], requested_url=row["requested_url"], status=JobStatus(row["status"]),
            phase=row["phase"],
            created_at=datetime.fromisoformat(row["created_at"]), updated_at=datetime.fromisoformat(row["updated_at"]),
            result=result, error_code=row["error_code"], error_detail=row["error_detail"],
        )

    async def active_count(self) -> int:
        async with self._lock:
            with self._connect() as c:
                row = c.execute("SELECT COUNT(*) AS n FROM scan_jobs WHERE status IN (?, ?)", (JobStatus.QUEUED.value, JobStatus.RUNNING.value)).fetchone()
                return int(row["n"])

    async def create(self, url: str) -> ScanJob:
        async with self._lock:
            with self._connect() as c:
                active = c.execute("SELECT COUNT(*) AS n FROM scan_jobs WHERE status IN (?, ?)", (JobStatus.QUEUED.value, JobStatus.RUNNING.value)).fetchone()["n"]
                if active >= self.max_queued:
                    raise QueueFull("QUEUE_FULL")
                job = ScanJob.new(uuid4().hex, url)
                c.execute(
                    "INSERT INTO scan_jobs(id,requested_url,status,phase,created_at,updated_at) VALUES(?,?,?,?,?,?)",
                    (job.id, job.requested_url, job.status.value, job.phase, job.created_at.isoformat(), job.updated_at.isoformat()),
                )
                # Bound retained terminal records without deleting active work.
                excess = c.execute("SELECT COUNT(*) FROM scan_jobs").fetchone()[0] - self.max_records
                if excess > 0:
                    c.execute(
                        "DELETE FROM scan_jobs WHERE id IN (SELECT id FROM scan_jobs WHERE status NOT IN (?, ?) ORDER BY updated_at ASC LIMIT ?)",
                        (JobStatus.QUEUED.value, JobStatus.RUNNING.value, excess),
                    )
                c.commit()
                return job

    async def get(self, job_id: str) -> ScanJob:
        async with self._lock:
            with self._connect() as c:
                row = c.execute("SELECT * FROM scan_jobs WHERE id=?", (job_id,)).fetchone()
                if row is None:
                    raise JobNotFound(job_id)
                return self._row_to_job(row)

    async def update(self, job_id: str, *, status: JobStatus | None = None, phase: str | None = None,
                     result: ScanResult | None = None,
                     error_code: str | None = None, error_detail: str | None = None) -> ScanJob:
        async with self._lock:
            with self._connect() as c:
                row = c.execute("SELECT * FROM scan_jobs WHERE id=?", (job_id,)).fetchone()
                if row is None:
                    raise JobNotFound(job_id)
                current = self._row_to_job(row)
                new_status = status or current.status
                new_phase = phase if phase is not None else current.phase
                new_result = result if result is not None else current.result
                updated = datetime.now(timezone.utc)
                c.execute(
                    "UPDATE scan_jobs SET status=?, phase=?, updated_at=?, result_json=?, error_code=?, error_detail=? WHERE id=?",
                    (new_status.value, new_phase, updated.isoformat(), new_result.model_dump_json() if new_result else None, error_code, error_detail, job_id),
                )
                c.commit()
        return await self.get(job_id)

    async def cancel(self, job_id: str) -> ScanJob:
        job = await self.get(job_id)
        if job.status in TERMINAL:
            return job
        return await self.update(job_id, status=JobStatus.CANCELLED, error_code="CANCELLED_BY_CLIENT")


# Backward-compatible alias for old tests/imports; still SQLite-backed, never in-memory.
class InMemoryJobStore(SQLiteJobStore):
    """Compatibility helper for tests; implemented as a private temporary SQLite file."""
    def __init__(self, max_records: int = 500):
        import tempfile
        self._tmpdir = tempfile.TemporaryDirectory(prefix="cla-jobstore-")
        super().__init__(Path(self._tmpdir.name) / "jobs.sqlite3", max_records=max_records, max_queued=5)
