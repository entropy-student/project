# Reviewer Decision — G3C Owner Visual Review RETURN

Date: 2026-10-01  
Source: Owner-supplied current G3C screenshot package (17 current-state screenshots)  
Related PR: #64

## Result

**G3C_FUNCTIONAL_IMPLEMENTATION = ACCEPTED AS CURRENT BASELINE**

**G3C_VISUAL_QUALITY = RETURN**

This is not a template/architecture rejection. Blocksy Wedding + Gutenberg + WooCommerce + the existing Good Issue preview remain the frozen technical foundation.

The Owner explicitly agrees to proceed with a visual consolidation pass.

## Accepted technical baseline

Keep unchanged:

- Blocksy 2.1.57
- Blocksy Companion 2.1.57
- Wedding Gutenberg starter
- WooCommerce 11.1.2
- authenticated-account/private-workspace model
- US$39.99 product path
- browser-local free preview
- zero model calls before payment
- current Owner Administrator/Gutenberg editing route

No new template selection is authorized.

## Visual findings from current screenshots

### 1. Page hierarchy is fragmented

The homepage reads as multiple independently-designed modules stacked together rather than one coherent product story.

Observed causes:

- Wedding visual language;
- Good Issue preview visual language;
- default WooCommerce visual language;
- repeated story/memory concepts;
- excessive section separation.

### 2. Excessive vertical length

Current screenshots show a very long desktop page and an even longer mobile page.

The issue is structural, not a fixed pixel-height requirement:

- too many sections;
- repeated content;
- gallery/sample images all stacking vertically on mobile;
- unnecessary whitespace between major conversion sections.

### 3. Duplicate / redundant content

The current page repeats closely-related story concepts such as:

- Birthday Person
- Their Story
- people/memories/gallery concepts

The next pass must reduce duplication instead of adding more sections.

### 4. Good Issue preview is the strongest current visual component

The desktop preview has the clearest product-value communication and the most coherent editorial identity.

Therefore the site should consolidate toward the preview's editorial palette and hierarchy rather than treating the preview as an isolated embedded mini-site.

### 5. Mobile preview has a real layout defect

At 375px, current screenshots show internal preview content clipped at the right edge, including step/status labels and preview content.

This is a visual-functional regression.

The mobile preview must become a true single-column flow rather than a compressed desktop two-column composition.

### 6. Sample/gallery density is too high

The current gallery presents too many similar magazine samples at once.

On mobile this creates excessive scrolling.

The next pass should show no more than three representative samples in the main flow.

### 7. WooCommerce visual continuity is weak

Product / Cart / Checkout / My Account remain functionally valid but visually read as a separate default store.

This is acknowledged but **not the first subtask**.

First complete homepage consolidation. Woo visual skinning follows only after the Owner accepts the homepage direction.

### 8. Footer contrast defect

WooCommerce screenshots show insufficient text contrast in the footer area.

This must eventually be corrected, but homepage consolidation remains the immediate scope.

## Reviewer state

```text
G3C_FUNCTIONAL_BASELINE=ACCEPTED
G3C_VISUAL_QUALITY=RETURN
BLOCKSY_WEDDING=RETAINED
GUTENBERG=RETAINED
GOOD_ISSUE_PREVIEW=RETAINED
WOO_COMMERCE=RETAINED

G3CR3_VISUAL_EVIDENCE_CLOSURE=SUPERSEDED_BY_OWNER_VISUAL_REVIEW
G3CR4_VISUAL_CONSOLIDATION=CURRENT

OWNER_VISUAL_FREEZE=NOT_READY
G4=HOLD_NOT_AUTHORIZED
```

Current execution contract:

`G3CR4_G3C_VISUAL_CONSOLIDATION.md`
