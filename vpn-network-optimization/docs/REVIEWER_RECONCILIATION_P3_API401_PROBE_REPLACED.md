# Reviewer Reconciliation — Replace OpenAI API 401 Probe with Normal ChatGPT Functional Smoke

Status: P3_PROBE_CONTRACT_REVISED

Date: 2026-10-07

## Fresh Owner baseline evidence

Owner restored the pre-P3 baseline profile and ran the Reviewer read-only network diagnostic.

Observed:

```text
WG_MANAGER_RUNNING=YES
WG_TUNNEL_RUNNING=YES
WG_ADAPTER_UP=YES
WG_MTU=1280
DNS_API_OPENAI_COM=PASS
DNS_API_IPIFY_ORG=PASS
DNS_WWW_CLOUDFLARE_COM=PASS
TCP443_API_OPENAI_COM=YES
TCP443_API_IPIFY_ORG=YES
TCP443_WWW_CLOUDFLARE_COM=YES
OPENAI_CURL_EXIT=35
OPENAI_RESULT=000|0.431954|0.000000
IPIFY_CURL_EXIT=0
IPIFY_RESULT=200|0.435927|0.686562
CLOUDFLARE_CURL_EXIT=0
CLOUDFLARE_RESULT=200|0.424815|0.647364
PUBLIC_IP=24.199.118.137
NETWORK_MUTATION=NONE
```

## Interpretation

The current production WireGuard path is healthy for general HTTPS and public egress, but `api.openai.com/v1/models` is reset on the accepted baseline itself.

Therefore an expected HTTP 401 from that endpoint is not a valid discriminator for the new nodes in this environment.

The earlier HY2 attempt remains UNVERIFIED, not FAIL.

## Owner acceptance scope

The prior explicit Owner scope is retained:

```text
FINAL_VALIDATION_SCOPE=CHATGPT_THREE_ROLE_SMOKE_ONLY
REQUIRED_ROLES=HY2,WG,REALITY
ACCEPTANCE=EACH_ROLE_MANUALLY_SELECTED_IN_CLASH_AND_CAN_CONTINUE_NORMAL_CHATGPT_CONVERSATION
HEAVY_BENCHMARKS=NOT_REQUIRED
```

## Revised P3 probe model

For each node:

1. select the node in Clash `PROXY`;
2. verify explicit Clash SOCKS egress through `https://api.ipify.org` equals `143.198.159.233`;
3. enable Clash system proxy temporarily, keep TUN off and old standalone WireGuard connected;
4. refresh the active ChatGPT page so a fresh browser connection is created through the selected Clash node;
5. Owner sends one short test message and receives a normal assistant response;
6. turn system proxy off before changing to the next node.

No `api.openai.com/v1/models` request is required.

P3 remains functional smoke only.
