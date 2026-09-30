# Reviewer Decision — M2B Owner Authorized Temporary Tunnel Canary

Date: 2026-09-30
Role: Reviewer / Architect / Gatekeeper

## Owner authorization

Owner explicitly confirmed continuation of the M2B temporary Cloudflare Tunnel canary in chat.

```text
OWNER_EXPLICITLY_AUTHORIZES_M2B_TEMPORARY_CLOUDFLARE_TUNNEL_CANARY=YES
```

This authorization is limited to the exact bounded canary defined below. It does not authorize production hostname cutover.

## Current Gate

```text
CURRENT_GATE=M2B_TEMPORARY_TUNNEL_CANARY
CURRENT_GATE_STATUS=AUTHORIZED_BOUNDED_PROVIDER_WRITE

TUNNEL=spikersun-shared-private
TEMP_HOSTNAME=minicraft-m2b-canary.spikersun.com
ORIGIN_SERVICE=http://mini-craft-night-kit-wordpress:80
ORIGIN_HTTP_HOST_HEADER=minicraft.spikersun.com

CURRENT_PRODUCTION_HOST=minicraft.spikersun.com
CURRENT_PRODUCTION_INGRESS=DNS_A_TO_CADDY
CURRENT_CADDY_ROUTE_RETAINED=YES
```

## Authorization scope

Allowed provider mutations:

1. create the one exact temporary public hostname `minicraft-m2b-canary.spikersun.com` on existing Tunnel `spikersun-shared-private`;
2. create or allow Cloudflare to create only the exact DNS record required by that temporary Tunnel hostname;
3. set the origin service exactly to `http://mini-craft-night-kit-wordpress:80`;
4. set HTTP Host Header exactly to `minicraft.spikersun.com`;
5. after canary evidence is collected, remove the temporary public hostname and its temporary DNS record;
6. verify the temporary hostname is absent again after cleanup.

The temporary route is ephemeral. A successful M2B ends with no temporary canary hostname left active.

## Prewrite requirements

Before any provider mutation:

- authenticated Cloudflare Dashboard session must be present; otherwise `RETURN_OWNER_CLOUDFLARE_SESSION_REQUIRED`;
- exact temporary hostname must be absent from both DNS and Tunnel public-hostname config;
- current production `minicraft.spikersun.com` DNS record and Caddy path must be read-only captured;
- current Tunnel `spikersun-shared-private` must be healthy;
- current Dujiao / Unified Pay / Xianyu Tunnel public-hostname mappings must be captured read-only and left unchanged;
- private origin baseline from M2A remains accepted; no VPS write is required.

If temp hostname already exists or any material route drift is found, stop before write with `RETURN_M2B_PREFLIGHT_DRIFT`.

## Canary validation

After creating the temporary route, verify through the temporary HTTPS hostname without following redirects unless needed only to classify a same-site canonical redirect.

Preferred PASS target:

```text
TEMP_HOME_HTTP=200
TEMP_SHOP_HTTP=200
TEMP_WP_REST_HTTP=200
```

Also verify:

- TLS for the temporary hostname is valid;
- production `minicraft.spikersun.com` remains on its original DNS A -> Caddy path and remains healthy;
- existing Tunnel routes for Dujiao / Unified Pay / Xianyu are unchanged;
- no cookie/session continuity claim is made across temporary and canonical hostnames.

If canary validation fails, remove only the temporary route/DNS created by this Gate, verify cleanup, then RETURN.

## Success cleanup

Even on success, remove the temporary route/DNS before returning. Final state must be:

```text
TEMP_HOSTNAME_PRESENT=NO
CURRENT_PRODUCTION_HOST_UNCHANGED=YES
CURRENT_CADDY_ROUTE_RETAINED=YES
```

## Hard boundaries

No:

- modification of `minicraft.spikersun.com` DNS or Tunnel config;
- M2C production cutover;
- Caddy mutation/reload/restart;
- cloudflared restart/recreate;
- VPS/Docker/Compose/WordPress/MariaDB mutation;
- shared-network mutation;
- payment/provider-commerce action;
- Secret/token/session-cookie output;
- cleanup/prune outside the exact temporary Cloudflare route/DNS.

## Required success

```text
PASS_CANDIDATE_M2B_TEMPORARY_TUNNEL_CANARY
TEMP_HOSTNAME=minicraft-m2b-canary.spikersun.com
TEMP_ROUTE_CANARY=PASS
ORIGIN_HTTP_HOST_HEADER=minicraft.spikersun.com
TEMP_ROUTE_CLEANUP=PASS
PRODUCTION_HOST_UNCHANGED=PASS
EXISTING_TUNNEL_ROUTES_UNCHANGED=PASS
M2C_ENTERED=NO
STOP_AT_REVIEWER=YES
```
