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
   │   DigitalOcean sfo3 droplet
   │        ↓
   │   Internet / OpenAI
   │
   └─ Side-by-side candidate: Hysteria2 UDP 8443
            ↓
       same DigitalOcean sfo3 droplet
       (server deployed/active; client not imported/enabled; no traffic switched)
```

- VPS: DigitalOcean droplet at `24.199.118.137`. Legacy project/client label `SFO2-A`; fresh DigitalOcean metadata identifies the actual provider region as `sfo3`. Treat `SFO2-A` only as the legacy local profile/test label, not as the provider region.
- Current production VPN: WireGuard; fresh active MTU is 1420. Historical 1280 remains only as legacy metadata.
- Client: Windows; Clash Verge 2.5.6 installed. Mihomo Meta v1.19.31 and alpha-f103639 are present and HY2/fingerprint config-parser compatible; no active Mihomo core/TUN was observed at G2-A completion.
- Hysteria2: G2-A side-by-side server deployment accepted; official v2.12.3 service active on UDP 8443. Client profile is prepared but not imported/enabled.
- Current networking baseline: eth0 qdisc fq_codel; TCP CC cubic; BBR inactive; generic GRO on; rx-gro-list off; rx-udp-gro-forwarding off. No live tuning has been applied.
- Shared infra dependency: none assumed. Any discovered Caddy/80/443/shared firewall dependency must fail closed and be reported before change.

## 4. Current State

```text
P0 Research / Scope / Project Init   ✅ REVIEWER ACCEPTED
G1 Foreground-safe Foundation        ✅ REVIEWER PASS
G2-A Side-by-side HY2 Deployment     ✅ REVIEWER PASS
G2-B Safe-window Validation + Seal   ← CURRENT / OWNER SAFE WINDOW CONFIRMED
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

## 6. Accepted Gate — G1 Foreground-safe Foundation

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

## 7A. Reviewer Decision — G1

- Decision: `PASS_G1_FOREGROUND_SAFE_FOUNDATION`.
- Accepted execution commit: `75b738726d3325dbb67ee4cbeaf1bad46cf47f78`.
- GitHub branch reconciliation: current `main` later advanced to `e9b2de0303d3e9c36fb7e025b62e16a11a48ad3a` through unrelated `shared-vps-infrastructure` commits. The G1 commit remains an ancestor of current `main`; no VPN project rollback or overwrite occurred.
- The Executor's `RETURN_PREFLIGHT_DRIFT` was correct at execution time. Reviewer reconciliation resolves it as documentation/label drift, not wrong-host drift: the exact historical public IP was reached under strict host-key checking, while fresh DigitalOcean metadata identifies the same target as region `sfo3`. Future docs/scripts must not call the provider region `SFO2`.
- No live VPS/network/client mutation occurred; current WireGuard remained active; foreground tasks were not interrupted.
- G1 portable templates, preflight, health-check, rollback, and migration scaffolding are accepted.
- `HY2_READY=BLOCKED_WITH_EXACT_REASON` is accepted under G1 criteria because Secret/TLS/DNS/cloud-firewall enablement was intentionally not authorized in this foreground-safe Gate.
- YAML parser validation remains outstanding and must be performed before any HY2 deployment.
- Mihomo active core version remains UNKNOWN; it must be confirmed before importing/enabling the HY2 profile.

## 7B. Reviewer Decision — G2-A

- Decision: `PASS_G2A_HY2_SIDE_BY_SIDE`.
- Accepted execution commit: `e17929a469a616c299ca22ec094e42f019b90df5`.
- GitHub fresh read-back: PASS; at review time this commit is current `main` HEAD.
- Hysteria2 official binary v2.12.3 is installed side-by-side and its dedicated service is enabled/active on UDP 8443.
- Existing WireGuard remains active on UDP 51820; routes, NAT/firewall state, Windows WireGuard/proxy/TUN state, MTU/qdisc/BBR/GRO baseline, and current foreground traffic were not switched or tuned.
- Secret authorization and recovery requirements were satisfied: target files use the accepted permissions; Secret values emitted/logged/committed = 0; DPAPI CurrentUser recovery final artifact passed host-local existence, owner-only ACL, and byte-identity round-trip checks.
- The non-sensitive `config/clash/sfo3-a-hy2.yaml` is parser-valid and pins the deployed certificate fingerprint; its auth remains a local secret-injection placeholder and it has not been imported/enabled.
- Client handshake and real traffic validation were intentionally not performed in G2-A. Therefore server deployment is accepted, but HY2 performance/reliability is not yet accepted.
- Resource observation: HY2 RSS was ~21 MiB; the interval MemAvailable delta is not attributed solely to HY2.
- G2-A execution notes about the missing `/srv/data`/`/srv/apps` parents and the corrected `ss -p` parser are accepted because final independent read-back passed before DPAPI final promotion and no prohibited network change occurred.

## 8. UNKNOWN / Open Risks

