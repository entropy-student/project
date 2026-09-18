# Reviewer Decision — K0R1 Local Project Hygiene

Date: 2026-09-18  
Status: **RETURN — bounded cleanup required**

## Trigger

Owner provided a screenshot of the local workspace root after K0. The screenshot shows the intended project directory:

- `mini-craft-kadence-poc/`

but also several WooCommerce download/extraction artifacts at the same parent level, including names such as:

- `woocommerce-10.0.4-extract/`
- `woocommerce-latest-stable-extract-.../`
- `woocommerce-10.0.4.zip`
- `woocommerce-10.0.4-fresh.zip`
- `woocommerce-latest-stable.zip`

These are implementation/download artifacts and should not remain scattered in the shared workspace root.

## Reviewer conclusion

K0 functional acceptance remains valid:

```text
K0_FUNCTIONAL_RESULT=PASS
```

Project hygiene is not accepted:

```text
PROJECT_CONTAINMENT=RETURN
WORKSPACE_ROOT_HYGIENE=RETURN
CURRENT_GATE=K0R1_LOCAL_PROJECT_HYGIENE_CLEANUP
```

This is a bounded cleanup Gate, not a redesign and not a rerun of K0.

## Required cleanup

Executor must:

1. Inventory only artifacts created by the K0 execution.
2. Do not touch unrelated pre-existing project directories.
3. Keep the actual project inside:
   `mini-craft-kadence-poc/`
4. Reproducible temporary downloads/extractions used only for installation should be deleted after confirming the installed WordPress/Kadence/WooCommerce runtime remains healthy.
5. If any artifact must be retained for audit/recovery, move it under a project-local path such as:
   `mini-craft-kadence-poc/.artifacts/`
   or
   `mini-craft-kadence-poc/.cache/`
   rather than leaving it in the parent workspace.
6. Do not delete or move:
   - `mini-craft-night-kit/`
   - `dujiao-next/`
   - other unrelated projects
   - shared infrastructure documents
   unless separately proven to be K0-generated disposable artifacts.
7. Re-run a narrow smoke test:
   - Home 200
   - Product 200
   - Cart 200
   - Checkout 200
   - containers healthy
   - old project still unchanged.
8. Update:
   - `EXECUTION_EVIDENCE.md`
   - `EXECUTOR_HANDOFF.md`

## Expected candidate

```text
PASS_CANDIDATE_K0R1_LOCAL_PROJECT_HYGIENE_CLEANUP
K0_FUNCTIONAL_BASELINE_RETAINED=PASS
K0_TEMP_ARTIFACTS_CONTAINED_OR_REMOVED=PASS
SHARED_WORKSPACE_ROOT_CLEAN=PASS
UNRELATED_PROJECTS_TOUCHED=NO
OLD_PROJECT_UNCHANGED=PASS
VPS_WRITES=ZERO
REAL_PAYMENT_ACTIONS=0
STOP_AT_REVIEWER=YES
```

## Governance note

If this cleanup Gate passes, add the following candidate rule to the GitHub handoff trial backlog:

> Every project execution must keep downloads, extracted packages, generated helper files, caches, and evidence inside the project directory or an explicitly approved shared tooling directory. Temporary reproducible artifacts must be removed before PASS_CANDIDATE.

Do not promote this globally until the GitHub handoff trial reaches the agreed threshold.
