# K7 R1 — Canary Fixture + Resend Email Foundation

Gate:
K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION

Status:
AWAIT_OWNER_AUTHORIZATION

Required Owner marker:
AUTHORIZE_K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION

Do not execute until the Owner marker is accepted by Reviewer.

## Exact Canary fixture

- title: Mini Craft Payment Canary
- simple
- publish
- catalog visibility hidden
- virtual yes
- downloadable no
- tax none
- price JPY 500
- sold individually yes
- manage stock no
- no shipping
- truthful controlled-payment/full-refund verification description
- do not mutate Product 223

Expected populated Checkout:
item 500 JPY
shipping 0
tax 0
total 500 JPY
PayPal method visible
No order submit.

## Resend

Exact domain:
minicraft.spikersun.com

Sender:
support@minicraft.spikersun.com

Conditional DNS preauthorization after Owner marker:
Add only the exact DNS verification records returned by Resend for this domain. No unrelated DNS changes.

Install/activate official Resend WordPress plugin.

Secret:
Owner must create one sending-only, exact-domain-scoped API key in Resend dashboard and paste it directly into WordPress plugin settings. Never expose the value/hash to Executor output, chat, GitHub, logs or Evidence.

Then send exactly one test email to the configured Owner-controlled WordPress admin recipient and verify Resend delivery + mailbox arrival via metadata only.

## Still forbidden

No PayPal Live/login/authorization, order creation, buyer payment, capture/refund, webhook money-flow action, Product223 write, Soft Launch, unrelated DNS/VPS/Shared Infra mutation.

## Success

PASS_CANDIDATE_K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION
STOP_AT_REVIEWER=YES
