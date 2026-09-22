from __future__ import annotations

import asyncio
import json
import sys
import tempfile
import time
from pathlib import Path
from typing import Any

from ..config import SETTINGS
from ..jobs import SQLiteJobStore
from ..models import JobStatus, ScanResult, PageEvidence, RuleDecision
from ..security import validate_url_syntax, resolve_and_validate, UnsafeTarget
from ..extractors.static import extract_static_facts
from ..rules.coordinator import evaluate_if_ready
from .fact_state import build_rule_state

RULE_IDS = [
    "GATE-001", "GATE-002", "CORE-001", "CORE-002", "CORE-003", "CORE-004",
    "CORE-006", "CORE-007", "CORE-009", "CORE-010", "PHYS-001", "PHYS-002",
    "SUB-001", "SUB-002", "SUB-003", "SUB-004", "SUB-005",
]

FACT_REF_MAP = {
    "GATE-001": ["page:0.status", "page:0.access_state"],
    "GATE-002": ["page:0.final_url", "page:0.facts.visible_currency"],
    "CORE-001": ["page:0.status"],
    "CORE-002": ["page:0.facts.direct_purchase_signal", "page:0.facts.out_of_stock_signal"],
    "CORE-003": ["page:0.access_state"],
    "CORE-004": ["page:0.facts.form_accessibility"],
    "CORE-006": ["page:0.facts.internal_links"],
    "CORE-007": ["page:0.facts.visible_price", "page:0.facts.direct_purchase_signal"],
    "CORE-009": ["page:0.facts.noindex"],
    "CORE-010": ["page:0.facts.visible_price", "page:0.facts.visible_currency", "page:0.facts.structured_price", "page:0.facts.structured_currency"],
    "PHYS-001": ["page:0.facts.return_links"],
    "PHYS-002": ["page:0.facts.shipping_links"],
    "SUB-001": ["page:0.facts.intro_price", "page:0.facts.standard_price"],
    "SUB-002": ["page:0.facts.cadence_visible"],
    "SUB-003": ["page:0.facts.auto_renew_signal"],
    "SUB-004": ["page:0.facts.trial_days", "page:0.facts.standard_price", "page:0.facts.auto_renew_signal"],
    "SUB-005": ["page:0.facts.cancel_signal"],
}

BLOCK_BROWSER_FALLBACK = {
    "ROBOTS_DENIED", "RATE_LIMITED", "ACCESS_BLOCKED", "UNSAFE_TARGET",
    "SCRAPY_DEPENDENCY_UNAVAILABLE", "RESPONSE_BODY_TOO_LARGE",
}


def _public_facts(facts: dict[str, Any]) -> dict[str, Any]:
    """Persist bounded evidence only; never persist full raw HTML/body text."""
    out = {k: v for k, v in facts.items() if k != "body_text"}
    if facts.get("body_text"):
        out["bounded_text_snippet"] = str(facts["body_text"])[:1000]
    # Avoid unbounded link arrays in persisted evidence.
    for key in ("return_links", "shipping_links", "internal_links"):
        if isinstance(out.get(key), list):
            out[key] = out[key][:20]
    return out


def _fact_refs_for(rule_id: str, result: str, page: PageEvidence | None) -> list[str]:
    if page is None or result in {"NOT_APPLICABLE", "CONTEXT_INSUFFICIENT"}:
        return []
    candidates = FACT_REF_MAP.get(rule_id, [])
    refs: list[str] = []
    for ref in candidates:
        if ref == "page:0.status" and page.status is not None:
            refs.append(ref)
        elif ref == "page:0.access_state":
            refs.append(ref)
        elif ".facts." in ref:
            key = ref.rsplit(".", 1)[-1]
            if key in page.facts and page.facts.get(key) is not None:
                refs.append(ref)
        elif ref == "page:0.final_url" and page.final_url:
            refs.append(ref)
    return refs


