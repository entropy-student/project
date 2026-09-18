# Reviewer Decision — K1B WordPress Implementation

Date: 2026-09-18
Status: OWNER APPROVED TO EXECUTE

## Gate

`K1B_WORDPRESS_IMPLEMENTATION`

Owner approved the K1A visual/growth direction.

## Source of Truth

Executor must read and follow:

- `docs/K1A_VISUAL_DIRECTION_AND_GROWTH_MAP.md`
- `docs/REVIEWER_DECISION_K1_UI_GROWTH_BRAND_ADAPTATION.md`
- latest `PROJECT_RECORD.md`
- latest `REVIEWER_HANDOFF.md`

## Core implementation rule

Kadence remains the implementation architecture.

Archived Mini Craft Home is the visual reference only.

Do not rebuild the site to chase pixel parity.

Priority:

```text
Business / Growth truth
> approved K1A hierarchy
> Kadence native layout
> Mini Craft brand tokens
> visual parity
```

## Layout Lock

`KADENCE_LAYOUT_SYSTEM=LOCKED`

Forbidden:

- rebuilding global container system
- replacing Kadence layout with a custom grid system
- broad absolute positioning
- fixed-pixel desktop-only alignment hacks
- large CSS rewrites for screenshot parity
- breaking Gutenberg editability
- breaking WooCommerce blocks/hooks

Allowed:

- replace copy
- replace colors and typography
- replace/remove irrelevant images
- adjust individual section padding/gap where necessary
- remove irrelevant template sections
- add one native Gutenberg/Kadence section only when an approved K1A section has no usable existing slot
- fix the inherited 375px clipping with the narrowest safe change

## Image Policy

Codex MUST NOT generate final product/lifestyle images.

Image workflow:

```text
existing approved Mini Craft assets
> reusable neutral reference assets
> clearly labeled editable placeholder
```

All K1B images must remain replaceable from WordPress/Gutenberg.

Do not create:

- fake UGC
- fake customer photos
- fake testimonial cards
- fabricated review screenshots
- AI-generated final lifestyle/product photography presented as real proof

If a required visual is missing, preserve the approved layout with a neutral placeholder and record the missing asset in Evidence.

Final image production is a later Owner/Reviewer-controlled step.

## Content / Claim boundary

Do not invent:

- exact kit contents
- exact duration
- difficulty claims
- price if not finalized
- shipping time/cost
- return/refund window
- guarantee
- star rating
- review count
- testimonials

Sections that depend on unknown facts may be structurally prepared but must remain neutral or hidden.

## Pages / surfaces in scope

Primary:

- Home
- shared Header
- shared Footer

Necessary brand consistency only:

- Product
- Cart
- Checkout

Do not redesign Cart/Checkout in K1B.

## Mandatory Home implementation

Implement the approved K1A hierarchy with minimum changes:

1. Hero
2. Experience / How It Works
3. Differentiation
4. canonical WooCommerce product / offer handoff
5. What's Inside shell
6. Beginner objection
7. Proof placeholder/hidden state
8. Trust / before-you-order shell
9. Closing CTA

## Brand tokens

Use:

- Ink `#2F211D`
- Burgundy `#6C2C22`
- Olive `#53664B`
- Olive Dark `#46583F`
- Cream `#FBF6EE`
- Paper `#FFFDF9`
- Beige `#F3E8DC`
- Line `#EADFD4`
- Muted `#766861`
- Footer `#F5ECDF`

Typography direction:

- DM Serif Display for display/headlines
- Plus Jakarta Sans for body/UI

If local font availability in Studio differs, use the closest safe implementation without bundling unapproved font binaries into GitHub.

## Responsive requirement

K1B MUST fix the inherited 375px clipping.

Required checks:

`320 / 375 / 390 / 430 / 768 / 820 / 1024 / 1280 / 1366 / 1440 / 1920 / 2048 / 2560`

No horizontal overflow.

## WooCommerce protection

Must remain functional:

- Product
- Add to Cart
- Cart
- Checkout
- Orders admin
- native WooCommerce behavior/hooks

No PayPal configuration in K1B.

## PASS candidate

```text
PASS_CANDIDATE_K1B_WORDPRESS_IMPLEMENTATION
K1A_DIRECTION_IMPLEMENTED=PASS
KADENCE_LAYOUT_SYSTEM_PRESERVED=PASS
MINI_CRAFT_BRAND_ADAPTATION=PASS
FINAL_IMAGES_GENERATED_BY_CODEX=NO
PLACEHOLDER_IMAGES_REPLACEABLE=PASS
UNVERIFIED_CLAIMS_PUBLISHED=NO
FAKE_SOCIAL_PROOF=NO
GUTENBERG_VALIDITY=PASS
INVALID_BLOCK_COUNT=0
OWNER_EDITABILITY=PASS
MOBILE_320=PASS
MOBILE_375=PASS
MOBILE_390=PASS
MOBILE_430=PASS
TABLET_RESPONSIVE=PASS
DESKTOP_RESPONSIVE=PASS
ULTRAWIDE_SMOKE=PASS
PRODUCT_RUNTIME=PASS
ADD_TO_CART=PASS
CART_RUNTIME=PASS
CHECKOUT_RUNTIME=PASS
WOOCOMMERCE_BEHAVIOR=PASS
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
SECRET_EXPOSURE=NO
STOP_AT_REVIEWER=YES
```

## Evidence

Update:

- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Evidence must include:

- before/after section map
- exact sections reused vs adapted vs removed
- image placeholders / reused assets list
- withheld unknown claims
- 375px remediation evidence
- responsive matrix
- Gutenberg validity
- WooCommerce smoke

## Stop

Stop at Reviewer after Evidence is written.

No K2, PayPal, VPS, production domain, real order, or real payment.