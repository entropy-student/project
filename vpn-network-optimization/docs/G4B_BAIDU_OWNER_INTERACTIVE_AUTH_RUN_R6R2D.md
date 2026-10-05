# G4-B Baidu Owner Interactive Auth Run R6R2D

Status: ACTIVE / OWNER_LOCAL_AUTH

## GATE_ID

`G4B_BAIDU_OWNER_INTERACTIVE_AUTH_RUN_R6R2D`

## PREVIOUS_RESULT

`PASS_G4B_BAIDU_OWNER_INTERACTIVE_AUTH_HELPER_R6R2C`

## OBJECTIVE

Run the reviewed Owner-local no-argument interactive Baidu login checkpoint exactly once on the accepted Windows host. Authentication factors remain local to the live console. After login, the checkpoint validates the protected config ACL and performs one captured read-only `who` without emitting UID or raw `who` output.

## LOCKED SOURCE

```text
R6R2C_SOURCE_COMMIT=c7516042c9c2f4a6e373b9a35986c760d1583e89
INTERACTIVE_AUTH_HELPER_BLOB=cbf8c971567faea3b1735786827611861dafe52a
INTERACTIVE_AUTH_VALIDATOR_BLOB=4bf30c0629f8136f8a3eb6c4d8710d1c801472e7
R6R1_CHECKPOINT_BLOB=be1c55d4b7623041c338aca83194ec0b59a41dc8
R6R2A_UID_HELPER_BLOB=ba8502287989ecc8c9b003e67c729b6d82df378a
```

## OWNER SHELL

Use PowerShell 7.6.6 as Administrator / High integrity on the accepted Owner Windows host.

Before execution, verify the local helper blob equals the locked helper blob. If not, stop.

## AUTHENTICATION BOUNDARY

The helper launches exactly the pinned BaiduPCS-Go executable with one argument:

`login`

The Owner may type username, password, and any requested verification code only into the live local console prompts.

Do not paste authentication factors into chat/GitHub or place them in commands, flags, environment variables, files, screenshots, logs, or transcripts.

The interactive upstream flow is long-unmaintained and may fail. A failed attempt is not retried automatically.

## ALLOWED EFFECTS

- initialize the exact canonical config directory `%APPDATA%\BaiduPCS-Go` only when absent or safely empty;
- tighten only that exact config directory/subtree to the reviewed Owner-only ACL;
- download/verify/extract the pinned v4.0.2 binary into a temporary Owner-only runtime;
- perform one interactive no-argument login attempt;
- after login, validate config metadata/ACL/reparse/location;
- perform one captured read-only `who`;
- retain authenticated config only on proven success;
- preserve non-empty partial/unknown state fail-closed rather than deleting it;
- clean the bounded temporary runtime.

## FORBIDDEN

- cookie/BDUSS/STOKEN/PTOKEN/username/password CLI flags;
- credential-bearing environment variables;
- transcripts/tee/capture of the interactive login console;
- pasting provider/login output, username, password, verification codes, UID, cookies, or tokens into chat/GitHub;
- Baidu file upload/download/mkdir/mv/rm;
- VPS/SSH, DPAPI/Secret, Clash/service/route/proxy/TUN, live G4-B/G4-C.

## OWNER RETURN CONTRACT

During login the upstream program may print account/provider details. Do **not** copy that section.

After the checkpoint finishes, return only these final bounded markers:

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

## SUCCESS

Formal Owner checkpoint success requires:

```text
BAIDU_INTERACTIVE_AUTH=READY
BAIDU_INTERACTIVE_AUTH_FAILURE_CODE=NONE
BAIDU_INTERACTIVE_AUTH_RUNTIME_CLEANUP=PASS
BAIDU_INTERACTIVE_LOGIN_OUTPUT_CAPTURED=NO
BAIDU_WHO_RAW_OUTPUT_EMITTED=NO
BAIDU_UID_EMITTED=NO
```

and a safe config disposition/state consistent with this run.

If `FAIL_CLOSED` or `OWNER_ACTION_REQUIRED`, stop and return only the bounded markers. Do not retry or switch to Cookie/BDUSS login without a new Reviewer decision.

`STOP_AT_REVIEWER=YES`
