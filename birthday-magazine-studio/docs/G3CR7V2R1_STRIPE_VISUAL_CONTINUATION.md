# G3CR7V2R1 — Stripe Visual Continuation After False-Positive Preflight

## Gate

```text
GATE_ID=G3CR7V2R1_STRIPE_VISUAL_CONTINUATION
OBJECTIVE=Continue the Owner-selected Stripe DESIGN.md visual implementation after Reviewer overruled the false-positive Woo preflight drift
MAX_ENDPOINT_THIS_ROUND=Owner-reviewable Stripe candidate mounted at 127.0.0.1:8189 + visual evidence; no business logic, payment, backend, generation, P1-P12, production deployment or PR merge
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=birthday-magazine-studio/poc/g3c/preview-plugin presentation layer + local visual runtime
APPLICABLE_CRITICAL_CONSTRAINTS=PHP_JS_BUSINESS_MUTATIONS_0; REAL_MONEY_ACTIONS_0; CHECKOUT_SUBMISSIONS_0; PROVIDER_MUTATIONS_0; MODEL_GENERATION_CALLS_0; PRODUCTION_DEPLOYMENT_0; SHARED_INFRA_MUTATIONS_0; PR64_MERGE_0; P1_P12_BUILD_0
ROLLBACK_STATUS_OR_PLAN=Restore visual source to 806907177ba48ef2ed11310e36f4cca0e209b421; keep G3CR7R1R2 payment truth and G3CR7V2 preflight evidence
OWNER_ONLY_ACTIONS=Final local visual acceptance
```

Governance: **vps-project-governance v0.2.7**.

## Authority

Read first:
1. `docs/REVIEWER_DECISION_G3CR7V2_RETURN_PREFLIGHT_DRIFT_OVERRULED_2026-10-05.md`
2. `docs/OWNER_DECISION_G3CR7V2_STRIPE_STYLE_LOCK_2026-10-05.md`
3. `docs/design-references/stripe/PROJECT_ADAPTER.md`
4. `docs/design-references/stripe/DESIGN.md`
5. `docs/design-references/stripe/SOURCE.md`

Pinned DESIGN.md blob:
`589bd23baeb1344444f087043c060afd6239371f`

## Accepted frozen business source

Before visual mutation, fresh-read these exact blobs:

- `frontend-reproduction.php` = `db3af21e56fe2683b20020ae25cda0fbf6a8f5a1`
- `frontend-reproduction.js` = `cbd67a7dc0897e87e4c7bc4edb017a1e138d2e6a`
- `birthday-magazine-poc.php` = `0aa39e131b7958652bc0cfbd4ada7a4621fb3caf`

If any differs, RETURN before mutation.

Do not modify these three files in this Gate.

## Payment-truth reuse

Accepted G3CR7R1R2 proof remains authoritative because the above business blobs are unchanged.

Do **not** use order #1131 as a required payment-truth preflight unless you can independently prove a valid Woo order-received access context.

Do not recreate a Woo synthetic order merely to replay already accepted evidence.

A fresh Woo order/payment smoke is required only if:
- any frozen PHP/JS blob changes;
- Woo payment/order logic changes;
- the visual implementation alters the actual order-status markup semantics beyond CSS-only restyling.

Pure CSS visual changes may reuse G3CR7R1R2 payment truth.

## Visual objective

Apply the vendored Stripe-inspired DESIGN.md to the three real surfaces.

### Homepage Preview / core entry

- eliminate beige/paper-dominant app shell;
- use cool `#f6f9fc`-style field/background language;
- white control and preview panels;
- restrained original atmospheric mesh allowed outside product panels;
- indigo `#533afd`-family CTA/focus;
- app typography sans-serif;
- magazine object alone may stay ivory/serif;
- integrated full-creator CTA;
- deliberate 375px stack.

### Intake

