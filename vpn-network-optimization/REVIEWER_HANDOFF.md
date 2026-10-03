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
- **Connectivity dependency:** at least one working VPN must remain available for ChatGPT/Codex; this checkpoint does not require disconnecting WireGuard.
- **G3-A:** health/readiness/advisory PASS.
- **G3-B D1-D3:** offline migration package/qualification/render PASS; fresh-target rehearsal deferred.
- **G3-C C1 design:** manual-control profile, contract and offline validator are on GitHub; A–G fixtures PASS; source remains unchanged.
- **Mihomo runtime:** installed exact path is `C:\Program Files\Clash Verge\verge-mihomo.exe`; observed version is stable `v1.19.32`.
- **R2 result:** native parse is still unproven because Codex policy blocked creation of the local PowerShell/config-test process before it started. This is not a Mihomo parser failure.
- **Execution-channel decision:** do not retry/bypass Codex policy. Use one minimal Owner-local config-test checkpoint.
- **Timing process:** R1 and R2 both missed whole-round start capture. Owner R3 embeds timing inside the one-shot script so the first emitted evidence is `ROUND_STARTED_AT`.
- **Formal client-core baseline:** remains v1.19.31 until Owner R3 proves v1.19.32 accepts the unchanged C1 profile shape.

## CURRENT_GATE

```text
GATE_ID=G3C_C1_OWNER_MIHOMO_NATIVE_PARSE_R3
STATE=AWAITING_OWNER_EXECUTION
PREVIOUS_RESULT=RETURN_MIHOMO_NATIVE_PARSE_BLOCKED_BY_POLICY
SPECIALIST_TRIGGERS=11B_TARGET_HOST_LOCAL_RUNTIME,11C_DEPLOYMENT_NETWORK_RESOURCES
OBJECTIVE=Use one Owner-local PowerShell checkpoint to prove installed Mihomo v1.19.32 accepts the unchanged canonical C1 profile shape.
MAX_ENDPOINT_THIS_ROUND=one local one-shot PowerShell checkpoint: source/hash check + synthetic TEMP fixture + mihomo native config-test + exact cleanup + bounded output.
MANDATORY_REVIEW_STOP=YES
OWNER_INTERVENTION_REQUIRED=YES_ONE_SHOT_LOCAL
OWNER_DEBUGGING_REQUIRED=NO
ACTIVE_VPN_CONNECTIVITY_MUST_BE_PRESERVED=YES
WG_DISCONNECT_REQUIRED=NO
WG_SERVICE_STOP_AUTHORIZED=NO
WG_ROUTE_REMOVAL_AUTHORIZED=NO
CLASH_ACTIVE_START_AUTHORIZED=NO
CLASH_PROFILE_APPLY_AUTHORIZED=NO
SYSTEM_PROXY_CHANGE_AUTHORIZED=NO
TUN_CHANGE_AUTHORIZED=NO
ROUTE_CHANGE_AUTHORIZED=NO
VPS_ACCESS_AUTHORIZED=NO
PROVIDER_ACCESS_AUTHORIZED=NO
SECRET_READ_AUTHORIZED=NO
EXTERNAL_REQUEST_AUTHORIZED=NO
MIHOMO_BINARY_PATH=C:\Program Files\Clash Verge\verge-mihomo.exe
EXPECTED_MIHOMO_VERSION=v1.19.32
C1_TEMPLATE_SHA256=37759F834A637CF37DF4D71BA7C75585DA1F8211C668A23C323B50D2D9C1D424
C1_VALIDATOR_SHA256=3682B298833C9352BA56AE6A1F7EAF2A24D06D19CE9B8B2F8418AEAD8C39E783
ESTIMATED_EXECUTION_TIME=2-5_minutes
TIMING_OBSERVABILITY_REQUIRED=SCRIPT_EMBEDDED
ROLLBACK_STATUS=TEMP_FIXTURE_CLEANUP_ONLY
```

### OWNER_CHECKPOINT_CONTRACT

- Run exactly one Reviewer-provided PowerShell 7.x checkpoint on the Owner Windows host.
- The checkpoint must emit `ROUND_STARTED_AT` before path/version/source checks.
- It must verify:
  - PowerShell 7.x;
  - exact Mihomo path exists;
  - Mihomo reports v1.19.32;
  - current C1 template SHA-256 equals the accepted hash above;
  - current C1 validator SHA-256 equals the accepted hash above.
- It may perform only read-only physical-interface discovery required to replace the template's runtime interface placeholder in a **synthetic TEMP fixture**.
- Fixture values must be test-only and contain no real Secret.
- Native parse invocation is Mihomo config-test only: `-t -d <marked-temp-dir> -f <fixture>`.
- The checkpoint must never start Mihomo as an active client.
- It must delete only its own marked temp directory and prove cleanup.
- Output is bounded/non-secret and is the only Owner relay required.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires:
- exact source hashes match accepted C1 source;
- Mihomo v1.19.32 native config-test exit code 0;
- `MIHOMO_NATIVE_CONFIG_TEST=PASS`;
- `TEMP_FIXTURE_SECRET_VALUES=0`;
- exact cleanup PASS;
- template/validator hashes unchanged after the test;
- no active client, external request, route/proxy/TUN/WG/VPS/Provider/Secret action;
- complete script-embedded timing fields.

### TIMING_OBSERVABILITY

- Reviewer estimate: **2–5 minutes**.
- Script itself emits start before preflight and computes finish/elapsed.
- If execution exceeds 5 minutes, preserve the emitted last phase and timing; Reviewer performs the overrun analysis. Owner does not debug.
- Do not rerun solely because timing exceeds estimate.

### OWNER_ONLY_ACTIONS

Run the single Reviewer-provided PowerShell checkpoint and paste its complete bounded output back to Reviewer. No VPN switch or admin elevation is expected.

### REVIEWER_TO_EXECUTOR_RELAY

**NONE while awaiting Owner R3.** Codex must not retry the blocked native parse or attempt a policy workaround.

### EXECUTOR_TO_REVIEWER_RELAY

No Executor action is authorized until Owner R3 output is reviewed.

## NEXT_STEP

Owner runs one local PowerShell checkpoint. Reviewer checks the bounded output. A clean native parse closes C1 and accepts installed Mihomo v1.19.32 as the current client-core baseline; a parser failure opens a source-repair Gate with the exact parser error.

## OWNER_ACTION_REQUIRED

Run the single PowerShell checkpoint provided by Reviewer and paste the full output back. **Do not disconnect WireGuard or change Clash/VPN settings.**

## REVIEWER_TO_EXECUTOR_RELAY

**NONE while Owner R3 is pending.** Do not retry or bypass the Codex process-creation policy.

## EXECUTOR_TO_REVIEWER_RELAY

No Executor action until Reviewer processes Owner R3 output.

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
