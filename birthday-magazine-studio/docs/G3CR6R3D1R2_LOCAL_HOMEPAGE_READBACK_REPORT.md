# G3CR6R3D1R2 — fresh local homepage readback

2026-10-04. Executor result: **PASS_CANDIDATE**. Reviewer acceptance and D2 permission remain pending.

## Authority and freshness

Current D1R2 contract, current Reviewer Handoff and Owner Preview-interaction hold govern this run. Canonical Governance v0.2.6 applies. D1R1 benchmark work is superseded; pre-existing untracked benchmark files were neither reused nor submitted.

PR #64 was freshly read as open/unmerged at approved head `48191f6f0b95eb4be169746f8eac9c1d7ca5365a`. Main was `abc5216da1c29841aeca58fb1c4ef653c19a0017`; no main-only Birthday Magazine commits remain outside this branch. Local `8eba815caf4e65a978cfd69c2410fc2acb8c5809` was an earlier merge and could not fast-forward. Non-destructive merge `ce8df2b0a34bf8206fe4d5acec24a7387c4f7192` preserved it; project tree equals the approved head. No reset or unrelated implementation edit occurred.

Reuse the accepted [D1 mapping](G3CR6R3D1_FOCUSLY_VISUAL_MAPPING_REPORT.md) and its [66 reference screenshots](evidence/g3cr6r3d1/README.md). No Focusly visit, new research, asset generation or Preview benchmark this round. The later Owner hold supersedes any older Preview interaction proposal.

## Retained runtime availability

Docker Desktop was already running: 4.88.1, Engine 29.7.2. Executor did not start/install/update/login/elevate/reconfigure Desktop. Four retained G3C containers existed and were stopped. Only these existing IDs were started, in database-first order:

| Container | Existing ID prefix | Image | Final state |
|---|---|---|---|
| database | `361d58eb5454` | mariadb:11.4.7 | running, healthy |
| WordPress | `21892d72baeb` | wordpress:7.1.1-php8.3-apache | running; Home HTTP200 |
| Mailpit | `35d286e7af50` | axllent/mailpit:v1.31.2 | running, healthy |
| WP-CLI | `de9742647e06` | wordpress:cli-php8.3 | retained stopped; not needed |

No build, pull, compose up, recreate, volume reset, migration, global setting change or prune. Existing mount/image/container identities, volume names and network IDs/names remained identical. Unrelated container state/start-time/mount/image projection also matched, after normalizing Docker mount-list order. These are metadata checks, not a claim of bitwise volume/database identity. See [runtime before/after and closure checks](evidence/g3cr6r3d1r2/README.md).

Site remains available at http://127.0.0.1:8189/; admin http://127.0.0.1:8189/wp-admin/. No login attempted.

## Fresh WordPress projection and browser observation

Read-only PHP was piped to the existing WordPress container; no helper copied into its volume, no setup/provisioning script executed. `wp-load.php`, `parse_blocks`, a read-only Home query and `get_page_template` supplied current facts:

- Home **858**, title Home; content SHA256 `3f678c490ff78f91d0918aacf4edd236d58500dced0a3ac229f0c865e86e1269`, identical to accepted G3CR6R1 and before/after this run.
- WordPress7.1.1 / WooCommerce11.1.2 / Blocksy2.1.57. Gutenberg enabled; page-template slug empty (default); actual resolved page template `wp-content/themes/blocksy/page.php`.
- Owner Administrator, edit Home, upload media and edit theme options capabilities still true. No password, auth state or user/session data exported.
- Eight top-level editable core Groups, in current order:

| Group class | Current anchor |
|---|---|
| bms-hero | none |
| bms-value-strip | none |
| bms-samples | samples |
| bms-preview-chapter | preview |
| bms-included | what-you-get |
| bms-how | how-it-works |
| bms-offer | offer |
| bms-faq | faq |

The browser independently saw eight Groups and one `[data-bms-preview]`, with its default no-photo state. **Existing upload/replace/remove behavior KEEP_AS_IS; not exercised or researched.** Preview PHP/JS/CSS and protected workspace hashes match accepted D1 source inventory. This is presence/no-source-drift proof, not a new photo-network or authorization test.

Existing Edge154.0.4258.53 with Playwright Core1.62.1 rendered fresh Home at **1440×1000** and **375×812**. Full-page, Hero and default Preview PNGs exist for both sizes. Document widths equal1440 and375 respectively. No JS page error, HTTP>=400 resource response or rendered broken image observed. Images/sample copy and Preview are readable in the captured current state. No visual redesign or visual freeze is claimed.

### Menu and CTA readback

- Desktop header: Home, What You Get→`/#what-you-get`, Create a Free Preview→`/#preview`.
- Hero→`#preview`; existing Preview purchase and Offer→`/product/birthday-magazine/`.
- Footer→Preview, native Product, My Account; its Privacy policy link has an **empty href**.
- Persisted mobile-menu locations include a historical Sample Pages→`/#sample-pages`; **this anchor is absent**, while the actual sample Group is `#samples`. Other inspected section targets exist. Mobile menu stored configuration is recorded separately from its collapsed rendered header; no mobile-menu interaction replay was needed.

