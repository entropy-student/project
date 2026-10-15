# G3P0 — Source audit: prepayment intake still browser-only

> Date: 2026-10-16
> Scope: read-only GitHub source audit, no Windows host/Stripe/provider access
> Project source: PR #64 head `4cb0d527d77a6d583e123acd3f62c45408669569` (Open/unmerged)
> Contract: `docs/MVP_PRODUCT_CONTRACT.md`, Owner frontend visual freeze `docs/OWNER_DECISION_G3CR7_FRONTEND_VISUAL_ACCEPTANCE_2026-10-15.md`
> Status: **SOURCE_GAP_CONFIRMED**; no claim of fresh Owner-host runtime reproduction.

## What is implemented

- Five-step frontend intake accepts customer facts, **12–25 local photos** and up to **3 must-use** photos, six editorial prompt answers, client-side review, and WooCommerce cart/checkout navigation. Source `poc/g3c/preview-plugin/frontend-reproduction.php` blob `36a668b37e53e491f9858abe0772c014721d9ade` and `frontend-reproduction.js` blob `cbd67a7dc0897e87e4c7bc4ed017a1e138d2e6a` at PR head.
- The PHP UI itself explicitly tells customers/testers that answers/photos **remain in the browser and are not saved to the server** (PHP ~L90).
- JS `photos` is an in-memory array of `File` and `URL.createObjectURL` values (JS ~L17, L89). `pagehide` revokes object URLs (JS ~L205).
- The checkout handler (JS L181–203) validates local steps and posts **only** `product_id` and `quantity:1` to Woo's `add_to_cart` endpoint, then navigates to Woo checkout; it does **not** send or persist the photos, prompts or a durable versioned intake reference.
- Original order workspace `poc/g3c/commerce-workspace-plugin/bms-g3a-commerce-loop.php` binds order owner and secures a private route, but says generation is disabled (L115–117). No durable buyer intake-to-order binding proof in this current G3C source audit.
- G3CR7 prior source review already explicitly called the UI **frontend-shell only** and excluded server draft persistence, reference `docs/REVIEWER_DECISION_G3CR7_SOURCE_PASS_RUNTIME_VISUAL_PENDING.md`.
- Official Stripe Gateway 11.1.0 installed **inactive** on Owner local Windows was previously Reviewer-accepted at bounded evidence scope; that is separate from backend intake/fulfillment readiness.

## Gap vs frozen MVP product contract

`docs/MVP_PRODUCT_CONTRACT.md` §3–4 and §11 require: an unguessable server-bound **temporary** draft holding complete pre-payment answers and 12–25 source photos, a server-validated frozen **versioned snapshot** linked to WooCommerce checkout, and only **after verified paid entitlement and exact order/customer correlation** can a single canonical generation job become eligible. Incomplete/unpaid draft must never generate. Abandoned records/photos must expire and be deleted on a disclosed short TTL.

**Current blocker to delivery:** The displayed checkout button can proceed without preserving any of those intake assets. A real buyer might complete the form and start Woo checkout, yet no retained intake data exists for a paid magazine job. Client-side step checks alone cannot prove server completeness or entitlement.

## Smallest next workstream, independent of Stripe merchant onboarding

1. Implement server draft endpoints, short-lived secure session/draft identity and protected local file persistence in Owner G3C **offline lab** only; server-validate fields, format/size/count and uploads; files cannot be exposed through public WordPress media URLs or Git.
2. Freeze a versioned complete snapshot and associate opaque snapshot reference with native WooCommerce cart, **without placing any payment order or enabling Stripe**. Keep the standard Woo cart/checkout UI and exact locked visual structure.
3. Prove deterministic local fixture tests: 12 valid synthetic test photos + six prompts survives refresh/return; rejected 11 photos, 26 photos, over-3 must-use, invalid MIME/oversize; foreign session cannot read draft; duplicate submit creates no extra snapshot; stale draft unavailable/cleanable; unpaid cannot create job. No real customer materials.
4. Defer actual order/customer paid-entitlement binding and production AI generation to the *next separate* Gate; avoid coupling account eligibility to front-end intake persistence now.
5. Before local writes, check current PR/local source identity and selected restore point, with no DB reset/reinstall, no PAYPAL or Stripe changes. Because project host mutations are not authorized simply by documenting this audit, no Codex prompt or action is emitted until Owner explicitly asks.

## Classification

```text
PREFLIGHT_SOURCE_READONLY=PASS
G3P0_SOURCE_AUDIT=PASS_SOURCE_GAP_CONFIRMED
FRONTEND_FIVE_STEPS=SOURCE_PRESENT_VISUAL_OWNER_FROZEN
SERVER_PREPAYMENT_DRAFT=PRESENT_IN_CONTRACT_NOT_IN_CURRENT_G3C_APP_PATH
CUSTOMER_PHOTO_STORAGE=CLIENT_MEMORY_ONLY
CHECKOUT_PAYLOAD=PRODUCT_ID_QUANTITY_ONLY
ORDER_PAID_SNAPSHOT_BINDING=NOT_PROVEN_CURRENT_G3C
INACTIVE_STRIPE_STAGING=REVIEWER_PREVIOUS_PASS_UNCHANGED
NEXT_PREPARED_GATE=G3P1_LOCAL_PREPAYMENT_DRAFT_AND_CART_CORRELATION
NEXT_GATE_EXECUTION=NOT_STARTED_NO_CODEX_PROMPT_OWNER_LAST_REQUEST
LOCAL_PROVIDER_DB_PAYMENTS_MUTATIONS=0
```
