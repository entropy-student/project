# G3S0 — Stripe Account & Woo Gateway Readiness (Read-Only)

> Date: 2026-10-15
> Governance: vps-project-governance v0.2.7
> Payment specialist: section 11E, plus 11B/11C/11D as triggered by Secrets/runtime/auth
> Authoritative Owner decision: `docs/OWNER_DECISION_G3S_STRIPE_PRIMARY_PAYPAL_RETIREMENT_DEFERRED_2026-10-15.md`

## Gate

```text
GATE_ID=G3S0_STRIPE_ACCOUNT_AND_GATEWAY_READINESS
OBJECTIVE=Establish the exact minimal safe Stripe/Woo payment-integration plan and account/HTTPS prerequisites while preserving the accepted frontend and PayPal Sandbox baseline
MAX_ENDPOINT_THIS_ROUND=Read-only readiness findings + actionable Stripe test-only G3S1 implementation boundary; no plugin install/activation/provider login/payment mutation
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Birthday Magazine Studio current PR #64 + existing retained local WordPress/Woo runtime + official public Stripe/Woo requirements; no live/public mutation
APPLICABLE_CRITICAL_CONSTRAINTS=FRONTEND_VISUAL_FREEZE_YES; WOO_CANONICAL_YES; PAYPAL_DISABLE_UNINSTALL_0; PROVIDER_ACCOUNT_MUTATIONS_0; SECRET_EXPORT_0; STRIPE_PLUGIN_INSTALL_ACTIVATION_0; REAL_PAYMENT_0; SANDBOX_CAPTURE_REFUND_0; CHECKOUT_SUBMISSIONS_0; GENERATION_MODEL_CALLS_0; DB_WRITE_0; PRODUCTION_DEPLOY_0; VPS_SHARED_INFRA_WRITE_0; PR64_MERGE_0
ROLLBACK_STATUS_OR_PLAN=READ_ONLY; no business/runtime changes or rollback actions required. Retain current accepted local frontend and PayPal evidence.
OWNER_ONLY_ACTIONS=Stripe account registration/region/entity selection, KYC/KYB, dashboard/OAuth login, bank linkage and any actual provider consent; no account work in G3S0 unless Owner separately elects to do it.
```

## Why a preflight Gate

The user has authorized the **integration goal**, but current accepted state does not establish:
- whether a Stripe account exists today;
- where that account is or may lawfully be registered;
- merchant legal status / Stripe payment capability / settlement eligibility;
- whether a provider-safe test-only connection can be established from the retained local runtime;
- which exact Stripe plugin/auth/webhook environment is already present.

Do not assume a Wise HK receiving account establishes Stripe registration/payout eligibility.

If the account is not ready, avoid spending time on a faux checkout/payment integration that cannot be authenticated or completed.

## PREFLIGHT — inspect without mutation

1. Fresh-read current `main`, PR #64 head and project-scoped freshness. Report precise repo ref; no rebase/reset/merge.
2. Read only current relevant source/config for Woo checkout, official PPCP coexistence and project payment/entitlement adapter boundaries. Preserve accepted frontend visuals.
3. Local runtime read-only inspection:
   - WordPress/Woo version + PHP version;
   - active plugins, especially official PPCP and whether `woocommerce-gateway-stripe` or WooPayments already exists;
   - live vs sandbox/test enabled flags **without fetching token values**;
   - product 1113 USD 39.99 virtual;
   - current checkout page and existing Woo order state (metadata only; no real buyer info);
   - whether localhost site requires a temporary HTTPS origin for Stripe test callbacks, and what already-accepted safe reversible tunnel recipe is available;
   - local bind-mount/DB preservation boundaries.
4. Distinguish verified facts from `OWNER_REPORTED` and `UNKNOWN` for Stripe account existence, country, entity, verification, bank payout, payment methods. Do not inspect any authenticated Stripe session without Owner.
5. Inspect official Stripe/Woo documentation for version compatibility, test-only onboarding, HTTPS/webhook requirements, supported payment modes, documented refund behavior, and region-specific eligibility. Record source links and access date.
6. Identify test-only official plugin and minimum settings needed; compare official `woocommerce-gateway-stripe` vs WooPayments **only at decision level**, prefer official Stripe gateway absent a concrete blocker.
7. Identify exact owner-side auth checkpoints without initiating OAuth, KYC or bank onboarding.
8. Determine whether local Stripe testing can proceed:
   - `READY_FOR_TEST_ONLY_SETUP`;
   - `OWNER_STRIPE_TEST_ACCOUNT_AUTH_REQUIRED`;
   - `MERCHANT_ELIGIBILITY_UNRESOLVED`;
   - `HTTPS_WEBHOOK_TEST_ORIGIN_UNRESOLVED`;
   - `RETURN_PREFLIGHT_DRIFT`.
   The result must clearly separate **test-mode usability** from **real-money/payout readiness**.

## Stripe-specific next implementation contract (proposal only)

Prepare a bounded `G3S1` test-only implementation plan (do not execute it in G3S0):

