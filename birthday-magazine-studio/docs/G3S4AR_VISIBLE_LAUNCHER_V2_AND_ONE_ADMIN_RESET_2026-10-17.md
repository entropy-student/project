# G3S4AR — Versioned visible launcher v2, with at most one existing local admin reset

> Date: 2026-10-17
> Status: **PREPARED — AWAIT_FRESH_OWNER_AUTHORIZATION; NO LOCAL SCRIPT OR CREDENTIAL WRITE**
> Parent Reviewer decision: `docs/REVIEWER_DECISION_G3S4A_RETURN_LAUNCHER_FAIL_CLOSED_DIAGNOSTICS_2026-10-17.md`
> Original G3S4A: `docs/G3S4A_LOCAL_WP_ADMIN_DISCOVERY_AND_PASSWORD_RESET_2026-10-17.md` (STOPPED/RETURNED, not auto-resumed)
> Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7 §11B
> PR #64 previous head: `777463995a298118dae0c6763f6c668207a19350`, verify fresh before any later Evidence commit
> **Owner authentication/passphrase only in a separate personally visible Windows PowerShell 5.1 window.** This Gate is not authorization until relayed with a fresh Owner approval.

## Gate contract

```text
GATE_ID=G3S4AR_VISIBLE_LAUNCHER_V2_AND_ONE_ADMIN_RESET_20261017
OBJECTIVE=Repair ONLY original non-secret launcher exception diagnostics with a side-by-side versioned v2 file and, after real-host safety validation, let Owner perform at most one private password reset of the verified unique G3C WordPress administrator.
MAX_ENDPOINT_THIS_ROUND=Read-only original v1 and current host/unique-admin/attempt-marker proofs -> if freshly Owner-approved, create exactly one NEW non-secret side-by-side v2 launcher and test fail-closed with dummy fixtures in verified Windows PS5.1 -> independent ordinary Owner-host path/hash/ACL/PS51 readback -> Owner alone invokes once in visible PS5.1 with CONFIRM and twice-masked chosen password -> Executor read-only WordPress outcome verification -> exactly one sanitized PR64 Evidence file -> Reviewer stop.
MANDATORY_REVIEW_STOP=YES
OWNER_AUTHORIZATION=FRESH_EXPLICIT_G3S4AR_APPROVAL_REQUIRED_BEFORE_ANY_HOST_FILE_OR_CREDENTIAL_WRITE
TARGET=Same original Windows 11 G3C existing WordPress/WP-CLI/MariaDB Docker project, Woo #1113 virtual USD39.99, localhost 127.0.0.1:8189; one already-proven WordPress site administrator only.
EXISTING_SCRIPT=%LOCALAPPDATA%/BirthdayMagazineStudio/G3S4A-VisiblePS51-20261017/Invoke-G3S4A-AdminRecovery.ps1
EXISTING_SCRIPT_SHA256_REPORTED=685cc5fab1ecefffbc30368f888ec2b0662937cd5256cd307b331f6043ae8fe1
ALLOWED_NEW_LOCAL_FILE=%LOCALAPPDATA%/BirthdayMagazineStudio/G3S4A-VisiblePS51-20261017/Invoke-G3S4A-AdminRecovery-v2.ps1
MUST_BE_NEW_FILE_FAIL_IF_EXISTS=YES
ORIGINAL_NORMAL_AND_PACKAGED_CACHE_SCRIPTS=READONLY_NO_OVERWRITE_DELETE_RENAME
PR64_EVIDENCE_ONLY=docs/evidence/g3s4/G3S4AR_VISIBLE_LAUNCHER_AND_ADMIN_RESET_2026-10-17.md
APPLICABLE_CRITICAL_CONSTRAINTS=No unverified exception message/stack/unfiltered stdout/stderr, Secret values/hash/cookies in output or argv/env/history/scripts/temp/logs/chat/repo; no account creation/privilege/email mutation, other user password changes, Woo order or source mutation, Stripe/plugin activation/payment, PayPal/Netlify, Docker recreate, DB restore/export, preexisting backup deletion, browser Computer Use, PR64 merge. Owner password entry ONLY in independently visible Windows PowerShell 5.1.
PREFLIGHT=Fresh relayed Owner authorization; original v1 exact SHA-256 plus protected ACL/path/PS51 context and code contents actually reviewed; original reset attempt marker absent, no prior ambiguous credential update, uniquely proven admin role/ID and original project Docker context/loopback/source/backup state unchanged. Historical CommandNotFound cause remains UNKNOWN, no need to recopy v1. If any identity/code/marker mismatch stop before v2 creation.
REQUIRED_EVIDENCE=Original vs new exact allowlisted script diff in protected local evidence (no embedded credentials or account identifiers); original and v2 hash/ACL/existence and ordinary Windows PS51 readback; sanitized stage/error class and mutation-start state; native exit nonzero on failure; parser/static/fixture paths proving fail closed before/after simulated mutation and no unconditional PASS; masked double Owner input+stdin no argv/env/history/log exposure; exactly one selected admin credential write if executed; nonsecret WordPress post-write readback and untouched source/backups/Stripe; only one sanitized evidence file on PR64; STOP.
ACCEPTANCE_CRITERIA=Prepared v2 is verified on real Owner host and optionally one authenticated password reset was safely completed on exactly one existing admin with Owner-only secret handling, or exact RETURN at blocker. Distinguish PREPARED_ONLY from ADMIN_PASSWORD_CHANGED and OWNER_LOGIN_CONFIRMED; no inferred success, Stripe acceptance, or commercial readiness.
ROLLBACK=Preserve v1, both prior matching locations, protected existing G3S4 backup and all dirty worktree. New v2 file must fail-on-existing, allowlist exact path/ACL, protect no password or hash in file. Do not restore database to roll back a password reset. Once a remote WP password mutation MAY_HAVE_STARTED, unknown result => no blind retry; Reviewer reconciles before further credential action.
OWNER_ONLY_ACTIONS=Owner first explicitly approves this new G3S4AR local v2 creation+one existing WordPress admin password reset; later enters CONFIRM and twice-masked new password solely via their own visible Windows PS5.1 window and saves it in their password manager. No secrets in chat. All other steps by Executor with exact scope and mandatory Reviewer stop.
REVIEWER_TO_EXECUTOR_RELAY=Read this Gate plus parent Reviewer RETURN and original v1 actual code on exact verified Owner host. Do NOT infer safe v2 code merely from SHA/ACL, and do not read raw secret data. If fresh Owner approval missing, read-only plan/review ONLY; no local writes. If approved, minimal versioned repair and one Owner-visible checkpoint, no unrelated G3S4A reruns.
EXECUTOR_TO_REVIEWER_RELAY=Brief result including real-host source+v2 digest readbacks, error-class fail-closed fixture validation, attempt/credential mutation state and one PR evidence link/SHA or precise RETURN; mandatory stop.
```

