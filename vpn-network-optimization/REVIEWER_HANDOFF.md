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
- **G2-C REALITY:** public TCP/443 canary is formally PASS and closed; replay is forbidden without a new Gate.
- **G3-A H1:** advisory planner source/offline engineering PASS with 9 deterministic fixtures and zero mutation.
- **G3-A H2:** read-only health/readiness collection PASS after the control-route validator repair; 10 fixtures PASS.
- **Current live facts from H2:** WireGuard current health = `HEALTHY`; HY2 readiness = `READY_FOR_SEPARATE_ACTIVATION`; REALITY readiness = `READY_FOR_SEPARATE_ACTIVATION`.
- **Residue checks:** P1 route residue 0; TCP/443 and 14443 free; G2-C runtime residue 0.
- **Automation boundary:** no live automatic switching has been authorized. H1/H2 are advisory/read-only only.
- **Final validation pending:** G4 peak-hour and representative Codex/OpenAI/image-generation workload validation remains mandatory before MVP v1 seal.

## CURRENT_GATE

```text
GATE_ID=G3A_READINESS_TO_PLAN_INTEGRATION_H3
STATE=AUTHORIZED
PREVIOUS_RESULT=PASS_G3A_READONLY_HEALTH_READINESS_H2
OWNER_CONTINUE_AUTHORIZATION=2026-10-03
SPECIALIST_TRIGGERS=11C_DEPLOYMENT_NETWORK_RESOURCES,11D_AUTOMATION
OBJECTIVE=Integrate H2 readiness semantics into the advisory planner without live activation, so current health and candidate readiness are not conflated.
MAX_ENDPOINT_THIS_ROUND=project-owned planner source change + deterministic offline fixtures + Owner self-test + Reviewer stop.
MANDATORY_REVIEW_STOP=YES
LIVE_NETWORK_ACTIVATION_AUTHORIZED=NO
REAL_OPENAI_REQUEST_AUTHORIZED=NO
SSH_OR_REMOTE_COLLECTION_AUTHORIZED=NO_IN_H3_SELFTEST
SECRET_READ_AUTHORIZED=NO
ROLLBACK_STATUS=SOURCE_ONLY_REVERTABLE
ESTIMATED_EXECUTION_TIME=10-20_minutes
IMPLEMENTATION_COMMIT=36f44502b6347d6478dea43afc18c9cfc1da91b5
STATIC_SOURCE_REVIEW=PASS
OWNER_SELFTEST_PROOF=PENDING
```

### TARGET_AND_SCOPE

- Update `scripts/g3a-network-adaptation-planner.ps1`.
- Replace HY2/REALITY "health" input semantics with explicit candidate readiness semantics:
  - `READY_FOR_SEPARATE_ACTIVATION`
  - `NOT_READY`
  - `UNKNOWN`
- Preserve WireGuard as `HEALTHY | UNHEALTHY | UNKNOWN` because it is the current active production path.
- Advisory policy:
  - WG HEALTHY => remain `WIREGUARD_BASELINE`;
  - WG UNHEALTHY + HY2 READY => advise `HY2_FALLBACK_CANDIDATE`;
  - WG UNHEALTHY + HY2 NOT_READY + REALITY READY => advise `REALITY_FALLBACK_CANDIDATE`;
  - any required UNKNOWN => fail closed;
  - no usable candidate => fail closed.
- Route output remains intent-only with `ApplyAllowed=false`.

### REQUIRED_EVIDENCE

- AST/static review;
- no network/service/proxy/TUN/SSH/HTTP mutation/action code introduced;
- no historical physical-egress constants introduced;
- deterministic fixtures for WG healthy, HY2 fallback, REALITY fallback, UNKNOWN readiness, and no candidate;
- H2 accepted state maps to `WIREGUARD_BASELINE`;
- Owner PowerShell 7.6.6 self-test PASS with mutation counters zero.

### ACCEPTANCE_CRITERIA

PASS requires semantic separation of current health vs candidate readiness, all fixtures PASS, H2 accepted state maps to WireGuard baseline, and zero live mutation/action.

### ROLLBACK_STATUS_OR_PLAN

Exact source commit revert only. H3 has no runtime mutation.

### OWNER_ONLY_ACTIONS

Run one bounded fixture-only self-test after Reviewer static review.

### REVIEWER_TO_EXECUTOR_RELAY

Modify only `scripts/g3a-network-adaptation-planner.ps1`. Use H2 accepted enum semantics above. Do not invoke H2 collector, SSH, HTTP, route/service mutation, or live network reads in the H3 self-test.

### EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE only after static source review and deterministic self-test. Any live activation requirement returns for a new Gate.

## NEXT_STEP

Run the H3 planner fixture-only `-SelfTest` once on the Owner host and return the bounded output for Reviewer PASS/RETURN. No live network collection or switching occurs.

## OWNER_ACTION_REQUIRED

Run one fixture-only PowerShell 7.6.6 `-SelfTest` after syncing canonical `main`. Do not use `-ReadOnlySnapshot`; H3 self-test must not read or change live network state.

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
