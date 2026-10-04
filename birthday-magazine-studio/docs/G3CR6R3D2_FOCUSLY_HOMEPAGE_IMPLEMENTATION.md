# G3CR6R3D2 — Focusly Homepage Implementation

## Gate

~~~text
GATE_ID=G3CR6R3D2_FOCUSLY_HOMEPAGE_IMPLEMENTATION
OBJECTIVE=Independently implement a high-fidelity Focusly-inspired Birthday Magazine homepage using the accepted public-reference mapping while preserving the current Preview, WooCommerce, account, payment and private-workspace behavior
MAX_ENDPOINT_THIS_ROUND=Implemented local homepage candidate + regression/evidence package + Owner visual-review candidate; no PR merge, production deploy, payment action, core-Aha redesign or P1-P12 redesign
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Local Birthday Magazine Home 858 + homepage-scoped CSS/motion JS + narrowly required homepage enqueue + one bounded mobile sample-anchor correction; current Preview interaction and commerce/account backend remain frozen
APPLICABLE_CRITICAL_CONSTRAINTS=FREE_PREVIEW_MODEL_CALLS_0; FREE_PREVIEW_SERVER_PHOTO_UPLOADS_0; FREE_PREVIEW_EXTERNAL_IMAGE_POSTS_0; CURRENT_UPLOAD_PREVIEW_KEEP_AS_IS; WOO_CANONICAL_ORDER_SYSTEM_YES; AUTHENTICATED_ACCOUNT_MVP_YES; REAL_MONEY_ACTIONS_0; PAYPAL_ACTIONS_0; CHECKOUT_SUBMISSIONS_0; ORDER_CREATION_0; PRODUCTION_DEPLOYMENT_0; SHARED_INFRA_MUTATIONS_0; PR64_MERGE_0; CORE_AHA_CHANGE_0; P1_P12_VISUAL_CHANGE_0
PREFLIGHT=Use PR64 branch at or descended from reviewed D1R2 commit 7a0a16cf0169980443f8bb760f7f9e919ff0d68c; project-scoped main freshness only; retained local runtime must still identify the same Home/product/plugin/theme baseline; create scoped rollback artifacts before first mutation
REQUIRED_EVIDENCE=Pre-change rollback package; implementation diff; 1440 and 375 full-home/section screenshots; motion-state evidence; mobile-menu evidence; reduced-motion and no-JS fallback proof; Home Groups/anchors/editability readback; Preview unchanged proof; Woo/Product/Cart/Checkout/Account read-only regression; source/config hash correlation; generated-asset provenance if any; rollback verification; post-write resource/runtime readback
ACCEPTANCE_CRITERIA=See below
ROLLBACK_STATUS_OR_PLAN=Snapshot Home 858 content/hash, touched source files and any explicitly touched menu object before mutation; rollback restores only those touched surfaces and verifies hashes/anchors/routes; no DB/volume reset
OWNER_ONLY_ACTIONS=NONE within this Gate; any paid template/font/asset/provider purchase, new external model account/API, real payment, production enablement or new legal-content decision returns to Owner
REVIEWER_TO_EXECUTOR_RELAY=SEE_BELOW
EXECUTOR_TO_REVIEWER_RELAY=SEE_BELOW
~~~

Governance: vps-project-governance v0.2.6.

## Accepted inputs

Reuse and do not replay:

1. `docs/REVIEWER_DECISION_G3CR6R3D1R2_PASS.md`
2. `docs/G3CR6R3D1_FOCUSLY_VISUAL_MAPPING_REPORT.md`
3. `docs/evidence/g3cr6r3d1/` — accepted Focusly public visual/motion evidence and 66 screenshots
4. `docs/evidence/g3cr6r3d1r2/` — current local homepage readback
5. `docs/OWNER_DECISION_G3CR6R3D_PREVIEW_INTERACTION_HOLD_2026-10-04.md`
6. current target files named below.

Do not crawl Focusly again unless one narrowly missing implementation fact cannot be resolved from the accepted evidence.

## Visual objective

The Owner wants the homepage to be **visually and behaviorally very close to the publicly observable Focusly Home 1 reference**, while using Birthday Magazine Studio content, owned/rights-compatible assets and an independent implementation.

Preserve the reference's major observable language where it fits the product:

- dark compact/capsule navigation treatment;
- dramatic photographic Hero with a focus/viewfinder composition;
- warm paper-like background;
- large editorial serif headings with restrained sans-serif utility text;
- alternating large image + copy compositions;
- full-width image sections with readable translucent/dark text panels;
- rounded imagery/cards;
- Selected Work-style editorial sample-card progression;
- restrained hover label transitions;
- scroll-triggered image/title entrances;
- a strong dark closing section;
- mobile-specific simplification rather than desktop effects squeezed into 375px.

