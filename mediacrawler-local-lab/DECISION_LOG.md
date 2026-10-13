# MediaCrawler Local Lab — DECISION_LOG
> Created: 2026-10-13. Governance v0.2.7.
## Decision 2026-10-13 — Rapid original Windows app, no feature removal
- Owner asked to fully apply management Governance and **quickly clone original second project MediaCrawler to Windows local PC, with original functions preserved**. Reviewer chooses native Windows (NOT Docker) because previous BettaFish GHCR pull induced host resource pressure before containers; user wants fastest original WebUI.
- `DIRECT_READBACK` original upstream 2026-10-10 main source SHA `156c602c8d689266e6c5e9130b36f0b70495f5f0`. Preexisting `uv.lock`, `webui/package-lock.json`, and Vite static build into `api/webui`. Original WebUI uses `api/main.py`, crawler and data FastAPI routers. No rewrite necessary.
- Preserve all seven platforms, original search/detail/creator/comment/media-download/storage/export UI. Original UI only starts one platform per task (no cross-platform job queue yet); no new feature promised. Codex later analyzes exported data.
- Exactly 2 tracked config toggles allowed to disable CDP and attaching user's existing Chrome/Edge; standard Playwright uses per-project `browser_data` with optional persistent login. Use project-contained browser binary, single `uvicorn` localhost service, no Vite dev after static build.
- Raw `--cookies` flag currently passed to subprocess/logged by WebUI manager: do NOT enter Cookie into UI or relay; Owner manual QR later requires separate real-action Gate; commercial use excluded by NON-COMMERCIAL LEARNING LICENSE 1.1.
- No blanket 4GiB free RAM requirement; fresh staged resource safety guard protects other workloads. Avoid any BettaFish Docker partial cache deletion or other project disruption.
