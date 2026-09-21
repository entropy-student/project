# Reviewer Decision — K3 PayPal Sandbox

Date: 2026-09-21
Status: APPROVED TO EXECUTE

## Gate

`K3_PAYPAL_SANDBOX`

## Goal

Validate the Mini Craft MVP payment path with the official WooCommerce PayPal Payments plugin in PayPal Sandbox only.

Target flow:

```text
WooCommerce order
→ PayPal Sandbox checkout
→ sandbox payment approval/capture
→ WooCommerce paid / processing state
→ provider callback / webhook behavior
→ WooCommerce refund
→ PayPal Sandbox refund state
```

## Architecture lock

Use:

```text
WooCommerce
→ official WooCommerce PayPal Payments
→ PayPal Sandbox
```

Do NOT:

- hand-code the PayPal API;
- add Dujiao as a second order system;
- route through Shared Payment Layer in this Gate;
- configure Live/Production credentials;
- execute a real payment.

## Preflight

Before changing payment configuration:

- confirm current Studio target and K2 baseline;
- create a project-local rollback backup;
- record current WooCommerce currency/product/test-shipping values;
- verify no real PayPal/live credentials are already enabled;
- verify plugin source is the official WooCommerce PayPal Payments plugin.

## Test-only commerce values

K2 values are not production truth.

For K3 Sandbox, Executor may use clearly labeled test-only values required for PayPal Sandbox checkout.

Preferred Sandbox baseline:

- currency: USD for the US-market Sandbox path, test-only;
- low test amount such as USD 1.00;
- local/test shipping only;
- no production tax/shipping/returns promise.

Do not present these as final business values.

## Plugin

Install/activate only the official WooCommerce PayPal Payments plugin if not already installed.

Record:

- exact plugin name/version;
- source;
- activation state;
- whether any additional plugin was required.

No extra payment plugin may be added without Reviewer approval.

## Owner checkpoint

The Executor should proceed autonomously until PayPal account authorization is actually required.

Owner intervention is required for:

- PayPal login;
- selecting/authorizing a PayPal Sandbox account;
- OAuth/account consent;
- KYC/identity requests;
- viewing or entering any Secret that cannot be handled without Owner authorization;
- any action that would enable Live/Production mode.

When such a step is reached, stop with:

`RETURN_OWNER_PAYPAL_SANDBOX_AUTH_REQUIRED`

and state only the exact UI action the Owner must perform. Do not ask the Owner to paste PayPal passwords, private keys, client secrets, cookies, or tokens into chat/GitHub.

After Owner authorization, Executor may resume the same K3 Gate.

## Sandbox payment validation

After Sandbox is connected, verify at minimum:

- PayPal appears as a checkout payment option;
- one sandbox order can be approved and captured;
- no real money moves;
- WooCommerce order amount/currency/order number correlate with the PayPal Sandbox transaction;
- successful payment transitions WooCommerce to the correct paid/processing state for a physical product;
- payment success does NOT mark the physical product as shipped/completed.

## Webhook / callback validation

Verify provider-to-WooCommerce asynchronous state propagation where the official plugin supports it.

Important local-runtime rule:

If PayPal Sandbox cannot reach the localhost Studio callback/webhook endpoint, do NOT improvise a public tunnel, VPS route, production domain, or Cloudflare change.

Stop with:

`RETURN_K3_PUBLIC_CALLBACK_REQUIRED`

and provide evidence of the exact blocked callback/webhook requirement. Reviewer will decide whether to authorize a bounded local-preview/tunnel subgate.

## Refund validation

If Sandbox callback/payment capture is working, perform one test refund from WooCommerce using the official integration.

Verify:

- unique WooCommerce refund record;
- provider Sandbox refund result;
- order state / notes reflect the refund;
- no duplicate refund;
- amount does not exceed captured amount.

Use test-only amount(s).

## Security

Never write to GitHub:

- PayPal password;
- Client Secret;
- access token;
- refresh token;
- OAuth code;
- cookie/session value;
- webhook signing secret;
- full transaction-sensitive payloads containing secrets.

Evidence may record redacted transaction IDs/order IDs only where useful.

## K2 carry-forward

Studio SQLite currently uses local-only `woocommerce_hold_stock_minutes=0` due to stock-reservation compatibility.

K3 must not silently convert this workaround into production policy.

Do not attempt broad database/runtime migration in K3.

## Required evidence

Executor must update:

- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

PASS candidate requires:

```text
PASS_CANDIDATE_K3_PAYPAL_SANDBOX
OFFICIAL_WOOCOMMERCE_PAYPAL_PAYMENTS=PASS
PAYPAL_MODE=SANDBOX
PAYPAL_LIVE_ENABLED=NO
SANDBOX_ACCOUNT_CONNECTED=PASS
PAYPAL_CHECKOUT_VISIBLE=PASS
SANDBOX_PAYMENT_APPROVED=PASS
SANDBOX_CAPTURE=PASS
ORDER_PROVIDER_CORRELATION=PASS
WOO_ORDER_PAID_STATE=PASS
PHYSICAL_FULFILLMENT_NOT_AUTO_COMPLETED=PASS
WEBHOOK_OR_CALLBACK=PASS
SANDBOX_REFUND=PASS
REFUND_IDEMPOTENCY_SMOKE=PASS
GUTENBERG_REGRESSION=PASS
K1B_UI_REGRESSION=PASS
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
PRODUCTION_DOMAIN_WRITES=ZERO
SECRET_EXPOSURE=NO
STOP_AT_REVIEWER=YES
```

## Valid RETURN outcomes

Use RETURN instead of improvising when:

- Owner PayPal authorization is required;
- PayPal Sandbox account is unavailable/ineligible;
- callback/webhook requires a public URL not currently authorized;
- official plugin requires unsupported runtime capability;
- Studio SQLite creates a payment-critical incompatibility;
- any step would require Live/Production enablement;
- any secret would need to be exposed in GitHub/chat.

## Out of scope

- Live PayPal;
- production canary;
- real customer order;
- real funds;
- VPS deployment;
- production domain;
- final shipping/tax/returns policy;
- K4 conversion/trust work;
- K5 final-image/RC work.

Stop at Reviewer when PASS_CANDIDATE or a defined RETURN condition is reached.