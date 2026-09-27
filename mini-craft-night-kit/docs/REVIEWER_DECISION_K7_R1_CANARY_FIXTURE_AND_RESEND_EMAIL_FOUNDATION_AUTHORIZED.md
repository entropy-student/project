# Reviewer Decision — K7 R1 Canary Fixture + Resend Email Foundation Authorized

Date: 2026-09-27
Role: Reviewer / Architect / Gatekeeper

## Owner authorization

Owner approved the previously presented bounded K7 R1 preparation scope.

Reviewer normalizes the approval as:

AUTHORIZE_K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION

## Current Gate

CURRENT_GATE=K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION
CURRENT_GATE_STATUS=AUTHORIZED_AWAIT_EXECUTOR
OWNER_ACTION=NONE

## Authorized scope

This Gate authorizes only:

1. Create one dedicated controlled canary product:
   - title: Mini Craft Payment Canary
   - type: simple
   - status: publish
   - catalog visibility: hidden
   - virtual: yes
   - downloadable: no
   - tax status: none
   - price: JPY 500
   - sold individually: yes
   - manage stock: no
   - shipping required: no
   - truthful controlled-payment/full-refund verification description
   - do not modify Product 223

2. Configure Resend transactional-email foundation:
   - exact sending domain: minicraft.spikersun.com
   - sending enabled
   - receiving not required
   - add only exact DNS records returned by Resend for verification
   - verify the exact domain
   - install and activate the official Resend WordPress plugin
   - sender convention: support@minicraft.spikersun.com

3. Resend API key handling:
   - one sending-only key
   - restricted to the exact verified domain
   - key value must never enter chat/GitHub/Evidence/logs
   - Owner creates it interactively in Resend when prompted
   - Owner pastes it directly into WordPress plugin settings
   - Executor must stop at the Owner checkpoint if the secret cannot be safely entered interactively

4. Email qualification:
   - after setup, send exactly one non-sensitive test email to the currently configured Owner-controlled WordPress admin recipient
   - prove Resend accepted/delivered state and recipient arrival via metadata only

5. Populated Checkout qualification:
   - create only browser/cart/session state for the hidden Canary SKU
   - quantity=1
   - expected item total JPY 500
   - expected shipping JPY 0
   - expected tax JPY 0
   - expected order total JPY 500
   - PayPal method visible
   - no order submission
   - no final PayPal/Place Order action

## Existing accepted facts

K6_VPS_DEPLOYMENT=PASS
PUBLIC_SANDBOX_INGRESS=ACTIVE
PAYPAL_LIVE=NO
PPCP_SANDBOX_ENABLED=YES

Product 223:
PRODUCT_223_CANARY_CLASSIFICATION=NOT_SUITABLE_REQUIRE_SEPARATE_HIDDEN_CANARY_SKU

Email:
EMAIL_READINESS=BLOCKED
RESEND_DOMAIN_COUNT=0 at Reviewer read-only check

## DNS safety

Resend DNS mutation is limited to:
- records returned by Resend for exact domain minicraft.spikersun.com;
- no deletion/modification of the existing Mini Craft A record;
- no unrelated Cloudflare DNS changes.

Before saving each DNS record:
- verify zone=spikersun.com;
- verify record belongs to the exact Resend verification set;
- verify it does not replace or conflict with the current Mini Craft A record.

No blind retry after ambiguous save.

## Product safety

The canary product must not:
- appear in Shop/category/search/catalog listings;
- represent a physical product;
- imply shipment/fulfillment;
- alter Product 223;
- alter existing inventory.

The product page/description must truthfully identify it as a controlled payment-verification item intended for one consenting canary buyer and full refund after validation.

## Email Secret safety

No API key value, value hash, OAuth token, credential, mailbox secret or customer address may be written to:
- GitHub;
- ordinary Evidence;
- chat;
- logs.

Evidence may record only:
- key presence/configured=true;
- domain restriction confirmed;
- sending-only permission confirmed.

## Hard forbidden

Still forbidden:
- PayPal Live enablement;
- PayPal login/merchant authorization;
- order creation;
- real payment;
- Sandbox buyer payment;
- authorization/capture/refund;
- webhook money-flow mutation;
- Product 223 mutation;
- Soft Launch/advertising;
- unrelated DNS/VPS/Shared Infra mutation.

## Success

PASS_CANDIDATE_K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION

Required:
OWNER_AUTHORIZATION=AUTHORIZE_K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION
CANARY_PRODUCT=CREATED_EXACT_SPEC
CANARY_PRODUCT_ID=
CANARY_PRODUCT_HIDDEN=YES
CANARY_ITEM_TOTAL_JPY=500
CANARY_SHIPPING_JPY=0
CANARY_TAX_JPY=0
CANARY_ORDER_TOTAL_JPY=500
PUBLIC_POPULATED_CHECKOUT=PASS
PAYPAL_METHOD_PRESENT=YES

RESEND_DOMAIN=minicraft.spikersun.com
RESEND_DOMAIN_VERIFIED=YES
RESEND_SENDING=READY
WORDPRESS_RESEND_PLUGIN=ACTIVE
RESEND_KEY_CONFIGURED=YES_NO_VALUE_OUTPUT
RESEND_KEY_PERMISSION=SENDING_ONLY
RESEND_KEY_DOMAIN_SCOPE=minicraft.spikersun.com
EMAIL_TEST=DELIVERED
EMAIL_READINESS=PASS

PAYPAL_LIVE=NO
ORDER_CREATION=0
REAL_PAYMENT_ACTIONS=0
REFUND_ACTIONS=0
SOFT_LAUNCH_AUTHORIZED=NO
STOP_AT_REVIEWER=YES

## Owner interaction checkpoint

If the only remaining action is Resend API-key creation/paste, return:

RETURN_OWNER_RESEND_API_KEY_INTERACTIVE_ENTRY_REQUIRED

with:
- exact UI location to create a sending-only domain-scoped key;
- exact WordPress plugin field where Owner must paste it;
- no secret value in the return.

After Owner confirms direct entry, continue the same Gate without requiring a new authorization.
