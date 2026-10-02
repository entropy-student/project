# VPN Network Optimization — REVIEWER HANDOFF

> Maintainer: Reviewer / Architect / Gatekeeper only  
> Governance: `entropy-student/spike.skill/vps-project-governance` latest  
> Executor facts begin in `EXECUTOR_HANDOFF.md` / `EXECUTION_EVIDENCE.md` once G1 execution starts.

## 0. Current Truth / Resume Point

This section is the canonical resume point. If any older section conflicts with it, this section wins.

```text
P0                                   PASS
G1                                   PASS
G2-A server-side HY2 deployment      PASS
G2-A DPAPI recovery closure          PASS
G2-B benchmark                       NOT STARTED (0 formal samples)
CURRENT_BLOCKER                      Owner High-integrity -PreflightOnly retry pending
```

Current runtime facts:

- Production traffic remains on WireGuard; WireGuard has not been stopped or replaced.
- VPS is DigitalOcean `24.199.118.137` in `sfo3`; WireGuard listens on UDP 51820 and Hysteria2 v2.12.3 listens on UDP 8443.
- Safe split control/data path is proven:
  - control plane: Codex/SSH → WireGuard → `10.66.21.1:22`;
  - HY2 candidate data plane: localhost test proxy → WLAN → `24.199.118.137:8443`.
- Owner-created temporary route is currently present and fresh-read as: `24.199.118.137/32 -> 192.168.1.1 -> WLAN ifIndex 18 -> ActiveStore, metric 1`. It is non-persistent and must be removed only after G2-B testing/cleanup is complete.
- With that route present, WireGuard services remain Running, adapter `SFO2-A` remains Up, and normal public exit remains `24.199.118.137`.
- SSH over the public IP is not the G2-B control path. Use `10.66.21.1:22` through WireGuard with the already accepted host-key trust.
- Owner PowerShell environment has been verified as PowerShell 7.6.6, Administrator = True, integrity RID 12288 / High.
- Codex desktop cannot run the long local benchmark in the current thread because no integrated terminal is attached; therefore the accepted execution model is an Owner-run PowerShell runner, with Codex/Reviewer handling preparation, review, evidence, and final acceptance.

DPAPI recovery reality:

- The original 1206-byte DPAPI artifact was found under Codex packaged-app LocalCache virtualization, fully validated with DPAPI CurrentUser + `VPNHY2R1` + TLS checks, then copied as identical encrypted bytes into the canonical Owner path.
- Canonical Owner path realization is PASS: Owner Windows target confirmed, Owner-only ACL PASS, DPAPI round-trip PASS, `VPNHY2R1` validation PASS, pending absent, no plaintext temp file, Secret values emitted 0.
- Do not re-fetch or rotate VPS Secrets. The virtualized source remains retained for now.
- The AppData/path-virtualization defect is CLOSED.

G2-B benchmark status:

- WireGuard benchmark samples completed: `0`.
- HY2 benchmark samples completed: `0`.
- HY2 real client handshake tested in G2-B: `NO`.
- The first Owner run of `g2b-owner-runner.ps1` passed Administrator/High checks but failed closed at `PRECHECK_ROUTE_AND_ADAPTERS` with `CimJobException` before any benchmark sample.
- Owner then ran the underlying read-only Windows queries successfully from the same elevated PowerShell 7.6.6 shell: exact /32 route present, WLAN ifIndex 18 Up with IPv4 192.168.1.4 and gateway present, WireGuard `SFO2-A` ifIndex 13 Up.
- Reviewer fresh-read accepted the bounded diagnostic/source-persistence Gate at commit `243c5eeb5833f25566ea49463b84b93b5063ad14`: the no-match `PersistentStore` query fault is handled narrowly, branch-specific diagnostics are present, `-PreflightOnly` returns before Secret/Mihomo/benchmark/network mutation, and all three runner sources are now canonical/reviewable on GitHub.
- Owner High-integrity `-PreflightOnly` was then executed from PowerShell 7.6.6 / RID 12288. The earlier route/adapter precheck passed far enough to advance into `PRECHECK_WIREGUARD_AND_CLIENT_STATE`, where the runner failed closed with `PropertyNotFoundException` before Secret access, Mihomo start, benchmark, or network mutation.
- Owner bounded read-only diagnostic proved `AutoConfigURL` is absent while the other snapshot inputs are healthy; under StrictMode the old direct access was the exact `PropertyNotFoundException` cause.
- Reviewer fresh-read accepted commit `50a6b02480df6554493fee59f1610486a9a239fe`: optional `ProxyServer` / `ProxyOverride` / `AutoConfigURL` now normalize missing/null to empty string, `ProxyEnable` and required service/WireGuard/route fields remain fail-closed, and snapshot failures now retain branch-specific diagnostics.
- Exact candidate commit scope is limited to `g2b-owner-runner.ps1`, `EXECUTION_EVIDENCE.md`, and `EXECUTOR_HANDOFF.md`; `REVIEWER_HANDOFF.md` was not modified by Executor. Reviewer acceptance then advanced `main` only by the Reviewer-owned Handoff record.
- No G2-B performance conclusion exists yet.

