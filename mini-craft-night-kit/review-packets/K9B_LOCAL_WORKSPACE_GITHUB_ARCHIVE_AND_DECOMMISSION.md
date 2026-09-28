# K9B — Local Workspace GitHub Archive and Decommission

Status: AUTHORIZED_CONDITIONAL_LOCAL_DECOMMISSION
Date: 2026-09-28

Read first:
- current `REVIEWER_HANDOFF.md`
- `docs/REVIEWER_DECISION_K9A_PASS_AND_K9B_LOCAL_DECOMMISSION.md`
- `docs/REVIEWER_DECISION_PROJECT_DIRECTORY_CONSOLIDATION.md`
- `docs/REVIEWER_DECISION_PROJECT_DIRECTORY_CONSOLIDATION_OWNER_CLEANUP.md`
- `docs/LOCAL_DOCUMENT_CONSOLIDATION_SUMMARY.md`
- latest `EXECUTION_EVIDENCE.md`
- latest `EXECUTOR_HANDOFF.md`
- canonical Governance latest
- Target Host Reality Contract

## Goal

Archive any remaining unique, non-secret, continuity-relevant Mini Craft local material to GitHub, then decommission ordinary Mini Craft local workspaces/runtime as far as safely possible.

Target:
`LOCAL_ORDINARY_MINI_CRAFT_PROJECT_FILES=ZERO`

Protected exception:
`LOCAL_SECURE_SECRET_RECOVERY=KEEP`

## Phase A — local read-only inventory + archive barrier

First prove the real Owner Windows host.

Record:
- machine identity;
- current user;
- PowerShell version;
- target root existence;
- local Docker availability/version if present.

Inspect the known Mini Craft candidate paths from the Reviewer decision plus any newly discovered Mini Craft-specific sibling/root temp paths.

For each path record:
- exists / absent;
- file or directory;
- logical/allocated size when practical;
- Git boundary;
- active process/container reference;
- classification.

Classification:
```text
GIT_ARCHIVABLE_RECONSTRUCTIBLE
DISPOSABLE
LOCAL_RUNTIME_REBUILDABLE
LOCAL_ROLLBACK_OBSOLETE
SECURE_RECOVERY_KEEP
SHARED
UNKNOWN
```

Do not read Secret values or database contents.

## GitHub archive barrier

For every local Git worktree/repo touching Mini Craft:

- prove repository root;
- branch/status;
- unpushed commits count;
- staged/unstaged tracked changes;
- untracked files;
- remote origin;
- relationship to the shared `entropy-student/project` repo.

If any unique non-secret continuity-relevant file exists only locally and is suitable for Git:
1. place it under the existing `mini-craft-night-kit/` project tree;
2. commit/push through the existing GitHub workflow;
3. fresh GitHub read-back;
4. only then treat the local copy as removable.

Do not archive caches, browser profiles, local Docker DB volumes, DB dumps, screenshots already in GitHub, duplicate ZIPs, or other disposable payloads merely for completeness.

Required barrier:
```text
GITHUB_MAIN_CURRENT_READBACK=PASS
LOCAL_UNPUSHED_COMMITS=0
LOCAL_UNTRACKED_UNIQUE_NONSECRET_FILES=0_AFTER_ARCHIVE
LOCAL_SENSITIVE_FILES_ARCHIVED_TO_GITHUB=0
```

If this barrier fails: RETURN before local deletion.

## Sensitive exclusions

Never upload or expose:
- DB dumps/live DB;
- `.env`;
- passwords/tokens/cookies;
- private keys;
- browser profiles;
- Secret values or hashes;
- DPAPI recovery files;
- private provider logs;
- customer/order private data.

Do not hash Secret material merely for Evidence.

## Phase B — exact local decommission

Only after Phase A PASS.

### Filesystem

Delete exact paths classified as:
- GIT_ARCHIVABLE_RECONSTRUCTIBLE after successful archive/read-back;
- DISPOSABLE;
- LOCAL_RUNTIME_REBUILDABLE;
- LOCAL_ROLLBACK_OBSOLETE.

