# K0 Execution Evidence — Kadence Single Product Local PoC

- Gate: `K0_KADENCE_SINGLE_PRODUCT_LOCAL_POC`
- Execution date: 2026-09-18 (Asia/Shanghai)
- Executor result: `PASS_CANDIDATE_K0_KADENCE_SINGLE_PRODUCT_LOCAL_POC`
- Reviewer note: this is an executor candidate only; it is not the Reviewer PASS decision.

## Environment

- Independent project path: `C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-kadence-poc`
- Compose project: `mini-craft-kadence-poc`
- Local URL: `http://localhost:8090`
- Docker Engine / CLI: 29.7.2; Docker Desktop 4.88.1; Compose v5.4.0
- Host: Windows 11, x64, build 26200
- WordPress: 6.8.2 (`wordpress:6.8.2-php8.3-apache`)
- Database: MariaDB 11.4.7; database container healthy
- Durable named volumes: `mini-craft-kadence-poc_db_data`, `mini-craft-kadence-poc_wp_core`, `mini-craft-kadence-poc_uploads`
- HTTP port 8090 was free during preflight. Old project port 8088 was not changed.

## Kadence / plugin list

- Kadence Theme 1.5.2 — active
- Kadence Blocks 3.7.11 — active
- Starter Templates by Kadence WP 2.3.4 — active
- WooCommerce 10.0.4 — active
- Preinstalled but inactive and not used: Akismet 5.4, Hello Dolly 1.7.2

## Import

- Exact template: `Kadence — Single Product` / `Single Product`
- Import mode: `Import Full Site`
- Style/color/font changes: none; original template defaults retained
- Required components shown by the importer: Kadence Blocks and WooCommerce, both already active
- Optional third-party plugins: none selected
- Final import result: PASS; importer displayed `Success`
- The first attempt exposed a write-permission problem on the new uploads volume. The independent PoC uploads directory was corrected, and the unmodified template was imported successfully on the retry.
- Owner authorization, Kadence account login, premium license, and payment: not required

## Runtime

Verified after the final container restart:

| Surface | URL | Result |
|---|---|---|
| Home | `http://localhost:8090/` | HTTP 200; original Single Product hero/content rendered |
| Product | `http://localhost:8090/product/smart-speaker/` | HTTP 200; Smart Speaker product detail and Add to Cart rendered |
| Cart | `http://localhost:8090/cart/` | HTTP 200; Cart Summary, line item, quantity, totals rendered |
| Checkout | `http://localhost:8090/checkout/` | HTTP 200 in local browser session with the imported demo product; Billing details rendered |
| Orders admin | `http://localhost:8090/wp-admin/admin.php?page=wc-orders` | WooCommerce Orders screen loaded |

An empty, unauthenticated cart correctly redirects Checkout to Cart. No order was submitted.

## Gutenberg

- Home page opened in the Gutenberg editor and reopened after the final container restart.
- Editor canvas loaded; no `Invalid block`, unexpected-content notice, or `.is-invalid` block was present.
- Invalid block count: `0`
- Product edit page also loaded its WooCommerce product editor and description editor without an invalid-block notice.
- `GUTENBERG_EDITOR=PASS`

## Responsive QA

Home, Product, Cart, and Checkout were checked at 375px, 430px, 768px, 1024px, 1366px, 1440px, 1920px, 2048px, and a 2560px ultra-wide smoke size.

- Mobile 375 / 430: PASS — header collapses, content stacks, product/cart/checkout controls remain visible, no horizontal overflow
- Tablet 768 / 1024: PASS — content remains within viewport and transitions cleanly
- Desktop 1366 / 1440 / 1920 / 2048: PASS — container remains bounded and pages render without horizontal overflow
- Ultra-wide 2560: PASS — bounded layout; no uncontrolled horizontal expansion
- DOM checks: every tested route had `scrollWidth <= clientWidth`; representative mobile and desktop screenshots were visually checked

## Old-project protection

The old project remained read-only:

| File | Preflight SHA-256 | Final SHA-256 |
|---|---|---|
| `mini-craft-night-kit/README.md` | `FC9063688E8E8F3A919DFB27D8B1E4344B7503852A22900051238E151F11B056` | same |
| `mini-craft-night-kit/docker-compose.yml` | `B6C415F9C95A1512CD2901C6AB306EFE9BA5DAE7690E37DD19E3DF4CD1BBB0EF` | same |
| `mini-craft-night-kit/REVIEWER_HANDOFF.md` | `88259AE0806D1994A2E2459E9A9689EFC314EAABA1DD780496560F1F0B76D732` | same |

- Old WordPress container remained running on `localhost:8088`.
- Old database volume `mini-craft-night-kit_db_data` remained present.
- No old container, volume, database, or archive was stopped, deleted, or modified.

## Safety flags

```text
KADENCE_SINGLE_PRODUCT_IMPORTED=PASS
FRONTEND_RUNTIME=PASS
HOME_RUNTIME=PASS
PRODUCT_RUNTIME=PASS
CART_RUNTIME=PASS
CHECKOUT_RUNTIME=PASS
GUTENBERG_EDITOR=PASS
INVALID_BLOCK_COUNT=0
WOOCOMMERCE_BASELINE=PASS
MOBILE_RESPONSIVE=PASS
TABLET_RESPONSIVE=PASS
DESKTOP_RESPONSIVE=PASS
ULTRAWIDE_SMOKE=PASS
OLD_PROJECT_UNCHANGED=PASS
COMMERCE_CUSTOM_BUILD=NO
BRAND_CUSTOMIZATION=NO
CLONE_UI_EXECUTED=NO
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
SECRET_EXPOSURE=NO
STOP_AT_REVIEWER=YES

```

Local `.env` credentials were kept only in the independent PoC directory and were not written to this repository.

## Known issues / boundaries

- The local site is HTTP-only by design for this gate; no production SSL, domain, VPS, Cloudflare, DNS, or payment setup was performed.
- WordPress 6.8.2 shows a newer WordPress update in wp-admin. The verified baseline remains pinned to the stable local image; WooCommerce 10.0.4 is the compatible package used for this WordPress baseline.
- No K1 branding, copy, hero, color, layout, custom CSS, custom commerce, or clone-UI work was performed.

## K0R1 — Local Project Hygiene Cleanup

- Gate: `K0R1_LOCAL_PROJECT_HYGIENE_CLEANUP`
- Reviewer return was bounded to K0-generated WooCommerce download and extraction artifacts.
- K0 was not reinstalled, reimported, or functionally redesigned.

### Confirmed K0 artifacts removed

All five targets were created during the K0 execution window, matched the K0 installation evidence, and were confirmed to be outside the running WordPress mounts. The runtime uses only the independent named Docker volumes; no shared-root zip or extraction path is mounted.

| Removed category | Confirmed item | Read-only pre-cleanup evidence |
|---|---|---|
| Latest WooCommerce download | `woocommerce-latest-stable.zip` | 18,024,069 bytes; modified 2026-09-18 07:27:28Z; SHA-256 `6BAE9BF74D722B6DEB15F049687C311CFAFC26E3A5D8FA55AC6EA4B9A3A8DF19` |
| Latest WooCommerce extraction | `woocommerce-latest-stable-extract-20260918/` | 5,862 files; modified 2026-09-18 07:30:10Z |
| Compatibility-download attempt | `woocommerce-10.0.4.zip` | 21,391,000 bytes; modified 2026-09-18 07:35:01Z; SHA-256 `273AA0B56641720DACE4B15369D8FD7079C29BFF0F91DB034120221437C7FEAE` |
| Verified WooCommerce package | `woocommerce-10.0.4-fresh.zip` | 17,802,904 bytes; modified 2026-09-18 07:41:14Z; SHA-256 `002B3CB8B1FCACF9836367A1AE617C87D6DEF0C33D16B8A79A4F81DAD9894429` |
| Verified package extraction | `woocommerce-10.0.4-extract/` | 4,964 files; modified 2026-09-18 07:41:41Z |

No artifact was retained because every item was a reproducible installation/download intermediate and the installed WooCommerce runtime was already present in the named WordPress volume. No `.artifacts/` or `.cache/` directory was needed.

### Post-cleanup verification

- Shared root no longer contains the five K0 WooCommerce zip/extraction names.
- `mini-craft-kadence-poc/` contains only its local Compose/configuration files; no install zip, extraction directory, temporary script, debug output, or duplicate backup remains.
- Local `.env` remains in the PoC directory and was not read into or written to GitHub evidence.
- No template import, plugin installation, Docker volume deletion, payment action, or VPS write was performed in K0R1.
- Smoke test after cleanup: Home 200, Product 200, Cart 200, Checkout 200 in the existing local browser session; no re-import was required.
- Docker: WordPress container remains up on 8090; MariaDB remains healthy.
- Old project: `http://localhost:8088/` returned 200; old containers and `mini-craft-night-kit_db_data` remain present; K0 baseline hashes remain unchanged.
- Protected unrelated items (`dujiao-next/`, `dujiao-next.zip`, `formwork-design/`, `.clone-ui/`, `project-github-sync/`, `SHARED_VPS_HANDOFF.md`, and the old project) were not touched.

The remaining unrelated root-level project/archive items are out of scope for K0R1 and were intentionally left in place.

```text
PASS_CANDIDATE_K0R1_LOCAL_PROJECT_HYGIENE_CLEANUP
K0_FUNCTIONAL_BASELINE_RETAINED=PASS
K0_TEMP_ARTIFACTS_CONTAINED_OR_REMOVED=PASS
SHARED_WORKSPACE_ROOT_CLEAN=PASS
PROJECT_ROOT_HYGIENE=PASS
HOME_RUNTIME=PASS
PRODUCT_RUNTIME=PASS
CART_RUNTIME=PASS
CHECKOUT_RUNTIME=PASS
UNRELATED_PROJECTS_TOUCHED=NO
OLD_PROJECT_UNCHANGED=PASS
DOCKER_VOLUMES_DELETED=NO
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
SECRET_EXPOSURE=NO
STOP_AT_REVIEWER=YES
```


OUT_OF_SCOPE_WORKSPACE_DEBT=Protected non-K0 items remain: dujiao-next.zip, .clone-ui/, dujiao-next/, formwork-design/, mini-craft-night-kit/, project-github-sync/, and SHARED_VPS_HANDOFF.md.
---

## K0R2 — WordPress Studio Consolidation

- Gate: `K0R2_LOCAL_PROJECT_HYGIENE_CLEANUP` / WordPress Studio consolidation execution requested by Owner
- Execution date: 2026-09-18 (Asia/Shanghai)
- Executor result: `RETURN_K0R2_RESPONSIVE_BASELINE_CONFLICT`
- Reviewer decision source: `docs/REVIEWER_DECISION_K0R2_STUDIO_CONSOLIDATION.md`
- Reviewer-owned files were not modified. GitHub `PROJECT_RECORD.md` and `REVIEWER_HANDOFF.md` still identify K0R1 as their current checkpoint; this document records the K0R2 execution requested by Owner and leaves that truth reconciliation to Reviewer.

### Source and target

- Docker source retained at `http://localhost:8090`
- Docker source project: `C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-kadence-poc`
- Studio site name: `Mini Craft Night Kit`
- Studio site URL: `http://localhost:8881/`
- Studio site directory: project-local `.studio\mini-craft-night-kit`
- WordPress Studio desktop/CLI version: `1.21.0`
- Studio runtime: native PHP `8.3`; Studio-managed SQLite database at `wp-content/database/.ht.sqlite`
- Studio imported core: WordPress `6.8.9` (the source Docker baseline remains WordPress `6.8.2`; Studio only exposed the `6.8` line as `6.8.9`)

### Backup and import

