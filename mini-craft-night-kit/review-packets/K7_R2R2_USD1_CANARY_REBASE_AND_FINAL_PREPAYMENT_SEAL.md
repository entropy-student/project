# K7 R2R2 — USD 1.00 Canary Rebase and Final Prepayment Seal

Status: AUTHORIZED_NONPAYMENT_EXECUTION

Governance:
- canonical `entropy-student/spike.skill/vps-project-governance` latest
- Production Provider Canary and Recovery Contract rev2
- current Mini Craft `REVIEWER_HANDOFF.md`
- `docs/REVIEWER_DECISION_K7_R2R1_R1_PASS_AND_USD_CANARY_AMOUNT_CHECKPOINT.md`
- `docs/REVIEWER_DECISION_K7_R2R2_USD1_CANARY_AMOUNT_SEALED.md`

## Goal

Safely prepare the exact USD 1.00 Production Canary without creating any real order/payment.

## Owner-sealed amount

```text
PRODUCTION_TRANSACTION_CURRENCY=USD
REAL_PAYMENT_CANARY_CURRENCY=USD
REAL_PAYMENT_CANARY_AMOUNT_USD=1.00
REAL_PAYMENT_AUTHORIZED=NO
```

## Phase A — mandatory read-only currency-impact preflight

Read fresh authoritative runtime state:

1. WooCommerce global store currency.
2. Product 1224 current:
   - status/visibility;
   - type;
   - virtual/downloadable;
   - sold individually;
   - stock management;
   - numeric regular/sale/current price;
   - rendered currency semantics.
3. Product 223 current numeric price and rendered currency semantics.
4. Current populated/empty Cart/Checkout state as applicable.
5. Current PPCP Live connection and PayPal method visibility.

No mutation is allowed before Phase A classification.

### Branch A1 — store currency already USD

Only if fresh authoritative read-back proves the current WooCommerce store currency is exactly USD and there is no material drift:

Continue to Phase B.

### Branch A2 — store currency is not USD

Immediately stop before any store-currency, Product, Cart, or Checkout mutation:

```text
RESULT=RETURN_CURRENCY_REBASE_IMPACT_REVIEW_REQUIRED
STOP_AT_REVIEWER=YES
```

Evidence must include:

```text
WOOCOMMERCE_STORE_CURRENCY=
PRODUCT_1224_CURRENT_NUMERIC_PRICE=
PRODUCT_1224_CURRENT_RENDERED_CURRENCY=
PRODUCT_223_CURRENT_NUMERIC_PRICE=
PRODUCT_223_CURRENT_RENDERED_CURRENCY=
GLOBAL_CURRENCY_SWITCH_WOULD_REINTERPRET_UNRELATED_PRICES=YES/NO/UNKNOWN
SAFE_USD_CANARY_ROUTE_CANDIDATE=<non-mutating analysis only>
```

Do not change the global currency in this Gate.

## Phase B — conditional hidden Canary rebase

Allowed only after Branch A1 PASS.

Mutate only Product 1224:

```text
PRICE=1.00
CURRENCY=USD via already-existing global store currency
QUANTITY_FOR_CHECKOUT=1
```

Preserve accepted fixture semantics unless fresh drift requires RETURN:

- Product ID 1224;
- hidden/catalog-excluded;
- Simple;
- Virtual=YES;
- Downloadable=NO;
- Sold individually=YES;
- Manage stock=NO;
- truthful controlled Canary description.

Forbidden:
- Product 223 mutation;
- any unrelated Product mutation;
- global store-currency mutation;
- tax policy mutation;
- shipping policy mutation.

## Phase C — populated Checkout revalidation

Using exactly one Product 1224:

Prove:

```text
CANARY_QUANTITY=1
CANARY_ITEM_TOTAL_USD=1.00
CANARY_SHIPPING_USD=0.00
CANARY_TAX_USD=0.00
CANARY_ORDER_TOTAL_USD=1.00
PAYPAL_METHOD_PRESENT=YES
PAYPAL_LIVE_CONNECTED=PASS
ORDER_CREATION=0
REAL_PAYMENT_ACTIONS=0
```

Do not press any order-submit, PayPal approval, or buyer-payment control.

## Phase D — final prepayment seal

Read-only/documentation only.

Seal:

