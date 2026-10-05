# G3CR7V1 — Premium SaaS Visual Refinement

## Gate

```text
GATE_ID=G3CR7V1_PREMIUM_SAAS_VISUAL_REFINEMENT
OBJECTIVE=Raise the three technically accepted frontend surfaces from prototype/PPT quality to polished production-like UI without changing business logic
MAX_ENDPOINT_THIS_ROUND=Owner-reviewable desktop/mobile visual candidate for the three surfaces; no backend, payment, generation, P1-P12, deployment or PR merge
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=birthday-magazine-studio/poc/g3c/preview-plugin presentation CSS/markup only as necessary + local WordPress visual evidence
APPLICABLE_CRITICAL_CONSTRAINTS=FREE_PREVIEW_MODEL_CALLS_0; FREE_PREVIEW_SERVER_PHOTO_UPLOADS_0; WOO_COMMERCE_CANONICAL_ORDER_SYSTEM_YES; REAL_MONEY_ACTIONS_0; CHECKOUT_SUBMISSIONS_0; PROVIDER_MUTATIONS_0; MODEL_GENERATION_CALLS_0; PRODUCTION_DEPLOYMENT_0; SHARED_INFRA_MUTATIONS_0; PR64_MERGE_0; P1_P12_BUILD_0
ROLLBACK_STATUS_OR_PLAN=Restore exact G3CR7 technical PASS candidate c0a1f2aab3913c96df7d2382f17ebfeabbdfae1c for visual-source files
OWNER_ONLY_ACTIONS=Final visual acceptance after Reviewer candidate review
```

Governance: **vps-project-governance v0.2.7**.

## Frozen technical behavior

Do not redesign or reimplement:

- canonical flow;
- Free Preview browser-local photo behavior;
- Preview input fields and deterministic cover/spread behavior;
- core intake five-step structure;
- 12–25 photo bounds;
- <=3 must-use rule;
- six required prompts;
- validation;
- review summary semantics;
- WooCommerce checkout handoff;
- Woo `WC_Order::is_paid()` payment truth;
- order-received pending continuation;
- query-promotion negative behavior.

No functional regression suite replay is required except the smallest smoke checks needed to prove visual edits did not break the frozen behavior.

## Reference strategy — reuse patterns, do not port Webflow runtime

The Owner explicitly prefers mature SaaS onboarding patterns.

Use these as visual/layout references:

1. **Flowbase — Webflow Onboarding Form (Full Page)**
   - https://webflow.com/made-in-webflow/website/webflow-onboarding-form-clone
   - mature full-page onboarding shell; free cloneable reference.

2. **Flowbase — Multi Step Form Webflow**
   - visible in Webflow free multi-step collection:
     https://webflow.com/made-in-webflow/multi-step-form?cloneable=true
   - use for stepper/action/control hierarchy.

3. **BRIX — Multi-step Form Webflow Cloneable Template**
   - visible in:
     https://webflow.com/made-in-webflow/multistep?cloneable=true
   - use for polished SaaS control/card treatment.

These references are for composition and visual language only. Do not add Webflow runtime, React, paid libraries, or a new form plugin.

## Surface A — Homepage Preview → Core entry

This is the **highest-quality surface**.

The Owner's screenshoted Free Preview block is the target. Do not satisfy this Gate by changing only the later `.bms-offer` card.

### Required composition

Desktop target:
- one coherent premium **product-demo panel**, not a horizontal raw form plus loose magazine objects;
- clear section heading/subcopy introducing the free preview;
- two-column or asymmetric contained layout:
  - compact control card/panel;
  - larger visual magazine preview stage;
- controls grouped inside a deliberate card with clear labels, spacing and selected states;
- cover + spread presented inside a surfaced/elevated preview canvas with visual depth;
- “continue to full creation” CTA integrated into the product-demo component and visually primary after preview;
- enough depth/shadow/radius/background layering to feel like a finished consumer product, but preserve the existing warm editorial brand.

Mobile:
- deliberate stacked app/demo layout;
- controls first, preview second, CTA obvious;
- no horizontal overflow;
- preview objects remain legible, not microscopic.

### Do not

- leave the current long thin top form strip;
- leave the preview objects floating on one flat full-width beige background;
- merely add another CTA/card elsewhere on the homepage;
- add complex animation to compensate for weak composition.

## Surface B — Core function / intake

Target: **premium conventional SaaS onboarding**, not editorial presentation.

### Required visual structure

- full-height or near-full-height app shell;
- compact top brand/app bar;
- desktop stepper/rail or clearly contained progress header;
- one primary form card/surface with restrained max width;
- clear current-step label, headline, helper text and action area;
- controls use consistent height/radius/border/focus states;
- generous but controlled spacing;
- photo uploader and photo grid read like a modern product uploader, not raw bordered boxes;
- review step uses summary cards/rows with deliberate grouping;
- primary CTA has high contrast and fixed/consistent placement.

Typography:
- UI primarily uses a modern system/sans stack;
- serif may remain only as a restrained brand/editorial accent;
- no 60–70px headline dominating ordinary form steps.

