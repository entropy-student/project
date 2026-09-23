# Reviewer Decision — K5R2 Checkout Action + Deployment Version Reconciliation

Date: 2026-09-23
Status: AUTHORIZED
Parent return: K5_RELEASE_CANDIDATE_QA_RESUME
Executor commit: 2f8e33022ea8e82b310b3bac44846dc5dce6de5a

## Reviewer finding

The K5 return is valid, but scope should stay narrow.

Two technical questions must be resolved before Release Candidate acceptance:

1. Checkout final action:
   K4 previously proved the native WooCommerce Place order action rendered when the local no-payment test gateway was selected.
   K5 currently observed PayPal Sandbox as the populated Checkout payment method but did not observe a final action.
   We must determine whether this is:
   - WooCommerce core checkout regression;
   - gateway availability/state difference;
   - PPCP smart-button/SDK rendering issue;
   - invalid/stale checkout/session state;
   - browser-observation limitation.

2. Deployment WordPress version:
   running container image tag is wordpress:6.8.2-php8.3-apache while the persistent WordPress installation reports core 7.1.1.
   This is explainable locally because the persistent core volume contains the upgraded installation, but production deployment must not recreate a 6.8.2 core against a 7.1.1 database by accident.

## Gate

GATE=K5R2_CHECKOUT_ACTION_VERSION_RECONCILIATION

## A. Checkout diagnostic — no order/payment

Use a fresh anonymous session.

Add Product 223 to cart and open populated Checkout with a valid US address.

Do NOT click any final action.

### A1. Available gateway inventory

Read current WooCommerce available gateways for the populated US checkout.

Return only non-sensitive gateway IDs/titles/status:
AVAILABLE_GATEWAYS=

Specifically determine whether the existing local test-only no-payment/COD gateway is still enabled and eligible.

Do not output credentials/settings secrets.

### A2. Core checkout action isolation

If the local test-only no-payment gateway is available:
- select it through the real checkout UI/state;
- verify whether native WooCommerce Place order renders;
- do not click it.

Return:
LOCAL_TEST_GATEWAY_AVAILABLE=
LOCAL_TEST_PLACE_ORDER_VISIBLE=

Interpretation:
- if YES, WooCommerce checkout core final-action path is healthy;
- then any missing PayPal action is PPCP/browser/provider-specific, not a core checkout blocker.

If local test gateway is unexpectedly unavailable, diagnose why read-only first. Do not broadly reconfigure payment settings without Reviewer return unless the cause is a reversible stale session/cache state.

### A3. PayPal rendering isolation

With PayPal selected, inspect without exposing secrets:
- PPCP final-action container present/absent;
- PayPal SDK/script requested/loaded/error state if observable;
- PayPal iframe/button container present/absent;
- checkout validation notices;
- shipping method/address eligibility;
- terms checkbox requirement/state if applicable;
- relevant DOM element visibility/computed display if available.

Return:
PPCP_ACTION_CONTAINER=
PPCP_SDK_LOAD_STATE=
PPCP_IFRAME_OR_BUTTON=
CHECKOUT_VALIDATION_NOTICES=
PAYPAL_FINAL_ACTION_VISIBLE=

Do not reproduce Client ID, Secret, tokens, cookies, order keys or raw provider payloads.

### A4. Decision rule

If LOCAL_TEST_PLACE_ORDER_VISIBLE=YES and PayPal button remains missing only in localhost/browser context:
- CHECKOUT_CORE_STATUS=PASS
- treat PayPal production action verification as BLOCKS_SOFT_LAUNCH / PRODUCTION_CANARY, not BLOCKS_DEPLOYMENT;
- retain historical K3 Sandbox payment/capture/webhook evidence as proof that payment integration itself previously completed end-to-end;
- do not change PPCP configuration merely to make localhost render.

If native Place order is also absent:
RETURN_REVIEWER_CHECKOUT_CORE_ACTION_MISSING

If a concrete reversible local PPCP rendering defect is identified that can be fixed without credentials/order/payment and without changing accepted architecture, return the diagnosis first unless the fix is a cache/session refresh only.

