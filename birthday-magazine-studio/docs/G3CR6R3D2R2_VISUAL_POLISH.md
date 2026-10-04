# G3CR6R3D2R2 — Focusly Visual Polish

## Gate

~~~text
GATE_ID=G3CR6R3D2R2_VISUAL_POLISH
OBJECTIVE=Close the directly observed visual-quality gap in the existing Focusly-inspired homepage without reopening accepted Preview/commerce/account behavior
MAX_ENDPOINT_THIS_ROUND=Polished local homepage candidate + regression evidence + new Owner-relayed visual contact sheet; no PR merge, production deploy, P1-P12 work or core-Aha redesign
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Home 858 presentation + homepage-scoped CSS/motion + static homepage marketing assets + compact mobile header treatment; existing Preview internals and protected business logic frozen
APPLICABLE_CRITICAL_CONSTRAINTS=CURRENT_UPLOAD_PREVIEW_KEEP_AS_IS; FREE_PREVIEW_MODEL_CALLS_0; FREE_PREVIEW_SERVER_PHOTO_UPLOADS_0; FREE_PREVIEW_EXTERNAL_IMAGE_POSTS_0; WOO_CANONICAL_ORDER_SYSTEM_YES; REAL_MONEY_ACTIONS_0; PAYPAL_ACTIONS_0; CHECKOUT_SUBMISSIONS_0; ORDER_CREATION_0; PRODUCTION_DEPLOYMENT_0; SHARED_INFRA_MUTATIONS_0; PR64_MERGE_0; CORE_AHA_CHANGE_0; P1_P12_VISUAL_CHANGE_0
PREFLIGHT=Use current D2 candidate and D2R1 evidence as accepted baseline; create a new R2 scoped rollback for every touched Home/source/asset surface before mutation; do not replay Focusly research
REQUIRED_EVIDENCE=Exact diff; generated-asset provenance/call count if used; 1440+375 full-page and required section screenshots; motion/reduced/no-JS checks; Preview/Woo source correlation; rollback proof; new labeled Focusly-vs-R2 contact sheet saved locally and committed for Owner relay
ACCEPTANCE_CRITERIA=See below
ROLLBACK_STATUS_OR_PLAN=New R2 scoped rollback restores the accepted D2 candidate only; do not roll back to pre-D2 unless Reviewer later directs it
OWNER_ONLY_ACTIONS=Owner manually uploads the final R2 contact sheet to current ChatGPT conversation; new external paid model/provider/API/Secret remains Owner-only
REVIEWER_TO_EXECUTOR_RELAY=SEE_BELOW
EXECUTOR_TO_REVIEWER_RELAY=SEE_BELOW
~~~

Governance: vps-project-governance v0.2.6.

## Accepted baseline — do not replay

Preserve and build from the existing D2 candidate.

Already accepted:
- Hero direction;
- editorial split direction;
- photographic dark-panel direction;
- dark closing direction;
- typography/paper/dark visual language;
- actual motion implementation;
- reduced-motion and no-JS fallback;
- Preview/Woo/account/payment freeze;
- mobile samples-anchor fix;
- font provenance;
- rollback mechanics.

Do not restart template research or reconstruct D2 from scratch.

## Required visual repairs

### 1. Samples / Selected Work — mandatory

This is the primary repair.

Current problem:
- vertical cover is too small inside an oversized pale card;
- too much dead empty space;
- weak visual impact compared with Focusly's dominant Selected Work card.

Repair requirements:
- make each Samples card a visually dominant editorial object on desktop;
- target card width should be close to the main page/content width rather than a small centered poster;
- the primary visual should occupy most of the card surface;
- preserve the three-card scroll/perspective behavior;
- each of the three cards should have a meaningfully different visual composition, not the same small cover dropped into the same frame;
- mobile cards remain near full available width with deliberate image hierarchy;
- keep samples explicitly fictional/illustrative.

A strong solution may combine:
- magazine cover;
- spread/product mockup;
- original editorial birthday/lifestyle imagery;
- composed magazine-in-context scenes.

Do not introduce a blank-editor or P1-P12 authoring interface.

### 2. Reduce major-section imagery repetition — mandatory

Do not use the same dominant Mira/gift image treatment as the main photographic impression for multiple consecutive major sections.

At minimum:
- Hero may retain the current product-focused magazine scene;
- at least two other major photographic sections must use materially different original visuals/compositions.

The Owner's quality-first image-generation authorization is active.

~~~text
DESIGN_TIME_IMAGE_GENERATION=AUTHORIZED_QUALITY_FIRST
ARTIFICIAL_LOW_CALL_CAP=NONE
RUNTIME_PREVIEW_MODEL_CALLS=0
NEW_EXTERNAL_PAID_PROVIDER_OR_SECRET=NO
~~~

If existing assets cannot achieve sufficient diversity and polish, generate original static marketing assets.

Do not copy Focusly photography. Any generated people must be fictional/non-customer subjects.

For all generation calls record:
- total call count including rejected iterations;
- prompt/purpose;
- adopted asset path;
- section where used;
- whether it replaced or supplemented an existing asset.

