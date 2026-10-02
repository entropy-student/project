# VPN Network Optimization — EXECUTION EVIDENCE

> G1 evidence is metadata-only. No private key, password, token, certificate key, or other Secret value is recorded.

The initial G1 sections below preserve historical preflight evidence. Current G2-A deployment and post-deployment read-back are recorded in the later G2-A sections.

## G1 historical execution boundary

```text
GATE=G1_FOREGROUND_SAFE_FOUNDATION
FINAL_RETURN=RETURN_PREFLIGHT_DRIFT
STOP_AT_REVIEWER=YES
EXECUTOR_RUNTIME=Owner Windows host (target-host identity read back locally)
TARGET_HOST_EXECUTION_PROVEN=PASS_FOR_READ_ONLY_PROBES
SSH_HOST_KEY_MATCH=YES
SSH_NATIVE_EXIT_STATUS_CHECKED=YES
SHARED_VPS_HANDOFF=ABSENT_IN_WORKSPACE
SSH_CONNECTION_CONTRACT_READ=NO_LOCAL_HANDOFF; bounded read-only probe used explicit user-provided endpoint
SECRET_VALUES_EMITTED=0
SANDBOX_ONLY_WRITE_USED_AS_HOST_EVIDENCE=NO
```

Governance source read-back:

```text
GITHUB_GOVERNANCE_SOURCE=PASS
GOVERNANCE_REPOSITORY=entropy-student/spike.skill
GOVERNANCE_PATH=/vps-project-governance
GOVERNANCE_HEAD_READ_BACK=2026-10-01 session read; canonical GitHub source
PROJECT_REPOSITORY=entropy-student/project
PROJECT_HEAD_READ_BACK=2026-10-01 session read; main
```

## Fresh VPS read-back

```text
TARGET_PUBLIC_IP=24.199.118.137
TARGET_HOSTNAME=ubuntu-s-1vcpu-512mb-10gb-sfo3
TARGET_DO_REGION=sfo3
TARGET_DO_DROPLET_ID=605143113
TARGET_OS=Ubuntu 24.04.5 LTS
TARGET_KERNEL=6.8.0-142-generic
TARGET_ARCH=x86_64
TARGET_WAN_INTERFACE=eth0
TARGET_DEFAULT_ROUTE=24.199.112.1 dev eth0
TARGET_RESOURCE=458MiB RAM; 23% root filesystem; no swap; load low at probe
```

Identity drift:

```text
DOCUMENTED_LABEL=SFO2-A
FRESH_REGION=sfo3
MATERIAL_DRIFT=YES_UNRESOLVED
REMOTE_WRITE_ALLOWED=NO_PENDING_REVIEWER_RECONCILIATION
FULL_PREFLIGHT_SSH_EXIT=1_EXPECTED_EMPTY_HY2_UNIT_LIST_ONLY
```

## WireGuard and path

```text
WG_INTERFACE=wg0
WG_SERVICE=enabled+active
WG_ADDRESS=10.66.21.1/24
WG_LISTEN_PORT=51820/udp
WG_LINK_MTU=1420
WG_PEER_PRIVATE_KEY_READ=NO
WG_PEER_METADATA_READ=YES
WG_LIVE_HANDSHAKE_OBSERVED=YES
WG_ROUTE=10.66.21.0/24 dev wg0
IPV4_FORWARDING=1
IPV6_FORWARDING=0
NAT=eth0 masquerade present
FIREWALL=UFW inactive; nft/iptables forward rules present
UDP_51820=OCCUPIED_BY_WIREGUARD
UDP_8443=NO_LISTENER_AT_PROBE
```

Windows:

```text
WINDOWS_TARGET_PROVEN=YES_FOR_READ_ONLY
CLASH_VERGE_VERSION=2.5.6
MIHOMO_BINARY_PRESENT=YES
MIHOMO_ACTIVE_CORE_VERSION=UNKNOWN
CLASH_TUN_ADAPTER=NOT_OBSERVED
WINHTTP_PROXY=DIRECT
SYSTEM_PROXY_ENABLE=0
WIREGUARD_TUNNEL_SERVICE=Running
WIREGUARD_ADAPTER=SFO2-A Up
WIREGUARD_ACTIVE_INTERFACE_MTU=1420
WIREGUARD_DEFAULT_ROUTE=0.0.0.0/0 via SFO2-A metric 0
WG_EXE_SHOW=permission denied; no change attempted
```

## Linux networking read-back

```text
WAN_QDISC= fq_codel on eth0
WG_QDISC= noqueue on wg0
TCP_CONGESTION=cubic
TCP_AVAILABLE=reno cubic
TCP_ALLOWED=reno cubic
TCP_BBR_MODULE=present_not_active
RX_GRO=on
RX_GRO_LIST=off
RX_UDP_GRO_FORWARDING=off
LIVE_SYSCTL_TUNING=NO
LIVE_QDISC_TUNING=NO
LIVE_OFFLOAD_CHANGE=NO
```

## Local artifacts and checks

```text
PORTABLE_TEMPLATE_READY=YES
ROLLBACK_READY=YES
MIGRATION_HELPER_DEFAULT=PLAN_ONLY
HEALTH_CHECK_DEFAULT=READ_ONLY_NO_TRAFFIC
SECRET_FILES_IN_REPOSITORY=0
SECRET_VALUES_GENERATED=0
CURRENT_TRAFFIC_SWITCHED=NO
FOREGROUND_TASK_INTERRUPTION=NO
POSTCHECK_WG_SERVER_SERVICE=active
POSTCHECK_WG_51820=still_listening
POSTCHECK_HY2_8443=still_no_listener
POSTCHECK_WINDOWS_WG_SERVICES=Running
```

The local scripts were syntax-checked after creation with `bash -n`; the Windows preflight was parsed/read-only reviewed. No script was executed against the VPS, no package was installed, no service was created, and no system/network setting was changed.

The two YAML templates were structurally reviewed against the official Hysteria 2 and Mihomo field shapes. A YAML parser was not available in the execution environment, so `YAML_TEMPLATE_PARSE=NOT_RUN_PARSER_UNAVAILABLE`; this is not represented as a parser PASS.

## Acceptance snapshot

```text
TARGET_HOST_VERIFIED=YES
CURRENT_WIREGUARD_PRESERVED=YES
FOREGROUND_TASK_INTERRUPTION=NO
BASELINE_INSPECTION_COMPLETE=YES
PORTABLE_TEMPLATE_READY=YES
ROLLBACK_READY=YES
CURRENT_TRAFFIC_SWITCHED=NO
LIVE_SYSTEM_TUNING_APPLIED=NO
HY2_READY=BLOCKED_WITH_EXACT_REASON
CLASH_VERGE_INTEGRATION_PLAN_READY=YES
```

## G2-A pre-authorization read-only evidence (historical; 2026-10-01)

The following is a new read-only G2-A read-back and local template validation. Historical G1 evidence above is unchanged; G1 was not rerun.

