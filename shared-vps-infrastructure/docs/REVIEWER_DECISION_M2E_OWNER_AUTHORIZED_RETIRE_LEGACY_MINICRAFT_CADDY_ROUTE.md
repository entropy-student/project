# Reviewer Decision — M2E Owner Authorized Legacy Mini Craft Caddy Route Retirement

Date: 2026-09-30
Role: Reviewer / Architect / Gatekeeper

## Owner authorization

Owner explicitly confirmed:

```text
OWNER_EXPLICITLY_AUTHORIZES_M2E_RETIRE_LEGACY_MINICRAFT_CADDY_ROUTE=YES
```

This authorizes one bounded Shared Caddy configuration change for Mini Craft only.

## Current Gate

```text
CURRENT_GATE=M2E_RETIRE_LEGACY_MINICRAFT_CADDY_ROUTE
CURRENT_GATE_STATUS=AUTHORIZED_BOUNDED_SHARED_INFRA_WRITE

PRODUCTION_HOST=minicraft.spikersun.com
PRODUCTION_INGRESS=CLOUDFLARE_TUNNEL_DIRECT_TO_MINICRAFT_APP
PRODUCTION_TUNNEL=spikersun-shared-private
PRODUCTION_ORIGIN=http://mini-craft-night-kit-wordpress:80

LEGACY_MINICRAFT_CADDY_ROUTE=PRESENT
ACCEPTED_PREWRITE_CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
```

## Exact authorization

Allowed:

1. read-only prove target host `srv1970241`;
2. discover the active shared Caddy config source and current reload mechanism from runtime metadata;
3. require exact prewrite Caddyfile SHA-256 match to the accepted M2D seal;
4. identify the exact Mini Craft-only matcher/site block serving `minicraft.spikersun.com`;
5. create one exact rollback copy in an already-established Shared Infrastructure/Caddy backup or config directory; do not invent unrelated top-level storage;
6. validate the current Caddy config before editing;
7. remove only the exact Mini Craft-only Caddy route/site block;
8. validate the edited Caddy config;
9. perform one bounded Caddy reload using the already-established live Caddy mechanism;
10. verify remaining Caddy-served sites, Mini Craft Tunnel ingress, and existing Tunnel routes remain healthy.

No other Caddy edit is authorized.

## Mandatory prewrite requirements

Before any write, prove:

```text
TARGET_HOST=srv1970241
CURRENT_CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
MINICRAFT_CADDY_MATCHER_PRESENT=YES
MINICRAFT_CADDY_MATCHER_HOST=minicraft.spikersun.com
MINICRAFT_CADDY_MATCHER_SHARED_WITH_OTHER_HOSTS=NO
CURRENT_CADDY_CONFIG_VALID=PASS
```

Also fresh-read:

- Mini Craft canonical Tunnel route exact;
- canonical Tunnel DNS present and old A absent;
- Mini Craft Home / Shop / REST HTTP 200 with TLS verification;
- xianyu/pay/shop Tunnel routes unchanged;
- Caddy service/container currently healthy;
- all non-Mini-Craft hostnames currently configured in Caddy, so they can be regression-checked after reload.

If the Caddy hash differs, route boundaries are ambiguous, or the Mini Craft matcher is shared with another host, stop before write:

```text
RETURN_M2E_PREFLIGHT_DRIFT
CADDY_MUTATIONS=0
STOP_AT_REVIEWER=YES
```

## Backup rule

Create exactly one rollback copy before editing.

The backup must preserve the entire exact prewrite active Caddy config and metadata sufficient for restoration. It must be stored only in an already-existing Shared Infrastructure/Caddy-scoped directory. If no approved existing location can be identified without creating a new storage convention:

```text
RETURN_M2E_ROLLBACK_LOCATION_UNRESOLVED
CADDY_MUTATIONS=0
STOP_AT_REVIEWER=YES
```

Do not expose Secret values if the Caddy config contains any.

## Edit and reload

The only semantic edit is removal of the Mini Craft legacy Caddy route/site block.

After edit:

- validate before reload;
- require all unrelated Caddy hostnames/routes to remain semantically unchanged;
- perform one reload only;
- do not restart/recreate the Caddy container/service unless a separate Reviewer decision authorizes it.

If validation fails, restore exact rollback config before any reload and RETURN.

## Post-reload proof

Require:

```text
MINICRAFT_CADDY_MATCHER_PRESENT=NO
CADDY_SERVICE_HEALTH=PASS
PRODUCTION_MINICRAFT_HOME_HTTP=200
PRODUCTION_MINICRAFT_SHOP_HTTP=200
PRODUCTION_MINICRAFT_WP_REST_HTTP=200
PRODUCTION_MINICRAFT_TLS_VALID=YES
PRODUCTION_INGRESS=CLOUDFLARE_TUNNEL_DIRECT_TO_MINICRAFT_APP
EXISTING_TUNNEL_ROUTES_UNCHANGED=PASS
OTHER_CADDY_SITES_REGRESSION=PASS
```

## Rollback

If reload or any required regression check fails:

1. restore the exact sealed prewrite Caddy config;
2. validate it;
3. perform one rollback reload;
4. fresh-readback the original Caddy hash/matcher;
5. verify remaining Caddy sites healthy;
6. verify Mini Craft Tunnel production remains healthy;
7. persist Evidence/Handoff and RETURN.

No blind repeated reloads.

## Hard boundaries

No:

- Cloudflare/DNS/Tunnel mutation;
- cloudflared restart/recreate;
- Caddy package/image upgrade;
- Caddy container/service recreate;
- unrelated Caddy route edit;
- VPS unrelated mutation;
- Docker/Compose/WordPress/MariaDB mutation;
- Shared Network mutation;
- payment/refund/provider-commerce action;
- cleanup/prune beyond the one Mini Craft route removal;
- SSH repair;
- Secret/token/cookie output.

## Success

```text
PASS_CANDIDATE_M2E_RETIRE_LEGACY_MINICRAFT_CADDY_ROUTE
LEGACY_MINICRAFT_CADDY_ROUTE=ABSENT
CADDY_RELOAD=PASS
OTHER_CADDY_SITES_REGRESSION=PASS
MINICRAFT_TUNNEL_PRODUCTION_REGRESSION=PASS
MIGRATION_M1_TO_M2E=COMPLETE_CANDIDATE
STOP_AT_REVIEWER=YES
```
