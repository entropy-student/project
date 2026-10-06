# G4-B R17 Validator Fixture Repair R6R2L-R17R1R1

Status: PREPARED / LOCAL_CODE_REPAIR_ONLY / NO_PROVIDER_ACTION

## GATE_ID
`G4B_BAIDU_STALE_PENDING_QUARANTINE_VALIDATOR_FIXTURE_REPAIR_R6R2L_R17R1R1`

## PREVIOUS_RESULT
`RETURN_R17R1_OFFLINE_VALIDATOR_DIRECTORY_HEADER_INVALID`

Owner-local evidence:
- PowerShell 7.6.6: PASS
- Administrator: PASS
- canonical repo root: PASS
- safe fast-forward to `62dbb97b0768857f40b7bd7e16b300475a4ea9e5`: PASS
- helper blob `3d7797a21c31fb805993530b28d674db4cdf288c`: PASS
- validator blob `359cddf73075c090396a49d106022efd3f078029`: PASS
- helper AST: PASS
- validator AST: PASS
- provider allowlist: PASS
- forbidden provider action scan: PASS
- offline validator: FAIL with `BAIDU_DIRECTORY_HEADER_INVALID`
- R17 Run mode: NOT EXECUTED
- Provider/Owner config/Secret/DPAPI/SSH/VPS/network actions: NONE

## OBJECTIVE
Repair the offline validator fixture encoding bug only, then rerun the complete offline validator and the stale-`$LASTEXITCODE` regression.

Reviewer source inspection identified the immediate defect: PowerShell double-quoted strings use the backtick escape for newline. The validator fixtures currently embed literal `\n`, so `Assert-R17DirectoryHeader` sees one physical line containing backslash-n text and fails before the real parser fixtures execute.

## MAX_ENDPOINT_THIS_ROUND
Modify only:
- `scripts/g4b-baidu-stale-pending-quarantine-r17-validator.ps1`
- bounded evidence/handoff records.

Do not modify the R17 helper unless a new independent defect is proven and Reviewer opens another Gate.

## REQUIRED CHANGE
In the synthetic listing fixtures only, replace literal `\n` separators with actual PowerShell newline escapes (for example ``n`) or an equivalent deterministic newline construction.

Affected fixture families include:
- one pending
- post-forward quarantine file
- quarantine-directory collision
- pending-directory rejection
- unknown-project-object rejection

Do not globally replace `\n` across unrelated regex/source text.

## REQUIRED VALIDATION
On Owner-compatible PowerShell 7.6.6:
- validator AST PASS
- helper blob remains exactly `3d7797a21c31fb805993530b28d674db4cdf288c`
- normal offline validator returns `R17_OFFLINE_VALIDATOR=PASS`
- fixture markers for pending/quarantine/directory/unknown states PASS
- deliberate inherited `$LASTEXITCODE=37` rerun is executed and separately classified
- no Provider action
- no Owner config read
- no Secret/DPAPI access
- no SSH/VPS/Clash/network mutation
- no R17 Run mode

If normal validator still fails, RETURN with the exact sanitized failure.  
If normal validator passes but stale-`$LASTEXITCODE` regression fails, RETURN for a separate minimal validator repair; do not combine defects.

## ACCEPTANCE
`PASS_CANDIDATE_R17R1R1_VALIDATOR_FIXTURE_REPAIR` only if the normal offline validator passes after the scoped fixture repair and the final validator blob is reported.

The stale-`$LASTEXITCODE` result must be reported independently; a failure there blocks parent R17R1 completion.

## OWNER_ONLY_ACTIONS
NONE consequential. Local file edit/test only.

## REVIEWER_TO_EXECUTOR_RELAY
Apply only the fixture-newline repair described above. Do not alter helper behavior, provider command scope, or consequential logic. Run offline validation locally, report final validator blob, then stop for Reviewer.

## EXECUTOR_TO_REVIEWER_RELAY
Return: result / changed file / exact validation markers / final validator blob / problems / rollback / Owner transfer. Owner transfer must be NONE.
