# M1-R4 — Cloudflare Read-only Session + Architecture Seal

## Gate

```text
M1_R4_CLOUDFLARE_READONLY_SESSION_AND_ARCHITECTURE_SEAL
OWNER_ACCOUNT_AUTH_CHECKPOINT_THEN_READONLY=YES
STOP_AT_REVIEWER=YES
```

## Owner checkpoint

Owner signs into Cloudflare Dashboard in the existing browser session.

Do not provide credentials, 2FA, recovery codes, API tokens or sensitive screenshots to Executor/chat.

After successful login, no further Owner action is required unless Cloudflare itself requires an account-side approval to view the relevant Tunnel.

## Executor: read-only only

Read latest canonical Governance and current Shared VPS handoff/decision first.

Then use the authenticated Cloudflare Dashboard session only for read-only inspection.

Required outputs:

```text
SHOP_PUBLIC_HOSTNAME=shop.spikersun.com
SHOP_TUNNEL_ORIGIN_SERVICE=
DUJIAO_TUNNEL_PATTERN=DIRECT_TO_APP_ALIAS|VIA_CADDY|OTHER|UNVERIFIED
PAY_PUBLIC_HOSTNAME_ORIGIN_SERVICE=   # optional, only if useful
```

Do not expose:

- Tunnel token;
- API token;
- account/session cookie;
- origin credential;
- private account identifiers unrelated to architecture.

## Architecture seal

Combine the Cloudflare control-plane readback with accepted host-side facts:

- cloudflared on `spikersun-private`;
- Dujiao/Unified Pay/Xianyu attached to `spikersun-private`;
- Mini Craft currently on project DB network + `spikersun-edge`;
- Mini Craft has no current alias on `spikersun-private`;
- generic `app` alias is already non-unique on `spikersun-private`;
- future Mini Craft private-network alias must be project-unique.

Freeze:

```text
TEMP_TUNNEL_CANARY_FEASIBLE=
MINICRAFT_FUTURE_PRIVATE_ALIAS=
ORIGIN_SERVICE_PATTERN=
ORIGIN_HOST_HEADER_REQUIREMENT=
CANARY_SAFE_SCOPE=
COOKIE_SESSION_LIMITATION=
```

Then return exactly one:

```text
TARGET_ARCHITECTURE=DIRECT_TUNNEL_TO_MINICRAFT_APP
TARGET_ARCHITECTURE=TUNNEL_TO_CADDY
TARGET_ARCHITECTURE=OTHER_REVIEW_REQUIRED
TARGET_ARCHITECTURE=UNRESOLVED
```

Also freeze, but do not execute:

```text
M2A_PRIVATE_NETWORK_PREPARATION
M2B_TEMP_TUNNEL_CANARY
M2C_PRODUCTION_HOSTNAME_CUTOVER
M2D_PUBLIC_REGRESSION_AND_OBSERVATION
M2E_RETIRE_OLD_MINICRAFT_CADDY_ROUTE
```

Old Mini Craft Caddy route remains rollback through M2D.

## Forbidden

No:

- DNS edit/create/delete;
- Tunnel/Public Hostname edit/create/delete;
- cloudflared/Caddy mutation;
- Docker network mutation;
- Compose/application/database mutation;
- payment/provider action;
- SSH retry;
- cleanup/deletion;
- Secret/token/session output.

## Result

Success:

```text
PASS_CANDIDATE_M1_R4_CLOUDFLARE_READONLY_SESSION_AND_ARCHITECTURE_SEAL
TARGET_ARCHITECTURE=<one allowed value>
CLOUDFLARE_MUTATIONS=0
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
CADDY_MUTATIONS=0
PROJECT_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

Otherwise return one precise fail-closed reason and stop.
