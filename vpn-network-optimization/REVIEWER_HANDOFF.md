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
G3-C C2B Synthetic Clash UI canary          IN_PROGRESS
G3-C C2C Real HY2-in-Clash canary           PENDING
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

No production mutation is authorized in C2B. Current rollback/continuity baseline is the already-running WireGuard path. The synthetic profile must be removed during the checkpoint; the runner may clean only its own exact temporary runtime files.

## UNRESOLVED

- C2B synthetic Clash UI visibility/manual-selector proof has not yet run.
- C2C real HY2-in-Clash proof remains pending.
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
- **Repair authorization:** because the exact root is empty, non-reparse, project-owned, and has no explicit unauthorized ACL rules, Reviewer authorizes a bounded in-place ACL reconciliation only; no deletion is authorized.
- **Benchmark detour remains cancelled.**

## CURRENT_GATE

```text
GATE_ID=G3C_C2B_RUNTIME_ROOT_ACL_RECONCILE_AND_CANARY_R1
STATE=OWNER_ACTION_REQUIRED
PREVIOUS_RESULT=PASS_D3_STALE_RUNTIME_ROOT_CONFIRMED
OBJECTIVE=Reconcile the exact empty stale project-owned runtime root to the accepted Owner-only ACL invariant, validate all C2B source guards, then conditionally complete the synthetic/no-traffic Clash UI canary.
MAX_ENDPOINT_THIS_ROUND=Safe ff-only sync -> locked repair/source identity -> exact runtime-root ACL reconciliation -> readback -> offline validator -> conditional C2B UI canary -> post-readback/cleanup -> STOP_AT_REVIEWER.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=%LOCALAPPDATA%\vpn-network-optimization\runtime exact root plus existing reviewed C2B package only.
APPLICABLE_CRITICAL_CONSTRAINTS=Repair only if exact root exists, empty, non-reparse, and has no explicit unauthorized ACL rules; no root deletion; no destructive Git; validator before runner; WireGuard remains connected; synthetic/no-traffic only; no real HY2/REALITY/VPS/DPAPI/Secret; no route/proxy/TUN/WG mutation.
RUNTIME_ROOT_REPAIR_BLOB=cf33051c1a6eb073673020e835f182756f05d783
RUNNER_BLOB=817ed91b30efd72f7cbb43fff56e9c55025380b6
VALIDATOR_BLOB=aaddf4810b77655e4a2ae6d94ba3fb443a6b3e3a
TEMPLATE_BLOB=b50f9747157200670d6e85fdd53ba81e9a8c5c76
PACKAGE_BLOB=64b7ea3c562adc241311517c79cc53d966197a6e
SPECIALIST_RULES=11B_TARGET_HOST
ESTIMATED_EXECUTION_TIME=5-10_minutes
TIMING_OBSERVABILITY_REQUIRED=YES
```

### PREFLIGHT

1. Use the real Owner Windows host and elevated PowerShell 7.6.6.
2. Operate Git from the known C2B scripts directory; do not parse Git-emitted Chinese filesystem paths.
3. Require project scope clean; fetch origin/main; require local HEAD ancestor of origin/main; update only with ff-only.
4. Require post-sync project scope clean.
5. Verify exact blobs for repair/runner/validator/template/package.
6. Run `c2b-runtime-root-acl-repair.ps1` first.
7. Repair script must fail closed unless the exact runtime root exists, is empty, non-reparse, and has zero explicit unauthorized ACL rules.
8. Require post-repair ACL invariant: protected, owner match, zero inherited rules, zero unauthorized rules, Owner direct FullControl, Owner child FullControl, root still empty, no deletion, no network/Secret action.
9. Only after repair PASS run the full offline validator.
10. Require validator PASS including the route-shape and modern ACL regression fixtures, AST parse, zero network requests, and zero network change.
11. Only after validator PASS may the repaired C2B runner execute exactly once.

### OWNER CHECKPOINT

If the runner reaches the UI prompt:
1. import only the printed synthetic profile;
2. leave production WireGuard/current production profile unchanged;
3. confirm `WG-BASELINE`, synthetic `HY2-SFO3`, and the manual selector are visible;
4. keep `WG-BASELINE` current/default;
5. do not select HY2 and send no HY2 traffic;
6. remove the synthetic profile;
7. enter the exact acknowledgement requested by the runner.

### REQUIRED_EVIDENCE

- safe ff-only sync and post-sync project clean;
- exact five locked blobs;
- runtime-root repair before/after bounded ACL facts;
- `RUNTIME_ROOT_ACL_POST_REPAIR=PASS`;
- `RUNTIME_ROOT_STILL_EMPTY=PASS`;
- `RUNTIME_ROOT_DELETE=NO`;
- full offline validator PASS;
- runner `C2B_PREFLIGHT=PASS`;
- `OWNER_ONLY_RUNTIME_ACL=PASS`;
- `MIHOMO_CONFIG_TEST=PASS`;
- structured Owner acknowledgement;
- `CLASH_PROFILE_STORE_POSTREMOVE=PASS`;
- `POST_UI_NETWORK_READBACK=PASS`;
- `LOCAL_RUNTIME_CLEANUP=PASS`;
- WireGuard connected; proxy OFF; TUN OFF; routes unchanged;
- `SECRET_VALUES_EMITTED=0`;
- complete timing.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires exact stale-root ACL reconciliation without deletion, full post-repair invariant, validator PASS before runner, successful synthetic UI acknowledgement/removal, unchanged production network state, complete timing, and STOP_AT_REVIEWER.

### ROLLBACK_STATUS_OR_PLAN

The only host mutation authorized is tightening the exact empty project-owned runtime-root ACL. No deletion is authorized. If repair fails, validator and runner do not start. If runner fails, its cleanup/fail-closed behavior applies and Reviewer reconciles before any retry.

### OWNER_ONLY_ACTIONS

Run the single Reviewer-supplied atomic reconcile+validation+canary checkpoint. Only if the runner reaches the UI prompt, perform the bounded synthetic import/inspect/remove/acknowledge steps.

### REVIEWER_TO_EXECUTOR_RELAY

Do not independently repair or rerun C2B. Wait for Owner R1 output; persist bounded ACL repair/source/validator/canary/cleanup/timing facts only; STOP_AT_REVIEWER.

### EXECUTOR_TO_REVIEWER_RELAY

Return `PASS_CANDIDATE_G3C_C2B_RUNTIME_ROOT_ACL_RECONCILE_AND_CANARY_R1` or precise `RETURN_*`; STOP_AT_REVIEWER.

## NEXT_STEP

Owner performs the exact stale-root ACL reconciliation, validates the package, and—only if both pass—completes the synthetic Clash UI canary.

## OWNER_ACTION_REQUIRED

Run the Reviewer-supplied atomic reconcile+validation+canary checkpoint. Do not manually delete the runtime root. If the UI prompt appears, follow only the bounded synthetic profile steps.

## REVIEWER_TO_EXECUTOR_RELAY

Wait for Owner R1 output. Do not enter C2C.

## EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE_G3C_C2B_RUNTIME_ROOT_ACL_RECONCILE_AND_CANARY_R1 or precise RETURN; STOP.

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
