# BettaFish G1L — Isolated Embedded Collector and Export Offline Smoke
> GATE_ID: BTFL-G1L-ISOLATED-CRAWLER-EXPORT-OFFLINE-20261013
> STATUS: READY_FOR_EXECUTOR
> MAX_ENDPOINT_THIS_ROUND: Isolated, commit-pinned source checkout + source-derived, synthetic JSON-export/Codex-readability verification; no real crawl or environment/dependency install
> MANDATORY_REVIEW_STOP: YES

## OBJECTIVE
在不打断 Owner Edge、ChatGPT、Codex、Docker 或 VPN 的条件下，验证 BettaFish 自带 MediaCrawler 子模块的**独立关键词采集入口与笔记/评论 JSON 导出链路**在源码上是否成立，并用完全模拟的少量笔记/评论完成 JSON 数据契约 → Python/PowerShell 读取统计试验。**不将模拟验收冒充真实采集验收。**

## TARGET_AND_SCOPE
- Owner 物理 Windows 11 上本地 Codex（非 VPS、Grok Bot、WSL/云代理）。
- Canonical project docs: `entropy-student/project` main `bettafish-local-lab/`. No local checkout of canonical management repo required.
- Source root: `https://github.com/666ghj/BettaFish`, exact commit `b67928ff1ce515dd7672408221fb1e9500d0972d`.
- Scoped submodule: `MindSpider/DeepSentimentCrawling/MediaCrawler`, exact gitlink SHA `4de2a325a9cd4f7de7dfb58204b154fc2bb86e40` from above root's Git tree. **Do not substitute upstream MediaCrawler main or other version**.
- ONLY approved local write area: brand-new non-existing `Join-Path $env:LOCALAPPDATA 'BettaFishLocalLab\crawler-lite-smoke-v1'`, contained under current Owner user context. If nonempty/existing or cannot prove owner-local host target, stop with `RETURN_TARGET_PATH_COLLISION` or `RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE`. Do NOT clean, overwrite, move or delete unknown files.
- Allow public GitHub HTTPS `git clone/checkout` only for pinned BettaFish source and its single pinned submodule, using noninteractive Git; no repo management checkout. No GitHub issue/PR/write. Network calls to social sites/authenticated services forbidden.
- Source tree is read-only once staged; create fixture and smoke output only in project-owned `offline-smoke\` child. Do not edit tracked upstream files or .gitmodules.

## APPLICABLE_CRITICAL_CONSTRAINTS
Reviewer has read v0.2.7 Governance §§0–10, 11A–11D, 12–13. Executor reads ONLY this Gate/relay and named source files; no full Governance reread, no historical excavation.
- NO `docker compose`, image pull/build/run, installs (`uv sync`, `pip install`, `playwright install`, Node/npm), elevation, global Python/uv/Git config mutation, machine cache cleanup, Windows services changes, WSL/Docker daemon settings, VPN/Clash/HY2/WireGuard/proxy/firewall/routing changes, process termination, account login, cookie inspection, platform access, AI API/model calls, paid actions, download of browser binaries.
- No real user, platform, account, personal data or Secret files/environment values read or displayed. Don't open/copy authentic .env, local Edge/Chrome/CDP profile, user cookies, or existing browser debugging endpoints. No importing third-party crawler modules or executing its `main.py` this round; source inspection only.
- No uncontrolled whole-disk scans or raw process listings. Sanitized environment and per-project output.
- Safe source retrieval needs sufficient free disk and no memory pressure; if local preflight reports inadequate headroom (e.g., <2 GiB available host RAM, conservative lightweight source staging threshold), return `RETURN_RESOURCE_HEADROOM_INSUFFICIENT`; DO NOT claim this is a universal crawler minimum.
- If Git/provenance/network to GitHub unavailable, RETURN precisely; do not use a different mirror/archive/latest fallback.

## PREFLIGHT / EXECUTION
1. Confirm same Owner physical Windows target with bounded sanitized proof; check PowerShell/native command and Git availability, host available RAM (GiB), target drive free GiB. No process termination. If context/resource/target path collision invalid, RETURN before writes.
2. Reproducibly obtain BettaFish exact root commit in the new isolated path and initialize **only** the MediaCrawler submodule at the root gitlink SHA. Verify `git rev-parse HEAD`, `git -C MindSpider/DeepSentimentCrawling/MediaCrawler rev-parse HEAD`, and exact path; record sha/version only. No package installation/execution.
3. Inspect `MindSpider/main.py`, `MindSpider/DeepSentimentCrawling/main.py`, `MindSpider/DeepSentimentCrawling/platform_crawler.py` and submodule `cmd_arg/arg.py`, `config/base_config.py`, `tools/async_file_writer.py`, `store/xhs/__init__.py`, `LICENSE`. Classify: independent CLI possible? user keyword entry? note/comment field schema? file export option? mandatory DB? effects on tracked configs? CDP/browser risks? future login requirements? Native `json`/csv supported; do NOT claim pinned JSONL support without source proof.
4. Under `offline-smoke\` only, create at most three small synthetic files (e.g. source-shaped `notes.json`, `comments.json`, `summary.json`) using stdlib Python available on system or PowerShell built-in ConvertTo/From-Json. Use fabricated IDs, keywords and text; no real URLs/cookies/xsec tokens/PII/Secret. Use source-derived note/comment field names. Read back and validate record counts, note-comment join by `note_id`, keyword and timestamp fields when present. This only verifies data shape for future Codex analysis; label `SYNTHETIC_OFFLINE_ONLY`.
5. Document exact future *minimal* crawler + JSON export run path and blockers; real-world success remains UNKNOWN. Do not trigger it. Capture bounded git refs, path category, artifact names/file sizes and SHA-256 for synthetic outputs; no full real path, username or host identifier in chat.
6. Recheck only project-owned footprint and host RAM; if resource anomaly, halt, leave exact owned state and return. No automatic cleanup of workspace unless separate Owner instruction.

## REQUIRED_EVIDENCE
Reply concise sanitized fields:
`GATE_ID`, `TARGET_LOCAL_PROOF`, `ROOT_SHA`, `SUBMODULE_SHA`, `HOST_AVAILABLE_RAM_GiB_PRE_POST`, `PROJECT_DISK_DELTA_MiB`, `EXPORT_FORMATS_PINNED`, `INDEPENDENT_CLI_PATH`, `DATA_SCHEMA`, `SIMULATED_NOTE_COUNT`, `SIMULATED_COMMENT_COUNT`, `SIMULATED_JOIN_MATCHES`, `SYNTHETIC_ARTIFACT_SHA256`, `RISK_CDP_SECRET_LICENSE`, `ACTUAL_CHANGES`, `ANOMALIES`, `RESULT`, `STOP_AT_REVIEWER=YES`.
Provenance: target values are `OWNER_REPORTED` upon Owner relay; Reviewer can separately read back GitHub source. No write to canonical GitHub by Executor. Detail in chat is bounded, never real customer data.

## ACCEPTANCE_CRITERIA
`PASS_CANDIDATE` requires pinned root/submodule SHA verified, independent CLI/file exporter source contract assessed, synthetic JSON note/comment parse and key matching works, no access to browser/platform/model/Secret, no unrelated or global changes, acceptable resource delta. If independent clean JSON export cannot be established, return precise `RETURN_EXPORT_PATH_BLOCKED`, explaining exact dependency, not a pass. A `PASS_CANDIDATE` proves only **offline feasibility**, NOT actual XHS crawling or export from live data.

## ROLLBACK_STATUS_OR_PLAN
Project-owned workspace and test fixtures are new and identified. No user data/secret migration and no running services. On error leave exact owned path unchanged and report state for Reviewer; do not delete/overwrite unknown target. A future explicit owner/reviewer Gate can remove only proven new project-created files. No other rollback needed if only additive own files.

## OWNER_ONLY_ACTIONS
None this round beyond forwarding prompt. Real platform login/QR/credential/cookie, access rights, paid API, browser profile, and commercial purpose remain Owner-only future actions; no implicit authorizations.

## REVIEWER_TO_EXECUTOR_RELAY
你是 Owner Windows 11 本地 Codex Executor，开始 BettaFish G1L：只读取 `entropy-student/project` 最新 main 的 `bettafish-local-lab/G1L_ISOLATED_CRAWLER_EXPORT_OFFLINE_GATE.md` 并执行。项目不换：只审查/隔离准备 BettaFish 固定 commit `b67928ff1ce515dd7672408221fb1e9500d0972d` 的 MediaCrawler 固定子模块 `4de2a325a9cd4f7de7dfb58204b154fc2bb86e40`，只在全新项目拥有的 LOCALAPPDATA 子目录落源码和模拟数据。确认原版支持 xhs 关键词采集 CLI 和 JSON/CSV 文件导出，使用少量全假数据验证笔记/评论 JSON 可被 Codex/Python 读入、按 note_id 关联，并列明未来最小真实采集的前提。不得安装依赖、运行爬虫/浏览器/数据库、扫码、读取 Cookie/Secret、拉 Docker 镜像、动 VPN、关 ChatGPT/Codex/Edge。不得将新 MediaCrawler main 冒充 pinned 子模块；如无法安全准备源码就 RETURN，不得绕过。向 Reviewer 返回去敏字段和真实/模拟验收界限；`STOP_AT_REVIEWER=YES`。

## EXECUTOR_TO_REVIEWER_RELAY
结果：PASS_CANDIDATE / RETURN_*。
改动：仅新建独立项目源码目录和模拟 JSON 文件，或说明实际未改。
验证：BettaFish/submodule SHA；CLI/JSON 源码结论；模拟笔记/评论数量及匹配；资源变化。
问题：NONE 或具体阻塞。
回滚：已识别新增目录及是否存在待人工处理的部分状态。
请 Reviewer 检查：是否准许下一轮单平台、最小真实采集 Canaries。
Owner 转交：NONE；本轮禁止平台登录。