Do not delete:
- SECURE_RECOVERY_KEEP;
- SHARED;
- UNKNOWN;
- enclosing shared Git repo/root;
- unrelated projects.

For every deleted path:
- record exact path + category + size;
- remove exact path;
- verify absence.

Avoid broad wildcard deletion at shared root.

### Local processes / browser profiles

If a Mini Craft temp/browser profile is still referenced by a running browser process:
- do not kill the user's general browser merely to clean it;
- classify as `RETURN_K9B_ACTIVE_LOCAL_REFERENCE` unless the exact project process can be safely closed without touching unrelated sessions.

### Local Docker

Inventory exact Mini Craft containers/networks/volumes/images.

May remove exact Mini Craft-only:
- containers;
- networks;
- named volumes

only when all are proven obsolete and contain no unique retained state.

Images may be removed only if uniquely Mini Craft-owned; shared upstream images remain.

Forbidden:
```text
docker system prune
docker system prune -a
docker image prune -a
docker volume prune
docker network prune
docker builder prune
```

## Production protection

K9B must not mutate VPS production.

After local cleanup perform read-only production check:
- public origin TLS/HTTP healthy;
- Product 223 remains non-purchasable;
- Product 1224 remains hidden Canary;
- WooCommerce remains USD.

No order/payment/refund.

## Required final inventory

Return all remaining Mini Craft-related local items.

Desired:
```text
LOCAL_ORDINARY_MINI_CRAFT_PROJECT_FILES=ZERO
LOCAL_MINI_CRAFT_RUNTIME=DECOMMISSIONED
LOCAL_MINI_CRAFT_DOCKER_CONTAINERS=0
LOCAL_MINI_CRAFT_DOCKER_NETWORKS=0
LOCAL_MINI_CRAFT_DOCKER_VOLUMES=0
LOCAL_SECURE_RECOVERY=RETAINED_PROTECTED_EXCEPTION
```

If a shared/secure/active exception remains, name the path/resource and exact reason.

## Evidence minimum

```text
GATE=K9B_LOCAL_WORKSPACE_GITHUB_ARCHIVE_AND_DECOMMISSION
TARGET_WINDOWS_HOST_EXECUTION_PROVEN=
LOCAL_ROOT=
KNOWN_CANDIDATE_COUNT=
DISCOVERED_ADDITIONAL_CANDIDATE_COUNT=
GIT_REPOSITORY_BOUNDARY_PROVEN=
GITHUB_MAIN_CURRENT_READBACK=
LOCAL_UNPUSHED_COMMITS=
LOCAL_TRACKED_DIRTY_FILES_BEFORE=
LOCAL_UNTRACKED_FILES_BEFORE=
UNIQUE_NONSECRET_FILES_ARCHIVED_COUNT=
ARCHIVE_GITHUB_COMMITS=
LOCAL_SENSITIVE_FILES_ARCHIVED_TO_GITHUB=0
LOCAL_FILESYSTEM_DELETE_PATH_COUNT=
LOCAL_FILESYSTEM_DELETED_BYTES=
LOCAL_DOCKER_CONTAINERS_REMOVED=
LOCAL_DOCKER_NETWORKS_REMOVED=
LOCAL_DOCKER_VOLUMES_REMOVED=
LOCAL_DOCKER_IMAGES_REMOVED=
BROAD_PRUNE_USED=NO
LOCAL_ORDINARY_MINI_CRAFT_PROJECT_FILES=
LOCAL_SECURE_RECOVERY=
LOCAL_REMAINING_EXCEPTIONS=
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
PASS_CANDIDATE_K9B_LOCAL_WORKSPACE_GITHUB_ARCHIVE_AND_DECOMMISSION
STOP_AT_REVIEWER=YES
```

Precise returns:
- `RETURN_K9B_GITHUB_ARCHIVE_BARRIER_FAILED`
- `RETURN_K9B_UNKNOWN_LOCAL_STATE`
- `RETURN_K9B_ACTIVE_LOCAL_REFERENCE`
- `RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE`

Do not enter K9C automatically.
