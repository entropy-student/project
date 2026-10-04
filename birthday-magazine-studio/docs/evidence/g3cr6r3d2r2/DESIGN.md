---
name: Birthday Magazine — G3CR6R3D2R2 Home
description: Scoped refinement of the existing Focusly-inspired D2 homepage.
colors:
  paper: "#e4e3dc"
  ink: "#0c0e0f"
  white: "#fffdf9"
  signal: "#f3350c"
typography:
  heading:
    fontFamily: "BMS Instrument, Georgia, serif"
    fontSize: "72px"
    fontWeight: 400
    lineHeight: 1
    letterSpacing: "-.02em"
  body:
    fontFamily: "Arial, sans-serif"
    fontSize: "14px"
    fontWeight: 400
    lineHeight: 1.5
rounded:
  sample-desktop: "32px"
  sample-mobile: "18px"
spacing:
  sample-mobile-gutter: "16px"
  sample-desktop-gap: "80px"
  sample-mobile-gap: "28px"
---

# Design System: Birthday Magazine Home — G3CR6R3D2R2

## Overview

R2 refines the existing Owner-pinned Focusly Home 1 direction: the product remains in a sharp hero frame, with paper sections, serif/italic headings, dark photographic panels and capsule links. It enlarges the three sample visuals, replaces repeated major-section imagery and tightens mobile spacing. This contract supersedes the corresponding sample geometry, image assignments, mobile header and spacing in [D2 DESIGN.md](../g3cr6r3d2/DESIGN.md) for the R2 candidate. The D2 document remains unchanged as historical documentation; its inherited visual language and functional boundaries still apply.

Authority is the [R2 visual-polish Gate](../../G3CR6R3D2R2_VISUAL_POLISH.md). Sources are current `home.css`, `apply-home-g3cr6r3d2r2.php` and [generated-asset-provenance.json](generated-asset-provenance.json). This is a source contract, not a formal PASS, Reviewer decision or Owner acceptance. No browser, tests or fresh photo-upload regression were run for this documentation pass.

## Colors

The paper/ink/white/signal palette is inherited from D2. R2 adds visual diversity through photographic compositions: terracotta cover, cobalt/cream spread, warm kitchen gift, olive/rust memory scene and sandstone/sage birthday scene. These are image colors, not new interface tokens. Translucent dark panels retain the existing readable white text treatment.

## Typography

Instrument Serif Regular/Italic remains self-hosted as **BMS Instrument**, with Georgia/serif fallback and `font-display: swap`; Arial/sans-serif remains the utility/body font. The independently sourced Google Fonts OFL files and provenance remain the D2 record. R2's mobile Blocksy brand title is (22px), line-height (1.05), with a (230px) maximum width. Other established type roles and heading sizes remain inherited.

## Layout

Home **858** retains eight editable top-level Gutenberg Groups in the D2 order: Hero → Included → Preview → How → Offer → FAQ → Samples → Closing. Six unique anchors remain `what-you-get`, `preview`, `how-it-works`, `offer`, `faq`, `samples`. The R2 installer replaces exactly five image blocks; non-image Home content, group order, headings, factual copy, shortcode and link destinations are unchanged. It makes no menu changes.

Sample cards have a **3:2** aspect ratio at both widths. Their desktop maximum width is (1280px), giving an untransformed layout box of approximately **1280×853px** at the 1440px target. At 375px, (16px) section gutters give a **343×229px** box. Images fill the card edge to edge with `object-fit: cover`; the old cover-card mat and its padding are removed. These dimensions describe layout boxes, not scroll-transformed projections.

At widths up to (700px), the header shell is viewport minus (32px), **343px** at the 375px target, with (16px) internal horizontal padding and a (12px) gap. The native menu trigger has a minimum **44×44px** hit area. Mobile offcanvas behavior and destinations remain native Blocksy behavior.

