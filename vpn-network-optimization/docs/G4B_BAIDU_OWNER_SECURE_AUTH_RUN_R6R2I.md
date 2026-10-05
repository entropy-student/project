# G4-B Baidu Owner Secure Auth Run R6R2I

Status: ACTIVE / OWNER_LOCAL_AUTH / ONE_SHOT

## GATE_ID

`G4B_BAIDU_OWNER_SECURE_AUTH_RUN_R6R2I`

## PREVIOUS_RESULT

`PASS_G4B_BAIDU_OWNER_OUTPUT_CONTRACT_REPAIR_R6R2H_R3`

## OBJECTIVE

Perform exactly one Owner-local authenticated-config setup attempt using the reviewed retained adapter binary and Owner checkpoint, without exposing authentication material to chat/GitHub/logs or command arguments/environment variables.

## LOCKED SOURCE

```text
R6R2H_R3_SOURCE_COMMIT=0474fe6b68211ce602beaa55cb9dc9786084e694
OWNER_CHECKPOINT_BLOB=8d0aded1b49aff58e06f5e7c450b8799737b3b68
VALIDATOR_BLOB=62c2d6819d26d9a35d1ccbced23058809c0328b6
ADAPTER_BINARY_SHA256=9d0fff1aec7015210ba421c67bff956bc360cc6121c8d70a226c9e0817da7367
BUILD_HELPER_BLOB=7f369604de3cf0cce46bf0cf7328313c03ed61d5
```

## OWNER SHELL

PowerShell 7.6.6, Administrator, High integrity, accepted Windows Owner host.

## PRECONDITION / BUILD

Use the frozen build helper once with its reviewed retained-binary mode. The helper must:

- fetch/build only the pinned public source/toolchain/module inputs;
- verify the pinned upstream identities;
- produce the exact reviewed Windows amd64 adapter digest;
- retain it only at the reviewed Owner-only runtime path;
- report temp build cleanup PASS.

If build/provenance fails, stop before auth.

## AUTH BOUNDARY

Run the reviewed Owner checkpoint exactly once against the retained adapter binary.

Authentication material:
- is entered only into the adapter's hidden local console prompt;
- is never pasted into chat/GitHub;
- is not passed via command-line arguments/environment variables/history/logs.

No second attempt is authorized by this Gate.

## CHECKPOINT SUCCESS

Success requires all bounded markers:

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

If any failure:
- stop;
- do not retry;
- preserve/rollback only according to the reviewed checkpoint result;
- return the eight bounded markers to Reviewer.

## TEMP RUNTIME BINARY

After checkpoint completes, do not manually remove or modify the retained adapter binary unless a later reviewed cleanup Gate/checkpoint authorizes it. Its path/value must not be pasted into chat if it contains identity-bearing local path data.

## FORBIDDEN

- authentication material in chat/GitHub/CLI args/env/logs/transcripts;
- browser/clipboard automation;
- repeated attempts;
- stock credential-bearing CLI flags;
- manual config editing;
- provider file upload/download/mkdir/mv/rm;
- who/UID discovery in this Gate;
- VPS/SSH/Clash/network runtime/live G4-B/G4-C.

## OWNER RETURN CONTRACT

Return only the eight bounded checkpoint lines above. Do not return provider raw output or authentication material.

`STOP_AT_REVIEWER=YES`
