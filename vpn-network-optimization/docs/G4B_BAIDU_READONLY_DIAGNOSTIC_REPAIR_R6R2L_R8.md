# G4-B Baidu Read-Only Diagnostic Repair R6R2L-R8

Status: ACTIVE / OWNER_LOCAL_READ_ONLY_NETWORK_DIAGNOSTIC

## GATE_ID

`G4B_BAIDU_READONLY_DIAGNOSTIC_REPAIR_R6R2L_R8`

## PREVIOUS_RESULT

`RETURN_R6R2L_R7_BAIDU_WHO_PROPERTY_NOT_FOUND`

## FAILURE FACTS

```text
EXPECTED_UID_INPUT=READY
DIAGNOSTIC_STAGE=BAIDU_WHO
DIAGNOSTIC_EXCEPTION_TYPE=System.Management.Automation.PropertyNotFoundException
BAIDU_READONLY_DIAGNOSTIC_CLASSIFICATION=LOCAL_DIAGNOSTIC_EXCEPTION
TEMP_RUNTIME_CLEANUP=PASS
BAIDU_MUTATION_ACTION=NO
SSH_OR_VPS_ACTION=NO
RECOVERY_WRITE=NO
NETWORK_MUTATION=NO
SECRET_VALUES_EMITTED=0
STOP_AT_REVIEWER=YES
```

## INTERPRETATION

The R7 failure is in the diagnostic's PowerShell object/property handling during the Baidu `who` boundary. It does not prove a Baidu authentication, network, or remote-state failure.

This failure is potentially the same class as R5's previously unclassified P5 exception, so no live repair or retry is allowed until the read-only diagnostic can classify the boundary.

## REPAIR

Only the read-only diagnostic implementation changes:
- process results use explicit hashtable keys rather than dynamic property access;
- Baidu `who` and `ls` are split into narrower diagnostic substages;
- catch output may report script line number and bounded stage/code only;
- raw stdout/stderr and all account/Secret values remain suppressed.

## ALLOWED / FORBIDDEN

Same as R7. Only `who` and `ls -l` are allowed against Baidu. No mutation commands, no SSH/VPS, no live runner, no recovery/profile/service/network mutation.

## ACCEPTANCE

Obtain a bounded classification for the `who` and, if reachable, `ls` paths with:
- temp cleanup PASS;
- Baidu mutation NO;
- SSH/VPS action NO;
- Secret values emitted 0;
- STOP_AT_REVIEWER.

No live retry is authorized.

## STOP

`STOP_AT_REVIEWER=YES`
