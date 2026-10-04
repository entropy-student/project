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
- **Benchmark detour remains cancelled.**

## CURRENT_GATE

```text
GATE_ID=G3C_C2B_OWNER_WORKTREE_SYNC_AND_DIAGNOSTIC_D1R1
STATE=OWNER_ACTION_REQUIRED
PREVIOUS_RESULT=RETURN_D1_DIAGNOSTIC_NOT_PRESENT_LOCAL_WORKTREE
OBJECTIVE=Safely fast-forward the existing clean project worktree to current origin/main, prove the reviewed diagnostic blob is present, then run only that read-only diagnostic.
MAX_ENDPOINT_THIS_ROUND=Project-scoped cleanliness check -> git fetch origin main -> ff-only update if safe -> diagnostic blob verification -> read-only D1 diagnostic -> STOP_AT_REVIEWER.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=C:\Users\34707\.codex\worktrees\g2b-runner-binding-cleanup\VPS搭建; local Git synchronization plus read-only diagnostic only.
APPLICABLE_CRITICAL_CONSTRAINTS=No reset/force/stash/checkout overwrite; fail if project scope dirty or branch cannot fast-forward; no C2B runner retry; no Clash/Mihomo UI; no DPAPI/Secret; no VPS; no route/proxy/TUN/WG mutation.
DIAGNOSTIC_RELATIVE_PATH=vpn-network-optimization/scripts/c2b-network-state-shape-diagnostic.ps1
DIAGNOSTIC_BLOB=895af3b8c2adccec3a8671ad8130792e4bdca3c3
SPECIALIST_RULES=11B_TARGET_HOST
ESTIMATED_EXECUTION_TIME=2-5_minutes
TIMING_OBSERVABILITY_REQUIRED=YES
```

### PREFLIGHT

1. Use the real Windows host and the existing elevated PowerShell 7.6.6 session.
2. Target exactly the existing Codex worktree root above.
3. Require `git status --porcelain -- vpn-network-optimization` to be empty before any local Git update.
4. Fetch only `origin main`; any native Git failure stops the Gate.
5. Require current local HEAD to be an ancestor of fetched `origin/main`; otherwise RETURN without merge/reset/rebase/stash.
6. Update only with `git merge --ff-only origin/main`.
7. Require post-update project scope clean and diagnostic file Git blob exactly `895af3b8c2adccec3a8671ad8130792e4bdca3c3`.
8. Only then run the reviewed D1 diagnostic. Do not run the C2B canary runner.

### REQUIRED_EVIDENCE

- PowerShell 7.6.6 / Administrator / High integrity;
- pre-sync project-scope clean;
- pre-sync HEAD;
- fetched origin/main;
- ancestor check PASS;
- ff-only update PASS;
- post-sync HEAD and project-scope clean;
- diagnostic file exists and blob matches;
- D1 diagnostic bounded output, timing, `NETWORK_MUTATION=NONE`, `SECRET_VALUES_EMITTED=0`.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires safe ff-only synchronization with no local project content discarded, exact diagnostic identity, and successful bounded D1 read-only output. Any dirt, divergence, Git failure, blob mismatch, mutation, or diagnostic failure returns precisely and stops.

### ROLLBACK_STATUS_OR_PLAN

The local update is ff-only to canonical origin/main; no destructive Git operation is authorized. If any precondition fails, no local revision change occurs. The diagnostic is read-only.

### OWNER_ONLY_ACTIONS

Run the single Reviewer-supplied atomic PowerShell checkpoint in the existing elevated PowerShell 7.6.6 window and return its complete non-secret output.

### REVIEWER_TO_EXECUTOR_RELAY

Do not rerun C2B. Wait for Owner output from D1R1, persist bounded Git-sync/diagnostic facts only, and STOP_AT_REVIEWER.

### EXECUTOR_TO_REVIEWER_RELAY

Return `PASS_CANDIDATE_G3C_C2B_OWNER_WORKTREE_SYNC_AND_DIAGNOSTIC_D1R1` or precise `RETURN_*`; STOP_AT_REVIEWER.

## NEXT_STEP

Owner performs one safe ff-only synchronization of the existing clean worktree and, only if the exact diagnostic appears with the accepted blob, runs the read-only D1 diagnostic.

## OWNER_ACTION_REQUIRED

Run the atomic PowerShell checkpoint supplied by Reviewer in the existing elevated PowerShell 7.6.6 session; do not manually locate/copy files and do not rerun the C2B canary runner.

## REVIEWER_TO_EXECUTOR_RELAY

Wait for the D1R1 Owner-local result. Do not run, patch, or retry C2B before Reviewer sees the diagnostic output.

## EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE_G3C_C2B_OWNER_WORKTREE_SYNC_AND_DIAGNOSTIC_D1R1 or precise RETURN; STOP.

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
