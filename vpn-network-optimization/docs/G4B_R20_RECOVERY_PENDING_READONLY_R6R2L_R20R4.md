# G4-B R20 Recovery Pending Read-Only Reconciliation — R6R2L-R20R4

Status: RELEASED / READ_ONLY_PROVIDER_OBSERVATION / NO_RECOVERY_MUTATION

## GATE_ID
`G4B_R20_RECOVERY_PENDING_READONLY_R6R2L_R20R4`

## PREVIOUS_RESULT
`PASS_R20R3_REMOTE_TRANSACTION_CLEANUP`

## ACCEPTED R20R3 FACTS
```text
R20R3_PREFLIGHT_OWNERSHIP=PASS
R20R3_STAGED_UNIT_RUN_ID_MARKER=PASS
R20R3_PRE_CLEAN_CONSEQUENTIAL_SURFACE=CLEAN
R20R3_REMOTE_TRANSACTION_CLEANUP=PASS
R20R3_POST_CLEAN_REMOTE_BASELINE=PASS
R20R3_WG_HEALTHY=YES
R20R3_HY2_HEALTHY=YES
R20R3_LOCAL_ROLLBACK_JOURNAL_RETAINED=YES
R20R3_RECOVERY_ARTIFACTS_TOUCHED=NO
R20R3_BAIDU_ACTION=NO
R20R3_CLASH_MUTATION=NO
R20R3_LOCAL_NETWORK_MUTATION=NO
```

The VPS-side R20 residue is now closed. The retained recovery pending set is intentionally handled separately.

## OBJECTIVE
Read-only reconcile the exact R20 recovery artifact state:
- local DPAPI pending path;
- local portable pending path;
- local final DPAPI path;
- any retained R20 Baidu runtime directory;
- exact R20 Baidu pending object;
- canonical Baidu final object.

No recovery artifact content may be read or decrypted.

## LOCKED HELPER
```text
HELPER_PATH=scripts/g4b-r20-recovery-pending-readonly.ps1
HELPER_BLOB=f697ac18a16b7aa6e9e612779efadd6dfb75fd62
```

## ALLOWED
- safe-sync canonical main;
- helper AST parse;
- local rollback-journal metadata read;
- local file existence/metadata/ACL/size checks only;
- pinned BaiduPCS-Go preparation in an owner-only temporary diagnostic directory;
- Baidu `who` and `ls -l` read-only commands only;
- exact UID match using hidden local input;
- exact remote pending/final object classification;
- diagnostic temporary runtime cleanup.

## FORBIDDEN
- reading bytes/content of DPAPI or portable recovery artifacts;
- DPAPI unprotect/decrypt;
- Baidu download/upload/mv/rm/mkdir;
- any recovery rename/delete/write;
- SSH/VPS action;
- Clash/network/proxy/TUN/route mutation;
- second R20 invocation.

## REQUIRED EVIDENCE
```text
R20R4_LOCAL_JOURNAL_IDENTITY=PASS
R20R4_LOCAL_DPAPI_PENDING=<FILE|ABSENT>
R20R4_LOCAL_PORTABLE_PENDING=<FILE|ABSENT>
R20R4_LOCAL_FINAL=<FILE|ABSENT>
R20R4_LOCAL_BAIDU_RUNTIME=<PRESENT|ABSENT>
R20R4_REMOTE_PENDING=<FILE|ABSENT|DIRECTORY>
R20R4_REMOTE_FINAL=<FILE|ABSENT|DIRECTORY>
R20R4_BAIDU_UID_MATCH=PASS
R20R4_RECOVERY_STATE=<EXPECTED_FAILED_RUN_PENDING_SET|UNEXPECTED_REQUIRES_REVIEW>
R20R4_TEMP_RUNTIME_CLEANUP=PASS
R20R4_RECOVERY_CONTENT_READ=NO
R20R4_RECOVERY_MUTATION=NO
R20R4_BAIDU_MUTATION=NO
R20R4_SSH_OR_VPS_ACTION=NO
R20R4_NETWORK_MUTATION=NO
STOP_AT_REVIEWER=YES
```

## ACCEPTANCE
If the exact failed-run pending set is present and both final artifacts are absent, Reviewer may prepare one exact cleanup Gate proving ownership before deleting only those pending artifacts. Any other combination returns for review.

## AUTHORIZATION
Covered by standing Owner authorization.

## STOP
`STOP_AT_REVIEWER=YES`
