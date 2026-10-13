# BettaFish Local Lab — REVIEWER_HANDOFF
> Updated: 2026-10-13
> Governance: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7 ACTIVE_PROVISIONAL
> Canonical project: entropy-student/project main:bettafish-local-lab/
> Execution channel: Owner's Windows 11 local Codex; Reviewer owns Governance and canonical GitHub evidence
> STOP_AT_REVIEWER: YES

## PROJECT_GOAL
Owner 本地 Windows 11 独立部署开源 BettaFish（微舆），仅经 localhost 访问，先验证 UI、PostgreSQL、持久化及启动条件；真实小红书/其他社媒采集、平台登录、付费模型 API 与商业使用不属于初始 Docker 验证授权。不得影响既有 VPN/网络/其他项目。

## PROJECT_STAGE
RESOURCE_HOLD_AFTER_G0R. NO BettaFish deployment yet. G0 returned `RETURN_NO_SAFE_CHECKOUT` (documentation workflow); reviewer removed this dependency. G0R returned `RETURN_RESOURCE_HEADROOM_INSUFFICIENT` (actual resource blocker).

## SYSTEM_MAP
- Target physical PC (OWNER_REPORTED through Codex): HP OEM portable Windows 11 Home Chinese build 26300; PowerShell 7.6.5, non-admin; Codex process ancestry reported and SSH/WSL markers absent. Console/RDP markers UNKNOWN, not a basis to claim independently verified physical access.
- Docker Desktop Engine 4.88.1 / Compose 5.4.0 usable (G0 OWNER_REPORTED). Docker Engine total visible capacity 7.40 GiB, code 0 (G0R OWNER_REPORTED). This is capacity, **not unused memory**.
- RAM (G0R OWNER_REPORTED, 2026-10-13): host total 15.28 GiB, currently available 1.78 GiB. Conservative initial-start planning check ~4 GiB available; deficit ~2.22 GiB. No proof of official BettaFish minimum; absolutely no automatic setting changes.
- Storage/ports (G0 OWNER_REPORTED): C free ~205 GiB; ports 5000, 8501–8503, 5444 unoccupied then; no BettaFish container/image/network/volume observed.
- Upstream: https://github.com/666ghj/BettaFish at b67928ff1ce515dd7672408221fb1e9500d0972d; Compose GHCR :latest + PostgreSQL 15; default ports 5000,8501-8503,5444; .env/report/DB mounts, no Compose healthcheck observed. Before G1 pin exact image digest+manifest and verify upstream provenance where practical, localhost-bind app ports, remove host DB port, isolate app/data, plan rollback.
- MindSpider/platform crawl and API secrets are not automatically initialized by `docker compose up`; external keys cost money; README states noncommercial research/education limitation beyond GPL-2.0 code license.
- GitHub persistence through Reviewer connector: local Git checkout unnecessary for future Codex runtime verification.

## CURRENT_ACCEPTED_STATE
Reviewer verified latest GitHub management files and durably recorded G0 return and G0R return as `OWNER_REPORTED` physical-host facts. G0R is not PASS; it established adequate Docker engine capacity but insufficient live host memory. Codex reported `ACTUAL_CHANGES=NONE`; local runtime deployment is UNVERIFIED/NOT_STARTED.

## CURRENT_GATE
`BTFL-G0M-READONLY-MEMORY-RECHECK-20261013` at `G0M_MEMORY_RECHECK_GATE.md`: conditional, perform only **after** Owner voluntarily frees available RAM; if Owner does not choose to close apps, HOLD without any new Codex run. Reviewer must accept results before authoring G1.

## CRITICAL_CONSTRAINTS
- Physical Owner-local Windows 11 Codex only; no other server or environment.
- No install, image pull, compose up/down, Docker daemon/WSL global config edit, Secret access, browser/crawler login, real API calls, paid services or public routes until separate reviewed Gate.
- Codex shall not terminate processes, reboot, alter networking/VPN/Clash/HY2/WG/proxy/routes/MTU/firewall, free memory by intrusive cleanup, or use admin escalation.
- No local project management Git checkout required; sanitized runtime facts in chat, Reviewer appends GitHub evidence.
- Future local app services bind 127.0.0.1, DB no host port, isolate namespaces/durable volumes, classify resource and rollback; no claims of PASS without review.

## DEFAULT_EXECUTION_CHANNEL
Owner's local Windows 11 Codex; Executor executes precise current Gate only and returns; Reviewer performs GitHub documentation writes.

## CURRENT_ROLLBACK_STATUS
G0/G0R target unchanged per Executor. No runtime rollback needed for diagnostic Gates. Future G1 explicit rollback and recovery required.

## UNRESOLVED
Live headroom and memory pressure after Owner closes apps; exact Docker image digest-to-source correlation; durable app+DB path, Secret integration strategy, future G1 rollback, actual boot health and UI/DB behavior, source/platform access authorization, session marker classification if consequential.

## NEXT_STEP
Owner voluntarily saves work/closes unused apps to recover >2.22 GiB; rerun only one read-only memory check with G0M; if at least ~4 GiB host available and engine capacity stable, Reviewer can decide and author G1 independently. Do NOT re-run G0/G0R exhaustive scans and do NOT trigger G1 automatically.

## OWNER_ACTION_REQUIRED
Optionally close unneeded applications in Windows Task Manager, WITHOUT touching VPN/other active workloads or Docker. Then send the G0M read-only relay to local Codex. Otherwise keep RESOURCE_HOLD.

## EVIDENCE_POINTERS
- `EXECUTION_EVIDENCE.md` (append-only, contains G0 and G0R returns)
- `G0_LOCAL_READONLY_DISCOVERY_GATE.md` and `G0R_TARGET_RESOURCE_GATE.md` (completed/returned historical Gates)
- `G0M_MEMORY_RECHECK_GATE.md` (next conditional read-only check)
