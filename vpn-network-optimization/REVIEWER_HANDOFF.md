# VPN Network Optimization — REVIEWER HANDOFF

> Maintainer: Reviewer / Architect / Gatekeeper only  
> Governance: `entropy-student/spike.skill/vps-project-governance` latest  
> Executor facts begin in `EXECUTOR_HANDOFF.md` / `EXECUTION_EVIDENCE.md` once G1 execution starts.

## 1. Project Goal

- Final goal: 建立一套可迁移、可验证、可回滚的自建 VPN 优化标准，提高 Codex / OpenAI / AI 生图等长任务的稳定性与尾部表现，并可快速复用于不同 VPS。
- Current goal: 在不影响当前前台任务的前提下，以现有 SFO2-A + WireGuard 为基线，完成第一版可迁移优化骨架；暂不做性能 A/B 和路由切换。
- Guiding principle: 不复制某一作者的全部参数；以官方文档、可靠实现和本机证据筛选最小有效配置。

## 2. Authority / Source of Truth

### Governance

1. Owner 最新明确指令
2. active bounded Reviewer override
3. GitHub canonical `entropy-student/spike.skill/vps-project-governance` latest
4. 历史副本 / chat

### Project factual state

1. 本 `REVIEWER_HANDOFF.md`
2. fresh target-host read-back + accepted `EXECUTION_EVIDENCE.md`
3. `EXECUTOR_HANDOFF.md`
4. README / historical chat

## 3. Current Architecture

```text
Windows client
   │
   ├─ Current production path: WireGuard
   │        ↓
   │   DigitalOcean SFO2-A
   │        ↓
   │   Internet / OpenAI
   │
   └─ Future candidate: Hysteria2 via Clash Verge
            (not deployed/activated as current traffic path yet)
```

- VPS: DigitalOcean SFO2-A, historical IP `24.199.118.137`; G1 must fresh-verify identity before any remote write.
- Current VPN: WireGuard, historical client MTU 1280.
- Client: Windows; Clash Verge installed. Exact version/core/TUN state = UNKNOWN until G1 read-back.
- Hysteria2: NOT YET ACCEPTED AS DEPLOYED.
- fq / BBR / UDP GRO settings: UNKNOWN until G1 read-only inspection.
- Shared infra dependency: none assumed. Any discovered Caddy/80/443/shared firewall dependency must fail closed and be reported before change.

## 4. Current State

```text
P0 Research / Scope / Project Init   ✅ REVIEWER ACCEPTED
G1 Foreground-safe Foundation        ← CURRENT
G2 Safe-window Validation + v1 Seal  ⏳
```

P0 acceptance covers research/scope only. It does NOT assert fresh server/runtime state.

## 5. Accepted Baseline

- Owner priority: finish quickly; avoid unnecessary feature accumulation.
- Highest runtime constraint: current foreground Codex / image-generation tasks must not be interrupted or rerouted.
- Current WireGuard remains production baseline until G2 evidence proves a reason to change.
- Hysteria2 is a candidate/backup path, not a predetermined winner.
- Clash Verge should be reused where suitable rather than adding another Windows GUI client unnecessarily.
- Author-derived ideas are a candidate pool only; external official/reliable sources may replace them.
- First MVP excludes 3X-UI, VLESS-Reality, TUIC, residential IP, broad sysctl tuning, aggressive fixed-bandwidth HY2, automated VPS purchasing.

Historical performance reference:
- short WG test: Median ~0.595s / P95 ~0.773s / P99 ~0.985s;
- 15-minute foreground-load test: 90/90 success, Median ~0.696s / P95 ~1.358s / P99 ~1.872s / >1s 13;
- 2026-10-01 ~20:00 peak test: 90/90 OpenAI requests succeeded, average ~0.845s, Median ~0.756s, P95 ~1.628s, P99 ~2.190s, >1s 18/90, >1.5s 7/90, >2s 1/90, WG ping no-reply 4/90;
- same peak sample: client→public VPS ping Median ~160ms / P95 ~187ms; WG tunnel ping Median ~163ms / P95 ~180ms; TCP22 Median ~169ms with isolated ~1.17s tail.
Interpretation boundary: evidence currently supports “normal baseline RTT with materially worse evening tail/jitter”; it does NOT yet prove whether the root cause is client uplink, international route loss/retransmission, WireGuard/MTU behavior, local bufferbloat, VPS forwarding, or OpenAI/upstream wait. ICMP no-reply is a warning signal, not by itself a transport packet-loss measurement.
These are historical references, not G1 fresh evidence.

## 6. Current Gate — G1 Foreground-safe Foundation

### Goal

Without affecting current foreground traffic:

1. prove target-host identity and current client/server baseline;
2. inspect WireGuard, MTU, routes, firewall, NAT, ports, kernel, qdisc, congestion control, GRO/offload capabilities;
3. create portable non-secret deployment/config templates;
4. prepare Hysteria2 side-by-side as far as safely possible;
5. prepare health-check and rollback tooling;
6. leave current traffic on existing WireGuard;
7. do not run performance benchmark yet.

### Allowed

- Read-only local/remote inspection.
- Project-local GitHub files/scripts/templates.
- Back up relevant non-secret configuration metadata.
- Download/install binaries/packages if the operation does not restart or alter current network services.
- Create isolated HY2 config/service on an unused UDP port only after conflict checks.
- Generate syntax-valid non-secret client templates for Clash Verge/Mihomo or official HY2 client.
- Start an isolated HY2 service only if this requires no route/NAT/default-policy changes, no existing-service restart, no material foreground resource impact, and no unresolved cloud-firewall dependency.
- Create rollback/uninstall scripts.
- Create `EXECUTOR_HANDOFF.md` and `EXECUTION_EVIDENCE.md` when actual execution begins.

