# Mini Craft Night Kit — PROJECT STORAGE MANIFEST

Status: PRE-DEPLOYMENT FROZEN PLAN / REMOTE READBACK PENDING
Governance: canonical `entropy-student/spike.skill/vps-project-governance` latest
Current Gate: `K6R1_GOVERNANCE_ALIGNED_SSH_RECOVERY`

This manifest records deployment/storage truth only. It contains no Secret values.
It does not authorize a VPS write.

## 1. Project namespace

```text
PROJECT=mini-craft-night-kit
COMPOSE_PROJECT=mini-craft-night-kit
APPS_PATH=/srv/apps/mini-craft-night-kit
DATA_PATH=/srv/data/mini-craft-night-kit
BACKUP_PATH=/srv/backups/mini-craft-night-kit
```

One project owns exactly these project namespaces. Shared infrastructure remains outside them.

## 2. Reconstructible application layer

`/srv/apps/mini-craft-night-kit` may contain only reconstructible deployment material such as:

- production Compose manifest;
- non-secret configuration templates;
- deployment/restore helper scripts;
- version/release metadata.

It must not be the sole location of the database, uploads, runtime Secrets, or irreplaceable business state.

## 3. Durable project state

Planned explicit bind-backed durable paths:

```text
/srv/data/mini-craft-night-kit/mysql
/srv/data/mini-craft-night-kit/wp-content
/srv/data/mini-craft-night-kit/secrets
```

Classification:

- `mysql/` — MariaDB durable database data;
- `wp-content/` — WordPress plugins/themes/uploads and other site-owned wp-content state;
- `secrets/` — protected runtime Secret files only.

MariaDB must remain project-local and must not join the shared public edge network.

Anonymous durable volumes are forbidden.

## 4. Secret metadata

No Secret value may enter this manifest, GitHub, ordinary Evidence, chat, or logs.

Planned Secret references:

```text
/srv/data/mini-craft-night-kit/secrets/db-app-password
/srv/data/mini-craft-night-kit/secrets/db-root-password
```

Default metadata target:

- Secret directory: restrictive project-only access;
- Secret files: minimum required runtime access only;
- fail on unexpected pre-existing target;
- no overwrite except a separately authorized rotation Gate.

The restored WordPress database may itself contain application/provider credential material (including Sandbox configuration). Therefore database dumps and production database files are sensitive deployment/recovery artifacts and must never be committed to GitHub or copied into ordinary review bundles.

Any additional Secret file required by the final rendered Compose/config must be added here by metadata only before the first deployment write.

## 5. Backup layout

```text
/srv/backups/mini-craft-night-kit/database
/srv/backups/mini-craft-night-kit/wp-content
/srv/backups/mini-craft-night-kit/manifests
```

Backup method:

- MariaDB: logical consistent dump using the database-native dump path;
- wp-content: project-scoped filesystem archive/snapshot;
- deployment metadata: Compose/release/version manifest without Secret values;
- Secret recovery: governed separately from ordinary DB/wp-content backups.

A backup existing is not sufficient evidence of recoverability.

## 6. Restore method

Planned restore unit:

```text
reconstructible application/release
+ MariaDB logical backup
+ wp-content backup
+ protected Secret references / recovery procedure
+ deployment manifest
```

Restore sequence must be validated in a bounded K6/K7 recovery check:

1. create/use the exact project namespace;
2. restore protected Secret references without value output;
3. restore MariaDB from a logical backup;
4. restore wp-content;
5. start only the Mini Craft Compose project;
6. perform serialized-data-safe WordPress origin migration;
7. verify DB/site integrity, primary routes, media, WooCommerce, and payment Sandbox state;
8. verify unrelated shared services are unchanged.

`RESTORE_METHOD_DEFINED=YES`
`RESTORE_REHEARSAL=K6_OR_K7_PENDING`

## 7. Retention

- pre-deployment recovery point: retain through K7 Production Canary PASS and at least 14 additional days;
- post-deployment recovery point: retain at least 14 days;
- any later routine backup retention may be tightened/extended in a separate operations Gate;
- irreversible deletion of business data/backups remains Owner-only.

## 8. Network / ingress storage boundary

Shared Caddy, shared cloudflared, host 80/443, shared Docker networks and Shared Infra storage are not Mini Craft project data.

If current topology is confirmed, the WordPress HTTP-facing service may join the existing `spikersun-edge` network through an explicitly authorized Shared Infra membership/config change.

MariaDB must never join `spikersun-edge`.

## 9. Migration unit

If the project moves to another VPS, migrate:

- application/release definition;
- `/srv/data/mini-craft-night-kit/mysql` via validated logical DB backup/restore rather than raw live-directory copying;
- `/srv/data/mini-craft-night-kit/wp-content`;
- protected Secret recovery/inventory procedure;
- project backup/release manifest.

Do not copy a live MariaDB raw data directory as the default migration method.

## 10. Decommission boundary

Classify before deletion:

- REBUILDABLE: app/release/cache;
- DURABLE: DB/wp-content;
- SECRET: separate protected handling;
- BACKUP: retention decision;
- SHARED: never delete from a Mini Craft project Gate.

No broad Docker prune.

## 11. Resource footprint / remote reality

Exact remote resource headroom and initial footprint are not yet claimed because K6R1 SSH read-back is pending.

Before the first K6 deployment write, record:

- root filesystem free/used;
- Docker image footprint;
- current Mini Craft transfer/package size;
- expected MariaDB + wp-content footprint;
- before/after deployment delta.

```text
EXPECTED_INITIAL_FOOTPRINT=PENDING_K6R1_REMOTE_PREFLIGHT
RESOURCE_HEADROOM=PENDING_K6R1_REMOTE_PREFLIGHT
```

If headroom cannot be proven safe, stop before write.

## 12. Governance acceptance markers

```text
STORAGE_LAYOUT_CONTRACT_READ=YES
PROJECT_STORAGE_MANIFEST_EXISTS=YES
DURABLE_DATA_PATHS_EXPLICIT=YES
SECRET_PATHS_EXPLICIT_METADATA_ONLY=YES
SECRET_RUNTIME_ACCESS_DEFINED=PLANNED_MINIMUM_ACCESS; FINAL_RENDER_READBACK_REQUIRED
SECRET_RECOVERY_POLICY_DEFINED=YES_SEPARATE_FROM_ORDINARY_BACKUP
BACKUP_PATH_EXPLICIT=YES
RESTORE_METHOD_DEFINED=YES
ANONYMOUS_DURABLE_VOLUME=NO
CROSS_PROJECT_DATA_SHARING=NO
REMOTE_STORAGE_WRITE_AUTHORIZED_BY_THIS_FILE=NO
```

Any material change to these paths/ownership classes requires Reviewer reconciliation before deployment.
