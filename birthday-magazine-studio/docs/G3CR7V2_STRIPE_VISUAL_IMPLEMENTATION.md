# G3CR7V2 — Stripe Soft-Tech Visual Implementation

## Gate

```text
GATE_ID=G3CR7V2_STRIPE_VISUAL_IMPLEMENTATION
OBJECTIVE=Apply the Owner-selected Stripe Soft-Tech visual system to the three technically accepted frontend surfaces while preserving all frozen business behavior
MAX_ENDPOINT_THIS_ROUND=Owner-reviewable Stripe-style candidate mounted in local runtime + complete visual evidence; no backend, payment, generation, P1-P12, production deployment, PR merge
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=birthday-magazine-studio/poc/g3c/preview-plugin visual markup/CSS only as necessary + retained local WordPress runtime
APPLICABLE_CRITICAL_CONSTRAINTS=BUSINESS_LOGIC_MUTATIONS_0; FREE_PREVIEW_MODEL_CALLS_0; FREE_PREVIEW_SERVER_PHOTO_UPLOADS_0; WOO_COMMERCE_CANONICAL_ORDER_SYSTEM_YES; REAL_MONEY_ACTIONS_0; CHECKOUT_SUBMISSIONS_0; PROVIDER_MUTATIONS_0; MODEL_GENERATION_CALLS_0; PRODUCTION_DEPLOYMENT_0; SHARED_INFRA_MUTATIONS_0; PR64_MERGE_0; P1_P12_BUILD_0
ROLLBACK_STATUS_OR_PLAN=Restore visual-source files to PR #64 baseline `806907177ba48ef2ed11310e36f4cca0e209b421`; do not discard technical/evidence history
OWNER_ONLY_ACTIONS=Final visual acceptance after Reviewer PASS_CANDIDATE
```

Governance: **vps-project-governance v0.2.7**.

## Authority

Owner-selected style:
- **STRIPE_SOFT_TECH**

Supersedes:
- `G3CR7V2A_SAAS_STYLE_AUDITION`
- Linear audition
- Attio audition
- three-way style comparison

Owner decision:
- `docs/OWNER_DECISION_G3CR7V2_STRIPE_STYLE_LOCK_2026-10-05.md`

### Canonical DESIGN.md reference

The Owner supplied a concrete Stripe-inspired DESIGN.md. It is now vendored project-locally and is the **primary visual-system authority** for this Gate:

1. `docs/design-references/stripe/PROJECT_ADAPTER.md`
2. `docs/design-references/stripe/DESIGN.md`
3. `docs/design-references/stripe/SOURCE.md`
4. `docs/design-references/stripe/LICENSE-VoltAgent.txt`

Upstream:
- `VoltAgent/awesome-design-md/design-md/stripe/DESIGN.md`
- pinned upstream blob: `589bd23baeb1344444f087043c060afd6239371f`
- MIT licensed.

Where the generic DESIGN.md conflicts with Birthday Magazine product constraints, `PROJECT_ADAPTER.md` wins. Do not replace these references with an Executor-invented Stripe summary.

## Frozen behavior

Do not change:

- homepage/free Preview product logic;
- name/age/mood/photo behavior;
- Preview browser-local photo boundary;
- five-step intake structure;
- 12–25 photo rule;
- <=3 must-use rule;
- six prompts;
- validation;
- review summary semantics;
- Woo checkout handoff;
- Woo order/payment truth;
- unpaid order-received continuation;
- query-promotion negative behavior.

No backend draft persistence or generation wiring in this Gate.

## Stripe visual system

### Global app tokens

Use the exact project-local DESIGN.md + adapter above. The following summary is secondary and must not replace them.

Use a Stripe-like application shell, not Stripe branding:

- background: cool light gray or very pale blue/lilac;
- surfaces: bright white;
- text: near-black/slate;
- secondary text: cool gray;
- border: cool neutral, low contrast;
- primary accent: restrained indigo/purple;
- success/pending/info: compact semantic chips;
- radius: primary cards 14–18px; fields/buttons 8–12px;
- shadows: soft, controlled, layered;
- typography: modern sans-serif across application UI;
- serif only inside the magazine artifact itself;
- spacing: generous but not sparse;
- avoid beige/paper treatment outside the magazine preview object.

No Stripe logo, proprietary asset or source-code copying.

## Surface A — Homepage Free Preview / core entry

This is the highest visual bar.

Required:
- actual existing Preview/core-entry block must be visibly replaced, not another homepage section;
- Stripe-like product demo shell;
- contained control panel rather than one long horizontal utility strip;
- clear free-preview heading/support copy;
- name/age/mood/upload controls in a modern white panel;
- magazine cover + sample spread inside a separate preview canvas;
- surrounding preview canvas uses cool SaaS shell colors; only magazine pages may remain ivory;
- integrated CTA to full creator;
- desktop asymmetry/split-layout may be used;
- 375px must intentionally stack controls -> preview -> CTA.

Do not retain the current beige full-width flat canvas.

## Surface B — Core intake

Required:
- real application shell;
- compact top bar;
- stepper/progress component;
- one clear primary work panel;
- modern Stripe-like fields/selects/buttons;
- photo uploader styled as a first-class dropzone;
- photo grid uses real project-local photography or neutral non-human imagery;
- no SVG/cartoon human fixtures;
- review step uses structured summary panels;
- no giant editorial headline;
- no paper/editorial SaaS shell;
- stable action area on desktop/mobile.

## Surface C — Status / Woo continuation

