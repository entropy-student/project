# Reviewer Decision — G3S4A RETURN: existing launcher swallows diagnostic exception class

> Date: 2026-10-17
> Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7, especially §11B fail-closed diagnostics, same-target Windows readback, and native-exit / Secret restrictions
> Parent: `docs/G3S4A_LOCAL_WP_ADMIN_DISCOVERY_AND_PASSWORD_RESET_2026-10-17.md`
> Source of facts: **OWNER_RELAYED_EXECUTOR_READBACK**, not independent Reviewer access to Windows script bytes; no G3S4A PR Evidence commit exists in this report
> Related earlier Reviewer correction: `docs/G3S4A_LOCAL_WP_ADMIN_DISCOVERY_AND_PASSWORD_RESET_2026-10-17.md` last two appended sections

## Decision

```text
REVIEWER_DECISION=RETURN_G3S4A_LAUNCHER_FAIL_CLOSED_DIAGNOSTICS
FAILURE_SCOPE=SCRIPT_EXCEPTION_HANDLER_SUPPRESSES_SANITIZED_ERROR_CLASS
ORIGINAL_SCRIPT_PHYSICALLY_PRESENT=OWNER_RELAY_TWO_CONTEXTS_SAME_SHA256
CANONICAL_SCRIPT_SHA256=685cc5fab1ecefffbc30368f888ec2b0662937cd5256cd307b331f6043ae8fe1
CANONICAL_WINDOWS_PS51_SYNTAX=0_ERRORS_EXECUTOR_REPORTED
ORIGINAL_SCRIPT_ACL=CURRENT_USER_AND_SYSTEM_ONLY_EXECUTOR_REPORTED
WORDPRESS_TARGET_ADMIN_IDENTITY=ONE_EXISTING_VERIFIED_ADMIN_EXECUTOR_REPORTED_NO_ACCOUNT_ID_DISCLOSED
ATTEMPT_MARKER=ABSENT_EXECUTOR_REPORTED
PASSWORD_RESET=NOT_ATTEMPTED_EXECUTOR_REPORTED
STRIPE_ACTION=NONE
HISTORICAL_COMMAND_NOT_FOUND_ROOT_CAUSE=UNKNOWN
PATH_VIRTUALIZATION=COMPATIBLE_HYPOTHESIS_NOT_PROVEN_HISTORICAL_CAUSE
EXISTING_SCRIPT_OVERWRITE=NOT_AUTHORIZED
NEXT_GATE=G3S4AR_VISIBLE_LAUNCHER_V2_AND_ONE_ADMIN_RESET_20261017
NEXT_GATE_STATUS=PREPARED_PENDING_FRESH_OWNER_AUTHORIZATION
PR64_LAST_VERIFIED_HEAD=777463995a298118dae0c6763f6c668207a19350
```

## Reviewer analysis

1. The Executor's reported real Windows PowerShell 5.1 readback now sees **both** canonical ordinary `%LOCALAPPDATA%` and Codex packaged-cache copies of `Invoke-G3S4A-AdminRecovery.ps1`, with matching SHA-256 `685cc5fab1ecefffbc30368f888ec2b0662937cd5256cd307b331f6043ae8fe1`. Reported filesystem ACL is restricted to current user+SYSTEM; source and directory lack reparse points; syntax parser yielded zero errors. These are Executor-provided observations and not a Reviewer independent file audit.
2. The earlier Owner-side `CommandNotFoundException` is historical and cannot now be conclusively attributed to virtualization. Do not manufacture a root cause, copy an identical file, or continue path searches without concrete drift.
3. **Material present defect:** A generic exception branch omits a sanitized exception type/class; this violates §11B's requirement to retain stage, non-secret failure class and whether consequential mutation started, did not start, or is ambiguous. A script with this defect **must not** be recommended for Owner password input merely because path/ACL/PS51 parsing pass.
4. Owner relays no `CONFIRM`, password entry, native WP update, attempt marker, new backup, payments or GitHub Evidence. Existing original script and all original source/private backups stay unchanged. No password hash comparison was performed.
5. The prior bounded G3S4A Executor round has formally RETURNed. Its Owner approval must **not automatically authorize a new credential-write attempt**. Reviewing a replacement design and writing this decision to GitHub `main` do not constitute new Owner consent.

## Reviewer-approved minimal technical correction

Prepare `docs/G3S4AR_VISIBLE_LAUNCHER_V2_AND_ONE_ADMIN_RESET_2026-10-17.md` as the sole next Gate. Under fresh explicit Owner approval it may create **one new, version-named, non-secret** local script alongside the original, after reading its complete current source and narrowly repairing **only** fail-closed exception diagnostics and required attempt-state bookkeeping. The original `Invoke-G3S4A-AdminRecovery.ps1` and both copies, including their ACL and hash, are immutable.

The new Owner-visible script must emit only allowlisted **stage + sanitized error category/type + mutation-start state + nonzero exit** for failures. Never print arbitrary exception messages/stack traces, process stdout/stderr potentially containing secret data, password hashes or account identities. If the native password-update process has started and its result is ambiguous, label `UNKNOWN_NO_RETRY` and stop; no automatic second reset. Only independently verified success may print a PASS marker.

Require PS5.1 parse/static/fixture diagnostics and Owner-host path/hash/ACL readback before offering any password prompt. Do **not** create a new backup, re-restore DB, change Stripe or alter WordPress accounts simply for the repair. If code cannot be safely reviewed, RETURN with no new script and no credential change.

## Distinct approval boundary

A fresh explicit Owner approval for the **new combined G3S4AR round** (one side-by-side local non-secret launcher plus at most one uniquely identified existing WordPress admin password reset entered privately in Owner-controlled PowerShell) must precede any owner-host file or password mutation. An Owner approval is neither evidence of script safety nor authorization for other sites or Stripe payment actions. Next Reviewer must reconcile proof and issue precise PASS/RETURN; do not auto-advance into G3S4M.