Visual tokens:
- warm off-white app background;
- white/near-white cards;
- charcoal text;
- existing coral/red as the single action accent;
- subtle neutral borders;
- soft shadow/elevation;
- approximately 12–20px radius on primary surfaces;
- 8–12px on fields/buttons where appropriate.

No gradients/effects merely for decoration.

## Surface C — Woo / status / success

Target: familiar SaaS order/progress screen.

Required:
- compact centered status shell;
- clear state icon/badge;
- strong but not oversized status heading;
- visual timeline/progress card;
- compact order/context summary card or metadata row;
- pending, generating fixture, and ready fixture share one system;
- actual Woo order-received pending continuation visually belongs to the same system;
- preserve Woo payment truth and native page semantics.

Do not redesign Woo checkout itself.

## Anti-PPT checklist

A candidate RETURNs if any primary surface still has several of these traits:

- giant headline consuming most of the viewport;
- raw form controls floating directly on a blank page;
- excessive unused white space;
- every element separated only by thin rules;
- flat full-width canvas without card/surface hierarchy;
- visual hierarchy depending mainly on font size;
- content looks like a static slide/document instead of an application;
- CTA appears appended rather than integrated;
- desktop looks acceptable only because the viewport is wide;
- mobile is just stacked desktop without a deliberate mobile composition.

## PREFLIGHT

Before mutation:

1. fresh-fetch current PR #64;
2. confirm exact technical-pass candidate source `c0a1f2a...` or its equivalent current descendant;
3. confirm current PR still contains independent `frontend-reproduction.*`;
4. prove no current-main Birthday Magazine source drift invalidates the visual baseline;
5. capture current 1440/375 visual baseline for the three target surfaces;
6. no backend/payment/runtime architecture changes are needed.

If source meaning or frozen behavior differs materially, RETURN to Reviewer.

## REQUIRED_EVIDENCE

Return an evidence bundle containing:

1. exact source baseline and changed files;
2. visual-reference notes: which structural ideas came from Flowbase/BRIX and how they were reimplemented locally;
3. before/after screenshots at 1440 and 375 for:
   - homepage Free Preview/core-entry;
   - intake About;
   - intake Photos with >=12 fixtures;
   - intake Review;
   - Woo pending continuation;
   - status/generating fixture;
   - ready fixture;
4. one compact contact sheet showing all three final surfaces desktop + mobile;
5. geometry: no horizontal overflow at 375;
6. smallest functional smoke proof:
   - Free Preview still reacts to name/photo locally;
   - intake Next/Back and photo grid still operate;
   - checkout handoff URL still native Woo;
   - order-received unpaid state still pending;
7. no real payment/provider/model/deploy action;
8. rollback effect;
9. `STOP_AT_REVIEWER=YES`.

## ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires:

1. homepage screenshoted Preview/core-entry is visibly redesigned, not merely another homepage section;
2. homepage entry visually reaches the quality level of the otherwise accepted homepage;
3. intake reads as a modern SaaS application rather than a prototype or slide deck;
4. status/order continuation reads as a production SaaS state screen rather than test documentation;
5. desktop and 375px are deliberately composed;
6. frozen technical behavior remains intact;
7. no scope expansion/backend/payment/model/production/P1-P12 work;
8. Reviewer can directly inspect all final screenshots.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. this Gate;
2. current PR target source:
   - `poc/g3c/preview-plugin/birthday-magazine-poc.php`
   - `poc/g3c/preview-plugin/magazine-preview.css`
   - `poc/g3c/preview-plugin/frontend-reproduction.php`
   - `poc/g3c/preview-plugin/frontend-reproduction.css`
   - `poc/g3c/preview-plugin/frontend-reproduction.js`
   - `poc/g3c/preview-plugin/studio.css`
   - `poc/g3c/preview-plugin/home.css` only if required for the actual Preview/core-entry surface;
3. Owner visual-return decision:
   - `docs/OWNER_DECISION_G3CR7_VISUAL_RETURN_2026-10-05.md`;
4. existing G3CR7 screenshots only as the **before** baseline.

Do not reread Governance, broad project history, P1-P12 research, or earlier motion research.

Use Flowbase/BRIX as visual references, not dependencies.

## EXECUTOR_TO_REVIEWER_RELAY

Return exactly:

```text
结果：PASS_CANDIDATE / RETURN_*
改动：只重做首页 Preview/core-entry、五步 intake 和状态页的视觉层，冻结业务逻辑。
验证：1440/375 before-after、contact sheet、无横向溢出、最小功能 smoke、支付真值未变。
问题：NONE，或明确视觉/运行阻塞。
回滚：可恢复到 G3CR7 技术 PASS 候选 c0a1f2a...
请 Reviewer 检查：三页面最终截图 + contact sheet + scoped diff。
Owner 转交：NONE。
```

## Stop boundary

Stop after PASS_CANDIDATE / RETURN. Do not enter pre-payment draft persistence, automatic generation, P1-P12, PR reconciliation/merge, real payment, production deployment, or Shared Infra.
