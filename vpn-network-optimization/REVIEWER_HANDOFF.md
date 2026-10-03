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
G3-A Network auto-adaptation + health       IN_PROGRESS
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
- **REALITY:** Mihomo v1.19.31 is the accepted server implementation; public TCP/443 canary PASS with complete cleanup and no persistence.
- **P1 replay:** forbidden; the one-request budget is exhausted (`1/1`).
- **G3-A H1:** formally PASS. `scripts/g3a-network-adaptation-planner.ps1` is advisory-only, dynamically resolves physical egress, fails closed on missing/ambiguous egress or health state, and passed 9 deterministic Owner-host fixtures under PowerShell 7.6.6 with zero network/service/proxy/TUN/VPS mutation and zero Secret read/emission.
- **Automation boundary:** no live automatic switching has been authorized. H1 plans only; H2 may collect read-only health/readiness facts only.
- **Final validation pending:** G4 peak-hour and representative Codex/OpenAI/image-generation workload validation remains mandatory before MVP v1 seal.

## CURRENT_GATE

```text
GATE_ID=G3A_READONLY_HEALTH_READINESS_H2
STATE=AUTHORIZED
PREVIOUS_RESULT=PASS_G3A_NETWORK_ADAPTATION_LOCAL_ENGINEERING_H1
OWNER_CONTINUE_AUTHORIZATION=2026-10-03
SPECIALIST_TRIGGERS=11B_SSH_TARGET_HOST,11C_DEPLOYMENT_NETWORK_RESOURCES,11D_AUTOMATION
OBJECTIVE=Build and validate a read-only Windows/VPS health-readiness collector that distinguishes current production health from cold candidate readiness without changing network state or generating external workload traffic.
MAX_ENDPOINT_THIS_ROUND=project-owned source change + offline fixtures + one Owner read-only local/SSH collection + Reviewer stop.
MANDATORY_REVIEW_STOP=YES
LIVE_NETWORK_ACTIVATION_AUTHORIZED=NO
REAL_OPENAI_REQUEST_AUTHORIZED=NO
PUBLIC_LISTENER_CREATION_AUTHORIZED=NO
TEMP_ROUTE_MUTATION_AUTHORIZED=NO
SECRET_READ_AUTHORIZED=NO
ROLLBACK_STATUS=SOURCE_ONLY_REVERTABLE
ESTIMATED_EXECUTION_TIME=15-30_minutes
```

### TARGET_AND_SCOPE

- New collector: `scripts/g3a-health-readiness-readonly.ps1`.
- Local read-only facts:
  - PowerShell/runtime identity;
  - WireGuard `SFO2-A` adapter/service/control-route state;
  - split-default route presence;
  - unique current physical IPv4 egress identity;
  - Clash Verge service presence/state;
  - exact P1 `24.199.118.137/32` route residue count;
  - system proxy / WinHTTP / TUN read-back without modification.
- Remote read-only facts over the already accepted strict SSH control path:
  - target hostname/public-IP identity;
  - WG/HY2 service and UDP listener state;
  - TCP/443 and 14443 listener absence;
  - G2-C runtime-residue absence;
  - UFW/iptables/nft summary needed to classify readiness.
- H2 outputs facts/readiness only. It must not feed a mutating actuator or change production default.

### STATE_SEMANTICS

- `WIREGUARD_CURRENT_HEALTH`: health of the currently active production/rollback path.
- `HY2_READINESS`: readiness of the already deployed HY2 server plus local prerequisites; not a claim that a persistent HY2 client is active.
- `REALITY_READINESS`: validated cold candidate readiness. TCP/443 being free is expected; absence of a persistent REALITY server is not failure.
- `UNKNOWN` is preserved whenever required evidence is ambiguous or unavailable.

### PREFLIGHT

- Canonical `main`, project-owned source path, clean source baseline.
- Reuse accepted strict SSH trust/identity metadata; no host-key auto-accept.
- Multiline remote payloads must normalize CRLF to LF and use stdin/simple fixed remote command.
- No Secret values or recovery bundles are read.
- No external HTTP/OpenAI request.

### REQUIRED_EVIDENCE

- AST/static source review;
- offline fixtures for healthy baseline, missing/ambiguous local egress, unhealthy WG, unavailable HY2 server, REALITY cold-ready, SSH/nonzero failure classification;
- negative scan for route/service/proxy/TUN mutation and external workload calls;
- Owner-host read-only output with explicit mutation counters all zero;
- strict SSH exit checked; remote target identity matched;
- no P1 route/runtime/listener residue.

### ACCEPTANCE_CRITERIA

PASS requires:
- local and remote facts are reviewable and internally consistent;
- WireGuard current health and HY2/REALITY readiness are not conflated;
- missing/ambiguous facts produce `UNKNOWN`/fail-closed rather than optimistic readiness;
- zero live network/service/proxy/TUN/VPS mutation and zero Secret read/emission;
- no external workload request.

### ROLLBACK_STATUS_OR_PLAN

Source-only changes are revertable by exact commit revert. Owner collection is read-only, so runtime rollback is not applicable.

### OWNER_ONLY_ACTIONS

None beyond running one bounded read-only Owner checkpoint after Reviewer source review.

### REVIEWER_TO_EXECUTOR_RELAY

Work only on `scripts/g3a-health-readiness-readonly.ps1`, current H2 Gate, accepted H1 planner semantics, and the accepted strict SSH/public-path facts needed to define read-only probes. Do not replay P1, do not read Secrets, do not create routes/listeners, and do not send HTTP/OpenAI traffic.

### EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE only after static negative scan + fixtures. Owner-host read-only proof is still required before formal H2 PASS.

## NEXT_STEP

Implement and statically/offline validate the H2 read-only health/readiness collector. After Reviewer source review, run exactly one bounded Owner-host read-only collection and return the output for H2 PASS/RETURN.

## OWNER_ACTION_REQUIRED

**NONE yet.** Wait for Reviewer to finish H2 source/static validation and provide the exact read-only PowerShell command.

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
