# MediaCrawler Local Lab — REVIEWER_HANDOFF
> Updated: 2026-10-13
> Governance: `entropy-student/spike.skill` main:`vps-project-governance/VNEXT.md` v0.2.7 ACTIVE_PROVISIONAL
> Canonical: `entropy-student/project` main:`mediacrawler-local-lab/`
> Executor: Owner's Windows 11 local Codex; Reviewer owns Gate/Evidence/GitHub
> STOP_AT_REVIEWER: YES

## PROJECT_GOAL
原样快速复刻 **NanmiCoder/MediaCrawler** 至 Owner Windows 11，首次即可操作原版 WebUI，支持小红书/抖音/快手/B站/微博/贴吧/知乎按关键词搜索、详情、创作者、评论、数据预览/导出（JSONL/JSON/CSV/Excel/SQLite 等原版路径），未来输出交给 Codex 分析。**保持开源原有功能，不开发新前端、AI Agent、多平台自动排队或新增 Docker 架构**。官方版每次采集任务通常单平台；不是原生一次执行七个平台队列。使用限学习研究；商业用途需另取得授权。

## PROJECT_STAGE
G1 and G1R both RETURNed before local writes (first missing Python/uv, then RAM latest ~1.09 GiB). Owner reports **~1.7 GiB free after voluntarily freeing resources** and requests a conditional installation retry. Current G1S one-shot retry Gate is ACTIVE on Owner relay, using fresh repeated RAM readings. Old G1M read-only RAM diagnosis is deferred, not active. No MediaCrawler local install or real crawl yet.

