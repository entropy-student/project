# G4-B Baidu UID UTF-8 Decode Retry R6R2J-R3

Status: ACTIVE / OWNER_LOCAL_VALIDATE_THEN_READ_ONLY_ONE_SHOT

## GATE_ID

`G4B_BAIDU_UID_UTF8_DECODE_RETRY_R6R2J_R3`

## PREVIOUS_RESULT

`RETURN_R6R2J_R2_BAIDU_UID_OUTPUT_AMBIGUOUS`

## REVIEWER REPAIR

The R6R2J-R1 canonical-line parser remains accepted.

The second real read-only attempt still returned `BAIDU_UID_OUTPUT_AMBIGUOUS`. Reviewer inspection found the inherited `ProcessStartInfo` redirected stdout/stderr decoder did not explicitly lock UTF-8, while pinned BaiduPCS-Go v4.0.2 writes the Chinese canonical `who` line from a Go UTF-8 string.

The UID helper now wraps only the read-only `who` process and explicitly sets:

```text
StandardOutputEncoding = UTF-8 (no BOM)
StandardErrorEncoding  = UTF-8 (no BOM)
```

The accepted authentication/readiness checkpoint source remains unchanged.

## LOCKED SOURCE

```text
UID_HELPER_BLOB=db75bb7fb2cefffb243b8003186ac6b5dcc96372
UID_VALIDATOR_BLOB=bde25e6987a16d9f06a368c73b432cb57d958761
AUTH_READINESS_CHECKPOINT_BLOB=be1c55d4b7623041c338aca83194ec0b59a41dc8
```

## OBJECTIVE

On the accepted Owner Windows host:

1. fresh fast-forward to current `main`;
2. verify the locked helper/validator blobs;
3. run the full UID validator locally;
4. proceed only if validator exits 0 and reports `UID_WHO_UTF8_DECODE_LOCKED=PASS`;
5. then run exactly one real read-only UID discovery;
6. keep the numeric UID local only;
7. stop at Reviewer.

## ALLOWED REAL ACTIONS

After validator PASS only:

- inspect accepted config metadata/ACL/location;
- download/verify the pinned BaiduPCS-Go v4.0.2 archive into the bounded temporary runtime;
- execute exactly one read-only `who`;
- parse/display the numeric UID locally only;
- clean the temporary runtime.

## FORBIDDEN

- login/re-authentication;
- auth material input/output;
- config-content print/copy/edit/delete;
- provider upload/download/mkdir/mv/rm;
- UID/raw provider output in chat/GitHub/Evidence;
- VPS/SSH/Clash/service/route/proxy/TUN changes;
- live G4-B deployment or G4-C workloads;
- retry if this one-shot fails.

## SUCCESS

Local validator:

```text
UID_WHO_UTF8_DECODE_LOCKED=PASS
FULL_UID_VALIDATOR=PASS
```

Owner return:

```text
BAIDU_UID_DISCOVERY=READY
UID_DISPLAYED_LOCALLY=YES
BAIDU_UID_NOT_FOR_CHAT_OR_GITHUB=YES
BAIDU_UID_FAILURE_CODE=NONE
BAIDU_UID_RUNTIME_CLEANUP=PASS
```

Do not paste `BAIDU_OWNER_LOCAL_UID=<number>`.

`STOP_AT_REVIEWER=YES`
