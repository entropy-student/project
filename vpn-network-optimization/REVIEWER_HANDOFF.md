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
G3-C C2A Synthetic UI package repair        PASS_WITH_TIMING_GAP
G3-C C2B-P0 Local-fact persistence          RETURN->FIXED
G3-C C2B Synthetic Clash UI canary          IN_PROGRESS
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
- **G3-C C2A repair:** accepted technically with the previously recorded timing-observability gap.
- **G3-C C2B-P0 R1 durability objective:** accepted without replay. Canonical commits `fc2aa9399627c19b5368ed6da6a219deaeb20b77` and `dd8651aa760062f71ddc84a1154b21873ecbc174` durably contain the previously missing GitHub read-back, Git-persistence timing, and safe-fast-forward facts.
- **R1 formal Gate disposition:** `RETURN_R1_TIMING_START_NOT_CAPTURED` remains the correct Executor result because the Gate required a round-start marker before initial fetch. Reviewer does not convert that Gate to PASS; the missing exact start is retained as a process-observability defect.
- **Replay:** NONE. The timing defect cannot be repaired by replay and does not invalidate the already-completed document reconciliation.
- **Current-main drift check:** current main may advance for unrelated projects; Reviewer verified the post-`dd8651...` advancement touched only `birthday-magazine-studio/`, not this VPN project.
- **C2B source identity:** direct GitHub read-back confirms runner blob `cd5a2eb768b54d13307b651ea514a912b9742c9d` and template blob `b50f9747157200670d6e85fdd53ba81e9a8c5c76`.
- **Local worktree:** Executor reported the managed VPN worktree clean after durable read-back and cleanup; the next Gate must independently re-prove project-scoped cleanliness before the Owner checkpoint.
- **No live action occurred in R1.**
- **Benchmark detour remains cancelled.**

## CURRENT_GATE

```text
GATE_ID=G3C_C2B_OWNER_SYNTHETIC_UI_CANARY_R2
STATE=READY_OWNER_CHECKPOINT
PREVIOUS_RESULT=RETURN_R1_TIMING_START_NOT_CAPTURED_CLOSED_NO_REPLAY
OBJECTIVE=Prove the existing synthetic two-node Clash Verge profile is visible and manually selectable in the UI while production WireGuard remains unchanged and no HY2 traffic is sent.
MAX_ENDPOINT_THIS_ROUND=Synthetic local UI import -> visual confirmation -> profile removal -> post-readback/cleanup only. No real HY2 credentials, no DPAPI recovery read, no real endpoint, no network request, no VPS access, no route/proxy/TUN/WireGuard mutation, no REALITY activation.
MANDATORY_REVIEW_STOP=YES
RUNNER=scripts/c2b-owner-clash-ui-canary.ps1
RUNNER_BLOB=cd5a2eb768b54d13307b651ea514a912b9742c9d
TEMPLATE=templates/clash/c2b-wg-hy2-canary.yaml.template
TEMPLATE_BLOB=b50f9747157200670d6e85fdd53ba81e9a8c5c76
OWNER_PACKAGE=docs/G3C_C2B_OWNER_CANARY_PACKAGE.md
SPECIALIST_RULES=11B_TARGET_HOST
ESTIMATED_EXECUTION_TIME=5-10_minutes
TIMING_OBSERVABILITY_REQUIRED=YES
```

### PREFLIGHT

1. Fresh-read current canonical main and verify this VPN project has no material drift from the accepted C2B package.
2. Re-prove the project-scoped checkout/worktree is clean before launching the checkpoint; unrelated repository artifacts outside the VPN project are not blockers.
3. Verify the runner/template blobs exactly match the locked identities above.
4. Use the existing runner as one atomic PowerShell checkpoint; do not edit it in this Gate.
5. Runner must emit `ROUND_STARTED_AT` before its own runtime/network-state prechecks.
6. Require PowerShell 7.6.6, Administrator/High-integrity Owner host context, current WireGuard baseline running, system proxy OFF, Clash/Mihomo TUN OFF, and exactly one discoverable Clash Verge profile store.
7. Any mismatch, ambiguous profile store, unexpected local residue, source drift, or cleanup failure => precise RETURN before proceeding further.

