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
G3-C C2B-P0 Worktree reconciliation         IN_PROGRESS
G3-C C2B Synthetic Clash UI canary          NEXT_OWNER_CHECKPOINT
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

## CURRENT_ACCEPTED_STATE

- **Current production:** WireGuard remains connected and authoritative.
- **G3-C C1:** PASS; Windows Mihomo v1.19.32 accepted.
- **G3-C C2A synthetic UI repair:** technical/safety package accepted from commit `408f632c...`; timing gap recorded without replay.
- **C2B package identity:** reviewed runner blob `cd5a2eb768b54d13307b651ea514a912b9742c9d`; template blob `b50f9747157200670d6e85fdd53ba81e9a8c5c76`.
- **Executor interruption residue:** the managed worktree may still contain three unstaged superseded R1 closeout edits in `EXECUTION_EVIDENCE.md`, `EXECUTOR_HANDOFF.md`, and `docs/ROUND_TIMING_RETROSPECTIVE.md`.
- **Owner has explicitly resumed the main project on 2026-10-04.**
- **Benchmark detour remains cancelled and outside project governance.**

## CURRENT_GATE

```text
GATE_ID=G3C_C2B_PREFLIGHT_WORKTREE_RECONCILIATION_P0
STATE=AUTHORIZED
PREVIOUS_RESULT=PASS_TECHNICAL_WITH_RECORDED_TIMING_OBSERVABILITY_GAP
OWNER_CONTINUE_AUTHORIZATION=2026-10-04
OBJECTIVE=Reconcile and clean only the known superseded unstaged R1 closeout edits before the live Owner C2B checkpoint.
MAX_ENDPOINT_THIS_ROUND=Git/worktree/document reconciliation only; no C2B runner execution, Clash/Mihomo runtime, Secret, network, route, proxy/TUN/WG or VPS action.
MANDATORY_REVIEW_STOP=YES
EXPECTED_DIRTY_FILES=EXECUTION_EVIDENCE.md,EXECUTOR_HANDOFF.md,docs/ROUND_TIMING_RETROSPECTIVE.md
C2B_RUNNER_EXECUTION_AUTHORIZED=NO_IN_P0
CLASH_PROFILE_APPLY_AUTHORIZED=NO
MIHOMO_EXECUTION_AUTHORIZED=NO
SECRET_READ_AUTHORIZED=NO
NETWORK_REQUEST_AUTHORIZED=NO
WG_CHANGE_AUTHORIZED=NO
ROUTE_CHANGE_AUTHORIZED=NO
SYSTEM_PROXY_CHANGE_AUTHORIZED=NO
TUN_CHANGE_AUTHORIZED=NO
VPS_ACCESS_AUTHORIZED=NO
OWNER_INTERVENTION_REQUIRED=NO_IN_P0
ESTIMATED_EXECUTION_TIME=5-10_minutes
TIMING_OBSERVABILITY_REQUIRED=YES
```

### P0 TASK

1. First action: record `ROUND_STARTED_AT` before fetch/status/preflight.
2. Fresh fetch `origin/main`; do not reset or discard anything yet.
3. Inspect the managed worktree status and exact diffs for the three expected dirty files.
4. Require that there are **no other** modified/untracked files in `vpn-network-optimization/`. Any extra project file => RETURN.
5. Compare each dirty hunk against current canonical GitHub Evidence/Handoff/timing records.
6. If any dirty hunk contains unique factual evidence not already durably represented on `main`, RETURN with the exact file/hunk class; do not discard it.
7. If all three dirty files contain only superseded/duplicate R1 closeout text, discard **only those exact three unstaged modifications** back to current canonical `origin/main`.
8. Do not touch C2B source files; verify runner/template blobs remain exactly the accepted identities.
9. End state must be a clean project-scoped worktree for `vpn-network-optimization/`.
10. Persist only a bounded reconciliation record in Executor Handoff / Evidence if needed; do not alter C2B source or Reviewer Handoff.
11. Fresh GitHub read-back.
12. Record `ROUND_FINISHED_AT`, `ACTUAL_ELAPSED`, `TIME_OVERRUN=YES|NO`. If >10m record cause.
13. STOP_AT_REVIEWER.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires:
- no unique evidence lost;
- only the three known superseded unstaged docs were discarded, if present;
- project-scoped worktree clean;
- accepted C2B runner/template blob identities unchanged;
- no live/runtime/network/Secret action;
- complete timing.

### OWNER_ONLY_ACTIONS

NONE in P0.

### REVIEWER_TO_EXECUTOR_RELAY

Perform only the bounded worktree reconciliation. Do not run C2B.

### EXECUTOR_TO_REVIEWER_RELAY

Return `PASS_CANDIDATE_G3C_C2B_PREFLIGHT_WORKTREE_RECONCILIATION_P0` or precise `RETURN_*`; STOP_AT_REVIEWER.

## NEXT_STEP

Codex reconciles the interrupted R1 worktree. If P0 passes, Reviewer opens the live Owner C2B synthetic/no-traffic Clash UI canary immediately.

## OWNER_ACTION_REQUIRED

**NONE in P0.** Keep WireGuard and Clash unchanged.

## REVIEWER_TO_EXECUTOR_RELAY

Execute only C2B-P0 worktree reconciliation; do not run C2B.

## EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE_G3C_C2B_PREFLIGHT_WORKTREE_RECONCILIATION_P0 or precise RETURN; STOP.

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
