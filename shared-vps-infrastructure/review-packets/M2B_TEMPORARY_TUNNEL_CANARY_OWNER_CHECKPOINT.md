# M2B — Temporary Tunnel Canary Owner Checkpoint

## Gate

```text
M2B_TEMPORARY_TUNNEL_CANARY_OWNER_CHECKPOINT
WRITE_GATE=YES
OWNER_CONFIRMATION_REQUIRED=YES
STOP_AT_REVIEWER=YES
```

## Current authorization

```text
CLOUDFLARE_MUTATION_AUTHORIZED=NO
DNS_MUTATION_AUTHORIZED=NO
TUNNEL_PUBLIC_HOSTNAME_MUTATION_AUTHORIZED=NO
VPS_MUTATION_AUTHORIZED=NO
DOCKER_MUTATION_AUTHORIZED=NO
CADDY_MUTATION_AUTHORIZED=NO
```

This packet is a checkpoint definition only. Do not execute Cloudflare writes until a later Reviewer decision records explicit Owner authorization.

## Accepted M2A baseline

```text
TUNNEL=spikersun-shared-private
PRIVATE_ORIGIN=http://mini-craft-night-kit-wordpress:80
PRIVATE_ORIGIN_HTTP=200
WORDPRESS_PRIVATE_ALIAS=mini-craft-night-kit-wordpress
MARIADB_PRIVATE_ENDPOINT=ABSENT
CURRENT_PRODUCTION_HOST=minicraft.spikersun.com
CURRENT_PRODUCTION_INGRESS=DNS_A_TO_CADDY
CURRENT_CADDY_ROUTE_RETAINED=YES
```

## Intended temporary-canary constraints

After Owner authorization only:

1. select one fresh absent temporary hostname under `spikersun.com`;
2. prove it is absent before mutation;
3. create only the temporary Tunnel public-hostname/DNS route required for the canary;
4. origin service must be exactly `http://mini-craft-night-kit-wordpress:80`;
5. explicitly configure/verify origin HTTP Host header `minicraft.spikersun.com`;
6. do not modify canonical production hostname/DNS;
7. do not modify Caddy;
8. do not restart/recreate cloudflared;
9. do not modify WordPress/MariaDB/Compose;
10. validate temporary public HTTPS behavior and core routes;
11. if canary fails, remove only the temporary route/DNS created by this Gate;
12. stop at Reviewer; do not enter M2C.

Temporary hostname cookie/session isolation is an accepted limitation and must be recorded.

## Owner checkpoint

Required next action before execution:

```text
OWNER_EXPLICITLY_AUTHORIZES_M2B_TEMPORARY_CLOUDFLARE_TUNNEL_CANARY=YES
```
