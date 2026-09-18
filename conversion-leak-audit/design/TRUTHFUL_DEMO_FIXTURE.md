# Conversion Leak Audit — Truthful Demo Fixture

Status: FROZEN_FOR_G3_5
Purpose: provide one reproducible, clearly synthetic demo dataset for Golden Screens. It is not a customer case study.

## Fixture identity

Name: `demo-store-physical-v1`
Type: synthetic physical-goods storefront fixture
Claim: demonstration only
Source: frozen Scanner V0 rule contract

## Applicable trusted rules shown in demo

### Finding 1 — CORE-007
Title: Price cannot be determined before purchase action

Observed fact:
The product page exposes a direct purchase action, but the visible page state does not provide a determinable price or price calculation before purchase.

Evidence example:
`/products/example-chair`
Locator: product purchase region

Allowed claim:
The direct-purchase price is not clearly determinable in the observed page state.

Forbidden:
This causes a specific conversion loss or is the root cause of low sales.

### Finding 2 — PHYS-002
Title: Shipping cost or delivery timing was not found

Observed fact:
For the scanned region/context, shipping cost/free-threshold and estimated delivery timing were not found within the allowed discovery path.

Evidence example:
`/products/example-chair`, `/cart`, navigation/footer checked

Allowed claim:
Shipping cost/timing was not found within the audited public-page path for this context.

Forbidden:
Customers definitely abandoned because of shipping.

### Finding 3 — PHYS-001
Title: Return information was not found

Observed fact:
No return/refund information was discovered within the allowed P0–P4 public-page discovery path.

Evidence example:
product page + navigation/footer + policy/help links checked

Allowed claim:
Return information was not found within the audited public-page path.

Forbidden:
The store has no return policy.

## Report summary contract

Golden Screens must use:

```text
3 confirmed findings
17 trusted checks evaluated
Synthetic demo
```

Do not invent:
- High / Medium / Low totals;
- lost revenue;
- uplift percentages;
- customer quotes;
- testimonials;
- additional issues outside the frozen trusted rules.

## UI wording

Home headline candidate:
> Find friction that may be making customers hesitate.

Supporting line:
> Scan public storefront pages for evidence-backed issues. Get a free Top 3 based on trusted checks, not guesses.

Results intro:
> We found 3 confirmed findings in this demo scan.

Full report label:
> Synthetic demo — not a customer case study.

## Golden Screen rule

Every issue, count and evidence example visible in a G3.5 Golden Screen must either:
1. come from this fixture; or
2. be generic UI chrome with no factual implication.

No handwritten placeholder metric may appear in the frozen Golden Screens.
