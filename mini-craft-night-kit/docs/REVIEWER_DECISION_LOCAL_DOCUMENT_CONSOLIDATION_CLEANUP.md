# Reviewer Decision — Local Document Consolidation and Cleanup

Date: 2026-09-23
Status: AUTHORIZED
Owner instruction: pause K6 and clean/consolidate Mini Craft local project documents first.

## Superseding sequence

K6_VPS_PRODUCTION_DEPLOYMENT is PAUSED_BEFORE_EXECUTION.

Current Gate:
LOCAL_DOCUMENT_CONSOLIDATION_CLEANUP

After PASS, resume K6 from preflight; do not replay K5.

## Objective

Consolidate Mini Craft project-owned local documentation under the existing canonical workspace:

C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace\

The shared parent directory:
C:\Users\34707\Documents\ChatGPT\VPS基建\

must no longer accumulate scattered Mini Craft markdown/txt/zip/report files where they can safely be consolidated or removed.

This Gate is about documents and documentation artifacts, not moving the active runtime or Git repository.

## Protected paths / assets — MUST NOT DELETE OR MOVE

Do not move/delete:
- active runtime:
  C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery
- physical Git repository:
  C:\Users\34707\Documents\ChatGPT\VPS基建\project-github-sync\mini-craft-night-kit
- canonical workspace root itself
- current K5 deployment package and backups under workspace\artifacts\gates\k5-release-candidate-qa
- rollback SQL / wp-content / config backups required for K5/K6
- SSH identities / known_hosts
- .env / secret files / credentials
- Docker volumes / Compose runtime data
- unrelated projects/workspaces
- Shared VPS canonical documents not owned solely by Mini Craft
- files whose ownership or current-runtime dependency is uncertain

No broad recursive delete of VPS基建 root.

## Target local documentation structure

Under:
mini-craft-night-kit-workspace\docs\

Use:

docs\current\
- current local-only handoff/reference documents that are operationally useful and not already better represented by the Git repo

docs\deployment\
- deployment manifests/checklists/non-secret deployment notes

docs\archive\
- historical Mini Craft local documents still worth retaining for traceability

Existing:
artifacts\
- keep Gate outputs, backups, screenshots, ZIP deliverables, manifests and rollback artifacts in their current artifact hierarchy

The canonical workspace root should contain only:
- README / project-map / pointer files needed to enter the project
- docs\
- artifacts\
- existing safe pointers/links

Do not create extra top-level document clutter.

## Inventory scope

Inspect:
1. canonical workspace root recursively;
2. shared VPS基建 root, but only classify items confidently attributable to Mini Craft;
3. active runtime only for documentation-like files outside required runtime/artifact locations;
4. known Mini Craft temp/report folders.

For every candidate classify:

KEEP_CURRENT
MOVE_TO_DOCS_CURRENT
MOVE_TO_DOCS_DEPLOYMENT
MOVE_TO_DOCS_ARCHIVE
DELETE_DUPLICATE
DELETE_TEMPORARY
PROTECTED_OPERATIONAL
UNRELATED
UNCERTAIN_RETAIN

## Deletion policy

Owner explicitly authorized deletion of Mini Craft project-owned material that is clearly invalid, duplicate, superseded, or temporary.

Safe deletion candidates include, when proven:
- duplicate local copies of documents already canonically preserved in GitHub/current workspace;
- obsolete timestamped handoffs/reviewer packs;
- superseded execution prompts after their truth is captured;
- scratch markdown/txt reports;
- temporary diagnostic notes;
- duplicated visual-review ZIPs when one canonical retained copy + hashes/evidence exist;
- empty directories left by prior moves;
- temp browser/helper documentation artifacts no longer referenced.

Do NOT delete merely because a file is old.

If a document contains unique project truth not preserved elsewhere:
move to docs\archive rather than delete.

If uncertain:
UNCERTAIN_RETAIN.

## Duplicate proof

Before DELETE_DUPLICATE:
- compare content/hash or prove semantic duplicate with canonical source;
- record retained canonical path;
- if GitHub is the canonical retained copy, record the repository path/commit or current file path.

Do not delete the only local copy of secret-bearing config/backups just because documentation exists in GitHub.

## Root cleanup target

Desired result:
- no Mini Craft loose .md/.txt/.html/.zip/report documents scattered directly under VPS基建 root unless operationally required;
- canonical workspace root is tidy;
- historical docs live under docs\archive;
- current local docs under docs\current or docs\deployment;
- artifacts remain under artifacts\;
- active runtime and Git repo unchanged.

## Required deliverable

Create local non-sensitive:
mini-craft-night-kit-workspace\docs\current\LOCAL_DOCUMENT_INVENTORY.md

It must record:
- source path
- classification
- action
- destination/retained canonical path
- delete rationale
- whether unique
- whether runtime-dependent

Create GitHub-safe summary:
docs/LOCAL_DOCUMENT_CONSOLIDATION_SUMMARY.md

Do not include secrets or sensitive file contents.

## Safety / verification

Before any move/delete:
- prove ownership;
- prove not runtime-required;
- prove destination exists / create it;
- use move rather than copy when consolidation is intended;
- verify files at destination before removing source;
- no broad wildcard delete;
- no Docker prune;
- no active runtime restart;
- no VPS action;
- no K6 execution.

After:
- re-scan VPS基建 root for Mini Craft loose docs;
- re-scan workspace root;
- confirm active runtime path unchanged;
- confirm Git repo path unchanged;
- confirm K5 deployment package/backups hashes unchanged;
- confirm no protected secret/config file moved into GitHub-visible area.

## Return

GATE=LOCAL_DOCUMENT_CONSOLIDATION_CLEANUP
RESULT=<PASS_CANDIDATE_LOCAL_DOCUMENT_CONSOLIDATION_CLEANUP | RETURN_REVIEWER_*>
SUMMARY=
CANONICAL_WORKSPACE=
ROOT_MINICRAFT_DOCS_BEFORE=
ROOT_MINICRAFT_DOCS_AFTER=
MOVED_TO_DOCS_CURRENT=
MOVED_TO_DOCS_DEPLOYMENT=
MOVED_TO_DOCS_ARCHIVE=
DELETED_DUPLICATES=
DELETED_TEMPORARY=
EMPTY_DIRS_REMOVED=
UNCERTAIN_RETAINED=
ACTIVE_RUNTIME_UNCHANGED=
GIT_REPO_UNCHANGED=
K5_DEPLOYMENT_PACKAGE_UNCHANGED=
K5_BACKUP_HASHES_UNCHANGED=
SECRETS_MOVED_TO_GITHUB_VISIBLE_AREA=NO
UNRELATED_PROJECTS_TOUCHED=NO
VPS_ACTIONS=0
DOCKER_ACTIONS=0
INVENTORY=
EVIDENCE=
COMMIT=
OWNER_ACTION=NONE
NEXT=STOP_AT_REVIEWER

Do not resume K6 automatically.
