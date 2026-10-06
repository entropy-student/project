# G4-B R20 P7 Remote Read-Only Reconciliation — R6R2L-R20R1

Status: RELEASED / OWNER_READONLY_CHECKPOINT / NO_MUTATION

## GATE_ID
`G4B_R20_P7_REMOTE_READONLY_RECONCILIATION_R6R2L_R20R1`

## PREVIOUS_RESULT
`RETURN_R20_P7_UNCLASSIFIED_ROLLBACK_UNKNOWN`

## FACTS
```text
R20_GATE_BLOB=a35f1c4c62091338a1ef71c19f1af0ac94a60a46
R20_RUNNER_BLOB=3a5e7c93bb96a4b485283f6590df18c5fac2690f
R20_FAILED_PHASE=P7_SERVICE_ENABLE_AND_LISTENER_READBACK
R20_FAILURE_CODE=UNCLASSIFIED
R20_CONSEQUENTIAL_MUTATION_STARTED=YES
R20_REMOTE_ROLLBACK=UNKNOWN_REQUIRES_RECONCILIATION
R20_RECOVERY_ARTIFACT_CLEANUP=RETAINED_ROLLBACK_UNVERIFIED
R20_ROLLBACK_JOURNAL=RETAINED_REQUIRES_RECONCILIATION
R20_SECOND_ATTEMPT=FORBIDDEN
```

## OBJECTIVE
Establish the exact post-R20 remote state before any further mutation.

The checkpoint must determine only:
- whether the R20 project transaction still exists;
- whether the project REALITY service/unit/binary/runtime/secret-config paths remain;
- whether TCP/443 is listening and, if so, whether the listener is Mihomo;
- whether the project runtime user/group remain;
- whether WireGuard and HY2 remain healthy;
- whether the remote transaction state matches the locally retained R20 rollback journal.

## LOCKED HELPER
```text
HELPER_PATH=scripts/g4b-r20-readonly-reconciliation.ps1
HELPER_BLOB=50bc1911d9ae5493cc715e0fb7cfdac8d9266d9c
```

The helper identifies the unique R20 journal only from the known R20 checkpoint UTC window, validates its format/run-id/IN_PROGRESS state and confirms no Clash profile was imported. The run id is used internally and is not emitted.

## ALLOWED
- safe-sync canonical main;
- PowerShell AST parse of the helper;
- local read of the non-secret rollback journal;
- exactly one SSH read-only query to the accepted private control target;
- systemd status/show queries;
- socket/process/path metadata queries;
- read of the project transaction state JSON only;
- sanitized classifications.

## FORBIDDEN
- runner `-Mode Run`, `-Mode Rollback` or `-Mode Closeout`;
- systemctl start/stop/restart/enable/disable;
- rm/unlink/rmdir/write/chmod/chown/useradd/userdel/groupadd/groupdel;
- any provider action;
- Baidu action;
- Secret/DPAPI content access;
- reading REALITY server configuration content;
- Clash profile mutation;
- local network/proxy/TUN/route mutation;
- second R20 attempt.

## REQUIRED EVIDENCE
```text
R20R1_LOCAL_JOURNAL_IDENTITY=PASS
R20R1_REMOTE_READONLY_QUERY=PASS
R20R1_REALITY_SERVICE_LOAD=<...>
R20R1_REALITY_SERVICE_ACTIVE=<...>
R20R1_REALITY_SERVICE_SUB=<...>
R20R1_REALITY_SERVICE_ENABLE=<...>
R20R1_TCP443_COUNT=<n>
R20R1_TCP443_OWNED_BY_MIHOMO=<YES|NO|NA>
R20R1_MIHOMO_PROCESS_COUNT=<n>
R20R1_WG_HEALTHY=<YES|NO>
R20R1_HY2_HEALTHY=<YES|NO>
R20R1_BINARY_PRESENT=<YES|NO>
R20R1_RUNTIME_PRESENT=<YES|NO>
R20R1_SECRET_CONFIG_PRESENT=<YES|NO>
R20R1_UNIT_PRESENT=<YES|NO>
R20R1_TRANSACTION_PRESENT=<YES|NO>
R20R1_TEMP_PRESENT=<YES|NO>
R20R1_TRANSACTION_STATE_PRESENT=<YES|NO>
R20R1_TRANSACTION_RUN_ID_MATCH=<YES|NO|NA>
R20R1_RUNTIME_USER_PRESENT=<YES|NO>
R20R1_RUNTIME_GROUP_PRESENT=<YES|NO>
R20R1_RECONCILIATION_STATE=<CLEAN|PROJECT_RESIDUAL_PRESENT|AMBIGUOUS_BASELINE>
R20R1_REMOTE_MUTATION=NO
R20R1_SECRET_CONTENT_READ=NO
R20R1_LOCAL_MUTATION=NO
STOP_AT_REVIEWER=YES
```

## DECISION AFTER READBACK
- `CLEAN`: do not run rollback; diagnose/repair P7 and rollback error reporting offline before a fresh future live Gate.
- `PROJECT_RESIDUAL_PRESENT`: prepare one exact ownership-proven bounded reconciliation/rollback Gate; do not blindly reuse R20 rollback.
- `AMBIGUOUS_BASELINE`: stop and diagnose the baseline before mutation.

## AUTHORIZATION
Standing Owner authorization covers this read-only reconciliation. No additional authorization prompt is required.

## STOP
`STOP_AT_REVIEWER=YES`
