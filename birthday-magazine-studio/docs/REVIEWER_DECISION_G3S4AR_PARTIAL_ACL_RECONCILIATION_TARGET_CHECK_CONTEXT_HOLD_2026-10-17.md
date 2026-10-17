# Reviewer Decision — G3S4AR ACL read-only reconciliation accepted; live TARGET_CHECK context unresolved

> Date: 2026-10-17  
> Role: Independent Reviewer / Architect / Gatekeeper  
> Scope: Existing G3S4AR only; **not a new Gate, not a password-reset PASS**  
> Evidence PR: [#64 @ 14bd89cf1e6a471a7f262f38db27c73081af2ba0](https://github.com/entropy-student/project/commit/14bd89cf1e6a471a7f262f38db27c73081af2ba0)  
> Evidence file: `birthday-magazine-studio/docs/evidence/g3s4/G3S4AR_VISIBLE_LAUNCHER_AND_ADMIN_RESET_2026-10-17.md`  
> Governance: `entropy-student/spike.skill/vps-project-governance/VNEXT.md` v0.2.7, §§5–7, 10, 11B and 11E

## Formal scoped disposition

```text
REVIEWER_DECISION=PARTIAL_ACCEPTED_READONLY_ACL_ONLY
GATE_STATE=HOLD_BEFORE_OWNER_PASSWORD_WRITE
EXECUTOR_ACL_READONLY_RECONCILIATION=ACCEPTED_AS_NARROW_DIRECT_LOCAL_PROBE_REPORT
OWNER_ACTUAL_PRIOR_V2_RUN=TARGET_CHECK_ACL_UNSAFE_NOT_STARTED
CURRENT_NATIVE_PS51_ACL_PREDICATE=TRUE_ON_TESTED_DIR_AND_V2_FILE_EXECUTOR_REPORTED
ROOT_CAUSE=UNKNOWN_CONTEXT_OR_UNTESTED_CALLSITE
V2_SCRIPT_CHANGED=NO
ACL_CHANGED=NO
CREDENTIAL_ATTEMPT_MARKER=ABSENT_EXECUTOR_REPORTED
PASSWORD_RESET=NOT_STARTED
OWNER_LOGIN_CONFIRMED=NO
STRIPE_TEST=NOT_STARTED
NEXT=ONE_BOUNDED_NONSECRET_CALLSITE_AND_CHILD_CONTEXT_RECONCILIATION
OWNER_REAPPROVAL=NOT_REQUIRED_WITHIN_CURRENT_SCOPE
NO_UNCHANGED_V2_REAL_RESET_REPLAY=YES
NO_NEW_GATE_BACKUP_RESTORE_PROVIDER_WORK=YES
```

## Independently inspected evidence and limits

1. Refreshed PR #64: **Open**, unmerged, head `14bd89cf1e6a471a7f262f38db27c73081af2ba0`. GitHub commit readback shows a change to **only one sanitized G3S4AR Evidence Markdown**. Evidence is present, readable, and reviewed.
2. Owner's **actual** earlier visible Windows PS5.1 console printed `RESULT=STOP_NO_WRITE; STAGE=TARGET_CHECK; ERROR_CLASS=ACL_UNSAFE; MUTATION_STATE=NOT_STARTED`. This takes precedence for the outcome of that invocation. No password input or WordPress write followed. The outer helper's generic `UNKNOWN_NO_RETRY` text does not override `NOT_STARTED`.
3. Executor's new local Windows PS5.1 **read-only** probe reports reviewed v2 SHA-256 `fd99b00d106adbf706a6b8f560bc63c931cd5596a00d557d71fa4deda35367d2`, zero parser errors, and v2 extracted ACL predicate returning **True** on exactly the launcher's ordinary directory and file. Both currently have protected DACL, owner=current user, explicit FullControl ACEs for current user/SYSTEM; negative controls for shared parent and nonexistent path fail closed; attempt marker absent. These results justify **not changing ACL or code speculatively**.
4. Limitation: Extracting/calling an ACL function in isolation does **not prove** the exact actual v2 `TARGET_CHECK` *callsite*, all paths inspected, arguments, process SID/environment or exception mapping in the **Owner's failed child process**. Private v2 bytes and Owner's original child security context were **not independently available to Reviewer**. This specific mismatch is unresolved; neither 'ACL was unsafe' nor 'ACL was certainly safe at historical execution' is proven from both readings.

## Authorized single next action — same Gate, no further approval

Executor must **not rerun the unchanged failed credential launcher** or repeat the accepted two-object ACL check. Instead, perform **one bounded read-only callsite reconciliation** against the existing private v2 source and the already-known ordinary Owner host:

- Statically locate **every** `ACL_UNSAFE` throw/classification and its exact `TARGET_CHECK` callers. Enumerate, using **sanitized roles rather than private absolute paths**, each actual path checked and the origin of that path; distinguish the tested directory/file from any additional ancestor/marker/backup path. Confirm whether an ACL predicate false, unrelated exception remapping, or a transient/child-context issue could emit the same class.
- In a separately launched **read-only native PS5.1 child** using equivalent `-NoProfile` and environment/SID context, probe **only these exact allowlisted callsite inputs**, inspecting owner/DACL/identity/inheritance/reparse and the same predicate. No original v2 real-target invocation, password prompt, WP-CLI, DB write, broad disk scan or Secret printing. Compare process identity/integrity, `LOCALAPPDATA` expansion and exact path *roles* between helper, child and prior execution insofar as recorded. If prior context cannot be reconstructed, state the specific gap; do not fabricate it.
- Act on proven outcome only: a real unsafe project-private ACL => fix only that target ACL with same-host independent readback; an incorrect guard/exception mapping => **minimal side-by-side versioned nonsecret correction** with original v2 preserved, same native PS5.1 parser, positive/negative/failure/ambiguous-state dummy fixtures and exact hash/ACL real-console readback. If the old execution is genuinely unresolvable, isolate a new corrected/preflight-only target-check route that unambiguously names **safe nonsecret failing role/stage** and cannot reach password transport or WP mutation while being tested. Do not turn off or skip ACL validation.
- After safe independent actual Owner-native qualification of a corrected candidate, provide one Owner-visible private password entry opportunity **only once** under the existing authorized G3S4AR boundary. `MUTATION_STATE=MAY_HAVE_STARTED` or ambiguous result after WP write => `UNKNOWN_NO_RETRY`, read-only reconciliation only. On completion, update the **existing** one PR64 Evidence file, stop for Reviewer.

Do not add a replacement Gate, replay backups, touch unrelated dirty project source, merge PR, restart Docker unnecessarily, activate Stripe or modify universal Governance based on unverified cause. A narrowly scoped additional read-only diagnostic may return exact `ROOT_CAUSE_UNPROVEN` when source/control-plane is insufficient; this is not license for speculative changes.

## Reviewer acceptance and next Owner action

**Accepted now:** PR Evidence integrity; narrow read-only ACL validation; absence of reported new mutation; correct decision not to alter presently private DACL. **Not accepted:** a finding that the old `ACL_UNSAFE` never happened, an end-to-end successful child-context preflight, a changed administrator password, a confirmed WordPress login or Stripe payment test.

Owner needs **no new approval or immediate PowerShell action**. Executor must deliver an actual repaired/qualified, Owner-visible **single** private reset entrypoint, not another round of unchanged file/digest/ACL discovery. Owner alone enters the credential, after the prerequisite gate genuinely passes.


## Subsequent Reviewer superseding disposition — missing git.exe, direct WP-CLI route

> 2026-10-17. This appended decision **supersedes the prior NEXT=ACL child-context-only work** without erasing its historically accurate evidence classification.

**Latest Owner-relayed Executor result:** the original private v2 target check attempted to resolve `git.exe`, raised `CommandNotFoundException` classified `OTHER_EXCEPTION`, and stopped before `CONFIRM`, masked password or WordPress update. Owner `Get-Command git.exe` reportedly found no executable; no reset marker. Executor did not change ACL/v2 or commit new Evidence, reporting GitHub ref=404. This new finding is **Owner-relayed**, not an independent reading of private script bytes or Owner-host PATH. It clarifies the immediately reported stop, but does not prove the cause of all earlier `ACL_UNSAFE` events.

**Formal status:** `REVIEWER_DECISION=RETURN_PREWRITE_TOOL_DEPENDENCY`; `PASSWORD_MUTATION=NOT_STARTED_REPORTED`; `LIVE_V2_LAUNCHER=RETIRED_FROM_FURTHER_RETRY`; `NEXT=IN_SCOPE_DIRECT_WPCLI_ONE_ADMIN_RESET_WITH_EQUIVALENT_TARGET_AND_SECRET_CHECKS`. Existing Owner consent for exactly one G3C local admin reset remains in effect; no new Gate. Technical implementation in the existing G3S4AR Gate is now amended to stop Git-dependent v2 retry and use the accepted existing WP-CLI container with positive runtime site+single-admin proof and qualified masked stdin transport before any one-time write. Missing Git is **not itself a WordPress password-reset prerequisite**, but loss of Git-based target assurance must be replaced by trusted real-runtime readback before credential mutation. Unknown/maybe-started outcome still means `UNKNOWN_NO_RETRY`.

**GitHub independent readback at review:** current PR #64 remains Open/unmerged, previous Evidence path is readable using branch ref `codex/birthday-magazine-g3c-blocksy-wedding-productization`; no fresh latest Executor Evidence Commit SHA was supplied. An Executor PR-ref `404` alone must be diagnosed as GitHub access/ref selection, not authorization to switch to browser or skip Evidence. The Owner needs no separate action until a qualified single native WP-CLI recovery command is prepared. Stripe and real-money operations remain unstarted/unapproved by this stage.
