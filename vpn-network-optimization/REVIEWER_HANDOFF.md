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
- **Benchmark detour remains cancelled.**

## CURRENT_GATE

```text
GATE_ID=G3C_C2B_OWNER_SYNTHETIC_UI_CANARY_R2R1_O1
STATE=OWNER_ACTION_REQUIRED
PREVIOUS_RESULT=RETURN_C2B_OWNER_RUNTIME_PREFLIGHT_FAILED
OBJECTIVE=Run the already-reviewed C2B synthetic/no-traffic UI canary on the real Owner Windows host from an elevated PowerShell 7.6.6 High-integrity session.
MAX_ENDPOINT_THIS_ROUND=Owner-local runtime self-check -> existing one-shot C2B runner -> synthetic profile import/visual check/removal -> runner post-readback/cleanup -> STOP_AT_REVIEWER.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Real Owner Windows host only; existing reviewed runner/template/package; no source changes.
APPLICABLE_CRITICAL_CONSTRAINTS=PowerShell exactly 7.6.6; Administrator; High integrity; production WireGuard remains connected; synthetic/no-traffic only; no DPAPI/recovery/real Secret; no real HY2 endpoint or traffic; no VPS/REALITY; no route/proxy/TUN/WG mutation.
EXECUTOR_PREFLIGHT_PROVENANCE=OWNER_RELAYED_EXECUTOR_REPORT
EXECUTOR_PREFLIGHT_CANONICAL_MAIN=d87fbddce8c4e74b988d8683ff6c35b84b4c59b4
EXECUTOR_PREFLIGHT_GATE_ALIGNMENT=PASS
EXECUTOR_PREFLIGHT_PROJECT_SCOPE_CLEAN=PASS
EXECUTOR_PREFLIGHT_RUNNER_TEMPLATE_BLOBS=PASS
EXECUTOR_RUNTIME_POWERSHELL=7.6.5
EXECUTOR_RUNTIME_ADMINISTRATOR=False
EXECUTOR_RUNTIME_INTEGRITY_RID=8192
RUNNER_STARTED_BY_EXECUTOR=NO
RUNNER=scripts/c2b-owner-clash-ui-canary.ps1
RUNNER_BLOB=cd5a2eb768b54d13307b651ea514a912b9742c9d
TEMPLATE_BLOB=b50f9747157200670d6e85fdd53ba81e9a8c5c76
OWNER_LOCAL_RUNNER_PATH=C:\Users\34707\.codex\worktrees\g2b-runner-binding-cleanup\VPS搭建\vpn-network-optimization\scripts\c2b-owner-clash-ui-canary.ps1
SPECIALIST_RULES=11B_TARGET_HOST
ESTIMATED_EXECUTION_TIME=5-10_minutes
TIMING_OBSERVABILITY_REQUIRED=YES
```

### PREFLIGHT

1. Owner uses the real Windows host and starts **PowerShell 7.6.6 as Administrator**.
2. One atomic checkpoint must verify before the runner starts:
   - PowerShell version is exactly 7.6.6;
   - Administrator role is true;
   - integrity RID is High (`>=12288`);
   - the exact reviewed runner path exists.
3. If any of those checks fail, stop before the runner and return the bounded failure; do not improvise another shell/runtime/path.
4. If the self-check passes, invoke the existing runner exactly once. Do not edit the runner/template/package.
5. The runner owns its own timing and runtime/network/profile-store checks. Any runner failure remains fail-closed.

### OWNER CHECKPOINT

When the runner reaches the UI prompt:
1. import **only** the synthetic profile path printed by the runner;
2. leave production WireGuard and the active production profile unchanged;
3. confirm `WG-BASELINE`, synthetic `HY2-SFO3`, and the manual selector are visible;
4. keep `WG-BASELINE` current/default;
5. do **not** select HY2 and do not send HY2 traffic;
6. remove the imported synthetic profile in Clash Verge;
7. type the exact acknowledgement string requested by the runner.

### REQUIRED_EVIDENCE

- Owner-local self-check: PowerShell 7.6.6, Administrator=true, integrity RID >=12288, exact runner path exists;
- runner `ROUND_STARTED_AT`, `ROUND_FINISHED_AT`, `ACTUAL_ELAPSED`, `TIME_OVERRUN`;
- `C2B_PREFLIGHT=PASS`;
- `MIHOMO_CONFIG_TEST=PASS`;
- structured Owner acknowledgement;
- `CLASH_PROFILE_STORE_POSTREMOVE=PASS`;
- `POST_UI_NETWORK_READBACK=PASS`;
- `LOCAL_RUNTIME_CLEANUP=PASS`;
- WireGuard remains connected; system proxy OFF; TUN OFF; routes unchanged;
- `SECRET_VALUES_EMITTED=0`;
- no real HY2/REALITY/VPS/DPAPI/Secret action.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires all required evidence above, no unrelated profile-store/network mutation, no real HY2/REALITY traffic, complete runner timing, and STOP_AT_REVIEWER.

### ROLLBACK_STATUS_OR_PLAN

No production mutation is authorized. WireGuard is the continuity baseline. The Owner removes the synthetic profile before acknowledgement; the runner cleans only its exact project-owned temporary runtime. Any unexpected network/profile-store delta stops for Reviewer reconciliation.

### OWNER_ONLY_ACTIONS

Run the single reviewed Owner-local checkpoint and perform only the bounded Clash Verge import/inspect/remove/acknowledge UI steps it requests.

### REVIEWER_TO_EXECUTOR_RELAY

Do not attempt the runner again from the Codex shell. Wait for the Owner-local checkpoint result; then persist bounded evidence only and STOP_AT_REVIEWER.

## EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE_G3C_C2B_OWNER_SYNTHETIC_UI_CANARY_R2R1_O1 or precise RETURN; STOP.

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
