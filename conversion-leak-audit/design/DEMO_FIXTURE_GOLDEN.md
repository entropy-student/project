# Conversion Leak Audit — Golden Demo Fixture

Status: `FROZEN_FOR_G3_5_VISUALS`

Purpose: provide one truthful, reproducible demo dataset for all final Golden Screens. Do not hand-invent issue counts or findings in design mockups.

## Demo store

Synthetic public storefront used only for product demonstration.

```text
site_id: demo-store-golden-v1
store_type: physical direct-purchase store
pages:
- /
- /products/example
- /cart
- /faq
```

The demo is explicitly labeled `Demo` in public-facing sample-report contexts.

## Rules checked

The UI may state:

```text
17 trusted rules checked
```

because Scanner V0 evaluates the frozen 17-rule set.

Do not display invented totals such as `3 High / 6 Medium / 8 Low` unless those totals are produced by the fixture output.

## Confirmed demo issues

Exactly three issues are used in the Golden Screen fixture.

### 1. CORE-007 — Direct purchase price not visible

Observed fact:
> A direct-purchase product page exposes a purchase action, but no visible product price is present near the purchase decision.

Evidence:
```text
/products/example
source: visible page content near purchase action
```

Allowed UI title:
> Product price not visible near purchase action

Allowed explanation:
> Shoppers may need clear price information before they can evaluate the purchase.

First move:
> Make the current purchase price visible near the primary purchase action.

Do not claim revenue loss or root cause.

### 2. PHYS-002 — Shipping cost/timing not discoverable

Observed fact:
> Shipping cost or delivery timing was not found in the expected purchase-adjacent pages checked by the demo fixture.

Evidence:
```text
/products/example
/cart
```

Allowed UI title:
> Shipping information is hard to find

Allowed explanation:
> Missing or distant shipping information can leave an important purchase question unresolved.

First move:
> Surface shipping cost/timing closer to the product or cart decision point.

### 3. PHYS-001 — Return information not discoverable

Observed fact:
> No clear return/refund policy link or return information was found in the checked public navigation/purchase context.

Evidence:
```text
/
/products/example
/faq
```

Allowed UI title:
> Return information is hard to find

Allowed explanation:
> Return terms are a common purchase-risk question and should be easy to discover before checkout.

First move:
> Make return/refund terms directly discoverable from the relevant purchase journey.

## Free Top 3 screen

The three issues above are the complete free result for this demo fixture.

UI order:
1. CORE-007
2. PHYS-002
3. PHYS-001

Each card must expose:
- title;
- observed fact;
- evidence/source;
- why it may matter;
- first move;
- `View evidence` interaction.

## Full report shell

For G3.5 visuals, the Full Report may show:
- `17 rules checked`;
- the same 3 confirmed issues;
- additional full-report capabilities as future paid expansion labels.

It must NOT invent extra issue counts merely to make the dashboard look fuller.

Allowed paid-expansion preview:
- complete evidence detail;
- prioritized action plan;
- fuller explanations;
- export/report continuity;
- later model-assisted explanation from structured issues.

## Truthfulness constraints

Golden Screens must not contain:
- fake testimonials;
- fake customer counts;
- fake revenue uplift;
- fake lost-sales estimates;
- fabricated additional findings;
- a generic trust-score issue outside the frozen rule set;
- SEO-only findings that are not part of this fixture.

## Claim boundary

Use wording such as:

> Find observable on-site friction worth checking first.

Do not use:
- `Stop losing customers`;
- `Same traffic. More revenue.`;
- `This will increase conversion`;
- exact revenue-loss claims.
