# G4-B Baidu Owner Auth Readiness Run R6R2

Status: ACTIVE / OWNER_LOCAL_READ_ONLY

## GATE_ID

`G4B_BAIDU_OWNER_AUTH_READINESS_RUN_R6R2`

## PREVIOUS_RESULT

`PASS_G4B_BAIDU_OWNER_AUTH_READINESS_ACL_REPAIR_R6R1`

## OBJECTIVE

Run the reviewed Owner-local Baidu authentication-readiness checkpoint once on the real Owner Windows host to determine whether the selected BaiduPCS-Go config is already authenticated to the intended account.

This Gate is **read-only readiness proof**. It does not authorize login, upload, recovery publication, VPS mutation, Clash/profile mutation, persistent REALITY deployment, or live G4-B.

## LOCKED SOURCE

```text
R6R1_FINAL_COMMIT=a13c0c76e9a3a5051848db78615fadbf12506d9b
CHECKPOINT_BLOB=be1c55d4b7623041c338aca83194ec0b59a41dc8
VALIDATOR_BLOB=891d2eaf981962d2241ec008877b8188dc150dee
R6R1_GATE_BLOB=3cdfec9d1a82d84da8f0384d0eeb7ff1fdfe62d0
```

Before execution, verify the current local checkpoint file matches the locked checkpoint blob or safe-sync to canonical GitHub `main` and verify again. Unrelated repository commits are acceptable only if the VPN checkpoint blob remains exact.

## OWNER CHECKPOINT BOUNDARY

Owner executes exactly the reviewed checkpoint:

`vpn-network-optimization/scripts/g4b-baidu-auth-readiness-checkpoint.ps1`

Allowed behavior:

- inspect the selected BaiduPCS-Go config tree metadata/ACL/reparse/location only;
- use a locally supplied pinned archive, or download the exact reviewed BaiduPCS-Go v4.0.2 archive from the reviewed GitHub release URL;
- verify the fixed SHA-256 before opening/extracting the archive;
- create a temporary Owner-only runtime;
- invoke exactly one read-only BaiduPCS-Go `who`;
- parse UID only in memory and compare with the Owner-local expected numeric UID;
- emit only bounded sanitized markers;
- delete the temporary runtime.

Not authorized:

- CLI `login`;
- browser/cookie credential extraction;
- BDUSS/STOKEN/password/token/cookie input to chat, GitHub, logs, environment, or process arguments;
- upload/download of Owner files, mkdir/mv/rm on Baidu Netdisk;
- config-content printing/copying;
- VPS/SSH;
- DPAPI/Secret access;
- Clash/service/route/proxy/TUN mutation;
- persistent REALITY/profile writes;
- G4-C.

## OWNER INPUT

The expected Baidu numeric UID is treated as an Owner-local identity value. Do not paste it into chat or GitHub. Collect it locally with `Read-Host` and pass it only to the reviewed checkpoint in the same PowerShell session.

No credential value is requested or accepted.

## ACCEPTED OWNER SHELL

Use the already accepted Owner Windows checkpoint shell:

```text
PowerShell=7.6.6
Administrator=YES
HighIntegrity=YES
```

If these facts no longer hold, stop and return the sanitized mismatch rather than improvising.

## SANITIZED OUTPUT CONTRACT

Return only the checkpoint's bounded markers:

```text
BAIDU_AUTH_READINESS=...
BAIDU_FAILURE_CODE=...
BAIDU_LOGIN_READY=...
BAIDU_ACCOUNT_MATCH=...
BAIDU_PROVIDER_MUTATION=NO
BAIDU_RAW_PROVIDER_OUTPUT_EMITTED=NO
BAIDU_UID_EMITTED=NO
BAIDU_TEMP_RUNTIME_CLEANUP=...
```

Never return the UID, provider stdout/stderr, config content, credentials, cookie/token values, local private paths containing identity data, or hashes of credential material.

## DECISION

### Success

Only if all are true:

```text
BAIDU_AUTH_READINESS=READY
BAIDU_FAILURE_CODE=NONE
BAIDU_LOGIN_READY=YES
BAIDU_ACCOUNT_MATCH=YES
BAIDU_PROVIDER_MUTATION=NO
BAIDU_RAW_PROVIDER_OUTPUT_EMITTED=NO
BAIDU_UID_EMITTED=NO
BAIDU_TEMP_RUNTIME_CLEANUP=PASS
```

then stop and return to Reviewer. This proves only the authenticated-config readiness boundary.

### Owner action required

If:

`BAIDU_AUTH_READINESS=RETURN_OWNER_ACTION_REQUIRED`

stop. Do **not** improvise a login method. Reviewer must reconcile a separate Owner authentication Gate.

### Fail closed

For any `FAIL_CLOSED`, account mismatch, ACL/config-location failure, archive verification failure, ambiguous provider output, cleanup failure, or other unexpected marker: stop and return only the bounded markers to Reviewer.

## STOP

`STOP_AT_REVIEWER=YES`

No live G4-B execution follows automatically.
