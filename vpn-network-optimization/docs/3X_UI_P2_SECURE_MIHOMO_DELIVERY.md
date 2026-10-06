# 3x-ui Fast Path P2 — Secure Mihomo Delivery + Clash-Ready Staging

Status: REVIEWER_RELEASED / EXECUTOR_P2

## GATE_ID

`3XUI_FASTPATH_P2_SECURE_MIHOMO_DELIVERY`

## OBJECTIVE

Turn the accepted P1 three-node state into one Clash Verge / Mihomo-consumable profile on the Owner Windows host without switching live traffic yet.

Preferred delivery:

`VALID_HTTPS_IP_SUBSCRIPTION`

Bounded fallback if official IP-certificate issuance is unavailable:

`OWNER_LOCAL_STATIC_MIHOMO_SNAPSHOT`

Either path must produce a locally parsed, Owner-only Clash-ready artifact containing exactly the three accepted nodes.

## ACCEPTED P1 STATE

```text
TARGET=143.198.159.233
3X_UI_VERSION=v3.9.0
ADMIN_PANEL=127.0.0.1:54912
SUB_ENABLE=NO
SUB_2096=CLOSED
HY2=UDP_8443 / inbound_id=1
WG=UDP_51820 / inbound_id=2
REALITY=TCP_443 / inbound_id=3
SHARED_CLIENT=owner-main
SHARED_CLIENT_ATTACHMENTS=3
SHARED_CLIENT_SUBID_PRESENT=YES
SWAP_TOTAL_MB=1023
XRAY_RUNTIME_HEALTHY=YES
OLD_VPS=24.199.118.137_OUT_OF_SCOPE
```

Formal P1 decision:
`docs/REVIEWER_DECISION_3XUI_P1_THREE_INBOUNDS_SHARED_CLIENT_PASS.md`

## MAX ENDPOINT

Secure subscription/profile generation -> protected transfer/staging to Owner Windows -> installed `verge-mihomo.exe` parse -> sanitized Evidence -> STOP_AT_REVIEWER.

Do not activate the new profile, do not change system proxy/TUN, do not stop standalone WireGuard, and do not send traffic through the three new nodes in P2.

## EXECUTION CHANNEL

Local Codex/Executor -> strict SSH -> fresh target.

Windows local artifact location must be outside Git and Owner-only, under:

