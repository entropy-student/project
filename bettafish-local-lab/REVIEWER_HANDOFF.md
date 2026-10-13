# BettaFish Local Lab — REVIEWER_HANDOFF
> Updated: 2026-10-13
> Governance: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7 ACTIVE_PROVISIONAL
> Canonical project: entropy-student/project main:bettafish-local-lab/
> Execution channel: Owner's Windows 11 local Codex; Reviewer handles GitHub persistence if safe checkout unavailable
> STOP_AT_REVIEWER: YES

## PROJECT_GOAL
在 Owner 的实体 Windows 11 本机独立部署并验证开源 BettaFish（微舆），通过 localhost 查看网页并完成数据库健康检查。初期仅进行无实际平台采集、无外部收费 API 的低风险服务测试。保护当前 VPN、代理、其他项目、账户及数据。

## PROJECT_STAGE
G0 READ-ONLY DISCOVERY: RETURN_NO_SAFE_CHECKOUT recorded; targeted G0R follow-up authorized. No runtime installation/deployment yet.

## SYSTEM_MAP
- Target: Owner Windows 11 physical host; Codex reported Windows 11 Home build 26300, PowerShell 7.6.5, not elevated. This is OWNER_REPORTED until direct reviewable sanitized read-back.
- Existing Docker reported: Docker Desktop Engine 4.88.1, Compose 5.4.0 available; named ports 5000, 8501-8503, 5444 not listening; no BettaFish container/network/volume/image detected. All OWNER_REPORTED.
- Host resources (OWNER_REPORTED): C: available about 205 GiB; system available RAM ~1.4 GiB at probe time; low headroom blocks G1 service start until reconciled. Docker VM memory budget/total physical memory UNKNOWN.
- Upstream: https://github.com/666ghj/BettaFish at observed main b67928ff1ce515dd7672408221fb1e9500d0972d. Official Compose: GHCR latest + PostgreSQL 15, default host ports 5000, 8501-8503, 5444; .env, database and report bind mounts; no healthcheck in inspected Compose; exact digest and provenance need G1 freezing. MindSpider platform crawling, browser login and model APIs are separate from starting Web UI; no real crawling/model use authorized.
- License/restriction: upstream GPL-2.0 LICENSE, README also restricts use to research/education; not authorized for commercial product.
- Current Codex workdir was not a Git repository; no safe local `entropy-student/project` checkout established; no existing local BettaFish install. No local runtime mutations reported.
- Reviewer persists canonical records via GitHub API so target executor need not checkout management repo merely to write Evidence. Project-specific install workspace will be isolated in a future G1 after source/host validation.

## CURRENT_ACCEPTED_STATE
- Reviewer has read current canonical Governance v0.2.7 and triggered 11A-D.
- G0 Executor returned `RETURN_NO_SAFE_CHECKOUT`, with bounded diagnostic facts but no repo write. Reviewer retained returned facts as `OWNER_REPORTED` rather than falsifying `DIRECT_READBACK`; see EXECUTION_EVIDENCE.md.
- Reviewer verified `entropy-student/project` main `bettafish-local-lab/` doc files exist on GitHub. Real Windows host read-back not independently reviewable. No service deployed or tested.

## CURRENT_GATE
`BTFL-G0R-READONLY-TARGET-RESOURCE-20261013` in `G0R_TARGET_RESOURCE_GATE.md`; short read-only refresh only. G0 original is returned; do not rerun it wholesale.

## CRITICAL_CONSTRAINTS
- Only Owner physical Windows host via Codex, no VPS/remote/Grok Bot/sandbox target.
- G0R read-only. NO clone/checkout/install/pull/run/build/config write/git write/API key/cookie/platform login/crawl/paid calls, admin elevation, resource cleanup, or unrelated process kill.
- No changes to VPN, Clash, HY2, WireGuard, WSL config, Docker daemon/global resources, firewall, proxy, network, shared apps.
- Secret values/hashes/profiles/logs never output. Mask machine/username/IP/credentials. Anonymous access exposure forbidden; future G1 localhost-only.
- This round's canonical GitHub persistence belongs to Reviewer. Executor relays concise sanitized evidence in chat and stops. `PASS_CANDIDATE != PASS`.

## DEFAULT_EXECUTION_CHANNEL
Owner Windows 11 local Codex. Reviewer does not pretend GitHub connector has direct access to user's physical PC.

## CURRENT_ROLLBACK_STATUS
Target runtime unchanged according to G0 report. No runtime rollback needed for G0/G0R; future deploy must own exact namespace and plan app/DB/report removal/restore.

## UNRESOLVED
Physical host identity proof/effective runtime context; total physical/available host memory and Docker VM allocation; practical resource margin after ordinary owner-controlled app closing; exact image digest/source link; Secret placement; production/crawler/browser permissions, costs; future isolated local install path.

## NEXT_STEP
Owner pastes G0R relay to local Codex; it reports read-only host/resource read-back. Reviewer records/reviews and decides G1 local Docker-only setup when sufficient headroom is evidenced.

## OWNER_ACTION_REQUIRED
Pass G0R relay to existing local Codex. If memory insufficient, Owner may voluntarily close their own nonessential apps, but Executor must not terminate apps or alter OS settings.

## EVIDENCE_POINTERS
- `EXECUTION_EVIDENCE.md`: Reviewer-persisted G0 return evidence, tagged OWNER_REPORTED where applicable.
- `G0_LOCAL_READONLY_DISCOVERY_GATE.md`: prior G0 Gate, returned and not replayed.
- `G0R_TARGET_RESOURCE_GATE.md`: next Gate.
