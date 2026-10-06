# G4-B R17 Validator LASTEXITCODE Repair R6R2L-R17R1R2

Status: PREPARED / LOCAL_CODE_REPAIR_ONLY / NO_PROVIDER_ACTION

## GATE_ID
`G4B_BAIDU_STALE_PENDING_QUARANTINE_VALIDATOR_LASTEXITCODE_REPAIR_R6R2L_R17R1R2`

## PREVIOUS_RESULT
`RETURN_R17R1R1_STALE_LASTEXITCODE_FALSE_FAILURE`

Accepted Owner-local evidence:
- R17R1R1 preflight PASS
- fixture-newline repair PASS
- change scope PASS
- helper blob unchanged: `3d7797a21c31fb805993530b28d674db4cdf288c`
- repaired validator AST PASS
- normal offline validator PASS
- inherited `$LASTEXITCODE=37` regression FAIL with `R17_VALIDATOR_DEFAULT_EXECUTION_EXIT`
- local repaired validator blob before this Gate: `c468f99128ebad1f84cfbb0f8a1ec4dc6d6fc3a6`
- Provider/Owner-config/Secret/DPAPI/SSH/VPS/network actions: NONE
- R17 Run mode: NOT EXECUTED

## OBJECTIVE
Remove the validator's false dependency on inherited `$LASTEXITCODE` after invoking the helper's default PowerShell script path, then prove both normal and deliberately stale-LASTEXITCODE runs pass offline.

## ROOT CAUSE
The validator currently executes the helper as a PowerShell script and then asserts that `$LASTEXITCODE` is zero or null. PowerShell script invocation does not reset `$LASTEXITCODE` when no native process is run, so an unrelated earlier native exit code can survive and create a false failure. Script exceptions are already fail-closed through `$ErrorActionPreference='Stop'` and the validator's required output-marker checks.

## MAX_ENDPOINT_THIS_ROUND
Modify only:
- `scripts/g4b-baidu-stale-pending-quarantine-r17-validator.ps1`
- bounded evidence/handoff records.

Helper source remains frozen.

## REQUIRED CHANGE
Remove only the stale `$LASTEXITCODE` assertion:
`Assert-R17Validator ($LASTEXITCODE -eq 0 -or $null -eq $LASTEXITCODE) 'R17_VALIDATOR_DEFAULT_EXECUTION_EXIT'`

Do not replace it with another native-exit assumption. Continue to rely on:
- terminating PowerShell errors;
- required `R17_VALIDATION=PASS` marker;
- required `R17_DEFAULT_MODE=NON_MUTATING` marker;
- required `BAIDU_PROVIDER_ACTION=NO` marker;
- absence of runtime stage markers.

## REQUIRED VALIDATION
- helper blob remains `3d7797a21c31fb805993530b28d674db4cdf288c`
- validator AST PASS
- normal offline validator PASS
- inherited `$LASTEXITCODE=37` offline validator PASS
- final validator blob reported
- diff limited to validator
- no Provider/Owner config/Secret/DPAPI/SSH/VPS/network action
- no R17 Run mode

## ACCEPTANCE
`PASS_CANDIDATE_R17R1R2_LASTEXITCODE_REPAIR` only if both normal and stale-LASTEXITCODE offline runs PASS and final source identity is reported.

This does not complete parent R17R1 by itself; Reviewer must next assess whether forward/rollback executable offline evidence is still outstanding.

## OWNER_ONLY_ACTIONS
NONE consequential. Local file edit/test only.

## REVIEWER_TO_EXECUTOR_RELAY
Continue from the current local dirty validator blob `c468f99128ebad1f84cfbb0f8a1ec4dc6d6fc3a6`. Do not discard the accepted fixture-newline repair. Remove only the obsolete LASTEXITCODE assertion, rerun normal validator and stale-LASTEXITCODE regression, report final validator blob, and stop.

## EXECUTOR_TO_REVIEWER_RELAY
Return: result / changed file / validation / final validator blob / problems / rollback / Owner transfer. Owner transfer must be NONE.
