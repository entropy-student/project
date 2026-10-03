# G3CR5 — G3C Visual Finish + WooCommerce Continuity

> Project: Birthday Magazine Studio  
> Parent Gate: G3C UI/UX Productization + Owner Visual Freeze  
> Reviewer status: **CURRENT / PROJECT-LOCAL REVERSIBLE VISUAL POLISH AUTHORIZED**  
> Related PR: #64  
> G4 / Live / real-money authority: **NONE**

## 1. Goal

Finish the current G3C visual direction without changing architecture.

This is a narrow polish pass after G3CR4 PASS.

Two objectives only:

1. correct the uploaded-photo composition inside the Good Issue preview;
2. visually align WooCommerce Product / Cart / Checkout / My Account with the accepted homepage.

Do not reopen homepage structure unless a tiny spacing/token adjustment is required for visual consistency.

## 2. Frozen foundation

Keep:

```text
THEME=BLOCKSY
STARTER=WEDDING
BUILDER=GUTENBERG
GOOD_ISSUE_PREVIEW=KEEP
WOOCOMMERCE_CANONICAL_ORDER_SYSTEM=YES
USD_39_99_PRODUCT=YES
AUTHENTICATED_ACCOUNT_MVP=YES
OWNER_ADMIN_GUTENBERG_EDITING=YES
```

No template/builder/plugin architecture changes.

## 3. Objective A — Preview photo composition

Current issue:

When a local preview photo is selected, the image frame can visibly cover or collide with headline/copy on the right-hand sample spread.

Required result:

- uploaded image must sit inside a dedicated image area/frame;
- it must not cover headline text;
- it must not cover body text;
- it must not cover page number/critical labels;
- desktop and 375px must both remain readable;
- no new clipping or internal horizontal overflow;
- photo can use `object-fit: cover` or equivalent;
- preserve the same browser-local `blob:` privacy model.

Do not remove the photo-preview feature.

Do not send the photo to WordPress/server/external services.

Success fields:

```text
PHOTO_PREVIEW_DEDICATED_FRAME=YES
PHOTO_PREVIEW_TEXT_OVERLAP=NO
PHOTO_PREVIEW_DESKTOP=PASS
PHOTO_PREVIEW_MOBILE_375=PASS
```

## 4. Objective B — WooCommerce visual continuity

Do not rebuild WooCommerce templates from scratch.

Use project-local CSS/theme overrides and existing Blocksy/Woo hooks where practical.

Apply the accepted homepage visual language:

- warm paper/white backgrounds;
- ink typography;
- editorial serif headings;
- coral/blue/yellow only as controlled accents;
- square/low-radius buttons consistent with homepage;
- coherent max-width/padding rhythm;
- readable footer.

### Product

Keep native Woo product behavior.

Improve:

- product image / detail balance;
- title/price hierarchy;
- Add to Cart button treatment;
- spacing;
- breadcrumb/header consistency.

### Cart

Keep native cart behavior.

Improve:

- table/card spacing;
- totals hierarchy;
- checkout CTA;
- footer continuity.

### Checkout

Keep native checkout behavior and current account-required settings.

Improve:

- section hierarchy;
- order-summary treatment;
- input/readability spacing;
- Place order button treatment.

No payment submission.

### My Account

Keep native account/login behavior.

Improve:

- form width/rhythm;
- heading hierarchy;
- login button;
- footer continuity.

## 5. Mobile Woo check

At minimum test 375px:

- Product;
- Cart;
- Checkout;
- My Account.

No blocking horizontal overflow.

Core CTA remains visible/usable.

Do not require bespoke mobile redesign; responsive skinning is sufficient.

## 6. Homepage regression

Do not materially change the accepted six-section homepage.

Verify only:

```text
HOMEPAGE_PRIMARY_SECTIONS=6
MOBILE_PREVIEW_SINGLE_COLUMN=YES
MOBILE_PREVIEW_CLIPPING=NO
HERO_CTA_VISIBLE=YES
```

## 7. Technical invariants

```text
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0

PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
MODEL_CALLS=0
PRODUCTION_AI_CALLS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
G4_ACTIONS=0
```

## 8. Gutenberg / Owner editability

Do not reduce Owner editability.

Must remain:

- Owner role Administrator;
- Home editable in Gutenberg;
- text/image/block ordering still editable;
- Blocksy global styles editable.

Woo visual skin may be CSS/theme-level and does not need every Woo detail to be Gutenberg-editable.

## 9. Required current screenshots

Capture:

```text
01-desktop-home-regression.png
02-desktop-preview-with-photo.png
03-mobile-preview-with-photo-375.png

04-desktop-product.png
05-mobile-product-375.png

06-desktop-cart.png
07-mobile-cart-375.png

08-desktop-checkout.png
09-mobile-checkout-375.png

10-desktop-my-account.png
11-mobile-my-account-375.png
```

Optional:

`12-desktop-full-page.png`

## 10. Machine evidence

Record:

```text
PHOTO_PREVIEW_DEDICATED_FRAME=YES
PHOTO_PREVIEW_TEXT_OVERLAP=NO

WOO_PRODUCT_VISUAL_CONTINUITY=PASS
WOO_CART_VISUAL_CONTINUITY=PASS
WOO_CHECKOUT_VISUAL_CONTINUITY=PASS
WOO_ACCOUNT_VISUAL_CONTINUITY=PASS

WOO_MOBILE_375=PASS
WOO_BLOCKING_OVERFLOW=NO

HOMEPAGE_REGRESSION=PASS
OWNER_GUTENBERG_EDIT_ACCESS=PASS
```

## 11. Runtime / Git / PR

Continue:

- branch: `codex/birthday-magazine-g3c-blocksy-wedding-productization`
- PR: #64
- current retained G3C runtime

Do not create a new PR.

Keep runtime running after completion for Owner review.

## 12. Success return

```text
PASS_CANDIDATE_G3CR5_G3C_VISUAL_FINISH_WOO_CONTINUITY

PR_64=OPEN_UNMERGED

PHOTO_PREVIEW_DEDICATED_FRAME=YES
PHOTO_PREVIEW_TEXT_OVERLAP=NO
PHOTO_PREVIEW_DESKTOP=PASS
PHOTO_PREVIEW_MOBILE_375=PASS

WOO_PRODUCT_VISUAL_CONTINUITY=PASS
WOO_CART_VISUAL_CONTINUITY=PASS
WOO_CHECKOUT_VISUAL_CONTINUITY=PASS
WOO_ACCOUNT_VISUAL_CONTINUITY=PASS
WOO_MOBILE_375=PASS
WOO_BLOCKING_OVERFLOW=NO

HOMEPAGE_REGRESSION=PASS
OWNER_GUTENBERG_EDIT_ACCESS=PASS

FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0

PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
MODEL_CALLS=0
SHARED_INFRA_MUTATIONS=0
G4_ACTIONS=0

G3C_RUNTIME_RETAINED_FOR_OWNER_REVIEW=YES
OWNER_VISUAL_FREEZE=PENDING
STOP_AT_REVIEWER=YES
```

## 13. RETURN outcomes

```text
RETURN_G3CR5_PHOTO_PREVIEW_COMPOSITION_FAILED
RETURN_G3CR5_WOO_VISUAL_CONTINUITY_FAILED
RETURN_G3CR5_MOBILE_WOO_REGRESSION
RETURN_G3CR5_HOMEPAGE_REGRESSION
RETURN_G3CR5_PREVIEW_NETWORK_REGRESSION
RETURN_G3CR5_OWNER_EDITABILITY_REGRESSION
RETURN_TEST_FAILURE
```

Do not enter G4.
