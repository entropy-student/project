# Reviewer Decision — K7 Readiness RETURN Accepted / K7R1 Canary Fixture + Resend Email Owner Checkpoint

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper

## Reviewed result

GATE=K7_PRODUCTION_CANARY_READINESS_SEAL
RESULT=RETURN_REVIEWER_K7_CHECKOUT_PPCP_AND_CANARY_TOTAL_RECONCILIATION_REQUIRED
EVIDENCE_COMMIT=69500c70f54a21e8fe1677d0943450e1b5692ff4
HANDOFF_COMMIT=bdfc27274fea86f128e39caf18855ffbf7eac239

Reviewer accepts the RETURN.

## Accepted blockers

### Product 223

Accepted current truth:
- simple;
- published/visible/purchasable;
- JPY 1;
- physical / shipping-required;
- stock-managed, qty 8;
- supplier/product truth remains unverified.

Decision:

PRODUCT_223_CANARY_CLASSIFICATION=NOT_SUITABLE_REQUIRE_SEPARATE_HIDDEN_CANARY_SKU

No real-money canary may use Product 223.

### Populated Checkout / exact total

Current public empty Checkout correctly redirects to Cart.

A fresh populated public Checkout was not observed, therefore:
- PayPal method visibility was not freshly proven;
- shipping/total was not sealed;
- JPY 500 remains only a proposed gross cap, not an accepted order total.

### Email

WooCommerce email notification switches are present, but delivery transport is unverified.

Accepted:
EMAIL_READINESS=BLOCKED

Project Record already selected Resend as initial transactional-email provider and support@minicraft.spikersun.com as the planned sender/support convention.

Reviewer direct Resend account read-only check on 2026-09-27 found:
RESEND_DOMAIN_COUNT=0

No Resend mutation was performed.

### PPCP

Accepted K6 G-R4 baseline remains:
PPCP_ACTIVE=YES
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_ENABLED=YES
PPCP_LIVE_ENABLED=NO

The K7 fresh read-only CLI REST probe failed only at PHP CLI memory limit. It made no Provider/payment call and is not evidence of PPCP regression.

## Reviewer proposed K7R1 fixture

Create one dedicated hidden canary product only after Owner authorization.

Proposed exact fixture:

CANARY_PRODUCT_TITLE=Mini Craft Payment Canary
CANARY_PRODUCT_PURPOSE=CONTROLLED_PAYMENT_AND_REFUND_VERIFICATION_ONLY
CANARY_PRODUCT_TYPE=simple
CANARY_PRODUCT_STATUS=publish
CANARY_CATALOG_VISIBILITY=hidden
CANARY_VIRTUAL=YES
CANARY_DOWNLOADABLE=NO
CANARY_TAX_STATUS=none
CANARY_PRICE_JPY=500
CANARY_SOLD_INDIVIDUALLY=YES
CANARY_MANAGE_STOCK=NO
CANARY_SHIPPING_REQUIRED=NO
CANARY_EXPECTED_ITEM_TOTAL_JPY=500
CANARY_EXPECTED_SHIPPING_JPY=0
CANARY_EXPECTED_TAX_JPY=0
CANARY_EXPECTED_ORDER_TOTAL_JPY=500

The product description must truthfully state that it is a controlled payment-verification item for a consenting canary buyer and will be fully refunded after validation. It must not represent a physical Mini Craft item or imply fulfillment.

The product must remain hidden from catalog/search and Soft Launch remains blocked.

## Reviewer proposed Resend foundation

Target sending domain:
minicraft.spikersun.com

Planned sender:
support@minicraft.spikersun.com

Resend:
- create exact sending domain only;
- sending enabled;
- receiving not required for this Gate;
- add only exact DNS verification records returned by Resend;
- no unrelated DNS mutation;
- verify exact domain;
- use a sending-only API key restricted to the exact verified domain.

API-key safety:
- do not use any tool path that requires displaying the secret in chat/evidence;
- Owner must generate the domain-scoped sending-only key interactively in the Resend dashboard when prompted and paste it directly into the WordPress plugin settings;
- the key must never enter chat, GitHub, logs or ordinary Evidence.

WordPress:
- install/activate the official Resend WordPress plugin;
- configure sender name/email;
- key may be stored in the protected WordPress database by the plugin;
- database/backups remain sensitive deployment artifacts;
- no extra provider credential may be emitted.

Email qualification:
- send exactly one explicit test email to the currently configured Owner-controlled WordPress admin recipient after setup;
- prove Resend accepted/delivered state and recipient arrival using metadata only;
- do not include sensitive content.

## Populated Checkout qualification

After the hidden Canary product exists:
- create browser/cart session only;
- quantity=1;
- no order creation;
- no final checkout submission;
- do not click PayPal final/continue action.

Require:
CANARY_ITEM_TOTAL_JPY=500
CANARY_SHIPPING_JPY=0
CANARY_TAX_JPY=0
CANARY_ORDER_TOTAL_JPY=500
PAYPAL_METHOD_PRESENT=YES
PUBLIC_POPULATED_CHECKOUT=PASS

If any total differs:
RETURN before any Live/payment action.

## Current Gate

CURRENT_GATE=K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_OWNER_CHECKPOINT
CURRENT_GATE_STATUS=AWAIT_OWNER
OWNER_ACTION=AUTHORIZE_OR_DECLINE_K7R1_FIXTURE_EMAIL_FOUNDATION

## Authorization marker

To authorize the bounded preparation transaction, Owner sends:

AUTHORIZE_K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION

This authorizes only:
1. create the exact hidden JPY 500 virtual Canary fixture above;
2. create/verify exact Resend sending domain minicraft.spikersun.com;
3. add only Resend-returned DNS verification records under the existing Cloudflare zone;
4. install/activate official Resend WordPress plugin;
5. Owner interactive creation/paste of one exact domain-scoped sending-only API key without exposing it;
6. one transactional-email delivery test to the configured Owner-controlled admin recipient;
7. populated Checkout/cart-session verification of the hidden Canary SKU.

Still forbidden:
- PayPal Live;
- PayPal login/merchant authorization;
- order creation;
- real/Sandbox buyer payment;
- authorization/capture/refund;
- webhook money-flow mutation;
- Product 223 mutation;
- Soft Launch/advertising;
- unrelated DNS/infrastructure/product mutation.

## Expected success

PASS_CANDIDATE_K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION

Required:
CANARY_PRODUCT=CREATED_EXACT_SPEC
CANARY_PRODUCT_HIDDEN=YES
CANARY_ORDER_TOTAL_JPY=500
CANARY_SHIPPING_JPY=0
CANARY_TAX_JPY=0
PUBLIC_POPULATED_CHECKOUT=PASS
PAYPAL_METHOD_PRESENT=YES
RESEND_DOMAIN=minicraft.spikersun.com
RESEND_DOMAIN_VERIFIED=YES
RESEND_SENDING=READY
WORDPRESS_RESEND_PLUGIN=ACTIVE
EMAIL_TEST=DELIVERED
EMAIL_READINESS=PASS
PAYPAL_LIVE=NO
ORDER_CREATION=0
REAL_PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
SOFT_LAUNCH_AUTHORIZED=NO
STOP_AT_REVIEWER=YES
