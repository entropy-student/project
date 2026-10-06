# 3x-ui Fast Path P3 — Clash Import + Three-Node Functional Smoke

Status: REVIEWER_RELEASED / EXECUTOR_P3_INTERACTIVE

## GATE_ID

`3XUI_FASTPATH_P3_CLASH_IMPORT_THREE_NODE_SMOKE`

## OBJECTIVE

Prove the Owner can consume the accepted 3x-ui HTTPS Mihomo subscription in Clash Verge and manually switch among:

1. `SELF-HY2-SFO3`
2. `SELF-WG-SFO3`
3. `SELF-REALITY-SFO3`

Each selected node must carry one bounded OpenAI request and one public-exit request through Clash.

This is a functional smoke only. No latency/throughput benchmark, p95/p99 matrix, image-generation workload, or long-running load is required.

## ACCEPTED P2 STATE

```text
TARGET=143.198.159.233
DELIVERY_MODE=VALID_HTTPS_IP_SUBSCRIPTION
HTTPS_CERT_NORMAL_VALIDATION=PASS
HTTPS_CERT_IP_SAN=PASS
CERT_AUTO_RENEW=PASS
SUB_2096=TLS
SUB_CLASH_ENABLE=YES
PUBLIC_REAL_MIHOMO_STATUS=200
LOCAL_SECRET_URL_FILE=%LOCALAPPDATA%\vpn-network-optimization\3xui-fastpath\subscription.url
LOCAL_STAGED_PROFILE=%LOCALAPPDATA%\vpn-network-optimization\3xui-fastpath\self-vpn-3xui.yaml
MIHOMO_PROFILE_PARSE=PASS
PROXY_COUNT=3
OLD_VPS=24.199.118.137_CURRENT_FALLBACK
```

Formal P2 decision:
`docs/REVIEWER_DECISION_3XUI_P2_SECURE_MIHOMO_DELIVERY_PASS.md`

## EXECUTION MODEL

P3 is intentionally interactive because selecting/importing a profile inside the Owner's running Clash Verge GUI is an Owner-visible control-plane action.

Executor performs all preflight/read-back/network probes.

Owner only performs the exact GUI actions prompted by Executor and returns the exact structured acknowledgement strings.

Do not ask Owner to type or paste any Secret into chat.

## MAX ENDPOINT

baseline snapshot -> import remote HTTPS subscription -> activate new profile with system proxy/TUN still OFF -> select each node -> bounded explicit-Clash probes -> restore previous active profile/selector/network baseline while leaving the new subscription imported -> Evidence -> STOP_AT_REVIEWER.

Do not enter P4.

## PRECHECK

Executor must prove before Owner GUI action:

- Clash Verge service/process healthy;
- standalone old WireGuard remains connected/healthy;
- system proxy = OFF;
- Clash TUN = OFF;
- no exact active/persistent route already exists for `143.198.159.233/32`;
- current active profile identity/hash recorded;
- profile store snapshot recorded;
- locally staged `subscription.url` is Owner-only;
- local HTTPS subscription fetch succeeds through normal Windows certificate validation;
- local staged YAML still parses with installed Mihomo;
- new VPS server-side 443/TCP, 8443/UDP, 51820/UDP remain healthy if a narrow strict-SSH read-back is needed;
- old VPS is not mutated.

Unexpected baseline drift -> RETURN before import.

## SECRET BOUNDARY

The HTTPS subscription URL contains a protected Sub ID.

Allowed:

- Executor may read the URL only in protected local process memory.
- Executor may open the protected URL file locally for the Owner or otherwise facilitate local copy/paste without echoing the URL into terminal/chat/logs.
- Clash Verge may persist the remote subscription URL in its own application profile store as the intended final product state.

Forbidden:

- URL in GitHub/Evidence/chat;
- URL in shell history or ordinary stdout/stderr;
- URL passed in a way that exposes it in process command-line logging when avoidable.

Protocol credentials remain inside Clash profile/application storage and protected local staging.

