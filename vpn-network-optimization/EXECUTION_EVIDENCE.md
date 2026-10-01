# VPN Network Optimization — EXECUTION EVIDENCE

> G1 evidence is metadata-only. No private key, password, token, certificate key, or other Secret value is recorded.

## Execution boundary

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

## G2-A fresh execution evidence (2026-10-01)

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

