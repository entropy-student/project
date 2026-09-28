# K9A — VPS Project Hygiene Closeout

Status: AUTHORIZED_BOUNDED_PROJECT_LOCAL_CLEANUP
Date: 2026-09-28

Read first:

- current `REVIEWER_HANDOFF.md`
- `docs/REVIEWER_DECISION_K9_CLOSEOUT_HYGIENE_AND_ARCHIVAL_PLAN.md`
- `PROJECT_STORAGE_MANIFEST.md`
- latest accepted `EXECUTION_EVIDENCE.md`
- latest `EXECUTOR_HANDOFF.md`
- canonical Governance latest
- Storage Layout Contract
- Target Host Reality Contract

## Goal

Clean Mini Craft project-owned disposable file residue from the production VPS while preserving all active runtime, durable data, Secrets, required backups and Shared Infrastructure.

This Gate is **VPS only**. Do not clean the Owner Windows workstation in this Gate.

## Target host

Use the existing verified strict SSH connection and prove target identity before deletion.

Expected project namespaces:

```text
/srv/apps/mini-craft-night-kit
/srv/data/mini-craft-night-kit
/srv/backups/mini-craft-night-kit
```

Shared Infra is outside scope.

## Phase A — read-only inventory

Before any deletion, record:

1. target host identity / user / strict SSH trust result;
2. root filesystem used/free bytes;
3. exact recursive inventory for Mini Craft project namespaces, sufficient to classify paths without reading Secret values;
4. file/dir sizes;
5. current Compose/runtime references;
6. current active manifest/script references from `/srv/apps/mini-craft-night-kit`;
7. current backup inventory with timestamps/sizes;
8. current WordPress/MariaDB container state and restart counts.

Do not read contents of:
- Secret files;
- DB dumps;
- database files;
- provider logs containing sensitive payloads.

## Required classification

Classify each cleanup candidate as:

```text
ACTIVE_RECONSTRUCTIBLE
DURABLE
SECRET
BACKUP
DISPOSABLE
SHARED
UNKNOWN
```

Only `DISPOSABLE` may be deleted in this Gate.

Any `UNKNOWN` remains untouched and is returned to Reviewer.

## Mandatory KEEP

Do not delete or mutate:

```text
/srv/data/mini-craft-night-kit/mysql
/srv/data/mini-craft-night-kit/wp-content
/srv/data/mini-craft-night-kit/secrets
```

Keep all current required files under `/srv/apps/mini-craft-night-kit` that are referenced by the active Compose/runtime/redeploy path.

Keep all `/srv/backups/mini-craft-night-kit` recovery material by default in K9A, including the USD migration backup. Backup-retention deletion is NOT authorized in this Gate.

Keep:
- current production containers;
- current networks;
- current images;
- Shared Caddy/cloudflared/network resources;
- unrelated project files.

## Authorized deletion candidates

Delete only exact project-owned paths that fresh evidence proves are both unreferenced and disposable/reconstructible, for example:

- stale upload/transfer archives already unpacked and not canonical;
- project-local temporary extraction/staging directories;
- failed helper scripts or temp payload files that are not referenced by active deployment;
- obsolete project-local diagnostic scratch files;
- duplicate reconstructible deployment bundles when one canonical active copy remains;
- disposable project-local temp logs not required by current evidence or incident retention.

Names alone are insufficient. Reference and ownership checks are required.

## Docker boundary

Do NOT run:

```text
docker system prune
docker system prune -a
docker image prune -a
docker volume prune
docker network prune
docker builder prune
```

Do not remove any Docker volume/image/network/container in K9A.

This Gate is file hygiene only.

## Write procedure

For each delete candidate:

1. prove exact project ownership;
2. prove no active runtime/manifest reference;
3. record path + type + size only;
4. delete exact allowlisted path;
5. verify absence from target host;
6. continue.

No wildcard deletion outside an already-classified disposable subtree.

## Post-cleanup regression

Freshly verify:

```text
TARGET_HOST_IDENTITY=PASS
WORDPRESS_STATE=RUNNING
MARIADB_STATE=RUNNING_HEALTHY
WORDPRESS_RESTART_COUNT_UNCHANGED=YES
MARIADB_RESTART_COUNT_UNCHANGED=YES
PUBLIC_ORIGIN_HTTP=PASS
PRODUCT_223_NONPURCHASABLE=PASS
HIDDEN_CANARY_STATE_UNCHANGED=PASS
WOOCOMMERCE_CURRENCY_USD=PASS
PAYMENT_CONFIGURATION_MUTATION=0
SHARED_INFRA_MUTATION=0
```

Do not create a Cart/Checkout session unless needed for a non-mutating health check; payment flow is out of scope.

## Evidence minimum

```text
GATE=K9A_VPS_PROJECT_HYGIENE_CLOSEOUT
REMOTE_IDENTITY=
TARGET_HOST_EXECUTION_PROVEN=
ROOT_USED_BYTES_BEFORE=
ROOT_FREE_BYTES_BEFORE=
PROJECT_NAMESPACE_BYTES_BEFORE=
DELETE_CANDIDATE_COUNT=
DELETED_PATH_COUNT=
DELETED_BYTES=
UNKNOWN_PATH_COUNT=
UNKNOWN_PATHS_METADATA_ONLY=
BACKUP_DELETE_ACTIONS=0
DURABLE_DELETE_ACTIONS=0
SECRET_ACCESS_ACTIONS=0
DOCKER_PRUNE_ACTIONS=0
DOCKER_RESOURCE_DELETE_ACTIONS=0
SHARED_INFRA_WRITES=0
ROOT_USED_BYTES_AFTER=
ROOT_FREE_BYTES_AFTER=
PROJECT_NAMESPACE_BYTES_AFTER=
WORDPRESS_STATE=
MARIADB_STATE=
PUBLIC_ORIGIN_HEALTH=
PRODUCTION_REGRESSION=
STOP_AT_REVIEWER=YES
```

Evidence must list deleted path names and sizes, but never Secret values or DB content.

## Success

```text
PASS_CANDIDATE_K9A_VPS_PROJECT_HYGIENE_CLOSEOUT
STOP_AT_REVIEWER=YES
```

If any deletion target is ambiguous:

```text
RETURN_K9A_CLEANUP_CLASSIFICATION_UNRESOLVED
STOP_AT_REVIEWER=YES
```

Do not guess and do not proceed to local Windows cleanup.
