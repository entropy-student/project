# Reviewer Decision — K7 R1 PASS / K7 R2 Production Canary Preflight

Date: 2026-09-28
Role: Reviewer / Architect / Gatekeeper
Governance: canonical VPS Project Governance latest + Production Provider Canary and Recovery Contract rev2

## Reviewed result

GATE=K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION
RESULT=PASS_CANDIDATE_K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION

Accepted Evidence:
- 6fd55bba67ea1998526d35d2042da073be149b06
- be23d4b2914d4449aa646e62630f60634328990e

Reviewer independently reviewed the Evidence/Handoff.

## Formal decision

K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION=PASS

Accepted final K7 R1 state:

```text
EMAIL_TEST_SEND_COUNT=1
RESEND_PROVIDER_STATUS=DELIVERED
OWNER_RECIPIENT_ARRIVAL=YES
EMAIL_TEST=DELIVERED
EMAIL_READINESS=PASS
BLIND_RESEND=NO

CANARY_PRODUCT=CREATED_EXACT_SPEC
CANARY_PRODUCT_ID=1224
CANARY_PRODUCT_STATUS=PUBLISHED
CANARY_PRODUCT_HIDDEN=YES
CANARY_PRODUCT_TYPE=SIMPLE
CANARY_PRODUCT_VIRTUAL=YES
CANARY_PRODUCT_DOWNLOADABLE=NO
CANARY_PRODUCT_PRICE=JPY_500
CANARY_PRODUCT_SOLD_INDIVIDUALLY=YES
CANARY_PRODUCT_MANAGE_STOCK=NO
PRODUCT_223_MUTATION=0

STORE_TAX_ENABLED=NO
CANARY_TAX_CONTROL=NOT_APPLICABLE_WHILE_GLOBAL_TAX_DISABLED

CANARY_ITEM_TOTAL_JPY=500
CANARY_SHIPPING_JPY=0
CANARY_TAX_JPY=0
CANARY_ORDER_TOTAL_JPY=500
PUBLIC_POPULATED_CHECKOUT=PASS
PAYPAL_METHOD_PRESENT=YES

ORDER_CREATION=0
REAL_PAYMENT_ACTIONS=0
SANDBOX_BUYER_PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
PAYPAL_LIVE=NO
SOFT_LAUNCH_AUTHORIZED=NO
```

## Why the next Gate is still read-only

Production Provider Canary and Recovery Contract rev2 requires the Provider identity/permission map to be frozen before the first real Provider action.

K7 R1 proved the local fixture, Checkout total, PayPal presentation and email delivery. It did not yet freshly freeze the production PayPal merchant/application/permission/webhook state.

Therefore no real-payment Owner authorization is requested yet.

## Current Gate

```text
CURRENT_GATE=K7_R2_PAYPAL_PRODUCTION_CANARY_PREFLIGHT
CURRENT_GATE_STATUS=AUTHORIZED_READONLY_AWAIT_EXECUTOR
OWNER_ACTION=NONE
```

This Gate is read-only/design-only.

## K7 R2 objective

Freeze the exact Production Canary contract before any Live enablement or buyer action.

### A. Fresh PPCP current-state readback

Using the authenticated WordPress Admin session, determine without changing settings:

- PPCP plugin active/version;
- merchant connection state;
- current environment Sandbox/Live;
- whether a distinct Live merchant connection already exists;
- whether switching to Live requires Owner interactive PayPal login/OAuth;
- whether Live connection creates/updates webhooks automatically;
- whether any Live credentials are currently present/configured without reading values;
- PayPal method remains available for the Canary Checkout.

Require:

```text
PPCP_ACTIVE=YES
PPCP_CURRENT_ENVIRONMENT=SANDBOX
PAYPAL_LIVE=NO
```

Any contradictory fresh state -> RETURN.

### B. Freeze non-secret Provider identity map

Before any real Provider call, establish non-secret identity mapping sufficient for this provider:

- Provider=PayPal
- merchant/business account identity: stable non-secret identifier or safely redacted account label/presence
- application/connection identity: non-secret connection/client/app identifier where exposed safely
- environment: production target, currently sandbox
- product/contract permission required for PayPal Checkout
- merchant binding/correlation status
- signing/verification mode used by PPCP
- callback/webhook route
- webhook acknowledgement/processing model
- interaction mode: PayPal Checkout/button approval
- Canary amount/currency: JPY500
- Canary fixture: WooCommerce product 1224
- fulfillment type: virtual controlled verification item; no shipment

Do not expose account email, credentials, client secret, tokens or webhook secret.

If identity/permission cannot be proven safely:
RETURN_PROVIDER_IDENTITY_OR_PERMISSION_UNRESOLVED

### C. Freeze exact Live enablement path

Determine exact future sequence only. Do not perform it.

Required:
- WordPress admin path/control used to leave Sandbox;
- Owner interactive PayPal login/OAuth requirement;
- whether a new/different Live merchant connection is needed;
- observable success markers after Live connection;
- exact post-connect readback before any buyer action;
- exact rollback/disconnect safe state if Live connection fails before payment.

Return:
PAYPAL_LIVE_ENABLEMENT_PATH=SEALED
OWNER_INTERACTIVE_PAYPAL_ACTION_REQUIRED=YES|NO