These two existing navigation issues were identified, **not fixed**. They do not prevent this readback closure but must be visible to Reviewer when opening the next mutation scope.

### Woo routes — only GETs

Both viewport contexts were new anonymous contexts. Non-GET/HEAD, add-to-cart query and PayPal requests were blocked by the observer guard; **no blocked request occurred**. No button/form/file control was operated.

| Requested route | Actual fresh result | Proof limit |
|---|---|---|
| Product | HTTP200, correct product/price and Add to Cart control present | no Add to Cart click |
| Cart | HTTP200, empty native Cart | no cart mutation |
| Checkout | redirects to Cart, final HTTP200 | expected empty-cart boundary; **checkout form not verified** |
| My Account | HTTP200, native login form present | no login/account mutation |

Product1113 remains **USD39.99 / virtual**. Guest checkout=no, checkout signup=yes. Order count remains1; generation-job and product-model-call counters remain0. Home/footer/theme-mod hashes, menus, active plugins, product projection and protected code hashes are identical before/after. No official PayPal plugin is active in this G3C baseline. No provider query or payment action.

## Protected-function map

| Surface | Current evidence | Next-Gate boundary |
|---|---|---|
| Home/editor/theme shell | actual groups, resolved template, editable capabilities | Home presentation only; no theme/builder switch |
| Preview | current component exists; accepted hashes match | hold interaction and component internals; zero upload/model contract retained |
| Product/cart/checkout/order | actual price/virtual, routes, unchanged source/config projection | native canonical logic frozen; no new commerce system |
| Account/private workspace | accepted guard hash unchanged; account route present | no authorization/session/order binding change; no new access-test claim |
| PayPal/entitlement/provider | no invocation, no source change; counters0 | wholly outside mutation surface |
| P1–P12/Aha | unresolved Owner choices remain unresolved | no selection or implementation |

## Exact D2 recommendation — proposal only

Reviewer can now assess the last fresh-runtime prerequisite. D2 is **not opened by this report**. Proposed smallest homepage-only implementation allowlist:

1. Home post858 core Gutenberg content: rearrange/restyle existing visual Groups, headings, sample frames and existing owned image references; preserve required anchor IDs and native product/Preview/account destinations. No product1113, footer block1143, global menu or account/order DB writes by default.
2. `poc/g3c/preview-plugin/home.css`: original Focusly-inspired presentation, scoped to Home. Existing cover/spread/gift assets are sufficient; no required image generation. No Woo route stylesheet edits and no component-internal Preview restyling under the current hold.
3. New `poc/g3c/preview-plugin/home-motion.js`: original display-only entrance/hover/scroll effects with bounded mobile geometry, reduced-motion/static/no-JS fallbacks. No form/file/commerce interception.
4. `birthday-magazine-poc.php`: if needed, **only an `is_front_page()`-guarded enqueue** of that presentation controller. Leave shortcode markup, Preview JS/CSS, product/Woo hooks and permissions intact.
5. A new project-scoped D2 Home-only application/rollback helper plus Gate documentation/evidence. Do not run historical installers or modify historical evidence.

The missing mobile sample anchor and empty privacy link need a **Reviewer-scoped decision** before touching shared menus/footer. A narrowly authorized target correction can be separate from the homepage visual work; this report neither invents a privacy policy nor authorizes a global-shell mutation. Exact section reordering in D1 remains a proposal, not an Owner-frozen choice.

Before D2 writes, snapshot Home858 content and hashes, relevant source and any explicitly approved theme-mod/menu/footer surface into a scoped secret-free rollback package; otherwise exclude those global surfaces. Restore only the touched Home/source projection and verify hashes. Do not reset DB/volumes.

D2 evidence recommendation:1440/375 screenshots of every visible region/motion state; core Groups/anchors/editability; no-JS/reduced-motion fallbacks; contained image/sample bounds; current Preview preserved. Perform only the regression checks authorized in D2, without reopening Preview UX research. Confirm native Woo GET routes and unchanged product/account/workspace code; any additional interaction/privacy regression must be explicitly within that later Gate. No orders/payments/providers/deployment/G4/merge.

## Submission and rollback

Only this report, readback artifacts and appended Executor Evidence/Handoff are intended changes. Existing17 screenshot deletions, Owner archives/current-review files and untracked D1R1 benchmark/resume artifacts remain untouched and excluded. PR #64 continues, no new PR, no merge.

Runtime retained for Owner/Reviewer inspection. Availability rollback, only if later requested: stop exactly the three IDs started above; no teardown, removal or volume cleanup needed. This round has no application/content rollback. The documentation/evidence commit can be reverted independently. Browser contexts closed; no cookie/storage-state/auth export.

`STOP_AT_REVIEWER=YES`; `Owner relay=NONE`; D2/G4 not started.
