# Reviewer Decision — K7 R2 RETURN / K7 R2R1 PayPal Live Connection + Webhook Owner Checkpoint

Date: 2026-09-28
Role: Reviewer / Architect / Gatekeeper

## Reviewed evidence

Accepted Executor persistence:
- Evidence commit: `f8d3799a7b08fd0ce29d2503b36d28dfaa9630ff`
- Handoff commit: `6b7f6398c38a4823c82ca0375c3a9348b780fa97`

Formal classification:

```text
K7_R2_PAYPAL_PRODUCTION_CANARY_PREFLIGHT=RETURN_PROVIDER_IDENTITY_OR_PERMISSION_UNRESOLVED
RETURN_CLASS=PRODUCTION_PROVIDER_ACCOUNT_AND_WEBHOOK_READINESS_BLOCKER
HELPER_FAILURE=NO
RUNTIME_REGRESSION=NO
PAYMENT_ACTION=0
```

## Accepted facts

```text
PPCP_ACTIVE=YES
PPCP_PLUGIN_VERSION=4.1.3
PPCP_CURRENT_ENVIRONMENT=SANDBOX
PPCP_SANDBOX_ENABLED=YES
PPCP_LIVE_ENABLED=NO
PAYPAL_LIVE=NO

CANARY_PRODUCT_ID=1224
CANARY_QUANTITY=1
CANARY_AMOUNT_JPY=500
PAYPAL_METHOD_PRESENT=YES

LIVE_MERCHANT_CONNECTION=UNPROVEN
LIVE_MERCHANT_BINDING=UNPROVEN
LIVE_PRODUCT_PERMISSION=UNPROVEN
LIVE_CREDENTIAL_PRESENCE_STATE=UNPROVEN_NO_SECRET_ACCESS

CURRENT_PPCP_WEBHOOK_PATH=/wp-json/paypal/v1/incoming
CURRENT_PPCP_WEBHOOK_ORIGIN=OLD_ORIGIN_NOT_ACCEPTABLE_FOR_PRODUCTION
PRODUCTION_WEBHOOK_PATH=UNRESOLVED
WEBHOOK_LIVE_CREATE_OR_UPDATE_BEHAVIOR=UNRESOLVED

ORDER_CREATION=0
REAL_PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
WEBHOOK_MUTATION=0
SECRET_VALUE_OR_HASH_ACCESS=0
SOFT_LAUNCH_AUTHORIZED=NO
```

This is a real production-account readiness blocker. A real-money Canary must not proceed.

## Reviewer-sealed technical facts

Based on the official WooCommerce PayPal Payments documentation:

1. Live onboarding requires connecting a PayPal account through the official onboarding flow and may require Owner PayPal login/consent.
2. The onboarding wizard automatically configures the required PayPal webhooks.
3. PPCP exposes webhook resubscription and simulation controls for repairing/testing webhook configuration.
4. The Canary product is Virtual=YES and Downloadable=NO. Under standard WooCommerce order semantics, a successfully paid order that is not composed exclusively of products that are both virtual and downloadable normally enters `processing`, not automatic `completed`.
5. PPCP supports full refunds from WooCommerce Admin using `Refund via PayPal`; a full refund is expected to update the WooCommerce order to `refunded`.
6. Public PayPal Japan terms state that, when those Japan merchant terms apply, refunding a commercial transaction does not return the original payment-receipt transaction fee. The exact Canary merchant jurisdiction remains unproven, so the project marker remains:
   `PAYPAL_FEE_RECOVERY_STATUS=UNKNOWN_REQUIRES_OWNER_AWARENESS`
   until the actual Live merchant identity/jurisdiction is sealed.

References:
- https://woocommerce.com/document/woocommerce-paypal-payments/account-setup-and-onboarding/
- https://woocommerce.com/document/woocommerce-paypal-payments/plugin-settings-guide/
- https://woocommerce.com/document/woocommerce-paypal-payments/paypal-payments-documentation-legacy/
- https://woocommerce.com/document/managing-orders/order-statuses/
- https://woocommerce.com/document/woocommerce-paypal-payments/managing-orders-and-refunds/
- https://www.paypal.com/jp/business/paypal-business-fees

## Next Gate

```text
CURRENT_GATE=K7_R2R1_PAYPAL_LIVE_CONNECTION_AND_WEBHOOK_RECOVERY
CURRENT_GATE_STATUS=AWAIT_OWNER_AUTHORIZATION
OWNER_ACTION=AUTHORIZE_LIVE_CONNECTION_AND_COMPLETE_PAYPAL_INTERACTIVE_LOGIN
```

