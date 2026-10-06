# G4-B R17 Rollback Output/Boolean Repair R6R2L-R17R1R4

Status: PREPARED / LOCAL_CODE_REPAIR_ONLY / R17_PROVIDER_EXECUTION_BLOCKED

## GATE_ID
`G4B_BAIDU_STALE_PENDING_QUARANTINE_ROLLBACK_OUTPUT_REPAIR_R6R2L_R17R1R4`

## PREVIOUS_RESULT
`RETURN_R17R1R3_ROLLBACK_OUTPUT_CAPTURE_DEFECT`

Owner-local offline evidence:
- helper blob `3d7797a21c31fb805993530b28d674db4cdf288c`
- validator blob `4d490bdbe8f686053cccae8310c72ff74117600b`
- forward executable fixture PASS
- forward mv count = 1
- rollback fixture reached production forward-failure branch but did not expose `R17_ROLLBACK_ATTEMPT=YES`
- fixture root cleanup PASS
- no Provider/config/Secret/DPAPI/SSH/VPS/network action

## ROOT CAUSE
`Invoke-R17Rollback` writes sanitized rollback markers to the success output stream and then returns a Boolean. Its callers assign the whole output stream directly:

`$rollbackOk=Invoke-R17Rollback ...`

Therefore:
1. rollback markers are captured into the variable instead of propagating to the parent output stream;
2. `$rollbackOk` can become an Object[] rather than the intended Boolean;
3. truth testing can be influenced by array non-emptiness instead of only the final rollback success value.

This is a production helper correctness issue and blocks R17 release.

## OBJECTIVE
Make rollback result handling explicit and type-safe while preserving all sanitized rollback markers in the parent output stream.

## MAX_ENDPOINT_THIS_ROUND
Modify only:
- `scripts/g4b-baidu-stale-pending-quarantine-r17.ps1`
- bounded validator/evidence updates only if required by the helper behavior change.

No Provider action, Owner config read, Secret/DPAPI, SSH/VPS/Clash/network mutation, or real R17 Run.

## REQUIRED CHANGE
At every `Invoke-R17Rollback` call site:
- capture the full emitted sequence as an array;
- require at least one returned item;
- interpret only the final item as the Boolean success value;
- emit every preceding sanitized marker back to the parent success output stream;
- reject a final item that is not Boolean.

Do not change provider command scope, rollback decision conditions, or rollback target/source shapes.

A small helper function for normalizing the rollback return sequence is allowed if it reduces duplication and remains local/source-only.

## REQUIRED VALIDATION
- helper AST PASS
- validator AST PASS
- provider allowlist unchanged
- normal offline validator PASS
- inherited LASTEXITCODE regression PASS
- forward executable fixture PASS with mv count 1
- rollback executable fixture PASS with mv count 2
- rollback output contains:
  - `R17_ROLLBACK_ATTEMPT=YES`
  - `R17_ROLLBACK_PRECHECK=PASS`
  - `R17_ROLLBACK_READBACK=PASS`
  - `R17_RESULT=RETURN_FORWARD_FAILED_ROLLED_BACK`
- cleanup PASS
- no real Provider/config/Secret/DPAPI/SSH/VPS/network action
- final helper and validator blobs reported
- changed-file scope reported

## ACCEPTANCE
`PASS_CANDIDATE_R17R1R4_ROLLBACK_OUTPUT_REPAIR` only if both forward and rollback executable offline fixtures pass and rollback success is proven by the final Boolean, not array truthiness.

## OWNER_ONLY_ACTIONS
Local PowerShell source edit/test only. Do not run the real R17 checkpoint.

## REVIEWER_TO_EXECUTOR_RELAY
Repair only rollback output/result normalization. Preserve rollback markers and convert only the final returned object to a strict Boolean after asserting its type. Apply at every production call site, rerun existing offline validator plus forward/rollback executable fixtures, report final blobs, and stop.

## EXECUTOR_TO_REVIEWER_RELAY
Return result / changed files / validation markers / final blobs / problems / rollback / Owner transfer. Owner transfer must be NONE.
