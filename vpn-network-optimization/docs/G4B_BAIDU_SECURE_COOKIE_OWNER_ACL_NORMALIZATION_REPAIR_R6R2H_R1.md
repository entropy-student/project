# G4-B Baidu Secure Cookie Owner ACL Normalization Repair R6R2H-R1

Status: SUPERSEDED / DO_NOT_EXECUTE

## GATE_ID

`G4B_BAIDU_SECURE_COOKIE_OWNER_ACL_NORMALIZATION_REPAIR_R6R2H_R1`

> SUPERSEDED by canonical Gate `G4B_BAIDU_SECURE_COOKIE_OWNER_CHECKPOINT_REPAIR_R6R2H_R1`
> (`docs/G4B_BAIDU_SECURE_COOKIE_OWNER_CHECKPOINT_REPAIR_R6R2H_R1.md`, blob `6f448f7c16a322c240f756121ddbbc0ca97dc516`).
> Do not execute this duplicate Gate.

## PREVIOUS_RESULT

`RETURN_R6R2H_COOKIE_OWNER_CHECKPOINT_MISSING_POSTSAVE_ACL_NORMALIZATION`

## ACCEPTED / FROZEN FROM R6R2H

The following R6R2H work is accepted and frozen unless a directly dependent assertion must change:

- pinned v4.0.2 adapter source lineage and build provenance;
- no-echo live-console Cookie input;
- zero credential CLI arguments;
- zero credential environment variables;
- no command-history / clipboard path;
- Cookie empty / CRLF / BDUSS-shape validation;
- direct `SetupUserByBDUSS("", "", "", cookie)` path;
- config Save only after setup success;
- bounded output, UID/account-name suppression;
- reliable nonzero native exit on adapter failure;
- public-only build/toolchain/module retrieval;
- temporary build cleanup;
- no real Cookie/provider/Owner-config action in R6R2H.

Accepted candidate identities:

```text
R6R2H_SOURCE_COMMIT=8265ade045c8df3aaaa449280b75dc79afc4cf02
ADAPTER_SOURCE_BLOB=9298b477ccbaae6439ae33ddf098e343dfac4dc0
BUILD_HELPER_BLOB=7f369604de3cf0cce46bf0cf7328313c03ed61d5
OWNER_CHECKPOINT_BLOB=ab43037ef793d8a3c9cce69e14c7e64b33239957
VALIDATOR_BLOB=07d1f24f2cc934852b456ac2e293c8d74a88d71d
RECONCILIATION_HELPER_BLOB=cb46e2bc949b4b71445de5c79180c5c05bd26c21
ADAPTER_BINARY_SHA256=5c6ad2fdbcb9bee1b3b2fdc789b07e061bd89cc64350c750298b682b717e7955
```

## BLOCKING DEFECT

The Owner checkpoint currently does this after the adapter process exits:

```text
process exit
-> Assert-SafeBaiduConfigDirectory(...)
-> inspect entries
-> if exit == 0 require exact pcs_config.json
```

The adapter's upstream `pcsconfig.Config.Save()` creates `pcs_config.json` inside an elevated Owner-launched child process. R6R2D already proved on this exact Windows host that a child-created Baidu config file can be owned by Builtin Administrators rather than the exact Owner SID.

Therefore a successful Cookie setup can be rejected immediately by the strict R6R1 predicate before any normalization occurs, reproducing the previously accepted `BAIDU_AUTH_CONFIG_OWNER_MISMATCH` class.

This is a real production-path defect. No real Cookie input is authorized until repaired.

## OBJECTIVE

Repair only the Owner checkpoint's post-adapter config metadata flow so the exact run-created `pcs_config.json` is shape-validated, then Owner/ACL-normalized, then strictly validated through the accepted R6R1 predicate.

Also preserve precise provenance/rollback semantics for failure paths without reading config content.

## REQUIRED SUCCESS PATH

For child native exit 0:

1. inspect config subtree metadata only;
2. require exact root + exactly one regular non-reparse `pcs_config.json`, bounded nonzero size;
3. before mutation, allow only Owner provenance already accepted for this Windows child-process shape (current Owner SID or Builtin Administrators) and reject unexpected/reparse/extra entries;
4. reuse the accepted R6R2E metadata structure predicate where practical;
5. normalize Owner/ACL metadata for the exact `pcs_config.json` and exact root through the accepted `Set-OwnerOnlyAcl` constructor;
6. do not read/parse/hash/print config content;
7. then run strict `Assert-OwnerOnlyAcl` / `Assert-SafeBaiduConfigDirectory`;
8. only after all of the above set:
   `BAIDU_COOKIE_AUTH_CHECKPOINT=SETUP_SAVED`.

Strict R6R1 validation must occur after normalization, not before it.

## REQUIRED FAILURE / PROVENANCE BEHAVIOR

The checkpoint must record whether the root existed before this run.

