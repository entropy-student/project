# G3S4AR — Versioned visible launcher v2, with at most one existing local admin reset

> Date: 2026-10-17
> Status: **OWNER_AUTHORIZED — EXECUTOR_REPORTS_V2_PREPARED; OWNER_NATIVE_PS51_CANNOT_FIND_FILE; CREDENTIAL_WRITE_NOT_STARTED; REAL_HOST_DELIVERY_HOLD**
> Parent Reviewer decision: `docs/REVIEWER_DECISION_G3S4A_RETURN_LAUNCHER_FAIL_CLOSED_DIAGNOSTICS_2026-10-17.md`
> Explicit Owner authorization: `docs/OWNER_AUTHORIZATION_G3S4AR_VERSIONED_LOCAL_ADMIN_RECOVERY_2026-10-17.md` (Owner current direct message; one defined bounded G3S4AR round)
> Original G3S4A: `docs/G3S4A_LOCAL_WP_ADMIN_DISCOVERY_AND_PASSWORD_RESET_2026-10-17.md` (STOPPED/RETURNED, not auto-resumed)
> Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7 §11B
> PR #64 previous head: `777463995a298118dae0c6763f6c668207a19350`, verify fresh before any later Evidence commit
> **Owner authentication/passphrase only in a separate personally visible Windows PowerShell 5.1 window.** Owner approval is now recorded for this exact round; Executor relay must include it. All safety preconditions and STOP remain in force.

## Gate contract

