# VPN Network Optimization — EXECUTOR HANDOFF

> Executor-owned execution facts only. Reviewer truth remains `REVIEWER_HANDOFF.md`.

## Current execution status — G2C REALITY handshake diagnostic R1

- Gate: `G2C_REALITY_HANDSHAKE_DIAGNOSTIC_R1`; source base was fresh GitHub `main` commit `3b20323933f6751e6cd614e5b41946430c191432`. Executed in the Owner Windows account via PowerShell 7.6.5, Medium integrity RID `8192`, Administrator `False`; elevation was not required.
- Fresh local preflight passed: WireGuard Manager/Tunnel Running, `SFO2-A` Up/ifIndex 13, control route to `10.66.21.1` via ifIndex 13, system proxy disabled, WinHTTP direct, no Mihomo/TUN process or adapter, and accepted Mihomo Meta `v1.19.31` present.
- Strict SSH with the accepted HostKeyAlias reached root on `10.66.21.1`; target was `ubuntu-s-1vcpu-512mb-10gb-sfo3`, Ubuntu 24.04.5 LTS, kernel `6.8.0-142-generic`. WG/HY2 were active with UDP 51820/8443 listeners; TCP 14443 and TCP 443 were initially free.
- VPS→`www.microsoft.com:443` read-only check passed TCP and TLS 1.3. After the temporary server listener was ready, Windows→`10.66.21.1:14443` TCP reachability passed. Pinned sing-box v1.14.2 asset/hash and server/Mihomo config checks passed; listener was private-only, with no public 14443/443 listener.
- Protocol parameters remained unchanged: VLESS+REALITY+Vision, handshake/SNI `www.microsoft.com`, flow `xtls-rprx-vision`, VPS private listener `10.66.21.1:14443`, localhost HTTP proxy `127.0.0.1:17990`. Only diagnostic log capture/classification was added.
- Exactly one proxied request to `https://api.openai.com/v1/models`: curl exit `35`, HTTP `0`, total `5.002744s`, proxy connect `0.000765s`, TLS app-connect `0.000000s`. Sanitized classes: curl `UNKNOWN_TLS_HANDSHAKE_FAILURE`; Mihomo `TIMEOUT`; sing-box `UNKNOWN_TLS_HANDSHAKE_FAILURE`. Aggregate `REALITY_DIAGNOSTIC_CLASSIFICATION=TIMEOUT`. This narrows the observed client-core failure to a timeout class, but does not prove protocol compatibility or identify a more specific underlying defect. No retry, benchmark, or performance conclusion.
- Cleanup/fresh read-back passed: test Mihomo stopped; temporary owner-only client config removed; protected VPS runtime/workspace, sing-box process and TCP 14443 listener absent; TCP 443 still free; WG/HY2, routes, system proxy, WinHTTP, and TUN state preserved. Secret values emitted/committed: `0`.
- No public listener, firewall, route, WireGuard/HY2 service, system proxy, TUN, MTU, or kernel tuning change occurred; no persistent service was installed. Result: `PASS_CANDIDATE_DIAGNOSTIC`; stop for Reviewer. Owner action: `NONE`.
- Timing: `ROUND_STARTED_AT=2026-10-02T17:57:29Z`; `ROUND_FINISHED_AT=2026-10-02T18:21:58Z`; `ACTUAL_ELAPSED=24m29s`; `TIME_OVERRUN=NO` (estimate 15–30 minutes).

## G1 historical executor status (preserved)

`RETURN_PREFLIGHT_DRIFT` — G1 read-only preflight and project-local foundation completed; stopped before any VPS write or live client change.

`STOP_AT_REVIEWER: YES`

## Gate boundary

The following G1-era inspection sections preserve the state observed during G1; later accepted G2-A read-backs below supersede any conflicting current-state wording.

- Gate: `G1 — Foreground-safe Foundation`
- Foreground interruption: `NO`
- VPS write: `NO`
- Windows/VPN write: `NO`
- Current traffic switched: `NO`
- Live fq/BBR/sysctl/MTU/GRO tuning applied: `NO`

## G1 historical target-host facts

- SSH read-only probe reached `24.199.118.137` with strict host-key checking and the existing local identity reference; host-key mismatch was not observed.
- No `SHARED_VPS_HANDOFF.md` was present in the workspace; the probe used the explicit user-provided historical endpoint and existing local key/known-host metadata only. This is not treated as authorization for a remote write.
- Fresh hostname: `ubuntu-s-1vcpu-512mb-10gb-sfo3`.
- Fresh DigitalOcean metadata: region `sfo3`, droplet id recorded in evidence only.
- Fresh OS/kernel: Ubuntu 24.04.5 LTS, kernel 6.8.0-142-generic, x86_64.
- Fresh WAN: `eth0`; public IPv4 `24.199.118.137`; default route via `24.199.112.1`.
- Material drift: Reviewer labels the VPS `SFO2-A`; target-host read-back reports `sfo3`. This is recorded as unresolved identity/location drift and must be reconciled by Reviewer before any remote write.
- Full read-only preflight transport returned exit code 1 only because the optional `hysteria*` systemd-unit listing was empty; identity and all required inspection sections were collected. No remote write occurred.

