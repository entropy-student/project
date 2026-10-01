# VPN Network Optimization — EXECUTOR HANDOFF

> Executor-owned execution facts only. Reviewer truth remains `REVIEWER_HANDOFF.md`.

## Current execution status — G2-A

- The latest Owner instruction states G1 has Reviewer PASS. G1 was not rerun; its evidence below is preserved as historical execution evidence.
- Current Gate: `G2-A — Side-by-side Hysteria2 Deployment`.
- G2-A stopped before any VPS write at the Secret authorization and Cloud Firewall read-back checkpoints.
- No VPS, WireGuard, Windows route, Clash profile, proxy, TUN, or live tuning change was made.
- `REVIEWER_HANDOFF.md` was not modified. G2-B was not entered.

## G1 historical executor status (preserved)

`RETURN_PREFLIGHT_DRIFT` — G1 read-only preflight and project-local foundation completed; stopped before any VPS write or live client change.

`STOP_AT_REVIEWER: YES`

## Gate boundary

- Gate: `G1 — Foreground-safe Foundation`
- Foreground interruption: `NO`
- VPS write: `NO`
- Windows/VPN write: `NO`
- Current traffic switched: `NO`
- Live fq/BBR/sysctl/MTU/GRO tuning applied: `NO`

## Fresh target-host facts

- SSH read-only probe reached `24.199.118.137` with strict host-key checking and the existing local identity reference; host-key mismatch was not observed.
- No `SHARED_VPS_HANDOFF.md` was present in the workspace; the probe used the explicit user-provided historical endpoint and existing local key/known-host metadata only. This is not treated as authorization for a remote write.
- Fresh hostname: `ubuntu-s-1vcpu-512mb-10gb-sfo3`.
- Fresh DigitalOcean metadata: region `sfo3`, droplet id recorded in evidence only.
- Fresh OS/kernel: Ubuntu 24.04.5 LTS, kernel 6.8.0-142-generic, x86_64.
- Fresh WAN: `eth0`; public IPv4 `24.199.118.137`; default route via `24.199.112.1`.
- Material drift: Reviewer labels the VPS `SFO2-A`; target-host read-back reports `sfo3`. This is recorded as unresolved identity/location drift and must be reconciled by Reviewer before any remote write.
- Full read-only preflight transport returned exit code 1 only because the optional `hysteria*` systemd-unit listing was empty; identity and all required inspection sections were collected. No remote write occurred.

## Current WireGuard facts

- Server `wg0` is up, listening on UDP 51820, address `10.66.21.1/24`, service enabled/active.
- Server read-back showed a live peer handshake and transfer counters; no private key was read or emitted.
- Server MTU read-back: 1420. Client active adapter read-back: connected `SFO2-A`, active MTU 1420; a separate 1280 metadata entry was present. No MTU was changed.
- Forwarding/NAT read-back: IPv4 forwarding enabled; nftables/iptables FORWARD and eth0 masquerade present; UFW inactive.
- UDP 8443 had no listener at probe time; UDP 51820 was occupied by WireGuard.

## Linux candidate facts

- `eth0` qdisc: `fq_codel`; `wg0`: `noqueue`.
- TCP congestion control: `cubic`; available/allowed: `reno cubic`.
- TCP BBR kernel module exists, but it is not active in the read-back.
- `rx-gro-list=off` and `rx-udp-gro-forwarding=off`; generic receive offload is on. No offload/sysctl change was made.
- No Hysteria2 systemd unit was present.

## Windows client facts

- Target runtime was proven as the Owner Windows host for this read-only check: Windows 11 build 26200, PowerShell 7.6.5.
- Clash Verge 2.5.6 is installed under `C:\Program Files\Clash Verge`; Mihomo binaries are present. Current active core version was not independently proven.
- No Clash/Mihomo TUN adapter was observed. WinHTTP is direct and `ProxyEnable=0`; a configured proxy endpoint value remains inactive and was not changed.
- WireGuard Manager and `WireGuardTunnel$SFO2-A` are running; adapter `SFO2-A` is Up and default route metric 0 remains present.
- `wg.exe show all` was attempted read-only but returned permission denied; adapter/service/route evidence still proves the tunnel is active. No privilege escalation or client change was attempted.

## Local project artifacts

