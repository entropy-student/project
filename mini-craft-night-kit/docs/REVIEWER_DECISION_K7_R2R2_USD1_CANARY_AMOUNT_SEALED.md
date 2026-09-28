# Reviewer Decision — K7 R2R2 USD 1.00 Canary Amount Sealed

Date: 2026-09-28
Role: Reviewer / Architect / Gatekeeper

## Owner decision

The Owner explicitly sealed the real Production Canary gross amount as:

```text
REAL_PAYMENT_CANARY_CURRENCY=USD
REAL_PAYMENT_CANARY_AMOUNT_USD=1.00
REAL_PAYMENT_CANARY_GROSS=USD_1_00
```

This amount decision does **not** authorize a real order, buyer approval, payment, capture, refund, or Soft Launch.

## Current Gate

```text
CURRENT_GATE=K7_R2R2_USD_CANARY_REBASE_AND_FINAL_PREPAYMENT_SEAL
CURRENT_GATE_STATUS=AUTHORIZED_NONPAYMENT_PREFLIGHT_AND_CONDITIONAL_CANARY_REBASE
PRODUCTION_TRANSACTION_CURRENCY=USD
REAL_PAYMENT_CANARY_CURRENCY=USD
REAL_PAYMENT_CANARY_AMOUNT_USD=1.00
REAL_PAYMENT_AUTHORIZED=NO
REFUND_AUTHORIZED=NO
SOFT_LAUNCH_AUTHORIZED=NO
```

## Critical currency-impact guard

WooCommerce core normally applies one store currency across products. The historical Canary was validated as JPY 500, while the Owner later changed the intended Production transaction currency to USD.

Therefore this Gate must first perform a fresh read-only currency/price impact preflight.

### If current WooCommerce store currency is already USD

Executor may continue with the bounded reversible Canary rebase:

- mutate only hidden Canary Product 1224 price to exactly `1.00`;
- preserve hidden/catalog-excluded state;
- preserve Simple + Virtual=YES + Downloadable=NO + Sold individually=YES + Manage stock=NO unless fresh current truth shows a material drift;
- do not mutate Product 223 or any unrelated product;
- populate Checkout with exactly qty 1 of Product 1224;
- prove subtotal/total = USD 1.00, shipping = 0, tax = 0 under the existing accepted tax-disabled/virtual semantics;
- prove PayPal is visible and Live-connected;
- no order submit.

### If current WooCommerce store currency is NOT USD

Stop before any currency or Product mutation:

```text
RETURN_CURRENCY_REBASE_IMPACT_REVIEW_REQUIRED
```

Do not switch the global store currency in this Gate.

Evidence must capture, without changing anything:

- current store currency;
- Product 1224 current numeric price/currency semantics;
- Product 223 current numeric price/currency semantics;
- whether a global currency switch would reinterpret unrelated product prices;
- the smallest safe route to reach a USD 1.00 Canary without corrupting production catalog semantics.

Reviewer will decide the next bounded change.

## Final prepayment seal — only after safe USD Checkout is proven

If the USD 1.00 Canary Checkout can be established without unsafe global-currency side effects, seal:

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
PAYPAL_FEE_RECOVERY_STATUS=UNKNOWN_UNTIL_LIVE_TRANSACTION_OR_PROVIDER_TERMS_CORRELATED
NO_BLIND_REPLAY=SEALED
REAL_PAYMENT_AUTHORIZED=NO
```

The later real-money authorization must separately cover exactly one USD 1.00 buyer payment and, only after Provider/WooCommerce/payment correlation passes, exactly one full USD 1.00 refund.

## Forbidden

- global store-currency change unless a later Reviewer Gate explicitly authorizes it;
- Product 223 mutation;
- unrelated Product mutation;
- order creation;
- buyer approval;
- real payment;
- auth/capture;
- refund;
- webhook replay;
- another webhook simulation;
- webhook resubscribe;
- Secret output;
- Shared Infra mutation;
- Soft Launch.
