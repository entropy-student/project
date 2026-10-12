# BettaFish Local Lab — REVIEWER_HANDOFF
> Updated: 2026-10-13
> RULESET: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7 (ACTIVE_PROVISIONAL)
> EXECUTION_CHANNEL: Owner's Windows 11 local Codex
> EXECUTOR_DOES_NOT_READ_GOVERNANCE: YES

## PROJECT_GOAL
在 Owner 本地 Windows 11 上独立、可恢复、仅 localhost 地部署开源 BettaFish（微舆），验证界面、数据库及后续舆情分析就绪条件；不动现有 VPN/代理、共享项目及生产环境。正式舆情采集和真实模型调用不在首轮授权内。

## PROJECT_STAGE
NEW_PROJECT / READ_ONLY_DISCOVERY_REQUIRED

## SYSTEM_MAP
- Target: Owner Windows 11 physical PC; actual machine/user/privilege and Docker Desktop/WSL2 state UNKNOWN until G0 read-back.
- Source: https://github.com/666ghj/BettaFish ; reviewed upstream main at b67928ff1ce515dd7672408221fb1e9500d0972d (2026-10-13 observation, not frozen tested artifact).
- Official Docker Compose: GHCR `ghcr.io/666ghj/bettafish:latest` + PostgreSQL 15; default published host ports 5000, 8501–8503, 5444; default bind-mounted `.env`, reports/logs, and `./db_data`. Exact image digest and source/image correspondence UNKNOWN.
- Browser automation: MindSpider/MediaCrawler, platform login/session required, and deeper crawling separately initialized/operated. Not part of G0 or automatically authorized later.
- Models: multiple externally provided LLM API configurations; may incur charges. Secrets and account access are Owner-controlled.
- Data/security: no real data, credentials, public hosting, or production use in G0. Upstream README says academic/research/education only; GPL-2.0 code license separately stated. Do not infer commercial permission.
- Preferred future app path: project-isolated Owner-local directory, selected only after G0 inventories existing paths; no new path is authorized for mutation in G0.
- Existing other local projects, Docker workloads, networking, VPN, browser profiles: out of scope.

## CURRENT_ACCEPTED_STATE
- GitHub canonical Governance v0.2.7 was reviewed by Reviewer for this new project on 2026-10-13.
- Reviewer has verified official upstream source/README/Compose surface; no target-host direct read-back has occurred.
- NO local BettaFish deployment is claimed. `RUNTIME=UNKNOWN`, `SECURE_SECRET_PROVISIONING=UNRESOLVED`.

## CURRENT_GATE
`BTFL-G0-READONLY-DISCOVERY-20261013`: [G0_LOCAL_READONLY_DISCOVERY_GATE.md](G0_LOCAL_READONLY_DISCOVERY_GATE.md).

## CRITICAL_CONSTRAINTS
- Only Owner's physical Windows 11 via local Codex; cloud tool/container/Grok Bot/VPS is NOT the target.
- G0 is READ_ONLY on local machine and GitHub upstream. No install, service start, image pull, file mutation, application setup, credentials reading, scraping, AI API calls, account login, payment, new network exposure.
- Strict Secret safety (no values, no hashes, no logs or plaintext in Git/chat).
- No changes to HY2/WireGuard/Clash/VPN/proxy, routes, TUN, MTU, firewall, Docker global configuration, WSL settings, 80/443, or unrelated apps.
- Only bounded non-secret Evidence + completion packet may be written to `bettafish-local-lab/` in canonical project repository, using GitHub main and exact path scope. Do not modify Governance or other projects.
- `PASS_CANDIDATE != PASS`. `STOP_AT_REVIEWER=YES`. No G1 until Reviewer acceptance.

## DEFAULT_EXECUTION_CHANNEL
Owner's Windows 11 local Codex acting as Executor via precisely scoped `REVIEWER_TO_EXECUTOR_RELAY` from G0. Reviewer (ChatGPT) owns Governance interpretation and Gate acceptance.

## CURRENT_ROLLBACK_STATUS
No local mutation authorized/performed by this round; target local runtime rollback NOT_APPLICABLE for G0. Future G1 must define rollback and persistent-data protection before deploy.

## UNRESOLVED
Local Windows runtime identity, privilege, PowerShell version, Docker Desktop/Compose daemon state, WSL availability, available local disk/memory, conflicting ports/containers, existing local target directory, current project worktree state, real image digest, trustworthy Secret runtime integration, platform data permission, cost plan.

## NEXT_STEP
Codex runs G0 only, records sanitized evidence and returns. Reviewer inspects, reconciles target state, then decides and authors G1 local-only Docker deployment Gate.

## OWNER_ACTION_REQUIRED
Copy G0 relay to local Codex. No admin or credential action for G0.

## EVIDENCE_POINTERS
This new project has no accepted runtime Evidence. Executor creates/appends `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md` in this folder for G0, preserving only non-secret facts.
