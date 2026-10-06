# G4-B R17 Validator Negative Fixtures R6R2L-R17R1R5

Status: PREPARED / VALIDATOR_ONLY / NO_PROVIDER_ACTION

## GATE_ID
`G4B_BAIDU_STALE_PENDING_QUARANTINE_VALIDATOR_NEGATIVE_FIXTURES_R6R2L_R17R1R5`

## PREVIOUS_RESULT
`PARTIAL_R17R1_FINAL_REVIEW_MISSING_NEGATIVE_FIXTURES`

Durable production identities at preparation:
- helper blob: `9c910628932c22c448c822437fd53e0b71804a9c`
- validator blob: `4d490bdbe8f686053cccae8310c72ff74117600b`
- helper forward executable fixture: PASS
- helper rollback executable fixture: PASS
- rollback markers: PASS
- normal offline validator: PASS
- inherited LASTEXITCODE regression: PASS

## OBJECTIVE
Close only the remaining parent R17R1 evidence gap by adding executable negative fixtures for:
1. multiple canonical pending objects;
2. final production object present.

Both fixtures must prove the production R17 precondition (final=0 / pending=1 / unknown=0) would reject the state.

Also emit explicit parent-Gate evidence markers for the existing source/target shape guards already enforced by production source and validator static checks.

## MAX_ENDPOINT_THIS_ROUND
Modify only:
- `scripts/g4b-baidu-stale-pending-quarantine-r17-validator.ps1`
- bounded evidence/handoff records.

Helper source is frozen at `9c910628932c22c448c822437fd53e0b71804a9c`.

No Provider action, Owner config read, Secret/DPAPI, SSH/VPS/Clash/network action, or real R17 Run.

## REQUIRED CHANGE
Add deterministic synthetic listing fixtures:
- two distinct canonical pending names -> `PendingCount=2`, no single pending identity, production precondition rejects;
- final object present (with otherwise valid pending state) -> `FinalCount=1`, production precondition rejects.

Add/retain explicit validator output markers:
- `R17_FIXTURE_MULTIPLE_PENDING_REJECT=PASS`
- `R17_FIXTURE_FINAL_PRESENT_REJECT=PASS`
- `R17_SOURCE_TARGET_SHAPE_GUARDS=PASS`

Do not alter production helper.

## REQUIRED VALIDATION
- helper blob unchanged at `9c910628932c22c448c822437fd53e0b71804a9c`
- validator AST PASS
- normal offline validator PASS
- inherited LASTEXITCODE=37 regression PASS
- existing one-pending/quarantine/directory/unknown fixtures remain PASS
- new multiple-pending fixture PASS
- new final-present fixture PASS
- default non-mutating execution PASS
- Provider/config/Secret/DPAPI/SSH/VPS/network actions NO
- real R17 Run NO
- final validator blob reported
- changed-file scope validator-only

## ACCEPTANCE
`PASS_CANDIDATE_R17R1R5_NEGATIVE_FIXTURES` only if both new fixtures execute and pass, all existing validator assertions still pass, helper identity remains frozen, and final validator blob is reported.

After durability to canonical main and fresh readback, Reviewer may perform the parent R17R1 final acceptance without re-running real/provider actions.

## OWNER_ONLY_ACTIONS
Local validator edit/test and later scoped commit/push only. Do not run real R17.

## REVIEWER_TO_EXECUTOR_RELAY
Add only the two missing negative listing fixtures and explicit shape-guard marker to the validator. Preserve all existing fixtures and default non-mutating checks. Run normal validator and LASTEXITCODE=37 regression on PowerShell 7.6.6, report final validator blob, then stop.

## EXECUTOR_TO_REVIEWER_RELAY
Return result / changed file / validation markers / final validator blob / problems / rollback / Owner transfer. Owner transfer must be NONE.
