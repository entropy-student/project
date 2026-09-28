# K9B-R2R2A-R2 — Authenticated WordPress Admin Product 1224 Containment

Status: AUTHORIZED_OWNER_AUTHENTICATED_APPLICATION_MUTATION
Date: 2026-09-29

Read first:
- current REVIEWER_HANDOFF.md
- docs/REVIEWER_DECISION_K9B_R2R2A_R2_AUTHENTICATED_WP_ADMIN_CONTAINMENT.md
- latest EXECUTION_EVIDENCE.md
- latest EXECUTOR_HANDOFF.md

## Execution boundary

Use the Owner's already-authenticated WordPress Admin session in the Codex embedded browser.

Do not request, expose, re-enter, copy, or store credentials.

## Exact task

Navigate to WooCommerce/Products and open Product ID 1224.

Pre-check:
- ID = 1224
- Status = Published
- Price = USD 1.00
- Catalog visibility = Hidden

If any differs materially, stop.

Change only:
- Status: Published -> Draft

Save/update once.

Do not change any other product field.

## Post-check in Admin

Verify:
- ID = 1224
- Status = Draft
- Price = USD 1.00
- Catalog visibility = Hidden

## Public validation

In logged-out/incognito/public context verify:
- /shop/ does not show 1224;
- unauthenticated Store API search does not return 1224;
- unauthenticated Store API direct Product 1224 is not public;
- public product permalink is not public;
- Product 1224 is not publicly purchasable.

Do not create cart/order/checkout.

## Forbidden

No:
- Product 223 mutation
- PayPal/webhook/email mutation
- order/payment/refund
- filesystem/Docker mutation
- plugin/theme/file editor
- direct SQL
- plugin installation

## Persist

Append Evidence and Handoff and fresh-read-back both.

Success:

```text
PASS_CANDIDATE_K9B_R2R2A_R2_AUTHENTICATED_WP_ADMIN_PRODUCT_1224_CONTAINMENT
STOP_AT_REVIEWER=YES
```

Do not continue K9B cleanup or K9C.
