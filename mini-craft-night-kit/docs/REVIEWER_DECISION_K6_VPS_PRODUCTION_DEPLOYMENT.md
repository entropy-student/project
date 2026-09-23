# Reviewer Decision — K6 VPS Production Deployment

Date: 2026-09-23
Status: AUTHORIZED
Owner authorization: explicit in chat ("开始")

## Objective

Deploy the accepted Mini Craft Release Candidate to the existing shared Hostinger VPS as a Sandbox-first public canary.

Target origin:
https://minicraft.spikersun.com

This Gate authorizes bounded VPS/project/reverse-proxy/DNS work required for the Mini Craft canary, but does NOT authorize PayPal Live, real payment, or public commercial launch.

## Current accepted RC

K5 Release Candidate: PASS

Production WordPress target image:
wordpress:7.1.1-php8.3-apache

Local K5 deployment package:
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace\artifacts\gates\k5-release-candidate-qa\

Accepted local runtime source:
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery

## Shared VPS authority

Before any write, re-read the current local/canonical Shared VPS handoff and current project/infrastructure handoffs.

Expected previously observed shared-host baseline includes:
- Hostinger shared VPS
- existing shared 80/443 ownership
- existing shared reverse-proxy / edge infrastructure
- project-isolated Compose stacks
- /srv contract
- unrelated apps that must not be disturbed

Do not assume stale values. Re-prove current facts before mutation.

## Gate

GATE=K6_VPS_PRODUCTION_DEPLOYMENT

## Phase A — read-only shared-host preflight

Connect using the existing approved SSH path/identity only.

Do not ask Owner to paste SSH passwords/keys into chat or GitHub.

Freshly record:
- hostname
- OS / kernel
- CPU / RAM / disk free
- Docker Engine version
- Docker Compose version
- current containers
- current Docker networks
- current published host ports
- current UFW/firewall summary
- current 80/443 owner
- reverse proxy implementation and exact config source
- cloudflared state/routes if present
- /srv/apps
- /srv/data
- /srv/backups
- current Mini Craft path collision check
- resource headroom

Expected historical baseline may include existing xianyu, shared Caddy and cloudflared. Treat current host state as authoritative.

STOP immediately on:
- SSH host-key drift
- unexpected ownership of 80/443
- unknown shared-proxy topology
- path/name/port/network collision
- insufficient disk/RAM
- existing Mini Craft deployment of uncertain ownership
- material disagreement with Shared VPS handoff that could make write unsafe

Return:
RETURN_REVIEWER_SHARED_VPS_DRIFT
rather than guessing.

## Phase B — deployment manifest finalization

Before remote mutation:
- update local K5 deployment manifest production WordPress image to:
  wordpress:7.1.1-php8.3-apache
- do not rebuild accepted DB/wp-content backups solely for the zero-mutation K5R2 tooling stop
- verify existing backup hashes
- identify exact files to transfer
- create a dated local deployment execution record
- list secret/environment variable NAMES only

Never upload secret values to GitHub.

## Phase C — project-scoped remote layout

Use the Shared VPS directory contract.

Preferred canonical namespaces:

/srv/apps/mini-craft-night-kit
/srv/data/mini-craft-night-kit
/srv/backups/mini-craft-night-kit

If current Shared VPS handoff defines a different canonical WordPress project naming contract, follow that current contract and record the final paths.

Do not reuse or overwrite:
- /srv/apps/xianyu*
- /srv/apps/dujiao-next
- /srv/data/dujiao-next
- /srv/backups/dujiao-next
- unrelated application namespaces
- shared proxy/cloudflared data except the narrow Mini Craft route addition

Each Mini Craft service must be in its own Compose project.

## Phase D — production Compose

Deploy:
- WordPress:
  wordpress:7.1.1-php8.3-apache
- MariaDB:
  retain the K5-compatible MariaDB 11.4 family unless current Shared VPS policy requires an exact compatible pinned tag; no unreviewed major-version change

