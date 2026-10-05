# G4-B Baidu Secure Cookie Owner Checkpoint Repair R6R2H-R1

Status: ACTIVE / EXECUTOR_OFFLINE_ONLY

## GATE_ID

`G4B_BAIDU_SECURE_COOKIE_OWNER_CHECKPOINT_REPAIR_R6R2H_R1`

## PREVIOUS_RESULT

`RETURN_R6R2H_OWNER_CHECKPOINT_POSTAUTH_ACL_AND_FAILURE_RECONCILIATION_GAP`

## ACCEPTED / FROZEN FROM R6R2H

The following R6R2H artifacts and conclusions are accepted and frozen:

```text
R6R2H_SOURCE_COMMIT=8265ade045c8df3aaaa449280b75dc79afc4cf02
ADAPTER_SOURCE_BLOB=9298b477ccbaae6439ae33ddf098e343dfac4dc0
ADAPTER_TEST_BLOB=b02bf9bbfff5e1ad99523b568d202d1e63d5c9ae
BUILD_HELPER_BLOB=7f369604de3cf0cce46bf0cf7328313c03ed61d5
R6R1_CHECKPOINT_BLOB=be1c55d4b7623041c338aca83194ec0b59a41dc8
R6R2E_RECONCILIATION_HELPER_BLOB=cb46e2bc949b4b71445de5c79180c5c05bd26c21
```

Accepted:

- username/password login route retired;
- stock `-cookies` / `-bduss` CLI Secret arguments forbidden;
- Cookie adapter reads only no-echo live console input;
- Cookie not in args/env/history/logs/Evidence;
- adapter rejects empty/CRLF/malformed BDUSS shape;
- adapter calls `pcsconfig.Config.SetupUserByBDUSS("", "", "", cookie)` directly;
- config `Save()` is after successful setup;
- fixed bounded output and reliable native nonzero failure;
- exact pinned upstream v4.0.2 provenance/build;
- temporary build cleanup;
- adapter binary hash provenance;
- no real Cookie/Baidu/Owner config action occurred.

Do not redesign the Go adapter or build helper in this repair unless a direct compatibility defect is proven.

## BLOCKING DEFECT 1 — POST-AUTH OWNER / ACL ORDER

The candidate Owner checkpoint currently does:

```text
adapter process exits
-> Assert-SafeBaiduConfigDirectory(...)
-> inspect pcs_config.json shape
```

The adapter is a child process running under the elevated Owner token and creates `pcs_config.json` through upstream `os.OpenFile(..., O_CREATE|O_RDWR, 0600)`.

R6R2D already proved the corresponding Windows behavior can create the child file with Builtin Administrators as Owner rather than the exact Owner SID. The strict R6R1 predicate requires exact Owner identity.

Therefore a semantically successful Cookie authentication can be rejected before the checkpoint has a chance to normalize the newly created file Owner/ACL.

The accepted R6R2E pattern is:

```text
exact post-write metadata/shape check
-> normalize exact pcs_config.json + root Owner/ACL
-> strict R6R1 predicate
```

The Cookie Owner checkpoint must use the same ordering.

## BLOCKING DEFECT 2 — FAILURE / PARTIAL-WRITE RECONCILIATION

The candidate checkpoint creates or accepts an empty config root before launching the adapter, but on adapter nonzero exit or a post-auth validation failure it does not reconcile state created by this run.

Possible bounded states include:

- root created this run, adapter fails before Save -> empty new root;
- pre-existing empty root, adapter fails before Save -> pre-existing root must remain;
- adapter reaches Save and then fails/returns nonzero -> exact `pcs_config.json` may exist and must not be left ambiguous;
- adapter exits 0 but post-auth shape/ACL verification fails -> run-created state must be reconciled only when exact provenance/shape is proven;
- unexpected extra/non-exact state -> preserve fail-closed; no blind cleanup.

Governance requires partial/ambiguous state reconciliation before retry.

## OBJECTIVE

Repair only the Owner checkpoint and its validator so real Cookie authentication can be attempted safely later.

No real Cookie, config, provider, or retained runtime binary action is allowed in this Executor round.

## REQUIRED PRE-RUN PROVENANCE

The Owner checkpoint must explicitly record:

- whether the canonical `%APPDATA%\BaiduPCS-Go` root existed before this run;
- whether it was accepted as pre-existing empty or created by this run;
- that `pcs_config.json` was absent before adapter execution.

Unknown/non-empty initial state remains fail-closed.

## REQUIRED SUCCESS PATH

After adapter native exit 0:

1. collect metadata only using the accepted R6R2E reconciliation primitives;
2. require exact canonical root + exactly one regular non-reparse `pcs_config.json`;
3. require bounded non-zero file size;
4. accept only the bounded pre-normalization Owner provenance already justified by R6R2E (current Owner SID or Builtin Administrators) and reject unexpected owners/extra entries/reparse;
5. before strict R6R1 validation, normalize exactly:
   - `pcs_config.json`;
   - canonical `BaiduPCS-Go` root;
   using the accepted `Set-OwnerOnlyAcl` constructor with current Owner SID;
6. then assert exact Owner-only ACL on file/root and run strict `Assert-SafeBaiduConfigDirectory`;
7. only after all of the above may checkpoint report `SETUP_SAVED`;
8. no `who` in this Gate/helper.

No config content may be read, parsed, copied, printed, or hashed by the Owner checkpoint.

## REQUIRED FAILURE RECONCILIATION

The checkpoint must have a production reconciliation function covered by filesystem fixtures.

