# G4-B R20 Transaction Residual Read-Only Classification — R6R2L-R20R2

Status: RELEASED / READ_ONLY / NO_MUTATION

## GATE_ID
`G4B_R20_TRANSACTION_RESIDUAL_READONLY_R6R2L_R20R2`

## PREVIOUS_RESULT
`PASS_R20R1_OBSERVATION_PROJECT_RESIDUAL_PRESENT`

## ACCEPTED R20R1 FACTS
```text
REALITY_SERVICE=ABSENT
TCP443=0
MIHOMO_PROCESSES=0
BINARY=ABSENT
RUNTIME=ABSENT
SECRET_CONFIG=ABSENT
UNIT=ABSENT
RUNTIME_USER=ABSENT
RUNTIME_GROUP=ABSENT
WG_HEALTHY=YES
HY2_HEALTHY=YES
TRANSACTION_PRESENT=YES
TRANSACTION_STATE_PRESENT=YES
TRANSACTION_RUN_ID_MATCH=YES
TEMP_PRESENT=NO
```

## OBJECTIVE
Classify the remaining R20 transaction residue before any deletion:
- exact transaction child names and file types, restricted to sanitized allowlisted names;
- transaction metadata contract;
- state booleans only;
- created_parents symbolic identities and whether each is absent/empty/nonempty;
- reject unknown parent paths or unknown transaction children.

## LOCKED HELPER
```text
HELPER_PATH=scripts/g4b-r20-transaction-residual-readonly.ps1
HELPER_BLOB=dcabd46abc7d2736369e1f0f0a0072f6dfe78398
```

## ALLOWED
- safe-sync main;
- helper AST parse;
- local read of the retained rollback journal metadata;
- one SSH read-only metadata/state query;
- remote read of R20 transaction state JSON only;
- remote directory metadata/listing for project-owned transaction and created-parent paths;
- sanitized boolean/classification output.

## FORBIDDEN
Any remote/local mutation, runner Run/Rollback/Closeout, service action, rm/unlink/rmdir, chmod/chown, provider/Baidu action, Secret/DPAPI content read, REALITY config content read, Clash/network/proxy/TUN/route mutation, or second R20 invocation.

## REQUIRED EVIDENCE
All `R20R2_*` markers produced by the locked helper, plus:
```text
R20R2_REMOTE_MUTATION=NO
R20R2_SECRET_CONTENT_READ=NO
R20R2_LOCAL_MUTATION=NO
STOP_AT_REVIEWER=YES
```

## ACCEPTANCE
Observation only. If transaction children are fully allowlisted, metadata matches, unknown counts are zero, and any created parent still present is empty and ownership-safe, Reviewer may prepare one exact residual cleanup Gate. Otherwise stop and diagnose.

## AUTHORIZATION
Covered by standing Owner authorization.

## STOP
`STOP_AT_REVIEWER=YES`
