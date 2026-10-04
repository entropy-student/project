---
name: Birthday Magazine — G3CR6R3D2 Home
description: Independent implementation of the Owner-pinned Focusly Home 1 visual language.
colors:
  paper: "#e4e3dc"
  ink: "#0c0e0f"
  white: "#fffdf9"
  signal: "#f3350c"
  closing: "#080a0b"
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
  button:
    fontFamily: "Arial, sans-serif"
    fontSize: "12px"
    fontWeight: 600
    lineHeight: 1
    letterSpacing: ".035em"
rounded:
  button: "40px"
  photo-panel: "32px"
  sample-card: "48px"
  split-image: "64px"
spacing:
  desktop-gutter: "32px"
  mobile-gutter: "24px"
components:
  preview-link:
    backgroundColor: "{colors.white}"
    textColor: "{colors.ink}"
    typography: "{typography.button}"
    rounded: "{rounded.button}"
    padding: "17px 22px"
---

# Design System: Birthday Magazine Home — G3CR6R3D2

## Overview

The birthday magazine is the subject in focus. The Owner-pinned Focusly Home 1 language is expressed through a blurred photographic field and sharp viewfinder, large upright/italic editorial type, paper sections, translucent dark panels, white capsule links and restrained red-orange dots. This is original project CSS, Gutenberg content and a small display controller, informed by the rendered observations in [the D1 mapping](../../G3CR6R3D1_FOCUSLY_VISUAL_MAPPING_REPORT.md). The implementation uses no Focusly source, template runtime, photos or CDN fonts.

This contract records the final source in `home.css`, `home-motion.js`, `apply-home-g3cr6r3d2.php` and [font-provenance.json](font-provenance.json). It is source documentation, not an official Reviewer/Owner approval or a functional test result. The historical D1 report's runtime blocker remains a historical result; this document does not rewrite that gate verdict.

## Colors

Paper is the continuous background for introduction, steps, FAQ and samples; ink carries their text. White supports capsule links, while the signal accent marks small dots, selection and visible keyboard focus. The hero and closing use dark surfaces with white text. Depth comes from a dark translucent navigation shell (`#111b22ed`) and text panels (`#171b1ce6`), with warm neutral image mats.

## Typography

Display text uses self-hosted Instrument Serif Regular/Italic under the CSS family name **BMS Instrument**, with Georgia/serif fallback and `font-display: swap`. Body, navigation and utility text use Arial/sans-serif; BDO Grotesk is not imported.

Headings use the frontmatter desktop role, reduce to (60px) at widths up to (1000px), and (40px/1.03) up to (700px). Hero headings are (76px) desktop and (48px) mobile; sample headings are (96px/.98) and (48px); closing headings use `clamp(80px,9vw,132px)` and (54px) mobile. Body width is bounded to (62ch). Notes are (12px/1.6); FAQ question headings are (14px/1.3), weight (600).

Font provenance: Google Fonts repository, `ofl/instrumentserif`, commit `0b58fb370093f9a9f4ff785d94405710b79de67c`, **SIL Open Font License 1.1**. The two TTFs and `OFL.txt` live in `preview-plugin/assets/fonts/instrument-serif/`; exact bytes and SHA-256 values are recorded in the adjacent provenance file. They were sourced independently of Focusly.

## Layout

Home **858** contains exactly eight top-level editable core Gutenberg Groups. Headings, paragraphs, images and buttons remain ordinary blocks; the existing Preview shortcode is nested in its own display wrapper.

| Order | Group | Anchor / destination |
|---|---|---|
| 1 | Hero with focus frame, product statement and preview CTA | CTA → `#preview` |
| 2 | Included introduction, full spread and copy | `#what-you-get`; link → `#samples` |
| 3 | Preview photo panel followed by the existing interactive component | `#preview`; `[bms_preview product_id="1113"]` |
| 4 | How it works, contained cover and four steps | `#how-it-works` |
| 5 | Offer with right-aligned dark panel | `#offer`; link → native product 1113 permalink |
| 6 | FAQ with six questions | `#faq` |
| 7 | Three sequential fictional sample cards | `#samples` |
| 8 | Closing CTA, retaining the value-strip group identity | CTA → `#preview` |

All six named section anchors occur once. The installer changes only the positively identified menu item **1098** from `/#sample-pages` to `/#samples`, alongside Home presentation content. Existing Blocksy navigation controls and the editable footer remain the shell.