class ScanRunner:
    def __init__(self, store: SQLiteJobStore):
        self.store = store
        self._sem = asyncio.Semaphore(SETTINGS.max_concurrent_jobs)
        self._tasks: dict[str, asyncio.Task] = {}

    def schedule(self, job_id: str, url: str):
        t = asyncio.create_task(self._run(job_id, url))
        self._tasks[job_id] = t
        t.add_done_callback(lambda _: self._tasks.pop(job_id, None))

    async def cancel(self, job_id: str):
        t = self._tasks.get(job_id)
        if t and not t.done():
            t.cancel()

    async def _run(self, job_id: str, url: str):
        async with self._sem:
            if (await self.store.get(job_id)).status == JobStatus.CANCELLED:
                return
            await self.store.update(job_id, status=JobStatus.RUNNING, phase="CHECKING_ACCESS")
            started = time.monotonic()
            try:
                syntax = validate_url_syntax(url)
                await asyncio.to_thread(resolve_and_validate, syntax)
                await self.store.update(job_id, phase="READING_PAGES")
                payload = await self._scrapy(url, self._remaining(started))

                statuses = {p.get("status") for p in payload.get("pages", [])}
                error_code = payload.get("error_code")
                can_fallback = (
                    SETTINGS.allow_browser_fallback
                    and payload.get("access_state") != "ACCESS_OK"
                    and not ({403, 429} & statuses)
                    and error_code not in BLOCK_BROWSER_FALLBACK
                    and self._remaining(started) > 1
                )
                if can_fallback:
                    browser = await self._browser(url, self._remaining(started))
                    if browser.get("access_state") == "ACCESS_OK":
                        payload = browser
                    elif payload.get("access_state") != "ACCESS_OK":
                        payload.setdefault("warnings", []).append(browser.get("error_code") or "BROWSER_FALLBACK_INCOMPLETE")

                pages: list[PageEvidence] = []
                for p in payload.get("pages", [])[: SETTINGS.max_pages]:
                    facts: dict[str, Any] = {}
                    if p.get("html") and p.get("status") == 200:
                        facts = extract_static_facts(p["html"], p.get("final_url") or p["requested_url"])
                    pages.append(PageEvidence(
                        requested_url=p["requested_url"],
                        final_url=p.get("final_url"),
                        status=p.get("status"),
                        access_state="ACCESS_OK" if p.get("status") == 200 else "AUDIT_INCOMPLETE",
                        facts=_public_facts(facts),
                    ))

                await self.store.update(job_id, phase="MATCHING_EVIDENCE")
                decisions: list[RuleDecision] = []
                first = pages[0] if pages else None
                if first:
                    # Rebuild rule state from full freshly-extracted facts, not the bounded persisted subset.
                    source_page = payload.get("pages", [])[0]
                    full_facts = extract_static_facts(source_page.get("html", ""), source_page.get("final_url") or source_page.get("requested_url")) if source_page.get("html") and source_page.get("status") == 200 else {}
                    state = build_rule_state({"final_url": first.final_url, "status": first.status, "access_state": first.access_state, "facts": full_facts})
                    for rid in RULE_IDS:
                        raw = evaluate_if_ready(rid, state)
                        refs = _fact_refs_for(rid, raw["result"], first)
                        # An ISSUE without concrete evidence is forbidden: degrade instead of guessing.
                        if raw["result"] == "ISSUE" and not refs:
                            raw = {
                                "rule_id": rid,
                                "result": "CONTEXT_INSUFFICIENT",
                                "message": "必要证据引用不足",
                                "confidence": "LOW",
                                "evidence_level": raw.get("evidence_level", "L0"),
                            }
                            refs = []
                        decisions.append(RuleDecision(
                            rule_id=rid,
                            result=raw["result"],
                            message=raw["message"],
                            confidence=raw.get("confidence", "HIGH"),
                            evidence_level=raw.get("evidence_level", "L0"),
                            fact_refs=refs,
                        ))

                result = ScanResult(
                    requested_url=url,
                    final_url=pages[0].final_url if pages else None,
                    access_state=payload.get("access_state", "AUDIT_INCOMPLETE"),
                    pages=pages,
                    decisions=decisions,
                    warnings=list(payload.get("warnings", [])),
                )
                st = JobStatus.SUCCEEDED if result.access_state == "ACCESS_OK" else JobStatus.AUDIT_INCOMPLETE
                await self.store.update(job_id, status=st, phase="COMPLETE" if st == JobStatus.SUCCEEDED else "INCOMPLETE", result=result, error_code=payload.get("error_code"))
            except UnsafeTarget as exc:
                await self.store.update(job_id, status=JobStatus.FAILED, phase="FAILED", error_code=f"UNSAFE_TARGET_{exc.reason}", error_detail="Target rejected by network safety gate")
            except asyncio.CancelledError:
                await self.store.update(job_id, status=JobStatus.CANCELLED, phase="CANCELLED", error_code="CANCELLED_BY_CLIENT")
                raise
            except Exception as exc:
                # Client-facing API sees only bounded error metadata through the stored job.
                await self.store.update(job_id, status=JobStatus.AUDIT_INCOMPLETE, phase="INCOMPLETE", error_code="SCAN_RUNTIME_ERROR", error_detail=type(exc).__name__)

    def _remaining(self, started: float) -> float:
        return max(0.0, SETTINGS.max_runtime_seconds - (time.monotonic() - started))

    async def _worker(self, module: str, url: str, seconds: float):
        if seconds <= 0:
            return {"access_state": "AUDIT_INCOMPLETE", "error_code": "SCAN_TIMEOUT", "pages": []}
        with tempfile.TemporaryDirectory(prefix="cla-scan-") as td:
            out = Path(td) / "result.json"
            args = [sys.executable, "-m", module, "--url", url, "--out", str(out)]
            if module.endswith("scrapy_worker"):
                args += [
                    "--max-pages", str(SETTINGS.max_pages),
                    "--max-depth", str(SETTINGS.max_depth),
                    "--max-redirects", str(SETTINGS.max_redirects),
                    "--max-body-bytes", str(SETTINGS.max_response_bytes),
                ]
            else:
                args += [
                    "--max-redirects", str(SETTINGS.max_redirects),
                    "--max-body-bytes", str(SETTINGS.max_response_bytes),
                    "--timeout-ms", str(int(min(seconds, 25) * 1000)),
                ]
            proc = await asyncio.create_subprocess_exec(*args, stdout=asyncio.subprocess.DEVNULL, stderr=asyncio.subprocess.DEVNULL)
            try:
                await asyncio.wait_for(proc.wait(), timeout=seconds)
            except asyncio.TimeoutError:
                proc.kill()
                await proc.wait()
                return {"access_state": "AUDIT_INCOMPLETE", "error_code": "SCAN_TIMEOUT", "pages": []}
            if not out.exists():
                return {"access_state": "AUDIT_INCOMPLETE", "error_code": "CRAWLER_NO_OUTPUT", "pages": []}
            return json.loads(out.read_text(encoding="utf-8"))

    async def _scrapy(self, url: str, seconds: float):
        return await self._worker("app.crawlers.scrapy_worker", url, seconds)

    async def _browser(self, url: str, seconds: float):
        return await self._worker("app.crawlers.browser_worker", url, seconds)
