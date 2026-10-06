# VPN Network Optimization — REVIEWER HANDOFF

> Maintainer: Reviewer only  
> Governance: `entropy-student/spike.skill/vps-project-governance/VNEXT.md` v0.2.7 / ACTIVE_PROVISIONAL  
> Canonical branch: `main`  
> Detailed chronology: `docs/REVIEWER_TRANSITION_2026-10-05.md`  
> Detailed proof: `EXECUTION_EVIDENCE.md`

## PROJECT_GOAL

建立一套可迁移、可验证、可回滚的自建 VPN 优化标准，重点改善 Codex / OpenAI / AI 生图等长任务的稳定性和尾部表现。WireGuard 当前仍是生产/回退基线；HY2 是当前 G3-C 真实 Clash 控制面验证对象；REALITY 是已验证的 TCP/443 兼容候选。

## PROJECT_STAGE

```text
P0 Research / Scope                         PASS
G1 Foreground-safe Foundation               PASS
G2 Multi-path candidate validation          PASS
G3-A Health/readiness/advisory              PASS
G3-B Migration package D1-D3                PASS_OFFLINE
G3-C Manual-control contract C1             PASS
G3-C Synthetic UI package C2A               PASS
G3-C Synthetic Clash UI canary C2B          PASS
G3-C Real C2C package + scanner repair      PASS
G3-C Secret Prepare real-host verification  PASS
G3-C Real HY2-in-Clash canary R3R2          PASS
G4-A Three-role target/offline package          PASS
G4-B0 Windows interface bypass canary            PASS
G4-B Persistent three-role readiness             IN_PROGRESS
G4-C Three-role ChatGPT switching smoke          PENDING
G4-D WireGuard-in-Clash migration                 PENDING
MVP v1 seal                                       PENDING
```

## SYSTEM_MAP

```text
Windows Owner host
├─ Production / rollback: WireGuard
│  ├─ IPv4 coverage: 0.0.0.0/1 + 128.0.0.0/1
│  ├─ active MTU: 1420
│  └─ current self-hosted VPS: DigitalOcean 24.199.118.137 / sfo3
├─ Clash Verge 2.5.6
│  └─ local SOCKS5 listener must be dynamically discovered
│     └─ D5 observed 127.0.0.1:7900, but port 7900 is NOT a hardcoded contract
├─ HY2 candidate
│  ├─ server: Hysteria2 v2.12.3
│  ├─ UDP/8443
│  └─ current C2C Owner Mihomo validation baseline: v1.19.32
└─ REALITY candidate
   └─ historical G2-C interoperability baseline: Mihomo v1.19.31
```

## CURRENT_ACCEPTED_STATE

### Transport and architecture

- WireGuard is the production and rollback baseline.
- HY2 passed the historical same-window 60/60 comparison against WireGuard and showed better median/tail behavior in that accepted sample.
- VLESS + REALITY + Vision passed private implementation A/B and public TCP/443 canary; it remains a compatibility candidate, not the current active G3-C target.
- G3-A sensing/readiness/advisory automation is complete; no automatic network-switch actuator is authorized.
- G3-B migration package D1-D3 is complete offline; fresh-target live rehearsal remains deferred.
- G3-C synthetic manual-control/UI behavior is accepted.
- G3-C R3R2 real HY2-in-Clash canary is formally PASS: the bounded OpenAI request used the explicit Clash proxy path, the public-exit check matched the accepted SFO3 exit, and final cleanup/read-back restored the WireGuard/network/profile baseline.
- Owner target v1 role order is now HY2-SFO3 PRIMARY, WG-BASELINE BACKUP_1, REALITY-SFO3 BACKUP_2. This order is frozen for G4 validation but is not yet a production-role PASS.
- G4-A offline plan/package is PASS. G4-B0 is now formally PASS: on the current Owner Windows host, Mihomo `interface-name` carried HY2 traffic over the dynamically discovered physical interface while WireGuard remained connected and exact active/persistent VPS `/32` routes stayed absent. The OpenAI probe returned HTTP 401 through the proxy, the public-exit probe matched the accepted SFO3 exit, request count was exactly 2, and final cleanup restored baseline. G4-B persistent implementation may now proceed to offline runner/package work without designing a persistent `/32` route solely for HY2. This does not yet prove REALITY client-path behavior or production-role acceptance.
- G4-B Baidu recovery and provider reconciliation through R18 is formally accepted; R19 returned safely before remote consequential mutation, R19R1 repaired the executable Mihomo path, and the consumed R20 live attempt has been fully reconciled: consequential VPS residue and failed-run recovery pending artifacts are clean, while its rollback journal is retained as historical evidence only. R20R6 formally repaired bounded remote error propagation and rollback diagnostics. R21 returned safely at P0 before consequential mutation because a stale authorization-field binding remained. R21R2 is now formally PASS after the exact +7/-5 two-file repair, PowerShell AST, live fixtures, package validation, and Reviewer diff inspection. R20 and R21 are both consumed and must never be replayed. The only current live Gate is R22, authorized for exactly one fresh invocation; persistent REALITY and `SELF-VPN-V1` remain unaccepted until R22 formally PASSes.