## G1 historical WireGuard facts

- Server `wg0` is up, listening on UDP 51820, address `10.66.21.1/24`, service enabled/active.
- Server read-back showed a live peer handshake and transfer counters; no private key was read or emitted.
- Server MTU read-back: 1420. Client active adapter read-back: connected `SFO2-A`, active MTU 1420; a separate 1280 metadata entry was present. No MTU was changed.
- Forwarding/NAT read-back: IPv4 forwarding enabled; nftables/iptables FORWARD and eth0 masquerade present; UFW inactive.
- UDP 8443 had no listener at probe time; UDP 51820 was occupied by WireGuard.

## G1 historical Linux candidate facts

- `eth0` qdisc: `fq_codel`; `wg0`: `noqueue`.
- TCP congestion control: `cubic`; available/allowed: `reno cubic`.
- TCP BBR kernel module exists, but it is not active in the read-back.
- `rx-gro-list=off` and `rx-udp-gro-forwarding=off`; generic receive offload is on. No offload/sysctl change was made.
- No Hysteria2 systemd unit was present.

## G1 historical Windows client facts

- Target runtime was proven as the Owner Windows host for this read-only check: Windows 11 build 26200, PowerShell 7.6.5.
- Clash Verge 2.5.6 is installed under `C:\Program Files\Clash Verge`; Mihomo binaries are present. Current active core version was not independently proven.
- No Clash/Mihomo TUN adapter was observed. WinHTTP is direct and `ProxyEnable=0`; a configured proxy endpoint value remains inactive and was not changed.
- WireGuard Manager and `WireGuardTunnel$SFO2-A` are running; adapter `SFO2-A` is Up and default route metric 0 remains present.
- `wg.exe show all` was attempted read-only but returned permission denied; adapter/service/route evidence still proves the tunnel is active. No privilege escalation or client change was attempted.

## G1 historical local project artifacts

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

## G1 historical HY2 status

`HY2_READY=BLOCKED_WITH_EXACT_REASON`

Blocked because the current Gate has no authorized HY2 auth Secret or TLS private key, no DNS/SNI certificate checkpoint, and the VPS identity/location drift (`SFO2-A` vs fresh `sfo3`) is unresolved. UDP 8443 is free at the read-only probe, but that alone is not end-to-end readiness.

## G1 historical reviewer handoff

Please reconcile the fresh `sfo3` identity/location against the historical `SFO2-A` label before authorizing any remote write. If accepted, the next bounded Gate may separately authorize Secret/DNS/cloud-firewall checkpoints and a safe-window HY2 installation; G1 did not enter that Gate.

## G1 historical exact return

`RETURN_PREFLIGHT_DRIFT`

## G2-A pre-authorization execution facts (historical)

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

## G2-A pre-authorization checkpoint (historical; superseded by completed execution below)

`HY2_READY=BLOCKED_WITH_EXACT_REASON`

- Owner must explicitly authorize the exact Secret paths/modes and generation behavior before auth/certificate material can be created.
- Owner must inspect the DigitalOcean Cloud Firewall for this droplet and, only if absent, allow inbound UDP 8443 for this droplet only. No other rule or port is in scope.
- After those checkpoints, validate the rendered Hysteria config and systemd unit before starting only the independent HY2 service; then verify WG and Windows routes remain unchanged.

## G2-A completed execution — 2026-10-02

