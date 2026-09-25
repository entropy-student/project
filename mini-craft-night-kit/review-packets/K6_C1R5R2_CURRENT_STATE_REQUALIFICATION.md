# K6 C1R5R2 — Current-State Requalification Execution Pack

Gate:
`K6_PHASE_C1R5R2_CURRENT_STATE_REQUALIFICATION`

Authority:
- canonical `entropy-student/spike.skill/vps-project-governance` latest;
- `docs/REVIEWER_DECISION_K6_C1R5R1_RETURN_C1R5R2_STATE_REQUALIFICATION.md`;
- current `REVIEWER_HANDOFF.md`;
- latest `EXECUTION_EVIDENCE.md`;
- latest `EXECUTOR_HANDOFF.md`;
- unique current Shared VPS Handoff;
- sealed production Compose/package.

## Objective

Independently qualify the **current resulting Secret state** for later K6 deployment without changing any Secret or recovery content and without claiming the historical C1R5 helper-source defect is fixed.

## Mandatory preflight

1. Read all authority sources completely.
2. Strictly verify Owner-host / SSH target identity/trust.
3. Confirm exact ten Secret files still exist with the expected metadata.
4. Confirm Mini Craft production containers/networks are still absent.
5. Confirm required validation images are already present; do not pull/build.
6. Confirm unrelated running services do not mount Mini Craft Secret paths.

Any drift → precise RETURN before validation container creation.

## Bounded runtime-access validation

Use disposable validation containers only.

### WordPress reader proof

- no network;
- no published ports;
- no persistent volumes;
- run as UID/GID 33:33;
- bind only the exact nine WordPress-allowed Secret files read-only to their intended paths;
- do not mount `db-root-password`;
- use permission checks only such as `test -r` / metadata;
- do not print, cat, checksum, hash, copy or otherwise expose contents;
- prove all 9 intended files readable;
- prove DB-root path absent/not mounted.

### MariaDB access proof

- no network;
- no published ports;
- no persistent volumes;
- bind only `db-app-password` and `db-root-password` read-only;
- use the intended root/entrypoint access boundary;
- permission checks only;
- prove both required files readable without content output.

### Cleanup

After validation:
- remove disposable containers;
- verify zero new project networks/volumes;
- verify Mini Craft production services remain unstarted;
- verify unrelated running services unchanged.

## Recovery metadata recheck

Owner-Windows metadata only:
- exact new final recovery path/basename;
- existence;
- size;
- ACL/inheritance;
- historical pending existence/size/ACL metadata.

Do not open/decrypt/hash/copy/move/modify either recovery artifact.

## Forbidden

No:
- Secret value read/hash/output/copy/transfer;
- Secret regeneration/rotation/overwrite/chmod/chown/delete/rename;
- recovery content access/decrypt/hash;
- production WordPress/MariaDB service startup;
- DB/wp-content restore;
- `/srv/apps` or `/srv/backups` creation;
- Shared Infra mutation;
- DNS/public route;
- PayPal Live/payment/refund;
- image pull/build;
- broad prune.

## Evidence

Append only redacted actual facts to:
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Required markers:

```text
TARGET_SECRET_METADATA_READBACK=
WORDPRESS_UID33_EFFECTIVE_READ_9_OF_9=
WORDPRESS_DB_ROOT_NOT_MOUNTED=
MARIADB_REQUIRED_SECRET_ACCESS=
UNRELATED_RUNNING_SERVICE_SECRET_MOUNTS=
DISPOSABLE_VALIDATION_NETWORK=
DISPOSABLE_VALIDATION_PORTS=
DISPOSABLE_VALIDATION_PERSISTENT_STATE=
VALIDATION_RESOURCES_AFTER_CLEANUP=
NEW_FINAL_RECOVERY_METADATA_READBACK=
OLD_PENDING_METADATA_UNCHANGED=
SECRET_VALUE_OR_HASH_ACCESS=0
MINICRAFT_PRODUCTION_SERVICE_STARTS=0
SHARED_INFRA_WRITES=0
```

## Return

Success:

```text
PASS_CANDIDATE_K6_PHASE_C1R5R2_CURRENT_STATE_REQUALIFICATION
STOP_AT_REVIEWER=YES
```

Otherwise return a precise `RETURN_*`.

Do not enter deployment/start after this Gate.
