# G3CR7V2R4 — Widescreen Composition + Placeholder Cleanup

## Gate

```text
GATE_ID=G3CR7V2R4_WIDESCREEN_COMPOSITION_AND_PLACEHOLDER_CLEANUP
OBJECTIVE=Make homepage Preview/core-entry and intake feel premium and appropriately scaled at the Owner's real 2048px-wide desktop viewport; remove all fake no-photo illustration and simplify CTA hierarchy
MAX_ENDPOINT_THIS_ROUND=Owner-reviewable 2048/1440/375 homepage + intake candidate mounted at 127.0.0.1:8189
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=homepage Preview markup microcopy + magazine-preview.css + intake frontend-reproduction.css; PHP only where needed for CTA microcopy / placeholder DOM simplification; JS behavior frozen
APPLICABLE_CRITICAL_CONSTRAINTS=PAYMENT_LOGIC_MUTATIONS_0; ORDER_STATE_MUTATIONS_0; CHECKOUT_SUBMISSIONS_0; PROVIDER_MUTATIONS_0; MODEL_GENERATION_CALLS_0; IMAGE_GENERATION_0; PRODUCTION_DEPLOYMENT_0; SHARED_INFRA_MUTATIONS_0; PR64_MERGE_0; P1_P12_BUILD_0
ROLLBACK_STATUS_OR_PLAN=Restore project source to 43ebf7bb732e9e3be8d547364ca7b018f7f505f8
OWNER_ONLY_ACTIONS=Final live homepage + intake visual acceptance
```

Governance: **vps-project-governance v0.2.7**.

Triggered specialist checks:
- **11C Deployment / Network / Resources** — exact candidate must remain mounted and normal Edge cache-safe CSS delivery must stay intact.
- **11E Provider / Payment** — payment/order semantics frozen; no replay.
- **11G Image Generation** — explicitly NOT APPLICABLE. No replacement placeholder image is authorized.

## Authority

1. `docs/OWNER_DECISION_G3CR7V2R4_WIDESCREEN_COMPOSITION_RETURN_2026-10-05.md`
2. project Stripe/Birthday Magazine design adapter
3. existing accepted business flow
4. current PR #64 source at the Gate start

Keep:
- mulberry brand palette;
- cool SaaS shell;
- no mesh;
- Stripe-derived component grammar;
- browser-local Preview;
- five-step intake;
- Woo/payment truth;
- Status standalone = QA-only.

## Core change in review methodology

### Primary viewport

Visual quality must now be reviewed primarily at:

```text
2048px desktop width
```

because that matches the Owner's live review captures.

Also verify:
- 1440px desktop compatibility;
- 375px mobile compatibility.

A candidate that looks strong only at 1440 but becomes visually tiny at 2048 is RETURN.

## Phase A — Homepage Preview/core-entry composition

### A1. Remove fake placeholder artwork

Current source contains:
- `.bms-cover-art` with CSS radial-gradient silhouette;
- `.bms-spread-art` with CSS linear-gradient diagonal block.

Required:
- remove the visual gradient artwork;
- no SVG/image/generated substitute;
- no human/face/cartoon silhouette;
- no decorative geometric fake photo.

When no photo is selected:
- the photo areas are neutral blank frames;
- suggested background range: `#F1F3F5` / `#F4F5F7`;
- optional hairline border only;
- do not center decorative artwork;
- no text is required inside the photo frame.

When a local photo is selected:
- existing browser-local image behavior remains unchanged.

### A2. Create a deliberate feature field

The Preview/core-entry section should use a light mulberry-tinted section background around:

`#F3EEF1`

with white control/demo panels.

Do not tint the magazine paper itself.

The section must clearly read as:
> this is the interactive product demo

not as another generic page block.

### A3. Widescreen scale

At 2048px target:
- feature section useful width: approx **1500–1660px**;
- intro/content alignment should share the same widescreen grid;
- headline: approx **52–64px** desktop;
- supporting copy: **17–19px**;
- controls panel: approx **360–420px** useful width;
- magazine cover should be visibly larger than the current live screenshot;
- sample spread should be visibly larger and dominate the demo region;
- reduce detached empty zones inside the controls card;
- controls should align toward the top/content, not vertically float in a mostly empty column.

At 1440px:
- maintain strong composition without overflow;
- proportional scale may reduce.

At 375px:
- stack intentionally;
- no horizontal overflow;
- preview objects remain legible.

### A4. CTA hierarchy

Replace the overloaded small CTA.

Required hierarchy:

```text
Supporting metadata:
12 pages · US$39.99

Primary button:
Create the full magazine →
```

Equivalent concise action wording is allowed, but:
- button must contain only the action;
- price/page count must remain outside;
- button target height approx 50–56px desktop;
- CTA group should occupy a deliberate area of the product-demo footer/action rail;
- privacy note remains separate.

Do not increase CTA emphasis by adding decoration; use scale, spacing and hierarchy.

## Phase B — Intake widescreen composition

