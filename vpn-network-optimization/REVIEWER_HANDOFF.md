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

- **Current production/rollback:** WireGuard remains the active production/rollback path on the existing DigitalOcean sfo3 VPS.
- **G3-A:** H1–H4 formally PASS; sensing/readiness/advisory decision is complete, with no automatic actuator implemented.
- **G3-B D1:** migration package discovery/design PASS.
- **G3-B D2:** future-target qualification contract PASS.
- **G3-B D3:** staged-install render contract PASS; six offline fixtures passed on the clean rebuilt validator under PowerShell 7.6.5/7.6.x contract.
- **Portable package:** current SFO3 instance identity constants are excluded from portable templates; WireGuard split-default baseline and Secret sentinels are preserved.
- **Migration rollback policy:** the source VPS remains intact and distinguishable through the rollback window; deleting/rebuilding the source is not part of migration PASS.
- **Unproven boundary:** no fresh target VPS has yet been qualified or staged. Governance migration PASS requires fresh-target proof; D1–D3 offline success cannot substitute for it.
- **Current runtime:** existing VPS/client state remains unchanged by G3-B D1–D3.

## CURRENT_GATE

```text
GATE_ID=G3B_FRESH_TARGET_QUALIFICATION_R1
STATE=PENDING_OWNER_ACTION
PREVIOUS_RESULT=PASS_G3B_STAGED_INSTALL_RENDER_CONTRACT_D3
SPECIALIST_TRIGGERS=11A_SHARED_VPS_STORAGE,11B_SSH_SECRET_TARGET_HOST,11C_DEPLOYMENT_NETWORK_RESOURCES,11E_PROVIDER
OBJECTIVE=Qualify one fresh disposable target VPS with the accepted D2 read-only probe before any install, Secret transfer, service activation, or cutover.
OWNER_TARGET_REQUIRED=YES
OWNER_AUTHORIZATION_REQUIRED=YES
LIVE_TARGET_MUTATION_AUTHORIZED=NO
SOURCE_VPS_ACCESS_AUTHORIZED=NO
SOURCE_VPS_MUTATION_AUTHORIZED=NO
SECRET_TRANSFER_AUTHORIZED=NO
SERVICE_ENABLEMENT_AUTHORIZED=NO
PROVIDER_PURCHASE_OR_PROVISIONING=OWNER_CHECKPOINT
CUTOVER_AUTHORIZED=NO
ROLLBACK_STATUS=SOURCE_VPS_REMAINS_AUTHORITATIVE
MANDATORY_REVIEW_STOP=YES
```

### TARGET_AND_SCOPE

- One **fresh/disposable** Ubuntu 24.04 x86_64 VPS with no unrelated business workload.
- Freeze exact provider/account context, public IPv4, hostname, SSH identity reference, and host-key trust before first SSH.
- First execution after authorization is **read-only qualification only** using the accepted D2 target probe.
- Required target facts: identity, OS/arch, default route/WAN, memory/disk, required-port collisions, conflicting VPN runtimes, firewall/nft state, and project-path residue.
- No package install, directory creation, Secret read/generation/transfer, service change, firewall/NAT/sysctl/route change, or Owner traffic switch in R1.

### ACCEPTANCE_CRITERIA

PASS requires a fresh real target to return `QUALIFIED_FOR_STAGED_INSTALL` semantics under the accepted D2 contract, with exact target identity/trust proven and zero target/source mutation.

### ROLLBACK_STATUS_OR_PLAN

Read-only R1 has no target mutation to roll back. Existing source VPS remains the authoritative production/rollback path.

### OWNER_ONLY_ACTIONS

Provide or create one disposable fresh VPS for rehearsal and explicitly authorize its use as the G3-B target. Do not send any Secret value in chat. Provider purchase/provisioning, if needed, is an Owner checkpoint.

### REVIEWER_TO_EXECUTOR_RELAY

**NONE until Owner supplies/authorizes a fresh target.** Do not SSH to any existing VPS as a substitute and do not use the shared Hostinger VPS merely because it is available.

### EXECUTOR_TO_REVIEWER_RELAY

No execution is authorized while `STATE=PENDING_OWNER_ACTION`.

## NEXT_STEP

Wait for Owner to provide/authorize one fresh disposable target VPS. Reviewer will then freeze target identity/trust and issue the bounded read-only D2 qualification command to Codex Desktop Executor.

## OWNER_ACTION_REQUIRED

Provide one fresh/disposable Ubuntu 24.04 x86_64 VPS for migration rehearsal, or explicitly authorize creating one. Minimum relay: provider/name or label, public IPv4, expected hostname, and confirmation that it may be used as a disposable VPN migration target. Do **not** send private keys, passwords, tokens, or other Secret values.

## REVIEWER_TO_EXECUTOR_RELAY

**NONE while R1 is pending Owner target authorization.**

## EXECUTOR_TO_REVIEWER_RELAY

No Executor action is authorized until Reviewer changes R1 from `PENDING_OWNER_ACTION` after target identity/trust is frozen.

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