- cool SaaS app shell;
- compact product top bar;
- Stripe-like stepper/progress;
- one clear white work surface;
- 6px inputs, 8–12px cards, pill action buttons where appropriate;
- photographic or neutral non-human local photo fixtures;
- no SVG/cartoon human placeholders;
- no giant editorial step headline;
- no beige paper shell.

### Status / Woo

- white status card on cool SaaS background;
- compact semantic badge;
- timeline rows with hairlines;
- order metadata using tabular numerics;
- coherent pending/generating/ready visual system;
- CSS-only restyle of actual Woo continuation if needed; payment truth itself is frozen.

## Local runtime requirement

The exact final candidate must remain mounted at:

`http://127.0.0.1:8189/`

after screenshot capture.

Do not restore old CSS before Owner review.

The previous 14 before screenshots from `docs/evidence/g3cr7v2/before/` may be reused; do not recapture them unless the current Owner-visible baseline has materially changed.

## Required evidence

1. fresh blob preflight for the three frozen PHP/JS files;
2. proof DESIGN.md + adapter were read;
3. implementation token map back to DESIGN.md;
4. scoped visual diff;
5. after screenshots at 1440 and 375 for:
   - homepage Preview/core-entry;
   - intake About;
   - intake Photos with >=12 approved local photographic/neutral fixtures;
   - intake Review;
   - status generating fixture;
   - status ready fixture;
   - Woo pending continuation **only if the actual order-route visual markup was changed and a valid access context is available without replaying payment actions**;
6. final desktop/mobile contact sheet;
7. no horizontal overflow at 375;
8. minimal behavior smoke:
   - Preview still updates from name/local photo;
   - local photo remains `blob:`;
   - intake Next/Back/photo-grid/must-use still works;
   - Woo checkout URL unchanged;
9. final local-runtime readback proving the same CSS/markup remains mounted;
10. no SVG/cartoon human placeholders;
11. all payment/provider/model/deploy counters 0;
12. `STOP_AT_REVIEWER=YES`.

## Acceptance criteria

PASS_CANDIDATE requires:
- visual system materially matches the project-local Stripe DESIGN.md/adapter;
- warm paper styling is limited to the magazine artifact itself;
- actual homepage Preview/core-entry is visibly transformed;
- intake looks like mature SaaS software;
- status surface looks production-grade;
- desktop/mobile both deliberate;
- no frozen PHP/JS changes;
- exact visual candidate remains live at 127.0.0.1:8189;
- no business/payment/backend scope expansion.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. this Gate;
2. overrule decision;
3. Stripe DESIGN.md / PROJECT_ADAPTER / SOURCE;
4. current visual files:
   - `magazine-preview.css`
   - `frontend-reproduction.css`
   - `studio.css`
   - `home.css` only if required by the actual Preview component;
5. the three frozen PHP/JS files only to verify exact blobs, not to edit;
6. G3CR7V2 before screenshots;
7. existing approved local photographic assets.

Do not reread broad project history.
Do not replay G3CR7R1R2 payment/order evidence.
Do not create a new test order unless Reviewer later authorizes it because frozen business source changed.

## EXECUTOR_TO_REVIEWER_RELAY

Return exactly:

```text
结果：PASS_CANDIDATE / RETURN_*
改动：继续按项目内 Stripe DESIGN.md/adapter 重做三块真实视觉；未修改冻结 PHP/JS 或支付逻辑。
验证：frozen blob preflight、DESIGN token map、1440/375 after、contact sheet、最小 smoke、候选仍挂载在 127.0.0.1:8189。
问题：NONE，或明确视觉/runtime 阻塞。
回滚：视觉文件可恢复到 806907...；G3CR7R1R2 支付真值证据继续复用。
请 Reviewer 检查：视觉 scoped diff + after screenshots + runtime readback。
Owner 转交：NONE。
```

## Stop boundary

Stop after PASS_CANDIDATE / RETURN. Do not enter backend draft persistence, automatic generation, P1-P12, real payment, production deployment, PR merge or Shared Infra.