## B. WordPress deployment-version reconciliation

Do not restart or mutate the current runtime.

Confirm whether an official/available production image/tag compatible with actual core 7.1.1 and PHP 8.3 Apache exists using a non-mutating manifest/registry check where possible.

Return:
CURRENT_WORDPRESS_IMAGE_TAG=wordpress:6.8.2-php8.3-apache
CURRENT_WORDPRESS_CORE_VERSION=7.1.1
TARGET_PRODUCTION_WORDPRESS_IMAGE=

If exact 7.1.1/php8.3-apache tag is available, record it in the deployment manifest.

If exact tag cannot be verified:
- do not guess;
- set TARGET_PRODUCTION_WORDPRESS_IMAGE=UNRESOLVED;
- RETURN_REVIEWER_PRODUCTION_IMAGE_UNRESOLVED.

Do not pull/restart the active local container merely for this check unless unavoidable; a manifest check is preferred.

## C. Existing K5 evidence acceptance

Do not repeat:
- admin CRUD/media QA;
- Orders admin QA;
- Product Gallery QA;
- Contact fields QA;
- full backup generation;
- K4 visual review.

Existing K5 evidence for those remains valid.

Exact 1440/390 recapture is not required in this Gate because no customer-facing layout mutation occurred after accepted K4 visual evidence. If this Gate changes customer-facing layout, stop and return.

## D. Deployment manifest update

If target production WordPress image is resolved, update the local deployment manifest only.

Keep:
- target domain minicraft.spikersun.com
- database/wp-content/config backup hashes
- local test product warnings
- rollback/canary plan

GitHub evidence may record image/tag and secret names only, not secret values.

## E. Release Candidate acceptance criteria

Candidate can proceed toward K5 PASS when:
- CHECKOUT_CORE_STATUS=PASS
- TARGET_PRODUCTION_WORDPRESS_IMAGE is resolved
- no new deployment blocker is found
- existing backups/hashes remain valid
- no site/commerce baseline mutation occurred

PayPal final action on the public HTTPS production origin may remain a Production Canary check if core checkout is healthy and historical Sandbox payment evidence remains intact.

## Return

GATE=K5R2_CHECKOUT_ACTION_VERSION_RECONCILIATION
RESULT=<PASS_CANDIDATE_K5R2_CHECKOUT_ACTION_VERSION_RECONCILIATION | RETURN_REVIEWER_*>
SUMMARY=
AVAILABLE_GATEWAYS=
LOCAL_TEST_GATEWAY_AVAILABLE=
LOCAL_TEST_PLACE_ORDER_VISIBLE=
CHECKOUT_CORE_STATUS=
PPCP_ACTION_CONTAINER=
PPCP_SDK_LOAD_STATE=
PPCP_IFRAME_OR_BUTTON=
CHECKOUT_VALIDATION_NOTICES=
PAYPAL_FINAL_ACTION_VISIBLE=
PAYPAL_LOCALHOST_CLASSIFICATION=
CURRENT_WORDPRESS_IMAGE_TAG=
CURRENT_WORDPRESS_CORE_VERSION=
TARGET_PRODUCTION_WORDPRESS_IMAGE=
PRODUCTION_IMAGE_VERIFIED=
DEPLOYMENT_MANIFEST_UPDATED=
BLOCKS_DEPLOYMENT=
BLOCKS_PUBLIC_SALES=
BLOCKS_SOFT_LAUNCH=
SITE_MUTATION=
NEW_ORDER_ACTIONS=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
VPS_WRITES=0
WORKSPACE_TEMP_CLEANUP=
ROOT_TRANSIENTS_CREATED=
ROOT_TRANSIENTS_REMAINING=
LOCAL_HELPERS_CLEANED=
BROWSER_PROFILES_CLEANED=
EVIDENCE=
COMMIT=
OWNER_ACTION=NONE
NEXT=STOP_AT_REVIEWER

Do not deploy VPS.
Do not enable Live PayPal.