### OWNER CHECKPOINT

The runner creates only an owner-only temporary synthetic profile. Owner then:
1. imports **only** the synthetic profile shown by the runner;
2. leaves the active production profile and WireGuard unchanged;
3. confirms `WG-BASELINE`, synthetic `HY2-SFO3`, and the manual selector are visible;
4. confirms `WG-BASELINE` remains current/default;
5. does **not** select HY2 and sends **no** HY2 traffic;
6. removes the imported synthetic profile in Clash Verge;
7. enters the runner's exact bounded acknowledgement.

### REQUIRED_EVIDENCE

- canonical/main and locked source identities;
- project-scoped clean preflight;
- `ROUND_STARTED_AT`, `ROUND_FINISHED_AT`, `ACTUAL_ELAPSED`, `TIME_OVERRUN`;
- `C2B_PREFLIGHT=PASS`;
- `MIHOMO_CONFIG_TEST=PASS`;
- structured Owner acknowledgement;
- `CLASH_PROFILE_STORE_POSTREMOVE=PASS`;
- `POST_UI_NETWORK_READBACK=PASS`;
- `LOCAL_RUNTIME_CLEANUP=PASS`;
- WireGuard remains connected; system proxy OFF; TUN OFF; route snapshot unchanged;
- `SECRET_VALUES_EMITTED=0`;
- no network/VPS/Secret/DPAPI action.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires all required evidence above, no profile-store residue or unrelated mutation, no real HY2/REALITY traffic, no system-network change, complete timing, and STOP_AT_REVIEWER.

### ROLLBACK_STATUS_OR_PLAN

No production mutation is authorized. The synthetic Clash profile is removed by Owner during the checkpoint; the runner owns and removes only its exact temporary project runtime files. Any unexpected profile-store or network delta fails closed and stops for Reviewer reconciliation.

### OWNER_ONLY_ACTIONS

Import/inspect/remove the synthetic Clash profile and enter the exact runner acknowledgement. Owner is not responsible for debugging or redesign.

### REVIEWER_TO_EXECUTOR_RELAY

Use only the locked C2B runner/template/package. First fresh-read canonical state and re-prove project-scoped cleanliness/source blobs. Then enter the one-shot Owner synthetic UI checkpoint. Do not read DPAPI/recovery material, substitute real HY2 values, start Mihomo traffic, touch routes/proxy/TUN/WireGuard/VPS, or enter C2C. STOP_AT_REVIEWER.

### EXECUTOR_TO_REVIEWER_RELAY

Return `PASS_CANDIDATE_G3C_C2B_OWNER_SYNTHETIC_UI_CANARY_R2` or precise `RETURN_*`; include the bounded runner outputs only; STOP_AT_REVIEWER.

## NEXT_STEP

Run the bounded C2B synthetic/no-traffic Clash UI checkpoint. This proves only UI visibility/manual selection semantics and cleanup; real HY2 connectivity remains C2C.

## OWNER_ACTION_REQUIRED

Run the one-shot C2B Owner checkpoint when prompted: import only the synthetic profile, visually confirm the two nodes/manual selector with WG still current, do not select HY2 or send traffic, remove the synthetic profile, then enter the exact acknowledgement.

## REVIEWER_TO_EXECUTOR_RELAY

Use only the locked C2B package and perform its fresh local preflight before the Owner checkpoint. No real HY2/REALITY, Secret/DPAPI, network/VPS, route/proxy/TUN/WG action. STOP_AT_REVIEWER.

## EXECUTOR_TO_REVIEWER_RELAY

Return PASS_CANDIDATE_G3C_C2B_OWNER_SYNTHETIC_UI_CANARY_R2 or precise RETURN; STOP.

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
