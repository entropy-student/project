# G3CR6R3D1 — Focusly Homepage Visual Mapping

## Gate

~~~text
GATE_ID=G3CR6R3D1_FOCUSLY_VISUAL_MAPPING
OBJECTIVE=Produce a directly observed Focusly-to-current-homepage visual/motion mapping that is safe to independently implement without changing accepted commerce/account/preview behavior
MAX_ENDPOINT_THIS_ROUND=Reviewer-ready mapping/specification and evidence only; no source/runtime mutation
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Public Focusly reference inspection + current Birthday Magazine homepage read-only inspection + project-scoped documentation
APPLICABLE_CRITICAL_CONSTRAINTS=FREE_PREVIEW_MODEL_CALLS_0; FREE_PREVIEW_SERVER_PHOTO_UPLOADS_0; FREE_PREVIEW_EXTERNAL_IMAGE_POSTS_0; WOO_CANONICAL_ORDER_SYSTEM_YES; REAL_MONEY_ACTIONS_0; PAYPAL_ACTIONS_0; CHECKOUT_SUBMISSIONS_0; RUNTIME_MUTATION_0; PRODUCTION_DEPLOYMENT_0; SHARED_INFRA_MUTATIONS_0; PR64_MERGE_0
PREFLIGHT=Use current PR64 project-scoped baseline; verify Focusly public reference is reachable; verify current local homepage is reachable read-only; identify exact current homepage source/theme/template paths before proposing any mutation
REQUIRED_EVIDENCE=Focusly section inventory; Focusly motion inventory; desktop and mobile visual evidence; current-homepage section/asset/function inventory; protected-function map; Focusly-to-current mapping; asset reuse/generation gap list; independent-implementation plan; license/source boundary
ACCEPTANCE_CRITERIA=See below
ROLLBACK_STATUS_OR_PLAN=Read-only Gate; no runtime rollback required
OWNER_ONLY_ACTIONS=NONE unless a paid/proprietary asset/template/license or new paid model/provider is required
REVIEWER_TO_EXECUTOR_RELAY=SEE_SECTION_BELOW
EXECUTOR_TO_REVIEWER_RELAY=SEE_SECTION_BELOW
~~~

Governance: vps-project-governance v0.2.6.

## Accepted facts

- The existing G3CR6R1 homepage/runtime functional baseline remains accepted.
- Focusly is now an Owner-authorized public visual/motion reference for the homepage only.
- magazine-web-viewer remains the accepted reader direction.
- Core Aha interaction and P1-P12 magazine visual system remain unresolved and are outside this Gate.
- The paid Focusly template itself is not required and must not be copied/extracted.
- Existing project-owned homepage images may be reused.
- Design-time image generation may be proposed where existing assets are insufficient, but no new external paid provider/account/Secret may be introduced in this Gate.

## Focusly reference

Public template page:
- https://webflow.com/templates/html/focusly-website-template

Inspect the actual live public preview when available. Do not infer motion from screenshots alone.

## Required mapping

For each major Focusly homepage section, record:

- visible layout/composition;
- typography hierarchy;
- image ratio/crop and placement;
- spacing/whitespace rhythm;
- background/surface treatment;
- navigation/CTA treatment;
- observed hover/scroll/entrance/transition behavior;
- desktop behavior;
- mobile/responsive behavior where directly observable;
- reduced-motion implication;
- whether the effect can be independently recreated with HTML/CSS/JS in the current WordPress/Gutenberg shell.

For the current Birthday Magazine homepage, record:

- existing major sections/groups;
- source/template/theme paths that control them;
- existing project-owned images and which can be reused;
- CTA destinations and behaviors;
- Free Preview DOM/component boundary;
- Woo/Product/Cart/Checkout/Account navigation boundary;
- any element whose visual wrapper may change but behavior must not.

Then produce a one-to-one mapping:

~~~text
FOCUSLY_REFERENCE_SECTION
-> CURRENT_BIRTHDAY_MAGAZINE_SECTION
-> KEEP / RESTYLE / REORDER / REPLACE_VISUAL_ONLY
-> EXISTING_ASSET / NEW_PROJECT_ASSET / OPTIONAL_GENERATED_ASSET
-> MOTION_TO_REIMPLEMENT
-> FUNCTIONAL_BEHAVIOR_PRESERVED
~~~

## License/source boundary

Allowed:
- public visual observation;
- independent recreation of general layout, spacing, hierarchy, animation concepts and interaction behavior;
- project-owned assets;
- independently generated project assets.

Not allowed:
- extracting/copying the paid Focusly template source;
- downloading or reusing proprietary Focusly imagery, fonts, logos or protected template assets without explicit compatible rights;
- using a paid template/license as if it were open source.

If a desired visual requires a proprietary asset, substitute an owned/generated/free-compatible asset rather than purchasing or copying it unless Owner separately authorizes that purchase.

## Acceptance criteria

Reviewer PASS requires all of the following:

1. Focusly homepage has been directly inspected, not described from marketing copy alone.
2. At least one desktop and one mobile/responsive evidence view exist for the reference where technically accessible.
3. Every major visible Focusly homepage section and meaningful motion pattern is mapped to the current homepage or explicitly marked not applicable.
4. The current homepage functional paths are identified and protected.
5. No protected backend/payment/account/Preview semantics are proposed for change.
6. Existing assets are inventoried before proposing new generation.
7. Any proposed new generated asset has a clear role and is static design-time content, not a runtime/free-preview model dependency.
8. The implementation plan can be executed independently without proprietary Focusly source/assets.
9. The plan includes desktop + 375px target behavior and reduced-motion fallback.
10. No source/runtime mutation occurs in D1.
11. Reviewer can inspect the captured evidence and mapping before D2 opens.

## Reviewer to Executor relay

Start only from:
1. this Gate;
2. docs/OWNER_DECISION_G3CR6R3D_FOCUSLY_HOMEPAGE_REDESIGN.md;
3. REVIEWER_HANDOFF.md only the SYSTEM_MAP, CRITICAL_CONSTRAINTS and accepted G3CR6R1 boundary;
4. the current homepage source/template files required to identify the exact implementation surface;
5. the public Focusly reference URL.

Do not reread project history.

Use browser inspection/screenshot tooling as available to inspect the actual Focusly preview and the current local homepage. This Gate is read-only: do not modify WordPress content, source, CSS, JS, media, Woo settings, runtime, database, or PR topology.

Do not attempt to download/extract the paid Webflow template source.

Deliver a compact mapping/spec and evidence that a later implementation Agent can follow without needing to rediscover the reference.

Stop at Reviewer.

## Executor to Reviewer relay

~~~text
结果：PASS_CANDIDATE / RETURN_*
改动：只新增 Focusly 视觉拆解、当前首页映射和证据；无运行态/前端代码修改。
验证：说明 Focusly 实际预览、桌面/移动证据、现有首页功能边界和映射是否完整。
问题：NONE，或说明无法直接观察的动效/移动端/许可/本地页面阻塞。
回滚：研究型只读 Gate，无运行态回滚。
请 Reviewer 检查：视觉映射是否足够支持高保真实现，同时确认 Woo/支付/账户/Preview 边界未被打开。
Owner 转交：NONE
~~~