If the attempt is not a proven success:

### Case A — no file produced

- pre-existing empty root -> preserve root, disposition `PRESERVED_PREEXISTING_EMPTY`;
- root created this run -> verify still empty, delete exact root non-recursively, disposition `REMOVED_EMPTY_NEW`.

### Case B — exact `pcs_config.json` produced this run

Because precondition proves the root was empty and the file absent before launch:

- first verify exact metadata-only single-file shape and allowed pre-normalization owner/ACL provenance;
- delete exactly `pcs_config.json`;
- if root pre-existed, preserve empty root;
- if root was created this run, verify empty then delete exact root non-recursively.

### Case C — unexpected/non-exact state

Extra entry, subdirectory, reparse, forbidden owner/ACE, metadata ambiguity, or failed proof:

- preserve state fail-closed;
- do not recursively delete;
- return a bounded `PRESERVED_UNPROVEN` / `ROLLBACK_FAILED` class;
- no retry is authorized until Reviewer reconciliation.

No failure branch may silently leave a run-created exact residue while reporting ordinary adapter failure.

## REQUIRED OWNER OUTPUT CONTRACT

Keep output bounded and Secret-free. At minimum:

```text
BAIDU_COOKIE_AUTH_CHECKPOINT=...
BAIDU_COOKIE_AUTH_FAILURE_CODE=...
BAIDU_COOKIE_AUTH_NATIVE_EXIT=...
BAIDU_COOKIE_AUTH_CONFIG_STATE=...
BAIDU_COOKIE_AUTH_CONFIG_DISPOSITION=...
BAIDU_COOKIE_AUTH_CONTENT_READ=NO
BAIDU_COOKIE_AUTH_WHO=NOT_RUN
BAIDU_COOKIE_AUTH_UID_EMITTED=NO
```

No account name, UID, Cookie/BDUSS/STOKEN, provider raw output, config content, SID, ACL detail, or Secret-derived hash.

## REQUIRED VALIDATION

Use the real production checkpoint reconciliation/normalization functions in fixtures, not only string assertions.

At minimum:

```text
R6R2H_R1_ADAPTER_CORE_FROZEN=PASS
R6R2H_R1_PREAUTH_EMPTY_ONLY=PASS
R6R2H_R1_POSTAUTH_EXACT_SHAPE_BEFORE_NORMALIZE=PASS
R6R2H_R1_POSTAUTH_ADMIN_OWNER_ACCEPTED_FOR_NORMALIZE=PASS
R6R2H_R1_POSTAUTH_UNEXPECTED_OWNER_REJECTED=PASS
R6R2H_R1_POSTAUTH_FILE_AND_ROOT_OWNER_ACL_NORMALIZED=PASS
R6R2H_R1_R6R1_STRICT_AFTER_NORMALIZE=PASS
R6R2H_R1_PREEXISTING_EMPTY_FAILURE_PRESERVED=PASS
R6R2H_R1_NEW_EMPTY_FAILURE_REMOVED=PASS
R6R2H_R1_PREEXISTING_ROOT_EXACT_FILE_FAILURE_FILE_ONLY=PASS
R6R2H_R1_NEW_ROOT_EXACT_FILE_FAILURE_FILE_AND_ROOT=PASS
R6R2H_R1_UNEXPECTED_STATE_PRESERVED=PASS
R6R2H_R1_NO_CONFIG_CONTENT_READ=PASS
R6R2H_R1_NO_BROAD_DELETE=PASS
R6R2H_R1_NO_WHO=PASS
R6R2H_R1_SECRET_BOUNDARIES_UNCHANGED=PASS
R6R2H_R1_FULL_R6R2H_REGRESSION=PASS
R6R1_ACL_REGRESSION=PASS
POWERSHELL_AST_PARSE=PASS
SECRET_SCAN=PASS
REAL_COOKIE_VALUES_USED=0
REAL_BAIDU_AUTH_ACTIONS=0
OWNER_CONFIG_READ=NO
OWNER_CONFIG_WRITE=NO
NETWORK_REQUESTS=0
STOP_AT_REVIEWER=YES
```

If local NTFS ACL writes are blocked by `SeSecurityPrivilege`, the exact ACL normalization plan/constructor may use the already accepted synthetic ACL method, but filesystem provenance/delete behavior must exercise the production reconciliation functions.

## EXECUTOR BOUNDARY

Offline only.

Forbidden:

- real Cookie/BDUSS/STOKEN;
- Owner browser or clipboard access;
- real Owner config read/write/delete;
- real Baidu auth/`who`/provider action;
- retained Owner runtime binary creation;
- Secret/DPAPI;
- VPS/SSH/Clash/service/route/proxy/TUN/live G4-B/G4-C.

## ALLOWED FILES

- `scripts/g4b-baidu-cookie-auth-owner-checkpoint.ps1`
- `scripts/validate-g4b-baidu-cookie-auth-adapter.ps1`
- this Gate;
- `EXECUTION_EVIDENCE.md`;
- `EXECUTOR_HANDOFF.md`.

Frozen:

- `scripts/g4b-baidu-cookie-auth-adapter/main.go`;
- `scripts/g4b-baidu-cookie-auth-adapter/main_test.go`;
- `scripts/build-g4b-baidu-cookie-auth-adapter.ps1`;
- accepted R6R1/R6R2A/R6R2E/R6R2E-R1 sources;
- `REVIEWER_HANDOFF.md`;
- unrelated files.

## STOP

`STOP_AT_REVIEWER=YES`
