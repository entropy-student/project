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
G2-C VLESS+REALITY side-by-side candidate  IN_PROGRESS
G2-D Peak-hour + real workload validation   PENDING
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

- G2-C read-only preflight passed: strict SSH path valid; TCP/443 free; WG/HY2 healthy; no existing sing-box/Xray/Mihomo server-core collision; NTP healthy; about 254 MiB MemAvailable and 6.69 GiB root free.
- G2-B root cause is closed: WireGuard Windows `0.0.0.0/0` strict WFP kill-switch blocked HY2 outer UDP before WLAN.
- Owner replaced IPv4 `0.0.0.0/0` with `0.0.0.0/1, 128.0.0.0/1`; fresh read-back proved both split defaults present and `Block all outbound (IPv4)` absent.
- Post-repair raw UDP/8443 reached the VPS.
- Post-repair HY2 handshake passed: curl exit 0, HTTP 401 from the OpenAI endpoint, `HY2_AUTH=PASS`, `TLS_CERTIFICATE_PINNING=PASS`, `HY2_OUTER_ROUTE=WLAN_DIRECT`.
- Formal same-window comparison completed 60 WireGuard + 60 HY2 samples with zero failures, zero timeouts, and zero resets on both.
- WireGuard: Median 0.796850s, P90 1.502720s, P95 1.735142s, P99 5.745878s, >1s 15, >1.5s 7, >2s 1.
- HY2: Median 0.498499s, P90 0.715330s, P95 0.761820s, P99 1.771594s, >1s 2, >1.5s 1, >2s 0.
- Accepted comparison: `HY2_BETTER_THIS_WINDOW`.
- Not yet proven: `PEAK_HOUR_SUPERIORITY_PROVEN=NO`.
- Cleanup passed: temporary /32 route absent, test Mihomo absent, runtime Secret config absent, plaintext Secret residue 0, production WireGuard restored.
- Secret values emitted/committed: 0.
- Accepted Evidence commit: `b85224370a295cc5128e29da9186573b81345d27`.

## CURRENT_GATE

```text
GATE_ID=G2C_VLESS_REALITY_SIDEBYSIDE
STATE=PREFLIGHT_PASS_DEPLOYMENT_PENDING_OWNER_AUTH
OBJECTIVE=Add VLESS+REALITY as the frozen TCP/443 fallback candidate without disturbing WireGuard or HY2.
MAX_ENDPOINT_THIS_ROUND=Read-only preflight completed; next consequential endpoint is one side-by-side VLESS+REALITY deployment checkpoint after explicit Owner authorization.
MANDATORY_REVIEW_STOP=YES
```

### TARGET_AND_SCOPE

This Gate adds one complementary candidate only:
- candidate protocol: VLESS + REALITY + XTLS Vision over TCP/443;
- planned server implementation: sing-box, subject to fresh preflight;
- planned Windows client: existing Clash Verge / Mihomo;
- WireGuard remains production/rollback;
- HY2 remains the validated UDP/QUIC performance candidate;
- no persistent VLESS client/default-route switch in this round.

The protocol candidate set is frozen to WireGuard + HY2 + VLESS/REALITY. Do not add TUIC/AnyTLS/VMess/Trojan/Shadowsocks/MASQUE unless later evidence proves a capability gap not covered by these three.

### APPLICABLE_CRITICAL_CONSTRAINTS

- Do not interrupt current WireGuard connectivity or foreground work.
- Reuse the accepted strict SSH identity/trust path; do not request or expose the private key.
- Secret values must not be generated or emitted during this read-only round.
- TCP/443 ownership must be proven before any later listener is installed.
- No change to WG/HY2 services, routes, firewall, sysctl, BBR/fq/GRO, DNS, or current client profile.

### PREFLIGHT

Fresh read-back must prove:
- real Owner Windows runtime and current WireGuard state;
- existing SSH key/trust metadata is usable through the accepted WireGuard control path;
- exact VPS identity;
- TCP/443 listener/ownership state;
- current WG UDP/51820 and HY2 UDP/8443 health;
- whether sing-box/Xray/Mihomo already exists on the VPS;
- time sync, memory, disk, and firewall status sufficient for a later side-by-side service;
- no target-port/shared-service collision.

### REQUIRED_EVIDENCE

- Windows preflight PASS;
- strict SSH connection PASS with native exit 0;
- VPS hostname/OS/arch;
- TCP_443_FREE=YES/NO plus bounded owner/process metadata if occupied;
- WG and HY2 service/listener read-back;
- server-core inventory;
- time-sync/resource/firewall read-back;
- READ_ONLY_MUTATION=NO;
- SECRET_VALUES_EMITTED=0.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE for preflight only when target identity is unchanged, WireGuard/HY2 are healthy, SSH trust is valid, and TCP/443 has no unreviewed ownership conflict. Any collision/drift returns to Reviewer before a deployment design is sealed.

### ROLLBACK_STATUS_OR_PLAN

Read-only round: no target mutation, so rollback is not applicable. Existing WireGuard + HY2 state must remain unchanged.

### OWNER_ONLY_ACTIONS

