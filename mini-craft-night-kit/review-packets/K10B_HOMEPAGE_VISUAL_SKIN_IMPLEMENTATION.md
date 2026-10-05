# K10B — Homepage Visual Skin Implementation

Status: AUTHORIZED_PRODUCTION_VISUAL_CHANGE
Date: 2026-10-05

## GATE_ID

`K10B_HOMEPAGE_VISUAL_SKIN_IMPLEMENTATION`

## OBJECTIVE

Replace only the Mini Craft homepage presentation with a Homira-inspired skin using the Owner-selected reference sections:

`H0 + H1 + H3 + H5 + H6 + H10`

Keep Mini Craft's existing WordPress/WooCommerce functionality, URLs, navigation/cart behavior, product/payment state, other pages, shared infrastructure and business semantics unchanged.

This is a visual skin implementation, not a site rebuild.

## MAX_ENDPOINT_THIS_ROUND

K10B may:
1. create the exact prewrite project recovery set required below;
2. create canonical homepage-skin source under the Mini Craft GitHub project;
3. deploy only the approved homepage presentation files under the durable project-owned `wp-content` bind;
4. update only WordPress page `939` content through the application-level WordPress update path;
5. perform public desktop/mobile visual QA and negative regression checks;
6. perform bounded rollback if acceptance fails;
7. persist Evidence / Executor Handoff and stop at Reviewer.

K10B may NOT:
- modify any Product/Shop/Cart/Checkout/FAQ/Shipping & Returns/Contact page content;
- change product price, stock, SKU, purchasability, fulfillment, claims or availability;
- change WooCommerce, PPCP/PayPal, orders, payment/provider state, callback/webhook or real commerce state;
- change `theme_mods_kadence`, menus, active_plugins, vendor theme/plugin files or mixed Custom CSS record `1041`;
- change Compose, cloudflared, shared networks, firewall, SSH, Caddy recovery assets or Docker daemon;
- recreate/restart containers unless a new Reviewer Gate explicitly authorizes it;
- read/output Secret values;
- generate new images in this Gate.

Existing Mini Craft images may be used as replaceable placeholders.

## MANDATORY_REVIEW_STOP

Stop at Reviewer after implementation + QA + durable Evidence.

Do not enter image-generation/final-content polish, commerce activation or any later Gate.

## TARGET_AND_SCOPE

Production:
- site: `https://minicraft.spikersun.com/`
- target host: `srv1970241`
- WordPress homepage: page `939`
- durable wp-content: `/srv/data/mini-craft-night-kit/wp-content`
- project backups: `/srv/backups/mini-craft-night-kit`

Visual reference:
- live Homira demo: `https://homiras.webflow.io/`
- accepted K10A screenshots: `mini-craft-night-kit/evidence/k10a-20261005/`

Stable section vocabulary:
- H0 = Header / Navigation
- H1 = Hero
- H3 = Selected Projects visual pattern -> Mini Craft featured experiences/placeholders
- H5 = Design Process -> Mini Craft night/process
- H6 = large visual brand break
- H10 = closing CTA

The existing global footer remains in place and is not redesigned.

## DESIGN INTENT

Implement the selected Homira visual language, not its business content or proprietary assets/code.

Required direction:
- H0: homepage-only Homira-like inset/glass presentation on the existing native Kadence header; preserve native logo, menu, mobile toggle, cart and CTA behavior.
- H1: image-led full-height/high-impact hero with Mini Craft copy and existing Mini Craft destination(s).
- H3: editorial large-image featured-experience area using replaceable Mini Craft/placeholder images; no invented SKU, price, stock or availability claims.
- H5: clearly numbered Mini Craft process section with Homira-like scroll rhythm/stacking character while remaining fully readable without motion.
- H6: strong full-image emotional brand pause using Mini Craft content.
- H10: large confident Mini Craft closing CTA using existing Product/Shop destination(s).

Executor chooses implementation details, timing/easing and exact technical technique after visual QA. Do not turn this Gate into a per-pixel clone.

Motion must:
- enhance rather than gate content;
- work with `prefers-reduced-motion`;
- avoid scroll hijacking;
- degrade to complete readable static content on mobile/reduced-motion;
- remain homepage-only.

## APPROVED CHANGE SURFACE

### WordPress content

Only:
- `posts.ID=939.post_content`

Use the WordPress application-level page update path. Keep routing, page ID, page template and accepted page layout metadata unchanged unless a specific blocker is proven and returned.

The page content should contain only the selected homepage content structure H1/H3/H5/H6/H10 plus any minimal supporting/accessibility text needed for those modules. Existing separate FAQ / Shipping & Returns / Contact pages remain available through existing site navigation/footer and must not be modified.

