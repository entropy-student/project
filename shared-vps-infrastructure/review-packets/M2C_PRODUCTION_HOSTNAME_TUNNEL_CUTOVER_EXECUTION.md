# M2C — Production Hostname Tunnel Cutover Execution

## Gate

```text
M2C_PRODUCTION_HOSTNAME_TUNNEL_CUTOVER
WRITE_GATE=YES
OWNER_AUTHORIZED=YES
STOP_AT_REVIEWER=YES
```

## Read first

Read canonical Governance latest and:

```text
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M2C_OWNER_AUTHORIZED_PRODUCTION_TUNNEL_CUTOVER.md
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Do not enter M2D or M2E.

## Exact authorized target

```text
PRODUCTION_HOST=minicraft.spikersun.com
EXPECTED_OLD_DNS_TYPE=A
EXPECTED_OLD_DNS_CONTENT=2.24.193.133
EXPECTED_OLD_DNS_PROXIED=NO

TARGET_TUNNEL=spikersun-shared-private
TARGET_ORIGIN=http://mini-craft-night-kit-wordpress:80
TARGET_ORIGIN_HTTP_HOST_HEADER=minicraft.spikersun.com
```

## Phase A — authenticated production preflight

Use the Owner-authenticated Cloudflare Dashboard session.

Before any mutation, reliably prove the active browser context and authenticated account/tunnel page. If page identity cannot be trusted:

```text
RETURN_CLOUDFLARE_BROWSER_CONTEXT_UNVERIFIED
STOP_AT_REVIEWER=YES
```

If authentication is absent:

```text
RETURN_OWNER_CLOUDFLARE_SESSION_REQUIRED
STOP_AT_REVIEWER=YES
```

Fresh-read and record metadata only:

```text
OLD_DNS_TYPE=
OLD_DNS_HOSTNAME=
OLD_DNS_CONTENT=
OLD_DNS_PROXIED=
OLD_DNS_TTL=
OLD_DNS_RECORD_ID_PRESENT=YES|NO
CANONICAL_TUNNEL_ROUTE_PRESENT=NO
TUNNEL_HEALTH=HEALTHY
M2B_TEMP_TUNNEL_ROUTE_PRESENT=NO
M2B_TEMP_DNS_PRESENT=NO
```

Require the old record to be exactly one DNS-only A record for `minicraft.spikersun.com -> 2.24.193.133`.

Also prove existing routes exactly unchanged:

```text
shop.spikersun.com -> http://dujiao-next-app:8080
pay.spikersun.com -> http://unified-pay-app:8080
xianyu.spikersun.com -> http://xianyu-app:8090
```

Verify before cutover:

```text
PREWRITE_PRODUCTION_HOME_HTTP=200
PREWRITE_PRODUCTION_SHOP_HTTP=200
PREWRITE_PRODUCTION_WP_REST_HTTP=200
```

If any material mismatch exists:

```text
RETURN_M2C_PREFLIGHT_DRIFT
PRODUCTION_MUTATIONS=0
STOP_AT_REVIEWER=YES
```

## Phase B — seal rollback record

Before deletion, persist in execution notes the exact safe rollback metadata:

```text
ROLLBACK_DNS_TYPE=A
ROLLBACK_DNS_HOSTNAME=minicraft.spikersun.com
ROLLBACK_DNS_CONTENT=2.24.193.133
ROLLBACK_DNS_PROXIED=NO
ROLLBACK_DNS_TTL=<exact fresh value>
```

Do not record sensitive account/session metadata.

## Phase C — bounded production cutover transaction

After Phase A+B PASS:

1. delete only the exact sealed old Mini Craft A record;
2. immediately navigate to / remain in Tunnel `spikersun-shared-private`;
3. create exactly one canonical public-hostname route:
   - hostname: `minicraft.spikersun.com`
   - service: `http://mini-craft-night-kit-wordpress:80`
   - HTTP Host Header: `minicraft.spikersun.com`
4. save once;
5. allow Cloudflare to create only the DNS record required for this canonical Tunnel route.

