# Owner Relay — G3S1SV could not read GitHub PR #64 (Codex connector transport closed)

> Date: 2026-10-15
> Provenance: OWNER_REPORTED; no new Executor PR Evidence provided
> Current project Gate: `G3S1SV_VERIFY_NEW_CHAT_DB_RESTORE_THEN_INACTIVE_STRIPE`
> Scope: Codex GitHub plugin preflight failure only, NOT database / WordPress / Stripe execution

## Exact reported failure

```text
CODEX_GITHUB_ACTION=codex_apps/github.fetch_pr
CODEX_ERROR="tool call error: tool call failed for codex_apps/github.fetch_pr — Caused by: Transport closed"
ERROR_CLASS=CONNECTOR_TRANSPORT_CLOSED
PR=64
CODEX_GATE_EXECUTED=NO
SOURCE_AND_TARGET_DB_RESTORE_CORRELATION=NOT_RUN_IN_THIS_ATTEMPT
STRIPE_INSTALL=NOT_RUN
PAYPAL_DB_OR_VOLUME_MUTATION=NONE_OWNER_REPORTED
NEW_PR_EVIDENCE=NONE
```

Owner said Codex stopped as required; no Stripe plugin installation and no PayPal/DB changes. Do not conflate GitHub connector transport closure with prior Codex PowerShell `CreateProcess blocked by policy` or MariaDB isolated import exit 1. These are independent faults at distinct steps.

## Reviewer independent verification

Reviewer `mcp__GitHub__get_pr_info` and `mcp__GitHub__fetch_file` both succeeded from the present ChatGPT connection, using the same repo and main G3S1SV Gate. At verification, PR #64 `state=open`, `merged=false`, head `d13b27fd8290d0575bd3ac7733f3f3039b415a21`; G3S1SV Gate source SHA/blob `0c5b3969ca85431e3e8736c436787d852fa6a712` and Handoff accessible. Thus the repository is reachable through **this connector**. This does not prove that the separate Codex desktop GitHub connector is healthy or authorized, and cannot identify whether its closure is transient, connection-specific, or transport bug.

## Practical containment

- Keep the **same G3S1SV Gate**. No new database import, no GitHub access substitute via SSH/VPS, no speculative payment change, no resetting WordPress, and no new Stripe task until normal GitHub preflight succeeds.
- Codex should first restore/verify the **supported GitHub connection in its own account/app environment**. After it is connected, allow **a single read-only PR #64 metadata check** using the normal GitHub integration, and report success or the exact safe transport error. This checkpoint does not imply permission to automatically replay all of G3S1SV.
- Once that read-only check succeeds, continue existing G3S1SV scope: correlate Owner-reported exit 0/58-table import to original private backup and isolated local Docker target **without repeat import**; then conditional official Stripe inactive stage only if full backup recovery barrier satisfied. STOP at Reviewer.
- If connector still `Transport closed`, report one error and STOP without alternate Git tools/SSH.
- Neither the prior successful import nor this connector report is a formal database restore PASS until independent source/target evidence exists.

## Current status

```text
G3S1SV_EXECUTION=BLOCKED_AT_CODEX_GITHUB_PREFLIGHT
G3S1SV_GATE=RETAINED_NO_REDESIGN
CURRENT_OWNER_ACTION=CHECK_CODEX_SUPPORTED_GITHUB_CONNECTION
REVIEWER_STRIPE_BACKUP_PASS=PENDING
PR64=OPEN_UNMERGED
```