## 1. Project Goal

- Final goal: 建立一套可迁移、可验证、可回滚的自建 VPN 优化标准，提高 Codex / OpenAI / AI 生图等长任务的稳定性与尾部表现，并可快速复用于不同 VPS。
- Current goal: 在 Owner 同一 High-integrity PowerShell 7.6.6 上重新运行只读 `-PreflightOnly` 验证已接受的 ClientSnapshot 修复；只有 Reviewer 接受该 Owner read-back 后才进入 WireGuard vs Hysteria2 同窗口低干扰 A/B。
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
G2-A HY2 server deployment           ✅ REVIEWER PASS
G2-A DPAPI recovery closure          ✅ REVIEWER PASS
G2-B Safe-window Validation + Seal   ⏸ OWNER PREFLIGHTONLY PENDING
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
- Secret generation/install on the VPS remains accepted and Secret values emitted/logged/committed = 0. The standard Owner AppData path is absent, but a matching DPAPI artifact has now been found under Codex packaged-app LocalCache virtualization. Therefore the G2-A server deployment remains accepted; DPAPI recovery closure is pending exact virtualized-artifact validation and reconciliation to the canonical Owner path before G2-B benchmark execution.
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
- HY2 auth/TLS generation on the VPS is complete and no public DNS dependency is used. A DPAPI artifact exists under Codex packaged-app LocalCache virtualization, while the canonical Owner AppData path is absent. Exact artifact validation/reconciliation is the active blocker; client-side auth injection and handshake remain untested.
- Whether any server-level changes would share a failure domain with other services.
- Active WireGuard MTU is 1420; whether any MTU change would improve tail behavior remains untested and is not authorized before the protocol A/B.
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

#### Owner route action — current

Owner subsequently created the route from an elevated PowerShell and fresh read-back proved:

- `24.199.118.137/32` → `192.168.1.1` → WLAN ifIndex 18;
- `PolicyStore=ActiveStore`, metric 1;
- `Find-NetRoute` selects WLAN for the VPS IP;
- WireGuard services remained Running, `SFO2-A` remained Up, public exit remained `24.199.118.137`.

Current boundary: the route remains present. Do not recreate, overwrite, or delete it from Codex. The Owner-run G2-B runner may remove only this exact matching route during final cleanup after the benchmark has actually completed.

### G2-B — Safe-window comparative validation — BLOCKED ON DPAPI RECOVERY

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

### Owner snapshot diagnostic — root cause proven

Owner read-only diagnostic proved that the optional Internet Settings field `AutoConfigURL` is absent while the other queried client-state fields and route/service checks are present and healthy. Under StrictMode, the current direct access in `Get-ClientSnapshot` explains the observed `PropertyNotFoundException`. No Secret access, benchmark, Mihomo start, or network mutation occurred.

## 12. Next Step

1. Reviewer accepts `G2B_ClientSnapshot_Optional_Property_Repair` at commit `50a6b02480df6554493fee59f1610486a9a239fe`.
2. Owner runs only the canonical read-only checkpoint from repository root in elevated PowerShell 7.6.6:
   `& .\vpn-network-optimization\scripts\g2b-owner-runner.ps1 -PreflightOnly`
