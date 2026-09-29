# Reviewer Decision — M1-R4 PASS / M1 Architecture Sealed / M2A Authorized

Date: 2026-09-29
Role: Reviewer / Architect / Gatekeeper

## Independent review

Reviewed Executor Evidence commit:

`36be2833cb0c4e1743f149f1d9b0c610b54d6e37`

and Executor Handoff commit:

`3f514da21e31ea869dfed09d6982d37ea3030864`

The evidence is internally consistent with the accepted M1 host-side facts and the authenticated Cloudflare control-plane readback.

## Formal result

```text
M1_R4_CLOUDFLARE_READONLY_SESSION_AND_ARCHITECTURE_SEAL=PASS
M1_MINICRAFT_TUNNEL_ARCHITECTURE_CONFIRMATION=PASS
TARGET_ARCHITECTURE=DIRECT_TUNNEL_TO_MINICRAFT_APP

TUNNEL=spikersun-shared-private
DUJIAO_PATTERN=DIRECT_TO_APP_ALIAS
SHOP_ORIGIN=http://dujiao-next-app:8080
PAY_ORIGIN=http://unified-pay-app:8080
XIANYU_ORIGIN=http://xianyu-app:8090

MINICRAFT_FUTURE_PRIVATE_ALIAS=mini-craft-night-kit-wordpress
MINICRAFT_FUTURE_ORIGIN=http://mini-craft-night-kit-wordpress:80
MARIADB_PRIVATE_NETWORK_ATTACHMENT=NO

M1_MUTATIONS=0
MINI_CRAFT_K9_REOPENED=NO
```

## Architecture

Accepted target:

```text
Internet
  -> Cloudflare
  -> spikersun-shared-private Tunnel
  -> cloudflared on spikersun-private
  -> mini-craft-night-kit-wordpress:80
  -> WordPress
```

Caddy is not part of the target Mini Craft ingress path.

The current Caddy route remains intact as rollback through M2D.

## M2 sequence

```text
M2A_PRIVATE_NETWORK_PREPARATION
M2B_TEMP_TUNNEL_CANARY
M2C_PRODUCTION_HOSTNAME_CUTOVER
M2D_PUBLIC_REGRESSION_AND_OBSERVATION
M2E_RETIRE_OLD_MINICRAFT_CADDY_ROUTE
```

M2C remains a separate production cutover authorization. M2E remains separately authorized only after M2D PASS.

## M2A authorization

M2A may change only Mini Craft WordPress project configuration/runtime membership:

- declare existing external network `spikersun-private`;
- attach WordPress only;
- assign unique alias `mini-craft-night-kit-wordpress`;
- keep the project DB network;
- keep MariaDB off `spikersun-private`;
- preserve `spikersun-edge` and the current Caddy route;
- perform no Cloudflare/DNS/Tunnel write.

Because direct SSH is currently intermittent and no repair is authorized, target-host write must use an execution path that proves the real host and gives post-write host-local readback. The accepted Hostinger Web Terminal may be used as an Owner-local checkpoint if the Executor cannot directly control it.

M2A does not authorize M2B.
