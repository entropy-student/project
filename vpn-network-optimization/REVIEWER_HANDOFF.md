# VPN Network Optimization — REVIEWER HANDOFF

> Maintainer: Reviewer only  
> Governance: `entropy-student/spike.skill/vps-project-governance` v0.2.6 / ACTIVE_PROVISIONAL  
> Canonical project state: this file. Detailed execution history/proof remains in `EXECUTION_EVIDENCE.md` and Git history.

## PROJECT_GOAL

建立一套可迁移、可验证、可回滚的自建 VPN 优化标准，重点改善 Codex / OpenAI / AI 生图等长任务的稳定性和尾部表现；当前 MVP 以 WireGuard 为生产基线，验证 Hysteria2 是否值得作为备用/增强通道。

## PROJECT_STAGE

```text
P0 Research / Scope                    PASS
G1 Foreground-safe Foundation          PASS
G2-A HY2 side-by-side deployment       PASS
G2-A DPAPI recovery closure            PASS
G2-B Safe-window WG vs HY2 validation  RETURN->DIAGNOSTIC
MVP v1 seal                            PENDING
```

## SYSTEM_MAP

```text
Windows Owner host
├─ Production: WireGuard adapter SFO2-A
│  └─ DigitalOcean sfo3 VPS 24.199.118.137
│     └─ Internet / OpenAI
├─ G2-B candidate path:
│  └─ localhost Mihomo test proxy :17890
│     └─ temporary ActiveStore /32 route via WLAN
│        └─ Hysteria2 UDP 8443 on same VPS
└─ Control path:
   └─ SSH through WireGuard to 10.66.21.1:22
```

Current known components:
- VPS: DigitalOcean `sfo3`, public IP `24.199.118.137`.
- Production VPN: WireGuard, active MTU 1420.
- Hysteria2: official v2.12.3, independent service on UDP 8443.
- Windows client: Clash Verge 2.5.6; Mihomo v1.19.31 / alpha-f103639 available.
- Owner execution runtime: PowerShell 7.6.6, Administrator, High integrity.
- Recovery: canonical DPAPI CurrentUser recovery artifact validated; do not re-fetch or rotate VPS Secrets.

## CURRENT_ACCEPTED_STATE

Latest accepted G2-B facts:
- Latest authorized retry completed WireGuard benchmark **60/60 with 0 failures**.
- Latest WG sample: Median 0.604015s, P90 0.764660s, P95 0.797894s, P99 1.333582s, >1s 1, >1.5s 0, >2s 0.
- Runtime Secret config creation and owner-only ACL validation passed.
- Mihomo test proxy reached READY.
- The latest run passed the repaired `proxy_used=1` proxy-path assertion, then returned on the next assertion with `HY2_HANDSHAKE_OR_AUTH_FAILED` before HY2 sample 1.
- Therefore the request reached the local proxy path, but the proxied curl sample did not satisfy `curl exit == 0 && HTTP status == 401`.
- The retained console output did not include that sample's exact curl exit code, HTTP status, or classified error; root cause is still UNKNOWN.
- Cleanup passed: Mihomo stopped, runtime Secret config deleted, plaintext Secret artifacts 0, temporary route removed, production WireGuard restored, final test residue absent.
- No HY2 benchmark sample or protocol-performance conclusion exists yet.

Accepted source:
- Repaired runner commit: `ed4f8216ecd18dcea29f06f12fa0773c97c3cdf4`
- Repaired runner blob: `5a6e65edd3d9e7c62b61fe209954f4d19c493366`
- Reviewer acceptance commit: `165fc79b906dd6de858fdb6c3521e95f7b749136`

## CURRENT_GATE

```text
GATE_ID=G2B_HY2_Server_ReadOnly_State_Diagnostic
STATE=OWNER_READ_ONLY_ACTION_PENDING
OBJECTIVE=Fresh-read the Hysteria2 server/service/listener/config-shape/firewall state without Secret output or any new HY2 handshake.
MAX_ENDPOINT_THIS_ROUND=One SSH read-only probe over the accepted WireGuard control path, persist sanitized output, then mandatory Reviewer stop.
MANDATORY_REVIEW_STOP=YES
```

### TARGET_AND_SCOPE

Allowed:
- Owner PowerShell 7.6.6 invokes one SSH read-only probe to `10.66.21.1:22` over WireGuard;
- verify target hostname, Hysteria service active/enabled state, process restart count, UDP 8443 listener, binary version;
- inspect only non-Secret config shape: listen port, TLS cert/key path presence, `sniGuard`, auth type, and boolean auth-format validity;
- inspect host firewall/service state without modifying it.

Forbidden:
- no new HY2 handshake;
- no Mihomo start;
- no DPAPI Secret read;
- no temporary route;
- no benchmark;
- no service restart/reload;
- no firewall change;
- no raw config, password, Secret hash, certificate private key, or raw logs.

### APPLICABLE_CRITICAL_CONSTRAINTS

- The handshake-probe authorization is consumed.
- Production WireGuard is restored and remains the control path.
- SSH host-key trust is reused strictly; no auto-accept.
- Sanitized read-only output only.
- Any target/host-key mismatch returns immediately.

