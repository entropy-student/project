# Reviewer Decision — K9A PASS / K9B Local Archive and Decommission

Date: 2026-09-28
Role: Reviewer / Architect / Gatekeeper

## Reviewed K9A-R1 evidence

Accepted:

- Evidence commit: `53b33668db914e78278acba1a70d25fbb8117431`
- Executor Handoff commit: `cf88c16da985135da19c035c3359647cddb22737`

## Formal K9A decision

```text
K9A_R1_EXACT_EMPTY_TMP_CLEANUP_AND_REGRESSION=PASS
K9A_VPS_PROJECT_HYGIENE_CLOSEOUT=PASS

AUTHORIZED_DELETE_TARGET=/srv/apps/mini-craft-night-kit/.tmp
DELETED_PATH_COUNT=1
TARGET_PATH_EXISTS_AFTER=NO

WORDPRESS_STATE=RUNNING
MARIADB_STATE=RUNNING_HEALTHY
RESTART_COUNTS_UNCHANGED=YES
PUBLIC_ORIGIN_HEALTH=PASS
PRODUCT_223_PURCHASABLE=NO
PRODUCT_1224_STATE=HIDDEN_USD_1.00_CANARY
WOOCOMMERCE_STORE_CURRENCY=USD

OTHER_DELETE_ACTIONS=0
BACKUP_DELETE_ACTIONS=0
DURABLE_DELETE_ACTIONS=0
SECRET_ACCESS_ACTIONS=0
DOCKER_RESOURCE_DELETE_ACTIONS=0
SHARED_INFRA_WRITES=0
```

The Store API post-delete checker initially assumed a different price encoding. Fresh read-only reconciliation established no product or currency drift. This does not reopen K9A.

## Open K9B

```text
CURRENT_GATE=K9B_LOCAL_WORKSPACE_GITHUB_ARCHIVE_AND_DECOMMISSION
CURRENT_GATE_STATUS=AUTHORIZED_CONDITIONAL_LOCAL_DECOMMISSION
OWNER_LOCAL_ORDINARY_PROJECT_FILES_TARGET=ZERO
LOCAL_SECURE_SECRET_RECOVERY_ARTIFACT=KEEP_UNLESS_SEPARATE_SECURE_RECOVERY_MIGRATION
SOFT_LAUNCH_AUTHORIZED=NO
```

Owner has already explicitly requested local cleanup and GitHub archival.

## Safety model

K9B must use a two-phase conditional sequence in one Gate:

```text
PHASE_A=READ_ONLY_LOCAL_INVENTORY_AND_GITHUB_ARCHIVE_BARRIER
IF_AND_ONLY_IF_PHASE_A_PASS
  -> PHASE_B=EXACT_PROJECT_LOCAL_DECOMMISSION
ELSE
  -> RETURN
```

No deletion is authorized until Phase A proves archive safety.

## Known historical local Mini Craft locations

These are candidates for fresh discovery/classification, not unconditional delete targets:

```text
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-docker-mariadb
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-kadence-poc
C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit
C:\Users\34707\Documents\ChatGPT\VPS基建\g4-5-owner-visual-review-runtime
C:\Users\34707\Documents\ChatGPT\VPS基建\_project-artifacts\mini-craft-night-kit
C:\Users\34707\Documents\ChatGPT\VPS基建\.tmp-cdp-test2
C:\Users\34707\Documents\ChatGPT\VPS基建\.tmp-k4-detail-browser-desktop
C:\Users\34707\Documents\ChatGPT\VPS基建\.tmp-k4-detail-browser-mobile
```

The shared Git worktree / repo boundary around `project-github-sync` must be freshly proven before any deletion. Do not delete an enclosing shared repository.

## Phase A archive barrier

Before deleting ordinary local project files, prove:

