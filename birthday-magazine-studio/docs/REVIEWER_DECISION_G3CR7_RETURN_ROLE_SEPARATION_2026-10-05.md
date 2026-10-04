# Reviewer Decision — G3CR7 RETURN: Independent Executor Reproduction Required

> Date: 2026-10-05
> Governance: vps-project-governance v0.2.7
> Evidence provenance: DIRECT_READBACK + Reviewer reconciliation
> Current PR: #64
> Non-authoritative reference source: `0603706ca0441fb1cb65ff716f47f7a919e2e4f3`
> Clean accepted pre-implementation source baseline: `e71f94377d341a88ba388f2c5da153e7cd6ee8b8`

## Decision

```text
GATE=G3CR7_THREE_FRONTEND_SURFACES
FORMAL_DECISION=RETURN_EXECUTOR_REPRODUCTION_REQUIRED
PRIOR_SOURCE_PASS=INVALIDATED
PRIOR_PASS_CANDIDATE_SOURCE_ONLY=INVALIDATED
PRIOR_PAYMENT_TRUTH_REVIEW_PASS=INVALIDATED
PRIOR_PREVIEW_STYLE_HANDOFF_PASS=INVALIDATED
RUNTIME_VISUAL=UNVERIFIED
OWNER_VISUAL_ACCEPTANCE=PENDING
REFERENCE_PROTOTYPE_MAY_BE_CONSULTED=YES
REFERENCE_PROTOTYPE_IS_ACCEPTED_BASELINE=NO
```

## Why

The prior round violated the intended Owner/Reviewer/Executor separation: Reviewer designed the Gate, implemented project source, and then reviewed that same implementation. Under Governance section 2 and section 7, that cannot be promoted into accepted project truth.

The prior prototype therefore remains useful only as a **non-authoritative reference**. It is not an accepted implementation baseline and none of its self-reviewed PASS labels survive this decision.

The prior candidate record also contains verification language such as PHP lint PASS that was not produced as independent Executor Evidence in that round. Those statements are historical claims only and cannot satisfy the new Gate.

## What remains accepted

This RETURN does **not** invalidate earlier accepted project work:
- G2BR3 solution proof;
- G3A commerce/account/private-workspace proof;
- G3B/G3BR1 Sandbox lifecycle proof;
- accepted G3CR6 homepage visual/motion baseline;
- Owner-approved customer flow: Homepage -> Free Preview -> Core function -> full intake -> Submit -> WooCommerce payment -> generation -> result;
- Owner decision to complete the three frontend surfaces before P1-P12.

## Baseline and reference handling

Executor must reproduce from the accepted pre-implementation source baseline `e71f94377d341a88ba388f2c5da153e7cd6ee8b8` for the G3CR7 target files.

Known baseline blobs:
- `birthday-magazine-poc.php`: `a677f5c321d9ac323c64b7efda73a57a37efe431`
- `preview.js`: `bf60295a2236eb96e0c358158653b05b95b1f390`
- `home.css`: `709556a42d2058d8252392f5df5d8339aae5d126`
- `studio.css`: `33252bd489156cf05522bf9a2cb60d4c89078de1`
- `magazine-preview.css`: `6eb88f4cc76ca99692499cd8eeb13362697507eb`

Files introduced after that baseline by the Reviewer prototype are **reference-only** and must not be treated as accepted source.

Do not rewrite Git history. In a clean project-scoped worktree, restore/construct the target implementation from the accepted baseline, then implement and validate independently. The current PR history may retain the reference prototype for audit.

## Next authority

Current Gate becomes:
- `docs/G3CR7R1_EXECUTOR_REPRODUCTION.md`

Only a fresh Executor completion packet + reviewable Evidence may produce a new PASS_CANDIDATE. Reviewer then independently decides PASS / RETURN.
