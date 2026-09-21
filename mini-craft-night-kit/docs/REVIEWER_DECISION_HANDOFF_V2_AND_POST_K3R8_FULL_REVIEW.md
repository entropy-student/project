# Reviewer Decision — Handoff V2 + Post-K3R8 Full Project Review

Date: 2026-09-21
Status: APPROVED / PROJECT-LOCAL

## Why

The Owner correctly identified a review-quality risk: if Reviewer sees only Executor-authored summaries, Reviewer may end up validating the Executor's interpretation rather than independently validating the actual project state.

## Governance basis

This project re-adopts the original Reviewer/Executor governance model:

- Owner → Reviewer → Execution Agent → Evidence → Reviewer PASS/RETURN;
- Execution Agent is execution-only;
- PASS_CANDIDATE is not PASS;
- Reviewer independently checks source/evidence/screenshots/runtime read-back as needed;
- GitHub is transport/audit infrastructure, not an authority that makes Executor claims true;
- Owner should be a bridge/approval gate only when a real external action is required.

## Handoff V2

Effective immediately:

1. EXECUTOR_HANDOFF is navigation, not evidence.
2. EXECUTION_EVIDENCE is an index/summary, not the only review surface.
3. Nontrivial Gates must preserve reviewable actual artifacts in GitHub under a gate-scoped review packet when feasible.
4. Reviewer must inspect the applicable actual source/diff/runtime/test/rollback/artifact evidence before formal PASS.
5. Review-relevant artifacts cannot be deleted before Reviewer PASS.
6. Owner checkpoint commands require post-cleanup readiness proof.
7. Owner should not relay long Executor logs to Reviewer; Reviewer pulls them from GitHub.

## Full review trigger

After the current K3R8* PayPal/helper issue reaches a stable resolved checkpoint:

```text
FULL_PROJECT_REVIEW_AFTER_K3R8_RESOLUTION=REQUIRED
ROUNDS=2_TO_3
K4_BROAD_FEATURE_EXPANSION_BEFORE_FULL_REVIEW=HOLD
```

The review must start from actual current project/runtime/evidence rather than accepting previous Reviewer conclusions as assumptions.

## Scope of that review

- project map and canonical runtime;
- source/config/plugin/theme truth;
- WooCommerce product/cart/checkout/order truth;
- PayPal/PPCP state and K3 evidence;
- database/order/stock state boundaries;
- UI/growth implementation drift;
- Secret/security boundaries;
- rollback/recovery artifacts;
- GitHub/documentation truth vs local runtime truth;
- obsolete artifacts and cleanup;
- K4–K7 roadmap validity.

Previous PASS decisions may be retained only where fresh evidence still supports them. If evidence conflicts, truth must be reconciled rather than defended.

## Global governance

This remains a Mini Craft project-local V2 trial. Do not silently promote it to global governance without a separate Governance Change Gate.