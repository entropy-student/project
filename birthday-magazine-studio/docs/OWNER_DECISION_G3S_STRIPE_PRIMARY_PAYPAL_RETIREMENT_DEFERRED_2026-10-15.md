# Owner Decision — Stripe as Target Primary, PayPal Retirement Deferred

> Date: 2026-10-15
> Provenance: OWNER_REPORTED
> Project: Birthday Magazine Studio
> Current frontend visual freeze: PASS; do not reopen.
> Existing commerce authority: WooCommerce

## Decision

```text
TARGET_PRIMARY_PAYMENT_PROVIDER=STRIPE
PAYPAL_RETIREMENT_INTENT=CONSIDERING_NOT_AUTHORIZED
PAYPAL_EXISTING_SANDBOX_EVIDENCE=RETAIN
PAYPAL_UNINSTALL_OR_DISABLE=NOT_AUTHORIZED
PAYPAL_LIVE_ENABLEMENT=HOLD
STRIPE_LIVE_ENABLEMENT=HOLD
STRIPE_REAL_MONEY_CANARY=NOT_AUTHORIZED
CURRENT_WOO_ORDER_SYSTEM=KEEP
FRONTEND_VISUAL_FREEZE=KEEP
CURRENT_GATE=G3S0_STRIPE_ACCOUNT_AND_GATEWAY_READINESS
```

## Why

The Owner wants to add Stripe payments to the Birthday Magazine purchase path and may eventually remove PayPal.

This approves Stripe as the **target payment provider**, NOT an immediate PayPal provider teardown, live activation, real-money transaction, KYC action, bank-link authorization, or production cutover.

The previous PayPal Sandbox/entitlement/refund evidence remains valid as historical, provider-specific proof. It is **not** proof that Stripe has passed the same provider-specific tests.

## Recommended integration

- Keep WooCommerce as canonical product/cart/checkout/order/payment-state authority.
- Prefer the official **WooCommerce Stripe Gateway** extension (`woocommerce-gateway-stripe`), not a new homegrown Stripe PaymentIntent/payment-status flow, not a second order system, and not WooPayments unless a later Reviewer comparison shows a clear requirement.
- Cards first; optional wallet/local methods only after account/region eligibility and relevant Woo extension settings are verified.
- Complete intake *before* checkout remains the product contract; generation requires exact server-submitted draft snapshot + verified paid Woo order.
- Stripe callbacks do not directly authorize generation unless server validation, unique order correlation, exact amount/currency and idempotent durable paid-entitlement processing are proven.
- WooCommerce-initiated refunds and refund-driven entitlement revocation must be re-proven for Stripe rather than inherited from PayPal.

## Account/eligibility condition

The Stripe account existence, country/region, legal merchant entity, verification status, receiving bank and ability to settle to that account are **UNKNOWN until authoritative readback/Owner confirmation**.

Stripe availability for a country is not authorization to fabricate a business address/entity or borrow a third-party identity.

A Wise or other virtual receiving account alone does not establish eligible Stripe merchant status and does not guarantee payout acceptance.

KYC, OAuth merchant consent, account activation and bank linking are Owner-only checkpoints; never request credentials or identity documents in chat/GitHub.

## Migration exit condition

PayPal remains preserved until:
1. Stripe merchant eligibility is confirmed for the intended real country/entity;
2. Stripe test-only Woo checkout, webhooks, paid status, duplicate/replay, refund and entitlement revocation independently PASS;
3. real collection/payout readiness is proven through appropriately separately authorized steps;
4. Owner explicitly approves disabling/removing PayPal after a separately reviewed migration/rollback plan.

Do not accidentally enable both live providers during a canary without an explicitly reviewed two-gateway coexistence plan.

## Source references checked 2026-10-15

- https://stripe.com/global
- https://support.stripe.com/questions/requirements-for-hong-kong-based-businesses
- https://woocommerce.com/products/stripe/
- https://woocommerce.com/document/stripe/setup-and-configuration/
- https://woocommerce.com/document/stripe/customer-experience/testing/
- https://woocommerce.com/document/stripe/setup-and-configuration/stripe-webhooks/
