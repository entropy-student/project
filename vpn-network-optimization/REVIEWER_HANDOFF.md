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
G3-A Network auto-adaptation + health       PASS
G3-B VPS migration + rollback package       IN_PROGRESS
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

- **Current production/rollback:** WireGuard remains the active production/rollback path.
- **G3-A:** H1–H4 formally PASS; sensing/readiness/advisory decision is complete, with no automatic actuator implemented.
- **G3-B D1:** migration package discovery/design formally PASS.
- **Portable package:** current-instance SFO3 IP/SNI/WLAN/label constants are excluded from portable templates; WireGuard split-default baseline is preserved.
- **Migration rollback policy:** source VPS remains intact and distinguishable through the rollback window; source decommission is a later Closeout Gate.
- **Secret/provider boundary:** Provider purchase/provisioning, Secret transfer/rotation, Owner client cutover, and source decommission remain separately authorized consequential actions.
- **Current runtime:** untouched by G3-B D1.

## CURRENT_GATE

```text
GATE_ID=G3B_TARGET_QUALIFICATION_CONTRACT_D2
STATE=AUTHORIZED
PREVIOUS_RESULT=PASS_G3B_MIGRATION_ROLLBACK_PACKAGE_DISCOVERY_D1
OWNER_CONTINUE_AUTHORIZATION=2026-10-03
SPECIALIST_TRIGGERS=11A_SHARED_VPS_STORAGE,11B_SSH_SECRET_TARGET_HOST,11C_DEPLOYMENT_NETWORK_RESOURCES
OBJECTIVE=Define and offline-validate a machine-readable, read-only qualification contract for a future target VPS before any install, Secret transfer, or migration action.
MAX_ENDPOINT_THIS_ROUND=repository-only target probe/parser/fixture work + offline validation; no SSH to current VPS, no Provider action, no target VPS required, no Secret read, no runtime mutation.
MANDATORY_REVIEW_STOP=YES
CURRENT_VPS_ACCESS_AUTHORIZED=NO
NEW_TARGET_SSH_AUTHORIZED=NO_IN_D2
PROVIDER_ACTION_AUTHORIZED=NO
SECRET_TRANSFER_AUTHORIZED=NO
RUNTIME_MUTATION_AUTHORIZED=NO
ROLLBACK_STATUS=SOURCE_ONLY_REVERTABLE
ESTIMATED_EXECUTION_TIME=15-25_minutes
```

### TARGET_AND_SCOPE

- Reuse `scripts/preflight-linux.sh` concepts but create a G3-B target-specific, machine-readable read-only qualification probe.
- Qualification facts must include:
  - target hostname and public IPv4 identity input;
  - OS/kernel/architecture;
  - default route/WAN interface;
  - root free space and memory;
  - IPv4 forwarding state;
  - current WG/HY2/Mihomo/sing-box/xray process/service collision indicators;
  - UDP/51820, UDP/8443, TCP/443, TCP/14443 listener collision counts;
  - UFW/iptables/nft summary;
  - project runtime residue/path collision indicators;
  - canonical project paths existence/state.
- Probe must not read private keys, application Secrets, or raw provider metadata.
- D2 defines qualification only; it does not decide provider/region performance suitability.

### ACCEPTANCE_CRITERIA

PASS requires:
- machine-readable probe is read-only and fail-closed;
- deterministic fixtures cover qualified target, occupied required port, existing conflicting runtime, insufficient resource, identity mismatch, and ambiguous firewall state;
- no Secret values are read or emitted;
- no network/service/package/firewall/filesystem mutation exists in the probe;
- target qualification result is separate from migration/cutover authorization.

### ROLLBACK_STATUS_OR_PLAN

Source-only D2. Exact commit revert is sufficient; no runtime rollback applies.

### OWNER_ONLY_ACTIONS

None in D2.

### REVIEWER_TO_EXECUTOR_RELAY

Create only the minimum target qualification probe/parser/fixtures needed for G3-B. Do not access any live VPS or Provider. Reuse accepted project path/port conventions and preserve fail-closed behavior.

### EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE after static negative scan and offline fixture validation. Live execution on an actual future target requires a separate Gate.

## NEXT_STEP

Implement and offline-validate the G3-B D2 target qualification contract. No live VPS is required or authorized in this Gate.

## OWNER_ACTION_REQUIRED

**NONE.** D2 is repository-only; do not buy/create a VPS or run SSH.

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
