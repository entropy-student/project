# Reviewer Decision — K3R11 PASS / Resume K3R10 Sandbox Checkout & Capture

Date: 2026-09-22
Status: K3R11 PASS; K3R10 RESUMED

## Independent review

Reviewer independently inspected Executor commit:

`f8c416006dd84d4b00b50a9837e9b6a5f8b30870`

Accepted evidence:

- Sandbox merchant connection is healthy;
- Sandbox mode is enabled;
- onboarding is completed;
- PPCP SDK v6 client-token generation succeeds;
- one PayPal Checkout button renders in the bounded test checkout;
- the configured PayPal webhook URL is HTTPS and points to the temporary public origin;
- webhook REST state is healthy and reports 17 subscribed events;
- Direct PayPal Settings is healthy;
- WordPress and MariaDB runtime are healthy;
- no buyer approval, WooCommerce order submission, PayPal capture, refund, Live activation, VPS write, production-domain cutover, version change, source patch, or secret output occurred.

Reviewer accepts:

`K3R11_PUBLIC_ORIGIN_READINESS_VERIFY=PASS`

## Non-blocking observation

Optional Apple Pay / Google Pay admin preview-manager errors were observed. They did not prevent PayPal connection, client-token generation, PayPal Checkout button rendering, or webhook readiness. They do not block the PayPal Sandbox mainline and are deferred unless they affect a later explicitly scoped payment method Gate.

## Temporary public-origin requirement

The active Cloudflare Quick Tunnel and public WordPress URL rebind must remain in place for the resumed K3R10 Sandbox payment/callback test.

Do not stop the tunnel or restore localhost URLs until the Sandbox payment, capture, and provider callback/webhook verification are complete or Reviewer explicitly authorizes rollback.

If the Quick Tunnel drops, do not continue payment testing against a stale URL. Re-establish/revalidate a temporary HTTPS origin first.

## Resumed K3R10 objective

Resume the original Sandbox payment-flow acceptance test:

1. keep the existing test-only Mini Craft cart/product;
2. open Checkout through the active public HTTPS origin;
3. use synthetic/local-only customer data;
4. select PayPal;
5. proceed until Sandbox buyer authentication/approval is required;
6. stop at Owner checkpoint for Sandbox buyer login/approval;
7. after Owner approval, complete exactly one Sandbox payment/capture;
8. verify WooCommerce creates/updates the corresponding order;
9. verify order reaches the correct paid/processing state;
10. verify PayPal transaction/order correlation using redacted identifiers only;
11. verify payment success does not auto-complete physical fulfillment/shipping;
12. verify actual provider callback/webhook delivery/processing after the payment.

## Owner boundary

Sandbox buyer account credentials and buyer approval remain Owner-only.

Executor must never request or record Sandbox buyer password, seller Secret, tokens, cookies, authorization headers, or raw provider payloads.

## Not authorized

- no Live/Production PayPal;
- no real money;
- no real customer data;
- no second/duplicate payment unless separately authorized after a failed first attempt;
- no refund yet;
- no VPS deployment;
- no production-domain cutover;
- no plugin/version changes;
- no PPCP source patch;
- no tunnel shutdown or localhost rollback before this resumed Gate is resolved.

## Current Gate

`K3R10_PAYPAL_SANDBOX_CHECKOUT_CAPTURE_RESUME`

Executor may proceed until the Sandbox buyer-authentication/approval boundary, then stop at Owner.
