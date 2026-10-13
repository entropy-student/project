# MediaCrawler Local Lab — DECISION_LOG
> Created: 2026-10-13. Governance v0.2.7.
## Decision 2026-10-13 — Rapid original Windows app, no feature removal
- Owner asked to fully apply management Governance and **quickly clone original second project MediaCrawler to Windows local PC, with original functions preserved**. Reviewer chooses native Windows (NOT Docker) because previous BettaFish GHCR pull induced host resource pressure before containers; user wants fastest original WebUI.
- `DIRECT_READBACK` original upstream 2026-10-10 main source SHA `156c602c8d689266e6c5e9130b36f0b70495f5f0`. Preexisting `uv.lock`, `webui/package-lock.json`, and Vite static build into `api/webui`. Original WebUI uses `api/main.py`, crawler and data FastAPI routers. No rewrite necessary.
- Preserve all seven platforms, original search/detail/creator/comment/media-download/storage/export UI. Original UI only starts one platform per task (no cross-platform job queue yet); no new feature promised. Codex later analyzes exported data.
- Exactly 2 tracked config toggles allowed to disable CDP and attaching user's existing Chrome/Edge; standard Playwright uses per-project `browser_data` with optional persistent login. Use project-contained browser binary, single `uvicorn` localhost service, no Vite dev after static build.
- Raw `--cookies` flag currently passed to subprocess/logged by WebUI manager: do NOT enter Cookie into UI or relay; Owner manual QR later requires separate real-action Gate; commercial use excluded by NON-COMMERCIAL LEARNING LICENSE 1.1.
- No blanket 4GiB free RAM requirement; fresh staged resource safety guard protects other workloads. Avoid any BettaFish Docker partial cache deletion or other project disruption.

## Review 2026-10-13 — G1 tool-missing repaired by portable Python/uv inside project
- Owner-local first G1 attempt returned early (`RETURN_RUNTIME_TOOL_MISSING`) with no files changed. This is a real prerequisite shortfall, not evidence of MediaCrawler incompatibility or RAM failure.
- No system-wide Python 3.11 / uv installation necessary. Authorization boundary for G1R expands only to new project-owned portable uv 0.12.20 Windows x64 artifact (GitHub release verified SHA256), uv-managed Python3.11 confined to project-owned `runtime/python`, and project-local install cache, with `--no-bin` to avoid user-global executables. Existing Python 3.10 remains untouched.
- Prefer one combined bounded Gate (runtime prep+original UI), no extra analysis Gate; stop if current RAM/Disk degrades or other apps affected. No unauthorized platform login/crawler execution and no moving-upstream version changes.

## Decision 2026-10-13 — G1R memory preflight RETURN, stop repeat attempts
- G1R pre-write RAM fell from two readings 1.947/1.822 GiB to 1.091/1.106 GiB; no installation started and project is still absent. Owner has other projects running; **do not retry same heavy installer, force-close apps, restart Docker/WSL or weaken RAM stop guard** merely to get a PASS.
- Root cause UNKNOWN. Reviewer chooses a short read-only RAM/categorized-process audit Gate (G1M), no file write, no downloads, no process mutations. Distinguish working set, private/commit, actual Available from total capacity and Docker VM capacity. Missing whole-host attribution is expected; do not claim every byte accounted for by process sums.
- If sustained capacity unfit, recommend a distinct target/environment AFTER Owner selects it; Hostinger exists in historical context but current capacity and overseas XHS login unknown; do not silently move source remotely. If adequate headroom, prepare staged local original-app install Gate with measured headroom, NOT unattended retry.
