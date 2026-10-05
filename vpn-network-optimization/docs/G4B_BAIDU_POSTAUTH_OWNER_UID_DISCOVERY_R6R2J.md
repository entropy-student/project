# G4-B Baidu Post-Auth Owner UID Discovery R6R2J

Status: ACTIVE / OWNER_LOCAL_READ_ONLY / ONE_SHOT

## GATE_ID

`G4B_BAIDU_POSTAUTH_OWNER_UID_DISCOVERY_R6R2J`

## PREVIOUS_RESULT

`PASS_G4B_BAIDU_CONSOLE_OUTPUT_VERIFY_R6R2I_D5_R1`

## ACCEPTED / FROZEN

```text
BAIDU_AUTH_STATE=PASS
AUTHENTICATED_CONFIG=ACCEPTED_FROZEN
D5_OUTPUT_REPAIR=PASS
D5_R1_COMPILED_VERIFY=PASS
UID_HELPER_BLOB=ba8502287989ecc8c9b003e67c729b6d82df378a
UID_VALIDATOR_BLOB=d750c0e665cdfe896e9728a499aad88c77454274
```

The authenticated config must not be recreated, manually edited, copied, printed, deleted, or exposed.

## OBJECTIVE

Use the already authenticated Owner-local BaiduPCS-Go config to run exactly one read-only `who` through the previously reviewed UID-discovery helper.

The purpose is to establish the expected numeric account identity locally before any real recovery-object upload/download action.

## OWNER SHELL

PowerShell 7.6.6, Administrator / High integrity, on the accepted Owner Windows host.

The wrapper must verify the helper blob before execution.

## ALLOWED REAL ACTIONS

Exactly one Owner-local UID discovery checkpoint may:

- inspect config metadata/ACL/location through the accepted predicate;
- download/verify the already pinned BaiduPCS-Go v4.0.2 archive into an Owner-only temporary runtime if needed;
- invoke exactly one read-only `who`;
- parse the numeric UID locally;
- display the numeric UID only on the Owner-local console;
- remove the temporary runtime.

## FORBIDDEN

- authentication/login/re-authentication;
- authentication material input/output;
- config-content print/copy;
- provider upload/download/mkdir/mv/rm;
- UID in chat/GitHub/Evidence;
- VPS/SSH;
- Secret/recovery plaintext access;
- Clash/service/route/proxy/TUN changes;
- live G4-B deployment or G4-C workload.

## OWNER RETURN CONTRACT

Do **not** return the numeric UID.

Return only:

```text
BAIDU_UID_DISCOVERY=...
UID_DISPLAYED_LOCALLY=YES|NO
BAIDU_UID_NOT_FOR_CHAT_OR_GITHUB=...
BAIDU_UID_FAILURE_CODE=...
BAIDU_UID_RUNTIME_CLEANUP=...
OWNER_REMINDER=...
```

## SUCCESS

```text
BAIDU_UID_DISCOVERY=READY
UID_DISPLAYED_LOCALLY=YES
BAIDU_UID_NOT_FOR_CHAT_OR_GITHUB=YES
BAIDU_UID_FAILURE_CODE=NONE
BAIDU_UID_RUNTIME_CLEANUP=PASS
```

On success, stop at Reviewer. Do not begin recovery upload automatically.

On any failure or ambiguity, do not retry; return only the sanitized markers.

`STOP_AT_REVIEWER=YES`
