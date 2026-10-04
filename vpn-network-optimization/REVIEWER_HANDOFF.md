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
- **Benchmark detour remains cancelled.**

## CURRENT_GATE

```text
GATE_ID=G3C_C2B_OWNER_SUBDIR_GIT_SYNC_AND_DIAGNOSTIC_D1R3
STATE=OWNER_ACTION_REQUIRED
PREVIOUS_RESULT=RETURN_RUNNER_OUTSIDE_GIT_ROOT_PATH_ENCODING
OBJECTIVE=Avoid decoding Git paths containing Chinese characters by running all Git operations from the already-proven runner directory, safely ff-only synchronize origin/main, prove the diagnostic file identity, and run only D1.
MAX_ENDPOINT_THIS_ROUND=Runner-directory Git-context proof -> project-scope cleanliness via relative pathspec -> fetch origin main -> ancestor proof -> ff-only update -> diagnostic tracked/content proof -> D1 read-only diagnostic -> STOP_AT_REVIEWER.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Known runner directory under the existing Codex worktree; no Git top-level path parsing or Unicode path comparison.
APPLICABLE_CRITICAL_CONSTRAINTS=No reset/force/stash/rebase/checkout overwrite; no decoded Git path used as a Windows filesystem locator; fail on dirt/divergence; no C2B retry; no Clash/Mihomo UI; no DPAPI/Secret; no VPS; no route/proxy/TUN/WG mutation.
KNOWN_EXISTING_RUNNER_PATH=C:\Users\34707\.codex\worktrees\g2b-runner-binding-cleanup\VPS搭建\vpn-network-optimization\scripts\c2b-owner-clash-ui-canary.ps1
PROJECT_DIR_BASENAME=vpn-network-optimization
DIAGNOSTIC_FILENAME=c2b-network-state-shape-diagnostic.ps1
DIAGNOSTIC_BLOB=895af3b8c2adccec3a8671ad8130792e4bdca3c3
SPECIALIST_RULES=11B_TARGET_HOST
ESTIMATED_EXECUTION_TIME=2-5_minutes
TIMING_OBSERVABILITY_REQUIRED=YES
```

### PREFLIGHT

1. Use the real Windows host and elevated PowerShell 7.6.6.
2. Require the known runner path to exist; derive `runnerDir` and `projectDir` using .NET filesystem operations only.
3. Require `projectDir` basename exactly `vpn-network-optimization`.
4. Prove `runnerDir` is inside a Git worktree using `git -C <runnerDir> rev-parse --is-inside-work-tree`; do not read or compare `--show-toplevel`.
5. Prove the runner is tracked using `git -C <runnerDir> ls-files --error-unmatch -- c2b-owner-clash-ui-canary.ps1`; do not consume the path text.
6. Require project-scope clean with `git -C <runnerDir> status --porcelain -- ..`; do not print dirty path text. Any non-empty result => RETURN.
7. Fetch only `origin main`; read only ASCII commit IDs from `rev-parse HEAD` and `rev-parse origin/main`.
8. Require HEAD ancestor of origin/main; update only by `git -C <runnerDir> merge --ff-only origin/main`.
9. Require post-update project scope clean.
10. Require the D1 diagnostic file at `Join-Path runnerDir DIAGNOSTIC_FILENAME`, prove it is tracked using basename-relative `ls-files --error-unmatch`, and prove its working-tree Git blob with `hash-object` equals the locked blob.
11. Only then run D1. Do not run C2B.

### REQUIRED_EVIDENCE

- Owner runtime pass;
- Git worktree context pass without top-level path decoding;
- runner tracked;
- pre-sync project clean;
- HEAD before / origin/main commit;
- ancestor + ff-only pass;
- HEAD after / post-sync project clean;
- diagnostic tracked + blob match;
- D1 bounded property-shape output, timing, `NETWORK_MUTATION=NONE`, `SECRET_VALUES_EMITTED=0`.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires no Git-path decoding dependency, clean + ancestor-proven ff-only synchronization, exact diagnostic identity, and successful read-only D1 evidence. Any dirt/divergence/Git failure/blob mismatch/diagnostic failure/mutation => precise RETURN.

### ROLLBACK_STATUS_OR_PLAN

No destructive Git operation is authorized. The only repository update is ancestor-proven ff-only. D1 is read-only.

### OWNER_ONLY_ACTIONS

Run the Reviewer-supplied single atomic D1R3 PowerShell checkpoint in the current elevated 7.6.6 window and return its complete non-secret output.

### REVIEWER_TO_EXECUTOR_RELAY

Do not rerun or patch C2B. Wait for Owner D1R3 output; persist bounded Git-sync/diagnostic facts only; STOP_AT_REVIEWER.

### EXECUTOR_TO_REVIEWER_RELAY

Return `PASS_CANDIDATE_G3C_C2B_OWNER_SUBDIR_GIT_SYNC_AND_DIAGNOSTIC_D1R3` or precise `RETURN_*`; STOP_AT_REVIEWER.

## NEXT_STEP

Use Git entirely from the known runner directory, avoiding Git-emitted Chinese filesystem paths. If the project is clean and safely fast-forwardable, synchronize canonical main and run only D1.

## OWNER_ACTION_REQUIRED

Run the D1R3 atomic PowerShell checkpoint supplied by Reviewer. Do not rerun C2B.

## REVIEWER_TO_EXECUTOR_RELAY

Wait for D1R3 Owner output. No C2B patch/retry until Reviewer receives D1 property-shape evidence.

## EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE_G3C_C2B_OWNER_SUBDIR_GIT_SYNC_AND_DIAGNOSTIC_D1R3 or precise RETURN; STOP.

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
