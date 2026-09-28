# K9B-R2 — Local Filesystem + Docker Decommission with Protected Recovery Exceptions

Status: AUTHORIZED_CONDITIONAL_LOCAL_CLEANUP
Date: 2026-09-28

Read first:
- current REVIEWER_HANDOFF.md
- docs/REVIEWER_DECISION_K9B_R1_RETURN_RECONCILED_R2_LOCAL_FILESYSTEM_DECOMMISSION.md
- docs/REVIEWER_DECISION_K9B_R2_DOCKER_ENABLED_AMENDMENT.md
- latest EXECUTION_EVIDENCE.md
- latest EXECUTOR_HANDOFF.md
- canonical Governance latest
- Target Host Reality Contract

## Goal

Finish local Mini Craft decommission in one Gate:
1. relocate protected rollback metadata;
2. delete 28 verified duplicate screenshots;
3. delete exact dedicated obsolete Mini Craft local filesystem paths;
4. decommission exact Mini Craft-only Docker resources;
5. retain protected recovery + shared Git exceptions;
6. leave VPS production unchanged.

## Phase A — host / production / Docker preflight

Prove:
```text
TARGET_WINDOWS_HOST_EXECUTION_PROVEN=PASS
PRODUCTION_PUBLIC_HEALTH=PASS
PRODUCTION_VPS_BACKUP_NAMESPACE_PRESENT=YES
DOCKER_DAEMON_AVAILABLE=YES
DOCKER_SERVER_VERSION=
DOCKER_CONTEXT=
```

Inventory exact Mini Craft Docker resources using labels/mounts/compose metadata, not names alone.

Known historical local runtime directories:
```text
mini-craft-k3r4-mariadb-recovery
mini-craft-k3r4-docker-mariadb
mini-craft-kadence-poc
mini-craft-night-kit
```

## Phase B — protected rollback relocation

Source:
`<shared project repo>\mini-craft-night-kit\.artifacts\k4-strict-storefront-cleanup\rollback-point.json`

Target:
`%LOCALAPPDATA%\MiniCraftNightKit\protected-recovery\k4-strict-storefront-cleanup\rollback-point.json`

Rules:
- source still 54,911 bytes;
- target absent;
- regular file / not reparse point;
- do not read/hash content;
- create restrictive Owner-local parent ACL without forced SetOwner;
- move exact file;
- verify source absent, target present, size unchanged.

Existing DPAPI recovery remains untouched.

## Phase C — remove 28 verified duplicate screenshots

Use exact 28 accepted K9B-R1 paths.

For each:
- exact path matches;
- byte size matches accepted evidence;
- GitHub canonical path still exists.

Delete exact file only.
Remove empty evidence-only descendants after files are gone.
Do not modify tracked files.

## Phase D — local Docker exact decommission

Inventory:
- containers;
- Compose project labels;
- working-dir labels;
- networks;
- named volumes;
- images;
- bind mounts.

For every candidate prove:
```text
RESOURCE_PROJECT_OWNERSHIP=MINICRAFT
RESOURCE_SHARED_REFERENCE_COUNT=0
RESOURCE_REQUIRED_BY_NON_MINICRAFT=NO
RESOURCE_CONTAINS_UNIQUE_CURRENT_BUSINESS_STATE=NO
RESOURCE_REQUIRED_FOR_PROTECTED_RECOVERY=NO
```

Use production VPS + validated backups/recovery as continuity boundary.

Deletion order:
1. stop exact obsolete Mini Craft containers;
2. remove exact containers;
3. remove exact Mini Craft-only networks;
4. remove exact Mini Craft-only named volumes only after no-unique-state proof;
5. remove exact Mini Craft-only custom images only if unreferenced.

Keep generic/shared WordPress/MariaDB images unless uniquely project-built.

Forbidden:
```text
docker system prune
docker system prune -a
docker container prune
docker image prune
docker image prune -a
docker volume prune
docker network prune
docker builder prune
```

No manual Docker/WSL internal-file deletion.

## Phase E — dedicated filesystem decommission

Freshly classify:

```text
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-docker-mariadb
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-kadence-poc
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit
C:\Users\34707\Documents\ChatGPT\VPS基建\_project-artifacts\mini-craft-night-kit
C:\Users\34707\Documents\ChatGPT\VPS基建\.tmp-cdp-test2
C:\Users\34707\Documents\ChatGPT\VPS基建\.tmp-k4-detail-browser-desktop
C:\Users\34707\Documents\ChatGPT\VPS基建\.tmp-k4-detail-browser-mobile
```

Do not delete `g4-5-owner-visual-review-runtime` by name.

