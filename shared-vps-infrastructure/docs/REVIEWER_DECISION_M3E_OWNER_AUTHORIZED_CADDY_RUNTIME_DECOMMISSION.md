# Reviewer Decision — M3E Owner Authorized Caddy Runtime Decommission

Date: 2026-10-01
Role: Reviewer / Architect / Gatekeeper

## Owner authorization

Owner explicitly approved M3E after M3D-R1 PASS.

```text
OWNER_AUTHORIZES_M3E=YES
AUTHORIZED_ACTION=REMOVE_STOPPED_CADDY_CONTAINER_ONLY
```

## Accepted baseline

```text
CADDY_PRODUCTION_ROLE=RETIRED
CADDY_RUNTIME_STATE=STOPPED_RETAINED_FOR_ROLLBACK
PUBLIC_TUNNEL_REGRESSION=PASS
MONITOR_SCHEDULED_RUNS_PASS=3
UNIFIED_PAY_MUTATIONS=0
```

## Exact authorized scope

Remove only the already-stopped Shared Caddy container/service instance from Docker.

Preserve all of:

- Caddy image;
- canonical Compose source;
- Caddyfile;
- /srv/infra/edge/data;
- /srv/infra/edge/config;
- spikersun-edge network;
- monitor rollback copy;
- all unrelated containers/services;
- all Unified Pay assets/runtime/data.

## Preconditions

Before removal, fresh-read and require:

```text
CADDY_STATE=stopped
CADDY_CONTAINER_PRESENT=YES
CADDY_IMAGE_PRESENT=YES
PUBLIC_MINICRAFT_HOME=PASS
PUBLIC_MINICRAFT_SHOP=PASS
PUBLIC_MINICRAFT_WP_REST=PASS
PUBLIC_SHOP_ENDPOINT=PASS
CLOUDFLARED_STATE=running
MONITOR_LAST_RESULT=success
```

Any material drift returns to Reviewer before deletion.

## Authorized mutation

Remove exactly the stopped Caddy container using the canonical Compose project/service or equivalent exact container removal path that affects no dependency.

Do not run compose down.

Do not remove networks, images, volumes, bind-mounted data, config files, or unrelated containers.

## Post-removal verification

Require:

```text
CADDY_CONTAINER_PRESENT=NO
CADDY_IMAGE_PRESENT=YES
CADDY_COMPOSE_SOURCE_PRESENT=YES
CADDYFILE_PRESENT=YES
CADDY_DATA_PRESENT=YES
CADDY_CONFIG_PRESENT=YES
SPIKERSUN_EDGE_PRESENT=YES
PUBLIC_TUNNEL_REGRESSION=PASS
MONITOR_MANUAL_RUN=PASS
UNIFIED_PAY_MUTATIONS=0
```

## Boundaries

```text
CADDY_CONTAINER_REMOVE_AUTHORIZED=YES_EXACTLY_ONE
CADDY_IMAGE_DELETE_AUTHORIZED=NO
CADDY_CONFIG_DELETE_AUTHORIZED=NO
CADDY_DATA_DELETE_AUTHORIZED=NO
CADDYFILE_DELETE_AUTHORIZED=NO
COMPOSE_DELETE_AUTHORIZED=NO
SPIKERSUN_EDGE_DELETE_AUTHORIZED=NO
CLOUDFLARE_MUTATION_AUTHORIZED=NO
DNS_MUTATION_AUTHORIZED=NO
TUNNEL_ROUTE_MUTATION_AUTHORIZED=NO
UNIFIED_PAY_MUTATION_AUTHORIZED=NO
BROAD_PRUNE_AUTHORIZED=NO
```

## Success

```text
PASS_CANDIDATE_M3E_CADDY_RUNTIME_DECOMMISSION
CADDY_CONTAINER_PRESENT=NO
CADDY_IMAGE_PRESENT=YES
CADDY_RECREATE_PATH_PRESERVED=YES
PUBLIC_TUNNEL_REGRESSION=PASS
UNIFIED_PAY_MUTATIONS=0
STOP_AT_REVIEWER=YES
```