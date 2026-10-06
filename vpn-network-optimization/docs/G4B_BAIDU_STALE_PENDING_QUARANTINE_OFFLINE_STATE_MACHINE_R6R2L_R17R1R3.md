# G4-B R17 Offline State-Machine Evidence R6R2L-R17R1R3

Status: PREPARED / OWNER_LOCAL_OFFLINE_TEST_ONLY / NO_SOURCE_CHANGE_EXPECTED

## GATE_ID
`G4B_BAIDU_STALE_PENDING_QUARANTINE_OFFLINE_STATE_MACHINE_R6R2L_R17R1R3`

## PREVIOUS_RESULT
`PASS_CANDIDATE_R17R1R2_DURABLE`

Durable identities:
- canonical main: `573a15091b9d084ed1d1e4eb20c9d712a051eaf7`
- helper blob: `3d7797a21c31fb805993530b28d674db4cdf288c`
- validator blob: `4d490bdbe8f686053cccae8310c72ff74117600b`
- normal offline validator: PASS
- inherited LASTEXITCODE=37 regression: PASS

## OBJECTIVE
Produce the final executable offline evidence required by parent R17R1 for the real helper forward-success and rollback-success orchestration without contacting Baidu or changing production source.

## METHOD
Use the existing `-DefinitionOnly` entry point in an isolated PowerShell scope, then temporarily replace only external/local side-effect boundaries:
- Baidu config ACL observation
- pinned CLI download/hash observation
- hidden UID input
- Provider process execution
- Provider listing readback

Invoke the production `Invoke-R17Run` function itself. Listing parsing, precheck/cardinality logic, forward decision, rollback decision, result classification, and cleanup remain the production helper implementation.

Fixture A must execute:
one pending -> one forward mv mock -> quarantine present -> `R17_RESULT=PASS_CANDIDATE`.

Fixture B must execute:
one pending -> mocked forward reports failure with quarantine present -> production `Invoke-R17Rollback` -> one rollback mv mock -> baseline pending restored -> `R17_RESULT=RETURN_FORWARD_FAILED_ROLLED_BACK`.

No real provider command may start.

## MAX_ENDPOINT_THIS_ROUND
Temporary local test artifacts only. No tracked source modification, no provider/config/Secret/DPAPI/SSH/VPS/Clash/network action, and no normal helper `-Mode Run` process invocation.

## REQUIRED EVIDENCE
- exact helper/validator blobs match durable identities
- tracked worktree clean before and after
- `R17R1R3_FORWARD_EXECUTABLE=PASS`
- `R17R1R3_FORWARD_MV_COUNT=1`
- `R17R1R3_ROLLBACK_EXECUTABLE=PASS`
- `R17R1R3_ROLLBACK_MV_COUNT=2`
- forward result contains `R17_RESULT=PASS_CANDIDATE`
- rollback fixture contains `R17_ROLLBACK_ATTEMPT=YES`
- rollback fixture contains `R17_ROLLBACK_READBACK=PASS`
- rollback result contains `R17_RESULT=RETURN_FORWARD_FAILED_ROLLED_BACK`
- both fixtures contain `TEMP_RUNTIME_CLEANUP=PASS`
- temporary harness cleanup PASS
- provider action NO
- Owner config read NO
- Secret/DPAPI access NO
- SSH/VPS action NO
- network mutation NO
- production source change NO

## ACCEPTANCE
PASS_CANDIDATE only if both forward and rollback fixtures execute the production state-machine functions and all exact markers/counts pass while source identities remain unchanged.

Any attempt to start the real Baidu executable, real web download, or read real Owner config => RETURN and hard stop.

## OWNER_ONLY_ACTIONS
Run the bounded local offline harness in Owner PowerShell 7.6.6. This is non-consequential and does not release parent R17.

## REVIEWER_TO_EXECUTOR_RELAY
Do not edit helper/validator. Use DefinitionOnly plus isolated test doubles for external boundaries. Execute production Invoke-R17Run twice: forward-success and forward-failure-with-successful-rollback. Verify exact result markers, mv call counts, cleanup, source identities, and tracked worktree cleanliness. Then mandatory Reviewer stop.

## EXECUTOR_TO_REVIEWER_RELAY
Return result / validation markers / source blobs / changed-file count / problems / cleanup / Owner transfer. Owner transfer must be NONE.
