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
- The latest handshake-only probe proved `proxy_used=1` and failed with curl exit 35 / `TLS_ERROR`, HTTP `000`, `appconnect=0`; no target HTTPS TLS session was established.
- Cleanup passed: Mihomo stopped, runtime Secret config deleted, plaintext Secret artifacts 0, temporary route removed, production WireGuard restored, final test residue absent.
- Fresh server-side read-only diagnostics then proved Hysteria service active+enabled, ExecMainStatus 0, NRestarts 0, one Hysteria UDP 8443 listener, intact strict-SNI/password-auth config shape, matching certificate fingerprint/SAN, and no host UFW/nft/iptables rule explicitly blocking UDP 8443.
- The UDP-arrival probe then proved `UDP_8443_INBOUND_SEEN=NO` and `OUTBOUND_SEEN=NO` while the local proxy attempted the HY2 connection. Therefore the failure occurs before Hysteria receives the packet.
- Because WireGuard UDP/51820 to the same VPS is already the working production path, generic local UDP/WLAN failure is less likely than a port-specific filter. DigitalOcean Cloud Firewall is now the highest-priority unverified boundary because it is external to UFW/nft/iptables and was not covered by the prior host-firewall checks.
- No HY2 benchmark sample or protocol-performance conclusion exists yet.

Accepted source:
- Repaired runner commit: `ed4f8216ecd18dcea29f06f12fa0773c97c3cdf4`
- Repaired runner blob: `5a6e65edd3d9e7c62b61fe209954f4d19c493366`
- Reviewer acceptance commit: `165fc79b906dd6de858fdb6c3521e95f7b749136`

## CURRENT_GATE

```text
GATE_ID=G2B_DigitalOcean_Cloud_Firewall_ReadOnly_Check
STATE=OWNER_READ_ONLY_ACTION_PENDING
OBJECTIVE=Determine whether a DigitalOcean Cloud Firewall is attached to the target Droplet and whether inbound UDP/8443 is permitted.
MAX_ENDPOINT_THIS_ROUND=Read-only provider control-plane inspection only; no firewall change, no new handshake, no benchmark.
MANDATORY_REVIEW_STOP=YES
```

### TARGET_AND_SCOPE

Allowed:
- inspect DigitalOcean Networking → Firewalls and the target Droplet's applied firewall rules;
- record only non-Secret metadata: firewall attached YES/NO, inbound UDP/8443 allow YES/NO, UDP/51820 allow YES/NO, relevant source scope;
- alternatively use an already-authenticated `doctl`/DigitalOcean API read-only listing if such authentication is already safely available.

Forbidden:
- no new DigitalOcean token creation or Secret disclosure;
- no firewall rule modification yet;
- no new HY2 handshake;
- no benchmark;
- no VPS/client config change.

### APPLICABLE_CRITICAL_CONSTRAINTS

- The previous UDP-arrival + handshake authorization is consumed.
- Production WireGuard remains ON and restored.
- DigitalOcean Cloud Firewall is distinct from UFW/nft/iptables and can block traffic before it reaches the Droplet.
- Provider control-plane state must be fresh-read before any firewall change is proposed.

### REQUIRED_EVIDENCE

- `DO_CLOUD_FIREWALL_ATTACHED=YES/NO`;
- `DO_UDP_8443_INBOUND_ALLOWED=YES/NO/NOT_APPLICABLE`;
- `DO_UDP_51820_INBOUND_ALLOWED=YES/NO/NOT_APPLICABLE`;
- source scope for any relevant rules;
- no provider mutation.

### ACCEPTANCE_CRITERIA

Diagnostic classification:
- firewall attached + UDP/8443 not allowed → root cause candidate proven at provider firewall boundary; next Gate may propose the smallest inbound UDP/8443 allow rule;
- firewall absent or UDP/8443 already allowed → DigitalOcean Cloud Firewall is cleared and next diagnosis moves to port-specific upstream/local egress behavior.

### ROLLBACK_STATUS_OR_PLAN

Read-only Gate; no rollback required.

### OWNER_ONLY_ACTIONS

Perform one read-only DigitalOcean firewall inspection. No consequential authorization is required because no provider setting is changed.

### REVIEWER_TO_EXECUTOR_RELAY

Read only this Current Gate and current provider-firewall evidence. Do not load historical benchmark evidence or rerun network tests.

### EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
Cloud Firewall：attached YES/NO
UDP8443：allowed YES/NO/NA
UDP51820：allowed YES/NO/NA
来源范围：一句话
变更：NONE
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

Fresh-read the DigitalOcean Cloud Firewall attached to the target Droplet. This is the highest-priority unverified boundary because the UDP/8443 probe never reached `eth0` while the Droplet-local firewall and Hysteria listener are healthy.

## OWNER_ACTION_REQUIRED

**Check the target Droplet's DigitalOcean Cloud Firewall rules read-only.** Keep WireGuard connected; do not change any rule yet.

## EVIDENCE_POINTERS

- `EXECUTION_EVIDENCE.md` — append-only execution proof.
- `EXECUTOR_HANDOFF.md` — Executor factual completion notes only; not canonical project truth.
- `scripts/g2b-owner-runner.ps1` — current repaired runner.
- Commit `9b730b81e751099fae7c4c3c61e8a5a5a755877d` — HY2 handshake validator return recorded.
- Commit `ed4f8216ecd18dcea29f06f12fa0773c97c3cdf4` — proxy-use validator repair.
- Commit `3c381726f38950579bceb0f258ba46cc83c68328` — diagnostic/repair evidence record.
- Commit `165fc79b906dd6de858fdb6c3521e95f7b749136` — proxy-use repair acceptance.
- Commit `e9cb20b9acfc3ffae30b27fe7d1cfd5b46181478` — latest Owner G2-B return persisted to Evidence.
- Commit `e683604b5c8e1e4a49af472d2b3e21cfeba6383b` — handshake/auth diagnostic Gate.
- Commit `dea461dcd25dd2497204f49c700cd05609634f04` — healthy HY2 server read-only state persisted.

Historical Reviewer narrative before this compact-dashboard takeover remains available in Git history. It is intentionally not duplicated here.
