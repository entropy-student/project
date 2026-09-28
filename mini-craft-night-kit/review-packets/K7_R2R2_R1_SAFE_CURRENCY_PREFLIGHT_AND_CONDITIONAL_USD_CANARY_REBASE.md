# K7 R2R2 R1 — Safe Currency Preflight and Conditional USD Canary Rebase

Status: AUTHORIZED_RESUME

Read first:
- current REVIEWER_HANDOFF.md
- docs/REVIEWER_DECISION_K7_R2R2_USD1_CANARY_AMOUNT_SEALED.md
- docs/REVIEWER_DECISION_K7_R2R2_SECRET_RISK_RECONCILED_SAFE_RESUME.md
- latest accepted EXECUTION_EVIDENCE.md / EXECUTOR_HANDOFF.md
- canonical Governance latest

## Owner-sealed amount

```text
REAL_PAYMENT_CANARY_CURRENCY=USD
REAL_PAYMENT_CANARY_AMOUNT_USD=1.00
REAL_PAYMENT_AUTHORIZED=NO
```

## Phase A — safe read-only preflight

Do NOT use PPCP detailed logs or broad browser accessibility snapshots.

Prefer existing verified SSH + read-only WordPress/WooCommerce runtime commands.

Read exactly:
- WooCommerce global currency;
- Product 1224 current numeric price + required fixture metadata;
- Product 223 current numeric price + catalog/publication role needed to classify currency impact.

Do not dump environment variables, all wp_options, cookies, nonces, sessions, PPCP log payloads, secrets, tokens, or hashes.

Carry forward the already-accepted K7 R2R1 PayPal Live/Business/current-origin webhook PASS unless material drift is discovered. Do not reopen PPCP settings/logs just to re-prove it.

## Branch

If store currency != USD:

```text
RETURN_CURRENCY_REBASE_IMPACT_REVIEW_REQUIRED
STOP_AT_REVIEWER=YES
```

No writes of any kind.

Evidence:
```text
WOOCOMMERCE_STORE_CURRENCY=
PRODUCT_1224_CURRENT_NUMERIC_PRICE=
PRODUCT_1224_CURRENT_STATUS_VISIBILITY=
PRODUCT_223_CURRENT_NUMERIC_PRICE=
PRODUCT_223_CURRENT_STATUS_VISIBILITY=
GLOBAL_CURRENCY_SWITCH_WOULD_REINTERPRET_UNRELATED_PRICES=
SAFE_USD_CANARY_ROUTE_CANDIDATE=
```

If store currency == USD:

Continue with bounded reversible write:
- change only Product 1224 price to 1.00;
- preserve hidden Canary semantics;
- Product 223 mutation = 0;
- global currency mutation = 0;
- populate Checkout with exactly Product 1224 qty 1;
- prove item/subtotal/order total USD 1.00, shipping 0, tax 0 under accepted fixture semantics;
- prove PayPal method visible using normal Checkout only;
- no Place order / buyer login / payment.

Then seal:
```text
BUYER_ACCOUNT_SEPARATION=REQUIRED
SAME_PAYPAL_ACCOUNT_BUYER_AND_MERCHANT=FORBIDDEN
MAX_REAL_ORDERS=1
MAX_REAL_BUYER_APPROVALS=1
MAX_REAL_PAYMENTS=1
MAX_REAL_REFUNDS=1
EXPECTED_PAID_ORDER_STATUS=PROCESSING
EXPECTED_SIGNED_WEBHOOK_PROOF=DEFERRED_TO_REAL_CANARY
FULL_REFUND_GROSS_USD=1.00
NO_BLIND_REPLAY=SEALED
REAL_PAYMENT_AUTHORIZED=NO
REFUND_AUTHORIZED=NO
```

## Forbidden

- PPCP detailed-log value capture;
- broad option/env dump;
- Secret/token/nonce/session/hash output;
- global currency mutation;
- Product 223/unrelated product mutation;
- order/payment/capture/refund;
- webhook replay/simulation/resubscribe;
- PayPal settings mutation;
- Shared Infra mutation;
- Soft Launch.

Persist Evidence + Executor Handoff and fresh-readback GitHub.

Success:
`PASS_CANDIDATE_K7_R2R2_R1_SAFE_CURRENCY_PREFLIGHT_AND_CONDITIONAL_USD_CANARY_REBASE`

Or precise RETURN. Then STOP_AT_REVIEWER.