Mobile rhythm is tightened in the existing sequence: split sections use (28px 24px 36px) padding and (24px) image/copy gap; copy gap is (18px). Preview wrapper top spacing is (24px), with (30px) chapter bottom padding. FAQ padding is (36px 24px), question gap (22px), grid top spacing (26px). Samples use (20px 16px 44px) padding, (28px) copy-to-card and card-to-card gaps. Desktop cards are separated by (80px).

Mobile photographic panels align their dark text panel at the bottom with (32px 24px) outer padding. The outer Preview photo panel has (560px) minimum height; Offer has (650px). Preview uses a (76% 45%) focal point. Offer uses a (320px) upper photograph with a (24% 35%) focal point and warm `#d4c9b7` backing below, revealing both faces above the dark text panel.

## Elevation & Depth

The inherited blur, sharp viewfinder, translucent panels and tonal layering remain. R2 changes sample prominence and image composition without introducing a shadow system. The interactive Preview remains in its existing separate wrapper below the outer photographic introduction.

## Shapes

Sample cards use rounded corners of (32px) desktop and (18px) mobile, with clipped full-bleed images. The mobile header retains (22px) lower corner radii. Existing hero, split-image, dark-panel and closing shapes remain inherited; removal of the mat applies only to the sample cover card, not the How section's contained cover.

## Components

**Five original static replacements.** All are (1536×1024) PNGs under `preview-plugin/assets/g3cr6r3d2r2/`. Provenance records **5 built-in image_gen calls, 0 rejected calls, 5 adopted assets**; prompts, purposes, hashes and source paths are in the linked manifest. Subjects are fictional/noncustomer, with no Focusly proprietary photography, real customer data, new paid provider or API key. These are illustrative marketing images, not customer output or runtime Preview generation.

| Asset | Actual display assignment |
|---|---|
| `sample-eli-cover.png` | Sample 1: prominent fictional Eli cover on terracotta; replaces the small Alex cover |
| `sample-moments-spread.png` | Sample 2: fictional editorial spread on blue/yellow; replaces the old spread |
| `sample-lena-gift.png` | Sample 3: fictional Lena receiving a magazine in a kitchen scene; replaces the old gift scene |
| `preview-memories-panel.png` | Outer Preview background: two fictional friends sharing printed memories; replaces the reused hero scene |
| `offer-birthday-panel.png` | Offer background: fictional father/daughter birthday embrace; replaces the reused hero scene |

The existing hero, Included spread, How cover and closing vignettes keep their D2 image assignments. Sample labels remain fictional/illustrative.

**Motion and fallbacks.** The existing `home-motion.js` controller is byte-identical to D2. The bounded entrance, once-only section reveals, scroll card perspective/scale, decorative panel travel, closing reveal and accessible label roll remain inherited. Larger 3:2 cards receive that same controller. Reduced-motion and no-JS styles remain in current `home.css`; no new controller or interaction is introduced. This documents preservation, not a fresh runtime test result.

**Frozen boundary.** `[bms_preview product_id="1113"]`, Preview internals, `preview.js`, `magazine-preview.css`, local-photo processing, upload/replace/remove semantics and object-URL handling are frozen. Runtime Preview model calls remain zero under the static-asset boundary. Product **1113**, virtual **USD39.99**, Woo canonical cart/checkout/account/order behavior, payment, private workspace ownership, entitlement, providers, P1–P12 and core Aha remain outside R2. The empty privacy link retains D2's configured-draft-page limitation.

## Do's and Don'ts

- Do use this R2 contract for current sample geometry/assets while retaining D2 as the historical baseline.
- Do preserve eight editable groups, six anchors, existing content and native destinations.
- Do keep the new photos static, fictional and separate from customer Preview data.
- Don't reintroduce the sample cover mat or reduce the cards to small centered posters.
- Don't extend display refinements into Preview or protected business behavior.
- Don't infer formal acceptance or a fresh upload/network regression from this documentation.
