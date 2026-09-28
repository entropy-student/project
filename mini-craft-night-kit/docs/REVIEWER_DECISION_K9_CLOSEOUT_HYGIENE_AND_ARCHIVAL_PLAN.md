# Reviewer Decision — K9 Closeout Hygiene and Archival Plan

Date: 2026-09-28
Role: Reviewer / Architect / Gatekeeper

## Owner instruction

Owner requests a final closeout phase covering:

1. VPS project-file cleanup;
2. local Windows project cleanup;
3. archive all appropriate reconstructible project material to GitHub;
4. preferably leave no ordinary Mini Craft project files on the local computer;
5. review Governance for reusable closeout improvements.

This is explicit Owner authorization to plan project-owned cleanup. It does not authorize deletion of unknown, shared, durable production, or Secret recovery material.

## Current project stage

```text
PROJECT_STAGE=PUBLIC_PLATFORM_OPERATIONAL_PRECOMMERCE
PUBLIC_PLATFORM_STATUS=ONLINE
REAL_COMMERCE_ENABLED=NO
PAYMENT_INFRASTRUCTURE=PASS_WITH_DEFERRED_FIRST_LIVE_TRANSACTION_CANARY
SOFT_LAUNCH_AUTHORIZED=NO
```

## K9 structure

Do not compress VPS and Owner-PC deletion into one execution Gate because they have different target-host and rollback domains.

```text
K9A=VPS_PROJECT_HYGIENE_CLOSEOUT
K9B=LOCAL_WORKSPACE_GITHUB_ARCHIVE_AND_DECOMMISSION
K9C=FINAL_CLOSEOUT_RECONCILIATION
```

Execution order:

```text
K9A PASS
  -> Reviewer
K9B PASS
  -> Reviewer
K9C documentation-only reconciliation
```

## K9A — VPS project hygiene

Goal: leave only canonical runtime/data/recovery material and remove project-owned disposable file residue.

Protected / KEEP:

```text
/srv/apps/mini-craft-night-kit canonical deployment files required to recreate current runtime
/srv/data/mini-craft-night-kit/mysql
/srv/data/mini-craft-night-kit/wp-content
/srv/data/mini-craft-night-kit/secrets
/srv/backups/mini-craft-night-kit required recovery points
current Compose runtime
current production containers/networks
Shared Infra
```

Cleanup candidates are only project-owned, provably disposable/reconstructible items such as:

- stale transfer packages;
- temporary extraction/staging directories;
- failed helper/temp scripts not referenced by current manifest;
- obsolete project-local generated diagnostic artifacts;
- duplicate reconstructible deployment bundles already canonical in GitHub/current app layer;
- disposable logs beyond explicit current evidence/retention need.

No broad Docker/image/volume/network prune.

Any backup deletion requires a separately justified retention decision; K9A default is KEEP backups.

## K9B — local Windows archive and decommission

Goal: remove ordinary Mini Craft local project/workspace/runtime residue after proving GitHub/production hold the canonical reconstructible state.

Archive barrier:

Before deleting local source/docs/artifacts, Executor must prove:

```text
GITHUB_CURRENT_PROJECT_TRUTH_READBACK=PASS
GITHUB_RECONSTRUCTIBLE_SOURCE_DOCS_COMPLETE=PASS_OR_EXACT_RETURN
UNPUSHED_GIT_COMMITS=0
UNTRACKED_UNIQUE_NONSECRET_PROJECT_FILES=0_AFTER_ARCHIVE
LOCAL_SECRET_OR_SENSITIVE_DB_NOT_UPLOADED_TO_GITHUB=YES
PRODUCTION_VPS_HEALTH=PASS
```

Allowed archive to GitHub:

- source;
- non-secret config templates;
- operational scripts;
- project docs;
- decisions/handoffs/evidence;
- small non-sensitive evidence/assets needed for continuity.

Forbidden GitHub archive:

- DB dumps;
- live DB files;
- `.env` or credential files;
- cookies/tokens/browser profiles;
- PPCP logs containing private material;
- DPAPI ciphertext/recovery artifacts;
- private keys;
- any Secret or Secret hash;
- sensitive customer/order data.

Local removal candidates after archive/read-back:

- canonical local Mini Craft workspace;
- old Mini Craft rollback/runtime folders;
- project-local disposable artifacts;
- Mini Craft browser profiles/temp folders;
- project-specific local Docker containers/networks/volumes **only if** proven to contain no unique production/business state and no longer referenced;
- local Git worktree/repo copies after fresh GitHub read-back / reconstruction proof.

No broad Docker prune and no unrelated workspace deletion.

## Important local-zero-files exception

The current Storage Manifest records an Owner-profile DPAPI Secret recovery artifact outside GitHub.

That artifact must **not** be committed to GitHub or deleted merely to achieve a cosmetic zero-file target.

Therefore:

```text
LOCAL_ORDINARY_PROJECT_FILES_TARGET=ZERO
LOCAL_SECURE_SECRET_RECOVERY_ARTIFACT=KEEP_UNLESS_SEPARATE_SECURE_RECOVERY_MIGRATION_IS_PROVEN
```

If the DPAPI recovery artifact is still the only validated off-VPS Secret recovery, it remains as the expected local exception.

A truly zero-local-file target requires a separate secure non-Git recovery destination and verified restore boundary.

## Retention boundary

Current VPS backups remain protected by Storage Manifest retention and business-recovery value.

K9 does not delete backups just because GitHub contains source/docs.

GitHub is not a substitute for:
- database backup;
- wp-content recovery;
- Secret recovery.

## Final target

After K9:

```text
VPS_PROJECT_NAMESPACE_HYGIENE=PASS
LOCAL_ORDINARY_PROJECT_FILES=ZERO_OR_EXACT_EXCEPTIONS
LOCAL_PROJECT_RUNTIME=DECOMMISSIONED
LOCAL_PROJECT_DOCKER_RESIDUE=ZERO_OR_EXACT_SHARED_REFERENCE
GITHUB_CANONICAL_ARCHIVE=PASS
SECURE_SECRET_RECOVERY=RETAINED_OUTSIDE_GITHUB
PRODUCTION_RUNTIME=UNCHANGED_HEALTHY
SOFT_LAUNCH_AUTHORIZED=NO
```

## Governance review

This project exposed a reusable gap: Governance has storage/decommission/cleanup rules but no single post-production workstation/archive closeout contract.

Reviewer will create a non-active CANDIDATE proposal in the canonical Governance repo. It does not change current v0.1.6 authority until validated and separately promoted.
