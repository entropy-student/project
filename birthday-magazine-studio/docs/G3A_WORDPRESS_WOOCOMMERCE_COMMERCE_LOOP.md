# G3A — WordPress + WooCommerce Commerce / Account Loop

> Reviewer execution contract  
> Status: CURRENT / READY_FOR_EXECUTION  
> Prerequisites: G2A1 PASS, G2A2 PASS, G2B content/rendering PASS via G2BR3  
> Scope: local/test commerce + authenticated order workspace only  
> Runtime strategy: **Docker Compose + WordPress + MariaDB**, informed by accepted Mini Craft lessons

## Why this runtime is fixed for G3A

Mini Craft proved that WordPress Studio / SQLite can introduce WooCommerce/runtime-specific behavior that is not representative of the intended production stack, including a local-only stock-hold workaround and later broader PHP/request instability.

Birthday Magazine therefore does **not** repeat that path.

G3A starts directly with:

```text
Docker Compose
├─ WordPress
├─ MariaDB
└─ Mailpit (local email capture only)
```

Do not use WordPress Studio/SQLite for this Gate.

Do not install WooCommerce PayPal Payments in G3A. Payment-provider work remains G3B.

## Goal

Prove the native WordPress + WooCommerce commerce/order/account loop for the frozen Birthday Magazine MVP **without external payment and without model generation**.

Required path:

```text
Good Issue-style preview/product entry
→ WooCommerce virtual product at US$39.99
→ Add to Cart
→ Cart
→ Checkout
→ core offline test gateway
→ on-hold / unpaid WooCommerce order
→ checkout creates or attaches authenticated customer account
→ local account email captured in Mailpit
→ customer can see only their own order/workspace
→ unrelated authenticated customer is denied
→ unpaid/test order creates zero generation jobs and zero model calls
```

This Gate does not prove PayPal, paid entitlement, refund, provider execution or production deployment.

## Product / commerce semantics

The Birthday Magazine MVP is a digital personalized service/output, not a physical product.

Use:

- product price: **USD 39.99**;
- WooCommerce product type: simple + **virtual**;
- stock management: not required for the MVP proof;
- shipping: not required;
- tax: local/test-only neutral configuration; do not infer final tax policy;
- payment for this Gate: WooCommerce core offline/test gateway only, preferably **Check payments** renamed clearly as local test/no payment;
- expected order state: unpaid / `on-hold` or equivalent non-paid state.

Do **not** copy Mini Craft's physical-product inventory, shipping, COD or fulfillment semantics into this Gate.

## Required implementation / evidence

1. Start from latest `main`; use a dedicated branch.
2. Create a new isolated project-local Docker Compose runtime with:
   - WordPress;
   - MariaDB;
   - Mailpit;
   - separate project-scoped network/volumes.
3. Do not reuse or modify Mini Craft containers, volumes, database, PayPal state or artifacts.
4. Install/activate only the minimum required WordPress/WooCommerce components.
5. Do **not** install or activate WooCommerce PayPal Payments.
6. Reuse the accepted Good Issue-style Birthday Magazine frontend/preview direction; do not redesign the product in G3A.
7. Create the frozen Birthday Magazine product at **US$39.99**, marked virtual.
8. Confirm the preview/product CTA reaches the native WooCommerce commerce path.
9. Prove native:
   - Add to Cart;
   - Cart read/update/remove;
   - Checkout validation;
   - Checkout submission.
10. Use only a WooCommerce core offline test gateway. No provider credentials and no real payment.
11. Account flow must preserve the frozen product contract:
   - no separate pre-checkout registration requirement;
   - a new synthetic buyer email at checkout creates the customer account or the checkout attaches to an already-authenticated matching account;
   - account creation/setup notification is captured locally in Mailpit where WooCommerce emits it;
   - the customer can authenticate and reach their order/account area;
   - no password, cookie, reset token or account secret is committed as evidence.
12. Prove account/order isolation with at least two synthetic users:
   - buyer A can see buyer A order/workspace;
   - unrelated authenticated buyer B cannot view buyer A private order/workspace route;
   - direct URL replay must fail closed for buyer B.
13. Create a minimal order-bound Birthday Magazine workspace/intake placeholder sufficient to prove:
   - workspace is bound to WooCommerce order ID + authenticated owner;
   - owner can open it;
   - unrelated authenticated user cannot;
   - no guest bearer URL is accepted.