Before adapter launch only ABSENT or safely EMPTY is allowed.

If adapter native exit is nonzero:

- no `who`;
- no success marker;
- if config remains empty:
  - remove root only if it was created by this run;
  - preserve a pre-existing empty root;
- if an exact `pcs_config.json` exists after a failed native exit:
  - do not assume it is safe to delete merely from exit code;
  - classify exact metadata shape/provenance and preserve fail-closed unless a separately proven rollback rule authorizes deletion;
- unknown/non-empty/extra/reparse state is preserved fail-closed.

If adapter native exit is 0 but post-save shape/normalization/strict validation fails:

- do not publish success;
- preserve the non-empty authenticated/possibly-authenticated config fail-closed rather than deleting it blindly;
- emit bounded disposition markers sufficient for Reviewer to know whether state is empty, exact-nonempty-preserved, or unknown-preserved without revealing identity/ACL/content.

No broad recursive delete is allowed.

## OUTPUT CONTRACT

Keep the existing bounded markers and add one bounded config disposition marker if needed, for example:

```text
BAIDU_COOKIE_AUTH_CHECKPOINT=...
BAIDU_COOKIE_AUTH_FAILURE_CODE=...
BAIDU_COOKIE_AUTH_NATIVE_EXIT=...
BAIDU_COOKIE_AUTH_CONFIG_DISPOSITION=...
BAIDU_COOKIE_AUTH_WHO=NOT_RUN
BAIDU_COOKIE_AUTH_UID_EMITTED=NO
```

Do not print usernames, UID, Cookie, BDUSS/STOKEN, provider raw response, ACL details, SIDs, paths containing private identity, file contents, or Secret-derived hashes.

## REQUIRED FIXTURES

Use production functions/predicates where possible.

At minimum prove:

```text
R6R2H_R1_POSTSAVE_EXACT_SHAPE_BEFORE_NORMALIZE=PASS
R6R2H_R1_ADMIN_OWNER_EXACT_FILE_ACCEPTED_FOR_NORMALIZATION=PASS
R6R2H_R1_UNEXPECTED_OWNER_REJECTED_BEFORE_NORMALIZATION=PASS
R6R2H_R1_EXTRA_ENTRY_REJECTED_BEFORE_NORMALIZATION=PASS
R6R2H_R1_REPARSE_REJECTED_BEFORE_NORMALIZATION=PASS
R6R2H_R1_OWNER_ACL_NORMALIZED_BEFORE_R6R1_STRICT_CHECK=PASS
R6R2H_R1_R6R1_STRICT_CHECK_AFTER_NORMALIZE=PASS
R6R2H_R1_PREEXISTING_EMPTY_ROOT_PRESERVED_ON_FAILURE=PASS
R6R2H_R1_NEW_EMPTY_ROOT_REMOVABLE_ON_FAILURE=PASS
R6R2H_R1_NONEMPTY_FAILURE_STATE_PRESERVED=PASS
R6R2H_R1_SUCCESS_NOT_PUBLISHED_BEFORE_STRICT_CHECK=PASS
R6R2H_R1_NO_CONFIG_CONTENT_READ=PASS
R6R2H_R1_NO_BROAD_DELETE=PASS
R6R2H_FULL_REGRESSION=PASS
R6R1_ACL_REGRESSION=PASS
POWERSHELL_AST_PARSE=PASS
GO_SOURCE_STATIC_VALIDATION=PASS
SECRET_SCAN=PASS
REAL_COOKIE_VALUES_USED=0
REAL_BAIDU_AUTH_ACTIONS=0
OWNER_CONFIG_READ=NO
OWNER_CONFIG_WRITE=NO
STOP_AT_REVIEWER=YES
```

Synthetic ACL fixtures may use the accepted in-memory/synthetic technique if local `SeSecurityPrivilege` blocks exact ACL mutation, but ordering and provenance logic must exercise the production checkpoint functions.

## EXECUTOR BOUNDARY

Offline only. No real Cookie, no browser/clipboard access, no Owner config read/write, no Baidu auth/who/provider action, no Secret/DPAPI, no VPS/SSH/Clash/live G4-B/G4-C.

## ALLOWED FILES

- `scripts/g4b-baidu-cookie-auth-owner-checkpoint.ps1`
- `scripts/validate-g4b-baidu-cookie-auth-adapter.ps1`
- this Gate
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Frozen:

- `scripts/g4b-baidu-cookie-auth-adapter/main.go`
- `scripts/g4b-baidu-cookie-auth-adapter/main_test.go`
- `scripts/build-g4b-baidu-cookie-auth-adapter.ps1`
- accepted R6R1/R6R2A/R6R2E/R6R2E-R1 helpers;
- `REVIEWER_HANDOFF.md`;
- unrelated project files.

## STOP

`STOP_AT_REVIEWER=YES`