3. Expected success evidence: Administrator/High integrity PASS, route/WLAN/WireGuard/client-state/public-exit/config prechecks complete, `G2B_PREFLIGHT_ONLY=PASS`, `SECRET_ACCESSED=NO`, `MIHOMO_STARTED=NO`, `BENCHMARK_STARTED=NO`, `NETWORK_CHANGED=NO`.
4. If it returns, do not rerun or patch interactively; return the complete bounded output to Reviewer.
5. Do not run the full G2-B benchmark or MTU/BBR/fq/GRO/sysctl tuning yet.

## 13. Status Summary

- Overall: P0 PASS, G1 PASS, G2-A HY2 server deployment PASS, DPAPI recovery/path realization PASS.
- Route/adapter precheck repair: PASS.
- ClientSnapshot optional-property repair: `PASS_G2B_CLIENTSNAPSHOT_OPTIONAL_PROPERTY_REPAIR` at commit `50a6b02480df6554493fee59f1610486a9a239fe`.
- Reviewer inspection: optional registry strings are safely normalized; required fields remain fail-closed; branch-specific snapshot diagnostics are present; benchmark/DPAPI/Mihomo/final cleanup boundaries are unchanged.
- Formal G2-B samples remain WG 0 / HY2 0; no protocol-performance conclusion exists.
- Current Owner checkpoint: elevated PowerShell 7.6.6 `-PreflightOnly` only.
- Full benchmark remains blocked until that Owner High-integrity preflight is reviewed.



### G2-B control-path preflight — PASS

Owner/Executor read-back established a safe split control/data path before benchmarking:

- SSH control target: `10.66.21.1:22`
- SSH control route: existing WireGuard tunnel
- TCP/22 reachability: PASS
- SSH host-key trust: PASS (accepted host identity reused without auto-accepting a new key)
- VPS read-only probe: PASS
- target hostname: `ubuntu-s-1vcpu-512mb-10gb-sfo3`
- `wg-quick@wg0`: active
- `hysteria2-vpn-network-optimization.service`: active
- UDP 51820 listener: present
- UDP 8443 listener: present

G2-B should therefore keep:
- control plane: Codex → WireGuard → `10.66.21.1:22`
- HY2 data-plane candidate: localhost test proxy → WLAN → `24.199.118.137:8443`

Do not retry public-IP SSH during this Gate unless Reviewer explicitly changes the plan.


### G2-B DPAPI recovery reality correction — OWNER FRESH READBACK

Owner fresh read-back on the actual Windows host supersedes the earlier G2-A evidence that claimed the final DPAPI artifact existed.

Observed on 2026-10-02:
- expected directory `C:\Users\34707\AppData\Local\vpn-network-optimization\recovery` is missing;
- recursive search under `C:\Users\34707\AppData\Local` found no `hy2-g2a*.dpapi` artifact;
- therefore `C:\Users\34707\AppData\Local\vpn-network-optimization\recovery\hy2-g2a.dpapi` is NOT PRESENT on the actual Owner Windows host.

Reviewer consequence:
- treat the prior G2-A claim `DPAPI_FINAL_EXISTS=YES` as stale/false for current host reality;
- do not rerun or rotate VPS Secrets merely to repair this;
- create and verify a new Owner-host DPAPI CurrentUser recovery artifact from the existing VPS Secret material over the accepted WireGuard SSH control path before any G2-B client Secret use;
- no G2-B benchmark may continue until recovery reality is repaired and fresh-read on the actual Owner host.

#### DPAPI repair attempt — current blocker

A dedicated Owner repair runner was created and statically reviewed. Owner executed it in elevated PowerShell 7.6.6.

Observed result:

```text
SSH_NATIVE_EXIT_CODE=0
REMOTE_TRANSFER_RESULT=PASS
LOCAL_FINALIZATION_RESULT=FAILED
FINAL_PROMOTION_RESULT=NOT_PROMOTED
RUNNER_FAILURE_CLASS=RECOVERY_ACL_OWNER_OR_RULE_COUNT_INVALID
```

Owner then fresh-read the expected local paths and found:

```text
BaseExists=False
RecoveryExists=False
PendingExists=False
FinalExists=False
```

Interpretation:

- VPS Secret material does not need regeneration or rotation.
- SSH transport is not the current blocker.
- No partial local recovery artifact remains.
- The current blocker is the ACL creation/validation helper used by the recovery runner.
- The next attempt must first validate the ACL helper with non-secret fixture data; do not use real Secret material as ACL debug input.

### G2-B AppData path virtualization finding — OWNER FRESH READBACK

