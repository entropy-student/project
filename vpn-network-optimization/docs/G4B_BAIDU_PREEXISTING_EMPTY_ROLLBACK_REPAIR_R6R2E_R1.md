# G4-B Baidu Pre-existing Empty Config Rollback Repair R6R2E-R1

Status: ACTIVE / EXECUTOR_OFFLINE_ONLY

## GATE_ID

`G4B_BAIDU_PREEXISTING_EMPTY_ROLLBACK_REPAIR_R6R2E_R1`

## PREVIOUS_RESULT

`RETURN_R6R2E_PREEXISTING_EMPTY_ROOT_DELETION_RISK`

## ACCEPTED / FROZEN FROM R6R2E

The following R6R2E work is accepted and frozen unless the narrow repair requires a directly dependent assertion update:

- metadata-only exact failed-run reconciliation checkpoint;
- exact `pcs_config.json` residue shape predicate;
- extra-entry/reparse/unexpected-owner/forbidden-ACE rejection;
- exact-delete scope;
- no-content-read boundary;
- post-login exact-shape validation;
- Owner/ACL normalization ordering;
- strict R6R1 ACL validation after normalization;
- no-credential login boundary;
- nonzero login -> no `who`;
- UID/raw-output suppression.

Current accepted candidate blobs:

```text
R6R2E_RECONCILE_HELPER_BLOB=cb46e2bc949b4b71445de5c79180c5c05bd26c21
R6R2E_AUTH_HELPER_BLOB=a5f6430627a1844c990ccd2712eb1f3ee74823ab
```

## DEFECT

In the repaired auth helper, the failure fallback currently uses:

```text
if login started && config file absent before login && !candidateReady:
    if post-login exact shape verified:
        exact residue rollback
    else:
        Remove-NewEmptyBaiduConfigDirectory(...)
```

`Remove-NewEmptyBaiduConfigDirectory` deletes an empty config directory without distinguishing whether the root was created by this run.

Therefore this sequence can delete pre-existing state:

```text
pre-run: %APPDATA%\BaiduPCS-Go already exists and is empty
-> Initialize marks EXISTING_EMPTY_INITIALIZED, RootCreatedThisRun=false
-> login attempt starts or is marked started
-> login fails before producing pcs_config.json / before post-login shape verification
-> fallback sees empty directory
-> fallback deletes the pre-existing empty root
```

This violates the R6R2E requirement that an existing empty root is preserved.

## OBJECTIVE

Repair only this rollback/provenance defect and add regression coverage.

## REQUIRED BEHAVIOR

1. A config root that existed before the run must **never be deleted** by failure rollback merely because it is empty.
2. If the root existed empty before login and no config file was produced:
   - preserve the directory;
   - emit/record a bounded disposition such as `PRESERVED_PREEXISTING_EMPTY`.
3. If the root was created by this run and remains empty:
   - exact empty-root rollback may remove it.
4. If `pcs_config.json` was created by this run and exact post-login shape/provenance was verified:
   - existing R6R2E exact file rollback remains allowed;
   - if the root pre-existed, remove only the newly created exact file and preserve the root;
   - if the root was created this run, remove exact file then exact empty root.
5. Unknown/non-empty/unverified state remains preserved fail-closed.
6. No content read, no broad recursive delete, no unrelated ACL/path changes.
7. No change to login arguments/environment/console behavior, pinned archive trust, post-login normalization, `who` count/order, UID suppression, or reconciliation helper behavior.

## REQUIRED FIXTURES

Use the production rollback predicate/function, not a documentation-only/static-only substitute.

At minimum prove:

```text
R6R2E_R1_PREEXISTING_EMPTY_START_FAILURE_PRESERVED=PASS
R6R2E_R1_PREEXISTING_EMPTY_NO_FILE_PRESERVED=PASS
R6R2E_R1_NEW_EMPTY_ROOT_ROLLBACK_ALLOWED=PASS
R6R2E_R1_PREEXISTING_ROOT_NEW_EXACT_FILE_REMOVES_FILE_ONLY=PASS
R6R2E_R1_NEW_ROOT_NEW_EXACT_FILE_REMOVES_FILE_AND_ROOT=PASS
R6R2E_R1_UNKNOWN_NONEMPTY_PRESERVED=PASS
R6R2E_R1_NO_CONTENT_READ=PASS
R6R2E_R1_NO_BROAD_DELETE=PASS
R6R2E_FULL_REGRESSION=PASS
R6R1_ACL_REGRESSION=PASS
POWERSHELL_AST_PARSE=PASS
SECRET_SCAN=PASS
REAL_CONFIG_ACTIONS=0
REAL_LOGIN_ACTIONS=0
REAL_BAIDU_ACTIONS=0
OWNER_CONFIG_READ=NO
NETWORK_REQUESTS=0
STOP_AT_REVIEWER=YES
```

Synthetic filesystem fixtures may be used for exact empty-directory/file deletion semantics. If the environment blocks non-secret ACL mutation, use the already accepted synthetic ACL approach for ACL-specific assertions, but the root-provenance rollback decision itself must be exercised against the production function.

## ALLOWED FILES

- `scripts/g4b-baidu-owner-interactive-auth-checkpoint.ps1`
- `scripts/g4b-baidu-owner-interactive-auth-validator.ps1`
- this Gate
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Frozen:

- `scripts/g4b-baidu-partial-config-reconcile-checkpoint.ps1`
- `scripts/g4b-baidu-partial-config-reconcile-validator.ps1`
- accepted R6/R6R1/R6R2A sources;
- `REVIEWER_HANDOFF.md`;
- unrelated project files.

## EXECUTOR BOUNDARY

Offline only. No real Owner config, no real deletion, no login, no `who`, no network/provider, no credentials/DPAPI, no VPS/SSH/Clash/live G4-B/G4-C.

## STOP

`STOP_AT_REVIEWER=YES`
