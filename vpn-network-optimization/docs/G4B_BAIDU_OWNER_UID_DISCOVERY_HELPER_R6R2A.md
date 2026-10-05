# G4-B Baidu Owner UID Discovery Helper R6R2A

Status: ACTIVE / EXECUTOR_OFFLINE_ONLY

## GATE_ID

`G4B_BAIDU_OWNER_UID_DISCOVERY_HELPER_R6R2A`

## PREVIOUS_STATE

`R6R2_BLOCKED_EXPECTED_UID_UNKNOWN`

## OBJECTIVE

Prepare and offline-validate one minimal Owner-local helper that discovers the currently authenticated Baidu account UID using the same reviewed BaiduPCS-Go trust/config/read-only boundaries, while keeping provider raw output and all credential material inside the local process boundary.

This Gate only builds/validates the helper. It does not execute a real `who`, read the Owner config, or perform network/provider actions.

## REQUIRED OWNER-HELPER BEHAVIOR

Future Owner run must:

- reuse the accepted BaiduPCS-Go v4.0.2 archive URL and SHA-256 trust anchor;
- reuse the accepted config path/location/reparse/ACL safety predicate from the R6R1 checkpoint;
- accept no credential/cookie/token/password/BDUSS/STOKEN parameters or environment values;
- never invoke `login`;
- invoke exactly one read-only `who`;
- capture stdout/stderr internally;
- parse exactly one numeric UID in memory using the accepted `当前帐号 uid:` contract;
- if unauthenticated, ambiguous, CLI error, unsafe config/ACL, or cleanup failure: fail closed / return Owner action required as applicable;
- print only one local identity marker containing the numeric UID for the Owner to read locally, plus bounded readiness/cleanup markers;
- never print username, provider raw output, config content, cookies/tokens, or credential material;
- explicitly tell Owner not to paste the UID or raw output into chat/GitHub;
- clean the temporary runtime.

The numeric UID is an account identifier, not a credential, but remains Owner-local for this workflow.

## EXECUTOR ROUND BOUNDARY

Offline only:

```text
implement helper
-> synthetic fixtures
-> AST parse
-> Secret scan
-> verify no live invocation
-> persist Evidence/Handoff
-> GitHub fresh read-back
-> STOP_AT_REVIEWER
```

Forbidden during Executor round:

- real Baidu CLI invocation;
- real `who`;
- Owner config access;
- network requests;
- login or provider mutation;
- credential/Secret/DPAPI access;
- VPS/SSH;
- Clash/service/route/proxy/TUN actions;
- live G4-B/G4-C.

## ALLOWED FILES

- `scripts/g4b-baidu-uid-discovery-checkpoint.ps1`
- `scripts/g4b-baidu-uid-discovery-validator.ps1`
- this Gate
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Frozen:

- `REVIEWER_HANDOFF.md`
- R6R1 accepted checkpoint/validator
- R5R1 live runner/package
- unrelated files.

## ACCEPTANCE

Require at least:

```text
UID_HELPER_NO_CREDENTIAL_PARAMETERS=PASS
UID_HELPER_NO_LOGIN_COMMAND=PASS
UID_HELPER_PINNED_ARCHIVE_TRUST_REUSED=PASS
UID_HELPER_R6R1_CONFIG_ACL_POLICY_REUSED=PASS
UID_HELPER_WHO_ONLY_PROVIDER_ACTION=PASS
UID_HELPER_RAW_PROVIDER_OUTPUT_SUPPRESSED=PASS
UID_HELPER_USERNAME_NOT_EMITTED=PASS
UID_HELPER_SINGLE_UID_PARSE=PASS
UID_HELPER_UNAUTHENTICATED_OWNER_ACTION_REQUIRED=PASS
UID_HELPER_AMBIGUOUS_OUTPUT_FAIL_CLOSED=PASS
UID_HELPER_TEMP_CLEANUP=PASS
POWERSHELL_AST_PARSE=PASS
SECRET_SCAN=PASS
REAL_BAIDU_ACTIONS=0
OWNER_CONFIG_READ=NO
NETWORK_REQUESTS=0
STOP_AT_REVIEWER=YES
```

Do not run the Owner helper after building it.
