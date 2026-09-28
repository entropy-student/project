# Reviewer Decision — K7 R2R2 R1 RETURN / Bounded USD Store Migration Path

Date: 2026-09-28
Role: Reviewer / Architect / Gatekeeper

## Reviewed Executor result

Accepted persistence:

- Evidence: `f93ea95945f683e75b5409feffef5fedac971335`
- Executor Handoff: `706ce6f6480346c67702423e88fc181f520c3d9f`

Accepted fresh facts:

```text
WOOCOMMERCE_STORE_CURRENCY=JPY
PRODUCT_1224_PRICE=500_JPY
PRODUCT_1224_STATUS_VISIBILITY=publish/HIDDEN
PRODUCT_223_PRICE=1_JPY
PRODUCT_223_STATUS_VISIBILITY=publish/VISIBLE
PRODUCT_223_CATALOG_ROLE=PUBLIC_CATALOG
GLOBAL_CURRENCY_SWITCH_WOULD_REINTERPRET_UNRELATED_PRICES=YES
PRODUCT_1224_MUTATION=0
PRODUCT_223_MUTATION=0
STORE_CURRENCY_MUTATION=0
ORDER_CREATION=0
REAL_PAYMENT_ACTIONS=0
```

## Historical truth reconciliation

The currency-impact blocker is real, but Product 223's `1 JPY` is not production commercial truth.

The accepted K2 Reviewer decision explicitly states:

- JPY 1 product price = test-only;
- JPY site currency = test-only;
- these values are not business decisions and must not be treated as production truth.

Growth readiness later repeats that the current JPY 1 price/currency/SKU/stock are test state, while production price/product truth remains an Owner/supplier checkpoint.

The Owner has since explicitly chosen:

```text
PRODUCTION_TRANSACTION_CURRENCY=USD
REAL_PAYMENT_CANARY_CURRENCY=USD
REAL_PAYMENT_CANARY_AMOUNT_USD=1.00
```

Therefore a separate second USD store is not justified for this project. The intended production store itself should migrate to USD, while unresolved test-only public product pricing must be neutralized before the currency flip.

## Reviewer design

Use a bounded reversible migration:

```text
Product 223: published concept shell, test price removed, non-purchasable
WooCommerce global currency: JPY -> USD
Hidden Canary Product 1224: 500 -> 1.00
```

Do not invent a production price for Product 223.

Keep Product 223's title/content/media/status/visibility/SKU/stock and other product truth unchanged unless an exact field must change to establish non-purchasability. Price must be EMPTY / unset, not numeric zero.

Production Product 223 remains non-purchasable until the Owner later approves actual product data and production pricing.

## Current Gate

```text
CURRENT_GATE=K7_R2R2_R2_BOUNDED_USD_STORE_MIGRATION_AND_CANARY_SEAL
CURRENT_GATE_STATUS=AUTHORIZED_REVERSIBLE_NONPAYMENT_MIGRATION
PRODUCTION_TRANSACTION_CURRENCY=USD
REAL_PAYMENT_CANARY_AMOUNT_USD=1.00
REAL_PAYMENT_AUTHORIZED=NO
REFUND_AUTHORIZED=NO
SOFT_LAUNCH_AUTHORIZED=NO
OWNER_ACTION=NONE
```

## Pre-mutation guard

Before writes:

1. Freshly read the complete set of published WooCommerce product IDs and their catalog visibility / non-empty numeric price state.
2. Confirm Product 223 remains the only ordinary public/catalog-visible product with a numeric test price and Product 1224 remains the hidden Canary.
3. If another public/catalog-visible product has a non-empty numeric price, RETURN for Reviewer impact analysis.
4. Capture exact rollback values for:
   - global currency;
   - Product 223 regular/current/sale price fields;
   - Product 1224 regular/current/sale price fields.
5. Create one project-local DB backup under the existing Mini Craft backup namespace. No Shared Infra mutation.

## Authorized write sequence

Only after preflight PASS:

1. Product 223:
   - remove/unset test regular/current/sale price as applicable;
   - do NOT set price to 0;
   - leave public concept-shell content/status/visibility unchanged;
   - verify `is_purchasable=NO` and no functional Add-to-Cart purchase path.

2. Change only WooCommerce global store currency:
   - `JPY -> USD`.

3. Product 1224:
   - regular/current price = `1.00`;
   - preserve hidden Canary fixture semantics.

4. Clear only narrow WooCommerce caches/transients required by these exact product/currency updates if the supported API does not already do so. No broad cache purge.

5. Read back authoritative runtime state.

6. Populate Cart/Checkout with exactly Product 1224 qty 1 and prove:
   - item/subtotal/order total USD 1.00;
   - shipping USD 0.00;
   - tax USD 0.00 under accepted fixture semantics;
   - PayPal method visible;
   - no order submit.

7. Re-prove Product 223 is not purchasable and does not expose the old test price as a customer-buyable offer.

## Rollback rule

If any post-write invariant fails before PASS_CANDIDATE:

- restore Product 223 exact pre-gate price fields;
- restore Product 1224 exact pre-gate price fields;
- restore global currency to JPY;
- read back restored state;
- RETURN exact failure cause.

No partial migrated state may be left behind.

Do not rollback a fully passing migration merely because the Gate stops at Reviewer; USD is the intended production currency.

## Final prepayment seal

On successful migration:

```text
WOOCOMMERCE_STORE_CURRENCY=USD
PRODUCT_223_TEST_PRICE_REMOVED=YES
PRODUCT_223_PURCHASABLE=NO
PRODUCT_223_PRODUCTION_PRICE=UNSEALED_OWNER_PRODUCT_TRUTH_CHECKPOINT
PRODUCT_1224_PRICE_USD=1.00
CANARY_ORDER_TOTAL_USD=1.00
PAYPAL_LIVE_CONNECTED=CARRIED_FORWARD_PASS
BUYER_ACCOUNT_SEPARATION=REQUIRED
SAME_PAYPAL_ACCOUNT_BUYER_AND_MERCHANT=FORBIDDEN
MAX_REAL_ORDERS=1
MAX_REAL_BUYER_APPROVALS=1
MAX_REAL_PAYMENTS=1
MAX_REAL_REFUNDS=1
EXPECTED_PAID_ORDER_STATUS=PROCESSING
EXPECTED_SIGNED_WEBHOOK_PROOF=DEFERRED_TO_REAL_CANARY
FULL_REFUND_GROSS_USD=1.00
PAYPAL_FEE_RECOVERY_STATUS=UNKNOWN_OWNER_AWARENESS_REQUIRED
NO_BLIND_REPLAY=SEALED
REAL_PAYMENT_AUTHORIZED=NO
REFUND_AUTHORIZED=NO
SOFT_LAUNCH_AUTHORIZED=NO
```

## Forbidden

- inventing or setting a production price for Product 223;
- changing Product 223 title/content/media/SKU/stock or other product truth;
- changing any unrelated product price/status;
- order creation;
- Place order;
- buyer PayPal login/approval;
- payment/capture/refund;
- webhook replay/simulation/resubscribe;
- PayPal settings mutation;
- Secret/token/nonce/session/hash output;
- Shared Infra mutation;
- Soft Launch.
