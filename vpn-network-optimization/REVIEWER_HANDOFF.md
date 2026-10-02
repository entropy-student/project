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
- The DigitalOcean Droplet networking page was fresh-read by Owner and shows no Cloud Firewall assigned. Therefore provider Cloud Firewall is cleared as the cause.
- The remaining primary boundary is Windows/Mihomo egress versus local WLAN/router/ISP/upstream path before the Droplet.
- No HY2 benchmark sample or protocol-performance conclusion exists yet.

Accepted source:
- Repaired runner commit: `ed4f8216ecd18dcea29f06f12fa0773c97c3cdf4`
- Repaired runner blob: `5a6e65edd3d9e7c62b61fe209954f4d19c493366`
- Reviewer acceptance commit: `165fc79b906dd6de858fdb6c3521e95f7b749136`

## CURRENT_GATE

```text
GATE_ID=G2B_Windows_UDP8443_Egress_Probe
STATE=AUTHORIZED_UNTIL_GATE_RESOLVED
OBJECTIVE=Determine whether the failure is port-specific by comparing one raw UDP datagram to known-working WireGuard port 51820 with one raw UDP datagram to HY2 port 8443 over the same exact WLAN route.
MAX_ENDPOINT_THIS_ROUND=One local packet-presence observer + one existing handshake-only probe + exact cleanup/read-back, then mandatory Reviewer stop.
MANDATORY_REVIEW_STOP=YES
```

### TARGET_AND_SCOPE

Current next diagnostic under the standing authorization:
- keep production WireGuard ON;
- create the same exact temporary `24.199.118.137/32` WLAN route;
- start one VPS-side read-only packet-presence observer for UDP/51820 and UDP/8443 on eth0;
- send exactly one small raw UDP datagram to 51820 and exactly one to 8443 from Windows;
- do not start Mihomo and do not read DPAPI Secret;
- record only whether each port's packet arrived;
- remove the exact temporary route and verify WireGuard remains restored.

Forbidden:
- no payload inspection;
- no persistent packet capture beyond the minimum temporary diagnostic artifact;
- no benchmark;
- no second handshake;
- no configuration/tuning changes;
- no service/firewall/provider changes.

### REQUIRED_EVIDENCE

- local UDP observer ready;
- `WINDOWS_UDP_8443_OUTBOUND_SEEN=YES/NO`;
- one handshake only;
- `proxy_used / curl exit / HTTP status / error`;
- no benchmark;
- observer stopped;
- temporary route removed;
- Mihomo/runtime config removed;
- production WireGuard restored;
- Secret values emitted/committed = 0.

### ACCEPTANCE_CRITERIA

Diagnostic classification:
- 51820 YES + 8443 NO → port-specific filtering/path policy is proven outside Hysteria/Mihomo;
- 51820 YES + 8443 YES → generic raw UDP path works; prior 8443 miss was transient/observer-specific and HY2 client behavior must be revisited;
- 51820 NO + 8443 NO → the raw-control route/Windows egress method itself is not reaching the VPS, so inspect local routing/source-interface behavior before blaming upstream filtering.

This Gate does not itself PASS G2-B.

### ROLLBACK_STATUS_OR_PLAN

Current baseline is clean and restored. Diagnostic cleanup is mandatory.

### OWNER_ONLY_ACTIONS

**Owner standing authorization: GRANTED for this Gate until the current UDP/8443 egress fault is resolved.**

This standing authorization covers repeated bounded diagnostics and the smallest reversible repairs that stay inside `G2B_Windows_UDP8443_Egress_Probe`, including one-at-a-time HY2 handshake reproductions when diagnostically necessary.

It does **not** authorize:
- scope expansion into a different Gate/protocol/architecture;
- destructive or materially irreversible changes;
- purchases/provider billing changes;
- Secret disclosure/rotation unless separately required by a new Gate;
- disabling the production WireGuard control path;
- broad firewall/security weakening.

Reviewer should not ask Owner for repeated authorization for ordinary bounded troubleshooting inside this Gate.

### REVIEWER_TO_EXECUTOR_RELAY

Current prepared comparison checkpoint:
- `scripts/g2b-raw-udp-port-compare.ps1`
- commit: `128a105a4da2fd2893238dc2e317b703a2427385`
- blob: `186c3ab088a800254bfbce731bddfdc23650827d`
- keeps production WireGuard ON;
- creates the exact temporary `24.199.118.137/32` WLAN route;
- binds each synthetic UDP socket explicitly to WLAN address `192.168.1.4`;
- sends exactly one 7-byte UDP datagram to 51820 and one 7-byte UDP datagram to 8443;
- VPS observes only UDP header length 15 on the corresponding destination port, which distinguishes the synthetic 51820 probe from normal WireGuard traffic without inspecting payload;
- does not start Mihomo, read DPAPI Secret, or run any benchmark;
- removes the exact temporary route and rechecks production WireGuard.

Standing Owner authorization remains valid for further bounded troubleshooting inside this Gate.

Executor should read only this Current Gate and the prepared comparison checkpoint. Do not alter configuration or replay benchmarks.

### EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
Windows UDP8443：outbound YES/NO
握手：proxy_used / curl exit / HTTP status / error
验证：one handshake / no benchmark / observer stopped
回滚：route / Mihomo / runtime / WireGuard
Owner 转交：NONE / 最小必要动作
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

The raw UDP/8443 control also failed to reach VPS eth0. Compare raw UDP/51820 vs UDP/8443 over the same route to distinguish port-specific filtering from a broader local routing/egress issue.

## OWNER_ACTION_REQUIRED

**No further authorization needed for bounded troubleshooting inside this Gate.** Keep WireGuard connected and run the prepared raw UDP 51820-vs-8443 comparison checkpoint.

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