Desktop split sections use a (1.45fr / 1fr) grid, (9vw) gap and (48px 32px) padding. The Preview component sits in a (1168px) maximum-width wrapper. At widths up to (700px), sections become image-first single columns with (24px) gutters; FAQ becomes one column. Hero height is (812px), focus frame width is viewport minus (48px), and the closing becomes a compact (560px) minimum-height section without sticky scroll travel.

## Elevation & Depth

The page uses tonal layering rather than a new shadow system: blurred hero backdrop, sharp framed image, subtle outline/corner marks, translucent photo panels with (8px) backdrop blur, and paper mats. Owned display photos may move within clipped surfaces; interactive Preview controls are outside those moving surfaces.

## Shapes

Recurring silhouettes are rounded photo frames, capsule navigation and links, small circular signal dots and thin viewfinder marks. Hero frame corners are (44px) desktop and (24px) mobile. Split images are (24px) on mobile; dark panels are also (24px). Sample cards are vertically stacked, have a (16:10) desktop aspect ratio and (1.4) mobile ratio, with (18px) mobile corners. Cover art is contained inside a paper mat; other display scenes use cover crops.

## Components

**Assets.** Exactly three existing owned static marketing PNGs are reused: `gift-hero.png` (1536×1024; attachment 1137), `sample-spread.png` (1536×1024; attachment 1138), and `sample-cover.png` (1024×1536; attachment 1139), all under `preview-plugin/assets/g3cr6/`. They populate the hero, panels, introduction, steps, cards and closing vignettes. Samples remain labeled fictional/illustrative. New frames, mats and dots are CSS. **imagegen = 0**.

**Links and navigation.** White capsule CTAs retain real anchors/permalinks and at least (46px) height. Navigation uses the native Blocksy menu, a centered translucent shell of at most (860px), and a rounded mobile offcanvas panel. CTA and header links receive a (3px) signal outline with (5px) offset on `focus-visible`.

**Original bounded motion.** A one-time sharp-image entrance runs for (1.8s), from (9px) blur/(.65) opacity to sharp/full opacity; the hero message settles over (1.2s) from (18px) displacement/(.75) opacity. Selected display headings and images reveal once over (.9s), triggered by IntersectionObserver at (.12) threshold, from (18px) displacement/(2px) blur/(.75) opacity. Entrance easing is `cubic-bezier(.16,1,.3,1)`; content is visible before enhancement.

Scroll updates are passive and batched through `requestAnimationFrame`. Cards use (1200px) perspective: desktop tilt is bounded to (−8°…8°) and scale to (.9…1); mobile tilt to (−2°…2°) and scale to (.975…1). Panel image travel is (−21px…21px) desktop and zero mobile, with (1.05) scale. Closing decorative photos travel at most (±60px)/(±50px) desktop and zero mobile; its heading has a bounded white/dim gradient reveal. The closing is ordinary document flow. No animation loops or scroll interception are introduced.

On hover/keyboard focus, eligible header/CTA labels roll over (.5s); their duplicate is `aria-hidden`, preserving one accessible name and the existing target. The CTA dot scales to (1.7) over (.35s). Reduced motion disables entrance/reveal animations, card/photo transforms and label transitions, and restores white closing text; changing the preference removes controller styles. Without JavaScript, the motion class and label duplicates are absent: content, sharp image, flat cards and links remain visible. Without IntersectionObserver, display content stays visible.

**Frozen functionality.** The Preview shortcode, controls/data hooks, local photo selection/replacement/removal, blob decode/revocation, status and keyboard behavior remain the existing component contract. The controller touches presentation labels and display containers only. Product **1113**, **US$39.99**, digital/virtual product facts, native Woo cart/checkout/account routes, account-required purchase, PayPal, private order ownership, entitlement/generation semantics, provider calls, DB schema, unresolved Aha behavior and P1–P12 scope are outside this redesign. Source inspection does not prove runtime regressions absent.

The footer's empty privacy href remains unchanged because the configured privacy page is a draft. D2 does not publish that page or substitute an invented destination.

## Do's and Don'ts

- Do preserve the eight editable groups, unique anchors, real product links and fictional sample labeling.
- Do keep cover/spread content contained where specified and keep Preview controls in normal flow.
- Do preserve visible content and native link behavior under reduced motion or missing JavaScript.
- Don't reuse Focusly source/runtime/assets or present static marketing samples as finished customer output.
- Don't extend presentation motion into Preview input state, Woo forms, authentication, payment or private workspace behavior.
- Don't treat this source contract as Reviewer approval, Owner acceptance or fresh functional/network verification.
