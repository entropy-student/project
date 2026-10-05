# G4-B Baidu Pipeline Output Repair R6R2L-R8

Status: ACTIVE / OWNER_LOCAL_OFFLINE_VALIDATION

## GATE_ID

`G4B_BAIDU_PIPELINE_OUTPUT_REPAIR_R6R2L_R8`

## PREVIOUS_RESULT

`RETURN_R6R2L_R7_ROOT_CAUSE_IDENTIFIED`

## ROOT CAUSE

R7 reproduced the R5 P5 failure at the Baidu `who` boundary with:

```text
DIAGNOSTIC_EXCEPTION_TYPE=System.Management.Automation.PropertyNotFoundException
```

Direct source inspection found the same defect in both the live runner and R7 diagnostic process wrappers:

```powershell
$psi.Environment.Remove([string]$key)
```

`Remove()` returns a Boolean. Because PowerShell functions emit uncaptured expression results to the success stream, those Booleans polluted the helper output before the final process-result object. Under StrictMode, downstream access such as `$result.StdOut` / `$who.ExitCode` encountered nonconforming objects and raised `PropertyNotFoundException`. In the live runner, that non-uppercase .NET exception was normalized only at the outer catch to `UNCLASSIFIED`.

## REPAIR

The live runner and R7 diagnostic now explicitly suppress the return value:

```powershell
[void]$psi.Environment.Remove([string]$key)
```

The live-runner fixture validator now requires this suppression contract and includes a negative regression fixture that removes `[void]` and must fail.

## LOCKED SOURCES

```text
LIVE_RUNNER_BLOB=388714218a7a6f1671777488b0c581812f6cc9eb
LIVE_RUNNER_VALIDATOR_BLOB=eac0f9684b8f98b71c856e4d297da03f867b2d51
BAIDU_READONLY_DIAGNOSTIC_BLOB=d0849cc7ba310312c23adeda9aae5e355f9ba10a
```

## OBJECTIVE

Run the full offline live-runner fixture validator and prove the Baidu pipeline-output repair plus all previous positive and negative contracts.

## REQUIRED PASS

In addition to all existing fixtures:

```text
G4B_FIXTURE_R6R2L_R8_BAIDU_ENV_REMOVE_OUTPUT_SUPPRESSED=PASS
G4B_FIXTURE_NEGATIVE_BAIDU_ENV_REMOVE_STREAM_POLLUTION=PASS
G4B_LIVE_RUNNER_FIXTURES=PASS
NEGATIVE_FIXTURES=PASS
SSH_OR_VPS_ACTION=NO
DPAPI_OR_REAL_SECRET_ACCESS=NO
EXTERNAL_REQUESTS=0
NETWORK_MUTATION=NO
```

## FORBIDDEN

- live runner invocation;
- Baidu network/API commands;
- SSH/VPS action;
- DPAPI/real Secret access;
- recovery/profile/service/route/proxy/TUN mutation;
- G4-C.

## STOP

`STOP_AT_REVIEWER=YES`
