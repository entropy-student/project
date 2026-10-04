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
G3-C C2B Synthetic Clash UI canary          PASS
G3-C C2C package offline validation         PASS
G3-C C2C real HY2-in-Clash Owner canary     IN_PROGRESS
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

- Production WireGuard remains the continuity/rollback baseline throughout C2C.
- Owner has explicitly authorized one bounded C2C real-HY2 canary, and the C2C offline package has now been formally accepted. The current Gate is the Owner-local real canary only.
- Real C2C actions are allowed only inside the locked Owner-local checkpoint: CurrentUser DPAPI unprotect via the Secret helper, one temporary real Clash profile, one temporary ActiveStore /32 route, and exactly two proxy requests. VPS/SSH, REALITY, G4, persistent routes/default changes, system-proxy enablement, TUN enablement, and WireGuard disconnect remain forbidden.
- C2C package architecture is split deliberately: Secret helper has no network-request capability; bounded network probe has no Secret/DPAPI capability; orchestrator owns sequencing only.
- The offline package is accepted; real execution must use the exact locked blobs and the Reviewer-supplied one-shot Owner checkpoint.
- REALITY remains cold/deferred; C2C does not authorize G4 or any persistent default change.
- Owner-local actions use one reviewed checkpoint; Owner is not responsible for debugging/design.

## DEFAULT_EXECUTION_CHANNEL

`CODEX_DESKTOP -> reviewed Owner-local PowerShell one-shot checkpoint when explicitly requested by the current Gate`.

## CURRENT_ROLLBACK_STATUS

C2B is closed PASS. C2C package validation is closed PASS. WireGuard remains production/rollback and must stay connected throughout the real C2C canary. The C2C orchestrator owns the temporary /32 route lifecycle; the Secret helper owns the temporary plaintext profile and residue verification. If execution fails after the real profile has been imported but before Owner removal, do not rerun: remove only the C2C profile if Reviewer directs it after inspecting the failure evidence.

## UNRESOLVED

- C2C real HY2-in-Clash Owner canary remains to be executed once using the accepted package.
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
- **C2C Owner authorization:** GRANTED in the current conversation on 2026-10-04. Authorization covers one bounded real HY2-in-Clash canary after a reviewed package is accepted; it does not authorize persistent default change, performance benchmarking, G4, REALITY activation, or broader network mutation.
- **C2C package candidate:** source split is now explicit: `c2c-secret-profile-helper.ps1` is local-only Secret handling, `c2c-bounded-proxy-probe.ps1` is exactly two network requests with no Secret access, and `c2c-owner-clash-real-canary.ps1` orchestrates the temporary route/UI lifecycle without DPAPI access.
- **C2C candidate source identities before offline validation:** orchestrator `e59be99321cc98a37a80e4a747b937aaaaf5d58b`; Secret helper `cdbcd94e504ca9d7f680d30a971bea201a812c7a`; proxy probe `4e17c849dffdd410ff2c635830ce0e59cb24304e`; validator `4ab9e18fef7f52dd60055e8bbcd5aacfe817bcc9`; template `ea18bdccf8f00f2d6d705e4ba34ba57db243722a`; package doc `10518d986ab3094a4578f431301a820645d7163b`.
- **C2C package acceptance:** PASS. Executor commit `87455f208ab58f6a134cc2fa15de1707c21a9d8d` changed only `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md`; all six package blobs remained unchanged.
- **C2C offline proof:** all seven static fixtures passed; PowerShell AST parse passed; Mihomo v1.19.32 synthetic fixture parse passed; DPAPI unprotect/real Secret read/orchestrator/Secret-helper real modes/Clash mutation/network requests/network changes/VPS/REALITY were all absent; validator exit 0; temp residue 0.
- **Offline runtime note:** Executor used PowerShell 7.6.5, which is acceptable for this repo-only/static Gate because no Owner-runtime action was authorized. The real Owner canary independently requires PowerShell 7.6.6 + Administrator + High integrity.
- **C2C formal Reviewer disposition:** `PASS_G3C_C2C_PACKAGE_OFFLINE_VALIDATION_R1`.
- **Locked real-canary source identities:** orchestrator `e59be99321cc98a37a80e4a747b937aaaaf5d58b`; Secret helper `cdbcd94e504ca9d7f680d30a971bea201a812c7a`; proxy probe `4e17c849dffdd410ff2c635830ce0e59cb24304e`; validator `4ab9e18fef7f52dd60055e8bbcd5aacfe817bcc9`; template `ea18bdccf8f00f2d6d705e4ba34ba57db243722a`; package doc `10518d986ab3094a4578f431301a820645d7163b`.
- **C2C Owner checkpoint R1 wrapper result:** RETURN before Git synchronization because the Reviewer-supplied wrapper used `$dirty.Count` under `Set-StrictMode -Version Latest`. A clean Git status yields no pipeline objects, so `$dirty` becomes `$null` and `.Count` faults. Only `OWNER_RUNTIME=PASS` preceded the failure; the orchestrator did not start and no DPAPI/Secret/Clash/route/network action occurred. R1R1 changes only the wrapper cardinality checks to `@($dirty).Count` / `@($dirtyAfter).Count`; locked C2C source blobs are unchanged.

