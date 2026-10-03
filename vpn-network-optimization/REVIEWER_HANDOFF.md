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
- **Connectivity dependency:** Owner's ChatGPT web and Codex desktop access require at least one working VPN path at all times. WireGuard is the current production VPN, but Owner has other temporary VPN options. WireGuard may be disconnected only at an explicit Owner checkpoint after an alternate VPN path is confirmed working; Executor must never strand the Owner offline.
- **HY2:** deployed and previously validated as a side-by-side candidate on UDP 8443.
- **REALITY:** public TCP/443 interoperability was validated by bounded canary, but the server is currently a cold/non-persistent candidate.
- **G3-A:** health/readiness/advisory logic PASS; no automatic actuator exists.
- **G3-B D1-D3:** offline migration package, target qualification contract, and staged render contract PASS. Fresh-target rehearsal is intentionally deferred while G3-C makes the existing system directly usable.
- **Manual-control design direction:** Clash Verge/Mihomo will be the upper control surface while system WireGuard stays connected underneath. A named DIRECT-type node may represent the WG baseline; HY2/REALITY candidate nodes may use per-node physical-interface binding, but Windows bypass behavior remains UNPROVEN until a live canary.
- **No current runtime change:** Clash is not required to be running now; current connectivity remains WireGuard-only.

## CURRENT_GATE

```text
GATE_ID=G3C_UNIFIED_MANUAL_CONTROL_CONTRACT_C1
STATE=AUTHORIZED
PREVIOUS_RESULT=PASS_G3B_STAGED_INSTALL_RENDER_CONTRACT_D3
OWNER_CONTINUE_AUTHORIZATION=2026-10-03
SPECIALIST_TRIGGERS=11B_SECRET_TARGET_HOST,11C_DEPLOYMENT_NETWORK_RESOURCES,11D_AUTOMATION
OBJECTIVE=Create and offline-validate a Clash Verge/Mihomo manual-control profile contract that can later expose WG baseline, HY2, and REALITY without disconnecting system WireGuard.
MAX_ENDPOINT_THIS_ROUND=repository-only profile/template/validator design + deterministic offline validation; no Clash apply, no system proxy/TUN change, no route change, no VPS access, no Secret read, no service action.
MANDATORY_REVIEW_STOP=YES
ACTIVE_VPN_CONNECTIVITY_MUST_BE_PRESERVED=YES
WG_IS_CURRENT_PRODUCTION_VPN=YES
WG_DISCONNECT_REQUIRES_OWNER_CHECKPOINT=YES
ALTERNATE_VPN_MUST_BE_CONFIRMED_BEFORE_WG_DISCONNECT=YES
OWNER_CHAT_AND_CODEX_CONNECTIVITY_MUST_BE_PRESERVED=YES
WG_SERVICE_STOP_AUTHORIZED=NO_IN_C1
WG_ROUTE_REMOVAL_AUTHORIZED=NO_IN_C1
CLASH_PROFILE_APPLY_AUTHORIZED=NO
SYSTEM_PROXY_CHANGE_AUTHORIZED=NO
TUN_CHANGE_AUTHORIZED=NO
PERSISTENT_BYPASS_ROUTE_AUTHORIZED=NO
VPS_ACCESS_AUTHORIZED=NO
SECRET_READ_AUTHORIZED=NO
ROLLBACK_STATUS=SOURCE_ONLY_REVERTABLE
DEFAULT_EXECUTION_CHANNEL=CODEX_DESKTOP_EXECUTOR
OWNER_INTERVENTION_REQUIRED=NO_IN_C1
ESTIMATED_EXECUTION_TIME=15-25_minutes
TIMING_OBSERVABILITY_REQUIRED=NEXT_GATE
TIME_OVERRUN_REVIEW_REQUIRED=NEXT_GATE
```

### TARGET_AND_SCOPE

- Build a non-secret portable manual-control profile contract with these logical entries:
  - `WG-BASELINE`: named Mihomo `direct` proxy; semantic meaning is “use normal Windows routing while system WireGuard remains connected”.
  - `HY2-SFO3`: existing HY2 candidate with Secret/auth/fingerprint placeholders preserved.
  - `REALITY-SFO3`: non-secret VLESS+REALITY+Vision client skeleton with Secret/identity placeholders preserved; not claimed usable until a later persistent-server Gate.
  - `SELF-VPN-MANUAL`: `select` group with default `WG-BASELINE`.
