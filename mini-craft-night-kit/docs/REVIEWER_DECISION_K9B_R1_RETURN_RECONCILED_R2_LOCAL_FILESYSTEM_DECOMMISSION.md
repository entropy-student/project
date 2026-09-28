# Reviewer Decision — K9B-R1 RETURN Reconciled / K9B-R2 Local Filesystem Decommission

Date: 2026-09-28
Role: Reviewer / Architect / Gatekeeper

## Reviewed evidence

Accepted:

- Evidence commit: `9fc0a6dc057445addac2dc93ec13571dfa2b0d5b`
- Executor Handoff commit: `a69df6ec1ac73b2b7dd0db264f97f51652660b22`

## Reconciliation

```text
K9B_R1_RESULT=RETURN_K9B_R1_SENSITIVE_LOCAL_ONLY_DISCOVERED
LOCAL_FILESYSTEM_DELETIONS=0
LOCAL_DOCKER_DELETIONS=0
SHARED_GIT_SETTINGS_MUTATION=0
MINICRAFT_UNKNOWN_ITEMS=0
MINICRAFT_UNIQUE_NONSECRET_CONTINUITY_FILES=NONE
```

This RETURN is not an unresolved archive failure. The remaining sensitive artifact is now classified and can be retained as a protected local recovery exception outside the ordinary project workspace.

## Accepted classifications

```text
TRACKED_DIRTY_FILES=2
TRACKED_DIRTY_CLASS=STALE_LOCAL_COPY_SUPERSEDED_BY_GITHUB

UNTRACKED_SCREENSHOTS=28
SCREENSHOT_CLASS=DUPLICATE_EVIDENCE_ALREADY_ARCHIVED

ROLLBACK_METADATA=mini-craft-night-kit/.artifacts/k4-strict-storefront-cleanup/rollback-point.json
ROLLBACK_METADATA_CLASS=SENSITIVE_LOCAL_ONLY_KEEP

MINICRAFT_UNKNOWN_ITEMS=0
UNIQUE_NONSECRET_CONTINUITY_FILES=NONE
```

## Current Gate

```text
CURRENT_GATE=K9B_R2_LOCAL_FILESYSTEM_DECOMMISSION_WITH_PROTECTED_RECOVERY_EXCEPTIONS
CURRENT_GATE_STATUS=AUTHORIZED_CONDITIONAL_LOCAL_CLEANUP
```

Owner previously explicitly requested final local cleanup and GitHub archival, preferably leaving no ordinary project files locally. This Gate implements that request while preserving protected recovery material.

## Protected local recovery exception

The sensitive rollback metadata must not remain inside a Git worktree.

Move, without reading/hash/outputting its contents, from its current untracked project location to a protected Owner-local recovery enclave:

```text
%LOCALAPPDATA%\MiniCraftNightKit\protected-recovery\k4-strict-storefront-cleanup\rollback-point.json
```

Rules:

1. target must not already exist;
2. create only the exact protected parent directories required;
3. disable inherited write/read access not required for the Owner;
4. allow the current Owner account and SYSTEM only, unless host-native ACL reality requires a narrower equivalent;
5. move the exact file, do not copy-and-leave;
6. verify source absent, target exists, byte size unchanged;
7. do not read content, compute digest, or print protected values.

This artifact becomes:

`LOCAL_PROTECTED_ROLLBACK_METADATA=RETAINED_PROTECTED_EXCEPTION`

It is not part of `LOCAL_ORDINARY_MINI_CRAFT_PROJECT_FILES`.

Existing DPAPI Secret recovery remains separately protected and untouched.

## Shared Git worktree exception

Do not delete, reset, restore, checkout, clean, or otherwise mutate tracked Mini Craft files inside the shared `project-github-sync` merely to make the local machine cosmetically empty.

The two stale tracked files have no unique continuity value and may remain as:

`SHARED_GIT_WORKTREE_CACHE_EXCEPTION`

The 28 untracked screenshot duplicates may be deleted by exact verified path because GitHub blob equivalence has already been proven.

After removing the untracked screenshot duplicates and moving the sensitive rollback JSON out, do not alter the shared repository topology.

