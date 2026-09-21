# Reviewer Decision — K3R5 PayPal Sandbox on Docker/MariaDB

Date: 2026-09-21
Status: APPROVED TO EXECUTE

## Gate

`K3R5_PAYPAL_SANDBOX_DOCKER`

## Target

Use only the recovered active local runtime:

`http://localhost:8093/`

Architecture:

```text
Docker/MariaDB Mini Craft
→ official WooCommerce PayPal Payments
→ PayPal Sandbox
```

## Phase P0 — plugin/admin compatibility

1. Create a project-local pre-K3R5 rollback backup of the 8093 runtime.
2. Install/activate only the official `woocommerce-paypal-payments` plugin version 4.1.3.
3. Do NOT authorize PayPal yet.
4. Verify:
   - WooCommerce Home;
   - Settings → Payments;
   - PayPal Payments settings UI;
   - browser Console;
   - wc-admin REST;
   - Store API;
   - Product/Cart/Checkout smoke;
   - container CPU / request latency.

If the prior React mount failure (`Target container is not a DOM element` / React #299) reproduces on Docker:

`RETURN_K3R5_PPCP_4_1_3_DOCKER_UI_CONFLICT`

Do not retry onboarding or change versions.

## Phase P1 — Owner Sandbox authorization

If P0 is healthy, proceed only until the official PayPal connection flow requires Owner login/consent.

Then return:

`RETURN_OWNER_PAYPAL_SANDBOX_AUTH_REQUIRED_DOCKER`

Owner must perform only provider-side Sandbox login/authorization. Never request password, client secret, token, OAuth code, cookie, or webhook secret in chat/GitHub.

## Phase P2 — Sandbox payment validation

After Owner confirms Sandbox authorization, resume the SAME Gate and verify:

- Sandbox/Test mode only;
- PayPal visible at checkout;
- sandbox buyer approval;
- sandbox capture;
- WooCommerce order/provider correlation;
- physical-goods paid order transitions to Processing, not Completed/Shipped;
- no real funds.

## Callback/webhook

If localhost prevents required provider callback/webhook validation, STOP with:

`RETURN_K3R5_PUBLIC_CALLBACK_REQUIRED`

Do not create a tunnel, Cloudflare route, VPS endpoint, or production URL without a new Reviewer decision.

## Refund

If Sandbox payment/callback path is healthy, execute one bounded Sandbox refund from WooCommerce and verify provider refund state and WooCommerce refund/order notes.

## Safety

- no Live mode;
- no real payment;
- no production domain;
- no VPS;
- no Shared Payment Layer;
- no Dujiao;
- no custom PayPal API;
- no plugin version changes;
- no Studio runtime writes.

## Evidence

Update `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md`.

Stop at Reviewer on PASS_CANDIDATE or any defined RETURN.