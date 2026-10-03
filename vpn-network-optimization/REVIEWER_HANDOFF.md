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
G3-C C2B-P0 Local-fact persistence          IN_PROGRESS
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
- **G3-C C2A repair:** accepted technically; C2B runner/template identities remain accepted.
- **P0 result:** the managed Executor worktree contains exactly the three expected dirty R1 closeout documents, but they contain unique facts not yet durable on canonical main. They must not be discarded.
- **Unique fact classes reported by Executor:** GitHub fresh-read-back, Git persistence timing, and safe fast-forward/reconciliation result.
- **No live action occurred in P0.**
- **Benchmark detour remains cancelled.**

## CURRENT_GATE

```text
GATE_ID=G3C_C2B_P0_LOCAL_FACT_PERSISTENCE_R1
STATE=AUTHORIZED
PREVIOUS_RESULT=RETURN_P0_LOCAL_FACTS_NOT_DURABLE
OWNER_CONTINUE_AUTHORIZATION=2026-10-04
OBJECTIVE=Persist only the unique factual R1 closeout material from the three dirty local documents onto the latest canonical main without reintroducing stale Gate/status text.
MAX_ENDPOINT_THIS_ROUND=Git/document reconciliation only; no C2B runner, Clash/Mihomo, DPAPI/Secret, network, route, proxy/TUN/WG or VPS action.
MANDATORY_REVIEW_STOP=YES
SOURCE_DIRTY_FILES=EXECUTION_EVIDENCE.md,EXECUTOR_HANDOFF.md,docs/ROUND_TIMING_RETROSPECTIVE.md
DISCARD_SOURCE_DIRTY_HUNKS_BEFORE_PERSISTENCE=NO
BLIND_WHOLE_FILE_OVERWRITE_AUTHORIZED=NO
STALE_REVIEWER_GATE_REINTRODUCTION_AUTHORIZED=NO
C2B_SOURCE_MODIFICATION_AUTHORIZED=NO
C2B_RUNNER_EXECUTION_AUTHORIZED=NO
LIVE_ACTION_AUTHORIZED=NO
OWNER_INTERVENTION_REQUIRED=NO
ESTIMATED_EXECUTION_TIME=8-15_minutes
TIMING_OBSERVABILITY_REQUIRED=YES
```

### R1 TASK

1. **First action before fetch/status/diff:** record `ROUND_STARTED_AT=<UTC ISO8601>`.
2. Preserve the existing dirty worktree exactly until the unique facts are captured.
3. Fresh fetch the latest `origin/main`; unrelated main advancement is expected and must not trigger VPN technical replay.
4. Inspect exact diffs for only the three source dirty files.
5. Classify every dirty hunk as:
   - `UNIQUE_FACT_TO_PERSIST`;
   - `ALREADY_DURABLE_DUPLICATE`;
   - `STALE_STATE_OR_GATE_TEXT_DO_NOT_PERSIST`.
6. The minimum unique fact set expected from the RETURN is:
   - final GitHub fresh-read-back fact(s);
   - Git persistence timing fact(s);
   - safe fast-forward/reconciliation result.
   If the local diff contains any other unique factual material, include it explicitly in Evidence and preserve it.
7. Do **not** commit the dirty files wholesale from the stale local base. Instead, reconcile only the unique factual hunks into the latest canonical versions of:
   - `EXECUTION_EVIDENCE.md`;
   - `EXECUTOR_HANDOFF.md`;
   - `docs/ROUND_TIMING_RETROSPECTIVE.md`.
8. Current Reviewer Gate/state must remain the R1 Gate from canonical main; local stale Gate/status prose must not overwrite it.
9. Do not modify C2B runner/template/validator/package source.
10. After the unique facts are safely committed and fresh-read back from GitHub, clean the original three local unstaged closeout edits only if they are now fully represented durably.
11. Require project-scoped worktree clean at the end. If any source hunk cannot be proven durable, RETURN and preserve it.
12. Verify accepted C2B runner/template blob identities unchanged.
13. Record finish/elapsed/overrun. If >15m, record the specific Git/document phase causing it.
14. STOP_AT_REVIEWER.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires:
- every unique local fact is durable on latest canonical main;
- no stale Gate/status text reintroduced;
- no unique source fact discarded before durability proof;
- original three dirty local edits are clean only after durability proof;
- C2B source blobs unchanged;
- no live/runtime/network/Secret action;
- complete timing;
- GitHub fresh read-back confirms the persistence commit is in current main or safely reconciled after unrelated main movement.

### OWNER_ONLY_ACTIONS

NONE.

### REVIEWER_TO_EXECUTOR_RELAY

Persist only the unique facts from the three dirty R1 closeout docs onto latest canonical state; do not overwrite whole stale files and do not run C2B.

### EXECUTOR_TO_REVIEWER_RELAY

Return `PASS_CANDIDATE_G3C_C2B_P0_LOCAL_FACT_PERSISTENCE_R1` or precise `RETURN_*`; STOP_AT_REVIEWER.

## NEXT_STEP

Codex durably persists the three local R1 closeout fact classes. If R1 passes and the worktree is clean, Reviewer opens C2B Owner synthetic/no-traffic UI canary.

## OWNER_ACTION_REQUIRED

**NONE.** Keep WireGuard and Clash unchanged.

## REVIEWER_TO_EXECUTOR_RELAY

Execute only P0-R1 local-fact persistence; no live action and no whole-file stale overwrite.

## EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE_G3C_C2B_P0_LOCAL_FACT_PERSISTENCE_R1 or precise RETURN; STOP.

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
