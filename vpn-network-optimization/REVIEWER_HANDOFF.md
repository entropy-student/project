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
G2-A HY2 side-by-side deployment            PASS
G2-A DPAPI recovery closure                 PASS
G2-B Safe-window WG vs HY2 validation       PASS
G2-C VLESS+REALITY side-by-side candidate   PASS
G3-A Network auto-adaptation + health       IN_PROGRESS
G3-B VPS migration + rollback package       PENDING
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
│  └─ Windows Mihomo v1.19.31 client
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
- Windows client: Clash Verge 2.5.6; Mihomo v1.19.31 / alpha-f103639 available.
- Owner execution runtime: PowerShell 7.6.6, Administrator, High integrity.
- HY2 recovery: canonical DPAPI CurrentUser recovery artifact validated; do not re-fetch or rotate VPS Secrets.

## CURRENT_ACCEPTED_STATE

- **Current production/rollback:** WireGuard remains the active production/rollback path.
- **G2-C REALITY:** public TCP/443 canary PASS and closed; no replay without a new Gate.
- **G3-A H1:** advisory planner engineering PASS.
- **G3-A H2:** read-only health/readiness collector PASS after the control-route validator repair.
- **G3-A H3:** readiness-to-plan semantic integration PASS with 10 deterministic fixtures.
- **Current accepted live state:** WireGuard = `HEALTHY`; HY2 = `READY_FOR_SEPARATE_ACTIVATION`; REALITY = `READY_FOR_SEPARATE_ACTIVATION`.
- **Automation boundary:** no live automatic switching is authorized; all G3-A work so far is advisory/read-only.
- **Final validation pending:** G4 peak-hour + representative Codex/OpenAI/image-generation workload validation remains mandatory before MVP v1 seal.

## CURRENT_GATE

```text
GATE_ID=G3A_LIVE_READONLY_ADVISORY_INTEGRATION_H4
STATE=AUTHORIZED
PREVIOUS_RESULT=PASS_G3A_READINESS_TO_PLAN_INTEGRATION_H3
OWNER_CONTINUE_AUTHORIZATION=2026-10-03
SPECIALIST_TRIGGERS=11B_SSH_TARGET_HOST,11C_DEPLOYMENT_NETWORK_RESOURCES,11D_AUTOMATION
OBJECTIVE=Integrate the accepted H2 live read-only collector with the accepted H3 advisory planner and prove one real current-state advisory decision without any activation.
MAX_ENDPOINT_THIS_ROUND=project-owned orchestrator source + offline parser/self-test + one Owner live read-only integrated run + Reviewer stop.
MANDATORY_REVIEW_STOP=YES
LIVE_NETWORK_ACTIVATION_AUTHORIZED=NO
ROUTE_SERVICE_PROXY_TUN_MUTATION_AUTHORIZED=NO
REAL_OPENAI_REQUEST_AUTHORIZED=NO
PUBLIC_LISTENER_CREATION_AUTHORIZED=NO
SECRET_READ_AUTHORIZED=NO
ROLLBACK_STATUS=SOURCE_ONLY_REVERTABLE
ESTIMATED_EXECUTION_TIME=10-20_minutes
IMPLEMENTATION_COMMIT=ff1c46ef114180651a1e49bfbcc8a76c6bccad2f
STATIC_SOURCE_REVIEW=PASS
OWNER_INTEGRATED_READONLY_PROOF=PASS
OWNER_SELFTEST_PROOF=PENDING
```

### TARGET_AND_SCOPE

- New orchestrator: `scripts/g3a-advisory-decision-readonly.ps1`.
- Reuse, do not duplicate:
  - H2 collector: `g3a-health-readiness-readonly.ps1`;
  - H3 planner: `g3a-network-adaptation-planner.ps1`.
- Orchestrator flow:
  1. run H2 collector read-only;
  2. require `G3A_H2_READONLY_RESULT=COMPLETE`;
  3. parse only allowlisted machine-state keys;
  4. feed those exact states into H3 planner;
  5. require planner `AdvisoryOnly=true`, `ProductionDefaultChangeAllowed=false`, and route `ApplyAllowed=false`;
  6. output one integrated advisory decision.
- H4 may repeat H2's strict read-only SSH probe but may not create routes/listeners or send external workload traffic.

### REQUIRED_EVIDENCE

- orchestrator AST/static source review;
- no mutating network/service/proxy/TUN/VPS commands;
- no HTTP/OpenAI workload calls;
- fixture tests for complete healthy H2 payload, missing required key, incomplete H2 marker, invalid enum, and planner refusal propagation;
- Owner live read-only run;
- integrated current decision expected to remain `WIREGUARD_BASELINE` while accepted H2 state remains unchanged;
- explicit zero-mutation/request markers.

### ACCEPTANCE_CRITERIA

PASS requires:
- H2 and H3 are invoked as canonical components rather than reimplemented;
- incomplete/ambiguous collector output fails closed;
- live integrated result is advisory-only;
- current accepted healthy-WG state maps to `WIREGUARD_BASELINE`;
- zero route/service/proxy/TUN/VPS mutation and zero external workload requests.

### ROLLBACK_STATUS_OR_PLAN

Source-only orchestrator can be reverted exactly. Live run is read-only, so no runtime rollback is applicable.

### OWNER_ONLY_ACTIONS

Run one bounded H4 integrated read-only command after Reviewer static review.

### REVIEWER_TO_EXECUTOR_RELAY

Create only `scripts/g3a-advisory-decision-readonly.ps1`. Invoke the accepted H2 collector and H3 planner; do not copy their decision/probe logic. No live mutation, listener creation, external HTTP/OpenAI request, or Secret read.

### EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE only after offline parser/self-test and static negative review. Formal PASS still requires one Owner live read-only integrated run.

## NEXT_STEP

Run H4 fixture-only `-SelfTest` once and return its bounded output. The live read-only integration proof is already accepted; do not replay it.

## OWNER_ACTION_REQUIRED

Run only H4 `-SelfTest` once under PowerShell 7.6.6. The live `-RunReadOnly` proof is already accepted and must not be replayed merely to satisfy missing self-test evidence.

## REVIEWER_TO_EXECUTOR_RELAY

Read only the current G3-A Gate, accepted G2-C P1 Evidence, and the target planner source. Do not replay G2-C or reconstruct historical Gates. H1 is source/offline only and must stop before any live network action.

## EXECUTOR_TO_REVIEWER_RELAY

Use the fixed P1 packet in `CURRENT_GATE` after authorization.

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
