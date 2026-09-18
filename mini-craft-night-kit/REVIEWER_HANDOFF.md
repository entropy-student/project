# Mini Craft Night Kit — REVIEWER HANDOFF

Last reviewed: 2026-09-18  
Maintainer: Reviewer

## Reviewer Decision

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

## Before K1

Owner must review the real imported template.

Then Reviewer + Growth/Acquisition Framework must produce approved UI Decision:
- KEEP / ADAPT / DROP；
- Offer hierarchy；
- Hero；
- CTA；
- trust proof；
- required product facts；
- visual adaptation boundary。

Executor may not invent conversion architecture.

## Fidelity Rule

clone-ui may be used only after target UI is approved.

A visual clone is not accepted unless these also pass:

```text
GUTENBERG_VALIDITY
RESPONSIVE
WOOCOMMERCE_BEHAVIOR
OWNER_EDITABILITY
BUSINESS_TRUTH
```

## Payment Decision

Project-specific architecture change approved:

```text
WooCommerce = canonical commerce/order system
WooCommerce PayPal Payments = MVP payment
Dujiao second canonical order system = NO
```

Long-term Shared Payment integration is deferred until real business evidence justifies a WooCommerce gateway adapter.

## GitHub Operating Model — Trial

Reviewer-owned:
- `PROJECT_RECORD.md`
- `REVIEWER_HANDOFF.md`
- Reviewer Decision docs

Executor-owned:
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`
- bounded evidence indexes

Chat response should normally be short:
> 已完成，可查阅对应 GitHub 文档。

After at least 3 stable Gates, propose Governance Change Gate to adopt this globally.

## Related Docs

- `docs/PROJECT_PLAN_AND_ROADMAP.md`
- `docs/UI_GROWTH_AND_FIDELITY_DECISION.md`
- `docs/PLUGIN_AND_OPERATIONS_PLAN.md`
- `docs/PAYMENT_ARCHITECTURE_DECISION.md`
- `docs/GITHUB_HANDOFF_PROTOCOL.md`
