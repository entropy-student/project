# K9B-R3 — Final Local Filesystem and Docker Volume Decommission

Status: AUTHORIZED_CONDITIONAL_FINAL_LOCAL_CLEANUP
Date: 2026-09-29

Read first:
- current REVIEWER_HANDOFF.md
- docs/REVIEWER_DECISION_K9B_R2R2A_R3_RETURN_CONTAINMENT_SUPERSEDED_RESUME_K9B_R3.md
- latest EXECUTION_EVIDENCE.md
- latest EXECUTOR_HANDOFF.md
- canonical Governance latest
- Target Host Reality Contract

## Goal

Finish Mini Craft local closeout after production cutover.

Do not mutate Product 1224, Product 223, PayPal, orders, payments, refunds or VPS application state.

## Current known Docker state

```text
MINICRAFT_CONTAINERS_CURRENT=0
MINICRAFT_NETWORKS_CURRENT=0
MINICRAFT_CUSTOM_IMAGE_TAGS_CURRENT=0
MINICRAFT_VOLUMES_CURRENT=9
```

Exact retained volumes:

```text
mini-craft-k3r4-db-data
mini-craft-k3r4-wp-data
mini-craft-k3r4-mariadb-recovery_mini-craft-k3r4-recovery-db-data
mini-craft-k3r4-mariadb-recovery_mini-craft-k3r4-recovery-wp-content
mini-craft-k3r4-mariadb-recovery_mini-craft-k3r4-recovery-wp-data
mini-craft-kadence-poc_db_data
mini-craft-kadence-poc_uploads
mini-craft-kadence-poc_wp_core
mini-craft-night-kit_db_data
```

## Phase A — final recovery barrier

Before destructive local cleanup, prove:

```text
TARGET_WINDOWS_HOST_EXECUTION_PROVEN=PASS
PUBLIC_ORIGIN_HEALTH=PASS
PRODUCTION_VPS_BACKUP_NAMESPACE_PRESENT=YES
CURRENT_GITHUB_MINICRAFT_READBACK=PASS
PROTECTED_ROLLBACK_METADATA_EXISTS=YES
PROTECTED_DPAPI_RECOVERY_EXISTS=YES
MINICRAFT_CONTAINERS_CURRENT=0
MINICRAFT_NETWORKS_CURRENT=0
```

Do not read protected recovery contents or hashes.

Also confirm production backup namespace contains current recovery coverage for:
- database;
- wp-content;
- deployment/release metadata.

Metadata/path existence only; do not inspect secret values.

## Phase B — exact Docker volume classification

For each of the 9 exact volumes, record:
- exact name;
- current reference count;
- historical role;
- whether any current container references it;
- classification.

Expected historical classes:
- K3R4 control runtime;
- K3R4 recovery runtime;
- Kadence PoC;
- old local Mini Craft runtime.

A volume is deletion-authorized only when:

```text
CURRENT_CONTAINER_REFERENCE_COUNT=0
NON_MINICRAFT_REFERENCE_COUNT=0
CURRENT_PRODUCTION_DEPENDENCY=NO
ONLY_CURRENT_RECOVERY_COPY=NO
PRODUCTION_VPS_BACKUP_COVERAGE=YES
```

Do not inspect DB/uploads business contents merely for deletion.

If any exact volume may still be the only current recovery copy, retain it and RETURN that exact volume to Reviewer.

Otherwise remove the exact volume.

No prune.

## Phase C — dedicated filesystem candidates

Freshly classify these exact known candidates if present:

```text
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-docker-mariadb
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-kadence-poc
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit
C:\Users\34707\Documents\ChatGPT\VPS基建\_project-artifacts\mini-craft-night-kit
C:\Users\34707\Documents\ChatGPT\VPS基建\.tmp-cdp-test2
```

Do not delete:
- `project-github-sync`;
- shared root `.git`;
- protected LocalAppData recovery;
- unrelated projects;
- shared Docker images.

For each dedicated path require:

```text
PROJECT_OWNERSHIP=MINICRAFT
SHARED_GIT_BOUNDARY=NO
REPARSE_POINT=NO
ACTIVE_PROCESS_REFERENCE_COUNT=0
PROTECTED_RECOVERY_ITEM_COUNT=0
UNIQUE_CURRENT_CONTINUITY_DEPENDENCY=NO
CURRENT_DOCKER_REFERENCE_COUNT=0
```

Then classify as one of:

```text
LOCAL_RUNTIME_OBSOLETE_AFTER_VPS_CUTOVER
LOCAL_ROLLBACK_OBSOLETE_AFTER_VPS_CUTOVER
LOCAL_WORKSPACE_RECONSTRUCTIBLE_FROM_GITHUB
DUPLICATE_LOCAL_ARTIFACT_ARCHIVE
DISPOSABLE_BROWSER_TEMP_NO_ACTIVE_REFERENCE
KEEP_ONLY_CURRENT_RECOVERY_COPY
UNKNOWN
```

Delete only first five classes.

## .env rule

A directory containing a local `.env` is not automatically a keep item.

Do not read or upload the `.env`.

If the entire directory is an obsolete local runtime and current production Secrets + protected recovery are already proven, the directory may be deleted as a whole.

Do not emit Secret values or hashes.

## ZIP / manifest rule

