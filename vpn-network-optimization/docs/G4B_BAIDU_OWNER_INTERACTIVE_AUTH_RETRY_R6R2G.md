# G4-B Baidu Owner Interactive Auth Retry R6R2G

Status: ACTIVE / OWNER_LOCAL_AUTH / SINGLE_ATTEMPT

## GATE_ID

`G4B_BAIDU_OWNER_INTERACTIVE_AUTH_RETRY_R6R2G`

## PREVIOUS_RESULT

`PASS_G4B_BAIDU_OWNER_PARTIAL_CONFIG_RECONCILIATION_RUN_R6R2F`

## OBJECTIVE

Perform exactly one new Owner-local no-argument interactive Baidu login attempt using the repaired and reviewed helper after the prior failed-run residue has been fully reconciled back to the absent baseline.

This is a single retry only. It is not permission for repeated provider retries.

## LOCKED SOURCE

```text
R6R2F_RECONCILIATION_RESULT=PASS
RECONCILIATION_HELPER_BLOB=cb46e2bc949b4b71445de5c79180c5c05bd26c21
AUTH_HELPER_BLOB=e67197ee15ad4ce758ed2c624c80d69dfd4bb08a
AUTH_VALIDATOR_BLOB=f49abcb6073e6b9c048825e1caec777df9e8f530
R6R1_CHECKPOINT_BLOB=be1c55d4b7623041c338aca83194ec0b59a41dc8
R6R2A_UID_HELPER_BLOB=ba8502287989ecc8c9b003e67c729b6d82df378a
```

## OWNER SHELL

Use PowerShell 7.6.6 as Administrator / High integrity on the accepted Owner Windows host.

Before execution, verify the local auth helper blob equals the locked `AUTH_HELPER_BLOB`.

## PRECONDITION

R6R2F proved:

```text
BAIDU_PARTIAL_CONFIG_RECONCILIATION=PASS
BAIDU_PARTIAL_CONFIG_SHAPE=EXACT_FAILED_RUN_RESIDUE
BAIDU_PARTIAL_CONFIG_CONTENT_READ=NO
BAIDU_PARTIAL_CONFIG_ROLLBACK=REMOVED_EXACT_RESIDUE
BAIDU_PARTIAL_CONFIG_BASELINE_RESTORED=RESTORED
```

Therefore the previous ambiguous/partial config is fully reconciled and this attempt starts from the accepted absent baseline.

## AUTHENTICATION BOUNDARY

The helper launches only:

`BaiduPCS-Go.exe login`

with no credential-bearing CLI flags or environment variables.

The Owner may enter requested username/password/verification code only into the inherited live local console.

Do not copy provider/login prompts or authentication factors into chat/GitHub.

## HELPER BEHAVIOR

The repaired helper must:

- initialize only absent or safely empty config state;
- use the pinned BaiduPCS-Go v4.0.2 archive and fixed digest;
- perform exactly one interactive login process;
- after login, require exact config shape;
- normalize exact root + `pcs_config.json` Owner/ACL metadata;
- run strict accepted R6R1 config safety checks;
- if login exit is nonzero, run zero `who`;
- if login exit is zero, run exactly one captured read-only `who`;
- never emit UID or raw `who` output;
- on failed attempt, roll back only state proven created by this run, preserving any pre-existing empty root;
- clean bounded temporary runtime.

## SINGLE-ATTEMPT RULE

If the provider again returns 50052, another provider error, timeout, or any helper `FAIL_CLOSED` / `OWNER_ACTION_REQUIRED`:

- stop;
- do not rerun;
- do not switch to Cookie/BDUSS login;
- return only the bounded final markers.

## OWNER RETURN CONTRACT

During interactive login, do not copy the provider section.

After the checkpoint completes, return only:

```text
BAIDU_INTERACTIVE_AUTH=...
BAIDU_INTERACTIVE_AUTH_FAILURE_CODE=...
BAIDU_INTERACTIVE_AUTH_CONFIG_STATE=...
BAIDU_INTERACTIVE_AUTH_CONFIG_DISPOSITION=...
BAIDU_INTERACTIVE_AUTH_RUNTIME_CLEANUP=...
BAIDU_INTERACTIVE_LOGIN_OUTPUT_CAPTURED=NO
BAIDU_WHO_RAW_OUTPUT_EMITTED=NO
BAIDU_UID_EMITTED=NO
OWNER_REMINDER=...
```

If the provider visibly shows a non-secret numeric error code such as 50052, the Owner may additionally report only that code and its generic class/message, with no account/provider identity details.

## SUCCESS

Success requires:

```text
BAIDU_INTERACTIVE_AUTH=READY
BAIDU_INTERACTIVE_AUTH_FAILURE_CODE=NONE
BAIDU_INTERACTIVE_AUTH_RUNTIME_CLEANUP=PASS
BAIDU_INTERACTIVE_LOGIN_OUTPUT_CAPTURED=NO
BAIDU_WHO_RAW_OUTPUT_EMITTED=NO
BAIDU_UID_EMITTED=NO
```

with safe config disposition/state.

A successful R6R2G proves authenticated config readiness but does not yet prove the expected account UID match. The next step after success is a separate Owner-local UID discovery / identity-correlation checkpoint.

`STOP_AT_REVIEWER=YES`
