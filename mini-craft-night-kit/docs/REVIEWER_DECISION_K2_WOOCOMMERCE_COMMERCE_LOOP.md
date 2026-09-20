# Reviewer Decision — K2 WooCommerce Commerce Loop

Date: 2026-09-21
Status: APPROVED TO EXECUTE

## Gate

`K2_WOOCOMMERCE_COMMERCE_LOOP`

## Goal

Run and verify the local WooCommerce commerce loop:

```text
Product
→ Add to Cart
→ Cart
→ Checkout
→ Order creation
→ Order confirmation
→ Orders admin
```

## Scope

Configure and verify only the minimum local commerce semantics needed for the Mini Craft MVP:

- canonical product setup;
- SKU / stock strategy;
- quantity behavior;
- cart add/update/remove;
- checkout required fields and validation;
- local shipping method / rate placeholder sufficient for checkout testing;
- order creation and order-state baseline;
- order confirmation page;
- Orders admin visibility.

## Boundaries

Do not enter:

- PayPal or any payment-provider setup;
- real payment;
- production shipping promises;
- VPS;
- production domain;
- K4 trust/content work;
- final image generation.

Do not invent real shipping time, real shipping fee, tax policy, returns policy, or fulfillment promises. If real values are unknown, use clearly local/test-only configuration and record it in Evidence.

## Required evidence

Executor must update:

- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Minimum checks:

```text
PRODUCT_CONFIG=PASS
SKU_STOCK_STRATEGY=PASS
ADD_TO_CART=PASS
CART_UPDATE_REMOVE=PASS
CHECKOUT_VALIDATION=PASS
LOCAL_SHIPPING_TEST_CONFIG=PASS
ORDER_CREATION=PASS
ORDER_CONFIRMATION=PASS
ORDERS_ADMIN=PASS
ORDER_STATE_BASELINE=PASS
GUTENBERG_REGRESSION=PASS
RESPONSIVE_SMOKE=PASS
REAL_PAYMENT_ACTIONS=0
PAYPAL_CONFIGURED=NO
VPS_WRITES=ZERO
SECRET_EXPOSURE=NO
STOP_AT_REVIEWER=YES
```

## Stop conditions

Return instead of improvising if:

- order creation requires a payment-provider action;
- checkout cannot proceed without inventing real business policy;
- WooCommerce core behavior breaks;
- Studio local runtime becomes unstable;
- a fix would require broad theme/layout reconstruction.

Stop at Reviewer after evidence is written.