Differences are allowed/required where necessary for:
- Birthday Magazine content;
- product clarity and conversion;
- accessibility;
- reduced motion / no-JS;
- mobile usability;
- legal/source rights;
- preserving existing functional controls.

Do not copy/extract Focusly's paid template source, proprietary images, logos, original brand content, or unverified font files.

## Allowed implementation surface

### 1. Home 858 Gutenberg presentation

May:
- reorder the existing eight major Home Groups to better match the accepted Focusly mapping;
- rewrite presentation copy only where necessary to fit the new visual hierarchy, while preserving the accepted product facts and offer;
- rearrange image/text/button blocks inside those Groups;
- preserve or explicitly remap these required anchors:
  - `#samples`
  - `#preview`
  - `#what-you-get`
  - `#how-it-works`
  - `#offer`
  - `#faq`
- use existing owned cover/spread/gift assets.

Must preserve:
- Free Preview as a real functional surface;
- native product CTA;
- account path;
- 12-page digital-PDF / US$39.99 facts;
- ordinary Gutenberg editability.

### 2. Homepage CSS

Primary target:
- `birthday-magazine-studio/poc/g3c/preview-plugin/home.css`

May add/rework homepage-scoped visual CSS needed for the Focusly-inspired composition.

Do not edit Woo route stylesheets merely to make the homepage pass.

### 3. Homepage motion

May add:
- `birthday-magazine-studio/poc/g3c/preview-plugin/home-motion.js`

Use original implementation for bounded display-only motion:
- entrance/focus composition;
- clipped label/CTA hover;
- once-only title/image reveals;
- bounded background/parallax treatment where safe;
- sample-card perspective/reveal;
- dark closing-section reveal.

Requirements:
- no interception of forms/file controls/Woo buttons/auth/payment;
- no horizontal-scroll hijacking;
- no long pinned blank mobile regions;
- content visible if JS fails;
- explicit `prefers-reduced-motion` fallback;
- 375px layout must not rely on hover.

### 4. Enqueue

`birthday-magazine-poc.php` may be changed only if needed to enqueue the new homepage presentation controller behind an `is_front_page()` guard.

Do not change the Preview shortcode markup/behavior, product hooks, account hooks, Woo hooks, workspace ownership/entitlement logic or provider logic.

### 5. Mobile sample-anchor repair

D2 may correct exactly:

`/#sample-pages` -> `/#samples`

for the positively identified existing mobile navigation item.

Before mutation:
- snapshot the exact menu object/value;
- verify cardinality/identity;
- do not change any other menu destination.

### 6. Footer privacy link

Read-only preflight may inspect WordPress's configured privacy-policy page.

If and only if:
- WordPress currently identifies a published intended privacy-policy page; and
- the existing empty footer Privacy policy item can be unambiguously correlated to it;

then D2 may wire that existing link to the canonical page.

Otherwise:
- do not create/invent policy text or URL;
- leave it unchanged;
- report it as a known issue.

## Preview hold

The current upload/Preview interaction is **not redesigned in D2**.

Frozen:
- Preview JS;
- Preview shortcode internals;
- upload/select/replace/remove behavior;
- browser-local object-URL processing;
- zero server/external image upload;
- zero runtime model calls.

The outer homepage section surrounding Preview may receive background/spacing/layout styling, but the `[data-bms-preview]` component's internal interaction/layout must remain materially unchanged.

## Asset policy

Owner quality-first update:
- `docs/OWNER_DECISION_G3CR6R3D2_IMAGE_GENERATION_QUALITY_PRIORITY_2026-10-04.md`

Use existing owned assets where they are genuinely strong enough, but **do not lower the final visual quality merely to avoid image generation**.

Design-time image generation is authorized whenever it materially improves composition, visual coherence, product clarity, or fidelity to the approved Focusly-inspired direction.

~~~text
DESIGN_TIME_IMAGE_GENERATION=AUTHORIZED_QUALITY_FIRST
ARTIFICIAL_LOW_CALL_CAP=NONE
RUNTIME_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0
NEW_EXTERNAL_PAID_PROVIDER_OR_SECRET=NO
~~~

Any generated asset must:
- be static homepage marketing/design content;
- depict fictional/non-customer people if people are present;
- avoid claims of actual customer output;
- have prompt/purpose, adopted file/path and usage recorded;
- not be required for runtime Preview behavior.

Total generation call count must be recorded in execution evidence, including rejected iterations. Rejected intermediate images do not need to be committed.

Do not copy Focusly proprietary photography. Generate original replacement assets when the existing project imagery would materially weaken the result.