```text
BUYER_ACCOUNT_SEPARATION=REQUIRED
SAME_PAYPAL_ACCOUNT_BUYER_AND_MERCHANT=FORBIDDEN
MAX_REAL_ORDERS=1
MAX_REAL_BUYER_APPROVALS=1
MAX_REAL_PAYMENTS=1
MAX_REAL_REFUNDS=1
EXPECTED_PAID_ORDER_STATUS=PROCESSING
EXPECTED_SIGNED_WEBHOOK_PROOF=DEFERRED_TO_REAL_CANARY
EXPECTED_EMAIL_PATH=ORDER_TRANSACTIONAL_EMAIL_OBSERVATION
FULL_REFUND_GROSS_USD=1.00
PAYPAL_FEE_RECOVERY_STATUS=UNKNOWN_OWNER_AWARENESS_REQUIRED_BEFORE_REAL_PAYMENT
NO_BLIND_REPLAY=SEALED
REAL_PAYMENT_AUTHORIZED=NO
REFUND_AUTHORIZED=NO
SOFT_LAUNCH_AUTHORIZED=NO
```

Do not infer fee recovery from another jurisdiction or historical terms. If exact live fee/refund treatment is not authoritative, retain UNKNOWN for the later Owner authorization checkpoint.

## Allowed actions

- read project/Governance state;
- read current WooCommerce/Product/PPCP state;
- conditional Product 1224 price update only if store currency already USD;
- bounded cart-session mutation needed to populate exactly Product 1224 qty 1;
- read-only Checkout validation;
- Evidence/Handoff persistence to GitHub.

## Strictly forbidden

- global store-currency mutation;
- Product 223 mutation;
- unrelated Product mutation;
- order creation;
- Place order;
- PayPal buyer approval/login;
- authorization/capture;
- payment;
- refund;
- void/cancel provider transaction;
- real or historical webhook replay;
- Simulate webhooks;
- Resubscribe webhooks;
- PayPal settings mutation;
- Secret/token/private-key/hash output;
- DNS/Caddy/VPS/Shared Infra mutation;
- Soft Launch.

## Evidence minimum

```text
GATE=K7_R2R2_USD_CANARY_REBASE_AND_FINAL_PREPAYMENT_SEAL
OWNER_SEALED_CANARY_AMOUNT_USD=1.00
WOOCOMMERCE_STORE_CURRENCY=
PRODUCT_1224_PRE_PRICE=
PRODUCT_1224_POST_PRICE=
PRODUCT_1224_MUTATION_COUNT=
PRODUCT_223_MUTATION_COUNT=0
STORE_CURRENCY_MUTATION_COUNT=0
CANARY_QUANTITY=
CANARY_ITEM_TOTAL_USD=
CANARY_SHIPPING_USD=
CANARY_TAX_USD=
CANARY_ORDER_TOTAL_USD=
PAYPAL_METHOD_PRESENT=
PAYPAL_LIVE_CONNECTED=
BUYER_ACCOUNT_SEPARATION=
SAME_PAYPAL_ACCOUNT_BUYER_AND_MERCHANT=
MAX_REAL_ORDERS=1
MAX_REAL_BUYER_APPROVALS=1
MAX_REAL_PAYMENTS=1
MAX_REAL_REFUNDS=1
EXPECTED_PAID_ORDER_STATUS=PROCESSING
EXPECTED_SIGNED_WEBHOOK_PROOF=DEFERRED_TO_REAL_CANARY
FULL_REFUND_GROSS_USD=1.00
PAYPAL_FEE_RECOVERY_STATUS=
NO_BLIND_REPLAY=SEALED
ORDER_CREATION=0
REAL_PAYMENT_ACTIONS=0
CAPTURE_ACTIONS=0
REFUND_ACTIONS=0
SECRET_VALUES_EMITTED=0
SOFT_LAUNCH_AUTHORIZED=NO
```

## Success

Only if store currency was already USD and the exact USD 1.00 Checkout is proven safely:

```text
PASS_CANDIDATE_K7_R2R2_USD_CANARY_REBASE_AND_FINAL_PREPAYMENT_SEAL
STOP_AT_REVIEWER=YES
```

If store currency is not USD:

```text
RETURN_CURRENCY_REBASE_IMPACT_REVIEW_REQUIRED
STOP_AT_REVIEWER=YES
```

Do not repair or expand scope after a RETURN.
