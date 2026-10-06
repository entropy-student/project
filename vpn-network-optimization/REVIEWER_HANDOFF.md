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
- G4-B Baidu recovery/provider preparation through **R18**, plus R19/R19R1, remains the last trusted execution anchor for takeover. R18 independently proved the production recovery namespace clean; R19 returned before persistent remote mutation; R19R1 behaviorally repaired the HY2 certificate-fingerprint renderer and passed the installed Mihomo parse regression.
- By explicit Owner takeover decision on 2026-10-06, **R20 and later material is reference-only until independently re-proven**. R20/R21/R22 execution-state, cleanup, authorization and later live-runner acceptance claims are not used as current truth. Their source changes may be selectively reused only after fresh Reviewer inspection/testing.
- Persistent REALITY and `SELF-VPN-V1` remain **UNACCEPTED**. Current target reality after the post-R20 attempts is treated as **UNKNOWN_PENDING_READONLY_REBASE**, not guessed from the inconsistent post-R20 Handoff.

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
GATE_ID=OWNER_PAUSE_SEAL_2026_10_06
STATE=PAUSED_BY_OWNER
PREVIOUS_ACTIVE_GATE=G4B_TAKEOVER_REALITY_REBASE_READONLY_R1
CURRENT_REALITY=UNKNOWN_NOT_RECHECKED_AFTER_TAKEOVER
TRUSTED_ANCHOR_COMMIT=85a33288c23e794d200ddf5e48d5bb7ae0d839c0
R1R1_PASS_COMMIT=903267dbb531ae56a68f742b12905eec9842d714
R1_OWNER_READONLY_CHECKPOINT_RELEASED=NO
FRESH_LIVE_GATE_RELEASED=NO
OWNER_ACTION_REQUIRED=NONE
RESUME_REQUIRES_FRESH_REVIEWER_GATE=YES
```

Canonical seal decision: `docs/OWNER_PAUSE_SEAL_2026-10-06.md`.

The previously released R1 checkpoint is revoked by Owner pause. No Windows/VPS/Baidu/Clash/WireGuard/live-runner action is currently authorized.

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
- Current execution channel is **Executor local/offline implementation only** for the new takeover read-only helper and fixtures.
- Owner-local execution is **not released yet**. Owner does not run R22/R22R1/R22R6 or any historical live/rollback/cleanup helper.
- Local paths are never source authority. The future released read-only checkpoint must fresh-sync GitHub `main` and lock its own source identity before any external read.
- No live G4-B runner is currently authorized or released.

## CURRENT_ROLLBACK_STATUS

- Standalone Windows WireGuard remains the accepted production/rollback baseline and must stay enabled.
- Trusted R19/R19R1 evidence says the R19 attempt stopped before persistent remote mutation; R19R1 was local/offline only.
- R18 is the last trusted Provider production-namespace CLEAN proof before the R20+ chain.
- Because R20+ execution/cleanup claims are reference-only for takeover, the **current post-R20 runtime/recovery state is UNKNOWN until the new read-only rebase completes**.
- Do not use or delete any historical rollback journal, recovery artifact, quarantine object, REALITY path/service, profile, runtime identity or Provider object merely to make the tree look clean.
- No rollback or cleanup is currently authorized.

## UNRESOLVED

- G4-B remains **IN_PROGRESS**.
- Current Windows/VPS/Baidu G4-B reality after R20+ is **UNKNOWN_PENDING_READONLY_REBASE**.
- Persistent REALITY backup service and persistent `SELF-VPN-V1` are still unaccepted regardless of post-R20 claims.
- The post-R20 live runner contains potentially useful repairs (structured remote error propagation, readiness polling, rollback diagnostics, iptables counter normalization), but those changes are not a released live candidate until independently re-reviewed and behaviorally qualified.
- G4-C remains pending and is limited to the Owner-approved three-role manual ChatGPT conversation smoke.
- G4-D remains pending after G4-C: migrate WG-BASELINE into native Clash/Mihomo WireGuard; standalone Windows WireGuard may be disabled only after formal G4-D PASS.
- Final v1 control posture, WireGuard routing/kill-switch policy and MVP v1 seal remain pending.
- G3-B fresh-target live migration rehearsal remains deferred.

## NEXT_STEP

None while paused.

When Owner resumes the project, Reviewer must first fresh-read `main`, reconcile current local/runtime reality, and issue a new Gate. Do not reuse the previously released R1 checkpoint automatically.

## OWNER_ACTION_REQUIRED

**NONE.**

Project is intentionally paused/sealed. Before deleting a local Codex worktree, inspect any untracked local `results/` and keep non-repository runtime/config state intact.

## EVIDENCE_POINTERS

Read only what is needed for the takeover Gate:

- `docs/G4B_TAKEOVER_REALITY_REBASE_READONLY_R1.md` — current canonical Gate.
- trusted anchor commit `85a33288c23e794d200ddf5e48d5bb7ae0d839c0` — formal R19R1 PASS state before R20.
- `docs/G4B_R19_LOCAL_MIHOMO_PARSE_DIAGNOSTIC_R6R2L_R19R1.md` — accepted R19R1 local repair boundary.
- `docs/G4B_PERSISTENT_THREE_ROLE_READINESS_GATE.md` — parent G4-B acceptance contract.
- `docs/G4_FINAL_THREE_ROLE_VALIDATION_PLAN.md` — Owner-approved final G4-C/G4-D sequence.
- `docs/REVIEWER_TRANSITION_2026-10-04.md` and `docs/REVIEWER_TRANSITION_2026-10-05.md` — accepted pre-R20 chronology/supporting context.
- current post-R20 runner/validators/helpers — **reference-only source material**, never current-state authority.
- `EXECUTION_EVIDENCE.md` — query only exact trusted sections when a fact needs proof; do not bulk replay it.
- `EXECUTOR_HANDOFF.md` and R20+ Gate narratives are historical/supporting material only and cannot override this Handoff.