Requirements:
- project-local DB network
- DB must have NO public host port
- WordPress must not bind host 80/443
- prefer no public host port at all if the existing shared edge/network can proxy directly
- if the current shared proxy contract requires a loopback-only app port, choose a proven free high port and bind to 127.0.0.1 only
- no privileged containers
- project-scoped restart policy
- project-scoped volumes/data paths
- log rotation consistent with shared host policy
- no automatic image updater

Do not reinstall Docker/Compose.

## Phase E — restore accepted RC

Restore from accepted K5 package:
- MariaDB dump
- wp-content
- required WordPress configuration

Use production-safe project secrets.

Do not expose any secret value in terminal capture committed to GitHub.

Perform production URL migration:
http://localhost:8093
→
https://minicraft.spikersun.com

Use a serialized-data-safe WordPress method.

Do not blindly SQL string-replace serialized WordPress values.

Verify:
- home/siteurl
- attachment/media URLs
- internal page links
- WooCommerce endpoints
- canonical behavior

## Phase F — payment safety state

First public canary MUST remain:
PAYPAL_MODE=SANDBOX
PAYPAL_LIVE=NO

Do not:
- enable Live
- create real-money order
- capture real funds
- rotate PayPal credentials

Retain current test product state only as canary/test data.

Because current product is:
- JPY 1
- stock 8
- MCK-LOCAL-TEST-001

it must not be represented as production commercial truth.

No paid traffic or launch announcement in this Gate.

## Phase G — shared ingress

Target:
minicraft.spikersun.com

Use the CURRENT existing shared ingress architecture.

Rules:
- do not replace Caddy
- do not replace cloudflared
- do not alter SSH
- do not broadly alter firewall
- do not take over 80/443
- add only the narrow route/config necessary for Mini Craft

If the current host uses:
A. Caddy directly for public ingress:
- add only the Mini Craft site/upstream

B. Cloudflare Tunnel → shared edge:
- add only the required Mini Craft route consistent with existing ownership

C. another current architecture:
- follow the current factual handoff; do not invent a second ingress stack

Any required change outside the established shared-infra pattern:
RETURN_REVIEWER_SHARED_INFRA_CHANGE_REQUIRED

## Phase H — DNS / TLS

For minicraft.spikersun.com:

- if an already authenticated Cloudflare control-plane session/API path exists and current Shared VPS governance permits the narrow record/route change, create only the required Mini Craft DNS/route record;
- never request/paste Cloudflare API tokens into GitHub/chat;
- otherwise stop with:
  OWNER_ACTION=CONFIGURE_MINICRAFT_DNS
  and provide the exact record target/type required without secret material.

Verify:
- public DNS resolves as intended
- HTTPS certificate valid
- HTTP redirects to HTTPS if consistent with shared proxy
- no mixed-content blocker on primary pages

Do not change unrelated DNS records.

## Phase I — public Sandbox canary

After public HTTPS is live, verify from the public origin:

Routes:
- /
- /shop/
- /product/mini-craft-night-kit/
- /faq/
- /shipping-returns/
- /contact/
- /cart/
- /my-account/
- /wp-json/

Checkout:
- fresh anonymous Product → Cart → Checkout
- valid US state/address context
- US-only shipping behavior
- PayPal Sandbox method visible
- final PayPal/native checkout action renders on public HTTPS origin
- DO NOT click/order/pay

Admin:
- wp-admin reachable through intended path
- Orders admin reachable with authorized admin session
- product edit capability intact
- do not publish temporary QA products

Health:
- containers healthy
- DB no public port
- no critical 4xx/5xx on primary routes
- recent logs no fatal PHP/startup errors
- no legacy demo products visible
- Product Gallery intact
- Contact fields visible

## Phase J — production indexing safety

Until Soft Launch:
- do not deliberately enable broad search indexing if legal/product/email/measurement launch checks remain unresolved
- preserve a conservative noindex/launch-safe state unless current project truth explicitly says otherwise

Do not install/activate GA4, Resend, Search Console, Merchant Center, or new SEO tooling in K6.

## Phase K — rollback

Before each mutation, retain exact prior state for the touched Mini Craft/shared-ingress item.

