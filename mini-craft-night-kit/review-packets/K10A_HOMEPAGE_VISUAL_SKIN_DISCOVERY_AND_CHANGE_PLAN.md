# K10A — Homepage Visual Skin Discovery and Change Plan

Status: AUTHORIZED_READONLY_DISCOVERY
Date: 2026-10-05

## GATE_ID

`K10A_HOMEPAGE_VISUAL_SKIN_DISCOVERY_AND_CHANGE_PLAN`

## OBJECTIVE

Prepare a safe production-only homepage visual refresh for Mini Craft Night Kit.

The business/runtime behavior remains Mini Craft's existing WordPress + WooCommerce implementation. The visual target is Homira-inspired, using only the Owner-selected homepage sections:

`H0 + H1 + H3 + H5 + H6 + H10`

This Gate does **not** implement the redesign. It establishes the real VPS implementation surface, exact rollback boundary, and an Executor-usable visual reference map so the later implementation Gate can change only the homepage presentation layer.

## MAX_ENDPOINT_THIS_ROUND

Read-only discovery + durable Evidence/Handoff only.

No production mutation.
No WordPress content write.
No CSS/JS/theme/plugin write.
No database mutation.
No Docker recreate/restart.
No ingress/network change.
No product/order/payment/refund action.
No image generation.

## MANDATORY_REVIEW_STOP

Stop at Reviewer after the discovery packet and Evidence are persisted and freshly read back.

Do not continue into implementation in this Gate.

## TARGET_AND_SCOPE

Production target:
- site: `https://minicraft.spikersun.com/`
- project: `mini-craft-night-kit`
- VPS project namespace: `/srv/apps/mini-craft-night-kit`
- durable data namespace: `/srv/data/mini-craft-night-kit`
- shared host: `srv1970241`
- normal management path: strict SSH as recorded in `shared-vps-infrastructure/SHARED_VPS_HANDOFF.md`

Reference:
- Webflow template page: `https://webflow.com/templates/html/homira-website-template`
- live Homira demo: `https://homiras.webflow.io/`

Current business baseline remains frozen:
- WordPress / Kadence / WooCommerce functionality stays Mini Craft's own.
- Product, Shop, Cart, Checkout, FAQ, Shipping & Returns, Contact, payment/provider configuration, orders and database semantics are outside the redesign scope.
- Other public pages must remain visually/functionally unchanged by the later implementation.
- Real commerce remains disabled and Soft Launch remains unauthorized.

## HOMIRA_REFERENCE_MAP

The H labels below are the stable reference vocabulary for this project. Executor must view the live Homira demo directly in a browser and capture enough screenshots/read-back to prove the correct sections were identified. These labels describe **what visual role we want**, not an implementation recipe.

### H0 — Header / Navigation
Reference: Homira top navigation/header.

Desired Mini Craft role:
- preserve Mini Craft logo/brand, existing navigation destinations, cart destination and homepage CTA behavior;
- use Homira's visual language/interaction feel for the homepage header only;
- do not assume the global site header must be replaced.

### H1 — Hero
Reference: Homira opening full-width visual section beginning with “Elevate Your Living Space with Homira”.

Desired Mini Craft role:
- primary first-screen brand impact;
- use Mini Craft's existing or later-replaceable image/content;
- retain Mini Craft's own conversion destination;
- visual composition and motion should clearly reference the Homira section without copying Homira assets.

### H3 — Selected Projects
Reference: Homira “Selected Projects” section.

Desired Mini Craft role:
- become Mini Craft's featured experience/product presentation area;
- temporary placeholder product/experience imagery is allowed;
- final images/text/links must remain replaceable later without redesigning the section;
- the business destination remains Mini Craft's existing product/shop URLs.

### H5 — Design Process
Reference: Homira “Design Process” numbered sequence.

Desired Mini Craft role:
- explain the Mini Craft night/process using Mini Craft content;
- preserve the visual rhythm and motion character of the reference section;
- content semantics remain Mini Craft's own.

### H6 — Visual Brand Break
Reference: Homira section beginning “LUXURY LIVES HERE” / large visual brand statement.