### New homepage-only presentation code

Create canonical source in the Mini Craft GitHub project and deploy only:

- `/srv/data/mini-craft-night-kit/wp-content/mu-plugins/mini-craft-home-skin.php`
- `/srv/data/mini-craft-night-kit/wp-content/mu-plugins/mini-craft-home-skin/home.css`
- `/srv/data/mini-craft-night-kit/wp-content/mu-plugins/mini-craft-home-skin/home.js`

The MU loader must remain presentation-only:
- enqueue assets/body class only for public front page page 939;
- no Woo/payment/order/auth/provider/filter business logic;
- no admin behavior;
- no non-home presentation load.

Namespace/scope CSS and JS to the homepage root. Preserve native Kadence/Woo scripts and markup semantics.

If implementation requires any path/record outside this exact surface, stop and RETURN for Reviewer expansion.

## APPLICABLE_CRITICAL_CONSTRAINTS

- K10A is formal PASS; do not replay K0–K9.
- VPS production is the only real runtime target; do not recreate the old local runtime.
- Strict SSH is the normal management path.
- Shared infrastructure is frozen.
- Durable business data and Secrets remain protected.
- No broad cleanup/prune.
- No real commerce/payment/refund action.
- No image generation.
- Source candidate, reviewed candidate and deployed candidate must be correlated.
- Consequential write requires exact preflight + rollback before mutation.

## PREFLIGHT

Before the first production write:

1. Fresh-read this Gate, newest Reviewer Handoff K10B block, K10A accepted Evidence section, Project Storage Manifest and Shared VPS Handoff only.
2. Freshly prove strict SSH target identity and current WordPress/MariaDB runtime identity.
3. Re-read and compare K10A guards:
   - page 939 content hash/bytes/status;
   - Custom CSS 1041 hash;
   - `theme_mods_kadence` hash;
   - `active_plugins` hash;
   - relevant vendor theme file hashes;
   - exact absence of the proposed MU loader/files.
4. Verify public Home and all non-home baseline routes remain consistent with K10A.
5. Verify target paths are project-owned and shared infra is not in the write set.
6. Build/review canonical homepage-skin source before deployment. Static-check PHP/CSS/JS.
7. Complete the recovery set below and prove it readable/restorable before page/file write.
8. If any relevant guard has drifted materially, RETURN `RETURN_PREFLIGHT_DRIFT` rather than merging around it.

## REQUIRED PREWRITE RECOVERY

Create a dated K10B recovery set under the project backup namespace only.

Minimum recovery evidence:
- exact pre-change page 939 `post_content`, status, modified timestamp and relevant accepted page layout/template metadata;
- source byte count + SHA-256 for the page content export;
- exact absence/previous bytes metadata for each proposed MU file/path;
- guard snapshots for front-page option, theme/menu/plugin/Custom CSS records (guard-only, not blanket restore targets);
- recovery manifest describing bounded restore steps.

Create the exact project-owned recovery directory needed for affected wp-content code if absent.

Do not dump/copy Secrets.

A full production database restore is NOT the default rollback. If Executor believes a full DB backup is technically required before the page write, it may use the already established project-consistent protected database backup mechanism inside the project backup namespace, but it must not expose/publish the dump and must still use page-scoped rollback as the normal restore path.

Recovery must be verified before mutation.

## EXECUTION

1. Create canonical source for the loader/CSS/JS in GitHub under the Mini Craft project.
2. Correlate reviewed GitHub blobs/source with deployment bytes.
3. Deploy only the three approved presentation files into durable project wp-content.
4. Verify host and running WordPress view expose identical candidate bytes.
5. Update only page 939 content through WordPress application-level update.
6. Verify served homepage uses the new scoped assets and selected content.
7. No restart/recreate is expected. If implementation appears to require restart/recreate/cache infrastructure mutation, stop and RETURN rather than expanding scope.
8. Do not import Webflow runtime or proprietary Homira assets/source.
9. Do not generate images; use accepted existing Mini Craft assets/placeholders.

## REQUIRED QA / EVIDENCE

### Visual / responsive

Capture and inspect final Home at minimum:
- desktop 1280×800
- mobile 375×812

Also verify at least one intermediate/tablet viewport if implementation materially changes breakpoint behavior.

Evidence must demonstrate:
- H0/H1/H3/H5/H6/H10 all present and recognizable by role;
- H0 uses native header semantics;
- H3 images/content remain replaceable and do not falsely present unconfirmed SKUs/prices;
- H5 static/reduced-motion readability;
- H6 visual break;
- H10 conversion CTA;
- no blocking overflow/clipping;
- mobile menu remains usable.

