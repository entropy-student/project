# Reviewer Decision — G3CR6R3C Takeover + Source Baseline Reconciliation

> Date: 2026-10-04  
> Governance: **vps-project-governance v0.2.6**  
> Project: Birthday Magazine Studio  
> Current Gate: `G3CR6R3C_TEMPLATE_SOURCE_DISCOVERY`

## Decision

```text
PROJECT_TAKEOVER=ACCEPTED
CURRENT_GATE=KEEP_G3CR6R3C
G3CR6R3C_RESEARCH_EXECUTION=BLOCKED_BY_PREFLIGHT_DRIFT
PREFLIGHT_RESULT=RETURN_PREFLIGHT_DRIFT
RUNTIME_MUTATION=0
PAYMENT_ACTIONS=0
PRODUCTION_ACTIONS=0
OWNER_ACTION_REQUIRED=NONE
```

The project truth on current `main` is coherent and G3CR6R3C remains the correct Gate.  
The execution channel is not yet safe because the existing PR #64 branch is materially stale relative to current canonical project documents.

## Fresh facts

- Current canonical branch read-back: `main=f066e45ac20bb6c9302cf5d0a9343babf335c505`.
- PR #64 remains open/unmerged at head `15ff73f6232e0ef94f04f313f74372e52389d1e2`.
- GitHub compare reports the PR head and `main` are **diverged**: the PR branch has 7 branch-only commits while `main` has hundreds of later repository commits.
- At PR #64 head, `birthday-magazine-studio/REVIEWER_HANDOFF.md` is still the 2026-09-30 handoff declaring the old v0.1.6-era governance surface.
- At PR #64 head, the current files below do not exist:
  - `docs/G3CR6R3C_TEMPLATE_SOURCE_DISCOVERY.md`
  - `docs/G3CR6R3C_TEMPLATE_DISCOVERY_RESEARCH_CONTRACT.md`
  - `docs/OWNER_DECISION_G3CR6R3C_TEMPLATE_RESEARCH_QUALITY_BAR.md`
- The 7 PR-branch-only commits contain G3C/G3CR6R1 execution evidence, screenshots, rollback material and PoC source. They are project evidence and must not be discarded merely to make the branch current.
- GitHub currently reports PR #64 as not mergeable. This is treated as a branch/source reconciliation fact, not as evidence that the accepted G3CR6R1 runtime state is invalid.

## Reviewer interpretation

The current Gate itself is not returned. The **source/execution baseline preflight** is returned.

Do not start broad template research from the stale PR #64 checkout and do not record new G3CR6R3C research into a workspace whose canonical Gate/Handoff are missing.

This is a shared repository. A broad blind merge/rebase of hundreds of unrelated repository commits is not an acceptable cosmetic repair.

## Required preflight before Executor research

1. Use current GitHub `main` as the authoritative governance/project-document baseline.
2. Use a clean project-scoped worktree/sparse workspace or equivalent isolation for `birthday-magazine-studio/`.
3. Compare and preserve the 7 PR #64 branch-only project commits/evidence.
4. Establish one execution workspace that contains:
   - current v0.2.6 `REVIEWER_HANDOFF.md`;
   - current G3CR6R3C Gate;
   - current mandatory research contract;
   - current Owner quality-bar decision;
   - the accepted G3CR6R1 evidence needed only as negative/accepted baseline.
5. Do not mutate WordPress, WooCommerce, payment, local runtime, production, Shared Infra or PR merge state while repairing this source baseline.
6. If the existing PR #64 branch can be safely aligned using a project-scoped preservation strategy, keep it. If that cannot be proven safe, Reviewer may choose a bounded replacement research branch/PR rather than forcing a repository-wide merge.

## Stop condition

G3CR6R3C research may begin only after the execution workspace passes the source-baseline preflight and the current Gate/contract can be read back from that same workspace.

Until then:

```text
STOP_AT_REVIEWER=YES
G3CR6R3C_RESEARCH_STARTED=NO
```