- Full-site backup created from the running Docker source before import.
- Backup layout contained `wp-config.php`, `wp-content/plugins`, `wp-content/themes`, `wp-content/uploads`, and `sql/`.
- Local-only backup location: `mini-craft-kadence-poc\.artifacts\studio-migration\mini-craft-kadence-poc-studio-backup.zip`
- Local backup SHA-256: `B71556D2E98162537042FAC9292E04015AD9AEB33461C9495C16F78D9B0031C1`
- Import method: official bundled Studio CLI `import <backup> --path <site>`.
- WordPress.com Sync: not used.
- Import result: `PASS`; Studio site registered and online.

### Imported stack and preserved content

- Active theme: Kadence `1.5.2`
- Active plugins: Kadence Blocks `3.7.11`, Kadence Starter Templates `2.3.4`, WooCommerce `10.0.4`
- Inactive preinstalled plugins retained: Akismet `5.4`, Hello Dolly `1.7.2`
- Studio runtime MU/drop-in components (`99-studio-loader`, SQLite integration) are Studio infrastructure, not an extra migration plugin.
- `EXTRA_MIGRATION_PLUGIN_INSTALLED=NO`
- Published pages include Home, Shop, Cart, Checkout, My account, Blog, Reviews, About, and Contact.
- Published products found: 4; Smart Speaker was used for bounded cart/checkout smoke only.
- Menus preserved: Company, Main, Support; media attachments found: 60.

### Runtime validation

| Surface | Studio URL / check | Result |
|---|---|---|
| Home | `http://localhost:8881/` | HTTP 200 |
| Product | `http://localhost:8881/product/smart-speaker/` | HTTP 200 |
| Cart | `http://localhost:8881/cart/` | HTTP 200 |
| Checkout, empty cart | `http://localhost:8881/checkout/` | HTTP 302 to Cart, expected WooCommerce behavior |
| Checkout, one local demo item | same URL after adding Smart Speaker | HTTP 200 |
| Studio admin auto-login | `/studio-auto-login?redirect_to=%2Fwp-admin%2F` | HTTP 200, final `/wp-admin/` |
| WooCommerce Orders admin | `/wp-admin/admin.php?page=wc-orders` | HTTP 200; WooCommerce Orders marker present |

No order was submitted and no payment action occurred.

### Gutenberg validation

- Home editor endpoint: `/wp-admin/post.php?post=939&action=edit`
- Editor page: HTTP 200; `block-editor` bootstrap marker present.
- Home content block markers: 156.
- Invalid block / `is-invalid` markers in editor response: 0.
- `GUTENBERG_EDITOR=PASS`
- `INVALID_BLOCK_COUNT=0`

### Responsive validation

Local screenshots were generated under `mini-craft-kadence-poc\.artifacts\studio-migration\responsive\` at 375, 768, 1440, and 1920 CSS pixels.

- Mobile 375: `RETURN` — Home header title and main heading are visibly clipped beyond the viewport in Studio. The same 375px clipping is present in a comparison screenshot from the retained Docker source, so this is a source-baseline conflict rather than a Studio-only mutation.
- Tablet 768: visually bounded and readable in the Studio screenshot.
- Desktop 1440: visually bounded and readable in the Studio screenshot.
- Desktop 1920: smoke screenshot generated and visually bounded.
- No responsive CSS or template edits were made.

`MOBILE_RESPONSIVE=RETURN`
`TABLET_RESPONSIVE=PASS`
`DESKTOP_RESPONSIVE=PASS`
`RESPONSIVE_BASELINE_CONFLICT=YES`

### Safety and containment

```text
STUDIO_INSTALLED_OR_AVAILABLE=PASS
STUDIO_SITE_IMPORTED=PASS
HOME_RUNTIME=PASS
PRODUCT_RUNTIME=PASS
CART_RUNTIME=PASS
CHECKOUT_RUNTIME=PASS
WOOCOMMERCE_BASELINE=PASS
GUTENBERG_EDITOR=PASS
INVALID_BLOCK_COUNT=0
OWNER_STUDIO_ADMIN_ACCESS=PASS
DOCKER_SOURCE_RETAINED=PASS
OLD_PROJECT_UNCHANGED=PASS
SHARED_WORKSPACE_ROOT_CLEAN=PASS_K0R2_SCOPED
PROJECT_ROOT_HYGIENE=PASS
EXTRA_MIGRATION_PLUGIN_INSTALLED=NO
BRAND_CUSTOMIZATION=NO
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
SECRET_EXPOSURE=NO
DOCKER_VOLUMES_DELETED=NO
UNRELATED_PROJECTS_TOUCHED=NO
STOP_AT_REVIEWER=YES
```

Old project regression checks: `localhost:8088` remained HTTP 200; old `/wp-admin/` remained HTTP 302; old project README, compose, and Reviewer Handoff hashes matched the K0 baseline; old container and database volume remained present.

K0R2-scoped shared-root check passed: no Studio migration archive, extraction directory, cookie, or helper was left in the shared `VPS基建` root. Existing unrelated `dujiao-next.zip` and other unrelated project directories were retained and not touched; they remain out of scope.

### Return reason and stop

`RETURN_K0R2_RESPONSIVE_BASELINE_CONFLICT`: the required 375px responsive check is not a PASS, and the same issue is observable on the retained Docker source. Executor did not alter the original template or write CSS to hide the issue. Reviewer must decide whether the earlier K0 mobile PASS evidence should be reconciled, or issue a separate bounded remediation Gate.

No K1 branding, copy, layout, payment, or commerce customization was started. Docker source and all Docker volumes remain available for rollback. Executor stops here for Reviewer review.
## K1B — WordPress Implementation

### Scope and status

`PASS_CANDIDATE_K1B_WORDPRESS_IMPLEMENTATION`

K1B was executed against the registered WordPress Studio target only:

- Studio target: `http://localhost:8881/`
- Docker PoC rollback source: `http://localhost:8090/` retained and not edited
- Kadence Layout System: preserved; no structure-level rebuild
- Reviewer-owned documents: not modified
- PayPal, real payment, K2, VPS, production: not entered

### Approved brand adaptation

- `K1A_DIRECTION_IMPLEMENTED=PASS`
- `KADENCE_LAYOUT_SYSTEM_PRESERVED=PASS`
- `MINI_CRAFT_BRAND_ADAPTATION=PASS`
- Approved hierarchy and copy were applied to the existing Kadence Home composition: hero, experience strip, differentiation, beginner framing, neutral trust shell, What’s Inside shell, product surface, and closing CTA.
- Irrelevant inherited Smart Speaker/demo sections and inherited testimonial row were removed from the Home composition without rebuilding the Kadence row/column system.
- Header navigation was reduced to Home / Shop / Contact with the existing Kadence menu system.
- Approved Mini Craft palette and typography direction were applied through Kadence theme settings.
- `CLONE_UI_EXECUTED=NO`
- `COMMERCE_CUSTOM_BUILD=NO`

### Image and claims policy

- `FINAL_IMAGES_GENERATED_BY_CODEX=NO`
- `FAKE_SOCIAL_PROOF=NO`
- Existing approved Mini Craft assets were reused from the retained old project source: product-main, product-flow-1, product-flow-2, product-flow-3, product-inside, and product-moment-1.
- No formal product image, lifestyle image, UGC, customer proof, testimonial, rating, or social-proof asset was generated.
- Missing/withheld factual content remains neutral and replaceable in Gutenberg.
- `UNVERIFIED_CLAIMS_PUBLISHED=NO`: inherited demo price, shipping promise, money-back promise, review count, rating, and featured-brand claims were removed or withheld.
- Local attachment IDs for the reused image set: `1031–1036`.

### WordPress / WooCommerce runtime

- WordPress `6.8.9`
- Kadence `1.5.2`
- Kadence Blocks `3.7.11`
- Kadence Starter Templates `2.3.4`
- WooCommerce `10.0.4`
- `WOOCOMMERCE_COMING_SOON=OFF` for the local runtime baseline
- Product `223`: title `Mini Craft Night Kit`, slug `mini-craft-night-kit`, published, local gallery retained
- No order was submitted; local order count remained `0`

| Surface | URL | Result |
|---|---|---|
| Home | `http://localhost:8881/` | HTTP 200 |
| Product | `http://localhost:8881/product/mini-craft-night-kit/` | HTTP 200 |
| Cart | `http://localhost:8881/cart/` | HTTP 200 |
| Checkout, empty cart | `http://localhost:8881/checkout/` | HTTP 302 to Cart, expected WooCommerce behavior |
| Checkout, one local product | same URL after adding product `223` | HTTP 200 |

`HOME_RUNTIME=PASS`
`PRODUCT_RUNTIME=PASS`
`CART_RUNTIME=PASS`
`CHECKOUT_RUNTIME=PASS`
`WOOCOMMERCE_BASELINE=PASS`
`FRONTEND_RUNTIME=PASS`

### Gutenberg validity and editability

- Home content remains native Kadence/WooCommerce block markup; no Custom HTML replacement was used.
- `use_block_editor_for_post(939)=true`
- `has_blocks(939)=true`
- `parse_blocks()` / `serialize_blocks()` round trip: `true`
- `INVALID_BLOCK_COUNT=0`
- Residual inherited Smart Speaker, Lorem ipsum, fake review, demo price, shipping, and featured-brand strings: `0`
- Home product surface still uses the native `woocommerce/handpicked-products` block and points only to local product `223`.
- `GUTENBERG_EDITOR=PASS`
- `OWNER_EDITABILITY=PASS`

### Responsive validation and inherited 375px fix

The required Home responsive matrix was checked at:

`320, 375, 390, 430, 768, 820, 1024, 1280, 1366, 1440, 1920, 2048, 2560` CSS pixels.

- Mobile 320 / 375 / 390 / 430: latest screenshots show header, hero, supporting copy, CTA, product heading, experience strip, and approved asset within the viewport; no visible right-side crop.
- Tablet 768 / 820 / 1024: bounded and readable.
- Desktop 1280 / 1366 / 1440 / 1920 / 2048: bounded and readable.
- Ultra-wide 2560: smoke-tested; content remains centered and does not expand without bound.
- The inherited 375px issue was fixed with narrow-device overflow guards plus editable mobile-only line breaks for the approved supporting copy and product heading. Kadence row/column structure was not rebuilt.
- Local QA screenshots are retained only in the local PoC artifact directory; they are not committed to GitHub.

`MOBILE_320_RESPONSIVE=PASS`
`MOBILE_375_RESPONSIVE=PASS`
`MOBILE_390_RESPONSIVE=PASS`
`MOBILE_430_RESPONSIVE=PASS`
`TABLET_RESPONSIVE=PASS`
`DESKTOP_RESPONSIVE=PASS`
`ULTRAWIDE_SMOKE=PASS`
`MOBILE_375_INHERITED_CROP=FIXED`

### Safety and containment

- `OLD_PROJECT_UNCHANGED=PASS`: old `README.md`, `docker-compose.yml`, and `REVIEWER_HANDOFF.md` hashes still match the recorded K0 baselines.
- No old project file, theme, database, or volume was edited or deleted.
- Final old-site HTTP recheck was unavailable because Docker Desktop was not exposing a usable Docker Engine in this host session; this is recorded as `OLD_PROJECT_RUNTIME_RECHECK=UNAVAILABLE_DOCKER_ENGINE`, not as a mutation or a pass claim.
- Docker source and its rollback backup remain retained; Docker volumes deleted: `NO`.
- `UNRELATED_PROJECTS_TOUCHED=NO`
- `REAL_PAYMENT_ACTIONS=0`
- `VPS_WRITES=ZERO`
- `SECRET_EXPOSURE=NO`
- No `.env`, password, token, cookie, private key, or payment credential was written to GitHub.
- Local pre-K1B full backup retained at `.artifacts/k1b-implementation/pre-k1b-backup.zip`; SHA-256 `EFA44656360BEFC031FCE6551365F6DC8BA3188094013BD247CFE6337ABDCEF1`.
- Temporary K1B helper scripts, diagnostic markers, and local auth cookies were removed after validation.

