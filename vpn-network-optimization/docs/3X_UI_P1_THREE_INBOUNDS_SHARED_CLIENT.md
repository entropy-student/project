# 3x-ui Fast Path P1 — Contain Subscription + Create Three Inbounds and Shared Client

Status: REVIEWER_RELEASED / EXECUTOR_P1

## GATE_ID

`3XUI_FASTPATH_P1_THREE_INBOUNDS_SHARED_CLIENT`

## OBJECTIVE

On fresh target `143.198.159.233`:

1. verify the current public subscription listener has no valid anonymous content;
2. disable the subscription server before any client is created;
3. add a small swap safety net for the 512 MB host;
4. create exactly three 3x-ui-managed inbounds:
   - Hysteria2 / UDP 8443
   - WireGuard / UDP 51820
   - VLESS + REALITY + XTLS Vision / TCP 443
5. create one shared 3x-ui client attached to all three inbounds, so one future Sub ID can aggregate all three;
6. enable the three inbounds and prove server-side listener/runtime readiness;
7. leave the subscription server disabled until P2;
8. persist sanitized Evidence and STOP_AT_REVIEWER.

P1 does **not** expose or import the subscription URL and does not modify the old VPS.

## ACCEPTED P0 FACTS

Executor may rely on:

```text
TARGET=143.198.159.233
HOSTNAME=ubuntu-s-1vcpu-512mb-10gb-sfo3
OS=Ubuntu_24.04
ARCH=x86_64
3X_UI_VERSION=v3.9.0
PANEL_ADMIN=127.0.0.1:54912
PANEL_PUBLICLY_BOUND=NO
SUBSCRIPTION_DEFAULT_LISTENER=*:2096
TCP_443=FREE
UDP_8443=FREE
UDP_51820=FREE
RAM_TOTAL_MB=458
RAM_AVAILABLE_MB=210
SWAP_TOTAL_MB=0
ROOT_FREE_MB=6276
OLD_VPS=24.199.118.137_OUT_OF_SCOPE
```

P0 formal decision:
`docs/REVIEWER_DECISION_3XUI_P0_FRESH_VPS_BOOTSTRAP_INSTALL_PASS.md`

## MAX_ENDPOINT_THIS_ROUND

Public negative subscription check -> subscription containment -> optional 1 GiB swap creation under the exact rule below -> three disabled inbound creation -> one shared client creation -> enable/read-back all three -> resource/readiness read-back -> Evidence -> STOP_AT_REVIEWER.

Do not enter P2.

## MANDATORY_REVIEW_STOP

YES

## EXECUTION CHANNEL

Local Codex/Executor -> strict SSH -> fresh target `143.198.159.233`.

Use the existing accepted identity and explicit known-host trust from P0.

Old VPS `24.199.118.137` is forbidden.

## P1 PRE-MUTATION PUBLIC BOUNDARY CHECK

Before any target mutation, from the Executor host probe public `143.198.159.233:2096` with random impossible/nonexistent IDs.

At minimum:

- raw path equivalent to `/sub/<fresh-random-nonexistent>`;
- Mihomo alias equivalent to `/mihomo/<fresh-random-nonexistent>`.

No existing real Sub ID may be used.

Expected result: no 2xx body with subscription/node data. A nonexistent subscription is expected to return 404; Clash/Mihomo may also be unavailable while `subClashEnable=false`.

Unexpected successful sensitive response -> `RETURN_SUBSCRIPTION_PUBLIC_BOUNDARY_UNEXPECTED` before mutation.

## SECRET HANDLING / LOCAL API CONTRACT

All panel API actions must occur through the loopback admin API inside the target.

The Executor may use a reviewed ephemeral Python process delivered over SSH stdin. The process may:

- read `/etc/x-ui/install-result.env` directly into process memory;
- parse panel port/base path/API token in memory;
- send `Authorization: Bearer <token>` only to the loopback panel API;
- carry generated protocol Secrets in process memory;
- write only explicitly approved target Secret files with restrictive permissions.

It must not:

- export Secrets to environment variables;
- put Secrets in command arguments;
- print API responses containing credentials;
- emit UUID/auth/private keys/Sub ID/API token;
- write plaintext Secret temp files;
- copy Secret values to the local Windows host, repo, Evidence, shell history or chat.

Only allowlisted sanitized fields may leave the protected process.

## PHASE 1 — CONTAIN SUBSCRIPTION SERVER

Using local panel API/application settings, not ad-hoc SQLite edits:

1. fetch current settings inside protected process memory;
2. set `subEnable=false` while preserving all unrelated settings exactly;
3. invoke the normal panel restart path;
4. verify x-ui returns active;
5. verify TCP/2096 listener is absent;
6. verify admin panel remains loopback-only.

Failure/ambiguity -> stop before client creation.

P2 will own secure re-enablement.

## PHASE 2 — RESOURCE SAFETY NET

