# G4-B Live Runner Baidu UTF-8 Validation R6R2K

Status: ACTIVE / OWNER_LOCAL_OFFLINE_VALIDATION

## GATE_ID

`G4B_LIVE_RUNNER_BAIDU_UTF8_VALIDATION_R6R2K`

## PREVIOUS_RESULT

`PASS_G4B_BAIDU_UID_UTF8_DECODE_RETRY_R6R2J_R3`

## ACCEPTED POST-AUTH STATE

```text
BAIDU_AUTHENTICATION=PASS
BAIDU_UID_DISCOVERY=READY
BAIDU_UID_LOCAL_ONLY=YES
BAIDU_UID_RUNTIME_CLEANUP=PASS
```

The numeric UID remains Owner-local. Do not place it in chat/GitHub/Evidence.

## REVIEWER SOURCE REPAIR

The live G4-B runner now explicitly decodes redirected BaiduPCS-Go stdout/stderr as UTF-8 for all bounded Baidu CLI actions. This carries the proven R6R2J-R3 decoding fix into the actual recovery runner, including both `who` and Chinese-text `ls` parsing.

Locked candidate:

```text
LIVE_RUNNER_BLOB=cf7bc19b1accc142065416bc6c6525aa7b58fc23
LIVE_RUNNER_VALIDATOR_BLOB=5d560481b0367bc0ab783ddd51b4c27285dd5831
```

## OBJECTIVE

Run the existing G4-B live-runner fixture validator locally and prove the UTF-8 decode repair did not regress the accepted offline runner contract.

This Gate does not invoke the live runner.

## REQUIRED ACTION

On the accepted Owner Windows host:

1. safe fast-forward to current `main`;
2. verify the two locked blobs above;
3. run:
   `vpn-network-optimization/scripts/g4b-live-runner-fixture-validator.ps1`
4. return only the bounded validator result/markers.

## REQUIRED PASS

At minimum:

```text
R6R2K_BAIDU_CLI_UTF8_DECODE_LOCKED=PASS
G4B_LIVE_RUNNER_FIXTURE_VALIDATION=PASS
NETWORK_MUTATION=NO
SECRET_ACCESS=NO
STOP_AT_REVIEWER=YES
```

Equivalent existing validator PASS markers are acceptable if the final validator exit is 0 and the new UTF-8 marker is present.

## MINIMALITY DECISION

The historical independent R6R2 auth-readiness rerun is superseded for this post-auth path because the Owner has already completed a successful post-auth real `who` and obtained the unique numeric UID from the accepted authenticated config. Re-running the same config/UID comparison immediately would add no independent identity information.

The live runner still performs its own account guard before recovery/provider mutation using the Owner-local UID; that guard is retained.

## FORBIDDEN

- real `who`;
- provider file actions;
- authentication/re-authentication;
- config access beyond validator synthetic fixtures;
- live runner invocation;
- VPS/SSH/Clash/service/network mutation;
- G4-C workloads.

`STOP_AT_REVIEWER=YES`
