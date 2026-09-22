from __future__ import annotations

from datetime import datetime, timezone
from enum import Enum
from typing import Any

from pydantic import BaseModel, Field


class JobStatus(str, Enum):
    QUEUED = "QUEUED"
    RUNNING = "RUNNING"
    SUCCEEDED = "SUCCEEDED"
    AUDIT_INCOMPLETE = "AUDIT_INCOMPLETE"
    FAILED = "FAILED"
    CANCELLED = "CANCELLED"


class ScanCreate(BaseModel):
    url: str = Field(min_length=8, max_length=2048)


class RuleDecision(BaseModel):
    rule_id: str
    result: str
    message: str
    confidence: str = "HIGH"
    evidence_level: str = "L0"
    fact_refs: list[str] = Field(default_factory=list)


class PageEvidence(BaseModel):
    requested_url: str
    final_url: str | None = None
    status: int | None = None
    access_state: str
    facts: dict[str, Any] = Field(default_factory=dict)


class ScanResult(BaseModel):
    requested_url: str
    final_url: str | None = None
    access_state: str
    pages: list[PageEvidence] = Field(default_factory=list)
    decisions: list[RuleDecision] = Field(default_factory=list)
    warnings: list[str] = Field(default_factory=list)


class ScanJob(BaseModel):
    id: str
    requested_url: str
    status: JobStatus
    phase: str | None = None
    created_at: datetime
    updated_at: datetime
    result: ScanResult | None = None
    error_code: str | None = None
    error_detail: str | None = None

    @classmethod
    def new(cls, job_id: str, url: str) -> "ScanJob":
        now = datetime.now(timezone.utc)
        return cls(id=job_id, requested_url=url, status=JobStatus.QUEUED, phase="CHECKING_ACCESS", created_at=now, updated_at=now)
