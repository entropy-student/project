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
G3-C Unified manual control surface         IN_PROGRESS
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

- **Current production/rollback:** system WireGuard remains connected and authoritative on the existing DigitalOcean sfo3 VPS.
- **Connectivity dependency:** at least one VPN path must remain available for ChatGPT/Codex. WireGuard may be disconnected only at an explicit Owner checkpoint after an alternate VPN is confirmed.
- **G3-A:** health/readiness/advisory PASS; no automatic actuator exists.
- **G3-B D1-D3:** offline migration package/qualification/render contracts PASS; fresh-target rehearsal remains deferred.
- **G3-C C1 source:** manual-control template, contract doc, and offline validator are present on GitHub; A–G deterministic fixtures PASS.
- **C1 review disposition:** RETURN only for missing Mihomo-native parser evidence. The source design is not rejected and must not be rebuilt without new parser evidence.
- **Historical Mihomo fact:** accepted project runners used `C:\Program Files\Clash Verge\verge-mihomo.exe` and proved Mihomo Meta v1.19.31. Current Executor discovery saying no verified binary is unresolved until the exact canonical path is checked.
- **Current runtime:** unchanged; Clash profile not applied, WG/routes/system proxy/TUN untouched.

## CURRENT_GATE

```text
GATE_ID=G3C_C1_MIHOMO_NATIVE_PARSE_RECONCILIATION_R1
STATE=AUTHORIZED
PREVIOUS_RESULT=RETURN_MIHOMO_NATIVE_PARSE_REQUIRED
OWNER_CONTINUE_AUTHORIZATION=2026-10-03
SPECIALIST_TRIGGERS=11B_TARGET_HOST_LOCAL_RUNTIME,11C_DEPLOYMENT_NETWORK_RESOURCES
OBJECTIVE=Reconcile the historical accepted Mihomo binary path and obtain one local-only native config parse for the C1 manual-control profile without applying or starting the profile.
MAX_ENDPOINT_THIS_ROUND=local read-only binary/version discovery + one non-secret temporary parse fixture + mihomo config-test + exact fixture cleanup + Evidence/Handoff persistence.
MANDATORY_REVIEW_STOP=YES
ACTIVE_VPN_CONNECTIVITY_MUST_BE_PRESERVED=YES
WG_SERVICE_STOP_AUTHORIZED=NO
WG_ROUTE_REMOVAL_AUTHORIZED=NO
CLASH_ACTIVE_START_AUTHORIZED=NO
CLASH_PROFILE_APPLY_AUTHORIZED=NO
SYSTEM_PROXY_CHANGE_AUTHORIZED=NO
TUN_CHANGE_AUTHORIZED=NO
ROUTE_CHANGE_AUTHORIZED=NO
VPS_ACCESS_AUTHORIZED=NO
SECRET_READ_AUTHORIZED=NO
EXTERNAL_REQUEST_AUTHORIZED=NO
SOURCE_REDESIGN_AUTHORIZED=NO_UNLESS_NATIVE_PARSE_PROVES_A_SOURCE_DEFECT
ROLLBACK_STATUS=LOCAL_FIXTURE_CLEANUP_ONLY
DEFAULT_EXECUTION_CHANNEL=CODEX_DESKTOP_EXECUTOR
OWNER_INTERVENTION_REQUIRED=NO
ESTIMATED_EXECUTION_TIME=10-15_minutes
TIMING_OBSERVABILITY_REQUIRED=YES
TIME_OVERRUN_REVIEW_REQUIRED=YES
```

### TARGET_AND_SCOPE

1. Fresh sync canonical `main` in the existing project-scoped worktree; do not disturb unrelated work.
2. Check the historically accepted exact binary first:
   `C:\Program Files\Clash Verge\verge-mihomo.exe`
3. If that exact file is absent, perform only a bounded read-only search under `C:\Program Files\Clash Verge\` for Mihomo executables; do not install/download anything.
4. Run `-v` only. Expected accepted stable identity is Mihomo Meta v1.19.31. Version drift returns to Reviewer; do not silently validate against an unknown replacement.
5. Build one **temporary, non-secret parse fixture** from the current canonical C1 template. Substitute only synthetic/test-safe values:
   - reserved documentation public IP;
   - fixture password/fingerprint;
   - valid synthetic UUID/short-id/public-key-shaped value;
   - dynamically discovered current physical interface name only if required for config validation.
6. Run the pinned Mihomo **config test only** (`-t` with the fixture); do not start the core as an active client.
7. Delete the temporary fixture and prove cleanup.
8. Do not modify the C1 template/validator unless native parse itself proves an exact source defect. If parse fails, record the sanitized parser failure and STOP_AT_REVIEWER.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires:
- historical/canonical Mihomo binary identity reconciled;
- `MIHOMO_VERSION=v1.19.31` or a precise RETURN for version drift;
- one native Mihomo config-test against the canonical C1 profile shape succeeds;
- fixture contains no real Secret and is removed afterward;
- no Clash active process/profile application, network request, route/proxy/TUN/WG/VPS change;
- C1 source blobs remain unchanged unless a parser-proven source defect required Reviewer-visible repair;
- timing fields recorded because this is the first mandatory timing round after C1.

### TIMING_OBSERVABILITY

- Reviewer estimate: **10–15 minutes end-to-end**.
- Record `ROUND_STARTED_AT`, `ROUND_FINISHED_AT`, `ACTUAL_ELAPSED`, `TIME_OVERRUN=YES|NO`.
- If over 15 minutes, record `TIME_OVERRUN_CAUSE` using existing evidence; at most one bounded timing diagnosis if unclear.
- Timeout alone is not Gate failure and must not trigger any network/action replay.
- Update `docs/ROUND_TIMING_RETROSPECTIVE.md` under its existing rules.

### OWNER_ONLY_ACTIONS

NONE.

### REVIEWER_TO_EXECUTOR_RELAY

Use the exact historical Mihomo path first and run only local binary/version/config-test reconciliation. Do not redesign C1 unless the native parser proves a source defect. No VPN/client/server/network action is authorized.

### EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE_G3C_C1_NATIVE_PARSE or a precise RETURN. Persist Evidence/Executor Handoff and STOP_AT_REVIEWER.

## NEXT_STEP

Codex Desktop Executor performs the bounded local-only Mihomo native parse reconciliation. If it passes and source identity remains unchanged, Reviewer can close C1 without any live VPN switch.

## OWNER_ACTION_REQUIRED

**NONE.** Keep your current VPN setup unchanged. This reconciliation is local-only and must not start Clash or disconnect WireGuard.

## REVIEWER_TO_EXECUTOR_RELAY

Use the current R1 Gate only: exact historical Mihomo path first, local `-v` + one non-secret native config test, cleanup, Evidence/Handoff, STOP.

## EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE_G3C_C1_NATIVE_PARSE or a precise RETURN. No live network/client/server action.

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
