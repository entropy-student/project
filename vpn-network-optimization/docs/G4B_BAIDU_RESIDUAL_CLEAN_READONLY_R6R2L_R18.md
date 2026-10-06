# G4-B Baidu Residual CLEAN Read-Only Reconciliation R6R2L-R18

Status: PREPARED / OWNER_LOCAL_READ_ONLY_PROVIDER_OBSERVATION

## GATE_ID
`G4B_BAIDU_RESIDUAL_CLEAN_READONLY_R6R2L_R18`

## PREVIOUS_RESULT
`PASS_R6R2L_R17_STALE_PENDING_QUARANTINE`

## OBJECTIVE
Independently verify after R17 that the production project namespace is durably CLEAN:

```text
PROJECT_FINAL_COUNT=0
PROJECT_PENDING_COUNT=0
PROJECT_UNKNOWN_COUNT=0
BAIDU_RESIDUAL_STATE=CLEAN
```

The R17 quarantine object is outside the production project prefix and must not be mutated or deleted in R18.

## REUSED READ-ONLY HELPER
Reuse the already reviewed R16/R11 read-only helper unchanged:

```text
SCRIPT=scripts/g4b-baidu-residual-readonly-r11.ps1
SCRIPT_BLOB=b3dfb42f4deaf28650d3aab35d92b5a2965ed662
```

## ALLOWED
- local strict Baidu config ACL validation;
- temporary local diagnostic runtime;
- pinned BaiduPCS-Go v4.0.2 preparation;
- hidden expected numeric UID input;
- Provider `who`;
- Provider `ls -l /vpn-network-optimization-g4b-recovery`;
- sanitized count/classification output only.

## FORBIDDEN
- any Provider mutation, including `mv`, `rm`, upload, download-from-Baidu, mkdir;
- touching/deleting the R17 quarantine object;
- login/logout/config mutation/credential refresh;
- printing raw UID, remote basenames, provider stdout/stderr, cookies or credentials;
- deleting/modifying the retained R15 rollback journal;
- DPAPI/recovery Secret access;
- SSH/VPS;
- Clash/profile/service/route/proxy/TUN mutation;
- live G4-B;
- G4-C.

## REQUIRED EVIDENCE
```text
OWNER_RUNTIME=PASS
BAIDU_CONFIG_ACL=PASS
BAIDU_PINNED_CLI=PASS
EXPECTED_UID_INPUT=READY
BAIDU_WHO_PROCESS=PASS
BAIDU_UID_PARSE=PASS
BAIDU_UID_MATCH=PASS
BAIDU_LS_PROCESS=PASS
BAIDU_DIRECTORY_HEADER=PASS
PROJECT_FINAL_COUNT=0
PROJECT_PENDING_COUNT=0
PROJECT_UNKNOWN_COUNT=0
BAIDU_RESIDUAL_STATE=CLEAN
TEMP_RUNTIME_CLEANUP=PASS
BAIDU_MUTATION_ACTION=NO
SSH_OR_VPS_ACTION=NO
RECOVERY_READ_OR_WRITE=NO
NETWORK_MUTATION=NO
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

## ACCEPTANCE
PASS only if a fresh read-only observation independently reports exact 0/0/0 and CLEAN with no mutation.

Any other count/classification or auth/provider/local diagnostic error => RETURN and mandatory Reviewer stop. No cleanup/retry is authorized in R18.

## ROLLBACK
None. R18 is read-only. R17 quarantine and R15 local rollback journal remain retained and untouched.

## OWNER ACTION
Safe-sync canonical main, lock this Gate and reused helper identity, AST-parse the helper, run exactly once, enter expected UID only via hidden prompt, return sanitized markers, stop.

## NEXT AFTER FORMAL PASS
Only after Reviewer formally accepts R18 CLEAN may G4-B persistent three-role live work resume. Permanent disposition of the R17 quarantine object remains a separate Gate and is not required for production-namespace CLEAN.

## STOP
`STOP_AT_REVIEWER=YES`