## SYSTEM_MAP
- Physical Owner-local Windows 11 Home build 26300, Codex on owner host, PowerShell 7.6.5 (past OWNER_REPORTED); must re-prove before writes. Host ~15.28 GiB total RAM; earlier G2D official BettaFish Docker image download caused available RAM to dip 0.587 GiB (cause UNKNOWN), so STOP on new live resource pressure and NEVER touch other workloads/processes, Docker, Clash/WG/HY2/Edge/ChatGPT/Codex/WSL.
- Exact public upstream `NanmiCoder/MediaCrawler` root commit **`156c602c8d689266e6c5e9130b36f0b70495f5f0`** (Github reviewed, 2026-10-10 upstream main); includes `uv.lock` and `webui/package-lock.json`. Source URL https://github.com/NanmiCoder/MediaCrawler . Do NOT use moving `main` in installed candidate; no upstream tag/digest confusion.
- Windows native selected instead of Docker: G1R adds only project-owned `runtime/tools/uv.exe` verified from uv 0.12.20 GitHub release and `runtime/python/` uv-managed CPython 3.11, without PATH/global installation. `uv sync --locked` project-scoped Python virtual environment, `npm ci` within webui and `npm run build` once to `api/webui/`. One steady-state `uvicorn api.main:app --host 127.0.0.1 --port 8080` serves static UI and API; use existing Node/uv/Python/Git if verified. No Vite dev process after build; port alternative `18080` only if 8080 occupied and alternate unused. No DB for JSONL/JSON/CSV; native options retained.
- Only new project-owned folder `%LOCALAPPDATA%\MediaCrawlerLocalLab\original-webui-v1`; `source\` git clone plus `runtime\` launch/log-control docs/Browser artifacts / caches; local protected `source\browser_data\` profile and `source\data\` exports. Project-local `PLAYWRIGHT_BROWSERS_PATH` for installed Chromium. All login-state/profile and gathered content local only, never committed/shared.
- CLI supports xhs/dy/ks/bili/wb/tieba/zhihu; WebUI `api/main.py`, `api/services/crawler_manager.py`, `api/routers/data.py`, `webui`; static build path confirmed `webui/vite.config.ts`.
- Important privacy/security: upstream `config/base_config.py` defaults `ENABLE_CDP_MODE=True`, `CDP_CONNECT_EXISTING=True` => could control user's active Chrome/Edge; first-run project copy allowlist edits only these 2 fields to FALSE so Playwright separate `source\browser_data\` profile. Never attach remote debugging port or personal profile. `api/services/crawler_manager.py` logs full `--cookies` command; **do not use cookie login** for this gate or relay credential/log values. QR/manual platform login not allowed by G1 and requires next approved live canary. No system-wide browser settings.
- Native backend listens localhost only, because crawler APIs are unauthenticated; no LAN/VPS/public access, no firewall/router changes or port forwarding. Anonymous local API not production-ready.
- License `NON-COMMERCIAL LEARNING LICENSE 1.1`, forbids commercial use without owner consent; follow target platform rules, limits and privacy. First G1 tests only health/flags/UI and **synthetic** export, no social platform real requests.

## CURRENT_ACCEPTED_STATE
GitHub source and official uv digest independently inspected. Owner Codex G1R last saw RAM 1.091/1.106 GiB; no MediaCrawler project files, downloads or processes. New ~1.7 GiB after cleanup is **OWNER_REPORTED only**, not a sustained verified baseline. Node/npm/Git present; Python3.11 and uv absent. Target must be freshly checked.

## CURRENT_GATE
`MC-G1S-RECOVERED-RAM-ONE-SHOT-20261013` at `G1S_RECOVERED_RAM_ONE_SHOT_GATE.md`, active upon Owner relay. Current G1M diagnosis deferred by updated Owner objective; old G1R remains RETURN, do not retry it without this new Gate.

## CRITICAL_CONSTRAINTS
- Physical Owner Windows local only. Existing Codex, desktop ChatGPT, Edge, Docker/WSL and VPN/Clash, other projects must continue untouched. No process killing/restart/system tweaks, global uv/Node/Git/Python installs, Windows ACL parent rewrites, global cache/prune, admin.
- Pin Git exact source, preserve full original features and UI; only 2 tiny config flips to separate browser CDP. No patching security/behavior broadly or cherry-pick latest, no platform-auth/cookies/credentials.
- Project-local Python/cache/npm/Playwright browser downloads only, bounded. User has requested fast local availability; G1R explicitly permits project-contained portable uv and CPython3.11, with official download+digest and no external global changes; other missing prerequisites RETURN.
- No real platform crawler start in G1, even if WebUI button exposed; Owner manual login and first single-platform canary are separate explicit steps. Preserve account/data separation and noncommercial restriction.
- Local online service loopback only, unauthenticated API never exposed to LAN. Exports and future profiles remain in protected local scope, no GitHub upload.

## DEFAULT_EXECUTION_CHANNEL
Owner's local Windows 11 Codex. Reviewer creates/updates canonical GitHub docs. Owner relays condensed local evidence.

## CURRENT_ROLLBACK_STATUS
G1/G1R created no local project artifacts. G1S may create only its new project-owned folder and one loopback server, stop only own process on failure, preserve partial files for Reviewer. Old BettaFish state unchanged.

## UNRESOLVED
Owner's new ~1.7 GiB available RAM is a single observation: stability unknown; prior abrupt drop may recur. G1S has repeated preflight and stage-by-stage memory checks, no threshold reduction. Real MediaCrawler platform use, login state, resource footprint remain untested.

## NEXT_STEP
Owner relays G1S once. Codex checks three memory samples over 30-45 seconds >=1.5 GiB and no >0.3 GiB decline, then conditionally executes the same pinned original local install plan (portable uv/Python3.11, React static build, isolated Chromium, loopback WebUI). If preflight or stage RAM fails, RETURN with facts; no repeated retry, no real social login/crawl.

## OWNER_ACTION_REQUIRED
Send only the NEW G1S relay to Codex. No more manual cleanup required. Do not send old G1R or G1M. Report safe redacted outcome.

## EVIDENCE_POINTERS
- `G1R_PORTABLE_TOOLCHAIN_AND_ORIGINAL_WEBUI_GATE.md` RESOURCE_RETURN / not active.
- `G1M_WINDOWS_MEMORY_READONLY_DIAGNOSTIC_GATE.md` DEFERRED.
- `G1S_RECOVERED_RAM_ONE_SHOT_GATE.md` ACTIVE.
- `G1_WINDOWS_ORIGINAL_WEBUI_LAUNCH_GATE.md` previous tool-missing RETURN.
- `EXECUTION_EVIDENCE.md` read-only source review; local runtime pending.
- `DECISION_LOG.md` scope and native-vs-Docker rationale.
- `USER_GUIDE.md` intended usage and limitations.