### D. Buyer separation

Seal:
- merchant account and buyer account must be different;
- same-account self-payment forbidden;
- do not persist buyer identity in GitHub/Evidence.

```text
BUYER_ACCOUNT_SEPARATION=SEALED
SAME_ACCOUNT_ALLOWED=NO
```

### E. Expected order/payment semantics

Freshly determine expected WooCommerce/PPCP states for product 1224:

- local order state immediately after order creation / before provider approval;
- provider state after successful approval/capture;
- expected WooCommerce paid/order status;
- whether stock effect is none;
- expected transactional email(s);
- fulfillment state for this virtual controlled canary;
- webhook/callback contribution to local state.

Return:
EXPECTED_ORDER_STATE=SEALED

Do not create an order.

### F. Refund path

Design but do not execute:
- exact full-refund amount JPY500;
- preferred initiation path that validates Provider + WooCommerce together;
- expected PayPal refund state;
- expected WooCommerce refund/order state;
- expected email effect;
- no stock effect;
- idempotency/no duplicate refund rule.

Also determine from the actual merchant/account terms, if safely observable, whether processing fees are refundable. If not safely observable, mark the fee cost as UNKNOWN_REQUIRES_OWNER_AWARENESS rather than guessing.

Return:
REFUND_PATH=SEALED
CANARY_GROSS_REFUND_JPY=500
PAYPAL_FEE_RECOVERY_STATUS=

### G. No-blind-replay contract

Seal:

```text
MAX_REAL_ORDERS=1
MAX_REAL_BUYER_APPROVALS=1
MAX_REAL_PAYMENTS=1
MAX_REAL_REFUNDS=1
AMBIGUOUS_PAYMENT_ACTION=STOP_AND_RECONCILE
SECOND_PAYMENT_WITHOUT_RECONCILIATION=FORBIDDEN
REAL_PAYMENT_RETRY_AFTER_PROVIDER_SUCCESS=NO
```

If browser/redirect/callback is ambiguous:
- query provider read-only;
- read local order/payment;
- inspect webhook/callback evidence;
- correlate exact amount/currency/order;
- never create/pay a second order until Reviewer classifies state.

### H. Exact future Owner authorization package

Prepare but do not request/execute inside Executor:

A future Owner marker should explicitly authorize only:
1. exact Live merchant connection transition if required;
2. exactly one Product 1224 / qty1 / JPY500 real order;
3. exactly one buyer approval/payment from a buyer account distinct from merchant;
4. automatic read-only reconciliation after buyer action;
5. exactly one full JPY500 refund only after successful payment is proven and local/provider correlation passes;
6. automatic post-refund reconciliation;
7. no Soft Launch.

The future marker must explicitly mention both payment and refund; refund is not implied by payment authorization.

## Forbidden in K7 R2

No:
- PayPal Live enablement;
- PayPal login/OAuth;
- order creation;
- real or Sandbox buyer payment;
- payment authorization/capture;
- refund;
- webhook mutation/replay;
- Canary product mutation;
- email resend;
- DNS/VPS/Caddy mutation;
- Secret output;
- Soft Launch/advertising.

## Success

PASS_CANDIDATE_K7_R2_PAYPAL_PRODUCTION_CANARY_PREFLIGHT

Return at least:

```text
PROVIDER=PAYPAL
PPCP_ACTIVE=YES
PPCP_CURRENT_ENVIRONMENT=SANDBOX
PAYPAL_LIVE=NO

PROVIDER_IDENTITY_MAP=SEALED
PRODUCT_PERMISSION_STATUS=
MERCHANT_BINDING_STATUS=
CALLBACK_WEBHOOK_PATH=SEALED
WEBHOOK_VERIFICATION_MODEL=SEALED
INTERACTION_MODE=PAYPAL_CHECKOUT

CANARY_PRODUCT_ID=1224
CANARY_QUANTITY=1
CANARY_AMOUNT_JPY=500
CANARY_CURRENCY=JPY

PAYPAL_LIVE_ENABLEMENT_PATH=SEALED
OWNER_INTERACTIVE_PAYPAL_ACTION_REQUIRED=YES|NO

BUYER_ACCOUNT_SEPARATION=SEALED
SAME_ACCOUNT_ALLOWED=NO

EXPECTED_ORDER_STATE=SEALED
EXPECTED_EMAIL_PATH=SEALED
REFUND_PATH=SEALED
CANARY_GROSS_REFUND_JPY=500
PAYPAL_FEE_RECOVERY_STATUS=

MAX_REAL_ORDERS=1
MAX_REAL_BUYER_APPROVALS=1
MAX_REAL_PAYMENTS=1
MAX_REAL_REFUNDS=1
AMBIGUOUS_PAYMENT_ACTION=STOP_AND_RECONCILE
SECOND_PAYMENT_WITHOUT_RECONCILIATION=FORBIDDEN
REAL_PAYMENT_RETRY_AFTER_PROVIDER_SUCCESS=NO

FUTURE_OWNER_AUTHORIZATION_PACKAGE=SEALED
ORDER_CREATION=0
REAL_PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
SOFT_LAUNCH_AUTHORIZED=NO
STOP_AT_REVIEWER=YES
```
