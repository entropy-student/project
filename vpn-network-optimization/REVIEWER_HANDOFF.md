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

- **Current production/rollback:** system WireGuard remains connected and authoritative.
- **G3-C C1:** formally PASS; accepted Windows Mihomo core is v1.19.32.
- **Original C2A package:** repository-only execution was clean; WG+HY2 selector shape, REALITY exclusion, AST/fixtures and no-live-action boundaries all passed.
- **C2A blocking review finding:** the prepared future C2B runner would decrypt the real HY2 auth into a temporary profile and then ask Owner to import it into Clash Verge. Upstream Clash Verge behavior persists local profile content into its own application `profiles/` storage, where proxy passwords/UUIDs can reside. The current package only proves cleanup of the project-owned temp file, not Clash-owned persistent copies or backup propagation.
- **C2A disposition:** RETURN for Secret persistence boundary only. Do not discard the valid selector/cleanup/network-safety work; minimally repair the future C2B package.
- **Revised sequencing:** C2B becomes a **synthetic-secret, no-traffic UI-only canary** with no DPAPI access and no real HY2 credential/endpoint dependency. It proves Clash profile import, WG/HY2 UI visibility, default/manual selector behavior, and canary-profile removal only.
- **Real HY2-in-Clash connectivity:** deferred to C2C, which will explicitly review whether and how real HY2 credentials may persist in Clash-owned storage.
- **REALITY:** remains cold/deferred and excluded from C2B/C2C until its own persistent readiness Gate.
- **Timing:** original C2A took 43m29s vs 15–25m; only broad aggregate cause was recorded. Repair round must include lightweight phase timing.

## CURRENT_GATE

```text
GATE_ID=G3C_C2A_SYNTHETIC_UI_PACKAGE_REPAIR_R1
STATE=AUTHORIZED
PREVIOUS_RESULT=RETURN_C2B_SECRET_PERSISTENCE_BOUNDARY_UNRESOLVED
OWNER_CONTINUE_AUTHORIZATION=2026-10-03
SPECIALIST_TRIGGERS=11B_SECRET_TARGET_HOST_LOCAL_RUNTIME,11C_DEPLOYMENT_NETWORK_RESOURCES,11D_AUTOMATION
OBJECTIVE=Repair the future C2B package into a synthetic-secret, no-traffic Clash UI canary that proves UI/control semantics without exposing or persisting the real HY2 Secret.
MAX_ENDPOINT_THIS_ROUND=repository-only package/template/validator/docs repair + deterministic offline validation + timing evidence; no DPAPI, Secret, Clash, Mihomo runtime, network, route, proxy/TUN/WG or VPS action.
MANDATORY_REVIEW_STOP=YES
ACTIVE_VPN_CONNECTIVITY_MUST_BE_PRESERVED=YES
DPAPI_ACCESS_AUTHORIZED=NO
SECRET_READ_AUTHORIZED=NO
REAL_HY2_AUTH_ALLOWED_IN_C2B_PACKAGE=NO
REAL_HY2_ENDPOINT_REQUIRED_IN_C2B=NO
CLASH_PROFILE_APPLY_AUTHORIZED=NO_IN_R1
CLASH_ACTIVE_START_AUTHORIZED=NO_IN_R1
NETWORK_REQUEST_AUTHORIZED=NO
WG_SERVICE_STOP_AUTHORIZED=NO
WG_ROUTE_REMOVAL_AUTHORIZED=NO
SYSTEM_PROXY_CHANGE_AUTHORIZED=NO
TUN_CHANGE_AUTHORIZED=NO
ROUTE_CHANGE_AUTHORIZED=NO
VPS_ACCESS_AUTHORIZED=NO
REALITY_LIVE_NODE_AUTHORIZED=NO
DEFAULT_EXECUTION_CHANNEL=CODEX_DESKTOP_EXECUTOR
OWNER_INTERVENTION_REQUIRED=NO_IN_R1
ESTIMATED_EXECUTION_TIME=15-25_minutes
TIMING_OBSERVABILITY_REQUIRED=YES_WITH_PHASES
TIME_OVERRUN_REVIEW_REQUIRED=YES
```

### REQUIRED_REPAIR

1. Preserve the valid two-node UI shape, but make the future C2B profile **synthetic/no-traffic**:
   - `WG-BASELINE` remains first/default `direct`.
   - one HY2 UI-canary node is shown; it must use a reserved documentation address and fixture-only auth/fingerprint, never the production HY2 Secret.
   - REALITY remains absent and documented cold/deferred.