### Motion / accessibility

Verify:
- selected scroll/enter/hover motion works on normal desktop;
- page remains complete with JS disabled or enhancement unavailable where practical;
- `prefers-reduced-motion` removes/reduces nonessential motion without hiding content;
- keyboard/focus/native menu/cart controls remain usable;
- no scroll hijacking.

### Business / negative regression

Recheck public:
- Home
- Product
- Cart
- Checkout (empty-session redirect baseline only; do not create cart state)
- FAQ
- Shipping & Returns
- Contact

Required negative assertions:
- new homepage CSS/JS not loaded on non-home pages;
- non-home Header appearance/computed critical properties remain baseline-equivalent;
- navigation/menu/cart destinations and native behavior unchanged;
- Product/Woo/payment/provider state unchanged;
- no order/cart/payment/contact-form submission;
- no product mutation;
- no theme/vendor/plugin/global Custom CSS mutation;
- runtime identities/restart counts remain unchanged.

### Runtime / persistence

Verify:
- deployed files are in durable `/srv/data/mini-craft-night-kit/wp-content`;
- running WordPress serves the exact candidate;
- page 939 durable content read-back matches the intended new content;
- next-start persistence is provided by the directory bind + DB persistence model;
- no container-only artifact is relied upon.

## ACCEPTANCE_CRITERIA

PASS_CANDIDATE only if all are true:

- prewrite recovery is complete and verified;
- write surface stayed exactly within page 939 + three approved MU presentation files;
- H0/H1/H3/H5/H6/H10 are visibly implemented with Mini Craft content/placeholders;
- homepage visual/motion character materially references accepted Homira evidence;
- functionality remains Mini Craft's own;
- desktop/mobile responsive QA passes;
- reduced-motion/static fallback is complete;
- no non-home presentation spill;
- all baseline non-home routes remain healthy;
- native header/menu/cart semantics remain intact;
- Woo/product/payment/provider/order state is unchanged;
- no shared infra, Docker, Secret or image-generation action occurred;
- deployed source/candidate identity is reviewable;
- Evidence + Executor Handoff are persisted and freshly read back.

Otherwise rollback when appropriate and RETURN with the precise reason.

## ROLLBACK_STATUS_OR_PLAN

Rollback is mandatory if:
- homepage render is materially broken;
- non-home styles/assets spill;
- native header/menu/cart behavior regresses;
- business/Product/Woo state changes unexpectedly;
- deployed bytes differ from reviewed candidate;
- write surface expands beyond authorization.

Bounded rollback:
1. disable/remove only the new homepage MU loader/files using the verified recovery manifest;
2. restore only page 939 pre-change content/allowed metadata through WordPress application-level update;
3. verify original Home hash/content/appearance;
4. recheck all non-home regression routes and runtime identity.

Do not restore the full database over newer business state merely to undo a homepage skin.

## OWNER_ONLY_ACTIONS

The Owner has authorized this bounded homepage visual change by directing Reviewer to proceed.

Still not authorized:
- Soft Launch / real-commerce enablement;
- real payment/refund;
- Provider/account changes;
- Secret generation/rotation/disclosure;
- Shared Infra changes;
- destructive business-data deletion;
- product truth/price/availability decisions outside existing accepted state.

## REVIEWER_TO_EXECUTOR_RELAY

Start only from:

1. `mini-craft-night-kit/review-packets/K10B_HOMEPAGE_VISUAL_SKIN_IMPLEMENTATION.md`
2. newest K10B block in `mini-craft-night-kit/REVIEWER_HANDOFF.md`
3. K10A section in `mini-craft-night-kit/EXECUTION_EVIDENCE.md`
4. `mini-craft-night-kit/evidence/k10a-20261005/`
5. `mini-craft-night-kit/PROJECT_STORAGE_MANIFEST.md`
6. `shared-vps-infrastructure/SHARED_VPS_HANDOFF.md`
7. live production `https://minicraft.spikersun.com/`
8. live reference `https://homiras.webflow.io/`

Accepted facts:
- K10A=PASS.
- page 939 is the homepage implementation content surface.
- existing Kadence header is global and must remain native.
- proposed MU namespace was absent at K10A.
- Custom CSS 1041 and global theme/plugin records are frozen.
- real commerce remains disabled.
- no formal new imagery is required; use replaceable existing/placeholders.

Do not broadly reread project history or Governance.
Do not redesign non-home pages.
Do not invent business claims/products.
If the exact approved surface proves insufficient, RETURN instead of widening scope.

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

On PASS_CANDIDATE or RETURN, stop at Reviewer.