### Forbidden in G1

- Restart/reboot VPS.
- Restart/stop/reconfigure WireGuard or wg0.
- Switch Windows current VPN, system proxy, TUN, route, or current Clash node.
- Run Speedtest, bulk downloads, stress tests, long benchmark loops, Codex/image A/B.
- Apply fq/BBR/sysctl/network offload changes to the live host.
- Change existing NAT/default firewall policy unless separately authorized after impact review.
- Touch shared Caddy/80/443 or unrelated production services.
- Install 3X-UI/VLESS-Reality/TUIC/one-click optimization suites.
- Commit any Secret value.
- Generate/install new Secret material unless Owner provides explicit exact allowlist authorization under Governance.

### Acceptance criteria

```text
TARGET_HOST_VERIFIED=YES
CURRENT_WIREGUARD_PRESERVED=YES
FOREGROUND_TASK_INTERRUPTION=NO
BASELINE_INSPECTION_COMPLETE=YES
PORTABLE_TEMPLATE_READY=YES
ROLLBACK_READY=YES
CURRENT_TRAFFIC_SWITCHED=NO
LIVE_SYSTEM_TUNING_APPLIED=NO
HY2_READY=YES|BLOCKED_WITH_EXACT_REASON
CLASH_VERGE_INTEGRATION_PLAN_READY=YES
```

HY2 may be `BLOCKED_WITH_EXACT_REASON` if Cloud Firewall, DNS/certificate, Secret authorization, or client GUI action requires Owner. That does not authorize bypassing the blocker.

### Evidence required

- target host identity and fresh IP read-back;
- WireGuard state without private key disclosure;
- current routes and relevant interface/MTU metadata;
- listening ports and HY2 port conflict result;
- firewall/NAT metadata;
- kernel/qdisc/congestion-control/GRO capability;
- exact files/services created or changed;
- proof existing WG remains up;
- proof no current route/proxy switch occurred;
- rollback commands/scripts and syntax checks;
- secret/private-data statement.

## 7. Candidate Optimization Pool

### MVP candidates

- WireGuard MTU/Keepalive standardization;
- Hysteria2 side-by-side;
- fq / BBR suitability inspection;
- UDP GRO forwarding/offload inspection;
- Clash Verge/Mihomo integration;
- automated inspection/health/rollback/migration tooling.

### Later only if evidence supports

- HY2 aggressive/fixed-bandwidth congestion mode;
- UDP socket buffer changes;
- SQM/CAKE for proven local bufferbloat;
- VLESS-Reality for reachability/obfuscation needs;
- additional protocols.

## 8. UNKNOWN / Open Risks

- Exact current Clash Verge version and core.
- Whether current Windows traffic uses official WireGuard app, Clash, or mixed routing at execution time.
- Actual SFO2-A live firewall/cloud-firewall policy.
- Current VPS OS/kernel/qdisc/BBR/offload values.
- Whether UDP 8443 is free end-to-end.
- Whether HY2 certificate/auth can be completed without Owner Secret authorization or DNS action.
- Whether any server-level changes would share a failure domain with other services.
- Whether current MTU=1280 is still necessary/optimal.
- Whether long-task bottleneck is client→VPS, international route jitter/retransmission, WireGuard/MTU behavior, local bufferbloat, VPS forwarding, VPS→OpenAI, or upstream service behavior.
- Peak-hour evidence shows tail degradation without broad request failure; G1 must preserve this as a diagnosis target rather than assume “high ping” is the root cause.

## 9. Owner-only Checkpoints

Owner intervention is required only for:

- purchase/payment/new VPS;
- account/2FA/DigitalOcean GUI action unavailable to Executor;
- DNS ownership action;
- explicit Secret generation/install authorization (exact allowlist);
- manual Clash Verge GUI import/switch when unavoidable;
- any action that would alter the current live route/VPN while foreground tasks are running;
- irreversible or material production/network enablement.

When blocked, Executor must stop with one compact action list; no fragmented command relay.

## 10. Rollback / Recovery

G1 rollback principle:

- Existing WireGuard is untouched.
- New project/HY2 artifacts must be isolated and removable without changing WG.
- Any new systemd service must have an explicit disable/stop/remove path.
- Any package/config write must be recorded.
- No broad prune.
- No secret value in repo/log/evidence.
- If a step unexpectedly changes connectivity or a shared service, fail closed and restore only the exact G1 change.

## 11. G2 Preview — Safe-window Validation + v1 Seal

Only after Owner confirms foreground tasks are idle:

- compare current WG and HY2 using the same endpoint/time window;
- test only the small set of candidate tunings that survived G1 review;
- include real Codex/image workload only after network validation;
- select the minimal configuration that improves stability/tail behavior without adding unnecessary complexity;
- freeze v1 portable deployment and rollback package.

MVP ends after G2. New VPS/provider evaluation later reuses the same package.

## 12. Next Step

- Reviewer next action: issue one bounded G1 execution prompt.
- Executor next action: start with target-host and client read-only preflight, then continue only within G1 allowed scope.
- Owner intervention required now: NO.
- If a Secret/DNS/cloud-firewall/client-switch checkpoint appears: YES, only at that exact checkpoint.

## 13. Status Summary

- Overall progress: Project initialized; research/scope frozen; no live optimization applied yet.
- Final goal: portable VPN optimization v1.
- Current Gate: G1 Foreground-safe Foundation.
- This round completed: research, scope, MVP/non-goals, Clash Verge direction, project governance mapping.
- Next: Executor G1.
- Attention: foreground tasks are protected; no performance tests or live route changes in G1.
