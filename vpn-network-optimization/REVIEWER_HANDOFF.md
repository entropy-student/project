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
- **G3-B D1:** migration package discovery/design PASS.
- **G3-B D2:** future-target qualification contract PASS; live target execution has not occurred.
- **Portable package:** current-instance SFO3 identity constants are excluded from portable templates; WireGuard split-default baseline is preserved.
- **Migration rollback policy:** source VPS remains intact and distinguishable through the rollback window; source decommission is a later Closeout Gate.
- **Secret/provider boundary:** Provider purchase/provisioning, Secret transfer/rotation, Owner client cutover, and source decommission remain separately authorized consequential actions.
- **Current runtime:** untouched by G3-B D1/D2.

## CURRENT_GATE

```text
GATE_ID=G3B_STAGED_INSTALL_RENDER_CONTRACT_D3
STATE=AUTHORIZED
PREVIOUS_RESULT=PASS_G3B_TARGET_QUALIFICATION_CONTRACT_D2
OWNER_CONTINUE_AUTHORIZATION=2026-10-03
SPECIALIST_TRIGGERS=11A_SHARED_VPS_STORAGE,11B_SECRET_TARGET_HOST,11C_DEPLOYMENT_NETWORK_RESOURCES,11D_AUTOMATION
OBJECTIVE=Define and offline-validate the staged target-install render contract: portable non-secret metadata may be rendered, while Secret material, service activation, firewall/NAT changes, cutover, and source mutation remain forbidden.
MAX_ENDPOINT_THIS_ROUND=repository-only render plan/manifest + deterministic offline fixtures + static validation; no VPS access, no Provider action, no Secret injection, no runtime file creation outside the local test fixture.
MANDATORY_REVIEW_STOP=YES
CURRENT_VPS_ACCESS_AUTHORIZED=NO
NEW_TARGET_SSH_AUTHORIZED=NO
PROVIDER_ACTION_AUTHORIZED=NO
SECRET_TRANSFER_AUTHORIZED=NO
SERVICE_ENABLEMENT_AUTHORIZED=NO
FIREWALL_NAT_MUTATION_AUTHORIZED=NO
OWNER_CLIENT_CUTOVER_AUTHORIZED=NO
ROLLBACK_STATUS=SOURCE_ONLY_REVERTABLE
ESTIMATED_EXECUTION_TIME=15-25_minutes
STAGED_MANIFEST_COMMIT=59899d53c319990256d9131b87671347a1f67bbb
STAGED_VALIDATOR_COMMIT=7a6e7784c3b79bbb4420e88c9d654f923e7f400c
WG_PUBLIC_KEY_INPUT_COMMIT=8f17c9ffaeca2f87f514adefd8e433a4d0a68f83
WG_SERVER_SECRET_SENTINEL_COMMIT=e286f0050146465347374a9bdabe170faaf966b4
WG_CLIENT_SECRET_SENTINEL_COMMIT=05bb99571b1f11ea954357c9275de00801100c2e
HY2_FINGERPRINT_SENTINEL_COMMIT=5522015954bb14aabd4350db2842ec8af5e3920d
STATIC_SOURCE_REVIEW=PASS
OWNER_OFFLINE_VALIDATION=PENDING
```

### TARGET_AND_SCOPE

- Build one repository-owned staged-install renderer/validator that consumes only non-secret migration metadata.
- Required metadata:
  - target public IPv4;
  - expected target hostname;
  - target-specific HY2 SNI;
  - WireGuard server/client addresses and ports;
  - HY2 port;
  - runtime user/path metadata.
- Render or validate only non-secret artifacts:
  - WireGuard server/client template skeletons with private-key placeholders still intact;
  - HY2 server skeleton with auth/private-key placeholders still intact;
  - HY2 systemd unit;
  - Mihomo/HY2 client skeleton with auth/fingerprint placeholders still intact;
  - staged-install manifest with exact target paths and activation order.
- Secret placeholder preservation is mandatory: D3 must fail if a rendered artifact contains a real-looking private key/password/token or if a required placeholder disappears.
- No service activation, package install, sysctl/firewall/NAT change, route change, SSH, HTTP, or Provider action.

### ACCEPTANCE_CRITERIA

PASS requires:
- deterministic non-secret render output/manifest from a fixture target identity;
- no current SFO3/public-IP/WLAN constants leak into portable output;
- accepted WireGuard split-default baseline preserved;
- target-specific HY2 SNI/public IP/hostname are rendered correctly;
- Secret placeholders remain explicit and complete;
- activation order and rollback checkpoint are explicit;
- zero live action/mutation.

### ROLLBACK_STATUS_OR_PLAN

Source-only D3. Exact commit revert is sufficient; no runtime rollback applies.

### OWNER_ONLY_ACTIONS

Run one repository-only PowerShell 7.6.6 validation after Reviewer static review.

### REVIEWER_TO_EXECUTOR_RELAY

Create the minimum staged-install render contract and validator. Do not read any local recovery bundle or Secret file. Do not execute Linux/service/network commands. Keep output limited to non-secret fixture content and manifest facts.

### EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE after static review and deterministic offline render validation. Any actual target rendering/injection or service activation requires a later Gate.

## NEXT_STEP

Run the G3-B D3 repository-only staged-install render validator once under PowerShell 7.6.6 after syncing canonical `main`, then return the bounded output for Reviewer PASS/RETURN.

## OWNER_ACTION_REQUIRED

Run one repository-only PowerShell 7.6.6 validation of `scripts/g3b-staged-install-render-validator.ps1 -Validate`. It renders fixture content in memory only and does not create files, access a VPS, read Secrets, or activate services.

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