### Secret / recovery

- Secret values never enter GitHub/chat/ordinary logs/handoff.
- Accepted recovery metadata: `%LOCALAPPDATA%\vpn-network-optimization\recovery\hy2-g2a.dpapi`, DPAPI CurrentUser, accepted `VPNHY2R1` bundle.
- Do not re-fetch or rotate the HY2 credential to continue C2C.
- R2R3V2 proved real Owner-host DPAPI unprotect, bundle/auth validation, certificate fingerprint match, temporary Owner-only profile creation, Mihomo parse, immediate VerifyCleanup, and zero residue.

### Accepted C2C repair

Historical blocker `SECRET_SCAN_READ_FAILED` was localized to transient contention on one Clash-app root-level zero-byte `.lock`.

Accepted scanner policy:

- no generic `.lock` bypass;
- no generic unreadable-file bypass;
- exception activates only **after an actual read exception** in the Clash-app scan;
- fresh metadata must prove the failing item is a direct root child, `.lock`, zero-byte, normal file, and non-reparse;
- project-runtime scanning has no exception and remains strict;
- every other unreadable-file case remains fail-closed.

R2R3 Owner validation passed Fixtures A-L, PowerShell AST parse and Mihomo fixture parse. R2R3V2 then behaviorally verified real Secret Prepare + immediate cleanup on the Owner host.

### Locked current C2C identities

```text
ORCHESTRATOR_BLOB=4424eab2f281af6398f6d7bfbe6e326bce5f7904
SECRET_HELPER_BLOB=81c5a43d4a947d57e44752fd7a09c59e735748e2
PROXY_PROBE_BLOB=d3403cba9196b55083ff9f443e9011582ef9cc01
VALIDATOR_BLOB=e520fa7b6c08b2e46365b55ec731a20bdb810c04
TEMPLATE_BLOB=ea18bdccf8f00f2d6d705e4ba34ba57db243722a
PACKAGE_BLOB=d9e815171d8d7b00722b213b6df6d52c46f6265e
```

Do not silently substitute historical C2C blobs from old Evidence or Executor sections.

## CURRENT_GATE