`%LOCALAPPDATA%\vpn-network-optimization\3xui-fastpath\`

Suggested files:

- `subscription.url` — only when HTTPS subscription mode succeeds;
- `self-vpn-3xui.yaml` — Mihomo profile snapshot;
- `delivery.meta` — non-secret mode/version metadata only.

The directory and Secret-bearing files must have inheritance disabled and only the current Owner SID granted access.

No Secret-bearing file may enter GitHub.

## COMMON PRECHECK

Before mutation:

- strict SSH target identity remains accepted;
- x-ui active;
- Xray healthy;
- exactly three expected inbounds enabled;
- shared client still attached to exactly three;
- subscription remains disabled and TCP/2096 closed;
- admin remains loopback-only;
- TCP/80 is not already owned by an unrelated service;
- old VPS is not contacted.

Unexpected state -> RETURN, no repair guessing.

## PROFILE NAMING

Before generating the Mihomo profile, set the subscription remark template through the official local panel API to:

`{{INBOUND}}`

Preserve all unrelated settings.

Expected proxy names:

- `SELF-HY2-SFO3`
- `SELF-WG-SFO3`
- `SELF-REALITY-SFO3`

The generated `PROXY` select group must present those three nodes plus `DIRECT`, with HY2 first.

## DELIVERY MODE A — PREFERRED VALID HTTPS IP SUBSCRIPTION

3x-ui v3.9.0 officially supports a Let's Encrypt short-lived certificate for a bare IPv4 address.

Use one bounded official-equivalent ACME attempt for:

`143.198.159.233`

Requirements:

1. port 80 must be free locally before issuance;
2. use Let's Encrypt short-lived IP certificate profile;
3. fixed installed certificate paths:
   - `/root/cert/ip/fullchain.pem`
   - `/root/cert/ip/privkey.pem`
4. private key remains root-only;
5. renewal configuration/cron must exist;
6. renewal reload must restart x-ui so the subscription server reloads the renewed certificate;
7. no certificate private key is emitted.

If issuance succeeds, configure through official local panel settings while preserving unrelated settings:

```text
subEnable=true
subPort=2096
subCertFile=/root/cert/ip/fullchain.pem
subKeyFile=/root/cert/ip/privkey.pem
subClashEnable=true
remarkTemplate={{INBOUND}}
```

A public URL base may be set to the bare-IP HTTPS origin if needed by the panel.

After restart prove:

- x-ui active;
- admin remains loopback-only;
- TCP/2096 is TLS, not plaintext HTTP;
- certificate validates against IP `143.198.159.233` using normal system trust, with no `-k`/insecure bypass;
- certificate SAN contains the target IP;
- the real Mihomo endpoint for the protected shared Sub ID returns HTTP 200;
- a fresh nonexistent Sub ID returns 404/no node data.

Do not print or persist the real Sub ID in Evidence.

### HTTPS failure boundary

If the single bounded IP-certificate attempt fails because of ACME reachability/CA/environment conditions:

- do not repeatedly retry;
- do not weaken TLS;
- leave/revert public subscription disabled;
- continue to Delivery Mode B.

Record only a sanitized failure class.

## DELIVERY MODE B — STATIC MIHOMO SNAPSHOT FALLBACK

This fallback is allowed only if Mode A is unavailable.

Keep the subscription server non-public:

- either `subEnable=false`, or
- bind it only to loopback for the minimum protected generation interval.

Enable Mihomo generation internally as needed, fetch the real shared-client Mihomo YAML entirely inside the trusted target/local SSH channel, then return subscription exposure to disabled/non-public state.

No public HTTP subscription is allowed.

## MIHOMO CONTENT VALIDATION

Whether obtained through Mode A or B, validate the raw generated YAML without logging its contents.

Required sanitized shape:

```text
PROXY_COUNT=3
PROXY_NAMES=SELF-HY2-SFO3,SELF-WG-SFO3,SELF-REALITY-SFO3
HY2_TYPE=hysteria2
HY2_PORT=8443
HY2_CERT_PIN_PRESENT=YES
HY2_SKIP_CERT_VERIFY=NO
WG_TYPE=wireguard
WG_PORT=51820
WG_CLIENT_PRIVATE_KEY_PRESENT=YES
WG_SERVER_PUBLIC_KEY_PRESENT=YES
WG_TUNNEL_IP_PRESENT=YES
REALITY_TYPE=vless
REALITY_PORT=443
REALITY_SECURITY_PRESENT=YES
REALITY_PUBLIC_KEY_PRESENT=YES
REALITY_SHORT_ID_PRESENT=YES
REALITY_FLOW=xtls-rprx-vision
PROXY_GROUP=PROXY_SELECT
PROXY_GROUP_ORDER=HY2,WG,REALITY,DIRECT
FINAL_RULE=MATCH,PROXY
```

Credential values must never be emitted.

## PROTECTED WINDOWS TRANSFER

Transfer the generated Mihomo YAML to the Owner-only local runtime path without printing it.

Preferred:

- create a target-side root-only transient profile file from the protected API/process;
- copy it with strict SCP to an already Owner-only local directory;
- immediately delete the target transient copy;
- verify local ACL before any parser invocation.

For Mode A, also create `subscription.url` locally without printing its contents. It must contain the exact HTTPS Mihomo URL including the protected Sub ID.

Do not place the URL in a command-line argument if that would expose it through process inspection or logs; use process memory / protected file input.

## LOCAL MIHOMO PARSE

Use the installed Clash Verge Mihomo binary:

`C:\Program Files\Clash Verge\verge-mihomo.exe`

Run a config parse/test against the protected local `self-vpn-3xui.yaml`.

No activation.

Required:

`MIHOMO_PROFILE_PARSE=PASS`

If installed binary path/version differs, narrowly discover the actual Clash Verge Mihomo binary and record only sanitized path/version metadata.

## WINDOWS BASELINE PRESERVATION

P2 must leave unchanged:

- current active Clash profile;
- current selector;
- system proxy state;
- Clash TUN state;
- standalone WireGuard service/tunnel state;
- route table.

P2 may snapshot hashes/metadata for later P3 comparison but must not activate/import the new profile.

## FINAL SERVER STATE

If Mode A succeeds:

```text
DELIVERY_MODE=VALID_HTTPS_IP_SUBSCRIPTION
SUB_ENABLE=YES
SUB_2096=TLS
SUB_CLASH_ENABLE=YES
CERT_AUTO_RENEW=YES
```

If Mode B is used:

```text
DELIVERY_MODE=STATIC_MIHOMO_SNAPSHOT_FALLBACK
PUBLIC_SUBSCRIPTION=DISABLED
LOCAL_PROFILE_READY=YES
```

In both cases:

- three VPN inbounds remain enabled/healthy;
- admin remains loopback-only;
- old VPS untouched.

## REQUIRED EVIDENCE

Persist only sanitized markers:

```text
P1_FORMAL_PASS=YES
DELIVERY_MODE=VALID_HTTPS_IP_SUBSCRIPTION|STATIC_MIHOMO_SNAPSHOT_FALLBACK
ACME_IP_ATTEMPT=PASS|FAILED_BOUNDED|NOT_NEEDED
HTTPS_CERT_NORMAL_VALIDATION=PASS|NOT_APPLICABLE
HTTPS_CERT_IP_SAN=PASS|NOT_APPLICABLE
CERT_AUTO_RENEW=PASS|NOT_APPLICABLE
PUBLIC_REAL_MIHOMO_STATUS=200|NOT_APPLICABLE
PUBLIC_RANDOM_SUB_NEGATIVE=PASS|NOT_APPLICABLE
PROXY_COUNT=3
HY2_PROFILE_SHAPE=PASS
WG_PROFILE_SHAPE=PASS
REALITY_PROFILE_SHAPE=PASS
PROXY_GROUP_ORDER=PASS
WINDOWS_OWNER_ONLY_PROFILE=PASS
WINDOWS_OWNER_ONLY_SUB_URL=PASS|NOT_APPLICABLE
MIHOMO_PROFILE_PARSE=PASS
ACTIVE_CLASH_PROFILE_CHANGED=NO
SYSTEM_PROXY_CHANGED=NO
TUN_CHANGED=NO
WIREGUARD_BASELINE_CHANGED=NO
ROUTE_SNAPSHOT_CHANGED=NO
ADMIN_LOOPBACK_ONLY=YES
XRAY_RUNTIME_HEALTHY=YES
SECRET_VALUES_EMITTED=0
OLD_VPS_MUTATION=NO
STOP_AT_REVIEWER=YES
```

## ROLLBACK

If Mode A partially configures subscription exposure but fails acceptance:

- restore `subEnable=false`;
- restart x-ui;
- prove TCP/2096 closed;
- keep issued certificate files if valid (they are not dangerous on their own) unless exact cleanup is needed;
- remove incomplete local staged artifacts;
- preserve P1 VPN inbounds/client/swap.

If local staging fails after server success, leave valid HTTPS subscription in place and return exact local failure; do not destroy P1.

## OWNER_ONLY_ACTIONS

NONE in P2.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. this Gate;
2. current `REVIEWER_HANDOFF.md`;
3. P1 formal PASS decision;
4. official 3x-ui v3.9.0 files narrowly needed for IP certificate / subscription settings;
5. current local Clash Verge metadata required for non-mutating baseline snapshot and Mihomo parse.

Legacy VPN material is reference-only. Do not resume historical Gates.

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
改动：说明 HTTPS IP 订阅或静态 Mihomo fallback，以及本机受保护配置落地情况。
验证：说明三节点 profile shape、Mihomo parse、TLS/订阅边界和 Windows baseline。
问题：NONE 或精确阻塞。
回滚：说明服务器订阅暴露与本地 artifact 当前安全状态。
请 Reviewer 检查：P2 delivery mode、Mihomo 三节点结构、TLS 与本机 baseline Evidence。
Owner 转交：NONE。
```