- Portable parameter file: `config/variables.env.example`
- WireGuard templates: `templates/wireguard/`
- HY2 server template: `templates/hysteria2/server.yaml.template`
- Mihomo fragment: `templates/clash/mihomo-hy2.yaml.template`
- Optional systemd unit template: `templates/systemd/hysteria2.service.template`
- Read-only preflight: `scripts/preflight-linux.sh`, `scripts/preflight-windows.ps1`
- Non-invasive health check: `scripts/health-check.sh`
- Dry-run rollback/uninstall: `scripts/rollback-uninstall.sh`
- Plan-first migration/reinstall helper: `scripts/migration-reinstall.sh`
- Secrets excluded by `.gitignore`; no Secret value was generated, read, or recorded.

## HY2 status

`HY2_READY=BLOCKED_WITH_EXACT_REASON`

Blocked because the current Gate has no authorized HY2 auth Secret or TLS private key, no DNS/SNI certificate checkpoint, and the VPS identity/location drift (`SFO2-A` vs fresh `sfo3`) is unresolved. UDP 8443 is free at the read-only probe, but that alone is not end-to-end readiness.

## Reviewer handoff

Please reconcile the fresh `sfo3` identity/location against the historical `SFO2-A` label before authorizing any remote write. If accepted, the next bounded Gate may separately authorize Secret/DNS/cloud-firewall checkpoints and a safe-window HY2 installation; G1 did not enter that Gate.

## Exact return

`RETURN_PREFLIGHT_DRIFT`

## G2-A actual execution facts

- Fresh SSH read-back used strict host-key checking against `24.199.118.137`; public IP, hostname, OS, kernel, WAN route, wg0, UDP listeners, forwarding, local firewall/NAT metadata, and resource usage were inspected read-only.
- Identity matches the current Owner-accepted baseline: `24.199.118.137`, hostname `ubuntu-s-1vcpu-512mb-10gb-sfo3`; `sfo3` is accepted and `SFO2-A` is a legacy label. The target's DigitalOcean metadata endpoint and cloud-init region query did not return a region value.
- wg0 remained active/enabled at MTU 1420 and UDP 51820 remained bound. UDP 8443 had no listener. No remote write, package install, systemd unit creation, service start, route/NAT/firewall change, or sysctl/qdisc/GRO/MTU tuning occurred.
- Fresh HY2-specific read-back found no Hysteria executable, no project HY2 binary/config, no HY2 unit, and none of the declared auth/certificate/key paths on the target.
- DigitalOcean Cloud Firewall could not be read through an authorized local interface: `doctl` is unavailable and no DigitalOcean API token is present. No firewall rule was changed.
- Clash Verge 2.5.6 is installed. Installed cores report Mihomo Meta `v1.19.31` and `alpha-f103639`; no Mihomo core process was running at read-back. The Clash Verge service and Windows WireGuard tunnel were running; no Clash/Mihomo TUN adapter was observed, system proxy is disabled, and WinHTTP is direct.
- Both YAML templates passed the installed Mihomo `-t` parser using both installed cores. The client template's fingerprint field was accepted. Its all-zero fingerprint is a deliberately non-matching parse sentinel, not a certificate fingerprint or handshake result. No Hysteria binary was installed, so Hysteria-specific config validation was not run.
- The Mihomo fragment now uses `SFO3-A-HY2`, the local SNI `hy2.sfo3-a.invalid`, `skip-cert-verify: true` plus certificate fingerprint pinning, and no public DNS dependency. It is a template only; the sentinel, server placeholder, and auth placeholder must be replaced before use.
- Rollback now names only the project HY2 unit, config, and binary; its default preserves data/Secrets and does not touch WireGuard, routes, NAT, or firewall. Bash syntax and the dry-run both passed. A systemd-native unit validator was unavailable on this Windows host.
- No HY2 auth Secret, TLS private key, or self-signed certificate was generated. No value was emitted, logged, or committed. Client runtime configuration and HY2 service are not ready until Owner checkpoints are resolved.

## G2-A current checkpoint

`HY2_READY=BLOCKED_WITH_EXACT_REASON`

- Owner must explicitly authorize the exact Secret paths/modes and generation behavior before auth/certificate material can be created.
- Owner must inspect the DigitalOcean Cloud Firewall for this droplet and, only if absent, allow inbound UDP 8443 for this droplet only. No other rule or port is in scope.
- After those checkpoints, validate the rendered Hysteria config and systemd unit before starting only the independent HY2 service; then verify WG and Windows routes remain unchanged.