Owner authorized entry into the next protocol-selection step on 2026-10-02. This authorization covers this read-only preflight only. A later server install / Secret generation / public TCP listener is a consequential continuation inside G2-C and will be issued only after Reviewer accepts this preflight.

### REVIEWER_TO_EXECUTOR_RELAY

Read only:
- this Gate;
- current `SYSTEM_MAP` / `CURRENT_ACCEPTED_STATE`;
- `scripts/g2c-vless-reality-preflight.ps1`;
- existing strict SSH pattern from `scripts/g2b-hy2-server-readonly.ps1` only if needed.

Do not traverse historical G2-B diagnostics. Run one bounded read-only Owner checkpoint and return the fixed completion packet.

### EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
改动：NONE；只读 Windows + VPS preflight。
验证：SSH / TCP443 / WG / HY2 / core inventory / time / resources。
问题：NONE，或精确说明端口、身份、服务或资源冲突。
回滚：NOT_APPLICABLE_READ_ONLY。
请 Reviewer 检查：是否可以进入 VLESS+REALITY side-by-side deployment。
Owner 转交：完整非敏感 checkpoint 输出。
```

## CRITICAL_CONSTRAINTS

- Foreground Codex / image-generation work must not be disrupted.
- WireGuard remains the current production/rollback path until a later accepted Gate changes that role.
- HY2 is now the validated UDP/QUIC performance candidate; VLESS+REALITY is the frozen TCP/443 fallback candidate under G2-C; neither is yet the sealed production default.
- Current WireGuard routing intentionally uses two `/1` defaults; this removes the strict WireGuard Windows WFP kill-switch. Treat this as an explicit current security/runtime property.
- Secret values never leave the protected execution boundary.
- No BBR/fq/GRO/MTU or other live tuning is authorized merely because the protocol comparison passed.
- Accepted completed Gates are not replayed without proven material drift.

## DEFAULT_EXECUTION_CHANNEL

For future consequential Windows validation: Owner-run elevated PowerShell 7.6.6 on the real Windows host, with one bounded Reviewer-designed checkpoint and fail-closed cleanup/read-back.

## CURRENT_ROLLBACK_STATUS

```text
PRODUCTION_WIREGUARD=RESTORED
WG_IPV4_DEFAULTS=0.0.0.0/1,128.0.0.0/1
WG_STRICT_WFP_KILLSWITCH=ABSENT
HY2_SERVER=ACTIVE
HY2_PERSISTENT_CLIENT_DEFAULT=NOT_ENABLED
TEMPORARY_VPS_ROUTE=ABSENT
MIHOMO_TEST_PROCESS=ABSENT
RUNTIME_SECRET_CONFIG=ABSENT
PLAINTEXT_SECRET_RESIDUE=0
```

Rollback/recovery assets:
- WireGuard remains directly usable as the current path.
- HY2 server deployment and DPAPI recovery artifact remain available.
- G2-B temporary test artifacts were removed.

## UNRESOLVED

- VLESS+REALITY side-by-side viability: TCP/443 ownership, server-core choice, handshake, and client compatibility remain unvalidated on this VPS.
- Peak-hour repeatability: whether HY2 retains its same-window advantage during the user's known evening congestion window.
- Real workload behavior: Codex / OpenAI / image-generation long-task A/B is still untested.
- Final production role: HY2 primary vs on-demand backup vs WireGuard primary remains undecided.
- Final WireGuard security policy: whether the split-default/no-strict-kill-switch state is accepted for v1 or replaced by a different final routing design.
- Optional Linux tuning candidates (BBR/fq/GRO/MTU) remain untested and are not required unless later evidence justifies them.
- MVP v1 seal remains pending G2-C VLESS+REALITY integration, G2-D peak-hour/real-workload validation, and final architecture decision.

## NEXT_STEP

Preflight passed. Reviewer now freezes the exact side-by-side deployment design and prepares one consequential Owner checkpoint. No server/client mutation occurs until Owner explicitly authorizes that checkpoint.

## OWNER_ACTION_REQUIRED

Explicitly authorize or decline the prepared G2-C side-by-side deployment checkpoint after Reviewer presents the exact design, rollback, and Secret boundary.

## REVIEWER_TO_EXECUTOR_RELAY

```text
NO_ACTIVE_EXECUTOR_GATE
```

## EXECUTOR_TO_REVIEWER_RELAY

```text
NONE
```

## EVIDENCE_POINTERS

- `EXECUTION_EVIDENCE.md` — append-only execution proof through the successful 60+60 same-window comparison.
- `DECISION_LOG.md` — durable decision rationale for the kill-switch routing change and current production/candidate roles.
- `EXECUTOR_HANDOFF.md` — historical Executor factual notes; not canonical current project truth.
- `scripts/g2b-owner-runner.ps1` — accepted G2-B benchmark/runtime logic.
- `scripts/g2b-comparative-after-killswitch-repair.ps1` — successful final G2-B comparative checkpoint.
- Evidence commit `b85224370a295cc5128e29da9186573b81345d27` — same-window WG vs HY2 results and cleanup proof.
- Reviewer acceptance commit `cfb2d723657a5607c5d8c756705dc873c06babe5` — first formal acceptance of the completed G2-B evidence.

Historical Reviewer narrative remains available in Git history and is intentionally not duplicated in this dashboard.