Desired Mini Craft role:
- act as the strong visual/emotional midpoint;
- use Mini Craft imagery and copy;
- the section should feel like a deliberate visual pause/high point rather than another product-information grid.

### H10 — Closing CTA
Reference: Homira final large CTA beginning “Got a project in mind let’s connect”.

Desired Mini Craft role:
- final conversion section;
- Mini Craft copy and existing Shop/Product destination;
- reference Homira's scale, visual confidence and motion character.

## VISUAL INTENT

Owner intent:
- this is a **skin replacement**, not a business-system rebuild;
- functions remain Mini Craft's own;
- Homira is a reference for visual structure, typography, spacing, image treatment, interaction and motion character;
- do not prescribe animation values or exact technical implementation to Executor;
- Executor chooses the implementation method that best satisfies the visual target while preserving the frozen runtime/business boundaries;
- do not copy/download Homira proprietary imagery, brand content, or licensed source assets/code as production assets unless separately licensed/authorized.

## APPLICABLE_CRITICAL_CONSTRAINTS

- Production-only reality: the old local Mini Craft runtime/workspace is decommissioned and is not the target.
- Existing K9 closeout PASS remains accepted; do not replay K0–K9.
- Strict SSH remains the normal management path; Hostinger console is fallback only.
- Shared infrastructure is frozen: no SSH/UFW/cloudflared/shared-network/host-wide Docker changes.
- MariaDB and all durable Mini Craft data remain untouched in this Gate.
- Secret values must never be emitted/read into ordinary Evidence.
- No broad Docker/system cleanup.
- Current public site must remain unchanged throughout K10A.

## PREFLIGHT

1. Fresh-read the exact pointers named in `REVIEWER_TO_EXECUTOR_RELAY`; do not broadly replay project history.
2. Verify canonical GitHub project source/ref and current Gate packet.
3. Verify the recorded strict SSH identity/trust tuple and run only the bounded read-only target identity probe.
4. Freshly prove target host/user/OS and current Mini Craft project/runtime identity.
5. Freshly verify the public homepage is reachable before discovery.
6. Confirm no production write authority exists in K10A.

## REQUIRED_DISCOVERY

Determine, from direct production read-back:

1. **Homepage implementation surface**
   - current WordPress front-page identity/page ID/template;
   - whether the homepage body is stored primarily in WordPress DB/block content, theme/template files, custom CSS/JS, plugin code, or a combination;
   - exact project-owned files/records that would need to change for the visual skin.

2. **Header boundary**
   - whether the current header is global or page-specific;
   - the safest way to achieve H0 on the homepage without unintentionally restyling Product/Cart/Checkout/FAQ/Shipping/Contact.

3. **Frontend/runtime boundary**
   - relevant theme/Kadence/custom code locations;
   - current CSS/JS loading path for the homepage;
   - whether a homepage-only namespace/asset load can be isolated from other pages;
   - no implementation is required yet.

4. **Deployment path**
   - identify the smallest safe production change mechanism for K10B;
   - identify whether changes would require content update, file deployment, container recreate/reload, cache invalidation, or some combination;
   - identify next-start/restart persistence implications.

5. **Rollback boundary**
   - define the exact pre-change recovery artifacts needed for K10B;
   - include page/content rollback plus any wp-content/file rollback actually affected by the chosen implementation;
   - do not create a new production backup in K10A unless it is strictly read-only metadata verification; creation belongs to the write Gate.

6. **Visual reference verification**
   - open the live Homira demo in a browser;
   - identify and capture H0/H1/H3/H5/H6/H10 using the labels above;
   - observe each selected section's layout, image treatment, typography hierarchy, responsive behavior, interaction and motion character;
   - record only the design intent needed for implementation. Do **not** turn the packet into per-pixel/per-millisecond animation instructions.

7. **Regression baseline**
   - record current public behavior/visual baseline for Home, Product, Cart, Checkout, FAQ, Shipping & Returns and Contact sufficiently to prove later that non-home pages were not unintentionally changed;
   - do not create orders, add products, pay, refund, submit contact forms, or alter cart/business state.

