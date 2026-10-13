# BettaFish Local Lab — REVIEWER_HANDOFF
> Updated: 2026-10-13
> Governance: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7 ACTIVE_PROVISIONAL
> Canonical project: entropy-student/project main:bettafish-local-lab/
> Execution channel: Owner physical Windows 11 local Codex; Reviewer owns governance and canonical GitHub evidence.
> STOP_AT_REVIEWER: YES

## PROJECT_GOAL
保留 BettaFish 项目，在 Owner Windows 11 本机优先完成 **BettaFish 内嵌 MediaCrawler 关键词采集 → JSON/CSV 可导出 → 已有 Codex 分析** 的轻量实验。完整 BettaFish Flask+PostgreSQL+三套 Streamlit+Forum/Report 引擎暂缓，非必需；不切换独立新项目。第一阶段只做源码与模拟数据离线链路，之后经单独评审才会做真实平台采集。

## PROJECT_STAGE
Scope refinement accepted by Owner on 2026-10-13; G1L isolated crawler-export offline Gate READY. No BettaFish deploy, no real crawler/profile/account use yet. G0 returned local checkout missing (not blocker); G0R returned insufficient memory for conservative full Compose. Owner manually released some RAM; 3.1/3.6 GB later informal samples not G0M-validated; do not misreport as formal resource PASS.

## SYSTEM_MAP
- Target: Owner HP OEM Windows 11 Home Chinese 26300; PowerShell 7.6.5, user-local Codex. G0/G0R data is OWNER_REPORTED. ChatGPT desktop/Codex may be interdependent; don't kill them or Edge.
- Docker Desktop Engine 4.88.1 / Compose 5.4.0 reported; full engine visible total capacity 7.40 GiB (not free). Host total 15.28 GiB. G0R host free at sample 1.78 GiB; later UI readings reportedly ~3.1–3.6 GB (different unit/source/time, unverified). Official BettaFish README "运行环境要求" says **"内存: 建议2GB以上"**, an environment/total-machine recommendation with no specified 4 GiB free-memory floor. Reviewer previously applied ~4 GiB *currently free* only as extra conservative full multi-service Compose safety buffer; this is **not official minimum and should not block lightweight/offline G1L**. If full Compose is later selected, reassess live headroom and apply staged resource monitoring rather than treating 4 GiB as hard vendor threshold. Offline G1L no Docker needed.
- Source BettaFish exact root `b67928ff1ce515dd7672408221fb1e9500d0972d`; `.gitmodules` nested MediaCrawler at `MindSpider/DeepSentimentCrawling/MediaCrawler`, Git tree `4de2a325a9cd4f7de7dfb58204b154fc2bb86e40`. Reviewer directly verified repository Git tree and pinned code.
- BettaFish MindSpider wrapper: deep crawl requires DB topics/keywords; overrides pinned crawler save to postgres/db, writes DB config that can include plaintext credentials. For lightweight export, **do not invoke wrapper unchanged**.
- Pinned MediaCrawler CLI has `--platform xhs`, `--type search`, native save JSON/CSV/Excel. **Pinned release does not support JSONL** (moving main might). Pinned XHS export fields include note_id, note_url, source_keyword, comment_id, comment.note_id, content.
- Pinned MediaCrawler defaults CDP=True, save login state=True, can use current Chrome/Edge profile. Future separate login/crawl Gate must isolate browser session and have safe-mode; no automatic use of user's Edge profile or credentials.
- NON-COMMERCIAL LEARNING LICENSE 1.1 on pinned submodule; learning/research only, no unapproved commercial use.
- Earlier official Compose GHCR latest+Postgres 15, ports 5000/8501–8503/5444, binds .env/data/report; full app path now deferred. Don't pull/build/start or publish ports under G1L.
- Isolated source-only staging and tiny synthetic JSON under new `%LOCALAPPDATA%\BettaFishLocalLab\crawler-lite-smoke-v1` after target/path collision and resource checks; local management repo Git checkout unnecessary. No credentials/model/platform use.

## CURRENT_ACCEPTED_STATE
Reviewer direct GitHub read-back: exact root and gitlink SHAs; pinned file exporter and XHS schema, risks. Earlier G0/G0R target evidence from Owner only, see append-only Evidence. No Owner-local source checkout or synthetic artifact exists yet by reviewed proof.

## CURRENT_GATE
`BTFL-G1L-ISOLATED-CRAWLER-EXPORT-OFFLINE-20261013` stored at `G1L_ISOLATED_CRAWLER_EXPORT_OFFLINE_GATE.md`. Supersedes conditional G0M as **current Gate only**; G0M remains deferred full Compose resource check and is not deleted.

## CRITICAL_CONSTRAINTS
- Only Owner physical local Windows Codex; no VPS/Grok Bot/remote/sandbox claim; project-owned additive path only.
- No package/uv/pip/browser/Playwright install; no crawler/Chrome/Edge/CDP/app/DB/docker run; no live social request, model/paid API, platform login or credentials; no existing browser profile/cookies.
- No edits to system, Docker, WSL, VPN, Clash, HY2/WG, firewall, network routes/proxies, machine-global config or unrelated apps; no process kill. No Secrets in chat/repo/logs or test fixtures; synthetic fabricated content only.
- Strict root and submodule commit pin; separate source-retrieval vs future dependency/real crawler execution boundaries. No global cleanup or directory overwrite.
- Future real crawler requires controlled tiny Canary, explicit Owner platform authorization, session profile privacy and platform compliance; commercial license clearance independent.

## DEFAULT_EXECUTION_CHANNEL
Owner local Windows 11 Codex executor; Reviewer writes GitHub docs. No local Git checkout of management repo required.

## CURRENT_ROLLBACK_STATUS
G0/G0R no runtime writes. G1L only new owned isolated source/fixture directory; known empty path required before starting. No deletion without bounded review if partial conflict.

## UNRESOLVED
Real-packet crawl and platform login/auth/rate limits, isolated browser profile safety, actual runtime dependency footprint, output fields for real scraped pages, account/data sensitivity and retention, commercial license, safe report dataset contract. Full Compose resources remain deferred.

## NEXT_STEP
Owner forwards G1L Gate to Codex. Codex verifies locked source and submodule, runs **synthetic-only offline JSON schema check** without package install or real crawler; relay evidence. Reviewer then decides next minimal install/real-data smoke Gate, based on proof and safety.

## OWNER_ACTION_REQUIRED
Copy approved G1L relay into existing local Codex. Do not close ChatGPT/Edge/Codex, do not login or change any settings. Paste compact result to Reviewer.

## EVIDENCE_POINTERS
- `EXECUTION_EVIDENCE.md`: historical G0/G0R relays plus Reviewer pinned-source read-back (DIRECT_READBACK only for GitHub upstream).
- `DECISION_LOG.md`: scope refinement toward embedded crawler and Codex.
- `G1L_ISOLATED_CRAWLER_EXPORT_OFFLINE_GATE.md`: active Gate.
- `G0M_MEMORY_RECHECK_GATE.md`: deferred full-Compose resource check, not active.