## OWNER UI STEP 1 — IMPORT REMOTE SUBSCRIPTION

Executor prompts Owner to import the HTTPS URL contained in:

`%LOCALAPPDATA%\vpn-network-optimization\3xui-fastpath\subscription.url`

Use Clash Verge's normal **remote subscription / profile URL import**.

Do not enable `Allow invalid certificates`; normal TLS validation already passed.

After import, Owner activates the newly imported profile while:

- standalone WireGuard remains connected;
- system proxy remains OFF;
- Clash TUN remains OFF.

Owner confirms the new profile shows exactly:

- `SELF-HY2-SFO3`
- `SELF-WG-SFO3`
- `SELF-REALITY-SFO3`
- selector/group `PROXY`.

Expected acknowledgement:

```text
P3_IMPORT_ACK|IMPORT=YES|REMOTE_SUBSCRIPTION=YES|PROFILE_ACTIVE=YES|HY2_VISIBLE=YES|WG_VISIBLE=YES|REALITY_VISIBLE=YES|PROXY_GROUP_VISIBLE=YES|SYSTEM_PROXY=OFF|TUN=OFF
```

Executor must then read back that Clash profile-store state changed as expected and that the old WireGuard/network baseline remains healthy.

## LOCAL CLASH PROXY DISCOVERY

Discover the live local Clash/Mihomo SOCKS5 listener dynamically.

Do not hardcode the historical port.

Require exactly one local no-auth SOCKS5 listener attributable to the running Clash/Mihomo process.

All smoke requests use that explicit SOCKS5 listener; system proxy and TUN remain OFF throughout P3.

## THREE-NODE SMOKE

For each node, Owner manually selects it in the `PROXY` group and gives the exact acknowledgement.

### A. HY2

Owner selects:

`SELF-HY2-SFO3`

Ack:

```text
P3_HY2_ACK|CURRENT=SELF-HY2-SFO3|SYSTEM_PROXY=OFF|TUN=OFF
```

Executor sends exactly two requests through the explicit local SOCKS5 proxy:

1. `https://api.openai.com/v1/models`
   - curl/network success required;
   - HTTP `401` is accepted proof of OpenAI reachability without credentials.

2. `https://api.ipify.org`
   - response must equal new VPS public IP `143.198.159.233`.

Required:

```text
HY2_OPENAI_HTTP=401
HY2_PUBLIC_EXIT=143.198.159.233
HY2_SMOKE=PASS
```

### B. WireGuard

Repeat with:

`SELF-WG-SFO3`

Ack:

```text
P3_WG_ACK|CURRENT=SELF-WG-SFO3|SYSTEM_PROXY=OFF|TUN=OFF
```

Same exact two requests.

Required:

```text
WG_OPENAI_HTTP=401
WG_PUBLIC_EXIT=143.198.159.233
WG_SMOKE=PASS
```

### C. REALITY

Repeat with:

`SELF-REALITY-SFO3`

Ack:

```text
P3_REALITY_ACK|CURRENT=SELF-REALITY-SFO3|SYSTEM_PROXY=OFF|TUN=OFF
```

Same exact two requests.

Required:

```text
REALITY_OPENAI_HTTP=401
REALITY_PUBLIC_EXIT=143.198.159.233
REALITY_SMOKE=PASS
```

Total intentional functional-smoke traffic: exactly 6 requests.

No delay test or bandwidth test.

## NESTED-TRANSPORT NOTE

The old standalone WireGuard remains connected during P3 as rollback protection. The new Clash proxy's outer connection may therefore traverse the old WireGuard path during this smoke.

This does **not** invalidate P3 because the acceptance proof is that each selected 3x-ui node terminates successfully and the final public exit is the new VPS `143.198.159.233`.

P4 owns the final cutover away from the old standalone WireGuard so normal operation no longer nests transports.

Do not add persistent routes in P3.

## POST-SMOKE RESTORE

After all three PASS:

Owner switches back to the exact pre-P3 active Clash profile.