## REQUIRED_EVIDENCE

Append a K10A section to `mini-craft-night-kit/EXECUTION_EVIDENCE.md` containing:

- `AUTHORIZED_GATE`
- `PREFLIGHT_FACTS`
- `ACTUAL_CHANGES` (must be documentation/read-only only)
- `OBJECTIVE_READBACK`
- `HOMEPAGE_IMPLEMENTATION_MAP`
- `HOMIRA_REFERENCE_MAP_VERIFIED`
- `HEADER_BOUNDARY`
- `PROPOSED_K10B_CHANGE_SURFACE`
- `PROPOSED_K10B_ROLLBACK_BOUNDARY`
- `REGRESSION_BASELINE`
- `ANOMALIES`
- `EVIDENCE_ARTIFACTS_AND_PURPOSE`
- `EXECUTOR_RESULT`

Screenshots may be referenced as evidence artifacts; do not paste large binary/log payloads into Markdown.

## ACCEPTANCE_CRITERIA

K10A is a PASS_CANDIDATE only if all are true:

- real target host/runtime identity is freshly proven;
- current public homepage remains unchanged and reachable;
- exact homepage implementation surface is identified;
- global-vs-homepage header boundary is identified;
- smallest safe K10B implementation surface is proposed;
- rollback/recovery boundary for that implementation is concrete and reviewable;
- H0/H1/H3/H5/H6/H10 are correctly identified from the live Homira demo and captured in evidence;
- current non-home regression baseline is recorded;
- no production, database, Docker, payment, Provider, Secret, product or shared-infrastructure mutation occurred;
- Evidence and Executor handoff are persisted and freshly read back.

Otherwise RETURN with the narrow blocking reason.

## ROLLBACK_STATUS_OR_PLAN

K10A is read-only; runtime rollback should be `NOT_APPLICABLE`.

For K10B, Executor must propose a concrete pre-change rollback plan based on the discovered implementation surface. Reviewer will approve or revise it before any production mutation.

## OWNER_ONLY_ACTIONS

None in K10A.

Any later action that changes real commerce/Soft Launch, payment/provider state, Secrets, shared infrastructure, or other Owner-only boundaries remains outside this Gate.

## REVIEWER_TO_EXECUTOR_RELAY

Start only from:

1. `mini-craft-night-kit/review-packets/K10A_HOMEPAGE_VISUAL_SKIN_DISCOVERY_AND_CHANGE_PLAN.md`
2. `mini-craft-night-kit/REVIEWER_HANDOFF.md` — read only the newest K10A current-state block once present
3. `mini-craft-night-kit/PROJECT_STORAGE_MANIFEST.md` — project paths/storage/Secret metadata only
4. `shared-vps-infrastructure/SHARED_VPS_HANDOFF.md` — SSH/host/shared-infra contract only
5. the live production site `https://minicraft.spikersun.com/`
6. the live Homira demo `https://homiras.webflow.io/`

Accepted facts:
- K9 closeout is PASS and is not replayed.
- production site remains the only real Mini Craft runtime target.
- local ordinary project runtime/workspace was decommissioned.
- current visual goal is H0 + H1 + H3 + H5 + H6 + H10 only.
- business behavior remains Mini Craft's existing behavior.
- this Gate is read-only discovery only.

Do not reread all Governance/history/Evidence.
Do not implement the redesign.
Do not infer missing production state; prove it or RETURN.

## EXECUTOR_TO_REVIEWER_RELAY

Use exactly:

```text
结果：PASS_CANDIDATE / RETURN_*
改动：一句话说明实际改了什么。
验证：一句话总结关键检查结果；详细证据仍写入 EXECUTION_EVIDENCE。
问题：NONE，或用“短语概括：一句通俗解释”说明阻塞点。
回滚：一句话说明是否可恢复、恢复到哪里。
请 Reviewer 检查：一句话说明需要 Reviewer 核对什么。
Owner 转交：NONE，或写明最小必要转交动作。
```

On PASS_CANDIDATE stop at Reviewer. K10B is not authorized by K10A.
