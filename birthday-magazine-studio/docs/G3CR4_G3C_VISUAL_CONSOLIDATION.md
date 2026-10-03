# G3CR4 — G3C Visual Consolidation

> Project: Birthday Magazine Studio  
> Parent Gate: G3C UI/UX Productization + Owner Visual Freeze  
> Reviewer status: **CURRENT / PROJECT-LOCAL REVERSIBLE UI REWORK AUTHORIZED**  
> Related PR: #64  
> Production / Live payment authority: **NONE**

## 1. Goal

Rework the existing G3C homepage into one coherent Birthday Magazine product experience **without changing the accepted architecture**.

This is a visual/product-structure correction, not a new template exercise.

The Owner has reviewed the current screenshots and agrees that the page is visually fragmented and overly long.

## 2. Hard non-negotiables

Keep:

```text
THEME=BLOCKSY
STARTER=WEDDING
BUILDER=GUTENBERG
WOOCOMMERCE_CANONICAL_ORDER_SYSTEM=YES
GOOD_ISSUE_PREVIEW_CORE=KEEP
AUTHENTICATED_ACCOUNT_MVP=YES
USD_39_99_PRODUCT=YES
OWNER_ADMIN_GUTENBERG_EDITING=YES
```

Do not:

- switch theme;
- switch builder;
- add Elementor;
- add HT Slider;
- replace WooCommerce;
- rebuild checkout/account architecture;
- introduce a new cart/order system;
- introduce server-upload-first preview;
- introduce AI/model calls into the free preview.

## 3. Visual system to consolidate around

Use the existing Good Issue preview as the primary visual reference.

Preferred tokens already present in the accepted preview:

```text
paper   #f3efe8
white   #fffdf9
ink     #17191e
blue    #263da8
coral   #ed593c
yellow  #f2cf4a
muted   #686761
```

The page does not need to use every token everywhere.

Goal:

- editorial;
- magazine-like;
- photo-led;
- warm;
- gift-oriented;
- visually consistent.

Avoid making every section highly decorated.

## 4. Homepage structure — freeze this pass to six major sections

The final homepage should have approximately six major narrative sections.

### Section 1 — Hero

Keep the existing broad Hero concept, but simplify it.

Target message:

```text
A Birthday Magazine
Made About Them
```

Supporting copy should communicate:

- photos + stories become a personalized birthday magazine;
- no design skills required.

Primary CTA:

`Create a Free Preview`

Secondary trust line may communicate:

- browser-local preview;
- no design skills needed.

Required visual correction:

- magazine cover/sample on the right must be bright and clearly readable;
- remove the mouse/scroll icon;
- avoid unrelated floating decoration;
- Hero must not visually collide with the next section on mobile.

### Section 2 — Representative magazine samples

Use this section to answer:

> What will I actually receive?

Reuse existing sample/gallery assets but show **maximum three** representative samples in the main homepage flow.

Do not show six near-duplicate cards/pages.

Desktop:
- up to 3 samples in a clean grid.

Mobile:
- 2–3 samples maximum;
- stack or horizontal-scroll only if it remains Gutenberg-editable and does not create clipping.

Remove duplicated "Birthday Person" / "Their Story" narrative blocks if they repeat the same idea.

### Section 3 — Free Preview

This is the central activation section.

Retain the Good Issue preview interaction and most of its current desktop visual design.

Desktop:
- current input + preview relationship may remain if it fits cleanly.

Mobile:
- must become a genuine single-column flow:

```text
inputs
↓
preview cover
↓
sample spread / result
↓
CTA
```

Do not squeeze the desktop multi-column layout into 375px.

Required mobile result:

```text
NO_RIGHT_EDGE_CLIPPING=YES
NO_INTERNAL_HORIZONTAL_OVERFLOW=YES
STEP_LABELS_VISIBLE=YES
FORM_CONTROLS_USABLE=YES
PREVIEW_CONTENT_VISIBLE=YES
```

### Section 4 — What you get

Explain the frozen product succinctly.

Use a small number of items, for example:

- personalized 12-page digital magazine;
- photos + story-driven layouts;
- one bounded revision batch;
- private order workspace after purchase.

Do not create a dense feature grid.

### Section 5 — How it works

Use a simple 3-step or 4-step flow.

Preferred:

1. Choose photos + answer prompts
2. Create a free preview
3. Purchase through WooCommerce
4. Continue in the private order workspace

Avoid repeating the same text elsewhere.

### Section 6 — Offer + FAQ

Keep US$39.99 offer and CTA close to FAQ.

Do not leave a large empty vertical gap between Preview / Offer / FAQ.

FAQ should feel intentionally designed, not default unstyled blocks.

Use only contract-supported claims.

## 5. Content removal rules

Remove or consolidate:

- duplicate Story sections;
- duplicate Birthday Person / Their Story framing;
- redundant magazine sample walls;
- Wedding-specific residual copy;
- decorative blocks that do not help product understanding;
- empty spacer blocks that create oversized whitespace;
- the current mouse/scroll icon.

Do not add new sections to compensate.

## 6. Mobile requirements

