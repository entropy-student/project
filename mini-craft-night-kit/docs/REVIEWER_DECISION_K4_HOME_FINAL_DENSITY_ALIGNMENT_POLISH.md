# Reviewer Decision — K4 Home Final Density & Alignment Polish

Date: 2026-09-22
Status: AUTHORIZED FINAL HOME POLISH
Parent checkpoint: OWNER_K4_FINAL_UI_EDIT_WINDOW

## Visual review basis

Reviewer reviewed the current 1440px desktop and 390px mobile full-page captures from:
- docs/ui-k4-visual-review-capture/home-desktop-1440.png
- docs/ui-k4-visual-review-capture/home-mobile-390.png

Owner feedback and Reviewer observations are consolidated below.

## Goal

Keep the current GPT-6 visual direction and current copy, but improve:
- hierarchy;
- density;
- rhythm;
- icon alignment;
- section differentiation;
- footer completeness.

This is a polish pass, not a redesign.

## Section map

The current visual review labels are interpreted as:

1. Hero
2. Three-step strip
3. Three-value section
4. Story / lifestyle split
5. Offer / product-display section
6. FAQ + order/shipping reassurance
7. Closing CTA
8. Footer

## Final modification plan

### ① Hero — increase visual weight

Keep:
- current hero image;
- current copy;
- current CTA;
- current light editorial composition;
- current image treatment.

Change:
- increase desktop Hero visual emphasis by roughly 8–12% through larger H1 and/or larger image footprint;
- allow the image/content pair to occupy more of the available desktop width;
- avoid adding extra vertical dead space;
- on mobile, preserve text-first then image order and increase H1 only modestly if needed.

Intent:
Hero should clearly dominate the first viewport without making the overall page longer.

### ② Three-step strip — compress and align

Keep it as a flat process strip, not cards.

Change:
- reduce section vertical padding by roughly 30–35%;
- use equal icon wrappers and equal top alignment;
- align icon / step number / title / body consistently across all three items;
- standardize icon size and burgundy color;
- keep desktop 3-column and mobile stacked behavior.

### ③ Three-value section — differentiate from ②

Current issue:
Sections ② and ③ both read as nearly identical three-column icon/text rows.

Change:
- reduce overall vertical padding by roughly 30–40%;
- keep three values but render them as restrained visual tiles/cards using existing palette tokens;
- 1px subtle border, existing approved radius, no heavy shadow;
- slightly larger native burgundy icons than section ②;
- equal card height/alignment on desktop;
- compact single-column stack on mobile.

Do not make the site heavily card-based; this distinction is intentionally limited to section ③.

### ④ Story / lifestyle split — compress

Keep:
- current image;
- current copy;
- split composition.

Change:
- reduce top/bottom section padding roughly 25–30%;
- normalize image/text gap;
- vertically center the copy against the image;
- preserve current mobile stacking.

### ⑤ Offer / product-display — preserve visual weight

This section is intentionally allowed to remain more spacious.

Keep:
- four 4:3 replaceable image slots;
- current copy;
- current 4-card desktop / stacked mobile behavior.

Only:
- normalize image/card alignment;
- keep consistent image radius;
- tighten title-to-grid spacing modestly if visibly excessive.

Do not shrink the product images merely to shorten the page.

### ⑥ FAQ + order reassurance — compress

Change:
- reduce top/bottom padding roughly 25–30%;
- align the two desktop columns from the same top baseline;
- tighten internal paragraph/list spacing;
- preserve readable mobile stack;
- keep all current factual policy copy unchanged.

### ⑦ Closing CTA — slightly compress

Keep:
- burgundy band;
- current copy;
- current CTA.

Change:
- reduce vertical padding roughly 15–25%;
- preserve strong visual separation from content and footer.

### ⑧ Footer — repair and simplify

Current screenshot shows a missing/non-rendering brand visual.

Change:
- remove the broken image state;
- use a reliable native/text brand lockup: site title plus optional native heart/brand icon;
- no generated image is required;
- keep FAQ / Shipping & Returns / Contact navigation;
- align brand and navigation cleanly on desktop;
- stack compactly on mobile;
- remove visible Kadence/WordPress theme-credit text from the public footer if it can be done through theme/editor settings without custom code;
- keep only the normal site copyright and intended navigation.

Do not introduce social links unless real destinations are confirmed.

## Global icon alignment rule

All native icons added during K4 Home work must use one consistent system:
- Kadence/native icon only;
- burgundy token;
- consistent visual size, approximately 20–24px;
- equal icon wrapper height;
- consistent stroke weight where the library permits;
- no manually offset icons;
- no icon rendered via missing external image.

## Density target

Desktop:
- sections ②/③/④/⑥ should become visibly tighter;
- Hero and section ⑤ remain the main visual anchors;
- total page height should decrease meaningfully without crowding copy.

Mobile:
- reduce repetitive blank spacing between stacked blocks;
- retain at least comfortable touch/readability spacing;
- product-display images remain single-column and prominent;
- no two-column mobile compression merely to shorten the page.

## Locked

Do not change:
- current final copy;
- product/business claims;
- hero image;
- product-display images unless fixing a broken reference;
- global palette;
- font families;
- Header mechanics;
- WooCommerce / PayPal / order/payment state;
- Product / Cart / Checkout structure.

No image generation.
No web-sourced imagery.
No new complex CSS framework.
No absolute-positioning hacks.

## Implementation method

Prefer native Gutenberg/Kadence controls:
- row/container padding;
- gap;
- alignment;
- border/radius;
- native icons;
- footer editor/theme controls.

Use custom CSS only if a native control cannot solve a specific responsive alignment defect, and keep any such CSS minimal and documented.

## Verification

Home widths:
320 / 375 / 390 / 430 / 768 / 820 / 1024 / 1280 / 1366 / 1440 / 1920 / 2048 / 2560

Required:
- Home HTTP 200;
- Gutenberg invalid block count 0;
- no horizontal overflow;
- no clipped text/buttons;
- icons aligned and rendered;
- footer broken image state gone;
- mobile nav functional;
- current copy/business truth unchanged;
- Product → Add to Cart → Cart → Checkout smoke without payment;
- WooCommerce/PayPal/existing Sandbox order unchanged.

Capture after implementation:
- Home desktop 1440 full-page
- Home mobile 390 full-page

Clean all task-generated temporary capture/profile directories before return.

## Stop

Return:

GATE=K4_HOME_FINAL_DENSITY_ALIGNMENT_POLISH
RESULT=PASS_CANDIDATE_K4_HOME_FINAL_DENSITY_ALIGNMENT_POLISH
SUMMARY=
EVIDENCE=
COMMIT=
OWNER_ACTION=NONE
NEXT=STOP_AT_REVIEWER

Do not enter K5.
