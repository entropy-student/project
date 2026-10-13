# BettaFish Local Lab — DECISION_LOG
> Canonical: entropy-student/project main:bettafish-local-lab/

## Decision 2026-10-13 — Prioritize embedded collector with Codex analytics
- Owner approved retaining **BettaFish**, but narrowing MVP to **keyword crawl / data export → Codex analysis** rather than full local multi-agent/report stack.
- This is a **scope refinement**, NOT approval to migrate to a different project or automatically replace pinned submodule with latest MediaCrawler.
- First candidate: BettaFish immutable source `b67928ff1ce515dd7672408221fb1e9500d0972d` and its embedded MediaCrawler submodule `4de2a325a9cd4f7de7dfb58204b154fc2bb86e40`.
- Why: BettaFish's MindSpider wrapper requires keyword DB and forces DB storage; embedded MediaCrawler has native JSON / CSV / Excel export and can potentially be invoked independently. The pinned edition does **not** offer JSONL output.
- Owner work environment: Edge/ChatGPT/Codex are necessary and must remain uninterrupted; low free RAM makes full Compose undesirable as first test.
- Prior conditional `G0M_MEMORY_RECHECK_GATE.md` is deferred for any future resource-heavy full Compose deployment. It is not a prerequisite for the new isolated source-only offline Gate.
- G1L offline Gate tests isolated checkout + export data contract using synthetic examples. No API key, platform login, crawler, model or Docker services. Future real crawler smoke is a separate reviewed authorization, bounded in count/rate/login/target, with privacy/license/SAFE_MODE protections.
- Future real crawl/profile handling needs explicit Owner authorization. Commercial deployment of NON-COMMERCIAL LEARNING LICENSE source needs license clearance or a legally suitable alternative.

## Clarification 2026-10-13 — Official 2 GB memory recommendation versus Reviewer 4 GiB buffer
- `DIRECT_READBACK`: BettaFish official `README.md` in "运行环境要求" explicitly states `内存: 建议2GB以上`; `README-EN.md` likewise says `Memory: 2GB+ recommended`. Source: https://github.com/666ghj/BettaFish/blob/main/README.md .
- It does not state that 4 GiB **currently free** RAM is mandatory. Reviewer-authored ~4 GiB free RAM for full Flask + PostgreSQL + 3 Streamlit service boot was an extra risk buffer and should never have been framed as vendor minimum or general installation blocker.
- Owner PC total 15.28 GiB; it meets the documented host-memory recommendation, but full-service peak usage remains unmeasured. Don't conflate total system memory, currently available memory, Docker Engine VM capacity, image/disk footprint and peak use.
- G1L is isolated source/synthetic-only, no full stack deployment; it has its own lightweight preflight. Keep future real collector memory evidence staged and observed. G0M remains a historical optional/full-compose preparation Gate, not prerequisite to G1L. Any future full Compose criterion may be revised with appropriate evidence and safety monitoring.

## Review 2026-10-13 — G1L partial acceptance and actual XHS 20-item floor
- Owner provided G1L `PASS_CANDIDATE` with correct immutable root+submodule refs and synthetic 3-note/4-comment report. Reviewer independently inspected upstream source and accepted CLI/export contract, but has not directly accessed Owner local synthetic JSON, so formal G1L overall status is `PARTIAL`, not runtime PASS.
- Separate immutable-source review of `media_platform/xhs/core.py` lines 128–131 reveals hard minimum `xhs_limit_count = 20`; `CRAWLER_MAX_NOTES_COUNT=1` alone cannot enforce a one-note canary. Any future real user access requires programmatic limit/guard, not aspirational prompt/config limit.
- G2 focuses on isolated dependency install if ready and **actual pinned export writer with synthetic data**. G2 does not grant live XHS, browser, login, API key, paid model, or full BettaFish execution.
- Host memory fluctuated 4.12 → 2.65 GiB after G1L, cause UNKNOWN. Avoid 4 GiB arbitrary mandatory floor; enforce per-Gate bounded stop conditions and report peak/headroom before real crawl.

## Decision 2026-10-13 — Owner returns to Docker for rapid local application bootstrap
- Owner: “改一下，部署在docker里吧还是，快速搬运项目然后落地应用。” This supersedes unexecuted G2 Windows Python/venv gate, NOT past G1L evidence. BettaFish retained; no change of canonical project.
- First objective: official BettaFish Docker image and PostgreSQL through localhost-only guarded proxy, **one bounded Gate** for image pull, config, startup, minimal site/db validation, rollback. No full source build/standalone native CLI install now. Exact image digests freeze observed builds; GHCR artifact correspondence with locked source SHA unknown, must report.
- Reviewer independently found critical unauthenticated `GET /api/config` returns DB_PASSWORD/API_KEY config and `POST /api/config` modifies settings. Therefore official Compose unchanged is NOT safe. Guard through minimal loopback-only reverse proxy, block all APIs by default except status; hide direct Flask port, no public DB port and no real API keys. UI smoke only; not full analysis/crawler functionality.
- Disposable local DB protected random credential permitted only after explicit Owner delegation in copied relay; no existing user secret. Do not print or store in repo/ordinary artifacts.
- Official README “内存建议2GB以上” refers to machine recommendation; G2D uses real resource observation, not earlier Reviewer 4GiB currently-free gate.
- Existing priority keyword → notes/comments → JSON/CSV → Codex remains unchanged. Docker boot is not crawler PASS.
