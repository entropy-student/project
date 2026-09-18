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
CURRENT_CHECKPOINT=OWNER_REVIEW_IMPORTED_TEMPLATE
K1_NOT_ENTERED=YES
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

### Current checkpoint — Owner template review

Owner should inspect:

`http://localhost:8090`

At minimum:
- Home
- Product
- Cart
- Checkout

No K1 implementation starts until Owner chooses USE / RETURN.

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

Owner reviews the imported Kadence site at:

`http://localhost:8090`

No Executor action is currently authorized beyond K0R1.
