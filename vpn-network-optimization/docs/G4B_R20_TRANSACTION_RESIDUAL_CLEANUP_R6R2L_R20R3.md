# G4-B R20 Transaction Residual Exact Cleanup — R6R2L-R20R3

Status: RELEASED / ONE_EXACT_REMOTE_CLEANUP / REVIEWER_STOP

## GATE_ID
`G4B_R20_TRANSACTION_RESIDUAL_CLEANUP_R6R2L_R20R3`

## PREVIOUS_RESULT
`PASS_R20R2_TRANSACTION_RESIDUAL_CLASSIFIED`

## ACCEPTED R20R2 FACTS
```text
R20R2_CREATED_PARENT_UNKNOWN_COUNT=0
R20R2_CREATED_PARENT_COUNT=2
R20R2_PARENT_RUNTIME=ABSENT
R20R2_PARENT_SECRETS_PARENT=ABSENT
R20R2_TXN_CHILD_COUNT=2
R20R2_TXN_UNKNOWN_CHILD_COUNT=0
R20R2_TXN_STATE_JSON=FILE_PRESENT
R20R2_TXN_MIHOMO_REALITY_VPN_NETWORK_OPTIMIZATION_SERVICE=FILE_PRESENT
R20R2_TXN_METADATA_CONTRACT=PASS
```

R20R1 already proved the consequential REALITY surface absent and WG/HY2 healthy.

## OBJECTIVE
Remove only the fully ownership-proven residual R20 transaction metadata:
1. exact staged unit file inside the R20 transaction directory;
2. exact `state.json` inside the same transaction directory;
3. the now-empty exact R20 transaction directory.

Nothing else may be changed.

## LOCKED HELPER
```text
HELPER_PATH=scripts/g4b-r20-transaction-residual-cleanup.ps1
HELPER_BLOB=11bfbd0cf4c4d6e990348fadccfd3d85be64e06b
```

## REQUIRED PRE-WRITE PROOF
The helper must re-prove immediately before deletion:
- unique retained local R20 rollback journal and matching run id;
- exact transaction directory root:root mode 0700;
- exactly two children and no unknown child;
- both children are regular non-symlink root-owned files;
- staged unit mode 0600;
- transaction state run id matches and `pass_candidate=false`;
- all R20 created flags expected from R20R2 remain true;
- staged unit first line is exactly the current run ownership marker;
- REALITY binary/runtime/secret/unit/temp/user/group all absent;
- TCP/443 count 0 and Mihomo process count 0;
- WireGuard and HY2 active with their accepted UDP listeners.

## ALLOWED MUTATION
Only:
- unlink the exact transaction-local staged unit;
- unlink the exact transaction-local `state.json`;
- remove the exact now-empty R20 transaction directory.

No recursive deletion is allowed.

## FORBIDDEN
- runner Run/Rollback/Closeout;
- any systemd service mutation;
- any REALITY target path mutation outside the transaction directory;
- any local rollback journal deletion;
- any recovery artifact change;
- any Baidu/provider action;
- any Clash/network/proxy/TUN/route mutation;
- second R20 invocation.

## REQUIRED EVIDENCE
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
STOP_AT_REVIEWER=YES
```

## NEXT AFTER PASS
After R20R3, do not launch a new live Gate yet. First reconcile the retained local / Baidu pending recovery artifacts from R20 under a separate bounded Gate, then repair P7/rollback error classification offline as needed.

## AUTHORIZATION
Covered by the Owner's standing authorization for the documented closeout roadmap.

## STOP
`STOP_AT_REVIEWER=YES`