## CURRENT_GATE

```text
GATE_ID=G3C_C2C_REAL_HY2_IN_CLASH_OWNER_CANARY_R1R1
STATE=OWNER_ACTION_REQUIRED
PREVIOUS_RESULT=RETURN_R1_OWNER_WRAPPER_NULL_COUNT
OWNER_C2C_AUTHORIZATION=GRANTED
OBJECTIVE=Retry the accepted one-shot real HY2-in-Clash Owner canary with only the outer checkpoint cardinality bug repaired; C2C package source remains unchanged.
MAX_ENDPOINT_THIS_ROUND=Owner runtime -> safe ff-only sync with null-safe Git cleanliness cardinality -> exact source identity -> owner-runtime offline validator -> C2C orchestrator -> three bounded UI acknowledgements -> exactly two proxy requests -> cleanup/readback -> STOP_AT_REVIEWER.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Real Owner Windows host; same accepted C2C package; outer wrapper fix only.
APPLICABLE_CRITICAL_CONSTRAINTS=PowerShell 7.6.6; Administrator=True; High integrity RID>=12288; WireGuard remains connected; system proxy OFF; TUN OFF; CurrentUser DPAPI only inside Secret helper; one temporary C2C profile; one ActiveStore /32 route; exactly two requests; no persistent route; no VPS/SSH; no REALITY; no benchmark; no G4; no persistent default change.
ORCHESTRATOR_BLOB=e59be99321cc98a37a80e4a747b937aaaaf5d58b
SECRET_HELPER_BLOB=cdbcd94e504ca9d7f680d30a971bea201a812c7a
PROXY_PROBE_BLOB=4e17c849dffdd410ff2c635830ce0e59cb24304e
VALIDATOR_BLOB=4ab9e18fef7f52dd60055e8bbcd5aacfe817bcc9
TEMPLATE_BLOB=ea18bdccf8f00f2d6d705e4ba34ba57db243722a
PACKAGE_BLOB=10518d986ab3094a4578f431301a820645d7163b
SPECIALIST_RULES=11B_SECRET_TARGET_HOST;11C_DEPLOYMENT_NETWORK_RESOURCES
ESTIMATED_EXECUTION_TIME=10-20_minutes
TIMING_OBSERVABILITY_REQUIRED=YES
```

### PREFLIGHT

1. Use the real Owner Windows host in elevated PowerShell 7.6.6.
2. Capture checkpoint start before Git synchronization.
3. Require project scope clean using null-safe cardinality checks `@($dirty).Count` and `@($dirtyAfter).Count`; fetch canonical `origin/main`; prove ancestor; update ff-only.
4. Verify the same six locked blobs.
5. Run the Owner-side offline validator first; only on PASS run the orchestrator exactly once.
6. Do not manually invoke the Secret helper or proxy probe.

### OWNER UI CHECKPOINTS

Unchanged from R1: perform only the three UI steps printed by the orchestrator.

### ACCEPTANCE_CRITERIA

Unchanged from R1: complete real HY2 proof, exactly two requests, full profile/Secret/route/network cleanup, and `C2C_OWNER_CHECKPOINT=COMPLETE`.

### ROLLBACK_STATUS_OR_PLAN

R1 caused no state change. R1R1 retains WireGuard as continuity path and the accepted orchestrator cleanup behavior. On any real-canary failure after import, do not rerun; return the complete non-secret output for Reviewer.

### OWNER_ONLY_ACTIONS

Run the corrected Reviewer-supplied R1R1 checkpoint. Follow only orchestrator prompts.

### REVIEWER_TO_EXECUTOR_RELAY

No Executor action during Owner canary.

### EXECUTOR_TO_REVIEWER_RELAY

NONE until Owner returns complete output.

## NEXT_STEP

Owner reruns the corrected outer checkpoint. Reviewer then accepts or returns C2C before G4.

## OWNER_ACTION_REQUIRED

Run the corrected R1R1 atomic checkpoint.

## REVIEWER_TO_EXECUTOR_RELAY

No execution while Owner canary is active.

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
