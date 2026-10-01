# VPN Network Optimization — EXECUTOR HANDOFF

> Executor-owned execution facts only. Reviewer truth remains `REVIEWER_HANDOFF.md`.

## Status

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


