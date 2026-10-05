# G4-B Baidu Secure Auth + Owner Checkpoint Combined Repair R6R2H-R2

Status: ACTIVE / EXECUTOR_OFFLINE_ONLY

## GATE_ID

`G4B_BAIDU_SECURE_AUTH_OWNER_COMBINED_REPAIR_R6R2H_R2`

## PREVIOUS_RESULT

`RETURN_R6R2H_REREVIEW_ADAPTER_PARSE_AND_PREFLIGHT_ORDER_GAP`

## SUPERSEDES

This Gate supersedes the unexecuted:
`G4B_BAIDU_SECURE_COOKIE_OWNER_CHECKPOINT_REPAIR_R6R2H_R1`.

R6R2H-R1 was directionally correct on post-write ACL normalization and provenance-aware rollback, but a fresh Reviewer re-review found two additional pre-real-run defects. Do not execute the older R6R2H-R1 relay.

## ACCEPTED / FROZEN

Keep these accepted properties:

- exact pinned upstream v4.0.2 source/build provenance;
- no-echo live-console secret input;
- secret absent from process args, environment, command history, ordinary logs/Evidence;
- empty/CRLF/oversize input rejection;
- setup/save ordering;
- reliable native nonzero failure;
- temporary build cleanup;
- no real provider or Owner-config action occurred.

Freeze:
- `scripts/build-g4b-baidu-cookie-auth-adapter.ps1`;
- accepted R6R1/R6R2A/R6R2E/R6R2E-R1 helpers;
- unrelated project files.

## DEFECT A — EXACT FIELD PARSE / UPSTREAM SECOND PARSE AMBIGUITY

The candidate adapter validates an exact semicolon-delimited `BDUSS=` field, but then calls:

`pcsconfig.Config.SetupUserByBDUSS("", "", "", cookie)`

The pinned upstream path re-parses the entire Cookie string with an unanchored `BDUSS=(.+?);` search when the explicit first argument is empty.

A synthetic string such as:

`OTHER=prefixBDUSS=fixture-wrong; BDUSS=fixture-right;`

can pass the adapter's exact-field validation while the upstream unanchored search would encounter the earlier substring first.

No real credential is needed to reproduce this parser mismatch.

### Required repair

- parse the exact semicolon-delimited field inside the adapter;
- return the exact validated field value to the call site;
- reject missing, duplicate, empty, unterminated, CR/LF or control-character value shapes as before;
- pass that parsed value explicitly:
  `pcsconfig.Config.SetupUserByBDUSS(parsedValue, "", "", cookie)`
- thereby skip the upstream whole-string secondary extraction;
- keep the full Cookie only for the upstream stored-session semantics;
- do not print/hash/log either value;
- clear mutable byte buffers where practical; immutable strings remain process-local and die with process exit.

Add a synthetic negative/ambiguity regression proving an earlier non-field substring cannot override the exact field value.

## DEFECT B — PREFLIGHT ORDER BEFORE HOST WRITE

The candidate Owner checkpoint can create the canonical config root before validating the adapter binary path/ACL/hash.

Governance requires source/candidate/runtime identity preflight before host-local mutation.

### Required order

Before creating or changing the canonical config root:

1. prove PowerShell/runtime compatibility required by the accepted Owner shell contract;
2. prove effective Owner/admin execution property with the accepted target-compatible method;
3. resolve Owner SID and safe canonical config path without writing;
4. resolve adapter path;
5. prove adapter is outside the project tree, is a regular non-reparse file, has accepted Owner-only ACL, and exact expected binary digest;
6. only then classify/create the config root.

A failed binary/runtime preflight must cause zero config mutation.

## DEFECT C — POST-WRITE ACL NORMALIZATION

Preserve the accepted R6R2H-R1 repair requirement:

native exit 0
-> metadata-only exact root + single regular `pcs_config.json` proof
-> bounded non-zero size
-> pre-normalization Owner provenance limited to current Owner or Builtin Administrators
-> normalize exact file and root using accepted `Set-OwnerOnlyAcl`
-> `Assert-OwnerOnlyAcl`
-> strict `Assert-SafeBaiduConfigDirectory`
-> only then `SETUP_SAVED`.

Do not read/parse/copy/hash/print config content.

## DEFECT D — FAILURE / PARTIAL-WRITE RECONCILIATION

Record before launch:
- whether root pre-existed;
- whether it was accepted pre-existing empty or created this run;
- exact config file absent before launch.

Any non-proven-success path must reconcile using production functions:

### No file produced
- pre-existing empty root -> preserve;
- run-created empty root -> verify empty and non-recursively delete exact root.

### Exact file produced this run
- require metadata-only exact single-file shape and allowed pre-normalization owner/ACL provenance;
- pre-existing root -> delete exact file only, preserve root;
- run-created root -> delete exact file, verify empty, delete exact root.

