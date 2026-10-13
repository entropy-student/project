# BettaFish Local Lab — REVIEWER_HANDOFF
> Updated: 2026-10-13
> Governance: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7 ACTIVE_PROVISIONAL
> Canonical project: entropy-student/project main:bettafish-local-lab/
> Execution channel: Owner Windows 11 local Codex; Reviewer owns governance/GitHub evidence.
> STOP_AT_REVIEWER: YES

## PROJECT_GOAL
Owner Windows 11 本机保留 BettaFish，轻量实施「关键词 → BettaFish 内嵌 MediaCrawler 采集笔记/评论 → JSON/CSV 文件 → Codex 自行分析」。无需完整 BettaFish 多 Agent、Streamlit 或 PostgreSQL；只在有真实必要时恢复完整系统方案。默认科研/学习测试，不授权商业使用。

## PROJECT_STAGE
G1L offline code+fixture: Executor `PASS_CANDIDATE`; Reviewer `PARTIAL` (source contract independently verified, local synthetic files only OWNER_REPORTED); appropriate to begin low-risk **G2 isolated dependency/actual synthetic writer smoke**. No crawler/browser/real platform interaction yet, no Docker/BettaFish app running.

## SYSTEM_MAP
- Owner target: reported physical HP OEM Windows 11 Home build 26300, PowerShell 7.6.5, local Codex. Desktop ChatGPT/Codex and Edge must remain running; do not stop. Owner's console/RDP marker unavailable, runtime details still OWNER_REPORTED.
- Host RAM total reported 15.28 GiB. G1L pre 4.12 GiB free; post 2.65 GiB; during min 2.27 GiB, fluctuation cause UNKNOWN. Docker Engine visible total 7.40 GiB but full Compose deferred. Official BettaFish README recommends **2GB+ machine RAM**; Reviewer 4 GiB currently-free full-Compose buffer was not official and is NOT a universal blocker. G2 bounded per-stage live memory monitoring; no owner closing apps.
- G1L Codex reported isolated checkout `%LOCALAPPDATA%\BettaFishLocalLab\crawler-lite-smoke-v1`, exact root SHA `b67928ff1ce515dd7672408221fb1e9500d0972d`, nested `MindSpider/DeepSentimentCrawling/MediaCrawler` SHA `4de2a325a9cd4f7de7dfb58204b154fc2bb86e40`, source clean. ~383.96 MiB owned directory, ~411.49 MiB volume change, ~204.68 GiB target drive available. Only synthetic 3 notes/4 comments.
- Reviewer direct upstream readback: pinned MediaCrawler has standalone CLI in `main.py`, `cmd_arg/arg.py`: `--platform xhs --type search --keywords ... --get_comment ... --save_data_option json`; JSON and CSV (+ Excel) native; JSONL not in pinned. Native `tools/async_file_writer.py` saves JSON arrays, pinned `store/xhs/__init__.py` note/comment fields link by `note_id`.
- BettaFish MindSpider wrapper uses DB keyword tables and forces postgres/db save and generates DB config, therefore do NOT invoke wrapper for lightweight path. Pinned MediaCrawler standalone CLI is preferred; this is still BettaFish's exact embedded version (not replacement project).
- **Important real-crawl blocker:** XHS `media_platform/xhs/core.py` `search()` forces minimum `CRAWLER_MAX_NOTES_COUNT` of **20**, so simply setting 1 does NOT bound first real experiment. Future single-note/one-comment canary requires verified in-code hard guard BEFORE outgoing detail requests / data writes; do not assume config implies bounded behavior. Reviewer has independently inspected code.
- Pinned `config/base_config.py` defaults CDP=true/SAVE_LOGIN_STATE=true; can touch active Edge/Chrome profile and Cookie. No browser/session interaction allowed in G2. Raw `xsec_token` appears in xhs URLs and logs; never relay actual scraped raw link/tokens/PII. NON-COMMERCIAL LEARNING LICENSE 1.1; real usage requires terms review.
- Existing Docker, VPN/Clash/WG/HY2, Edge/ChatGPT/Codex, other active environments always protected. No public ingress, platform login, paid API, crawler requests at this stage.
- G2 isolated venv/cache/test-owned outputs should be inside `offline-smoke\g2-...`; staged locked source checkout tracked files unchanged, no global package installation, browser binaries install, or Docker.