```text
GATE_ID=G3S4AR_VISIBLE_LAUNCHER_V2_AND_ONE_ADMIN_RESET_20261017
OBJECTIVE=Repair ONLY original non-secret launcher exception diagnostics with a side-by-side versioned v2 file and, after real-host safety validation, let Owner perform at most one private password reset of the verified unique G3C WordPress administrator.
MAX_ENDPOINT_THIS_ROUND=Read-only original v1 and current host/unique-admin/attempt-marker proofs -> if freshly Owner-approved, create exactly one NEW non-secret side-by-side v2 launcher and test fail-closed with dummy fixtures in verified Windows PS5.1 -> independent ordinary Owner-host path/hash/ACL/PS51 readback -> Owner alone invokes once in visible PS5.1 with CONFIRM and twice-masked chosen password -> Executor read-only WordPress outcome verification -> exactly one sanitized PR64 Evidence file -> Reviewer stop.
MANDATORY_REVIEW_STOP=YES
OWNER_AUTHORIZATION=APPROVED_G3S4AR_BY_OWNER_CURRENT_DIRECT_MESSAGE
TARGET=Same original Windows 11 G3C existing WordPress/WP-CLI/MariaDB Docker project, Woo #1113 virtual USD39.99, localhost 127.0.0.1:8189; one already-proven WordPress site administrator only.
EXISTING_SCRIPT=%LOCALAPPDATA%/BirthdayMagazineStudio/G3S4A-VisiblePS51-20261017/Invoke-G3S4A-AdminRecovery.ps1
EXISTING_SCRIPT_SHA256_REPORTED=685cc5fab1ecefffbc30368f888ec2b0662937cd5256cd307b331f6043ae8fe1
ALLOWED_NEW_LOCAL_FILE=%LOCALAPPDATA%/BirthdayMagazineStudio/G3S4A-VisiblePS51-20261017/Invoke-G3S4A-AdminRecovery-v2.ps1
MUST_BE_NEW_FILE_FAIL_IF_EXISTS=YES
ORIGINAL_NORMAL_AND_PACKAGED_CACHE_SCRIPTS=READONLY_NO_OVERWRITE_DELETE_RENAME
PR64_EVIDENCE_ONLY=docs/evidence/g3s4/G3S4AR_VISIBLE_LAUNCHER_AND_ADMIN_RESET_2026-10-17.md
APPLICABLE_CRITICAL_CONSTRAINTS=No unverified exception message/stack/unfiltered stdout/stderr, Secret values/hash/cookies in output or argv/env/history/scripts/temp/logs/chat/repo; no account creation/privilege/email mutation, other user password changes, Woo order or source mutation, Stripe/plugin activation/payment, PayPal/Netlify, Docker recreate, DB restore/export, preexisting backup deletion, browser Computer Use, PR64 merge. Owner password entry ONLY in independently visible Windows PowerShell 5.1.
PREFLIGHT=Fresh Owner authorization for this exact G3S4AR is recorded in docs/OWNER_AUTHORIZATION_G3S4AR_VERSIONED_LOCAL_ADMIN_RECOVERY_2026-10-17.md and must be relayed in Executor prompt; original v1 exact SHA-256 plus protected ACL/path/PS51 context and code contents actually reviewed; original reset attempt marker absent, no prior ambiguous credential update, uniquely proven admin role/ID and original project Docker context/loopback/source/backup state unchanged. Historical CommandNotFound cause remains UNKNOWN, no need to recopy v1. If any identity/code/marker mismatch stop before v2 creation.
REQUIRED_EVIDENCE=Original vs new exact allowlisted script diff in protected local evidence (no embedded credentials or account identifiers); original and v2 hash/ACL/existence and ordinary Windows PS51 readback; sanitized stage/error class and mutation-start state; native exit nonzero on failure; parser/static/fixture paths proving fail closed before/after simulated mutation and no unconditional PASS; masked double Owner input+stdin no argv/env/history/log exposure; exactly one selected admin credential write if executed; nonsecret WordPress post-write readback and untouched source/backups/Stripe; only one sanitized evidence file on PR64; STOP.
ACCEPTANCE_CRITERIA=Prepared v2 is verified on real Owner host and optionally one authenticated password reset was safely completed on exactly one existing admin with Owner-only secret handling, or exact RETURN at blocker. Distinguish PREPARED_ONLY from ADMIN_PASSWORD_CHANGED and OWNER_LOGIN_CONFIRMED; no inferred success, Stripe acceptance, or commercial readiness.
ROLLBACK=Preserve v1, both prior matching locations, protected existing G3S4 backup and all dirty worktree. New v2 file must fail-on-existing, allowlist exact path/ACL, protect no password or hash in file. Do not restore database to roll back a password reset. Once a remote WP password mutation MAY_HAVE_STARTED, unknown result => no blind retry; Reviewer reconciles before further credential action.
OWNER_ONLY_ACTIONS=Owner has explicitly approved this new G3S4AR local v2 creation+one existing WordPress admin password reset; Owner later enters CONFIRM and twice-masked new password solely via their own visible Windows PS5.1 window and saves it in their password manager. No secrets in chat. All other steps by Executor with exact scope and mandatory Reviewer stop.
REVIEWER_TO_EXECUTOR_RELAY=Read this Gate plus parent Reviewer RETURN and original v1 actual code on exact verified Owner host. Do NOT infer safe v2 code merely from SHA/ACL, and do not read raw secret data. Owner approval is now present in the named record and actual relay; do not ask it again for the same scope. If actual relay omits authorization, return before host writes. Perform minimal versioned repair and one Owner-visible checkpoint, no unrelated G3S4A reruns.
EXECUTOR_TO_REVIEWER_RELAY=Brief result including real-host source+v2 digest readbacks, error-class fail-closed fixture validation, attempt/credential mutation state and one PR evidence link/SHA or precise RETURN; mandatory stop.
```

## Implementation boundaries

### Phase A — inspect only (can be prepared without additional credential writes)

