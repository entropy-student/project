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


## DigitalOcean Cloud Firewall read-only check — 2026-10-02

```text
AUTHORIZED_GATE=G2B_DigitalOcean_Cloud_Firewall_ReadOnly_Check
PROVENANCE=OWNER_PROVIDED_DIGITALOCEAN_SCREENSHOT
TARGET_DROPLET_PUBLIC_IP=24.199.118.137
DO_CLOUD_FIREWALL_ATTACHED=NO
DO_UDP_8443_INBOUND_ALLOWED=NOT_APPLICABLE
DO_UDP_51820_INBOUND_ALLOWED=NOT_APPLICABLE
PROVIDER_MUTATION=NO
```

Reviewer interpretation:
- The target Droplet networking page explicitly shows that no DigitalOcean Cloud Firewall is assigned.
- Therefore DigitalOcean Cloud Firewall cannot explain why the previous UDP/8443 arrival probe saw no packets on the Droplet eth0 interface.
- With the Droplet-local Hysteria service/listener healthy and no provider firewall attached, the remaining primary boundary is before the Droplet: Windows/Mihomo egress, local WLAN/router/NAT, ISP/upstream UDP handling, or other provider-path filtering not represented by a Droplet Cloud Firewall.


## Windows UDP8443 egress probe — pktmon preflight return — 2026-10-02

```text
AUTHORIZED_GATE=G2B_Windows_UDP8443_Egress_Probe
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
ACCEPTED_SOURCE_IDENTITY=PASS
CHECKPOINT_RETURN_STAGE=NETWORK_BASELINE_PREFLIGHT
CHECKPOINT_RETURN_CODE=PKTMON_ACTIVE_OR_STATUS_UNCLEAR
FINAL_WINDOWS_UDP_OBSERVER_CLEAN=YES
FINAL_OWNER_TEMP_ROUTE_ABSENT=YES
FINAL_PRODUCTION_WIREGUARD=RESTORED
FINAL_TEST_RUNTIME_RESIDUE=ABSENT
RUNNER_INVOKED=NO
RUNNER_COMPLETED=NO
WINDOWS_EGRESS_PROBE_INVOKED=NO
CHECKPOINT_CLEANUP_FAILURE_COUNT=0
OWNER_WINDOWS_EGRESS_PROBE_RESULT=RETURN_TO_REVIEWER
```

Reviewer interpretation:
- No HY2 handshake was sent; standing Owner authorization for the current Gate remains available.
- Return occurred before any pktmon mutation because the checkpoint could not safely classify the localized/current `pktmon status` output as inactive.
- Cleanup/read-back is clean. Next step is read-only capture of `pktmon status` and `pktmon filter list` text, then repair the preflight parser or select a language-independent state check.


## Windows pktmon localized-state read-only check — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
PKTMON_STATUS=数据包监视器没有运行。
PKTMON_FILTER_LIST_HEADER=数据包筛选器:
PKTMON_FILTER_LIST_VALUE=无
PKTMON_RUNNING=NO
PKTMON_EXISTING_FILTERS=NO
NETWORK_MUTATION=NO
HY2_HANDSHAKE_SENT=NO
```

Reviewer interpretation:
- The prior checkpoint return was a localization-parser false negative.
- Windows Packet Monitor is currently inactive and has no existing filters.
- The checkpoint parser was repaired to recognize these zh-CN outputs.
- Standing Owner authorization for the current Gate remains valid because no handshake was sent.


## Windows UDP8443 egress probe — second pktmon preflight return — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
CHECKPOINT_RETURN_STAGE=NETWORK_BASELINE_PREFLIGHT
CHECKPOINT_RETURN_CODE=PKTMON_ACTIVE_OR_STATUS_UNCLEAR
RUNNER_INVOKED=NO
WINDOWS_EGRESS_PROBE_INVOKED=NO
FINAL_WINDOWS_UDP_OBSERVER_CLEAN=YES
FINAL_OWNER_TEMP_ROUTE_ABSENT=YES
FINAL_PRODUCTION_WIREGUARD=RESTORED
FINAL_TEST_RUNTIME_RESIDUE=ABSENT
CHECKPOINT_CLEANUP_FAILURE_COUNT=0
```

Reviewer interpretation:
- No handshake was sent and standing authorization remains valid.
- Manual Owner read-back immediately before this run already proved pktmon inactive and filter list empty.
- Repeated return is caused by localized/captured text decoding, not real pktmon activity.
- Parser is replaced with language-independent output-structure checks while retaining fail-closed behavior.


## Windows UDP8443 egress probe — pktmon counters result — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
PKTMON_PREFLIGHT=PASS
NETWORK_BASELINE_PREFLIGHT=PASS
OWNER_TEMP_ROUTE_CREATED=YES
WINDOWS_UDP_OBSERVER_READY=YES
FORMAL_WINDOWS_EGRESS_HANDSHAKE_INVOCATION=YES
HANDSHAKE_ONLY_MODE=YES
WG_BENCHMARK_SKIPPED=YES
MIHOMO_TEST_PROXY_READY=YES
HY2_HANDSHAKE_PROXY_USED=1
HY2_HANDSHAKE_CURL_EXIT=35
HY2_HANDSHAKE_HTTP_STATUS=000
HY2_HANDSHAKE_ERROR=TLS_ERROR
WINDOWS_UDP_8443_OUTBOUND_SEEN=NO
WINDOWS_UDP_8443_INBOUND_SEEN=NO
PKTMON_MAX_NIC_TX_PACKETS=0
PKTMON_MAX_NIC_RX_PACKETS=0
PKTMON_PAYLOAD_CAPTURED=NO
WINDOWS_UDP_OBSERVER_STOPPED=YES
FINAL_WINDOWS_UDP_OBSERVER_CLEAN=YES
FINAL_OWNER_TEMP_ROUTE_ABSENT=YES
FINAL_PRODUCTION_WIREGUARD=RESTORED
FINAL_TEST_RUNTIME_RESIDUE=ABSENT
CHECKPOINT_CLEANUP_FAILURE_COUNT=0
OWNER_WINDOWS_EGRESS_PROBE_RESULT=RETURN_TO_REVIEWER
```

Reviewer interpretation:
- The exact Packet Monitor filter shape is valid for matching either source/destination IP and port.
- However the checkpoint parsed localized human-readable `pktmon counters --type flow` text with a narrow regex. A zero result can therefore be a parser false-negative and is not accepted as proof that Windows emitted no UDP/8443.
- Do not change Mihomo/HY2 based on this pktmon result alone.
- Next diagnostic is a controlled raw UDP/8443 path probe: one small Windows UDP datagram with simultaneous VPS packet-presence observation. It does not use Mihomo or any Secret and stays within the standing-authorized current egress Gate.


## Raw UDP8443 path-control result — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
RAW_UDP_CONTROL_PREFLIGHT=PASS
OWNER_TEMP_ROUTE_CREATED=YES
RAW_UDP_OBSERVER_READY=YES
RAW_UDP_WINDOWS_SEND_BYTES=28
RAW_UDP_WINDOWS_SEND_CALL=PASS
RAW_UDP_OBSERVER_EXIT=124
RAW_UDP_OBSERVER_PAYLOAD_CAPTURED=NO
RAW_UDP_8443_VPS_INBOUND_SEEN=NO
RAW_UDP_PATH_CONTROL_COMPLETE=YES
RAW_UDP_OBSERVER_STOPPED=YES
FINAL_OWNER_TEMP_ROUTE_ABSENT=YES
FINAL_PRODUCTION_WIREGUARD=RESTORED
CLEANUP_FAILURE_COUNT=0
OWNER_RAW_UDP_CONTROL_RESULT=COMPLETE
```

Reviewer interpretation:
- This control did not use Mihomo, Hysteria, DPAPI Secret, or pktmon.
- Windows accepted a 28-byte UDP send to the target VPS public IP on port 8443 while the exact temporary /32 route was installed.
- Simultaneous VPS eth0 observation saw no inbound UDP/8443 packet.
- Therefore the active fault is outside Hysteria/Mihomo application processing.
- A successful UdpClient Send call alone does not prove the datagram physically exited the WLAN NIC, so ISP/upstream filtering is not yet conclusively proven.
- Next diagnostic is a same-host/same-route raw UDP port comparison against UDP/51820, which is the known-working WireGuard port, while observing both ports on VPS eth0.


## Raw UDP 51820 vs 8443 comparison — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
RAW_UDP_PORT_COMPARE_PREFLIGHT=PASS
OWNER_TEMP_ROUTE_CREATED=YES
RAW_UDP_COMPARE_OBSERVER_READY=YES
RAW_UDP_PORT_51820_WINDOWS_SEND_BYTES=7
RAW_UDP_PORT_51820_LOCAL_ADDRESS=192.168.1.4
RAW_UDP_PORT_51820_WINDOWS_SEND_CALL=PASS
RAW_UDP_PORT_8443_WINDOWS_SEND_BYTES=7
RAW_UDP_PORT_8443_LOCAL_ADDRESS=192.168.1.4
RAW_UDP_PORT_8443_WINDOWS_SEND_CALL=PASS
RAW_UDP_51820_OBSERVER_EXIT=124
RAW_UDP_8443_OBSERVER_EXIT=124
RAW_UDP_COMPARE_PAYLOAD_CAPTURED=NO
RAW_UDP_51820_VPS_INBOUND_SEEN=NO
RAW_UDP_8443_VPS_INBOUND_SEEN=NO
RAW_UDP_PORT_COMPARE_CLASSIFICATION=RAW_CONTROL_PATH_NOT_REACHING_VPS
RAW_UDP_PORT_COMPARE_COMPLETE=YES
RAW_UDP_COMPARE_OBSERVER_STOPPED=YES
FINAL_OWNER_TEMP_ROUTE_ABSENT=YES
FINAL_PRODUCTION_WIREGUARD=RESTORED
CLEANUP_FAILURE_COUNT=0
OWNER_RAW_UDP_PORT_COMPARE_RESULT=COMPLETE
```

Reviewer interpretation:
- Synthetic UDP datagrams bound explicitly to WLAN address 192.168.1.4 did not reach VPS eth0 on either destination port 51820 or 8443.
- This disproves a simple UDP/8443-only filter hypothesis.
- Production WireGuard to UDP/51820 remains healthy, so generic upstream UDP failure is also not proven.
- The remaining discriminator is whether the synthetic datagram reaches the Windows WLAN NIC transmit path. A local header-only pktmon capture can answer this without relying on localized counters text.


## pktmon JSON diagnostic — route-selection preflight return — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
PKTMON_JSON_DIAGNOSTIC_PREFLIGHT=PASS
PKTMON_JSON_DIAGNOSTIC_RETURN_CODE=VPS_ROUTE_SELECTION_AMBIGUOUS
FINAL_PKTMON_STATE_CLEAN=YES
FINAL_OWNER_TEMP_ROUTE_ABSENT=YES
FINAL_PRODUCTION_WIREGUARD=RESTORED
CLEANUP_FAILURE_COUNT=0
OWNER_PKTMON_JSON_DIAGNOSTIC_RESULT=COMPLETE
```

Reviewer interpretation:
- The probe stopped before pktmon start and before any synthetic UDP send.
- The exact temporary /32 route was created and later removed cleanly; production WireGuard was restored.
- `Find-NetRoute` returned more than one selectable result in this environment, so its cardinality check is too strict for this diagnostic.
- This check is redundant because the exact ActiveStore /32 route is already verified and the diagnostic UDP socket binds explicitly to WLAN address 192.168.1.4.
- The terminal `COMPLETE` marker is a script bug: it currently reflects cleanup success even when the diagnostic body returned. The next revision must return `RETURN_TO_REVIEWER` unless the diagnostic itself reaches completion.
- No UDP probe was sent; standing Owner authorization remains valid.


## pktmon NIC-only JSON egress diagnostic — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
PKTMON_JSON_DIAGNOSTIC_PREFLIGHT=PASS
OWNER_TEMP_ROUTE_CREATED=YES
VPS_EXACT_ROUTE_READBACK=WLAN_DIRECT
RAW_UDP_SOCKET_BIND_TARGET=192.168.1.4
PKTMON_JSON_OBSERVER_READY=YES
RAW_UDP_8443_WINDOWS_SEND_BYTES=7
RAW_UDP_8443_LOCAL_ADDRESS=192.168.1.4
RAW_UDP_8443_WINDOWS_SEND_CALL=PASS
PKTMON_COUNTERS_JSON_VALID=YES
PKTMON_COUNTERS_JSON=[]
PKTMON_JSON_OBSERVER_STOPPED=YES
PKTMON_PACKET_LOGGING=NO
PKTMON_JSON_DIAGNOSTIC_COMPLETE=YES
FINAL_PKTMON_STATE_CLEAN=YES
FINAL_OWNER_TEMP_ROUTE_ABSENT=YES
FINAL_PRODUCTION_WIREGUARD=RESTORED
DIAGNOSTIC_COMPLETED=YES
CLEANUP_FAILURE_COUNT=0
OWNER_PKTMON_JSON_DIAGNOSTIC_RESULT=COMPLETE
```

Reviewer interpretation:
- With pktmon restricted to NIC components, no matching UDP/8443 counter appeared anywhere at the NIC layer.
- The synthetic socket send still succeeded and was explicitly bound to WLAN address 192.168.1.4 with an exact WLAN /32 route.
- This strongly shifts the active fault domain toward the Windows networking stack before the physical NIC, but NIC-only monitoring cannot identify the exact internal component.
- Next diagnostic changes only pktmon component scope from `nics` to `all`, still counters-only/no packet logging, so JSON can reveal whether the matching datagram appears at protocol/filter components and whether a drop reason is reported.


## pktmon all-component JSON diagnostic — JSON formatting return — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
PKTMON_JSON_DIAGNOSTIC_PREFLIGHT=PASS
OWNER_TEMP_ROUTE_CREATED=YES
VPS_EXACT_ROUTE_READBACK=WLAN_DIRECT
RAW_UDP_SOCKET_BIND_TARGET=192.168.1.4
PKTMON_COMPONENT_SCOPE=ALL
PKTMON_JSON_OBSERVER_READY=YES
RAW_UDP_8443_WINDOWS_SEND_BYTES=7
RAW_UDP_8443_LOCAL_ADDRESS=192.168.1.4
RAW_UDP_8443_WINDOWS_SEND_CALL=PASS
PKTMON_JSON_DIAGNOSTIC_RETURN_CODE=PKTMON_COUNTERS_JSON_INVALID
FINAL_PKTMON_STATE_CLEAN=YES
FINAL_OWNER_TEMP_ROUTE_ABSENT=YES
FINAL_PRODUCTION_WIREGUARD=RESTORED
DIAGNOSTIC_COMPLETED=NO
CLEANUP_FAILURE_COUNT=0
OWNER_PKTMON_JSON_DIAGNOSTIC_RESULT=RETURN_TO_REVIEWER
```

Reviewer interpretation:
- The synthetic UDP send did occur with pktmon monitoring all networking components.
- Failure occurred only when parsing `pktmon counters --json`; Microsoft documentation confirms this syntax should be supported, so the current blocker is output representation/encoding rather than the traffic reproduction.
- Next run keeps the same traffic reproduction and all-component counters-only monitoring, but emits the native human-readable counters table verbatim without machine parsing.


## pktmon all-component counters — local outbound drop proven — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
TARGET_COMPONENT=Realtek 8852CE WiFi 6E PCI-E NIC
PKTMON_COMPONENT=TCP/IPv4 - L3/L4
PKTMON_COUNTER=DROP
RX_PACKETS=0
RX_BYTES=0
TX_PACKETS=1
TX_BYTES=15
SYNTHETIC_UDP_PAYLOAD_BYTES=7
EXPECTED_UDP_L4_BYTES=15
DROP_REASON_RENDERING=MOJIBAKE_CONSISTENT_WITH_INSPECTION_DROP
PKTMON_TEXT_DIAGNOSTIC_COMPLETE=YES
FINAL_PKTMON_STATE_CLEAN=YES
FINAL_OWNER_TEMP_ROUTE_ABSENT=YES
FINAL_PRODUCTION_WIREGUARD=RESTORED
DIAGNOSTIC_COMPLETED=YES
CLEANUP_FAILURE_COUNT=0
```

Reviewer interpretation:
- The synthetic 7-byte UDP payload plus 8-byte UDP header equals the observed 15-byte Tx drop counter exactly.
- Therefore the synthetic UDP/8443 datagram reaches Windows TCP/IPv4 L3/L4 processing but is dropped locally before physical WLAN transmission.
- The mojibake token `涓㈠純` round-trips to Chinese `丢弃`. The following mojibake text is consistent with an inspection-drop label, but exact filter ownership is not inferred from mojibake alone.
- Microsoft documents outbound `Inspection drop` as a Windows Filtering Platform inspection result.
- WireGuard for Windows documents a /0 single-peer kill-switch that permits the WireGuard tunnel service itself while blocking other untunneled traffic. This precisely matches the observed asymmetry (production WireGuard UDP works; synthetic direct UDP from PowerShell and HY2/Mihomo do not).
- Next step is read-only confirmation of WireGuard's WFP block filter and /0 route semantics before proposing any repair.


## WireGuard kill-switch root-cause confirmation — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
WG_ROUTE_DEFAULT_V4_0_0_0_0_0=YES
WG_ROUTE_SPLIT_V4_0_0_0_0_1=NO
WG_ROUTE_SPLIT_V4_128_0_0_0_1=NO
WFP_TARGET_BLOCK_ALL_OUTBOUND_IPV4=YES
WFP_TARGET_FILTER_TEXT_HAS_WIREGUARD=YES
WFP_STATE_HAS_WIREGUARD=YES
WFP_STATE_HAS_BLOCK_ALL_OUTBOUND_IPV4=YES
WIREGUARD_KILLSWITCH_CONFIRMATION=CONFIRMED
READ_ONLY_MUTATION=NO
SECRET_VALUES_EMITTED=0
TEMP_WFP_READONLY_ARTIFACTS_REMOVED=YES
FINAL_PRODUCTION_WIREGUARD=UNCHANGED
PROBE_COMPLETED=YES
CLEANUP_FAILURE_COUNT=0
OWNER_WIREGUARD_KILLSWITCH_READONLY_RESULT=COMPLETE
```

