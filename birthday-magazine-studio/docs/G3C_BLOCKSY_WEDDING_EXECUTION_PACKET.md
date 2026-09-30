# G3C Blocksy Wedding Execution Packet — UI/UX Productization + Owner Edit Checkpoint

> Project: Birthday Magazine Studio  
> Gate: G3C UI/UX Productization + Owner Visual Freeze  
> Governance: VPS Project Governance v0.1.6 + active addenda  
> Status: **CURRENT / PROJECT-LOCAL REVERSIBLE EXECUTION AUTHORIZED**  
> G4 / Live / real-money authority: **NONE**

## 1. Read order

Executor must read:

1. `../REVIEWER_HANDOFF.md`
2. `G3C_UI_UX_PRODUCTIZATION.md`
3. `REVIEWER_DECISION_G3CR2R3_PASS.md`
4. `OWNER_DECISION_G3C_BLOCKSY_WEDDING.md`
5. `MVP_PRODUCT_CONTRACT.md`
6. `REVIEWER_DECISION_G3A_PASS.md`
7. `REVIEWER_DECISION_G3BR1_G3B_PASS.md`
8. this packet
9. only then the reusable source trees below

Do not use old Astra execution contracts as current authority.

## 2. Frozen implementation route

```text
G3A local WordPress/WooCommerce/account baseline
+
Blocksy 2.1.57
+
Blocksy Companion 2.1.57
+
Wedding Gutenberg starter
+
Simply Gallery 3.4.3
+
Stackable 3.20.2
+
WPForms Lite 2.0.2.1
+
G2A1 Good Issue browser-local preview
+
G3A private-workspace logic
=
G3C local Birthday Magazine product experience
```

Do not change theme or builder.

## 3. Reusable assets

### G3A baseline

Reuse from `poc/g3a/`:

- isolated WordPress/WooCommerce/MariaDB pattern;
- commerce/private-workspace plugin;
- synthetic product/account conventions;
- local Mailpit only if account email verification is useful.

### G2A1 preview

Reuse from `poc/g2a1/preview-plugin/`:

- `birthday-magazine-poc.php`
- `preview.js`
- `preview.css`
- `routes.css`

Preserve the accepted browser-local image behavior.

### G3CR2R3 evidence

PR #63 is accepted compatibility evidence only. Reconstruct a fresh G3C runtime; do not depend on a deleted canary volume.

## 4. New G3C source

Create:

```text
birthday-magazine-studio/poc/g3c/
├── README.md
├── compose.yaml
├── scripts/
├── preview-plugin/
├── commerce-workspace-plugin/
├── theme-overrides/
└── artifacts/
    ├── screenshots/
    └── reports/
```

Do not modify historical G2A1/G3A/G3B evidence in place.

## 5. WordPress shell

Build a fresh isolated local runtime and import:

- Blocksy Wedding;
- Gutenberg variant;
- Simply Gallery Block 3.4.3;
- Stackable 3.20.2;
- WPForms Lite 2.0.2.1;
- WooCommerce 11.1.2.

Forbidden:

- Elementor;
- HT Slider;
- paid Blocksy/third-party components.

Replace or remove the two known stale imported logo references before Owner review.

## 6. Minimal-modification design principle

Use the existing Wedding structure wherever it already serves the Birthday Magazine story.

Prefer **rewriting/replacing content inside existing sections** over rebuilding the page.

Preserve useful visual behaviors such as:

- large photo-led hero;
- story/memory sections;
- photo galleries;
- warm event/milestone tone;
- responsive Gutenberg structure.

Remove only clearly irrelevant wedding-specific semantics.

Do not turn the site into a generic WooCommerce storefront.

## 7. Required Birthday Magazine page narrative

The page should read approximately:

### Hero
Communicate:
- turn their photos and story into a personalized birthday magazine;
- no design work required;
- primary CTA: **Create a Free Preview**.

### Memories / Story
Reuse Wedding story/photo sections to communicate:
- their people;
- their memories;
- their story;
- a personalized keepsake.

### Free Preview — central activation point
Embed the real G2A1 browser-local Good Issue preview.

It must allow a synthetic/user-selected local photo and update the preview in-browser.

It must not upload the preview image to WordPress or an external origin.

### What you get
Describe the frozen 12-page digital PDF product without inventing unproven features.

### How it works
Keep it simple:

1. choose photos / answer prompts;
2. preview the concept;
3. purchase through WooCommerce;
4. authenticated order workspace handles the paid path.

Do not claim production automation beyond accepted project evidence.

### Offer
- test price = US$39.99;
- native WooCommerce path only;
- CTA should connect clearly to product/cart/checkout.

### FAQ / trust
Use only supported statements:
- free preview is browser-local;
- digital PDF;
- account required for private order workspace;
- one bounded revision batch;
- privacy/retention statements only where frozen by MVP contract.

No fake testimonials, fake order counts or invented guarantees.

## 8. Owner direct editing — REQUIRED

The Owner explicitly wants to make visual changes directly.

Full G3C must therefore provide:

```text
OWNER_VISUAL_EDIT_ACCESS=REQUIRED
OWNER_ROLE=ADMINISTRATOR
PAGE_EDITOR=GUTENBERG
WEDDING_HOME_GUTENBERG_EDITABLE=YES
OWNER_CAN_EDIT_TEXT=YES
OWNER_CAN_REPLACE_IMAGES=YES
OWNER_CAN_REORDER_BLOCKS=YES
OWNER_CAN_EDIT_BLOCKSY_GLOBAL_STYLE=YES
WORDPRESS_STUDIO_REQUIRED=NO
```

The primary editing route is WordPress Admin + Gutenberg.

At technical PASS_CANDIDATE:

- leave the exact G3C local runtime running for Owner review/editing;
- report the local site URL;
- report the `/wp-admin/` URL;
- ensure an Owner Administrator account exists;
- do **not** commit or print a persistent password into GitHub evidence;
- give the Owner a local-only command/template to set or reset their own password if required.

Credentials, cookies and password values must not enter repository evidence.

## 9. Preview invariants

Must preserve:

```text
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0
WOO_COMMERCE_CANONICAL_ORDER_SYSTEM=YES
USD_39_99_PRODUCT_PATH=YES
AUTHENTICATED_ACCOUNT_MVP=YES
GUEST_BEARER_PRIVATE_DELIVERY=NO
PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
PRODUCTION_AI_CALLS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
```

A selected preview photo may use a browser-local `blob:` URL.

## 10. Technical verification

### Main page
Verify desktop and 375px:
- hero;
- photo/story sections;
- preview;
- offer;
- FAQ/trust;
- no blocking overflow/fatal error.

### Preview network proof
With one synthetic local image:

- preview changes visibly;
- image source is browser-local;
- no photo bytes are POSTed/uploaded;
- no model/API call occurs.

### WooCommerce
Verify:
- US$39.99 product;
- Cart;
- Checkout;
- My Account;
- no PayPal submission.

### Private workspace
Minimum regression:
- Owner account can access own workspace;
- unrelated authenticated account denied;
- guest denied.

### Gutenberg editing
Verify:
- home is a normal Gutenberg page;
- Owner Administrator can load the editor;
- text/image edits can be made through the editor without code changes.

Do not use the Owner's real private data as evidence.

## 11. Visual evidence

At minimum save:

```text
desktop-full-page.png
desktop-hero.png
desktop-preview.png
desktop-offer-faq.png
mobile-375-hero.png
mobile-375-preview.png
woo-product-or-cart.png
wp-admin-gutenberg-home.png
```

Use synthetic/sample data.

## 12. Runtime retention for Owner review

Unlike disposable canaries, a successful G3C local runtime should remain available at the Owner checkpoint.

On PASS_CANDIDATE:

```text
G3C_RUNTIME_RETAINED_FOR_OWNER_REVIEW=YES
OWNER_VISUAL_FREEZE=PENDING
```

Do not tear down the G3C runtime before Owner review unless it is required for safety or the Owner asks.

Still clean exact temporary package caches that are not needed for the running site.

## 13. Forbidden scope

- no PayPal Sandbox or Live action;
- no real-money payment/refund;
- no production AI/model call;
- no production deployment;
- no Shared VPS/Caddy/Cloudflare mutation;
- no paid plugin/theme purchase;
- no Elementor / HT Slider;
- no G4/G5/G6;
- no broad Docker/system prune.

## 14. Success return

```text
PASS_CANDIDATE_G3C_BLOCKSY_WEDDING_PRODUCTIZATION

BLOCKSY_WEDDING=PASS
GUTENBERG=PASS
KNOWN_LOGO_404S_RESOLVED=PASS

GOOD_ISSUE_PREVIEW_INTEGRATED=PASS
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0

WOOCOMMERCE_PATH=PASS
USD_39_99=PASS
ACCOUNT_PRIVATE_REGRESSION=PASS

DESKTOP_UI=PASS
MOBILE_375_UI=PASS

OWNER_ROLE=ADMINISTRATOR
OWNER_GUTENBERG_EDIT_ACCESS=PASS
G3C_RUNTIME_RETAINED_FOR_OWNER_REVIEW=YES

PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
PRODUCTION_AI_CALLS=0
SHARED_INFRA_MUTATIONS=0

OWNER_VISUAL_FREEZE=PENDING
STOP_AT_REVIEWER=YES
```

Return local URLs and the local-only password reset command/template.

## 15. RETURN

Use the narrowest:

```text
RETURN_PREFLIGHT_DRIFT
RETURN_BLOCKSY_WEDDING_IMPORT_FAILED
RETURN_KNOWN_LOGO_ASSET_REPAIR_FAILED
RETURN_GOOD_ISSUE_PREVIEW_INTEGRATION_FAILED
RETURN_FREE_PREVIEW_NETWORK_UPLOAD_REGRESSION
RETURN_FREE_PREVIEW_MODEL_CALL_REGRESSION
RETURN_WOOCOMMERCE_PATH_REGRESSION
RETURN_PRIVATE_ACCESS_REGRESSION
RETURN_OWNER_GUTENBERG_EDIT_ACCESS_FAILED
RETURN_TEST_FAILURE
```

Do not switch themes/builders or enter G4 to work around a RETURN.