### Reviewer checkpoint

`STOP_AT_REVIEWER=YES`

K1B execution is complete. Executor does not enter K2, PayPal, VPS, or production.
## K2 — WooCommerce Commerce Loop

### Scope and status

`PASS_CANDIDATE_K2_WOOCOMMERCE_COMMERCE_LOOP`

K2 was executed on the accepted WordPress Studio local target only:

- Target: `http://localhost:8881/`
- Docker PoC source retained as rollback; no Docker source, old project, volume, VPS, production domain, or PayPal resource was changed.
- Formal K2 decision read from `docs/REVIEWER_DECISION_K2_WOOCOMMERCE_COMMERCE_LOOP.md` dated 2026-09-21.
- Local-only test order reference is intentionally redacted from GitHub evidence.

### Local/test-only commerce configuration

- Product: existing WooCommerce product `223`, title `Mini Craft Night Kit`
- SKU: `MCK-LOCAL-TEST-001`
- Price: `JPY 1` local/test-only value; not a Mini Craft business-price decision
- Inventory strategy: `manage_stock=yes`, initial stock `10`, backorders `no`, sold individually `no`
- Result after the one successful local order: stock `9`, status `instock`
- Existing site currency `JPY` was retained as a local baseline; no formal currency decision was made.
- Tax calculation remained disabled: `woocommerce_calc_taxes=no`; no tax policy was invented.
- Native WooCommerce uncovered/rest-of-world Flat Rate instance configured only for this test: title `Local test shipping — no fulfillment promise`, cost `0`, tax status `none`.
- Local hold-stock behavior: `woocommerce_hold_stock_minutes=0`. This is test-only because Studio SQLite's WooCommerce 10 stock-reservation SQL path returned a compatibility failure; the product's normal stock quantity and availability checks remain enabled.
- WooCommerce core COD was enabled only as `Local test only — no payment`; no money was collected and no provider was contacted.
- No formal shipping time, shipping fee, tax, returns, fulfillment, or policy promise was added.

`PRODUCT_CONFIG=PASS`
`SKU_STOCK_STRATEGY=PASS`
`LOCAL_SHIPPING_TEST_CONFIG=PASS`
`PAYPAL_CONFIGURED=NO`

### Commerce loop evidence

| Step | Result |
|---|---|
| Product | HTTP 200; product title and native Add to Cart surface present |
| Add to Cart | HTTP 200; local product added with quantity 1 |
| Cart read | Store API returned one item, product 223, quantity 1 |
| Cart update | Native Store API quantity update 2 → 1 returned HTTP 200 |
| Cart remove | Native Store API removal returned HTTP 200 and zero remaining items |
| Checkout validation | Missing Japanese prefecture returned `woocommerce_rest_invalid_address`; valid `JP13` local test address proceeded |
| Order creation | One local order created through WooCommerce Store API using core COD; no external payment action |
| Order baseline | Status `processing`, total `JPY 1`, one Mini Craft Night Kit line item, stock 10 → 9 |
| Order confirmation | Redacted `/checkout/order-received/[order-key-redacted]/` endpoint returned HTTP 200 with confirmation marker |
| Orders admin | Real Studio admin page `wp-admin/admin.php?page=wc-orders` loaded; Orders page showed one Processing local test order and two checkout-draft validation attempts |

`ADD_TO_CART=PASS`
`CART_UPDATE_REMOVE=PASS`
`CHECKOUT_VALIDATION=PASS`
`ORDER_CREATION=PASS`
`ORDER_CONFIRMATION=PASS`
`ORDERS_ADMIN=PASS`
`ORDER_STATE_BASELINE=PASS`

The two `checkout-draft` entries are local rejected/abandoned validation attempts created while testing invalid address and SQLite stock-hold behavior. No payment or fulfillment action occurred; they were not deleted because this Gate does not authorize destructive order cleanup.

### Gutenberg, UI, and responsive regression

- Home remains native Kadence/WooCommerce block markup.
- `use_block_editor_for_post(939)=true`
- `has_blocks(939)=true`
- `parse_blocks()` / `serialize_blocks()` round trip: `true`
- Home top-level block count remained `7`; no structure-level rebuild or WooCommerce custom commerce UI was introduced.
- The only UI-adjacent adjustment in this Gate was restoring spaces around K1B mobile-only `<br>` markers so desktop text remains readable while mobile wrapping remains intact.
- Fresh local screenshots at 375px and 1440px show the existing K1B UI remains bounded and readable.

`GUTENBERG_REGRESSION=PASS`
`RESPONSIVE_SMOKE=PASS`
`K1B_UI_REGRESSION=PASS`
`OWNER_EDITABILITY=PASS`

### Backup, cleanup, and safety

- Pre-K2 full Studio backup retained locally at `.artifacts/k2-commerce-loop/pre-k2-backup.zip`.
- Backup SHA-256: `AE6AD6CC4CC0265E7E45404F8BC08861F84DCDCD01B041BD1149CB55704FFB23`
- Temporary K2 PHP helpers, local cookies, Store API headers, checkout responses, confirmation URL, and admin HTML were removed after validation.
- Only the local rollback backup and non-sensitive responsive QA screenshots remain in the K2 artifact directory.
- `REAL_PAYMENT_ACTIONS=0`
- `VPS_WRITES=ZERO`
- `SECRET_EXPOSURE=NO`
- `DOCKER_VOLUMES_DELETED=NO`
- `UNRELATED_PROJECTS_TOUCHED=NO`
- No `.env`, password, token, cookie, order key, private key, or payment credential was written to GitHub.

### Reviewer checkpoint

`STOP_AT_REVIEWER=YES`

K2 execution is complete. Executor does not enter K3/PayPal, K4, K5, K6/VPS, K7, or production.

## K3 — PayPal Sandbox (2026-09-21) — RETURN

~~~
K3_GATE=K3_PAYPAL_SANDBOX
K3_PREFLIGHT=PASS
K3_LOCAL_RUNTIME=WORDPRESS_STUDIO
K3_LOCAL_SITE_PATH=C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-kadence-poc\.studio\mini-craft-night-kit
K3_LOCAL_URL=http://localhost:8881/
K3_ROLLBACK_BACKUP=PASS
K3_BACKUP_ARTIFACT_LOCAL_ONLY=C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-kadence-poc\.artifacts\k3-paypal-sandbox\pre-k3-backup.zip
K3_BACKUP_SHA256=F669688F07BF0B4287B50C1B0B2DEBA5B8527E2BFAE03E9CC55C7CB9920939FF
~~~

### K3 preflight and baseline

- Studio CLI 1.21.0; Studio-managed Mini Craft site exists and was reachable.
- K2 test baseline was recorded before payment changes: JPY currency, existing local/test-only Mini Craft product, local/test-only zero-cost shipping, tax disabled, and the Studio SQLite hold_stock_minutes=0 workaround. These remain test-only values and were not promoted to production truth.
- Old project remained present; http://localhost:8088/ returned HTTP 200 during the K3 preflight. No old project files, database, volume, or theme were changed.
- No VPS, Cloudflare, public tunnel, production domain, or production payment action was used.

### Official plugin

~~~
OFFICIAL_WOOCOMMERCE_PAYPAL_PAYMENTS=PASS
PLUGIN_NAME=WooCommerce PayPal Payments
PLUGIN_SLUG=woocommerce-paypal-payments
PLUGIN_VERSION=4.1.3
PLUGIN_SOURCE=WordPress.org official WooCommerce plugin by WooCommerce
PLUGIN_ACTIVE=YES
ADDITIONAL_PAYMENT_PLUGIN=NO
~~~

The Studio WP-CLI remote installer returned a URL-invalid download error. The same official WordPress.org package was downloaded into the project-local .cache, installed successfully, activated, and the reproducible zip was removed after installation. No third-party PayPal plugin was installed.

The official setup wizard was advanced only through non-credential choices appropriate to this physical-goods local test store: Business account type, Physical Goods, and No thanks for the optional Expanded Checkout application.

### Owner checkpoint

The official UI reached:

~~~
WooCommerce → Settings → Payments → PayPal Payments
Complete Your Payment Setup
Connect to PayPal
~~~

The page explicitly requires PayPal login to continue. Therefore:

~~~
RETURN_OWNER_PAYPAL_SANDBOX_AUTH_REQUIRED
PAYPAL_MODE=NOT_CONFIGURED_OWNER_CHECKPOINT
PAYPAL_LIVE_ENABLED=NO
SANDBOX_ACCOUNT_CONNECTED=NOT_RUN_OWNER_CHECKPOINT
~~~

Owner-only action: in the local WordPress PayPal Payments setup page, click Connect to PayPal, complete the PayPal Sandbox account login/authorization in the provider flow, and choose Sandbox only if an environment choice is presented. Do not send any PayPal password, Client Secret, token, OAuth code, cookie, or webhook secret in chat or GitHub.

### K3 validation status

~~~
PAYPAL_CHECKOUT_VISIBLE=NOT_RUN_OWNER_CHECKPOINT
SANDBOX_PAYMENT_APPROVED=NOT_RUN_OWNER_CHECKPOINT
SANDBOX_CAPTURE=NOT_RUN_OWNER_CHECKPOINT
ORDER_PROVIDER_CORRELATION=NOT_RUN_OWNER_CHECKPOINT
WOO_ORDER_PAID_STATE=NOT_RUN_OWNER_CHECKPOINT
PHYSICAL_FULFILLMENT_NOT_AUTO_COMPLETED=NOT_RUN_OWNER_CHECKPOINT
WEBHOOK_OR_CALLBACK=NOT_RUN_OWNER_CHECKPOINT
PUBLIC_CALLBACK_ROUTE=NOT_CREATED
SANDBOX_REFUND=NOT_RUN_OWNER_CHECKPOINT
REFUND_IDEMPOTENCY_SMOKE=NOT_RUN_OWNER_CHECKPOINT
~~~

A browser smoke open reached the existing Cart page and showed the normal empty-cart state. K2 already carried the local Checkout baseline; K3 payment checkout was intentionally not executed before Owner authorization.

### Safety and handoff

~~~
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
PRODUCTION_DOMAIN_WRITES=ZERO
SECRET_EXPOSURE=NO
UNRELATED_PROJECTS_TOUCHED=NO
OLD_PROJECT_UNCHANGED=PASS
REVIEWER_DOCS_MODIFIED=NO
STOP_AT_REVIEWER=YES
~~~

K3 is stopped at the minimum Owner authorization checkpoint. Resume the same Gate only after the Owner completes the provider-side Sandbox authorization; do not enter Live, K4, K5, VPS, or production.
## K3 bounded diagnostic — WooCommerce/PPCP runtime failure (2026-09-21) — RETURN REVIEWER

This is a bounded diagnostic only. No PayPal authorization was retried, no credential was modified or deleted, no Live mode was enabled, and no payment/capture/refund action was executed.

~~~
K3_DIAGNOSTIC=BOUNDED
K3_DIAGNOSTIC_STATUS=RETURN_REVIEWER
STUDIO_RUNTIME_RESTART=PASS_BOUNDED_LOCAL_ONLY
PAYPAL_PLUGIN=woocommerce-paypal-payments 4.1.3 active
PAYPAL_USE_SANDBOX=false
PAYPAL_MERCHANT_CONNECTED=false
PAYPAL_CLIENT_SECRET_STORED=false
PAYPAL_ONBOARDING_COMPLETED=false
PAYPAL_AUTH_RETRY=0
PAYPAL_LIVE_ENABLED=NO
CREDENTIALS_MODIFIED=NO
~~~