Rollback must be able to:
- remove/stop only Mini Craft containers
- remove only Mini Craft route/config
- restore prior proxy config
- leave unrelated apps untouched
- preserve Mini Craft DB/data/backups for investigation unless deletion is explicitly authorized

Never broad docker prune.

## Acceptance

PASS candidate requires:

SHARED_VPS_PREFLIGHT=PASS
MINICRAFT_PATH_COLLISION=NO
PRODUCTION_IMAGE=wordpress:7.1.1-php8.3-apache
REMOTE_COMPOSE=PASS
WORDPRESS_CONTAINER=HEALTHY
MARIADB_CONTAINER=HEALTHY
DB_PUBLIC_PORT=NONE
WORDPRESS_PUBLIC_80_443_BIND=NONE
RESTORE=PASS
URL_MIGRATION=PASS
INGRESS=PASS
DNS=PASS
HTTPS=PASS
PUBLIC_PRIMARY_ROUTES=PASS
PUBLIC_CART_CHECKOUT=PASS
PAYPAL_MODE=SANDBOX
PAYPAL_PUBLIC_ACTION_VISIBLE=PASS
REAL_PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
UNRELATED_SERVICES_CHANGED=NO
ROLLBACK_READY=PASS

If DNS cannot be completed only because Owner control-plane access is required, it may return at a bounded Owner checkpoint after the remote deployment is healthy but before claiming public Canary PASS.

## Evidence

Update:
- EXECUTION_EVIDENCE.md
- EXECUTOR_HANDOFF.md

Create:
- docs/K6_VPS_DEPLOYMENT_MANIFEST.md

GitHub evidence must contain:
- non-sensitive topology
- image versions
- paths
- container/network names
- public route results
- redacted config facts
- rollback commands/strategy without secrets

Do NOT commit:
- .env
- wp-config.php
- DB credentials
- SSH private keys
- Cloudflare tokens
- PayPal secrets
- cookies/session tokens
- raw provider payloads

## Return

GATE=K6_VPS_PRODUCTION_DEPLOYMENT
RESULT=<PASS_CANDIDATE_K6_VPS_PRODUCTION_DEPLOYMENT | RETURN_REVIEWER_* | RETURN_OWNER_*>
SUMMARY=
SHARED_VPS_PREFLIGHT=
SSH_HOST_KEY=
HOSTNAME=
OS_KERNEL=
CPU_RAM_DISK=
DOCKER_VERSION=
COMPOSE_VERSION=
CURRENT_80_443_OWNER=
REVERSE_PROXY=
CLOUDFLARED_STATE=
EXISTING_PROJECTS_PROTECTED=
MINICRAFT_APP_PATH=
MINICRAFT_DATA_PATH=
MINICRAFT_BACKUP_PATH=
PATH_COLLISION=
PRODUCTION_WORDPRESS_IMAGE=
MARIADB_IMAGE=
REMOTE_COMPOSE=
WORDPRESS_CONTAINER=
MARIADB_CONTAINER=
DB_PUBLIC_PORT=
WORDPRESS_HOST_PORT=
RESTORE=
URL_MIGRATION=
PUBLIC_ORIGIN=
INGRESS=
DNS=
HTTPS=
PUBLIC_PRIMARY_ROUTES=
PUBLIC_CART_CHECKOUT=
PAYPAL_MODE=
PAYPAL_PUBLIC_ACTION_VISIBLE=
REAL_PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
TEST_PRODUCT_PUBLIC_SALE_ENABLED=NO
SEARCH_INDEXING_STATE=
UNRELATED_SERVICES_CHANGED=
ROLLBACK_READY=
DEPLOYMENT_MANIFEST=
WORKSPACE_TEMP_CLEANUP=
REMOTE_TEMP_CLEANUP=
EVIDENCE=
COMMIT=
OWNER_ACTION=<NONE | CONFIGURE_MINICRAFT_DNS | exact bounded action>
NEXT=STOP_AT_REVIEWER

Do not enter PayPal Live.
Do not execute a real payment.
Do not start Soft Launch.
