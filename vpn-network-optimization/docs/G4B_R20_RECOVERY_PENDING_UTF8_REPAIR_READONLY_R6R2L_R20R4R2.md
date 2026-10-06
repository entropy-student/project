# G4-B R20 Recovery Pending UTF-8 Repair Read-Only — R6R2L-R20R4R2

Status: RELEASED / READ_ONLY / OWNER_LOCAL_ACCOUNT_CONFIRMATION

## GATE_ID
`G4B_R20_RECOVERY_PENDING_UTF8_REPAIR_READONLY_R6R2L_R20R4R2`

## PREVIOUS_RESULT
`RETURN_R20R4R1_BAIDU_UID_PARSE_OR_UNIQUENESS_FAILED_SAFE`

## REVIEWER_FINDING
R20R4R1 omitted explicit UTF-8 decoding for BaiduPCS-Go stdout/stderr. The previously accepted R16/R17/R18 helpers explicitly set:

```text
StandardOutputEncoding=UTF8
StandardErrorEncoding=UTF8
```

R20R4 also collapsed UID parse failure and UID mismatch into one error code, so its earlier `BAIDU_UID_MISMATCH` result did not independently prove that the UID text parsed correctly.

The R20R4R2 repair changes only this process-output decoding seam and keeps the account-confirmation/recovery-presence logic unchanged.

## OBJECTIVE
Re-run the same read-only R20 recovery-presence reconciliation with the historically proven UTF-8 decoding contract:
1. pinned BaiduPCS-Go `who`;
2. require exactly one canonical UID line;
3. display current UID only in a local Windows Owner confirmation dialog;
4. never emit UID to terminal/GitHub;
5. after Owner confirmation, run Baidu `ls -l`;
6. classify exact R20 local/remote pending/final artifact presence;
7. do not read or decrypt recovery contents.

## LOCKED HELPER
```text
HELPER_PATH=scripts/g4b-r20-recovery-pending-readonly-owner-confirm-r2.ps1
HELPER_BLOB=1b515b88a14599bd7bc55d837f96ecd38420f547
```

## ALLOWED
- safe-sync canonical main;
- helper AST parse;
- local rollback-journal metadata read;
- recovery file existence/metadata/ACL/size checks only;
- pinned BaiduPCS-Go preparation in owner-only temp runtime;
- Baidu `who` and `ls -l` only;
- local-only Windows UID confirmation dialog;
- temp diagnostic cleanup.

## FORBIDDEN
- terminal/GitHub UID emission;
- recovery content read;
- DPAPI decrypt/unprotect;
- Baidu upload/download/mv/rm/mkdir;
- recovery rename/delete/write;
- SSH/VPS action;
- Clash/network/proxy/TUN/route mutation;
- second R20 live invocation.

## REQUIRED EVIDENCE
```text
R20R4R2_BAIDU_PROCESS_ENCODING=UTF8
R20R4R2_OWNER_BAIDU_ACCOUNT_CONFIRMATION=PASS
R20R4R2_LOCAL_JOURNAL_IDENTITY=PASS
R20R4R2_LOCAL_DPAPI_PENDING=<FILE|ABSENT>
R20R4R2_LOCAL_PORTABLE_PENDING=<FILE|ABSENT>
R20R4R2_LOCAL_FINAL=<FILE|ABSENT>
R20R4R2_LOCAL_BAIDU_RUNTIME=<PRESENT|ABSENT>
R20R4R2_REMOTE_PENDING=<FILE|ABSENT|DIRECTORY>
R20R4R2_REMOTE_FINAL=<FILE|ABSENT|DIRECTORY>
R20R4R2_RECOVERY_STATE=<EXPECTED_FAILED_RUN_PENDING_SET|UNEXPECTED_REQUIRES_REVIEW>
R20R4R2_TEMP_RUNTIME_CLEANUP=PASS
R20R4R2_UID_EMITTED_TO_TERMINAL=NO
R20R4R2_RECOVERY_CONTENT_READ=NO
R20R4R2_RECOVERY_MUTATION=NO
R20R4R2_BAIDU_MUTATION=NO
R20R4R2_SSH_OR_VPS_ACTION=NO
R20R4R2_NETWORK_MUTATION=NO
STOP_AT_REVIEWER=YES
```

## ACCEPTANCE
If exactly one UID line parses under UTF-8, Owner confirms the locally displayed account, and the exact failed-run pending set is observed with final artifacts absent, Reviewer may prepare one exact pending-cleanup Gate.

Any other outcome returns safely for review.

## AUTHORIZATION
Covered by standing Owner authorization.

## STOP
`STOP_AT_REVIEWER=YES`
