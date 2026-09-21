# Security Incident — K3R10 Sandbox Credential Output

Date: 2026-09-21
Status: CONTAINMENT / ROTATION REQUIRED
Severity: Sandbox-only credential exposure; no production credential identified

## What happened

During K3R10 diagnostics, a pre-existing WooCommerce PayPal Payments log line containing credential fields was inadvertently surfaced in a bounded diagnostic tool output.

The affected credential values are intentionally not reproduced in this repository.

Executor evidence confirms:

- no secret value was committed to GitHub;
- no secret value was written into EXECUTION_EVIDENCE.md or EXECUTOR_HANDOFF.md;
- the incident involved the Sandbox credential pair used by the local test environment;
- no Live/Production PayPal credential is implicated by the current evidence.

## Required containment

Before the affected Sandbox credential pair is used again:

1. Owner rotates/regenerates the affected Sandbox Secret in PayPal;
2. the old Sandbox Secret must no longer be reused;
3. the new Secret remains Owner-only and must never be pasted into chat/GitHub;
4. any reconnect required after rotation must occur only through the approved local UI checkpoint.

## Scope

This incident does not imply production compromise.
No production payment was executed.
No production customer data was involved.

## Follow-up

The project handoff/security review should add a rule that raw provider logs must be filtered/redacted before diagnostic tool output is surfaced, even when the final GitHub evidence itself is redacted.
