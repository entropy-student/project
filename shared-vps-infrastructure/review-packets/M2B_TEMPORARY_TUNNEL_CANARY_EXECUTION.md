# M2B — Temporary Tunnel Canary Execution

## Gate

```text
M2B_TEMPORARY_TUNNEL_CANARY
WRITE_GATE=YES
OWNER_AUTHORIZED=YES
STOP_AT_REVIEWER=YES
```

## Read first

Read canonical Governance latest and:

```text
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2B_OWNER_AUTHORIZED_TEMPORARY_TUNNEL_CANARY.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Do not enter M2C.

## Exact authorized canary

```text
TUNNEL=spikersun-shared-private
TEMP_HOSTNAME=minicraft-m2b-canary.spikersun.com
ORIGIN_SERVICE=http://mini-craft-night-kit-wordpress:80
ORIGIN_HTTP_HOST_HEADER=minicraft.spikersun.com
```

The canary hostname is temporary and must be absent again before successful completion.

## Phase A — authenticated provider preflight

Use the Owner-authenticated Cloudflare Dashboard session.

If not authenticated:

```text
RETURN_OWNER_CLOUDFLARE_SESSION_REQUIRED
STOP_AT_REVIEWER=YES
```

No credential entry or recovery is authorized.

Read-only verify:

1. Tunnel `spikersun-shared-private` exists and is healthy;
2. `minicraft-m2b-canary.spikersun.com` is absent from Tunnel public hostnames;
3. the exact temp hostname is absent from DNS;
4. `minicraft.spikersun.com` current DNS production record is unchanged from the current DNS-A-to-Caddy architecture;
5. existing routes remain:
   - `shop.spikersun.com -> http://dujiao-next-app:8080`
   - `pay.spikersun.com -> http://unified-pay-app:8080`
   - `xianyu.spikersun.com -> http://xianyu-app:8090`

If any temp collision or material drift exists:

```text
RETURN_M2B_PREFLIGHT_DRIFT
STOP_AT_REVIEWER=YES
```

## Phase B — create exact temporary Tunnel route

Create exactly one temporary public hostname:

`minicraft-m2b-canary.spikersun.com`

On existing Tunnel:

`spikersun-shared-private`

Service:

`http://mini-craft-night-kit-wordpress:80`

Origin request setting:

```text
HTTP Host Header=minicraft.spikersun.com
```

Allow only the DNS record required for this exact Tunnel public hostname.

Do not change any other public hostname, DNS record, Tunnel setting, connector, WARP/private-network setting, or access policy.

## Phase C — postwrite control-plane readback

Prove:

```text
TEMP_PUBLIC_HOSTNAME_PRESENT=YES
TEMP_PUBLIC_HOSTNAME_TUNNEL=spikersun-shared-private
TEMP_ORIGIN_SERVICE=http://mini-craft-night-kit-wordpress:80
TEMP_ORIGIN_HTTP_HOST_HEADER=minicraft.spikersun.com
TEMP_DNS_PRESENT=YES
```

Read back the three pre-existing public-hostname routes and require exact origin mappings unchanged.

Also confirm production `minicraft.spikersun.com` DNS record itself was not changed.

## Phase D — bounded canary

Use public HTTPS requests to:

- `https://minicraft-m2b-canary.spikersun.com/`
- `https://minicraft-m2b-canary.spikersun.com/shop/`
- `https://minicraft-m2b-canary.spikersun.com/wp-json/`

Do not send authenticated cookies, payment data, order data, admin credentials, or existing WordPress sessions.

Use normal TLS verification.

Allow a short bounded propagation window with at most three read-only validation attempts. Do not mutate anything between attempts.

Preferred PASS:

```text
TEMP_HOME_HTTP=200
TEMP_SHOP_HTTP=200
TEMP_WP_REST_HTTP=200
TEMP_TLS_VALID=YES
```

If a response redirects to the canonical Mini Craft origin, record the safe scheme/host/path and classify it; do not treat temporary-host cookie/session behavior as production-session proof.

Also fresh check:

```text
PRODUCTION_HOME_HTTP=200
PRODUCTION_SHOP_HTTP=200
PRODUCTION_WP_REST_HTTP=200
PRODUCTION_DNS_A_TO_CADDY_UNCHANGED=YES
```

## Phase E — mandatory temporary cleanup

Whether the canary passes or fails, remove only:

- the temporary Tunnel public hostname created by this Gate;
- the exact temporary DNS record created for it, if it remains separately present.

Then fresh read back:

```text
TEMP_PUBLIC_HOSTNAME_PRESENT=NO
TEMP_DNS_PRESENT=NO
```

Verify the three existing Tunnel routes remain unchanged and production Mini Craft remains healthy via Caddy.

If cleanup cannot be proven:

```text
RETURN_M2B_TEMP_CLEANUP_UNPROVEN
STOP_AT_REVIEWER=YES
```

## Forbidden

No production Mini Craft DNS/Tunnel change. No Caddy/cloudflared/VPS/Docker/Compose/WordPress/MariaDB mutation. No Shared Network mutation. No payment/provider-commerce action. No Secret/token/session-cookie output. No M2C.

## Evidence

Append only to:

```text
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Do not modify Reviewer Handoff.

## Result

Success:

```text
PASS_CANDIDATE_M2B_TEMPORARY_TUNNEL_CANARY
TEMP_HOSTNAME=minicraft-m2b-canary.spikersun.com
TEMP_ROUTE_CANARY=PASS
TEMP_HOME_HTTP=200
TEMP_SHOP_HTTP=200
TEMP_WP_REST_HTTP=200
TEMP_TLS_VALID=YES
ORIGIN_HTTP_HOST_HEADER=minicraft.spikersun.com
TEMP_ROUTE_CLEANUP=PASS
PRODUCTION_HOST_UNCHANGED=PASS
EXISTING_TUNNEL_ROUTES_UNCHANGED=PASS
CLOUDFLARE_MUTATIONS=TEMP_ROUTE_CREATE_AND_DELETE_ONLY
DNS_MUTATIONS=TEMP_RECORD_CREATE_AND_DELETE_ONLY
CADDY_MUTATIONS=0
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_EMITTED=0
M2C_ENTERED=NO
STOP_AT_REVIEWER=YES
```

Otherwise one precise RETURN after mandatory temp cleanup attempt.
