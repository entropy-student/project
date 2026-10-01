# G3CR6R1 — Frontend Composition Redesign

## Status

**CURRENT / REVIEWER OPENED / OWNER CHANGE REQUEST ACTIVE**

Parent:
- G3CR6 = RETURN — visual direction underexecuted
- G3CR4 / G3CR5 technical evidence remains accepted at its tested scope
- PR #64 remains open/unmerged
- Owner visual freeze = PENDING
- G4 = HOLD / NOT AUTHORIZED

## Purpose

Rebuild the **customer-facing composition** so the site actually expresses the selected **Option 2 — Warm Birthday Gift** direction instead of re-skinning the prior G3CR4/G3CR5 layout.

This is a frontend composition correction, not a backend rewrite.

## Core rule

**Do not optimize for preserving the previous six-section Gutenberg structure or the old `g3cr4-*` composition.**

Preserve the customer information and behavioral contracts, not the old visual skeleton.

The previous six top-level groups may be replaced, merged, split, reordered or rebuilt.

## Required customer journey

The redesigned homepage must still make this path obvious:

1. this is a personalized birthday gift;
2. the product is a birthday magazine made about one person;
3. show compelling sample magazine outcomes;
4. let the visitor experience the Free Preview quickly;
5. explain what the complete 12-page product includes;
6. explain the purchase / private-workspace flow;
7. present the USD 39.99 complete product;
8. answer trust / privacy / scope questions;
9. hand off into the native WooCommerce purchase path.

Section count is not frozen.

## Visual direction

Primary:
**Option 2 — Warm Birthday Gift**

Target:
- warm, premium, emotional;
- editorial magazine, not generic ecommerce;
- human/photo-led;
- cream / warm-white base;
- coral action color;
- elegant editorial typography;
- magazine mockup is the primary product visual;
- flowers / gift boxes / cards are supporting atmosphere only;
- consumer gift brand, not SaaS;
- no default WordPress/Woo feeling;
- no heavy scrapbook overload.

The current G3CR6 generated assets may be reused if they support the redesign. Generate additional visual assets only when they materially improve the finished composition.

## Frontend freedom — explicitly open

The Executor may redesign:

- header composition;
- Hero layout and visual hierarchy;
- sample-magazine layout;
- supporting value/trust strip;
- Free Preview location, frame and surrounding composition;
- upload / replace / remove UI;
- preview empty and photo-selected states;
- What's Included presentation;
- How It Works presentation;
- Offer / price presentation;
- FAQ composition;
- footer presentation;
- Product frontend composition;
- Cart frontend composition;
- Checkout frontend composition;
- My Account frontend composition;
- desktop/mobile hierarchy.

The Executor may create new semantic classes/components instead of preserving `g3cr4-*` naming.

## Required composition changes

A PASS_CANDIDATE must demonstrate more than a CSS recolor / image swap.

At minimum:

### Hero
- must no longer look like the prior generic text-left/image-right template block;
- should use a more intentional gift-editorial composition;
- magazine remains the dominant product visual;
- primary CTA must be immediately obvious.

### Samples
- must no longer read as a generic three-card portfolio grid;
- use scale, overlap, editorial rhythm, asymmetry or other controlled composition appropriate to the selected direction;
- sample/fictitious status remains clear enough not to imply real customer proof.

### Free Preview
- must become a visual focal point / primary Aha;
- upload UI may be rebuilt;
- empty state and selected-photo state must both feel designed as part of the brand, not as an embedded utility panel;
- choose / replace / remove / invalid-file feedback should remain usable.

### What's Included / How It Works
- avoid default four-column text-grid appearance;
- use visual grouping / editorial layout appropriate to the gift product;
- do not invent unsupported product benefits.

### Offer / FAQ
- paid transition should feel like a gift-product conclusion, not a generic CTA card next to accordion content;
- USD 39.99 and 12-page digital product scope remain accurate.

### Woo routes
- Product / Cart / Checkout / My Account must retain native Woo behavior;
- improve composition and brand continuity beyond simple recoloring where safely possible;
- do not replace native Woo forms/actions/nonces/endpoints;
- no fake checkout or parallel cart.