## Implementation boundaries

### Phase A — inspect only (can be prepared without additional credential writes)

1. Use the existing Owner-Windows target and read-only inventory. Owner reported the old ordinary and packaged-cache script copies both exist and have SHA-256 `685cc5fab1ecefffbc30368f888ec2b0662937cd5256cd307b331f6043ae8fe1`, protected ACL, no reparse point, 0 parser errors. These are **Owner-relayed Executor findings**, not enough to accept the script's behavior. Read the **actual v1 script** locally (do not print it into chat or GitHub; scrutinize for accidental identity/Secret references) and classify exact relevant exception handlers.
2. Verify no password change was attempted and no attempt marker exists in the selected target. Admin count is **exactly one** as last reported; freshly verify without exposing username/email or changing DB. Verify same Docker WP target/loopback and no material drift. If any existing script/target mismatch, STOP before staging.
3. Retain historic virtualization diagnosis as UNKNOWN. The ordinary Owner PS5.1 path is currently reported as visible, so do not duplicate or overwrite v1 or rehash entire backups without drift.

### Phase B — minimal v2 repair and source integrity, ONLY after fresh Owner approval

1. Create one entirely **new** non-secret sibling script `Invoke-G3S4A-AdminRecovery-v2.ps1` in the already protected user-local directory; **fail if that filename exists** (even if similar). Original `Invoke-G3S4A-AdminRecovery.ps1` and the packaged-cache copy remain untouched. Use a native ordinary Owner-host file creation route proven not subject to packaged-app AppData virtualization. No global execution policy, shell configuration, or unrelated ACL changes. Review the exact v1↔v2 source diff: limit to necessary exception diagnostics, mutation-status bookkeeping and associated fail-closed branches; preserve existing verified target-binding and protected masked-secret transport. Unexpected nontrivial algorithm/target changes => RETURN.
2. The v2 error path must report `STAGE` (fixed nonsecret enum: `TARGET_CHECK|OWNER_CONFIRM|MASKED_INPUT|BEFORE_WP_UPDATE|WP_UPDATE|POST_VERIFY`), `ERROR_CLASS` (a safe allowlisted exception category or inspected CLR type name without full messages), and `MUTATION_STATE` (`NOT_STARTED|MAY_HAVE_STARTED|VERIFIED_SUCCESS`), plus proper **nonzero native exit** on error. Avoid arbitrary exception messages/stack traces and raw stdout/stderr, as those may contain secret-bearing content. If native WP password update was invoked and exit/response is ambiguous, emit `UNKNOWN_NO_RETRY` and leave the attempt marker for read-only reconciliation. A static PASS marker after catch is forbidden. A PASS marker is reachable only when update's native exit and independent necessary post-update checks actually succeed.
3. The v2 script still asks for `CONFIRM` only after local target verification and uses **two masked Owner-only inputs**, password held only in protected process memory/STDIN, NEVER in argv/env/shell history/ordinary temp file/log. Review the exact PowerShell 5.1 stdin encoding/no-echo transport and process-state handling with benign dummy input, without touching a live WordPress administrator. Do not run any real reset while testing v2.
4. Validate v2 with PowerShell 5.1 parser/static audit, isolated dummy-fixture success and failure paths (pre-update, simulated update-failure, ambiguous post-update) proving expected `STAGE/ERROR_CLASS/MUTATION_STATE/exit`, including a negative check for missing/untrusted target. **Do not execute v2 against the live target** to test its diagnostics. Check that simulated failures don't output any dummy password/string secrets. If test harness can't model after-start ambiguous state, RETURN before Owner use.
5. From independently visible real Windows PowerShell 5.1, positively read back v2 with `Test-Path`, exact file bytes/SHA-256, PS51 parse count, `Get-Acl` and current-user/SYSTEM effective rights (not overly fixed ACE count); assert no reparse and no broad Users/Everyone ACE. Stop if any real-host readback disagrees with authoring context. A file-created result in packaged Codex alone does not count.

