# G3CR7V2R3 — Live Style Delivery + Intake Scale Refinement

## Gate

```text
GATE_ID=G3CR7V2R3_LIVE_STYLE_DELIVERY_AND_SCALE_REFINEMENT
OBJECTIVE=Make the Owner's normal Edge session load the reviewed homepage SaaS visual reliably, then strengthen intake scale/density while preserving the accepted visual system and business behavior; demote standalone status preview to QA-only
MAX_ENDPOINT_THIS_ROUND=Owner-reviewable homepage + intake mounted at 127.0.0.1:8189 with reliable cache-safe CSS delivery and bounded scale refinement
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=visual CSS delivery/enqueue versioning + homepage Preview CSS only if live-delivery diagnosis proves source styling itself is not applied + intake CSS scale/density + QA status-role metadata/evidence
APPLICABLE_CRITICAL_CONSTRAINTS=PAYMENT_LOGIC_MUTATIONS_0; ORDER_STATE_MUTATIONS_0; CHECKOUT_SUBMISSIONS_0; PROVIDER_MUTATIONS_0; MODEL_GENERATION_CALLS_0; IMAGE_GENERATION_0; PRODUCTION_DEPLOYMENT_0; SHARED_INFRA_MUTATIONS_0; PR64_MERGE_0; P1_P12_BUILD_0
ROLLBACK_STATUS_OR_PLAN=Visual/source rollback anchor daff4101080d71aa0aa958986096d14975339deb; any enqueue cache-busting change must be independently reversible
OWNER_ONLY_ACTIONS=Final live visual acceptance after Reviewer review
```

Governance: **vps-project-governance v0.2.7**.

Triggered specialist rules:
- **11C Deployment / Network / Resources** — live browser asset identity differs from reviewed source appearance; browser/runtime delivery must be proven by layer.
- **11E Provider / Payment** — payment/order continuation is preserved but not replayed.
- **11G Image Generation** — checked; NOT APPLICABLE because no image generation/editing is authorized.

## Accepted facts

Keep:
- Stripe-derived SaaS structure;
- Birthday Magazine mulberry palette;
- mesh removed;
- browser-local Preview behavior;
- five-step intake behavior;
- Woo checkout/payment truth from prior accepted evidence;
- frozen business logic.

Prior accepted source anchor:
`daff4101080d71aa0aa958986096d14975339deb`

## Phase A — diagnose live homepage style delivery before redesign

The Owner's browser view conflicts with automated candidate screenshots. Diagnose this as a delivery/cache problem first.

### Required read-only checks

1. fresh project-scoped Git/PR source identity;
2. runtime `magazine-preview.css` source hash;
3. normal Edge request URL for `magazine-preview.css`;
4. query/version parameter on that request;
5. response body hash/content marker seen by the browser;
6. cache status / cache-control / age indicators where available;
7. computed homepage tokens in a normal cache-enabled Edge page:
   - expected primary `#713F5D`;
   - expected soft canvas `#F7F8FB`;
8. repeat once with cache bypass/hard reload semantics;
9. compare normal-load and bypass-load results.

Current source observation:
- `bms-magazine-preview` is enqueued with fixed version `0.3.0`;
- `bms-g3cr7-reproduction` is enqueued with fixed version `0.1.0`.

### Allowed repair if stale CSS caching is proven

Change only visual asset versioning to cache-safe source-derived versions, preferably:
- `filemtime(__DIR__ . '/magazine-preview.css')`
- `filemtime(__DIR__ . '/frontend-reproduction.css')`

Equivalent deterministic file-content/version correlation is acceptable.

Do not change Preview/intake business behavior.

After repair, prove a normal fresh Owner-like Edge request—without DevTools cache disabling—loads the same CSS bytes/hash as the current Git/runtime candidate.

### If caching is not the cause

If normal Edge already loads the candidate CSS bytes but homepage still renders old composition:
- inspect actual DOM selectors/classes and cascade;
- identify the exact selector/cascade reason;
- make the smallest homepage Preview CSS fix that causes the actual existing DOM to render the already-approved SaaS composition.

Do not invent another visual system.

## Phase B — intake scale and density refinement

Preserve the current layout concept and mulberry palette, but increase visual confidence.

### Desktop targets

At 1440px:
- main app content should use roughly 70–80% of useful viewport width where appropriate, rather than appearing like a small centered document;
- reduce excessive top/side empty space;
- heading hierarchy should be visibly larger:
  - page headline target approx 38–46px desktop;
  - step title approx 28–32px;
  - supporting text approx 16–18px;
  - labels/body should generally not feel below 14px in ordinary reading contexts;
- primary work card padding can increase where content density benefits, while outer whitespace decreases;
- fields/buttons should feel substantial: target 44–52px control height;
- progress/stepper should be easier to read without becoming dominant;
- photo grid may use fewer/wider columns if that improves legibility and photo usefulness;
- footer/footnote must not create a large dead zone.