375px is a first-class target.

Required:

```text
VIEWPORT=375
DOCUMENT_WIDTH<=375_OR_NONBLOCKING
HERO_CTA_VISIBLE=YES
HERO_SAMPLE_READABLE=YES
PREVIEW_SINGLE_COLUMN=YES
PREVIEW_RIGHT_EDGE_CLIPPING=NO
OFFER_CTA_USABLE=YES
FAQ_READABLE=YES
```

The mobile page should be materially shorter than the current screenshot because duplicate content and excessive sample stacking are removed.

Do not optimize to an arbitrary total pixel height.

## 7. Gutenberg editability

This pass must preserve Owner editing.

Main page content must remain editable through Gutenberg.

Owner must still be able to:

- edit text;
- replace images;
- reorder major blocks;
- edit Blocksy global styling.

Custom code may support the preview component, but the overall homepage must not become a hard-coded opaque template.

## 8. WooCommerce scope for this pass

Do **not** redesign Product / Cart / Checkout / My Account yet.

Only preserve their existing functional path.

Homepage CTA must still reach the existing US$39.99 WooCommerce path.

The next visual pass may skin WooCommerce after the Owner accepts the homepage.

Exception:

- if a global footer style change is required by the homepage and also fixes the known low-contrast footer, it is allowed;
- do not otherwise spend this Gate redesigning Woo pages.

## 9. Preview technical invariants

Keep:

```text
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0
```

Synthetic local photo verification is allowed.

## 10. Execution strategy

Use the retained local G3C runtime on PR #64.

Do not rebuild from scratch.

Before editing:

- create a project-local reversible backup/read-back of the current Gutenberg home content and relevant theme mods;
- do not expose credentials;
- do not touch unrelated Docker resources.

Then edit only what is needed for this visual consolidation.

## 11. Required evidence after rework

Capture current-state screenshots:

```text
01-desktop-full-page.png
02-desktop-hero.png
03-desktop-samples.png
04-desktop-preview.png
05-desktop-what-how.png
06-desktop-offer-faq.png

07-mobile-full-page-375.png
08-mobile-hero-375.png
09-mobile-samples-375.png
10-mobile-preview-375.png
11-mobile-offer-faq-375.png
```

Also retain:

- current Product page screenshot only for CTA continuity;
- Gutenberg editor screenshot if safely available without exposing credentials.

## 12. Required machine evidence

Record:

```text
DUPLICATE_STORY_BLOCKS_REMOVED=YES
SAMPLE_COUNT_MAIN_FLOW<=3
MOBILE_PREVIEW_SINGLE_COLUMN=YES
MOBILE_PREVIEW_CLIPPING=NO
EXCESSIVE_SPACER_BLOCKS_REMOVED=YES
MOUSE_SCROLL_DECORATION_REMOVED=YES
HERO_SAMPLE_READABLE=YES

GOOD_ISSUE_PREVIEW_INTEGRATED=YES
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0

WOOCOMMERCE_PATH=PASS
USD_39_99=PASS
OWNER_GUTENBERG_EDIT_ACCESS=PASS

PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
MODEL_CALLS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
```

## 13. Runtime / PR behavior

Continue on:

`codex/birthday-magazine-g3c-blocksy-wedding-productization`

Continue using:

PR #64

Do not create a new PR.

Keep local G3C runtime running for Owner review after the pass.

## 14. Success return

```text
PASS_CANDIDATE_G3CR4_G3C_VISUAL_CONSOLIDATION

PR_64=OPEN_UNMERGED

HOMEPAGE_SECTION_COUNT_APPROX=6
DUPLICATE_STORY_BLOCKS_REMOVED=YES
SAMPLE_COUNT_MAIN_FLOW<=3

HERO=PASS
DESKTOP_VISUAL_HIERARCHY=PASS
MOBILE_375_UI=PASS
MOBILE_PREVIEW_SINGLE_COLUMN=PASS
MOBILE_PREVIEW_CLIPPING=NO

GOOD_ISSUE_PREVIEW_INTEGRATED=PASS
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0

WOOCOMMERCE_PATH=PASS
USD_39_99=PASS
OWNER_GUTENBERG_EDIT_ACCESS=PASS

G3C_RUNTIME_RETAINED_FOR_OWNER_REVIEW=YES

PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
MODEL_CALLS=0
SHARED_INFRA_MUTATIONS=0

OWNER_VISUAL_FREEZE=PENDING
STOP_AT_REVIEWER=YES
```

## 15. RETURN outcomes

Use the narrowest applicable:

```text
RETURN_G3CR4_BACKUP_FAILED
RETURN_G3CR4_HOMEPAGE_STRUCTURE_FAILED
RETURN_G3CR4_MOBILE_PREVIEW_CLIPPING
RETURN_G3CR4_GUTENBERG_EDITABILITY_REGRESSION
RETURN_G3CR4_WOOCOMMERCE_PATH_REGRESSION
RETURN_G3CR4_PREVIEW_NETWORK_REGRESSION
RETURN_TEST_FAILURE
```

Do not enter G4.