```text
GATE=G2A_SIDE_BY_SIDE_HYSTERIA2
G1_REEXECUTED=NO
REVIEWER_HANDOFF_MODIFIED=NO
TARGET_PUBLIC_IP=24.199.118.137
TARGET_HOSTNAME=ubuntu-s-1vcpu-512mb-10gb-sfo3
TARGET_IP_HOSTNAME_MATCH_ACCEPTED_BASELINE=YES
TARGET_DO_REGION_OWNER_ACCEPTED_BASELINE=sfo3
TARGET_DO_REGION_FRESH_METADATA=UNAVAILABLE
TARGET_OS=Ubuntu 24.04
TARGET_KERNEL=6.8.0-142-generic
TARGET_WAN=eth0; 24.199.118.137/20
TARGET_DEFAULT_ROUTE=24.199.112.1 dev eth0
TARGET_RESOURCES=185MiB/458MiB RAM; no swap; root filesystem 23% used; load 0.00,0.00,0.00
WG_INTERFACE=wg0
WG_SERVICE=enabled+active
WG_LINK=UP; MTU 1420
WG_ADDRESS=10.66.21.1/24
WG_PEER_COUNT=1
WG_PERSISTENT_KEEPALIVE=off
WG_LISTEN_PORT=51820/udp
WG_ROUTE=10.66.21.0/24 dev wg0
IPV4_FORWARDING=1
UDP_51820=LISTENING on IPv4 and IPv6
UDP_8443=NO_LISTENER
HOST_UFW=inactive
NFT_RULE_TEXT_MATCHES_8443=0
NFT_RULE_TEXT_MATCHES_51820=0
NAT_MASQUERADE=PRESENT
CLOUD_FIREWALL=UNVERIFIED; doctl unavailable and DO API token absent
CLOUD_FIREWALL_RULE_CHANGED=NO
REMOTE_WRITE=NO
HY2_BINARY_INSTALLED=NO
HY2_UNIT_CREATED_OR_STARTED=NO
HY2_UNIT_LOAD_STATE=not-found
HY2_COMMAND_PATH=absent
HY2_PROJECT_BINARY_EXISTS=NO
HY2_SERVER_CONFIG_EXISTS=NO (/srv/apps/vpn-network-optimization/config/hysteria2-server.yaml)
HY2_AUTH_FILE_EXISTS=NO; OWNER_MODE=N/A (path /srv/data/vpn-network-optimization/secrets/hy2-auth)
HY2_CERT_FILE_EXISTS=NO; OWNER_MODE=N/A (path /srv/data/vpn-network-optimization/secrets/server.crt)
HY2_PRIVATE_KEY_FILE_EXISTS=NO; OWNER_MODE=N/A (path /srv/data/vpn-network-optimization/secrets/server.key)
WG_OR_NETWORK_SERVICE_RESTARTED=NO
CURRENT_TRAFFIC_SWITCHED=NO
LIVE_SYSTEM_TUNING_APPLIED=NO
FOREGROUND_TASK_INTERRUPTION=NO
```

```text
CLASH_VERGE_VERSION=2.5.6
MIHOMO_STABLE_INSTALLED=Mihomo Meta v1.19.31 windows amd64
MIHOMO_ALPHA_INSTALLED=Mihomo Meta alpha-f103639 windows amd64
MIHOMO_ACTIVE_CORE_PROCESS=NONE
CLASH_VERGE_SERVICE=RUNNING
WINDOWS_WG_TUNNEL=RUNNING; adapter SFO2-A UP
CLASH_TUN_ADAPTER_MATCHES=0
SYSTEM_PROXY_ENABLE=0
WINHTTP_PROXY=DIRECT
WINDOWS_DEFAULT_ROUTES=SFO2-A and WLAN remain present; no route change was made
```

Both installed Mihomo cores successfully ran `-t` against both YAML templates. This verifies YAML/config parsing and acceptance of the `hysteria2` outbound plus `fingerprint` field; it does not constitute a TLS handshake or Hysteria server-config check. The fingerprint currently in the client template is a deliberate all-zero, non-matching parser sentinel and must be replaced with the real certificate SHA-256 fingerprint before use.

The TLS approach follows the official Hysteria self-signed certificate plus `insecure`/`pinSHA256` guidance and Mihomo's Hysteria2 `fingerprint` pinning field: [Hysteria 2 client TLS configuration](https://v2.hysteria.network/docs/advanced/Full-Client-Config/), [Hysteria 2 server TLS configuration](https://v2.hysteria.network/docs/advanced/Full-Server-Config/), [Mihomo Hysteria2 configuration](https://wiki.metacubex.one/en/config/proxies/hysteria2/), and [Mihomo TLS configuration](https://wiki.metacubex.one/en/config/proxies/tls/). No certificate or fingerprint was generated in this run. Hysteria-specific config validation was not run because no Hysteria binary was installed.

```text
YAML_PARSE_VALIDATED=YES (both templates; both installed Mihomo cores)
MIHOMO_HY2_AND_FINGERPRINT_FIELD_SUPPORTED=YES (both installed cores; config-test only)
HY2_INSTALLED=NO
HY2_SERVICE_ACTIVE=NO
HY2_UDP_8443_LISTENING=NO (port was free; service not deployed)
CLIENT_CONFIG_TEMPLATE_READY=YES
CLIENT_CONFIG_READY=NO (auth and real certificate fingerprint not present)
ROLLBACK_READY=YES (project unit/config/binary only; syntax + dry-run passed; Secrets preserved)
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
HY2_READY=BLOCKED_WITH_EXACT_REASON (Secret authorization and Cloud Firewall read-back)
G2B_ENTERED=NO
```

## G2-A completed deployment and verification (2026-10-02)

```text
GATE=G2A_SIDE_BY_SIDE_HYSTERIA2
G1_REEXECUTED=NO
REVIEWER_HANDOFF_MODIFIED=NO
README_MODIFIED=NO
TARGET_HOST_VERIFIED=YES
TARGET_PUBLIC_IP=24.199.118.137
TARGET_HOSTNAME=ubuntu-s-1vcpu-512mb-10gb-sfo3
TARGET_DO_REGION=sfo3
TARGET_OS=Ubuntu 24.04.5 LTS
TARGET_KERNEL=6.8.0-142-generic
TARGET_WAN=eth0
FOREGROUND_TASK_INTERRUPTION=NO
WG_PRESERVED=YES
WG_SERVICE=enabled+active
WG_MTU=1420
WG_LISTEN_PORT=51820/udp; still listening
WG_ROUTE=10.66.21.0/24 dev wg0; still present
DEFAULT_ROUTE=24.199.112.1 dev eth0; unchanged
IPV4_FORWARDING=1; unchanged
UDP_8443=HYSTERIA_LISTENING
CURRENT_TRAFFIC_SWITCHED=NO
WINDOWS_ROUTE_CHANGED=NO
WINDOWS_WG_CHANGED=NO
CLASH_PROFILE_IMPORTED_OR_ENABLED=NO
SYSTEM_PROXY_CHANGED=NO
TUN_ENABLED_OR_CHANGED=NO
LIVE_SYSTEM_TUNING_APPLIED=NO
G2B_ENTERED=NO
STOP_AT_REVIEWER=YES
```

Host, server, and client read-back:

```text
HY2_BINARY_VERSION=v2.12.3
HY2_BINARY_SHA256=8c7a68a906998b747a0db87586e364f995fbfddb95693ae6e2fdb68a6e920d3e
HY2_BINARY_SHA256_VERIFIED=YES
HY2_SERVICE=hysteria2-vpn-network-optimization.service
HY2_SERVICE_ACTIVE=YES
HY2_SERVICE_ENABLED=YES
HY2_RUNTIME_ACCOUNT=hy2-vpn; system account; shell=/usr/sbin/nologin; home=/nonexistent
HY2_UDP_8443_LISTENING=YES; socket owned by Hysteria service PID
HY2_SERVICE_OWNED_LISTEN_PORTS=8443
SERVER_YAML_PARSE=PASS (remote PyYAML; auth file matched config in memory)
SYSTEMD_UNIT_VERIFY=PASS (systemd-analyze verify)
HYSTERIA_CLI_HELP=PASS
SERVICE_STDOUT=null
SERVICE_STDERR=null
RUNTIME_READ_TLS_KEY_CERT_CONFIG=YES
RUNTIME_READ_AUTH_FILE=NO
CLIENT_HANDSHAKE_TESTED=NO
PERFORMANCE_TESTED=NO
```

