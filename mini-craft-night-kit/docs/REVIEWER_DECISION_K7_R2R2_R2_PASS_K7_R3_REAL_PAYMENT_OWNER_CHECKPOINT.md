# Reviewer Decision — K7 R2R2 R2 PASS / K7 R3 Real Payment Owner Checkpoint

Date: 2026-09-28
Role: Reviewer / Architect / Gatekeeper

## Reviewed Executor persistence

Accepted authoritative evidence:

- corrected Evidence commit: `c9946b8e0369fb864dc2c1db940a27b2dd2088fe`
- corrected Executor Handoff commit: `d48d9972f5465a4e162e039f312ba29a4cf07ba0`

The append-only correction changes only `SSH_NETWORK_INVOCATIONS` from 5 to 11. It does not alter the recorded business-state transaction count or accepted invariants.

## Formal Reviewer decision

```text
K7_R2R2_R2_BOUNDED_USD_STORE_MIGRATION_AND_CANARY_SEAL=PASS
WOOCOMMERCE_STORE_CURRENCY=USD
PRODUCT_223_TEST_PRICE_REMOVED=YES
PRODUCT_223_PURCHASABLE=NO
PRODUCT_223_STATUS_VISIBILITY=publish/VISIBLE_UNCHANGED
PRODUCT_1224_PRICE_USD=1.00
PRODUCT_1224_STATUS_VISIBILITY=publish/HIDDEN
CANARY_QUANTITY=1
CANARY_ORDER_TOTAL_USD=1.00
CANARY_SHIPPING_USD=0.00
CANARY_TAX_USD=0.00
PAYPAL_METHOD_PRESENT=YES
PAYPAL_LIVE_CONNECTED=CARRIED_FORWARD_ACCEPTED_PASS
PROJECT_DB_BACKUP_CREATED=YES
BUSINESS_STATE_COMMIT_COUNT=1
ORDER_CREATION=0
REAL_PAYMENT_ACTIONS=0
BUYER_APPROVAL_ACTIONS=0
CAPTURE_ACTIONS=0
REFUND_ACTIONS=0
WEBHOOK_ACTIONS=0
SECRET_VALUE_OR_HASH_ACCESS=0
SOFT_LAUNCH_AUTHORIZED=NO
```

The bounded non-payment preparation phase is complete.

## Next Gate — Owner-only real business action

```text
CURRENT_GATE=K7_R3_USD1_PRODUCTION_PAYMENT_CANARY_AND_CONDITIONAL_FULL_REFUND
CURRENT_GATE_STATUS=AWAIT_OWNER_REAL_PAYMENT_AUTHORIZATION
REAL_PAYMENT_CANARY_CURRENCY=USD
REAL_PAYMENT_CANARY_GROSS_USD=1.00
MAX_REAL_ORDERS=1
MAX_REAL_BUYER_APPROVALS=1
MAX_REAL_PAYMENTS=1
MAX_REAL_REFUNDS=1
REAL_PAYMENT_AUTHORIZED=NO
REFUND_AUTHORIZED=NO
SOFT_LAUNCH_AUTHORIZED=NO
OWNER_ACTION=EXPLICITLY_AUTHORIZE_REAL_USD1_CANARY
```

## Proposed Owner authorization marker

`AUTHORIZE_K7_R3_USD1_PRODUCTION_PAYMENT_CANARY_AND_CONDITIONAL_FULL_REFUND`

This authorization, if explicitly granted by the Owner, would authorize exactly:

1. create exactly one WooCommerce order from the already-sealed hidden Canary Product 1224, quantity 1, gross USD 1.00;
2. exactly one PayPal buyer approval and exactly one real payment attempt;
3. buyer account must be different from the connected merchant PayPal account;
4. immediately reconcile:
   - Provider payment state;
   - WooCommerce order/payment state;
   - real signed webhook receipt/effect;
   - expected paid order state `processing`;
   - transactional order-email path;
5. no blind retry if any payment outcome is ambiguous;
6. only after the real payment is positively correlated across Provider + WooCommerce and the order identity is sealed, perform exactly one full refund of gross USD 1.00 through the approved WooCommerce/PayPal refund path;
7. reconcile Provider refund state + WooCommerce refund state + webhook/state transition;
8. stop at Reviewer after Evidence/Handoff persistence and fresh GitHub read-back.

## Financial boundary

```text
CANARY_GROSS_CHARGE_USD=1.00
FULL_REFUND_GROSS_USD=1.00
PAYPAL_FEE_RECOVERY_STATUS=UNKNOWN_OWNER_AWARENESS_REQUIRED
```

A full gross refund of USD 1.00 does not imply that all Provider transaction fees, if any, will necessarily be returned. Do not infer fee treatment until the applicable Live merchant terms/transaction evidence establish it.

## No-blind-replay rule

If buyer approval or payment is submitted and the UI/network result becomes ambiguous:

- do not submit a second order;
- do not approve/pay again;
- first reconcile Provider state using the existing order/payment identifiers;
- classify as success / failure / pending / unknown;
- RETURN to Reviewer if the committed outcome cannot be proven.

## Still forbidden without explicit Owner authorization

- creating a real order;
- PayPal buyer login/approval;
- real payment;
- capture;
- refund;
- real transaction webhook replay;
- second payment attempt;
- Product/currency mutation;
- PayPal settings mutation;
- Soft Launch.

Soft Launch remains a separate later Owner authorization even if the Canary passes.