- Target fresh read-back: `24.199.118.137`, hostname `ubuntu-s-1vcpu-512mb-10gb-sfo3`, DigitalOcean region `sfo3`, Ubuntu 24.04.5 LTS, kernel `6.8.0-142-generic`, WAN `eth0`.
- The standard `/srv/data` and `/srv/apps` parents were absent and were created as `root:root 0755`; no pre-existing parent directory was changed. Project directories and the no-login `hy2-vpn` service account were created within the accepted paths.
- Official Hysteria `v2.12.3` binary was installed at `/usr/local/lib/vpn-network-optimization/hysteria`; the release SHA-256 was verified as `8c7a68a906998b747a0db87586e364f995fbfddb95693ae6e2fdb68a6e920d3e`.
- The independent `hysteria2-vpn-network-optimization.service` is enabled and active. It runs as `hy2-vpn`, listens on UDP 8443 only, and suppresses stdout/stderr so the Secret-bearing config is not sent to ordinary service logs.
- Runtime server YAML passed remote PyYAML parsing; the systemd unit passed `systemd-analyze verify`; the running service and listener were freshly read back. The auth file is readable only by root; `hy2-vpn` can read its TLS key/certificate and runtime config.
- Secret-file metadata: `hy2-auth` `root:root 0600`; `server.key` `root:hy2-vpn 0640`; `server.crt` `root:root 0644`; runtime config `root:hy2-vpn 0640`. Secret values are not recorded here.
- Self-signed certificate SAN is `DNS:hy2.sfo3-a.invalid`; SHA-256 fingerprint: `8A:8D:50:5F:DF:80:DB:76:C6:76:39:5A:86:E4:9D:81:8E:A1:5B:76:64:ED:70:30:8C:29:60:9C:23:74:1F:18`.
- The final recovery artifact is `%LOCALAPPDATA%\vpn-network-optimization\recovery\hy2-g2a.dpapi` (1206 bytes), DPAPI `CurrentUser`. Final existence, decryption/byte-identity round-trip, current-owner-only ACL, and disabled inheritance passed fresh read-back. The pending artifact no longer exists. The bundle contains only HY2 auth, TLS private key, and certificate; it excludes the runtime YAML.
- `config/clash/sfo3-a-hy2.yaml` points to `24.199.118.137:8443`, pins the certificate fingerprint, and retains a local auth-injection placeholder. It passed config tests with Mihomo Meta `v1.19.31` and `alpha-f103639`; Clash Verge is `2.5.6`. It was not imported or enabled.
- Fresh regression read-back: `wg0` remains active/enabled at MTU 1420, UDP 51820 remains bound, default/WG routes and IPv4 forwarding remain unchanged, UFW remains inactive, and the existing single NAT masquerade rule remains present. qdisc remains `fq_codel`, TCP CC `cubic`, BBR inactive, generic GRO on, `rx-gro-list` and UDP GRO forwarding off. No live tuning was applied.
- Windows fresh read-back: WireGuard Manager/tunnel remain Running, adapter `SFO2-A` remains Up, default routes remain on `SFO2-A` and `WLAN`, Clash Verge service remains Running, `ProxyEnable=0`, WinHTTP is direct, no Clash/Mihomo TUN adapter or active Mihomo core was present. No Windows network state was changed.
- G2-A service process RSS was `21,596 KiB`; target `MemAvailable` read-back was `260,452 KiB`. The pre-deployment observation was `292,280 KiB` (net interval change `-31,828 KiB`, not attributed solely to HY2). No performance benchmark or client handshake was run.
- During execution, the initial directory step correctly stopped because `/srv/data` and `/srv/apps` were missing; only the authorized no-login account had been created at that point. A later provisioner health read-back initially mis-indexed `ss -p` columns; no final DPAPI artifact was promoted until an independent read-only verification passed. The provisioner parser was corrected for future clean deployments.
- No WireGuard/network service restart, route/NAT/firewall change, Windows proxy/profile/TUN change, BBR/fq/GRO/sysctl/MTU change, traffic switch, Speedtest, benchmark, or G2-B work occurred. Secret values emitted/logged/committed: `0`.

```text
TARGET_HOST_VERIFIED=YES
WG_PRESERVED=YES
FOREGROUND_TASK_INTERRUPTION=NO
YAML_PARSE_VALIDATED=YES
MIHOMO_HY2_SUPPORT_VERIFIED=YES
HY2_INSTALLED=YES
HY2_SERVICE_ACTIVE=YES
HY2_UDP_8443_LISTENING=YES
CLIENT_CONFIG_READY=YES
CURRENT_TRAFFIC_SWITCHED=NO
LIVE_SYSTEM_TUNING_APPLIED=NO
ROLLBACK_READY=YES
DPAPI_FINAL_RECOVERY=YES
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
G2B_ENTERED=NO
STOP_AT_REVIEWER=YES
```



## Current resume point — supersedes earlier DPAPI path assumptions

- Hysteria2 server-side deployment remains accepted and active on UDP 8443; WireGuard remains active on UDP 51820.
- The original G2-A DPAPI artifact was not missing. It was written under Codex packaged-app virtualization at `...\Packages\OpenAI.Codex_2p2nqsd0c76g0\LocalCache\Local\vpn-network-optimization\recovery\hy2-g2a.dpapi`.
- That virtualized artifact is 1206 bytes, owner-only, DPAPI CurrentUser decryptable, parses as the accepted `VPNHY2R1` bundle, and passes TLS key/cert, SAN, and fingerprint validation.
- Do not re-fetch or rotate VPS Secrets.
- `g2b-owner-runner.ps1` ACL validation has been fixed and statically reviewed; benchmark has not started.
- `scripts/realize-owner-dpapi-path.ps1` is the current Owner action path. Its first run failed only because its integrity precheck falsely rejected a real High-integrity PowerShell 7.6.6 process.
- Owner read-back proved Administrator=True and integrity SID `S-1-16-12288` / High; pending and target canonical artifacts were not created.
- Next executor action: fix only the realization runner integrity precheck to use token integrity level semantics; do not execute benchmark until canonical Owner path fresh read-back passes.


