# Reviewer Decision — M2C Formal PASS / M2D Read-only Public Regression Observation Authorized

Date: 2026-09-30
Role: Reviewer / Architect / Gatekeeper

## Independent review

Reviewed:

- Evidence commit `b7a4b7c4c0a0a7450cdae0330647ca4d4a31b326`
- Executor Handoff commit `c1f6d9dd9e6c5846ac075deb908212acba2a000e`

The M2C PASS_CANDIDATE is accepted.

## Formal M2C result

```text
M2C_PRODUCTION_HOSTNAME_TUNNEL_CUTOVER=PASS

PRODUCTION_HOST=minicraft.spikersun.com
PRODUCTION_INGRESS=CLOUDFLARE_TUNNEL_DIRECT_TO_MINICRAFT_APP
PRODUCTION_TUNNEL=spikersun-shared-private
PRODUCTION_ORIGIN=http://mini-craft-night-kit-wordpress:80
PRODUCTION_ORIGIN_HTTP_HOST_HEADER=minicraft.spikersun.com

OLD_CANONICAL_A_RECORD=ABSENT
CANONICAL_TUNNEL_DNS_TYPE=CNAME
CANONICAL_TUNNEL_DNS_PROXY=PROXIED
CANONICAL_TUNNEL_DNS_TTL=AUTO

PUBLIC_HOME_HTTP=200
PUBLIC_SHOP_HTTP=200
PUBLIC_WP_REST_HTTP=200
TLS_VALID=YES

EXISTING_XIANYU_PAY_SHOP_ROUTES_UNCHANGED=PASS
CADDY_ROUTE_RETAINED_AS_ROLLBACK=YES

DNS_MUTATIONS=2
TUNNEL_ROUTE_MUTATIONS=1
CADDY_MUTATIONS=0
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
COMPOSE_MUTATIONS=0
WORDPRESS_MUTATIONS=0
MARIADB_MUTATIONS=0
PAYMENT_ACTIONS=0
M2D_ENTERED=NO
M2E_ENTERED=NO
```

M2C is formally closed.

## Current Gate

```text
CURRENT_GATE=M2D_PUBLIC_REGRESSION_AND_OBSERVATION
CURRENT_GATE_STATUS=AUTHORIZED_READONLY_ONLY
```

M2D requires no Owner write authorization because it is strictly read-only.

## M2D objective

Prove that the production cutover remains stable after the immediate M2C success and that no adjacent Shared VPS route regressed.

Required evidence:

1. canonical DNS still resolves through the Cloudflare Tunnel CNAME path and the old A record remains absent;
2. canonical Tunnel route remains exactly:
   - hostname `minicraft.spikersun.com`
   - Tunnel `spikersun-shared-private`
   - origin `http://mini-craft-night-kit-wordpress:80`
   - HTTP Host Header `minicraft.spikersun.com`;
3. Home / Shop / `/wp-json/` remain HTTP 200 with normal TLS verification;
4. xianyu/pay/shop Tunnel routes remain unchanged;
5. Mini Craft WordPress remains running with restart count 0 and on DB + edge + private networks;
6. MariaDB remains healthy and isolated from `spikersun-private`;
7. the old Mini Craft Caddy route remains present and untouched as rollback infrastructure;
8. no temporary M2B hostname reappears;
9. no payment/business action occurs.

## Observation shape

Use three read-only checkpoints:

```text
T0
T+5 minutes
T+10 minutes
```

At each checkpoint collect only safe metadata and HTTP/TLS results.

If the execution environment cannot reliably wait for the bounded intervals, it may return `RETURN_M2D_OBSERVATION_WINDOW_INCOMPLETE` rather than compressing all checks into one instant.

## Failure handling

M2D is read-only. It does not authorize rollback or any mutation.

If a regression is observed, return a precise `RETURN_M2D_...` and stop at Reviewer. A separate rollback Gate will be required if rollback is necessary.

## Success boundary

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
MUTATIONS=0
M2E_ENTERED=NO
STOP_AT_REVIEWER=YES
```

M2D PASS does not authorize Caddy retirement. M2E remains a separate explicit write Gate.
