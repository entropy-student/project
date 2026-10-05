# G4-B Baidu Owner Partial Config Reconciliation Run R6R2F

Status: ACTIVE / OWNER_LOCAL_DESTRUCTIVE_BOUNDED

## GATE_ID

`G4B_BAIDU_OWNER_PARTIAL_CONFIG_RECONCILIATION_RUN_R6R2F`

## PREVIOUS_RESULT

`PASS_G4B_BAIDU_PREEXISTING_EMPTY_ROLLBACK_REPAIR_R6R2E_R1`

## OBJECTIVE

Run the reviewed metadata-only reconciliation checkpoint exactly once on the real Owner Windows host to reconcile the preserved failed R6R2D residue and restore the pre-login absent baseline only if the exact bounded residue shape is proven.

## LOCKED SOURCE

```text
R6R2E_R1_SOURCE_COMMIT=9b65fed5b58b7c1f71615cda7b100acbfd1aa9c0
RECONCILIATION_HELPER_BLOB=cb46e2bc949b4b71445de5c79180c5c05bd26c21
AUTH_HELPER_BLOB=e67197ee15ad4ce758ed2c624c80d69dfd4bb08a
AUTH_VALIDATOR_BLOB=f49abcb6073e6b9c048825e1caec777df9e8f530
```

The reconciliation helper is frozen from accepted R6R2E. It is metadata-only before deletion.

## OWNER SHELL

Use PowerShell 7.6.6 as Administrator / High integrity on the accepted Owner Windows host.

Before execution, verify the local reconciliation helper blob equals the locked helper blob. If not, stop.

## EXACT DELETE AUTHORIZATION

The checkpoint may delete only when all production predicates pass for:

`%APPDATA%\BaiduPCS-Go`

Specifically:

- root exists, exact canonical location, real directory, no reparse;
- exactly one entry;
- exact regular non-reparse `pcs_config.json`;
- bounded non-zero file size <= 1 MiB;
- Owner provenance allowed by the accepted failed-run model;
- no Deny ACE;
- no Allow principal outside current Owner / LocalSystem / Builtin Administrators.

If and only if those predicates pass, the checkpoint may:

1. delete exactly `pcs_config.json`;
2. verify the directory is empty;
3. delete exactly the now-empty `BaiduPCS-Go` directory;
4. verify the path is absent.

Any mismatch must fail closed with zero deletion outside the exact path.

## FORBIDDEN

- reading/parsing/hashing/printing config content;
- broad recursive deletion;
- login / `who`;
- network/provider requests;
- credentials/Secret/DPAPI access;
- VPS/SSH/Clash/service/route/proxy/TUN/live G4-B/G4-C;
- manual cleanup outside the helper.

## OWNER RETURN CONTRACT

Return only:

```text
BAIDU_PARTIAL_CONFIG_RECONCILIATION=...
BAIDU_PARTIAL_CONFIG_SHAPE=...
BAIDU_PARTIAL_CONFIG_CONTENT_READ=NO
BAIDU_PARTIAL_CONFIG_ROLLBACK=...
BAIDU_PARTIAL_CONFIG_BASELINE_RESTORED=...
```

## SUCCESS

Success requires either:

```text
BAIDU_PARTIAL_CONFIG_RECONCILIATION=PASS
BAIDU_PARTIAL_CONFIG_SHAPE=EXACT_FAILED_RUN_RESIDUE
BAIDU_PARTIAL_CONFIG_CONTENT_READ=NO
BAIDU_PARTIAL_CONFIG_ROLLBACK=REMOVED_EXACT_RESIDUE
BAIDU_PARTIAL_CONFIG_BASELINE_RESTORED=RESTORED
```

or an already-absent equivalent:

```text
BAIDU_PARTIAL_CONFIG_RECONCILIATION=PASS
BAIDU_PARTIAL_CONFIG_SHAPE=ABSENT
BAIDU_PARTIAL_CONFIG_CONTENT_READ=NO
BAIDU_PARTIAL_CONFIG_ROLLBACK=NOT_REQUIRED
BAIDU_PARTIAL_CONFIG_BASELINE_RESTORED=RESTORED
```

If `FAIL_CLOSED`, stop and return the five bounded markers. Do not retry login or manually delete anything.

`STOP_AT_REVIEWER=YES`
