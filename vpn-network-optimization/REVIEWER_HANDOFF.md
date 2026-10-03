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
G3-C C2B Synthetic Clash UI canary          READY_NOT_STARTED
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
- **G3-C C2A synthetic UI repair:** technical/safety package accepted from commit `408f632c...`; timing start was missed and remains an explicit observability gap, with no technical replay.
- **Future C2B package:** synthetic/no-traffic only. WG baseline first/default; HY2 uses reserved documentation endpoint + fixture credentials; REALITY absent/cold.
- **Secret boundary:** no DPAPI/recovery/real HY2 credential access in C2B package.
- **Clash persistence boundary:** before/after profile-store filename+hash snapshots are required; no automatic deletion of unrelated Clash-owned files.
- **Benchmark detour:** cancelled by Owner. Ad-hoc latency testing is outside project governance unless explicitly reintroduced later.

## CURRENT_GATE

```text
GATE_ID=G3C_C2B_SYNTHETIC_CLASH_UI_CANARY
STATE=READY_NOT_STARTED
PREVIOUS_RESULT=PASS_TECHNICAL_WITH_RECORDED_TIMING_OBSERVABILITY_GAP
OWNER_CONTINUE_AUTHORIZATION=NOT_YET_REQUESTED
OBJECTIVE=Run the already-reviewed synthetic/no-traffic Clash UI canary when Owner chooses to resume the project.
MANDATORY_REVIEW_STOP=YES
OWNER_INTERVENTION_REQUIRED=YES_WHEN_RESUMED
REAL_SECRET_ACCESS_AUTHORIZED=NO
NETWORK_REQUEST_AUTHORIZED=NO
WG_DISCONNECT_REQUIRED=NO
SYSTEM_PROXY_CHANGE_AUTHORIZED=NO
TUN_CHANGE_AUTHORIZED=NO
ROUTE_CHANGE_AUTHORIZED=NO
REALITY_LIVE_NODE_AUTHORIZED=NO
ESTIMATED_EXECUTION_TIME=3-5_minutes
TIMING_OBSERVABILITY_REQUIRED=SCRIPT_EMBEDDED
```

### CURRENT_BOUNDARY

- Do not run C2B until Owner explicitly resumes the project.
- The reviewed runner is `scripts/c2b-owner-clash-ui-canary.ps1`.
- C2B proves UI visibility/default/manual selector semantics only; it does not prove HY2 connectivity.
- C2C remains the first stage allowed to consider real HY2 credentials/connectivity in Clash.

### OWNER_ONLY_ACTIONS

NONE now. Resume only on explicit Owner request.

### REVIEWER_TO_EXECUTOR_RELAY

No Executor action. Benchmark B1 is cancelled. C2A repair is accepted; wait for Owner to resume C2B.

### EXECUTOR_TO_REVIEWER_RELAY

No action until Owner resumes C2B.

## NEXT_STEP

Wait for Owner to resume the main project. The next governed step is the already-reviewed synthetic/no-traffic C2B UI canary.

## OWNER_ACTION_REQUIRED

**NONE.** Ad-hoc latency testing is separate from the project.

## REVIEWER_TO_EXECUTOR_RELAY

No Executor action. Benchmark B1 cancelled; wait for Owner to resume C2B.

## EXECUTOR_TO_REVIEWER_RELAY

No Executor action until Owner resumes C2B.

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