### 3. Mobile header refinement — mandatory

At 375px:
- brand/name must remain comfortably readable;
- menu shell must not feel horizontally squeezed;
- preserve the native menu trigger and accessibility behavior;
- do not alter menu destinations except the already-accepted Samples fix.

Visual compression/abbreviation of presentation may be used only if the product identity remains clear.

### 4. Mobile rhythm — bounded polish

Tighten nonfunctional vertical gaps and strengthen section-to-section contrast so the mobile page feels like an editorial sequence rather than a stack of generic landing-page blocks.

Do not remove:
- Preview;
- product facts;
- price/offer;
- FAQ;
- conversion paths;
- accessibility/fallback content.

Do not force the page to match Focusly's exact total pixel height; the Birthday Magazine page has additional product responsibilities.

## Optional polish

Allowed only where it materially improves the whole:
- refine Hero crop/negative space;
- adjust desktop heading scale/line breaks;
- refine panel/card corner radii;
- improve small labels/dots;
- refine closing decorative-image placement.

Do not destabilize sections already visually strong merely for novelty.

## Frozen Preview / commerce boundary

Do not modify:
- `preview.js`;
- `magazine-preview.css`;
- Preview shortcode internals;
- upload/replace/remove behavior;
- object-URL/local-photo processing;
- product/cart/checkout/account/payment/workspace/entitlement semantics;
- prices/currency/product identity;
- P1-P12 system;
- core Aha interaction.

Outer Preview-section styling may be adjusted only if the component itself remains materially unchanged.

## Regression acceptance

PASS_CANDIDATE requires:

1. Primary Samples card is no longer a small poster floating in a large empty box; it is a strong large-scale editorial visual comparable in presence to the Focusly reference.
2. All three Samples cards have distinct, intentional compositions.
3. Major-section dominant imagery is sufficiently varied; the page no longer appears to reuse the same Mira/gift scene repeatedly.
4. Mobile header reads as deliberate and comfortable at 375px.
5. Mobile visual rhythm is tighter without removing functional content.
6. Hero, editorial split, dark panel and closing do not regress from the accepted D2 direction.
7. Desktop 1440 and mobile 375 have no horizontal overflow, broken images, page errors or failed required resources.
8. Motion, reduced-motion and no-JS fallback continue to pass.
9. Preview internals/behavior and protected Woo/account/payment/private-workspace logic remain unchanged.
10. Eight editable Gutenberg Groups and six required anchors remain intact.
11. Product 1113 remains virtual USD 39.99.
12. No Add-to-Cart, checkout submission, order, PayPal, production or shared-infra action occurs.
13. Any generated marketing assets are original, static, non-customer, provenance-recorded and not part of runtime Preview.
14. New R2 rollback package can restore the accepted D2 candidate.
15. PR #64 remains unmerged.

## Required visual evidence

Capture new R2 evidence after the repair:

- desktop 1440 full homepage;
- mobile 375 full homepage;
- desktop Hero;
- desktop editorial split;
- desktop dark panel;
- desktop Samples plus at least two different scroll-card states;
- desktop Closing;
- mobile Hero/header/menu;
- mobile Samples;
- mobile Closing;
- reduced-motion desktop/mobile;
- no-JS desktop/mobile.

Also create:

`docs/evidence/g3cr6r3d2r2/reviewer-visual-contact-sheet-r2.jpg`

Side-by-side against the same accepted D1 Focusly reference frames, with special emphasis on:
- Samples;
- repeated-imagery repair;
- mobile header/rhythm.

Save locally and commit to PR evidence. Report exact local absolute path so Owner can upload it directly to the current ChatGPT conversation.

## Reviewer to Executor relay

Read only:
1. this Gate;
2. `docs/REVIEWER_DECISION_G3CR6R3D2_RETURN_VISUAL_QUALITY.md`;
3. `docs/OWNER_DECISION_G3CR6R3D2_IMAGE_GENERATION_QUALITY_PRIORITY_2026-10-04.md`;
4. existing D2 source and current Home 858;
5. existing D1 reference frames and D2R1 contact-sheet/manifest only as comparison evidence.

Do not reread full project history.
Do not redo Focusly research.
Do not alter Preview or business logic.

## Executor to Reviewer relay

~~~text
结果：PASS_CANDIDATE / RETURN_*
改动：说明 Samples、素材多样性、移动 Header/节奏的实际视觉修复，以及生图是否发生。
验证：1440/375、动效、reduced/no-JS、Preview/Woo 冻结、图片生成总调用数、R2 联系表路径。
问题：NONE，或精确说明仍未满足的视觉/版权/运行态问题。
回滚：说明 R2 如何只恢复到已接受的 D2 candidate。
请 Reviewer 检查：Owner 上传 R2 联系表后，重新判断视觉质量与 Focusly 对标是否正式 PASS。
Owner 转交：请将本地 reviewer-visual-contact-sheet-r2.jpg 直接上传到当前 ChatGPT 对话。
~~~
