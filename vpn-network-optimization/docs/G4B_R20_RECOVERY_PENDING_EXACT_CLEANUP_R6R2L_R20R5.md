# G4-B R20 Recovery Pending Exact Cleanup — R6R2L-R20R5

Status: RELEASED / EXACT_PENDING_CLEANUP / REVIEWER_STOP

## GATE_ID
`G4B_R20_RECOVERY_PENDING_EXACT_CLEANUP_R6R2L_R20R5`

## PREVIOUS_RESULT
`PASS_R20R4R2_EXPECTED_FAILED_RUN_PENDING_SET`

## ACCEPTED R20R4R2 FACTS
```text
R20R4R2_BAIDU_PROCESS_ENCODING=UTF8
R20R4R2_OWNER_BAIDU_ACCOUNT_CONFIRMATION=PASS
R20R4R2_LOCAL_JOURNAL_IDENTITY=PASS
R20R4R2_LOCAL_DPAPI_PENDING=FILE
R20R4R2_LOCAL_PORTABLE_PENDING=FILE
R20R4R2_LOCAL_FINAL=ABSENT
R20R4R2_LOCAL_BAIDU_RUNTIME=ABSENT
R20R4R2_REMOTE_PENDING=FILE
R20R4R2_REMOTE_FINAL=ABSENT
R20R4R2_RECOVERY_STATE=EXPECTED_FAILED_RUN_PENDING_SET
R20R4R2_TEMP_RUNTIME_CLEANUP=PASS
R20R4R2_UID_EMITTED_TO_TERMINAL=NO
R20R4R2_RECOVERY_CONTENT_READ=NO
R20R4R2_RECOVERY_MUTATION=NO
R20R4R2_BAIDU_MUTATION=NO
R20R4R2_SSH_OR_VPS_ACTION=NO
R20R4R2_NETWORK_MUTATION=NO
```

## OBJECTIVE
Delete only the exact R20 failed-run pending recovery set:
1. exact Baidu pending object named by the retained R20 rollback journal;
2. exact local portable pending file named by the same run id;
3. exact local DPAPI pending file at the journal-locked path.

Final recovery artifacts must remain absent and untouched.

## LOCKED HELPER
```text
HELPER_PATH=scripts/g4b-r20-recovery-pending-exact-cleanup.ps1
HELPER_BLOB=500096ce2bf12c3a8a36aa109d6995ae8352d48e
```

## REQUIRED PRE-WRITE OWNERSHIP PROOF
The helper must re-prove:
- unique R20 rollback journal from the accepted R20 execution window;
- journal status remains `IN_PROGRESS`;
- no Clash profile was created;
- exact local/remote pending/final paths match the journal and run id;
- local pending files are regular non-reparse Owner-only files;
- local pending file sizes are bounded;
- both local pending timestamps fall inside the R20 execution window;
- local final artifact is absent;
- current Baidu account is locally confirmed by Owner;
- exact remote pending is a file and remote final is absent;
- downloaded remote pending ciphertext SHA-256 exactly matches the local portable pending ciphertext.

No plaintext/decrypt step is permitted.

## ALLOWED MUTATION
Only after all proof passes:
1. Baidu `rm` of the exact R20 pending remote object;
2. read-only provider readback proving exact pending absent and final absent;
3. non-recursive deletion of exact local portable pending;
4. non-recursive deletion of exact local DPAPI pending;
5. deletion of owner-only temporary diagnostic/download files.

## FORBIDDEN
- recovery decrypt/unprotect;
- recovery final rename/write/delete;
- Baidu upload/mv/mkdir;
- any other Baidu rm target;
- rollback journal deletion;
- SSH/VPS/service action;
- Clash/profile/network/proxy/TUN/route mutation;
- R17 quarantine mutation;
- second R20 live invocation.

## REQUIRED EVIDENCE
```text
R20R5_OWNER_BAIDU_ACCOUNT_CONFIRMATION=PASS
R20R5_REMOTE_PENDING_CIPHERTEXT_MATCH=PASS
R20R5_REMOTE_PENDING_REMOVE=PASS
R20R5_LOCAL_PENDING_REMOVE=PASS
R20R5_EXACT_PENDING_SET_CLEAN=PASS
R20R5_TEMP_RUNTIME_CLEANUP=PASS
R20R5_REMOTE_PENDING_MUTATION_STARTED=YES
R20R5_LOCAL_PENDING_MUTATION_STARTED=YES
R20R5_RECOVERY_DECRYPT=NO
R20R5_RECOVERY_FINAL_MUTATION=NO
R20R5_SSH_OR_VPS_ACTION=NO
R20R5_CLASH_MUTATION=NO
R20R5_NETWORK_MUTATION=NO
R20R5_ROLLBACK_JOURNAL_RETAINED=YES
STOP_AT_REVIEWER=YES
```

## ACCEPTANCE
PASS_CANDIDATE only if:
- the exact remote pending is absent afterward;
- both exact local pending files are absent afterward;
- local and remote final artifacts remain absent;
- retained R20 rollback journal remains present;
- no unrelated state is changed.

## NEXT AFTER PASS
After R20R5 formal PASS:
1. repair the P7 enable/listener failure classification and rollback reporting offline;
2. prepare a fresh live Gate with new one-shot identity;
3. do not replay R20.

## AUTHORIZATION
Covered by standing Owner authorization for the documented roadmap. The local Baidu account dialog is an identity attestation, not a new authorization checkpoint.

## STOP
`STOP_AT_REVIEWER=YES`
