# Conversion Leak Audit — Final Golden Screen Specification

Status: `APPROVED_FROZEN_G3_5`
Gate: `G3.5_UI_GROWTH_DESIGN_FREEZE`

This document is the text-canonical companion to the final high-fidelity board reviewed in chat. If generated-image text conflicts with this file, **this file wins**.

## Brand

- Primary logo: Gap Mark.
- Visual direction: Editorial Diagnostic Console / Evidence-first Diagnostic.
- White / clean canvas, deep navy text, blue primary action.
- Platform compatibility strip: WordPress/WooCommerce, Shopify, Wix, Squarespace, BigCommerce, + more.
- Platform marks mean compatibility only, not partnership.

## Home

Canonical headline:

> Find friction that may be making customers hesitate.

Supporting copy:

> Scan public storefront pages for evidence-backed issues. Get a free Top 3 based on trusted checks, not guesses.

Trust facts:
- No credit card for free scan.
- Public pages only.
- No admin access.
- No changes to the site.

The synthetic preview product page must **not show a determinable price**, because the demo contains CORE-007.

## Scan progress

Canonical fixture contains exactly four pages.

Allowed progress examples:
- 1 / 4
- 2 / 4
- 3 / 4
- 4 / 4

Stages:
1. Checking access
2. Reading pages
3. Analyzing with trusted rules
4. Finalizing results

Do not invent fake completion percentages.

## Free Top 3

Exactly these findings, in this order:

1. `CORE-007` — Price cannot be determined before purchase action
2. `PHYS-002` — Shipping cost or delivery timing was not found
3. `PHYS-001` — Return information was not found

Each card exposes:
- rule id;
- observed fact;
- evidence/source;
- why it may matter;
- first move;
- View evidence.

Do not show High / Medium / Low until a separate prioritization algorithm is formally frozen.

## Full Report

Summary must be:

```text
3 confirmed findings
17 trusted checks
Synthetic Demo
```

Do not invent extra findings, severity totals, uplift estimates or revenue loss.

Allowed paid-expansion presentation:
- complete evidence detail;
- prioritized action plan;
- fuller explanation;
- report export / continuity;
- later model-assisted explanation from structured findings.

Canonical CTA framing:

> Review these findings and address the friction you can verify.

Do not claim that fixing findings guarantees higher conversion.

## Claim boundary

Allowed:
- observed facts;
- information was not found in the audited path;
- an unresolved purchase question may be worth checking;
- evidence-backed next action.

Forbidden:
- root cause;
- exact revenue loss;
- guaranteed conversion uplift;
- fabricated customer psychology;
- fake testimonial/social proof.

## Responsive references

Golden implementation must cover:
- Desktop 1440px reference viewport;
- Mobile 390px reference viewport;
- Home;
- Scan progress;
- Free Top 3;
- Full Report shell.

## Acceptance

At G4.5, Codex must produce Playwright screenshots from the implemented product. Reviewer compares them against this design system + approved high-fidelity direction.

Generated-image text is illustrative only. Functional facts and claims must follow this file and `DEMO_FIXTURE_GOLDEN.md`.
