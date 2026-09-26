# G2A — Frontend Foundation + Component PoC + MVP UI Freeze

> Reviewer execution contract  
> Status: READY_FOR_EXECUTOR  
> Parent truth: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)

## Goal

Choose the lowest-custom-work frontend foundation that still preserves the Birthday Magazine product experience.

Compare:

1. Kadence Jewelry Shop + Storelly
2. Blocksy Modern Shop + Storelly
3. Existing Good Issue prototype as the custom-reference baseline

This Gate is a local/test-only PoC. It does not implement AI, PayPal, production uploads, VPS or real customer data.

## Required Product Experience

The PoC must prove whether the chosen path can support:

```text
Product landing
→ name / age / style / optional local photo
→ instant zero-token cover + 1–2 spread preview
→ visible US$39.99 unlock CTA
→ WooCommerce-compatible path to checkout
```

The critical interaction is:

```text
simple inputs
      ↓
immediate magazine-shaped result
```

Do not replace this with a generic ecommerce product gallery.

## Allowed

- local WordPress test environment;
- free/open-source theme/plugin installation needed for the three PoCs;
- synthetic/demo photos only;
- temporary products/pages;
- CSS/JS needed to reproduce the minimum Good Issue interaction;
- screenshots and implementation notes;
- plugin/theme removal during cleanup.

## Forbidden

- PayPal account connection;
- real payment;
- AI/model API calls;
- production customer uploads;
- Secret entry;
- paid plugin purchase;
- VPS/domain/public production deployment;
- implementing the full 12-page generation engine;
- broad WordPress redesign outside the PoC.

## Evidence Required

For each route record:

- exact theme/plugin/version;
- install/activation result;
- Home/Product/preview screenshots at desktop and 375px;
- whether preview stays local/browser-only;
- whether Storelly can reproduce the required cover + spread concept without server/model calls;
- WooCommerce product/cart/checkout compatibility;
- custom code/files required;
- blockers/limitations;
- rollback/cleanup result.

## Decision Matrix

Score only evidence-backed facts:

| Criterion | A Kadence+Storelly | B Blocksy+Storelly | C Good Issue custom |
|---|---:|---:|---:|
| Editorial visual fit |  |  |  |
| 375px mobile |  |  |  |
| Zero-token preview |  |  |  |
| Woo compatibility |  |  |  |
| Admin editability |  |  |  |
| Custom code required |  |  |  |
| Plugin lock-in |  |  |  |
| Reuse into final MVP |  |  |  |

Do not invent a winner before the PoC.

## PASS Criteria

G2A can be PASS only when:

- all three routes have a comparable local evidence set, or a route is proven infeasible with specific evidence;
- one frontend foundation can be selected without relying on unverified claims;
- the selected path preserves the zero-token preview boundary;
- the selected path preserves WooCommerce compatibility;
- the selected path has an explicit migration/adaptation plan for Good Issue visual language;
- no live payment/AI/customer data action occurred;
- temporary PoC artifacts are either retained intentionally under the project or cleaned up.

## Return Conditions

Use a precise RETURN if:

- Storelly cannot meet the preview requirement without server/cloud dependency that breaks the zero-token/local boundary;
- a theme/plugin requires paid-only capability for the critical path;
- the PoC cannot preserve WooCommerce compatibility;
- the current runtime cannot support a clean comparison;
- plugin/theme conflicts make the evidence ambiguous.

## Output

Executor must create/update:

- `EXECUTOR_HANDOFF.md`
- `EXECUTION_EVIDENCE.md`

and return:

```text
PASS_CANDIDATE_G2A_FRONTEND_FOUNDATION_POC
STOP_AT_REVIEWER: YES
```

or a precise `RETURN_*`.
