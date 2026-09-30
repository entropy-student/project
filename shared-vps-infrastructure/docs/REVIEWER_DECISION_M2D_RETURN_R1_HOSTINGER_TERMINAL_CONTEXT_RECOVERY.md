# Reviewer Decision — M2D Observation RETURN Accepted / R1 Hostinger Terminal Context Recovery

Date: 2026-09-30
Role: Reviewer / Architect / Gatekeeper

## Reviewed result

Owner reported:

```text
RESULT=RETURN_M2D_OBSERVATION_WINDOW_INCOMPLETE
T0=NOT_STARTED
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

The Executor could see the Hostinger Web Terminal tab in the browser list, but two binding/read attempts timed out. No command was sent, no target-host readback was obtained, and the observation clock was not started.

Reviewer accepts the RETURN as fail-closed.

## Classification

```text
M2D_REGRESSION_PROVEN=NO
M2D_OBSERVATION_STARTED=NO
M2D_T0_COMPLETED=NO
M2D_MUTATIONS=0
M2C_PASS_REOPENED=NO

FAILURE_CLASS=HOSTINGER_BROWSER_TERMINAL_CONTEXT_UNAVAILABLE
```

This is an execution-context failure only. It does not invalidate the accepted M2C production cutover.

## Current Gate

```text
CURRENT_GATE=M2D_R1_HOSTINGER_TERMINAL_CONTEXT_RECOVERY_AND_OBSERVATION_RESTART
CURRENT_GATE_STATUS=OWNER_BROWSER_CHECKPOINT_THEN_READONLY_RESUME
```

M2D remains read-only. No new Owner write authorization is required.

## Owner checkpoint

Owner manually:

1. opens the Hostinger VPS browser terminal for the Mini Craft target VPS;
2. waits until the shell is visibly interactive;
3. leaves that terminal tab open and stable.

Owner must not paste credentials, tokens, private keys, or Secret values into chat.

## Executor after Owner checkpoint

Before starting T0, bind to the active Hostinger terminal and prove:

```text
HOSTINGER_TERMINAL_CONTEXT=VERIFIED
TARGET_HOST=srv1970241
TARGET_HOST_EXECUTION_PROVEN=PASS
CONSOLE_USER=<safe username only>
```

A single harmless read-only identity command is permitted for this proof.

If terminal context still cannot be reliably bound/read:

```text
RETURN_TARGET_HOST_EXECUTION_UNAVAILABLE
T0=NOT_STARTED
MUTATIONS=0
STOP_AT_REVIEWER=YES
```

Do not retry direct SSH. The deferred SSH stability investigation remains separate.

## Observation restart rule

If terminal context is verified, restart the original M2D packet from a fresh T0.

The previous failed attempt contributes zero checkpoints.

Required observation remains:

```text
T0
T+5 minutes
T+10 minutes
```

All original M2D read-only predicates and mutation prohibitions remain unchanged.

Do not backdate or reuse M2C/M2B historical runtime facts as an M2D checkpoint.

## Evidence

If R1 cannot establish terminal context and T0 does not start, a short canonical Evidence/Handoff record is permitted but not required to claim any runtime fact.

If T0 starts, persist the complete M2D result in Shared VPS Evidence/Handoff before returning.

## Success

Success is the unchanged original M2D PASS contract:

```text
PASS_CANDIDATE_M2D_PUBLIC_REGRESSION_AND_OBSERVATION
OBSERVATION_CHECKPOINTS=3
MUTATIONS=0
M2E_ENTERED=NO
STOP_AT_REVIEWER=YES
```