2. Remove all DPAPI recovery/unprotect/auth extraction from the future C2B Owner runner. The runner must not read the real recovery artifact at all.
3. C2B must not depend on the real HY2 endpoint or real certificate fingerprint to prove UI visibility.
4. C2B remains no-traffic:
   - system WireGuard stays connected;
   - system proxy and TUN remain off;
   - no delay test, curl, API request, health probe, or route mutation;
   - no persistent/temporary public-IP /32 route.
5. Add structured Owner UI evidence to the one-shot runner. Before cleanup, require one bounded acknowledgement that confirms all of:
   - temporary profile imported;
   - WG baseline visible;
   - HY2 UI-canary node visible;
   - manual selector group visible;
   - default/current selector is WG baseline;
   - synthetic HY2 node was not used for traffic.
6. Extend Clash-owned cleanup observability:
   - snapshot the Clash Verge application profile directory file-name/hash set before Owner import using read-only hashes only;
   - after Owner removes the canary profile, assert no **new canary-related profile file** remains and no unexpected new profile files remain relative to the pre-snapshot;
   - do not print or parse existing profile contents/Secrets;
   - if cleanup is ambiguous or residue remains, RETURN and do not delete unrelated Clash files automatically.
7. Keep the project-owned runtime marker/CreateNew/owner-only ACL cleanup logic.
8. Update package docs to state clearly:
   - C2B proves UI only, not HY2 connectivity;
   - no real Secret is used;
   - C2C is the first stage allowed to consider real HY2-in-Clash persistence/connectivity.
9. Extend deterministic fixtures to reject:
   - any DPAPI/recovery-path access in C2B;
   - any production HY2 auth/real endpoint dependency;
   - missing structured UI acknowledgement;
   - missing Clash profile-store pre/post residue check;
   - any network request/delay-test instruction;
   - REALITY live inclusion;
   - WG/proxy/TUN/route mutation.
10. C2A-R1 itself stays source-only.

### TIMING_OBSERVABILITY

Reviewer estimate: **15–25 minutes**.

Record total timing plus these four lightweight phase elapsed values:
- `SOURCE_BUILD_ELAPSED`
- `FIXTURE_VALIDATE_ELAPSED`
- `STATIC_REVIEW_ELAPSED`
- `GIT_PERSISTENCE_ELAPSED`

If total exceeds 25 minutes, use those measurements for `TIME_OVERRUN_CAUSE`; do not use only a broad aggregate label.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires:
- C2B package contains no real Secret and has no DPAPI/recovery access;
- synthetic HY2 node cannot accidentally represent production connectivity;
- structured UI evidence is encoded;
- Clash-owned profile-store residue detection is encoded without reading/printing existing Secret content;
- no automatic deletion of unrelated Clash files;
- project runtime cleanup remains exact;
- all new/updated negative fixtures PASS;
- no live action in R1;
- complete total + phase timing evidence.

### OWNER_ONLY_ACTIONS

NONE in R1.

### REVIEWER_TO_EXECUTOR_RELAY

Repair only the future C2B package. Do not execute it. Remove real-Secret/DPAPI use from C2B entirely; make it a synthetic UI-only canary and add Clash profile-store residue observability plus structured UI evidence.

### EXECUTOR_TO_REVIEWER_RELAY

Return `PASS_CANDIDATE_G3C_C2A_SYNTHETIC_UI_PACKAGE_REPAIR_R1` or precise `RETURN_*`; persist Evidence/Handoff/timing and STOP_AT_REVIEWER.

## NEXT_STEP

Codex repairs the future C2B package offline. Reviewer then inspects the synthetic/no-traffic package. Only after PASS will Owner be asked to import the temporary synthetic profile into Clash Verge.

## OWNER_ACTION_REQUIRED

**NONE.** Keep WireGuard and Clash unchanged. Do not run the current C2B runner; it is superseded pending repair.

## REVIEWER_TO_EXECUTOR_RELAY

Execute only C2A synthetic UI package repair R1. Do not run C2B or access DPAPI/Secrets/runtime/network.

## EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE_G3C_C2A_SYNTHETIC_UI_PACKAGE_REPAIR_R1 or precise RETURN; persist Evidence/Handoff/timing and STOP.

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