### Direct browser evidence

- WooCommerce Settings → Payments loaded the WordPress shell and the payment-provider headings, but the provider body remained blank/loading.
- The current page did not expose a “Click for error details” control; the link could not be captured because the affected React content never rendered. This is recorded as `CLICK_FOR_ERROR_DETAILS=NOT_EXPOSED_BY_STUCK_LOAD`, not as a guessed message.
- Browser Console captured a real exception:
  `Minified React error #299` from `wp-content/plugins/woocommerce-paypal-payments/assets/ppcp-settings-js-index.js`, at the PayPal settings bundle's `createRoot` call.
- Local inspection of the loaded official bundle shows the mount call targets `document.getElementById("ppcp-settings-container")`; the live Payments page had `#ppcp-settings-container` count `0`. This is the direct evidence for the blank Payments body.
- WooCommerce Home remained stuck on its Store Activity loading state after reload; no current DOM “Click for error details” link was present. Earlier reproduction showed the reported “Oops, something went wrong” state.

~~~
PAYPAL_SETTINGS_SCRIPT=LOADED
PAYPAL_SETTINGS_MOUNT_TARGET_PRESENT=NO
PAYPAL_SETTINGS_REACT_EXCEPTION=MINIFIED_REACT_ERROR_299
CLICK_FOR_ERROR_DETAILS=NOT_EXPOSED_BY_STUCK_LOAD
HOME_REACT_BODY=STUCK_LOADING_STORE_ACTIVITY
HOME_ERROR_DETAIL_FULL_TEXT=NOT_AVAILABLE_IN_CURRENT_DOM
~~~

### REST and Network evidence

REST route registration remained present for `/wc-admin/features`, `/wc-admin/options`, `/wc/store/v1/products`, `/wc/store/v1/cart`, `/wc/v3/wc_paypal/settings`, and `/wc/v3/wc_paypal/webhooks`.

Post-restart HTTP probes were mixed: public Store API `products?per_page=1` and `cart` each returned HTTP 200 in the first clean sample; repeated probes for `/wc-admin/features`, `/wc-admin/options`, and both PayPal settings/webhook routes timed out without an HTTP response. Later repeated frontend HEAD probes also timed out while the local PHP workers were saturated. This is not a clean REST health PASS.

~~~
REST_ROUTE_REGISTRATION=PASS
WC_STORE_PRODUCTS_SAMPLE=HTTP_200
WC_STORE_CART_SAMPLE=HTTP_200
WC_ADMIN_FEATURES_HTTP=TIMEOUT_NO_HEADERS
WC_ADMIN_OPTIONS_HTTP=TIMEOUT_NO_HEADERS
PPCP_SETTINGS_HTTP=TIMEOUT_NO_HEADERS
PPCP_WEBHOOKS_HTTP=TIMEOUT_NO_HEADERS
NETWORK_FAILURE_CLASS=LOCAL_REQUEST_TIMEOUT_OR_WORKER_SATURATION
~~~

### Logs and runtime evidence

- `WP_DEBUG=false`; `WP_DEBUG_LOG=false`; no `wp-content/debug.log` was present.
- No dedicated project PHP error log was found; WooCommerce logs were available.
- WooCommerce logs contain repeated Patterns Toolkit connection warnings.
- The PayPal log contains repeated upstream webhook API HTTP 404 responses and onboarding/OAuth records with `use_sandbox=false`; sensitive one-time OAuth fields were not retained in this evidence.
- After the bounded local runtime restart, four Studio PHP workers were again observed at sustained high CPU while the admin/API requests stalled. The restart was only a diagnostic recovery action and did not change WordPress business data or PayPal settings.

~~~
WP_DEBUG=FALSE
WP_DEBUG_LOG=FALSE
PHP_ERROR_LOG=NOT_FOUND
WORDPRESS_DEBUG_LOG=NOT_FOUND
WOOCOMMERCE_LOG=AVAILABLE
PPCP_UPSTREAM_WEBHOOK_LOG=HTTP_404_OBSERVED
PPCP_ONBOARDING_LOG=USE_SANDBOX_FALSE_OBSERVED
PHP_WORKER_SATURATION=OBSERVED
~~~

### Root-cause candidate and minimum fix

~~~
ROOT_CAUSE_CANDIDATE=PPCP_4.1.3_ADMIN_SETTINGS_REACT_MOUNT_FATAL_PLUS_ASSOCIATED_REMOTE_API_OR_WORKER_HANG
HOME_FAILURE_CANDIDATE=WC_ADMIN_REST_REQUEST_TIMEOUT_UNDER_PPCP_OR_REMOTE_CALL_SATURATION
MINIMUM_FIX=REVIEWER_AUTHORIZE_BOUNDED_PPCP_ISOLATION_TEST_OR_PRE_K3_ROLLBACK
PPCP_DEACTIVATION=NOT_EXECUTED_REVIEWER_REQUIRED
~~~

The direct Payments-page failure is attributable to the active official PPCP settings bundle mounting React against a missing container. The Home failure has an additional request-timeout/worker-saturation signal, so the executor does not claim that the PayPal JS fatal alone explains every symptom. The minimum next step is a Reviewer-authorized isolation test: temporarily deactivate only WooCommerce PayPal Payments, or restore the retained pre-K3 backup, then retest Payments, WooCommerce Home, and the affected REST routes. If isolation clears the fault, keep the result at Reviewer and re-establish a clean Sandbox-only onboarding path later; do not mutate or reuse the observed production-mode onboarding state.

~~~
RETURN_REVIEWER_PPCP_CONFLICT_ISOLATION_REQUIRED=YES
PAYPAL_AUTH_RETRY=0
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
SECRET_EXPOSURE=NO
OLD_PROJECT_UNCHANGED=PASS
UNRELATED_PROJECTS_TOUCHED=NO
STOP_AT_REVIEWER=YES
~~~
### Error detail clarification

The React decoder for the captured production exception `#299` resolves the full text to: `Target container is not a DOM element.` The live page inspection independently confirmed the targeted `#ppcp-settings-container` element was absent. No WooCommerce “Click for error details” link was rendered by the stuck Home view, so no additional WooCommerce UI error text was available to capture.
## K3R1 — PPCP conflict isolation (2026-09-21) — RETURN

- Gate: `K3R1_PPCP_CONFLICT_ISOLATION`
- Result: `RETURN_K3R1_CONFLICT_NOT_ISOLATED`
- Scope: one temporary deactivation test only; no reinstall, uninstall, option/credential deletion, version change, backup restore, authorization retry, Live mode, real payment, VPS, public tunnel, or database migration.

### Authorized action and state

- Plugin tested: `woocommerce-paypal-payments` `4.1.3`.
- Before: active.
- Action: deactivated only with the local Studio WordPress CLI.
- After: inactive; PPCP remains deactivated.
- Plugin files and stored configuration were not deleted or edited.
- Because four target PHP workers were saturated, the target local Studio runtime was restarted once as a bounded diagnostic recovery action. No database or volume operation was performed.

### Isolation results

- WooCommerce Settings → Payments: the blank provider body recovered enough to render the native WooCommerce payment UI, including `Payment providers`, `Take offline payments`, `Accept payments with Woo`, and the PayPal action-needed card.
- Native payment methods: visible again. The PayPal action-needed card is not evidence that PPCP was reactivated; the plugin list remained inactive.
- WooCommerce Home: not recovered to a usable dashboard; the main area remained the Store Activity shell/blank state.
- `/wc-admin/features`: timeout/no response after the final bounded restart probe.
- `/wc-admin/options`: timeout/no response after the final bounded restart probe.
- Store API products: timeout after the final bounded restart probe; an earlier post-deactivation sample returned HTTP 200, so the result is not a stable API health pass.
- Store API cart: timeout after the final bounded restart probe.
- PHP worker state: four new target workers were observed after the restart with lower CPU in the post-restart sample, but request timeouts persisted; worker saturation/request-hang behavior was not cleared.
- React #299: the final Home tab did not show a new console error and the Payments UI rendered native methods, but a final Payments-tab console recapture was not completed because navigation timed out. The prior active-PPCP React #299 fault is therefore not claimed as a full console PASS.

### Gate conclusion

```text
PPCP_DEACTIVATION_CLEARS_PAYMENTS_PAGE_FAILURE=PASS
PPCP_DEACTIVATION_CLEARS_WC_HOME_API_FAILURE=FAIL
REACT_299_POST_DEACTIVATION=NOT_OBSERVED_ON_FINAL_HOME_TAB
PPCP_REMAINS_DEACTIVATED=YES
PAYPAL_AUTH_RETRY=0
PAYPAL_LIVE_ENABLED=NO
REAL_PAYMENT_ACTIONS=0
K3R1_ISOLATION=FAIL
RETURN_K3R1_CONFLICT_NOT_ISOLATED=YES
VPS_WRITES=ZERO
SECRET_EXPOSURE=NO
UNRELATED_PROJECTS_TOUCHED=NO
OLD_PROJECT_UNCHANGED=PASS
STOP_AT_REVIEWER=YES
```

The direct Payments-page failure is isolated to the active PPCP path, but the broader WooCommerce Home/admin REST and Store API failure remains. No further change is authorized by K3R1; leave PPCP deactivated for Reviewer review.
## K3R2 — Pre-K3 parallel baseline comparison (2026-09-21) — RETURN

- Gate: `K3R2_PRE_K3_PARALLEL_BASELINE_COMPARISON`
- Result: `RETURN_K3R2_STUDIO_OR_WOOCOMMERCE_RUNTIME_SYSTEMIC`
- A current site: `http://localhost:8881/`, path `mini-craft-kadence-poc/.studio/mini-craft-night-kit`
- B pre-K3 clone: `http://localhost:8882/`, path `mini-craft-kadence-poc/.studio/mini-craft-k3r2-pre-k3-20260921`
- B source: retained `mini-craft-kadence-poc/.artifacts/k3-paypal-sandbox/pre-k3-backup.zip`; import completed successfully. Backup SHA-256 matched the retained K3 record.
- B was created with a separate Studio name, directory, site record, and port. B was kept running for Reviewer inspection.

### Plugin and mutation boundary

- A PPCP state before/after comparison: `woocommerce-paypal-payments` `4.1.3`, inactive.
- B plugin inventory after import: WooCommerce `10.0.4` active; Kadence components present; no `woocommerce-paypal-payments` entry.
- Filesystem check: A PPCP directory exists; B PPCP directory does not exist.
- No PPCP was installed or activated in B.
- A was not overwritten, restored, restarted, or configured by this Gate. A-side operations were read-only status/plugin checks and HTTP probes only.
- No version change, PayPal authorization, Live mode, real payment, database migration, VPS, Cloudflare, or public tunnel was performed.

### A/B runtime comparison

All probes used the same local HTTP method with `--noproxy *` and a 4-second bounded timeout. `HTTP 000` means no HTTP response before the timeout; it is not a guessed application status.

