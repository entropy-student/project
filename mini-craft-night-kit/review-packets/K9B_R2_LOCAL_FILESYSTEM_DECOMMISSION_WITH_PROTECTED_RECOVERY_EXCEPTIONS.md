# K9B-R2 — Local Filesystem Decommission with Protected Recovery Exceptions

Status: AUTHORIZED_CONDITIONAL_LOCAL_CLEANUP
Date: 2026-09-28

Read first:
- current REVIEWER_HANDOFF.md
- docs/REVIEWER_DECISION_K9B_R1_RETURN_RECONCILED_R2_LOCAL_FILESYSTEM_DECOMMISSION.md
- latest EXECUTION_EVIDENCE.md
- latest EXECUTOR_HANDOFF.md
- canonical Governance latest
- Target Host Reality Contract

## Scope

This Gate may:
1. relocate the exact sensitive rollback JSON to protected Owner-local recovery;
2. remove the exact 28 verified duplicate screenshot files from the shared Git worktree;
3. delete exact dedicated Mini Craft local workspaces/runtime/archive/temp paths after fresh safety classification;
4. leave Docker cleanup deferred while daemon unavailable.

Do not modify tracked shared-Git files or shared Git metadata.

## Phase A — target host and production read-only preflight

Prove:
```text
TARGET_WINDOWS_HOST_EXECUTION_PROVEN=PASS
PRODUCTION_PUBLIC_HEALTH=PASS
PRODUCTION_VPS_BACKUP_NAMESPACE_PRESENT=YES
```

Do not read backup contents.

## Phase B — protected relocation of rollback metadata

Source:
`<shared project repo>\mini-craft-night-kit\.artifacts\k4-strict-storefront-cleanup\rollback-point.json`

Target:
`%LOCALAPPDATA%\MiniCraftNightKit\protected-recovery\k4-strict-storefront-cleanup\rollback-point.json`

Before move:
- source exists and remains exactly 54,911 bytes;
- target absent;
- source is regular file and not reparse point;
- do not open/read/hash its content.

Create target parent with restrictive Owner-local ACL.
Do not force SetOwner.
Prefer host-native ACL handling and fresh read-back.

Move exact file.
Verify:
```text
ROLLBACK_METADATA_SOURCE_EXISTS_AFTER=NO
ROLLBACK_METADATA_TARGET_EXISTS_AFTER=YES
ROLLBACK_METADATA_BYTES_AFTER=54911
ROLLBACK_METADATA_CONTENT_READ=0
ROLLBACK_METADATA_HASH_ACTIONS=0
```

If target exists unexpectedly, RETURN.

## Phase C — exact 28 screenshot duplicate cleanup

Use the exact 28 paths already enumerated in accepted K9B-R1 Evidence.

Before deleting each:
- exact local path matches prior path;
- byte size still matches accepted evidence;
- current GitHub exact path still exists.

Delete exact file only.
No wildcard recursive deletion based solely on directory name.

Afterwards remove only directories that become empty and are Mini Craft evidence-only descendants.

Do not modify tracked files.

## Phase D — dedicated local path inventory and conditional deletion

Known candidates:

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

For each existing candidate record:
- path;
- type;
- logical bytes;
- reparse-point status;
- active process reference count;
- whether inside/shared Git repo;
- sensitive keep item count;
- classification.

Delete only when all are true:
```text
PROJECT_OWNERSHIP=MINICRAFT
SHARED_GIT_BOUNDARY=NO
REPARSE_POINT=NO
ACTIVE_PROCESS_REFERENCE_COUNT=0
SENSITIVE_KEEP_ITEM_COUNT=0
UNIQUE_CONTINUITY_FILE_COUNT=0
CLASS in {
 LOCAL_RUNTIME_OBSOLETE_AFTER_VPS_CUTOVER,
 LOCAL_ROLLBACK_OBSOLETE_AFTER_VPS_CUTOVER,
 LOCAL_WORKSPACE_RECONSTRUCTIBLE_FROM_GITHUB,
 DUPLICATE_LOCAL_ARTIFACT_ARCHIVE,
 DISPOSABLE_BROWSER_TEMP_NO_PROCESS_REFERENCE
}
```

For SQL/DB/rollback files contained in a dedicated obsolete runtime:
- do not read content;
- deleting them is authorized only as part of deletion of the exact whole obsolete local project path;
- production backup namespace must already be proven present;
- if any file is the only known current recovery copy, RETURN.

Use exact path deletion; no shared-root wildcard.

## Explicit exclusions

Do not delete or mutate:
- `project-github-sync` itself;
- tracked Mini Craft files inside shared repo;
- shared root `.git`;
- unrelated projects;
- `g4-5-owner-visual-review-runtime` unless separately proven Mini Craft-owned in a future Gate;
- protected rollback metadata target;
- DPAPI recovery;
- Docker/WSL internal files.

## Browser temp exception

Freshly check process references.

If a temp/profile path is active:
`ACTIVE_BROWSER_REFERENCE_EXCEPTION`

Do not kill user's general browser.
Continue cleaning other independent paths.

## Docker

```text
LOCAL_DOCKER_CLEANUP=DEFERRED_DAEMON_UNAVAILABLE
LOCAL_DOCKER_RESOURCE_DELETIONS=0
```

Do not start Docker Desktop solely for this Gate.

## Post-cleanup production regression

Read-only verify:
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
GATE=K9B_R2_LOCAL_FILESYSTEM_DECOMMISSION_WITH_PROTECTED_RECOVERY_EXCEPTIONS
TARGET_WINDOWS_HOST_EXECUTION_PROVEN=
PRODUCTION_VPS_BACKUP_NAMESPACE_PRESENT=
ROLLBACK_METADATA_SOURCE=
ROLLBACK_METADATA_TARGET=
ROLLBACK_METADATA_RELOCATED=
ROLLBACK_METADATA_CONTENT_READ=0
ROLLBACK_METADATA_HASH_ACTIONS=0
SCREENSHOT_DUPLICATE_DELETE_COUNT=
TRACKED_SHARED_GIT_FILE_MUTATIONS=0
DEDICATED_PATH_CANDIDATE_COUNT=
DEDICATED_PATHS_DELETED=
DEDICATED_PATHS_RETAINED_WITH_REASON=
LOCAL_FILESYSTEM_DELETED_BYTES=
LOCAL_DEDICATED_MINICRAFT_WORKSPACES=
LOCAL_UNTRACKED_MINICRAFT_GIT_ARTIFACTS=
LOCAL_PROTECTED_ROLLBACK_METADATA=
LOCAL_DPAPI_RECOVERY=
LOCAL_DOCKER_CLEANUP=DEFERRED_DAEMON_UNAVAILABLE
LOCAL_DOCKER_RESOURCE_DELETIONS=0
SHARED_GIT_METADATA_MUTATION=0
BROAD_DELETE_OR_PRUNE_USED=NO
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
PASS_CANDIDATE_K9B_R2_LOCAL_FILESYSTEM_DECOMMISSION_WITH_PROTECTED_RECOVERY_EXCEPTIONS
STOP_AT_REVIEWER=YES
```

Precise returns:
- RETURN_K9B_R2_PROTECTED_RECOVERY_RELOCATION_FAILED
- RETURN_K9B_R2_UNIQUE_RECOVERY_DEPENDENCY
- RETURN_K9B_R2_ACTIVE_LOCAL_REFERENCE
- RETURN_K9B_R2_LOCAL_CLASSIFICATION_DRIFT
- RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE

Do not enter K9C automatically.