```text
GATE_ID=G4B_R22_P7_ROLLBACK_UNKNOWN_READONLY_R6R2L_R22R1
STATE=OWNER_READONLY_RECONCILIATION_REQUIRED
PREVIOUS_RESULT=RETURN_R22_P7_REALITY_LISTENER_READBACK_INVALID_ROLLBACK_UNKNOWN
OBJECTIVE=Read-only reconcile the consumed R22 P7 rollback-unknown state before any cleanup or further live action.
MAX_ENDPOINT_THIS_ROUND=One bounded local metadata read plus one strict SSH read-only diagnostic; no mutation.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=R22 retained rollback journal, local recovery/runtime presence, remote REALITY service/listener/project residue, WG/HY2, route/firewall/service baseline.
APPLICABLE_CRITICAL_CONSTRAINTS=R22 consumed/no replay; consequential mutation started; automatic rollback UNKNOWN; no manual rollback; retained journal/pending artifacts untouched.
PREFLIGHT=Canonical main; R22R1 Gate current; helper tracked; PowerShell 7.6.6; SSH identity/known_hosts available.
REQUIRED_EVIDENCE=R22R1 helper bounded markers ending in RECONCILIATION_STATE and STOP_AT_REVIEWER=YES.
ACCEPTANCE_CRITERIA=This Gate never passes G4-B; it only classifies CLEAN, PROJECT_RESIDUAL_PRESENT, or AMBIGUOUS_BASELINE for the next Reviewer Gate.
ROLLBACK_STATUS_OR_PLAN=Not applicable; read-only only.
OWNER_ONLY_ACTIONS=Run exactly one R22R1 read-only checkpoint; do not run R22 or rollback.
REVIEWER_TO_EXECUTOR_RELAY=Use only scripts/g4b-r22-readonly-reconciliation.ps1; do not read Secret contents or mutate remote/local/provider state.
EXECUTOR_TO_REVIEWER_RELAY=Return sanitized R22R1 markers only.
R22_RESULT=RETURN_R22_P7_REALITY_LISTENER_READBACK_INVALID_ROLLBACK_UNKNOWN
R22_LIVE_INVOCATIONS_CONSUMED=1
SECOND_R22_LIVE_INVOCATION_AUTHORIZED=NO
CONSEQUENTIAL_MUTATION_STARTED=YES
REMOTE_ROLLBACK=UNKNOWN_REQUIRES_RECONCILIATION
CURRENT_HELPER=scripts/g4b-r22-readonly-reconciliation.ps1
OWNER_STANDING_AUTHORIZATION=GRANTED_FOR_DOCUMENTED_ROADMAP
```

R20, R21 and R22 are consumed and must never be replayed. Current work is the read-only R22R1 reconciliation shown above.

## OWNER-UPDATED FINAL VALIDATION SCOPE — 2026-10-06

```text
OWNER_FINAL_G4_VALIDATION_SCOPE=CHATGPT_THREE_ROLE_SMOKE_ONLY
G4C_REQUIRED_ROLES=HY2_SFO3,WG_BASELINE,REALITY_SFO3
G4C_ACCEPTANCE=EACH_ROLE_MANUALLY_SELECTED_IN_CLASH_AND_CAN_CONTINUE_NORMAL_CHATGPT_CONVERSATION
G4C_HEAVY_BENCHMARKS=NOT_REQUIRED
G4C_CODEX_WORKLOAD_MATRIX=NOT_REQUIRED
G4C_IMAGE_GENERATION_MATRIX=NOT_REQUIRED
G4C_P95_P99_COMPARISON=NOT_REQUIRED
G4D_OBJECTIVE=MIGRATE_WIREGUARD_FROM_WINDOWS_CLIENT_TO_CLASH_MIHOMO_INTERNAL_NODE
WINDOWS_WIREGUARD_MAY_BE_DISABLED_ONLY_AFTER_G4D_FORMAL_PASS=YES
FINAL_CONTROL_PLANE=CLASH_VERGE
```

Owner explicitly narrowed final workload validation: existing performance evidence is sufficient. G4-C is now a functional smoke only—manually select HY2, WG and REALITY in Clash one at a time and prove normal ChatGPT conversation remains usable on each. After that, G4-D moves WireGuard into Clash/Mihomo so the standalone Windows WireGuard client can be disabled. This scope change affects future Gates only; current R19R1 remains unchanged.

## CRITICAL_CONSTRAINTS

- Target v1 role order is HY2 PRIMARY, WG BACKUP_1, REALITY BACKUP_2.
- The target order is an Owner decision, not yet a technical production-role PASS.
- WireGuard remains the current production/rollback baseline until G4 acceptance and v1 sealing.
- Existing HY2 service must remain healthy through G4-B.
- Persistent REALITY deployment is a new consequential public-service/Secret boundary and requires fresh Owner authorization.
- No automatic switching.
- G4-B ends with system proxy OFF and TUN OFF.
- G4-C real workloads are not part of G4-B.
- Secret values/hashes/raw credential material never enter GitHub/chat/ordinary logs/Handoff/Evidence.
- Any failed/ambiguous live G4-B attempt is reconciled before retry.
- G3-B fresh-target live migration rehearsal remains deferred.

## DEFAULT_EXECUTION_CHANNEL

