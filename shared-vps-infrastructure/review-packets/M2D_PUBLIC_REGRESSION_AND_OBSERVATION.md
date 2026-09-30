# M2D — Public Regression + Observation

## Gate

```text
M2D_PUBLIC_REGRESSION_AND_OBSERVATION
READ_ONLY_ONLY=YES
STOP_AT_REVIEWER=YES
```

## Read first

Read canonical Governance latest and:

```text
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2C_PASS_M2D_READONLY_OBSERVATION_AUTHORIZED.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

## Hard boundary

No writes of any kind.

```text
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
CADDY_MUTATIONS=0
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
WORDPRESS_MUTATIONS=0
MARIADB_MUTATIONS=0
PAYMENT_ACTIONS=0
```

No rollback is authorized in M2D.

## Phase A — checkpoint T0

Read-only prove:

```text
PRODUCTION_HOST=minicraft.spikersun.com
OLD_A_RECORD_PRESENT=NO
CANONICAL_TUNNEL_DNS_PRESENT=YES
CANONICAL_TUNNEL_ROUTE_PRESENT=YES
CANONICAL_TUNNEL=spikersun-shared-private
CANONICAL_ORIGIN=http://mini-craft-night-kit-wordpress:80
CANONICAL_ORIGIN_HTTP_HOST_HEADER=minicraft.spikersun.com
M2B_TEMP_TUNNEL_ROUTE_PRESENT=NO
M2B_TEMP_DNS_PRESENT=NO
```

Confirm existing mappings unchanged:

```text
shop.spikersun.com -> http://dujiao-next-app:8080
pay.spikersun.com -> http://unified-pay-app:8080
xianyu.spikersun.com -> http://xianyu-app:8090
```

Public anonymous normal-TLS checks:

- `https://minicraft.spikersun.com/`
- `https://minicraft.spikersun.com/shop/`
- `https://minicraft.spikersun.com/wp-json/`

Record HTTP status + TLS verification result only.

From accepted Hostinger Web Terminal or another already-accepted target-host read-only path, verify safe runtime metadata only:

```text
WORDPRESS_STATE=running
WORDPRESS_RESTART_COUNT=0
WORDPRESS_NETWORKS=mini-craft-night-kit-database+spikersun-edge+spikersun-private
WORDPRESS_PRIVATE_ALIAS=mini-craft-night-kit-wordpress
MARIADB_STATE=running/healthy
MARIADB_NETWORKS=mini-craft-night-kit-database
MARIADB_PRIVATE_ENDPOINT=ABSENT
```

Read-only verify the Mini Craft Caddy rollback route remains present. Do not reload or edit Caddy.

## Phase B — checkpoint T+5 minutes

Wait approximately five minutes from T0.

Repeat only:

- canonical DNS/Tunnel route presence;
- old A absence;
- Home/Shop/REST HTTP + TLS;
- xianyu/pay/shop route integrity;
- WordPress state/restart count;
- MariaDB health/isolation.

No mutations between checkpoints.

## Phase C — checkpoint T+10 minutes

Wait approximately ten minutes from T0.

Repeat the same read-only set.

If the environment cannot complete the bounded observation intervals, return:

```text
RETURN_M2D_OBSERVATION_WINDOW_INCOMPLETE
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

Do not compress three checkpoints into one instant.

## PASS requirements

All three checkpoints must show:

```text
HOME_HTTP=200
SHOP_HTTP=200
WP_REST_HTTP=200
TLS_VERIFY_RESULT=0
OLD_A_RECORD_PRESENT=NO
CANONICAL_TUNNEL_ROUTE_PRESENT=YES
EXISTING_TUNNEL_ROUTES_UNCHANGED=PASS
WORDPRESS_RESTART_COUNT=0
MARIADB_HEALTH=healthy
MARIADB_PRIVATE_ENDPOINT=ABSENT
```

Caddy rollback route must remain present and untouched.

## Evidence

Append result to:

```text
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Fresh-read both after commit. Do not modify Reviewer Handoff.

## Result

Success:

```text
PASS_CANDIDATE_M2D_PUBLIC_REGRESSION_AND_OBSERVATION
OBSERVATION_CHECKPOINTS=3
PRODUCTION_INGRESS_STABLE=PASS
PUBLIC_HOME_STABLE=PASS
PUBLIC_SHOP_STABLE=PASS
PUBLIC_WP_REST_STABLE=PASS
TLS_STABLE=PASS
EXISTING_TUNNEL_ROUTES_UNCHANGED=PASS
WORDPRESS_RUNTIME_HEALTH=PASS
MARIADB_ISOLATION=PASS
CADDY_ROLLBACK_ROUTE_RETAINED=PASS
M2B_TEMP_HOSTNAME_ABSENT=PASS
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
CADDY_MUTATIONS=0
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
PAYMENT_ACTIONS=0
M2E_ENTERED=NO
STOP_AT_REVIEWER=YES
```

Otherwise return one precise read-only regression result.