14. Prove generation entitlement remains closed:
   - offline/on-hold/unpaid order does not create a generation job;
   - account creation does not create a generation job;
   - workspace open/refresh/revisit does not create a generation job;
   - duplicate checkout page refresh does not create a generation job;
   - model/provider call count remains exactly 0.
15. Preserve the architectural condition for later paid generation:
   - generation requires server-side paid entitlement **and** intake completeness;
   - G3A must not fake or manually force paid state merely to test generation.
16. Capture durable synthetic evidence:
   - Product;
   - Cart;
   - Checkout;
   - order confirmation/account surface;
   - Mailpit account email metadata/body with secrets/redemption links redacted where needed;
   - buyer A workspace;
   - buyer B denial;
   - WooCommerce admin order/state;
   - zero-generation-job report.
17. Record exact runtime/plugin versions and Docker image identities where available.
18. Cleanup:
   - scoped `docker compose down` for this project only;
   - no broad Docker prune;
   - confirm project containers are stopped/removed as intended;
   - do not delete unrelated Docker objects.
19. No target VPS/public domain/Cloudflare/shared-infra write.

## Mini Craft lessons explicitly carried forward

The Executor must not rediscover these as if unknown:

- prefer Docker/MariaDB over Studio/SQLite for WooCommerce proof;
- separate commerce proof from PayPal proof;
- do not install PPCP early;
- keep WordPress/WooCommerce native order ownership canonical;
- do not invent business shipping/tax/refund claims;
- use minimal plugins;
- preserve exact rollback/cleanup scope;
- if a future PayPal issue appears, isolate runtime / plugin / credential / public-origin causes separately rather than changing several variables at once.

The later G3B contract must also remember Mini Craft's successful Sandbox path required a valid temporary HTTPS public origin for PPCP client-token/webhook behavior; G3A must **not** create that origin yet.

## PASS_CANDIDATE requirements

- DOCKER_WORDPRESS_RUNTIME=PASS
- MARIADB_RUNTIME=PASS
- MAILPIT_LOCAL_CAPTURE=PASS
- WOOCOMMERCE_PRODUCT_USD_39_99=PASS
- PRODUCT_VIRTUAL=PASS
- PREVIEW_TO_NATIVE_COMMERCE_PATH=PASS
- ADD_TO_CART=PASS
- CART_UPDATE_REMOVE=PASS
- CHECKOUT_VALIDATION=PASS
- CHECKOUT_SUBMISSION=PASS
- LOCAL_OFFLINE_ORDER_CREATED=PASS
- ORDER_PAID_STATE=NO
- ORDER_STATUS_ON_HOLD_OR_EQUIVALENT=PASS
- CHECKOUT_ACCOUNT_CREATE_OR_ATTACH=PASS
- ACCOUNT_EMAIL_LOCAL_CAPTURE=PASS_OR_NOT_EMITTED_WITH_REASON
- OWNER_ORDER_VISIBILITY=PASS
- UNRELATED_ACCOUNT_ORDER_DENIAL=PASS
- ORDER_BOUND_WORKSPACE=PASS
- WORKSPACE_DIRECT_URL_REPLAY_BY_OTHER_USER=DENIED
- UNPAID_GENERATION_GATE_CLOSED=PASS
- GENERATION_JOB_COUNT=0
- MODEL_CALL_COUNT=0
- PAYPAL_PLUGIN_INSTALLED=NO
- PAYPAL_CONNECTED=NO
- REAL_PAYMENT=NO
- G3B_STARTED=NO
- TARGET_HOST_WRITE=NO
- CLEANUP_READBACK=PASS
- STOP_AT_REVIEWER=YES

## Valid RETURN conditions

Return instead of improvising if:

- Docker Engine is unavailable;
- WordPress/MariaDB runtime cannot become healthy;
- native WooCommerce checkout requires a payment-provider action;
- account creation/attachment semantics cannot satisfy the frozen account-required contract;
- order/workspace isolation fails;
- a fix would require PayPal/PPCP, public tunnel/domain, external Secret, production provider, VPS write or broad environment mutation;
- a required behavior depends on inventing a business policy.

## Explicit non-goals

- WooCommerce PayPal Payments installation/configuration;
- PayPal Sandbox connection/capture/callback/refund;
- temporary HTTPS public origin;
- paid-entitlement transition;
- real AI provider execution;
- final photo upload/object storage;
- final proof/final-PDF private delivery;
- production deployment.

Those remain later Gates.

## Handoff

Update `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md`; retain non-sensitive local synthetic screenshots/reports; commit, push, open PR to `main`; do not merge; `STOP_AT_REVIEWER`.