## G2-B readiness update — 2026-10-02

Owner-side canonical recovery path realization completed successfully. Source was retained; target ACL, DPAPI round-trip, bundle validation, and encrypted-byte identity all passed; no pending or plaintext temporary artifact remains. Do not repeat recovery creation. G2-B benchmark is now the next step and has not started yet.


## G2-B runtime ACL owner repair

结果：PASS_CANDIDATE
改动：owner-only directory/file ACL constructors now explicitly set Owner SID before Set-Acl.
验证：The repair is limited to ACL ownership semantics; benchmark, Secret, route, and cleanup logic are unchanged.
问题：下一次正式重试前仍需在真实 Windows 主机上用非 Secret 临时目录验证 SetOwner + Set-Acl + owner readback。
回滚：移除两处 SetOwner($script:ownerSid) 即可回到上一 accepted runner。
请 Reviewer 检查：核对 OWNER_ACL_OWNER_MISMATCH 与源码缺失 SetOwner 的因果一致性、补丁范围及下一次 fixture 要求。
Owner 转交：NONE

## Current executor result — G2C_REALITY_SERVER_STATE_DIAGNOSTIC_R2 (2026-10-03)

结果：PASS_CANDIDATE_DIAGNOSTIC；服务端状态归类为 `UNKNOWN_AFTER_R2`。
改动：canary 仅把临时 sing-box 日志提高到 trace，并从受保护日志提取固定 REALITY 状态枚举；VLESS+REALITY+Vision 参数未变。
验证：仅发送 1 次私网代理请求（curl 35 / HTTP 0）；临时私网监听器已创建并清理，sing-box 状态日志采集与 cleanup read-back 通过，但所有 REALITY 阶段字段均为 UNKNOWN。Mihomo 已停止、Secret runtime 已删除、WG/HY2 与本机网络基线保持。
问题：UNKNOWN_AFTER_R2：可读 trace 中未确认任何目标 REALITY 内部状态标记；不得据此推断 auth/fallback 或协议兼容性。
回滚：提交前恢复 `scripts/g2c-private-reality-canary.ps1` 与本轮两份记录即可；本轮临时服务端/客户端运行物已清理，无持久网络或服务变更。
请 Reviewer 检查：fresh-read 本轮 runner、Evidence 与 commit，评估为何 v1.14.2 trace 未暴露目标状态字段，并决定下一步 Gate。
Owner 转交：NONE
ROUND_STARTED_AT=2026-10-03T00:44:07Z
ROUND_FINISHED_AT=2026-10-03T01:09:19Z
ACTUAL_ELAPSED=25m12s
TIME_OVERRUN=YES
TIME_OVERRUN_CAUSE=GITHUB_MAIN_ADVANCED_DURING_ROUND_REQUIRED_FETCH_REBASE_AND_RETRY
STOP_AT_REVIEWER=YES

## Current executor result — G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R3 (2026-10-03)

结果：RETURN_G2C_R3_CLIENT_REQUEST_NOT_STARTED；不得将本轮归类为 Mihomo server success/failure A/B。
改动：新增有界 R3 runner，并修复其本地进程参数绑定问题；未重跑任何服务端、客户端或请求。
验证：固定 Mihomo v1.19.31 资产哈希与服务端配置校验通过，私网 TCP 检查通过；一次服务端尝试后发现 `--noproxy ''` 被 PowerShell mandatory string[] 参数绑定拒绝，curl/REALITY 请求数为 0。临时进程与运行配置清理及生产网络回读通过。
问题：LOCAL_PROCESS_ARGUMENT_BINDING_FAILED：PowerShell 参数校验拒绝显式空参数，发生在启动 curl 前；因此没有握手证据，结果为 UNKNOWN。
回滚：临时 server/client 进程和运行文件已删除；没有持久服务、公开监听或网络配置变更。若需继续，等待 Reviewer 决定是否另开/授权重试 Gate。
请 Reviewer 检查：fresh-read 本轮 runner、Evidence 和 commit，并决定下一步授权；本轮不得自动重放请求。
Owner 转交：NONE
ROUND_STARTED_AT=2026-10-03T01:20:41Z
ROUND_FINISHED_AT=2026-10-03T02:15:51Z
ACTUAL_ELAPSED=55m10s
TIME_OVERRUN=YES
TIME_OVERRUN_CAUSE=LOCAL_PROCESS_ARGUMENT_BINDING_DIAGNOSIS_AND_GITHUB_MAIN_RECONCILIATION
STOP_AT_REVIEWER=YES