Authorized remote file metadata; Secret values and config contents were not recorded:

| Path | Owner:group | Mode | Bytes | Notes |
|---|---|---:|---:|---|
| `/srv/data/vpn-network-optimization/secrets/hy2-auth` | `root:root` | `0600` | 64 | OpenSSL CSPRNG 32-byte hex; value not recorded |
| `/srv/data/vpn-network-optimization/secrets/server.key` | `root:hy2-vpn` | `0640` | 227 | OpenSSL P-256 private key; value not recorded |
| `/srv/data/vpn-network-optimization/secrets/server.crt` | `root:root` | `0644` | 644 | Self-signed; SAN `DNS=hy2.sfo3-a.invalid` |
| `/srv/apps/vpn-network-optimization/config/hysteria2-server.yaml` | `root:hy2-vpn` | `0640` | 271 | Secret-bearing runtime config; excluded from Git |
| `/usr/local/lib/vpn-network-optimization/hysteria` | `root:root` | `0755` | 23003298 | Official v2.12.3 binary |
| `/etc/systemd/system/hysteria2-vpn-network-optimization.service` | `root:root` | `0644` | 506 | Independent project unit |

`/srv/data` and `/srv/apps` did not exist on the target. They were created as `root:root 0755`; no pre-existing shared parent directory was modified. Project-specific directories are confined to this project. The rollback helper removes the project unit, runtime config, and binary; it preserves the Secret directory and does not touch WireGuard, routes, NAT, or firewall.

TLS/client metadata:

```text
TLS_CERT_TYPE=self-signed P-256
TLS_CERT_SAN=DNS:hy2.sfo3-a.invalid
TLS_CERT_SHA256_FINGERPRINT=8A:8D:50:5F:DF:80:DB:76:C6:76:39:5A:86:E4:9D:81:8E:A1:5B:76:64:ED:70:30:8C:29:60:9C:23:74:1F:18
TLS_PRIVATE_KEY_MATCHES_CERT=YES
TLS_CERT_VALID_NOW=YES
CLASH_VERGE_VERSION=2.5.6
MIHOMO_STABLE=Mihomo Meta v1.19.31; HY2+fingerprint parser PASS
MIHOMO_ALPHA=Mihomo Meta alpha-f103639; HY2+fingerprint parser PASS
MIHOMO_ACTIVE_CORE_PROCESS=NONE
CLIENT_CONFIG=config/clash/sfo3-a-hy2.yaml
CLIENT_CONFIG_SERVER=24.199.118.137:8443
CLIENT_CONFIG_SNI=hy2.sfo3-a.invalid
CLIENT_CONFIG_FINGERPRINT_PIN=YES
CLIENT_AUTH_VALUE=LOCAL_SECRET_INJECTION_REQUIRED_PLACEHOLDER
CLIENT_CONFIG_PARSE_STABLE_AND_ALPHA=PASS
CLIENT_CONFIG_IMPORTED_OR_ENABLED=NO
```

The non-sensitive client fragment contains the VPS IP, UDP port, local SNI, public certificate fingerprint, and auth-injection placeholder only. It passed parser tests with both installed Mihomo cores and was not imported into Clash Verge.

Windows foreground/network read-back:

```text
WINDOWS_WIREGUARD_MANAGER=Running
WINDOWS_WIREGUARD_TUNNEL=Running
WINDOWS_WIREGUARD_ADAPTER=SFO2-A Up
WINDOWS_DEFAULT_ROUTE_ADAPTERS=SFO2-A,WLAN
CLASH_VERGE_SERVICE=Running
WINDOWS_SYSTEM_PROXY_ENABLE=0
WINDOWS_WINHTTP_PROXY=Direct
CLASH_OR_MIHOMO_TUN_ADAPTERS=0
ACTIVE_MIHOMO_CORE_PROCESSES=0
FOREGROUND_TASK_INTERRUPTION=NO
```

Linux networking regression read-back:

```text
UFW=inactive
CLOUD_FIREWALL=NO_CLOUD_FIREWALL_ATTACHED (Owner-confirmed)
NAT_MASQUERADE_RULES=1; no rule changed
ETH0_QDISC=fq_codel
TCP_CONGESTION_CONTROL=cubic
TCP_BBR_ACTIVE=NO
GENERIC_GRO=on
RX_GRO_LIST=off
RX_UDP_GRO_FORWARDING=off
LIVE_QDISC_SYSCTL_BBR_GRO_MTU_CHANGE=NO
```

The fresh post-deployment read-back found the target default route, `wg0` route, forwarding, UDP 51820 listener, qdisc, congestion control, firewall/NAT count, and offload states unchanged. No client-side Hysteria handshake was attempted; no performance or G2-B test was run.

```text
MEM_AVAILABLE_BEFORE_DEPLOYMENT_OBSERVATION_KB=292280
MEM_AVAILABLE_AFTER_DEPLOYMENT_KB=260452
MEM_AVAILABLE_NET_INTERVAL_CHANGE_KB=-31828 (not attributed solely to HY2)
HY2_PROCESS_RSS_KB=21596
CPU_DELTA=NOT_CAPTURED
```

DPAPI recovery read-back:

```text
DPAPI_SCOPE=CurrentUser
DPAPI_PENDING_PATH=%LOCALAPPDATA%\vpn-network-optimization\recovery\hy2-g2a.pending.dpapi
DPAPI_PENDING_CREATED_AND_BYTE_IDENTITY_ROUNDTRIP=PASS
DPAPI_FINAL_PATH=%LOCALAPPDATA%\vpn-network-optimization\recovery\hy2-g2a.dpapi
DPAPI_FINAL_EXISTS=YES
DPAPI_FINAL_BYTES=1206
DPAPI_FINAL_BYTE_IDENTITY_ROUNDTRIP=PASS
DPAPI_RECOVERY_DIR_ACL=inheritance disabled; only current Owner SID
DPAPI_FINAL_FILE_ACL=inheritance disabled; only current Owner SID
DPAPI_PENDING_EXISTS_AFTER_PROMOTION=NO
DPAPI_PAYLOAD=HY2 auth + TLS private key + TLS certificate only; runtime YAML excluded
RECOVERY_FAILURE_DOMAIN=VPS and this Windows CurrentUser profile lost simultaneously means artifact unrecoverable (Owner-accepted)
SECRET_VALUES_EMITTED=0
SECRET_VALUES_LOGGED=0
SECRET_VALUES_COMMITTED=0
```

Execution notes: the first deployment attempt stopped because `/srv/data` and `/srv/apps` were missing; only the authorized no-login account had been created, with no Secret files or project service paths yet. A later provisioner read-back initially mis-indexed `ss -p` columns. The parser was corrected; an independent fresh read-only verification then passed for service, file permissions, TLS key/certificate match and fingerprint, listeners, runtime access, WireGuard, and routes. The DPAPI pending artifact was promoted only after that successful verification.

```text
TARGET_HOST_VERIFIED=YES
YAML_PARSE_VALIDATED=YES
MIHOMO_HY2_SUPPORT_VERIFIED=YES
HY2_READY=YES
HY2_INSTALLED=YES
HY2_SERVICE_ACTIVE=YES
HY2_UDP_8443_LISTENING=YES
CLIENT_CONFIG_READY=YES
ROLLBACK_READY=YES
CURRENT_TRAFFIC_SWITCHED=NO
LIVE_SYSTEM_TUNING_APPLIED=NO
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
G2B_ENTERED=NO
PASS_CANDIDATE=PASS_CANDIDATE_G2A_HY2_SIDE_BY_SIDE
STOP_AT_REVIEWER=YES
```