Required:
- polished Stripe-like status surface;
- compact state badge/icon;
- concise heading;
- progress/timeline card;
- order/context metadata card;
- pending / generating fixture / ready fixture share one coherent visual language;
- actual Woo order-received pending continuation visually belongs to this system;
- Woo checkout itself is not redesigned.

## Photo fixture rule

Human/cartoon/SVG-face placeholders are forbidden.

Use:
1. existing project-local photographic sample assets;
2. other already-approved local photographic assets;
3. neutral non-human photographic/abstract local assets.

Do not hotlink external images.
Do not invoke image generation solely for QA placeholders.

## Local-runtime rule

This Gate exists partly to fix the previous Owner-review failure.

After applying the candidate:

- keep the exact candidate CSS/markup mounted at `http://127.0.0.1:8189/`;
- do **not** restore prior CSS after evidence capture;
- Owner must be able to refresh the local URL and see the same candidate shown in screenshots;
- rollback occurs only after explicit Owner/Reviewer instruction or if the Gate RETURNs for technical safety.

## PREFLIGHT

Before mutation:

1. fresh-fetch current PR #64;
2. confirm current PR head descends from or is equivalent to visual baseline `806907177ba48ef2ed11310e36f4cca0e209b421`;
3. confirm technical G3CR7 behavior remains intact;
4. confirm local runtime is reachable with the known loopback/proxy-bypass handling if required;
5. capture current actual Owner-visible local state at 1440 and 375;
6. verify no current-main project source drift invalidates the visual work.

If any frozen behavior differs materially, RETURN.

## REQUIRED_EVIDENCE

Provide:

1. exact source baseline and changed files;
2. proof that the vendored DESIGN.md blob is `589bd23baeb1344444f087043c060afd6239371f` and that `PROJECT_ADAPTER.md` was read before visual mutation;
3. Stripe-style token sheet that maps implementation tokens back to DESIGN.md tokens;
4. scoped source diff;
5. before/after screenshots at 1440 and 375 for:
   - homepage Preview/core-entry;
   - intake About;
   - intake Photos with >=12 local photographic/neutral fixtures;
   - intake Review;
   - Woo pending continuation;
   - status/generating fixture;
   - ready fixture;
6. final desktop/mobile contact sheet;
7. no horizontal overflow at 375;
8. smallest smoke proof:
   - Preview name/photo still updates locally;
   - photo remains `blob:`, no upload/model call;
   - intake Next/Back/photo-grid/must-use still works;
   - Woo checkout handoff unchanged;
   - unpaid real Woo fixture still shows PAYMENT PENDING;
9. local-runtime readback proving the **same visual candidate remains mounted after screenshot capture**;
10. no SVG/cartoon human placeholders in final screenshots;
11. counters: real payment/provider/model/deploy/shared infra all 0;
12. `STOP_AT_REVIEWER=YES`.

## ACCEPTANCE_CRITERIA

PASS_CANDIDATE requires:

- all three surfaces visibly follow one coherent Stripe Soft-Tech system;
- application shell is cool SaaS, not beige editorial paper;
- homepage Preview/core-entry looks like a premium product demo;
- intake looks like mature onboarding software;
- status/Woo continuation looks like polished production SaaS;
- no SVG/cartoon human placeholders;
- desktop and mobile are deliberately composed;
- frozen business behavior remains intact;
- exact candidate remains visible in local runtime for Owner review;
- no scope expansion.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. this Gate;
2. `docs/OWNER_DECISION_G3CR7V2_STRIPE_STYLE_LOCK_2026-10-05.md`;
3. **mandatory design authority**:
   - `docs/design-references/stripe/PROJECT_ADAPTER.md`
   - `docs/design-references/stripe/DESIGN.md`
   - `docs/design-references/stripe/SOURCE.md`;
4. current PR target files:

   - `poc/g3c/preview-plugin/birthday-magazine-poc.php`
   - `poc/g3c/preview-plugin/magazine-preview.css`
   - `poc/g3c/preview-plugin/frontend-reproduction.php`
   - `poc/g3c/preview-plugin/frontend-reproduction.css`
   - `poc/g3c/preview-plugin/frontend-reproduction.js`
   - `poc/g3c/preview-plugin/studio.css`
   - `poc/g3c/preview-plugin/home.css` only if the actual Preview/core-entry requires it;
5. current rejected G3CR7V1 screenshots only as before-baseline evidence;
6. existing approved project-local photographic assets.

Do not reread broad Governance/project history.
Do not run the superseded three-style audition.
Do not modify backend/payment/generation logic.

## EXECUTOR_TO_REVIEWER_RELAY

Return exactly:

```text
结果：PASS_CANDIDATE / RETURN_*
改动：按 Owner 已锁定的 Stripe Soft-Tech 方向重做三块视觉，业务逻辑冻结；未执行 Linear/Attio 试镜。
验证：1440/375 before-after、final contact sheet、Stripe token、最小 smoke、无 SVG/卡通人脸、同一候选仍挂载在 127.0.0.1:8189。
问题：NONE，或明确视觉/运行阻塞。
回滚：可恢复至 806907... 的视觉源码；当前技术逻辑与 DB/支付状态不变。
请 Reviewer 检查：三页面最终截图 + runtime readback + scoped diff。
Owner 转交：NONE。
```

## Stop boundary

Stop after PASS_CANDIDATE / RETURN. Do not enter backend draft persistence, automatic generation, P1-P12, PR reconciliation/merge, real payment, production deployment, or Shared Infra.
