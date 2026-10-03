# Reviewer Decision — G3CR6R3C Project-Scoped Preflight Fix

> Date: 2026-10-04  
> Governance: **vps-project-governance v0.2.6**  
> Gate: `G3CR6R3C_TEMPLATE_SOURCE_DISCOVERY`

## Result

```text
EXECUTOR_RETURN=ACCEPTED_AS_CORRECT_UNDER_PRIOR_PREFLIGHT
EXECUTOR_RESULT=RETURN_PREFLIGHT_DRIFT
ACTUAL_BIRTHDAY_MAGAZINE_PROJECT_DRIFT=NO
ROOT_CAUSE=OVERBROAD_MONOREPO_MAIN_ANCESTRY_REQUIREMENT
SOURCE_BASELINE_PREFLIGHT=PASS_AFTER_RECONCILIATION
G3CR6R3C_RESEARCH_AUTHORIZED=YES
OWNER_ACTION_REQUIRED=NONE
```

## Fresh facts

Executor reported:

- PR #64 head `ee8dd61330dab14c4637e16c7c2cb26d87b107cf` remains a descendant of reconciliation anchor `83a8ad33ed70e2a391e4a4dacd71e0b812b15ef6`;
- repository `main` advanced to `dd8651aa760062f71ddc84a1154b21873ecbc174`;
- therefore the prior literal requirement that PR #64 contain the latest whole-repository `main` was false.

Reviewer read-back shows the two main-only commits after the PR's incorporated main baseline are:

1. `fc2aa9399627c19b5368ed6da6a219deaeb20b77` — only:
   - `vpn-network-optimization/EXECUTION_EVIDENCE.md`
   - `vpn-network-optimization/EXECUTOR_HANDOFF.md`
   - `vpn-network-optimization/docs/ROUND_TIMING_RETROSPECTIVE.md`
2. `dd8651aa760062f71ddc84a1154b21873ecbc174` — only the same `vpn-network-optimization/` paths.

No intervening `main` commit touched `birthday-magazine-studio/` or a shared dependency declared by the current G3CR6R3C Gate.

## Reviewer interpretation

The Executor behaved correctly: the prior Gate explicitly required the current whole-repository `main` to be in the PR ancestry, so it was required to stop.

The Gate condition was too broad for this shared monorepo. Unrelated commits from another project can move `main` at any time and would cause an endless sync/RETURN loop even when the Birthday Magazine source baseline is unchanged.

Governance requires source provenance, project-owned scope and contamination checks; it does **not** require unrelated monorepo commits to be ancestors of a project branch.

## Corrected project-scoped preflight

For G3CR6R3C:

```text
PR_HEAD_MUST_DESCEND_FROM_RECONCILIATION_ANCHOR=YES
PROJECT_SCOPED_MAIN_FRESHNESS_REQUIRED=YES
WHOLE_REPOSITORY_MAIN_TIP_ANCESTRY_REQUIRED=NO
UNRELATED_MONOREPO_MAIN_COMMITS_BLOCK=NO
```

Before research starts, Executor must check:

1. PR #64 current head descends from reconciliation anchor `83a8ad33ed70e2a391e4a4dacd71e0b812b15ef6`.
2. Compare PR head against current `main` **only for**:
   - `birthday-magazine-studio/**`;
   - any additional shared path explicitly named by the current Gate.
3. If current-main-only changes exist in those scoped paths, return `RETURN_PREFLIGHT_DRIFT`.
4. If current-main-only changes are exclusively outside those paths, they are unrelated monorepo movement and do not invalidate the Birthday Magazine execution baseline.
5. Current Gate / Research Contract / Owner Quality Bar must still be readable from the PR execution workspace.

For this Gate there are currently no extra shared source paths beyond `birthday-magazine-studio/**`.

## Stop boundary

This decision changes only source-preflight interpretation for the current project Gate.

No runtime, WordPress, WooCommerce, payment, production, Shared Infra or PR merge action is authorized.
