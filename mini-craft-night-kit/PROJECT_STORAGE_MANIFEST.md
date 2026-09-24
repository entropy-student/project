# Mini Craft Night Kit — PROJECT STORAGE MANIFEST

Status: PRE-DEPLOYMENT PLAN / K6 PHASE B REVIEWER RETURN / REMOTE STORAGE NOT CREATED
Governance: canonical `entropy-student/spike.skill/vps-project-governance` latest
Current Gate: `K6_PHASE_B_R1_PACKAGE_RECONCILIATION`

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

Planned Secret references required by the current production Compose candidate (paths and purposes only; none exist on the VPS yet):

| Host file under `/srv/data/mini-craft-night-kit/secrets/` | Runtime consumer | Purpose |
|---|---|---|
| `db-app-password` | MariaDB, WordPress | Application database password |
| `db-root-password` | MariaDB only | Database root password |
| `wordpress-auth-key` | WordPress only | WordPress AUTH_KEY |
| `wordpress-secure-auth-key` | WordPress only | WordPress SECURE_AUTH_KEY |
| `wordpress-logged-in-key` | WordPress only | WordPress LOGGED_IN_KEY |
| `wordpress-nonce-key` | WordPress only | WordPress NONCE_KEY |
| `wordpress-auth-salt` | WordPress only | WordPress AUTH_SALT |
| `wordpress-secure-auth-salt` | WordPress only | WordPress SECURE_AUTH_SALT |
| `wordpress-logged-in-salt` | WordPress only | WordPress LOGGED_IN_SALT |
| `wordpress-nonce-salt` | WordPress only | WordPress NONCE_SALT |

All ten are planned read-only, `create_host_path: false` file binds under `/run/secrets/` with the matching basename. The host Secret directory target is restrictive project-only access; files must be fail-on-existing and must never be committed or emitted in Evidence. Exact effective runtime uid/gid, host owner/group/mode, non-root WordPress read access, and an encrypted off-host recovery destination/procedure are **PENDING K6 Phase B R1 verification**. The generic minimum-access policy below is not evidence that those requirements are met.

Default metadata target:

- Secret directory: restrictive project-only access;
- Secret files: minimum required runtime access only;
- fail on unexpected pre-existing target;
- no overwrite except a separately authorized rotation Gate.

The restored WordPress database may itself contain application/provider credential material (including Sandbox configuration). Therefore database dumps and production database files are sensitive deployment/recovery artifacts and must never be committed to GitHub or copied into ordinary review bundles.

Any later Secret file required by the final rendered Compose/config must be added here by metadata only before the first deployment write.

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

A bounded Reviewer SSH read-back on 2026-09-24 found the recorded host reachable, 88G free on the 96G root filesystem, and no Mini Craft project namespaces. The full K6R3 Phase A read-only host inventory was accepted by Reviewer on 2026-09-24: 5.5 GiB RAM available, 88G root free, existing shared services protected and no Mini Craft namespace collision. Production package footprint and before/after deployment delta remain pending; this snapshot does not authorize a write.

Before the first K6 deployment write, record:

- root filesystem free/used;
- Docker image footprint;
- current Mini Craft transfer/package size;
- expected MariaDB + wp-content footprint;
- before/after deployment delta.

```text
EXPECTED_INITIAL_FOOTPRINT=PENDING_K6_PHASE_B_PACKAGE_SEAL
RESOURCE_HEADROOM=K6R3_HOST_BASELINE_PASS; DEPLOYMENT_DELTA_PENDING
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