Owner searched Codex packaged-app storage and found:

- package root: `C:\Users\34707\AppData\Local\Packages\OpenAI.Codex_2p2nqsd0c76g0`;
- virtualized project directory: `...\LocalCache\Local\vpn-network-optimization`;
- virtualized recovery directory: `...\LocalCache\Local\vpn-network-optimization\recovery`;
- at least one `hy2-g2a*.dpapi` artifact under that virtualized recovery directory.

This matches the known Windows packaged-app path virtualization failure mode from prior projects. Until the exact artifact is read back and DPAPI-validated, do not classify the original G2-A write as either fully valid or fully missing. The correct current state is: standard Owner path not realized; virtualized artifact present; validation/reconciliation pending.

#### Virtualized artifact exact metadata/ACL — PASS

Owner fresh read-back on 2026-10-02:

- exact file: `C:\Users\34707\AppData\Local\Packages\OpenAI.Codex_2p2nqsd0c76g0\LocalCache\Local\vpn-network-optimization\recovery\hy2-g2a.dpapi`;
- name: `hy2-g2a.dpapi`;
- length: `1206` bytes;
- creation time: `2026-10-02 00:14:04`;
- last write time: `2026-10-02 00:14:04`;
- owner: `码头整来的薯条\34707`;
- inheritance protected: `True`;
- access rule count: `1`;
- sole ACE: current Owner FullControl / Allow / explicit / no inheritance.

This matches the original G2-A reported size and intended owner-only ACL. The remaining validation is DPAPI CurrentUser decrypt + accepted bundle validation + byte-identity round-trip, followed by canonical-path realization. Do not re-fetch or rotate the VPS Secrets unless that validation fails.

### ACL fixture result — helper bug isolated and fixed

Non-secret fixture run completed without accessing real Secret material or executing the real recovery runner.

Result:

```text
ACL_FIXTURE_CREATE=PASS
ACL_FIXTURE_READBACK=PASS
ACL_FIXTURE_VALIDATOR=PASS
ACL_FIXTURE_CLEANUP=PASS
RECOVERY_RUNNER_ACL_FIXED=YES
STATIC_REVIEW=PASS
REAL_SECRET_ACCESSED=NO
REAL_RECOVERY_RUNNER_EXECUTED=NO
```

Root cause: the old ACL helper conflated `Owner SID mismatch` with `ACE count != 1`. The fixture proved that multiple explicit ACEs can all belong to the current Owner and combine to FullControl, so a fixed ACE-count assertion was not a valid security boundary. The helper now validates owner SID, inheritance, each principal/type, and merged rights instead of requiring exactly one ACE.

Important limitation: the already-cleaned real failure cannot be retroactively classified to a specific old branch because the old error class did not expose branch detail.

Execution note: fixture ran in PowerShell 7.6.5 with Medium token. This is acceptable only as non-secret ACL diagnostic evidence; it is not a substitute for elevated Owner-path validation.

Newly discovered follow-up: `g2b-owner-runner.ps1` still has its own single-ACE-count ACL assertion. It must be patched/reviewed before any real G2-B run. The repair-runner ACL fix must not be assumed to cover the benchmark runner.

Plan impact: despite the repaired recovery runner being technically retry-ready, do NOT rerun it now. The virtualized 1206-byte DPAPI final artifact has been found and is the preferred source for local validation + canonical-path realization, avoiding unnecessary VPS Secret re-fetch.

### Virtualized artifact DPAPI/content validation — PASS

Executor performed local-only validation of the existing virtualized recovery artifact. No VPS Secret was accessed; no network state changed; benchmark was not started.

```text
VIRTUALIZED_SOURCE_VALIDATION=PASS
DPAPI_UNPROTECT=PASS
VPNHY2R1_PARSE=PASS
TLS_KEY_CERT_MATCH=PASS
TLS_SAN_MATCH=PASS
TLS_FINGERPRINT_MATCH=PASS
REAL_SECRET_ACCESSED_FROM_VPS=NO
NETWORK_CHANGED=NO
BENCHMARK_STARTED=NO
```

Conclusion: the original G2-A DPAPI final artifact is valid; the defect is path realization caused by Codex packaged-app virtualization, not Secret loss or bundle corruption.

