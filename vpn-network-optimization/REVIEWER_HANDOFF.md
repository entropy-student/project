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
GATE_ID=G4B_POST_R22_P7_COMPLETE_OFFLINE_REPAIR_AUDIT_R6R2L_R22R6
STATE=OWNER_OFFLINE_REPAIR_VALIDATION_REQUIRED
PREVIOUS_RESULT=PASS_R22R5_FAILED_RUN_RESIDUE_CLEAN
OBJECTIVE=Repair and regression-test every offline-detectable defect class exposed by R21/R22 before any fresh live Gate.
MAX_ENDPOINT_THIS_ROUND=Runner/validator/package offline source repair and fixtures only; no live/external action.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=P7 readiness polling; rollback systemd diagnostics/postconditions; firewall counter normalization; future one-shot Gate binding contract.
APPLICABLE_CRITICAL_CONSTRAINTS=R20/R21/R22 consumed/no replay; R22 failed-run residue clean; REALITY runtime absent; WG/HY2 healthy; rollback journal retained historical evidence; no fresh live Gate until R22R6 formal PASS.
PREFLIGHT=Canonical main; R22R6 source repair commit 1034d52a7eeb449759b6e87557ad2545d339b5ec; runner blob 2f62064c4057803c3116fa428370fa1ad48bbb76; live validator blob 8aaecac4c873e8a3e112fd5f8da0fa587ed443da; audit validator blob 1e02c0605bc783c142826822b4deaef2f0e5d11c; offline-only temporary worktree required.
REQUIRED_EVIDENCE=AST runner/validator; delayed-readiness positive; readiness timeout negative; service-inactive negative; listener ownership negative; restart-readiness reuse; rollback systemd postcondition fixtures; iptables counter-only positive and semantic-drift negative; package validator; R19R1 parser regression; zero external action.
ACCEPTANCE_CRITERIA=Formal PASS only when all required offline regressions pass and Reviewer verifies the diff is bounded to the audited defect classes.
ROLLBACK_STATUS_OR_PLAN=Source-only rollback to locked pre-repair blobs if offline validation fails.
OWNER_ONLY_ACTIONS=Run the bounded local offline repair/validation checkpoint supplied by Reviewer when released; no SSH/VPS/provider/Secret/DPAPI/Clash/network action.
REVIEWER_TO_EXECUTOR_RELAY=Do not release or invoke a fresh live Gate inside R22R6.
EXECUTOR_TO_REVIEWER_RELAY=Run the locked repaired sources offline and return AST/live-fixture/audit-fixture/package markers plus proof of zero external action.
R22_RESULT=RETURN_R22_P7_REALITY_LISTENER_READBACK_INVALID_ROLLBACK_UNKNOWN
R22R5_RESULT=PASS
R22_FAILED_RUN_RESIDUE=CLEAN
R22R6_SOURCE_REPAIR_COMMIT=1034d52a7eeb449759b6e87557ad2545d339b5ec
R22R6_RUNNER_BLOB=2f62064c4057803c3116fa428370fa1ad48bbb76
R22R6_LIVE_VALIDATOR_BLOB=8aaecac4c873e8a3e112fd5f8da0fa587ed443da
R22R6_AUDIT_VALIDATOR_BLOB=1e02c0605bc783c142826822b4deaef2f0e5d11c
FRESH_LIVE_GATE_RELEASED=NO
OWNER_STANDING_AUTHORIZATION=GRANTED_FOR_DOCUMENTED_ROADMAP
```

R20, R21 and R22 are consumed and must never be replayed. R22 failed-run residue is clean. Current work is the complete offline repair audit above; no fresh live Gate exists yet.

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
- Current execution channel is Owner-local Windows PowerShell 7.6.6, Administrator + High integrity, running only the R22R1 read-only reconciliation helper.
- R22 is consumed. Owner must not rerun R22, invoke rollback mode, or perform manual remote cleanup before Reviewer classifies R22R1.
- Local paths are never source authority; each consequential run safe-syncs to GitHub `main` and verifies the exact Gate/runner/validator blobs before mutation.

## CURRENT_ROLLBACK_STATUS

- Standalone Windows WireGuard remains the active production/rollback baseline and must stay enabled through R22R1 and G4-C.
- Accepted pre-R21 state has WG and HY2 healthy; system proxy OFF and Clash TUN OFF.
- The consumed R20 attempt is closed: remote consequential residue, transaction residue, and failed-run recovery pending artifacts are clean; recovery finals are absent.
- The retained R20 rollback journal is historical evidence only and is out of scope for R21; it must not be reused or deleted by R21.
- R21 is consumed at P0 with no consequential mutation. R22 is consumed at P7 after consequential mutation; its rollback journal and recovery pending artifacts are retained because automatic rollback could not be verified. Persistent REALITY/profile state is not accepted.
- R22 already returned rollback UNKNOWN. Only R22R1 read-only reconciliation is allowed now; no second live invocation and no manual rollback/cleanup.

## UNRESOLVED

- G4-B remains **IN_PROGRESS** because R22 ended at P7 with rollback UNKNOWN and R22R1 reconciliation is pending.
- R22 is consumed at P7. Automatic rollback is UNKNOWN, so all mutation remains frozen until R22R1 classifies actual residue/baseline state.
- Persistent REALITY backup service and persistent `SELF-VPN-V1` remain unaccepted. P10 was never reached, so no accepted three-role profile import exists.
- G4-C remains pending until G4-B is recovered and formally PASS; it is limited to the Owner-approved three-role manual ChatGPT conversation smoke.
- G4-D remains pending after G4-C: migrate WG-BASELINE into native Clash/Mihomo WireGuard; standalone Windows WireGuard may be disabled only after formal G4-D PASS.
- Final v1 production default/control posture, final WireGuard routing/kill-switch policy, and MVP v1 seal remain pending.
- G3-B fresh-target live migration rehearsal remains deferred.

## NEXT_STEP

Owner runs the single R22R1 read-only reconciliation helper. Reviewer then classifies the state as CLEAN, PROJECT_RESIDUAL_PRESENT, or AMBIGUOUS_BASELINE and designs the next bounded Gate. No rollback, cleanup, provider mutation, or new live Gate occurs inside R22R1.

## OWNER_ACTION_REQUIRED

Run the exact R22R1 helper once in Administrator PowerShell 7.6.6 using the existing DigitalOcean SSH private key. Do not enter Baidu UID or recovery passphrase; the helper must not request either. Return only its sanitized output to Reviewer.

## EVIDENCE_POINTERS

Read only what is needed for the current R22R1 decision:

- `docs/G4B_R22_P7_ROLLBACK_UNKNOWN_READONLY_R6R2L_R22R1.md` — current read-only reconciliation Gate.
- `scripts/g4b-r22-readonly-reconciliation.ps1` — current read-only helper, blob `5ecb62fe2a1d544db4ea198a7cb3c4df3c5e00f9`.
- `docs/G4B_R22_P7_RETURN_REVIEW_R6R2L_R22.md` — formal consumed R22 P7 rollback-unknown return.
- `docs/G4B_PERSISTENT_THREE_ROLE_LIVE_AFTER_R21R2_R6R2L_R22.md` — consumed historical R22 Gate; never replay.
- `docs/G4B_R21_P0_AUTH_BINDING_REPAIR_R6R2L_R21R2_REVIEW.md` — historical R21R2 PASS.
- `EXECUTION_EVIDENCE.md` — append-only historical proof through R20R6; later R21/R22 proof uses dedicated Reviewer records to avoid large-file rewrites.
- `README.md -> Canonical current state` — compact snapshot after synchronization.
- `DECISION_LOG.md` — architecture and Owner-approved final validation scope.
- Older Gates and `EXECUTOR_HANDOFF.md` are historical/supporting material only; do not let them override `CURRENT_GATE`.