For each candidate require:
```text
PROJECT_OWNERSHIP=MINICRAFT
SHARED_GIT_BOUNDARY=NO
REPARSE_POINT=NO
ACTIVE_PROCESS_REFERENCE_COUNT=0
SENSITIVE_KEEP_ITEM_COUNT=0
UNIQUE_CONTINUITY_FILE_COUNT=0
NO_REMAINING_DOCKER_BIND_OR_COMPOSE_WORKDIR_REFERENCE=YES
```

Only then exact recursive delete.

If browser temp remains active, keep as exact active-reference exception. Do not kill general browser.

## Shared Git boundary

Do not:
- delete `project-github-sync`;
- modify tracked Mini Craft files;
- reset/restore/checkout/clean/stash;
- set upstream;
- modify shared Git topology.

Allowed shared-worktree changes only:
- delete accepted 28 untracked screenshot duplicates;
- move accepted sensitive rollback JSON out of worktree.

## Post-cleanup read-back

Local:
```text
LOCAL_DEDICATED_MINICRAFT_WORKSPACES=ZERO_OR_EXACT_ACTIVE_EXCEPTION
LOCAL_UNTRACKED_MINICRAFT_GIT_ARTIFACTS=ZERO
LOCAL_MINICRAFT_DOCKER_CONTAINERS=0
LOCAL_MINICRAFT_DOCKER_NETWORKS=0
LOCAL_MINICRAFT_DOCKER_VOLUMES=0_OR_EXACT_RECOVERY_EXCEPTION
LOCAL_MINICRAFT_DOCKER_CUSTOM_IMAGES=0_OR_EXACT_SHARED_REFERENCE
LOCAL_PROTECTED_ROLLBACK_METADATA=RETAINED_PROTECTED_EXCEPTION
LOCAL_DPAPI_RECOVERY=RETAINED_PROTECTED_EXCEPTION
SHARED_GIT_WORKTREE=PROTECTED_SHARED_EXCEPTION
```

Production read-only:
```text
PUBLIC_ORIGIN_HEALTH=PASS
PRODUCT_223_PURCHASABLE=NO
PRODUCT_1224_STATE=HIDDEN_USD_1.00_CANARY
WOOCOMMERCE_STORE_CURRENCY=USD
VPS_MUTATIONS=0
REAL_PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
```

## Evidence minimum

```text
GATE=K9B_R2_LOCAL_FILESYSTEM_AND_DOCKER_DECOMMISSION_WITH_PROTECTED_RECOVERY_EXCEPTIONS
TARGET_WINDOWS_HOST_EXECUTION_PROVEN=
PRODUCTION_VPS_BACKUP_NAMESPACE_PRESENT=
DOCKER_DAEMON_AVAILABLE=
DOCKER_SERVER_VERSION=
ROLLBACK_METADATA_RELOCATED=
ROLLBACK_METADATA_CONTENT_READ=0
ROLLBACK_METADATA_HASH_ACTIONS=0
SCREENSHOT_DUPLICATE_DELETE_COUNT=
TRACKED_SHARED_GIT_FILE_MUTATIONS=0
MINICRAFT_DOCKER_CONTAINER_COUNT_BEFORE=
MINICRAFT_DOCKER_NETWORK_COUNT_BEFORE=
MINICRAFT_DOCKER_VOLUME_COUNT_BEFORE=
MINICRAFT_DOCKER_CUSTOM_IMAGE_COUNT_BEFORE=
MINICRAFT_DOCKER_CONTAINERS_REMOVED=
MINICRAFT_DOCKER_NETWORKS_REMOVED=
MINICRAFT_DOCKER_VOLUMES_REMOVED=
MINICRAFT_DOCKER_CUSTOM_IMAGES_REMOVED=
SHARED_DOCKER_IMAGES_REMOVED=0
NON_MINICRAFT_DOCKER_RESOURCES_TOUCHED=0
BROAD_PRUNE_USED=NO
DEDICATED_PATHS_DELETED=
DEDICATED_PATHS_RETAINED_WITH_REASON=
LOCAL_FILESYSTEM_DELETED_BYTES=
LOCAL_UNTRACKED_MINICRAFT_GIT_ARTIFACTS=
LOCAL_PROTECTED_ROLLBACK_METADATA=
LOCAL_DPAPI_RECOVERY=
PUBLIC_ORIGIN_HEALTH=
PRODUCT_223_PURCHASABLE=
PRODUCT_1224_STATE=
WOOCOMMERCE_STORE_CURRENCY=
VPS_MUTATIONS=0
REAL_PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
STOP_AT_REVIEWER=YES
```

## Success

```text
PASS_CANDIDATE_K9B_R2_LOCAL_FILESYSTEM_AND_DOCKER_DECOMMISSION_WITH_PROTECTED_RECOVERY_EXCEPTIONS
STOP_AT_REVIEWER=YES
```

Do not enter K9C automatically.
