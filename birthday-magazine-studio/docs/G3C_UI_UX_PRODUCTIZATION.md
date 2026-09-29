# G3C — UI/UX Productization + Owner Visual Freeze

> Governance: VPS Project Governance v0.1.6 + current active addenda  
> Reviewer status: **CURRENT GATE / TEMPLATE SELECTION OPEN — IMPLEMENTATION NOT YET AUTHORIZED**  
> Opened: 2026-09-29  
> Production / Live payment authority: **NONE**

## 1. Goal

First select a concrete free/open-source-compatible WordPress starter template, then turn the accepted Birthday Magazine MVP into a WordPress-visible product experience that the Owner can review visually before UI freeze.

The accepted route remains hybrid, but the starter shell is **not yet selected**:

- **Concrete starter template: OPEN / requires Owner selection after research**;
- **Good Issue-style browser-local Free Preview** = accepted custom core conversion interaction;
- **WooCommerce** = canonical product/cart/checkout/account system;
- existing G3A/G3B payment/account/private-workspace boundaries must not be weakened.

This Gate is productization, not production deployment.

## 2. Required outcome

Produce a local/disposable WordPress implementation that visibly demonstrates:

1. a coherent Birthday Magazine product page using the selected Kadence shell;
2. the Good Issue Free Preview embedded as the central conversion component;
3. desktop and 375px mobile behavior;
4. CTA continuity into the existing WooCommerce product/cart path;
5. no pre-payment model/API invocation;
6. no preview-photo upload to the server before payment;
7. no regression of the authenticated-account/private-workspace product contract;
8. screenshots and a reproducible local read-back suitable for Owner visual review.

Technical completion ends at **PASS_CANDIDATE**. Final visual freeze requires explicit Owner review/approval.

## 3. Preflight

Before any write:

- read current `REVIEWER_HANDOFF.md`, this contract, `MVP_PRODUCT_CONTRACT.md`, and accepted G3A/G3B decisions;
- verify current repository files/branch and record the exact baseline;
- confirm no G4 Live payment authorization exists;
- confirm no production target or Shared VPS write is in scope;
- classify any reusable local G3A/G3B runtime artifact before reuse;
- if a local WordPress runtime is reconstructed, keep it project-scoped and disposable;
- use only synthetic fixtures/test accounts;
- record disk/Docker baseline when Docker is used.

Material drift in the accepted product/payment/privacy contract must return to Reviewer before implementation.

## 4. Allowed scope

Before Owner template selection, Executor may perform **research/read-only comparison only**. After explicit Owner selection and Reviewer implementation authorization, Executor may:

- create or reconstruct an isolated local WordPress + WooCommerce runtime;
- install/activate the selected free theme/starter template and only its required free/open-source dependencies;
- implement project-local WordPress code/CSS/blocks/shortcodes needed to integrate the Good Issue preview;
- adapt Header/Footer, typography, spacing, product sections, trust/FAQ/testimonial/sample sections and responsive layout;
- reuse synthetic G2A/G3 fixtures where appropriate;
- use local test customer/account/order fixtures only when required for regression;
- capture sanitized screenshots and deterministic browser/network evidence;
- add/update project-local source, Evidence and Executor Handoff;
- clean up only exact project-scoped disposable runtime objects after evidence capture.

## 5. Forbidden scope

Executor must not:

- enable PayPal Live or perform a real-money transaction/refund;
- rotate/enter/export Provider Secrets;
- start G4, G5 or G6;
- deploy to production or a Shared VPS;
- modify Shared Infrastructure, Caddy, Cloudflare production routing, SSH, firewall or host 80/443;
- use real customer photos, identity data, email or order data;
- call a production AI/LLM/vision/image provider;
- introduce model calls into the free preview;
- replace WooCommerce as the canonical order system;
- replace the authenticated-account MVP access model with guest bearer links;
- purchase paid themes/plugins/services;
- use broad Docker/system prune.

If any forbidden dependency becomes necessary, stop with a precise `RETURN_*`.

## 6. Non-regression invariants

The implementation must preserve:

```text
FREE_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
WOO_COMMERCE_CANONICAL_ORDER_SYSTEM=YES
AUTHENTICATED_ACCOUNT_MVP=YES
GUEST_BEARER_PRIVATE_DELIVERY=NO
LIVE_PAYPAL_ACTIONS=0
REAL_MONEY_ACTIONS=0
PRODUCTION_DEPLOYMENT=0
SHARED_INFRA_MUTATIONS=0
```

The free preview may use browser-local `blob:`/equivalent local object URLs, but selecting a preview image must not POST/upload that image to WordPress or another origin.

## 7. Acceptance criteria

Technical evidence must show:

- the Owner-selected concrete starter shell is actually active in the local WordPress runtime;
- the Birthday Magazine product page renders successfully on desktop and 375px mobile;
- Good Issue preview is visibly integrated in the product page, not replaced by a static mock;
- selecting the synthetic preview image results in browser-local rendering and **zero photo upload/network POST caused by selection**;
- preview flow makes **zero model/API calls**;
- CTA reaches the intended WooCommerce product/cart/checkout path without introducing a second commerce system;
- key page sections and responsive layout have no material overflow/fatal error;
- any account/private-workspace regression probe used remains owner-bound and denies unrelated access as defined by the accepted MVP contract;
- screenshots/evidence use only synthetic/redacted data;
- project-local cleanup and resource delta are recorded;
- G4/Live/production mutations remain zero.

## 8. Owner visual checkpoint

After technical `PASS_CANDIDATE_G3C_UI_UX_PRODUCTIZATION`:

- present the actual page/screenshots to the Owner;
- Owner may request visual/copy/layout changes without reopening G1–G3B;
- technical security/payment/privacy invariants remain fixed while subjective UI is iterated;
- only explicit Owner visual acceptance allows Reviewer to freeze G3C.

Owner is not asked to inspect logs or decide technical correctness.

## 9. Rollback

- source/document rollback: Git history;
- local WordPress/Docker runtime: disposable project-scoped teardown only;
- no production state exists to roll back;
- preserve only reviewed source/evidence needed to reproduce the G3C result;
- never delete shared Docker/network/image resources by broad cleanup.

## 10. Executor return

Success:

```text
PASS_CANDIDATE_G3C_UI_UX_PRODUCTIZATION
OWNER_VISUAL_FREEZE=PENDING
STOP_AT_REVIEWER: YES
```

Examples of precise failure:

```text
RETURN_PREFLIGHT_DRIFT
RETURN_KADENCE_SHELL_IMPORT_FAILED
RETURN_FREE_PREVIEW_NETWORK_UPLOAD_REGRESSION
RETURN_FREE_PREVIEW_MODEL_CALL_REGRESSION
RETURN_WOOCOMMERCE_PATH_REGRESSION
RETURN_PRIVATE_ACCESS_REGRESSION
RETURN_TEST_FAILURE
```

Do not enter G4 after technical success. Stop at Reviewer/Owner visual checkpoint.