Because P0 proved only 458 MB RAM and zero swap, P1 may create **one 1 GiB swap file** only if:

- `SWAP_TOTAL_MB=0`;
- root free remains > 4 GiB before creation;
- no existing `/swapfile` object exists.

Exact desired state:

```text
/swapfile
owner=root
mode=0600
size=1GiB
mkswap=valid
swapon=active
/etc/fstab contains exactly one project-created /swapfile swap entry
```

If `/swapfile` exists or fstab state is ambiguous, RETURN `RETURN_RESOURCE_PREFLIGHT_DRIFT`; do not overwrite.

After creation, read back active swap. No other sysctl/BBR/resource tuning is allowed.

## PHASE 3 — OFFICIAL v3.9.0 CONFIG SOURCES

Do not guess payload shapes.

Executor may narrowly inspect these official 3x-ui **v3.9.0** sources only as needed:

- `frontend/src/pages/api-docs/endpoints.ts`
- `frontend/src/lib/xray/inbound-defaults.ts`
- `frontend/src/lib/xray/inbound-form-adapter.ts`
- `frontend/src/pages/inbounds/form/protocols/hysteria.tsx`
- `frontend/src/pages/inbounds/form/protocols/wireguard.tsx`
- `frontend/src/pages/inbounds/form/protocols/vless.tsx`
- `frontend/src/pages/inbounds/form/security/reality.tsx`
- `frontend/src/schemas/protocols/inbound/hysteria.ts`
- `frontend/src/schemas/protocols/inbound/wireguard.ts`
- `frontend/src/schemas/protocols/security/reality.ts`
- `docs/content/docs/en/config/reality.mdx`

Use the v3.9.0 REST API, not direct DB writes.

## PHASE 4 — CREATE THREE INBOUNDS DISABLED FIRST

Create exactly three new local inbounds, initially disabled and with no clients.

Common:

```text
shareAddrStrategy=custom
shareAddr=143.198.159.233
enable=false
total=0
expiryTime=0
excludeFromSub=false
```

### A. VLESS + REALITY + Vision

```text
remark=SELF-REALITY-SFO3
protocol=vless
listen=
port=443
network=tcp
security=reality
decryption=none
encryption=none
```

Requirements:

- use local API `/panel/api/server/scanRealityTargets` and choose the first feasible **public** target returned by the v3.9.0 scanner;
- no private/local target;
- generate Reality X25519 pair through local `/panel/api/server/getNewX25519Cert`;
- generate a fresh CSPRNG short ID inside protected process memory;
- client-side Reality fingerprint = `chrome`;
- xver=0;
- no ML-DSA/extra experimental options;
- no private key output.

The future shared client's per-inbound flow must be `xtls-rprx-vision`.

### B. Hysteria2

```text
remark=SELF-HY2-SFO3
protocol=hysteria
port=8443
version=2
network=hysteria
```

Hysteria2 must use TLS.

Fast secure certificate path:

- generate a fresh self-signed ECDSA P-256 certificate/key on the VPS for this project;
- store under a project-owned root-only certificate directory under `/etc/x-ui/`;
- private key mode 0600, root-owned;
- certificate may be public/readable as required by x-ui runtime;
- compute the leaf certificate SHA-256 pin inside the protected process;
- configure the Hysteria TLS client settings with `pinnedPeerCertSha256`;
- do **not** use `allowInsecure` / `skip-cert-verify`;
- do not emit certificate private key or client auth.

Use the official v3.9.0 Hysteria stream/TLS shape. No masquerade, port hopping or Salamander obfuscation in v1.

### C. WireGuard

```text
remark=SELF-WG-SFO3
protocol=wireguard
port=51820
mtu=1420
subnetIp=10.0.0.0
subnetCidr=24
noKernelTun=false
```

Generate the server WireGuard secret key with a CSPRNG Curve25519/WireGuard-compatible 32-byte private scalar inside protected process memory. The private key stays only in the inbound DB/API transaction and is never emitted.

No pre-shared key is required for v1.

## PHASE 5 — CREATE ONE SHARED CLIENT

After all three disabled inbounds exist and their IDs are known inside the protected process, use the official v3.9.0:

`POST /panel/api/clients/add`

Create exactly one client attached to all three inbound IDs.

Use a generic non-personal identifier such as:

`owner-main`

Set:

```text
enable=true
totalGB=0
expiryTime=0
limitIp=0
limitHwid=0
tgId=0
flow=xtls-rprx-vision
```

Omit per-protocol client Secrets so the v3.9.0 server generates:

- VLESS UUID;
- Hysteria auth;
- WireGuard client private/public key and free tunnel /32;
- Sub ID when absent.

No generated client field may be emitted.

Read back only sanitized facts:

- exactly one client record with expected generic identifier;
- attached inbound count = 3;
- Sub ID present = YES, value not emitted;
- VLESS credential present = YES;
- HY2 auth present = YES;
- WG keypair present = YES;
- WG allowed IP present = YES.