### REQUIRED_EVIDENCE

- target hostname;
- Hysteria service active/enabled;
- ExecMainStatus and restart count;
- UDP 8443 listener count;
- Hysteria binary version;
- config listen/SNI-guard/auth-type shape;
- boolean auth-format-valid;
- non-Secret firewall summary relevant to UDP 8443;
- SSH native exit code.

### ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires:
- accepted target reached through strict SSH trust;
- service active and UDP 8443 listening;
- config shape matches accepted G2-A design;
- no host-firewall evidence of UDP 8443 being blocked;
- no mutation and no Secret output.

If this passes, the next fault domain is client-to-server UDP/HY2 initialization or Mihomo-specific behavior. If it fails, repair only the proven server/runtime drift.

### ROLLBACK_STATUS_OR_PLAN

Read-only Gate; rollback not applicable. Any attempted write is a Gate violation and must stop.

### OWNER_ONLY_ACTIONS

Run the prepared read-only server diagnostic from PowerShell 7.6.6. No new consequential authorization is required because this Gate performs no write, Secret read, or handshake.

### REVIEWER_TO_EXECUTOR_RELAY

Prepared read-only diagnostic:
- `scripts/g2b-hy2-server-readonly.ps1`
- commit: `7d86841d6f3406af0d99e5730bb369e8d693d162`
- blob: `e7e406a88d6438703d1b9469ec6347087d480817`
- strict SSH to `10.66.21.1:22` through existing WireGuard;
- outputs only sanitized service/listener/config-shape/firewall fields;
- no Secret read/output, no service restart, no handshake, no mutation.

Read only this Current Gate and the prepared read-only diagnostic script. Do not load historical benchmark Evidence or Governance.

### EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
服务器：service / UDP8443 / version
配置：listen / sniGuard / auth-shape
防火墙：一句话
验证：SSH exit + no mutation/no Secret
Owner 转交：NONE
```

## CRITICAL_CONSTRAINTS

- Foreground Codex / image-generation work must not be disrupted.
- WireGuard remains production baseline until Reviewer accepts G2-B evidence.
- Hysteria2 is a candidate, not a predetermined winner.
- Secret values never leave the protected execution boundary.
- No live tuning before the protocol A/B is completed and reviewed.
- Accepted completed Gates are not replayed without proven material drift.

## DEFAULT_EXECUTION_CHANNEL

Owner-run elevated PowerShell 7.6.6 on the real Windows host for the consequential G2-B checkpoint. Reviewer/Executor prepare, inspect, persist non-secret Evidence, and review; Owner is not responsible for debugging/design.

## CURRENT_ROLLBACK_STATUS

```text
PRODUCTION_WIREGUARD=RESTORED
TEMPORARY_VPS_ROUTE=ABSENT
MIHOMO_TEST_PROCESS=ABSENT
TCP_17890_ROWS=0
UDP_17890_ROWS=0
RUNTIME_SECRET_CONFIG=ABSENT
PLAINTEXT_SECRET_RESIDUE=0
```

These are the latest accepted read-backs from the completed diagnostic/cleanup chain. A fresh runtime preflight is required before the next consequential retry.

## UNRESOLVED

- HY2 local proxy usage after the validator repair is proven (`proxy_used=1`); HY2 handshake/auth success is not proven.
- HY2 formal G2-B sample count is 0.
- WireGuard vs Hysteria2 performance/reliability conclusion remains UNKNOWN.
- MVP v1 protocol/config seal remains pending G2-B completion.

## NEXT_STEP

Run the prepared read-only server-state diagnostic. Use it to separate server/runtime drift from client/UDP-path or Mihomo-specific failure before any new handshake.

## OWNER_ACTION_REQUIRED

**Run the prepared read-only server-state diagnostic from PowerShell 7.6.6.** No new HY2 handshake, benchmark, Secret read, or network mutation is authorized.

## EVIDENCE_POINTERS

- `EXECUTION_EVIDENCE.md` — append-only execution proof.
- `EXECUTOR_HANDOFF.md` — Executor factual completion notes only; not canonical project truth.
- `scripts/g2b-owner-runner.ps1` — current repaired runner.
- Commit `9b730b81e751099fae7c4c3c61e8a5a5a755877d` — HY2 handshake validator return recorded.
- Commit `ed4f8216ecd18dcea29f06f12fa0773c97c3cdf4` — proxy-use validator repair.
- Commit `3c381726f38950579bceb0f258ba46cc83c68328` — diagnostic/repair evidence record.
- Commit `165fc79b906dd6de858fdb6c3521e95f7b749136` — proxy-use repair acceptance.
- Commit `e9cb20b9acfc3ffae30b27fe7d1cfd5b46181478` — latest Owner G2-B return persisted to Evidence.
- Commit `e683604b5c8e1e4a49af472d2b3e21cfeba6383b` — current diagnostic Gate narrowed to handshake/auth only.

Historical Reviewer narrative before this compact-dashboard takeover remains available in Git history. It is intentionally not duplicated here.
