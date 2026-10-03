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
G3-C C2A UI canary package                  RETURN->FIXING
G3-C C2B Synthetic Clash UI canary          PENDING
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
- **G3-C C2A repair:** paused by Owner priority change and will resume after this benchmark.
- **HY2:** existing candidate is deployed and previously validated.
- **REALITY:** non-persistent; previous bounded public canary proved interoperability and cleanup.
- **New Owner priority:** obtain a same-window comparison of WG, HY2 and REALITY before traffic conditions change materially.

## CURRENT_GATE

```text
GATE_ID=G3X_TRI_PATH_SAME_WINDOW_BENCHMARK_PACKAGE_B1
STATE=AUTHORIZED
PREVIOUS_GATE=G3C_C2A_SYNTHETIC_UI_PACKAGE_REPAIR_R1_PAUSED
OWNER_CONTINUE_AUTHORIZATION=2026-10-04
OBJECTIVE=Build and offline-validate one bounded same-window benchmark package for WG, HY2 and REALITY using the same OpenAI endpoint and equal samples.
MAX_ENDPOINT_THIS_ROUND=repository-only benchmark runner/validator/docs/evidence; no live benchmark in B1.
MANDATORY_REVIEW_STOP=YES
SAMPLES_PER_PATH=20
SAMPLE_MODE=ROUND_ROBIN_TRIPLETS
TARGET_ENDPOINT=https://api.openai.com/v1/models
EXPECTED_HTTP_STATUS=401
METRICS=TTFB_P50_P95,TOTAL_P50_P95,FAILURE_RATE,JITTER
WG_MUST_REMAIN_CONNECTED=YES
SYSTEM_PROXY_CHANGE_AUTHORIZED=NO
TUN_CHANGE_AUTHORIZED=NO
PERSISTENT_ROUTE_AUTHORIZED=NO
API_CREDENTIAL_ALLOWED=NO
OWNER_INTERVENTION_REQUIRED=NO_IN_B1
ESTIMATED_EXECUTION_TIME=15-25_minutes
TIMING_OBSERVABILITY_REQUIRED=YES_WITH_PHASES
```

### PACKAGE_REQUIREMENTS

- Do not reuse historical benchmark code with hardcoded adapter/interface/address facts.
- Reuse only previously accepted bounded HY2 and public REALITY canary mechanisms, updated for the current Mihomo baseline and current dynamic-interface rules.
- The later B2 benchmark must keep WireGuard available throughout, use equal 20-sample round-robin triplets, and direct all three paths to the same OpenAI endpoint without credentials.
- Capture identical curl timing fields for every sample and compute TTFB median/P95, total median/P95, failure rate, timeout/reset counts, and an explicit jitter statistic.
- Any temporary path/runtime state used by the accepted canary mechanisms must be exact, bounded, non-persistent and fully proven absent afterward.
- A cleanup failure overrides benchmark success.
- Save only non-secret CSV/JSON statistics.
- B1 itself performs no live request, Secret access, runtime start, VPN change or server action.

### VALIDATOR_REQUIREMENTS

Reject:
- hardcoded physical interface/index/gateway/local address;
- unequal path sample counts/order;
- API credentials;
- persistent route or WG disconnect;
- system proxy/TUN change;
- missing cleanup proof;
- missing TTFB/total/jitter statistics;
- missing timing instrumentation.

### TIMING

Estimate: **15–25 minutes**.

Record total plus:
`SOURCE_BUILD_ELAPSED`,
`FIXTURE_VALIDATE_ELAPSED`,
`STATIC_REVIEW_ELAPSED`,
`GIT_PERSISTENCE_ELAPSED`.

### OWNER_ONLY_ACTIONS

NONE in B1.

### REVIEWER_TO_EXECUTOR_RELAY

Build only the offline same-window tri-path benchmark package. Preserve the paused C2A repair for later.

### EXECUTOR_TO_REVIEWER_RELAY

Return `PASS_CANDIDATE_G3X_TRI_PATH_BENCHMARK_PACKAGE_B1` or precise RETURN; persist Evidence/Handoff/timing and STOP_AT_REVIEWER.

## NEXT_STEP

Codex prepares the benchmark package. Reviewer inspects it. If accepted, Owner runs one bounded B2 benchmark during the current low-load window; then Reviewer summarizes WG/HY2/REALITY results.

## OWNER_ACTION_REQUIRED

**NONE during B1.** Keep WireGuard connected. Do not change Clash.

## REVIEWER_TO_EXECUTOR_RELAY

Execute G3X B1 benchmark package construction only; no live action.

## EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE_G3X_TRI_PATH_BENCHMARK_PACKAGE_B1 or precise RETURN; STOP_AT_REVIEWER.

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