| Required check | A — current 8881 | B — pre-K3 clone 8882 |
|---|---:|---:|
| WordPress frontend `/` | HTTP 000 / ~4.0s timeout | HTTP 000 / ~4.0s timeout |
| Studio auto-login → wp-admin | HTTP 000 / ~4.0s timeout | HTTP 000 / ~4.0s timeout |
| wp-admin `/wp-admin/` | HTTP 000 / ~4.0s timeout | HTTP 000 / ~4.0s timeout |
| WooCommerce Home `page=wc-admin` | HTTP 000 / ~4.0s timeout | HTTP 000 / ~4.0s timeout |
| Settings → Payments | HTTP 000 / ~4.0s timeout | HTTP 000 / ~4.0s timeout |
| `/wp-json/wc-admin/features` | HTTP 000 / ~4.0s timeout | HTTP 000 / ~4.0s timeout |
| `/wp-json/wc-admin/options` | HTTP 000 / ~4.0s timeout | HTTP 000 / ~4.0s timeout |
| Store API products | HTTP 000 / ~4.0s timeout | HTTP 000 / ~4.0s timeout |
| Store API cart | HTTP 000 / ~4.0s timeout | HTTP 000 / ~4.0s timeout |
| Product `/product/mini-craft-night-kit/` | HTTP 000 / ~4.0s timeout | HTTP 000 / ~4.0s timeout |
| Cart `/cart/` | HTTP 000 / ~4.0s timeout | HTTP 000 / ~4.0s timeout |
| Checkout `/checkout/` | HTTP 000 / ~4.0s timeout | HTTP 000 / ~4.0s timeout |

Both Studio ports were listening on IPv6 loopback (`::1:8881` and `::1:8882`), so the result is not explained by an unbound port. The B start operation completed with `WordPress server started` before the probes.

### PHP worker evidence

At the comparison sample, A and B each had four native Studio PHP workers. Over a 5-second process-CPU delta sample:

- A: one worker consumed approximately 4.828 CPU seconds (~96.6% of one core); the other three were approximately 0 CPU delta.
- B: one worker consumed approximately 4.891 CPU seconds (~97.8% of one core); the other three were approximately 0 CPU delta.
- HTTP requests for both sites continued to time out during/after the sample.

### Interpretation

B is not healthy while A is unhealthy. The pre-K3 baseline clone reproduces the same no-response and worker-hang pattern without PPCP. Therefore this Gate does not confirm a K3-only regression.

```text
K3R2_GATE=K3R2_PRE_K3_PARALLEL_BASELINE_COMPARISON
PRE_K3_BACKUP_IMPORT=PASS
PARALLEL_CLONE=PASS
PARALLEL_CLONE_URL=http://localhost:8882/
A_SITE_MODIFIED=NO
A_PPCP_REMAINS_DEACTIVATED=YES
B_PPCP_INSTALLED=NO
PRE_K3_BASELINE_HEALTHY=NO
CURRENT_SITE_RUNTIME_REGRESSION=NOT_CONFIRMED
A_B_RUNTIME_RESULT=BOTH_FAIL_SIMILARLY
RETURN_K3R2_STUDIO_OR_WOOCOMMERCE_RUNTIME_SYSTEMIC=YES
NO_VERSION_CHANGE=YES
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
SECRET_EXPOSURE=NO
UNRELATED_PROJECTS_TOUCHED=NO
STOP_AT_REVIEWER=YES
```

The parallel clone and its imported database are intentionally retained until Reviewer decides the next runtime/database diagnostic. No recovery action was applied to A.
## K3R3 — Studio / WooCommerce runtime isolation (C0 stop) (2026-09-21) — RETURN

- Gate: `K3R3_STUDIO_WOOCOMMERCE_RUNTIME_ISOLATION`
- Result: `RETURN_K3R3_STUDIO_RUNTIME_SYSTEMIC`
- A current site remained read-only at `http://localhost:8881/`; PPCP `4.1.3` remained inactive.
- B pre-K3 clone at `http://localhost:8882/` was not changed in this Gate.
- Fresh control C0: `Mini Craft K3R3 Clean WordPress Control`, path `mini-craft-kadence-poc/.studio/mini-craft-k3r3-control-20260921`, URL `http://localhost:8883/`.
- Studio CLI/runtime family: Studio `1.21.0`, WordPress `6.8.9`, native PHP `8.4`.

### C0 construction boundary

- C0 was created as a fresh Studio WordPress site with a separate site record, directory, and port.
- C0 `wp-content/plugins/woocommerce/` was absent; C0 `woocommerce-paypal-payments/` was also absent.
- No Kadence, Starter Templates, WooCommerce, PPCP, payment onboarding, or project database was installed in C0.
- Ports `8881`, `8882`, and `8883` were listening on IPv6 loopback; C0 start completed with `WordPress server started`.

### C0 runtime checks

All HTTP checks used `--noproxy *`, a 1-second connect limit, and a bounded response timeout.

| Check | C0 result |
|---|---:|
| Front page `/` | HTTP 000 / 4.008s timeout |
| wp-admin `/wp-admin/` | HTTP 000 / 4.007s timeout |
| Core REST `/wp-json/` | HTTP 000 / 4.010s timeout |
| Repeated `/` request 1 | HTTP 000 / 3.004s timeout |
| Repeated `/` request 2 | HTTP 000 / 3.014s timeout |
| Repeated `/` request 3 | HTTP 000 / 3.005s timeout |

C0 had four native Studio PHP workers. In a 5-second process-CPU sample, one worker consumed approximately 4.828 CPU seconds (~96.6% of one core) while the other three had approximately 0 CPU delta. HTTP requests continued to time out.

### Gate stop and safety

Because clean WordPress C0 already hangs before WooCommerce is installed, the decision requires an immediate return. C1 was not created or installed, and B WooCommerce deactivation was not executed.

```text
K3R3_GATE=K3R3_STUDIO_WOOCOMMERCE_RUNTIME_ISOLATION
C0_CREATED=PASS
C0_CLEAN_WORDPRESS=PASS
C0_WOOCOMMERCE_INSTALLED=NO
C0_FRONTEND=TIMEOUT
C0_WP_ADMIN=TIMEOUT
C0_CORE_REST=TIMEOUT
C0_REPEATED_REQUESTS=TIMEOUT
C0_PHP_WORKER_HANG=OBSERVED
C1_EXECUTED=NO_GATE_STOP_AT_C0
B_WOOCOMMERCE_DEACTIVATION=NOT_EXECUTED_GATE_STOP_AT_C0
A_SITE_MODIFIED=NO
A_PPCP_REMAINS_DEACTIVATED=YES
PAYPAL_AUTH_RETRY=0
REAL_PAYMENT_ACTIONS=0
NO_VERSION_CHANGE=YES
DATABASE_MIGRATION=NO
VPS_WRITES=ZERO
PUBLIC_TUNNEL=NO
SECRET_EXPOSURE=NO
UNRELATED_PROJECTS_TOUCHED=NO
RETURN_K3R3_STUDIO_RUNTIME_SYSTEMIC=YES
STOP_AT_REVIEWER=YES
```

C0 is intentionally retained with B until Reviewer decides cleanup/recovery. No further K3R3 action is authorized from this result.
## K3R4 D0-D2 Docker + MariaDB Local Recovery — 2026-09-21 12:58 +08:00

Gate: K3R4_LOCAL_RUNTIME_ESCAPE_DOCKER_MARIADB

### D0 clean control runtime

- D0_PROJECT: C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-docker-mariadb
- D0_URL: http://localhost:8092
- COMPOSE_PROJECT: mini-craft-k3r4-docker-mariadb
- D0_IMAGES: wordpress:6.8.2-php8.3-apache, mariadb:11.4.7
- D0_CONTAINERS: mini-craft-k3r4-wordpress, mini-craft-k3r4-mariadb
- D0_VOLUMES: independent WordPress and MariaDB named volumes
- D0_RUNTIME: / 200; /wp-admin/ 302 unauthenticated; /wp-json/ 200; five repeated home requests 200 with approximately 49–69 ms response times
- D0_HEALTH: MariaDB healthy; WordPress container up; sampled CPU approximately 0.01%
- D0_RESULT=PASS

### D1 official WooCommerce control runtime

- D1_INSTALL: official WooCommerce 10.0.4 only; no Kadence, Starter Templates, PPCP, or payment onboarding
- D1_PLUGIN_LIST: Akismet inactive; Hello inactive; WooCommerce active 10.0.4
- D1_TEST_DATA: one generic local control product, no Mini Craft import
- D1_AUTH_RUNTIME: Home 200; wp-admin 200; WooCommerce Home 200; Settings → Payments 200; /wp-json/wc-admin/features 200; /wp-json/wc-admin/options 200; Store API products/cart 200; Product 200; Cart 200; Checkout 200
- D1_HEALTH: MariaDB healthy; WordPress container up; sampled CPU approximately 0.01%
- D1_RESULT=PASS

### D2 Mini Craft recovery on MariaDB

- D2_PROJECT: C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery
- D2_URL: http://localhost:8093
- D2_COMPOSE_PROJECT: mini-craft-k3r4-mariadb-recovery
- D2_IMAGES: wordpress:6.8.2-php8.3-apache, mariadb:11.4.7
- D2_CONTAINERS: mini-craft-k3r4-recovery-wordpress, mini-craft-k3r4-recovery-mariadb
- D2_VOLUMES: independent MariaDB, WordPress core, and WordPress content named volumes
- D2_SOURCE: retained pre-k3-backup.zip; direct SQL dump import plus retained wp-content copy; no SQLite→MariaDB converter
- D2_DB_IMPORT: 52 tables imported into MariaDB successfully; no Studio wp-config.php reused
- D2_PLUGIN_LIST: Akismet inactive; Hello inactive; Kadence Blocks active 3.7.11; Kadence Starter Templates active 2.3.4; WooCommerce active 10.0.4; PPCP absent
- D2_URL_NORMALIZATION: clone-only siteurl and home set to http://localhost:8093
- D2_STOCK_HOLD: backup contained woocommerce_hold_stock_minutes=0; clone-only recovery runtime normalized to 10; a local pending test order produced one wc_reserved_stock row with quantity 1; no payment was attempted
- D2_RUNTIME: Home 200; Product 200; Cart 200; Checkout 200 after local add-to-cart; wp-admin 200; Orders admin 200; Gutenberg editor endpoint 200
- D2_WOOCOMMERCE_ADMIN: WooCommerce Home 200; Settings → Payments 200; /wp-json/wc-admin/features/ 200 with authenticated REST nonce; /wp-json/wc-admin/options/ 200 with its required options query and authenticated REST nonce
- D2_STORE_API: products 200; cart 200
- D2_RESPONSIVE: 375px mobile, 768px tablet, and 1440px desktop smoke checks completed; 375px visual check showed mobile header/menu and no visible horizontal crop; browser warning/error log count 0
- D2_PERFORMANCE: repeated home requests 200 at approximately 0.23–0.29 seconds; repeated wp-json requests 200 at approximately 0.21–0.27 seconds; sampled WordPress CPU approximately 0.01%; no one-hot worker observed
- D2_RESULT=PASS

### Safety and scope

- STUDIO_A_B_C0_TOUCHED=NO
- CURRENT_STUDIO_PPCP_REACTIVATED=NO
- OLD_DOCKER_8090_TOUCHED=NO
- OLD_PROJECT_UNCHANGED=PASS
- OLD_8090_SMOKE=200
- OLD_8088_SMOKE=200
- UNRELATED_PROJECTS_TOUCHED=NO
- DOCKER_VOLUMES_DELETED=NO
- REAL_PAYMENT_ACTIONS=0
- PAYPAL_AUTH_ACTIONS=0
- LIVE_MODE=NO
- VPS_WRITES=ZERO
- SECRET_EXPOSURE=NO

### Gate result

PASS_CANDIDATE_K3R4_DOCKER_MARIADB_LOCAL_RECOVERY

D0_CLEAN_WORDPRESS=PASS
D1_WOOCOMMERCE_DOCKER_BASELINE=PASS
D2_MINI_CRAFT_MARIADB_RECOVERY=PASS
K1B_UI_PRESERVED=PASS
K2_COMMERCE_PRESERVED=PASS
NORMAL_STOCK_HOLD=PASS
STOP_AT_REVIEWER=YES

