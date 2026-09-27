# Reviewer Decision — G3B Interim RETURN / Payment Reconciliation Required

Date: 2026-09-28  
Reviewed execution: PR #51  
Gate: `G3B_PAYPAL_SANDBOX_PAID_ENTITLEMENT_REFUND`

## Result

`RETURN_G3B_PROVIDER_CAPTURE_CORRELATION_AND_REMAINDER_REQUIRED`

PR #51 is accepted and merged as durable **interim RETURN evidence**. G3B is not PASS.

## Accepted facts

- the accepted G3A Docker/MariaDB commerce/account baseline was recreated;
- official WooCommerce PayPal Payments 4.1.3 was installed and active;
- Sandbox merchant connection became healthy;
- Sandbox remained enabled and Live remained disabled;
- a temporary HTTPS Sandbox origin was active;
- the PayPal Sandbox checkout component rendered and checkout progressed;
- Owner reported completing one Sandbox Buyer payment;
- WooCommerce read-back showed synthetic order #30 as:
  - `processing`;
  - `paid=true`;
  - USD 39.99;
  - payment method `ppcp-gateway`;
- PPCP reported webhook receipt/delivery-host health;
- generation remained disabled;
- generation job/action counts remained 0;
- model calls remained 0;
- no Live PayPal, real customer data, production model call, VPS deployment or production-domain cutover occurred.

## Still unproven

- exact provider-side capture count;
- exact provider capture ↔ WooCommerce order correlation;
- callback/webhook event identity and exact correlation;
- paid + intake-incomplete entitlement check;
- paid + intake-complete exactly-one canonical deferred generation-ready job;
- entitlement re-evaluation idempotency;
- one official WooCommerce-initiated Sandbox refund;
- refund/provider correlation;
- refund revocation/cancellation of the deferred generation entitlement.

## Safety interpretation

Do **not** run another Sandbox payment or explicit capture merely because correlation evidence is incomplete.

The already-observed payment is now a reconciliation problem:

```text
existing Sandbox payment
→ read-only provider / WooCommerce reconciliation
→ exact-cardinality and amount/currency/order match
→ only then continue entitlement/idempotency/refund proof
```

If exact provider correlation cannot be established safely, RETURN. Do not create a second payment.

Historical Seller-auth checkpoints remain preserved in Evidence but are superseded as current state by the stronger post-payment read-back.

## Next Gate

Proceed to `G3BR1_SANDBOX_PAYMENT_RECONCILIATION_ENTITLEMENT_REFUND`.