## CURRENT_ACCEPTED_STATE
- Reviewer direct GitHub proof supports source SHA/gitlink/CLI/config and 20-note crawler minimum. Owner relay supports G1L checkout, static synthetic export readability, and no unrelated changes; no independent Reviewer access to local synthetic bytes. G1L remains `PARTIAL` evidence, not formal PASS; won't be presented as completed real crawl.
- Files/read-back GitHub documentation persisted by Reviewer; Executor need not git checkout project management repo.

## CURRENT_GATE
`BTFL-G2-ISOLATED-RUNTIME-EXPORT-SMOKE-20261013` at `G2_ISOLATED_RUNTIME_EXPORT_SMOKE_GATE.md`. Previous G1L is completed as partial/claimed; G0M is deferred only for optional future full Compose, not active.

## CRITICAL_CONSTRAINTS
- Windows physical Owner-local only. Native exit/status checks. Respect previous source exact SHAs and known isolated location; no cloning again if unchanged.
- G2 may create only project-owned venv/cache and synthetic export test files in predefined fresh child. No global installer or package changes; no browser binary installation. No child process allowed to access XHS or other social platforms, start CDP, read Edge/Chrome sessions/cookies/.env, or run real crawler.
- No provider/API/model/paid calls, no commercial crawl, no accounts/platform logins, no Cookie/Secret in chat/command/env/logs/GitHub.
- No system-wide/global Docker/WSL/VPN/Clash/HY2/WG/routing/firewall/proxy changes, no killing user processes; never stop ChatGPT/Codex/Edge. Own install/test processes may be stopped on resource guard trigger.
- Real canary must use audited hard count guard because XHS minimum 20; explicit Owner authorizations for platform access/login/profile and provider costs remain outstanding.
- Source and synthetic data are non-secret. If project checkout shows prior partial/unowned or drift state, return; no override or automatic deletion. GitHub Reviewer owns Evidence and Gate.

## DEFAULT_EXECUTION_CHANNEL
Owner Windows 11 Codex. Reviewer stores GitHub records.

## CURRENT_ROLLBACK_STATUS
Earlier G1L additive isolated source+synthetic files, reported clean, retained. G2 additive child-only venv/cache/fixture outputs, no irreversible/external actions; failures leave owned state documented, no arbitrary cleanup or overwrite.

## UNRESOLVED
G1L synthetic file Reviewer direct read-back; local Python/uv availability; success and footprint of dependencies; safe actual exporter invocation; XHS one-note exact cap; isolated browser/profile/session; actual data fidelity, platform limits/license, safe provenance of user data; future commercial path.

## NEXT_STEP
Owner sends G2 relay. Codex in same isolated workspace sets up only project-local runtime dependencies if already-present trusted Python/uv support exists, then invokes pinned `AsyncFileWriter` directly using invented note/comment records with project-scoped output. Runs CLI `--help` only after proving import safe/no platform side effects, records bounded evidence; no browser/crawler/login. Reviewer evaluates before real platform Gate.

## OWNER_ACTION_REQUIRED
Paste G2 Gate relay to existing Codex. Do not close apps or log into XHS; later real crawler needs fresh explicit consent.

## EVIDENCE_POINTERS
- `EXECUTION_EVIDENCE.md`: append-only G1L Codex data and independent source findings.
- `DECISION_LOG.md`: lightweight project decisions and XHS 20-note limitation.
- `G2_ISOLATED_RUNTIME_EXPORT_SMOKE_GATE.md`: active next Gate.
- `G1L_ISOLATED_CRAWLER_EXPORT_OFFLINE_GATE.md`: old G1L Gate (not replayed).
- `G0M_MEMORY_RECHECK_GATE.md`: deferred full Compose RAM Gate (inactive).
