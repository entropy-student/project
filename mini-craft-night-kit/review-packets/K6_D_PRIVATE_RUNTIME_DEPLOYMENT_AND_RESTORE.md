# K6 Phase D — Private Runtime Deployment & Restore Execution Pack

Gate:
`K6_PHASE_D_PRIVATE_RUNTIME_DEPLOYMENT_AND_RESTORE`

Authority:
- canonical `entropy-student/spike.skill/vps-project-governance` latest;
- current `REVIEWER_HANDOFF.md`;
- current `PROJECT_STORAGE_MANIFEST.md`;
- `docs/REVIEWER_DECISION_K6_C1R5R2_PASS_K6_D_PRIVATE_DEPLOYMENT.md`;
- accepted K5 release candidate/package;
- latest accepted K6 package/evidence;
- unique current Shared VPS Handoff.

## Objective

Deploy and restore the accepted Mini Craft WordPress + MariaDB runtime privately on the verified VPS, prove internal health and rollback readiness, and stop before any Shared Ingress/public route change.

## Mandatory preflight

1. Read all authority sources completely.
2. Verify strict SSH identity/host pin and target `ops@srv1970241`.
3. Freshly recheck:
   - CPU/RAM/root/data free space;
   - Docker/Compose;
   - current containers/networks/ports;
   - Shared Caddy/cloudflared status and 80/443 ownership read-only;
   - existing Mini Craft app/data/backup paths;
   - existing `spikersun-edge` network identity;
   - exact 10 Secret metadata only.
4. Re-verify accepted K5 SQL/wp-content package hashes and canonical production Compose/manifest identity.
5. Render explicit canonical Compose with `-f` before mutation.
6. Stop on material drift, path collision of unknown provenance, capacity failure, Secret metadata mismatch, package/hash mismatch, or shared-network drift.

## Allowed remote writes

Only project-scoped Mini Craft writes:

- `/srv/apps/mini-craft-night-kit`
- `/srv/data/mini-craft-night-kit/mysql`
- `/srv/data/mini-craft-night-kit/wp-content`
- existing `/srv/data/mini-craft-night-kit/secrets` may be mounted/read by the application only as designed; do not alter it
- `/srv/backups/mini-craft-night-kit`
- project-scoped Compose containers/network
- WordPress membership in the existing `spikersun-edge` network only; do not alter/recreate the shared network

Transfer/restore only the accepted K5 RC artifacts and canonical deployment files.

## Deployment controls

- explicit canonical Compose file;
- `wordpress:7.1.1-php8.3-apache`;
- `mariadb:11.4.7`;
- no build;
- no unreviewed image pull/update;
- no host ports;
- MariaDB only on project-private internal DB network;
- WordPress may join existing `spikersun-edge`;
- no privileged containers;
- project log rotation per sealed manifest;
- Secret binds read-only.

If an accepted image is absent and a pull would be required, RETURN Reviewer instead of silently pulling unless the current sealed package explicitly authorizes that exact immutable acquisition path.

## Restore

1. Preserve/record project-scoped pre-change recovery artifacts.
2. Restore accepted MariaDB logical dump using the database-native path.
3. Restore accepted wp-content.
4. Perform serialized-data-safe URL migration:
   `http://localhost:8093` → `https://minicraft.spikersun.com`.
5. Do not use blind raw SQL string replacement on serialized WordPress data.
6. Keep PayPal in Sandbox.
7. Do not perform any Provider/buyer action.

## Internal validation

After starting only Mini Craft services, prove:

- exact running images;
- MariaDB healthy and no public port;
- WordPress healthy and no host port;
- project-private DB network only for MariaDB;
- WordPress edge-network membership does not alter that network;
- DB basic integrity/readback;
- home/siteurl target values;
- wp-content/media present;
- primary WordPress routes respond through a private/internal path;
- WooCommerce core/product/cart/checkout state loads internally where practical;
- PayPal mode remains Sandbox and Live disabled, without creating/capturing any payment;
- restart/recreate behavior consistent with the sealed manifest;
- unrelated services remain unchanged;
- root/data/RAM resource delta recorded.

## Public boundary

This Gate does **not** make Mini Craft public.

Do not:
- edit/reload Caddy;
- edit cloudflared/Tunnel;
- change DNS;
- expose host ports;
- modify UFW/SSH/Docker daemon;
- enable a public route.

Perform a bounded negative check sufficient to show no Mini Craft public ingress was introduced by this Gate.

## Rollback

Prepare and evidence a rollback capable of:

- stopping/removing only Mini Craft containers/project-private network;
- leaving Shared Infra and unrelated apps unchanged;
- preserving the verified Secret tree and recovery artifacts;
- preserving restored project data/backups for investigation unless a later explicit cleanup Gate authorizes removal.

Do not broad prune.

## Evidence

Append redacted facts to:
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Create/update a non-secret deployment manifest if required by the accepted project plan.

Required result markers:

```text
FRESH_SHARED_VPS_PREFLIGHT=
TARGET_HOST_IDENTITY=
RESOURCE_HEADROOM=
SECRET_STATE_PREDEPLOY_READBACK=
CANONICAL_COMPOSE_RENDER=
APPS_PATH=
DATA_MYSQL_PATH=
DATA_WP_CONTENT_PATH=
BACKUP_PATH=
ACCEPTED_K5_SQL_TRANSFER=
ACCEPTED_K5_WP_CONTENT_TRANSFER=
MARIADB_RESTORE=
WP_CONTENT_RESTORE=
URL_MIGRATION=
WORDPRESS_IMAGE=
MARIADB_IMAGE=
DB_PUBLIC_PORT=
WORDPRESS_HOST_PORT=
MARIADB_HEALTH=
WORDPRESS_HEALTH=
WORDPRESS_INTERNAL_PRIMARY_ROUTES=
WOOCOMMERCE_CORE_STATE=
PAYPAL_MODE=
PAYPAL_LIVE=NO
PUBLIC_INGRESS_CHANGE=0
PUBLIC_ROUTE_ENABLED=NO
UNRELATED_SERVICES_CHANGED=
ROLLBACK_READY=
RESOURCE_DELTA_RECORDED=
REMOTE_TEMP_CLEANUP=
SECRET_VALUE_OR_HASH_ACCESS=0
STOP_AT_REVIEWER=YES
```

Success:
`PASS_CANDIDATE_K6_PHASE_D_PRIVATE_RUNTIME_DEPLOYMENT_AND_RESTORE`

Otherwise return a precise `RETURN_*` and stop.

Do not enter Shared Ingress/public HTTPS after this Gate.
