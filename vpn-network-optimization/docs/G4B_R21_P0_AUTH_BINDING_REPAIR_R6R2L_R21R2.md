# G4-B R21 P0 Authorization Binding Repair — R6R2L-R21R2

Status: EXECUTOR_ACTION_REQUIRED_OFFLINE / NO_LIVE_ACTION

## GATE_ID
`G4B_R21_P0_AUTH_BINDING_REPAIR_R6R2L_R21R2`

## PREVIOUS_RESULT
`RETURN_R21_P0_REVIEWER_LIVE_AUTHORIZATION_MISSING_NO_MUTATION`

## OBSERVED R21 RESULT
```text
R21_LIVE_INVOCATIONS_CONSUMED=1
RUNNER_FAILED_PHASE=P0_CANONICAL_SOURCE
FAILURE_CODE=REVIEWER_LIVE_AUTHORIZATION_MISSING
CONSEQUENTIAL_MUTATION_STARTED=NO
R21_NATIVE_EXIT=1
R21_SOURCE_WORKTREE_CLEANUP=PASS
```

R21 is consumed and must not be invoked again. No consequential mutation began, so no live rollback is required.

## REVIEWER FINDING
The R21 runner required the stale line:
`LIVE_G4B_EXECUTION_AUTHORIZED=YES`

The canonical Handoff instead used the explicit one-shot contract:
```text
R21_LIVE_INVOCATIONS_CONSUMED=0
R21_LIVE_INVOCATIONS_AUTHORIZED=1
SECOND_R21_LIVE_INVOCATION_AUTHORIZED=NO
```

R21R1 repaired only the Gate-id binding and missed this second stale authorization binding.

## OBJECTIVE
Prepare a fresh R22 one-shot live Gate by changing only the live-source binding contract and its matching fixture:

1. bind the runner to the new R22 Gate id;
2. require the exact R22 one-shot fields:
   - `R22_LIVE_INVOCATIONS_CONSUMED=0`
   - `R22_LIVE_INVOCATIONS_AUTHORIZED=1`
   - `SECOND_R22_LIVE_INVOCATION_AUTHORIZED=NO`
3. retain the accepted Baidu second-failure-domain binding;
4. update only the matching fixture/CRLF source expectations;
5. validate PowerShell AST, live fixtures, and package offline.

## LOCKED INPUT IDENTITIES
```text
R21_GATE_BLOB=78aff88a93d95ee1753a51d1d4fbf6cd0bfea404
PRE_REPAIR_RUNNER_BLOB=2b9a6e5f361905500b00c71548118e9046cd89de
PRE_REPAIR_LIVE_FIXTURE_VALIDATOR_BLOB=b44fe52a560694dcb49ef0dfece0db253b7aa7a7
PACKAGE_VALIDATOR_BLOB=59e18226dff66adcaac978b4b7eeb540a14514c9
THREE_ROLE_TEMPLATE_BLOB=21c9a73f965e55da0c5d161b3c051e0d3bab1aa0
```

## ALLOWED SCOPE
- exact runner current-Gate / one-shot authorization source binding repair;
- matching fixture expectations only;
- offline AST/static/fixture/package validation;
- Reviewer documentation/evidence required to release R22.

## FORBIDDEN
- no R21 replay;
- no `-Live` execution;
- no SSH/VPS/provider/Secret/DPAPI/Clash/network action;
- no role order or AUTO_SWITCHING change;
- no rollback action because R21 consequential mutation never began.

## REQUIRED EVIDENCE
```text
RUNNER_R22_GATE_BINDING_SOURCE=PASS
RUNNER_R22_ONE_SHOT_BINDING_SOURCE=PASS
FIXTURE_R22_BINDING_SOURCE=PASS
CRLF_BINDING_BEHAVIOR=PASS
POWERSHELL_AST_RUNNER=PASS
POWERSHELL_AST_VALIDATOR=PASS
LIVE_RUNNER_FIXTURES=PASS
PACKAGE_VALIDATOR=PASS
LIVE_INVOCATION=NO
SSH_OR_VPS_ACTION=NO
PROVIDER_ACTION=NO
SECRET_OR_DPAPI_ACCESS=NO
CLASH_OR_NETWORK_MUTATION=NO
```

## ACCEPTANCE
Formal PASS only after executable offline validation. After PASS, release a fresh R22 Gate for exactly one live invocation. R21 remains consumed forever.

## AUTHORIZATION
Covered by Owner standing authorization for the documented closeout roadmap and the explicit instruction that subsequent authorizations within that roadmap are granted.

## STOP
`STOP_AT_REVIEWER=YES`
