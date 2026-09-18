# Mini Craft Night Kit — PROJECT RECORD

Last updated: 2026-09-18

## Current Truth

```text
STRATEGIC_PIVOT_TO_KADENCE_SINGLE_PRODUCT=APPROVED
OLD_19_PAGE_HIGH_FIDELITY_ROUTE=PAUSED
OLD_PROJECT=KEEP
MANUAL_06_19_REBUILD=STOP

UI_GROWTH_PRE_REVIEW=APPROVED
CLONE_UI_ROLE=VISUAL_ASSIST_ONLY
MINIMAL_PLUGIN_POLICY=APPROVED
CANONICAL_COMMERCE_SYSTEM=WOOCOMMERCE
MVP_PAYMENT=WOOCOMMERCE_PAYPAL_PAYMENTS
DUJIAO_SECOND_ORDER_SYSTEM=NO
GITHUB_HANDOFF_PROTOCOL=TRIAL_APPROVED

K0_KADENCE_SINGLE_PRODUCT_LOCAL_POC=PASS
K0R1_LOCAL_PROJECT_HYGIENE_CLEANUP=PASS
K0R2_WORDPRESS_STUDIO_CONSOLIDATION=PASS
CURRENT_GATE=K1A_VISUAL_DIRECTION_AND_GROWTH_MAPPING
K1_STATUS=SPLIT_K1A_K1B
WORDPRESS_STUDIO_CONSOLIDATION=PASS
VPS=DEFERRED
PRODUCTION_PAYMENT=DEFERRED

GITHUB_HANDOFF_TRIAL_SUCCESS_COUNT=2
GITHUB_HANDOFF_TARGET_FOR_GLOBAL_GOVERNANCE=3
```

## Why the route changed

旧路线从 CrossBorder / Medusa 视觉参考出发，手工迁移到 Gutenberg 并计划逐页复刻 01–19。

旧路线已完成：
- 01 Home：高保真 PASS；
- 02–05：高保真 PASS。

随后发现：
- Gutenberg Invalid Block；
- 超宽屏 / zoom-out 响应式迁移不完整；
- 继续实现 06–19 会重复建设 WooCommerce 已有能力。

因此转为成熟 WordPress 电商路线。

## New Architecture

```text
WordPress
→ Kadence Theme
→ Kadence Blocks
→ Kadence Single Product Starter Template
→ WooCommerce
→ Minimal Brand Adaptation
→ WooCommerce PayPal Payments
→ Conversion / Trust
→ RC QA
→ VPS
→ Production Canary
```

## Gate Status

### K0 — Kadence Local PoC — PASS

Verified:
- exact Single Product full-site import;
- Home / Product / Cart / Checkout runtime;
- Gutenberg valid, invalid block count 0;
- WooCommerce baseline;
- mobile/tablet/desktop/ultra-wide responsive baseline;
- old project unchanged;
- no brand customization;
- no payment;
- no VPS.

Formal Reviewer decision:
- `docs/REVIEWER_DECISION_K0_PASS.md`

### K0R1 — Local Project Hygiene Cleanup — PASS

Verified:
- five K0-generated WooCommerce download/extraction artifacts removed;
- shared workspace root no longer contains K0 temporary artifacts;
- project root remains clean;
- Home / Product / Cart / Checkout remain healthy;
- old project unchanged;
- unrelated projects untouched;
- no Docker volume deletion;
- no payment;
- no VPS.

Formal Reviewer decision:
- `docs/REVIEWER_DECISION_K0R1_PASS.md`

### Responsive baseline correction

The earlier K0 375px mobile PASS subclaim is superseded by K0R2 evidence. Current truth:

```text
K0_FUNCTIONAL_BASELINE=PASS
K0_MOBILE_375_VISUAL_BASELINE=KNOWN_DEFECT
K1_MUST_FIX_MOBILE_375=YES
```

The defect reproduces on both Docker source and Studio import, so it is not a Studio migration regression.

