# M2E — Retire Legacy Mini Craft Caddy Route Execution

## Gate

```text
M2E_RETIRE_LEGACY_MINICRAFT_CADDY_ROUTE
WRITE_GATE=YES
OWNER_AUTHORIZED=YES
STOP_AT_REVIEWER=YES
```

## Read first

Read canonical Governance latest and:

```text
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2E_OWNER_AUTHORIZED_RETIRE_LEGACY_MINICRAFT_CADDY_ROUTE.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Use the accepted Hostinger Web Terminal path. Do not retry direct SSH.

## Phase A — target and Caddy source preflight

Prove:

```text
TARGET_HOST=srv1970241
TARGET_HOST_EXECUTION_PROVEN=PASS
```

Read-only discover:

- running Caddy service/container identity;
- exact active Caddy config source path;
- exact reload mechanism already used by the current deployment;
- existing Shared Infrastructure/Caddy-scoped backup/config directory suitable for one rollback copy.

Do not read or print environment/Secret values.

Require active config hash:

```text
CURRENT_CADDYFILE_SHA256=cde23fafd4c23f69e089f11bcafdfec22db61bc7ebbfd979b3b8213ddfaf72f8
```

If different:

```text
RETURN_M2E_PREFLIGHT_DRIFT
CADDY_MUTATIONS=0
STOP_AT_REVIEWER=YES
```

## Phase B — exact route isolation

Identify only the Caddy site/matcher serving:

`minicraft.spikersun.com`

Prove:

```text
MINICRAFT_CADDY_MATCHER_PRESENT=YES
MINICRAFT_CADDY_MATCHER_SHARED_WITH_OTHER_HOSTS=NO
```

Capture a structural summary of the block without exposing Secret values.

Enumerate all other Caddy hostnames/routes as regression targets.

If the Mini Craft block shares a site label/matcher with another hostname or route boundaries are ambiguous:

```text
RETURN_M2E_ROUTE_BOUNDARY_UNRESOLVED
CADDY_MUTATIONS=0
STOP_AT_REVIEWER=YES
```

## Phase C — production/Tunnel continuity before write

Read-only prove:

```text
CANONICAL_TUNNEL_ROUTE=PASS
CANONICAL_TUNNEL_DNS=PASS
OLD_A_RECORD_PRESENT=NO
MINICRAFT_HOME_HTTP=200
MINICRAFT_SHOP_HTTP=200
MINICRAFT_WP_REST_HTTP=200
MINICRAFT_TLS_VALID=YES
EXISTING_XIANYU_PAY_SHOP_ROUTES_UNCHANGED=PASS
CADDY_SERVICE_HEALTH=PASS
```

Validate the current Caddy config using the deployment's accepted validation mechanism.

Require:

```text
PREWRITE_CADDY_VALIDATION=PASS
```

## Phase D — exact rollback copy

Create exactly one rollback copy of the full active Caddy config in an already-existing Shared Infrastructure/Caddy-scoped backup/config directory.

Record only safe metadata:

```text
ROLLBACK_COPY_PATH=
ROLLBACK_COPY_SHA256=
ROLLBACK_COPY_EQUALS_PREWRITE=YES
```

The rollback copy SHA must equal the accepted prewrite hash.

Do not create a new top-level backup convention. If no existing approved location can be identified:

```text
RETURN_M2E_ROLLBACK_LOCATION_UNRESOLVED
STOP_AT_REVIEWER=YES
```

## Phase E — bounded edit

Modify only the active Caddy config.

Delete exactly the Mini Craft legacy route/site block serving:

`minicraft.spikersun.com`

No other line/route/hostname semantic may change.

After edit, verify:

```text
MINICRAFT_CADDY_MATCHER_PRESENT=NO
OTHER_CADDY_ROUTES_SEMANTICALLY_UNCHANGED=YES
```

Then validate edited Caddy config.

If validation fails:

1. restore exact rollback copy;
2. prove original hash restored;
3. do not reload;
4. RETURN.

## Phase F — one bounded reload

If edited validation PASSes, perform exactly one Caddy reload using the already-established deployment mechanism.

Do not restart/recreate the Caddy service/container.

If reload result is ambiguous, do not repeat blindly. Fresh-read Caddy health/current config first.

## Phase G — post-reload proof

Require:

```text
CADDY_SERVICE_HEALTH=PASS
MINICRAFT_CADDY_MATCHER_PRESENT=NO
OTHER_CADDY_ROUTES_SEMANTICALLY_UNCHANGED=YES
OTHER_CADDY_SITES_REGRESSION=PASS

MINICRAFT_HOME_HTTP=200
MINICRAFT_SHOP_HTTP=200
MINICRAFT_WP_REST_HTTP=200
MINICRAFT_TLS_VALID=YES
PRODUCTION_INGRESS=CLOUDFLARE_TUNNEL_DIRECT_TO_MINICRAFT_APP
CANONICAL_TUNNEL_ROUTE=PASS
CANONICAL_TUNNEL_DNS=PASS
EXISTING_XIANYU_PAY_SHOP_ROUTES_UNCHANGED=PASS
```

## Phase H — rollback on failure

If reload or post-reload regression fails:

1. restore exact rollback Caddy config;
2. validate;
3. perform one rollback reload;
4. prove original prewrite hash restored;
5. prove Mini Craft legacy matcher restored;
6. verify all prior Caddy sites healthy;
7. verify Mini Craft Tunnel production Home/Shop/REST/TLS healthy;
8. persist Evidence/Handoff;
9. RETURN and stop.

No second retirement attempt in this Gate after rollback.

## Forbidden

No Cloudflare/DNS/Tunnel changes. No cloudflared mutation. No Caddy image/package upgrade. No Caddy restart/recreate. No unrelated route edit. No VPS/Docker/Compose/WordPress/MariaDB/shared-network/payment/cleanup/SSH changes. No Secret/token/cookie output.

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
PASS_CANDIDATE_M2E_RETIRE_LEGACY_MINICRAFT_CADDY_ROUTE
TARGET_HOST_EXECUTION_PROVEN=PASS
PREWRITE_CADDY_VALIDATION=PASS
ROLLBACK_COPY=PASS
LEGACY_MINICRAFT_CADDY_ROUTE=ABSENT
EDITED_CADDY_VALIDATION=PASS
CADDY_RELOAD=PASS
CADDY_SERVICE_HEALTH=PASS
OTHER_CADDY_SITES_REGRESSION=PASS
MINICRAFT_TUNNEL_PRODUCTION_REGRESSION=PASS
CLOUDFLARE_MUTATIONS=0
DNS_MUTATIONS=0
TUNNEL_ROUTE_MUTATIONS=0
VPS_OTHER_MUTATIONS=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
WORDPRESS_MUTATIONS=0
MARIADB_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_EMITTED=0
MIGRATION_M1_TO_M2E=COMPLETE_CANDIDATE
STOP_AT_REVIEWER=YES
```

Otherwise return one precise fail-closed result.