Leave the newly imported 3x-ui remote subscription present in Clash Verge for P4.

Keep:

- system proxy OFF;
- TUN OFF;
- old standalone WireGuard connected;
- no new persistent route.

Ack:

```text
P3_RESTORE_ACK|BASELINE_PROFILE_ACTIVE=YES|NEW_3XUI_PROFILE_RETAINED=YES|SYSTEM_PROXY=OFF|TUN=OFF|OLD_WG_CONNECTED=YES
```

Executor read-back must prove:

- baseline active profile restored;
- new remote subscription remains imported;
- old WG service/tunnel state matches baseline;
- system proxy/TUN match baseline;
- route snapshot matches baseline;
- no `143.198.159.233/32` persistent route exists.

## FAILURE / ROLLBACK

If any node fails:

- stop further node tests;
- return the selector to a known working/baseline state;
- restore pre-P3 active profile;
- keep system proxy/TUN off;
- keep old WG connected;
- leave the new subscription imported unless it is itself corrupt/unsafe;
- record only sanitized protocol/failure class;
- do not modify server protocol settings inside P3.

Server-side repair requires a separate narrow Reviewer Gate.

## REQUIRED EVIDENCE

```text
P2_FORMAL_PASS=YES
REMOTE_SUBSCRIPTION_IMPORT=PASS
REMOTE_SUBSCRIPTION_NORMAL_TLS=PASS
PROFILE_THREE_NODES_VISIBLE=PASS
CLASH_LOCAL_SOCKS5_DISCOVERY=PASS
HY2_SMOKE=PASS
HY2_OPENAI_HTTP=401
HY2_PUBLIC_EXIT_MATCH=YES
WG_SMOKE=PASS
WG_OPENAI_HTTP=401
WG_PUBLIC_EXIT_MATCH=YES
REALITY_SMOKE=PASS
REALITY_OPENAI_HTTP=401
REALITY_PUBLIC_EXIT_MATCH=YES
INTENTIONAL_SMOKE_REQUEST_COUNT=6
BASELINE_PROFILE_RESTORED=YES
NEW_3XUI_PROFILE_RETAINED=YES
SYSTEM_PROXY_FINAL=OFF
TUN_FINAL=OFF
OLD_WG_FINAL=CONNECTED
ROUTE_SNAPSHOT_RESTORED=YES
PERSISTENT_NEW_VPS_ROUTE=NO
SECRET_VALUES_EMITTED=0
OLD_VPS_MUTATION=NO
STOP_AT_REVIEWER=YES
```

## ACCEPTANCE CRITERIA

P3 PASS_CANDIDATE requires:

- normal-TLS remote subscription imported;
- all three nodes visible;
- each node manually selected in the same Clash `PROXY` group;
- each node gets OpenAI 401 and new-VPS public exit through explicit Clash SOCKS5;
- exactly six intentional smoke requests;
- baseline network state restored afterward;
- new 3x-ui subscription remains imported;
- Secret output zero;
- old VPS mutation zero.

## OWNER_ONLY_ACTIONS

Only the bounded Clash Verge GUI steps and structured acknowledgements requested while the Executor is running.

No server console action is required.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. this Gate;
2. current `vpn-network-optimization/REVIEWER_HANDOFF.md`;
3. P2 formal PASS decision;
4. current Clash Verge runtime/profile metadata needed for P3.

Legacy project material may be consulted only for the already-accepted pattern of read-only Clash state discovery; do not execute historical Gates/runners wholesale.

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE / RETURN_*
改动：说明远程订阅导入、三节点 smoke 与最终 baseline restore。
验证：说明三节点 OpenAI/public-exit 结果、请求计数和最终 Clash/WG/route 状态。
问题：NONE 或精确失败节点/阶段。
回滚：说明是否已恢复旧 profile/WG/system proxy/TUN/route baseline。
请 Reviewer 检查：三节点 smoke Evidence 和最终恢复状态。
Owner 转交：NONE（若已完成交互）；或精确剩余 GUI 步骤。
```
