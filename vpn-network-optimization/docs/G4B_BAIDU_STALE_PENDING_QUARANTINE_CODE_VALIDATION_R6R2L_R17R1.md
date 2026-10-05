# G4-B Baidu Stale Pending Quarantine Code Validation R6R2L-R17R1

Status: PREPARED / EXECUTOR_LOCAL_OFFLINE_ONLY / R17_PROVIDER_EXECUTION_BLOCKED

## GATE_ID

`G4B_BAIDU_STALE_PENDING_QUARANTINE_CODE_VALIDATION_R6R2L_R17R1`

## OBJECTIVE

Confirm the current R17 helper/validator are actually usable before any Owner-local consequential provider action. Perform local offline review, targeted repair if required, and executable validation evidence. Do not contact Baidu, do not read Owner authentication config, and do not execute the R17 provider move.

Parent consequential Gate:
`G4B_BAIDU_STALE_PENDING_QUARANTINE_R6R2L_R17`

Parent Gate blob at R17R1 preparation:
`dccccf92969d37f5f83b7cb4b6f085cc0cdf566c`

Starting implementation identities:
`R17_HELPER_BLOB=3d7797a21c31fb805993530b28d674db4cdf288c`
`R17_VALIDATOR_BLOB=359cddf73075c090396a49d106022efd3f078029`

## MAX_ENDPOINT_THIS_ROUND

Local Codex may modify only:

- `scripts/g4b-baidu-stale-pending-quarantine-r17.ps1`
- `scripts/g4b-baidu-stale-pending-quarantine-r17-validator.ps1`
- Executor evidence/handoff records required by Governance.

The maximum endpoint is an offline `PASS_CANDIDATE` with final helper/validator blobs, exact test evidence, and mandatory Reviewer stop.

No Provider command, Owner authentication/config read, Secret/DPAPI access, SSH/VPS action, Clash/network mutation, live G4-B, G4-C, or R17 quarantine move is authorized in R17R1.

## MANDATORY_REVIEW_STOP

YES.

Even if every offline test passes, do not run `-Mode Run -OwnerAuthorized`. Return to Reviewer with final blobs and sanitized offline evidence.

## TARGET_AND_SCOPE

Primary target: prove the R17 source can be safely released for the already-authorized but currently suspended one-shot Owner checkpoint.

Required review includes the complete R17 helper and validator, not only the currently known validator issue.

Known issue that must be resolved or conclusively disproven with executable evidence:

- the validator currently inspects `$LASTEXITCODE` after invoking the helper's default PowerShell script path; `$LASTEXITCODE` may contain a stale native-process value unrelated to that script invocation, causing a false failure.

This known issue is not the limit of review. Codex must inspect the complete forward/rollback state machine, parser/cardinality logic, command allowlist, error handling, cleanup, and output contracts.

## APPLICABLE_CRITICAL_CONSTRAINTS

- R16 accepted provider state remains `final=0 / pending=1 / unknown=0`; R17R1 must not re-observe it remotely.
- R15 rollback journal remains retained and untouched.
- Owner's explicit R17 authorization remains recorded, but it is NOT RELEASED for execution while R17R1 is open.
- R17 consequences must not expand: at most one future source→quarantine `mv` and at most one exact rollback `mv`; permanent delete remains forbidden.
- Provider command scope in production source must remain no broader than `who / ls / mv`.
- No raw UID, provider object basename, cookie, credential, Secret, DPAPI material, or raw provider payload may enter Git, evidence, or chat.
- Automatic switching, live G4-B and G4-C remain out of scope.

## PREFLIGHT

Before editing:

1. Confirm canonical repository root and project path.
2. Safe-sync to canonical `main`; do not overwrite unrelated work.
3. Confirm the two starting blobs above or report drift and stop for reconciliation.
4. Confirm PowerShell runtime used for executable validation. Prefer the Owner-compatible PowerShell 7.6.6 baseline; if unavailable, report the exact runtime and do not claim exact-runtime validation.
5. Confirm no real Baidu config/provider/Secret access is required for any planned test.

## REQUIRED_EVIDENCE

At minimum provide all of the following:

- `R17R1_AST_HELPER=PASS`
- `R17R1_AST_VALIDATOR=PASS`
- `R17R1_DEFAULT_NONMUTATING=PASS`
- `R17R1_STATIC_PROVIDER_ALLOWLIST=PASS`
- `R17R1_FORBIDDEN_PROVIDER_ACTION_SCAN=PASS`
- `R17R1_LASTEXITCODE_REGRESSION=PASS`
- `R17R1_ONE_PENDING_FIXTURE=PASS`
- `R17R1_QUARANTINE_FILE_FIXTURE=PASS`
- `R17R1_QUARANTINE_DIRECTORY_COLLISION=PASS`
- `R17R1_PENDING_DIRECTORY_REJECT=PASS`
- `R17R1_UNKNOWN_PROJECT_OBJECT_REJECT=PASS`
- `R17R1_MULTIPLE_PENDING_REJECT=PASS`
- `R17R1_FINAL_PRESENT_REJECT=PASS`
- `R17R1_SOURCE_TARGET_SHAPE_GUARDS=PASS`
- `R17R1_FORWARD_ROLLBACK_REVIEW=PASS`
- `R17R1_TEMP_CLEANUP_REVIEW=PASS`
- `R17R1_OFFLINE_VALIDATOR=PASS`
- `R17R1_SECRET_SCAN=PASS`
- `R17R1_PROVIDER_ACTION=NO`
- `R17R1_OWNER_CONFIG_READ=NO`
- `R17R1_SECRET_OR_DPAPI_ACCESS=NO`
- `R17R1_SSH_OR_VPS_ACTION=NO`
- `R17R1_NETWORK_MUTATION=NO`
- `R17R1_R17_RUN_MODE_EXECUTED=NO`
- final helper blob
- final validator blob
- exact changed-file list
- concise explanation of every source change.

For the `LASTEXITCODE` regression, the test must demonstrate that a deliberately non-zero pre-existing `$LASTEXITCODE` cannot cause the offline validator/default-helper validation path to fail or be misclassified.

For forward/rollback usability, offline executable fixtures are strongly preferred. If a branch cannot be executed offline without adding a test seam, Codex must either add a narrowly-scoped non-production test seam or return `PARTIAL`; static inspection alone is not enough to claim full branch usability.

## ACCEPTANCE_CRITERIA

`PASS_CANDIDATE` only if:

1. Both scripts parse on the stated PowerShell runtime.
2. The validator itself executes successfully offline.
3. The default helper path is demonstrably non-mutating.
4. The stale `$LASTEXITCODE` risk is removed and regression-tested.
5. All required positive/negative listing fixtures pass.
6. Source/target cardinality and file-vs-directory collision guards fail closed.
7. Forward/rollback logic has executable offline evidence or the Gate explicitly returns `PARTIAL` rather than inferring usability.
8. No forbidden provider action exists in the production command path.
9. No test reads real Owner config/Secret or reaches a Provider.
10. Final blobs are reported and no further code edit occurs after those blobs are captured.

Any unresolved ambiguity => `RETURN`.

## ROLLBACK_STATUS_OR_PLAN

R17R1 is source-only/offline. Repository source changes must remain reviewable and revertible through Git. Do not alter R15 local rollback artifacts or any runtime/provider state.

The R17 provider rollback plan remains frozen and unexercised.

## OWNER_ONLY_ACTIONS

NONE.

The Owner must not run the R17 one-shot checkpoint while R17R1 is open.

## REVIEWER_TO_EXECUTOR_RELAY

Work locally from canonical `main`. Review the full current R17 helper and validator. Fix only defects needed to make the existing bounded R17 design reliably usable; do not broaden scope or provider consequences.

Specifically verify the known stale-`$LASTEXITCODE` validator problem and add a regression fixture that begins with a non-zero inherited `$LASTEXITCODE`. Expand offline negative fixtures where needed to prove multiple pending, final-present, directory collisions, unknown project objects, and exact source/target shape rejection.

Do not use the real Baidu config, do not issue `who`, `ls`, or `mv` against the provider, and do not run helper `-Mode Run`. No network/VPS/Clash/Secret/DPAPI work.

If full forward/rollback behavior cannot be exercised offline with the current structure, add only the smallest test seam needed, keep it inert in normal production execution, and validate that normal/default behavior is unchanged. If safe proof still cannot be produced, return `PARTIAL` or `RETURN`; do not claim PASS from static reasoning.

Commit/push the code/evidence to `main`, fresh-read the final files, report final blobs, then stop for Reviewer.

## EXECUTOR_TO_REVIEWER_RELAY

Return exactly:

- 结果
- 改动
- 验证
- 问题
- 回滚
- 请 Reviewer 检查
- Owner 转交

The result must be one of:

- `PASS_CANDIDATE_R17R1_OFFLINE_CODE_VALIDATION`
- `PARTIAL_R17R1_OFFLINE_CODE_VALIDATION`
- `RETURN_R17R1_<REASON>`

Owner 转交 must be `NONE`.
