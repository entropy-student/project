# M2C — Production Hostname Tunnel Cutover Owner Checkpoint

## Gate

```text
M2C_PRODUCTION_HOSTNAME_TUNNEL_CUTOVER_OWNER_CHECKPOINT
WRITE_GATE=YES
OWNER_CONFIRMATION_REQUIRED=YES
STOP_AT_REVIEWER=YES
```

## Current authorization

```text
PRODUCTION_DNS_MUTATION_AUTHORIZED=NO
PRODUCTION_TUNNEL_HOSTNAME_MUTATION_AUTHORIZED=NO
CADDY_MUTATION_AUTHORIZED=NO
VPS_MUTATION_AUTHORIZED=NO
DOCKER_MUTATION_AUTHORIZED=NO
COMPOSE_MUTATION_AUTHORIZED=NO
M2D_AUTHORIZED=NO
M2E_AUTHORIZED=NO
```

This file defines the checkpoint only. Do not perform the production cutover until a later Reviewer decision records explicit Owner authorization.

## Accepted baseline

```text
PRODUCTION_HOST=minicraft.spikersun.com
CURRENT_DNS_TYPE=A
CURRENT_DNS_CONTENT=2.24.193.133
CURRENT_DNS_PROXIED=NO
CURRENT_INGRESS=DNS_A_TO_CADDY

TARGET_TUNNEL=spikersun-shared-private
TARGET_ORIGIN=http://mini-craft-night-kit-wordpress:80
TARGET_ORIGIN_HTTP_HOST_HEADER=minicraft.spikersun.com

M2A=PASS
M2B=PASS
M2B_TEMP_HOSTNAME_PRESENT=NO
CADDY_ROUTE_RETAINED=YES
```

## Intended prewrite requirements after Owner authorization

Before mutation, fresh-read:

1. exact canonical DNS record:
   - type;
   - hostname;
   - content;
   - proxied state;
   - TTL;
   - provider record identifier if available without exposing sensitive account data;
2. Tunnel health;
3. canonical hostname absent from Tunnel routes;
4. private origin HTTP 200;
5. production Home / Shop / REST HTTP 200;
6. exact xianyu / pay / shop route mappings unchanged;
7. M2B temporary hostname absent from Tunnel and DNS.

Any material difference -> `RETURN_M2C_PREFLIGHT_DRIFT` before mutation.

## Intended cutover transaction

Only after explicit Owner authorization and a PASS preflight:

1. delete only the sealed canonical Mini Craft DNS-only A record;
2. immediately create the canonical public-hostname route:
   - hostname: `minicraft.spikersun.com`
   - Tunnel: `spikersun-shared-private`
   - origin: `http://mini-craft-night-kit-wordpress:80`
   - HTTP Host Header: `minicraft.spikersun.com`
3. allow/create only the canonical Tunnel DNS record required by that route;
4. fresh-readback route + DNS;
5. immediately validate normal-TLS anonymous:
   - `https://minicraft.spikersun.com/`
   - `https://minicraft.spikersun.com/shop/`
   - `https://minicraft.spikersun.com/wp-json/`
6. confirm xianyu / pay / shop routes unchanged.

## Mandatory rollback contract

If any route creation, DNS readback, TLS, Home, Shop, REST, or existing-route integrity check fails:

1. remove only the new canonical Mini Craft Tunnel route;
2. remove its canonical Tunnel DNS record if present;
3. recreate the exact sealed previous DNS-only A record, including original TTL/proxied state;
4. verify `minicraft.spikersun.com` again serves Home / Shop / REST via the old Caddy path;
5. verify Caddy itself was never changed;
6. RETURN and stop.

No blind replay after an ambiguous provider action.

## Success boundary

On success:

```text
PRODUCTION_HOST=minicraft.spikersun.com
PRODUCTION_INGRESS=CLOUDFLARE_TUNNEL_DIRECT_TO_MINICRAFT_APP
CADDY_ROUTE_RETAINED_AS_ROLLBACK=YES
M2D_ENTERED=NO
M2E_ENTERED=NO
STOP_AT_REVIEWER=YES
```

## Forbidden

No Caddy edit/reload/restart. No cloudflared restart/recreate. No VPS/Docker/Compose/WordPress/MariaDB mutation. No Shared Network mutation. No payment/provider-commerce action. No Secret/token/cookie output. No unrelated DNS/route change. No M2D/M2E.

## Owner checkpoint

Required before execution:

```text
OWNER_EXPLICITLY_AUTHORIZES_M2C_PRODUCTION_HOSTNAME_TUNNEL_CUTOVER=YES
```
