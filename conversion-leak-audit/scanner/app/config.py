from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class Settings:
    max_pages: int = 6
    max_depth: int = 1
    max_redirects: int = 5
    max_response_bytes: int = 5 * 1024 * 1024
    max_runtime_seconds: int = 45
    max_browser_pages: int = 2
    max_concurrent_jobs: int = 1
    max_queued_jobs: int = 5
    max_interactive_actions: int = 1
    max_job_records: int = 500
    allow_browser_fallback: bool = True
    database_path: str = "scanner-v0.sqlite3"
    artifact_ttl_hours: int = 24
    production_egress_enforcement_ready: bool = False


SETTINGS = Settings()
