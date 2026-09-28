# K9B-R3R2 — Final Local Filesystem and Docker Volume Deletion

Status: AUTHORIZED_FINAL_PROJECT_LOCAL_DECOMMISSION
Date: 2026-09-29

Read first:
- current REVIEWER_HANDOFF.md
- docs/REVIEWER_DECISION_K9B_R3R1_PASS_R3R2_FINAL_LOCAL_DELETION.md
- latest EXECUTION_EVIDENCE.md
- latest EXECUTOR_HANDOFF.md
- canonical Governance latest
- Target Host Reality Contract

## Goal

Finish Mini Craft local decommission.

Do not touch VPS production state except read-only public validation.

## Protected keep

Do not delete:
- %LOCALAPPDATA%\MiniCraftNightKit\protected-recovery\...
- %LOCALAPPDATA%\MiniCraftNightKit\secret-recovery\...
- shared project-github-sync repository
- shared Git metadata
- shared Docker upstream images
- unrelated project resources

## Phase A — fresh local preflight

Prove:
```text
TARGET_WINDOWS_HOST_EXECUTION_PROVEN=PASS
CURRENT_GITHUB_MINICRAFT_READBACK=PASS
PROTECTED_ROLLBACK_METADATA_EXISTS=YES
PROTECTED_DPAPI_RECOVERY_EXISTS=YES
MINICRAFT_CONTAINERS_CURRENT=0
MINICRAFT_NETWORKS_CURRENT=0
MINICRAFT_CUSTOM_IMAGE_TAGS_CURRENT=0
```

## Phase B — delete 9 exact Docker volumes

Fresh check each exact volume:
- exists;
- current container reference count = 0;
- non-Mini-Craft reference count = 0.

Then delete exactly:

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

Use exact volume deletion only.

No prune.

After:
`LOCAL_MINICRAFT_DOCKER_VOLUMES=0`

## Phase C — delete exact dedicated local paths

Freshly inspect:

```text
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-docker-mariadb
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-kadence-poc
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit
C:\Users\34707\Documents\ChatGPT\VPS基建\_project-artifacts\mini-craft-night-kit
C:\Users\34707\Documents\ChatGPT\VPS基建\.tmp-cdp-test2
```

For each path require:
```text
PROJECT_OWNERSHIP=MINICRAFT
SHARED_GIT_BOUNDARY=NO
REPARSE_POINT=NO
PROTECTED_RECOVERY_ITEM_COUNT=0
CURRENT_DOCKER_REFERENCE_COUNT=0
UNIQUE_CURRENT_CONTINUITY_DEPENDENCY=NO
```

For normal dedicated directories also require:
`ACTIVE_PROCESS_REFERENCE_COUNT=0`

If satisfied, delete exact path recursively.

Do not inspect Secret content, DB contents, or old ZIP payloads before deletion.

A local .env inside an obsolete dedicated Mini Craft runtime is deleted with the directory without reading it.

## Browser temp

For `.tmp-cdp-test2`:

If current process references = 0:
- delete exact path.

If >0:
- keep as `ACTIVE_BROWSER_REFERENCE_EXCEPTION`;
- do not kill general browser;
- continue other cleanup.

## Shared Git

Do not mutate or delete:
- project-github-sync
- tracked Mini Craft files
- shared root .git

Do not use git reset/clean/restore/checkout/stash.

## Forbidden Docker commands

```text
docker system prune
docker container prune
docker image prune
docker volume prune
docker network prune
docker builder prune
```

Do not delete shared upstream images.

## Final local verification

```text
LOCAL_MINICRAFT_DOCKER_CONTAINERS=0
LOCAL_MINICRAFT_DOCKER_NETWORKS=0
LOCAL_MINICRAFT_DOCKER_VOLUMES=0
LOCAL_MINICRAFT_CUSTOM_IMAGES=0

LOCAL_DEDICATED_MINICRAFT_RUNTIME_PATHS=0
LOCAL_DEDICATED_MINICRAFT_ARTIFACT_PATHS=0
LOCAL_DISPOSABLE_MINICRAFT_TEMP_PATHS=0_OR_ACTIVE_BROWSER_EXCEPTION

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

Do not attempt Product 1224 write.

## Evidence minimum

```text
GATE=K9B_R3R2_FINAL_LOCAL_FILESYSTEM_AND_DOCKER_VOLUME_DELETION
TARGET_WINDOWS_HOST_EXECUTION_PROVEN=
CURRENT_GITHUB_MINICRAFT_READBACK=

DOCKER_VOLUMES_BEFORE=
DOCKER_VOLUME_NAMES_DELETED=
DOCKER_VOLUMES_AFTER=
BROAD_PRUNE_USED=NO
NON_MINICRAFT_DOCKER_RESOURCES_TOUCHED=0

DEDICATED_PATHS_BEFORE=
DEDICATED_PATHS_DELETED=
DEDICATED_PATHS_RETAINED_WITH_REASON=
LOCAL_FILESYSTEM_DELETED_BYTES=

LOCAL_MINICRAFT_DOCKER_CONTAINERS=
LOCAL_MINICRAFT_DOCKER_NETWORKS=
LOCAL_MINICRAFT_DOCKER_VOLUMES=
LOCAL_MINICRAFT_CUSTOM_IMAGES=
LOCAL_DEDICATED_MINICRAFT_RUNTIME_PATHS=
LOCAL_DEDICATED_MINICRAFT_ARTIFACT_PATHS=
LOCAL_DISPOSABLE_MINICRAFT_TEMP_PATHS=
LOCAL_UNTRACKED_MINICRAFT_GIT_ARTIFACTS=

LOCAL_PROTECTED_ROLLBACK_METADATA=
LOCAL_DPAPI_RECOVERY=
SHARED_GIT_CACHE_EXCEPTION=
SHARED_UPSTREAM_IMAGES=

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
PASS_CANDIDATE_K9B_R3R2_FINAL_LOCAL_FILESYSTEM_AND_DOCKER_VOLUME_DELETION
STOP_AT_REVIEWER=YES
```

If only .tmp-cdp-test2 remains because of an active browser process, success may include:
`LOCAL_CLOSEOUT_EXCEPTION=ACTIVE_BROWSER_REFERENCE_ONLY`

Do not enter K9C automatically.
