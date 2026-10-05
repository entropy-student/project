# G4-B CRLF Validator Assertion Repair R6R2L-R4

Status: ACTIVE / OWNER_LOCAL_OFFLINE_VALIDATION

## GATE_ID

`G4B_CRLF_VALIDATOR_ASSERTION_REPAIR_R6R2L_R4`

## PREVIOUS_RESULT

`RETURN_R6R2L_R3_CRLF_ASSERTION_FALSE_NEGATIVE`

## FAILURE FACTS

```text
OWNER_RUNTIME=PASS
FAST_FORWARD=PASS
LOCKED_SOURCE_IDENTITY=PASS
CURRENT_GATE_ALIGNMENT=PASS
RUNNER_AST=PASS
VALIDATOR_AST=PASS
UNICODE_GIT_ROOT=PASS
ROOT_RELATIVE_TRACKED_QUERY=PASS
ACCEPTED_RESULTS_ONLY_STATUS=PASS
FAILED_FIXTURE=R6R2L_R2_CRLF_HANDOFF_CONTRACT
CONSEQUENTIAL_MUTATION_STARTED=NO
```

## ROOT CAUSE

The live runner correctly contains the CRLF-compatible patterns `\r?$`. The validator's source-string assertion incorrectly searched for `\\r?$` because PowerShell does not treat backslash as a string escape character. Therefore the source assertion returned a false negative while the actual runner regex remained correct.

## REPAIR

Only `g4b-live-runner-fixture-validator.ps1` changed. The three `.Contains(...)` source checks now search for the exact single-backslash runner source text.

Locked sources:

```text
LIVE_RUNNER_BLOB=8b099e4229642bf439eb03c0d1e9cce0f8e698bd
LIVE_RUNNER_VALIDATOR_BLOB=5c8763350098f181f41b0b1e0799885da9e5d07d
```

## OBJECTIVE

Run the full offline fixture validator on the Owner Windows host and prove all R2/R3 repairs plus all prior regression fixtures.

## REQUIRED PASS

Same acceptance set as R3, including:

```text
G4B_FIXTURE_R6R2L_R2_CRLF_HANDOFF_CONTRACT=PASS
G4B_FIXTURE_R6R2L_R1_CANONICAL_GIT_ROOT_PATH_SCOPE=PASS
G4B_LIVE_RUNNER_FIXTURES=PASS
NEGATIVE_FIXTURES=PASS
NETWORK_MUTATION=NO
DPAPI_OR_REAL_SECRET_ACCESS=NO
EXTERNAL_REQUESTS=0
```

## FORBIDDEN

- live runner invocation;
- VPS/SSH/Baidu provider mutation;
- DPAPI/Secret access;
- Clash/service/route/proxy/TUN mutation;
- deleting or committing pre-existing `results/` artifacts;
- G4-C.

## STOP

`STOP_AT_REVIEWER=YES`
