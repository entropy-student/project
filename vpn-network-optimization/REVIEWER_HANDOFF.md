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
- **Repair candidate:** canonical runner now scopes the query with `Get-NetRoute ... -PolicyStore ActiveStore` but snapshots only the four proven route properties. Validator now requires ActiveStore query scoping and rejects any `$_.PolicyStore` route-object access. Repair is not accepted until Owner-local offline validator passes.
- **Benchmark detour remains cancelled.**

## CURRENT_GATE

```text
GATE_ID=G3C_C2B_ROUTE_SNAPSHOT_COMPAT_REPAIR_R1
STATE=OWNER_ACTION_REQUIRED
PREVIOUS_RESULT=PASS_DIAGNOSTIC_D1_ROOT_CAUSE_CONFIRMED
OBJECTIVE=Validate the minimal ActiveStore route-snapshot compatibility repair and, only if all offline fixtures pass, rerun the bounded synthetic/no-traffic Clash UI canary.
MAX_ENDPOINT_THIS_ROUND=Safe ff-only sync -> locked source identity -> offline package validator -> conditional Owner synthetic UI canary -> post-readback/cleanup -> STOP_AT_REVIEWER.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Existing Owner Windows worktree and repaired C2B runner/validator/template/package only.
APPLICABLE_CRITICAL_CONSTRAINTS=PowerShell 7.6.6/Admin/High; no destructive Git; validator before runner; production WireGuard remains connected; synthetic/no-traffic only; no real HY2/REALITY/VPS/DPAPI/Secret; no route/proxy/TUN/WG mutation.
RUNNER_BLOB=ffa5667e6e0d436294cb37de845d0f1440f5766a
VALIDATOR_BLOB=a1ad9a30c0657f0912bcdebc6f39de5cf7e5de20
TEMPLATE_BLOB=b50f9747157200670d6e85fdd53ba81e9a8c5c76
PACKAGE_BLOB=64b7ea3c562adc241311517c79cc53d966197a6e
SPECIALIST_RULES=11B_TARGET_HOST
ESTIMATED_EXECUTION_TIME=5-10_minutes
TIMING_OBSERVABILITY_REQUIRED=YES
```

### PREFLIGHT

1. Use the real Owner Windows host and elevated PowerShell 7.6.6.
2. Start from the already-known C2B runner path and operate Git from its scripts directory; do not parse Git-emitted Chinese filesystem paths.
3. Require project scope clean before synchronization.
4. Fetch only `origin main`; require local HEAD ancestor of `origin/main`; update only by `merge --ff-only`.
5. Require project scope clean after synchronization.
6. Verify exact Git blobs for runner, validator, template, and package against the locked identities above.
7. Run `g3c-c2a-package-validator.ps1` before the C2B runner.
8. Require validator PASS markers including:
   - `G3C_C2A_FIXTURE_I1_ACTIVE_STORE_SCOPE_WITHOUT_OBJECT_POLICYSTORE=PASS`;
   - `POWERSHELL_AST_PARSE=PASS`;
   - `G3C_C2A_OFFLINE_FIXTURES=PASS`;
   - `NETWORK_REQUESTS=0`;
   - `NETWORK_CHANGED=NO`.
9. Any validator non-zero exit or missing required marker stops before C2B.
10. Only if validation passes, invoke the repaired C2B runner exactly once.

### OWNER CHECKPOINT

If the repaired runner reaches the UI prompt:
1. import only the printed synthetic profile;
2. leave production WireGuard/current production profile unchanged;
3. confirm `WG-BASELINE`, synthetic `HY2-SFO3`, and manual selector are visible;
4. keep `WG-BASELINE` current/default;
5. do not select HY2 and send no HY2 traffic;
6. remove the synthetic profile;
7. enter the exact acknowledgement requested by the runner.

### REQUIRED_EVIDENCE

- safe ff-only synchronization and post-sync project clean;
- exact four locked blob identities;
- complete offline validator output and zero exit;
- new I1 route-shape regression fixture PASS;
- runner timing and `C2B_PREFLIGHT=PASS`;
- `MIHOMO_CONFIG_TEST=PASS`;
- structured Owner acknowledgement;
- `CLASH_PROFILE_STORE_POSTREMOVE=PASS`;
- `POST_UI_NETWORK_READBACK=PASS`;
- `LOCAL_RUNTIME_CLEANUP=PASS`;
- WireGuard remains connected; proxy OFF; TUN OFF; route snapshot unchanged;
- `SECRET_VALUES_EMITTED=0`;
- no real HY2/REALITY/VPS/DPAPI/Secret action.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires offline validator PASS before runner launch, exact repaired source identity, successful synthetic UI acknowledgement/cleanup, unchanged production network state, complete timing, and STOP_AT_REVIEWER.

### ROLLBACK_STATUS_OR_PLAN

The source repair is already canonical and local synchronization is ff-only. No production network mutation is authorized. If validator fails, C2B does not run. If runner fails, its cleanup/fail-closed behavior applies and Reviewer reconciles before any retry.

### OWNER_ONLY_ACTIONS

Run the single Reviewer-supplied atomic validation+canary checkpoint. If and only if the runner reaches the UI prompt, perform the bounded synthetic import/inspect/remove/acknowledge steps.

### REVIEWER_TO_EXECUTOR_RELAY

Do not independently rerun C2B. Wait for Owner R1 output; persist bounded validation/canary evidence only; STOP_AT_REVIEWER.

### EXECUTOR_TO_REVIEWER_RELAY

Return `PASS_CANDIDATE_G3C_C2B_ROUTE_SNAPSHOT_COMPAT_REPAIR_R1` or precise `RETURN_*`; STOP_AT_REVIEWER.

## NEXT_STEP

Owner safely synchronizes the repaired canonical source, runs the full offline validator, and only on validator PASS proceeds into the repaired synthetic Clash UI canary.

## OWNER_ACTION_REQUIRED

Run the Reviewer-supplied atomic repair-validation checkpoint. If it reaches the C2B UI prompt, follow only the bounded synthetic profile instructions.

## REVIEWER_TO_EXECUTOR_RELAY

Wait for Owner R1 output. Do not run or patch C2B independently and do not enter C2C.

## EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE_G3C_C2B_ROUTE_SNAPSHOT_COMPAT_REPAIR_R1 or precise RETURN; STOP.

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
