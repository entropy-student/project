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
G3-C C2A Live UI canary package             IN_PROGRESS
G3-C C2B Owner live UI canary               PENDING
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

- **Current production/rollback:** system WireGuard remains connected and authoritative.
- **Connectivity dependency:** at least one working VPN must remain available for ChatGPT/Codex. No automatic WG disconnect is authorized.
- **G3-A:** health/readiness/advisory PASS.
- **G3-B D1-D3:** offline migration package/qualification/render PASS; fresh-target rehearsal remains deferred.
- **G3-C C1:** formally PASS. Manual-control template/contract/validator passed A–G fixtures and installed Mihomo native config-test.
- **Accepted Windows client core:** `C:\Program Files\Clash Verge\verge-mihomo.exe`, stable Mihomo **v1.19.32**.
- **C1 Owner proof:** native parse exit 0; fixture contained no real Secret; marked temp residue after cleanup = 0; source hashes unchanged; WG/routes/system proxy/TUN/VPS/network unchanged.
- **Timing result:** Owner R3 + R3R1 took 10m09.782s vs 2–5 min estimate. Overrun cause was Reviewer checkpoint syntax split requiring cleanup remediation, not Mihomo runtime slowness.
- **HY2:** existing server candidate remains deployed/validated and is the only non-WG candidate eligible for the first live UI canary.
- **REALITY:** remains a cold/non-persistent candidate. It must not be represented as a currently usable live selector entry until a separate persistent-server/readiness Gate passes.
- **UI target remains:** eventual WG + HY2 + REALITY manual selection in Clash Verge. C2 first proves the control plane safely with WG + HY2 rather than presenting a fake/unusable REALITY node.

## CURRENT_GATE

```text
GATE_ID=G3C_C2_CLASH_UI_CANARY_PACKAGE_C2A
STATE=AUTHORIZED
PREVIOUS_RESULT=PASS_G3C_C1_MANUAL_CONTROL_CONTRACT
OWNER_CONTINUE_AUTHORIZATION=2026-10-03
SPECIALIST_TRIGGERS=11B_SECRET_TARGET_HOST_LOCAL_RUNTIME,11C_DEPLOYMENT_NETWORK_RESOURCES,11D_AUTOMATION
OBJECTIVE=Build and offline-validate one atomic Owner-run package for the first real Clash Verge UI canary using WG baseline + HY2 while preserving system WireGuard and excluding cold REALITY from live selection.
MAX_ENDPOINT_THIS_ROUND=repository-only package/script/docs/fixtures; no Secret read, no Clash apply/start, no system proxy/TUN/route change, no VPS access, no network request.
MANDATORY_REVIEW_STOP=YES
ACTIVE_VPN_CONNECTIVITY_MUST_BE_PRESERVED=YES
WG_SERVICE_STOP_AUTHORIZED=NO
WG_ROUTE_REMOVAL_AUTHORIZED=NO
CLASH_PROFILE_APPLY_AUTHORIZED=NO
CLASH_ACTIVE_START_AUTHORIZED=NO
SYSTEM_PROXY_CHANGE_AUTHORIZED=NO
TUN_CHANGE_AUTHORIZED=NO
ROUTE_CHANGE_AUTHORIZED=NO
VPS_ACCESS_AUTHORIZED=NO
SECRET_READ_AUTHORIZED=NO
DPAPI_UNPROTECT_AUTHORIZED=NO_IN_C2A
EXTERNAL_REQUEST_AUTHORIZED=NO
REALITY_LIVE_NODE_AUTHORIZED=NO
DEFAULT_EXECUTION_CHANNEL=CODEX_DESKTOP_EXECUTOR
OWNER_INTERVENTION_REQUIRED=NO_IN_C2A
ESTIMATED_EXECUTION_TIME=15-25_minutes
TIMING_OBSERVABILITY_REQUIRED=YES
TIME_OVERRUN_REVIEW_REQUIRED=YES
```

### TARGET_AND_SCOPE

Build the minimum repository-owned package for a later Owner C2B checkpoint. C2A itself is offline/source-only.

Required design:
- live canary selector contains only:
  - `WG-BASELINE` — named Mihomo `direct`, preserving normal Windows routing through the already-active system WireGuard;
  - `HY2-SFO3` — current deployed HY2 candidate.
- Do **not** include `REALITY-SFO3` in the live selector yet. Document it as `COLD / DEFERRED_TO_SEPARATE_PERSISTENT_READINESS_GATE`.
- The later Owner C2B package must:
  - discover the physical egress interface dynamically;
  - use the existing protected HY2 recovery path locally without printing/committing the auth value;
  - render runtime config only under a uniquely marked owner-local runtime directory;
  - run Mihomo native config-test before any UI apply;
  - keep system WireGuard connected throughout the first canary;
  - keep system proxy and TUN off initially;
  - avoid persistent public-IP /32 route creation;
  - expose bounded pre/post state markers and an exact rollback/cleanup path;
  - stop before any action that would disconnect WG.
- C2A may read existing recovery-helper **source/metadata only**, not decrypt or inspect real Secret content.
- C2A must produce deterministic fixtures that reject:
  - REALITY appearing as a live selectable node;
  - hardcoded WLAN/ifIndex/gateway/local IP;
  - plaintext HY2 auth in repo/package/log output;
  - system proxy or TUN auto-enable;
  - WG stop/route removal;
  - persistent /32 route;
  - missing rollback/cleanup markers;
  - missing timing instrumentation.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires:
- one atomic Owner-run C2B checkpoint package exists and is statically/offline validated;
- package contains no real Secret and does not unprotect DPAPI during C2A;
- WG + HY2 live selector semantics are explicit;
- REALITY is explicitly excluded from live selector and marked deferred/cold;
- first live canary keeps WG connected and proxy/TUN off;
- exact cleanup/rollback is encoded;
- timing begins inside the one-shot package before preflight;
- no live client/network/server action occurs in C2A.

### TIMING_OBSERVABILITY

- Reviewer estimate: **15–25 minutes end-to-end**.
- Executor must record `ROUND_STARTED_AT` before fetch/preflight and complete finish/elapsed/overrun fields.
- If over 25 minutes, record evidence-backed cause and update `docs/ROUND_TIMING_RETROSPECTIVE.md` under its existing rules.
- Do not replay actions for timing.

### OWNER_ONLY_ACTIONS

NONE in C2A.

### REVIEWER_TO_EXECUTOR_RELAY

Build only the offline Owner C2B canary package. Do not read Secret values, unprotect DPAPI, start/apply Clash, send traffic, change routes/proxy/TUN/WG, access VPS, or make REALITY live.

### EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE_G3C_C2A_CLASH_UI_CANARY_PACKAGE or a precise RETURN. Persist Evidence/Executor Handoff and STOP_AT_REVIEWER.

## NEXT_STEP

Codex Desktop builds and offline-validates the C2B Owner checkpoint package. Reviewer then inspects it before asking Owner to perform the first real Clash Verge UI canary.

## OWNER_ACTION_REQUIRED

**NONE for C2A.** Keep WireGuard and Clash settings unchanged. The next Owner action will only occur after Reviewer approves the C2B package.

## REVIEWER_TO_EXECUTOR_RELAY

Execute current C2A only: build the offline atomic Owner C2B canary package for WG+HY2; REALITY stays cold/deferred; no Secret/runtime/network action.

## EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE_G3C_C2A_CLASH_UI_CANARY_PACKAGE or precise RETURN; persist Evidence/Handoff and STOP.

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
