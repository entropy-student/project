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
G2-A DPAPI recovery closure          VIRTUALIZED ARTIFACT VERIFIED METADATA/ACL / ROUNDTRIP PENDING
G2-B benchmark                       NOT STARTED (0 formal samples)
CURRENT BLOCKER                      Realize validated DPAPI artifact into canonical Owner path
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

- Standard Owner path `C:\Users\34707\AppData\Local\vpn-network-optimization\recovery\hy2-g2a.dpapi` is absent. Owner found the exact virtualized final artifact at `C:\Users\34707\AppData\Local\Packages\OpenAI.Codex_2p2nqsd0c76g0\LocalCache\Local\vpn-network-optimization\recovery\hy2-g2a.dpapi`.
- Exact Owner read-back now matches the historical G2-A metadata: filename `hy2-g2a.dpapi`, length 1206 bytes, creation/write time 2026-10-02 00:14:04, owner `码头整来的薯条\34707`, inheritance protected, exactly one explicit ACE granting that owner FullControl. This strongly confirms the original G2-A write landed in Codex packaged-app LocalCache rather than the canonical Owner AppData path. Current classification: `PATH_VIRTUALIZATION_CONFIRMED / METADATA+ACL_MATCH / DPAPI_ROUNDTRIP_PENDING`.
- Do not rotate or regenerate VPS HY2 Secrets merely to repair this path-reality defect.
- The previous repair runner attempt successfully completed SSH transport from the VPS (`SSH_NATIVE_EXIT_CODE=0`, `REMOTE_TRANSFER_RESULT=PASS`) but failed locally before final promotion with `RECOVERY_ACL_OWNER_OR_RULE_COUNT_INVALID`; this failure is now treated as secondary until the virtualized artifact is fully inspected.
- Immediate next action: validate the virtualized artifact with DPAPI CurrentUser unprotect + accepted `VPNHY2R1` parser/byte-identity checks, then realize the same encrypted artifact into the canonical Owner AppData path with owner-only ACL and fresh round-trip. No VPS Secret re-fetch is needed if source validation passes.

G2-B benchmark status:

- WireGuard benchmark samples completed: `0`.
- HY2 benchmark samples completed: `0`.
- HY2 real client handshake tested in G2-B: `NO`.
- No G2-B performance conclusion exists yet.
- Do not claim HY2 is better/worse/equivalent until same-window data exists.

## 1. Project Goal

- Final goal: 建立一套可迁移、可验证、可回滚的自建 VPN 优化标准，提高 Codex / OpenAI / AI 生图等长任务的稳定性与尾部表现，并可快速复用于不同 VPS。
- Current goal: 修复并 fresh-verify Owner Windows DPAPI recovery，随后在已确认安全窗口内完成 WireGuard vs Hysteria2 同窗口低干扰 A/B；在 recovery 修复前不得开始 benchmark。
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
G2-A DPAPI recovery closure          ⚠ PATH VIRTUALIZATION CONFIRMED / VERIFY
G2-B Safe-window Validation + Seal   ⏸ BLOCKED BEFORE BENCHMARK
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

## 12. Next Step

1. Do not rerun the real DPAPI repair runner and do not rotate/regenerate VPS Secrets.
2. Virtualized artifact validation is COMPLETE: DPAPI CurrentUser unprotect, `VPNHY2R1` parse, TLS key/cert match, SAN match, and pinned fingerprint match all PASS; no VPS Secret was accessed.
3. `g2b-owner-runner.ps1` independent ACL validator is FIXED and static review PASS; it no longer relies on a fixed ACE count.
4. Owner now runs `scripts/realize-owner-dpapi-path.ps1` in elevated PowerShell 7.6.6 to copy the already-encrypted validated artifact into canonical path `C:\Users\34707\AppData\Local\vpn-network-optimization\recovery\hy2-g2a.dpapi` and perform target ACL + DPAPI round-trip read-back.
5. Do not delete the virtualized source during this step; do not re-fetch Secrets from the VPS.
6. After canonical-path fresh read-back PASS, resume `g2b-owner-runner.ps1`.
7. G2-B then performs WG 60×5s → HY2 real handshake → HY2 60×5s → comparison → Secret runtime cleanup → exact temporary route cleanup → production WireGuard read-back.
8. Do not run MTU/BBR/fq/GRO/sysctl tuning in this round.

## 13. Status Summary

- Overall: P0 PASS, G1 PASS, HY2 server-side G2-A PASS.
- DPAPI reality: the canonical Owner AppData path is absent, but a matching recovery artifact has been found under Codex packaged-app `LocalCache\Local\...` virtualization.
- Current classification: `PATH_VIRTUALIZATION_CONFIRMED / VIRTUALIZED ARTIFACT FULLY VALIDATED / CANONICAL PATH REALIZATION PENDING`, not `SECRET LOST`.
- Current Gate: G2-B remains blocked only until the already-validated virtualized artifact is realized and fresh-read at the canonical Owner path.
- Formal G2-B samples so far: WG 0 / HY2 0. No protocol-performance conclusion exists.
- Server state: WireGuard active on UDP 51820; Hysteria2 v2.12.3 active on UDP 8443.
- Control path: SSH via WireGuard to `10.66.21.1:22` PASS.
- Candidate data path: WLAN direct to `24.199.118.137:8443` prepared via the Owner-created temporary ActiveStore /32 route.
- Immediate next action: Owner runs the prepared local-only canonical-path realization runner in elevated PowerShell 7.6.6. The virtualized source has already passed DPAPI/VPNHY2R1/TLS validation, and the independent G2-B ACL validator has been fixed + statically reviewed.
- No live MTU/BBR/fq/GRO/sysctl tuning has been applied.


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