The existing scale pass was insufficient at 2048px.

### Desktop 2048 targets

Use the available viewport with intent.

Suggested target ranges:
- app/content max-width: **1480–1580px**;
- main card width: full available app width or at least **1380px** where content permits;
- header-to-content top gap: **28–40px**;
- page headline: **54–62px**;
- step title: **34–38px**;
- support text: **18px**;
- labels/body: **15–16px**;
- controls: **54–58px** height;
- stepper labels: **13–15px**;
- main card padding: **36–44px**, not inflated beyond usefulness.

Do not merely enlarge outer card while leaving inner content narrow.

### 1440 compatibility

At 1440:
- content should still feel generous;
- avoid edge crowding;
- target side gutters around 48–72px where practical.

### 375 mobile

Keep:
- 16–20px side gutters;
- headline approx 32px;
- readable 16px body;
- touch controls >=48px;
- compact vertical rhythm;
- no horizontal overflow.

## Phase C — Content/logic constraints

Allowed copy change:
- CTA microcopy only, to separate action from price/page count.

Do not rewrite:
- Preview story text;
- intake questions;
- navigation labels;
- Woo/payment copy.

Do not change:
- Preview JS;
- photo privacy behavior;
- 12–25 photo rule;
- <=3 must-use rule;
- five-step flow;
- Woo checkout handoff;
- order/payment truth.

Status standalone remains QA-only and is out of visual scope.

## Required evidence

### Viewports

Capture **nine** final screenshots:

Homepage:
1. 2048px
2. 1440px
3. 375px

Intake About:
4. 2048px
5. 1440px
6. 375px

Intake Photos:
7. 2048px
8. 1440px
9. 375px

### Machine geometry

Report computed:
- viewport width;
- main content width;
- content-width percentage;
- headline font size;
- step-title font size;
- body/support font;
- label font;
- input/control height;
- top gap;
- CTA button size;
- Preview control/stage widths;
- cover/spread bounding boxes;
- horizontal overflow.

### Placeholder proof

Prove:
- no `radial-gradient` placeholder remains for `.bms-cover-art`;
- no `linear-gradient` placeholder remains for `.bms-spread-art`;
- no SVG or image asset is introduced;
- no fake human/cartoon placeholder appears;
- no-photo state displays neutral empty frames.

### CTA proof

Prove:
- action button text does not contain price/page count;
- `12 pages · US$39.99` appears outside the button;
- route still targets `/make-your-magazine/`.

### Behavior smoke

Reuse smallest necessary smoke:
- Preview name/age update;
- local selected image uses `blob:`;
- intake Next/Back;
- 12 photos / 3 must-use;
- checkout URL unchanged;
- no non-GET/payment/provider/model action.

### Runtime

- cache-safe file-versioning from G3CR7V2R3 remains;
- exact final candidate remains mounted at `127.0.0.1:8189`;
- normal Edge must see the same candidate without cache clear.

## Acceptance criteria

PASS_CANDIDATE requires:
- homepage is materially larger and better balanced at 2048px;
- intake no longer looks like a small centered document at 2048px;
- empty whitespace feels intentional, not unused;
- no-photo fake artwork is gone;
- Preview section has a deliberate light mulberry emphasis field;
- CTA hierarchy is simplified and coordinated;
- 1440 and 375 remain coherent;
- business behavior unchanged;
- candidate remains mounted for Owner.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. this Gate;
2. Owner decision;
3. current target files:
   - `birthday-magazine-poc.php` only for Preview markup/CTA;
   - `preview.js` read-only behavior reference;
   - `magazine-preview.css`;
   - `frontend-reproduction.css`;
   - `frontend-reproduction.php` read-only DOM reference;
4. project Stripe/Birthday Magazine design adapter;
5. G3CR7V2R3 browser-style-delivery evidence to preserve cache-safe delivery.

Do not reread broad project history.
Do not generate images.
Do not touch Status fixture design.
Do not replay payment/order evidence.

## EXECUTOR_TO_REVIEWER_RELAY

Return exactly:

```text
结果：PASS_CANDIDATE / RETURN_*
改动：按 Owner 2048px 实机反馈重做 homepage/intake 的尺度与构图；删除所有 CSS 假照片占位图，Preview 使用浅莓紫 feature field，CTA 拆分动作与价格信息；业务逻辑冻结。
验证：2048/1440/375 九张图、几何 readback、no-placeholder 证明、CTA hierarchy、最小 smoke、正常 Edge 加载 exact candidate。
问题：NONE，或明确 widescreen/cascade/runtime 阻塞。
回滚：可恢复到 43ebf7bb...
请 Reviewer 检查：九张最终图 + geometry + scoped diff + live runtime readback。
Owner 转交：NONE。
```

## Stop boundary

Stop after PASS_CANDIDATE / RETURN. Do not enter backend draft persistence, automatic generation, P1-P12, real payment, production deployment, PR merge, Shared Infra or any new visual-direction exploration.