```text
TARGET_WINDOWS_HOST_EXECUTION_PROVEN=PASS
PROJECT_LOCAL_PATH_INVENTORY=COMPLETE_FOR_KNOWN_AND_DISCOVERED_MINI_CRAFT_PATHS
GIT_REPOSITORY_BOUNDARY_PROVEN=PASS
GITHUB_MAIN_CURRENT_READBACK=PASS
LOCAL_UNPUSHED_COMMITS=0
LOCAL_UNTRACKED_UNIQUE_NONSECRET_FILES=0_AFTER_ALLOWED_ARCHIVE
LOCAL_UNIQUE_NONSECRET_ARTIFACTS_ARCHIVED_TO_GITHUB=YES_OR_NONE
LOCAL_SENSITIVE_FILES_ARCHIVED_TO_GITHUB=0
PRODUCTION_VPS_PUBLIC_HEALTH=PASS
```

Any local file that is:
- unique;
- non-secret;
- still required for future project continuity;
- appropriate for Git

may be archived to the existing Mini Craft project repository before deletion.

Do not push large disposable caches/debug/browser data merely to justify deletion.

## Sensitive/local-only exclusions

Never upload to GitHub:

- MariaDB/SQLite dump or live DB;
- `.env`;
- credential files;
- private keys;
- cookies/tokens;
- browser profiles;
- PayPal/PPCP logs containing private payloads;
- customer/order private data;
- DPAPI encrypted recovery artifacts;
- Secret values or hashes.

Known DPAPI recovery material is a protected local exception and must remain outside GitHub unless a separate secure recovery migration Gate exists.

## Local runtime/data classification

Every discovered local Mini Craft object must be classified:

```text
GIT_ARCHIVABLE_RECONSTRUCTIBLE
DISPOSABLE
LOCAL_RUNTIME_REBUILDABLE
LOCAL_ROLLBACK_OBSOLETE
SECURE_RECOVERY_KEEP
SHARED
UNKNOWN
```

Only the first four categories may be removed after archive barrier PASS.

`SECURE_RECOVERY_KEEP`, `SHARED`, and `UNKNOWN` remain.

## Local Docker decommission

Local Docker cleanup is allowed only for exact Mini Craft project-owned resources after proving:

- no unique data exists only in that local Docker state;
- production VPS is the current canonical runtime;
- local rollback is no longer required because GitHub + validated VPS backups/restore material cover continuity;
- exact container/network/volume ownership is proven;
- no other project references the resource.

Do not delete shared Docker images merely because Mini Craft used them.

Allowed exact resource types if proven Mini-Craft-only and obsolete:
- stopped/running local Mini Craft containers;
- Mini Craft-only local networks;
- Mini Craft-only local named volumes containing no unique retained state.

No broad prune commands are authorized.

## Filesystem deletion

After Phase A PASS, delete only exact classified Mini Craft local filesystem paths.

Do not delete:
- shared `VPS基建` root;
- `project-github-sync` enclosing shared repo unless it is proven wholly Mini Craft-only;
- unrelated projects;
- shared handoffs;
- secure Secret recovery;
- UNKNOWN items.

For each deletion, record path + category + approximate allocated/logical bytes before deletion, then verify absence.

## Final local target

```text
LOCAL_ORDINARY_MINI_CRAFT_PROJECT_FILES=ZERO
LOCAL_MINI_CRAFT_RUNTIME=DECOMMISSIONED
LOCAL_MINI_CRAFT_DOCKER_RESIDUE=ZERO_OR_EXACT_SHARED_EXCEPTION
LOCAL_SECURE_RECOVERY=RETAINED_PROTECTED_EXCEPTION
GITHUB_CANONICAL_PROJECT_ARCHIVE=PASS
PRODUCTION_VPS_UNCHANGED_HEALTHY=PASS
```

If ordinary local files cannot reach zero, return exact remaining path(s) and reason.

## Success

```text
PASS_CANDIDATE_K9B_LOCAL_WORKSPACE_GITHUB_ARCHIVE_AND_DECOMMISSION
STOP_AT_REVIEWER=YES
```

Do not enter K9C automatically.
