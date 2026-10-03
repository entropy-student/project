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
G2-C VLESS+REALITY side-by-side candidate  IN_PROGRESS
G3-A Network auto-adaptation + health       PENDING
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

- **Current production/rollback:** WireGuard on Windows; IPv4 split defaults `0.0.0.0/1` + `128.0.0.0/1`; strict WireGuard WFP kill-switch is not active.
- **HY2:** official v2.12.3 is active on UDP/8443. Same-window 60+60 comparison passed on both protocols and favored HY2 in that tested window; peak-hour/representative workload superiority remains unproven.
- **REALITY implementation:** Mihomo v1.19.31 is the accepted v1 server candidate after the private implementation A/B.
- **Public REALITY path:** `G2C_REALITY_PUBLIC_TCP443_CANARY_P1` is formally PASS. One temporary public TCP/443 canary used a dynamically discovered physical-egress /32 route and returned curl 0 / HTTP 401 through VLESS+REALITY+Vision.
- **P1 cleanup:** temporary server/client/runtime and exact /32 route were removed; TCP/443 and 14443 were absent afterward; WG/HY2, system proxy, WinHTTP, TUN, firewall and routing baseline were preserved.
- **P1 replay:** forbidden. The one-request budget is exhausted (`1/1`); any future public canary/request requires a new Gate and fresh authorization.
- **Dynamic egress rule:** accepted P1 logic discovers the current physical egress at runtime. Historical WLAN values observed during P1 are Evidence only and must not become G3-A constants.
- **Secrets:** emitted/committed 0 in accepted P1 Evidence.
- **Final validation pending:** peak-hour and representative Codex/OpenAI/image-generation workload validation remains G4 before MVP v1 seal.

## CURRENT_GATE

```text
GATE_ID=G3A_NETWORK_ADAPTATION_LOCAL_ENGINEERING_H1
STATE=AUTHORIZED
PREVIOUS_RESULT=PASS_G2C_REALITY_PUBLIC_TCP443_CANARY_P1
OWNER_CONTINUE_AUTHORIZATION=2026-10-03
SPECIALIST_TRIGGERS=11B_SSH_TARGET_HOST,11C_DEPLOYMENT_NETWORK_RESOURCES,11D_AUTOMATION
OBJECTIVE=Build and offline-validate a deterministic Windows network-adaptation planner that discovers current physical egress dynamically, classifies WG/HY2/REALITY health inputs, and emits a fail-closed role/route intent without changing live network state.
MAX_ENDPOINT_THIS_ROUND=project-owned source changes + static review + offline/self-test + optional Owner read-only proof; no live route/service/proxy/TUN/VPN/VPS mutation and no real OpenAI request.
MANDATORY_REVIEW_STOP=YES
DEFAULT_EXECUTION_CHANNEL=GitHub_source_change_then_Owner_local_read_only_self_test
ROLLBACK_STATUS=SOURCE_ONLY_REVERTABLE
OWNER_ONLY_ACTIONS=NONE_IN_H1
LIVE_NETWORK_ACTIVATION_AUTHORIZED=NO
ESTIMATED_EXECUTION_TIME=15-30_minutes
IMPLEMENTATION_COMMIT=435a4e383be64c1d4649ab1f6d7b8cc42bdf95d1
STATIC_SOURCE_REVIEW=PASS
OWNER_SELFTEST_PROOF=PENDING
```

### TARGET_AND_SCOPE

- New project-owned planner: `scripts/g3a-network-adaptation-planner.ps1`.
- Reuse accepted P1 dynamic physical-egress invariants; do not copy historical WLAN IP/gateway/ifIndex as constants.
- Model three accepted protocol roles without making a production-default decision:
  - WireGuard = current production/rollback baseline;
  - HY2 = validated UDP candidate;
  - Mihomo VLESS+REALITY = validated TCP/443 candidate.
- H1 emits a plan only. It does not add/remove routes, start/stop services, change Clash Verge, change system proxy/TUN, or alter VPS state.
- Production role priority remains unresolved until later validation; H1 may expose policy inputs but must not silently promote HY2 or REALITY to persistent default.

### APPLICABLE_CRITICAL_CONSTRAINTS

- WireGuard remains the current production/rollback path.
- Existing HY2 and WG services must not be changed in H1.
- No hardcoded historical physical egress identity.
- Ambiguous/missing physical egress or contradictory health input => fail closed.
- No Secret values, auth material, private keys, certificate private material, or raw credential-bearing config in output.
- Automation defaults safe; H1 performs no real action.
- Any future live route/client/service switch is a separate consequential Gate.

### PREFLIGHT

Before source mutation:
- prove canonical GitHub `main` and project-owned path scope;
- confirm G2-C P1 is accepted and closed with request budget exhausted;
- identify reusable accepted dynamic-egress logic;
- verify no existing G3-A planner file collision.

Before Owner-local self-test:
- PowerShell 7.6.6;
- canonical synced source;
- AST parse PASS;
- self-test/read-only mode only.

### REQUIRED_EVIDENCE

- planner source identity and fresh read-back;
- static negative scan proving no live mutation cmdlets/actions in H1;
- deterministic fixtures for one valid physical egress, ambiguous egress, missing egress, WG healthy baseline, UDP/HY2 unavailable with REALITY available, and no healthy candidate/contradictory input;
- every ambiguous or unsafe fixture fails closed;
- planner output contains no Secret values;
- Owner-local self-test reports zero network/service/proxy/TUN/VPS mutation.

### ACCEPTANCE_CRITERIA

PASS requires:
- dynamic egress selection contains no historical WLAN identity constants;
- all offline fixtures pass;
- unsafe/ambiguous fixtures fail closed;
- role output is advisory/plan-only and does not change production default;
- static review finds no mutating network/service operations;
- Owner-local proof confirms zero live mutation when requested.

### ROLLBACK_STATUS_OR_PLAN

Source-only Gate. Rollback is exact revert of the G3-A H1 source commit. No runtime rollback is required because live network/VPS mutation is forbidden.

### OWNER_ONLY_ACTIONS

**NONE in H1.** Live activation is explicitly outside this Gate.

### REVIEWER_TO_EXECUTOR_RELAY

Work only on `vpn-network-optimization/scripts/g3a-network-adaptation-planner.ps1` plus the accepted G2-C P1 Evidence facts needed for role definitions. Reuse accepted P1 dynamic-egress semantics. Do not replay G2-C, do not read Secrets, do not touch live network state, and stop after source + offline/self-test evidence.

### EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE only after source read-back, static negative mutation scan, and deterministic fixture/self-test evidence. Any need for live route/service/proxy/TUN/VPS mutation requires a new reviewed Gate.

## NEXT_STEP

Run the implemented G3-A planner's built-in `-SelfTest` once on the Owner Windows host using PowerShell 7.6.6 after syncing canonical `main`. This self-test uses deterministic fixtures only and must not query or change live network state. Return the bounded output to Reviewer for H1 PASS/RETURN.

## OWNER_ACTION_REQUIRED

Run one Reviewer-provided PowerShell 7.6.6 `-SelfTest` command after canonical sync. No Administrator privilege is required for the fixture-only self-test. Do not run `-ReadOnlySnapshot` yet. No live route, service, proxy, TUN, VPN-default, or VPS change is authorized in H1.

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