- HY2/REALITY candidate nodes shall carry a placeholder for the dynamically discovered physical interface; no `WLAN`/ifIndex/gateway/IP may be hardcoded.
- Prefer per-node `interface-name` as the first bypass candidate because Mihomo supports node-bound outbound interfaces; treat Windows real behavior as `UNPROVEN_LIVE`.
- Do not add a persistent public-IP /32 route in C1.
- Include a manual delay-test URL/contract compatible with Clash Verge; do not enable automatic switching.
- `profile.store-selected=true` may be used so Owner manual selection persists, but the first/default selected node must remain `WG-BASELINE`.
- C1 must not emit or render real WG private keys, HY2 auth, REALITY UUID/private-key material, certificate key material, or populated recovery data.

### REQUIRED OFFLINE FIXTURES

- valid three-entry profile contract with default WG baseline;
- hardcoded physical interface rejected;
- WG baseline missing/reordered away from default rejected;
- automatic/fallback/url-test production selection rejected;
- Secret sentinel removed/populated rejected;
- persistent /32 route instruction present rejected;
- REALITY incorrectly marked production-ready rejected.

### ACCEPTANCE_CRITERIA

PASS requires:
- portable profile/template parses under the pinned Mihomo syntax validation path or equivalent deterministic parser available locally;
- `WG-BASELINE` is a named `direct` node and remains the default manual selection;
- HY2 and REALITY carry dynamic physical-interface placeholders only;
- REALITY is explicitly cold/not-ready-for-manual-use until its later live Gate;
- no automatic switching, route mutation, system proxy/TUN change, VPS access, Secret read, or file application occurs;
- C1 leaves current WireGuard connectivity untouched. Later live Gates may authorize a WG disconnect only after the Owner has confirmed another VPN is already carrying ChatGPT/Codex connectivity.

### TIMING_OBSERVABILITY

- **C1 transition exception:** the Executor prompt for C1 had already been issued before the timing rule was restored. Missing C1 timing fields are therefore **not an acceptance blocker** and must not cause replay or RETURN.
- Reviewer keeps the C1 estimate of **15–25 minutes** as non-blocking reference only.
- **Mandatory starting with the next Gate after C1:** Reviewer provides an end-to-end estimate before execution; Executor records `ROUND_STARTED_AT`, `ROUND_FINISHED_AT`, `ACTUAL_ELAPSED`, and `TIME_OVERRUN=YES|NO`.
- If a future round has `TIME_OVERRUN=YES`, record the best evidence-backed `TIME_OVERRUN_CAUSE`; if unclear, perform at most one bounded investigation of the slow stage.
- Timeout alone does not fail the Gate and must not trigger replay of a consequential action.
- Update `docs/ROUND_TIMING_RETROSPECTIVE.md` under its existing update rules.

### ROLLBACK_STATUS_OR_PLAN

Source-only C1. Exact commit revert is sufficient; no runtime rollback applies.

### OWNER_ONLY_ACTIONS

NONE in C1.

### REVIEWER_TO_EXECUTOR_RELAY

Read this C1 Gate plus only the current portable Clash/HY2/REALITY templates and any accepted G2-C client-schema source needed to build the non-secret profile contract. Do not inspect recovery artifacts or Secret values. Create the minimum profile contract + offline validator, validate only repository/local fixture content, update Evidence/Executor Handoff, and STOP_AT_REVIEWER.

### EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE or a precise RETURN. Do not start Clash, enable system proxy/TUN, stop WireGuard, add routes, access the VPS, or advance to C2.

## NEXT_STEP

Codex Desktop Executor builds and offline-validates the G3-C C1 manual-control profile contract. On Reviewer PASS, C2 will be the first live UI canary while WireGuard remains connected throughout.

## OWNER_ACTION_REQUIRED

**NONE.** C1 is repository-only. Keep your current VPN setup unchanged. If a later Gate truly needs WireGuard disconnected, Reviewer will first tell you to switch to another working VPN and confirm connectivity before authorizing the disconnect.

## REVIEWER_TO_EXECUTOR_RELAY

Read the current C1 Gate and its explicitly named portable templates only. Implement repository-only profile/validator work, write bounded Evidence, and STOP_AT_REVIEWER.

## EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE or a precise RETURN for C1. No live network/client/server action is authorized.

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