Do not modify xianyu/pay/shop routes.

### Ambiguous provider action rule

If delete/save outcome is unclear:

- do not repeat the destructive/save action blindly;
- fresh-read DNS + Tunnel route state first;
- if new canonical route/DNS is proven exact, continue;
- if old A is absent and new route is not proven exact, immediately execute rollback;
- if conflicting/unknown state remains, perform no further blind provider action; use the safest proven rollback path and RETURN.

## Phase D — immediate control-plane readback

Require:

```text
OLD_A_RECORD_PRESENT=NO
CANONICAL_TUNNEL_ROUTE_PRESENT=YES
CANONICAL_TUNNEL=spikersun-shared-private
CANONICAL_ORIGIN_SERVICE=http://mini-craft-night-kit-wordpress:80
CANONICAL_ORIGIN_HTTP_HOST_HEADER=minicraft.spikersun.com
CANONICAL_TUNNEL_DNS_PRESENT=YES
```

Record the canonical Tunnel DNS type/target as safe metadata.

Require xianyu/pay/shop mappings unchanged.

## Phase E — immediate public validation

Use normal TLS verification and anonymous requests with no cookies/admin/order/payment data:

- `https://minicraft.spikersun.com/`
- `https://minicraft.spikersun.com/shop/`
- `https://minicraft.spikersun.com/wp-json/`

Allow a short bounded propagation window with at most three read-only attempts. Do not mutate anything between attempts.

Require:

```text
POSTCUTOVER_HOME_HTTP=200
POSTCUTOVER_SHOP_HTTP=200
POSTCUTOVER_WP_REST_HTTP=200
POSTCUTOVER_TLS_VALID=YES
```

Also require:

```text
EXISTING_TUNNEL_ROUTES_UNCHANGED=PASS
CADDY_MUTATIONS=0
```

## Phase F — rollback on any failure

If Phase C/D/E fails:

1. fresh-read canonical DNS + Tunnel route first;
2. remove only the M2C-created canonical Mini Craft Tunnel route if present;
3. remove its canonical Tunnel DNS record if separately present;
4. recreate the exact sealed A record:
   - `minicraft.spikersun.com`
   - A
   - `2.24.193.133`
   - DNS-only / proxied OFF
   - exact `ROLLBACK_DNS_TTL`
5. fresh-readback exact restored DNS;
6. validate Home / Shop / REST HTTP 200;
7. confirm xianyu/pay/shop unchanged;
8. confirm Caddy was untouched;
9. persist Evidence/Handoff and RETURN.

No second cutover attempt in this Gate after rollback.

## Phase G — success stop

On success, do **not** delete or edit the existing Mini Craft Caddy route.

Return:

```text
PASS_CANDIDATE_M2C_PRODUCTION_HOSTNAME_TUNNEL_CUTOVER
PRODUCTION_HOST=minicraft.spikersun.com
PRODUCTION_INGRESS=CLOUDFLARE_TUNNEL_DIRECT_TO_MINICRAFT_APP
CANONICAL_TUNNEL=spikersun-shared-private
CANONICAL_ORIGIN_SERVICE=http://mini-craft-night-kit-wordpress:80
CANONICAL_ORIGIN_HTTP_HOST_HEADER=minicraft.spikersun.com
POSTCUTOVER_HOME_HTTP=200
POSTCUTOVER_SHOP_HTTP=200
POSTCUTOVER_WP_REST_HTTP=200
POSTCUTOVER_TLS_VALID=YES
EXISTING_TUNNEL_ROUTES_UNCHANGED=PASS
CADDY_ROUTE_RETAINED_AS_ROLLBACK=YES
CADDY_MUTATIONS=0
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
WORDPRESS_MUTATIONS=0
MARIADB_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_EMITTED=0
M2D_ENTERED=NO
M2E_ENTERED=NO
STOP_AT_REVIEWER=YES
```

## Evidence

Append the exact result to:

```text
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Fresh-read both after commit. Do not modify Reviewer Handoff.