1. Use the existing Owner-Windows target and read-only inventory. Owner reported the old ordinary and packaged-cache script copies both exist and have SHA-256 `685cc5fab1ecefffbc30368f888ec2b0662937cd5256cd307b331f6043ae8fe1`, protected ACL, no reparse point, 0 parser errors. These are **Owner-relayed Executor findings**, not enough to accept the script's behavior. Read the **actual v1 script** locally (do not print it into chat or GitHub; scrutinize for accidental identity/Secret references) and classify exact relevant exception handlers.
2. Verify no password change was attempted and no attempt marker exists in the selected target. Admin count is **exactly one** as last reported; freshly verify without exposing username/email or changing DB. Verify same Docker WP target/loopback and no material drift. If any existing script/target mismatch, STOP before staging.
3. Retain historic virtualization diagnosis as UNKNOWN. The ordinary Owner PS5.1 path is currently reported as visible, so do not duplicate or overwrite v1 or rehash entire backups without drift.

### Phase B — minimal v2 repair and source integrity, under recorded Owner approval and mandatory preflight

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
RETURN_OWNER_AUTHORIZATION_REQUIRED (only if new execution relay lacks the existing explicit authorization)
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

## Reviewer follow-up — minimal Governance learning after verified repair

Owner directs rapid resolution of recurring RETURN defects and a **minimal project-management governance record after they are actually solved**. Once G3S4AR has a real owner-host v2 execution/verification result and Reviewer disposition, assess whether the failure taught a new generally reusable rule not already present in Governance v0.2.7 §11B (currently already covers native host readback, path virtualization, masked Secret transport, fail-closed diagnostics). Make only the smallest necessary addition to the canonical `entropy-student/spike.skill` governance `VNEXT.md`, optionally a brief historical incident pointer. Do not add duplicative policy or mark the issue solved before independent proof. This is a post-closure action, not an extra checkpoint or reason to block the currently authorized recovery.

## 2026-10-17 Reviewer interim RETURN: v2 file invisible to actual Owner console

**Actual Owner observation:** Running

```powershell
& "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -NoLogo -NoProfile -ExecutionPolicy RemoteSigned -File "$env:LOCALAPPDATA\BirthdayMagazineStudio\G3S4A-VisiblePS51-20261017\Invoke-G3S4A-AdminRecovery-v2.ps1"
```

from Owner's independently opened Windows PowerShell returns **`-File ... does not exist`**. This occurs **before the v2 code, Owner `CONFIRM`, secret input, or WordPress update**. No successful password reset is proven or claimed.

**Conflicting Executor report:** the same Codex session says v2 was prepared, digest `fd99b00d106adbf706a6b8f560bc63c931cd5596a00d557d71fa4deda35367d2`, Windows PS5.1 syntactic and restrictive ACL checks passed, and 10 isolated, non-secret fixtures passed. That report is **EXECUTOR_REPORTED**, not positive evidence that the **actual Owner-visible Windows PS5.1** can read the file. The previous v1 had this same writer-versus-Owner-host disagreement. Root cause **NOT PROVEN**; packaged Codex `LocalCache\Local` virtualization is a known candidate per Governance §11B and historical 2026-09-29 incident. Do not repeat the exact invocation, declare the file deleted, rebuild v2 based on guesswork, or mark password reset PASS.

**Reviewer minimal delivery repair within this already approved one-admin Gate (no new Owner approval for a non-secret staging substep):**

