# G4-B R20 Recovery Pending Owner Account Confirmation Read-Only — R6R2L-R20R4R1

Status: RELEASED / LOCAL_OWNER_IDENTITY_CONFIRMATION + READ_ONLY_PROVIDER_OBSERVATION

## GATE_ID
`G4B_R20_RECOVERY_PENDING_OWNER_CONFIRM_READONLY_R6R2L_R20R4R1`

## PREVIOUS_RESULT
`RETURN_R20R4_BAIDU_UID_MISMATCH_SAFE`

## ACCEPTED R20R4 FACTS
```text
R20R4_SOURCE_IDENTITY=PASS
R20R4_AST=PASS
R20R4_MODE=READ_ONLY
R20R4_BAIDU_UID_PARSE=IMPLICIT_PASS
R20R4_BAIDU_UID_MATCH=FAIL
R20R4_TEMP_RUNTIME_CLEANUP=PASS
R20R4_RECOVERY_CONTENT_READ=NO
R20R4_RECOVERY_MUTATION=NO
R20R4_BAIDU_MUTATION=NO
R20R4_SSH_OR_VPS_ACTION=NO
R20R4_NETWORK_MUTATION=NO
```

The failure means the current BaiduPCS-Go account UID parsed successfully but did not equal the Owner-entered expected UID. Historical accepted checkpoints R16/R17/R18 used hidden UID input and stored only PASS markers, not the numeric UID. Therefore canonical history cannot reconstruct the prior numeric identifier.

## OBJECTIVE
Resolve the identity-input ambiguity without exposing the UID:
1. use pinned BaiduPCS-Go `who` locally;
2. require exactly one canonical UID line;
3. show the UID only in a local Windows confirmation dialog;
4. require Owner to explicitly confirm that this is the intended project Baidu account;
5. never emit the UID to terminal/GitHub evidence;
6. only after confirmation, perform Baidu `ls -l` and classify the exact R20 pending/final objects;
7. classify local recovery pending/final presence using metadata/ACL/size only.

## LOCKED HELPER
```text
HELPER_PATH=scripts/g4b-r20-recovery-pending-readonly-owner-confirm.ps1
HELPER_BLOB=2b3c418229ad2e340ad4284833bc29aa45f0719c
```

## ALLOWED
- safe-sync canonical main;
- helper AST parse;
- local rollback-journal metadata read;
- local recovery file existence/metadata/ACL/size checks only;
- pinned BaiduPCS-Go preparation in owner-only temporary diagnostic runtime;
- Baidu `who` and `ls -l` only;
- local Windows message box displaying current UID for Owner-only confirmation;
- diagnostic temp cleanup.

## FORBIDDEN
- terminal/GitHub emission of UID;
- recovery file content read;
- DPAPI decrypt/unprotect;
- Baidu upload/download/mv/rm/mkdir;
- recovery rename/delete/write;
- SSH/VPS action;
- Clash/network/proxy/TUN/route mutation;
- second R20 invocation.

## REQUIRED EVIDENCE
```text
R20R4R1_OWNER_BAIDU_ACCOUNT_CONFIRMATION=PASS
R20R4R1_LOCAL_JOURNAL_IDENTITY=PASS
R20R4R1_LOCAL_DPAPI_PENDING=<FILE|ABSENT>
R20R4R1_LOCAL_PORTABLE_PENDING=<FILE|ABSENT>
R20R4R1_LOCAL_FINAL=<FILE|ABSENT>
R20R4R1_LOCAL_BAIDU_RUNTIME=<PRESENT|ABSENT>
R20R4R1_REMOTE_PENDING=<FILE|ABSENT|DIRECTORY>
R20R4R1_REMOTE_FINAL=<FILE|ABSENT|DIRECTORY>
R20R4R1_RECOVERY_STATE=<EXPECTED_FAILED_RUN_PENDING_SET|UNEXPECTED_REQUIRES_REVIEW>
R20R4R1_TEMP_RUNTIME_CLEANUP=PASS
R20R4R1_UID_EMITTED_TO_TERMINAL=NO
R20R4R1_RECOVERY_CONTENT_READ=NO
R20R4R1_RECOVERY_MUTATION=NO
R20R4R1_BAIDU_MUTATION=NO
R20R4R1_SSH_OR_VPS_ACTION=NO
R20R4R1_NETWORK_MUTATION=NO
STOP_AT_REVIEWER=YES
```

## ACCEPTANCE
If Owner confirms the locally displayed account and the exact failed-run pending set is observed with finals absent, Reviewer may prepare one exact recovery-pending cleanup Gate. If Owner declines or the artifact state differs, stop for review.

## AUTHORIZATION
Covered by standing Owner authorization. The local account confirmation is an identity attestation, not a new authorization request.

## STOP
`STOP_AT_REVIEWER=YES`
