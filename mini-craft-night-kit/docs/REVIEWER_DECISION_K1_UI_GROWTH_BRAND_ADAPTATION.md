# Reviewer Decision — K1 UI / Growth Decision + Brand Adaptation

Date: 2026-09-18
Status: APPROVED TO EXECUTE

## 1. Gate

`K1_UI_GROWTH_DECISION_AND_BRAND_ADAPTATION`

WordPress Studio managed site `Mini Craft Night Kit` is now the active local development base.

## 2. Objective

Turn the accepted Kadence Single Product starter site into a credible Mini Craft Night Kit storefront with the smallest practical set of changes.

Primary conversion objective:

> Make a visitor understand that the product is a pre-planned at-home craft date, trust what they are buying, and reach the product / cart flow.

Growth hypothesis for K1:

> Sell the night, not the supplies.

The current message hypothesis to implement first is:

> Your next date night is already planned.

This is a hypothesis to validate, not a proven winner.

## 3. Audience / purchase context

Primary:
- couples looking for an at-home date-night activity
- people who want a low-planning shared activity

Secondary:
- experience-gift shoppers
- cozy / rainy-night activity shoppers

Do not broaden K1 toward family, children, corporate team building, or multiple unrelated audiences.

## 4. Homepage information hierarchy

Preserve Kadence layout patterns where they can express the following hierarchy. Do not rebuild the site from scratch.

### A. Hero — ADAPT

Required message:

`Your next date night is already planned.`

Supporting direction:

`Everything you need for a screen-free craft night for two.`

Primary CTA:

`Shop the Kit`

Do not add unsupported urgency, fake scarcity, ratings, or fake social proof.

### B. Experience proof / demo — ADAPT

Visual/narrative target:

```text
open the box
→ start making together
→ imperfect / playful moment
→ project takes shape
→ finished result
→ keepsake
```

Prefer real product/process imagery if available.

If real product/process imagery is not available, use existing approved Mini Craft assets or clearly non-deceptive placeholder imagery. Do not manufacture testimonial-style proof.

### C. How it works — KEEP/ADAPT

Use three-step structure:

```text
1. Open the box
2. Make together
3. Keep the memory
```

### D. What's inside — ADAPT

Purpose: reduce uncertainty about what is being purchased.

Only list contents that are actually confirmed by product truth.

Possible content classes from the Growth Playbook:
- materials
- tools
- guide
- conversation prompts
- packaging
- extras

Executor must not invent missing contents.

### E. Beginner objection — ADAPT

Purpose: reduce the fear that the activity requires artistic skill.

Allowed tone direction:

`This isn't an art class.`

Do not make quantified ease/success claims without evidence.

### F. Trust / boundaries — ADAPT

Make clear where verified:
- who it is for
- approximate difficulty
- expected duration
- expected finished result
- shipping
- returns/refunds
- damaged/missing-item support
- secure payment

Unverified facts must remain omitted or marked for Owner/product confirmation. No invented shipping times, refund windows, guarantees, ratings, review counts, or payment badges.

### G. Closing CTA — KEEP/ADAPT

Repeat the core promise and send the user to the canonical WooCommerce product flow.

Primary CTA remains:

`Shop the Kit`

## 5. Template KEEP / ADAPT / DROP rule

### KEEP
- Kadence responsive containers and spacing system
- header/footer structure unless product-specific copy requires adaptation
- mature WooCommerce product/cart/checkout blocks
- reusable section geometry that maps cleanly to the approved hierarchy
- Gutenberg editability

### ADAPT
- brand name
- product title/copy
- Hero
- images
- section headings
- feature/benefit cards
- CTA labels
- colors/typography using existing approved Mini Craft brand assets where available
- product-specific WooCommerce content

### DROP
- smart-speaker / technology-product language
- irrelevant feature/spec blocks that cannot map to Mini Craft value
- fake or imported demo reviews
- imported trust badges that imply facts not true for Mini Craft
- duplicated sections that add no conversion value
- any template content that creates a second product narrative

Do not add new custom page systems merely to achieve visual novelty.

## 6. Product truth boundary

K1 may only publish factual claims that are already supported by real product inputs.

Current unresolved / evidence-dependent items include:
- exact box contents
- actual completion duration
- final difficulty level
- exact final result
- product price
- shipping time/cost
- returns/refund policy
- damaged/missing-item handling
- real UGC/reviews

Where these are unavailable, keep the section structurally ready but do not fabricate facts.

## 7. Visual direction

Desired feel:

`warm / tactile / cozy / giftable / human / date-night`

Avoid:

`tech product / SaaS / sterile gadget store / over-animated landing page`

Reuse approved Mini Craft visual assets and brand tokens from the archived project where they are already defined.

Do not use clone-ui as the architecture controller.

## 8. Mandatory inherited fix

K1 must fix the known 375px Home clipping inherited from the Kadence baseline.

Required mobile widths:

`320 / 375 / 390 / 430`

The fix must not create regressions at:

`768 / 820 / 1024 / 1280 / 1366 / 1440 / 1920 / 2048 / 2560`

## 9. WooCommerce boundary

K1 must not rebuild commerce.

Preserve:
- Product
- Add to Cart
- Cart
- Checkout
- Orders admin
- WooCommerce hooks/blocks

No PayPal configuration in K1.

## 10. Execution strategy

Executor should first map each current Kadence homepage section to the approved hierarchy above, then perform the minimum set of edits.

Do not independently redesign the marketing information architecture.

Prefer:

```text
reuse existing section
> edit copy/image
> small style adjustment
> remove irrelevant section
> only then add a new block if a required approved section has no usable existing slot
```

## 11. K1 validation

Required before PASS_CANDIDATE:

```text
MINI_CRAFT_BRAND_ADAPTATION=PASS
HERO_MESSAGE=PASS
APPROVED_INFORMATION_HIERARCHY=PASS
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

## 12. Evidence

Executor must update:
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Evidence should include:
- before/after section mapping
- changed pages/blocks
- claims intentionally withheld because product truth is missing
- responsive checks including 375px remediation
- Gutenberg validity
- WooCommerce smoke checks

## 13. Stop conditions

RETURN instead of improvising if:
- a required claim needs unknown product facts
- the only solution requires rebuilding the Kadence layout system
- WooCommerce behavior breaks
- Gutenberg invalid blocks appear
- the 375px issue cannot be fixed without broad layout rewrite
- real payment/account authorization becomes necessary

## 14. Out of scope

- PayPal
- real orders
- production shipping configuration
- VPS
- production domain
- analytics/ads
- CRM/newsletter/loyalty
- broad plugin expansion

Stop at Reviewer after K1 evidence is written.