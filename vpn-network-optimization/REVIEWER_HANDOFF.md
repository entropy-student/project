# VPN Network Optimization — REVIEWER HANDOFF

> Maintainer: Reviewer only  
> Governance: `entropy-student/spike.skill/vps-project-governance` v0.2.6 / ACTIVE_PROVISIONAL  
> Canonical project state: this file. Detailed execution history/proof remains in `EXECUTION_EVIDENCE.md` and Git history.

## PROJECT_GOAL

建立一套可迁移、可验证、可回滚的自建 VPN 优化标准，重点改善 Codex / OpenAI / AI 生图等长任务的稳定性和尾部表现；以 WireGuard 为当前生产/回退基线，验证 Hysteria2 是否值得进入最终 v1。

## PROJECT_STAGE

```text
P0 Research / Scope                         PASS
G1 Foreground-safe Foundation               PASS
G2 Multi-path candidate validation          PASS
G3-A Health/readiness/advisory              PASS
G3-B Migration package D1-D3                PASS_OFFLINE
G3-C C1 Manual-control contract             PASS
G3-C C2A Synthetic UI package repair        PASS_WITH_TIMING_GAP
G3-C C2B-P0 Local-fact persistence          RETURN->FIXED
G3-C C2B Synthetic Clash UI canary          PASS
G3-C C2C Real HY2-in-Clash canary           OWNER_AUTH_REQUIRED
G3-B Fresh-target migration rehearsal       DEFERRED
G4 Peak-hour + real workload final validate PENDING
MVP v1 seal                                 PENDING
```

## SYSTEM_MAP

```text
Windows Owner host
├─ Current production / rollback: WireGuard adapter SFO2-A
│  ├─ IPv4 full coverage via 0.0.0.0/1 + 128.0.0.0/1
│  └─ DigitalOcean sfo3 VPS 24.199.118.137
│     └─ Internet / OpenAI
├─ Validated HY2 candidate path
│  └─ temporary localhost Mihomo proxy :17890
│     └─ temporary ActiveStore 24.199.118.137/32 via WLAN
│        └─ Hysteria2 UDP 8443 on same VPS
├─ Validated REALITY private interoperability path
│  └─ Windows Mihomo v1.19.31 client (historical G2-C proof)
│     └─ temporary Mihomo v1.19.31 VLESS+REALITY+Vision server on 10.66.21.1:14443
│        └─ one OpenAI request succeeded with expected HTTP 401
└─ Control path
   └─ SSH through WireGuard to 10.66.21.1:22
```

Current known components:
- VPS: DigitalOcean `sfo3`, public IP `24.199.118.137`.
- WireGuard: active MTU 1420; current IPv4 defaults are two `/1` routes, not `0.0.0.0/0`.
- WireGuard Windows strict WFP kill-switch: absent after the accepted G2-B repair.
- Hysteria2: official v2.12.3, independent service on UDP 8443.
- Windows client: Clash Verge 2.5.6; accepted current Mihomo core v1.19.32. Historical G2-C proofs used v1.19.31.
- Owner execution runtime: PowerShell 7.6.6, Administrator, High integrity.
- HY2 recovery: canonical DPAPI CurrentUser recovery artifact validated; do not re-fetch or rotate VPS Secrets.

## CRITICAL_CONSTRAINTS

- Production WireGuard must remain available throughout C2B.
- C2B is synthetic/UI-only: no real HY2 credential, endpoint, traffic, DPAPI recovery read, VPS access, REALITY activation, or route/proxy/TUN/WireGuard mutation.
- Owner-local actions must use the reviewed one-shot runner; Owner is not responsible for debugging or redesign.
- Any canonical Gate/relay disagreement fails closed before Owner-local execution.

## DEFAULT_EXECUTION_CHANNEL

`CODEX_DESKTOP -> reviewed Owner-local PowerShell one-shot checkpoint when explicitly requested by the current Gate`.

## CURRENT_ROLLBACK_STATUS

C2B is closed PASS. Production WireGuard remained connected and authoritative throughout the accepted canary; system proxy/TUN remained off, route state matched pre/post readback, the synthetic Clash profile was removed, and the project-owned temporary runtime was cleaned. C2C is not authorized yet.

## UNRESOLVED

- C2C real HY2-in-Clash proof remains pending and requires a new Owner authorization because it crosses from synthetic/no-traffic validation into real credential and real HY2 connectivity use.
- G4 peak-hour + real-workload final validation remains pending.
- REALITY remains cold/deferred for persistent manual-control use.

