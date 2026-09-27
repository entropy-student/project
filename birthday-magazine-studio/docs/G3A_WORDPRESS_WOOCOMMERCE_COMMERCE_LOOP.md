# G3A — WordPress + WooCommerce Commerce Loop

> Reviewer execution contract  
> Status: CURRENT / READY_FOR_EXECUTION  
> Prerequisites: G2A1 PASS, G2A2 PASS, G2B content/rendering PASS via G2BR3  
> Scope: local/test commerce and authenticated order workspace only

## Goal

Prove the native WordPress + WooCommerce commerce/order/account loop for the frozen Birthday Magazine MVP **without external payment and without model generation**.

Required path:

```text
Good Issue-style WordPress preview/product entry
→ WooCommerce $39.99 product
→ cart
→ checkout
→ local-only test/offline order creation
→ checkout email creates or attaches authenticated customer account
→ customer sees only their own order/workspace
→ unpaid/test order does NOT trigger model generation
```

This Gate does not prove PayPal, paid entitlement, refund, provider execution or production deployment.

## Required implementation/evidence

1. Start from latest `main`; use a dedicated branch.
2. Use a disposable local WordPress + WooCommerce environment.
3. Reuse the accepted WordPress/Good-Issue-style frontend foundation; do not redesign the product.
4. Create the frozen Birthday Magazine product at **US$39.99**.
5. Confirm preview/product CTA reaches the native WooCommerce commerce path.
6. Prove native add-to-cart, cart and checkout.
7. Use only a local/offline WooCommerce test path to create the order. No PayPal connection, no real payment and no external payment credentials.
8. Preserve the MVP access model:
   - no separate pre-checkout registration requirement;
   - checkout email creates or attaches the customer account;
   - the created order is visible from the authenticated account;
   - an unrelated authenticated customer cannot view the order/workspace.
9. Create a minimal order-bound workspace/intake placeholder sufficient to prove account + order ownership binding. Do not implement final production storage yet.
10. Prove the generation entitlement is closed:
    - local/offline unpaid/on-hold order does not create a model job;
    - no AI/model/provider call occurs;
    - refresh/revisit does not create a generation job.
11. Capture durable screenshots and order/account evidence using synthetic test identities only.
12. Clean up the disposable local runtime with scoped teardown; no broad Docker prune.
13. No target VPS/public domain/Cloudflare/shared-infra write.

## PASS_CANDIDATE requirements

- WORDPRESS_RUNTIME=PASS
- WOOCOMMERCE_PRODUCT_39_99=PASS
- PREVIEW_TO_NATIVE_COMMERCE_PATH=PASS
- ADD_TO_CART=PASS
- CART=PASS
- CHECKOUT=PASS
- LOCAL_TEST_ORDER_CREATED=PASS
- CHECKOUT_ACCOUNT_CREATE_OR_ATTACH=PASS
- OWNER_ORDER_VISIBILITY=PASS
- UNRELATED_ACCOUNT_ORDER_DENIAL=PASS
- ORDER_BOUND_WORKSPACE=PASS
- UNPAID_GENERATION_GATE_CLOSED=PASS
- MODEL_CALL_COUNT=0
- PAYPAL_CONNECTED=NO
- REAL_PAYMENT=NO
- G3B_STARTED=NO
- TARGET_HOST_WRITE=NO
- CLEANUP_READBACK=PASS

## Explicit non-goals

- PayPal Sandbox connection/capture/callback/refund;
- paid-entitlement transition;
- real AI provider execution;
- final upload/object-storage implementation;
- final proof/final-PDF private delivery implementation;
- production deployment.

Those remain later Gates.

## Handoff

Update `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md`; retain local synthetic screenshots/reports; commit, push, open PR to `main`; do not merge; `STOP_AT_REVIEWER`.
