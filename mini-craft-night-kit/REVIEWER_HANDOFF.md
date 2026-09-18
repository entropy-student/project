# Mini Craft Night Kit — REVIEWER HANDOFF

Last reviewed: 2026-09-18  
Maintainer: Reviewer

## Reviewer Decision

```text
STRATEGIC_PIVOT_TO_KADENCE_SINGLE_PRODUCT=APPROVED
OLD_19_PAGE_HIGH_FIDELITY_ROUTE=PAUSED
OLD_PROJECT=KEEP
MANUAL_06_19_REBUILD=STOP
CURRENT_GATE=K0_KADENCE_SINGLE_PRODUCT_LOCAL_POC
NEXT_OWNER_CHECKPOINT=REVIEW_IMPORTED_TEMPLATE
VPS=DEFERRED
PRODUCTION_PAYMENT=DEFERRED
```

## Current Gate — K0_KADENCE_SINGLE_PRODUCT_LOCAL_POC

Goal:

在不修改旧 mini-craft-night-kit 项目的前提下，新建独立本地 WordPress PoC，完整导入 Kadence Single Product Starter Template，验证其原生 UI、Gutenberg、WooCommerce 和响应式基线。

### Required

- 独立本地 WordPress 实例；
- Kadence Theme；
- Kadence Blocks；
- Starter Templates 所需免费组件；
- Single Product 完整导入；
- WooCommerce 基线；
- Home / Product / Cart / Checkout 验证；
- mobile / tablet / desktop 验证；
- Gutenberg 编辑器正常；
- 旧项目不变；
- 不做品牌改造；
- 不接正式支付；
- 不部署 VPS。

### PASS Candidate

```text
PASS_CANDIDATE_K0_KADENCE_SINGLE_PRODUCT_LOCAL_POC
KADENCE_SINGLE_PRODUCT_IMPORTED=PASS
FRONTEND_RUNTIME=PASS
GUTENBERG_EDITOR=PASS
WOOCOMMERCE_BASELINE=PASS
MOBILE_RESPONSIVE=PASS
TABLET_RESPONSIVE=PASS
DESKTOP_RESPONSIVE=PASS
OLD_PROJECT_UNCHANGED=PASS
COMMERCE_CUSTOM_BUILD=NO
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
STOP_AT_REVIEWER=YES
```

## Current Execution / Review Protocol

### Before K1
Owner must review the real imported template.

Then Reviewer + Growth/Acquisition framework define:
- KEEP / ADAPT / DROP sections;
- Offer hierarchy;
- Hero;
- CTA;
- trust proof;
- required product facts;
- visual adaptation boundary.

Executor may not invent the conversion architecture.

### UI fidelity
clone-ui may be used only after the target UI has been approved.

A visual clone is not accepted unless these also pass:

```text
GUTENBERG_VALIDITY
RESPONSIVE
WOOCOMMERCE_BEHAVIOR
OWNER_EDITABILITY
BUSINESS_TRUTH
```

No visual parity fix may break WordPress block validity, responsive behavior or WooCommerce behavior.

## Payment Decision Deferred

Do not select a payment architecture inside K0.

Candidate paths:
1. WooCommerce + official PayPal Payments;
2. WooCommerce + Shared Payment Layer via a WooCommerce gateway adapter;
3. WordPress marketing front end → Dujiao checkout / order handoff.

Reviewer must compare them after the WooCommerce PoC exists. Do not run two canonical order systems without an explicit architecture decision.

## GitHub Operating Model — Trial

Reviewer-owned:
- `REVIEWER_HANDOFF.md`
- Reviewer decisions
- `PROJECT_RECORD.md` truth updates

Executor-owned:
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`
- bounded manifests/evidence indexes

Chat response should normally be short:
> 已完成，可查阅 `mini-craft-night-kit/EXECUTION_EVIDENCE.md` 与 `EXECUTOR_HANDOFF.md`。

If this handoff mechanism runs reliably across several Gates, propose adding it to the global Governance specification.
