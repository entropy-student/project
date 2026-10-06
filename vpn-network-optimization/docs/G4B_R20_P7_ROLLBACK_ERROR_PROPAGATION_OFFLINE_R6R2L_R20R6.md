# G4-B R20 P7 / Rollback Error Propagation Offline Repair — R6R2L-R20R6

Status: EXECUTOR_ACTION_REQUIRED_OFFLINE / NO_LIVE_ACTION

## GATE_ID
`G4B_R20_P7_ROLLBACK_ERROR_PROPAGATION_OFFLINE_R6R2L_R20R6`

## PREVIOUS_RESULT
`PASS_R20R5_EXACT_PENDING_SET_CLEAN`

## ACCEPTED R20 CLOSEOUT FACTS
```text
R20_REMOTE_CONSEQUENTIAL_SURFACE=CLEAN
R20_REMOTE_TRANSACTION_RESIDUE=CLEAN
R20_FAILED_RUN_RECOVERY_PENDING_SET=CLEAN
R20_RECOVERY_FINAL_ARTIFACTS=ABSENT
R20_ROLLBACK_JOURNAL=RETAINED
WG_HEALTHY=YES
HY2_HEALTHY=YES
R20_SECOND_LIVE_ATTEMPT=FORBIDDEN
```

## REVIEWER CODE FINDING

The current runner loses structured remote error information:

1. the remote supervisor emits JSON such as `{"ok":false,"error_code":"REALITY_LISTENER_READBACK_INVALID"}` or `REMOTE_NATIVE_COMMAND_FAILED`;
2. `Invoke-Remote` checks the SSH process exit code before parsing stdout;
3. any remote GateError therefore collapses to `SSH_REMOTE_ACTION_FAILED` instead of preserving the remote `error_code`;
4. the top-level failure path can further collapse unexpected exceptions to `UNCLASSIFIED`;
5. the automatic rollback catch emits only `REMOTE_ROLLBACK=UNKNOWN_REQUIRES_RECONCILIATION` and discards its bounded error code.

The historical R20 output therefore cannot establish the exact P7 low-level cause. Do not infer one retrospectively.

## OBJECTIVE

Offline-only repair of error propagation and diagnostics so the next live Gate can distinguish:
- remote native command failure;
- service/listener readback failure;
- remote unclassified exception;
- SSH transport failure;
- JSON/response-shape failure;
- bounded rollback failure code.

## REQUIRED MINIMUM REPAIR

1. **Invoke-Remote structured error propagation**
   - collect stdout/stderr and exit code;
   - when stdout is valid bounded JSON with `ok=false` and allowlisted uppercase `error_code`, propagate that code even when SSH process exit is nonzero;
   - use SSH/transport fallback codes only when no trustworthy structured response exists;
   - never emit stderr or Secret-bearing remote output.

2. **Remote generic exception classification**
   - keep sanitized `REMOTE_UNCLASSIFIED` fallback;
   - do not expose exception text, config, credentials, command arguments, or Secret values.

3. **Rollback error evidence**
   - automatic rollback failure must emit a sanitized bounded marker such as `REMOTE_ROLLBACK_FAILURE_CODE=<ALLOWLISTED_CODE>`;
   - preserve `REMOTE_ROLLBACK=UNKNOWN_REQUIRES_RECONCILIATION` when rollback is unverified;
   - no blind retry behavior.

4. **Fixture coverage**
   Prove offline fixtures for at least:
   - remote GateError + nonzero exit + valid JSON preserves `REALITY_LISTENER_READBACK_INVALID`;
   - remote native command failure preserves `REMOTE_NATIVE_COMMAND_FAILED`;
   - remote generic exception yields `REMOTE_UNCLASSIFIED`;
   - SSH failure with no valid structured JSON yields transport fallback;
   - malformed/oversized remote stdout fails closed;
   - rollback GateError exposes bounded rollback failure code while remaining UNKNOWN;
   - success behavior and existing R19R1 fingerprint render regression remain PASS.

5. **No change to consequential semantics**
   - no service/network/provider/Clash/Secret action;
   - no new retry;
   - no change to HY2/WG/REALITY role order;
   - no change to AUTO_SWITCHING=OFF;
   - no deletion of retained R20 rollback journal in this Gate.

## REQUIRED EVIDENCE
```text
R20R6_INVOKE_REMOTE_STRUCTURED_ERROR_PROPAGATION=PASS
R20R6_REMOTE_GATEERROR_FIXTURE=PASS
R20R6_REMOTE_NATIVE_COMMAND_FIXTURE=PASS
R20R6_REMOTE_UNCLASSIFIED_FIXTURE=PASS
R20R6_SSH_TRANSPORT_FALLBACK_FIXTURE=PASS
R20R6_MALFORMED_RESPONSE_FAIL_CLOSED=PASS
R20R6_ROLLBACK_FAILURE_CODE_FIXTURE=PASS
R20R6_SUCCESS_REGRESSION=PASS
R20R6_R19R1_FINGERPRINT_REGRESSION=PASS
POWERSHELL_AST=PASS
LIVE_RUNNER_FIXTURES=PASS
REAL_SECRET_OR_DPAPI_ACCESS=NO
SSH_OR_VPS_ACTION=NO
PROVIDER_ACTION=NO
CLASH_PROFILE_MUTATION=NO
NETWORK_MUTATION=NO
STOP_AT_REVIEWER=YES
```

## ACCEPTANCE

PASS_CANDIDATE only when the smallest source repair and executable offline fixtures prove the above behavior. No new live Gate is released until Reviewer formally accepts R20R6.

## AUTHORIZATION

Standing Owner authorization covers the documented roadmap, but this Gate is offline-only and requires no consequential authorization.

## STOP
`STOP_AT_REVIEWER=YES`
