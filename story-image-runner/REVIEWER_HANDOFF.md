# Story Image Runner — REVIEWER HANDOFF

> Role: Reviewer / Architect / Gatekeeper
> Source of truth: `PROJECT_RECORD.md`

## Current decision

```text
P0_PROJECT_INTAKE_GOVERNANCE = PASS
P0A_ARCHITECTURE_SAFETY_FREEZE = PASS
G1_LOCAL_PLUMBING_DRY_RUN = RELEASED TO EXECUTOR
```

## Why G1 is zero-quota

This is a browser-automation project. Governance requires a central fail-closed safe mode before the first real action.

Therefore G1 proves the plumbing without clicking the ChatGPT submit button or generating an image.

Only after Reviewer accepts G1 may G1.5 authorize one real image.

## Frozen G1 architecture

```text
CLI
→ localhost bridge
→ validated queue/state
→ extension polling/heartbeat
→ browser readiness state
→ dry-run result
```

G1 does not yet need a working ChatGPT DOM submit adapter.

## Reviewer acceptance focus

G1 PASS requires independent evidence for:

- `SAFE_MODE=true` default;
- live submission impossible in safe mode;
- bridge bound only to loopback;
- schema validation;
- path traversal rejection;
- duplicate-job rejection;
- abort clears or marks queued/in-flight dry-run state safely;
- extension/bridge heartbeat has stale detection;
- restart does not silently mark unfinished work successful;
- no cookie/token/session export;
- tests pass;
- no real image-generation action occurred.

## Current Executor entry

`docs/G1_EXECUTION_CONTRACT.md`

Executor must return:

```text
GATE=G1_LOCAL_PLUMBING_DRY_RUN
RESULT=PASS_CANDIDATE_G1_LOCAL_PLUMBING_DRY_RUN | RETURN_<PRECISE_REASON>
SUMMARY=<short>
EVIDENCE=EXECUTION_EVIDENCE.md;EXECUTOR_HANDOFF.md
COMMIT=<sha>
OWNER_ACTION=NONE
NEXT=STOP_AT_REVIEWER
```

Reviewer will then independently decide PASS / RETURN.

## Protected boundaries

No:

- real prompt submission;
- image quota consumption;
- reference-image upload to ChatGPT;
- cookie/session extraction;
- rate-limit bypass;
- anti-bot bypass;
- multi-account rotation;
- concurrency > 1;
- mass generation;
- VPS or production deployment.
