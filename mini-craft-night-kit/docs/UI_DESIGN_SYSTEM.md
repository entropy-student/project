# Mini Craft Reusable Storefront — UI Design System

Date: 2026-09-22
Owner: Reviewer / Architect
Status: APPROVED IMPLEMENTATION SPEC

## Purpose

This is a reusable single-product ecommerce shell.

Normal future re-skin scope:
- change images;
- change text/product data;
- change global colors.

Normally do not rebuild layouts, WooCommerce flows, or payment logic.

Implementation priority:
FUNCTIONALITY / BUSINESS TRUTH > RESPONSIVE > OWNER EDITABILITY > THIS DESIGN SYSTEM > PIXEL PARITY.

## Architecture lock

Keep:
- Kadence Theme
- Kadence Blocks
- Gutenberg
- WooCommerce
- WooCommerce PayPal Payments

Kadence layout system is locked. Do not replace the global container/grid system, rebuild Cart/Checkout/Account, or use broad absolute positioning/fixed-pixel hacks.

## Global visual system

Default feel: warm / editorial / tactile / trustworthy / premium / human.

Avoid: SaaS / gadget / dashboard / discount-store / over-carded / aggressive animation / fake proof.

### Color tokens

| Token | Default | Role |
|---|---|---|
| Ink | #2F211D | primary text |
| Brand Primary / Burgundy | #6C2C22 | CTA, active states, icons |
| Brand Primary Dark | #542119 | hover |
| Cream | #FBF6EE | main warm page surface |
| Paper | #FFFDF9 | cards/forms |
| Beige | #F3E8DC | alternate section surface |
| Soft Accent | #F4E7E3 | light brand tint |
| Line | #EADFD4 | borders/dividers |
| Muted | #766861 | secondary text |
| Olive Optional | #53664B | optional secondary accent |

Default primary CTA is Burgundy.

Future re-skins should change global tokens first rather than recoloring blocks one by one.

### Typography

- Display/headings: DM Serif Display
- Body/UI/navigation/buttons: Plus Jakarta Sans
- Preserve existing safe local fallback if exact fonts are unavailable.

Target hierarchy:
- H1 desktop 56–64px; mobile 38–44px
- H2 desktop 38–44px; mobile 30–34px
- H3 desktop 24–30px; mobile 22–26px
- Body lead 18–20px; mobile 17–18px
- Body 16px
- Small/UI 13–14px

No forced desktop line breaks that overflow mobile.

### Shape and spacing

- card radius 14–20px
- button/input radius 8–12px
- border 1px Line
- shadows subtle or none
- keep existing Kadence container width
- section vertical spacing desktop 72–96px; tablet 56–72px; mobile 40–56px
- card gaps desktop 20–28px; mobile 16–20px
- no negative-margin or fixed-position parity hacks

## Buttons

Primary:
- Burgundy background
- Paper/white text
- Brand Primary Dark hover

Secondary:
- Paper or Soft Accent
- Burgundy text/border

One dominant CTA per visual section. No fake urgency/countdowns.

## Image policy

Executor must NOT generate images.

Allowed sources:
1. existing approved project assets;
2. existing WordPress Media Library assets;
3. clearly replaceable neutral placeholders.

If a final image is missing, keep the current approved image or a neutral editable placeholder.

Reusable image slots:
- Home Hero: wide 16:7 to 16:9
- Story/lifestyle split: 4:3
- Home content cards: 4:3
- Product gallery: 1:1 primary
- Product supporting cards: 4:3
- FAQ/Shipping/Contact hero: wide 16:7 to 16:9

All images must remain replaceable from Gutenberg/WooCommerce without code changes.

## Shared Header

Fixed shell:
- brand/logo left
- concise real navigation
- cart affordance
- one primary CTA right

Default nav:
- Shop
- FAQ
- Shipping & Returns
- Contact

