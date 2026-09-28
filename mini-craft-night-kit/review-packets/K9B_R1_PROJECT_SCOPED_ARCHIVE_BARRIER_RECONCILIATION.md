# K9B-R1 — Project-Scoped Archive Barrier Reconciliation

Status: AUTHORIZED_READONLY_CLASSIFICATION_AND_NONSECRET_ARCHIVE_ONLY
Date: 2026-09-28

Read first:
- current `REVIEWER_HANDOFF.md`
- `docs/REVIEWER_DECISION_K9B_RETURN_RECONCILED_R1_PROJECT_SCOPED_ARCHIVE_BARRIER.md`
- latest `EXECUTION_EVIDENCE.md`
- latest `EXECUTOR_HANDOFF.md`
- canonical Governance latest
- Target Host Reality Contract

## Purpose

Repair the archive barrier without mutating shared Git topology or deleting local files.

This Gate is Mini Craft subtree only.

## Current known state

```text
MINICRAFT_TRACKED_DIRTY=2
MINICRAFT_UNTRACKED=29
MINICRAFT_UNTRACKED_SCREENSHOTS_ALREADY_ON_GITHUB=28
MINICRAFT_UNKNOWN_ROLLBACK_METADATA=1
LOCAL_DOCKER_DAEMON=UNAVAILABLE
LOCAL_FILESYSTEM_DELETIONS=0
```

## Explicit non-blockers

Do NOT try to fix:

```text
shared root unborn Git repo
shared project-github-sync branch
shared repo no-upstream state
unrelated dirty/untracked files in shared repo
```

Do not set upstream, reset, checkout, clean or alter shared Git metadata.

## Phase A — exact Mini Craft file status

On the real Owner Windows host, collect exact paths for:

1. the 2 tracked dirty Mini Craft files;
2. all 29 untracked Mini Craft items;
3. the exact rollback metadata artifact.

Output filenames/relative paths and non-sensitive metadata only.

## Phase B — classify the 2 tracked dirty files

For each exact file:

- show bounded non-sensitive diff against current local tracked base;
- compare with current GitHub canonical Mini Craft file;
- classify:

```text
STALE_LOCAL_COPY_SUPERSEDED_BY_GITHUB
UNIQUE_NONSECRET_CONTINUITY_CHANGE
SENSITIVE_LOCAL_ONLY
UNKNOWN
```

If stale:
- preserve GitHub current truth;
- mark local file eligible for later deletion;
- do not push stale content.

If unique non-secret continuity change:
- archive only the needed change under `mini-craft-night-kit/`;
- commit/push through approved GitHub path;
- fresh read-back.

If sensitive or unknown:
- RETURN.

## Phase C — classify 28 screenshots

For each of the 28 screenshot paths:

- prove the corresponding evidence asset is already represented in GitHub, OR prove it is a disposable duplicate of an already archived review set;
- do not re-upload duplicates.

Classification:
`DUPLICATE_EVIDENCE_ALREADY_ARCHIVED`

If any screenshot is unique and continuity-relevant:
- archive only that item if non-sensitive and reasonably sized;
- otherwise RETURN with exact reason.

## Phase D — classify rollback metadata artifact

First record:
- exact path;
- filename;
- extension;
- bytes;
- timestamps;
- parent directory.

Only if it is clearly a regular text/JSON/manifest-like file and not a DB/Secret/recovery/provider-private artifact, read the minimum content needed for classification.

Do not print sensitive values.

Classify exactly one:

```text
UNIQUE_NONSECRET_ROLLBACK_METADATA_ARCHIVE_TO_GITHUB
OBSOLETE_LOCAL_ROLLBACK_METADATA_DISPOSABLE
SENSITIVE_LOCAL_ONLY_KEEP
UNKNOWN_RETURN
```

If archive-worthy:
- place a sanitized/non-secret canonical copy under the Mini Craft repo;
- GitHub commit;
- fresh read-back.

## Allowed Git/network checks

Read-only:
- `git status --porcelain -- <Mini Craft paths>`
- `git diff -- <Mini Craft paths>`
- `git ls-remote origin refs/heads/main`
- current GitHub API/raw reads of exact Mini Craft files

Do not require upstream.

## Docker

```text
LOCAL_DOCKER_CLEANUP=DEFERRED_DAEMON_UNAVAILABLE
```

Do not start Docker Desktop solely for this Gate.
Do not manually delete Docker internal storage.

## No deletion in R1

```text
LOCAL_FILESYSTEM_DELETE_PATH_COUNT=0
LOCAL_DOCKER_RESOURCE_DELETIONS=0
```

R1 only produces a safe deletion manifest.

## Required output

```text
GATE=K9B_R1_PROJECT_SCOPED_ARCHIVE_BARRIER_RECONCILIATION
TARGET_WINDOWS_HOST_EXECUTION_PROVEN=
MINICRAFT_TRACKED_DIRTY_PATHS=
MINICRAFT_TRACKED_DIRTY_CLASSIFICATIONS=
MINICRAFT_UNTRACKED_ITEM_COUNT=
MINICRAFT_SCREENSHOT_COUNT=
MINICRAFT_SCREENSHOT_ARCHIVE_STATUS=
ROLLBACK_METADATA_PATH=
ROLLBACK_METADATA_CLASSIFICATION=
MINICRAFT_UNIQUE_NONSECRET_CONTINUITY_FILES=
ARCHIVE_GITHUB_COMMITS=
GITHUB_MINICRAFT_CURRENT_TRUTH_READBACK=
MINICRAFT_SENSITIVE_ITEMS_ARCHIVED_TO_GITHUB=0
MINICRAFT_UNKNOWN_ITEMS=
LOCAL_DELETE_MANIFEST_READY=
LOCAL_DELETE_MANIFEST=
LOCAL_DOCKER_CLEANUP=DEFERRED_DAEMON_UNAVAILABLE
LOCAL_FILESYSTEM_DELETE_PATH_COUNT=0
STOP_AT_REVIEWER=YES
```

## Success

```text
PASS_CANDIDATE_K9B_R1_PROJECT_SCOPED_ARCHIVE_BARRIER_RECONCILIATION
MINICRAFT_UNKNOWN_ITEMS=0
LOCAL_DELETE_MANIFEST_READY=YES
STOP_AT_REVIEWER=YES
```

Precise returns:
- `RETURN_K9B_R1_SENSITIVE_LOCAL_ONLY_DISCOVERED`
- `RETURN_K9B_R1_UNKNOWN_LOCAL_ARTIFACT`
- `RETURN_K9B_R1_UNIQUE_UNARCHIVABLE_LOCAL_STATE`
- `RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE`