## CURRENT_ACCEPTED_STATE

- **Current production:** WireGuard remains connected and authoritative.
- **G3-C C1:** PASS; Windows Mihomo v1.19.32 accepted.
- **G3-C C2A repair:** accepted technically with the previously recorded timing-observability gap.
- **G3-C C2B-P0 R1 durability objective:** accepted without replay. Canonical commits `fc2aa9399627c19b5368ed6da6a219deaeb20b77` and `dd8651aa760062f71ddc84a1154b21873ecbc174` durably contain the previously missing GitHub read-back, Git-persistence timing, and safe-fast-forward facts.
- **R1 formal Gate disposition:** `RETURN_R1_TIMING_START_NOT_CAPTURED` remains the correct Executor result because the Gate required a round-start marker before initial fetch. Reviewer does not convert that Gate to PASS; the missing exact start is retained as a process-observability defect.
- **Replay:** NONE. The timing defect cannot be repaired by replay and does not invalidate the already-completed document reconciliation.
- **Current-main drift check:** current main may advance for unrelated projects; Reviewer verified the post-`dd8651...` advancement touched only `birthday-magazine-studio/`, not this VPN project.
- **C2B source identity:** direct GitHub read-back confirms runner blob `cd5a2eb768b54d13307b651ea514a912b9742c9d` and template blob `b50f9747157200670d6e85fdd53ba81e9a8c5c76`.
- **Local worktree:** Executor reported the managed VPN worktree clean after durable read-back and cleanup; the next Gate must independently re-prove project-scoped cleanliness before the Owner checkpoint.
- **No live action occurred in R1.**
- **C2B R2R1 Executor preflight:** Owner-relayed Executor report states canonical/main, Gate alignment, project cleanliness, and locked runner/template identities passed; the current Codex execution shell failed the Owner-runtime boundary at PowerShell 7.6.5 / non-admin / medium integrity. Runner did not start.
- **Execution-channel disposition:** Codex runtime is not authorized to bypass that mismatch. Reviewer approves a one-shot Owner-local checkpoint only; this does not change the default execution channel.
- **Owner-local R2R1-O1 result:** Owner-reported output shows the real PowerShell 7.6.6/Admin runner started, passed Clash profile-store baseline, then failed read-only `PRECHECK_NETWORK_STATE` with `PropertyNotFoundException`; cleanup passed and no UI acknowledgement occurred.
- **Failure classification:** this is treated as runner/evidence-shape incompatibility until a read-only object-shape diagnostic identifies the missing property; it is not evidence of network drift.
- **D1 local-path result:** Owner reported `Test-Path` for the reviewed diagnostic in the existing Codex worktree returned `False`. Canonical GitHub contains the diagnostic, so the local worktree is stale rather than the diagnostic being absent from canonical.
- **D1R1 root result:** Owner-reported bounded checkpoint returned `WORKTREE_ROOT_MISMATCH` before fetch/sync/diagnostic. No C2B runner or network action occurred. Reviewer classifies the fault as an incorrect hardcoded Git-root assumption in the checkpoint, not local repository drift.
- **D1R2 path-encoding result:** Owner-reported Git top-level rendered the Chinese path component `VPS搭建` as mojibake `VPS鎼缓`; the checkpoint then compared that decoded string with the correct .NET Unicode runner path and returned `RUNNER_OUTSIDE_GIT_ROOT`. No fetch/update/diagnostic/C2B/network action occurred. This is a native-output path-decoding defect, not repository topology evidence.
- **D1R3 diagnostic result:** Owner-local evidence proved safe ff-only synchronization from `d87fbdd...` to `867604f...`, exact diagnostic blob identity, PowerShell 7.6.6/Admin/High integrity, and a successful read-only object-shape capture with no network mutation or Secret output.
- **Confirmed root cause:** all 23 ActiveStore IPv4 route objects exposed `DestinationPrefix`, `NextHop`, `InterfaceIndex`, and `RouteMetric`, while `PolicyStore` was absent on 23/23 objects. The original runner's `$_.PolicyStore` access therefore caused the `PropertyNotFoundException`.
- **Route-snapshot repair:** Owner-local validation passed all offline fixtures, including the new ActiveStore/no-object-PolicyStore regression guard; the route-object compatibility repair is accepted.
- **C2B retry result:** the repaired runner progressed past the prior network-state failure and profile-store baseline, then failed at `CREATE_OWNER_RUNTIME` with `OWNER_ACL_INHERITANCE_ENABLED`. Cleanup passed; no UI acknowledgement, Secret output, real HY2/REALITY/VPS action, or network mutation occurred.
- **ACL failure classification:** the Owner-only runtime ACL invariant remains required. The current failure is treated as ACL application/read-back incompatibility, not permission relaxation.
- **D2 diagnostic result:** Owner-local D2 synchronized safely to current main, verified the diagnostic blob, then returned `MethodException` before either ACL method produced evidence; cleanup passed and C2B/network/Secret actions remained absent.
- **D2 root cause refinement:** the diagnostic invoked the .NET Framework-shaped static `[IO.Directory]::CreateDirectory(path, DirectorySecurity)` call. On the target PowerShell 7.6.6/.NET runtime that call shape is not bindable; modern .NET exposes equivalent ACL-at-create behavior through `System.IO.FileSystemAclExtensions.CreateDirectory(DirectorySecurity, path)`.
- **D2R1 result:** both modern create-with-ACL and create-then-`Set-Acl` independently proved `PROTECTED=True`, correct Owner, exactly one Owner rule, zero inherited/unauthorized rules, direct FullControl, child FullControl, cleanup PASS, no network mutation, and no Secret output. Reviewer selects create-with-ACL because it avoids a temporary inherited-permission window.
- **ACL repair candidate:** canonical runner now uses `FileSystemAclExtensions.CreateDirectory` for both Owner runtime directories and explicitly `SetOwner($script:ownerSid)`; validator requires both properties and rejects regression to the old Directory overload.
- **ACL repair target validation:** Owner-local validator passed all fixtures including the modern Owner ACL regression guard, but the repaired runner still returned `OWNER_ACL_INHERITANCE_ENABLED` at `CREATE_OWNER_RUNTIME` before UI. Cleanup passed and no network/Secret action occurred.
- **D3 residue result:** Owner-local readback proved the exact project-owned runtime root exists, is empty, is not a reparse point, and still carries the legacy inherited ACL: `PROTECTED=False`, `OWNER_MATCH=False`, one inherited rule, zero unauthorized rules, with no mutation performed.
- **Root cause closure:** the repaired runner was not reaching the new create-with-ACL code because the stale runtime root already existed. This fully explains the repeated `OWNER_ACL_INHERITANCE_ENABLED` without disproving the new ACL implementation.
- **Repair authorization:** because the exact root is empty, non-reparse, project-owned, and has no explicit unauthorized ACL rules, Reviewer authorized a bounded in-place ACL reconciliation only; no deletion was authorized.
- **C2B final Owner checkpoint:** exact runtime-root ACL reconciliation succeeded in place: before `PROTECTED=False / OWNER_MATCH=False / inherited=1`; after `PROTECTED=True / OWNER_MATCH=True / inherited=0 / unauthorized=0`, Owner direct+child FullControl true, root remained empty, and root deletion was `NO`.
- **C2B validator:** all offline fixtures passed, including the ActiveStore route-shape regression and modern Owner ACL creation regression; AST parse passed; network requests/change remained zero.
- **C2B UI proof:** Owner visual evidence showed `SELF-VPN-CANARY`, `WG-BASELINE`, and synthetic `HY2-SFO3` visible with `WG-BASELINE` current/default. Owner then removed the imported synthetic profile and supplied the exact structured acknowledgement.
- **C2B final readback:** `CLASH_PROFILE_STORE_POSTREMOVE=PASS`, `POST_UI_NETWORK_READBACK=PASS`, `LOCAL_RUNTIME_CLEANUP=PASS`, `OWNER_UI_PROFILE_REMOVED=ACKNOWLEDGED`, `SECRET_VALUES_EMITTED=0`, `C2B_OWNER_CHECKPOINT=COMPLETE`, and outer `RECONCILE_VALIDATION_CANARY=PASS`.
- **C2B formal Reviewer disposition:** `PASS_G3C_C2B_SYNTHETIC_CLASH_UI_CANARY`. This proves synthetic profile parsing, UI visibility/manual selection semantics, cleanup, and no-production-state drift only; it does **not** prove real HY2 authentication/connectivity/performance.
- **Benchmark detour remains cancelled.**