- Reviewer may directly perform normal repository/document/source reconciliation inside the accepted project boundary.
- Current consequential execution channel is Owner-local Windows PowerShell 7.6.6, Administrator + High integrity, using the R22 runner locked by blob.
- R22 is one-shot. Owner must not improvise a fallback, second invocation, or manual rollback after a RETURN/ambiguity.
- Local paths are never source authority; each consequential run safe-syncs to GitHub `main` and verifies the exact Gate/runner/validator blobs before mutation.

## CURRENT_ROLLBACK_STATUS

- Standalone Windows WireGuard remains the active production/rollback baseline and must stay enabled through R22 and G4-C.
- Accepted pre-R21 state has WG and HY2 healthy; system proxy OFF and Clash TUN OFF.
- The consumed R20 attempt is closed: remote consequential residue, transaction residue, and failed-run recovery pending artifacts are clean; recovery finals are absent.
- The retained R20 rollback journal is historical evidence only and is out of scope for R21; it must not be reused or deleted by R21.
- R21 is consumed at P0 with no consequential mutation and no rollback required. R22 has not yet executed, so no R22 rollback journal or persistent REALITY/profile state is accepted yet.
- On R22 failure after mutation, runner-owned bounded rollback may execute; any failure/ambiguity/UNKNOWN returns to Reviewer with no second invocation and no manual rollback.

## UNRESOLVED

- G4-B remains **IN_PROGRESS** solely because R21 has not yet been executed and formally reviewed.
- R21R2 is formally PASS. R22 is released for exactly one fresh live invocation; consumed count is 0 and a second R22 invocation is forbidden.
- Persistent REALITY backup service and persistent `SELF-VPN-V1` are still unaccepted until formal R22 PASS.
- G4-C remains pending after formal R21 PASS and is limited to the Owner-approved three-role manual ChatGPT conversation smoke.
- G4-D remains pending after G4-C: migrate WG-BASELINE into native Clash/Mihomo WireGuard; standalone Windows WireGuard may be disabled only after formal G4-D PASS.
- Final v1 production default/control posture, final WireGuard routing/kill-switch policy, and MVP v1 seal remain pending.
- G3-B fresh-target live migration rehearsal remains deferred.

## NEXT_STEP

Owner executes exactly one R22 Administrator PowerShell 7.6.6 live checkpoint using runner blob `3b02e6753fabea74ef53ce4b2f85778954bdf42b`. At P10 import only the exact generated profile without activation. Return sanitized output to Reviewer; do not run a second R22 attempt.

## OWNER_ACTION_REQUIRED

Run exactly one R22 live checkpoint under the standing documented authorization. Keep Baidu identity, SSH key path and recovery passphrase local. Keep standalone Windows WireGuard enabled. At P10 import only the generated profile and do not activate/switch it. If the run returns failure or ambiguity, do not retry and do not manually invoke rollback.

## EVIDENCE_POINTERS

Read only what is needed for the current R22 decision:

- `docs/G4B_PERSISTENT_THREE_ROLE_LIVE_AFTER_R21R2_R6R2L_R22.md` — current fresh one-shot live Gate.
- `docs/G4B_R21_P0_AUTH_BINDING_REPAIR_R6R2L_R21R2_REVIEW.md` — formal R21R2 PASS and locked repaired source identities.
- `docs/G4B_R21_P0_AUTH_BINDING_REPAIR_R6R2L_R21R2.md` — historical bounded offline repair Gate.
- `docs/G4B_R21_P0_RETURN_REVIEW_R6R2L_R21.md` — formal consumed R21 P0 RETURN with no consequential mutation.
- `docs/G4B_PERSISTENT_THREE_ROLE_LIVE_AFTER_R20R6_R6R2L_R21.md` — consumed historical R21 Gate; never replay.
- `EXECUTION_EVIDENCE.md` — append-only historical execution proof through R20R6; later R21/R21R2 proof uses dedicated Reviewer records to avoid large-file rewrites.
- `README.md -> Canonical current state` — compact snapshot after synchronization.
- `DECISION_LOG.md` — architecture and Owner-authorized role/final-validation decisions when rationale is needed.
- Older Gates and `EXECUTOR_HANDOFF.md` are historical/supporting material only; do not let them override `CURRENT_GATE`.