No PayPal reauthorization, Live mode, VPS, production domain, or K4/K5 work was entered.
## K3R5 P0 — Docker PPCP 4.1.3 UI Compatibility Return — 2026-09-21 14:03 +08:00

Gate: K3R5_PAYPAL_SANDBOX_DOCKER
Target: http://localhost:8093/

### Pre-K3R5 rollback

- ROLLBACK_DIR: local-only C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery\.artifacts\k3r5-preflight-20260921
- ROLLBACK_DATABASE: MariaDB dump created successfully; 2,178,206 bytes; mariadb-check returned OK for the database tables
- ROLLBACK_WP_CONTENT: complete named-volume archive created successfully; 11,097 archive entries; plugins and uploads present
- ROLLBACK_CONFIG: local wp-config.php copy retained; no configuration values recorded here
- ROLLBACK_SECRET_EXPOSURE=NO

### P0 change

- Official woocommerce-paypal-payments version 4.1.3 installed from the WordPress.org package and activated on the Docker/MariaDB recovery runtime
- No PayPal login, account connection, OAuth consent, credential entry, Sandbox authorization, Live enablement, or payment action was performed
- No version upgrade/downgrade, Studio write, VPS write, public tunnel, or custom PayPal API was used
- Plugin list after activation remained: Akismet inactive; Hello inactive; Kadence Blocks active 3.7.11; Kadence Starter Templates active 2.3.4; WooCommerce active 10.0.4; WooCommerce PayPal Payments active 4.1.3

### P0 runtime evidence

- WooCommerce Home UI loaded with visible Home, store task list, and Welcome to Mini Craft Night Kit
- WooCommerce Settings → Payments UI loaded with visible Payments and Payment providers
- PayPal settings section HTTP response: 200 at dmin.php?page=wc-settings&tab=checkout&section=ppcp-gateway
- WooCommerce PayPal settings REST requests observed in the local browser network: wc_paypal/settings 200 and wc_paypal/payment 200
- /wp-json/wc-admin/features/ 200 with authenticated REST nonce
- /wp-json/wc-admin/options/ 200 with its required options query and authenticated REST nonce
- Store API products 200; Store API cart 200
- Product 200; Cart 200; Checkout 200 after local add-to-cart
- Home 200; /wp-json/ 200; authenticated WooCommerce Home 200; authenticated Payments 200
- Five repeated Home requests returned 200 at approximately 0.24–0.36 seconds
- WordPress container up; MariaDB healthy; sampled CPU approximately 0.01% WordPress and 0.03% MariaDB

### Browser Console conflict

- PPCP_REACT_ERROR=CONFIRMED
- PPCP_REACT_ERROR_CODE=Minified React error #299
- Stack points to ReactDOM.createRoot inside wp-content/plugins/woocommerce-paypal-payments/assets/ppcp-settings-js-index.js
- A deprecated WordPress tooltip warning was also present; the blocking finding is the PPCP React #299 error
- The Payments page rendered its outer shell, but the PPCP React mount is not considered healthy; no PayPal authorization was attempted

### Gate result

RETURN_K3R5_PPCP_4_1_3_DOCKER_UI_CONFLICT

P0_RESULT=RETURN
P1_OWNER_PAYPAL_AUTH=NOT_REACHED
PAYPAL_LIVE_ENABLED=NO
REAL_PAYMENT_ACTIONS=0
STUDIO_WRITES=ZERO
VPS_WRITES=ZERO
SECRET_EXPOSURE=NO
STOP_AT_REVIEWER=YES

PPCP was left installed and active only to preserve the captured P0 failure state for Reviewer decision; the project-local rollback backup is ready. No further K3R5 phase was entered.

## K3R6 PPCP page-scope mount isolation (2026-09-21)

- Scope: Docker/MariaDB active runtime only, `http://localhost:8093/`; no Studio or other runtime writes.
- A (clean local admin page load): `/wp-admin/admin.php?page=wc-settings&tab=checkout` returned HTTP 200. Native WooCommerce Payments UI was visible, including `Payment providers` and the PayPal provider card. `#ppcp-settings-container` count was `0`. `ppcp-settings-js-index.js` was loaded. Browser Console recorded Minified React error `#299` from the PPCP settings bundle (`ReactDOM.createRoot` mount path).
- B (separate clean page load): `/wp-admin/admin.php?page=wc-settings&tab=checkout&section=ppcp-gateway` returned HTTP 200. `#ppcp-settings-container` count was exactly `1`; it was visible, had one child, and contained rendered PayPal Payments UI. The actionable control was visible and enabled as `Activate PayPal Payments`; `Manually Connect` was visible. No literal `Connect to PayPal` label was present in this PPCP 4.1.3 UI. No Console error or React `#299` was recorded on B. No control was clicked and no PayPal authorization was started.
- Authenticated local-admin REST smoke: `wc-admin/features` HTTP 200; `wc-admin/options` HTTP 200; `wc_paypal/settings` HTTP 200; `wc_paypal/payment` HTTP 200; Store API products HTTP 200; Store API cart HTTP 200. A/B page requests were HTTP 200.
- Runtime smoke: repeated home requests were HTTP 200 with approximately 0.27–0.43 s observed latency after the initial sample; WordPress container CPU was 0.01% and MariaDB container CPU was 0.02% at capture. No worker timeout or blocking runtime symptom was observed in this bounded probe.
- Safety: no plugin/version change, WooCommerce change, patch, DOM workaround, PayPal login, Live mode, real payment, VPS write, public tunnel, or Studio write.

K3R6_RESULT=PASS_CANDIDATE_K3R6_PPCP_OVERVIEW_ONLY_UI_DEFECT
OWNER_CHECKPOINT=RETURN_OWNER_PAYPAL_SANDBOX_AUTH_REQUIRED_DOCKER
STOP_AT_REVIEWER=YES
## K3R8 PayPal Sandbox credential / plugin isolation — Phase A and Owner checkpoint (2026-09-21)

- Target: active Docker/MariaDB runtime `http://localhost:8093/`; PPCP 4.1.3 remained active. No version change, source patch, Live enablement, repeated connect attempt, or credential mutation was performed.
- Phase A no-secret container probe: DNS resolution for `api-m.sandbox.paypal.com` succeeded. HTTPS reached the PayPal endpoint and returned HTTP 403 for the unauthenticated base request; this is network reachability evidence, not a credential verdict. TLS negotiated successfully with TLS 1.3 and certificate verification `OK`; probe exit was 0.
- Phase B helper: a LOCAL-ONLY PowerShell helper was created at the active runtime `.artifacts` path for Owner execution. It prompts Client ID and `Read-Host -AsSecureString` Secret, posts only the OAuth client-credentials request, and outputs only redacted PASS/FAIL plus HTTP status/token-received yes/no. Syntax validation returned 0 errors. No credential value, Authorization header, token, response body, or credential-bearing log was written.
- Phase C is intentionally pending Owner OAuth result; PPCP logs/REST error-code interpretation will occur only if the Owner helper returns OAuth PASS.

K3R8_PHASE_A_NETWORK_TLS=PASS
K3R8_PHASE_B_OWNER_OAUTH=REQUIRED
K3R8_RESULT=RETURN_OWNER_K3R8_SANDBOX_OAUTH_CHECK_REQUIRED
STOP_AT_REVIEWER=YES
## K3R8B Local OAuth helper diagnostic (2026-09-21)

- Scope remained host/helper-only on the active Docker/MariaDB runtime. No PayPal credential, PPCP/WooCommerce version, source, Live mode, or provider connection was changed.
- Host baseline: PowerShell 7.6.5 Core. .NET DNS resolution succeeded with two addresses; TCP 443 succeeded. `Resolve-DnsName` did not return a usable record in this PowerShell session, so it was not used as the final DNS verdict.
- HTTPS stack results: `Invoke-WebRequest` returned HTTP 403; .NET HttpClient with default proxy handling returned HTTP 403; .NET HttpClient with proxy disabled also returned HTTP 403. These prove an HTTP-layer response but are not credential verdicts.
- Proxy/environment: `HTTP_PROXY` was present with an HTTP scheme and no userinfo; `HTTPS_PROXY`, `ALL_PROXY`, and `NO_PROXY` were absent. WinHTTP reported direct access. Proxy values were not printed.
- Raw TLS comparison: Windows curl/Schannel failed the TLS handshake with exit 35 in both default and no-proxy modes; direct .NET SslStream also failed with a generic IO exception. This is a mixed host TLS/proxy-path result, not a DNS/TCP failure and not a credential result.
- Existing helper was syntax-valid but collapsed all request/setup exceptions to `LOCAL_REQUEST_FAILURE`. Body/header construction was independently validated with non-secret dummy values. The helper was revised locally to classify only `DNS_FAILURE`, `TCP_FAILURE`, `TLS_FAILURE`, `PROXY_FAILURE`, `HTTP_401`, `HTTP_403`, `HTTP_200_TOKEN_RECEIVED`, or `POWERSHELL_REQUEST_EXCEPTION`; it never prints response bodies or credential-bearing values.

ROOT_CAUSE_CANDIDATE=HELPER_EXCEPTION_CLASSIFICATION_GAP_WITH_MIXED_HOST_SCHANNEL_PROXY_PATH
K3R8B_HOST_DIAGNOSTIC=PASS_WITH_TLS_STACK_MISMATCH
K3R8B_OWNER_RETRY=REQUIRED
K3R8B_RESULT=RETURN_OWNER_K3R8B_CORRECTED_HELPER_REQUIRED
STOP_AT_OWNER_CHECKPOINT=YES
## K3R8C Container-native OAuth checkpoint (2026-09-21)

- Scope: active Docker/MariaDB runtime `http://localhost:8093/`; no PPCP/WooCommerce/WordPress version change, source patch, Live enablement, or repeated connect attempt.
- The OAuth request path was moved off Windows HTTPS stacks. A PHP helper inside the WordPress container uses WordPress `wp_remote_post` to `https://api-m.sandbox.paypal.com/v1/oauth2/token` with `grant_type=client_credentials`.
- Owner input path: a local PowerShell wrapper prompts Client ID and hidden Secret, sends them only as transient STDIN bytes to `docker exec`; they are not command-line arguments, environment variables, files, logs, GitHub content, or shell-history literals. The PHP helper emits only the five redacted result fields and never emits response content.
- Validation: container PHP lint exit 0; PowerShell wrapper syntax errors 0; no credential-like literals in either helper. The container-side temporary helper was removed after validation; local helper files remain only under active runtime `.artifacts` and contain no credential values.

DIAGNOSTIC_PACKET
GATE=K3R8C_CONTAINER_NATIVE_OAUTH_CHECK
ENVIRONMENT=Windows host plus active WordPress Docker container mini-craft-k3r4-recovery-wordpress on localhost:8093
TRIGGER=Owner K3R8B helper returned LOCAL_REQUEST_FAILURE before an HTTP credential result
REPRODUCTION=Owner runs the local container-native wrapper; Client ID and Secret enter only interactive prompts and travel through STDIN to PHP wp_remote_post
OBSERVED=container PHP lint 0; PowerShell syntax errors 0; OAuth status pending Owner execution
CONTROL_OR_BASELINE=K3R8A container DNS/TLS reachability PASS; Windows host path had mixed Schannel/HTTP-stack behavior
HYPOTHESES_RULED_OUT=No conclusion of invalid credentials; no credential was read, recovered, printed, or stored by Executor
HYPOTHESES_REMAINING=Sandbox credential pair validity; container-native HTTP response; PPCP 4.1.3 manual-connect behavior after valid OAuth
ARTIFACTS=active runtime .artifacts/k3r8c-container-oauth.php and .artifacts/k3r8c-container-oauth.ps1; helper validation only; no secret-bearing artifact
SECRETS_REDACTED=YES
NEXT_DISCRIMINATING_TEST=Owner runs the wrapper and returns only CONTAINER_OAUTH_STAGE, PAYPAL_SANDBOX_OAUTH, HTTP_STATUS, TOKEN_RECEIVED, ERROR_CLASS
STOP_REASON=Owner-only credential input is required before Phase C

