# M2E — Retire Legacy Mini Craft Caddy Route Owner Checkpoint

## Gate

```text
M2E_RETIRE_LEGACY_MINICRAFT_CADDY_ROUTE_OWNER_CHECKPOINT
WRITE_GATE=YES
OWNER_CONFIRMATION_REQUIRED=YES
STOP_AT_REVIEWER=YES
```

## Current accepted state

```text
M2A=PASS
M2B=PASS
M2C=PASS
M2D=PASS

PRODUCTION_HOST=minicraft.spikersun.com
PRODUCTION_INGRESS=CLOUDFLARE_TUNNEL_DIRECT_TO_MINICRAFT_APP
PRODUCTION_TUNNEL=spikersun-shared-private
PRODUCTION_ORIGIN=http://mini-craft-night-kit-wordpress:80

LEGACY_CADDY_MINICRAFT_ROUTE=PRESENT
CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
```

## Current authorization

```text
CADDY_MUTATION_AUTHORIZED=NO
CADDY_RELOAD_AUTHORIZED=NO
DNS_MUTATION_AUTHORIZED=NO
TUNNEL_ROUTE_MUTATION_AUTHORIZED=NO
VPS_OTHER_MUTATION_AUTHORIZED=NO
DOCKER_MUTATION_AUTHORIZED=NO
COMPOSE_MUTATION_AUTHORIZED=NO
WORDPRESS_MUTATION_AUTHORIZED=NO
MARIADB_MUTATION_AUTHORIZED=NO
PAYMENT_ACTION_AUTHORIZED=NO
CLEANUP_AUTHORIZED=NO
```

This packet is a checkpoint only. Do not edit or reload Caddy until a later Reviewer decision records explicit Owner authorization.

## Intended bounded retirement after authorization

Before write:

- verify Hostinger target `srv1970241`;
- locate the active shared Caddy config source from accepted runtime metadata;
- require exact current Caddyfile SHA-256 match to the M2D seal;
- prove the Mini Craft route/matcher is exact and isolated from unrelated hosts;
- create/preserve exact rollback configuration in a project/shared-infra approved backup location;
- validate current Caddy config;
- verify Mini Craft Tunnel production Home/Shop/REST + TLS;
- verify remaining shared routes/services are healthy.

Allowed mutation after separate authorization:

- delete only the exact Mini Craft route/matcher;
- validate Caddy configuration;
- perform one bounded Caddy reload using the existing accepted shared-infra mechanism.

Forbidden:

- Caddy package/image upgrade;
- Caddy container/service recreate unless a later Reviewer decision explicitly requires it;
- cloudflared mutation;
- DNS/Tunnel mutation;
- other Caddy route edits;
- VPS/Docker/Compose/WordPress/MariaDB/payment/cleanup operations;
- SSH repair;
- broad prune.

## Rollback

On any validation/reload/regression failure, restore exact prewrite Caddy config, validate, perform one rollback reload, verify prior state, persist Evidence/Handoff, and RETURN.

## Owner checkpoint

Required before execution:

```text
OWNER_EXPLICITLY_AUTHORIZES_M2E_RETIRE_LEGACY_MINICRAFT_CADDY_ROUTE=YES
```
