# Mini Craft Night Kit — PROJECT STORAGE MANIFEST

Status: K6 C1R4 RETURN (pending payload schema ambiguous) / Owner disposition checkpoint / remote storage not created / encrypted pending retained
Governance: canonical `entropy-student/spike.skill/vps-project-governance` latest
Current Gate: `K6_PHASE_C1R4R1_PENDING_DISPOSITION_OWNER_CHECKPOINT` (no Executor dispatched)

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

All ten are planned read-only, `create_host_path: false` file binds under `/run/secrets/` with the matching basename. The R1 local disposable rehearsal verified the mount allowlist and synthetic-file read access; it did not create or inspect real target Secret files.

Proposed **target Linux** metadata, pending an explicitly authorized Secret Gate and target-host read-back:

| File(s) | Host owner:group / mode | Allowed runtime reader |
|---|---|---|
| `db-app-password` and all eight `wordpress-*-key` / `wordpress-*-salt` files | `root:33` / `0440` | WordPress `www-data` UID/GID 33:33; MariaDB entrypoint root also reads `db-app-password` |
| `db-root-password` | `root:root` / `0400` | MariaDB entrypoint root only |

The proposed host `secrets/` directory is `root:root` mode `0700`; individual file binds do not require WordPress to traverse that host directory. The synthetic rehearsal proved `root:33 0440` can be read by UID 33 and `root:root 0400` cannot. Windows bind ACLs are not proof of target Linux modes. Actual target identity, file metadata, WordPress/MariaDB access and unrelated-service exclusion remain **UNVERIFIED**.

Provisioning must be exact-allowlist, cryptographic-RNG based, atomic exclusive create/fail-on-existing, no value or value-hash output, and no overwrite absent a separate rotation Gate. Default Secret authority remains Owner-only. On 2026-09-24 the Owner explicitly accepted the exact ten-file project/host/path/format/no-overwrite/DPAPI scope documented in `docs/REVIEWER_DECISION_K6_C1_SECRET_PROVISIONING_AUTHORIZED.md`. C1 attempted a prewrite transaction, created only the encrypted Owner-profile pending recovery artifact, and returned before any target directory or Secret file creation. That earlier write authorization is historical after RETURN. C1R4 was subsequently Owner-authorized for bounded in-memory inspection and returned because the payload contains two undocumented non-record boundary lines. The conditional C1R5 write authorization expired on that RETURN; any later Secret generation, transfer or write requires a fresh explicit Owner authorization.

First off-host recovery design is DPAPI `CurrentUser` under the verified Owner Windows profile, outside Git/review bundles. The C1 attempt generated the ten intended values only in target process memory and created `%LOCALAPPDATA%\MiniCraftNightKit\secret-recovery\k6-c1-mini-craft-night-kit-srv1970241.pending.dpapi` (1,686 bytes). Immediate in-memory DPAPI byte-identity round-trip passed. The Windows CRLF acknowledgement was rejected by the remote LF-only parser before any target path/file write. Reviewer read-only check found `/srv/data/mini-craft-night-kit` absent; the Owner recovery leaf is protected with an Owner-only ACL. The pending artifact was **not** promoted, deleted or copied. It is **not** a final deployed Secret recovery copy. C1R3 found that the original serialized payload schema was absent from non-sensitive retained source. C1R4 was then explicitly Owner-authorized for bounded DPAPI CurrentUser in-memory inspection: the project/host bindings and all ten allowlisted fields validated, but two undocumented non-record boundary lines remained, so C1R4 returned fail-closed before any real payload transfer. Retain the artifact encrypted, unpromoted and undeleted at the current Owner checkpoint. The previous conditional C1R5 write authorization expired on the RETURN. The Reviewer recommends fresh Secret regeneration under a newly sealed canonical serialization/parser after fresh Owner authorization; further recovery of the old exact values is an alternate Owner-selected path. Profile-bound recovery does not survive simultaneous loss of both VPS and Owner Windows profile.

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

The K6R3 dated read-only baseline has been refreshed by C0 Executor and independent Reviewer strict SSH probes on 2026-09-24. Reviewer read-back confirmed `srv1970241`, root total 102,888,095,744 bytes, used 9,329,029,120 bytes, free 93,542,289,408 bytes, and RAM available 5,876,936,704 bytes. No Mini Craft namespace existed in the C0 Executor inventory. These are dated snapshots, not permission to write.

The accepted local MariaDB datadir occupied 198,537,216 physical bytes. A planning reserve of 3× that size (595,611,648 bytes) covers proposed DB data plus restore workspace; it is an engineering assumption, not a guaranteed maximum. Together with 1,120,000,000 bytes WordPress image, 457,000,000 bytes MariaDB image, 238,099,266 bytes for two archive copies, 220,323,840 bytes expanded wp-content and 62,914,560 bytes bounded logs, the projected incremental peak is 2,693,949,314 bytes (~2.51 GiB). The Executor snapshot projected root use of ~11.68%, below the 60% stop line. Re-measure all inputs before the first write and stop if actual growth exceeds the envelope. Reserve 512 MiB WordPress tmpfs against RAM headroom.

Before the first K6 deployment write, record:

- root filesystem free/used;
- Docker image footprint;
- current Mini Craft transfer/package size;
- expected MariaDB + wp-content footprint;
- before/after deployment delta.

```text
EXPECTED_INITIAL_FOOTPRINT=2693949314_BYTES_PLANNING_ENVELOPE_INCLUDING_3X_LOCAL_DATADIR
RESOURCE_HEADROOM=C0_READONLY_BASELINE_PASS_2026-09-24; FRESH_PREWRITE_RECHECK_REQUIRED
```

Before the first target write, stop if fresh usage is at/above 60%, projected peak reaches 60%, or any required capacity term (including observed MariaDB restore growth and working space) is unknown or exceeds the accepted planning envelope. Include the 512 MiB WordPress tmpfs in RAM headroom, not durable disk. If headroom cannot be proven safe, stop before write.

## 12. Governance acceptance markers

```text
STORAGE_LAYOUT_CONTRACT_READ=YES
PROJECT_STORAGE_MANIFEST_EXISTS=YES
DURABLE_DATA_PATHS_EXPLICIT=YES
SECRET_PATHS_EXPLICIT_METADATA_ONLY=YES
SECRET_RUNTIME_ACCESS_DEFINED=PROPOSED_ROOT_33_0440_AND_ROOT_ROOT_0400; TARGET_READBACK_PENDING
SECRET_RECOVERY_POLICY_DEFINED=DPAPI_PENDING_ROUNDTRIP_PASS; FINAL_ARTIFACT_NOT_CREATED; RETRY_AUTH_PENDING
BACKUP_PATH_EXPLICIT=YES
RESTORE_METHOD_DEFINED=YES
ANONYMOUS_DURABLE_VOLUME=NO
CROSS_PROJECT_DATA_SHARING=NO
REMOTE_STORAGE_WRITE_AUTHORIZED_BY_THIS_FILE=NO
```

Any material change to these paths/ownership classes requires Reviewer reconciliation before deployment.