1. From the Owner's **actual visible, ordinary Windows PowerShell 5.1**, perform one bounded script **path discovery** only in (a) ordinary `%LOCALAPPDATA%\BirthdayMagazineStudio\G3S4A-VisiblePS51-20261017` and (b) the exact `%LOCALAPPDATA%\Packages\OpenAI.Codex_*\LocalCache\Local\BirthdayMagazineStudio\G3S4A-VisiblePS51-20261017` namespaces. Read **no secrets**. Compare candidate file **SHA-256** to the Executor-supplied **v2** digest `fd99b00d106adbf706a6b8f560bc63c931cd5596a00d557d71fa4deda35367d2`, distinct from v1's digest. If zero/multiple matching source paths, UNKNOWN, or wrong digest, STOP; no arbitrary full-drive search and no write.
2. If exactly one verified v2 source is found in package-local storage and the ordinary destination is absent, copy **only those reviewed non-secret v2 bytes** from that exact source to the already-authorized private ordinary Owner directory using that **same independent normal Windows PS5.1** process. Fail on an unexpected existing destination, wrong/insecure directory ACL, reparse points, or source hash mismatch. Never overwrite or delete v1/v2; no password input during this step. Do not need new or broader backup, account/password changes, or Windows-wide ACL/execution policy changes.
3. **Same-process readback required:** physical ordinary file exists, digest matches expected v2, DACL restricted to current Owner user and SYSTEM (validate actual SIDs/effective allowed identities), no reparse point, Windows PS5.1 parser zero errors. If any fails, `RETURN_REAL_WINDOWS_PS51_READBACK_UNVERIFIED`, no `CONFIRM`. Codex-side “independent PowerShell readback” without Owner-visible context is insufficient.
4. Only once this physical handoff is proven may the Owner launch the reviewed v2 **once** from their own visible PS5.1 and privately enter `CONFIRM` and two masked passwords. If outcome of any update is unknown, `UNKNOWN_NO_RETRY`, no repeated reset. Then Executor reads back nonsecret WordPress state and commits exactly one sanitized Evidence file in PR #64, mandatory Reviewer stop.

**Learning:** This is a *second recurrence* of v1/v2 premature “Owner-real Windows file exists” claims. Do not add a duplicate v0.2.7 §11B rule now; after real closure, review whether specific positive same-console validation wording would be a genuinely novel minimal norm. Project-specific mismatch remains recorded here and in canonical `REVIEWER_HANDOFF.md`.


## 2026-10-17 Owner-native helper precondition correction (same Gate, no new password attempt)

**New Owner-real observation (not a WordPress or password attempt):** An earlier Owner-run non-secret one-shot helper returned `SAFE_STOP STAGE=OWNER_TARGET REASON=PRIVATE_OWNER_DIRECTORY_ABSENT` in native Windows PS5.1. Inspection of that helper shows it checked for an already-existing ordinary private directory and matching v1 **before** looking for v2 in Codex's package-local cache. This is an overly strict helper precondition for the exact known AppData virtualization failure class (§11B and the 2026-09-29 incident). It proves the specified ordinary directory was absent at this attempt, **not** that the v2 file or its protected source has been deleted. No v2 code, Owner password input, or WP update was reached.

**Reviewer minimal in-scope correction, already within Owner's direction to fix bounded reversible handoff without repetitive approvals:** Replace that helper, not the reviewed v2, with one true Owner-native PS5.1 checkpoint that first accepts an already verified ordinary v2 or discovers **exactly one** matching, non-reparse, safely permissioned packaged-Codex v2 by expected SHA-256 `fd99b00d106adbf706a6b8f560bc63c931cd5596a00d557d71fa4deda35367d2`. Only after a verified source exists, allow creating the **missing specific** ordinary `%LOCALAPPDATA%\BirthdayMagazineStudio\G3S4A-VisiblePS51-20261017` private directory and, if needed, its missing project parent, with restrictive current-Owner-and-SYSTEM ACL set at creation, no changes to an existing parent or other files. Do not require an ordinary v1 copy for v2 delivery; never recreate, alter, run or copy v1. Copy only v2 with fail-on-existing; then perform same Owner-shell file hash, ACL, reparse and native PS5.1 parser readback before offering the **single** Owner-private v2 invocation. Any unknown source, unexpected existing destination, unsafe ACL or ambiguity remains a hard stop without password/Stripe action. This narrow correction does not authorize broad disk search, materialization of credentials, silent retries or payment changes.

**Evidence status:** Helper's initial directory check failed before write; revised helper constructed and statically checked off-host, **not yet run or parsed by actual Owner PS5.1**. Record its real shell result, not an inferred PASS. Executor should not recreate historical backups, re-review full application source or add a new Gate because of this helper bug.
