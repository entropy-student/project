# M1 — Mini Craft Tunnel Architecture Read-only Confirmation

## Gate

```text
M1_MINICRAFT_TUNNEL_ARCHITECTURE_READONLY_CONFIRMATION
READ_ONLY_ONLY=YES
STOP_AT_REVIEWER=YES
```

## Read first

Canonical Governance:

```text
entropy-student/spike.skill/vps-project-governance/GOVERNANCE_HANDOFF.md
entropy-student/spike.skill/vps-project-governance/SKILL.md
entropy-student/spike.skill/vps-project-governance/references/GOVERNANCE_SOURCE_POLICY.md
entropy-student/spike.skill/vps-project-governance/references/GOVERNANCE_V0_1_6.md
entropy-student/spike.skill/vps-project-governance/references/STORAGE_LAYOUT_CONTRACT.md
entropy-student/spike.skill/vps-project-governance/references/SSH_AND_DELEGATED_SECRET_OPERATIONS.md
entropy-student/spike.skill/vps-project-governance/references/TARGET_HOST_REALITY_CONTRACT.md
```

Current project/environment truth:

```text
shared-vps-infrastructure/REVIEWER_HANDOFF.md
shared-vps-infrastructure/SHARED_VPS_PORTFOLIO.md
mini-craft-night-kit/REVIEWER_HANDOFF.md
mini-craft-night-kit/PROJECT_STORAGE_MANIFEST.md
mini-craft-night-kit/docs/REVIEWER_DECISION_K6_G_R4_PASS_K6_DEPLOYMENT_PASS_K7_READINESS.md
dujiao-next/REVIEWER_HANDOFF.md
unified-pay-system/REVIEWER_HANDOFF.md
```

Reviewer decision:

```text
shared-vps-infrastructure/docs/REVIEWER_DECISION_M1_MINICRAFT_TUNNEL_ARCHITECTURE_READONLY_CONFIRMATION.md
```

## Important baseline

Mini Craft currently works through:

```text
minicraft.spikersun.com
-> DNS-only A to VPS
-> shared Caddy :443
-> wordpress:80
```

Accepted K6 evidence says Mini Craft WordPress is on `spikersun-edge`.

Current Shared VPS reconciliation says:

```text
cloudflared -> spikersun-private
Dujiao public ingress -> Cloudflare remote-managed Tunnel likely, not yet exactly verified
```

The job is to prove the correct reusable Tunnel architecture before any change.

## Phase A — target-host continuity

Use the canonical Shared VPS connection contract if available.

If direct strict SSH cannot prove target execution, use the already-allowed Hostinger Browser Terminal read-only recovery path if available.

Prove:

```text
TARGET_HOST=srv1970241
TARGET_HOST_EXECUTION_PROVEN=PASS
```

Read only:

- hostname/user/date/uptime;
- relevant running containers and restart counts;
- no host-published WordPress/MariaDB port;
- Caddy/cloudflared running state.

If target-host execution cannot be proven:

```text
RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE
STOP_AT_REVIEWER=YES
```

## Phase B — Mini Craft current network truth

Read-only inspect the running WordPress/MariaDB containers and current canonical Compose source.

Return:

```text
MINICRAFT_WORDPRESS_NETWORKS=
MINICRAFT_WORDPRESS_ALIASES_BY_NETWORK=
MINICRAFT_MARIADB_NETWORKS=
MINICRAFT_CANONICAL_COMPOSE_SOURCE=
MINICRAFT_RENDERED_NETWORK_DECLARATIONS=
```

Determine whether:

- `spikersun-private` can be declared as an existing external network without changing/recreating it;
- WordPress can join it without MariaDB joining it;
- the service/alias to be used by cloudflared is unambiguous.

Do not edit Compose.

## Phase C — shared network collision check

Read-only inventory `spikersun-private`:

- exact attached containers;
- per-container aliases;
- duplicate service/alias names relevant to Mini Craft;
- driver/scope/labels sufficient to prove ownership and reuse boundary.

Return:

```text
SPIKERSUN_PRIVATE_EXISTS=
SPIKERSUN_PRIVATE_RECREATE_REQUIRED=NO|YES|UNKNOWN
MINICRAFT_ALIAS_COLLISION=NO|YES|UNKNOWN
SAFE_PROJECT_MEMBERSHIP_CANDIDATE=YES|NO|UNKNOWN
```

Do not attach/detach anything.

## Phase D — cloudflared local truth

Read-only inspect cloudflared:

- image;
- running/restart state;
- networks;
- command/args **with token value redacted/not emitted**;
- whether local ingress config file exists;
- whether mode is remote-managed token mode.

Return:

```text
CLOUDFLARED_MODE=
CLOUDFLARED_NETWORKS=
LOCAL_INGRESS_FILE=PRESENT|ABSENT
TOKEN_VALUE_READ_OR_EMITTED=NO
```

## Phase E — Dujiao pattern confirmation

Use local read-only evidence first.

If an already-authenticated Cloudflare Dashboard/session is available, read only the Tunnel/Public Hostname mappings required to determine:

```text
shop.spikersun.com -> <service target>
pay.spikersun.com  -> <service target>   # only if useful; no Unified Pay mutation
```

Do not output account/session/token values.

Classify:

```text
DUJIAO_TUNNEL_PATTERN=
DIRECT_TO_APP_ALIAS
| VIA_CADDY
| OTHER
| UNVERIFIED
```

If Cloudflare authentication is not already available and exact route metadata is essential to architecture selection, stop with:

```text
RETURN_OWNER_CLOUDFLARE_READONLY_SESSION_REQUIRED
STOP_AT_REVIEWER=YES
```

No login credential request in chat.

## Phase F — current Mini Craft public baseline

Read-only verify:

- current DNS A/AAAA/CNAME answer and proxy semantics where externally observable;
- normal TLS verification;
- home;
- shop;
- product/public storefront route;
- cart;
- checkout accepted empty-cart semantics;
- My Account;
- WP REST;
- media;
- WooCommerce Store API;
- current PayPal webhook URL path only as non-secret route metadata if already documented/readable, without provider action.

No order/payment/cart state mutation.

Return a compact regression fingerprint.

## Phase G — current Caddy rollback truth

Read-only verify:

- Caddy current Mini Craft host matcher;
- upstream exactly `wordpress:80`;
- current Caddyfile source path;
- current Caddy container/image/network;
- existing project-scoped rollback Caddyfile artifacts metadata;
- exact current DNS rollback fact.

Do not read/emit unrelated route bodies or secrets.

## Phase H — canary feasibility

Determine whether a temporary hostname such as a Reviewer-selected Mini Craft Tunnel canary could reach the WordPress origin without changing the canonical WordPress URL.

Assess:

- expected WordPress redirect behavior;
- whether Cloudflare Tunnel origin request can preserve/override the Host header to `minicraft.spikersun.com`;
- whether TLS is terminated at Cloudflare and origin may safely be HTTP on the private Docker network;
- whether cookies/session behavior makes public canary checkout testing unsafe.

Do not create the canary hostname.

Return:

```text
TEMP_TUNNEL_CANARY_FEASIBLE=YES|NO|UNKNOWN
ORIGIN_HOST_HEADER_REQUIREMENT=
CANARY_VALIDATION_SCOPE=
```

## Phase I — architecture decision proposal

Return exactly one proposed target:

```text
TARGET_ARCHITECTURE=DIRECT_TUNNEL_TO_MINICRAFT_APP
TARGET_ARCHITECTURE=TUNNEL_TO_CADDY
TARGET_ARCHITECTURE=OTHER_REVIEW_REQUIRED
TARGET_ARCHITECTURE=UNRESOLVED
```

For the selected target, freeze the later mutation units but do not execute them.

The later M2 plan must separate:

1. private/network preparation;
2. optional temporary Tunnel canary;
3. production hostname cutover;
4. public regression;
5. observation window/readback;
6. retirement of the old Caddy Mini Craft route and direct A record only after new path is proven;
7. rollback in the reverse order.

The existing Caddy route remains rollback until Reviewer explicitly retires it.

## Hard forbidden

No:

- DNS write;
- Tunnel route write;
- Cloudflare account change;
- Docker network connect/disconnect;
- Compose edit/recreate;
- Caddy write/reload/restart/recreate;
- cloudflared restart/recreate;
- WordPress/MariaDB mutation;
- Provider/payment/refund/webhook action;
- Secret/token/cookie/session output;
- Unified Pay deletion;
- Xianyu cleanup;
- broad prune.

## Evidence / handoff

Update only execution facts:

```text
shared-vps-infrastructure/EXECUTION_EVIDENCE.md
shared-vps-infrastructure/EXECUTOR_HANDOFF.md
```

Create them if absent using Governance templates.

Do not edit `REVIEWER_HANDOFF.md`.

## Result

Success:

```text
PASS_CANDIDATE_M1_MINICRAFT_TUNNEL_ARCHITECTURE_READONLY_CONFIRMATION
TARGET_ARCHITECTURE=<one allowed value>
VPS_MUTATIONS=0
DOCKER_MUTATIONS=0
CLOUDFLARE_MUTATIONS=0
CADDY_MUTATIONS=0
PROJECT_MUTATIONS=0
PAYMENT_ACTIONS=0
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

Or return one precise reason and stop.
