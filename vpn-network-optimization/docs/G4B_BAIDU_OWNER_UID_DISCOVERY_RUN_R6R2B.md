# G4-B Baidu Owner UID Discovery Run R6R2B

Status: ACTIVE / OWNER_LOCAL_READ_ONLY

## GATE_ID

`G4B_BAIDU_OWNER_UID_DISCOVERY_RUN_R6R2B`

## PREVIOUS_RESULT

`PASS_G4B_BAIDU_OWNER_UID_DISCOVERY_HELPER_R6R2A`

## OBJECTIVE

Run the reviewed UID discovery helper exactly once on the real Owner Windows host to learn the currently authenticated Baidu numeric UID locally. The UID must remain Owner-local and is used only as the expected identity input for the later R6R2 authentication-readiness checkpoint.

## LOCKED SOURCE

```text
R6R2A_SOURCE_COMMIT=2383211efed12988ebf2742e5ab1150d76ea14c3
UID_HELPER_BLOB=ba8502287989ecc8c9b003e67c729b6d82df378a
UID_VALIDATOR_BLOB=d750c0e665cdfe896e9728a499aad88c77454274
R6R1_CHECKPOINT_BLOB=be1c55d4b7623041c338aca83194ec0b59a41dc8
R6R1_VALIDATOR_BLOB=891d2eaf981962d2241ec008877b8188dc150dee
```

## OWNER SHELL

Use PowerShell 7.6.6 as Administrator / High integrity on the accepted Owner Windows host. The wrapper must verify the helper blob before running it.

## ALLOWED REAL ACTIONS

The helper may:

- inspect the selected BaiduPCS-Go config metadata/ACL/reparse/location through the accepted R6R1 predicate;
- download only the pinned BaiduPCS-Go v4.0.2 archive if needed by the helper;
- verify the fixed SHA-256 before archive use;
- create an Owner-only temporary runtime;
- invoke exactly one read-only `who`;
- parse one numeric UID internally;
- display that numeric UID only on the Owner-local console after successful runtime cleanup;
- remove the temporary runtime.

## FORBIDDEN

- `login`;
- any credential/cookie/token/password/BDUSS/STOKEN input or output;
- provider raw stdout/stderr disclosure;
- username disclosure;
- config-content print/copy;
- Baidu file upload/download/mkdir/mv/rm;
- UID pasted into chat/GitHub/Evidence;
- VPS/SSH, DPAPI/Secret, Clash/service/route/proxy/TUN, live G4-B/G4-C.

## OWNER RETURN CONTRACT

Owner does **not** paste `BAIDU_OWNER_LOCAL_UID=<number>`.

Return only these sanitized markers:

```text
BAIDU_UID_DISCOVERY=...
BAIDU_UID_NOT_FOR_CHAT_OR_GITHUB=YES   # only when READY
BAIDU_UID_FAILURE_CODE=...
BAIDU_UID_RUNTIME_CLEANUP=...
OWNER_REMINDER=...
```

For Reviewer purposes, state separately only whether the UID was displayed locally: `UID_DISPLAYED_LOCALLY=YES|NO`. Do not include the numeric value.

## SUCCESS

Success requires:

```text
BAIDU_UID_DISCOVERY=READY
UID_DISPLAYED_LOCALLY=YES
BAIDU_UID_NOT_FOR_CHAT_OR_GITHUB=YES
BAIDU_UID_FAILURE_CODE=NONE
BAIDU_UID_RUNTIME_CLEANUP=PASS
```

Then stop at Reviewer. Do not automatically run R6R2.

If `OWNER_ACTION_REQUIRED` or `FAIL_CLOSED`, stop and return only the sanitized markers.

`STOP_AT_REVIEWER=YES`