Reviewer conclusion:
- Root cause is confirmed: WireGuard for Windows is operating with IPv4 `0.0.0.0/0` full-tunnel semantics and an active WireGuard-owned WFP `Block all outbound (IPv4)` filter.
- This kill-switch permits the WireGuard tunnel service's own outer traffic while blocking other untunneled/direct WLAN egress.
- That exactly explains the entire diagnostic chain: production WireGuard remains healthy while raw UDP and Mihomo/HY2 direct outer UDP are locally dropped before WLAN transmission.
- Hysteria server, UDP/8443 listener, certificate/SNI/auth shape, DigitalOcean Cloud Firewall, VPS host firewall, and ISP/port-specific filtering are no longer the active fault domain.
- Next phase is a minimal reversible client-side routing/security-semantics repair that keeps WireGuard connected while permitting the HY2 outer path.


## WireGuard kill-switch post-repair readback — configuration unchanged — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
WG_ROUTE_DEFAULT_V4_0_0_0_0_0=YES
WG_ROUTE_SPLIT_V4_0_0_0_0_1=NO
WG_ROUTE_SPLIT_V4_128_0_0_0_1=NO
WFP_TARGET_BLOCK_ALL_OUTBOUND_IPV4=YES
WFP_TARGET_FILTER_TEXT_HAS_WIREGUARD=YES
WFP_STATE_HAS_WIREGUARD=YES
WFP_STATE_HAS_BLOCK_ALL_OUTBOUND_IPV4=YES
WIREGUARD_KILLSWITCH_CONFIRMATION=CONFIRMED
READ_ONLY_MUTATION=NO
FINAL_PRODUCTION_WIREGUARD=UNCHANGED
PROBE_COMPLETED=YES
CLEANUP_FAILURE_COUNT=0
```

Reviewer interpretation:
- The running SFO2-A tunnel still has the original IPv4 `0.0.0.0/0` route.
- Neither split default `0.0.0.0/1` nor `128.0.0.0/1` is active.
- WireGuard's WFP `Block all outbound (IPv4)` kill-switch remains active.
- Therefore the intended repair has not yet been applied to the running tunnel; no HY2 retest should be attempted until the configuration is actually changed and the tunnel reloaded.


## WireGuard kill-switch repair verified — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_LOCAL_READBACK
WG_ROUTE_DEFAULT_V4_0_0_0_0_0=NO
WG_ROUTE_SPLIT_V4_0_0_0_0_1=YES
WG_ROUTE_SPLIT_V4_128_0_0_0_1=YES
WFP_TARGET_BLOCK_ALL_OUTBOUND_IPV4=NO
WFP_TARGET_FILTER_TEXT_HAS_WIREGUARD=YES
```

Reviewer conclusion:
- The running SFO2-A tunnel no longer uses the IPv4 `0.0.0.0/0` route.
- The two split defaults `0.0.0.0/1` and `128.0.0.0/1` are active, preserving full IPv4 route coverage.
- WireGuard's target WFP `Block all outbound (IPv4)` kill-switch filter is absent.
- The previously proven local WFP block has therefore been removed successfully while WireGuard remains active.
- Presence of WireGuard text in the target WFP dump is not itself a kill-switch failure; the decisive block filter is absent.
- Next validation: raw UDP/8443 arrival at VPS, then HY2 handshake.


## Raw UDP8443 path validation after WireGuard kill-switch repair — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
RAW_UDP_CONTROL_PREFLIGHT=PASS
OWNER_TEMP_ROUTE_CREATED=YES
RAW_UDP_OBSERVER_READY=YES
RAW_UDP_WINDOWS_SEND_BYTES=28
RAW_UDP_WINDOWS_SEND_CALL=PASS
RAW_UDP_OBSERVER_EXIT=0
RAW_UDP_OBSERVER_PAYLOAD_CAPTURED=NO
RAW_UDP_8443_VPS_INBOUND_SEEN=YES
RAW_UDP_PATH_CONTROL_COMPLETE=YES
RAW_UDP_OBSERVER_STOPPED=YES
FINAL_OWNER_TEMP_ROUTE_ABSENT=YES
FINAL_PRODUCTION_WIREGUARD=RESTORED
CLEANUP_FAILURE_COUNT=0
OWNER_RAW_UDP_CONTROL_RESULT=COMPLETE
```

Reviewer conclusion:
- The direct WLAN path from Owner Windows to VPS public UDP/8443 is now proven working.
- This is the exact path that failed before the WireGuard WFP kill-switch repair.
- The root-cause chain is therefore closed: WireGuard's strict Windows kill-switch was the blocker; replacing IPv4 /0 with two /1 defaults removed that blocker while preserving WireGuard routing.
- Next validation is the real HY2 handshake using the existing protected DPAPI Secret runtime boundary and one temporary Mihomo instance.


## Post-killswitch HY2 handshake checkpoint download reset — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
DOWNLOAD_ENDPOINT=raw.githubusercontent.com
CURL_EXIT=35
CURL_ERROR=Recv failure: Connection was reset
CHECKPOINT_DOWNLOAD_FAILED=YES
HANDSHAKE_SCRIPT_EXECUTED=NO
```

Reviewer interpretation:
- The post-killswitch HY2 handshake checkpoint did not execute.
- This provides no new evidence about HY2.
- The next attempt will fetch the exact same pinned commit via the GitHub Contents API instead of raw.githubusercontent.com, then verify the same Git blob SHA before execution.


## Post-killswitch HY2 handshake — inner source download reset — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
CURL_EXIT=35
CURL_ERROR=Recv failure: Connection was reset
CHECKPOINT_RETURN_STAGE=OWNER_AND_SOURCE_PREFLIGHT
CHECKPOINT_RETURN_CODE=ACCEPTED_SOURCE_DOWNLOAD_FAILED
FINAL_OWNER_TEMP_ROUTE_ABSENT=YES
FINAL_PRODUCTION_WIREGUARD=RESTORED
FINAL_TEST_RUNTIME_RESIDUE=ABSENT
TEMP_CHECKPOINT_WORKSPACE_REMOVED=YES
RUNNER_INVOKED=NO
RUNNER_COMPLETED=NO
CHECKPOINT_CLEANUP_FAILURE_COUNT=0
OWNER_POST_KILLSWITCH_HANDSHAKE_RESULT=RETURN_TO_REVIEWER
```

Reviewer interpretation:
- The outer checkpoint executed successfully.
- Failure occurred before the formal runner invocation because its internal `Download-ExactFile` helper still used raw.githubusercontent.com for the pinned runner/config sources.
- HY2 handshake was not attempted, so there is no new HY2 evidence.
- Cleanup and production WireGuard restoration passed.
- Next revision changes only the internal pinned-source transport from raw.githubusercontent.com to the GitHub Contents API, retaining the same accepted commit and blob SHA checks.


## Post-killswitch HY2 handshake — internal source fetch reset — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
CURL_EXIT=35
CURL_ERROR=Recv failure: Connection was reset
CHECKPOINT_RETURN_STAGE=OWNER_AND_SOURCE_PREFLIGHT
CHECKPOINT_RETURN_CODE=ACCEPTED_SOURCE_DOWNLOAD_FAILED
FINAL_OWNER_TEMP_ROUTE_ABSENT=YES
FINAL_PRODUCTION_WIREGUARD=RESTORED
FINAL_TEST_RUNTIME_RESIDUE=ABSENT
TEMP_CHECKPOINT_WORKSPACE_REMOVED=YES
RUNNER_INVOKED=NO
RUNNER_COMPLETED=NO
CHECKPOINT_CLEANUP_FAILURE_COUNT=0
OWNER_POST_KILLSWITCH_HANDSHAKE_RESULT=RETURN_TO_REVIEWER
```

Reviewer interpretation:
- The outer checkpoint itself executed, but its internal exact-source fetch still used raw.githubusercontent.com and was reset.
- The formal HY2 runner was never invoked, so this is not a handshake failure.
- Cleanup completed and production WireGuard was restored.
- Next revision removes raw.githubusercontent.com from the checkpoint's internal dependency fetch and uses the GitHub Contents API while retaining exact blob-SHA verification.


## Post-killswitch HY2 handshake validation — PASS — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
ACCEPTED_SOURCE_IDENTITY=PASS
NETWORK_BASELINE_PREFLIGHT=PASS
OWNER_TEMP_ROUTE_CREATED=YES
FORMAL_HANDSHAKE_PROBE_INVOCATION=START
PHASE=PRECHECK_PASS
HANDSHAKE_ONLY_MODE=YES
WG_BENCHMARK_SKIPPED=YES
CLIENT_SECRET_RUNTIME_CREATED=YES
CLIENT_SECRET_RUNTIME_OWNER_ONLY_ACL=PASS
MIHOMO_TEST_PROXY_READY=YES
HY2_HANDSHAKE_PROXY_USED=1
HY2_HANDSHAKE_CURL_EXIT=0
HY2_HANDSHAKE_HTTP_STATUS=401
HY2_HANDSHAKE_ERROR=NONE
HY2_HANDSHAKE_TIME_TOTAL=1.900814
HY2_HANDSHAKE_TIME_CONNECT=0.001333
HY2_HANDSHAKE_TIME_APPCONNECT=0.832811
HY2_AUTH=PASS
TLS_CERTIFICATE_PINNING=PASS
HY2_OUTER_ROUTE=WLAN_DIRECT
HY2_BENCHMARK_SKIPPED=YES
HY2_HANDSHAKE_ONLY_COMPLETE=YES
TEST_MIHOMO_STOPPED=YES
CLIENT_SECRET_RUNTIME_DELETED=YES
PLAINTEXT_SECRET_ARTIFACTS_REMAINING=0
OWNER_TEMP_ROUTE_REMOVED=YES
PRODUCTION_WG_RESTORED=YES
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
G2B_OWNER_RUNNER_RESULT=COMPLETE
FINAL_OWNER_TEMP_ROUTE_ABSENT=YES
FINAL_PRODUCTION_WIREGUARD=RESTORED
FINAL_TEST_RUNTIME_RESIDUE=ABSENT
TEMP_CHECKPOINT_WORKSPACE_REMOVED=YES
RUNNER_INVOKED=YES
RUNNER_COMPLETED=YES
CHECKPOINT_CLEANUP_FAILURE_COUNT=0
OWNER_POST_KILLSWITCH_HANDSHAKE_RESULT=COMPLETE
```

Reviewer conclusion:
- HY2 handshake is now proven successful after removal of the WireGuard Windows kill-switch.
- curl exit 0, TLS appconnect completed, HY2 auth passed, certificate pinning passed, and the HY2 outer route was WLAN direct.
- HTTP 401 is the expected unauthenticated response from the target HTTPS endpoint and is not a HY2 transport failure.
- The entire fault chain is closed: the previous TLS_ERROR was caused by the local WireGuard WFP kill-switch preventing HY2 outer UDP from leaving Windows.
- Cleanup was complete and production WireGuard was restored.
- Next step is the formal WG vs HY2 benchmark; do not repeat root-cause diagnostics.


## Post-killswitch same-window WG vs HY2 comparative validation — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
ACCEPTED_SOURCE_IDENTITY=PASS
NETWORK_BASELINE_PREFLIGHT=PASS
OWNER_TEMP_ROUTE_CREATED=YES
FORMAL_COMPARATIVE_VALIDATION_INVOCATION=START
WG_SAMPLES=60
WG_SUCCESS=60
WG_FAILURES=0
WG_MEDIAN=0.796850
WG_P90=1.502720
WG_P95=1.735142
WG_P99=5.745878
WG_GT_1S=15
WG_GT_1_5S=7
WG_GT_2S=1
HY2_HANDSHAKE_CURL_EXIT=0
HY2_HANDSHAKE_HTTP_STATUS=401
HY2_HANDSHAKE_ERROR=NONE
HY2_HANDSHAKE_TIME_TOTAL=1.151337
HY2_HANDSHAKE_TIME_CONNECT=0.000728
HY2_HANDSHAKE_TIME_APPCONNECT=0.852377
HY2_AUTH=PASS
TLS_CERTIFICATE_PINNING=PASS
HY2_OUTER_ROUTE=WLAN_DIRECT
PUBLIC_EXIT_THROUGH_HY2=24.199.118.137
HY2_SAMPLES=60
HY2_SUCCESS=60
HY2_FAILURES=0
HY2_MEDIAN=0.498499
HY2_P90=0.715330
HY2_P95=0.761820
HY2_P99=1.771594
HY2_GT_1S=2
HY2_GT_1_5S=1
HY2_GT_2S=0
CURRENT_WINDOW_RESULT=HY2_BETTER_THIS_WINDOW
PEAK_HOUR_SUPERIORITY_PROVEN=NO
TEST_MIHOMO_STOPPED=YES
CLIENT_SECRET_RUNTIME_DELETED=YES
PLAINTEXT_SECRET_ARTIFACTS_REMAINING=0
OWNER_TEMP_ROUTE_REMOVED=YES
PRODUCTION_WG_RESTORED=YES
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
G2B_OWNER_RUNNER_RESULT=COMPLETE
FINAL_OWNER_TEMP_ROUTE_ABSENT=YES
FINAL_PRODUCTION_WIREGUARD=RESTORED
FINAL_TEST_RUNTIME_RESIDUE=ABSENT
TEMP_CHECKPOINT_WORKSPACE_REMOVED=YES
RUNNER_INVOKED=YES
RUNNER_COMPLETED=YES
CHECKPOINT_CLEANUP_FAILURE_COUNT=0
OWNER_POST_KILLSWITCH_COMPARATIVE_RESULT=COMPLETE
```

Reviewer analysis:
- Both transports completed 60/60 samples with zero failures, zero timeouts, zero resets, and no failure streak.
- HY2 dominated WireGuard on every measured latency/tail metric in this same window: median 0.498499s vs 0.796850s; P90 0.715330s vs 1.502720s; P95 0.761820s vs 1.735142s; P99 1.771594s vs 5.745878s.
- Relative to WireGuard in this window, HY2 reduced median by about 37.4%, P90 by 52.4%, P95 by 56.1%, and P99 by 69.2%.
- Tail-count improvement was also material: >1s 2 vs 15; >1.5s 1 vs 7; >2s 0 vs 1.
- The runner's deterministic comparator classified this window as `HY2_BETTER_THIS_WINDOW`.
- This does not prove universal or peak-hour superiority; the runner explicitly reports `PEAK_HOUR_SUPERIORITY_PROVEN=NO`.
- The Windows UDP/8443 egress fault Gate is resolved and can be closed. G2-B safe-window network comparison has positive evidence; final v1 sealing should still preserve the distinction between this same-window network result and any separate peak-hour / real Codex workload validation required by project scope.