### Mobile targets

At 375px:
- do not simply enlarge desktop values;
- preserve 16–20px side gutters;
- body/support text should remain comfortably readable;
- CTA/control targets remain touch-friendly;
- avoid excessive vertical padding between sections;
- no horizontal overflow.

### Style constraint

This is a **scale/density pass**, not a redesign:
- same Stripe-derived SaaS structure;
- same mulberry palette;
- same card/field visual grammar;
- no gradients/mesh/illustrations;
- no new decorative assets;
- no copy rewrite except tiny QA-only labels if required.

## Phase C — status role correction

Do not treat `/magazine-status-preview/` as a production page.

Required:
- preserve `bms_g3cr7_render_order_status()` / Woo order continuation behavior unchanged;
- preserve status/progress component CSS needed for eventual order/private-workspace integration;
- classify the standalone status fixture/route as **QA_ONLY_NOT_PRODUCT_SURFACE** in Evidence/Handoff;
- no Owner visual acceptance screenshot is required for the standalone fixture in this Gate;
- do not delete Woo status logic;
- do not create/replay orders/payment evidence.

Removing the QA fixture shortcode/page is **not required** in this Gate; avoid unnecessary functional edits.

## Required evidence

1. fresh source/runtime identity;
2. Phase A browser CSS delivery report showing:
   - requested stylesheet URL/version;
   - normal-load response identity;
   - cache-bypass identity;
   - final normal-load identity;
   - computed key tokens;
3. scoped diff;
4. if enqueue versioning changes PHP, prove only asset-version arguments changed and business handlers/shortcodes/order logic did not;
5. final screenshots:
   - homepage 1440;
   - homepage 375;
   - intake About 1440;
   - intake About 375;
   - intake Photos 1440;
   - intake Photos 375;
6. before/after geometry measurements for intake:
   - primary content width;
   - headline/step/body computed font sizes;
   - control height;
   - relevant outer/top spacing;
7. no horizontal overflow at 375;
8. minimal behavior smoke:
   - Preview name/photo local update;
   - Preview image remains `blob:`;
   - intake Next/Back;
   - 12-photo/must-use behavior;
   - checkout handoff unchanged;
9. status role recorded as `QA_ONLY_NOT_PRODUCT_SURFACE`;
10. Woo order status PHP blob/logic unchanged unless only enqueue/cache versioning in the same file changes; if the main plugin file changes, provide a structural diff proving payment/order functions are byte-equivalent;
11. payment/order/provider/model/deploy/shared-infra counters all 0;
12. exact candidate remains mounted at `127.0.0.1:8189`;
13. `STOP_AT_REVIEWER=YES`.

## Acceptance criteria

PASS_CANDIDATE requires:
- Owner-like normal Edge load reliably receives the same homepage CSS candidate as Git/runtime;
- homepage visibly renders the approved SaaS shell on a normal load;
- intake is materially larger, denser, and more confident without changing the visual language;
- mobile remains deliberate;
- standalone status preview is formally de-scoped from product-facing acceptance;
- Woo order continuation behavior remains frozen;
- no backend/payment/business expansion;
- exact candidate remains mounted for Owner review.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. this Gate;
2. `docs/OWNER_DECISION_G3CR7V2R3_VISUAL_RETURN_SCALE_STATUS_ROLE_2026-10-05.md`;
3. current PR source:
   - `birthday-magazine-poc.php` only for enqueue/Preview DOM and structural diff;
   - `frontend-reproduction.php` only for intake/status DOM and frozen order-status verification;
   - `magazine-preview.css`;
   - `frontend-reproduction.css`;
4. existing G3CR7V2R2 runtime/browser readbacks as prior source identity evidence;
5. active runtime/browser responses for the two visual stylesheets.

Do not reread broad project history.
Do not replay Woo/payment evidence.
Do not generate images.
Do not redesign status as an independent page.

## EXECUTOR_TO_REVIEWER_RELAY

Return exactly:

```text
结果：PASS_CANDIDATE / RETURN_*
改动：先修复/证明首页正常 Edge 的 CSS 实际加载链，再仅放大并收紧 intake 视觉；状态页降级为 QA-only，Woo 状态组件逻辑保持冻结。
验证：首页正常/绕缓存 CSS 身份、1440/375 首页+intake 六图、intake 几何/字号 readback、最小功能 smoke、候选持续挂载。
问题：NONE，或明确 cache/cascade/runtime 阻塞。
回滚：可恢复到 daff410...；如仅改 enqueue 版本和 CSS，可逐文件回退。
请 Reviewer 检查：browser CSS delivery report + scoped diff + 六张最终截图。
Owner 转交：NONE。
```

## Stop boundary

Stop after PASS_CANDIDATE / RETURN. Do not enter backend draft persistence, automatic generation, P1-P12, real payment, production deployment, PR merge, Shared Infra, or new visual-direction exploration.