## CURRENT_GATE

```text
GATE_ID=G3C_C2C_REAL_HY2_IN_CLASH_AUTHORIZATION_A0
STATE=OWNER_DECISION_REQUIRED
PREVIOUS_RESULT=PASS_G3C_C2B_SYNTHETIC_CLASH_UI_CANARY
OBJECTIVE=Decide whether to cross from synthetic/no-traffic C2B into a bounded real HY2-in-Clash canary using the already-validated HY2 service and an explicitly approved credential/profile-storage lifecycle.
MAX_ENDPOINT_THIS_ROUND=Owner authorization decision only -> Reviewer designs C2C implementation Gate -> STOP_AT_REVIEWER.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=No host/VPS/Clash/Secret action in A0.
APPLICABLE_CRITICAL_CONSTRAINTS=No real HY2 credential read/unprotect/import yet; no real HY2 traffic yet; no C2B replay; production WireGuard remains current rollback baseline; REALITY remains cold/deferred.
SPECIALIST_RULES=11B_TARGET_HOST;11C_DEPLOYMENT_NETWORK_RESOURCES
ESTIMATED_EXECUTION_TIME=Owner decision only
TIMING_OBSERVABILITY_REQUIRED=NO
```

### C2B ACCEPTED BOUNDARY

C2B proves:
- synthetic profile parses under accepted Mihomo;
- Clash UI exposes WG/HY2 entries and a manual selector;
- `WG-BASELINE` can remain current/default;
- synthetic profile lifecycle can be cleaned without profile-store residue;
- network state remains unchanged before/after.