Do not add fake social links, wishlist/search clutter, or unnecessary account clutter.

Keep native Kadence responsive navigation.

## Shared Footer

Fixed shell:
- brand identity
- primary navigation
- policy/help links
- real social links only
- copyright

Future sites change text, links, logo and colors only.

## Home — locked reusable shell

Section order:
1. Header
2. Hero
3. Three-step / three-beat strip
4. Three value cards
5. Story / lifestyle split
6. Product contents / offer grid
7. Compact benefit / trust strip
8. FAQ + Shipping/Returns reassurance
9. Closing CTA band
10. Footer

Hero replaceable: image, eyebrow, H1, body, CTA label/link, colors.
Three-step strip stays exactly three beats.
Value area stays three cards.
Story stays split layout on desktop and stacks on mobile.
Contents grid uses a reusable 3–5 card component; default 4.
FAQ/reassurance stays two-column desktop and stacked mobile.

## Product — locked reusable shell

Preserve canonical WooCommerce behavior.

Composition:
1. breadcrumb/context
2. product gallery
3. product summary
4. quantity + Add to Cart
5. compact trust row
6. three-value/experience panel
7. contents grid
8. lifestyle/use-case split
9. Shipping & Returns + FAQ compact split
10. closing CTA/footer

WooCommerce owns title, price, inventory, SKU, gallery, quantity, Add to Cart, variations/options.

Never fake ratings, reviews, scarcity, shipping time, or outcomes.

## FAQ — locked shell

1. shared header
2. warm hero/page intro
3. grouped accordion content
4. help/contact panel
5. closing CTA
6. shared footer

Recommended groups:
- Product Basics
- Shipping
- Returns
- Orders & Support

Only content/images/colors change.

## Shipping & Returns — locked shell

1. shared header
2. hero/page intro
3. three policy cards: Shipping / Returns / Damaged or Missing
4. reassurance strip
5. compact FAQ + Contact
6. closing CTA
7. shared footer

Only policy copy/images/colors change.

## Contact — locked shell

1. shared header
2. hero/page intro
3. two-column main area: native Kadence form + support reasons
4. three reassurance/support cards
5. closing CTA
6. shared footer

Form stays Name / Email / Message. Do not invent email, phone, or address.

## Shop / Cart / Checkout / Thank You / Account

These remain commerce-system surfaces.

- Shop: keep Woo archive structure; brand via global tokens and product data.
- Cart: no structural redesign.
- Checkout: no structural redesign.
- Thank You: no transactional redesign.
- My Account: no account-flow redesign.

Only inherited global typography/color styling is allowed on protected commerce pages.

## Responsive contract

Responsive behavior is functional.

Mandatory widths:
320 / 375 / 390 / 430 / 768 / 820 / 1024 / 1280 / 1366 / 1440 / 1920 / 2048 / 2560

Required:
- no horizontal overflow
- no clipped headings/buttons/forms
- no overlapping cards
- no inaccessible nav
- no fixed-width images/cards breaking viewport
- no distorted images
- tappable buttons
- usable forms
- native WooCommerce cart/checkout/account behavior preserved

Mobile:
- stack content
- target at least 20px side padding
- cards generally one column
- no hover-only content

## Motion

MVP motion is optional and minimal. No custom animation framework, parallax dependency, or motion required for conversion.

## Business-truth guardrails

Never publish unverified:
- exact kit contents
- fixed completion duration
- fixed delivery days
- free shipping
- ratings/review count
- testimonials
- certifications
- guarantees
- public support email/address
- supplier-origin claims

Current approved policy truth:
- initial market United States
- tracked standard shipping
- shipping cost shown at Checkout
- no fixed delivery-day promise
- 14-day return window after delivery
- non-defective return unused, unassembled, original packaging
- non-defective return shipping buyer paid
- damaged/missing report within 7 days
- replacement first; refund if replacement cannot reasonably be provided
- public support channel Contact form
