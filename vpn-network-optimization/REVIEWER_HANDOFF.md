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
- The remaining primary fault domain is client-to-server HY2/UDP initialization or a provider/network-path issue outside the VPS host firewall.
- No HY2 benchmark sample or protocol-performance conclusion exists yet.

Accepted source:
- Repaired runner commit: `ed4f8216ecd18dcea29f06f12fa0773c97c3cdf4`
- Repaired runner blob: `5a6e65edd3d9e7c62b61fe209954f4d19c493366`
- Reviewer acceptance commit: `165fc79b906dd6de858fdb6c3521e95f7b749136`

## CURRENT_GATE

```text
GATE_ID=G2B_HY2_UDP_Arrival_Probe
STATE=AUTHORIZED_UDP_ARRIVAL_PROBE_PENDING
OBJECTIVE=Determine whether one HY2 handshake sends UDP/8443 packets to the VPS and whether the VPS emits UDP/8443 response traffic.
MAX_ENDPOINT_THIS_ROUND=One server-side read-only packet-presence observer + one existing handshake-only client probe + exact cleanup/read-back, then mandatory Reviewer stop.
MANDATORY_REVIEW_STOP=YES
```

### TARGET_AND_SCOPE

After fresh Owner authorization, allow exactly:
- keep production WireGuard **ON**; it remains the ChatGPT/SSH control path;
- strict SSH to `10.66.21.1:22` using the accepted `HostKeyAlias=24.199.118.137`;
- start temporary read-only packet-presence observers on VPS `eth0` for UDP destination/source port 8443; no payload dump and no persistent pcap;
- locally create the same exact temporary `24.199.118.137/32` WLAN route;
- read the protected DPAPI Secret only inside the existing handshake-only runtime boundary;
- start one temporary Mihomo instance;
- send exactly one HY2 handshake request;
- retain only non-Secret packet-presence/count result plus existing handshake diagnostic fields;
- mandatory cleanup and WireGuard restoration/read-back.

Forbidden:
- no 60-sample benchmark;
- no second handshake;
- no packet payload/hex dump or persistent capture file;
- no service restart/reload;
- no firewall/cloud-firewall change;
- no HY2/server/client configuration change;
- no Secret value/hash/log output;
- no MTU/BBR/fq/GRO/sysctl tuning.

### APPLICABLE_CRITICAL_CONSTRAINTS

- Previous handshake authorization is consumed.
- Production WireGuard must remain ON throughout.
- The public VPS /32 data route is temporary and applies only to the HY2 data plane.
- Server observer is read-only and temporary.
- Client handshake authorization is consumed only if the actual one-shot handshake runner is invoked.
- Any preflight failure before the handshake does not authorize improvisation or a second attempt.

### REQUIRED_EVIDENCE

- server observer ready before client handshake;
- `UDP_8443_INBOUND_SEEN=YES/NO`;
- `UDP_8443_OUTBOUND_SEEN=YES/NO`;
- one handshake only;
- `proxy_used / curl exit / HTTP status / error`;
- no benchmark;
- observer terminated;
- temporary route removed;
- Mihomo/runtime config removed;
- production WireGuard restored;
- Secret values emitted/committed = 0.

### ACCEPTANCE_CRITERIA

Diagnostic classification:
- inbound **NO** → packet does not reach VPS: client/WLAN/provider/cloud-firewall path becomes primary fault domain;
- inbound **YES**, outbound **NO** → VPS/Hysteria receive-side/runtime becomes primary fault domain;
- inbound **YES**, outbound **YES** → bidirectional UDP reaches the host; client/Mihomo/HY2 TLS/auth handling becomes primary fault domain.

This Gate does not itself PASS G2-B.

### ROLLBACK_STATUS_OR_PLAN

Current baseline is clean. After the one probe:
- terminate server observers;
- stop Mihomo;
- delete runtime Secret config;
- remove exact temporary route;
- verify production WireGuard remains active and public exit restored.

### OWNER_ONLY_ACTIONS

**Authorization status: GRANTED** for exactly one UDP-arrival + HY2-handshake probe. Keep WireGuard VPN on. Authorization is consumed only when the one-shot handshake runner is actually invoked.

### REVIEWER_TO_EXECUTOR_RELAY

Prepared one-shot checkpoint:
- `scripts/g2b-hy2-udp-arrival-checkpoint.ps1`
- commit: `3c28e2990fd9964a7f7ade5ef12a9970a1edc299`
- blob: `2c8e498939a76c0baf9e4dd56b31e56103ccb73f`
- keeps WireGuard on;
- creates the exact temporary VPS /32 WLAN route;
- starts strict-SSH UDP/8443 packet-presence observers with no payload output or pcap file;
- invokes accepted `g2b-owner-runner.ps1 -HandshakeOnly` exactly once;
- then stops the observer and performs the existing route/Mihomo/runtime/WireGuard cleanup/read-back.
- if the observer is not ready, the handshake runner is not invoked and authorization is not consumed.

Executor should read only this Current Gate and the prepared checkpoint. Do not reread full Governance or historical benchmark evidence. Do not alter configuration.

### EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
UDP：inbound YES/NO；outbound YES/NO
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

After fresh Owner authorization, run one UDP-arrival + handshake probe. Keep WireGuard on. Use packet presence to determine whether the failure is before the VPS, on the VPS receive path, or after bidirectional UDP is established.

## OWNER_ACTION_REQUIRED

**Run the prepared one-shot UDP-arrival + HY2 handshake checkpoint when presented.** Keep the current WireGuard VPN connected.

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
