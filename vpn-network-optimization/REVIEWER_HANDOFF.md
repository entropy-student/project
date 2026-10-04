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
- **Benchmark detour remains cancelled.**

## CURRENT_GATE

```text
GATE_ID=G3C_C2B_OWNER_ACL_BEHAVIOR_DIAGNOSTIC_D2
STATE=OWNER_ACTION_REQUIRED
PREVIOUS_RESULT=RETURN_C2B_OWNER_RUNTIME_ACL_INHERITANCE_ENABLED
OBJECTIVE=Determine which Owner-only ACL application method reliably produces a protected, owner-only DACL on the real Windows PowerShell 7.6.6 host.
MAX_ENDPOINT_THIS_ROUND=Safe ff-only sync -> locked ACL diagnostic identity -> create isolated temp ACL fixtures -> read back protection/owner/rules -> cleanup -> STOP_AT_REVIEWER.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Real Owner Windows host; temporary %LOCALAPPDATA% ACL diagnostic directories only.
APPLICABLE_CRITICAL_CONSTRAINTS=No C2B runner retry; no Clash/Mihomo/UI; no network/VPS/DPAPI/Secret; no route/proxy/TUN/WG mutation; temp ACL fixtures must be removed before completion.
ACL_DIAGNOSTIC=scripts/c2b-owner-acl-diagnostic.ps1
ACL_DIAGNOSTIC_BLOB=64bc2fd1c3dfe85250cb229a116202e5d9b6c460
SPECIALIST_RULES=11B_TARGET_HOST
ESTIMATED_EXECUTION_TIME=2-5_minutes
TIMING_OBSERVABILITY_REQUIRED=YES
```

### PREFLIGHT

1. Use the existing elevated PowerShell 7.6.6 Owner session.
2. Operate Git from the known C2B scripts directory; do not parse Git-emitted Chinese filesystem paths.
3. Require project scope clean, fetch origin/main, prove local HEAD ancestor of origin/main, and update only with ff-only.
4. Require post-sync project scope clean and exact ACL diagnostic blob identity.
5. Do not run `c2b-owner-clash-ui-canary.ps1` in this Gate.

### DIAGNOSTIC METHODS

- **Method A:** create a unique temporary directory using `Directory.CreateDirectory(path, DirectorySecurity)` with a protected owner-only ACL.
- **Method B:** create a unique temporary directory normally, then read its existing ACL, call `SetAccessRuleProtection(true,false)`, set Owner, set the Owner FullControl rule, and apply it using `Set-Acl`.
- For each method, read back only bounded ACL facts: protected flag, owner match, rule count, inherited-rule count, unauthorized-rule count, direct FullControl, and child-inheritance FullControl.
- Delete the entire temporary diagnostic root in `finally`.

### REQUIRED_EVIDENCE

- PowerShell 7.6.6 / Administrator / High integrity;
- safe ff-only synchronization and clean project scope;
- exact diagnostic blob;
- Method A bounded ACL facts;
- Method B bounded ACL facts;
- `ACL_DIAGNOSTIC=PASS` or precise RETURN;
- `TEMP_ACL_DIAGNOSTIC_CLEANUP=PASS`;
- `NETWORK_MUTATION=NONE`;
- `SECRET_VALUES_EMITTED=0`;
- complete timing.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires at least one method to prove `PROTECTED=True`, `OWNER_MATCH=True`, zero inherited rules, zero unauthorized rules, Owner direct FullControl, Owner child FullControl, and successful cleanup. No ACL requirement may be weakened merely to make C2B pass.

### ROLLBACK_STATUS_OR_PLAN

All diagnostic writes are isolated under a unique temporary %LOCALAPPDATA% path and removed in finally. No production/runtime/network state is authorized to change.

### OWNER_ONLY_ACTIONS

Run the Reviewer-supplied single atomic D2 checkpoint and return its complete non-secret output.

### REVIEWER_TO_EXECUTOR_RELAY

Do not rerun C2B. Wait for Owner D2 output; persist only bounded ACL diagnostic facts; STOP_AT_REVIEWER.

### EXECUTOR_TO_REVIEWER_RELAY

Return `PASS_CANDIDATE_G3C_C2B_OWNER_ACL_BEHAVIOR_DIAGNOSTIC_D2` or precise `RETURN_*`; STOP_AT_REVIEWER.

## NEXT_STEP

Run the isolated ACL behavior diagnostic. Reviewer will choose the minimal ACL implementation repair only from the method that proves the full Owner-only ACL invariant on the real host.

## OWNER_ACTION_REQUIRED

Run the D2 atomic PowerShell checkpoint supplied by Reviewer. Do not rerun C2B.

## REVIEWER_TO_EXECUTOR_RELAY

Wait for D2 Owner output. No C2B patch/retry until Reviewer accepts an ACL application method.

## EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE_G3C_C2B_OWNER_ACL_BEHAVIOR_DIAGNOSTIC_D2 or precise RETURN; STOP.

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