A local-only path realization runner is prepared at `scripts/realize-owner-dpapi-path.ps1`. It has not been executed. Its purpose is to copy the already-encrypted source bytes into the canonical Owner AppData path and verify target ACL, DPAPI CurrentUser unprotect, parser validation, and byte identity without contacting the VPS.

### G2-B ACL validator repair — PASS STATIC

The independent ACL validator in `g2b-owner-runner.ps1` was patched to reject inherited rules, non-Owner principals, and Deny ACEs while aggregating Owner rights to FullControl; it no longer requires exactly one ACE.

```text
G2B_ACL_VALIDATOR_FIXED=YES
G2B_RUNNER_STATIC_REVIEW=PASS
```

Do not execute G2-B until canonical-path realization receives Owner-host fresh read-back PASS.

### Canonical-path realization integrity precheck — owner High confirmed

Owner fresh read-back from the same PowerShell 7.6.6 window used to execute `realize-owner-dpapi-path.ps1`:

```text
WindowsPrincipal.IsInRole(Administrator)=True
Mandatory Label\High Mandatory Level
INTEGRITY_SID=S-1-16-12288
```

Therefore the runner failure `HIGH_INTEGRITY_TOKEN_REQUIRED` is a false negative in the runner's integrity precheck, not a lack of elevation. The script stopped before creating either pending or target artifact (`PENDING_EXISTS=NO`, `TARGET_EXISTS=NO`).

Next action: fix only the integrity-level detection in `realize-owner-dpapi-path.ps1` using the same accepted token-integrity method already used for the corrected G2-B runner; do not weaken other prechecks, do not execute the path runner during the fix, and do not start G2-B.


### Canonical Owner DPAPI path realization — PASS

Owner executed the local-only path realization runner from elevated PowerShell 7.6.6. The canonical Owner path is now realized and validated.

```text
OWNER_WINDOWS_TARGET=CONFIRMED
DPAPI_SCOPE=CurrentUser
SOURCE_RETAINED=YES
SOURCE_TARGET_ENCRYPTED_BYTES=BYTE_IDENTICAL
TARGET_OWNER_ONLY_ACL=PASS
TARGET_DPAPI_ROUNDTRIP=PASS
TARGET_VPNHY2R1_VALIDATION=PASS
PENDING_EXISTS=NO
PLAINTEXT_TEMP_FILES_CREATED=0
SECRET_VALUES_EMITTED=0
```

Reviewer consequence: the packaged-app AppData path-realization defect is closed. No VPS Secret re-fetch or rotation is required. The virtualized source remains retained for now. G2-B is now ready to proceed to the planned same-window benchmark; no protocol-performance conclusion exists until that benchmark completes.


### G2-B runner precheck — PRECHECK_ROUTE_AND_ADAPTERS CimJobException

Owner executed `g2b-owner-runner.ps1` from elevated PowerShell 7.6.6. Administrator and High integrity checks passed (`INTEGRITY_RID=12288`), but the runner failed closed during `PRECHECK_ROUTE_AND_ADAPTERS` with `CimJobException` before any benchmark samples were produced.

```text
ADMINISTRATOR_TOKEN=YES
INTEGRITY_RID=12288
RUNNER_FAILED_PHASE=PRECHECK_ROUTE_AND_ADAPTERS
RUNNER_FAILURE_TYPE=CimJobException
CURRENT_WINDOW_RESULT=INCONCLUSIVE
G2B_OWNER_RUNNER_RESULT=FAIL_CLOSED
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
```

Current interpretation: this is a local Windows route/adapter precheck implementation/runtime issue, not a protocol-performance result. Formal G2-B samples remain WG 0 / HY2 0. Before rerun, fresh-read the temporary host route and the WLAN/WireGuard adapter state from the same Owner shell, and isolate which read-only NetTCPIP/NetAdapter query throws the CIM exception. Do not start benchmark or change network state until that is identified.


### G2-B route/adapter fresh read-back — PASS

Owner reran the exact underlying Windows read-only queries from the same elevated PowerShell 7.6.6 shell after the runner's `PRECHECK_ROUTE_AND_ADAPTERS` CimJobException.

Observed:

```text
TEMP_ROUTE=24.199.118.137/32 -> 192.168.1.1 via WLAN ifIndex 18 metric 1
WLAN_ADAPTER=Up; Realtek 8852CE WiFi 6E PCI-E NIC; ifIndex 18
WLAN_IPV4=192.168.1.4
WLAN_DEFAULT_GATEWAY=present
WIREGUARD_ADAPTER=SFO2-A; WireGuard Tunnel; ifIndex 13; Up
```

All four direct commands (`Get-NetRoute`, `Get-NetAdapter` for WLAN, `Get-NetIPConfiguration` for WLAN, and `Get-NetAdapter` for `SFO2-A`) completed successfully. Therefore the network state required by G2-B is present and healthy; the prior `CimJobException` is attributable to the runner's precheck implementation or composition, not to a missing route, down adapter, or lack of elevation. Formal G2-B samples remain WG 0 / HY2 0.

Next action: fresh-read the local uncommitted `g2b-owner-runner.ps1`, identify the exact statement inside `PRECHECK_ROUTE_AND_ADAPTERS` that can throw `CimJobException`, add branch-specific diagnostics, and fix only that precheck. Do not start benchmark during the fix.

### Reviewer Decision — G2-B bounded diagnostic/source persistence

- Decision: `PASS_G2B_BOUNDED_DIAGNOSTIC_AND_SOURCE_PERSISTENCE`.
- Accepted commit: `243c5eeb5833f25566ea49463b84b93b5063ad14`.
- Reviewer fresh-read inspected the commit, canonical `g2b-owner-runner.ps1`, `EXECUTION_EVIDENCE.md`, `EXECUTOR_HANDOFF.md`, and the persisted recovery-runner source identities.
- Commit scope is project-owned only: the accepted commit itself changes exactly the two executor records plus the three runner files. Unrelated repository commits between the pre-Gate base and accepted commit are not part of this Gate.
- Root-cause confidence boundary: the exact `PersistentStore` no-match `CimJobException` was reproduced in Codex Medium-integrity runtime and the repair is narrowly scoped; the original Owner High-integrity failure lacked subcheck detail, so Owner `-PreflightOnly` remains required before the full benchmark.
- No benchmark, Mihomo start, DPAPI Secret access, or network mutation is accepted as having occurred in this Gate.

### Owner High PreflightOnly — RETURN_PROPERTY_NOT_FOUND

Owner executed the canonical `g2b-owner-runner.ps1 -PreflightOnly` from repository root using PowerShell 7.6.6, Administrator token, High integrity RID 12288.

Observed:

```text
RUNNER_FAILED_PHASE=PRECHECK_WIREGUARD_AND_CLIENT_STATE
SUBCHECK=PRECHECK_WIREGUARD_AND_CLIENT_STATE
NON_SECRET_ERROR_CLASS=PropertyNotFoundException
CONSEQUENTIAL_MUTATION_STARTED=NO
CURRENT_WINDOW_RESULT=INCONCLUSIVE
G2B_OWNER_RUNNER_RESULT=FAIL_CLOSED
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
```

Reviewer interpretation: the previous route/adapter failure is no longer the active blocker. This new failure occurred before Secret access, Mihomo, benchmark, or cleanup-eligible network mutation. Because the phase lacks branch-specific detail, exact cause remains unproven. Fresh source review narrows the next diagnostic to `Get-ClientSnapshot` and its optional property reads; do not patch from inference alone.

### Reviewer Decision — G2-B ClientSnapshot optional-property repair

- Decision: `PASS_G2B_CLIENTSNAPSHOT_OPTIONAL_PROPERTY_REPAIR`.
- Accepted commit: `50a6b02480df6554493fee59f1610486a9a239fe`.
- Reviewer fresh-read inspected the exact commit diff, canonical runner, `EXECUTION_EVIDENCE.md`, and `EXECUTOR_HANDOFF.md`; the candidate was current `main` at inspection, after which Reviewer advanced `main` only with the acceptance Handoff update.
- Exact commit changes only the runner and the two Executor-owned records. Intervening unrelated repository commits are not part of this Gate and do not alter the reviewed VPN candidate.
- The fix preserves StrictMode, keeps `ProxyEnable` and required service/WireGuard/route state fail-closed, and normalizes only the three optional proxy strings.
- Owner `-PreflightOnly` was intentionally not executed by Executor. Full benchmark remains blocked until Owner High-integrity preflight succeeds and Reviewer accepts the read-back.
