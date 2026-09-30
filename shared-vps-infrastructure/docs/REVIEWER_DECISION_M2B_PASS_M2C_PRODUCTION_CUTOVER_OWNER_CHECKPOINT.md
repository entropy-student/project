# Reviewer Decision — M2B Formal PASS / M2C Production Hostname Cutover Owner Checkpoint

Date: 2026-09-30
Role: Reviewer / Architect / Gatekeeper

## Independent review

Reviewed:

- Evidence commit `cb3835f621c444d7aa0b731c3d023bd00ada075e`
- Executor Handoff commit `4a3a86e02b50903522dae7db195d8e766998bc87`

The M2B PASS_CANDIDATE is accepted.

## Formal M2B result

```text
M2B_TEMPORARY_TUNNEL_CANARY=PASS

TEMP_HOSTNAME=minicraft-m2b-canary.spikersun.com
TEMP_ORIGIN_SERVICE=http://mini-craft-night-kit-wordpress:80
TEMP_ORIGIN_HTTP_HOST_HEADER=minicraft.spikersun.com

TEMP_HOME_HTTP=200
TEMP_SHOP_HTTP=200
TEMP_WP_REST_HTTP=200
TEMP_TLS_VALID=YES

PRODUCTION_HOME_HTTP=200
PRODUCTION_SHOP_HTTP=200
PRODUCTION_WP_REST_HTTP=200
PRODUCTION_DNS_A_TO_CADDY_UNCHANGED=YES

TEMP_ROUTE_CLEANUP=PASS
TEMP_PUBLIC_HOSTNAME_PRESENT=NO
TEMP_DNS_PRESENT=NO
EXISTING_TUNNEL_ROUTES_UNCHANGED=PASS

CLOUDFLARE_MUTATIONS=TEMP_ROUTE_CREATE_AND_DELETE_ONLY
DNS_MUTATIONS=TEMP_CNAME_CREATE_AND_DELETE_ONLY
CADDY_MUTATIONS=0
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
WORDPRESS_MUTATIONS=0
MARIADB_MUTATIONS=0
PAYMENT_ACTIONS=0
M2C_ENTERED=NO
```

M2B is formally closed.

## Current architecture

Current production remains:

```text
minicraft.spikersun.com
  -> DNS-only A 2.24.193.133
  -> VPS 80/443
  -> shared Caddy
  -> Mini Craft WordPress
```

The tested target path is now proven:

```text
Cloudflare Tunnel spikersun-shared-private
  -> http://mini-craft-night-kit-wordpress:80
  -> WordPress

Origin HTTP Host Header=minicraft.spikersun.com
```

The existing Mini Craft Caddy route remains intact and is the rollback origin through M2D.

## Next Gate — M2C Owner checkpoint

M2C changes the canonical production hostname and DNS. It is a production ingress cutover and requires explicit Owner confirmation.

```text
CURRENT_GATE=M2C_PRODUCTION_HOSTNAME_TUNNEL_CUTOVER_OWNER_CHECKPOINT
CURRENT_GATE_STATUS=OWNER_CONFIRMATION_REQUIRED

PRODUCTION_DNS_MUTATION_AUTHORIZED=NO
PRODUCTION_TUNNEL_HOSTNAME_MUTATION_AUTHORIZED=NO
CADDY_MUTATION_AUTHORIZED=NO
M2D_AUTHORIZED=NO
```

## Intended M2C shape after Owner authorization

Canonical hostname:

`minicraft.spikersun.com`

Target Tunnel:

`spikersun-shared-private`

Origin:

`http://mini-craft-night-kit-wordpress:80`

Origin request HTTP Host Header:

`minicraft.spikersun.com`

### Required prewrite snapshot

Before any cutover write, capture and preserve the exact rollback record for the current canonical DNS entry, including at minimum:

```text
TYPE=A
HOSTNAME=minicraft.spikersun.com
CONTENT=2.24.193.133
PROXIED=NO
TTL=<fresh exact value>
```

Also prove:

- canonical hostname is absent from Tunnel public-hostname routes;
- Tunnel is healthy;
- private origin remains HTTP 200;
- production Home / Shop / REST remain HTTP 200 on the Caddy path;
- Dujiao / Unified Pay / Xianyu routes are unchanged;
- M2B temporary hostname remains absent.

### Cutover constraint

Only the canonical Mini Craft DNS/Tunnel binding may change.

Because the current A record and the Tunnel-required canonical CNAME cannot coexist at the same hostname, the execution packet must treat the change as one bounded cutover transaction with immediate rollback capability.

Expected sequence after explicit authorization:

1. fresh-read and seal exact old A record;
2. remove only that exact canonical A record;
3. create canonical Tunnel public-hostname route on `spikersun-shared-private`;
4. ensure the resulting canonical DNS record points to the Tunnel;
5. set/verify origin HTTP Host Header exactly `minicraft.spikersun.com`;
6. immediately verify TLS + Home / Shop / REST;
7. if any required control-plane or HTTP check fails, remove the new canonical Tunnel route/DNS and recreate the exact sealed old DNS-only A record;
8. fresh-readback the rollback state and stop.

### M2C success boundary

A successful M2C leaves the canonical hostname on the Tunnel path, but **does not retire Caddy**.

Caddy remains untouched as rollback infrastructure until M2D is formally accepted and M2E separately authorized.

No M2D observation window and no M2E Caddy retirement are authorized by this checkpoint.