C2B does not prove:
- real HY2 credential handling inside Clash;
- real HY2 handshake/authentication;
- UDP 8443 reachability from Clash;
- real traffic continuity/performance;
- production/manual-switch readiness of HY2 in Clash.

### C2C AUTHORIZATION QUESTION

C2C would intentionally cross into real HY2 credential + real HY2 connectivity use. Owner authorization is required before Reviewer may design or execute that Gate.

If authorized, Reviewer must design a new fail-closed C2C Gate that:
1. uses the already-validated canonical HY2 recovery artifact/credential source without printing Secrets;
2. defines exact temporary or persistent Clash profile-storage lifecycle before any credential access;
3. keeps WireGuard as rollback/continuity until the Gate explicitly permits a bounded HY2 switch;
4. proves actual HY2 handshake/real connectivity with bounded traffic;
5. defines immediate rollback and residue cleanup;
6. stops at Reviewer before any G4 or persistent default change.

### ACCEPTANCE_CRITERIA

A0 closes only when Owner explicitly authorizes or declines C2C. No technical action occurs in this authorization Gate.

### OWNER_ONLY_ACTIONS

Explicitly choose whether to proceed into C2C real HY2-in-Clash canary.

### REVIEWER_TO_EXECUTOR_RELAY

No execution. Do not read/unprotect credentials, modify Clash, contact VPS, or send HY2 traffic until Reviewer opens a post-authorization C2C Gate.

### EXECUTOR_TO_REVIEWER_RELAY

NONE until Owner authorization.

## NEXT_STEP

Await Owner authorization decision for C2C. If authorized, Reviewer designs the bounded real-HY2 Gate before any execution.

## OWNER_ACTION_REQUIRED

Authorize C2C real HY2-in-Clash canary, or defer it.

## REVIEWER_TO_EXECUTOR_RELAY

No execution in A0.

## EXECUTOR_TO_REVIEWER_RELAY

NONE.

## EVIDENCE_POINTERS

- `EXECUTION_EVIDENCE.md` — append-only execution proof through the successful 60+60 same-window comparison.
- `DECISION_LOG.md` — durable decision rationale for the kill-switch routing change and current production/candidate roles.
- `docs/ROUND_TIMING_RETROSPECTIVE.md` — per-round estimate/actual timing, overrun causes, and reusable execution-efficiency improvements; not canonical project truth.
- `EXECUTOR_HANDOFF.md` — historical Executor factual notes; not canonical current project truth.
- `scripts/g2b-owner-runner.ps1` — accepted G2-B benchmark/runtime logic.
- `scripts/g2b-comparative-after-killswitch-repair.ps1` — successful final G2-B comparative checkpoint.
- Evidence commit `b85224370a295cc5128e29da9186573b81345d27` — same-window WG vs HY2 results and cleanup proof.
- Reviewer acceptance commit `cfb2d723657a5607c5d8c756705dc873c06babe5` — first formal acceptance of the completed G2-B evidence.

Historical Reviewer narrative remains available in Git history and is intentionally not duplicated in this dashboard.
