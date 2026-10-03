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
- **Connectivity dependency:** at least one working VPN must remain available; no VPN change is needed for the current checkpoint.
- **G3-A:** health/readiness/advisory PASS.
- **G3-B D1-D3:** offline migration package/qualification/render PASS; fresh-target rehearsal deferred.
- **G3-C C1 source:** manual-control profile, contract and offline validator remain unchanged; A–G fixtures PASS.
- **Mihomo runtime:** installed exact path is `C:\Program Files\Clash Verge\verge-mihomo.exe`; current version is stable `v1.19.32`.
- **Owner R3 technical result:** native Mihomo config-test succeeded with exit 0 against the synthetic C1 fixture; source postcheck reported unchanged.
- **R3 formal status:** not yet PASS only because Reviewer-delivered interactive `finally` did not execute, leaving temp-fixture cleanup and finish timing unproven.
- **No replay rule:** the successful native parse must not be rerun. Only cleanup/source-postcheck/timing-finalization remains.
- **Checkpoint-design lesson:** future PowerShell Owner checkpoints must be delivered as one syntactic unit; split interactive `try/finally` is prohibited.

## CURRENT_GATE

```text
GATE_ID=G3C_C1_OWNER_R3_CLEANUP_R3R1
STATE=AWAITING_OWNER_EXECUTION
PREVIOUS_RESULT=PASS_CANDIDATE_NATIVE_PARSE_PENDING_CLEANUP
SPECIALIST_TRIGGERS=11B_TARGET_HOST_LOCAL_RUNTIME
OBJECTIVE=Complete exact cleanup and timing finalization for the already-successful Owner R3 native parse without replaying Mihomo config-test.
MAX_ENDPOINT_THIS_ROUND=one atomic local PowerShell cleanup-only checkpoint: identify exact marked R3 temp artifact, delete it, prove absence, re-check C1 source hashes, finalize elapsed/overrun evidence.
MANDATORY_REVIEW_STOP=YES
OWNER_INTERVENTION_REQUIRED=YES_ONE_SHOT_LOCAL
OWNER_DEBUGGING_REQUIRED=NO
NATIVE_CONFIG_TEST_REPLAY_AUTHORIZED=NO
MIHOMO_EXECUTION_AUTHORIZED=NO
ACTIVE_VPN_CONNECTIVITY_MUST_BE_PRESERVED=YES
WG_DISCONNECT_REQUIRED=NO
WG_SERVICE_STOP_AUTHORIZED=NO
ROUTE_CHANGE_AUTHORIZED=NO
SYSTEM_PROXY_CHANGE_AUTHORIZED=NO
TUN_CHANGE_AUTHORIZED=NO
VPS_ACCESS_AUTHORIZED=NO
PROVIDER_ACCESS_AUTHORIZED=NO
SECRET_READ_AUTHORIZED=NO
EXTERNAL_REQUEST_AUTHORIZED=NO
C1_TEMPLATE_SHA256=37759F834A637CF37DF4D71BA7C75585DA1F8211C668A23C323B50D2D9C1D424
C1_VALIDATOR_SHA256=3682B298833C9352BA56AE6A1F7EAF2A24D06D19CE9B8B2F8418AEAD8C39E783
R3_ORIGINAL_STARTED_AT=2026-10-03T14:45:59.5840466Z
ESTIMATED_EXECUTION_TIME=1-2_minutes
TIMING_OBSERVABILITY_REQUIRED=SCRIPT_EMBEDDED
ROLLBACK_STATUS=CLEANUP_ONLY
```

### OWNER_CHECKPOINT_CONTRACT

- Run exactly one atomic Reviewer-provided PowerShell block.
- Do not rerun Mihomo or any parser command.
- The block may inspect only:
  - the existing R3 `$tempDir` variable if still present;
  - `$env:TEMP\vpn-network-optimization-g3c-r3-*` candidates with exact marker `.g3c-owner-r3-marker=G3C_OWNER_R3`;
  - the C1 template/validator hashes.
- Delete only a directory that has the exact R3 marker. If ambiguity exists, return without deleting anything.
- Prove no marked R3 temp directory remains.
- Re-check canonical source hashes.
- Finalize elapsed time from `2026-10-03T14:45:59.5840466Z`; overrun cause is the Reviewer checkpoint syntax split/remediation, not Mihomo performance.
- Owner pastes bounded output back to Reviewer.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires:
- no Mihomo/parser replay;
- exact marked temp fixture cleanup PASS or proven already absent;
- marked R3 temp residue count after cleanup = 0;
- template and validator hashes match accepted values;
- no network/VPN/system mutation;
- finish/elapsed/overrun evidence emitted.

### OWNER_ONLY_ACTIONS

Run the single atomic cleanup-only PowerShell block provided by Reviewer and paste its complete output. Do not rerun the earlier R3 block.

### REVIEWER_TO_EXECUTOR_RELAY

**NONE.** Codex remains paused until Owner R3R1 is reviewed.

### EXECUTOR_TO_REVIEWER_RELAY

No Executor action is authorized.

## NEXT_STEP

Owner performs cleanup-only R3R1. Reviewer then persists the final R3 result. If cleanup/source hashes pass, C1 can be formally closed and Mihomo v1.19.32 accepted as the current client-core baseline without replaying native parse.

## OWNER_ACTION_REQUIRED

Run the single cleanup-only PowerShell block from Reviewer in the same PowerShell 7 window if it is still open, then paste the complete output. **Do not rerun the previous R3 script.**

## REVIEWER_TO_EXECUTOR_RELAY

**NONE.** Codex remains paused; do not retry Mihomo native parse.

## EXECUTOR_TO_REVIEWER_RELAY

No Executor action while Owner cleanup-only R3R1 is pending.

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