## Dedicated local project paths

Freshly inspect the following known dedicated Mini Craft paths, if present:

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

`g4-5-owner-visual-review-runtime` is NOT deletion-authorized by name. It was historically classified unrelated/active; leave it unless a separate future Gate proves it is Mini Craft-owned.

## Conditional deletion safety barrier

Before deleting any dedicated local project path, prove:

```text
TARGET_WINDOWS_HOST_EXECUTION_PROVEN=PASS
PRODUCTION_PUBLIC_HEALTH=PASS
PRODUCTION_VPS_BACKUP_NAMESPACE_PRESENT=YES
MINICRAFT_UNIQUE_NONSECRET_CONTINUITY_FILES=NONE
DEDICATED_PATH_NOT_GIT_SHARED_BOUNDARY=YES
DEDICATED_PATH_NOT_REPARSE_POINT=YES
DEDICATED_PATH_ACTIVE_PROCESS_REFERENCE=0
SENSITIVE_KEEP_ITEMS_WITHIN_DELETE_TARGET=0_AFTER_PROTECTED_RELOCATION
```

For local SQL/DB/rollback artifacts inside dedicated obsolete runtimes:
- content must not be read;
- they may be deleted as part of the exact obsolete local runtime path under the Owner's explicit cleanup request only after the production backup namespace is proven present;
- if any artifact is identified as the only known recovery copy for a still-current invariant, RETURN instead of deletion.

## Authorized dedicated path classes

After safety checks, exact paths may be classified and deleted as:

- `LOCAL_RUNTIME_OBSOLETE_AFTER_VPS_CUTOVER`
- `LOCAL_ROLLBACK_OBSOLETE_AFTER_VPS_CUTOVER`
- `LOCAL_WORKSPACE_RECONSTRUCTIBLE_FROM_GITHUB`
- `DUPLICATE_LOCAL_ARTIFACT_ARCHIVE`
- `DISPOSABLE_BROWSER_TEMP_NO_PROCESS_REFERENCE`

No wildcard deletion at the shared root.

## Browser temp rule

The prior evidence historically showed `.tmp-cdp-test2` was referenced by Edge. Freshly check again.

If any candidate profile has a current browser/process reference:
- do not kill the user's general browser;
- retain exact path as `ACTIVE_BROWSER_REFERENCE_EXCEPTION`;
- continue with other independently safe paths.

## Docker boundary

```text
LOCAL_DOCKER_DAEMON=UNAVAILABLE
LOCAL_DOCKER_CLEANUP=DEFERRED_DAEMON_UNAVAILABLE
```

Do not start Docker Desktop solely for cleanup.
Do not manually delete Docker/WSL internal storage.

Docker residue is a documented closeout exception until the daemon is later available and exact ownership can be proven.

## Final target for this Gate

```text
LOCAL_DEDICATED_MINICRAFT_WORKSPACES=ZERO_OR_EXACT_ACTIVE_EXCEPTION
LOCAL_UNTRACKED_MINICRAFT_GIT_ARTIFACTS=ZERO
LOCAL_PROTECTED_ROLLBACK_METADATA=RETAINED_PROTECTED_EXCEPTION
LOCAL_DPAPI_RECOVERY=RETAINED_PROTECTED_EXCEPTION
SHARED_GIT_WORKTREE=UNCHANGED_EXCEPT_REMOVAL_OF_VERIFIED_UNTRACKED_DUPLICATES_AND_SOURCE_MOVE
LOCAL_DOCKER_CLEANUP=DEFERRED_DAEMON_UNAVAILABLE
```

The project should not claim literal zero local bytes because protected recovery and shared Git cache are intentional exceptions.

## Production boundary

No VPS mutation, product mutation, PayPal change, order, payment or refund is authorized.

After cleanup, fresh read-only production health must pass.

## Success

```text
PASS_CANDIDATE_K9B_R2_LOCAL_FILESYSTEM_DECOMMISSION_WITH_PROTECTED_RECOVERY_EXCEPTIONS
STOP_AT_REVIEWER=YES
```

Do not enter K9C automatically.