K3R8C_RESULT=RETURN_OWNER_K3R8C_CONTAINER_OAUTH_REQUIRED
STOP_AT_OWNER_CHECKPOINT=YES

## K3R8D Owner helper artifact readiness repair (2026-09-21)

- Scope: active local Docker/MariaDB runtime only: `C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery`, WordPress at `http://localhost:8093/`. No PPCP, WooCommerce, WordPress, version, Live, payment, Studio, VPS, database, or credential configuration was changed.
- The Owner-reported `ERROR_CLASS=LOCAL_HELPER_MISSING` is not a credential verdict. In the previous wrapper, that result was emitted before `docker cp`; the exact missing candidate was the host-side PHP source path `C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery\.artifacts\k3r8c-container-oauth.php`, resolved from the wrapper's hard-coded project path. The container staging path had not yet been reached.
- Current retained source artifacts after repair:
  - `.artifacts/k3r8c-container-oauth.ps1` — 5,152 bytes — SHA-256 `11174B970BC5C3806309BB6879D38D9F60DCA8B1D52B74542C6FCE8183017B96`
  - `.artifacts/k3r8c-container-oauth.php` — 2,961 bytes — SHA-256 `358E3AF38AAE41BA95E701A33B7CFC17B4B1CC22CAA4C8EBB4B7B0228137E789`
- The wrapper now resolves the PHP source beside itself via `$PSScriptRoot`, checks the active container, copies to `/tmp/k3r8c-container-oauth.php`, verifies the remote file before execution, and removes only that remote temporary copy in `finally`. The local `.ps1` and `.php` source files are not removed.
- No-secret end-to-end dry-run was executed twice through the same wrapper staging/execution/cleanup path. Both runs reached PHP/WordPress input validation without making an OAuth request, returned `NO_SECRET_DRY_RUN=PASS`, exited 0, and left no remote helper. After the second run: remote helper absent; both local source artifacts present.
- The dry-run did not read or use any Client ID, Secret, token, response body, cookie, or authorization header. No credential-bearing log or file was created.

DIAGNOSTIC_PACKET
GATE=K3R8D_OWNER_HELPER_ARTIFACT_READINESS_REPAIR
ENVIRONMENT=Windows host plus active Docker/MariaDB WordPress runtime mini-craft-k3r4-recovery-wordpress at localhost:8093
TRIGGER=Owner K3R8C run returned LOCAL_HELPER_MISSING with HTTP_STATUS=0 before an OAuth request
REPRODUCTION=Previous wrapper performed Test-Path on its host-side PHP source path before docker cp; repaired wrapper was then run twice with -NoSecretDryRun
OBSERVED=Previous result was LOCAL_HELPER_MISSING; current source helpers exist; two no-secret runs staged, executed, and cleaned the remote helper successfully
CONTROL_OR_BASELINE=Active WordPress container is running; no PayPal request was made by the dry-run; remote helper was absent after each run
HYPOTHESES_RULED_OUT=Credential invalidity, PayPal HTTP response, container OAuth failure, and PHP request failure were not tested or inferred; no credentials were accessed; source-path failure was isolated before network execution
HYPOTHESES_REMAINING=Owner-entered Sandbox credential pair result and the later PPCP manual-connect behavior remain pending Owner checkpoint
ARTIFACTS=retained local .artifacts/k3r8c-container-oauth.ps1 and .artifacts/k3r8c-container-oauth.php; remote /tmp/k3r8c-container-oauth.php is run-scoped only and absent after cleanup
SECRETS_REDACTED=YES
NEXT_DISCRIMINATING_TEST=Owner runs the exact readiness-verified wrapper and reports only its five redacted output fields
STOP_REASON=Owner-only Client ID and hidden Sandbox Secret input is required for the real OAuth request

OWNER_CHECKPOINT_READINESS
COMMAND=powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery\.artifacts\k3r8c-container-oauth.ps1"
LOCAL_ARTIFACTS_PRESENT=PASS
CONTAINER_STAGING_PATH=PASS
POST_CLEANUP_EXISTENCE_CHECK=PASS
NO_SECRET_DRY_RUN=PASS
EXPECTED_PRE_AUTH_STAGE=CONTAINER_HELPER_EXECUTED_INPUT_VALIDATION
CLEANUP_AFTER_OWNER_RUN=Wrapper removes only /tmp/k3r8c-container-oauth.php in finally; retained local source helpers remain in active runtime .artifacts

K3R8D_RESULT=RETURN_OWNER_K3R8D_CONTAINER_OAUTH_REQUIRED
STOP_AT_OWNER_CHECKPOINT=YES

## K3R8C Phase C — PPCP manual-connect isolation (2026-09-21)

- Scope: active Docker/MariaDB runtime only, `http://localhost:8093/`; no PPCP/WooCommerce/WordPress version change, source patch, Live enablement, real payment, public tunnel, VPS write, database migration, or credential mutation.
- Owner's real container-native OAuth result was accepted as the precondition for this phase: `PAYPAL_SANDBOX_CREDENTIAL_PAIR=VALID_FOR_THIS_RUN`, `PAYPAL_SANDBOX_CONTAINER_HTTP=PASS`, `PAYPAL_SANDBOX_OAUTH_TOKEN_ISSUANCE=PASS`. No credential was re-entered by Executor.
- Existing PPCP log evidence was sufficient; no bounded manual-connect retry was executed.

### Existing manual-connect failure evidence

- The WooCommerce PayPal Payments log `woocommerce-paypal-payments-2026-09-21-8098f8945f88a0b743a37ee6e7224fa0.log` records the latest Sandbox attempt at `2026-09-21T11:12:47Z`: `Attempting manual connection to PayPal...` with `sandbox=true`, followed by `Direct API authentication failed: Failed to retrieve payee details.`
- The web access log records the corresponding `POST /wp-json/wc/v3/wc_paypal/authenticate/direct` at `11:12:46Z` as HTTP 200. Earlier production and Sandbox attempts were also HTTP 200; the production attempt separately recorded an upstream 401, while the latest Sandbox attempt was wrapped by PPCP without an upstream status/body in the WooCommerce log.
- The PPCP 4.1.3 source confirms the direct-connect path: `AuthenticationRestEndpoint::connect_direct()` validates format, then `AuthenticationManager::authenticate_via_direct_api()` calls `request_payee()`. `request_payee()` creates a minimal PayPal order and retrieves that order to obtain the payee; any upstream/JSON/transport Throwable is collapsed to `Failed to retrieve payee details.` and the REST response is returned as HTTP 200 with `success=false` and the generic `Could not connect to PayPal. Please verify your credentials and try again.` message.
- Browser evidence on the direct PPCP page: the page rendered HTTP 200; the visible notice was `Could not connect to PayPal. Please verify your credentials and try again.`; Console captured three PPCP bundle errors `Connection error Object` from `ppcp-settings-js-index.js`. No new React #299 was observed on this direct page.

### Current PPCP/plugin/REST state

- Runtime versions: WordPress 6.8.2, WooCommerce 10.0.4, WooCommerce PayPal Payments 4.1.3; PPCP active; WordPress and MariaDB containers running, MariaDB healthy.
- Redacted authenticated REST inspection returned HTTP 200 for `/wc/v3/wc_paypal/common`, `/settings`, `/payment`, and `/features`. `common` reports `useSandbox=true`, `useManualConnection=true`, `merchant.isConnected=false`, `merchant.isSandbox=false`; `onboarding` reports `completed=false`, `step=4`, `gatewaysSynced=false`, `gatewaysRefreshed=false`.
- `/wc/v3/wc_paypal/payment` returned `success=true` but all PPCP payment gateway entries remained disabled. `/wc/v3/wc_paypal/webhooks` returned HTTP 200 with `success=false` and `No webhooks found.`
- The post-failure `woocommerce-ppcp-data-common` state has no persisted merchant connection: `merchant_connected=false`, `sandbox_merchant=false`, seller type `unknown`, and no persisted merchant/client credential fields. This is a read-only state check; no option was changed.
- Container runtime scan found no PHP Fatal error, PHP Parse error, Uncaught Error, memory exhaustion, execution-timeout, or segmentation fault in the bounded log window. No worker/runtime crash explains the direct-connect failure.

ROOT_CAUSE_CANDIDATE=PPCP_4_1_3_MANUAL_CONNECT_PAYEE_PROBE_FAILURE_AFTER_VALID_SANDBOX_OAUTH
PPCP_MANUAL_CONNECT_REST_HTTP=200
PPCP_MANUAL_CONNECT_REST_SUCCESS=false
PPCP_MANUAL_CONNECT_UPSTREAM_ERROR=NOT_EXPOSED_BY_PPCP_LOG_WRAPPER
PPCP_MERCHANT_CONNECTED=NO
PPCP_SANDBOX_MODE=YES
PPCP_ONBOARDING_COMPLETED=NO
BOUNDED_MANUAL_CONNECT_RETRY=NOT_EXECUTED_EXISTING_EVIDENCE_SUFFICIENT

DIAGNOSTIC_PACKET
GATE=K3R8C_PHASE_C_PPCP_MANUAL_CONNECT_ISOLATION
ENVIRONMENT=active Docker/MariaDB WordPress runtime at localhost:8093; WordPress 6.8.2; WooCommerce 10.0.4; PPCP 4.1.3
TRIGGER=Owner OAuth helper returned HTTP 200 with token, while the existing PPCP Sandbox manual-connect attempt remained disconnected
REPRODUCTION=Existing PPCP direct-connect attempt with Sandbox mode enabled reached /wc/v3/wc_paypal/authenticate/direct and failed in the payee-retrieval stage; Executor did not repeat the request
OBSERVED=Container OAuth token issuance PASS; PPCP log says Failed to retrieve payee details; REST access HTTP 200; UI success=false generic error; common state isConnected=false; onboarding incomplete
CONTROL_OR_BASELINE=Authenticated read-only REST GETs for common/settings/payment/features returned HTTP 200; containers running; no PHP fatal/runtime crash; plugin active at unchanged version
HYPOTHESES_RULED_OUT=Sandbox credential-pair invalidity and container OAuth reachability failure for this run; version drift; PHP fatal; Live mode; real payment; public callback/VPS issue
HYPOTHESES_REMAINING=PPCP 4.1.3 direct manual-connect payee probe incompatibility or a PayPal Sandbox capability response hidden by the plugin's generic exception wrapper
ARTIFACTS=redacted PPCP WooCommerce log; container access-log lines; source references in modules/ppcp-settings/src/Endpoint/AuthenticationRestEndpoint.php and Service/AuthenticationManager.php; browser Console/UI evidence; redacted REST state
SECRETS_REDACTED=YES
NEXT_DISCRIMINATING_TEST=Reviewer should decide whether to accept the confirmed manual-connect defect boundary or authorize a separately scoped provider-capability test; no automatic retry was performed
STOP_REASON=The existing evidence is sufficient for the K3R8C return and no further credential entry is authorized in this phase

RETURN_K3R8C_PPCP_MANUAL_CONNECT_DEFECT_CONFIRMED
REAL_PAYMENT_ACTIONS=0
PAYPAL_LIVE_ENABLED=NO
PPCP_VERSION_CHANGED=NO
WOOCOMMERCE_VERSION_CHANGED=NO
WORDPRESS_VERSION_CHANGED=NO
PPCP_SOURCE_PATCHED=NO
VPS_WRITES=ZERO
STOP_AT_REVIEWER=YES