This is **not** the real-payment authorization.

### Proposed Owner authorization marker

`AUTHORIZE_K7_R2R1_PAYPAL_LIVE_CONNECTION_AND_WEBHOOK_RECOVERY`

If the Owner gives that exact or clearly equivalent authorization, the following bounded actions become authorized:

1. Use the official WooCommerce PayPal Payments onboarding path to establish the intended **Live/Production** merchant connection.
2. Owner performs any PayPal login/OAuth/consent directly in the provider UI; credentials/2FA must never enter chat, GitHub, Evidence or logs.
3. After the Owner interaction, Executor performs read-only verification of:
   - Live merchant connection;
   - Production merchant binding;
   - product/permission readiness;
   - current environment;
   - current production webhook URL/status;
   - current Checkout PayPal method.
4. Expected production webhook target is:
   `https://minicraft.spikersun.com/wp-json/paypal/v1/incoming`
5. If the Live onboarding did not produce an exact healthy current-origin webhook, Executor may perform **at most one** official PPCP `Resubscribe` webhook action.
6. After exact current-origin webhook registration, Executor may perform **at most one** official PPCP webhook simulation/test if available, solely to validate receipt/ACK and without creating an order/payment/refund.
7. If Live connection or webhook state is ambiguous, stop and reconcile. No second onboarding, resubscribe or simulation without Reviewer classification.

## Mandatory post-connection seal

Before any real order/payment authorization can be requested, K7 R2R1 must prove:

```text
PPCP_CURRENT_ENVIRONMENT=LIVE
PAYPAL_LIVE=YES
LIVE_MERCHANT_CONNECTION=PASS
LIVE_MERCHANT_BINDING=PASS
LIVE_PRODUCT_PERMISSION=PASS_OR_EXPLICITLY_NOT_REQUIRED_FOR_BASIC_PAYPAL_CHECKOUT
LIVE_CREDENTIAL_PRESENCE_STATE=CONFIGURED_NO_SECRET_ACCESS
PRODUCTION_WEBHOOK_URL=https://minicraft.spikersun.com/wp-json/paypal/v1/incoming
PRODUCTION_WEBHOOK_STATUS=HEALTHY
WEBHOOK_RECEIPT_ACK_TEST=PASS_IF_SUPPORTED
PAYPAL_METHOD_PRESENT=YES

BUYER_ACCOUNT_SEPARATION=SEALED
SAME_ACCOUNT_ALLOWED=NO

EXPECTED_PAID_ORDER_STATUS=PROCESSING
EXPECTED_EMAIL_PATH=SEALED
REFUND_PATH=SEALED
CANARY_GROSS_REFUND_JPY=500
PAYPAL_FEE_RECOVERY_STATUS=KNOWN_OR_UNKNOWN_OWNER_AWARE

MAX_REAL_ORDERS=1
MAX_REAL_BUYER_APPROVALS=1
MAX_REAL_PAYMENTS=1
MAX_REAL_REFUNDS=1
NO_BLIND_REPLAY=SEALED
FUTURE_REAL_PAYMENT_OWNER_AUTHORIZATION_PACKAGE=SEALED
```

The exact merchant/account identifier may be retained only as the minimum non-secret correlation necessary; do not record merchant or buyer email, credentials, OAuth tokens, client secret, webhook secret, cookies or session data.

## Still forbidden in K7 R2R1

Even after Owner authorizes this Gate:

- no order creation;
- no buyer approval;
- no real payment;
- no Sandbox buyer payment;
- no auth/capture;
- no refund;
- no real transaction webhook replay;
- no Product 1224 mutation;
- no Product 223 mutation;
- no email resend;
- no DNS/Caddy/VPS mutation;
- no Soft Launch/advertising.

## Fail-closed

Return immediately if:
- Owner connects the wrong PayPal merchant account;
- Live identity cannot be correlated;
- required product permission is unavailable;
- webhook target remains the old origin after the single authorized recovery action;
- webhook simulation/ACK is ambiguous;
- any unexpected order/payment is created;
- any credential value is exposed.

No blind retry.

## Success

`PASS_CANDIDATE_K7_R2R1_PAYPAL_LIVE_CONNECTION_AND_WEBHOOK_RECOVERY`

Then stop at Reviewer. The next Gate would be the separate explicit authorization for exactly one JPY500 real payment and, only if payment correlation passes, exactly one full JPY500 refund.
