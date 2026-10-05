# G4-B Baidu Owner Secure Auth Run R6R2I-D4

Status: ACTIVE / OWNER_LOCAL_AUTH / ONE_SHOT

## GATE_ID

`G4B_BAIDU_OWNER_SECURE_AUTH_RUN_R6R2I_D4`

## PREVIOUS_RESULT

`PASS_G4B_BAIDU_OWNER_RETAINED_BUILD_RETRY_R6R2I_D3`

## ACCEPTED OWNER BUILD

```text
UPSTREAM_COMMIT=225bdd3b6cb298601c4d5ef7104c3e08cd1d692d
GO_VERSION=go1.27.1
GO_TOOLCHAIN_SHA256=a3911b5e0e1b1053f25ed0675f4c1c6aad1e2bfcf253df2b9be4caabd2edd95d
BUILD_TARGET=windows/amd64
ADAPTER_BINARY_SHA256=9d0fff1aec7015210ba421c67bff956bc360cc6121c8d70a226c9e0817da7367
OWNER_RUNTIME_BINARY=CREATED
GO_SOURCE_TESTS=PASS
NATIVE_FAILURE_EXIT_FIXTURE=PASS
TEMP_BUILD_CLEANUP=PASS
```

## OBJECTIVE

Run exactly one Owner-local secure authentication checkpoint using the already-retained, reviewed adapter binary. Do not rebuild in this Gate.

## LOCKED SOURCE

```text
D2_SOURCE_COMMIT=02ab19b52ff993a4a66827ad283614f38295f292
OWNER_CHECKPOINT_BLOB=8d0aded1b49aff58e06f5e7c450b8799737b3b68
ADAPTER_BINARY_SHA256=9d0fff1aec7015210ba421c67bff956bc360cc6121c8d70a226c9e0817da7367
```

## PRECONDITION

Before authentication, read-only prove:
- retained adapter exists as a regular non-reparse file;
- strict Owner-only ACL passes;
- SHA-256 equals the reviewed digest above.

If any precondition fails, stop before authentication.

## AUTH BOUNDARY

Run the reviewed Owner checkpoint exactly once against the retained adapter binary.

Authentication material:
- is entered only at the adapter's hidden local console prompt;
- never enters chat/GitHub;
- is not placed in command arguments, environment variables, clipboard automation, transcripts, logs, or ordinary files.

No second attempt is authorized by this Gate.

## SUCCESS CONTRACT

Success requires exactly these bounded markers:

```text
BAIDU_COOKIE_AUTH_CHECKPOINT=SETUP_SAVED
BAIDU_COOKIE_AUTH_FAILURE_CODE=NONE
BAIDU_COOKIE_AUTH_NATIVE_EXIT=0
BAIDU_COOKIE_AUTH_CONFIG_STATE=ABSENT_PREAUTH|PREEXISTING_EMPTY
BAIDU_COOKIE_AUTH_CONFIG_DISPOSITION=PRESERVED_AUTHENTICATED_CONFIG
BAIDU_COOKIE_AUTH_CONTENT_READ=NO
BAIDU_COOKIE_AUTH_WHO=NOT_RUN
BAIDU_COOKIE_AUTH_UID_EMITTED=NO
```

## FAILURE CONTRACT

On any non-success:
- stop;
- do not retry;
- do not manually edit/delete config or retained binary;
- return only the eight bounded checkpoint markers.

## FORBIDDEN

- rebuild;
- repeated auth attempt;
- provider `who` / UID discovery;
- provider file upload/download/mkdir/mv/rm;
- manual config edit;
- manual ACL repair;
- browser/clipboard automation;
- VPS/SSH/Clash/live G4-B/G4-C.

## OWNER RETURN CONTRACT

Return only the eight bounded checkpoint lines. Do not include provider raw output, account identity, UID, local paths, SID/ACL detail, or authentication material.

`STOP_AT_REVIEWER=YES`