## Post-G2-A Owner host reality correction — packaged-app virtualization (2026-10-02)

The earlier G2-A DPAPI block above is preserved as historical execution evidence, but it is not sufficient by itself to prove the canonical Owner Windows path was realized.

Owner fresh read-back later established:

- canonical path `C:\Users\34707\AppData\Local\vpn-network-optimization\recovery\hy2-g2a.dpapi` was absent;
- canonical recovery directory was absent;
- recursive search under ordinary `C:\Users\34707\AppData\Local` did not find `hy2-g2a*.dpapi`;
- Codex packaged-app storage exists at `C:\Users\34707\AppData\Local\Packages\OpenAI.Codex_2p2nqsd0c76g0`;
- a matching `hy2-g2a*.dpapi` artifact was found under `...\LocalCache\Local\vpn-network-optimization\recovery\`;
- the corresponding virtualized project and recovery directories exist.

Current interpretation: this is consistent with Windows packaged-app path virtualization. The historical `DPAPI_FINAL_EXISTS=YES` must therefore not be read as proof that the canonical Owner AppData path was written. Exact virtualized-artifact metadata, ACL, DPAPI round-trip, and canonical-path reconciliation remain pending.

During a later repair attempt, SSH transfer from the VPS succeeded but local finalization failed before promotion with `RECOVERY_ACL_OWNER_OR_RULE_COUNT_INVALID`; cleanup left no canonical base/recovery/pending/final paths. Because a virtualized artifact has now been found, do not rotate/regenerate VPS Secrets or rerun the real repair until the virtualized artifact is validated.

### Virtualized DPAPI artifact exact metadata/ACL read-back

Owner fresh read-back found the exact artifact under Codex packaged-app virtualization:

```text
PATH=C:\Users\34707\AppData\Local\Packages\OpenAI.Codex_2p2nqsd0c76g0\LocalCache\Local\vpn-network-optimization\recovery\hy2-g2a.dpapi
NAME=hy2-g2a.dpapi
BYTES=1206
CREATION_TIME=2026-10-02 00:14:04
LAST_WRITE_TIME=2026-10-02 00:14:04
OWNER=码头整来的薯条\34707
INHERITANCE_PROTECTED=True
ACCESS_RULE_COUNT=1
SOLE_ACE=current Owner FullControl Allow explicit
```

This matches the historical G2-A size and intended ACL pattern and confirms the packaged-app path-virtualization hypothesis at the filesystem metadata level. DPAPI CurrentUser decrypt/round-trip and bundle validation are still pending; canonical Owner AppData path remains unrealized.

## Non-secret ACL fixture diagnosis

A non-secret ACL fixture was used to isolate the recovery-runner ACL validator without SSH, VPS Secret access, or real DPAPI recovery execution.

```text
ACL_FIXTURE_CREATE=PASS
ACL_FIXTURE_READBACK=PASS
ACL_FIXTURE_VALIDATOR=PASS
ACL_FIXTURE_CLEANUP=PASS
RECOVERY_RUNNER_ACL_FIXED=YES
STATIC_REVIEW=PASS
REAL_SECRET_ACCESSED=NO
REAL_RECOVERY_RUNNER_EXECUTED=NO
```

The old helper incorrectly treated `ACE count != 1` as failure even where all explicit ACEs belonged to the current Owner and merged to FullControl. The fixed helper now validates security semantics rather than a fixed rule count. Because the prior real failure had already been cleaned and the old error class merged multiple branches, the exact historical branch hit cannot be proven.

Fixture runtime was PowerShell 7.6.5 / Medium token and is diagnostic only. Real canonical-path validation still requires the elevated Owner execution path.

`g2b-owner-runner.ps1` independently retains a single-ACE-count validator and remains unfixed as of this evidence update.

## Current DPAPI path-realization evidence (2026-10-02)

The packaged-app virtualized recovery artifact has now passed content validation:

```text
VIRTUALIZED_SOURCE_VALIDATION=PASS
DPAPI_UNPROTECT=PASS
VPNHY2R1_PARSE=PASS
TLS_KEY_CERT_MATCH=PASS
TLS_SAN_MATCH=PASS
TLS_FINGERPRINT_MATCH=PASS
REAL_SECRET_ACCESSED_FROM_VPS=NO
NETWORK_CHANGED=NO
BENCHMARK_STARTED=NO
```

The independent ACL validator in `g2b-owner-runner.ps1` was also fixed to validate security semantics rather than a fixed ACE count and passed static review.

A local-only canonical-path realization runner exists at `scripts/realize-owner-dpapi-path.ps1`. On first Owner execution it stopped in PRECHECK with `HIGH_INTEGRITY_TOKEN_REQUIRED` before creating pending or target files.

Owner fresh read-back from the same PowerShell 7.6.6 window proved:

```text
ADMINISTRATOR=True
INTEGRITY_SID=S-1-16-12288
INTEGRITY_LEVEL=High
PENDING_EXISTS=NO
TARGET_EXISTS=NO
```

Therefore the path-realization failure is a false negative in the runner's integrity precheck, not a lack of elevation. Current next action is to fix only that precheck helper, then rerun canonical-path realization. G2-B benchmark remains not started.


## Canonical Owner DPAPI path realization — PASS (2026-10-02)

Owner executed the local-only realization runner from elevated PowerShell 7.6.6. Results: Owner Windows target confirmed; DPAPI scope CurrentUser; virtualized source retained; source and target encrypted bytes identical; target owner-only ACL PASS; target DPAPI round-trip PASS; target VPNHY2R1 validation PASS; pending absent; no plaintext temporary files; Secret values emitted 0. This closes the AppData path-realization defect. G2-B benchmark had not started at this evidence point.

## G2-B bounded route/adapter diagnostic and runner-source persistence (2026-10-02)

```text
AUTHORIZED_GATE=G2B_RouteAdapter_Precheck_Diagnostic_And_Source_Persistence
GOVERNANCE_VERSION=v0.2.4 / ACTIVE_PROVISIONAL
PROJECT_REPOSITORY=entropy-student/project
PROJECT_BRANCH=main
WORKSPACE_INITIAL_HEAD=b8699ec02d4a02e9d73c646922fa18033dde157b
CANONICAL_PRE_GATE_HEAD=b3f21718fb0e015ce4f0c622b43f1d293efbf8d7
SOURCE_PROVENANCE=PASS (canonical root/remote verified; workspace fast-forwarded before source edits)
UNRELATED_DIRTY_STATE=NONE (only the three requested untracked runner sources were present)

OWNER_REPORTED_READBACK=route 24.199.118.137/32 -> 192.168.1.1 via WLAN ifIndex 18; WLAN Up / 192.168.1.4 / gateway present; SFO2-A Up / ifIndex 13
OWNER_REPORTED_RUNNER_FAILURE=PRECHECK_ROUTE_AND_ADAPTERS / CimJobException
DIRECT_CODEX_RUNTIME=Medium integrity; not Owner High-integrity preflight
DIRECT_ACTIVE_ROUTE_READBACK=one exact route; WLAN / ifIndex 18 / next hop 192.168.1.1
DIRECT_WLAN_ADAPTER_AND_IP_READBACK=PASS
DIRECT_FIND_NET_ROUTE_READBACK=two CIM objects; scalar route selection resolved to WLAN / ifIndex 18 / next hop 192.168.1.1
DIRECT_PERSISTENT_ROUTE_QUERY=CimJobException; FQID CmdletizationQuery_NotFound,Get-NetRoute; category ObjectNotFound when the exact destination has no persistent match
PREFLIGHT_FACTS=Owner state above is OWNER_REPORTED; direct route/helper probes were performed in the Codex Medium-integrity runtime only

