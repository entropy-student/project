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
G3-A Network auto-adaptation + health       PASS
G3-B VPS migration + rollback package       IN_PROGRESS
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
- **HY2:** deployed server candidate remains ready for a separately reviewed activation Gate.
- **REALITY:** Mihomo v1.19.31 public TCP/443 path is validated and currently cold/clean; no persistent public listener exists.
- **G3-A H1:** advisory planner engineering PASS.
- **G3-A H2:** real read-only health/readiness collector PASS.
- **G3-A H3:** readiness-to-plan semantic integration PASS.
- **G3-A H4:** live read-only H2→H3 advisory integration PASS; current real state maps to `WIREGUARD_BASELINE`; HY2 and REALITY remain `READY_FOR_SEPARATE_ACTIVATION`.
- **G3-A boundary:** sensing/classification/advisory decision is complete. No automatic actuator/switching capability is authorized or implemented.
- **Final validation pending:** G4 peak-hour + representative Codex/OpenAI/image-generation workload validation remains mandatory before MVP v1 seal.

## CURRENT_GATE

```text
GATE_ID=G3B_MIGRATION_ROLLBACK_PACKAGE_DISCOVERY_D1
STATE=AUTHORIZED
PREVIOUS_RESULT=PASS_G3A_LIVE_READONLY_ADVISORY_INTEGRATION_H4
OWNER_CONTINUE_AUTHORIZATION=2026-10-03
SPECIALIST_TRIGGERS=11A_SHARED_VPS_STORAGE,11B_SSH_SECRET_TARGET_HOST,11C_DEPLOYMENT_NETWORK_RESOURCES
OBJECTIVE=Inventory and reconcile the existing migration/reinstall/rollback assets into a deterministic VPS migration package design without changing the current VPS or purchasing/provisioning a new provider.
MAX_ENDPOINT_THIS_ROUND=read-only repository discovery + package design/source changes + offline validation; no provider purchase, no new VPS, no live migration, no Secret rotation, no current-VPS mutation.
MANDATORY_REVIEW_STOP=YES
LIVE_MIGRATION_AUTHORIZED=NO
NEW_PROVIDER_PURCHASE_AUTHORIZED=NO
CURRENT_VPS_MUTATION_AUTHORIZED=NO
SECRET_ROTATION_AUTHORIZED=NO
ROLLBACK_STATUS=SOURCE_ONLY_REVERTABLE
ESTIMATED_EXECUTION_TIME=20-35_minutes
MIGRATION_MANIFEST_COMMIT=92e5d5eda83c09b74d6a07c59e47c531df8a85c8
MIGRATION_VALIDATOR_COMMIT=3d0741454fc7aa6bed2e92862a9e69d00c76c85c
MIGRATION_PLAN_COMMIT=f8c549b41699e43824f9ce68ff9306c9b03d5bec
WG_TEMPLATE_COMMIT=4c849e3f7a006f97614032d66bff604a369f26eb
HY2_TEMPLATE_COMMIT=6224820052285a17cff50f3570a0f926123f8f17
CLASH_TEMPLATE_COMMIT=58537223e13890a47ddae3387934acee30790fbe
STATIC_SOURCE_REVIEW=PASS
OWNER_PACKAGE_VALIDATION=PENDING
```

### TARGET_AND_SCOPE

- Reconcile existing assets first, especially:
  - `scripts/migration-reinstall.sh`
  - `scripts/rollback-uninstall.sh`
  - `scripts/preflight-linux.sh`
  - `scripts/health-check.sh`
  - existing WireGuard/HY2/Clash templates.
- Define the migration unit for this VPN project:
  - reconstructible software/config templates;
  - per-VPS network identity inputs;
  - Secret/certificate material classes and secure transfer/recovery procedure;
  - post-deploy health checks;
  - staged new→old cutover and rollback semantics;
  - exact old/new VPS identity proof.
- No Secret values may enter GitHub/chat/bundles.
- D1 does not create or mutate a VPS.

### REQUIRED_EVIDENCE

- current repository asset inventory and gaps;
- explicit classification of reconstructible vs Secret/recovery vs runtime-only assets;
- static/offline validation of migration package inputs;
- rollback procedure that does not depend on deleting the old working VPS first;
- no provider/API purchase or live-host mutation.

### ACCEPTANCE_CRITERIA

PASS for D1 requires a reviewable migration package design with exact inputs/outputs, target identity, Secret handling, health/read-back and rollback boundaries, while preserving the current VPS untouched.

### ROLLBACK_STATUS_OR_PLAN

Source-only D1 changes can be exactly reverted. Current runtime remains unchanged.

### OWNER_ONLY_ACTIONS

None in D1. Any provider purchase/new VPS provisioning, Secret rotation/transfer, or live cutover is a later explicit Owner-authorized Gate.

### REVIEWER_TO_EXECUTOR_RELAY

Inspect only the existing migration/reinstall/rollback/preflight/health/template assets needed for G3-B. Do not touch current VPS, Provider control plane, Secrets, or network state. Prefer adapting existing assets over creating duplicate migration paths.

### EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE after repository-only migration-package reconciliation and offline validation. Any need for live target provisioning or Secret movement requires a new Gate.

## NEXT_STEP

Run the G3-B D1 repository-only migration-package validator once under PowerShell 7.6.6 after syncing canonical `main`, then return the bounded output for Reviewer PASS/RETURN.

## OWNER_ACTION_REQUIRED

Run one repository-only PowerShell 7.6.6 validation of `scripts/g3b-migration-package-validator.ps1 -Validate`. It reads only tracked non-secret package files. No provider purchase, VPS mutation, Secret movement, or live cutover is authorized.

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
