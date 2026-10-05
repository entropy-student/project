# G4-B Baidu Owner Console Output Contract Repair R6R2I-D5

Status: ACTIVE / EXECUTOR_OFFLINE_ONLY

## GATE_ID

`G4B_BAIDU_OWNER_CONSOLE_OUTPUT_REPAIR_R6R2I_D5`

## PREVIOUS_RESULT

`PASS_AUTH_STATE_RETURN_D4_EXTRA_ADAPTER_MARKERS`

## ACCEPTED OWNER AUTH STATE

The real Owner authentication attempt is accepted as successful and MUST NOT be repeated.

Accepted bounded checkpoint state:

```text
BAIDU_COOKIE_AUTH_CHECKPOINT=SETUP_SAVED
BAIDU_COOKIE_AUTH_FAILURE_CODE=NONE
BAIDU_COOKIE_AUTH_NATIVE_EXIT=0
BAIDU_COOKIE_AUTH_CONFIG_STATE=ABSENT_PREAUTH
BAIDU_COOKIE_AUTH_CONFIG_DISPOSITION=PRESERVED_AUTHENTICATED_CONFIG
BAIDU_COOKIE_AUTH_CONTENT_READ=NO
BAIDU_COOKIE_AUTH_WHO=NOT_RUN
BAIDU_COOKIE_AUTH_UID_EMITTED=NO
```

The authenticated config is now an accepted real Owner artifact. Do not read its content, rewrite it, delete it, or re-authenticate.

## BLOCKING DEFECT

The Owner checkpoint's eight-marker contract is correct, but the child adapter also writes bounded status markers directly to the inherited console. On successful authentication this caused two extra visible lines before the checkpoint's eight lines.

This is a reviewability/output-contract defect only. It does not invalidate the successful authenticated config.

## OBJECTIVE

Repair only the child/Owner console-output boundary so a future execution of the reviewed checkpoint presents the interactive hidden prompt but emits only the Owner checkpoint's eight bounded final markers.

Do not change authentication semantics, config semantics, ACL semantics, rollback semantics, or the accepted real Owner config.

## REQUIRED DESIGN

Use a narrow output-boundary repair. Acceptable approaches include:

1. make the adapter interactive prompt remain visible while all adapter status output is suppressed/consumed by the Owner checkpoint; or
2. make the adapter itself emit no final/status markers and rely on native exit + Owner checkpoint markers.

Whichever approach is chosen must:

- preserve hidden local input;
- preserve nonzero native exit on failure;
- prevent adapter success/failure status lines from escaping into the Owner console;
- leave exactly the eight Owner checkpoint markers as the only final status contract;
- not expose raw exception/provider/auth/config content;
- not pass authentication material via args/env/logs.

If adapter source output behavior changes, update only the minimal native fixture needed to prove exit semantics; do not alter parsing/setup/save behavior.

## REQUIRED VALIDATION

Offline only with synthetic/non-secret fixtures.

At minimum:

```text
R6R2I_D5_AUTH_LOGIC_FROZEN=PASS
R6R2I_D5_HIDDEN_INPUT_PATH_PRESERVED=PASS
R6R2I_D5_ADAPTER_STATUS_CONSOLE_LEAK_BLOCKED=PASS
R6R2I_D5_OWNER_EIGHT_MARKER_CONTRACT_EXACT=PASS
R6R2I_D5_SUCCESS_PATH_NO_DUPLICATE_MARKERS=PASS
R6R2I_D5_FAILURE_PATH_NO_CHILD_MARKERS=PASS
R6R2I_D5_NATIVE_NONZERO_EXIT_PRESERVED=PASS
R6R2I_D5_NO_REAL_OWNER_CONFIG_ACCESS=PASS
R6R2I_D5_NO_REAL_AUTH_RETRY=PASS
R6R2I_D5_FULL_R6R2H_R3_REGRESSION=PASS
POWERSHELL_AST_PARSE=PASS
GO_SOURCE_TESTS=PASS
SECRET_SCAN=PASS
REAL_AUTH_ACTIONS=0
OWNER_CONFIG_READ=NO
OWNER_CONFIG_WRITE=NO
PROVIDER_REQUESTS=0
STOP_AT_REVIEWER=YES
```

## ALLOWED FILES

- `scripts/g4b-baidu-cookie-auth-adapter/main.go` only if required for output-only behavior;
- `scripts/g4b-baidu-cookie-auth-adapter/main_test.go` only if required for output-only behavior;
- `scripts/g4b-baidu-cookie-auth-owner-checkpoint.ps1`;
- `scripts/build-g4b-baidu-cookie-auth-adapter.ps1` only if its native fixture must be updated to the new bounded output behavior;
- `scripts/validate-g4b-baidu-cookie-auth-adapter.ps1`;
- this Gate for implementation note only;
- `EXECUTION_EVIDENCE.md`;
- `EXECUTOR_HANDOFF.md`.

Frozen:
- authentication parsing/setup/save semantics;
- R6R1 ACL helper;
- authenticated Owner config;
- retained real Owner binary/runtime state;
- `REVIEWER_HANDOFF.md`;
- unrelated files.

## EXECUTOR BOUNDARY

Strictly offline.

Forbidden:
- real authentication;
- real Owner config read/write/delete;
- real retained runtime binary replacement/removal;
- provider who/file operations;
- browser/clipboard;
- VPS/SSH/Clash/live G4-B/G4-C.

## STOP

`STOP_AT_REVIEWER=YES`