### Unexpected/unproven state
Preserve fail-closed; no broad/recursive cleanup and no retry authorization.

This applies even if failure occurs after root creation but before child-process start.

## OUTPUT CONTRACT

At minimum, bounded/non-secret only:

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

No account identity, UID, secret material, provider raw output, config content, SID/ACL detail, or secret-derived hash.

## REQUIRED VALIDATION

Use production functions for filesystem provenance/rollback behavior.

At minimum:

```text
R6R2H_R2_PINNED_BUILD_CHAIN_FROZEN=PASS
R6R2H_R2_EXACT_FIELD_VALUE_PARSED=PASS
R6R2H_R2_UPSTREAM_SECOND_PARSE_BYPASSED=PASS
R6R2H_R2_AMBIGUOUS_SUBSTRING_FIXTURE=PASS
R6R2H_R2_SECRET_BOUNDARIES_UNCHANGED=PASS
R6R2H_R2_RUNTIME_PREFLIGHT_BEFORE_CONFIG_WRITE=PASS
R6R2H_R2_BINARY_IDENTITY_BEFORE_CONFIG_WRITE=PASS
R6R2H_R2_BINARY_PREFLIGHT_FAILURE_ZERO_CONFIG_MUTATION=PASS
R6R2H_R2_PREAUTH_EMPTY_ONLY=PASS
R6R2H_R2_POSTAUTH_EXACT_SHAPE_BEFORE_NORMALIZE=PASS
R6R2H_R2_POSTAUTH_ADMIN_OWNER_ACCEPTED_FOR_NORMALIZE=PASS
R6R2H_R2_POSTAUTH_UNEXPECTED_OWNER_REJECTED=PASS
R6R2H_R2_FILE_AND_ROOT_OWNER_ACL_NORMALIZED=PASS
R6R2H_R2_R6R1_STRICT_AFTER_NORMALIZE=PASS
R6R2H_R2_PREEXISTING_EMPTY_FAILURE_PRESERVED=PASS
R6R2H_R2_NEW_EMPTY_FAILURE_REMOVED=PASS
R6R2H_R2_PREEXISTING_ROOT_EXACT_FILE_FAILURE_FILE_ONLY=PASS
R6R2H_R2_NEW_ROOT_EXACT_FILE_FAILURE_FILE_AND_ROOT=PASS
R6R2H_R2_UNEXPECTED_STATE_PRESERVED=PASS
R6R2H_R2_NO_CONFIG_CONTENT_READ=PASS
R6R2H_R2_NO_BROAD_DELETE=PASS
R6R2H_R2_NO_WHO=PASS
R6R2H_R2_FAILURE_NATIVE_EXIT_NONZERO=PASS
R6R2H_R2_CONFIG_SAVE_ONLY_AFTER_SETUP_SUCCESS=PASS
R6R2H_R2_FULL_R6R2H_REGRESSION=PASS
R6R1_ACL_REGRESSION=PASS
POWERSHELL_AST_PARSE=PASS
GO_SOURCE_TESTS=PASS
GO_SOURCE_STATIC_VALIDATION=PASS
SECRET_SCAN=PASS
REAL_COOKIE_VALUES_USED=0
REAL_BAIDU_AUTH_ACTIONS=0
OWNER_CONFIG_READ=NO
OWNER_CONFIG_WRITE=NO
NETWORK_REQUESTS_TO_PROVIDER=0
STOP_AT_REVIEWER=YES
```

If NTFS ACL fixture writes are privilege-blocked, the accepted synthetic ACL technique may validate the exact normalization plan/constructor; filesystem provenance/delete tests must still exercise production functions.

## EXECUTOR BOUNDARY

Offline with respect to Owner/provider state.

Allowed:
- project source mutation within allowed files;
- synthetic fixtures;
- public source/toolchain/module access only if required to rebuild the already-pinned adapter candidate.

Forbidden:
- real authentication material;
- browser/clipboard acquisition;
- Owner real config read/write/delete;
- real provider auth or `who`;
- retained Owner runtime binary creation;
- Secret/DPAPI;
- VPS/SSH/Clash/service/route/proxy/TUN/live G4-B/G4-C.

## ALLOWED FILES

- `scripts/g4b-baidu-cookie-auth-adapter/main.go`
- `scripts/g4b-baidu-cookie-auth-adapter/main_test.go`
- `scripts/g4b-baidu-cookie-auth-owner-checkpoint.ps1`
- `scripts/validate-g4b-baidu-cookie-auth-adapter.ps1`
- this Gate;
- `EXECUTION_EVIDENCE.md`;
- `EXECUTOR_HANDOFF.md`.

Frozen:
- `scripts/build-g4b-baidu-cookie-auth-adapter.ps1`;
- accepted R6R1/R6R2A/R6R2E/R6R2E-R1 sources;
- `REVIEWER_HANDOFF.md`;
- unrelated project files.

## STOP

`STOP_AT_REVIEWER=YES`
