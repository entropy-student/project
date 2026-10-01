# G3CR6 — Frontend Experience + Brand Redesign

## Status

**CURRENT / OWNER AUTHORIZED**

Owner approved:
- selected visual direction: **Option 2 — Warm Birthday Gift**
- execution Agent may call image generation for high-fidelity site assets
- reference images define visual direction, **not** a pixel-perfect structural contract

Parent state:
- G3CR4 = PASS
- G3CR5 = PASS
- G3C technical UI/UX = PASS
- Owner visual freeze = PENDING
- PR #64 remains open/unmerged
- G4 remains HOLD / NOT AUTHORIZED

## Goal

Raise the retained G3C experience from “technically clear but still looks like a test/demo” to a customer-facing birthday-gift brand that the Owner is willing to show directly to potential users.

This is not limited to CSS-only work. User-visible frontend interaction may be redesigned where it materially improves the experience, especially the Free Preview upload / preview UI.

## Visual North Star

Primary direction:
- warm birthday-gift feeling
- premium editorial magazine character
- photo-led and human
- cream / warm-white base
- coral primary CTA
- elegant serif display type + restrained sans UI type
- magazine is always the product hero
- flowers / gift boxes / cards are supporting atmosphere, not the product
- consumer gift brand, not SaaS, not generic WooCommerce, not a heavy scrapbook site

Reference hierarchy:
1. **Primary image:** Option 2 Warm Birthday Gift — use for emotion, palette, hero, photography, magazine treatment.
2. **Secondary image:** multi-route commerce continuity board — use only for visual continuity across Product / Cart / Checkout / My Account and mobile.

Do not infer new product features from any generated concept image.

## Three-layer change boundary

### A. Frontend experience layer — OPEN

May be redesigned freely when it improves clarity, desirability or usability:
- Hero
- Samples
- Free Preview shell
- upload UI
- selected-photo state
- replace / reselect controls
- Preview layout and client-side state presentation
- What You Get / How It Works / Offer / FAQ presentation
- product-page visual layout
- Cart / Checkout / My Account visual presentation
- mobile composition

### B. Frontend behavior layer — OPEN WITH REGRESSION

May change if needed, but every changed behavior must be re-tested:
- browser-local image selection / preview interaction
- preview state switching
- user-visible form interaction
- arrangement of native Woo frontend components

The implementation details do not need to remain identical if the accepted behavioral contract remains true.

### C. Backend business/data layer — PROTECTED

Do not redesign or replace without a new Reviewer authorization:
- WooCommerce canonical cart / checkout / order data logic
- payment gateway logic
- server-side checkout submission semantics
- order status machine
- account / authorization model
- private-workspace ownership checks
- entitlement / generation-job semantics
- database schema
- production AI/provider logic

## Non-negotiable behavior contracts

### Free Preview

The upload UI may be completely redesigned.

But:
- selected photos remain browser-local
- no photo upload to WordPress
- no third-party photo upload
- no model-provider request
- FREE_PREVIEW_MODEL_CALLS=0
- FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
- FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0

A new upload component is acceptable if it preserves those facts.

### WooCommerce

Frontend Woo pages may look substantially different.

But:
- WooCommerce remains the canonical commerce/order system
- native product identity and USD 39.99 price remain
- Add to Cart must still use WooCommerce behavior
- Cart must still use WooCommerce cart state
- Checkout must remain WooCommerce checkout
- My Account must remain WooCommerce account access
- no parallel custom checkout/payment/order implementation
- no checkout submission in this Gate
- no PayPal action / real-money action

Prefer styling, Gutenberg/Blocksy composition and safe Woo hooks. If native Woo elements are rearranged, preserve their forms/actions/nonces/endpoints.

## Homepage information architecture

Do not treat the prior six visual section boundaries as immutable pixel layout.

The experience must still clearly communicate this customer path:

Hero
→ Sample Magazines
→ Free Preview
→ What You Get
→ How It Works
→ US$39.99 complete magazine offer + FAQ
→ native WooCommerce purchase path

The Agent may merge or visually recompose sections when doing so produces a clearly better frontend, as long as no accepted product promise is removed or invented.

## Image-generation authorization

The Owner explicitly authorizes image generation for high-fidelity frontend visual assets.

Allowed:
- Hero magazine / gift composition
- fictional/sample magazine covers
- sample editorial spreads
- supporting gift/floral/paper atmosphere assets
- product presentation visuals

Rules:
- generated people are fictional/sample people
- do not imply they are real customers
- no fake reviews, ratings, order counts or testimonials
- label sample work appropriately where the UI could otherwise imply real customer proof
- final adopted assets should be curated; do not commit an uncontrolled dump of unused generations

## Content / conversion priorities

Primary first-screen message should communicate:
1. birthday gift
2. personalized magazine
3. made for one specific person
4. immediate Free Preview

Preferred hero direction:
**Give them a birthday gift that feels like a magazine made just for them.**

Primary CTA:
**Create a Free Preview**

Preview message direction:
**See one photo become a magazine moment.**

Paid transition direction:
**Turn it into the complete 12-page birthday magazine for $39.99.**

Exact wording may be refined, but no unsupported claim may be introduced.

## Execution order

1. Fresh read-back of PR #64 / current runtime / current implementation.
2. Create scoped rollback backup before mutation.
3. Inspect current code and identify the minimum protected backend surface.
4. Generate / curate only the visual assets needed for the selected direction.
5. Redesign frontend experience, including upload UI where beneficial.
6. Re-skin native Woo frontend without replacing canonical commerce logic.
7. Desktop + 375px regression.
8. Behavioral regression for every touched interaction.
9. Produce screenshot/evidence packet.
10. Stop at Reviewer.

## Required evidence

At minimum:
- desktop full homepage
- desktop Hero
- desktop Samples
- desktop Free Preview empty state
- desktop Free Preview with selected photo
- desktop paid transition / Offer + FAQ
- 375px full homepage
- 375px Hero
- 375px Preview empty state
- 375px Preview selected-photo state
- desktop + 375px Product
- desktop + 375px Cart
- desktop + 375px Checkout
- desktop + 375px My Account

Machine/read-back evidence:
- preview uses browser-local selected photo
- 0 server photo uploads
- 0 external image POSTs
- 0 model calls for Preview
- Product → Add to Cart → Cart → Checkout → My Account regression
- no checkout submission
- Owner Gutenberg/media/global-style edit access
- mobile width/overflow checks

## Forbidden

- merge PR #64
- G4 work
- PayPal Live or Sandbox payment mutation
- real-money transaction
- production deployment
- shared infrastructure mutation
- theme/builder replacement
- Elementor
- parallel order/checkout system
- backend WooCommerce rewrite solely to match a design mockup

## Return contract

Return exactly one:

`PASS_CANDIDATE_G3CR6_FRONTEND_EXPERIENCE_BRAND_REDESIGN`

or

`RETURN_G3CR6_<CONCRETE_REASON>`

Include:
- branch
- pre-run head
- final head
- PR #64 state
- backup/rollback location
- files changed
- frontend behaviors changed
- protected backend files/behaviors confirmed unchanged
- generated assets list
- adopted assets list
- screenshot directory
- machine report path
- runtime URL
- wp-admin URL
- all forbidden-action counters
- `OWNER_VISUAL_FREEZE=PENDING`
- `STOP_AT_REVIEWER=YES`
