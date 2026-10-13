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
