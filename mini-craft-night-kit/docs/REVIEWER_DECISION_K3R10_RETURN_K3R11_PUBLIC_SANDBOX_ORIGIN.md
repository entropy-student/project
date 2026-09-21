# Reviewer Decision — K3R10 RETURN / K3R11 Public Sandbox Origin

Date: 2026-09-21
Status: K3R10 RETURN ACCEPTED; K3R11 APPROVED TO PREPARE

## K3R10 independent review

Reviewer independently inspected commit `e0da27b27e083b50cc80e16462fcafdea8f55f37`, the latest EXECUTION_EVIDENCE.md, EXECUTOR_HANDOFF.md, and PPCP source for the SDK v6 client-token path.

Accepted facts:

- PayPal Sandbox merchant connection existed before checkout;
- PayPal was visible and selected at Checkout;
- PPCP SDK v6 loaded;
- the browser-side PayPal button did not render because PPCP client-token generation failed;
- buyer approval was never reached;
- no WooCommerce order was created;
- no PayPal capture or refund occurred;
- PPCP attempted to register a webhook at a localhost URL and PayPal rejected the registration;
- no public tunnel/VPS/domain workaround was created;
- a Sandbox credential-bearing log line was inadvertently surfaced in diagnostic output and the affected Sandbox Secret must be rotated before reuse.

Reviewer accepts:

`RETURN_K3_PUBLIC_CALLBACK_REQUIRED`

with a precision correction:

`K3_PUBLIC_SANDBOX_ORIGIN_REQUIRED`

## Why this is broader than webhook only

PPCP SDK v6 client-token generation is a separate PayPal API path from webhook registration.

The PPCP source constructs the SDK client-token request using the domain parsed from WordPress `home_url()` and sends it to PayPal as a domain parameter.

The current WordPress home URL is localhost.

Therefore K3R10 contains two distinct local-origin failures:

1. PPCP client-token generation fails before the PayPal approval button renders;
2. webhook registration fails because the callback URL is localhost.

They are not the same function call, but both require the next Gate to provide a valid HTTPS public Sandbox origin rather than attempting a webhook-only workaround.

## Security precondition

Before any further PayPal use, Owner must rotate/regenerate the affected Sandbox Secret.

Do not reuse the prior Sandbox Secret.
Do not paste the replacement Secret into chat or GitHub.

Formal incident record:

`docs/SECURITY_INCIDENT_K3R10_SANDBOX_CREDENTIAL_OUTPUT.md`

## K3R11 goal

Prepare a temporary, reversible HTTPS public origin for the local Sandbox WordPress runtime so PPCP can:

- request its SDK v6 client token against a non-localhost origin;
- register its Sandbox webhook against a publicly reachable HTTPS callback;
- render the PayPal checkout control.

K3R11 is environment preparation only. It does not authorize a Sandbox buyer payment yet.

## Preferred implementation

Use a temporary Cloudflare Tunnel / equivalent Reviewer-bounded HTTPS preview that forwards only to the existing local Docker WordPress runtime.

Requirements:

- no VPS deployment;
- no production domain migration;
- no Live PayPal;
- no real customer data;
- exact rollback record of WordPress URL/origin changes;
- public origin must use HTTPS;
- public origin must be temporary and test-only;
- the local runtime remains canonical for this Gate;
- any WordPress home/site URL change must be reversible and restored when the Gate ends.

If the Executor cannot establish the public origin without requiring Owner Cloudflare authorization/account credentials, stop at an Owner checkpoint rather than requesting credentials in chat.

## K3R11 sequence

Phase A — safety and rollback:
- verify current Docker/MariaDB runtime health;
- snapshot the current WordPress home/site URL and relevant PPCP connection state;
- create/verify a rollback point;
- confirm the affected Sandbox Secret has been rotated before reconnect/reuse.

Phase B — public origin:
- establish one temporary HTTPS public origin to the existing local runtime;
- temporarily configure WordPress/PPCP to generate public-origin URLs;
- verify front-end and Direct PayPal Settings are reachable and healthy through the test origin;
- do not expose credentials/log bodies.

Phase C — PayPal readiness:
- if Secret rotation invalidated the stored Sandbox connection, stop for one Owner Manual Connect using the rotated Secret;
- verify merchant connected/Sandbox/onboarding state;
- verify SDK client-token generation succeeds and the PayPal checkout control renders;
- verify webhook registration succeeds against the public HTTPS callback.

Stop before Sandbox buyer approval/payment.

## Not authorized

- no Live/Production credentials;
- no real funds;
- no production domain cutover;
- no VPS deployment/write;
- no PPCP/WooCommerce/WordPress version change;
- no source patch;
- no refund;
- no Sandbox capture in K3R11;
- no persistent public exposure after this bounded test without another Reviewer decision.

## Resume condition

When K3R11 returns PASS_CANDIDATE with:

```text
PUBLIC_HTTPS_ORIGIN=PASS
PPCP_CLIENT_TOKEN=PASS
PAYPAL_CHECKOUT_BUTTON_RENDERED=PASS
WEBHOOK_REGISTER=PASS
SANDBOX_MERCHANT_CONNECTED=PASS
SECRET_ROTATION_CONFIRMED=YES
```

Reviewer may resume K3R10 at the Sandbox buyer approval/capture step.

## Current checkpoint

`OWNER_K3R11_SANDBOX_SECRET_ROTATION_REQUIRED`
