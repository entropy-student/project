# G3CR6R3D1R2 — Local Homepage Readback Closure

## Gate

~~~text
GATE_ID=G3CR6R3D1R2_LOCAL_HOMEPAGE_READBACK_CLOSURE
OBJECTIVE=Close only the fresh current-local-homepage readback blocker before the Focusly homepage implementation Gate
MAX_ENDPOINT_THIS_ROUND=Reviewer-ready local readback package and D2 implementation recommendation; no homepage or Preview implementation
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Existing retained local Birthday Magazine runtime availability + read-only Home/Woo route inspection + project documentation
APPLICABLE_CRITICAL_CONSTRAINTS=FREE_PREVIEW_MODEL_CALLS_0; FREE_PREVIEW_SERVER_PHOTO_UPLOADS_0; FREE_PREVIEW_EXTERNAL_IMAGE_POSTS_0; CURRENT_UPLOAD_PREVIEW_KEEP_AS_IS; WOO_CANONICAL_ORDER_SYSTEM_YES; REAL_MONEY_ACTIONS_0; PAYPAL_ACTIONS_0; CHECKOUT_SUBMISSIONS_0; FRONTEND_MUTATION_0; WORDPRESS_CONTENT_MUTATION_0; DATABASE_BUSINESS_MUTATION_0; PRODUCTION_DEPLOYMENT_0; SHARED_INFRA_MUTATIONS_0; PR64_MERGE_0
PREFLIGHT=Reuse accepted D1 Focusly evidence; prove project-scoped source freshness; inspect Docker/runtime state before any start action; use only the existing retained project runtime
REQUIRED_EVIDENCE=Runtime availability path; exact retained project-container identity; fresh Home desktop+375px readback; fresh Home group/anchor/Preview presence; active theme/template/menu/CTA readback; read-only Product/Cart/Checkout/Account route readback; protected-function no-drift map; D2 exact mutation-surface recommendation
ACCEPTANCE_CRITERIA=See below
ROLLBACK_STATUS_OR_PLAN=No application/content mutation; any bounded local runtime start is reversible and must be recorded; no rebuild/pull/recreate/reset/migration/config change
OWNER_ONLY_ACTIONS=NONE unless Docker Desktop requires GUI/elevation/login/update/install action that Executor cannot safely perform
REVIEWER_TO_EXECUTOR_RELAY=SEE_BELOW
EXECUTOR_TO_REVIEWER_RELAY=SEE_BELOW
~~~

Governance: vps-project-governance v0.2.6.

## Reuse, do not replay

Reuse:
- `docs/G3CR6R3D1_FOCUSLY_VISUAL_MAPPING_REPORT.md`
- `docs/evidence/g3cr6r3d1/`
- `docs/REVIEWER_DECISION_G3CR6R3D1_RETURN_SCOPE_RECONCILIATION_2026-10-04.md`
- `docs/OWNER_DECISION_G3CR6R3D_PREVIEW_INTERACTION_HOLD_2026-10-04.md`

Do not re-crawl Focusly and do not redo the 66 screenshots unless one narrowly missing fact is required.

Do not benchmark or redesign the upload/Preview interaction. The current interaction remains unchanged.

## Bounded local-runtime availability path

1. Read current Docker Desktop/engine state and project runtime state first.
2. If Docker Desktop is installed but its engine is not running, Executor may perform only the smallest reversible availability action to start the existing installed Docker Desktop process.
3. Do not install, update, reconfigure, reset, sign in, elevate, or modify global Docker settings.
4. Once the engine is available, inspect the exact retained Birthday Magazine project containers.
5. If those existing project containers are merely stopped, starting those exact existing containers is allowed.
6. Do **not** use any action that would build, pull, recreate, replace, reset volumes, run migrations, or create a new runtime.
7. If the retained containers are missing or safe availability requires any forbidden action, RETURN precisely.
8. If Docker Desktop requires Owner GUI/elevation/login/update intervention, RETURN `RETURN_OWNER_RUNTIME_START_REQUIRED` with the smallest exact Owner action.

## Fresh readback

Read-only verification must settle:

- current Home page renders at localhost:8189;
- desktop 1440px and mobile 375px visual readback;
- current major Gutenberg groups/section anchors;
- current Preview component is present and its existing upload/replace/remove behavior remains the accepted unchanged boundary;
- active theme/template shell;
- current menu and CTA destinations, including Preview/Product/Account paths;
- Product, Cart, Checkout and My Account routes are reachable read-only;
- no evidence that Woo/payment/account/private-workspace semantics drifted.

Do not Add to Cart, submit Checkout, invoke PayPal, create orders, modify accounts, upload customer photos to a server, or call a model.

## Acceptance criteria

PASS_CANDIDATE requires:

1. D1 Focusly evidence remains reviewable and is reused rather than replayed.
2. Fresh current local homepage/runtime readback succeeds.
3. Desktop 1440px and 375px current-home evidence exists.
4. Current Home groups/anchors/template/menu/CTA/Preview presence are identified from current runtime, not inferred only from historical source.
5. Existing upload/Preview interaction is explicitly preserved unchanged.
6. Product/Cart/Checkout/Account routes are read successfully without business submission/mutation.
7. Protected Woo/payment/account/private-workspace logic remains outside the proposed D2 mutation surface.
8. Any runtime availability action used only the retained existing runtime with no build/pull/recreate/reset/migration/config change.
9. Reviewer receives an exact D2 homepage-only mutation/rollback/evidence recommendation.
10. No homepage/Preview implementation occurs in this Gate.

## Reviewer to Executor relay

Read only:
1. this Gate;
2. `docs/REVIEWER_DECISION_G3CR6R3D1_RETURN_SCOPE_RECONCILIATION_2026-10-04.md`;
3. `docs/OWNER_DECISION_G3CR6R3D_PREVIEW_INTERACTION_HOLD_2026-10-04.md`;
4. existing D1 mapping report/evidence;
5. current source files required only to correlate the fresh local readback.

Do not reread full project history.
Do not redo Focusly research.
Do not perform Preview benchmark research.
Do not implement yet.

Stop at Reviewer.

## Executor to Reviewer relay

~~~text
结果：PASS_CANDIDATE / RETURN_*
改动：只恢复/读取既有本地运行态并补 fresh homepage readback 证据；不改首页或 Preview。
验证：说明 Docker/既有容器状态、当前首页桌面+375px、Groups/anchors/menu/CTA/Preview、Product/Cart/Checkout/Account 只读结果。
问题：NONE，或精确说明为何既有 runtime 无法安全启动/读取。
回滚：说明是否启动了 Docker/既有容器，以及当前保留状态；无应用/内容修改。
请 Reviewer 检查：是否已满足打开 Focusly 首页 D2 实现 Gate 的最后前提。
Owner 转交：NONE，或最小 runtime 启动动作。
~~~
