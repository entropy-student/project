# G1S — Recovered-RAM one-shot Windows WebUI retry
GATE_ID: MC-G1S-RECOVERED-RAM-ONE-SHOT-20261013
STATUS: ACTIVE_AFTER_OWNER_RELAY
MAX_ENDPOINT_THIS_ROUND: one fresh stable-RAM preflight; conditional pinned MediaCrawler Windows original WebUI install and offline demo, otherwise stop
MANDATORY_REVIEW_STOP: YES

## OBJECTIVE
Owner voluntarily freed memory and reports ~1.7 GiB now available. After G1R resource RETURN at ~1.09 GiB with zero changes, permit a **single materially changed preflight** and a full original MediaCrawler install only if new RAM is stable. Never claim 1.7 GiB alone proves success.

## TARGET_AND_SCOPE
Owner physical Windows 11 x64 local Codex, PowerShell; previously no project root created. New project root only `%LOCALAPPDATA%\MediaCrawlerLocalLab\original-webui-v1`; must be absent on fresh host-local readback, or RETURN collision. Source repo `NanmiCoder/MediaCrawler` pinned SHA `156c602c8d689266e6c5e9130b36f0b70495f5f0`; browser profiles and data local to this project. G1R detailed original Windows installation recipe at `mediacrawler-local-lab/G1R_PORTABLE_TOOLCHAIN_AND_ORIGINAL_WEBUI_GATE.md` is a **referenced implementation checklist only**, not an active second Gate. Read that one file only as needed; current G1S stop/authorization boundary controls in any conflict. No Docker, VPS, existing BettaFish mutations or broad Governance/history rereads by Executor.

## APPLICABLE_CRITICAL_CONSTRAINTS
Canonical Governance `entropy-student/spike.skill` v0.2.7 sec 0–10, 11A/11B/11C/11D interpreted by Reviewer. Preserve all seven original platform/mode/comment/export/UI functions; only cloned config `ENABLE_CDP_MODE=False` and `CDP_CONNECT_EXISTING=False` permitted. Do not attach personal Chrome/Edge, access saved Cookie, enable remote debug. Original crawler manager logs `--cookies`; no cookie input. Keep backend unauthenticated API **127.0.0.1 only**; never make public. No real social site requests, QR/login, crawler start, user data, tokens, paid AI, or commercial activity. Never kill/close other processes, edit global Python/uv/PATH, Docker/WSL/Clash/VPN, system services, firewall or global cache. No GitHub write by Codex.

## PREFLIGHT
1. Reconfirm intended Owner Windows local machine, user-level execution, x64, free disk >=12 GiB, Git/Node/npm present, 8080 or 18080 unoccupied, project root absent. No cached assumption about yesterday's readings.
2. With identical Windows Available RAM metric, sample **at least 3 readings over ~30–45s**, every value **>=1.5 GiB**. Reject sustained decline of >0.3 GiB, observed OOM/pagefile thrash or harm to other projects. If fail: `RETURN_RESOURCE_HEADROOM_INSUFFICIENT` **before creating anything**. Owner's ~1.7 GiB report is not the proof. Do not try repeatedly until one passing set appears.
3. Before each heavy stage (uv/Python download, dependency sync, npm build, Chromium, web server) re-read RAM; >=1.5 GiB before initiating heavy stage, and **stop project-owned operations immediately** if available RAM <1.0 GiB, unexpected other-app disruption, or disk delta >6 GiB. No global optimization, cleanup or unattended retries. If RAM declines after a partial install, preserve known project-owned state; RETURN_RESOURCE_PRESSURE.

## EXECUTION — AFTER PREFLIGHT ONLY
1. Fetch official Windows x64 portable uv `0.12.20` to project-owned runtime folder; archive SHA256 must match `95f9bc30fbb3574d276e28ac4a6de932d25153645853d13da8c21eec3bc88d06` before use. Project-only `UV_PYTHON_INSTALL_DIR`, `UV_PYTHON_BIN_DIR`, `UV_CACHE_DIR`, `TEMP/TMP`; `uv python install 3.11 --no-bin` no global Python or PATH.
2. Clone exact pinned SHA to project `source`; verify HEAD + committed `uv.lock` and `webui/package-lock.json`; `uv sync --locked --no-dev --python 3.11 --no-python-downloads` to isolated `.venv`, using project-local cache. `npm ci` with project-local cache in `webui`, then `npm run build` produces original `api/webui/index.html` (not a replacement UI).
3. Change only the two cloned CDP config toggles, leave all other original functionality intact; install matching Playwright Chromium into project-only `runtime/playwright-browsers` if new stage memory permits; no browser launch/login yet.
4. Add project-owned Start shortcut and run one `source\.venv\Scripts\python.exe -m uvicorn api.main:app --host 127.0.0.1 --port 8080` (18080 only if 8080 occupied and 18080 free); no dev Vite/--reload/autostart. Offline synthetic note fixture, verify HTML/static, `GET /api/health`, seven `/api/config/platforms`, idle `/api/crawler/status`, `/api/data/files` list + byte-match download. Do not POST start. If Chromium blocked by resources but app complete, `PARTIAL_BROWSER_PENDING` and give URL, not full PASS.
5. Verify pin/lockfiles unchanged except two allowlisted toggles; RAM samples by stage, owned disk use, localhost port, no effects on existing apps. Leave successful own WebUI running for Owner. Otherwise stop only own service, do not erase unknown/valuable paths. No second retry within this Gate.

