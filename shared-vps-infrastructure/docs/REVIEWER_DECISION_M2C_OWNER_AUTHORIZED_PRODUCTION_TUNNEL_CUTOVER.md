# Reviewer Decision — M2C Owner Authorized Production Tunnel Cutover

Date: 2026-09-30
Role: Reviewer / Architect / Gatekeeper

## Owner authorization

Owner explicitly confirmed:

```text
OWNER_EXPLICITLY_AUTHORIZES_M2C_PRODUCTION_HOSTNAME_TUNNEL_CUTOVER=YES
```

This authorizes one bounded production-ingress cutover transaction for the canonical Mini Craft hostname only.

## Current Gate

```text
CURRENT_GATE=M2C_PRODUCTION_HOSTNAME_TUNNEL_CUTOVER
CURRENT_GATE_STATUS=AUTHORIZED_BOUNDED_PRODUCTION_PROVIDER_WRITE

PRODUCTION_HOST=minicraft.spikersun.com
CURRENT_EXPECTED_DNS=A 2.24.193.133 DNS_ONLY
TARGET_TUNNEL=spikersun-shared-private
TARGET_ORIGIN=http://mini-craft-night-kit-wordpress:80
TARGET_ORIGIN_HTTP_HOST_HEADER=minicraft.spikersun.com

CADDY_ROUTE_RETAINED_AS_ROLLBACK=YES
M2D_AUTHORIZED=NO
M2E_AUTHORIZED=NO
```

## Authorization scope

Allowed Cloudflare/DNS mutations are limited to the canonical Mini Craft hostname:

1. fresh-read and seal the exact existing `minicraft.spikersun.com` DNS-only A record;
2. delete only that exact sealed A record;
3. create the canonical Tunnel public-hostname route on existing Tunnel `spikersun-shared-private`;
4. origin service exactly `http://mini-craft-night-kit-wordpress:80`;
5. origin HTTP Host Header exactly `minicraft.spikersun.com`;
6. allow/create only the canonical DNS record required by that Tunnel route;
7. read back and validate the canonical route/DNS;
8. on any failed or ambiguous cutover check, remove only the new canonical Mini Craft Tunnel route/DNS and restore the exact sealed prior A record.

No other DNS/Tunnel route may change.

## Mandatory prewrite proof

Before deleting the production A record, prove:

- browser context reliably identifies authenticated Cloudflare Dashboard and Tunnel `spikersun-shared-private`;
- exact current Mini Craft record is one DNS-only A record to `2.24.193.133`;
- exact TTL and provider record identifier are captured if visible;
- canonical `minicraft.spikersun.com` is absent from Tunnel public-hostname routes;
- M2B temp hostname is absent from Tunnel and DNS;
- Tunnel is healthy;
- private origin `http://mini-craft-night-kit-wordpress:80` is healthy according to accepted M2A/M2B state or fresh safe probe;
- production Home / Shop / REST return HTTP 200 before cutover;
- xianyu/pay/shop Tunnel mappings remain unchanged.

Any material difference -> `RETURN_M2C_PREFLIGHT_DRIFT` with zero production mutation.

## Transaction rule

The old A record and canonical Tunnel CNAME cannot coexist at the same hostname. Therefore this Gate is one bounded transaction:

```text
SEAL_OLD_A
-> DELETE_EXACT_OLD_A
-> CREATE_EXACT_CANONICAL_TUNNEL_ROUTE
-> READBACK_ROUTE_AND_DNS
-> VERIFY_TLS_HOME_SHOP_REST
```

After deleting the A record, do not perform unrelated navigation or work.

If a provider save/delete result is ambiguous, do **not** click again blindly. Fresh-read the canonical DNS and Tunnel route state first. Then either continue from proven state or execute rollback.

## Rollback contract

If route creation, DNS readback, TLS, Home, Shop, REST, or route-integrity validation fails:

1. remove only the canonical Mini Craft Tunnel route created by M2C, if present;
2. remove only its canonical Tunnel DNS record if separately present;
3. recreate the exact sealed prior record:
   - type A
   - hostname `minicraft.spikersun.com`
   - content `2.24.193.133`
   - proxied OFF / DNS-only
   - exact prewrite TTL
4. fresh-readback the restored A record;
5. verify Home / Shop / REST return HTTP 200 via the old Caddy path;
6. verify xianyu/pay/shop unchanged;
7. return precise `RETURN_M2C_...` and stop.

Caddy itself must never be edited/reloaded/restarted during this Gate.

## Success boundary

Success leaves:

```text
PRODUCTION_HOST=minicraft.spikersun.com
PRODUCTION_INGRESS=CLOUDFLARE_TUNNEL_DIRECT_TO_MINICRAFT_APP
PRODUCTION_TUNNEL=spikersun-shared-private
PRODUCTION_ORIGIN=http://mini-craft-night-kit-wordpress:80
PRODUCTION_ORIGIN_HTTP_HOST_HEADER=minicraft.spikersun.com
CADDY_ROUTE_RETAINED_AS_ROLLBACK=YES
M2D_ENTERED=NO
M2E_ENTERED=NO
STOP_AT_REVIEWER=YES
```

M2C does not authorize Caddy retirement or M2D/M2E execution.

## Forbidden

No Caddy mutation, cloudflared restart/recreate, VPS/Docker/Compose/WordPress/MariaDB/shared-network mutation, payment action, Secret/token/cookie output, unrelated DNS/Tunnel changes, cleanup/prune, M2D, or M2E.
