# BettaFish G2 — Project-Local Runtime + Native JSON Writer Synthetic Smoke
> GATE_ID: BTFL-G2-ISOLATED-RUNTIME-EXPORT-SMOKE-20261013
> STATUS: READY_FOR_EXECUTOR
> MAX_ENDPOINT_THIS_ROUND: isolated pinned MediaCrawler dependency install into a project-owned virtual environment + invocation of its real JSON writer with entirely synthetic records + optional CLI --help; NO real crawler/browser/platform
> MANDATORY_REVIEW_STOP: YES

## OBJECTIVE
既然源码与 JSON 数据结构已经离线证明可行，本轮实际调用 BettaFish **锁定子模块中的原版 JSON writer**，检验无需 PostgreSQL 就能落盘两类独立笔记/评论 JSON，并准备只属于当前项目的 Python 环境。修复 G1L 的“只模拟 JSON，不真正调用原写入器”的验证缺口。绝不自动进入小红书采集、扫码登录或启动 BettaFish 全栈。

## TARGET_AND_SCOPE
- Owner physical Windows 11 local Codex and prior exact checkout `%LOCALAPPDATA%\BettaFishLocalLab\crawler-lite-smoke-v1`.
- Approved immutable root Git SHA `b67928ff1ce515dd7672408221fb1e9500d0972d`; nested `MindSpider/DeepSentimentCrawling/MediaCrawler` at `4de2a325a9cd4f7de7dfb58204b154fc2bb86e40`. Do not fetch/checkout/upgrade either again if unchanged.
- Allowed project-new writes: `offline-smoke\g2-runtime-v1\` (runtime interpreter/venv, uv cache, generated test code, outputs) only. This child MUST NOT already exist or contain unknown content. Use exact resolved path under intended LOCALAPPDATA owner project; recheck path virtualization/collision, source SHA, `git status --porcelain` for root and submodule before write.
- No writes outside project-owned directory; avoid creating tracked source changes and avoid browsing real data files. If an installer requires global/site-packages or external cache write beyond scoped temp/caches, fail closed.
- No local Git checkout of the management repo, no GitHub mutation by Executor. Reviewer handles durable evidence.

## APPLICABLE_CRITICAL_CONSTRAINTS
Governance v0.2.7 §§0–10 and triggered 11A–11D interpreted by Reviewer. Executor reads only this Gate plus exact files as needed, NOT entire Governance/project history.
- **NO** Docker start/pull, BettaFish app/MindSpider wrapper, real crawler `main.py` search/detail execution, account/platform access, CDP/browser/Playwright driver installation, Chromium download, browser launching, user Edge/Chrome profiles/cookies, login, private .env/Secret or environment credential values, model/API calls, payments.
- No installing uv/Python/Node/system packages or changing user-wide/global Python, Git, uv, pip, Docker, WSL, Windows, VPN/Clash/HY2/WG, proxy/routing/firewall. No admin elevation. Existing trusted Python 3.11+ and uv required; if absent RETURN precise `RETURN_RUNTIME_TOOL_MISSING` with sanitized program/version only. Do not auto-download Python or uv. uv may download **pinned lockfile Python wheels/dependencies** into explicitly scoped local cache; these are third-party package downloads, NOT model/browser downloads. Check expected package footprint/lock/reproducibility.
- NEVER terminate Edge/ChatGPT/Codex/Clash/Docker processes. If low memory, stop only own G2 child installer/test processes and RETURN. Never claim a 4 GiB available RAM floor as official/minimum; this Gate uses its own risk stop criteria.
- No raw stdout/stderr traceback dumps if they might include credentials/host IDs; sanitize in process before relay.

## PREFLIGHT
1. Read G2 Gate. Confirm real Owner Windows 11 host using same sanitized mechanism G1L (not process command lines). Prove expected source checkout exact path, root and submodule git SHA, non-dirty tracked source, and G1L synthetic artifacts still parse and their SHA256 are unchanged (contents synthetic only). If any mismatch or unowned/new child exists, RETURN before writing.
2. Check `uv --version`, `python --version` / `py -3.11` (no installing); pinned pyproject `requires-python>=3.11` and existing `uv.lock` exact. No dependency preparation if Python 3.11+ interpreter unavailable or uv absent; RETURN. Do not print user paths.
3. Host RAM available >=2.0 GiB for **attempting isolated dependency installation only** (not upstream minimum). Drive available >=6 GiB; no high CPU/memory-pressure warning. If lower, RETURN_RESOURCE_HEADROOM_INSUFFICIENT. Check current resource before installing; G1L last 2.65 GiB is not live truth. Prepare to monitor during install at bounded intervals; prefer one normal trial, no blind retries.
4. Check by source inspection that import of `tools.async_file_writer.AsyncFileWriter` and optional CLI `--help` have no known network/browser/profile side effects; if uncertain, SKIP CLI help, run only safe synthetic writer once verified. `config.ENABLE_GET_WORDCLOUD=False` in isolated run. No platform action.

## EXECUTION
A. After preflight, create `offline-smoke\g2-runtime-v1\` as new project-owned child. Use `UV_PROJECT_ENVIRONMENT`, `UV_CACHE_DIR`, and temp/cache controls limited to this child; `UV_PYTHON_DOWNLOADS=never`, `UV_LINK_MODE=copy`, `UV_CONCURRENT_DOWNLOADS=1`, `UV_CONCURRENT_BUILDS=1`. Run `uv sync --locked --no-dev` in pinned MediaCrawler submodule, preserving exact root and gitlink and lockfile. Do not modify source/tracked files, system env or existing local caches; no pip/global installer fallback or source version changes. If upstream metadata requires unexpected indexes or non-package downloads, halt and RETURN with stage reason.
B. During installation, ensure only own subprocesses can be interrupted on low RAM (e.g. available <1.0 GiB), growing owned disk >3 GiB, heavy unexpected swap/resource pressure or sustained high system load. Do not suspend/kill anything else. One bounded attempt; on failure record stage, no blind retry/cleanup.
C. If installation succeeds and resource checks permit, launch **only the package interpreter** for safe synthetic exporter smoke, not `MediaCrawler/main.py` crawling. Set CWD to a newly created `g2-runtime-v1\synthetic-export\`; import pinned `AsyncFileWriter` from source root via scoped PYTHONPATH within this child (no global edits); instantiate with platform `xhs`, crawler_type `search`. Call async `write_single_item_to_json` for two fully fictional note-shaped dicts (`item_type="contents"`) and 1–2 fully fictional comment-shaped dicts (`item_type="comments"`), using `note_id` relationships and dummy fields. Source's writer should create `data/xhs/json/search_contents_<date>.json` and `search_comments_<date>.json` in owned CWD. Ensure no personal info, real link, xsec_token, account value. Verify read-back JSON arrays, counts, note-comment join, source keywords, encoding, file SHA256. Do not copy/paste any real content.
D. Optional only after import side-effect preflight: run the pinned CLI `--help` with no crawler execution, check flags for platform/search/keywords/save_data_option, and capture only sanitized flag names/native exit status. No browser/net request. If help may do import-side network/profile work, mark `SKIPPED_SAFETY` and do not let it block JSON writer proof.
E. Report key extra risk that pinned `media_platform/xhs/core.py` `search()` sets `xhs_limit_count=20`, and forces count below 20 to 20, so configuring 1 note is NOT sufficient. **Read-only** inspect entrypoints to propose smallest guard for future G3 (before more than one detail retrieval/write, max one comment, one keyword, single page, bounded rate/timeout, isolated browser). Do NOT edit code for this guard in G2.
F. Collect bounded before/after RAM GiB and owned folder delta MiB, venv/cache size, native installer/writer exit code, exact G1L+G2 synthetic artifact name/size/hash and all new tracked/untracked changes. Confirm no non-G2 mutation; prior G1L fixture preserved. Do not cleanup any files or rewrite original tracked code.

## REQUIRED_EVIDENCE
`GATE_ID`, `TARGET_LOCAL_PROOF`, `SOURCE_ROOT_SHA`, `SOURCE_SUBMODULE_SHA`, `PYTHON_VERSION`, `UV_VERSION`, `UV_LOCK_STATUS`, `INSTALL_STATUS_EXIT`, `PROJECT_NEW_WRITES`, `EXPORTER_CALL`, `EXPORTER_EXIT`, `ACTUAL_JSON_FILES`, `SYNTHETIC_NOTE_COUNT`, `SYNTHETIC_COMMENT_COUNT`, `JOIN_MATCHES`, `JSON_SHA256`, `CLI_HELP_STATUS`, `RESOURCE_RAM_PRE_POST_MIN_GiB`, `PROJECT_DISK_DELTA_MiB`, `SOURCE_GIT_STATUS`, `ONE_NOTE_CRAWL_GUARD_FINDING`, `NETWORK_BROWSER_SECRET_ACTIONS=NONE`, `ANOMALIES`, `RESULT`, `STOP_AT_REVIEWER=YES`.
If test generated only fake small JSON, include at most a compact **literal subset of 1 synthetic note + 1 synthetic comment** (without PII/URLs/xsec fields) in reply so Reviewer can inspect contract; hashes alone are not file-byte read-back. Avoid raw CLI output/logging.

## ACCEPTANCE_CRITERIA
`PASS_CANDIDATE` only if package install is isolated and dependency-lock verified, exact source unchanged, native exporter actually invoked without browser/network, two generated JSON arrays parsed and joined correctly, local resources remain tolerable, and scope respected. If prerequisites unavailable return `RETURN_RUNTIME_TOOL_MISSING` or `RETURN_RESOURCE_HEADROOM_INSUFFICIENT`, no fallback. If writer import side effects uncertain, RETURN `RETURN_EXPORTER_IMPORT_SAFETY_UNRESOLVED`; don't run risky imports. None of these checks proves real platform access, legitimate access authority, or 1-note hard limit. No G3 without Reviewer and Owner authorizing real account/platform actions.

## ROLLBACK_STATUS_OR_PLAN
Only additive project-owned `g2-runtime-v1\` work. If error/ambiguity leave exact new owned paths intact and report; Reviewer later can authorize allowlisted removal after proof. No global changes or migration. Safe stop self-owned installer child only on resource pressure.

## OWNER_ONLY_ACTIONS
Owner does not need to close apps or provide platform login/credentials now. Login, profile/session/cookie custody, first real XHS access and any commercial use require separate Owner authorization and independent Gate. No social media browsing or platform scans under G2.

## REVIEWER_TO_EXECUTOR_RELAY
你是 Owner Windows 11 本机 Codex Executor。执行 `entropy-student/project` 最新 main 的 `bettafish-local-lab/G2_ISOLATED_RUNTIME_EXPORT_SMOKE_GATE.md`。G1L 已在 `%LOCALAPPDATA%\BettaFishLocalLab\crawler-lite-smoke-v1` 留下锁定的 BettaFish 源码和模拟数据。先核对本机位置、SHA、项目目录状态和内存。仅在已有 Python3.11+/uv 工具且资源允许的情况下，将 pinned MediaCrawler 所需 Python 包安装到新建、仅当前项目使用的虚拟环境与本地缓存，然后**直接调用原项目 AsyncFileWriter 对完全模拟笔记/评论写 JSON，并复核字段/数量/关联**。可做零真实采集的 CLI --help 检查，但不运行 crawler/main.py 搜索。不要改源码，别碰真实 Edge、ChatGPT、Codex、浏览器 Cookie、平台登录、Docker、Clash/VPN；不下载浏览器或模型。特别检查小红书源码默认最低20条的陷阱，只报告后续如何实现严格1条限制，不要实际爬取。返回脱敏结果和一小段纯模拟 JSON，`STOP_AT_REVIEWER=YES`，不得进入真实采集。

## EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE / RETURN_*。
改动：仅隔离项目子目录内 venv/cache/模拟 JSON，或说明失败阶段。
验证：source Git SHAs、实际 JSON 写入器调用、笔记评论关联、Python/uv/资源数值。
问题：NONE 或可复核具体阻塞。
回滚：仅新增子目录，保持已有数据不动，记录可清理范围。
请 Reviewer 检查：是否可在未来经 Owner 授权后进入严格限量 XHS 真实 Canary。
Owner 转交：NONE；本轮不需要扫码/密钥。