### Phase C — one Owner-run update, conditional on all checks

1. Codex does not open the Owner password entry prompt or any detached session. It provides the Owner a single tested, path-literal command to run the reviewed **v2** in their personally opened Windows PowerShell **5.1**. The Owner verifies target banner, enters `CONFIRM`, then a strong password twice under no-echo masking; does not relay it through ChatGPT/Codex. Save password securely.
2. Owner reports only `已在本机终端执行完成` or `本机执行失败` **without** error messages potentially bearing secret values. Executor performs **read-only** WP user/site and test-mode-inactive Stripe/no-order-change poststate check; if script outcome ambiguous after WP update started, never rerun. A single prior password-update success does not prove Owner was able to log in until Owner manually reports WP admin dashboard visible.
3. Store one sanitized PR #64 evidence Markdown under the exact allowlisted `docs/evidence/g3s4/G3S4AR_VISIBLE_LAUNCHER_AND_ADMIN_RESET_2026-10-17.md` without staging local dirty source. PR Evidence must omit username/email/admin ID and all secret values/hashes, raw exception messages, session tokens, native raw stderr and private paths containing usernames. STOP for Reviewer; previous PR original head must be verified fresh.

## Return codes

```text
RETURN_OWNER_AUTHORIZATION_REQUIRED
RETURN_ORIGINAL_LAUNCHER_IDENTITY_DRIFT
RETURN_ADMIN_IDENTITY_OR_ATTEMPT_AMBIGUOUS
RETURN_V2_FILE_ALREADY_EXISTS
RETURN_V2_SOURCE_DIFF_OUT_OF_SCOPE
RETURN_V2_ERROR_DIAGNOSTICS_UNVERIFIED
RETURN_V2_SECRET_TRANSPORT_UNVERIFIED
RETURN_REAL_WINDOWS_PS51_READBACK_UNVERIFIED
RETURN_UNKNOWN_NO_RETRY
PASS_CANDIDATE_G3S4AR_V2_PREPARED_OWNER_RESET_PENDING
PASS_CANDIDATE_G3S4AR_ONE_ADMIN_RESET_OWNER_LOGIN_PENDING
PASS_CANDIDATE_G3S4AR_ADMIN_LOGIN_CONFIRMED
```
