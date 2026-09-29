# G3C Execution Packet — Astra Bestselling Author + Good Issue Preview

> Project: Birthday Magazine Studio  
> Gate: G3C UI/UX Productization + Owner Visual Freeze  
> Governance: VPS Project Governance v0.1.6 + current active addenda  
> Status: **AUTHORIZED FOR PROJECT-LOCAL / REVERSIBLE EXECUTION**  
> G4 Live / real-money authority: **NONE**

## 1. Read order

Executor must read, in order:

1. `../REVIEWER_HANDOFF.md`
2. `G3C_UI_UX_PRODUCTIZATION.md`
3. `OWNER_DECISION_G3C_ASTRA_BESTSELLING_AUTHOR.md`
4. `MVP_PRODUCT_CONTRACT.md`
5. `REVIEWER_DECISION_G3A_PASS.md`
6. `REVIEWER_DECISION_G3BR1_G3B_PASS.md`
7. this packet
8. only then the reusable source trees listed below

Do not infer current authority from README/history/chat.

## 2. Frozen implementation route

G3C is **not** a new architecture exercise.

Use:

```text
G3A local WordPress/WooCommerce baseline
+
Astra Theme
+
Astra Starter Templates / concrete free "Bestselling Author" starter
+
G2A1 Good Issue browser-local preview
+
G3A commerce/private-workspace plugin
=
G3C local productized WordPress page
```

No alternative theme/starter may be substituted without Reviewer RETURN.

## 3. Exact reusable source map

### Reuse as baseline

From `poc/g3a/`:

- `compose.yaml`
- `scripts/bootstrap-g3a.cjs`
- `scripts/configure-g3a.cjs`
- `scripts/verify-g3a.cjs`
- `commerce-workspace-plugin/bms-g3a-commerce-loop.php`
- Mailpit helper only if required for account regression
- existing synthetic product/account conventions

These are the accepted G3A commerce/account/private-workspace baseline.

### Reuse as preview core

From `poc/g2a1/preview-plugin/`:

- `birthday-magazine-poc.php`
- `preview.js`
- `preview.css`
- `routes.css`

These implement the accepted Good Issue-style browser-local preview behavior.

The Executor may refactor/copy them into a G3C-specific plugin/module only if behavior is preserved and the diff is explicit.

### Reference only

From `poc/g3b/`:

- provider/payment code and scripts are **reference only**
- do not start PayPal Sandbox
- do not import provider credentials
- do not execute refund/payment/callback tests
- do not treat G3B runtime as the G3C implementation base if that would activate PPCP

## 4. New G3C source layout

Create a project-local subtree:

```text
birthday-magazine-studio/poc/g3c/
├── README.md
├── compose.yaml
├── scripts/
│   ├── bootstrap-g3c.*
│   ├── configure-g3c.*
│   └── verify-g3c.*
├── preview-plugin/          # G2A1-derived, explicit diff
├── commerce-workspace-plugin/ # G3A-derived only if needed
├── theme-overrides/         # project-local CSS/child-theme/block patterns if required
└── artifacts/
    ├── screenshots/
    └── reports/
```

Do not edit the historical G2A1/G3A/G3B evidence source in place merely to make G3C work.

## 5. Preflight before first write

Record:

```text
GIT_BASELINE=<exact commit>
G3A_ACCEPTED_BASELINE_READ=YES
G2A1_PREVIEW_BASELINE_READ=YES
G3B_LIVE_OR_SANDBOX_STARTED=NO
DOCKER_BASELINE_RECORDED=YES/NO
PROJECT_PORT_COLLISION=NO
UNRELATED_DOCKER_RESOURCES_CLASSIFIED=YES
PRODUCTION_TARGET=NONE
SHARED_VPS_WRITE=NO
```

If an existing local G3A/G3B runtime is found:

- classify it before reuse;
- never assume it is disposable;
- do not delete unknown containers/volumes;
- prefer a new G3C Compose project name and isolated ports.

Any material drift in the accepted product/account/privacy contract => `RETURN_PREFLIGHT_DRIFT`.

## 6. WordPress/theme installation

Required:

1. isolated local WordPress + MariaDB + WooCommerce;
2. activate **Astra**;
3. install only the free/open-source dependencies required to import the concrete **Bestselling Author** starter;
4. import the concrete Bestselling Author starter;
5. record exact versions of:
   - WordPress
   - WooCommerce
   - Astra
   - Starter Templates/importer
   - additional required free plugins
6. no paid Astra Pro / Spectra Pro / Elementor Pro / commercial add-on purchase.

If the exact starter has changed upstream or now requires paid-only components, stop with:

`RETURN_ASTRA_BESTSELLING_AUTHOR_FREE_IMPORT_UNAVAILABLE`

Do not silently replace it.

## 7. Birthday Magazine adaptation

The imported author/book site is a shell, not a content contract.

Replace irrelevant author semantics with the Birthday Magazine funnel.

Minimum page narrative:

### Hero
- personalized birthday magazine promise;
- concrete magazine/book-cover visual;
- primary CTA: **Create a Free Preview** or equivalent;
- secondary trust text explaining no design skill is required.

### Core Preview
Embed the real Good Issue browser-local preview interaction.

It must not be replaced by:
- a screenshot;
- a static fake editor;
- server-upload-first media block;
- AI-generated preview.

### How it works
A simple 3-step story:
1. upload/select photos + answer questions;
2. preview the concept;
3. purchase and receive the personalized PDF.