- isolate or snapshot current accepted local runtime without destroying PayPal Sandbox proof;
- use official `WooCommerce Stripe Gateway` plugin and official supported test connection; never implement a second canonical checkout/order model;
- use Stripe **test mode** only; no production/Live activation or real money;
- owner completes any needed account/test-mode OAuth consent in provider-controlled UI; do not handle Secrets in chat, logs or Git;
- if required, use a temporary HTTPS webhook-compatible origin scoped to the local test environment with exact revert plan; do not publish admin/private workspace unintentionally;
- one explicitly bounded synthetic Stripe test checkout/capture only after the account/environment/provider correlation can be verified; fresh authorization required for any consequential Provider action per 11E;
- verify customer path and server-side order/payment correlation (environment/merchant/payment-intent/amount/currency); webhook signature authentic, retry/replay idempotent, no duplicate capture;
- verify **paid + incomplete intake => 0** jobs and **paid + exact submitted intake snapshot => <=1** canonical generation-ready job (without running a model);
- prove appropriate failure/3DS cancellation / delayed callback paths; separate authorization and capture states;
- refund is a distinct Owner-authorized checkpoint, including Woo initiated test refund, Stripe correlation, and entitlement revocation; do not imply a refund is authorized merely by this Gate;
- duplicate payment/provider side effects prevented even if a customer refreshes or retries;
- preserve the old PayPal route/test evidence throughout.
- Test-only success does not assert Stripe KYB/payout/live readiness.

Before payment-to-generation production wiring, finish temporary server-side pre-payment draft persistence. The Gate must avoid fabricating a complete draft/order linkage while it is currently browser-only.

## REQUIRED_EVIDENCE

- source/head and project-scoped freshness;
- local Woo/plugin inventory and payment gateway states (sanitized, no secrets);
- relevant official Stripe supported region / Woo extension and webhook source links;
- non-secret Stripe account readiness matrix distinguishing `UNKNOWN` from verified state;
- connection points for product 1113, Woo order/checkout, existing paid entitlement;
- compatibility / HTTPS origin / localhost constraints;
- narrow G3S1 implementation plan with Owner checkpoints, idempotency/refund criteria, rollback;
- absolute zeros for mutations, live payment, provider actions, install, real secrets and checkout;
- `STOP_AT_REVIEWER=YES`.

## ACCEPTANCE_CRITERIA

PASS_CANDIDATE if:
- all possible read-only readiness facts are documented, and unknowns clearly identified;
- official gateway path and test-only plan are directly actionable with no premature provider/cost mutation;
- no unfounded HK/Wise eligibility assertion is made;
- PayPal historical environment/evidence and current frontend remain unchanged;
- one concise next Owner checkpoint is identified if Stripe merchant/test account authorization is required.

A PASS of G3S0 means **readiness research complete**, not **Stripe installed/connected**.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:
1. this Gate on current `main`;
2. `docs/OWNER_DECISION_G3S_STRIPE_PRIMARY_PAYPAL_RETIREMENT_DEFERRED_2026-10-15.md`;
3. `docs/MVP_PRODUCT_CONTRACT.md` sections 3, 4 and 11;
4. `docs/G3BR1_SANDBOX_PAYMENT_RECONCILIATION_ENTITLEMENT_REFUND.md` only accepted provider-independent test invariants, not PayPal credentials or private evidence;
5. exact current Woo/payment/adaptor source or the smallest runtime admin metadata surfaces needed to classify current plugin/payment states;
6. official WooCommerce Stripe payment gateway docs and Stripe supported countries/KYC docs.

Do not reread broad Governance, Handoff or history, search Secrets, open unrelated applications, or write application/plugin/runtime code. Owner account authority is not delegated.

Accepted inputs:
- frontend visuals frozen as Owner PASS;
- current WooCommerce 11.1.2; WordPress 7.1.1 at last verified local stage;
- Woo product 1113, virtual USD 39.99;
- PayPal Sandbox historical proof accepted, PayPal not authorized to remove;
- pre-payment full intake exists as browser-side interface; durable server draft is still missing;
- customer private workspace/order ownership baseline accepted;
- no Stripe live merchant readiness has been established.

## EXECUTOR_TO_REVIEWER_RELAY

```text
结果：PASS_CANDIDATE_G3S0 / RETURN_*
改动：只读核验 Stripe 账户/官方 Woo 插件/HTTPS 回调准备情况，PayPal 与前端均未修改。
验证：环境/插件/账户资格矩阵、测试模式和下一 Gate 条件、零安装/支付/Provider 修改。
问题：NONE，或指出当前唯一真正阻塞的 Owner/provider 条件。
回滚：本轮没有业务或运行态修改；现有 Woo/PayPal 基线保留。
请 Reviewer 检查：readiness Evidence + 官方来源 + 有明确停止边界的 G3S1 测试接入计划。
Owner 转交：NONE，或 Stripe 官网必要的账户/测试授权动作（不含密钥）。
```

## Stop boundary

Stop after read-only readiness Evidence and PASS_CANDIDATE/RETURN. Do not enable Stripe (test/live), connect any account, submit checkout, disable PayPal, mutate DB, build backend drafts, run model/provider generation, expose public domain, merge PR #64, or migrate production data.