## PHASE 6 — ENABLE AND READ BACK

Enable the three inbounds using official API/application methods.

Required final server state:

```text
TCP/443 = xray/REALITY listener
UDP/8443 = xray/Hysteria2 listener
UDP/51820 = xray/WireGuard listener
TCP/2096 subscription = CLOSED
admin panel = loopback-only
x-ui service = active
three inbounds = enabled
shared client attachments = 3
```

If enabling one inbound fails or Xray becomes unhealthy:

- stop further enablement/mutation;
- classify which exact inbounds/client objects committed;
- do not blindly replay;
- RETURN with sanitized phase/protocol/error class.

## VALIDATION

After final enablement:

- x-ui active;
- Xray runtime active/healthy according to panel/runtime read-back;
- exact three expected listeners present;
- admin listener remains loopback-only;
- subscription listener remains absent;
- no unexpected new listening ports attributable to this Gate;
- swap read-back if created;
- RAM available, root free and OOM-kill counter recorded;
- old VPS untouched;
- Secret output count zero.

No full client connectivity smoke in P1; P3 owns real Clash traffic.

## ROLLBACK

The target is still a fresh dedicated deployment with no accepted user/business data.

If P1 fails after mutation:

- use exact created object IDs retained inside protected execution state;
- disable/delete only the P1-created inbounds/client through official API when safe;
- revert `subEnable` only if required to restore the accepted P0 state;
- remove P1-created swap only if rollback specifically requires it and its ownership is proven;
- preserve P0 3x-ui installation and loopback admin panel;
- old VPS is never part of rollback.

Ambiguous partial state -> read-only reconciliation, not replay.

## REQUIRED EVIDENCE

Persist only sanitized fields, including:

```text
P0_FORMAL_PASS=YES
PUBLIC_SUB_NEGATIVE_CHECK=PASS
SUB_ENABLE_FINAL=NO
SUB_2096_FINAL=CLOSED
SWAP_ACTION=CREATED_1G|PREEXISTING_NONZERO
SWAP_TOTAL_MB_FINAL=<integer>
INBOUND_COUNT_CREATED=3
REALITY_INBOUND_PRESENT=YES
REALITY_PORT=443
REALITY_TARGET_FEASIBLE=YES
REALITY_PRIVATE_KEY_PRESENT=YES
REALITY_PRIVATE_KEY_EMITTED=NO
HY2_INBOUND_PRESENT=YES
HY2_PORT=8443
HY2_TLS_PIN_PRESENT=YES
HY2_ALLOW_INSECURE=NO
WG_INBOUND_PRESENT=YES
WG_PORT=51820
WG_SERVER_SECRET_PRESENT=YES
SHARED_CLIENT_COUNT=1
SHARED_CLIENT_ATTACHMENT_COUNT=3
SHARED_CLIENT_SUBID_PRESENT=YES
SHARED_CLIENT_SUBID_EMITTED=NO
TCP_443_LISTENER=YES
UDP_8443_LISTENER=YES
UDP_51820_LISTENER=YES
ADMIN_LOOPBACK_ONLY=YES
XUI_SERVICE_ACTIVE=YES
RAM_AVAILABLE_MB_FINAL=<integer>
ROOT_FREE_MB_FINAL=<integer>
OOM_KILL_COUNTER_FINAL=<integer>
SECRET_VALUES_EMITTED=0
OLD_VPS_MUTATION=NO
STOP_AT_REVIEWER=YES
```

## ACCEPTANCE CRITERIA

P1 can be `PASS_CANDIDATE` only when all required Evidence is available and:

- default public subscription listener is contained before client creation;
- swap safety net is either safely created per contract or an already-active nonzero swap is proven;
- exactly three intended inbounds exist and are enabled;
- one shared client is attached to exactly all three;
- Reality target is scanner-proven feasible;
- HY2 uses certificate pinning and not insecure TLS;
- required TCP/UDP listeners are present;
- panel remains loopback-only;
- subscription server remains disabled;
- x-ui/Xray remain healthy with no OOM;
- Secret values emitted = 0;
- old VPS mutation = NO.

## OWNER_ONLY_ACTIONS

NONE.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. this Gate;
2. current `vpn-network-optimization/REVIEWER_HANDOFF.md`;
3. P0 PASS decision;
4. only the explicitly listed official 3x-ui v3.9.0 source files when payload details are needed.

Do not read legacy G1-G4/R19-R22/Baidu material.

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
改动：一句话说明 subscription containment、swap 和三入站/共享 client 的实际变化。
验证：一句话总结三监听、共享 client、资源、安全边界和 Secret 检查。
问题：NONE 或精确协议/阶段阻塞。
回滚：一句话说明精确可恢复对象与当前安全状态。
请 Reviewer 检查：P1 三入站配置、共享 client 和 listener/resource Evidence。
Owner 转交：NONE。
```