## G2-C VLESS+REALITY read-only preflight — PASS — 2026-10-02

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
WINDOWS_ADMINISTRATOR=YES
POWERSHELL_VERSION=7.6.6
SSH_LOCAL_FILES=PASS
WINDOWS_WIREGUARD_BASELINE=PASS
SSH_CONNECTION_OK=YES
REMOTE_USER=root
REMOTE_UID=0
REMOTE_HOSTNAME=ubuntu-s-1vcpu-512mb-10gb-sfo3
REMOTE_OS=Ubuntu 24.04.5 LTS
REMOTE_KERNEL=6.8.0-142-generic
REMOTE_ARCH=x86_64
WG0_PRESENT=YES
WG_SERVICE_ACTIVE=YES
UDP_51820_LISTENER=YES
HY2_SERVICE_ACTIVE=YES
UDP_8443_LISTENER=YES
TCP_443_FREE=YES
TCP_443_LISTENER_COUNT=0
TCP_443_OWNER_NAMES=NONE
SING_BOX_PRESENT=NO
SING_BOX_VERSION=NONE
XRAY_PRESENT=NO
XRAY_VERSION=NONE
MIHOMO_SERVER_PRESENT=NO
MIHOMO_SERVER_VERSION=NONE
NTP_SYNCHRONIZED=yes
MEM_AVAILABLE_KIB=259660
ROOT_FREE_KIB=7013936
UFW_STATE=INACTIVE
NFT_TCP443_RULE_COUNT=0
IPTABLES_TCP443_RULE_COUNT=0
READ_ONLY_MUTATION=NO
SECRET_VALUES_EMITTED=0
SSH_NATIVE_EXIT=0
G2C_TCP443_PREFLIGHT=PASS
OWNER_G2C_VLESS_REALITY_PREFLIGHT_RESULT=COMPLETE
```

Reviewer conclusion:
- Preflight PASS. The accepted strict SSH identity/trust path remains usable with native exit 0 and root target identity.
- Existing WireGuard and HY2 production/candidate services remain healthy on UDP 51820 and UDP 8443.
- TCP/443 is free with no listener and no matching nftables/iptables rule conflict.
- sing-box, Xray, and server-side Mihomo are not installed, so there is no existing server-core collision to preserve.
- Time synchronization is healthy. Root filesystem has about 6.69 GiB free. MemAvailable is about 254 MiB on this small VPS; later deployment must keep the side-by-side service footprint small and include resource read-back.
- No target mutation occurred and no Secret value was emitted.
- G2-C may proceed to a separately authorized side-by-side deployment design on TCP/443.


## G2-C private REALITY compatibility canary authorization — 2026-10-02

```text
AUTHORIZED_GATE=G2C_PRIVATE_REALITY_COMPAT_CANARY
OWNER_AUTHORIZATION=GRANTED
PUBLIC_TCP443_EXPOSURE=NOT_AUTHORIZED
MAX_ENDPOINT=temporary 10.66.21.1:14443 canary + one proxied HTTPS handshake + exact cleanup + Reviewer stop
PINNED_SERVER_CORE=sing-box v1.14.2 stable linux-amd64-glibc
PINNED_ASSET_SHA256=5c7bc18461827b28d0e5ee7e89d33b276d3ff7c818531104c8e8d26d85b0656e
```

No consequential execution is claimed by this authorization record. Executor must append the actual runtime Evidence after execution.

## G2-C private REALITY compatibility canary — preflight blocked (2026-10-02)

```text
AUTHORIZED_GATE=G2C_PRIVATE_REALITY_COMPAT_CANARY
PROJECT_REPOSITORY=entropy-student/project
CANONICAL_GIT_ROOT=C:\Users\34707\Documents\ChatGPT\VPS搭建
EXECUTION_WORKTREE=C:\Users\34707\.codex\worktrees\g2b-runner-binding-cleanup\VPS搭建
PUSH_TARGET_BRANCH=main
PRE_GATE_HEAD=fc030c28ab010047f38d80c3e2abb2c8f389376f
SOURCE_PROVENANCE=PASS (origin verified; isolated managed worktree; original checkout's untracked results preserved)
REVIEWER_RELAY=Current G2-C gate and its accepted G2-C preflight facts only; no historical Gate reread
PREFLIGHT_SCRIPT=scripts/g2c-vless-reality-preflight.ps1
PREFLIGHT_RESULT=RETURN_ADMINISTRATOR_ELEVATION_REQUIRED
WINDOWS_ADMINISTRATOR_TOKEN=NO
WINDOWS_INTEGRITY=MEDIUM / RID 8192
SSH_NATIVE_STARTED=NO
REMOTE_PREFLIGHT=NOT_RUN
SING_BOX_DOWNLOAD=NO
SING_BOX_EXECUTED=NO
SERVER_SECRET_GENERATED=NO
SERVER_RUNTIME_CONFIG_CREATED=NO
PRIVATE_LISTENER_CREATED=NO
MIHOMO_STARTED=NO
CLIENT_RUNTIME_CONFIG_CREATED=NO
REALITY_HANDSHAKE=NOT_RUN
BENCHMARK_STARTED=NO
NETWORK_CHANGED=NO
PUBLIC_TCP443_CHANGED=NO
WIREGUARD_OR_HY2_CHANGED=NO
SYSTEM_PROXY_OR_TUN_CHANGED=NO
CLEANUP_REQUIRED=NO (no canary artifacts/processes were created)
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
ACTUAL_CHANGES=Updated only EXECUTION_EVIDENCE.md and EXECUTOR_HANDOFF.md with the preflight blocker
REVIEWER_HANDOFF_MODIFIED=NO
EXECUTOR_RESULT=RETURN_G2C_WINDOWS_ADMIN_PREFLIGHT_BLOCKED
REQUIRED_NEXT_CONTEXT=Elevated Windows PowerShell must pass the named preflight before any canary action
STOP_AT_REVIEWER=YES
```


## Reviewer reconciliation — G2-C admin preflight return — 2026-10-03

```text
REVIEWED_COMMIT=181554b265ce9f7c9f8978186943d7dd87d540d0
EXECUTOR_RESULT=RETURN_G2C_WINDOWS_ADMIN_PREFLIGHT_BLOCKED
REVIEWER_CLASSIFICATION=PREFLIGHT_TOOLING_OVERCONSTRAINT
TARGET_RUNTIME_DRIFT_PROVEN=NO
CONSEQUENTIAL_ACTION_STARTED=NO
SSH_STARTED=NO
SECRET_ACCESSED=NO
VPS_CHANGED=NO
WINDOWS_NETWORK_CHANGED=NO
OWNER_AUTHORIZATION_REMAINS_VALID=YES
ADMINISTRATOR_REQUIRED_FOR_RETRY=NO
SAME_GATE_BOUNDED_RETRY=AUTHORIZED
PUBLIC_TCP443_EXPOSURE=NOT_AUTHORIZED
```

Reviewer reasoning:
- The accepted canary Gate itself does not require any Windows route/firewall/service/TUN/system-proxy mutation.
- The failed attempt stopped before SSH or any consequential action and therefore does not create ambiguous partial target state.
- The blocker came from executing the earlier `g2c-vless-reality-preflight.ps1` Administrator assertion as if it were a canary acceptance requirement. In the current Gate that script is only a reference for the strict SSH/runtime pattern.
- Medium-integrity Windows execution is sufficient for user-space Mihomo, current-owner-only ephemeral runtime files, and strict SSH, subject to the exact read-backs already required by the Gate.
- Retry stays inside the existing Owner-authorized Gate and must still fail closed if a specific operation independently proves elevation is actually required.


## G2-C private REALITY compatibility canary — bounded execution — 2026-10-03

```text
AUTHORIZED_GATE=G2C_PRIVATE_REALITY_COMPAT_CANARY
SOURCE_BRANCH=codex/g2c-private-reality-compat-canary
PRE_GATE_HEAD=cabd36f1f25be6b312ae83846e68f1b738462c4e
WINDOWS_RUNTIME=PowerShell 7.6.5 / Medium integrity RID 8192 / Administrator=False
LOCAL_CONTROL_ROUTE=10.66.21.1 via SFO2-A ifIndex 13
WIREGUARD_MANAGER=Running
WIREGUARD_TUNNEL=Running
WIREGUARD_ADAPTER=SFO2-A / Up / ifIndex 13
SYSTEM_PROXY_ENABLE=0
WINHTTP_DIRECT=YES
TUN_ADAPTER_COUNT=0
MIHOMO=Mihomo Meta v1.19.31
SSH_CONTROL=10.66.21.1:22 / StrictHostKeyChecking=yes / HostKeyAlias=24.199.118.137
SSH_HOST_KEY_TRUST=PASS
TARGET_HOSTNAME=ubuntu-s-1vcpu-512mb-10gb-sfo3
TARGET_OS=Ubuntu 24.04.5 LTS
TARGET_KERNEL=6.8.0-142-generic
TARGET_DEFAULT_ROUTE=default via 24.199.112.1 dev eth0 proto static
TARGET_WG_ROUTE=10.66.21.0/24 proto kernel scope link src 10.66.21.1
WG_SERVICE=active
HY2_SERVICE=active
UDP_51820_LISTENERS=2
UDP_8443_LISTENERS=1
TCP_443_LISTENER_BEFORE=0
MEM_AVAILABLE_KIB=267676
TMP_FREE_KIB=7013704
SING_BOX_VERSION=1.14.2
PINNED_ASSET_SHA256=5c7bc18461827b28d0e5ee7e89d33b276d3ff7c818531104c8e8d26d85b0656e / VERIFIED
SERVER_CONFIG_CHECK=PASS
PRIVATE_LISTENER=10.66.21.1:14443 / PASS
PUBLIC_14443_LISTENER=NO
PUBLIC_TCP443_LISTENER=NO
MIHOMO_CONFIG_CHECK=PASS
MIHOMO_TEST_PROXY=127.0.0.1:17990 / HTTP-only / READY
PROXIED_HTTPS_REQUESTS=1
REQUEST_ENDPOINT=https://api.openai.com/v1/models
CURL_EXIT=35
HTTP_STATUS=0
CURL_TIME_TOTAL_SECONDS=5.002776
CURL_TIME_CONNECT_SECONDS=0.000937
CURL_TIME_APPCONNECT_SECONDS=0.000000
REALITY_HANDSHAKE=NOT_PROVEN
CLIENT_INTEROPERABILITY=NOT_PROVEN
BENCHMARK_STARTED=NO
PERFORMANCE_CONCLUSION=NONE
TEST_MIHOMO_STOPPED=YES
CLIENT_SECRET_RUNTIME_DELETED=YES
REMOTE_CANARY_PROCESS_CONFIG_BINARY_REMOVED=YES
REMOTE_G2C_RUN_PATHS_ABSENT=YES
TCP_14443_POSTCLEANUP_LISTENERS=0
TCP_443_POSTCLEANUP_LISTENERS=0
WG_HY2_POSTCLEANUP=PASS
LOCAL_ROUTE_PROXY_TUN_POSTCLEANUP=PASS
PUBLIC_TCP443_CHANGED=NO
FIREWALL_CHANGED=NO
ROUTES_CHANGED=NO
WIREGUARD_OR_HY2_CHANGED=NO
SYSTEM_PROXY_OR_TUN_CHANGED=NO
LIVE_SYSTEM_TUNING_APPLIED=NO
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
EXECUTOR_RESULT=RETURN_G2C_PRIVATE_REALITY_HANDSHAKE_CURL_EXIT_35
STOP_AT_REVIEWER=YES
```

Execution notes:
- The first local-only preflight attempt exposed an empty-array scalarization false positive in the runner's TUN adapter count; the helper was minimally corrected and empty/one-match fixtures passed. No remote action occurred in that attempt.
- A subsequent read-only VPS preflight exposed a `pgrep -c` zero-result fallback that rendered the marker as `00`; the shell fallback was corrected. A targeted read-only check found zero `sing-box` processes, zero G2C temp paths, and no TCP 14443 listener.
- Two runner invocations then reached the official asset/keypair or private listener setup but stopped on empty dynamic assertion-message binding. Each `finally` cleanup and post-cleanup read-back passed. A later invocation found that Mihomo's mixed HTTP/SOCKS port opened a UDP socket; the temporary client config was narrowed to an HTTP-only localhost port.
- The final bounded invocation passed the read-only preflight, asset hash, sing-box config check, private listener boundary, Mihomo config check, and localhost proxy readiness. Its single proxied request ended with curl exit 35 before TLS app-connect. curl stderr remained suppressed; the exact TLS failure cause is therefore unknown and no compatibility success is claimed.
- Across attempts, generated VLESS/REALITY material existed only in the authorized ephemeral process/runtime boundaries and was not emitted. Every attempted remote and local temporary artifact was removed and freshly verified absent. No later request was made after the observed curl failure.
- The new executor script is `scripts/g2c-private-reality-canary.ps1`. It contains no runtime Secret values. PowerShell AST, embedded Python syntax, static Secret scan, and static network-mutation scan passed before the final attempt.


## Reviewer review — G2-C private REALITY curl 35 return — 2026-10-03

```text
REVIEWED_COMMIT=450a3d18ed5575cf5b0e27edd3c4949262b87cd6
EXECUTOR_RESULT=RETURN_G2C_PRIVATE_REALITY_HANDSHAKE_CURL_EXIT_35
REVIEWER_RESULT=RETURN_DIAGNOSTIC_REQUIRED
PRIVATE_LISTENER_AND_CONFIG=PASS
ONE_PROXIED_REQUEST=YES
CURL_EXIT=35
HTTP_STATUS=0
TLS_APPCONNECT_SECONDS=0.000000
REALITY_COMPATIBILITY_PROVEN=NO
EXACT_TLS_ERROR_CLASS=UNKNOWN
WHY_UNKNOWN=curl stderr and protocol-core error streams were suppressed
CLEANUP=PASS
WG_HY2_PRESERVED=YES
PUBLIC_TCP443_CHANGED=NO
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
TIMING_RECORD_PRESENT=NO
TIMING_NONCONFORMANCE_BLOCKS_TECHNICAL_REVIEW=NO
PROPOSED_NEXT_GATE=G2C_REALITY_HANDSHAKE_DIAGNOSTIC_R1
PROPOSED_ESTIMATED_EXECUTION_TIME=15-30 minutes
NEXT_GATE_AUTHORIZED=NO
```

Reviewer interpretation:
- The return is valid and cleanup evidence is sufficient.
- The evidence narrows the problem to the REALITY/TLS/VLESS handshake path after local proxy readiness and private listener creation, but it does not identify a specific implementation/configuration defect.
- No speculative protocol-parameter patch is accepted yet. The next round should first capture sanitized Mihomo/sing-box/curl error classes and prove the configured handshake target is reachable from the VPS.
- Per-round timing fields requested by the current timing policy were not recorded. This is a documentation/observability miss only and does not invalidate the network result; the next round must include them.


## Owner authorization — G2C REALITY handshake diagnostic R1 — 2026-10-03

```text
AUTHORIZED_GATE=G2C_REALITY_HANDSHAKE_DIAGNOSTIC_R1
OWNER_AUTHORIZATION=GRANTED
MAX_ENDPOINT=one private diagnostic setup + handshake-target check + one proxied HTTPS request + sanitized error classification + exact cleanup + Reviewer stop
PROTOCOL_PARAMETERS_CHANGE=NOT_AUTHORIZED
PUBLIC_TCP443_EXPOSURE=NOT_AUTHORIZED
PERSISTENT_SERVICE=NOT_AUTHORIZED
BENCHMARK=NOT_AUTHORIZED
ESTIMATED_EXECUTION_TIME=15-30 minutes
TIMING_RECORD_REQUIRED=YES
```

No execution result is claimed by this authorization record. Executor must append the actual diagnostic Evidence after execution.


## G2C_REALITY_HANDSHAKE_DIAGNOSTIC_R1 — one private diagnostic request — 2026-10-03

```text
AUTHORIZED_GATE=G2C_REALITY_HANDSHAKE_DIAGNOSTIC_R1
SOURCE_BASE=3b20323933f6751e6cd614e5b41946430c191432
LOCAL_EXECUTION_CONTEXT=Owner Windows account 34707 / PowerShell 7.6.5 / Medium RID 8192 / Administrator False
LOCAL_PREFLIGHT=PASS
SSH_CONTROL_TARGET=10.66.21.1
SSH_HOST_KEY_TRUST=PASS
TARGET_HOSTNAME=ubuntu-s-1vcpu-512mb-10gb-sfo3
TARGET_OS=Ubuntu 24.04.5 LTS
TARGET_KERNEL=6.8.0-142-generic
WG_SERVICE=active
HY2_SERVICE=active
UDP_51820_LISTENERS=2
UDP_8443_LISTENERS=1
PRECHECK_TCP_14443_LISTENERS=0
PRECHECK_TCP_443_LISTENERS=0
HANDSHAKE_TARGET=www.microsoft.com:443
HANDSHAKE_TARGET_TCP=PASS
HANDSHAKE_TARGET_TLS=PASS
HANDSHAKE_TARGET_TLS_VERSION=TLSv1.3
WINDOWS_TO_PRIVATE_LISTENER_TCP=PASS (10.66.21.1:14443)
SING_BOX_VERSION=1.14.2
SING_BOX_ASSET_SHA256=PASS
SERVER_CONFIG_CHECK=PASS
PRIVATE_LISTENER=10.66.21.1:14443
PUBLIC_14443_LISTENER=NO
PUBLIC_TCP443_LISTENER=NO
MIHOMO_CONFIG_CHECK=PASS
LOCAL_PROXY=127.0.0.1:17990 / HTTP-only / READY
PROTOCOL_PARAMETERS=UNCHANGED (VLESS+REALITY+Vision; SNI/handshake www.microsoft.com; flow xtls-rprx-vision)
PROXIED_REQUEST_COUNT=1
REQUEST_ENDPOINT=https://api.openai.com/v1/models
CURL_EXIT=35
HTTP_STATUS=0
CURL_TIME_TOTAL_SECONDS=5.002744
CURL_TIME_CONNECT_SECONDS=0.000765
CURL_TIME_APPCONNECT_SECONDS=0.000000
CURL_ERROR_CLASS=UNKNOWN_TLS_HANDSHAKE_FAILURE
MIHOMO_ERROR_CLASS=TIMEOUT
SING_BOX_ERROR_CLASS=UNKNOWN_TLS_HANDSHAKE_FAILURE
REALITY_DIAGNOSTIC_CLASSIFICATION=TIMEOUT
REALITY_COMPATIBILITY_PROVEN=NO
BENCHMARK_STARTED=NO
PERFORMANCE_CONCLUSION=NONE
TEST_MIHOMO_STOPPED=YES
CLIENT_SECRET_RUNTIME_DELETED=YES
REMOTE_CANARY_PROCESS_CONFIG_BINARY_LOG_AND_RUN_PATHS_REMOVED=YES
TCP_14443_POSTCLEANUP_LISTENERS=0
TCP_443_POSTCLEANUP_LISTENERS=0
WG_HY2_POSTCLEANUP=PASS
LOCAL_ROUTE_PROXY_TUN_POSTCLEANUP=PASS
PUBLIC_TCP443_CHANGED=NO
FIREWALL_OR_ROUTE_MUTATION=NO
WIREGUARD_OR_HY2_CHANGED=NO
SYSTEM_PROXY_OR_TUN_CHANGED=NO
LIVE_SYSTEM_TUNING_APPLIED=NO
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
OWNER_ACTION_REQUIRED=NONE
EXECUTOR_RESULT=PASS_CANDIDATE_DIAGNOSTIC
STOP_AT_REVIEWER=YES
ROUND_STARTED_AT=2026-10-02T17:57:29Z
ROUND_FINISHED_AT=2026-10-02T18:21:58Z
ACTUAL_ELAPSED=24m29s
TIME_OVERRUN=NO
TIME_OVERRUN_CAUSE=NONE
```

Diagnostic implementation change was limited to capturing curl/Mihomo output in process memory and sing-box debug output in a root-owned `0600` file inside the temporary root-only `/run` directory; only allowlisted classes were emitted. That file and all temporary runtime artifacts were removed and their absence was verified. The VLESS/REALITY/Vision protocol fields, endpoint/ports, routing, and production services were not changed. The concrete `TIMEOUT` class came from Mihomo; curl and sing-box streams remained generic, so Reviewer should decide whether the narrowed client-side timeout is sufficient for a minimal next repair.


## Reviewer acceptance — G2C REALITY handshake diagnostic R1 — 2026-10-03

```text
REVIEWED_MAIN_COMMIT=e2e89aa920bc06fe417428bffa4842aa5119ceec
DIAGNOSTIC_IMPLEMENTATION_COMMIT=c45a09688ed6eb48ac885f1f85a3b9c98f649923
EXECUTOR_RESULT=PASS_CANDIDATE_DIAGNOSTIC
REVIEWER_RESULT=PASS_DIAGNOSTIC_ONLY
PRIVATE_TCP_REACHABILITY=PASS
HANDSHAKE_TARGET_TCP=PASS
HANDSHAKE_TARGET_TLS=PASS_TLS1_3
ONE_PROXIED_REQUEST=YES
CURL_EXIT=35
HTTP_STATUS=0
MIHOMO_ERROR_CLASS=TIMEOUT
SING_BOX_ERROR_CLASS=UNKNOWN_TLS_HANDSHAKE_FAILURE
REALITY_COMPATIBILITY_PROVEN=NO
CLEANUP=PASS
WG_HY2_PRESERVED=YES
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
ESTIMATED_EXECUTION_TIME=15-30 minutes
ACTUAL_ELAPSED=24m29s
TIME_OVERRUN=NO
PROPOSED_NEXT_GATE=G2C_REALITY_SERVER_STATE_DIAGNOSTIC_R2
PROPOSED_NEXT_ESTIMATE=10-20 minutes
NEXT_GATE_AUTHORIZED=NO
```

Reviewer reasoning:
- R1 successfully removed general private-TCP and handshake-target reachability as leading explanations.
- The remaining evidence does not reveal whether REALITY authentication was accepted, whether sing-box fell back to the target, or whether the server accepted auth and stalled later in TLS rewriting.
- No protocol parameter is changed yet. R2 should extract only those safe state transitions from the protected server log, then stop.


## Owner authorization — G2C REALITY server-state diagnostic R2 — 2026-10-03

```text
AUTHORIZED_GATE=G2C_REALITY_SERVER_STATE_DIAGNOSTIC_R2
OWNER_AUTHORIZATION=GRANTED
MAX_ENDPOINT=one private 10.66.21.1:14443 setup + one unchanged proxied HTTPS request + allowlisted server-state extraction + exact cleanup + Reviewer stop
PROTOCOL_PARAMETERS_CHANGE=NOT_AUTHORIZED
CORE_REPLACEMENT=NOT_AUTHORIZED
PUBLIC_TCP443_EXPOSURE=NOT_AUTHORIZED
PERSISTENT_SERVICE=NOT_AUTHORIZED
BENCHMARK=NOT_AUTHORIZED
ESTIMATED_EXECUTION_TIME=10-20 minutes
TIMING_RECORD_REQUIRED=YES
```

No execution result is claimed by this authorization record. Executor must append the actual R2 diagnostic Evidence after execution.

## G2C_REALITY_SERVER_STATE_DIAGNOSTIC_R2 — execution evidence (2026-10-03)

```text
GATE_ID=G2C_REALITY_SERVER_STATE_DIAGNOSTIC_R2
RESULT=PASS_CANDIDATE_DIAGNOSTIC
ROUND_STARTED_AT=2026-10-03T00:44:07Z
ROUND_FINISHED_AT=2026-10-03T01:09:19Z
ACTUAL_ELAPSED=25m12s
ESTIMATED_EXECUTION_TIME=10-20 minutes
TIME_OVERRUN=YES
TIME_OVERRUN_CAUSE=GITHUB_MAIN_ADVANCED_DURING_ROUND_REQUIRED_FETCH_REBASE_AND_RETRY
PRE_GATE_HEAD=acde0b5084ab420c740b32c2b5d820dc51423cd1
SING_BOX_VERSION=1.14.2
MIHOMO_VERSION=v1.19.31
SING_BOX_TRACE_STATE_CAPTURE=PASS
ONE_PRIVATE_PROXIED_REQUEST=YES
ONE_PROXIED_REQUEST_COUNT=1
REALITY_CANARY_CURL_EXIT=35
REALITY_CANARY_HTTP_STATUS=0
REALITY_CANARY_TIME_TOTAL=5.005446
REALITY_CANARY_TIME_CONNECT=0.000856
REALITY_CANARY_TIME_APPCONNECT=0.000000
HANDSHAKE_TARGET_TCP=PASS
HANDSHAKE_TARGET_TLS=PASS
HANDSHAKE_TARGET_TLS_VERSION=TLSv1.3
MIHOMO_ERROR_CLASS=TIMEOUT
SING_BOX_ERROR_CLASS=NONE_OBSERVED
REALITY_SERVER_AUTH_ACCEPTED=UNKNOWN
REALITY_SERVER_FALLBACK_USED=UNKNOWN
REALITY_SERVER_KEY_SHARE=UNKNOWN
REALITY_SERVER_HANDSHAKE_REACHED=UNKNOWN
REALITY_SERVER_CLIENT_FINISHED=UNKNOWN
REALITY_SERVER_HANDSHAKE_STAGE=UNKNOWN
REALITY_SERVER_HANDSHAKE_COMPLETE=UNKNOWN
REALITY_SERVER_ERROR_STAGE=UNKNOWN
REALITY_SERVER_STATE_CLASSIFICATION=UNKNOWN_AFTER_R2
TEST_MIHOMO_STOPPED=YES
CLIENT_SECRET_RUNTIME_DELETED=YES
REMOTE_CANARY_CLEANUP=PASS
LOCAL_BASELINE_RESTORED=YES
WG_HY2_PRESERVED=YES
SYSTEM_PROXY_UNCHANGED=YES
TUN_UNCHANGED=YES
PUBLIC_TCP443_LISTENER=ABSENT
TEMPORARY_PRIVATE_LISTENER_CREATED_AND_REMOVED=YES
CURRENT_TRAFFIC_SWITCHED=NO
BENCHMARK_STARTED=NO
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
PERSISTENT_NETWORK_OR_SERVER_STATE_CHANGED=NO
STOP_AT_REVIEWER=YES
```

The only source change was temporary sing-box trace verbosity plus a bounded parser that emits fixed, non-secret REALITY state enums; VLESS/REALITY/Vision parameters, endpoint, versions, and the one-request limit were unchanged. The protected temporary log was not emitted and was removed by the existing remote cleanup. The trace capture was readable, but none of the expected server-state markers was confirmed, so this round does not distinguish authentication/fallback from later handshake stages. No compatibility or protocol-performance conclusion is established.


## Reviewer acceptance — G2C REALITY server-state diagnostic R2 — 2026-10-03

```text
REVIEWER_GOVERNANCE_VERSION=v0.2.6
REVIEWER_GOVERNANCE_SHA=de2b38ec0e7f3ecceb1aeffa3fc7f033ed14429a
TRIGGERED_SPECIALISTS=11B_SSH_SECRET_TARGET_HOST,11C_DEPLOYMENT_NETWORK_RESOURCES,11D_AUTOMATION_AUTH
REVIEWED_MAIN_COMMIT=0d9249ada6fa17223e3587fb7f77c52b0227ffa7
EXECUTOR_RESULT=PASS_CANDIDATE_DIAGNOSTIC
REVIEWER_RESULT=PASS_DIAGNOSTIC_ONLY
R2_CLASSIFICATION=UNKNOWN_AFTER_R2
ONE_PRIVATE_REQUEST=YES
CURL_EXIT=35
HTTP_STATUS=0
MIHOMO_ERROR_CLASS=TIMEOUT
SING_BOX_TRACE_STATE_CAPTURE=PASS
REALITY_SERVER_STATE_FIELDS=UNKNOWN
HANDSHAKE_TARGET_TLS=PASS_TLS1_3
CLEANUP=PASS
WG_HY2_PRESERVED=YES
PUBLIC_TCP443_CHANGED=NO
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
ESTIMATED_EXECUTION_TIME=10-20 minutes
ACTUAL_ELAPSED=25m12s
TIME_OVERRUN=YES
TIME_OVERRUN_CAUSE=GITHUB_MAIN_ADVANCED_DURING_ROUND_REQUIRED_FETCH_REBASE_AND_RETRY
OVERRUN_TECHNICAL_BLOCKER=NO
NEXT_STRATEGY=CONTROLLED_IMPLEMENTATION_AB
PROPOSED_NEXT_GATE=G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R3
PROPOSED_NEXT_ESTIMATE=20-35 minutes
NEXT_GATE_AUTHORIZED=NO
```

Reviewer reasoning:
- R2 satisfied its diagnostic acceptance path by safely reaching `UNKNOWN_AFTER_R2`; it does not prove REALITY interoperability.
- The protected trace parser was valid as an evidence extractor, but no allowlisted REALITY internal marker appeared. Per Governance, more materially similar retries or blind parameter edits are not justified.
- The next smallest high-information change is a one-sided implementation A/B: preserve the accepted Windows Mihomo client and all VLESS/REALITY/Vision semantics, replace only the temporary server core with the matching Mihomo v1.19.31 native listener, and make one request.
- The 25m12s overrun is accepted as repository-concurrency overhead. It does not change the network result and does not require a separate technical incident Gate.


## Owner authorization — G2C REALITY implementation A/B Mihomo server R3 — 2026-10-03

```text
REVIEWER_GOVERNANCE_VERSION=v0.2.6
REVIEWER_GOVERNANCE_SHA=de2b38ec0e7f3ecceb1aeffa3fc7f033ed14429a
TRIGGERED_SPECIALISTS=11B_SSH_SECRET_TARGET_HOST,11C_DEPLOYMENT_NETWORK_RESOURCES,11D_AUTOMATION_AUTH
AUTHORIZED_GATE=G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R3
OWNER_AUTHORIZATION=GRANTED
A_SIDE_REPLAY=NOT_AUTHORIZED
B_SIDE_SERVER_IMPLEMENTATION=MIHOMO_V1_19_31_NATIVE
B_SIDE_PRIVATE_BIND=10.66.21.1:14443
B_SIDE_REQUEST_COUNT=1
CLIENT_AND_PROTOCOL_SEMANTICS=UNCHANGED
PUBLIC_TCP443_EXPOSURE=NOT_AUTHORIZED
PERSISTENT_SERVICE=NOT_AUTHORIZED
BENCHMARK=NOT_AUTHORIZED
TARGET_OR_SNI_CHANGE=NOT_AUTHORIZED
PRODUCTION_DEFAULT_CHANGE=NOT_AUTHORIZED
ESTIMATED_EXECUTION_TIME=20-35 minutes
TIMING_RECORD_REQUIRED=YES
```

No execution result is claimed by this authorization record. Executor must append the actual R3 A/B Evidence after execution.

## G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R3 — execution evidence (2026-10-03)

```text
AUTHORIZED_GATE=G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R3
ROUND_STARTED_AT=2026-10-03T01:20:41Z
ROUND_FINISHED_AT=2026-10-03T02:15:51Z
ACTUAL_ELAPSED=55m10s
ESTIMATED_EXECUTION_TIME=20-35 minutes
TIME_OVERRUN=YES
TIME_OVERRUN_CAUSE=LOCAL_PROCESS_ARGUMENT_BINDING_DIAGNOSIS_AND_GITHUB_MAIN_RECONCILIATION
PRE_RUN_MAIN=db5a39c4d94165c6d364ef6b338daa079c58e15e
MAIN_RECONCILED_TO=58ee3616ed7a8f43af25a76dfa1ffaa7a3b6a483
TARGET_HOSTNAME=ubuntu-s-1vcpu-512mb-10gb-sfo3
TARGET_OS=Ubuntu 24.04.5 LTS
TARGET_KERNEL=6.8.0-142-generic
SSH_CONTROL_PATH=10.66.21.1:22 via WireGuard; strict accepted host-key trust; read-only preflight PASS
WG_AND_HY2=active before and after; UDP 51820 and UDP 8443 listeners preserved
WINDOWS_MIHOMO_CLIENT=v1.19.31
WINDOWS_WG_MANAGER_AND_TUNNEL=Running
WINDOWS_WG_ADAPTER=SFO2-A Up, ifIndex 13
WINDOWS_PROXY_ENABLE=0
WINDOWS_WINHTTP=direct
WINDOWS_TUN_ADAPTERS=0
LOCAL_PROXY_PORT_17990=free at preflight; temporary test proxy later READY
VPS_PRIVATE_TCP_14443=free at preflight
VPS_TCP_443=free at preflight; no public 443 listener was opened
VPS_DEFAULT_ROUTE=default via 24.199.112.1 dev eth0
VPS_IP_FORWARD=1
VPS_MEMAVAILABLE_KIB_PREFLIGHT=293912
VPS_TMP_FREE_KIB_PREFLIGHT=7012740
SERVER_IMPLEMENTATION=MIHOMO_V1_19_31_NATIVE
SERVER_ASSET_SHA256=04cf9f09671704f839ddbee2e93069dc831a4123a75281e725d1d96ab9ac1afc (PASS)
SERVER_CONFIG_CHECK=PASS
SERVER_PRIVATE_BIND=10.66.21.1:14443
PRIVATE_LISTENER_TCP_CHECK=PASS
SERVER_RSS_KIB_AT_READY=41192
CLIENT_CONFIG=rendered with unchanged accepted client/protocol semantics; protected runtime ACL check PASS
CLIENT_PROXY_PROCESS=READY
ONE_SERVER_B_SIDE_ATTEMPT=YES
SING_BOX_A_SIDE_REPLAY=NO
OPENAI_PROXIED_REQUEST_COUNT=0
CURL_PROCESS_STARTED=NO
REALITY_HANDSHAKE=NOT_REACHED
CURL_EXIT=NA
HTTP_STATUS=NA
CLIENT_ERROR_CLASS=NOT_RUN
SERVER_ERROR_CLASS=NO_SERVER_ERROR_OBSERVED
INITIAL_RUNNER_FAILURE=UNEXPECTED_LOCAL_FAILURE
ROOT_CAUSE=Start-R3SuppressedProcess mandatory string[] Arguments rejected the intentional empty --noproxy value under PowerShell parameter validation
ROOT_CAUSE_ERROR_CLASS=ParameterBindingValidationException
ROOT_CAUSE_FQID=ParameterArgumentValidationErrorEmptyStringNotAllowed,Start-R3SuppressedProcess
IMPLEMENTATION_AB_RESULT=UNKNOWN
PERFORMANCE_CONCLUSION=NONE
POST_CLEANUP_MEMAVAILABLE_KIB=279768
CLIENT_MIHOMO_STOPPED=YES
SERVER_MIHOMO_STOPPED=YES
CLIENT_RUNTIME_DELETED=YES
REMOTE_RUNTIME_DELETED=YES
LOCAL_BASELINE_UNCHANGED=YES
WG_HY2_PRESERVED=YES
NETWORK_CHANGED=NO
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
FINAL_RESULT=RETURN_G2C_R3_CLIENT_REQUEST_NOT_STARTED
STOP_AT_REVIEWER=YES
```

The request process was never started, so this round provides no REALITY handshake or implementation compatibility result. The failure was reproduced only with a local no-network helper fixture. The runner source now allows an empty argument and classifies parameter-binding failures without exposing exception text; after this patch, PowerShell AST parsing and a local `curl --version` helper fixture passed. No server/client/request rerun followed the patch. Temporary server/client processes and protected runtime files were removed, and post-cleanup read-back confirmed the production baseline remained intact.

Evidence artifact purpose: `scripts/g2c-mihomo-server-r3.ps1` is the source for the bounded one-shot attempt and its cleanup; it contains no runtime Secret values.


## Reviewer reconciliation — G2C R3 request-not-started return — 2026-10-03

```text
REVIEWER_GOVERNANCE_VERSION=v0.2.6
REVIEWER_GOVERNANCE_SHA=de2b38ec0e7f3ecceb1aeffa3fc7f033ed14429a
TRIGGERED_SPECIALISTS=11B_SSH_SECRET_TARGET_HOST,11C_DEPLOYMENT_NETWORK_RESOURCES,11D_AUTOMATION_AUTH
REVIEWED_COMMIT=f2a02ca60f8698d126620bcbbad21130386a7258
EXECUTOR_RESULT=RETURN_G2C_R3_CLIENT_REQUEST_NOT_STARTED
REVIEWER_CLASSIFICATION=LOCAL_PROCESS_ARGUMENT_BINDING_FAILURE_BEFORE_REQUEST
SERVER_ASSET_AND_CONFIG=PASS
PRIVATE_LISTENER_TCP=PASS
CLIENT_PROXY_READY=YES
OPENAI_PROXIED_REQUEST_COUNT=0
CURL_PROCESS_STARTED=NO
REALITY_HANDSHAKE_REACHED=NO
IMPLEMENTATION_AB_RESULT=UNKNOWN
PROTOCOL_COMPATIBILITY_CONCLUSION=NONE
TOOLING_ROOT_CAUSE=EMPTY_NOPROXY_ARGUMENT_REJECTED_BY_MANDATORY_STRING_ARRAY_PARAMETER
REPAIRED_RUNNER_STATIC_REVIEW=PASS
REPAIRED_LOCAL_NO_NETWORK_FIXTURE=EXECUTOR_REPORTED_PASS
CLEANUP=PASS
WG_HY2_PRESERVED=YES
NETWORK_CHANGED=NO
PUBLIC_TCP443_CHANGED=NO
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
PREVIOUS_ESTIMATE=20-35 minutes
ACTUAL_ELAPSED=55m10s
TIME_OVERRUN=YES
TIME_OVERRUN_CAUSE=LOCAL_PROCESS_ARGUMENT_BINDING_DIAGNOSIS_AND_GITHUB_MAIN_RECONCILIATION
OWNER_REQUEST_AUTHORIZATION_CONSUMED=NO
SAME_GATE_RETRY=AUTHORIZED
FRESH_OWNER_AUTHORIZATION_REQUIRED=NO
RETRY_ESTIMATED_EXECUTION_TIME=15-25 minutes
```

Reviewer reasoning:
- The server-side B candidate reached a valid private ready state, but the only authorized real request never started, so no Mihomo-server A/B conclusion exists.
- The failure is localized to the Windows process helper. The repaired helper now explicitly permits the intentional empty string and keeps passing each argument through `ProcessStartInfo.ArgumentList`; no protocol or server semantics changed.
- Retry must run the local no-network empty-argument fixture before starting the remote candidate. If it passes, the same R3 Gate may continue once. If a real request starts, that consumes the remaining request authorization regardless of protocol outcome.
- Repository advancement after execution may require reconciliation, but must never cause the real request to be replayed.

## G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R3 — authorized retry evidence (2026-10-03)

```text
AUTHORIZED_GATE=G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R3_RETRY
ROUND_STARTED_AT=2026-10-03T04:56:08Z
ROUND_FINISHED_AT=2026-10-03T05:07:06Z
ACTUAL_ELAPSED=10m58s
ESTIMATED_EXECUTION_TIME=15-25 minutes
TIME_OVERRUN=NO
TIME_OVERRUN_CAUSE=NONE
RETRY_PREFLIGHT_EMPTY_ARGUMENT_FIXTURE=PASS
FIXTURE_METHOD=Extracted the committed Start-R3SuppressedProcess definition and ran local curl.exe --noproxy '' --version; ArgumentList retained 3 args including the empty value; exit 0; no URL/request.
FIXTURE_NETWORK_REQUESTS=0
RUNNER_SOURCE=unchanged at commit 752e66282f384cd2bb28433d12e2db450447b597
RUNNER_INVOCATIONS=1
RUNNER_EXIT=1
RUNNER_FAILURE_PHASE=UNKNOWN
RUNNER_SECONDARY_ERROR=Unable to find type Management.Automation.ParameterBindingValidationException in the top-level catch classifier at line 1093
UNDERLYING_EXCEPTION=MASKED_BY_CATCH_CLASSIFIER_FAILURE
REQUEST_COUNT=UNKNOWN
REALITY_HANDSHAKE=UNKNOWN
IMPLEMENTATION_AB_RESULT=UNKNOWN
NO_REQUEST_REPLAY_AFTER_RUN=YES
POSTCHECK_WIREGUARD_MANAGER=Running
POSTCHECK_WIREGUARD_TUNNEL=Running
POSTCHECK_SFO2_A=Up, ifIndex 9
POSTCHECK_CONTROL_ROUTE=10.66.21.1 selects SFO2-A, ifIndex 9
RUNNER_EXPECTED_WIREGUARD_IFINDEX=13; entry-time value not independently captured
POSTCHECK_SYSTEM_PROXY_ENABLE=0
POSTCHECK_WINHTTP=DIRECT
POSTCHECK_TUN_MATCH_COUNT=0
POSTCHECK_LOCAL_MIHOMO_PROCESS_COUNT=0
POSTCHECK_LOCAL_PROXY_LISTENERS_TCP_UDP=0/0
POSTCHECK_LOCAL_R3_RUNTIME_DIRECTORIES=0
POSTCHECK_VPS_HOSTNAME=ubuntu-s-1vcpu-512mb-10gb-sfo3
POSTCHECK_WG_SERVICE=active
POSTCHECK_HY2_SERVICE=active
POSTCHECK_UDP_51820_LISTENERS=2
POSTCHECK_UDP_8443_LISTENERS=1
POSTCHECK_TCP_14443_LISTENERS=0
POSTCHECK_TCP_443_LISTENERS=0
POSTCHECK_VPS_MIHOMO_PROCESS_COUNT=0
POSTCHECK_VPS_R3_RUNTIME_RESIDUE=0
CLEANUP_READBACK=PASS
POSTCHECK_QUERY_ANOMALY=Initial exact-port Get-NetTCPConnection query returned no-match CimJobException; read-only full listener enumeration plus filter confirmed zero; no state changed.
NETWORK_CONFIGURATION_MUTATION=NO
SING_BOX_A_SIDE_REPLAY=NO
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
FINAL_RESULT=RETURN_G2C_R3_RUNNER_EXCEPTION_CLASSIFIER_FAILURE
STOP_AT_REVIEWER=YES
```

The local fixture passed, but the one authorized retry did not produce its normal result markers: the top-level catch itself raised a missing-type error, masking the original exception and phase. Therefore actual request count and handshake state are recorded as UNKNOWN; no additional request or runner invocation was made. Cleanup was independently read back over the accepted strict SSH control path and on Windows: no temporary server/client process, listener, or R3 runtime residue remained; WG/HY2, proxy, TUN, and the WireGuard-selected control route remained operational. The current post-run adapter index is 9 while the runner invariant expects 13; because entry-time state was not emitted, this is recorded as a current readback fact, not asserted as the triggering exception.


## Reviewer reconciliation — G2C R3 retry masked-failure return — 2026-10-03

```text
REVIEWER_GOVERNANCE_VERSION=v0.2.6
REVIEWER_GOVERNANCE_SHA=de2b38ec0e7f3ecceb1aeffa3fc7f033ed14429a
TRIGGERED_SPECIALISTS=11B_SSH_SECRET_TARGET_HOST,11C_DEPLOYMENT_NETWORK_RESOURCES,11D_AUTOMATION_AUTH
REVIEWED_COMMIT=23e025ef6ef158361ac8bb73d3b6ac969f2ad70a
EXECUTOR_RESULT=RETURN_G2C_R3_RUNNER_EXCEPTION_CLASSIFIER_FAILURE
REVIEWER_RESULT=RETURN_LOCAL_RUNNER_HARDENING_REQUIRED
EMPTY_ARGUMENT_FIXTURE=PASS
RUNNER_TOP_LEVEL_CLASSIFIER_DEFECT=CONFIRMED
MASKED_ORIGINAL_FAILURE=YES
REQUEST_COUNT=UNKNOWN
REALITY_HANDSHAKE=UNKNOWN
IMPLEMENTATION_AB_RESULT=UNKNOWN
PROTOCOL_COMPATIBILITY_CONCLUSION=NONE
POSTCHECK_SFO2_A_STATUS=UP
POSTCHECK_SFO2_A_IFINDEX=9
POSTCHECK_CONTROL_ROUTE_INTERFACE=SFO2-A
POSTCHECK_CONTROL_ROUTE_IFINDEX=9
RUNNER_HARDCODED_IFINDEX=13
HARDCODED_IFINDEX_INVARIANT=STALE
CLEANUP_READBACK=PASS
WG_HY2_PRESERVED=YES
SYSTEM_PROXY_UNCHANGED=YES
TUN_COUNT=0
PUBLIC_TCP443_CHANGED=NO
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
ESTIMATED_EXECUTION_TIME=15-25 minutes
ACTUAL_ELAPSED=10m58s
TIME_OVERRUN=NO
PRIOR_REAL_REQUEST_AUTHORIZATION_STATUS=AMBIGUOUS_CONSUMED_OR_NOT
FRESH_OWNER_AUTHORIZATION_REQUIRED_BEFORE_NEXT_REAL_REQUEST=YES
NEXT_GATE=G2C_R3_LOCAL_RUNNER_HARDENING_H1
NEXT_GATE_NETWORK_ACTIONS=0
NEXT_GATE_OWNER_AUTHORIZATION_REQUIRED=NO
NEXT_GATE_ESTIMATED_EXECUTION_TIME=10-20 minutes
```

Reviewer reasoning:
- The empty-argument repair itself is now proven locally, so repeating that binder fix is not justified.
- The catch classifier can itself throw while classifying another exception, masking the original phase and request state.
- Post-run read-back shows SFO2-A and the selected control route both on ifIndex 9 while the runner requires 13; the safe invariant is runtime consistency, not a fixed interface number.
- Because request state is UNKNOWN, Reviewer will not reuse the prior one-request authorization. A fresh Owner authorization is required before any later real OpenAI/REALITY request.
- The next round is local-only runner hardening with zero SSH/network/Secret activity.


## Owner context reconciliation — Windows reboot before R3 ifIndex read-back — 2026-10-03

```text
PROVENANCE=OWNER_REPORTED
OWNER_REPORTED_WINDOWS_REBOOT=YES
TIMING=shortly before the observed R3 post-run SFO2-A ifIndex=9 read-back
REVIEWER_INTERPRETATION=reboot may plausibly coincide with Windows interface-index renumbering
CAUSATION_OF_R3_FAILURE=NOT_PROVEN
RUNNER_HARDCODED_IFINDEX_13=STILL_INVALID_RUNTIME_ASSUMPTION
H1_GATE_REQUIRED=YES
H1_LIVE_IFINDEX_EXPECTATION=DYNAMIC_POSITIVE_VALUE_MATCHING_CONTROL_ROUTE
SPECIFIC_IFINDEX_9_REQUIRED=NO
SPECIFIC_IFINDEX_13_REQUIRED=NO
```

This Owner-reported reboot context changes the interpretation of the ifIndex observation, not the safety conclusion. The project no longer treats the move from 13 to 9 as unexplained evidence of network drift; it is plausibly consistent with a normal Windows reboot/re-enumeration. However, no causal claim is made about the masked R3 failure. The H1 runner-hardening Gate remains necessary because the runner must tolerate legitimate interface-index changes across reboot/reconnect and because the exception classifier independently failed.


## Executor evidence — G2C_R3_LOCAL_RUNNER_HARDENING_H1 — 2026-10-03

```text
AUTHORIZED_GATE=G2C_R3_LOCAL_RUNNER_HARDENING_H1
SOURCE_PROVENANCE=LOCAL_CANONICAL_WORKTREE_AT_GITHUB_MAIN_BASE
PRE_GATE_HEAD=642255a1185100057c7ab8ea9d2515ea5d076046
LATEST_MAIN_RECONCILED=889fe48defd4bcd59221bfdf1567dbf93a6db66e
MAIN_ADVANCE_DURING_GATE=YES; TARGET_GATE_RUNNER_AND_RELAY_UNCHANGED
RUNNER_PATH=vpn-network-optimization/scripts/g2c-mihomo-server-r3.ps1
RUNNER_EXCEPTION_CLASSIFIER=RUNTIME_TYPE_NAME_AND_RESTRICTED_FQID
LOCAL_PARAMETER_BINDING_RUNTIME_TYPE=ParameterBindingValidationException
LOCAL_PARAMETER_BINDING_FQID=ParameterArgumentValidationErrorEmptyArrayNotAllowed,Start-R3SuppressedProcess
LOCAL_PARAMETER_BINDING_CLASSIFICATION=LOCAL_PROCESS_ARGUMENT_BINDING_FAILED
UNKNOWN_EXCEPTION_CLASSIFICATION=UNEXPECTED_LOCAL_FAILURE
POWERSHELL_AST_PARSE=PASS
SYNTHETIC_MATCHING_DYNAMIC_IFINDEX=PASS
SYNTHETIC_MISMATCHING_IFINDEX=FAIL_CLOSED
EMPTY_STRING_ARGUMENT_PROCESS_FIXTURE=PASS
HARDCODED_IFINDEX_13_CHECK=PASS
LIVE_HOST_WG_MANAGER=Running
LIVE_HOST_WG_TUNNEL=Running
LIVE_HOST_SFO2_A_STATUS=Up
LIVE_HOST_SFO2_A_IFINDEX=9
LIVE_HOST_CONTROL_ROUTE_ALIAS=SFO2-A
LIVE_HOST_CONTROL_ROUTE_IFINDEX=9
LIVE_HOST_DYNAMIC_ROUTE_BASELINE=PASS
NETWORK_REQUESTS=0
SSH_INVOCATIONS=0
SECRET_ACCESSED=NO
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
MIHOMO_STARTED=NO
VPS_OPERATIONS=0
NETWORK_CHANGED=NO
REVIEWER_HANDOFF_MODIFIED=NO
```

The top-level catch previously evaluated a statically named exception type that was not resolvable in the failing runtime, allowing the classifier to mask the original failure. The replacement safely extracts runtime type name and `FullyQualifiedErrorId`, only maps known parameter-binding types with a narrowly matched `Start-R3SuppressedProcess` binding ID, preserves only constrained uppercase runner codes, and returns a fixed generic code if classification itself encounters an error. The production baseline now reads the current `SFO2-A` adapter index and requires a positive value plus a control-route alias and index matching that same snapshot value. Static review found no benchmark, request, protocol, Secret, process-start, or cleanup logic changes. The live Windows readback and all fixtures were local/read-only; no SSH, remote operation, network request, Secret access, or network mutation occurred.

ROUND_STARTED_AT=2026-10-03T05:18:10Z
ROUND_FINISHED_AT=2026-10-03T05:32:55Z
ACTUAL_ELAPSED=14m45s
TIME_OVERRUN=NO
TIME_OVERRUN_CAUSE=NONE
STOP_AT_REVIEWER=YES


## Reviewer acceptance — G2C_R3_LOCAL_RUNNER_HARDENING_H1 — 2026-10-03

```text
REVIEWER_GOVERNANCE_VERSION=v0.2.6
REVIEWER_GOVERNANCE_SHA=de2b38ec0e7f3ecceb1aeffa3fc7f033ed14429a
TRIGGERED_SPECIALISTS=11B_SSH_SECRET_TARGET_HOST,11C_DEPLOYMENT_NETWORK_RESOURCES,11D_AUTOMATION_AUTH
REVIEWED_COMPLETION_COMMIT=2993756d41d0621471480ed2891c828d6674c7e6
REVIEWED_SOURCE_COMMIT=4d50e963a519aa5452cfe4d639c4bdf173827faa
EXECUTOR_RESULT=PASS_CANDIDATE_HARDENING
REVIEWER_RESULT=PASS
POWERSHELL_AST_PARSE=PASS
PARAMETER_BINDING_FAILURE_FIXTURE=PASS
UNKNOWN_EXCEPTION_FIXTURE=PASS
MATCHING_DYNAMIC_IFINDEX_FIXTURE=PASS
MISMATCH_DYNAMIC_IFINDEX_FIXTURE=FAIL_CLOSED_AS_REQUIRED
EMPTY_STRING_ARGUMENT_FIXTURE=PASS
HARDCODED_IFINDEX_13_CHECK=PASS
LIVE_SFO2_A_STATUS=UP
LIVE_SFO2_A_IFINDEX=9
LIVE_CONTROL_ROUTE_ALIAS=SFO2-A
LIVE_CONTROL_ROUTE_IFINDEX=9
LIVE_DYNAMIC_BASELINE=PASS
NETWORK_REQUESTS=0
SSH_INVOCATIONS=0
SECRET_ACCESSED=NO
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
NETWORK_CHANGED=NO
ESTIMATED_EXECUTION_TIME=10-20 minutes
ACTUAL_ELAPSED=14m45s
TIME_OVERRUN=NO
H1_SCOPE_COMPLETE=YES
REALITY_AB_RESULT=NOT_APPLICABLE
NEXT_GATE=G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R4
NEXT_GATE_STATE=PROPOSED_NOT_AUTHORIZED
FRESH_OWNER_AUTHORIZATION_REQUIRED=YES
NEXT_ESTIMATED_EXECUTION_TIME=15-25 minutes
```

Reviewer reasoning:
- The reviewed source patch is limited to a non-throwing failure-code resolver and dynamic WireGuard adapter/control-route consistency checks; it does not modify protocol, request, Secret, process-start, server-config, or cleanup semantics.
- Every H1 required fixture is present and reviewable, including the failure path that previously masked the original exception.
- The live Windows baseline confirms the dynamic invariant on the current boot without treating numeric ifIndex as stable.
- H1 therefore closes the two known local runner defects. It does not prove REALITY interoperability.
- Because the earlier R3 retry left real-request state UNKNOWN, a fresh Owner authorization is still required before another real request.


## Owner authorization — G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R4 — 2026-10-03

```text
AUTHORIZED_GATE=G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R4
OWNER_AUTHORIZATION=GRANTED
HARDENED_RUNNER_BASE=2993756d41d0621471480ed2891c828d6674c7e6
LOCAL_PREFLIGHT_REQUIRED=YES
REAL_REQUEST_MAX=1
A_SIDE_REPLAY=NOT_AUTHORIZED
PUBLIC_EXPOSURE=NOT_AUTHORIZED
PERSISTENT_DEPLOYMENT=NOT_AUTHORIZED
BENCHMARK=NOT_AUTHORIZED
PROTOCOL_OR_TARGET_CHANGE=NOT_AUTHORIZED
PRODUCTION_DEFAULT_CHANGE=NOT_AUTHORIZED
ESTIMATED_EXECUTION_TIME=15-25 minutes
```

No execution result is claimed by this authorization record. If the single real request starts, it must not be replayed because of later Git synchronization.


## Executor evidence — G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R4 — 2026-10-03

```text
AUTHORIZED_GATE=G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R4
OWNER_AUTHORIZATION=GRANTED_IN_CURRENT_REVIEWER_HANDOFF
PRE_GATE_MAIN=caf4211ccdb6b7767e71b321a5442ed03b77f74f
RUNNER_SOURCE_COMMIT=2993756d41d0621471480ed2891c828d6674c7e6
LOCAL_HARDENED_RUNNER_PREFLIGHT=PASS
POWERSHELL_AST_PARSE=PASS
FAILURE_CLASSIFIER_BINDING_FIXTURE=PASS
FAILURE_CLASSIFIER_UNKNOWN_FIXTURE=PASS
EMPTY_ARGUMENT_FIXTURE=PASS
LIVE_DYNAMIC_SFO2A_ROUTE_BASELINE=PASS
SFO2A_STATUS=Up
SFO2A_IFINDEX=9
CONTROL_ROUTE_ALIAS=SFO2-A
CONTROL_ROUTE_IFINDEX=9
LOCAL_MIHOMO_VERSION=v1.19.31
LOCAL_PRECHECK_PROCESS_RESIDUE=0
LOCAL_PROXY_TUN_RUNTIME_PREFLIGHT=PASS
VPS_IDENTITY=ubuntu-s-1vcpu-512mb-10gb-sfo3
VPS_READONLY_PREFLIGHT=PASS
WG_SERVICE=active
HY2_SERVICE=active
UDP_51820_LISTENERS=2
UDP_8443_LISTENERS=1
TCP_14443_BEFORE=0
TCP_443_BEFORE=0
MIHOMO_SERVER_ASSET=v1.19.31
MIHOMO_SERVER_ASSET_SHA256=PASS
SERVER_CONFIG_CHECK=PASS
SERVER_PRIVATE_LISTENER=10.66.21.1:14443
SERVER_PRIVATE_LISTENER_CHECK=PASS
SERVER_IMPLEMENTATION=MIHOMO_V1_19_31_NATIVE
PROTOCOL_PARAMETERS_CHANGED=NO
SING_BOX_A_REPLAYED=NO
REQUEST_PHASE=ONE_OPENAI_REQUEST
REQUEST_COUNT=1
CURL_EXIT=0
HTTP_STATUS=401
CURL_TIME_TOTAL_SECONDS=0.862103
CURL_TIME_CONNECT_SECONDS=0.001103
CURL_TIME_APPCONNECT_SECONDS=0.600938
CLIENT_ERROR_CLASS=NONE_OBSERVED
SERVER_ERROR_CLASS=NO_SERVER_ERROR_OBSERVED
IMPLEMENTATION_AB_RESULT=MIHOMO_SERVER_SUCCEEDED
REQUEST_ALLOWANCE_CONSUMED=YES
CLIENT_MIHOMO_STOPPED=YES
SERVER_MIHOMO_STOPPED=YES
CLIENT_RUNTIME_DELETED=YES
REMOTE_RUNTIME_AND_BINARY_WORKSPACE_DELETED=YES
LOCAL_POSTCLEANUP_RUNTIME_PROCESS_LISTENER_RESIDUE=0
VPS_POSTCLEANUP_RUNTIME_PROCESS_RESIDUE=0
TCP_14443_AFTER=0
TCP_443_AFTER=0
WG_HY2_PRESERVED=YES
LOCAL_BASELINE_UNCHANGED=YES
SFO2A_POSTCLEANUP=Up/9
CONTROL_ROUTE_POSTCLEANUP=SFO2-A/9
SYSTEM_PROXY_CHANGED=NO
WINHTTP_CHANGED=NO
GLOBAL_TUN_ENABLED=NO
NETWORK_CONFIGURATION_CHANGED=NO
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
EXISTING_SECRETS_ACCESSED=NO
EPHEMERAL_RUNTIME_CREDENTIAL_VALUES_RECORDED=NO
REVIEWER_HANDOFF_MODIFIED=NO
POSTCLEANUP_READBACK=PASS
```

The single OpenAI request was explicitly proxied through the local Mihomo client to the temporary private Mihomo B-side. HTTP 401 is the expected unauthenticated network response. This is a bounded B-side result only; it does not establish a production default or peak-hour conclusion. The runner completed its exact cleanup and before/after checks; a subsequent read-only local snapshot and strict SSH VPS probe independently confirmed no temporary processes, runtime/workspace residue, listener on 14443/443, or change to the WireGuard/HY2 and local network baseline. Temporary VLESS/REALITY runtime credential material was generated only for this attempt and cleaned; values were not recorded.

ROUND_STARTED_AT=2026-10-03T05:51:20Z
ROUND_FINISHED_AT=2026-10-03T06:00:58Z
ACTUAL_ELAPSED=9m38s
TIMING_SCOPE=LOCAL_PREFLIGHT_START_THROUGH_GITHUB_FRESH_READBACK; CANONICAL_SOURCE_READ_PRECEDED_TIMER
TIME_OVERRUN=NO
TIME_OVERRUN_CAUSE=NONE
STOP_AT_REVIEWER=YES


## Reviewer acceptance — G2C_REALITY_IMPLEMENTATION_AB_MIHOMO_SERVER_R4 — 2026-10-03

```text
REVIEWER_GOVERNANCE_VERSION=v0.2.6
REVIEWER_GOVERNANCE_SHA=de2b38ec0e7f3ecceb1aeffa3fc7f033ed14429a
TRIGGERED_SPECIALISTS=11B_SSH_SECRET_TARGET_HOST,11C_DEPLOYMENT_NETWORK_RESOURCES,11D_AUTOMATION_AUTH
REVIEWED_COMPLETION_COMMIT=7e957ab9adbf59535a9c0ed548183051e7ebcf94
EXECUTOR_RESULT=PASS_CANDIDATE_AB
REVIEWER_RESULT=PASS
SERVER_IMPLEMENTATION=MIHOMO_V1_19_31_NATIVE
PROTOCOL_PARAMETERS_CHANGED=NO
SING_BOX_A_REPLAYED=NO
REQUEST_COUNT=1
CURL_EXIT=0
HTTP_STATUS=401
CURL_TIME_TOTAL_SECONDS=0.862103
CLIENT_ERROR_CLASS=NONE_OBSERVED
SERVER_ERROR_CLASS=NO_SERVER_ERROR_OBSERVED
IMPLEMENTATION_AB_RESULT=MIHOMO_SERVER_SUCCEEDED
SERVER_IMPLEMENTATION_DIFFERENCE=MATERIALLY_IMPLICATED_UNDER_TESTED_PRIVATE_PATH
UNIVERSAL_SING_BOX_DEFECT_PROVEN=NO
PUBLIC_REALITY_INTEROPERABILITY=NOT_YET_TESTED
PRODUCTION_DEFAULT=NOT_AUTHORIZED
PEAK_HOUR_CONCLUSION=NONE
CLEANUP_READBACK=PASS
WG_HY2_PRESERVED=YES
NETWORK_CONFIGURATION_CHANGED=NO
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
ESTIMATED_EXECUTION_TIME=15-25 minutes
ACTUAL_ELAPSED=9m38s
TIME_OVERRUN=NO
NEXT_GATE=G2C_REALITY_PUBLIC_TCP443_CANARY_P1
NEXT_GATE_STATE=PROPOSED_NOT_AUTHORIZED
```

Reviewer reasoning:
- The single changed material variable was the temporary REALITY server implementation. With the same Windows Mihomo client and unchanged VLESS+REALITY+Vision/SNI/target semantics, the Mihomo server path returned the expected OpenAI HTTP 401 while the accepted sing-box path had repeatedly failed.
- This is sufficient to select Mihomo v1.19.31 as the remaining G2-C server candidate and stop spending further v1 effort on the sing-box path.
- The evidence does not prove a universal sing-box defect and does not establish public TCP/443 reachability, persistence, production default, or peak-hour performance.
- Cleanup and regression evidence are complete; the private A/B Gate is formally closed.

## Owner authorization — G2C_REALITY_PUBLIC_TCP443_CANARY_P1 — 2026-10-03

```text
AUTHORIZED_GATE=G2C_REALITY_PUBLIC_TCP443_CANARY_P1
OWNER_AUTHORIZATION=GRANTED
AUTHORIZATION_SOURCE=OWNER_DIRECT_IN_CURRENT_CHAT
PUBLIC_TCP443_TEMPORARY_EXPOSURE=AUTHORIZED
TEMPORARY_EXACT_VPS_PUBLIC_IPV4_32_PHYSICAL_EGRESS_ROUTE=AUTHORIZED
REAL_OPENAI_REQUEST_MAX=1
PERSISTENT_DEPLOYMENT=NOT_AUTHORIZED
PERMANENT_FIREWALL_CHANGE=NOT_AUTHORIZED
PERMANENT_ROUTING_CHANGE=NOT_AUTHORIZED
BENCHMARK=NOT_AUTHORIZED
PRODUCTION_DEFAULT_CHANGE=NOT_AUTHORIZED
SECOND_REAL_REQUEST=NOT_AUTHORIZED
MANDATORY_REVIEW_STOP=YES
ESTIMATED_EXECUTION_TIME=20-30 minutes
```

Authorization applies only to the already-reviewed P1 Gate recorded in `REVIEWER_HANDOFF.md`. It does not widen the Gate. Any preflight conflict, target ambiguity, unexpected TCP/443 owner, firewall conflict, physical-egress ambiguity, or failed/ambiguous consequential action returns without retry or scope expansion.

## Executor preflight result — G2C_REALITY_PUBLIC_TCP443_CANARY_P1 — 2026-10-03

```text
GATE_ID=G2C_REALITY_PUBLIC_TCP443_CANARY_P1
OWNER_AUTHORIZATION=GRANTED; AUTHORIZATION_COMMIT=ee278e6af643088cfe026ef7b61fca31eb431ddb
CANONICAL_SOURCE=entropy-student/project; FRESH_MAIN_BEFORE_ATTEMPT=f2ffe68cc1da9a970aa5e3fae83661751b9fc0c5
PRECHECK_RESULT=RETURN_LOCAL_ADMIN_HIGH_TOKEN_REQUIRED
WINDOWS_RUNTIME=PowerShell 7.6.5
ADMIN_HIGH=FAIL; IS_IN_ADMINISTRATOR_ROLE=NO; INTEGRITY_RID=8192 (MEDIUM)
REMOTE_PREFLIGHT=NOT_RUN
PHYSICAL_EGRESS_DISCOVERY=NOT_RUN
TEMP_ROUTE_BEFORE=NOT_READ; TEMP_ROUTE_ADDED=NO; TEMP_ROUTE_SELECTED=NOT_RUN
SERVER_IMPLEMENTATION=NOT_STARTED
SERVER_CONFIG_CHECK=NOT_RUN
PUBLIC_TCP443_LISTENER=NOT_STARTED
PRIVATE_TCP14443_LEFTOVER=NOT_READ
PUBLIC_TCP_REACHABILITY=NOT_TESTED
REQUEST_COUNT=0
CURL_EXIT=NA
HTTP_STATUS=NA
CURL_TIME_CONNECT=NA
CURL_TIME_APPCONNECT=NA
CURL_TIME_TOTAL=NA
PUBLIC_REALITY_INTEROPERABILITY=NOT_TESTED_PRECONDITION_BLOCKED
CLIENT_ERROR_CLASS=NA
SERVER_ERROR_CLASS=NA
TEMP_ROUTE_REMOVED=NOT_APPLICABLE_NO_ROUTE_CREATED
TCP443_AFTER=NOT_READ
TCP14443_AFTER=NOT_READ
LOCAL_RUNTIME_REMOVED=NOT_APPLICABLE_NOT_CREATED
REMOTE_RUNTIME_REMOVED=NOT_APPLICABLE_NOT_CREATED
WG_PRESERVED=NOT_TOUCHED; POSTCHECK_NOT_RUN
HY2_PRESERVED=NOT_TOUCHED; POSTCHECK_NOT_RUN
SYSTEM_PROXY_UNCHANGED=NOT_TOUCHED; POSTCHECK_NOT_RUN
WINHTTP_UNCHANGED=NOT_TOUCHED; POSTCHECK_NOT_RUN
TUN_UNCHANGED=NOT_TOUCHED; POSTCHECK_NOT_RUN
PERMANENT_FIREWALL_CHANGED=NO
PERMANENT_ROUTE_CHANGED=NO
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
CLEANUP_READBACK=NOT_REQUIRED_NO_MUTATION_OR_RUNTIME
ROUND_STARTED_AT=NOT_CAPTURED_BEFORE_FIRST_CLOCK_READ
ROUND_FINISHED_AT=2026-10-03T06:33:10Z (bounded preflight stop observed)
ACTUAL_ELAPSED=UNAVAILABLE; source/preflight began before timer capture and no duration is reconstructed
TIME_OVERRUN=NO; stopped at the first local authorization prerequisite, before the 20-30 minute execution window
STOP_AT_REVIEWER=YES
```

The only direct local readback was the current PowerShell version and Windows token role/integrity. The token was not an Administrator token and its integrity RID was 8192 (Medium), so the required High-integrity preflight failed. No SSH connection, VPS command, route operation, listener, Mihomo process, Secret access, or OpenAI request was attempted. Interoperability remains untested; no failure or performance conclusion is inferred.

## Reviewer reconciliation — G2C_REALITY_PUBLIC_TCP443_CANARY_P1 preflight RETURN — 2026-10-03

```text
REVIEWED_EXECUTOR_COMMIT=58b12a313ed80f9f30d7f1d979d06b5c9173a482
REVIEWER_RESULT=RETURN_ACCEPTED
RETURN_REASON=RETURN_LOCAL_ADMIN_HIGH_TOKEN_REQUIRED
OBSERVED_WINDOWS_RUNTIME=PowerShell 7.6.5
OBSERVED_ADMINISTRATOR_ROLE=NO
OBSERVED_INTEGRITY_RID=8192_MEDIUM
REQUIRED_EXECUTION_CHANNEL=REAL_OWNER_WINDOWS_POWERSHELL_7.6.6_ADMINISTRATOR_HIGH
SSH_STARTED=NO
VPS_MUTATION_STARTED=NO
TEMP_ROUTE_CREATED=NO
PUBLIC_TCP443_LISTENER_STARTED=NO
SECRET_ACCESS_STARTED=NO
OPENAI_REQUEST_COUNT=0
P1_REQUEST_BUDGET_CONSUMED=NO
P1_REQUEST_BUDGET_REMAINING=1
CLEANUP_REQUIRED=NO_MUTATION_OCCURRED
CURRENT_GATE=G2C_REALITY_PUBLIC_TCP443_CANARY_P1
EXISTING_OWNER_AUTHORIZATION_REUSABLE=YES_WITHIN_IDENTICAL_BOUNDED_P1_SCOPE_AFTER_REVIEWER_RECONCILIATION
FRESH_OWNER_CONSEQUENTIAL_AUTH_REQUIRED=NO
OWNER_LOCAL_ACTION_REQUIRED=START_EXECUTOR_FROM_POWERSHELL_7.6.6_ADMINISTRATOR_HIGH
STOP_AT_REVIEWER=YES
```

Reviewer interpretation:
- The Executor correctly failed closed before any SSH, route, listener, runtime, Secret, or real request action because the local token was Medium integrity and not in the Administrator role.
- The project's sticky default execution channel is real-host Owner-run PowerShell 7.6.6 elevated to Administrator/High. The observed PowerShell 7.6.5 Medium session does not satisfy that channel.
- No consequential action began and the real-request counter remains zero, so the previously granted single-canary authorization is not consumed. The same bounded P1 may be retried only after the Owner starts the Executor from the required elevated PowerShell 7.6.6 environment.
- The retry restarts at fresh preflight. It does not inherit runtime facts from the blocked attempt and still cannot exceed one real OpenAI request.

## Reviewer superseding clarification — P1 Owner-local elevation boundary — 2026-10-03

```text
SUPERSEDES_EXECUTION_MECHANISM_ONLY=REVIEWER_RECONCILIATION_AT_90a8b6bd3a682c4e3e059cf570cd89b242c4da25
GATE_ID=G2C_REALITY_PUBLIC_TCP443_CANARY_P1
OWNER_AUTHORIZATION_CHANGED=NO
REQUEST_BUDGET=0_OF_1_CONSUMED
CODEX_ELEVATION_REQUIRED=NO
OWNER_LOCAL_CONSEQUENTIAL_CHECKPOINT_ELEVATION_REQUIRED=YES
REQUIRED_CHECKPOINT_RUNTIME=PowerShell_7.6.6
REQUIRED_CHECKPOINT_TOKEN=Administrator_High
NON_ELEVATED_EXECUTOR_ALLOWED=RUNNER_PREPARATION_AND_STATIC_REVIEW_ONLY
CONSEQUENTIAL_ACTIONS_FROM_NON_ELEVATED_EXECUTOR=FORBIDDEN
OWNER_RELAY=ONE_ATOMIC_COMMAND_ONLY
LINE_BY_LINE_OWNER_DEBUGGING=FORBIDDEN
```

Reviewer interpretation:
- Governance 11B requires the real Owner-host checkpoint that performs host-local consequential work to prove effective privilege and target identity. It does not require the Codex process that prepares the runner to inherit the elevated token.
- Therefore the previous instruction to launch Codex itself from elevated PowerShell was unnecessarily strict. The safer/minimal relay is: prepare and static-review the bounded runner without elevation, then have Owner run one atomic checkpoint from PowerShell 7.6.6 Administrator/High.
- This clarification changes only the execution mechanism, not the authorized P1 scope, acceptance criteria, one-request limit, or rollback boundary.

## G2C_REALITY_PUBLIC_TCP443_CANARY_P1 — Owner checkpoint prepared (2026-10-03)

```text
SOURCE_BASE=496f464029fad4a5747465ce441613104ed8ce06
RUNNER=vpn-network-optimization/scripts/g2c-reality-public-tcp443-canary-p1.ps1
RUNNER_PURPOSE=single bounded Owner-local P1 checkpoint; no runner execution in this preparation round
OWNER_CHECKPOINT_REQUIRED=PowerShell_7.6.6_Administrator_High
TOKEN_GATE_ORDER=PowerShell_7.6.6_then_Administrator_role_then_integrity_RID_ge_12288_then_source_preflight
CANONICAL_SOURCE_PREFLIGHT=Git_root_and_GitHub_origin_plus_tracked_clean_runner_and_current_authorized_gate_with_request_budget_0_of_1
POWERSHELL_AST_PARSE=PASS
REMOTE_PYTHON_AST_PARSE=PASS
PHYSICAL_EGRESS_MATCH_FIXTURE=PASS
EXACT_ROUTE_MATCH_FIXTURE=PASS
ROUTE_IFINDEX_MISMATCH_FAIL_CLOSED=PASS
AMBIGUOUS_PHYSICAL_EGRESS_FAIL_CLOSED=PASS
STRUCTURAL_REVIEW=PASS; one exact /32 add and remove path, dynamic interface/gateway, UFW/iptables-backend/nftables readback with unknown backends fail-closed, one OpenAI request call site, TCP/443-only listener, localhost-only client proxy, TUN disabled
SECRET_SCAN=PASS; no concrete Secret material found in runner
STATIC_REPAIR=Embedded remote Python server-config block indentation corrected after local Python AST parser exposed an IndentationError; re-parse PASS
RUNNER_EXECUTED=NO
OWNER_PREFLIGHT_EXECUTED=NO
SSH_STARTED=NO
VPS_READ_OR_WRITE=NO
TEMP_ROUTE_CREATED=NO
PUBLIC_LISTENER_STARTED=NO
SECRET_ACCESSED=NO
OPENAI_REQUEST_COUNT=0
P1_REQUEST_BUDGET_REMAINING=1
NETWORK_CHANGED=NO
REVIEWER_HANDOFF_MODIFIED=NO
STOP_BEFORE_OWNER_LOCAL_EXECUTION=YES
```

The runner fail-closes before SSH or other P1 actions unless the invoking Owner process is exactly PowerShell 7.6.6, is in the Windows Administrator role, and has integrity RID at least 12288. Static fixtures exercised only pure route/physical-egress helpers with synthetic non-secret values. Neither Owner host preflight nor the P1 consequential checkpoint was run by Executor. The Gate estimate of 20–30 minutes applies to the later Owner execution; consequential execution time is therefore not started. Preparation timing was not captured from the initial source read and is not reconstructed.
## Reviewer acceptance — G2C P1 runner preparation — 2026-10-03

```text
REVIEWED_RUNNER_COMMIT=4a4eae48dac1fd3c21638efb2dfe0fc6b69a4614
REVIEWER_RESULT=PASS_RUNNER_PREPARATION_ONLY
RUNNER_PATH=vpn-network-optimization/scripts/g2c-reality-public-tcp443-canary-p1.ps1
POWERSHELL_7_6_6_GATE_BEFORE_SSH=PASS
ADMINISTRATOR_HIGH_GATE_BEFORE_SSH=PASS
CANONICAL_SOURCE_GATE_BEFORE_RUNTIME_MUTATION=PASS
EXACT_ACTIVE_STORE_32_ROUTE_BOUNDARY=PASS
EXACT_ROUTE_CLEANUP_BOUNDARY=PASS
PUBLIC_TCP443_ONLY_SERVER_SCOPE=PASS
OPENAI_REQUEST_CALLSITE_COUNT=1
REQUEST_BUDGET_GUARD=PASS
REQUEST_BUDGET_MARKED_CONSUMED_ON_PROCESS_START=PASS
FINALLY_CLEANUP_PATH_PRESENT=PASS
STATIC_SECRET_BOUNDARY_REVIEW=PASS
REAL_P1_EXECUTED=NO
OPENAI_REQUEST_COUNT=0
P1_REQUEST_BUDGET_REMAINING=1
OWNER_CHECKPOINT_REQUIRED=YES
OWNER_CHECKPOINT_RUNTIME=PowerShell_7.6.6_Administrator_High
CURRENT_GATE=G2C_REALITY_PUBLIC_TCP443_CANARY_P1
```

Reviewer interpretation:
- The preparation round is accepted only as runner readiness; it is not evidence that public REALITY interoperability passed.
- The checkpoint verifies PowerShell 7.6.6, Administrator membership, and High integrity before SSH. It then verifies canonical source and fresh Gate/request-budget state before any P1 mutation.
- The temporary VPS public-IP route is ActiveStore-only, exact /32, dynamically bound to the single accepted physical egress, and cleanup removes only the matching exact route.
- The OpenAI canary has one call site and is guarded by request count/budget state. Once curl successfully starts, the request budget is marked consumed regardless of outcome; no retry is authorized.
- The final Owner action is one execution of the prepared checkpoint. Any RETURN is relayed back to Reviewer rather than manually repaired/replayed.
## Owner launcher reconciliation — P1 checkpoint not started — 2026-10-03

```text
OWNER_REPORTED_LAUNCHER=Start-Process against C:\Program Files\PowerShell\7\pwsh.exe
LAUNCHER_RESULT=FAIL_FILE_NOT_FOUND
P1_RUNNER_STARTED=NO
SSH_STARTED=NO
VPS_MUTATION_STARTED=NO
TEMP_ROUTE_CREATED=NO
PUBLIC_TCP443_LISTENER_STARTED=NO
OPENAI_REQUEST_COUNT=0
P1_REQUEST_BUDGET_REMAINING=1
HISTORICALLY_PROVEN_OWNER_RUNTIME=PowerShell_7.6.6_Administrator_High_RID_12288
HISTORICALLY_PROVEN_PWSH_LOCATION=C:\Program Files\WindowsApps\Microsoft.PowerShell_7.6.6.0_x64__8wekyb3d8bbwe\pwsh.exe
CORRECTION=DISCOVER_MICROSOFT_POWERSHELL_APPX_INSTALLLOCATION_AT_RUNTIME; DO_NOT_HARDCODE_PROGRAMFILES_POWERSHELL_7
```

Reviewer interpretation:
- The failure occurred in Windows PowerShell `Start-Process` before the P1 runner started, so it is not a P1 runtime failure and consumes no request budget.
- Project history already proves the Owner host previously ran PowerShell 7.6.6 elevated with Administrator=True and integrity RID 12288. The earlier successful installation was the Microsoft Store/AppX package, not the conventional Program Files PowerShell 7 directory.
- Future Owner relay must discover the current AppX InstallLocation and validate version 7.6.6 before elevation, instead of assuming an installation layout.
## Reviewer reconciliation — P1 canonical Git root preflight RETURN — 2026-10-03

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT_PLUS_REVIEWER_SOURCE_INSPECTION
GATE_ID=G2C_REALITY_PUBLIC_TCP443_CANARY_P1
OWNER_RUNTIME=PowerShell_7.6.6
ADMINISTRATOR_TOKEN=TRUE
INTEGRITY_RID=12288
HIGH_INTEGRITY_TOKEN=TRUE
RUNNER_PHASE=PRECHECK_CANONICAL_SOURCE
FAILURE_CODE=CANONICAL_GIT_ROOT_MISMATCH
CANONICAL_SOURCE_VERIFIED=FALSE
SSH_STARTED=NO
VPS_READ_OR_WRITE=NO
TEMP_ROUTE_CREATED=NO
PUBLIC_TCP443_LISTENER_STARTED=NO
SECRET_ACCESS_STARTED=NO
OPENAI_REQUEST_COUNT=0
P1_REQUEST_BUDGET_REMAINING=1
CLEANUP_READBACK=NOT_REQUIRED_NO_MUTATION
PERMANENT_FIREWALL_CHANGED=NO
PERMANENT_ROUTE_CHANGED=NO
HISTORICAL_CANONICAL_GIT_ROOT=C:\Users\34707\Documents\ChatGPT\VPS搭建
HISTORICAL_EXECUTION_WORKTREE=C:\Users\34707\.codex\worktrees\g2b-runner-binding-cleanup\VPS搭建
REVIEWER_RESULT=RETURN_ACCEPTED
ROOT_CAUSE_CLASS=RUNNER_SOURCE_PROVENANCE_PATH_DISCOVERY_DEFECT
NEXT_REPAIR_GATE=G2C_P1_CANONICAL_SOURCE_WORKTREE_DISCOVERY_H1
FRESH_OWNER_CONSEQUENTIAL_AUTH_REQUIRED=NO
```

Reviewer interpretation:
- The Owner execution channel is now positively reconfirmed: PowerShell 7.6.6, Administrator=True, High integrity RID 12288.
- The failure occurred in canonical-source validation before SSH or any consequential action. Therefore the one-request authorization remains unconsumed and no cleanup is required.
- Source inspection shows the P1 runner derives `repoRoot` by taking the parent of `vpn-network-optimization`, then requires Git `rev-parse --show-toplevel` to equal that guessed path. This is an unnecessary fixed-layout assumption and is the fault domain to repair.
- Historical project Evidence already records successful provenance from both the canonical checkout and the managed Codex worktree. The repair must ask Git for the actual worktree root from the live project path and validate the project-relative tracked files, rather than infer the Git root solely by parent depth.
- No Owner retry is allowed until the repaired runner is statically reviewed and accepted.

## Executor evidence — G2C_P1_CANONICAL_SOURCE_WORKTREE_DISCOVERY_H1 — 2026-10-03

```text
GATE_ID=G2C_P1_CANONICAL_SOURCE_WORKTREE_DISCOVERY_H1
PRE_GATE_HEAD=db94f252e450f0cb94be3d8c67259c6df2d6efa2
SOURCE_PROVENANCE=PASS
SOURCE_PROVENANCE_BASIS=FRESH_GITHUB_MAIN_PLUS_ISOLATED_WORKTREE
GIT_ROOT_DISCOVERY=REV_PARSE_FROM_ACTUAL_PROJECT_ROOT
PROJECT_TRACKED_RELATIVE_PATH=DYNAMIC_FROM_GIT_ROOT
FIXED_PARENT_DEPTH_REPOSITORY_ROOT_ASSUMPTION=REMOVED
CANONICAL_CHECKOUT_FIXTURE=PASS
MANAGED_CODEX_WORKTREE_FIXTURE=PASS
NESTED_TRACKED_PROJECT_PATH_FIXTURE=PASS
MISMATCHED_GIT_ROOT_PROJECT_PATH=FAIL_CLOSED
WRONG_ORIGIN=FAIL_CLOSED
INVALID_HEAD=FAIL_CLOSED
ACCEPTED_BASE_NOT_ANCESTOR=FAIL_CLOSED
RUNNER_UNTRACKED=FAIL_CLOSED
REVIEWER_HANDOFF_UNTRACKED=FAIL_CLOSED
RUNNER_DIRTY=FAIL_CLOSED
REVIEWER_HANDOFF_DIRTY=FAIL_CLOSED
GATE_ID_STATE_BUDGET_INVALID=FAIL_CLOSED
CURRENT_GATE_LF_FIXTURE=PASS
CURRENT_GATE_CRLF_FIXTURE=PASS
LOCAL_PRODUCTION_SOURCE_PREFLIGHT=PASS
POWERSHELL_AST_PARSE=PASS
UNCHANGED_RUNNER_FUNCTIONS=PASS
STATIC_SECRET_SCAN=PASS
STATIC_NETWORK_MUTATION_BOUNDARY=PASS
OWNER_PRIOR_FAILURE_PROVENANCE=OWNER_REPORTED_REVIEWER_ACCEPTED
OPENAI_REQUEST_COUNT=0
P1_REQUEST_BUDGET_REMAINING=1
SSH_STARTED=NO
VPS_READ_OR_WRITE=NO
TEMP_ROUTE_ADDED=NO
PUBLIC_TCP443_LISTENER_STARTED=NO
MIHOMO_STARTED=NO
SECRET_ACCESSED=NO
NETWORK_CHANGED=NO
REVIEWER_HANDOFF_MODIFIED=NO
```

The canonical-source check now asks Git for the real worktree root from the actual project directory, derives the project-relative paths from that root, and uses those paths for tracked/clean checks. Origin validation, valid HEAD, the existing accepted-base ancestry anchor, tracked runner/Reviewer source, clean-target checks, and current Gate/request-budget validation remain fail-closed. The local fixtures exercised the production path/fact helpers with non-secret values; no Owner checkpoint or P1 action was run. Initial source reconnaissance preceded a timing checkpoint, so total round elapsed time is not reconstructed.

### GitHub persistence read-back

```text
SOURCE_FIX_COMMIT=e5f1dd24064ccab47b2412fd8a3305a161c17ed6
SOURCE_FIX_PUSH=PASS
FRESH_FETCH_REMOTE_MAIN=e5f1dd24064ccab47b2412fd8a3305a161c17ed6
LOCAL_SOURCE_HEAD=e5f1dd24064ccab47b2412fd8a3305a161c17ed6
RUNNER_FRESH_READBACK=PASS
EVIDENCE_FRESH_READBACK=PASS
EXECUTOR_HANDOFF_FRESH_READBACK=PASS
REVIEWER_HANDOFF_MODIFIED=NO
```
## Reviewer acceptance — G2C_P1_CANONICAL_SOURCE_WORKTREE_DISCOVERY_H1 — 2026-10-03

```text
REVIEWED_COMPLETION_COMMIT=64461d63fb92c6e8944639198e5e1a385e6d8c59
REVIEWED_SOURCE_COMMIT=e5f1dd24064ccab47b2412fd8a3305a161c17ed6
REVIEWER_RESULT=PASS
GIT_ROOT_DISCOVERY=REV_PARSE_FROM_ACTUAL_PROJECT_ROOT
PROJECT_TRACKED_RELATIVE_PATH=DYNAMIC_FROM_GIT_ROOT
CANONICAL_CHECKOUT_FIXTURE=PASS
MANAGED_CODEX_WORKTREE_FIXTURE=PASS
NESTED_TRACKED_PROJECT_PATH_FIXTURE=PASS
MISMATCHED_GIT_ROOT_PROJECT_PATH=FAIL_CLOSED
WRONG_ORIGIN=FAIL_CLOSED
INVALID_HEAD=FAIL_CLOSED
ACCEPTED_BASE_NOT_ANCESTOR=FAIL_CLOSED
RUNNER_UNTRACKED=FAIL_CLOSED
REVIEWER_HANDOFF_UNTRACKED=FAIL_CLOSED
RUNNER_DIRTY=FAIL_CLOSED
REVIEWER_HANDOFF_DIRTY=FAIL_CLOSED
GATE_ID_STATE_BUDGET_INVALID=FAIL_CLOSED
CURRENT_GATE_LF_FIXTURE=PASS
CURRENT_GATE_CRLF_FIXTURE=PASS
LOCAL_PRODUCTION_SOURCE_PREFLIGHT=PASS
POWERSHELL_AST_PARSE=PASS
STATIC_SECRET_SCAN=PASS
STATIC_NETWORK_MUTATION_BOUNDARY=PASS
OPENAI_REQUEST_COUNT=0
P1_REQUEST_BUDGET_REMAINING=1
NETWORK_CHANGED=NO
OWNER_CHECKPOINT_EXECUTED=NO
NEXT_STEP=SYNC_EXISTING_MANAGED_WORKTREE_TO_REVIEWER_ACCEPTED_MAIN_THEN_OWNER_CHECKPOINT
```

Reviewer interpretation:
- The hardening removes the fixed parent-depth repository-root assumption and instead asks Git for the actual worktree root from the live project directory, then derives tracked-relative project paths.
- Provenance strictness is preserved: canonical origin, valid HEAD, accepted-base ancestry, tracked runner/Handoff, clean target paths, and exact current Gate/request-budget facts remain mandatory and fail closed.
- Positive fixtures cover the canonical checkout, the existing managed Codex worktree, and a nested tracked-project layout. Negative fixtures cover the material provenance failure classes relevant to this Gate.
- No P1 runtime action occurred; request budget remains 0/1.
- Because this Reviewer acceptance advances GitHub main beyond the Executor's local completion HEAD, the next action is a local Git synchronization/read-back only. The Owner checkpoint must not run from a stale worktree.
## Reviewer reconciliation — second P1 canonical-source preflight RETURN — 2026-10-03

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT_PLUS_REVIEWER_SOURCE_INSPECTION
GATE_ID=G2C_REALITY_PUBLIC_TCP443_CANARY_P1
OWNER_RUNTIME=PowerShell_7.6.6
ADMINISTRATOR_TOKEN=TRUE
INTEGRITY_RID=12288
HIGH_INTEGRITY_TOKEN=TRUE
RUNNER_PHASE=PRECHECK_CANONICAL_SOURCE
FAILURE_CODE=CANONICAL_GIT_PROJECT_PATH_MISMATCH
CANONICAL_SOURCE_VERIFIED=FALSE
SOURCE_HEAD=NOT_VERIFIED
SSH_STARTED=NO
VPS_READ_OR_WRITE=NO
TEMP_ROUTE_CREATED=NO
PUBLIC_TCP443_LISTENER_STARTED=NO
SECRET_ACCESS_STARTED=NO
OPENAI_REQUEST_COUNT=0
P1_REQUEST_BUDGET_REMAINING=1
CLEANUP_READBACK=NOT_REQUIRED_NO_MUTATION
PERMANENT_FIREWALL_CHANGED=NO
PERMANENT_ROUTE_CHANGED=NO
SIMILAR_PROVENANCE_FAILURE_COUNT=2
REVIEWER_RESULT=RETURN_ACCEPTED
NEXT_GATE=G2C_P1_CANONICAL_SOURCE_PATH_DIAGNOSTIC_D1
NEXT_GATE_MODE=READ_ONLY_LOCAL_DIAGNOSTIC
FRESH_OWNER_CONSEQUENTIAL_AUTH_REQUIRED=NO
OWNER_ACTION_REQUIRED=NONE
```

Reviewer interpretation:
- The Owner execution runtime is correct and is not the blocker.
- Git-root query advanced past the previous failure; the new failure occurs inside `Resolve-P1TrackedProjectPath`, where the live Git-root/projectRoot relationship does not match the assumed relative-path invariant.
- No consequential action began and the OpenAI request budget remains 0/1.
- This is the second materially similar source-provenance failure. Governance §6 therefore requires a bounded diagnostic rather than another speculative patch/retry.
- The next round is read-only and must capture the exact live path/worktree facts before any further source change or Owner checkpoint.
## Owner live diagnostic — Windows Git Unicode path decode mismatch — 2026-10-03

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT
ACTUAL_RUNNER_ABSOLUTE_PATH=C:\Users\34707\.codex\worktrees\g2b-runner-binding-cleanup\VPS搭建\vpn-network-optimization\scripts\g2c-reality-public-tcp443-canary-p1.ps1
COMPUTED_PROJECT_ROOT=C:\Users\34707\.codex\worktrees\g2b-runner-binding-cleanup\VPS搭建\vpn-network-optimization
GIT_SHOW_TOPLEVEL=C:/Users/34707/.codex/worktrees/g2b-runner-binding-cleanup/VPS鎼缓
GIT_SHOW_PREFIX=vpn-network-optimization/
DOTNET_RELATIVE_NORMALIZED=../VPS搭建/vpn-network-optimization
WORKTREE_LIST_CURRENT_PATH=C:/Users/34707/.codex/worktrees/g2b-runner-binding-cleanup/VPS搭建
WORKTREE_CURRENT_HEAD=7966a23645b0f2eb8eea5d9b7c446ec2354ed059
TRACKED_RUNNER=scripts/g2c-reality-public-tcp443-canary-p1.ps1
TRACKED_REVIEWER_HANDOFF=REVIEWER_HANDOFF.md
TARGET_STATUS_PORCELAIN=CLEAN
ORIGIN=https://github.com/entropy-student/project.git
ROOT_CAUSE_CLASS=WINDOWS_NATIVE_GIT_UNICODE_PATH_OUTPUT_DECODE_MISMATCH
OPENAI_REQUEST_COUNT=0
NETWORK_CHANGED=NO
```

Reviewer interpretation:
- Filesystem/worktree metadata agree on the real directory name `VPS搭建`; only decoded Git `--show-toplevel` is corrupted to `VPS鎼缓`.
- Feeding that corrupted path to `.NET GetRelativePath()` manufactured a false parent escape and caused `CANONICAL_GIT_PROJECT_PATH_MISMATCH`.
- Repair avoids the fragile Unicode absolute-root output entirely: Git checks now execute from the already-resolved project directory and require the canonical ASCII `--show-prefix=vpn-network-optimization/`.
- A `-CanonicalSourceOnly` mode was added so this repair can be proven on the Owner host without entering SSH/network/P1.
## Reviewer-directed source repair — avoid Unicode absolute Git-root decoding — 2026-10-03

```text
REPAIR_CLASS=CANONICAL_SOURCE_PROVENANCE_TRANSPORT_ENCODING
REMOVED_DEPENDENCY=git_rev_parse_show_toplevel_for_path_arithmetic
REPLACEMENT=git_rev_parse_show_prefix_from_actual_project_directory
EXPECTED_PREFIX=vpn-network-optimization/
GIT_COMMAND_CWD=actual_project_root
TARGET_PATHS=project_local_ASCII_paths
CANONICAL_SOURCE_ONLY_MODE=ADDED
REAL_P1_EXECUTED=NO
OPENAI_REQUEST_COUNT=0
NETWORK_CHANGED=NO
NEXT_PROOF=OWNER_LOCAL_CANONICAL_SOURCE_ONLY
```
## Reviewer acceptance — Owner CanonicalSourceOnly proof — 2026-10-03

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT_REVIEWED_AGAINST_CURRENT_RUNNER_AND_GATE
GATE_ID=G2C_REALITY_PUBLIC_TCP443_CANARY_P1
REVIEWER_RESULT=PASS
RUNNER_PHASE=CANONICAL_SOURCE_ONLY_PASS
FAILURE_CODE=NONE
POWERSHELL_RUNTIME=7.6.6
ADMINISTRATOR_TOKEN=TRUE
INTEGRITY_RID=12288
HIGH_INTEGRITY_TOKEN=TRUE
CANONICAL_SOURCE_VERIFIED=TRUE
SOURCE_HEAD=67c7ed2dc57e47bad10b4c2957b98b24d21ccfb3
CURRENT_GATE_PREFLIGHT=AUTHORIZED_BUDGET_0_OF_1
CANONICAL_SOURCE_ONLY_MODE=TRUE
OPENAI_REQUEST_COUNT=0
P1_REQUEST_BUDGET_REMAINING=1
NETWORK_CHANGED=NO
CLEANUP_READBACK=NOT_REQUIRED_NO_MUTATION
NEXT_STEP=RUN_REAL_P1_ONCE
FRESH_OWNER_CONSEQUENTIAL_AUTH_REQUIRED=NO
```

Reviewer interpretation:
- The Unicode-path provenance repair is behaviorally proven on the real Owner Windows host.
- Owner runtime, effective elevation, canonical source, current Gate, and unconsumed request budget pass together.
- This verification mode made no network, VPS, route, listener, Secret, or OpenAI request action.
- The existing P1 authorization remains valid; the real P1 may run once and must return to Reviewer after any outcome without manual retry.
## Owner P1 Windows preflight RETURN + local baseline diagnosis — 2026-10-03

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT_AND_READ_ONLY_LOCAL_DIAGNOSTIC
GATE_ID=G2C_REALITY_PUBLIC_TCP443_CANARY_P1
RUNNER_PHASE=PRECHECK_WINDOWS
FAILURE_CODE=UNEXPECTED_LOCAL_FAILURE
CANONICAL_SOURCE_VERIFIED=TRUE
SOURCE_HEAD=5b1f5799b23bd0d71181b33a5544dcd2928fc851
CURRENT_GATE_PREFLIGHT=AUTHORIZED_BUDGET_0_OF_1
WIREGUARD_ADAPTER=SFO2-A_IFINDEX_9_UP
CONTROL_ROUTE=SFO2-A_IFINDEX_9
SYSTEM_PROXY_ENABLED_BEFORE=FALSE
RUNNER_WINHTTP_DIRECT_BEFORE=FALSE
OWNER_API_WINHTTP_ACCESS_TYPE=1
OWNER_API_WINHTTP_ACCESS_NAME=NO_PROXY_DIRECT
OWNER_API_WINHTTP_PROXY_PRESENT=NO
OWNER_API_WINHTTP_BYPASS_PRESENT=NO
MIHOMO_PROCESS_COUNT_BEFORE=1
EXISTING_MIHOMO_NAME=verge-mihomo
EXISTING_MIHOMO_PATH=C:\ProgramData\clash-verge-service\cores\verge-mihomo.exe
EXISTING_MIHOMO_LISTENERS=127.0.0.1:9097;127.0.0.1:7900
P1_LOCAL_PROXY_TCP_17990_COUNT=0
P1_LOCAL_PROXY_UDP_17990_COUNT=0
SSH_STARTED=NO
VPS_READ_OR_WRITE=NO
TEMP_ROUTE_ADDED=FALSE
OPENAI_REQUEST_COUNT=0
P1_REQUEST_BUDGET_REMAINING=1
ROOT_CAUSE_1=WINHTTP_NATIVE_TEXT_LOCALIZATION_OR_DECODING_FALSE_NEGATIVE
ROOT_CAUSE_2=PREEXISTING_CLASH_VERGE_MIHOMO_BASELINE_WAS_INCORRECTLY_REQUIRED_TO_BE_ZERO
REPAIR_COMMIT=c6c15550333600aeafce282215424c6eede5d269
REPAIR_WINHTTP=WINDOWS_API_WINHTTP_DEFAULT_PROXY_CONFIGURATION
REPAIR_MIHOMO=ALLOW_UNRELATED_EXISTING_PROCESS_AND_REQUIRE_EXACT_BASELINE_PRESERVATION
REPAIR_FAILURE_CLASSIFIER=SYMBOLIC_ASSERT_CODE_PASSTHROUGH
LOCAL_PREFLIGHT_ONLY_MODE=ADDED
REAL_P1_EXECUTED=NO
NETWORK_CHANGED=NO
```

Reviewer interpretation:
- The Windows preflight failure occurred before SSH or any consequential action, so request budget remains 0/1.
- WinHTTP is actually direct according to the Windows WinHTTP API; the earlier text parser produced a false negative.
- The existing Mihomo process is the user's Clash Verge service and does not occupy P1 port 17990. P1 must preserve it rather than require all Mihomo processes to be absent.
- The repaired runner now proves these facts with a bounded local-preflight-only mode before any further real P1 attempt.

## Reviewer acceptance — Owner LocalPreflightOnly proof — 2026-10-03

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT_REVIEWED_AGAINST_CURRENT_RUNNER
GATE_ID=G2C_REALITY_PUBLIC_TCP443_CANARY_P1
REVIEWER_RESULT=PASS
RUNNER_PHASE=LOCAL_PREFLIGHT_ONLY_PASS
FAILURE_CODE=NONE
SOURCE_HEAD=d04e08e61cbac7fa511daba9c3b55f6725582b18
CANONICAL_SOURCE_VERIFIED=TRUE
POWERSHELL_RUNTIME=7.6.6
ADMINISTRATOR_TOKEN=TRUE
HIGH_INTEGRITY_TOKEN=TRUE
CLIENT_MIHOMO_VERSION=v1.19.31
PINNED_CLIENT_ARCHIVE_SHA256=PASS
PHYSICAL_EGRESS_DISCOVERY=WLAN|18|192.168.1.1|192.168.1.4
WIREGUARD_ADAPTER=SFO2-A|9|Up
CONTROL_ROUTE=SFO2-A|9
WINHTTP_DIRECT_BEFORE=TRUE
P1_TEST_MIHOMO_PROCESS_COUNT_BEFORE=0
TEMP_ROUTE_BEFORE=ACTIVE_MATCHES_0_PERSISTENT_MATCHES_0
REQUEST_COUNT=0
P1_REQUEST_BUDGET_REMAINING=1
NETWORK_MUTATION=NO
VPS_ACCESS=NO
NEXT_STEP=RUN_REAL_P1_ONCE
```

Reviewer interpretation:
- Windows local preflight is now behaviorally proven on the Owner host with the pinned official Mihomo v1.19.31 client.
- The physical egress, WireGuard/control-route baseline, WinHTTP state, local port exclusivity, and absence of P1 route residue all pass.
- No SSH, VPS access, route mutation, public listener, Secret action, or OpenAI request occurred.
- Existing P1 authorization remains valid and the real P1 may run exactly once.

## Reviewer acceptance — G2C REALITY public TCP/443 canary P1 — 2026-10-03

```text
PROVENANCE=OWNER_REPORTED_CONSOLE_OUTPUT_REVIEWED_AGAINST_ACCEPTED_P1_GATE
GATE_ID=G2C_REALITY_PUBLIC_TCP443_CANARY_P1
REVIEWER_RESULT=PASS
SOURCE_HEAD=7f6dd289d8909bb610f570d17832b335b47543ee
RUNNER_SOURCE_COMMIT=4065410817c9f206face86c49dfca2f43198223d
RUNNER_PHASE=ONE_OPENAI_REQUEST
FAILURE_CODE=NONE
CANONICAL_SOURCE_VERIFIED=TRUE
SERVER_IMPLEMENTATION=MIHOMO_V1_19_31_NATIVE
CLIENT_MIHOMO_VERSION=v1.19.31
PINNED_CLIENT_ARCHIVE_SHA256=PASS
TARGET_HOSTNAME=ubuntu-s-1vcpu-512mb-10gb-sfo3
STRICT_SSH_HOST_KEY_TRUST=PASS
VPS_PUBLIC_IP_MATCH_COUNT=1
WG_SERVICE=active
HY2_SERVICE=active
TCP443_BEFORE=0
TCP14443_BEFORE=0
TEMP_ROUTE_ADDED=TRUE
TEMP_ROUTE_SELECTED=24.199.118.137/32|WLAN|18|192.168.1.1
SERVER_BINARY_VERSION=v1.19.31
SERVER_ASSET_SHA256=PASS
SERVER_CONFIG_CHECK=PASS
PUBLIC_TCP443_LISTENER=YES
SERVER_OWNED_LISTENER_COUNT=1
PUBLIC_TCP_REACHABILITY=PASS
CLIENT_CONFIG_CHECK=PASS
CLIENT_PROXY_PROCESS=READY
REQUEST_COUNT=1
CURL_EXIT=0
HTTP_STATUS=401
CURL_TIME_TOTAL=0.834066
CURL_TIME_CONNECT=0.001372
CURL_TIME_APPCONNECT=0.620132
CLIENT_ERROR_CLASS=NONE_OBSERVED
SERVER_ERROR_CLASS=NO_SERVER_ERROR_OBSERVED
PUBLIC_REALITY_INTEROPERABILITY=PASS
SERVER_RSS_KIB_AT_READY=40712
CLIENT_MIHOMO_STOPPED=YES
SERVER_MIHOMO_STOPPED=YES
CLIENT_RUNTIME_DELETED=YES
REMOTE_RUNTIME_DELETED=YES
TEMP_ROUTE_REMOVED=YES
TCP443_AFTER=0
TCP14443_AFTER=0
WG_SERVICE_AFTER=active
HY2_SERVICE_AFTER=active
LOCAL_BASELINE_UNCHANGED=TRUE
WG_HY2_PRESERVED=TRUE
SYSTEM_PROXY_UNCHANGED=TRUE
WINHTTP_UNCHANGED=TRUE
TUN_UNCHANGED=TRUE
PERMANENT_FIREWALL_CHANGED=NO
PERMANENT_ROUTE_CHANGED=NO
CLEANUP_READBACK=PASS
REQUEST_BUDGET_REMAINING=0
SECRET_VALUES_EMITTED=0
SECRET_VALUES_COMMITTED=0
ACTUAL_ELAPSED=00:00:19.9681927
```

Reviewer interpretation:
- The accepted Mihomo v1.19.31 VLESS+REALITY+Vision candidate is proven over the intended public TCP/443 path.
- The VPS public IPv4 outer connection was forced through the dynamically discovered physical WLAN egress by one temporary exact /32 route.
- Exactly one authorized OpenAI request was consumed and returned curl exit 0 / HTTP 401.
- Public TCP/443 exposure, client/server runtimes, and the temporary route were removed successfully.
- WireGuard, HY2, system proxy, WinHTTP, TUN, firewall state, and routing baseline were preserved.
- No persistent change, permanent firewall/routing change, or Secret emission/commit occurred.
- The one-request P1 budget is exhausted; this Gate must not be replayed absent a separately authorized future Gate.

## Reviewer acceptance — G3A network adaptation local engineering H1 — 2026-10-03

```text
PROVENANCE=OWNER_REPORTED_POWERSHELL_OUTPUT_REVIEWED_AGAINST_PINNED_H1_SOURCE
GATE_ID=G3A_NETWORK_ADAPTATION_LOCAL_ENGINEERING_H1
REVIEWER_RESULT=PASS
IMPLEMENTATION_COMMIT=eef00e13e51734d892b74de7c20efc9f5243f23f
HANDOFF_PIN_COMMIT=cfdf8c23048b30dd70309eb29ec22deed98eceb1
POWERSHELL_RUNTIME=7.6.6
OWNER_EXECUTION_PRIVILEGE=NON_ADMINISTRATOR
PLANNER_AST=PASS
G3A_SELFTEST_CASES=9
G3A_SELFTEST_RESULT=PASS
PLANNER_MODE=ADVISORY_ONLY
STATIC_SOURCE_REVIEW=PASS
HISTORICAL_WLAN_CONSTANTS_PRESENT=NO
LIVE_ROUTE_MUTATION_CODE_PRESENT=NO
SERVICE_MUTATION_CODE_PRESENT=NO
SYSTEM_PROXY_MUTATION_CODE_PRESENT=NO
TUN_MUTATION_CODE_PRESENT=NO
SSH_OR_HTTP_ACTION_CODE_PRESENT=NO
NETWORK_MUTATION=NO
SERVICE_MUTATION=NO
SYSTEM_PROXY_MUTATION=NO
TUN_MUTATION=NO
VPS_MUTATION=NO
SECRET_VALUES_READ=0
SECRET_VALUES_EMITTED=0
```

Reviewer interpretation:
- H1 source and deterministic fixture behavior satisfy the accepted plan-only Gate.
- Dynamic physical-egress selection is not tied to historical WLAN address/gateway/ifIndex values.
- Valid, missing, and ambiguous physical-egress fixtures are covered.
- WireGuard baseline, HY2 fallback, REALITY fallback, no-safe-role, and ambiguous-health cases are fail-closed as designed.
- H1 performs no live route, service, proxy, TUN, VPS, SSH, or HTTP action and reads/emits no Secret values.
- H1 is formally closed. The next G3-A step may collect real read-only health/readiness facts, but live switching remains separately gated.

## G3A H2 control-route validator diagnostic — 2026-10-03

```text
PROVENANCE=OWNER_REPORTED_READ_ONLY_POWERSHELL_DIAGNOSTIC
GATE_ID=G3A_READONLY_HEALTH_READINESS_H2
H2_INITIAL_RESULT=RETURN_DIAGNOSTIC_ONLY
INITIAL_WG_CONTROL_ROUTE_VALID=FALSE
INITIAL_WIREGUARD_CURRENT_HEALTH=UNHEALTHY
STRICT_SSH_CONTROL_PATH=SUCCEEDED_IN_SAME_H2_RUN
REMOTE_WG_SERVICE=active
REMOTE_UDP_51820=2
SELECTED_INTERFACE_ALIAS=SFO2-A
SELECTED_INTERFACE_INDEX=9
WG_INTERFACE_INDEX=9
SELECTED_ROUTE_IS_WG=TRUE
NETWORK_MUTATION=NO
SERVICE_MUTATION=NO
EXTERNAL_REQUEST_COUNT=0
ROOT_CAUSE=H2_CONTROL_ROUTE_CARDINALITY_VALIDATOR_TOO_STRICT
ACCEPTED_REFERENCE_SEMANTICS=P1_REQUIRES_AT_LEAST_ONE_ROUTE_AND_VALIDATES_SELECTED_FIRST_ROUTE
REPAIR_COMMIT=48a831a7de40741515a91c835d8a09b6ae45f943
REAL_WORKLOAD_RETRY=NOT_APPLICABLE
```

Reviewer interpretation:
- The H2 `WIREGUARD_CURRENT_HEALTH=UNHEALTHY` result was a collector false negative, not accepted evidence that WireGuard was unhealthy.
- The same H2 run successfully used the strict SSH control path to `10.66.21.1`, while the bounded diagnostic independently proved the selected route uses `SFO2-A` ifIndex 9.
- H2 incorrectly required exactly one `Find-NetRoute` result. The already accepted P1 logic requires at least one result and validates the selected first route.
- The repair aligns H2 with accepted P1 route semantics and adds a deterministic multi-route regression fixture.

## Reviewer acceptance — G3A read-only health/readiness H2 — 2026-10-03

```text
PROVENANCE=OWNER_REPORTED_POWERSHELL_OUTPUT_REVIEWED_AGAINST_REPAIRED_H2_SOURCE
GATE_ID=G3A_READONLY_HEALTH_READINESS_H2
REVIEWER_RESULT=PASS
COLLECTOR_REPAIR_COMMIT=48a831a7de40741515a91c835d8a09b6ae45f943
H2_SELFTEST_CASES=10
H2_SELFTEST_RESULT=PASS
POWERSHELL_RUNTIME=7.6.6
PHYSICAL_EGRESS=WLAN|18|192.168.1.1|192.168.1.4
WG_ADAPTER=SFO2-A|9|Up
WG_MANAGER_RUNNING=TRUE
WG_TUNNEL_RUNNING=TRUE
WG_CONTROL_ROUTE_VALID=TRUE
WG_SPLIT_DEFAULTS_VALID=TRUE
CLASH_SERVICE_RUNNING=TRUE
SYSTEM_PROXY_ENABLED=FALSE
WINHTTP_ACCESS_TYPE=1
TUN_ADAPTER_COUNT=0
P1_ROUTE_RESIDUE_COUNT=0
HY2_RECOVERY_ARTIFACT_PRESENT=TRUE
REALITY_PINNED_CLIENT_PRESENT=TRUE
REALITY_PINNED_ARCHIVE_HASH_PASS=TRUE
TARGET_HOSTNAME=ubuntu-s-1vcpu-512mb-10gb-sfo3
VPS_PUBLIC_IP_MATCH_COUNT=1
REMOTE_WG_SERVICE=active
REMOTE_HY2_SERVICE=active
REMOTE_UDP_51820=2
REMOTE_UDP_8443=1
REMOTE_TCP_443=0
REMOTE_TCP_14443=0
REMOTE_G2C_RUNTIME_RESIDUE=0
REMOTE_UFW_STATUS=inactive
REMOTE_IPTABLES_BACKEND=nf_tables
REMOTE_NFT_INPUT_POLICY=NO_INPUT_HOOK
WIREGUARD_CURRENT_HEALTH=HEALTHY
HY2_READINESS=READY_FOR_SEPARATE_ACTIVATION
REALITY_READINESS=READY_FOR_SEPARATE_ACTIVATION
REALITY_INTEROP_REPROBED=NO
EXTERNAL_WORKLOAD_REQUEST_COUNT=0
NETWORK_MUTATION=NO
SERVICE_MUTATION=NO
SYSTEM_PROXY_MUTATION=NO
TUN_MUTATION=NO
VPS_MUTATION=NO
VPN_APPLICATION_SECRET_VALUES_READ=0
SECRET_VALUES_EMITTED=0
SSH_PRIVATE_KEY_VALUE_EXPOSED=NO
G3A_H2_READONLY_RESULT=COMPLETE
```

Reviewer interpretation:
- H2 is formally PASS after the control-route validator repair and 10-case regression suite.
- WireGuard is currently healthy on both Owner-host and VPS-side evidence.
- HY2 is ready for a separately reviewed activation Gate; this does not mean a persistent HY2 client is currently active.
- REALITY is ready as a cold candidate for a separately reviewed activation Gate; TCP/443 being free and no persistent REALITY listener are expected.
- The previous H2 `WIREGUARD_CURRENT_HEALTH=UNHEALTHY` result is superseded as a validator false negative by the accepted diagnostic and repaired rerun.
- No P1 route/runtime/listener residue exists.
- No external workload request, network/service/proxy/TUN/VPS mutation, VPN/application Secret read, or Secret emission occurred.