CIMJOBEXCEPTION_ROOT_CAUSE=The runner treated the NetTCPIP provider's exact no-match CimJobException from Get-NetRoute -PolicyStore PersistentStore -DestinationPrefix ... as a generic query failure instead of an empty result. The original Owner run did not retain a subcheck, so the direct Codex-runtime reproduction narrows the fault to this statement but is not represented as an Owner High-token reproduction.
ACTUAL_CHANGES=Patched only g2b-owner-runner.ps1 precheck/query diagnostics and added same-path -PreflightOnly; updated this handoff and execution evidence. The realization and repair runner sources were persisted unchanged.
ROUTE_REQUIREMENT=Still requires exactly 24.199.118.137/32, next hop 192.168.1.1, WLAN alias, ifIndex 18, and no persistent exact route
WLAN_REQUIREMENT=Still requires WLAN ifIndex 18 Up, IPv4 192.168.1.4, and gateway 192.168.1.1
WIREGUARD_REQUIREMENT=Still requires SFO2-A ifIndex 13 Up and the existing WireGuard services Running

NO_MATCH_CIM_NORMALIZATION_FIXTURE=PASS (only exact Get-NetRoute ObjectNotFound no-match FQID maps to empty; other errors remain fail-closed)
PRODUCTION_ROUTE_WLAN_HELPER=DIRECT_CODEX_RUNTIME_READ_ONLY_PASS
WG_ADAPTER_SCALAR_EXTRACTION_FIXTURE=PASS
BRANCH_SPECIFIC_QUERY_ERROR_FIXTURE=PASS
POWERSHELL_AST_PARSE=PASS (all three runner scripts)
SECRET_SCAN=PASS (six PEM header-format literals are parser markers; two 64-hex literals are accepted public Hysteria binary SHA-256 integrity values; no private-key PEM body, Secret hash, long base64 payload, credential literal, API key, or bearer value)
BENCHMARK_LOGIC_UNCHANGED=YES
DPAPI_SECRET_HANDLING_UNCHANGED=YES
MIHOMO_RUNTIME_LOGIC_UNCHANGED=YES
FINALLY_CLEANUP_UNCHANGED=YES
EXACT_ROUTE_REMOVAL_SEMANTICS_UNCHANGED=YES
PREFLIGHT_ONLY_ORDERING=PASS (returns before benchmark, DPAPI Unprotect, runtime YAML, Mihomo, handshake, and cleanup-eligible route removal)
VALIDATION=PASS (PowerShell AST, secret scan, exact no-match fixture, query-error branch fixture, direct read-only production route/WLAN helper, preservation checks)

