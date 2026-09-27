# K7 R1 — Canary Fixture + Resend Email Foundation Execution

Gate:
K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION

Owner authorization:
AUTHORIZE_K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION

Read:
- current REVIEWER_HANDOFF.md
- current PROJECT_RECORD.md
- current PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION_AUTHORIZED.md
- prior K7 readiness Evidence/Handoff
- canonical VPS Governance latest
- payment-integration governance latest

## Execute

A. Reconcile current state, read-only:
- K6 public Sandbox still healthy
- Product223 unchanged
- PayPal Live remains NO
- Resend domain state current

B. Create exact hidden virtual JPY500 canary product.
Do not touch Product223.

C. Create exact Resend sending domain minicraft.spikersun.com.
Use only DNS records returned by Resend.
Do not alter current Mini Craft A.
Verify domain.

D. Install/activate official Resend WordPress plugin.

E. Stop for Owner secret entry if needed:
RETURN_OWNER_RESEND_API_KEY_INTERACTIVE_ENTRY_REQUIRED
No API-key value may enter chat/GitHub/Evidence/logs.

F. After Owner direct entry:
- prove key configured only by presence/state, not value/hash
- prove sending-only permission and exact-domain restriction when observable safely
- configure sender support@minicraft.spikersun.com
- send exactly one non-sensitive test email to configured Owner-controlled admin recipient
- prove provider delivery and recipient arrival metadata

G. Populate cart/checkout with the hidden canary product only:
- quantity 1
- item JPY500
- shipping JPY0
- tax JPY0
- total JPY500
- PayPal method visible
- do not submit order or click final payment action

H. Evidence/Handoff and STOP.

## Forbidden

No PayPal Live/login, order creation, payment, auth/capture/refund, webhook money-flow action, Product223 mutation, Soft Launch, unrelated DNS/VPS/Shared Infra mutation, or Secret output.

## Success

PASS_CANDIDATE_K7_R1_CANARY_FIXTURE_AND_RESEND_EMAIL_FOUNDATION
STOP_AT_REVIEWER=YES
