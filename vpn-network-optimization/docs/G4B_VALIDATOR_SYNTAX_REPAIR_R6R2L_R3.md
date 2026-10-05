# G4-B Validator Syntax Repair R6R2L-R3

Status: ACTIVE / OWNER_LOCAL_OFFLINE_VALIDATION

## GATE_ID

`G4B_VALIDATOR_SYNTAX_REPAIR_R6R2L_R3`

## PREVIOUS_RESULT

`RETURN_R6R2L_R2_VALIDATOR_PARSER_ERROR`

## FAILURE FACTS

```text
OWNER_RUNTIME=PASS
PRE_SYNC_PROJECT_STATUS=PASS
PREEXISTING_RESULTS_PRESERVED=YES
HEAD_BEFORE=e5152337720618ce88657c5ae01e4bdcc66383a2
ORIGIN_MAIN=89e458c81475b110411b8ff10f789b52c79bcc34
FAST_FORWARD=PASS
HEAD_AFTER=89e458c81475b110411b8ff10f789b52c79bcc34
LOCKED_SOURCE_IDENTITY=PASS
CURRENT_GATE_ALIGNMENT=PASS
VALIDATOR_RESULT=PARSER_ERROR
CONSEQUENTIAL_MUTATION_STARTED=NO
```

The validator did not begin fixture execution. PowerShell rejected the validator source before runtime because the R2 source-contract assertion was written as one oversized compound expression and parsed incorrectly.

## REPAIR

Only `g4b-live-runner-fixture-validator.ps1` changed.

The single compound canonical-source contract expression was split into individually named booleans and a final conjunction. The live runner remains byte-identical to the accepted R2 repair.

Locked sources:

```text
LIVE_RUNNER_BLOB=8b099e4229642bf439eb03c0d1e9cce0f8e698bd
LIVE_RUNNER_VALIDATOR_BLOB=753570734f82e75ab0a0ec56c4a8c6f0d3c469cb
```

## OBJECTIVE

Run the full live-runner fixture validator on the Owner Windows host and prove the R2 Unicode-root / CRLF / accepted-results repair plus all prior regressions.

## REQUIRED PASS

Same R2 acceptance markers remain required:

```text
G4B_FIXTURE_R6R2L_R1_GIT_PROJECT_PREFIX=PASS
G4B_FIXTURE_R6R2L_R2_DOTNET_REPO_PARENT=PASS
G4B_FIXTURE_R6R2L_R1_GIT_ROOT_DISCOVERY=PASS
G4B_FIXTURE_R6R2L_R2_UNICODE_SAFE_GIT_ROOT=PASS
G4B_FIXTURE_R6R2L_R1_GIT_RUNNER_ROOT_PATH_QUERY=PASS
G4B_FIXTURE_R6R2L_R1_GIT_HANDOFF_ROOT_PATH_QUERY=PASS
G4B_FIXTURE_R6R2L_R1_GIT_STATUS_ROOT_PATH_QUERY=PASS
G4B_FIXTURE_R6R2L_R2_PROJECT_STATUS_ACCEPTED_RESULTS_ONLY=PASS
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
