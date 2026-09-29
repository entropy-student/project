# M1-R3 — Mini Craft Tunnel Architecture Completion

## Gate

```text
M1_R3_MINICRAFT_TUNNEL_ARCHITECTURE_COMPLETION
READ_ONLY_ONLY=YES
STOP_AT_REVIEWER=YES
```

## Read first

Read canonical Governance latest, then:

```text
shared-vps-infrastructure/SHARED_VPS_HANDOFF.md
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/docs/REVIEWER_DECISION_M1_R2_PASS_R3_ARCHITECTURE_COMPLETION.md
shared-vps-infrastructure/review-packets/M1_MINICRAFT_TUNNEL_ARCHITECTURE_READONLY_CONFIRMATION.md
mini-craft-night-kit/REVIEWER_HANDOFF.md
mini-craft-night-kit/PROJECT_STORAGE_MANIFEST.md
dujiao-next/REVIEWER_HANDOFF.md
unified-pay-system/REVIEWER_HANDOFF.md
```

Treat the accepted Hostinger console checkpoint as authoritative target-host evidence:

```text
TARGET_HOST=srv1970241
TARGET_HOST_EXECUTION_PROVEN=PASS
CONSOLE_USER=root
SSH_SERVER_SIDE_HEALTH=PASS
SSH_ROOT_CAUSE=INSUFFICIENT_EVIDENCE
```

Do not retry direct SSH in this Gate.

## Remaining host-side facts

If exact alias / Compose network facts are not already present in accepted Owner-console output, stop only for one minimal Owner-console read-only checkpoint. Do not reopen broad host discovery.

Required facts:

```text
MINICRAFT_WORDPRESS_ALIASES_BY_NETWORK=
SPIKERSUN_PRIVATE_ALIASES=
MINICRAFT_ALIAS_COLLISION=
MINICRAFT_COMPOSE_NETWORK_DECLARATIONS=
SPIKERSUN_PRIVATE_EXTERNAL_REUSE_FEASIBLE=
```

A future Mini Craft Tunnel origin should prefer a project-unique explicit alias rather than generic `wordpress` if that reduces collision risk.

Do not change Compose or attach the network.

## cloudflared truth

Use accepted target-host metadata and historical accepted Evidence. Confirm without reading command/env/token values:

```text
CLOUDFLARED_STATE=
CLOUDFLARED_IMAGE=
CLOUDFLARED_NETWORKS=
CLOUDFLARED_MODE=REMOTE_MANAGED_TOKEN|OTHER|UNKNOWN
LOCAL_INGRESS_FILE=PRESENT|ABSENT|UNKNOWN
TOKEN_OR_ENV_READ=NO
```

## Cloudflare control-plane truth

If an authenticated Cloudflare Dashboard session is already available, read only the remotely-managed Tunnel public-hostname mappings needed to establish:

```text
shop.spikersun.com -> exact origin service target
pay.spikersun.com -> exact origin service target (only if useful)
```

No DNS/Tunnel write.

Classify Dujiao:

```text
DUJIAO_TUNNEL_PATTERN=DIRECT_TO_APP_ALIAS|VIA_CADDY|OTHER|UNVERIFIED
```

If no authenticated Cloudflare session exists and the mapping is required:

```text
RETURN_OWNER_CLOUDFLARE_READONLY_SESSION_REQUIRED
STOP_AT_REVIEWER=YES
```

Do not request credentials in chat.

## Canary feasibility

Determine whether a temporary hostname can validate the new Tunnel path while the canonical domain remains on Caddy.

Freeze:

```text
TEMP_TUNNEL_CANARY_FEASIBLE=
ORIGIN_SERVICE=
ORIGIN_HOST_HEADER_REQUIREMENT=
CANARY_SAFE_SCOPE=
COOKIE_SESSION_LIMITATION=
```

No canary route is created in R3.

## Final architecture proposal

Return exactly one:

```text
TARGET_ARCHITECTURE=DIRECT_TUNNEL_TO_MINICRAFT_APP
TARGET_ARCHITECTURE=TUNNEL_TO_CADDY
TARGET_ARCHITECTURE=OTHER_REVIEW_REQUIRED
TARGET_ARCHITECTURE=UNRESOLVED
```

Also freeze M2 into bounded units:

```text
M2A_PRIVATE_NETWORK_PREPARATION
M2B_TEMP_TUNNEL_CANARY
M2C_PRODUCTION_HOSTNAME_CUTOVER
M2D_PUBLIC_REGRESSION_AND_OBSERVATION
M2E_RETIRE_OLD_MINICRAFT_CADDY_ROUTE
```

Old Caddy route remains rollback until M2E.

## Forbidden

No SSH retry, DNS write, Tunnel write, cloudflared/Caddy mutation, Docker network mutation, Compose edit/recreate, WordPress/MariaDB write, payment/provider action, Secret/token/session/private-key output, cleanup, Unified Pay deletion or Xianyu cleanup.

## Result

Success:

```text
PASS_CANDIDATE_M1_R3_MINICRAFT_TUNNEL_ARCHITECTURE_COMPLETION
TARGET_HOST_EXECUTION_PROVEN=PASS
TARGET_ARCHITECTURE=<one allowed value>
MUTATIONS=0
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

Otherwise precise RETURN and stop.
