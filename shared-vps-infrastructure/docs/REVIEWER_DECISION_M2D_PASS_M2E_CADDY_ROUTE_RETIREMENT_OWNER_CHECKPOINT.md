# Reviewer Decision — M2D Formal PASS / M2E Mini Craft Caddy Route Retirement Owner Checkpoint

Date: 2026-09-30
Role: Reviewer / Architect / Gatekeeper

## Independent review

Reviewed:

- Evidence commit `f55be4e2b9bddfd28b04be3b736716054c58cfc0`
- Executor Handoff commit `ec7005249a37db58bd99ed0ad34358196b80521e`

The M2D PASS_CANDIDATE is accepted.

## Formal M2D result

```text
M2D_PUBLIC_REGRESSION_AND_OBSERVATION=PASS
OBSERVATION_CHECKPOINTS=3

T0_RUNTIME_READBACK_UTC=2026-09-30T07:55:27Z
T_PLUS_5_RUNTIME_READBACK_UTC=2026-09-30T08:06:35Z
T_PLUS_10_RUNTIME_READBACK_UTC=2026-09-30T08:15:53Z
OBSERVATION_WINDOW=REAL_SPACED_READONLY_CHECKPOINTS_OVER_20_MINUTES

PRODUCTION_INGRESS_STABLE=PASS
PUBLIC_HOME_STABLE=PASS
PUBLIC_SHOP_STABLE=PASS
PUBLIC_WP_REST_STABLE=PASS
TLS_STABLE=PASS

PRODUCTION_TUNNEL=spikersun-shared-private
PRODUCTION_ORIGIN=http://mini-craft-night-kit-wordpress:80
PRODUCTION_HTTP_HOST_HEADER=minicraft.spikersun.com
CANONICAL_DNS=CNAME_TO_EXISTING_TUNNEL
OLD_CANONICAL_A_RECORD=ABSENT

EXISTING_TUNNEL_ROUTES_UNCHANGED=PASS
M2B_TEMP_HOSTNAME_ABSENT=PASS

WORDPRESS_STATE=RUNNING
WORDPRESS_RESTART_COUNT=0
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge+spikersun-private
WORDPRESS_PRIVATE_ALIAS=mini-craft-night-kit-wordpress

MARIADB_STATE=RUNNING_HEALTHY
MARIADB_NETWORKS=mini-craft-night-kit-database
MARIADB_ON_SPIKERSUN_PRIVATE=NO

CADDY_MINICRAFT_ROLLBACK_MATCHER=PRESENT
CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8

MUTATIONS=0
M2E_ENTERED=NO
```

M2D is formally closed.

## Migration status

The production ingress migration is now proven through:

```text
M1_ARCHITECTURE_SEAL=PASS
M2A_PRIVATE_NETWORK_PREPARATION=PASS
M2B_TEMPORARY_TUNNEL_CANARY=PASS
M2C_PRODUCTION_TUNNEL_CUTOVER=PASS
M2D_PUBLIC_REGRESSION_AND_OBSERVATION=PASS
```

Current production path:

```text
Internet
-> Cloudflare
-> spikersun-shared-private
-> http://mini-craft-night-kit-wordpress:80
-> WordPress
```

The legacy Mini Craft Caddy route is no longer the production ingress. It remains present only as rollback infrastructure.

## Next Gate — M2E Owner checkpoint

M2E removes the legacy Mini Craft matcher/route from shared Caddy. This is a Shared Infrastructure write and requires explicit Owner confirmation.

```text
CURRENT_GATE=M2E_RETIRE_LEGACY_MINICRAFT_CADDY_ROUTE_OWNER_CHECKPOINT
CURRENT_GATE_STATUS=OWNER_CONFIRMATION_REQUIRED

CADDY_MUTATION_AUTHORIZED=NO
CADDY_RELOAD_AUTHORIZED=NO
VPS_MUTATION_AUTHORIZED=NO
DNS_MUTATION_AUTHORIZED=NO
TUNNEL_ROUTE_MUTATION_AUTHORIZED=NO
```

## Intended M2E scope after Owner authorization

M2E may remove only the exact legacy Caddy configuration that serves `minicraft.spikersun.com`.

Before any write it must:

1. prove `TARGET_HOST=srv1970241`;
2. fresh-read the active Caddy configuration source path and exact file identity;
3. require current Caddyfile SHA-256 to equal the accepted M2D value:
   `cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8`;
4. identify the exact Mini Craft route/matcher block and prove it does not contain any other hostname;
5. capture the exact prewrite Caddy configuration for rollback without exposing Secrets;
6. confirm canonical production Tunnel/DNS still healthy and Home / Shop / REST still HTTP 200;
7. confirm xianyu/pay/shop routes unchanged.

If the Caddy hash or route boundaries differ, stop before write with a precise RETURN.

After explicit authorization and PASS preflight, M2E may:

1. remove only the exact Mini Craft Caddy route/matcher;
2. validate Caddy configuration before reload;
3. reload Caddy using the existing accepted shared-infra method; do not restart the whole VPS or unrelated services;
4. prove Caddy remains healthy for all remaining configured sites;
5. prove Mini Craft Home / Shop / REST continue HTTP 200 through the Tunnel;
6. prove xianyu/pay/shop Tunnel routes and Mini Craft Tunnel route remain unchanged.

## Rollback principle

If Caddy validation/reload or public regression checks fail:

- restore the exact sealed prewrite Caddy configuration;
- validate;
- reload Caddy once;
- prove prior Caddy state restored;
- prove Mini Craft Tunnel production path remains healthy;
- RETURN and stop.

No blind repeated reloads.

## Success boundary

A successful M2E means the Mini Craft ingress migration is complete and the old Caddy route is retired.

It does not authorize unrelated Caddy cleanup, shared-infrastructure cleanup, SSH repair, Docker cleanup, payment actions, or any other project mutation.