## Preflight and rollback

Before first mutation:

1. Confirm PR64 current head descends from D1R2 reviewed commit or reconcile only Birthday Magazine project-scoped drift.
2. Confirm retained runtime identity and Home 858/product/plugin/theme baseline.
3. Capture rollback artifacts for:
   - Home 858 full content + hash;
   - `home.css`;
   - `birthday-magazine-poc.php` if touched;
   - new/previous `home-motion.js` state;
   - exact mobile-menu object if the anchor repair is performed;
   - footer link object only if the conditional privacy repair becomes eligible.
4. Do not run historical redesign/install scripts blindly.
5. Do not rebuild/pull/recreate/reset/migrate the retained Docker runtime.

## Acceptance criteria

PASS_CANDIDATE requires all of the following:

1. Homepage is independently implemented and materially reflects the accepted Focusly public reference at 1440px and 375px.
2. Every major existing product-information responsibility remains present, readable and truthful.
3. All six required Home anchors exist exactly once and work.
4. The old mobile `#sample-pages` target is corrected to `#samples`, or the Executor proves the identified object is no longer present/relevant before mutation.
5. Preview component internals and behavior remain unchanged; its source hashes or exact approved equivalent prove no Preview implementation drift.
6. No server/external photo upload or runtime model dependency is introduced.
7. Product1113 remains USD39.99/virtual and canonical WooCommerce remains the order system.
8. Product, Cart, Checkout and My Account remain reachable by read-only regression; empty-cart Checkout redirect is acceptable and does not require form proof.
9. No PayPal/payment/order/account/business mutation occurs.
10. Desktop 1440px has no horizontal overflow, broken images, page errors or failed required resources.
11. Mobile 375px has no horizontal overflow, clipped required content, unusable menu/CTA or desktop-only hover dependency.
12. Meaningful motion is demonstrated with state evidence; it is not merely static CSS imitation.
13. `prefers-reduced-motion` yields a complete readable page with nonessential motion removed.
14. With homepage motion JS disabled/unavailable, content and canonical links remain usable.
15. Existing Gutenberg editability is preserved.
16. Rights boundary is clean: no proprietary Focusly source/assets/fonts copied.
17. Image-generation usage is quality-driven rather than capped at 2; total calls and adopted-asset provenance are recorded, and all generation remains static-design-time only.
18. Footer Privacy policy behavior follows the conditional rule above; an unresolved destination does not block D2 if no valid existing page exists.
19. Rollback package is complete and a dry/read-only restore correlation proves touched surfaces can be restored.
20. PR #64 remains unmerged and production/shared infrastructure remain untouched.

## Required visual evidence

At minimum:

- desktop 1440 full homepage;
- mobile 375 full homepage;
- Hero desktop/mobile;
- each major mapped section;
- Preview section proving current component retained;
- samples motion at multiple scroll states;
- one hover/focus state where applicable;
- mobile menu open;
- reduced-motion desktop/mobile;
- no-JS/static fallback;
- closing section;
- Product/Cart/Checkout/Account read-only route screenshots or equivalent browser evidence.

The Executor may capture additional states as needed.

## Reviewer to Executor relay

Read only:

1. this Gate;
2. `docs/REVIEWER_DECISION_G3CR6R3D1R2_PASS.md`;
3. `docs/OWNER_DECISION_G3CR6R3D_PREVIEW_INTERACTION_HOLD_2026-10-04.md`;
4. `docs/G3CR6R3D1_FOCUSLY_VISUAL_MAPPING_REPORT.md`;
5. `docs/evidence/g3cr6r3d1/` only as the visual/motion reference evidence;
6. `docs/evidence/g3cr6r3d1r2/` only for the current local baseline;
7. Home 858 and the exact target source/menu objects listed by this Gate.

Do not reread the full project history.
Do not redo template research.
Do not redesign Preview.
Do not touch P1-P12 or the unresolved core Aha interaction.

Stop after implementation + evidence at Reviewer. Do not merge PR #64.

## Executor to Reviewer relay

~~~text
结果：PASS_CANDIDATE / RETURN_*
改动：一句话说明 Focusly-inspired 首页视觉/动效实际改动，以及是否修复了 mobile samples anchor / privacy link。
验证：概括 1440+375、动效、reduced-motion/no-JS、Preview 保持、Woo 只读回归、图片生成次数。
问题：NONE，或精确说明视觉/功能/版权/运行态阻塞。
回滚：说明 Home/source/menu rollback 包和当前本地 runtime 状态。
请 Reviewer 检查：视觉相似度、移动端、动效质量、Preview/Woo/账户冻结边界以及是否可进入 Owner 视觉确认。
Owner 转交：NONE
~~~
