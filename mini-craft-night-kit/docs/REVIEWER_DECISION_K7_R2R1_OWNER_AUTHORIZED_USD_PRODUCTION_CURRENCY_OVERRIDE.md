# Reviewer Decision — K7 R2R1 Owner Authorized / USD Production Currency Override

Date: 2026-09-28
Role: Reviewer / Architect / Gatekeeper

## Owner instruction

Owner explicitly changed the intended final market / Production transaction currency to USD and authorized continuation of the current PayPal Live connection + webhook recovery Gate.

Normalized Owner authorization:

`AUTHORIZE_K7_R2R1_PAYPAL_LIVE_CONNECTION_AND_WEBHOOK_RECOVERY`

Production currency override:

`OWNER_PRODUCTION_CURRENCY=USD`

## Currency effect

The previously accepted JPY500 Canary fixture and checkout evidence remain valid as historical K7 R1 proof of:
- hidden Canary fixture mechanics;
- zero shipping;
- zero tax under current store-tax-disabled state;
- populated Checkout;
- PayPal method presence;
- no order/payment action.

However, it is **superseded for the real Production Canary**.

```text
HISTORICAL_CANARY_FIXTURE_CURRENCY=JPY
HISTORICAL_CANARY_FIXTURE_AMOUNT=500
HISTORICAL_CANARY_EVIDENCE_RETAINED=YES

PRODUCTION_TRANSACTION_CURRENCY=USD
REAL_PAYMENT_CANARY_CURRENCY=USD
REAL_PAYMENT_CANARY_AMOUNT_USD=UNSEALED
JPY500_REAL_PAYMENT_AUTHORIZATION=NO
```

No USD amount is invented because the Owner changed currency but did not specify an exact dollar amount.

Before any real payment Gate, Reviewer/Executor must rebase the Canary to an exact USD amount and revalidate populated Checkout in USD.

## Current Gate authorization

```text
CURRENT_GATE=K7_R2R1_PAYPAL_LIVE_CONNECTION_AND_WEBHOOK_RECOVERY
CURRENT_GATE_STATUS=OWNER_AUTHORIZED
OWNER_ACTION=COMPLETE_PAYPAL_INTERACTIVE_LOGIN_WHEN_PROMPTED
```

Authorized scope:
1. official WooCommerce PayPal Payments Live onboarding;
2. Owner performs PayPal login/OAuth/consent directly in provider UI;
3. fresh Live merchant/binding/product-permission readback;
4. verify production webhook target:
   `https://minicraft.spikersun.com/wp-json/paypal/v1/incoming`
5. if needed, at most one official PPCP webhook Resubscribe;
6. if supported, at most one official webhook simulation/test;
7. seal non-secret Production identity and webhook readiness;
8. no order/payment/refund.

## USD rebase requirement before real payment

After K7 R2R1 Live identity/webhook PASS, the next preparation Gate must:

- inspect the current WooCommerce store currency safely;
- change the production/store transaction currency to USD only under this Owner directive;
- choose/seal an exact USD Canary amount before payment;
- re-read Product 1224 price/currency;
- ensure no unintended Product 223/business product pricing mutation;
- revalidate the hidden Canary Checkout:
  - currency USD
  - exact item total
  - shipping 0
  - tax 0 unless business policy changes
  - exact order total
  - PayPal visible
- stop before order/payment;
- obtain separate Owner authorization for exactly one real USD payment and exactly one full refund.

The exact USD amount is intentionally unresolved until that Gate; do not guess.

## Still forbidden

Even with this authorization:
- no order creation;
- no buyer approval;
- no real payment;
- no Sandbox buyer payment;
- no auth/capture;
- no refund;
- no Product 1224 price/currency mutation in K7 R2R1;
- no Product 223 mutation;
- no email resend;
- no DNS/Caddy/VPS mutation;
- no Soft Launch/advertising;
- no Secret output.

## Success for current Gate

`PASS_CANDIDATE_K7_R2R1_PAYPAL_LIVE_CONNECTION_AND_WEBHOOK_RECOVERY`

Then stop at Reviewer.