- Clash Verge is 2.5.6; installed Mihomo cores are known and parser-compatible, but no active core was running during G2-A.
- Whether current Windows traffic uses official WireGuard app, Clash, or mixed routing at execution time.
- DigitalOcean Cloud Firewall: Owner visually confirmed no Cloud Firewall is attached to this droplet.
- Current VPS OS/kernel/qdisc/BBR/offload values.
- UDP 8443 is locally bound by the Hysteria2 service; end-to-end client reachability/handshake is still unproven until G2-B.
- HY2 auth/TLS generation and DPAPI recovery are complete; no public DNS dependency is used. Client-side auth injection and handshake remain to be validated.
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

## 11. G2 — Deploy + Safe-window Validation + v1 Seal

G2 remains one Gate with two bounded checkpoints to avoid Gate sprawl.

### G2-A — Side-by-side HY2 deployment — REVIEWER PASS

Completed without switching the live WireGuard path.

Required sequence:
- fresh read-only preflight and confirm the accepted sfo3 target;
- validate the YAML templates with a real parser before deployment;
- confirm the actual Mihomo core/version and current Hysteria2 support;
- inspect DigitalOcean Cloud Firewall / UDP 8443 reachability without changing live routing;
- prefer the minimum private-node TLS design. Current research candidate is self-signed TLS with certificate pinning, avoiding a domain requirement, but Executor must verify compatibility against the installed Hysteria2/Mihomo versions before freezing config;
- Secret generation/install requires exact Owner authorization and must follow delegated-secret rules;
- install HY2 as a side-by-side service on UDP 8443 only; do not alter wg0, routes, NAT default policy, system proxy, or current Clash/WireGuard traffic;
- perform local/service-level health checks only.

G2-A must stop before client traffic switches if foreground tasks are active.

### G2-B client-route preflight — Owner read-back

Owner-side Windows read-back before G2-B established:

- target VPS `24.199.118.137` currently resolves through the WireGuard adapter `SFO2-A` (ifIndex 13), source `10.66.21.2`;
- physical WLAN is `Realtek 8852CE WiFi 6E PCI-E NIC`, ifIndex 18, IPv4 `192.168.1.4`, gateway `192.168.1.1`;
- there is no existing `24.199.118.137/32` host route;
- both WLAN and WireGuard expose a default route, and Windows route diagnosis selected WireGuard for the VPS IP.

Implication: do not run HY2 through the current default route because that would risk nesting HY2 inside WireGuard and invalidating the comparison. Preferred bounded G2-B method is a temporary ActiveStore-only `24.199.118.137/32` route via WLAN gateway `192.168.1.1` / ifIndex 18, with exact pre/post read-back and exact removal at the end. WireGuard itself must remain running. If route creation requires elevation unavailable to Executor, stop at an Owner checkpoint rather than disabling WireGuard.

### G2-B — Safe-window comparative validation — NEXT

Only after Owner explicitly confirms a safe window:
- import/enable the prepared HY2 profile without deleting the existing WireGuard profile;
- compare WG and HY2 under the same short, low-impact method;
- prioritize success rate, Median/P95/P99, >1s tails, timeout/reset, and real long-task behavior over bandwidth screenshots;
- only if HY2 alone does not explain/improve the tail, test the surviving tuning candidates one at a time (for example MTU or UDP GRO forwarding), with before/after rollback boundaries;
- do not bundle BBR/fq/GRO/MTU changes into one experiment;
- select the minimal configuration that improves stability without adding unnecessary complexity;
- freeze v1 portable deployment and rollback package.

### G2 exit

MVP ends after G2. New VPS/provider evaluation later reuses the same package rather than rebuilding the stack.

## 12. Next Step

- Owner explicitly confirmed a safe window on 2026-10-02: no foreground task needs protection during this G2-B run.
- Reviewer next action: issue the bounded G2-B validation prompt.
- Executor next action: perform only the bounded G2-B sequence below and stop at Reviewer.
- Owner safe-window confirmation for this run: CONFIRMED.
- G2-B must keep WireGuard as the rollback baseline, inject the existing HY2 auth locally without exposing it, prove a real HY2 handshake first, then run short low-impact same-window comparison.
- Do not add 3X-UI, VLESS-Reality, broad sysctl tuning, aggressive fixed-bandwidth settings, or bundled multi-variable tuning.
- If HY2 alone materially improves the accepted tail/stability metrics, seal v1 without unnecessary BBR/GRO/MTU changes. If not, test surviving tuning candidates one at a time with rollback.

## 13. Status Summary

- Overall progress: P0 + G1 + G2-A PASS. HY2 is deployed side-by-side; current production traffic remains on WireGuard.
- Final goal: portable VPN optimization v1.
- Current Gate: G2-B safe-window validation is next and has not started.
- This round completed: official HY2 v2.12.3 deployment on UDP 8443, Secret/TLS provisioning, DPAPI recovery, parser-validated Mihomo client fragment, rollback and regression verification.
- Next: Owner confirms a safe window; then prove client handshake and compare WireGuard vs HY2 under the same low-impact method.
- Attention: server-side readiness is accepted; HY2 performance superiority is not yet proven.