## K3R8E Payee-probe parity helper readiness (2026-09-21)

- Scope: active local Docker/MariaDB runtime only: `C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery`, WordPress at `http://localhost:8093/`. No PPCP, WooCommerce, WordPress, version, source, Live, payment, database, VPS, tunnel, or credential configuration was changed.
- This is the Reviewer-approved provider-parity test for the confirmed boundary `K3R8C_PPCP_MANUAL_CONNECT_PAYEE_PROBE_FAILURE_CONFIRMED`. It is not a PPCP defect verdict.
- A local-only wrapper and PHP helper were prepared under the active runtime `.artifacts` directory. They are not committed to GitHub. The PHP helper performs, only after Owner input, Sandbox OAuth, the specified USD 1.00 `CAPTURE` order-create request, and an order GET; it never captures. It emits only the seven K3R8E redacted fields.
- Owner input path: the wrapper prompts Client ID and hidden Secret locally, then sends transient bytes only through `docker exec -i` STDIN to the active WordPress container. No credential is placed in command arguments, environment variables, files, logs, GitHub, or shell history. The helper never emits response bodies, token, order ID, payee values, headers, or debug IDs.
- Local artifact readiness: `.artifacts/k3r8e-payee-probe.ps1` — 5,237 bytes — SHA-256 `4CD2143F2C4C5B08E4AB950D32ADA8849131229BA71F3E39DC50A6BBAABD8E8E`; `.artifacts/k3r8e-payee-probe.php` — 6,911 bytes — SHA-256 `7E9615E20242A9816C10B3215020995C37C9270713C04C31E8E608026CCC9676`. These are local metadata only; no credential values are present.
- Validation: PowerShell parser completed with zero errors; PHP lint completed with `No syntax errors detected`; two no-secret end-to-end runs used the same source-existence → `docker cp` → remote helper execution → cleanup path. Both returned `NO_SECRET_DRY_RUN=PASS` and `EXPECTED_PRE_AUTH_STAGE=CONTAINER_HELPER_EXECUTED_INPUT_VALIDATION`; neither made a PayPal request. The remote `/tmp/k3r8e-payee-probe.php` was absent after each run, while both local source files remained present.
- No real Client ID or Secret was read by Executor. No OAuth, order creation, order GET, or capture was executed by Executor. Existing Owner OAuth PASS evidence was not reused as a substitute for this newly authorized parity sequence.

DIAGNOSTIC_PACKET
GATE=K3R8E_PAYEE_PROBE_PARITY_TEST
ENVIRONMENT=active Docker/MariaDB WordPress runtime at localhost:8093; container mini-craft-k3r4-recovery-wordpress
TRIGGER=Reviewer accepted OAuth PASS plus PPCP request_payee payee-probe failure, but did not accept a PPCP root-cause verdict
REPRODUCTION=Owner must run the readiness-verified local wrapper; it stages the PHP helper into the active container, sends interactive credentials only via STDIN, performs OAuth → order create → order GET, emits seven redacted fields, and removes the remote helper in finally
OBSERVED=Source artifacts present; PowerShell parse 0; PHP lint 0; two no-secret staging/execution/cleanup dry-runs PASS; no network request or credential access by Executor
CONTROL_OR_BASELINE=Active WordPress container running; remote helper absent after cleanup; local source helpers retained; PPCP/WooCommerce/WordPress state unchanged
HYPOTHESES_RULED_OUT=Helper artifact absence, PHP syntax failure, PowerShell syntax failure, and staging/cleanup failure
HYPOTHESES_REMAINING=Provider Sandbox OAuth/order-create/order-GET/payee response capability versus PPCP 4.1.3 request_payee client-path behavior
ARTIFACTS=local-only active runtime .artifacts/k3r8e-payee-probe.ps1 and .artifacts/k3r8e-payee-probe.php; no secret-bearing GitHub artifact; remote /tmp helper is ephemeral and cleaned
SECRETS_REDACTED=YES
NEXT_DISCRIMINATING_TEST=Owner runs the command below and returns only OAUTH_HTTP, ORDER_CREATE_HTTP, ORDER_GET_HTTP, PAYEE_OBJECT_PRESENT, PAYEE_MERCHANT_ID_PRESENT, PAYEE_EMAIL_PRESENT, and ERROR_CLASS
STOP_REASON=Owner-only Sandbox Client ID and hidden Secret input is required for the real parity request

OWNER_CHECKPOINT_READINESS
COMMAND=powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery\.artifacts\k3r8e-payee-probe.ps1"
LOCAL_ARTIFACTS_PRESENT=PASS
CONTAINER_STAGING_PATH=PASS
POST_CLEANUP_EXISTENCE_CHECK=PASS
NO_SECRET_DRY_RUN=PASS
EXPECTED_PRE_AUTH_STAGE=CONTAINER_HELPER_EXECUTED_INPUT_VALIDATION
CLEANUP_AFTER_OWNER_RUN=Wrapper removes only the ephemeral /tmp/k3r8e-payee-probe.php; local source helpers remain in active runtime .artifacts

K3R8E_RESULT=RETURN_OWNER_K3R8E_PAYEE_PROBE_REQUIRED
REAL_PAYMENT_ACTIONS=0
PAYPAL_CAPTURE_ACTIONS=0
PAYPAL_LIVE_ENABLED=NO
PPCP_VERSION_CHANGED=NO
WOOCOMMERCE_VERSION_CHANGED=NO
WORDPRESS_VERSION_CHANGED=NO
PPCP_SOURCE_PATCHED=NO
VPS_WRITES=ZERO
STOP_AT_OWNER_CHECKPOINT=YES
STOP_AT_REVIEWER=YES

## K3R9 PPCP minimal environment isolation — Owner checkpoint (2026-09-21)

- Gate: `K3R9_PPCP_MINIMAL_ENV_ISOLATION`
- Active runtime: `C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery`; URL `http://localhost:8093/`; containers `mini-craft-k3r4-recovery-wordpress` and `mini-craft-k3r4-recovery-mariadb`.
- Scope remained local and reversible. No WordPress/WooCommerce/PPCP version change, source patch, theme replacement, PayPal authorization, Live mode, payment/capture, tunnel, VPS, database migration, or Owner Secret access occurred.

### Rollback point

- Local-only rollback directory: `C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery\.artifacts\k3r9-preflight-20260921-211040`
- MariaDB single-transaction dump: 3,042,772 bytes; SHA-256 `7BB4F752418338A13AE21299A7D45C5A7C41AB887C83CEF608ABC27F75042DCE`; `mariadb-check` returned success.
- Full `wp-content` archive: 65,980,519 bytes; SHA-256 `9699EBC39D2467E72BD03718231631D3EA479CAB3D2589BD6DEB87E7158FD364`.
- Local `wp-config.php` copy: 5,922 bytes; SHA-256 `496A407429FF680EE5321B812182ECA68BBDE7FB629545441917F60091AC231C`; contents were not read into Evidence.
- Pre-isolation active-plugin inventory was saved locally as non-secret metadata. The rollback point is retained; no restore was needed before the Owner checkpoint.

### Plugin isolation

Pre-isolation active plugins:

- Kadence Blocks `3.7.11`
- Kadence Starter Templates `2.3.4`
- WooCommerce `10.0.4`
- WooCommerce PayPal Payments `4.1.3`

Authorized reversible action:

- Temporarily deactivated only Kadence Blocks and Kadence Starter Templates.
- WooCommerce `10.0.4` and WooCommerce PayPal Payments `4.1.3` remain active.
- Post-isolation active plugin inventory contains exactly those two required plugins.
- Theme remained Kadence `1.5.2`; WordPress remained `6.8.2`; no plugin files or settings were deleted.

### Cache/transient isolation

- No `object-cache.php` or `advanced-cache.php` drop-in was present.
- Cleared only WooCommerce/PPCP transient prefixes through WordPress APIs; 40 pre-existing matching transient entries were removed during the first cleanup.
- The authenticated page probe regenerated 4 ordinary WooCommerce/PPCP cache entries as part of normal bootstrap. A final allowlisted cleanup removed 16 matching entries and reported `FINAL_REMAINING_MATCHING_COUNT=0`.
- No unrelated options, business data, orders, credentials, or provider configuration were changed.

### Direct settings and runtime verification

- A one-time PHP probe ran inside the active WordPress container using an in-memory existing local `admin` session cookie. The cookie and page bodies were not output or persisted; the probe source and remote copy were removed after use.
- Direct PayPal Settings page: HTTP `200`; authenticated admin marker `YES`; `#ppcp-settings-container` count `1`; `ppcp-settings-js-index.js` marker `YES`.
- Generic Payments overview: HTTP `200`; authenticated admin marker `YES`; expected overview container count `0`; PPCP settings script marker `YES`.
- Probe PHP lint: `No syntax errors detected`; local and remote one-time helpers were removed after validation.
- Final public smoke: `/` returned HTTP `200` in 3/3 requests at approximately `0.36–0.45s`; `/wp-json/` returned HTTP `200` in 3/3 at approximately `0.22–0.37s`; unauthenticated `/wp-admin/` returned expected HTTP `302` in 3/3.
- WordPress container remained running with restart count `0`; MariaDB remained `healthy` with restart count `0`. Resource sample: WordPress `0.01%` CPU, MariaDB `5.32%` CPU.

### Owner boundary

The minimal environment is prepared for exactly one Owner-run Sandbox Manual Connect retry. Executor did not click Connect/Manually Connect and did not enter, obtain, or request Client ID/Secret. Prior plugin activation state must be restored exactly after the Owner result, as required by the Reviewer decision; no automatic reconnect or next Gate is authorized.

```text
K3R9_GATE=K3R9_PPCP_MINIMAL_ENV_ISOLATION
ROLLBACK_READY=PASS
ACTIVE_PLUGINS_BEFORE=KADENCE_BLOCKS_3.7.11,KADENCE_STARTER_TEMPLATES_2.3.4,WOOCOMMERCE_10.0.4,PPCP_4.1.3
ACTIVE_PLUGINS_AFTER=WOOCOMMERCE_10.0.4,PPCP_4.1.3
PLUGIN_ISOLATION=PASS
ALLOWLIST_TRANSIENT_CLEANUP=PASS
DIRECT_PAYPAL_SETTINGS_HTTP=200
DIRECT_PAYPAL_SETTINGS_AUTH=PASS
PPCP_SETTINGS_CONTAINER_COUNT=1
PPCP_SETTINGS_SCRIPT=LOADED
MINIMAL_ENV_RUNTIME=PASS
OWNER_MANUAL_CONNECT=NOT_RUN_OWNER_CHECKPOINT
PAYPAL_AUTH_ACTIONS=0
REAL_PAYMENT_ACTIONS=0
PAYPAL_LIVE_ENABLED=NO
PPCP_VERSION_CHANGED=NO
WOOCOMMERCE_VERSION_CHANGED=NO
WORDPRESS_VERSION_CHANGED=NO
PPCP_SOURCE_PATCHED=NO
THEME_CHANGED=NO
VPS_WRITES=ZERO
SECRET_EXPOSURE=NO
UNRELATED_PROJECTS_TOUCHED=NO
RESTORE_PRIOR_PLUGIN_STATE=DEFERRED_UNTIL_OWNER_RESULT
PASS_CANDIDATE_K3R9_PPCP_MINIMAL_ENV_PREP
STOP_AT_OWNER_CHECKPOINT=YES
STOP_AT_REVIEWER=YES
```
