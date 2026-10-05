# G4-B Baidu UID Parser Repair R6R2J-R1

Status: ACTIVE / EXECUTOR_OFFLINE_ONLY

## GATE_ID

`G4B_BAIDU_UID_PARSER_REPAIR_R6R2J_R1`

## PREVIOUS_RESULT

`RETURN_R6R2J_BAIDU_UID_OUTPUT_AMBIGUOUS`

## OWNER RESULT

```text
BAIDU_UID_DISCOVERY=FAIL_CLOSED
BAIDU_UID_FAILURE_CODE=BAIDU_UID_OUTPUT_AMBIGUOUS
BAIDU_UID_RUNTIME_CLEANUP=PASS
UID_DISPLAYED_LOCALLY=NO
```

No retry is authorized in this Gate.

## DIAGNOSIS

The existing discovery parser is stricter than the pinned upstream v4.0.2 `who` identity contract and stricter than the already accepted readiness parser.

Pinned upstream v4.0.2 emits its account identity as exactly one canonical stdout line beginning:

`当前帐号 uid: <numeric>, ...`

The discovery helper currently counts every generic `uid` mention across stdout/stderr and rejects when that count exceeds one. This can create a false ambiguity even when exactly one canonical account-identity line is present.

The real provider stdout/stderr must not be persisted, printed, copied into GitHub, or requested from Owner.

## OBJECTIVE

Repair only `Resolve-BaiduUidDiscoveryOutcome` and its validator so identity is derived from the canonical pinned `who` line instead of generic `uid` token counts.

## REQUIRED PARSER CONTRACT

For exit code 0:

- exactly one canonical stdout identity line matching `(?m)^当前帐号 uid:\s*([0-9]+),` -> candidate UID;
- more than one canonical identity line -> `FAIL_CLOSED / BAIDU_UID_OUTPUT_AMBIGUOUS`;
- zero canonical identity lines:
  - if stdout/stderr contains an identity-like UID indication, fail closed as ambiguous;
  - otherwise return `OWNER_ACTION_REQUIRED`;
- candidate UID must be non-zero decimal and fit the existing bounded numeric contract;
- generic/non-canonical `uid` text outside a second canonical identity line must not by itself invalidate one unique canonical identity.

For nonzero native exit:

- preserve the already accepted readiness behavior: no READY result; return bounded non-success without exposing raw output.

## REQUIRED FIXTURES

At minimum prove:

```text
UID_SINGLE_CANONICAL_LINE=PASS
UID_SINGLE_CANONICAL_PLUS_GENERIC_UID_TEXT=PASS
UID_DUPLICATE_CANONICAL_LINES_REJECTED=PASS
UID_ZERO_CANONICAL_WITH_IDENTITY_LIKE_TEXT_REJECTED=PASS
UID_ZERO_CANONICAL_NO_IDENTITY_TEXT_OWNER_ACTION=PASS
UID_NONZERO_NATIVE_EXIT_NOT_READY=PASS
UID_NUMERIC_BOUNDS=PASS
UID_RAW_PROVIDER_OUTPUT_NOT_EMITTED=PASS
UID_USERNAME_NOT_EMITTED=PASS
UID_HELPER_TEMP_CLEANUP_REGRESSION=PASS
UID_HELPER_READ_ONLY_WHO_ONLY=PASS
POWERSHELL_AST_PARSE=PASS
SECRET_SCAN=PASS
REAL_AUTH_ACTIONS=0
OWNER_CONFIG_READ=NO
OWNER_CONFIG_WRITE=NO
PROVIDER_REQUESTS=0
STOP_AT_REVIEWER=YES
```

## ALLOWED FILES

- `scripts/g4b-baidu-uid-discovery-checkpoint.ps1`
- `scripts/g4b-baidu-uid-discovery-validator.ps1`
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Frozen:

- authenticated Owner config;
- all authentication adapter/checkpoint sources;
- live runner;
- retained Owner runtime binary;
- `REVIEWER_HANDOFF.md`;
- unrelated files.

## FORBIDDEN

- real `who` invocation;
- authentication/re-authentication;
- reading or changing real Owner config;
- provider upload/download/mkdir/mv/rm;
- UID/raw provider output in GitHub/chat/logs;
- VPS/SSH/Clash/service/network changes.

## STOP

`STOP_AT_REVIEWER=YES`