For `_project-artifacts\mini-craft-night-kit`:

- inspect filenames, sizes and archive metadata only as needed;
- do not extract private DB/Secret payloads;
- if a non-sensitive manifest is unique and continuity-relevant, archive only the manifest to GitHub and fresh read-back;
- if ZIP contents are visual/evidence duplicates already represented on GitHub or obsolete rollback packages covered by current VPS recovery, delete them;
- if an archive may be the only current recovery copy, retain and RETURN.

## CDP/browser temp

For `.tmp-cdp-test2`:
- fresh process-reference check;
- if reference count = 0 and ownership is Mini Craft, delete exact path;
- if active, retain as `ACTIVE_BROWSER_REFERENCE_EXCEPTION`;
- do not kill the user's general browser.

## Docker deletion

Allowed only exact 9-volume names that satisfy Phase B.

Forbidden:

```text
docker system prune
docker container prune
docker image prune
docker volume prune
docker network prune
docker builder prune
```

Shared WordPress/MariaDB images remain.

## Final read-back

Expected:

```text
LOCAL_DEDICATED_MINICRAFT_RUNTIME_PATHS=0_OR_EXACT_RECOVERY_EXCEPTION
LOCAL_DISPOSABLE_MINICRAFT_TEMP_PATHS=0_OR_ACTIVE_BROWSER_EXCEPTION
LOCAL_MINICRAFT_DOCKER_CONTAINERS=0
LOCAL_MINICRAFT_DOCKER_NETWORKS=0
LOCAL_MINICRAFT_DOCKER_VOLUMES=0_OR_EXACT_RECOVERY_EXCEPTION
LOCAL_MINICRAFT_CUSTOM_IMAGES=0
LOCAL_UNTRACKED_MINICRAFT_GIT_ARTIFACTS=0
LOCAL_PROTECTED_ROLLBACK_METADATA=RETAINED
LOCAL_DPAPI_RECOVERY=RETAINED
SHARED_GIT_CACHE_EXCEPTION=RETAINED
SHARED_UPSTREAM_IMAGES=RETAINED
```

## Production regression

Read-only:
```text
PUBLIC_ORIGIN_HEALTH=PASS
PRODUCT_223_PURCHASABLE=NO
PRODUCT_1224_STATUS=Published
PRODUCT_1224_CATALOG_VISIBILITY=Hidden
PRODUCT_1224_PRICE_USD=1.00
WOOCOMMERCE_STORE_CURRENCY=USD
VPS_MUTATIONS=0
REAL_PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
```

Do not attempt Product 1224 status change.

## Evidence minimum

```text
GATE=K9B_R3_FINAL_LOCAL_FILESYSTEM_AND_DOCKER_VOLUME_DECOMMISSION
TARGET_WINDOWS_HOST_EXECUTION_PROVEN=
PRODUCTION_VPS_BACKUP_NAMESPACE_PRESENT=
CURRENT_GITHUB_MINICRAFT_READBACK=
PROTECTED_ROLLBACK_METADATA_EXISTS=
PROTECTED_DPAPI_RECOVERY_EXISTS=

MINICRAFT_DOCKER_VOLUMES_BEFORE=9
MINICRAFT_DOCKER_VOLUMES_DELETED=
MINICRAFT_DOCKER_VOLUMES_RETAINED=
MINICRAFT_DOCKER_VOLUMES_RETAINED_WITH_REASON=
BROAD_PRUNE_USED=NO
NON_MINICRAFT_DOCKER_RESOURCES_TOUCHED=0

DEDICATED_LOCAL_PATHS_BEFORE=
DEDICATED_LOCAL_PATHS_DELETED=
DEDICATED_LOCAL_PATHS_RETAINED_WITH_REASON=
LOCAL_FILESYSTEM_DELETED_BYTES=

LOCAL_DEDICATED_MINICRAFT_RUNTIME_PATHS=
LOCAL_DISPOSABLE_MINICRAFT_TEMP_PATHS=
LOCAL_UNTRACKED_MINICRAFT_GIT_ARTIFACTS=0
LOCAL_PROTECTED_ROLLBACK_METADATA=
LOCAL_DPAPI_RECOVERY=
SHARED_GIT_CACHE_EXCEPTION=

PUBLIC_ORIGIN_HEALTH=
PRODUCT_223_PURCHASABLE=
PRODUCT_1224_STATUS=
PRODUCT_1224_CATALOG_VISIBILITY=
PRODUCT_1224_PRICE_USD=
WOOCOMMERCE_STORE_CURRENCY=
VPS_MUTATIONS=0
REAL_PAYMENT_ACTIONS=0
REFUND_ACTIONS=0

STOP_AT_REVIEWER=YES
```

## Success

```text
PASS_CANDIDATE_K9B_R3_FINAL_LOCAL_FILESYSTEM_AND_DOCKER_VOLUME_DECOMMISSION
STOP_AT_REVIEWER=YES
```

If exact recovery dependency remains:

```text
RETURN_K9B_R3_ONLY_CURRENT_RECOVERY_COPY
STOP_AT_REVIEWER=YES
```

If ownership/classification remains unresolved:

```text
RETURN_K9B_R3_LOCAL_CLASSIFICATION_UNRESOLVED
STOP_AT_REVIEWER=YES
```

Do not enter K9C automatically.
