# G4-B R21 P0 Gate Binding Offline Repair — R6R2L-R21R1

Status: EXECUTOR_ACTION_REQUIRED_OFFLINE / NO_LIVE_ACTION

## GATE_ID
`G4B_R21_P0_GATE_BINDING_OFFLINE_R6R2L_R21R1`

## PREVIOUS_STATE
`R21_RELEASED_UNEXECUTED`

## REVIEWER FINDING
The released R21 runner still checks the historical Handoff line:
`GATE_ID=G4B_PERSISTENT_THREE_ROLE_READINESS`.

Canonical `REVIEWER_HANDOFF.md` correctly names the current live Gate:
`G4B_PERSISTENT_THREE_ROLE_LIVE_AFTER_R20R6_R6R2L_R21`.

Executing the released runner as-is would therefore fail at P0 with
`LIVE_G4B_GATE_NOT_CURRENT` before consequential mutation and would unnecessarily consume the one-shot workflow.

## OBJECTIVE
Repair only the stale canonical Gate-id binding in:
1. `scripts/g4b-persistent-three-role-live-runner.ps1`;
2. the matching CRLF/source contract in `scripts/g4b-live-runner-fixture-validator.ps1`.

## LOCKED INPUT IDENTITIES
```text
PRE_REPAIR_MAIN=66d8e37938978a4335ccb07469e8f6be1af8aa3e
PRE_REPAIR_RUNNER_BLOB=4bd7df28e93f29d9d1d2b29ea0be29b2ea43657b
PRE_REPAIR_LIVE_FIXTURE_VALIDATOR_BLOB=e4bb719b9a1b24f81d2322e0615ba44d1d4d8b06
R21_LIVE_INVOCATIONS_CONSUMED=0
```

## ALLOWED SCOPE
- exact source-literal repair only;
- corresponding fixture expectation repair only;
- PowerShell AST/static/fixture/package validation;
- documentation/evidence needed to release the corrected R21 candidate.

## FORBIDDEN
- no `-Live` invocation;
- no SSH/VPS/provider/Secret/DPAPI/Clash/network mutation;
- no R20 replay;
- no role-order/AUTO_SWITCHING change;
- no second repair strategy without Reviewer reconciliation.

## REQUIRED EVIDENCE
```text
RUNNER_GATE_BINDING_SOURCE=PASS
FIXTURE_GATE_BINDING_SOURCE=PASS
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
Formal PASS only after the patched source identities are recorded and the PowerShell AST + live fixture validator + package validator all pass on PowerShell 7.6.6.

After PASS, update the existing unexecuted R21 Gate to the repaired runner/validator identities and release exactly one live invocation. The original R21 live invocation count remains zero.

## AUTHORIZATION
Covered by the Owner's standing authorization for the documented roadmap. No additional Owner authorization prompt is required.

## STOP
`STOP_AT_REVIEWER=YES`
