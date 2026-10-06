# 3x-ui Fast Path P1 Executor Evidence

```text
RESULT=PASS_CANDIDATE
GATE_ID=3XUI_FASTPATH_P1_THREE_INBOUNDS_SHARED_CLIENT
EXECUTOR_RELEASE=REVIEWER_RELEASED_EXECUTOR_P1
EVIDENCE_UTC=2026-10-06 14:19 UTC
P0_FORMAL_PASS=YES
TARGET=143.198.159.233
TARGET_HOSTNAME=ubuntu-s-1vcpu-512mb-10gb-sfo3
TARGET_OS=Ubuntu_24.04
TARGET_ARCH=x86_64
3X_UI_VERSION=v3.9.0
DATABASE_BACKEND=SQLite
OLD_VPS_MUTATION=NO
P2_ACTIONS=NONE

PUBLIC_SUB_NEGATIVE_CHECK=PASS
PUBLIC_RAW_SUB_HTTP_STATUS_BEFORE=404
PUBLIC_RAW_SUB_NODE_DATA_BEFORE=NO
PUBLIC_MIHOMO_HTTP_STATUS_BEFORE=404
PUBLIC_MIHOMO_NODE_DATA_BEFORE=NO
PUBLIC_SUB_POST_CONTAINMENT=PASS
PUBLIC_TCP_2096_REACHABLE_AFTER=NO

SUB_ENABLE_FINAL=NO
SUB_2096_FINAL=CLOSED
SUB_SETTINGS_OTHER_FIELDS_PRESERVED=YES
ADMIN_LOOPBACK_ONLY=YES
ADMIN_LISTENER=127.0.0.1:54912
XUI_SERVICE_ACTIVE=YES
XRAY_RUNTIME_HEALTHY=YES

SWAP_ACTION=CREATED_1G
SWAPFILE_PATH=/swapfile
SWAPFILE_SIZE_BYTES=1073741824
SWAPFILE_OWNER_MODE=root:root_0600
SWAPFILE_ACTIVE=YES
FSTAB_PROJECT_SWAP_ENTRY_COUNT=1
SWAP_TOTAL_MB_FINAL=1023

INBOUND_COUNT_CREATED=3
INBOUND_ID_HY2=1
INBOUND_ID_WG=2
INBOUND_ID_REALITY=3
INBOUND_ALL_ENABLED=YES
HY2_INBOUND_PRESENT=YES
HY2_PORT=8443
HY2_TLS_PIN_PRESENT=YES
HY2_TLS_PIN_READBACK_MATCH=YES
HY2_ALLOW_INSECURE=NO
HY2_PRIVATE_KEY_PRESENT=YES
HY2_PRIVATE_KEY_EMITTED=NO
WG_INBOUND_PRESENT=YES
WG_PORT=51820
WG_SERVER_SECRET_PRESENT=YES
WG_SERVER_SECRET_EMITTED=NO
REALITY_INBOUND_PRESENT=YES
REALITY_PORT=443
REALITY_TARGET_FEASIBLE=YES
REALITY_PRIVATE_KEY_PRESENT=YES
REALITY_PRIVATE_KEY_EMITTED=NO

SHARED_CLIENT_COUNT=1
SHARED_CLIENT_IDENTIFIER=owner-main
SHARED_CLIENT_ATTACHMENT_COUNT=3
SHARED_CLIENT_SUBID_PRESENT=YES
SHARED_CLIENT_SUBID_EMITTED=NO
SHARED_CLIENT_FLOW=xtls-rprx-vision
VLESS_CREDENTIAL_PRESENT=YES
HY2_AUTH_PRESENT=YES
WG_CLIENT_KEYPAIR_PRESENT=YES
WG_ALLOWED_IP_PRESENT=YES

TCP_443_LISTENER=YES
UDP_8443_LISTENER=YES
UDP_51820_LISTENER=YES
UNEXPECTED_XUI_XRAY_LISTENER=NO
RAM_TOTAL_MB_FINAL=458
RAM_AVAILABLE_MB_FINAL=205
ROOT_FREE_MB_FINAL=5252
OOM_KILL_COUNTER_FINAL=0
OOM_COUNTER_SOURCE=/proc/vmstat:oom_kill
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

## Verification

- Strict SSH used the P0-accepted identity and explicit known-host trust for the fresh target. Target hostname, OS and architecture matched the accepted P0 target.
- Before any P1 target mutation, fresh impossible random IDs were probed at both public HTTP routes. Both returned HTTP 404 with no node-data markers. No probe ID or response body was retained in Evidence. After containment, a fresh public probe could not connect to TCP/2096 and received no body.
- The local panel API changed only `subEnable` to `false`; the read-back comparison confirmed all other settings were unchanged. Once the panel restart settled, x-ui was active, TCP/2096 was absent, and the admin listener remained loopback-only before any client was created.
- The 1 GiB swap file is root-owned mode 0600, exactly 1,073,741,824 bytes, active, and has exactly one project-created fstab swap entry. Linux reports 1023 MiB available as swap after swap metadata overhead.
- The three API-created inbounds were read back disabled before creating the client. REALITY used the first feasible public scanner result and a fresh API-generated X25519 keypair. HY2 uses an ECDSA P-256 self-signed certificate with the target IP SAN; its SHA-256 DER pin was computed inside the protected target process and read back matching the configured `pinnedPeerCertSha256`. Certificate and private-key values were not emitted.
- The single `owner-main` client was created once via the official API with no protocol credentials supplied. Read-back showed it enabled, attached to exactly inbound IDs 1/2/3, with Sub ID present and VLESS, HY2 and WireGuard credentials present. No credential or Sub ID value was emitted.
- Each inbound was enabled through the official API and each enable was followed by a healthy Xray API status, x-ui active state, expected listener presence, closed TCP/2096, loopback-only panel and no unexpected x-ui/Xray listener. A later independent strict-SSH snapshot confirmed TCP/443, UDP/8443 and UDP/51820; a fresh panel API read confirmed exactly three enabled inbounds, Xray `running`, subscription disabled and three client attachments.
- The final OOM kill counter was read as zero from `/proc/vmstat`. Final resource read-back recorded 205 MB available RAM and 5,252 MB root free.
- One executor-side aggregate read-back routine failed to parse its final snapshot after all three enable operations. No subsequent target writes were made; independent SSH and panel API read-backs above completed successfully.

## Secret boundary

The API token and all generated protocol credentials remained in protected target-process memory or protected target storage. The API token was read from `/etc/x-ui/install-result.env` only inside the target process. No token, password, UUID, private key, auth value, Sub ID or subscription URL was written to this repository or emitted to stdout/stderr/chat.

## Rollback state

P0 installation remains intact. P1 state is the exact subscription-server disablement, project-owned swap file and fstab line, HY2 certificate/key under `/etc/x-ui/p1-hy2-tls/`, three enabled inbound IDs 1/2/3 and one shared client. No rollback was applied; all P1 acceptance checks passed. The old VPS was not accessed.

STOP_AT_REVIEWER=YES