Do not claim production AI/final delivery capabilities beyond what the current project has proven.

### What is inside
Explain the 12-page concept using the frozen MVP contract.

### Trust / proof
May use synthetic/sample evidence only.
No fabricated customer reviews or transaction counts.

### Offer / CTA
- USD 39.99 remains the frozen test price;
- CTA must enter the native WooCommerce product/cart/checkout path;
- no second cart/order system.

### FAQ / privacy
Include clear statements consistent with the MVP contract, especially:
- account-required private workspace;
- preview photo local-browser behavior;
- digital PDF;
- current revision boundary;
- retention promises only where already frozen/provable.

## 8. Design rule

Preserve the useful visual language of Bestselling Author:

- editorial/book-like hierarchy;
- large cover-focused hero;
- generous whitespace;
- publication storytelling rhythm;
- strong sample/preview CTA.

Remove or rewrite:

- author biography framing;
- book-tour/events;
- multiple-book catalog semantics;
- signed-copy framing;
- irrelevant publishing badges.

The target should feel like a **personalized editorial gift product**, not a generic WooCommerce store and not an author portfolio.

## 9. Core technical invariants

Must remain:

```text
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0
WOO_COMMERCE_CANONICAL_ORDER_SYSTEM=YES
USD_39_99_PRODUCT_PATH=YES
AUTHENTICATED_ACCOUNT_MVP=YES
GUEST_BEARER_PRIVATE_DELIVERY=NO
LIVE_PAYPAL_ACTIONS=0
SANDBOX_PAYMENT_ACTIONS=0
REAL_MONEY_ACTIONS=0
PRODUCTION_AI_CALLS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
```

## 10. Browser/network verification

Verify at minimum:

### Desktop
- hero;
- core preview;
- CTA;
- product/cart/checkout continuity;
- FAQ/trust;
- no fatal/overflow.

### Mobile 375 px
Same sections; no horizontal overflow; CTA usable.

### Preview network proof
Using a synthetic local image:

- select image;
- preview updates;
- resulting image source is `blob:` or equivalent local object URL;
- no image bytes are POSTed/uploaded to WordPress or any external origin as a consequence of selection;
- no AI/model endpoint request occurs.

### WooCommerce continuity
- CTA enters canonical USD 39.99 WooCommerce path;
- no duplicate cart/order mechanism;
- checkout page renders;
- **do not submit a PayPal payment**.

### Account/private regression
Use only the minimum G3A regression necessary to confirm the shell did not break:
- authenticated account path remains available;
- unrelated account/guest cannot access another account's private workspace.
No payment is needed.

## 11. Required visual evidence

Retain sanitized screenshots at minimum:

```text
desktop-hero.png
desktop-preview.png
desktop-offer-faq.png
mobile-375-hero.png
mobile-375-preview.png
woo-product-or-cart.png
```

All screenshots must use synthetic/sample data.

If useful, add one full-page desktop screenshot, but do not rely on it instead of focused evidence.

## 12. Cleanup

After evidence capture:

- preserve G3C source and intended screenshots/reports;
- remove exact temporary caches/packages that are not required;
- local runtime may remain only if needed for immediate Owner visual review;
- if kept running, document exact project-scoped runtime state;
- no broad Docker prune;
- unrelated Docker resources untouched.

## 13. Evidence/Handoff

Append to:

- `../EXECUTION_EVIDENCE.md`
- `../EXECUTOR_HANDOFF.md`

Do not modify Reviewer decisions.

Evidence must include:

- exact dependency versions;
- imported starter identity;
- before/after resource state;
- network proof for browser-local preview;
- desktop/mobile screenshots;
- WooCommerce path proof;
- account/private regression;
- cleanup/read-back;
- forbidden-action counters.

## 14. Success return

```text
PASS_CANDIDATE_G3C_UI_UX_PRODUCTIZATION

ASTRA_THEME=PASS
BESTSELLING_AUTHOR_STARTER=PASS
GOOD_ISSUE_PREVIEW_INTEGRATED=PASS
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
WOO_COMMERCE_PATH=PASS
USD_39_99=PASS
DESKTOP_UI=PASS
MOBILE_375_UI=PASS
ACCOUNT_PRIVATE_REGRESSION=PASS
SANDBOX_PAYMENT_ACTIONS=0
REAL_MONEY_ACTIONS=0
PRODUCTION_AI_CALLS=0
SHARED_INFRA_MUTATIONS=0
OWNER_VISUAL_FREEZE=PENDING
STOP_AT_REVIEWER=YES
```

## 15. Precise RETURN outcomes

Use the narrowest applicable reason, including:

```text
RETURN_PREFLIGHT_DRIFT
RETURN_ASTRA_BESTSELLING_AUTHOR_FREE_IMPORT_UNAVAILABLE
RETURN_STARTER_DEPENDENCY_REQUIRES_PAID_COMPONENT
RETURN_STARTER_IMPORT_FAILED
RETURN_GOOD_ISSUE_PREVIEW_INTEGRATION_FAILED
RETURN_FREE_PREVIEW_NETWORK_UPLOAD_REGRESSION
RETURN_FREE_PREVIEW_MODEL_CALL_REGRESSION
RETURN_WOOCOMMERCE_PATH_REGRESSION
RETURN_PRIVATE_ACCESS_REGRESSION
RETURN_TEST_FAILURE
```

Do not switch themes or enter G4 to work around a RETURN.
