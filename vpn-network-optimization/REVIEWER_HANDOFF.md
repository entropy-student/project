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

- **Current production/rollback:** system WireGuard remains connected and authoritative.
- **Connectivity dependency:** at least one working VPN must remain available for ChatGPT/Codex; no automatic WG disconnect is authorized.
- **G3-A:** health/readiness/advisory PASS.
- **G3-B D1-D3:** offline migration package/qualification/render PASS; fresh-target rehearsal deferred.
- **G3-C C1 design:** manual profile template + contract + offline validator are on GitHub; A–G fixtures PASS; no runtime application occurred.
- **R1 result:** exact historical Mihomo path exists, but installed core is now v1.19.32 instead of historical accepted v1.19.31. Executor stopped correctly before native parse.
- **Upstream verification:** MetaCubeX officially published stable v1.19.32 on 2026-09-30. Reviewer will requalify the current installed core rather than downgrade it.
- **Timing process:** R1 timing start was not captured; next Gate must record `ROUND_STARTED_AT` before any preflight/fetch/version action.
- **Formal client-core baseline:** remains v1.19.31 until R2 native parse passes. Current local installed fact is v1.19.32.

## CURRENT_GATE

```text
GATE_ID=G3C_C1_MIHOMO_V11932_NATIVE_PARSE_R2
STATE=AUTHORIZED
PREVIOUS_RESULT=RETURN_MIHOMO_VERSION_DRIFT
OWNER_CONTINUE_AUTHORIZATION=2026-10-03
SPECIALIST_TRIGGERS=11B_TARGET_HOST_LOCAL_RUNTIME,11C_DEPLOYMENT_NETWORK_RESOURCES
OBJECTIVE=Requalify the actual installed stable Mihomo v1.19.32 against the unchanged canonical C1 manual-control profile using one local-only native config test.
MAX_ENDPOINT_THIS_ROUND=timing start marker + local version confirmation + one non-secret temporary config-test fixture + native mihomo parse + exact cleanup + Evidence/Handoff persistence.
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
MIHOMO_BINARY_PATH=C:\Program Files\Clash Verge\verge-mihomo.exe
EXPECTED_MIHOMO_VERSION=v1.19.32
PREVIOUS_ACCEPTED_MIHOMO_VERSION=v1.19.31
OFFICIAL_STABLE_RELEASE_VERIFIED=YES
ROLLBACK_STATUS=LOCAL_FIXTURE_CLEANUP_ONLY
DEFAULT_EXECUTION_CHANNEL=CODEX_DESKTOP_EXECUTOR
OWNER_INTERVENTION_REQUIRED=NO
ESTIMATED_EXECUTION_TIME=10-15_minutes
TIMING_OBSERVABILITY_REQUIRED=YES
TIME_OVERRUN_REVIEW_REQUIRED=YES
```

### TARGET_AND_SCOPE

1. **First action before any other preflight:** record `ROUND_STARTED_AT=<UTC ISO8601>`.
2. Fresh fetch/sync canonical `origin/main` in the existing project-scoped worktree; do not discard unrelated work.
3. Verify exact binary path `C:\Program Files\Clash Verge\verge-mihomo.exe`.
4. Run only `-v`; require v1.19.32. Any new drift returns immediately.
5. Use the canonical C1 template unchanged to create one temporary non-secret config-test fixture outside the repository.
6. Substitute placeholders only with synthetic/test-safe values sufficient for parser validation:
   - reserved documentation IP;
   - example SNI;
   - fixture-only password;
   - parser-safe certificate fingerprint sentinel;
   - valid synthetic UUID;
   - valid synthetic short-id;
   - non-secret public-key-shaped fixture;
   - dynamically discovered current physical interface name only if required by parser validation.
7. Run Mihomo native config test only; no active client start and no external traffic.
8. Delete the temporary fixture and prove absence.
9. If parse succeeds, do not edit C1 source. If parse fails, record sanitized parser output and STOP_AT_REVIEWER; source repair is not automatic.
10. Persist Evidence + Executor Handoff only; do not modify Reviewer Handoff.
11. Fresh GitHub read-back and verify canonical C1 template/validator blob identity.
12. Record finish/elapsed/overrun fields and update timing retrospective if required.
13. STOP_AT_REVIEWER.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires:
- `ROUND_STARTED_AT` captured before preflight;
- binary exists at exact path and reports v1.19.32;
- native Mihomo config-test succeeds on the unchanged C1 profile shape;
- no real Secret appears in fixture;
- fixture cleanup proven;
- C1 source unchanged;
- no Clash active client/profile apply, network request, route/proxy/TUN/WG/VPS change;
- complete timing fields.

### TIMING_OBSERVABILITY

- Reviewer estimate: **10–15 minutes end-to-end**.
- Start marker is the first execution record, before fetch/path/version checks.
- Record `ROUND_FINISHED_AT`, `ACTUAL_ELAPSED`, `TIME_OVERRUN=YES|NO`.
- If over 15 minutes, record evidence-backed `TIME_OVERRUN_CAUSE`; at most one bounded timing diagnosis.
- Timeout alone does not fail the Gate or justify action replay.
- Update `docs/ROUND_TIMING_RETROSPECTIVE.md` under its current rules.

### OWNER_ONLY_ACTIONS

NONE.

### REVIEWER_TO_EXECUTOR_RELAY

Execute only the R2 local requalification of installed stable Mihomo v1.19.32. Timing start must be recorded first. No downgrade, download, profile apply, client start, network request, or C1 redesign is authorized.

### EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE_G3C_C1_MIHOMO_V11932_NATIVE_PARSE or a precise RETURN. Persist Evidence/Executor Handoff and STOP_AT_REVIEWER.

## NEXT_STEP

Codex Desktop requalifies installed stable Mihomo v1.19.32 with one local-only native config test. If it passes with unchanged C1 source and complete cleanup/timing evidence, Reviewer can formally close C1 and open the first live Clash UI canary C2.

## OWNER_ACTION_REQUIRED

**NONE.** Keep your current VPN setup unchanged. R2 is local-only and must not start Clash or disconnect WireGuard.

## REVIEWER_TO_EXECUTOR_RELAY

Execute only current R2: timing marker first, verify exact Mihomo v1.19.32 path/version, one synthetic native config test, cleanup, Evidence/Handoff, STOP.

## EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE_G3C_C1_MIHOMO_V11932_NATIVE_PARSE or precise RETURN; no live networking/client action.

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