OWNER_HIGH_PREFLIGHT=NOT_RUN_REQUIRES_OWNER
OBJECTIVE_READBACK=Extracted production route/WLAN precheck helper passed read-only in the direct Codex Medium-integrity runtime; Owner High-integrity -PreflightOnly remains pending.
WG_FORMAL_SAMPLES=0
HY2_FORMAL_SAMPLES=0
HY2_REAL_G2B_HANDSHAKE=NO
PERFORMANCE_CONCLUSION=NONE
BENCHMARK_STARTED=NO
MIHOMO_STARTED=NO
SECRET_ACCESSED=NO
NETWORK_CHANGED=NO
REVIEWER_HANDOFF_MODIFIED=NO
ANOMALIES=The original Owner run retained only phase and CimJobException class; the precise reproduction was obtained in the separate Direct Codex Medium-integrity runtime, not Owner High context.
EVIDENCE_ARTIFACTS_AND_PURPOSE=Three project runner sources (G2-B precheck fix plus existing recovery chain) and the two executor-owned factual records; no runtime/recovery artifacts
ROLLBACK_EFFECT=Revert only this Gate's source/document commit to canonical pre-edit base; preserve prior remote history, unrelated paths, DPAPI artifacts, Owner route, and all network state
```

Validation ran only parser/static checks, a non-secret no-match/error fixture, and read-only execution of the extracted production route/WLAN precheck helper in the current Medium-integrity Codex runtime. Owner High-integrity `-PreflightOnly` remains required to validate the packaged Owner execution path; no benchmark or full runner was executed.

Evidence artifacts: `scripts/g2b-owner-runner.ps1` is the repaired production runner; `scripts/realize-owner-dpapi-path.ps1` and `scripts/repair-owner-dpapi-recovery.ps1` are the existing recovery-execution chain persisted unchanged. No DPAPI artifact, LocalCache data, runtime Secret config, Secret value, or result sample was added.

Rollback effect: revert only this Gate's project-owned source and record commit to the canonical pre-edit base; preserve the already-canonical remote history, unrelated paths, all Windows/VPS network state, DPAPI artifacts, and the Owner route.

```text
EXECUTOR_RESULT=PASS_CANDIDATE_G2B_BOUNDED_DIAGNOSTIC_AND_SOURCE_PERSISTENCE
STOP_BEFORE_FULL_BENCHMARK=YES
STOP_AT_REVIEWER=YES
```

## G2-B ClientSnapshot optional-property repair — 2026-10-02

```text
AUTHORIZED_GATE=G2B_ClientSnapshot_Optional_Property_Repair
GOVERNANCE_VERSION=v0.2.4 / ACTIVE_PROVISIONAL
PROJECT_REPOSITORY=entropy-student/project
PROJECT_BRANCH=main
CANONICAL_PRE_GATE_HEAD=0f2217dba7716291e0c277ac62f787c85dd78a26
SOURCE_PROVENANCE=PASS (canonical root/remote verified; clean worktree before this Gate; unrelated dirty state NONE)
OWNER_REPORTED_DIAGNOSTIC=AutoConfigURL absent; other Owner-reported snapshot queries passed
ROOT_CAUSE=Direct $internet.AutoConfigURL access under StrictMode Latest raised PropertyNotFoundException when the optional property was absent
ACTUAL_CHANGES=Only g2b-owner-runner.ps1 snapshot/property diagnostics plus these Executor-owned records
OPTIONAL_PROPERTY_POLICY=ProxyEnable required; ProxyServer, ProxyOverride, and AutoConfigURL optional strings; missing/null normalize to empty string
SNAPSHOT_DIAGNOSTICS=WG_SERVICE_STATE_INVALID; WG_ADAPTER_STATE_INVALID; CLASH_SERVICE_STATE_INVALID; INTERNET_SETTINGS_QUERY_FAILED; INTERNET_SETTINGS_SHAPE_INVALID; CLIENT_SNAPSHOT_ROUTE_QUERY_FAILED; WINHTTP_READBACK_FAILED; CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED
AUTOCONFIGURL_MISSING_FIXTURE=PASS
PROXYSERVER_MISSING_FIXTURE=PASS
PROXYOVERRIDE_MISSING_FIXTURE=PASS
OPTIONAL_NULL_FIXTURES=PASS
OPTIONAL_PRESENT_STRING_FIXTURE=PASS
PROXYENABLE_MISSING_FAIL_CLOSED=PASS
REQUIRED_WG_FIELD_NEGATIVE_FIXTURE=PASS
REQUIRED_ROUTE_FIELD_NEGATIVE_FIXTURE=PASS
UNRELATED_PROPERTY_RUNTIME_EXCEPTION_NOT_SWALLOWED=PASS
POWERSHELL_AST_PARSE=PASS
SECRET_SCAN=PASS (no Secret values or Secret-bearing runtime/recovery files in the candidate)
BENCHMARK_LOGIC_UNCHANGED=YES
DPAPI_SECRET_HANDLING_UNCHANGED=YES
MIHOMO_RUNTIME_LOGIC_UNCHANGED=YES
FINALLY_CLEANUP_UNCHANGED=YES
ROUTE_REMOVAL_SEMANTICS_UNCHANGED=YES
PREFLIGHT_ONLY_BOUNDARY_UNCHANGED=YES
OWNER_PREFLIGHT_EXECUTED=NO
BENCHMARK_STARTED=NO
MIHOMO_STARTED=NO
SECRET_ACCESSED=NO
NETWORK_CHANGED=NO
REVIEWER_HANDOFF_MODIFIED=NO
ROLLBACK_EFFECT=Revert only this Gate's project-owned source and record changes; preserve accepted history, unrelated paths, Owner route, DPAPI artifacts, and all network state
EXECUTOR_RESULT=PASS_CANDIDATE_G2B_CLIENTSNAPSHOT_OPTIONAL_PROPERTY_REPAIR
STOP_BEFORE_OWNER_EXECUTION=YES
STOP_AT_REVIEWER=YES
```

## G2-B runner binding and cleanup no-match repair — 2026-10-02

```text
AUTHORIZED_GATE=G2B_Runner_Binding_And_Cleanup_NoMatch_Repair
GOVERNANCE_VERSION=v0.2.5 / ACTIVE_PROVISIONAL (as supplied in the Gate relay)
PROJECT_REPOSITORY=entropy-student/project
CANONICAL_GIT_ROOT=C:\Users\34707\Documents\ChatGPT\VPS搭建
EXECUTION_WORKTREE=C:\Users\34707\.codex\worktrees\g2b-runner-binding-cleanup\VPS搭建
PUSH_TARGET_BRANCH=main
EXECUTOR_WORKTREE_BRANCH=codex/g2b-runner-binding-cleanup
PRE_GATE_HEAD=bc593aaab08c6a3eca3334e4eb4d5dc8f099b946
SOURCE_PROVENANCE=PASS (origin verified; isolated clean worktree; original checkout's untracked results directory preserved and not staged)
REVIEWER_RELAY_STATE=Production network restored; exact temporary /32 absent; WireGuard active; proxy/TUN off; Mihomo/runtime Secret config absent (relay-reported, not Executor read-back)
ROOT_CAUSE_1=Mandatory List[object] parameter rejected the initially empty Rows collection before sample 1
ROOT_CAUSE_2=Get-NetRoute exact no-match raises ObjectNotFound with FQID CmdletizationQuery_NotFound,Get-NetRoute instead of returning an empty collection
ACTUAL_CHANGES=Added AllowEmptyCollection to Invoke-Benchmark.Rows; exact no-match normalization in Get-ExactTemporaryRoute; branch-specific cleanup failure markers; updated this Evidence section and current Executor Handoff section
EMPTY_ROWS_PRODUCTION_SHAPE_FIXTURE=PASS
NONEMPTY_ROWS_FIXTURE=PASS
WRONG_TYPE_BINDING_FAIL_CLOSED=PASS
ROUTE_NO_MATCH_FIXTURE=PASS
ROUTE_ONE_MATCH_FIXTURE=PASS
ROUTE_QUERY_UNRELATED_ERROR_FAIL_CLOSED=PASS
ROUTE_NO_MATCH_CLEANUP_FIXTURE=PASS
ROUTE_REMOVE_THEN_NOMATCH_CLEANUP_FIXTURE=PASS
OWNER_ROUTE_QUERY_FAILED_FIXTURE=PASS
OWNER_ROUTE_STATE_INVALID_FIXTURE=PASS
OWNER_ROUTE_REMOVE_FAILED_FIXTURE=PASS
OWNER_ROUTE_POSTREMOVE_VERIFY_FAILED_FIXTURE=PASS
POWERSHELL_AST_PARSE=PASS
SECRET_SCAN=PASS (no Secret values or Secret-bearing artifacts in changed files)
BENCHMARK_LOGIC_UNCHANGED=YES
DPAPI_SECRET_HANDLING_UNCHANGED=YES
MIHOMO_RUNTIME_LOGIC_UNCHANGED=YES
ROUTE_REMOVAL_SCOPE_UNCHANGED=YES
FINAL_NETWORK_ACCEPTANCE_UNCHANGED=YES
BENCHMARK_STARTED=NO
OWNER_PREFLIGHT_EXECUTED=NO
SECRET_ACCESSED=NO
MIHOMO_STARTED=NO
NETWORK_CHANGED=NO
REVIEWER_HANDOFF_MODIFIED_BY_EXECUTOR=NO
ROLLBACK_EFFECT=Revert only this Gate's runner and Executor record changes; preserve Reviewer relay/history, the original checkout's untracked results, and all Windows/VPS network state
EXECUTOR_RESULT=PASS_CANDIDATE_G2B_RUNNER_BINDING_AND_CLEANUP_NOMATCH_REPAIR
STOP_AT_REVIEWER=YES
```


## G2-B runtime ACL owner repair

AUTHORIZED_GATE: G2B_Runtime_Acl_Owner_Repair
PREFLIGHT_FACTS:
- Owner full G2-B retry reached WG benchmark and completed 60/60 WireGuard samples.
- The run then failed closed at CREATE_OWNER_ONLY_RUNTIME_CONFIG with OWNER_ACL_OWNER_MISMATCH.
- Cleanup reported OWNER_TEMP_ROUTE_REMOVED=YES, PRODUCTION_WG_RESTORED=YES, plaintext Secret artifacts remaining 0, and no Mihomo start.
- Source review found both New-OwnerOnlyDirectoryAcl and New-OwnerOnlyFileAcl created protected ACLs for the Owner SID but did not explicitly set the security descriptor owner before Set-Acl.

ACTUAL_CHANGES:
- Added SetOwner($script:ownerSid) to both owner-only ACL constructors before access-rule protection/rules are applied.
- No network, Secret, runtime, benchmark, or Owner-host action was performed by this source repair.

VALIDATION:
- Patch is limited to explicit owner assignment in the two ACL constructors.
- Existing allowlist, inheritance protection, FullControl rules, Assert-OwnerOnlyAcl, Secret handling, benchmark logic, and cleanup logic are unchanged.
- A real-host non-secret ACL fixture remains required before the next consequential full retry.

EXECUTOR_RESULT: PASS_CANDIDATE


## G2-B retry after ACL owner repair — HY2 handshake validator return

AUTHORIZED_GATE: G2B_Full_Retry_After_Acl_Repair
PREFLIGHT_FACTS:
- Owner PowerShell 7.6.6 / Administrator / integrity RID 12288 passed.
- Accepted repaired runner/config source identity passed.
- Real-host non-Secret directory and file ACL fixtures both passed before any network mutation.
- Production network baseline passed and the exact temporary VPS /32 WLAN route was created and read back as WLAN_DIRECT.

ACTUAL_EXECUTION:
- Repaired full runner invoked exactly once.
- WireGuard benchmark completed 60/60 with 0 failures.
- Runtime Secret config creation and owner-only ACL validation passed.
- Mihomo test-only local proxy became ready.
- Run failed closed in HY2_OUTER_ROUTE_AND_HANDSHAKE with HY2_HANDSHAKE_DID_NOT_USE_LOCAL_PROXY before any HY2 benchmark sample.

WIREGUARD_METRICS:
- Success 60 / Failures 0
- Median 0.600826s
- P90 0.832286s
- P95 1.111586s
- P99 1.533950s
- >1s 4 / >1.5s 1 / >2s 0

CLEANUP_AND_READBACK:
- Mihomo process stop: YES.
- Runtime Secret config deleted: YES.
- Plaintext Secret artifacts remaining: 0.
- Exact temporary route removed: YES.
- Production WireGuard restored: YES.
- Wrapper fallback route cleanup not needed.
- Non-Secret result artifacts copied: 2.
- Wrapper final readback returned FINAL_PROXY_LISTENER_PRESENT even though runner reported Mihomo stopped.

ANOMALIES:
- The runner currently treats curl %{remote_ip} == 127.0.0.1 as proof that the HTTP proxy was used. curl documentation provides a dedicated %{proxy_used} write-out variable (curl >= 8.7.0), which is a more direct proxy-use invariant; real-host support still needs a read-only check before repair.
- The wrapper final check counts any TCP connection with LocalPort 17890 as a listener, regardless of state. A read-only real-host TCP-state readback is required to distinguish LISTEN residue from TIME_WAIT/other closed-connection residue.

SECRET_VALUES_EMITTED: 0
SECRET_VALUES_COMMITTED: 0
EXECUTOR_RESULT: RETURN_TEST_FAILURE


## G2-B HY2 proxy-use validator diagnostic and repair

AUTHORIZED_GATE: G2B_HY2_Handshake_Validator_Diagnostic
PREFLIGHT_FACTS:
- Real-host PowerShell 7.6.6 remained Administrator-ready.
- curl is 8.21.0 and supports the write-out variable proxy_used.
- Direct no-proxy probe returned proxy_used=0 with native exit 0.
- After the prior runner cleanup: TCP rows on local port 17890 = 0; UDP rows = 0; Mihomo process count = 0; runtime directory absent; runtime config absent.

DIAGNOSIS:
- The runner used curl remote_ip == 127.0.0.1 as proof that an HTTP proxy was used. That is an incidental representation and not the correct invariant for this curl runtime.
- curl proxy_used is available on the verified target and directly expresses whether the proxy path was used.
- The wrapper's previous FINAL_PROXY_LISTENER_PRESENT was not persistent residue. Current authoritative readback shows no TCP/UDP endpoint, no Mihomo process, and no runtime files.
- The wrapper check was also over-broad because it treated every TCP state on LocalPort 17890 as a listener; future wrapper readback must check TCP State=Listen.

ACTUAL_CHANGES:
- Invoke-CurlSample now records curl proxy_used and parses it as 0/1.
- WG samples require ProxyUsed=0; HY2/proxied samples require ProxyUsed=1.
- HY2 handshake path validation now uses ProxyUsed=1 instead of RemoteIp=127.0.0.1.
- Result CSV includes ProxyUsed.
- Runner preflight now treats only TCP State=Listen on 17890 as port occupation; UDP endpoint behavior is unchanged.

VALIDATION:
- Fresh source readback confirms the write-out format, eight-field parser, ProxyUsed property, benchmark guards, handshake guard, CSV field, and Listen-only TCP precheck.
- No network mutation, Secret access, Mihomo start, or benchmark was performed during this diagnostic/repair round.

EXECUTOR_RESULT: PASS_CANDIDATE


## G2-B authorized retry after proxy-use validator repair — 2026-10-02

```text
AUTHORIZED_GATE=G2B_Full_Retry_After_ProxyUse_Repair
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
OWNER_RUNTIME=PowerShell 7.6.6 / Administrator=True / High integrity RID 12288
ACCEPTED_SOURCE_IDENTITY=PASS
NETWORK_BASELINE_PREFLIGHT=PASS
OWNER_TEMP_ROUTE_CREATED=YES
FORMAL_RUNNER_INVOKED=YES
AUTHORIZED_RETRY_CONSUMED=YES

WG_SUCCESS=60
WG_FAILURES=0
WG_MEDIAN=0.604015
WG_P90=0.764660
WG_P95=0.797894
WG_P99=1.333582
WG_GT_1S=1
WG_GT_1_5S=0
WG_GT_2S=0

CLIENT_SECRET_RUNTIME_CREATED=YES
CLIENT_SECRET_RUNTIME_OWNER_ONLY_ACL=PASS
MIHOMO_TEST_PROXY_READY=YES
RUNNER_FAILED_PHASE=HY2_OUTER_ROUTE_AND_HANDSHAKE
RUNNER_FAILURE_CODE=HY2_HANDSHAKE_OR_AUTH_FAILED
HY2_FORMAL_SAMPLES=0
CURRENT_WINDOW_RESULT=INCONCLUSIVE

TEST_MIHOMO_STOPPED=YES
CLIENT_SECRET_RUNTIME_DELETED=YES
PLAINTEXT_SECRET_ARTIFACTS_REMAINING=0
OWNER_TEMP_ROUTE_REMOVED=YES
PRODUCTION_WG_RESTORED=YES
FINAL_OWNER_TEMP_ROUTE_ABSENT=YES
FINAL_PRODUCTION_WIREGUARD=RESTORED
FINAL_TEST_RUNTIME_RESIDUE=ABSENT
CHECKPOINT_CLEANUP_FAILURE_COUNT=0
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
OWNER_CHECKPOINT_RESULT=RETURN_TO_REVIEWER
NON_SECRET_RESULTS_PATH=C:\Users\34707\AppData\Local\vpn-network-optimization\results\g2b-authorized-20261002T094415Z
```

Reviewer interpretation boundary:
- The repaired proxy-use guard did not fail; therefore the request advanced past the `ProxyUsed == 1` assertion.
- The next assertion failed because the proxied curl sample did not satisfy the runner's success condition `curl exit == 0 && HTTP status == 401`.
- Current retained console output does not include that handshake sample's exact curl exit code, HTTP status, or error classification. Do not infer TLS/auth/UDP/server root cause yet.
- Consequential authorization is consumed. No second full retry is authorized.
- Cleanup is accepted from Owner-reported bounded output as clean; formal G2-B PASS is not possible because HY2 sample count remains 0.


## G2-B HY2 handshake-only diagnostic — 2026-10-02

```text
AUTHORIZED_GATE=G2B_HY2_Handshake_Only_Probe
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
OWNER_RUNTIME=PowerShell 7.6.6 / Administrator=True / High integrity RID 12288
ACCEPTED_SOURCE_IDENTITY=PASS
NETWORK_BASELINE_PREFLIGHT=PASS
OWNER_TEMP_ROUTE_CREATED=YES
FORMAL_HANDSHAKE_PROBE_INVOKED=YES
HANDSHAKE_PROBE_AUTHORIZATION_CONSUMED=YES

HANDSHAKE_ONLY_MODE=YES
WG_BENCHMARK_SKIPPED=YES
CLIENT_SECRET_RUNTIME_CREATED=YES
CLIENT_SECRET_RUNTIME_OWNER_ONLY_ACL=PASS
MIHOMO_TEST_PROXY_READY=YES

HY2_HANDSHAKE_PROXY_USED=1
HY2_HANDSHAKE_CURL_EXIT=35
HY2_HANDSHAKE_HTTP_STATUS=000
HY2_HANDSHAKE_ERROR=TLS_ERROR
HY2_HANDSHAKE_TIME_TOTAL=5.001902
HY2_HANDSHAKE_TIME_CONNECT=0.000712
HY2_HANDSHAKE_TIME_APPCONNECT=0.000000
RUNNER_FAILED_PHASE=HY2_OUTER_ROUTE_AND_HANDSHAKE
RUNNER_FAILURE_CODE=HY2_HANDSHAKE_OR_AUTH_FAILED

BENCHMARK_REPLAYED=NO
HY2_FORMAL_SAMPLES=0
TEST_MIHOMO_STOPPED=YES
CLIENT_SECRET_RUNTIME_DELETED=YES
PLAINTEXT_SECRET_ARTIFACTS_REMAINING=0
OWNER_TEMP_ROUTE_REMOVED=YES
PRODUCTION_WG_RESTORED=YES
FINAL_OWNER_TEMP_ROUTE_ABSENT=YES
FINAL_PRODUCTION_WIREGUARD=RESTORED
FINAL_TEST_RUNTIME_RESIDUE=ABSENT
CHECKPOINT_CLEANUP_FAILURE_COUNT=0
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
OWNER_HANDSHAKE_PROBE_RESULT=RETURN_TO_REVIEWER
NON_SECRET_RESULTS_PATH=C:\Users\34707\AppData\Local\vpn-network-optimization\results\g2b-handshake-probe-20261002T100521Z
```

Reviewer interpretation boundary:
- The local HTTP proxy was definitely used (`proxy_used=1`).
- The target HTTPS TLS session never completed (`curl exit 35`, HTTP `000`, app-connect `0`).
- This does not by itself identify whether the Hysteria outbound failed because of server reachability/UDP filtering, Hysteria TLS/pinning/SNI, Hysteria authentication, or another outbound initialization error; Mihomo was configured silent and its stderr was intentionally discarded.
- No benchmark was replayed and cleanup is accepted as clean.


## HY2 server read-only probe SSH trust return — 2026-10-02

```text
AUTHORIZED_GATE=G2B_HY2_Server_ReadOnly_State_Diagnostic
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
SSH_NATIVE_EXIT_CODE=255
SERVER_READONLY_PROBE_RESULT=SSH_HOST_KEY_VERIFY_FAILED
REMOTE_COMMAND_STARTED=NO
REMOTE_STATE_READ=NO
REMOTE_MUTATION=NO
SECRET_READ=NO
```

Reviewer reconciliation:
- This return does not prove host-key drift.
- The new read-only probe connected to `10.66.21.1` without the already accepted control-path alias.
- The previously validated recovery/control script uses `HostName=10.66.21.1` with `HostKeyAlias=24.199.118.137`, preserving strict checking against the existing trusted public-IP host key.
- Repair is limited to restoring those accepted SSH options. No `known_hosts` write or auto-accept is authorized.


## HY2 server read-only state diagnostic — 2026-10-02

```text
AUTHORIZED_GATE=G2B_HY2_Server_ReadOnly_State_Diagnostic
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
TARGET_HOSTNAME=ubuntu-s-1vcpu-512mb-10gb-sfo3
HY2_SERVICE_ACTIVE=active
HY2_SERVICE_ENABLED=enabled
HY2_EXEC_MAIN_STATUS=0
HY2_NRESTARTS=0
HY2_SERVICE_USER=hy2-vpn
HY2_SERVICE_GROUP=hy2-vpn
HY2_UDP_8443_LISTENER_COUNT=1
HY2_UDP_8443_HYSTERIA_COUNT=1
HY2_BINARY_PRESENT=YES
HY2_BINARY_VERSION=UNKNOWN
HY2_CONFIG_PRESENT=YES
HY2_CONFIG_LISTEN_OK=YES
HY2_CONFIG_SNI_GUARD_STRICT=YES
HY2_CONFIG_AUTH_TYPE_PASSWORD=YES
HY2_CONFIG_AUTH_FORMAT_VALID=YES
HY2_CONFIG_CERT_PATH_OK=YES
HY2_CONFIG_KEY_PATH_OK=YES
HY2_CERT_PRESENT=YES
HY2_KEY_PRESENT=YES
HY2_CERT_FINGERPRINT_MATCH=YES
HY2_CERT_SAN_MATCH=YES
UFW_ACTIVE=NO
UFW_8443_UDP_ALLOW_RULES=0
UFW_8443_UDP_DENY_RULES=0
NFT_8443_UDP_ACCEPT_RULES=0
NFT_8443_UDP_DROP_RULES=0
IPTABLES_8443_UDP_ACCEPT_RULES=0
IPTABLES_8443_UDP_DROP_RULES=0
READ_ONLY_MUTATION=NO
SECRET_VALUES_EMITTED=0
SSH_NATIVE_EXIT_CODE=0
SERVER_READONLY_PROBE_RESULT=COMPLETE
```

Reviewer interpretation:
- Server-side Hysteria runtime is healthy: service active/enabled, ExecMainStatus 0, no restarts, one UDP 8443 listener owned by Hysteria.
- Accepted server config shape is intact: port 8443, strict SNI guard, password auth, expected certificate/key paths, valid auth format.
- Current certificate fingerprint and SAN match the accepted client metadata.
- No host-level UFW/nft/iptables evidence of UDP 8443 being explicitly blocked.
- The remaining primary fault domain is therefore client-to-server Hysteria/UDP initialization or a provider/network-path issue outside the host firewall.
- HY2 binary version string was not returned by this probe; this is not enough to explain the current failure because the service is active and its accepted deployment identity remains otherwise intact.


## HY2 UDP arrival probe — 2026-10-02

```text
AUTHORIZED_GATE=G2B_HY2_UDP_Arrival_Probe
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
ACCEPTED_SOURCE_IDENTITY=PASS
NETWORK_BASELINE_PREFLIGHT=PASS
OWNER_TEMP_ROUTE_CREATED=YES
UDP_OBSERVER_READY=YES
FORMAL_UDP_ARRIVAL_HANDSHAKE_INVOCATION=YES

HANDSHAKE_ONLY_MODE=YES
WG_BENCHMARK_SKIPPED=YES
CLIENT_SECRET_RUNTIME_CREATED=YES
CLIENT_SECRET_RUNTIME_OWNER_ONLY_ACL=PASS
MIHOMO_TEST_PROXY_READY=YES
HY2_HANDSHAKE_PROXY_USED=1
HY2_HANDSHAKE_CURL_EXIT=35
HY2_HANDSHAKE_HTTP_STATUS=000
HY2_HANDSHAKE_ERROR=TLS_ERROR
HY2_HANDSHAKE_TIME_TOTAL=5.002079
HY2_HANDSHAKE_TIME_CONNECT=0.000719
HY2_HANDSHAKE_TIME_APPCONNECT=0.000000

UDP_OBSERVER_INBOUND_EXIT=124
UDP_OBSERVER_OUTBOUND_EXIT=124
UDP_OBSERVER_PAYLOAD_CAPTURED=NO
UDP_8443_INBOUND_SEEN=NO
UDP_8443_OUTBOUND_SEEN=NO

BENCHMARK_REPLAYED=NO
TEST_MIHOMO_STOPPED=YES
CLIENT_SECRET_RUNTIME_DELETED=YES
PLAINTEXT_SECRET_ARTIFACTS_REMAINING=0
OWNER_TEMP_ROUTE_REMOVED=YES
PRODUCTION_WG_RESTORED=YES
FINAL_OWNER_TEMP_ROUTE_ABSENT=YES
FINAL_PRODUCTION_WIREGUARD=RESTORED
FINAL_TEST_RUNTIME_RESIDUE=ABSENT
CHECKPOINT_CLEANUP_FAILURE_COUNT=0
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
UDP_ARRIVAL_PROBE_AUTHORIZATION_CONSUMED=YES
OWNER_UDP_ARRIVAL_PROBE_RESULT=RETURN_TO_REVIEWER
NON_SECRET_RESULTS_PATH=C:\Users\34707\AppData\Local\vpn-network-optimization\results\g2b-udp-arrival-probe-20261002T103009Z
```

Reviewer interpretation:
- Local curl definitely used the local Mihomo proxy.
- Mihomo attempted the HY2 outbound, but no UDP packet with destination port 8443 reached the VPS public interface during the observation window.
- Because inbound UDP/8443 was not seen on eth0, current failure occurs before Hysteria server processing. Server TLS/auth/SNI configuration is therefore not the active fault domain for this run.
- Primary remaining fault domains are external to the Hysteria process: Windows/WLAN egress path, local/router/ISP UDP handling, or provider-side/cloud firewall filtering before packets reach the droplet.
- Cleanup and production WireGuard restoration passed.
