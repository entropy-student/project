# G3CR7V2A — Premium SaaS Style Audition

## Gate

```text
GATE_ID=G3CR7V2A_SAAS_STYLE_AUDITION
OBJECTIVE=Reproduce three materially different premium SaaS visual directions using the same frozen Birthday Magazine content, so Owner can choose one before full reskin
MAX_ENDPOINT_THIS_ROUND=Three style auditions + screenshots/contact sheet; no production integration, no business-logic mutation, no full three-surface reskin
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=birthday-magazine-studio visual audition/evidence only; current accepted functionality and PR implementation remain untouched
APPLICABLE_CRITICAL_CONSTRAINTS=BUSINESS_LOGIC_MUTATIONS_0; PHP_JS_BEHAVIOR_MUTATIONS_0; REAL_MONEY_ACTIONS_0; CHECKOUT_SUBMISSIONS_0; PROVIDER_MUTATIONS_0; MODEL_GENERATION_CALLS_0; PRODUCTION_DEPLOYMENT_0; SHARED_INFRA_MUTATIONS_0; PR64_MERGE_0; P1_P12_BUILD_0
ROLLBACK_STATUS_OR_PLAN=Audition artifacts are isolated; existing technical candidate remains recoverable at c0a1f2a... and prior visual candidate at 806907...
OWNER_ONLY_ACTIONS=Choose one visual direction after Reviewer inspection
```

Governance: **vps-project-governance v0.2.7**.

## Why this is a separate audition Gate

Do **not** reskin the whole product again before Owner chooses a direction.

The previous two rounds proved that “premium SaaS” is too vague and different people interpret it differently. This Gate converts that vague request into three explicit visual candidates using identical content and geometry targets.

## Selected reference directions

### STYLE A — LINEAR PRECISION

Reference:
- Linear onboarding / workspace setup / application UI.
- Public screenshot references may be consulted from SaaSUI and other read-only design libraries.

Visual language:
- cool near-white / graphite application shell;
- optional dark graphite navigation/header, but primary form surfaces remain light;
- modern sans typography throughout app chrome;
- compact, precise spacing;
- thin cool-gray borders;
- 10–12px radii rather than large soft “paper” cards;
- indigo/cobalt as one controlled action accent;
- subtle shadows only where hierarchy requires;
- highly deliberate input/focus/selected states;
- restrained density: not empty, not decorative.

What must feel like Linear:
- precision;
- software-tool confidence;
- low visual noise;
- no editorial-paper metaphor in the surrounding UI.

### STYLE B — ATTIO CLEAN DATA-SAAS

Reference:
- Attio onboarding / CRM application UI.

Visual language:
- bright white + cool gray shell;
- strong modular grid;
- crisp panels with subtle elevation;
- almost entirely sans-serif;
- neutral black/gray text;
- tiny blue/green state accents;
- thin dividers, compact badges, clear grouped controls;
- split-panel layouts may be used where they improve the Preview/core-entry;
- photo grid behaves like a polished asset/data manager rather than an album page.

What must feel like Attio:
- high-end B2B SaaS;
- clean information architecture;
- sophisticated without looking decorative.

### STYLE C — STRIPE SOFT-TECH

Reference:
- Stripe onboarding / dashboard / activation flows.

Visual language:
- cool light-gray / very pale blue-lilac application background;
- bright white raised panels;
- more depth/elevation than Linear/Attio;
- 14–18px primary panel radius;
- purple/indigo action color;
- generous but controlled whitespace;
- crisp progress/state badges;
- friendly onboarding copy hierarchy;
- subtle soft color wash is allowed, but no decorative gradient spectacle.

What must feel like Stripe:
- polished;
- trustworthy;
- consumer-friendly premium;
- especially strong for Preview/core-entry and payment/status surfaces.

## Explicitly not selected as the main direction

Cal.com may be consulted for open-source implementation simplicity, but its default monochrome onboarding is **not** one of the three Owner-facing style candidates because this round needs a higher visual differentiation/quality ceiling.

## Shared content for all three auditions

Use identical Birthday Magazine content so only style changes:

### Representative Surface 1 — Homepage Preview/core-entry
Must show:
- free Preview heading/supporting copy;
- name / age / mood controls;
- upload control;
- cover + sample spread;
- CTA to full creation.

The **magazine pages themselves** may remain ivory/editorial because they represent the actual product. The surrounding SaaS shell must not be beige/paper.

### Representative Surface 2 — Core intake, Photos step
Must show:
- 5-step progress;
- 12-photo grid;
- one must-use selection;
- uploader;
- Back / Continue.

### Representative Surface 3 — Status
Must show:
- PAYMENT PENDING;
- one progress timeline/card;
- order/context metadata.

## Photo-fixture rule

**Human/cartoon/SVG-face placeholders are prohibited.**

Use, in order of preference:
1. existing project-local photographic sample assets already approved for visual demos;
2. existing local magazine/sample photography;
3. neutral non-human abstract/geometric image fixtures if photography is insufficient.

Do not invoke image generation merely to create audition placeholders.
Do not introduce external hot-linked image dependencies.

## Audition implementation form

This round should be fast and disposable.

Executor may create isolated static HTML/CSS audition files under:
`birthday-magazine-studio/docs/evidence/g3cr7v2a/style-audition/`

or an equally isolated project-scoped preview artifact.

Do **not** alter the current live application CSS/PHP/JS to produce these auditions.

Each style must use the same DOM/content model as closely as practical so visual differences are attributable to the style system, not rewritten content.

## Required outputs

For each Style A/B/C:

1. homepage Preview/core-entry — 1440px;
2. intake Photos step — 1440px;
3. status — 1440px;
4. intake Photos step — 375px.

Total: **12 full-resolution screenshots**.

Also create:
- one desktop comparison contact sheet: A / B / C side by side for all three surfaces;
- one mobile comparison contact sheet for the 375px intake step;
- a one-page token summary for each style:
  - background;
  - card/surface;
  - text;
  - border;
  - accent;
  - radius;
  - shadow;
  - typography hierarchy.

## Visual acceptance floor

RETURN if:
- the three candidates look like simple color swaps;
- beige/cream/paper dominates the application shell;
- serif typography dominates the SaaS UI;
- screenshots use SVG/cartoon human faces;
- one variant is clearly much less complete than the others;
- style depends on gradients/illustration rather than component quality;
- candidate looks like a landing-page section instead of software.

PASS_CANDIDATE requires three **materially different, production-plausible SaaS systems**.

## Reference fidelity vs copying

Reproduce design principles and component language, not proprietary source code or brand marks.

Do not:
- copy source from Linear/Attio/Stripe;
- use their logos;
- use their proprietary assets;
- import their runtime/design systems.

Local implementation should use plain HTML/CSS and existing project assets for the audition.

## REVIEWER_TO_EXECUTOR_RELAY

Read only:

1. this Gate;
2. `docs/OWNER_DECISION_G3CR7V1_VISUAL_RETURN_V2_2026-10-05.md`;
3. current G3CR7V1 screenshots only to understand rejected baseline content;
4. existing local Birthday Magazine sample assets only as needed for photographic fixtures.

Public read-only references:
- Linear onboarding/UI examples;
- Attio onboarding/UI examples;
- Stripe onboarding/UI examples.

Do not reread broad Governance/project history.
Do not modify current product runtime or business logic.

## EXECUTOR_TO_REVIEWER_RELAY

Return exactly:

```text
结果：PASS_CANDIDATE / RETURN_*
改动：创建 Linear / Attio / Stripe 三套隔离 SaaS 风格试镜，不修改现有产品运行代码。
验证：12 张全尺寸截图 + desktop/mobile 对比总览 + 三套 token 摘要；无 SVG/卡通人脸占位。
问题：NONE，或明确风格/素材阻塞。
回滚：删除隔离 audition 目录即可；当前应用源码和本地 runtime 未修改。
请 Reviewer 检查：A/B/C 三套视觉总览与全尺寸截图。
Owner 转交：NONE。
```

## Stop boundary

Stop after the three auditions. Do not choose a style on behalf of Owner, do not apply any audition to the real product, and do not enter backend/PR merge/P1-P12.