Formal Reviewer decision:
- `docs/REVIEWER_DECISION_K0R2_RECONCILED_PASS.md`

### Owner Studio migration review — PASS

Owner confirmed the Studio-managed site opens normally and is accepted as the active local development base.

### Current Gate — K1 UI/Growth Decision + Brand Adaptation

Owner should inspect the Studio-managed `Mini Craft Night Kit` site

At minimum:
- Home
- Product
- Cart
- Checkout

K1 is now approved to execute. The inherited 375px mobile clipping fix is mandatory within K1.

### K1 — UI/Growth Decision + Brand Adaptation

If Owner chooses USE:

Owner + Reviewer + Growth/Acquisition Framework first confirm:
- Offer hierarchy;
- Hero;
- CTA;
- Trust;
- KEEP / ADAPT / DROP;
- required product facts;
- visual adaptation boundary.

Only then Executor implements.

### K2 — WooCommerce Commerce Loop
Product → Cart → Checkout → Order → Confirmation.

### K3 — Payment
MVP fixed as WooCommerce + WooCommerce PayPal Payments.

Dujiao is not a second canonical order system.

### K4 — Conversion & Trust
Home / Product / FAQ / Shipping & Returns / Contact.

### K5 — Release Candidate QA
Responsive, Gutenberg validity, WooCommerce, email, SEO, performance, Secret hygiene.

### K6 — VPS Deployment
Only after local RC PASS.

### K7 — Production Canary
Low-value real order → payment → state → email → refund/cancel → launch.

## UI Governance

clone-ui is visual-assist only.

UI PASS requires:

```text
VISUAL_FIDELITY=PASS
GUTENBERG_VALIDITY=PASS
RESPONSIVE=PASS
WOOCOMMERCE_BEHAVIOR=PASS
OWNER_EDITABILITY=PASS
BUSINESS_TRUTH=PASS
```

## Plugin Policy

K0 baseline:
- Kadence Theme
- Kadence Blocks
- Starter Templates
- WooCommerce

Future plugins are added only when a current MVP capability requires them.

## GitHub Handoff

Reviewer owns:
- `PROJECT_RECORD.md`
- `REVIEWER_HANDOFF.md`
- Reviewer Decision docs

Executor owns:
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`
- bounded evidence indexes

Trial status:

```text
SUCCESSFUL_GATES=2
TARGET=3
```

After at least 3 stable Gates, open a Governance Change Gate before promoting this protocol globally.

Candidate Governance rule now validated twice:
- project-generated downloads, extraction directories, helper files, caches, and temporary artifacts must remain inside the project directory or be removed before PASS_CANDIDATE;
- shared workspace roots must not be polluted by project execution.

## Current Documents

- `docs/PROJECT_PLAN_AND_ROADMAP.md`
- `docs/UI_GROWTH_AND_FIDELITY_DECISION.md`
- `docs/PLUGIN_AND_OPERATIONS_PLAN.md`
- `docs/PAYMENT_ARCHITECTURE_DECISION.md`
- `docs/GITHUB_HANDOFF_PROTOCOL.md`
- `docs/REVIEWER_DECISION_K0_PASS.md`
- `docs/REVIEWER_DECISION_K0R1_PROJECT_HYGIENE_RETURN.md`
- `docs/REVIEWER_DECISION_K0R1_PASS.md`

## Current Next Action

Current Gate:

`K1_UI_GROWTH_DECISION_AND_BRAND_ADAPTATION`

Formal decision:
- `docs/REVIEWER_DECISION_K1_UI_GROWTH_BRAND_ADAPTATION.md`

WordPress Studio is the active local development base. Docker PoC remains rollback only. K1 must perform minimal Mini Craft brand/growth adaptation and fix the inherited 375px clipping.


## K1 Split

K1 is now split into:

- K1A: Visual Direction + Growth Mapping
- K1B: WordPress implementation after Owner visual approval

Formal decision: `docs/REVIEWER_DECISION_K1A_VISUAL_DIRECTION.md`.