## REQUIRED_EVIDENCE
`GATE_ID`, `TARGET_LOCAL_PROOF`, `RAM_3PLUS_PREFLIGHT_SAMPLES_GiB`, `RAM_SAMPLE_DURATION_SECONDS`, `RAM_TREND`, `RAM_PER_STAGE_AVAILABLE_GiB`, `DISK_PRE_POST_GiB`, `ROOT_PREEXISTED_BOOL`, `UV_SHA_MATCH_AND_VERSION`, `PYTHON311_PROJECT_ONLY`, `SOURCE_SHA_AND_LOCKFILES`, `NPM_BUILD`, `CDP_DISABLED`, `CHROMIUM_PROJECT_ONLY`, `LOCAL_URL_OR_NONE`, `HTTP_HTML_ASSETS_HEALTH`, `SEVEN_PLATFORMS`, `CRAWLER_IDLE`, `SYNTHETIC_EXPORT_DOWNLOAD_SHA`, `LOOPBACK_ONLY`, `ACTUAL_CHANGES`, `NON_TARGET_DELTA`, `REAL_PLATFORM_CALLS=NONE`, `ANOMALIES`, `RESULT`, `STOP_AT_REVIEWER=YES`. Local facts remain OWNER_REPORTED until independently reviewed.

## ACCEPTANCE_CRITERIA
`PASS_CANDIDATE`: stable fresh resource gate + original pinned source/full static WebUI/7 platforms/JSON synthetic data check/isolated browser/loopback only/no real social calls/no other project harm. `PARTIAL_BROWSER_PENDING`: original web served but project browser not yet safely available. Otherwise precise RETURN. This proves OFFLINE WebUI only; real crawler and QR remain a separate Owner-authorized Gate.

## ROLLBACK_STATUS_OR_PLAN
G1/G1R created nothing. G1S only owns fresh project tree and its web process. Stop ONLY own process on failure; preserve partial files and send Reviewer sanitized status. No Docker prune, file deletion, account changes, migration or existing system modifications.

## OWNER_ONLY_ACTIONS
Forwarding the relay authorizes one controlled attempt to download/install verified **project-local** uv/Python3.11, original source and declared locked deps, project-local Playwright browser, launch offline localhost WebUI. Does NOT authorize real platform requests/account login/crawler runs, Cookie use, cost or global installs.

## REVIEWER_TO_EXECUTOR_RELAY
Owner 已自愿释放内存，报告目前可用约 1.7 GiB，并要求重新尝试原版 MediaCrawler 本机安装。请读取 `entropy-student/project` 最新 main：`mediacrawler-local-lab/G1S_RECOVERED_RAM_ONE_SHOT_GATE.md`，仅按 G1S 执行；原 G1R 已 RETURN、G1M 暂缓。先在约 30–45 秒内取得至少 3 次可比的 Windows 可用 RAM 读数，**每次都 >=1.5 GiB 且无持续大幅下降**，否则不下载、不安装直接返回。达标后允许一次性按 Gate 准备项目内官方校验的 uv 0.12.20 + Python3.11，固定源码、锁定依赖、保留原版七平台 WebUI，隔离浏览器并只用假数据测试本地网页。每个重负载阶段重新测内存；不关闭其他程序、不碰 Docker/Clash/VPN/现有 Edge，也不扫码、输入 Cookie 或真实采集。一次尝试，遇压力就安全停止，留下去敏证据和实际网页地址（如成功），`STOP_AT_REVIEWER=YES`。

## EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE / PARTIAL_BROWSER_PENDING / RETURN_*。
改动：仅项目内新文件或 NONE。
验证：3+ RAM 样本、分段内存、锁定源码/完整原版 WebUI/API/离线导出或精确受阻阶段。
问题：NONE 或实际资源/环境阻塞。
回滚：仅项目自有进程的停止与文件保留。
请 Reviewer 检查：前端能否使用、是否适合下一轮真实小样本采集。
Owner 转交：NONE。
