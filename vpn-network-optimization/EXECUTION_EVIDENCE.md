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