### Footer
- remove generic theme/vendor attribution from the customer-facing experience if it can be done through supported theme/footer settings or project-local presentation code without licensing circumvention;
- keep only accurate brand/navigation/legal presentation.

## Protected backend layer

Do not replace or redesign without a new Reviewer Gate:

- WooCommerce canonical cart / checkout / order data logic;
- payment gateway implementation;
- checkout server semantics;
- order status machine;
- account authorization;
- private-workspace ownership;
- entitlement / generation-job semantics;
- database schema;
- production AI/provider;
- shared infrastructure.

## Free Preview contract

Frontend implementation may change, but all must still hold:

```text
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0
```

Selected images stay browser-local.

## Owner editability

The redesigned Home must remain reasonably Owner-editable in WordPress.

Required:

```text
OWNER_ROLE=ADMINISTRATOR
OWNER_CAN_EDIT_HOME=YES
OWNER_CAN_REPLACE_IMAGES=YES
OWNER_CAN_EDIT_COPY=YES
OWNER_CAN_REORDER_MAJOR_SECTIONS=YES
OWNER_CAN_EDIT_GLOBAL_STYLE=YES
```

Do not turn the full homepage into one opaque hard-coded PHP/HTML blob.

Project-local frontend components/shortcodes are acceptable for interaction-heavy elements such as Free Preview, provided the surrounding page remains editable.

## Execution sequence

1. fresh read-back PR #64 and current runtime;
2. create scoped rollback point from current G3CR6 state;
3. inspect which old structural CSS/classes are actually constraining the design;
4. redesign page composition rather than layering another skin over the old composition;
5. preserve / improve Preview interaction;
6. improve Woo frontend composition without replacing native behavior;
7. desktop + 375px regression;
8. privacy/network regression;
9. Owner editability regression;
10. submit complete evidence and stop at Reviewer.

## Required visual evidence

At minimum:

- desktop full Home;
- desktop Hero;
- desktop Samples;
- desktop Preview empty;
- desktop Preview with photo;
- desktop What's Included / How It Works;
- desktop Offer / FAQ / footer;
- mobile 375 full Home;
- mobile Hero;
- mobile Samples;
- mobile Preview empty;
- mobile Preview with photo;
- mobile paid transition / footer;
- desktop + mobile Product;
- desktop + mobile Cart;
- desktop + mobile Checkout;
- desktop + mobile My Account.

The screenshots must show the actual rendered runtime state at final head.

## Required machine/regression evidence

- browser-local preview object URL behavior;
- 0 server photo uploads;
- 0 external image POSTs;
- 0 model-provider requests for Free Preview;
- choose / replace / remove / invalid file behavior;
- native Add to Cart;
- Cart state;
- Checkout load without submission;
- My Account load;
- product remains USD 39.99 virtual;
- order count unchanged by browser regression;
- protected backend file hashes/read-back;
- Owner Gutenberg/media/global-style capabilities;
- 375px document-width / blocking-overflow checks.

## Forbidden

```text
PR_MERGE=0
THEME_CHANGE=0
BUILDER_CHANGE=0
ELEMENTOR_INSTALL=0
PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
CHECKOUT_SUBMISSIONS=0
PRODUCTION_AI_CALLS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
PAID_PURCHASES=0
GLOBAL_DOCKER_PRUNE=0
G4_ACTIONS=0
```

## Return contract

Return exactly one:

`PASS_CANDIDATE_G3CR6R1_FRONTEND_COMPOSITION_REDESIGN`

or:

`RETURN_G3CR6R1_<CONCRETE_REASON>`

Include:

- branch;
- pre-run head;
- final head;
- PR #64 state;
- rollback path;
- structural/frontend changes;
- old structural constraints removed or intentionally retained;
- frontend behaviors changed;
- protected backend confirmation;
- generated/adopted asset list;
- screenshot directory;
- machine report;
- local site URL;
- wp-admin URL;
- forbidden-action counters;
- `OWNER_VISUAL_FREEZE=PENDING`;
- `STOP_AT_REVIEWER=YES`.
