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

## K4 UI Conversion Trust Finalize — Executor candidate (2026-09-22)

The latest Reviewer-confirmed business facts were applied once across Product, FAQ, Shipping & Returns, and Contact. No unconfirmed kit contents, fixed completion time, fixed delivery promise, support email, phone number, personal/home address, certification, review, sales claim, or supplier promise was added. The final domain mailbox and operational return address remain intentionally unpublished and editable later.

```text
GATE=K4_UI_CONVERSION_TRUST_FINALIZE
K4_ROLLBACK_POINT=PASS
ROLLBACK_BACKUP_LOCAL_ONLY=.artifacts/k4-finalize-preflight-20260922-025529
OWNER_FACTS_APPLIED=PASS
INITIAL_MARKET=UNITED_STATES
SHIPPING_METHOD=TRACKED_STANDARD_SHIPPING
SHIPPING_COST=DISPLAY_AT_CHECKOUT
FIXED_DELIVERY_PROMISE=NO_UNTIL_VERIFIED
RETURN_WINDOW=14_DAYS_AFTER_DELIVERY
NON_DEFECT_RETURN_CONDITION=UNUSED_UNASSEMBLED_ORIGINAL_PACKAGING
NON_DEFECT_RETURN_SHIPPING=BUYER_PAID
MISSING_DAMAGED_REPORT_WINDOW=7_DAYS
MISSING_DAMAGED_PRIMARY_REMEDY=REPLACEMENT_FIRST
PUBLIC_SUPPORT_CHANNEL=CONTACT_FORM
DOMAIN_SUPPORT_EMAIL=PENDING_FINAL_DOMAIN_MAILBOX
PUBLIC_RETURN_ADDRESS=NOT_PUBLISHED_PENDING_OPERATIONAL_ADDRESS
BUSINESS_RULES_FUTURE_EDITABLE=YES
```

### Final content and native editing

```text
PRODUCT_FINAL_CONTENT=PASS
FAQ_FINAL_CONTENT=PASS
SHIPPING_RETURNS_FINAL_CONTENT=PASS
CONTACT_FINAL_CONTENT=PASS
CONTACT_FORM=KADENCE_NATIVE_FORM
CONTACT_FORM_FIELDS=NAME_EMAIL_MESSAGE
CONTACT_FORM_DESTINATION=WORDPRESS_ADMIN_FALLBACK_UNEXPOSED
CONTACT_FORM_RENDERED=PASS
CONTACT_FORM_SUBMIT_ACTION=NOT_EXECUTED
UNVERIFIED_SUPPLIER_CONTENT=NOT_ADDED
PUBLIC_SUPPORT_EMAIL_INVENTED=NO
PUBLIC_HOME_ADDRESS_PUBLISHED=NO
OWNER_EDITABILITY=PASS
```

The Contact page initially exposed a real implementation issue: WordPress save filtering stripped the native form markup when the content was written through the ordinary helper. A bounded local repair used the existing Kadence Form block, temporarily removed only the content-save KSES filter for that write, restored the filter immediately, and removed the host/container helper. The final page has one native form with Name, Email, Message, and Send message controls; no message was submitted.

### Runtime, navigation, Gutenberg, and WooCommerce verification

```text
LOCAL_HOME_URL=http://localhost:8093/
WORDPRESS_HOME=200
WORDPRESS_WP_ADMIN_AUTHENTICATED=PASS
WP_ADMIN_HTTP_WITHOUT_COOKIE=302_EXPECTED
WPJSON_HTTP=200
HOME_HTTP=200
PRODUCT_HTTP=200
FAQ_HTTP=200
SHIPPING_RETURNS_HTTP=200
CONTACT_HTTP=200
CART_HTTP=200
CHECKOUT_HTTP=302_EMPTY_CART_EXPECTED
CONTACT_FORM_DOM=PASS
NAVIGATION_LINKS=PASS
WOOCommerce_HOME_UI=PASS
WOOCommerce_PAYMENTS_UI=PASS
DIRECT_PAYPAL_SETTINGS_UI=PASS
PPCP_CONNECTION_STATE=CONNECTED_SANDBOX_REDACTED
WOOCommerce_ORDER_STATE_UNCHANGED=PASS
EXISTING_SANDBOX_ORDER=PROCESSING_PAID
K4_NEW_ORDER_ACTIONS=0
```

The page content parses as native Gutenberg blocks, including `kadence/form`; there is no invalid-block marker, and server-side `do_blocks` plus browser rendering both produce the form. The existing K1B editor and responsive baseline remains intact; the new content added no CSS or layout-system rebuild.

```text
GUTENBERG_VALIDITY=PASS
INVALID_BLOCK_COUNT=0
HOME_EDITOR=PASS
PRODUCT_EDITOR=PASS
FAQ_EDITOR=PASS
SHIPPING_RETURNS_EDITOR=PASS
CONTACT_EDITOR=PASS
RESPONSIVE=PASS
K4_RESPONSIVE_SCREENSHOT_COUNT=18
K4_RESPONSIVE_WIDTHS=375,430,768,1024,1366,1440,1920,2048,2560
KADENCE_LAYOUT_REBUILD=NO
CUSTOM_CSS_ADDED=NO
WOOCOMMERCE_BEHAVIOR=PASS
CANONICAL_COMMERCE_SYSTEM=WOOCOMMERCE
```

Runtime remained healthy after the final write: the WordPress container is running, MariaDB is healthy, no recent PHP fatal/parse/timeout log match was found, and no version or payment configuration changed.

```text
DOCKER_RUNTIME=PASS
MARIADB_HEALTH=PASS
RUNTIME_FATAL_LOG_MATCHES=0
PAYPAL_RECONNECT_ACTIONS=0
PPCP_VERSION_CHANGED=NO
WOOCOMMERCE_VERSION_CHANGED=NO
WORDPRESS_VERSION_CHANGED=NO
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
SECRET_VALUES_OUTPUT=NO
```

### K4 candidate result and Reviewer sequence

```text
UI_MODIFICATION=PASS
HOME_CONVERSION_TRUST=PASS
PRODUCT_CONVERSION_TRUST=PASS
FAQ=PASS
SHIPPING_RETURNS=PASS
CONTACT=PASS
BUSINESS_TRUTH=PASS
OWNER_EDITABILITY=PASS
RESPONSIVE=PASS
GUTENBERG_VALIDITY=PASS
WOOCOMMERCE_BEHAVIOR=PASS
PASS_CANDIDATE_K4_UI_CONVERSION_TRUST_FINAL
OWNER_K4_UI_EDIT_WINDOW=REQUIRED_BEFORE_FORMAL_CLOSE
K4_FORMAL_CLOSE=DEFERRED_UNTIL_OWNER_UI_EDIT
STOP_AT_REVIEWER=YES
```

## K3R11 Public Origin Rebind Prep — Owner Manual Connect checkpoint (2026-09-22)

### Official Disconnect and redacted post-state

The single authorized official WooCommerce PayPal Payments Disconnect was executed from the authenticated local Settings UI. No reconnect was attempted and no credential value was read or output.

```text
OFFICIAL_DISCONNECT=EXECUTED_ONCE
PPCP_MERCHANT_CONNECTED=NO
PPCP_SANDBOX_MODE=YES
PPCP_ONBOARDING_COMPLETED=NO
CLIENT_ID_BINDING_PRESENT=NO
CLIENT_SECRET_BINDING_PRESENT=NO
MERCHANT_ID_BINDING_PRESENT=NO
MERCHANT_EMAIL_BINDING_PRESENT=NO
```

The post-disconnect read-only helper was copied into the WordPress container, executed, and removed from both container and host. The active runtime remained healthy: WordPress container running, MariaDB healthy, local home HTTP `200`, and local admin unauthenticated redirect `302`.

### Temporary HTTPS origin and reversible URL rebind

An accountless Cloudflare Quick Tunnel was started with the preinstalled local `cloudflared` binary; no Cloudflare login, token, account authorization, VPS, or production domain was used.

```text
PUBLIC_HTTPS_ORIGIN=https://email-rich-barbie-merchants.trycloudflare.com
ORIGIN_TARGET=http://localhost:8093
ORIGINAL_HOME_URL=http://localhost:8093
ORIGINAL_SITE_URL=http://localhost:8093
REBIND_HOME_URL=https://email-rich-barbie-merchants.trycloudflare.com
REBIND_SITE_URL=https://email-rich-barbie-merchants.trycloudflare.com
```

The exact rollback is to restore both WordPress options `home` and `siteurl` to `http://localhost:8093`, then stop the Quick Tunnel process. The verified pre-K3R11 rollback point remains available locally at `mini-craft-k3r4-mariadb-recovery/.artifacts/k3r11-preflight-20260921-231206`.

### Public-origin smoke tests

```text
PUBLIC_HOME_HTTP=200
PUBLIC_WPJSON_HTTP=200
PUBLIC_WP_ADMIN_DIRECT_HTTP=302
PUBLIC_WP_ADMIN_FINAL_HTTP=200_LOGIN_PAGE
PUBLIC_DIRECT_PAYPAL_SETTINGS_DIRECT_HTTP=302
PUBLIC_DIRECT_PAYPAL_SETTINGS_FINAL_HTTP=200_LOGIN_PAGE
LOCAL_HOME_AFTER_REBIND_HTTP=200
DOCKER_WORDPRESS=RUNNING
DOCKER_MARIADB=RUNNING_HEALTHY
```

The `302` responses are the expected unauthenticated redirects; the browser reached the public WordPress login page for both wp-admin and the direct PayPal Settings URL. No Owner credentials were entered by Executor.

During the first URL-rebind smoke test, WordPress created a temporary `.maintenance` marker and returned 503. Container logs showed no plugin/update fatal. The marker was copied only to a container `/tmp` path, removed as a stale WordPress maintenance artifact, and the runtime immediately returned to the statuses above. The temporary `/tmp` copy and all PHP helpers were removed.

```text
K3R11_GATE=K3R11_PUBLIC_ORIGIN_REBIND_PREP
ROLLBACK_POINT_VERIFIED=PASS
OFFICIAL_DISCONNECT=PASS_ONCE
OLD_CREDENTIAL_BINDING_CLEARED=PASS
PUBLIC_HTTPS_ORIGIN=PASS
WORDPRESS_URL_REBIND=PASS_REVERSIBLE
PUBLIC_FRONTEND=PASS
PUBLIC_WP_ADMIN=PASS_AUTH_REDIRECT
PUBLIC_DIRECT_PAYPAL_SETTINGS=PASS_AUTH_REDIRECT
RUNTIME_HEALTH=PASS
PPCP_VERSION_CHANGED=NO
WOOCOMMERCE_VERSION_CHANGED=NO
WORDPRESS_VERSION_CHANGED=NO
PAYPAL_LIVE_ENABLED=NO
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
SECRET_VALUES_OUTPUT=NO
OWNER_MANUAL_CONNECT=NOT_EXECUTED
STOP_AT_OWNER_CHECKPOINT=YES
PASS_CANDIDATE_K3R11_PUBLIC_ORIGIN_REBIND_PREP_READY
```

## K3R11 Public Origin Rebind Prep — pre-action checkpoint (2026-09-21)

The existing local rollback point was re-verified before the bounded official Disconnect action:

- Rollback directory: local-only `mini-craft-k3r4-mariadb-recovery/.artifacts/k3r11-preflight-20260921-231206`
- `database.sql`: present; size `5,853,278`; SHA-256 matched the previously recorded local baseline.
- `wp-content.tar.gz`: present; size `65,991,284`; SHA-256 matched the previously recorded local baseline.
- `wp-config.php`: present; size `5,922`; SHA-256 matched the previously recorded local baseline.
- WordPress container: running.
- MariaDB container: running/healthy.
- Local home URL smoke test: `http://localhost:8093/` returned HTTP `200`.
- Previously recorded original `home_url` and `siteurl`: `http://localhost:8093`.

The official WooCommerce PayPal Payments Settings page was opened in the authenticated local browser and the `Disconnect` control was located. No click was performed, no reconnect was performed, and no credential value was read or output. The required action-time confirmation is pending before the single authorized Disconnect.

```text
K3R11_GATE=K3R11_PUBLIC_ORIGIN_REBIND_PREP
ROLLBACK_POINT_VERIFIED=PASS
CURRENT_LOCAL_HOME_URL=http://localhost:8093
CURRENT_LOCAL_SITE_URL=http://localhost:8093
DOCKER_WORDPRESS=RUNNING
DOCKER_MARIADB=RUNNING_HEALTHY
LOCAL_HOME_HTTP=200
OFFICIAL_DISCONNECT_CONTROL=LOCATED
DISCONNECT_ACTION=NOT_EXECUTED
OWNER_ACTION_TIME_CONFIRMATION=REQUIRED
OLD_SANDBOX_SECRET_REUSE=FORBIDDEN
SECRET_VALUES_OUTPUT=NO
PUBLIC_HTTPS_ORIGIN=NOT_CREATED
WORDPRESS_URL_REBIND=NOT_EXECUTED
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
STOP_AT_OWNER_CHECKPOINT=YES
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

## K3R9 Post-result restore and read-only verification (2026-09-21)

- Gate: `K3R9_POST_RESULT_RESTORE_AND_VERIFY`
- Owner's single authorized minimal-environment attempt was accepted by Reviewer as `K3R9_OWNER_MANUAL_CONNECT_UI=SUCCESS` with visible `Connected to PayPal`. Executor did not re-enter credentials, reconnect, or inspect any credential value.
- The K3R9 rollback directory and pre-isolation manifest remained present locally. No restore-from-backup was needed; only the two temporarily deactivated plugins were reactivated.

### Exact plugin-state restoration

- Kadence Blocks `3.7.11`: restored to active.
- Kadence Starter Templates `2.3.4`: restored to active.
- WooCommerce `10.0.4`: remained active.
- WooCommerce PayPal Payments `4.1.3`: remained active.
- Akismet `5.4` and Hello Dolly `1.7.2`: remained inactive.
- Post-restore active-plugin inventory exactly matched the saved pre-isolation manifest. No plugin/version/theme files or settings were deleted or changed.

### Read-only PPCP connection state after restoration

An in-container authenticated read-only probe used the existing local administrator session only in memory and emitted only redacted booleans/statuses. It did not perform a reconnect or write provider state.

- `/wc/v3/wc_paypal/common`: HTTP `200`; `merchant.isConnected=YES`; `merchant.isSandbox=YES`; `useSandbox=YES`.
- `/wc/v3/wc_paypal/onboarding`: HTTP `200`; `completed=YES`.
- `/wc/v3/wc_paypal/settings`: HTTP `200`.
- `/wc/v3/wc_paypal/payment`: HTTP `200`.
- `/wc/v3/wc_paypal/features`: HTTP `200`.
- Direct PayPal Settings page: HTTP `200`; authenticated admin marker `YES`; exactly one `#ppcp-settings-container`; PPCP settings script marker present.
- Payments overview: HTTP `200`; its zero PPCP container count is the previously known overview-only mount boundary, while the direct PayPal route remained healthy. No new direct-page connection failure was observed.

### WordPress/WooCommerce/runtime regression check

- WordPress container: running; restart count `0`.
- MariaDB container: running; health `healthy`; restart count `0`.
- `/`: HTTP `200`.
- `/wp-json/`: HTTP `200`.
- Product `/product/mini-craft-night-kit/`: HTTP `200`.
- Cart `/cart/`: HTTP `200`.
- Empty-cart Checkout `/checkout/`: HTTP `302`, expected WooCommerce behavior.
- Store API products: HTTP `200`.
- Store API cart: HTTP `200`.
- Unauthenticated `/wp-admin/`: HTTP `302`, expected login redirect.
- Recent container log scan: PHP fatal/parse/timeout marker count `0`; PPCP connection-error marker count `0`.
- Resource sample: WordPress `0.01%` CPU; MariaDB `0.04%` CPU.
- One-time read-only helper was removed from both local `.artifacts` and the container `/tmp`; no secret-bearing artifact was retained.

```text
K3R9_GATE=K3R9_POST_RESULT_RESTORE_AND_VERIFY
K3R9_OWNER_MANUAL_CONNECT_UI=SUCCESS
PLUGIN_STATE_RESTORED=PASS
PRE_ISOLATION_ACTIVE_PLUGIN_STATE_MATCH=PASS
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_MODE=YES
PPCP_SANDBOX_CONNECTED=YES
PPCP_ONBOARDING_COMPLETED=YES
PPCP_REST_STATE=PASS
DIRECT_PAYPAL_SETTINGS_AFTER_RESTORE=PASS
DIRECT_PPCP_CONTAINER_COUNT=1
WORDPRESS_RUNTIME_AFTER_RESTORE=PASS
WOOCOMMERCE_RUNTIME_AFTER_RESTORE=PASS
PPCP_CONNECTION_ERROR_AFTER_RESTORE=NOT_OBSERVED
OVERVIEW_REACT_MOUNT_BOUNDARY=KNOWN_PRIOR_STATE
PAYPAL_RECONNECT_ACTIONS=0
CREDENTIALS_READ_OR_ENTERED_BY_EXECUTOR=NO
REAL_PAYMENT_ACTIONS=0
PAYPAL_LIVE_ENABLED=NO
PPCP_VERSION_CHANGED=NO
WOOCOMMERCE_VERSION_CHANGED=NO
WORDPRESS_VERSION_CHANGED=NO
PPCP_SOURCE_PATCHED=NO
VPS_WRITES=ZERO
SECRET_EXPOSURE=NO
UNRELATED_PROJECTS_TOUCHED=NO
PASS_CANDIDATE_K3R9_POST_RESTORE_VERIFY
STOP_AT_REVIEWER=YES
```

## K3R10 Sandbox checkout/capture — callback boundary return (2026-09-21)

- Gate: `K3R10_PAYPAL_SANDBOX_CHECKOUT_CAPTURE`
- Active runtime: Docker/MariaDB WordPress at `http://localhost:8093/`; WordPress 6.8.2; WooCommerce 10.0.4; WooCommerce PayPal Payments 4.1.3. All remained unchanged.
- Sandbox connection was available before checkout: PayPal was present as a Checkout method and selected by default. No reconnect or credential entry was performed.

### Test-only checkout preflight

- Product: `Mini Craft Night Kit`.
- SKU: `MCK-LOCAL-TEST-001`.
- Quantity: `1`.
- Displayed price/total: `¥1`.
- Product page reported local stock available (`9` before cart add).
- Shipping method was explicitly labeled `Local test shipping — no fulfillment promise`.
- Checkout also exposed the separate `Local test only — no payment` method. Synthetic local test billing values were used only to render the checkout form; no real customer data was used.
- The item was added to the browser-local cart only. No WooCommerce order was created.

### Checkout result

- Checkout PayPal method: visible and selected.
- PPCP SDK v6 loaded, but client-token generation failed in the browser; the PayPal approval button did not render and the legacy `Proceed to PayPal` control remained hidden.
- Browser console contained only the redacted PPCP category `Failed to generate client token`; no token, cookie, header, buyer credential, or response body was recorded.
- Buyer login/approval was not reached.
- `ORDER_CREATED=NO`.
- `PAYPAL_CAPTURE_ACTIONS=0`.
- `REFUND_ACTIONS=0`.

### Callback/webhook boundary

- Existing PPCP log evidence shows the Sandbox merchant connection had succeeded and Sandbox OAuth returned HTTP 200 before this checkout attempt.
- PPCP attempted to register the provider callback at `https://localhost:8093/wp-json/paypal/v1/incoming`.
- PayPal rejected that webhook registration because the URL was not a valid publicly reachable webhook URL; PPCP recorded webhook subscription failure.
- This is the Gate-defined public-callback boundary. No tunnel, VPS route, Cloudflare route, public domain, or callback workaround was created.

### Runtime and safety

- WordPress container: running; restart count `0`.
- MariaDB container: running; health `healthy`; restart count `0`.
- Store API products/cart remained HTTP `200` through direct no-proxy local probes.
- `PPCP_VERSION_CHANGED=NO`.
- `WOOCOMMERCE_VERSION_CHANGED=NO`.
- `WORDPRESS_VERSION_CHANGED=NO`.
- `PAYPAL_LIVE_ENABLED=NO`.
- `REAL_PAYMENT_ACTIONS=0`.
- `VPS_WRITES=ZERO`.
- `PUBLIC_TUNNEL_CREATED=NO`.
- `SECRET_VALUES_COMMITTED=NO`.
- `SECRET_VALUES_WRITTEN_TO_EVIDENCE=NO`.
- `DIAGNOSTIC_SECRET_OUTPUT_INCIDENT=REVIEW_REQUIRED`: a pre-existing PPCP log line containing credential fields was inadvertently included in a bounded diagnostic tool output; no value is reproduced here, retained in project files, or committed to GitHub. Reviewer/Owner should treat the affected Sandbox credential pair as requiring containment/rotation before any future use.

```text
K3R10_GATE=K3R10_PAYPAL_SANDBOX_CHECKOUT_CAPTURE
PAYPAL_CHECKOUT_METHOD_VISIBLE=YES
PAYPAL_CHECKOUT_BUTTON_RENDERED=NO
PPCP_CLIENT_TOKEN=FAIL
BUYER_APPROVAL_REACHED=NO
ORDER_CREATED=NO
PAYPAL_CAPTURE_ACTIONS=0
WOO_ORDER_PROVIDER_CORRELATION=NOT_APPLICABLE
WOO_ORDER_PAID_PROCESSING=NOT_APPLICABLE
PHYSICAL_FULFILLMENT_AUTO_COMPLETED=NOT_APPLICABLE
WEBHOOK_REGISTER=FAIL_INVALID_PUBLIC_URL
PUBLIC_CALLBACK_REQUIRED=YES
RETURN_K3_PUBLIC_CALLBACK_REQUIRED
STOP_AT_REVIEWER=YES
```

## K3R11 Public Sandbox Origin — Owner reconnect checkpoint (2026-09-21)

- Gate: `K3R11_PUBLIC_SANDBOX_ORIGIN`.
- Owner security precondition was confirmed: `SANDBOX_SECRET_ROTATED=YES`; the replacement Secret was not requested, read, recorded, or output by Executor.
- Rollback point created before any K3R11 mutation under local project path `.artifacts/k3r11-preflight-20260921-231206`.
- Rollback contents and SHA-256 metadata:
  - `database.sql`: 5,853,278 bytes; SHA-256 `DF1C782C784BB4C3EA3C91D4F7E576B5260E3CD4100A5C95DDEA7D920232D285`.
  - `wp-content.tar.gz`: 65,991,284 bytes; SHA-256 `9B68A54974B04D0F95A5C1C3574666E9FAD8B681EDCBC2404AB942F9C6932C0B`.
  - `wp-config.php`: 5,922 bytes; SHA-256 `496A407429FF680EE5321B812182ECA68BBDE7FB629545441917F60091AC231C`.
  - Backup is local-only and was not committed to GitHub.

### Preflight baseline

- WordPress `home_url`: `http://localhost:8093/`.
- WordPress `siteurl`: `http://localhost:8093/`.
- WordPress container: running; restart count `0`.
- MariaDB container: running; health `healthy`; restart count `0`.
- No WordPress URL, Docker, PPCP, WooCommerce, theme, plugin, or database mutation was made.

### Secret-rotation connection check

The in-container read-only probe emitted only statuses and booleans, then was removed locally and from the container.

- `/wc/v3/wc_paypal/common`: HTTP `200`.
- `PPCP_MERCHANT_CONNECTED=NO` after the Owner's Sandbox Secret rotation.
- `PPCP_SANDBOX_MODE=YES`.
- `/wc/v3/wc_paypal/onboarding`: HTTP `200`; `PPCP_ONBOARDING_COMPLETED=YES`.
- `/wc/v3/wc_paypal/settings`: HTTP `200`.
- `/wc/v3/wc_paypal/payment`: HTTP `200`.
- `/wc/v3/wc_paypal/features`: HTTP `200`.
- `LOCAL_HELPER_REMOVED=PASS`; `REMOTE_HELPER_REMOVED=PASS`.

Because the stored PPCP connection is no longer valid after rotation, K3R11 stops before creating a public origin. Owner must reconnect once through the local WooCommerce PayPal Settings page using the already-rotated Sandbox Secret; the Secret must remain local and must not be sent to chat/GitHub.

```text
K3R11_GATE=K3R11_PUBLIC_SANDBOX_ORIGIN
ROLLBACK_READY=PASS
ORIGINAL_HOME_URL=http://localhost:8093/
ORIGINAL_SITE_URL=http://localhost:8093/
SANDBOX_SECRET_ROTATION_CONFIRMED=YES
PPCP_MERCHANT_CONNECTED=NO
PPCP_SANDBOX_MODE=YES
PPCP_ONBOARDING_COMPLETED=YES
PUBLIC_HTTPS_ORIGIN=NOT_CREATED_OWNER_RECONNECT_FIRST
PPCP_CLIENT_TOKEN=NOT_TESTED
PAYPAL_CHECKOUT_BUTTON_RENDERED=NOT_TESTED
WEBHOOK_REGISTER=NOT_TESTED
DIRECT_PAYPAL_SETTINGS=READ_ONLY_REST_HEALTHY
RUNTIME_HEALTH=PASS
PPCP_VERSION_CHANGED=NO
WOOCOMMERCE_VERSION_CHANGED=NO
WORDPRESS_VERSION_CHANGED=NO
PAYPAL_LIVE_ENABLED=NO
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
SECRET_EXPOSURE=NO_NEW_SECRET_ACCESSED
RETURN_OWNER_K3R11_SANDBOX_RECONNECT_REQUIRED
STOP_AT_OWNER_CHECKPOINT=YES
STOP_AT_REVIEWER=YES
```

## K3R11 Connection-state reconciliation — probe structure corrected (2026-09-21)

- Gate: `K3R11_CONNECTION_STATE_RECONCILIATION`.
- Owner's UI observation remains: Connection status, Disconnect, Business/Sandbox, and merchant metadata presentation are visible. No Disconnect action was executed.
- The prior `PPCP_REST_MERCHANT_CONNECTED=NO` was a read-only probe parsing error, not a confirmed PPCP state. PPCP `/wc/v3/wc_paypal/common` returns `merchant` at the top level; the prior helper incorrectly looked for `data.merchant`.
- A corrected in-container read-only probe used `common.merchant` and emitted only redacted statuses/presence metadata. It was linted, staged ephemerally, executed, and removed from both host and container.

### Corrected REST state

- `/wc/v3/wc_paypal/common`: HTTP `200`.
- Top-level `merchant` object: present.
- `merchant.isConnected=YES`.
- `merchant.isSandbox=YES`.
- Merchant ID, email, Client ID, and Client Secret fields: present only as boolean metadata; no values were read into evidence or output.
- `data.useSandbox=YES`; `data.useManualConnection=YES`.
- `/wc/v3/wc_paypal/onboarding`: HTTP `200`; `completed=YES`.
- `/wc/v3/wc_paypal/settings`: HTTP `200`.
- `/wc/v3/wc_paypal/payment`: HTTP `200`.
- `/wc/v3/wc_paypal/features`: HTTP `200`.

### Local option-state evidence

- Related option `woocommerce-ppcp-data-common`: present; metadata flags indicate merchant ID, merchant email, Client ID, Client Secret, `merchant_connected`, `sandbox_merchant`, `use_sandbox`, and `use_manual_connection` are present/enabled. Values were not output.
- Related option `woocommerce-ppcp-data-onboarding`: present; onboarding completed flag present/enabled. Values were not output.
- The Settings UI shows the connected presentation because local merchant metadata and connection flags are present; the corrected REST response agrees. The apparent mismatch was caused by the prior probe's wrong response path.
- Whether the externally rotated Secret is accepted by PayPal has not been tested in this Gate. Local presence is not a credential-validity verdict.

```text
K3R11_GATE=K3R11_CONNECTION_STATE_RECONCILIATION
PPCP_ADMIN_UI_CONNECTION_STATE=CONNECTED_PRESENTATION
PPCP_REST_MERCHANT_CONNECTED=YES
PPCP_STATE_MISMATCH=FALSE_PRIOR_PROBE_PATH_ERROR
PPCP_COMMON_RESPONSE_PATH=TOP_LEVEL_MERCHANT
PPCP_SANDBOX_MODE=YES
PPCP_ONBOARDING_COMPLETED=YES
PPCP_CONNECTION_METADATA_PRESENT=YES
PPCP_EXTERNAL_SECRET_VALIDITY=NOT_TESTED
DISCONNECT_ACTION=NOT_EXECUTED
RECONNECT_ACTION=NOT_EXECUTED
PUBLIC_HTTPS_ORIGIN=NOT_CREATED
PPCP_VERSION_CHANGED=NO
WOOCOMMERCE_VERSION_CHANGED=NO
WORDPRESS_VERSION_CHANGED=NO
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
SECRET_VALUES_OUTPUT=NO
LOCAL_HELPER_REMOVED=PASS
REMOTE_HELPER_REMOVED=PASS
PASS_CANDIDATE_K3R11_CONNECTION_STATE_RECONCILED
STOP_AT_REVIEWER=YES
```

## K3R11 Public Origin Readiness Verification (2026-09-22)

Owner supplied the sanitized public-origin UI result `Connected to PayPal`. The following checks were performed read-only or with bounded local Checkout rendering only. No buyer approval, order submission, capture, refund, Live activation, version change, source patch, VPS action, or production-domain action occurred.

### Public origin and connection state

```text
PUBLIC_HTTPS_ORIGIN=https://email-rich-barbie-merchants.trycloudflare.com
PUBLIC_ORIGIN_TARGET=http://localhost:8093
SANDBOX_MERCHANT_CONNECTED=PASS
PPCP_SANDBOX_MODE=PASS
PPCP_ONBOARDING_COMPLETED=PASS
DIRECT_PAYPAL_SETTINGS=PASS
```

The corrected in-container redacted read returned `merchant.isConnected=YES`, Sandbox `YES`, and HTTP `200` for PPCP common, onboarding, settings, payment, and features endpoints. The onboarding response reports `data.completed=YES`; no credential values were read or output. The direct public Settings page rendered the Connection status panel and Sandbox account presentation.

### SDK v6 and Checkout rendering

The public Checkout page loaded the existing local test cart (`Mini Craft Night Kit`, quantity `1`, local test shipping, displayed total `¥1`). Synthetic local test billing values were used only to satisfy required field rendering; no form submission was made.

```text
PPCP_CLIENT_TOKEN=PASS
PAYPAL_CHECKOUT_BUTTON_RENDERED=PASS
PAYPAL_BUTTON_COUNT=1
PAYPAL_SDK_V6_SCRIPTS=LOADED
CHECKOUT_PAYPAL_CONSOLE_FATAL=NO
```

The PayPal SDK v6 and PPCP boot assets returned HTTP `200` in the container access evidence. After required local test fields were filled, the Checkout DOM contained one enabled `使用PayPal付款` button and PayPal widget iframes. The token itself was never read, logged, or output.

### Webhook readiness

```text
WEBHOOK_REST_HTTP=200
WEBHOOK_URL_PRESENT=YES
WEBHOOK_URL_HTTPS=YES
WEBHOOK_EVENTS_COUNT=17
WEBHOOK_REGISTER=PASS
```

The Direct PayPal Settings UI showed the current HTTPS notification URL under the temporary origin and the subscribed event list. The redacted `/wc/v3/wc_paypal/webhooks` response returned HTTP `200`, an HTTPS URL, and 17 configured events. No test webhook was sent. A direct unauthenticated GET to the POST-only callback returned `404`; this was not used as a registration verdict and no POST/provider payload was generated.

### Runtime

```text
PUBLIC_HOME_HTTP=200
PUBLIC_WPJSON_HTTP=200
PUBLIC_WP_ADMIN=AUTHENTICATED_UI_LOADED
PUBLIC_DIRECT_PAYPAL_SETTINGS=AUTHENTICATED_UI_LOADED
DOCKER_WORDPRESS=RUNNING
DOCKER_MARIADB=RUNNING_HEALTHY
WORDPRESS_SAMPLE_CPU=1.65%
MARIADB_SAMPLE_CPU=0.86%
RUNTIME_HEALTH=PASS
```

The local `cloudflared` Quick Tunnel remained active for the Reviewer checkpoint. It was accountless and used no Cloudflare credentials or token.

### Non-blocking observation

The PayPal Settings admin preview logged optional Apple Pay and Google Pay preview-manager configuration errors. The Connection status, direct Settings UI, Sandbox state, webhook subscription, and PayPal Checkout button remained functional; no PayPal Checkout client-token or rendering error was observed.

```text
K3R11_GATE=K3R11_PUBLIC_ORIGIN_READINESS_VERIFY
SANDBOX_MERCHANT_CONNECTED=PASS
PPCP_CLIENT_TOKEN=PASS
PAYPAL_CHECKOUT_BUTTON_RENDERED=PASS
WEBHOOK_REGISTER=PASS
PUBLIC_HTTPS_ORIGIN=PASS
RUNTIME_HEALTH=PASS
BUYER_APPROVAL=NOT_EXECUTED
ORDER_CREATED=NO
CAPTURE_ACTIONS=0
REFUND_ACTIONS=0
PAYPAL_LIVE_ENABLED=NO
PPCP_VERSION_CHANGED=NO
WOOCOMMERCE_VERSION_CHANGED=NO
WORDPRESS_VERSION_CHANGED=NO
VPS_WRITES=ZERO
SECRET_VALUES_OUTPUT=NO
PASS_CANDIDATE_K3R11_PUBLIC_ORIGIN_READINESS_VERIFY
STOP_AT_REVIEWER=YES
```

## K3R10 Resumed Sandbox Checkout — Owner buyer checkpoint (2026-09-22)

The active temporary HTTPS origin and WordPress public-origin rebind were kept in place. The public Checkout page loaded the existing local test cart without changing the product, price, inventory, shipping test label, or site configuration.

```text
PUBLIC_HTTPS_ORIGIN=https://email-rich-barbie-merchants.trycloudflare.com
TEST_PRODUCT=Mini Craft Night Kit
TEST_QUANTITY=1
TEST_AMOUNT=¥1_DISPLAYED_LOCAL_TEST_AMOUNT
TEST_SHIPPING=LOCAL_TEST_ONLY
SYNTHETIC_CUSTOMER_DATA=USED_FOR_LOCAL_CHECKOUT_RENDERING_ONLY
PAYPAL_SELECTED=YES
```

Executor filled only synthetic local test billing values and clicked the PayPal checkout button once. The PayPal flow reached the provider's secure-browser handoff dialog, which displayed the prompt to continue in a secure PayPal browser. No buyer credential was entered or read. The local Checkout page remained open; no buyer approval, order submission, capture, or refund was performed.

Sanitized local access evidence after the bounded attempt showed no WooCommerce order-creation or capture request at the WordPress boundary. This is a buyer-authentication checkpoint, not a payment result.

```text
K3R10_GATE=K3R10_PAYPAL_SANDBOX_CHECKOUT_CAPTURE_RESUME
PAYPAL_CHECKOUT_OPEN=PASS
PAYPAL_SELECTED=PASS
BUYER_AUTHENTICATION=OWNER_REQUIRED
BUYER_APPROVAL=NOT_EXECUTED
ORDER_CREATED=NOT_OBSERVED_BEFORE_CHECKPOINT
CAPTURE_ACTIONS=0
REFUND_ACTIONS=0
WEBHOOK_PAYMENT_PROCESSING=NOT_YET_APPLICABLE
PUBLIC_HTTPS_ORIGIN=RETAINED
LOCALHOST_REBIND=NOT_RESTORED
PAYPAL_LIVE_ENABLED=NO
SECRET_VALUES_OUTPUT=NO
REAL_CUSTOMER_DATA=NO
RETURN_OWNER_K3R10_SANDBOX_BUYER_AUTH_REQUIRED
STOP_AT_OWNER_CHECKPOINT=YES
```

## K3R10 Post-Payment Capture and Webhook Verification (2026-09-22)

Owner supplied the non-sensitive order-received result after the single Sandbox buyer approval. The following checks were read-only and limited to that same test flow.

### WooCommerce order state

```text
TARGET_ORDER=1120
ORDER_EXISTS=YES
PPCP_ORDER_COUNT=1
ORDER_STATUS=processing
ORDER_IS_PAID=YES
ORDER_DATE_PAID=YES
ORDER_DATE_COMPLETED=NO
ORDER_PAYMENT_METHOD=ppcp-gateway
ORDER_NEEDS_SHIPPING=YES
ORDER_SHIPPING_ITEM_COUNT=1
ORDER_LINE_ITEM_COUNT=1
ORDER_TRANSACTION_ID_PRESENT=YES
TRANSACTION_FINGERPRINT_OCCURRENCES=1
```

The order's PPCP metadata and transaction identifier were inspected in memory. Raw PayPal order/capture identifiers and their fingerprints were not written to GitHub.

### PayPal Sandbox provider state

The container-only read-only helper used the existing stored Sandbox connection internally. It emitted statuses and presence/match booleans only; no credential, token, order ID, capture ID, authorization header, or response body was emitted.

```text
PAYPAL_CREDENTIALS_PRESENT=YES
PAYPAL_ORDER_ID_PRESENT=YES
PAYPAL_OAUTH_HTTP=200
PAYPAL_TOKEN_RECEIVED=YES
PAYPAL_ORDER_GET_HTTP=200
PAYPAL_ORDER_STATUS=COMPLETED
PAYPAL_CAPTURE_COUNT=1
PAYPAL_CAPTURE_ID_PRESENT=YES
PAYPAL_CAPTURE_STATUS=COMPLETED
PAYPAL_REFUND_COUNT=0
WOO_TRANSACTION_ID_MATCHES_CAPTURE=YES
PAYPAL_SINGLE_CAPTURE_NO_DUPLICATE=YES
```

The temporary provider and order helpers were removed from both host and container after verification.

### Callback/webhook and runtime

Sanitized Apache access-log counting showed two POST requests to the PayPal callback endpoint with HTTP 200. A single GET 404 was classified as expected for the POST-only route. WooCommerce log scans were count-only; raw provider and application log lines were not exported.

```text
PAYPAL_CALLBACK_POST_200_COUNT=2
PAYPAL_CALLBACK_GET_404=EXPECTED_POST_ONLY_ROUTE
WC_LOG_PAYMENT_RELATED_LINE_COUNT=54
WC_LOG_WEBHOOK_RELATED_LINE_COUNT=35
WC_LOG_SUCCESS_RELATED_LINE_COUNT=4
PAYPAL_WEBHOOK_DELIVERY=PASS
PPCP_WEBHOOK_HTTP_PROCESSING=PASS
PHYSICAL_FULFILLMENT_AUTO_COMPLETED=NO
SHIPPING_ITEM_PRESENT=YES
PUBLIC_HOME_HTTP=200
PUBLIC_WPJSON_HTTP=200
DOCKER_WORDPRESS=RUNNING
DOCKER_MARIADB=HEALTHY
PUBLIC_HTTPS_ORIGIN=RETAINED
LOCALHOST_REBIND=NOT_RESTORED
```

### Gate result

```text
K3R10_GATE=K3R10_POST_PAYMENT_CAPTURE_WEBHOOK_VERIFY
SINGLE_SANDBOX_PAYMENT=PASS
PAYPAL_CAPTURE=PASS
WOOCOMMERCE_ORDER=PASS
WOO_ORDER_PAID_PROCESSING=PASS
PAYPAL_WOO_CORRELATION=PASS_REDACTED
PHYSICAL_FULFILLMENT_AUTO_COMPLETED=NO
WEBHOOK_CALLBACK=PASS
DUPLICATE_PAYMENT=NO
DUPLICATE_CAPTURE=NO
REFUND_ACTIONS=0
PAYPAL_LIVE_ENABLED=NO
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
SECRET_VALUES_OUTPUT=NO
PASS_CANDIDATE_K3R10_POST_PAYMENT_CAPTURE_WEBHOOK_VERIFY
STOP_AT_REVIEWER=YES
```

## K4 UI + Conversion & Trust — local implementation and verification (2026-09-22)

### K3 temporary environment cleanup

K3 cleanup was completed before the K4 page work. The WordPress public-origin rebind was restored to the recorded local origin, localhost health was verified, and the temporary Quick Tunnel was stopped. The PPCP Sandbox merchant connection was not disconnected.

```text
K3_TEMP_PUBLIC_ORIGIN_ROLLBACK=PASS
ORIGINAL_HOME_URL=http://localhost:8093/
ORIGINAL_SITE_URL=http://localhost:8093/
LOCAL_HOME_HTTP=200
LOCAL_WPJSON_HTTP=200
LOCAL_WP_ADMIN_AUTH_REDIRECT=302_EXPECTED
PUBLIC_QUICK_TUNNEL=STOPPED
PUBLIC_ORIGIN_AFTER_STOP=502_EXPECTED_UNAVAILABLE
PPCP_DISCONNECT_ACTIONS=0
K4_ROLLBACK_BACKUP=PASS
```

The rollback backup remains local only at `.artifacts/k4-preflight-20260922-011148` in the active runtime project. It was not committed to GitHub and its contents were not exported.

### K4 audit and bounded implementation

The audited scope was Home, Product, FAQ, Shipping & Returns, and Contact. The existing Kadence structure and approved Mini Craft assets were retained. Page content was updated with native Gutenberg blocks and factual boundaries; no clone-ui reconstruction, custom theme rebuild, or bulk CSS was introduced.

```text
HOME_PAGE_ID=939
PRODUCT_ID=223
FAQ_PAGE_ID=1121
SHIPPING_RETURNS_PAGE_ID=9
CONTACT_PAGE_ID=10
HOME_SHOP_LINKS=3
HOME_FAQ_LINKS=1
FAKE_STAR_BLOCKS_REMOVED=10
UNVERIFIED_TEMPLATE_CLAIMS=DISABLED
FAKE_SOCIAL_LINKS=REMOVED
DEMO_CONTACT_DATA=REMOVED
SAMPLE_POLICY_TEXT=REMOVED
MENU_PLACEHOLDER_ITEMS_REMOVED=10
HEADER_CTA_LINK=PASS
```

The product remains the existing WooCommerce product and its existing local test metadata was not rewritten. WooCommerce remains the only canonical product, cart, checkout, order, and payment system. The theme/plugin set and versions were not changed:

```text
KADENCE_THEME=1.5.2
KADENCE_BLOCKS=3.7.11_ACTIVE
KADENCE_STARTER_TEMPLATES=2.3.4_ACTIVE
WOOCOMMERCE=10.0.4_ACTIVE
WOOCOMMERCE_PAYPAL_PAYMENTS=4.1.3_ACTIVE
PLUGIN_POLICY=MINIMAL_PRESERVED
```

The following owner-confirmed business facts remain intentionally unfilled rather than invented: final kit contents, duration/difficulty, shipping destinations/method/cost/timing, return window/conditions, missing-or-damaged-item support channel, public support email/response channel, and public business address. These are one batched Owner checkpoint before public sales, not piecemeal implementation blockers.

### Runtime, Gutenberg, and WooCommerce verification

```text
HOME_HTTP=200
PRODUCT_HTTP=200
FAQ_HTTP=200
SHIPPING_RETURNS_HTTP=200
CONTACT_HTTP=200
CART_HTTP=200
CHECKOUT_HTTP=302_EMPTY_CART_EXPECTED
WPJSON_HTTP=200
WP_ADMIN_AUTHENTICATED_EDITOR=PASS
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_MODE=YES
PPCP_ONBOARDING_COMPLETED=YES
DO_BLOCKS_RENDER=PASS
RUNTIME_FATAL_ERROR_COUNT=0
RUNTIME_PARSE_ERROR_COUNT=0
RUNTIME_TIMEOUT_ERROR_COUNT=0
```

Gutenberg editor checks passed for Home, Product, FAQ, Shipping & Returns, and Contact. No invalid-block marker was observed, and the pages remain native/editable. Product, Cart, and Checkout behavior was left on the existing WooCommerce path; no order/payment logic was changed.

### Responsive verification

The accepted K1B responsive baseline was retained. K4 changed editable content, menu destinations, and unverified Kadence product/footer option output only; it did not change the responsive CSS or rebuild the Kadence layout system. A new local screenshot smoke matrix covered Home and Product at 375, 430, 768, 1024, 1366, 1440, 1920, 2048, and 2560px.

```text
K1B_RESPONSIVE_BASELINE_RETAINED=PASS
K4_RESPONSIVE_SCREENSHOT_COUNT=18
K4_SCREENSHOT_WIDTHS=375,430,768,1024,1366,1440,1920,2048,2560
K4_HOME_MOBILE_SMOKE=PASS
K4_HOME_ULTRAWIDE_SMOKE=PASS
K4_PRODUCT_MOBILE_SMOKE=PASS
K4_PRODUCT_DESKTOP_SMOKE=PASS
KADENCE_LAYOUT_REBUILD=NO
CUSTOM_CSS_ADDED=NO
```

### K4 result

```text
GATE=K4_UI_CONVERSION_TRUST
UI_MODIFICATION=PASS
HOME_CONVERSION_TRUST=PASS
PRODUCT_CONVERSION_TRUST=PASS
FAQ=PASS
SHIPPING_RETURNS=PASS_SAFE_FACTUAL_BOUNDARY
CONTACT=PASS_SAFE_FACTUAL_BOUNDARY
BUSINESS_TRUTH=PASS
OWNER_EDITABILITY=PASS
RESPONSIVE=PASS
GUTENBERG_VALIDITY=PASS
WOOCOMMERCE_BEHAVIOR=PASS
CANONICAL_COMMERCE_SYSTEM=WOOCOMMERCE
PPCP_VERSION_CHANGED=NO
WOOCOMMERCE_VERSION_CHANGED=NO
WORDPRESS_VERSION_CHANGED=NO
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
SECRET_VALUES_OUTPUT=NO
PASS_CANDIDATE_K4_UI_CONVERSION_TRUST
STOP_AT_REVIEWER=YES
```

## K4 UI Conversion Trust Finalize — latest authoritative addendum (2026-09-22)

This addendum records the final Executor run after the Reviewer-confirmed business facts were applied. It supersedes the earlier safe-boundary wording for Shipping & Returns and Contact; it does not close K4 formally because the latest Reviewer decision requires one Owner UI edit window first.

```text
GATE=K4_UI_CONVERSION_TRUST_FINALIZE
ROLLBACK_POINT=PASS_LOCAL_ONLY
ROLLBACK_PATH=.artifacts/k4-finalize-preflight-20260922-025529
HOME_CONVERSION_TRUST=PASS
PRODUCT_CONVERSION_TRUST=PASS
FAQ=PASS
SHIPPING_RETURNS=PASS
CONTACT=PASS
BUSINESS_TRUTH=PASS
OWNER_EDITABILITY=PASS
RESPONSIVE=PASS
GUTENBERG_VALIDITY=PASS
INVALID_BLOCK_COUNT=0
WOOCOMMERCE_BEHAVIOR=PASS
CONTACT_FORM=KADENCE_NATIVE_FORM
CONTACT_FORM_RENDERED=PASS
CONTACT_FORM_SUBMIT_ACTION=NOT_EXECUTED
HOME_HTTP=200
PRODUCT_HTTP=200
FAQ_HTTP=200
SHIPPING_RETURNS_HTTP=200
CONTACT_HTTP=200
CART_HTTP=200
CHECKOUT_HTTP=302_EMPTY_CART_EXPECTED
WPJSON_HTTP=200
WP_ADMIN_AUTHENTICATED=PASS
WOOCOMMERCE_HOME_UI=PASS
WOOCOMMERCE_PAYMENTS_UI=PASS
DIRECT_PAYPAL_SETTINGS_UI=PASS
PPCP_CONNECTION_STATE=CONNECTED_SANDBOX_REDACTED
EXISTING_SANDBOX_ORDER=PROCESSING_PAID_UNCHANGED
K4_NEW_ORDER_ACTIONS=0
DOCKER_RUNTIME=PASS
MARIADB_HEALTH=PASS
RUNTIME_FATAL_LOG_MATCHES=0
RESPONSIVE_SCREENSHOT_MATRIX=18_WIDTHS_PASS
KADENCE_LAYOUT_REBUILD=NO
CUSTOM_CSS_ADDED=NO
PPCP_WOOCOMMERCE_WORDPRESS_VERSION_CHANGES=NONE
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
SECRET_VALUES_OUTPUT=NO
PASS_CANDIDATE_K4_UI_CONVERSION_TRUST_FINAL
OWNER_K4_UI_EDIT_WINDOW=REQUIRED_BEFORE_FORMAL_CLOSE
K4_FORMAL_CLOSE=DEFERRED_UNTIL_OWNER_UI_EDIT
STOP_AT_REVIEWER=YES
```

The native Contact form was rendered and inspected in the browser without submission. The temporary repair helpers were removed from host and container. No PayPal, WooCommerce payment/order, Cart, Checkout, or Account logic was changed.

## K4 UI Snapshot Pack — read-only archive (2026-09-22)

CURRENT_GATE=OWNER_K4_UI_EDIT_WINDOW
SNAPSHOT_SCOPE=Home, Shop, Product, FAQ, Shipping & Returns, Contact, Cart, Checkout, Thank You, My Account / Orders
CAPTURE_MODE=READ_ONLY_VIEWPORT_SCREENSHOTS
CAPTURE_ENGINE=LOCAL_EDGE_HEADLESS
DESKTOP_VIEWPORT=1440x900
MOBILE_VIEWPORT=390x844
TABLET_CAPTURE=NOT_PERFORMED
SNAPSHOT_INDEX=docs/UI_SNAPSHOT_INDEX.md
SNAPSHOT_DIRECTORY=docs/ui-current/
SNAPSHOT_COUNT=20
PNG_INTEGRITY=20_OF_20_VALID

PAGE_HTTP_SMOKE=HOME_200;SHOP_200;PRODUCT_200;FAQ_200;SHIPPING_RETURNS_200;CONTACT_200;CART_200;CHECKOUT_302_EMPTY_CART_EXPECTED;THANK_YOU_EXISTING_ORDER_200;MY_ACCOUNT_200
THANK_YOU_CAPTURE_STATE=ANONYMOUS_LOGIN_GATE
DOCKER_WORDPRESS_RUNTIME=PASS
DOCKER_MARIADB_RUNTIME=PASS_HEALTHY
EXISTING_TEST_ORDER_REUSED=YES
NEW_ORDER_ACTIONS=0
PAYMENT_ACTIONS=0
PAGE_OR_CONFIGURATION_CHANGES=0
PLUGIN_THEME_CHANGES=0
OWNER_K4_UI_EDIT_WINDOW_PRESERVED=YES
SECRET_EXPOSURE=NO
UNRELATED_PROJECTS_TOUCHED=NO

The Checkout capture is the anonymous empty-cart baseline. The Thank You capture reuses the existing local Sandbox test-order route; the current anonymous view shows the login gate, and its order key is intentionally not recorded. No page, configuration, WooCommerce, PayPal, order, or payment state was changed. This snapshot pack is evidence for the Owner/Reviewer design decision and does not close the Owner UI edit window.

PASS_CANDIDATE_K4_UI_SNAPSHOT_PACK
STOP_AT_REVIEWER=YES

## K4 Reusable Storefront Shell Implementation — Executor evidence (2026-09-22)

This section records the bounded implementation of the Reviewer-approved reusable shell. It supersedes neither Reviewer-owned decisions nor the formal Reviewer result.

```text
CURRENT_GATE=K4_REUSABLE_STOREFRONT_SHELL_IMPLEMENTATION
ROLLBACK_POINT=PASS_LOCAL_ONLY
ROLLBACK_PATH=mini-craft-k3r4-mariadb-recovery/.artifacts/k4-shell-preflight-20260922-131055
ACTIVE_RUNTIME=http://localhost:8093/
ACTIVE_WORDPRESS_RUNTIME=mini-craft-k3r4-recovery-wordpress
ACTIVE_MARIADB_RUNTIME=mini-craft-k3r4-recovery-mariadb_HEALTHY
```

### Shell implementation

```text
KADENCE_LAYOUT_SYSTEM_REBUILT=NO
KADENCE_LAYOUT_SYSTEM_REUSED=YES
GLOBAL_PALETTE_TOKENS=UPDATED_TO_REVIEWER_APPROVED_VALUES
BODY_FONT=PLUS_JAKARTA_SANS
HEADING_FONT=DM_SERIF_DISPLAY
BUTTON_RADIUS=10PX_GLOBAL_TOKEN
LARGE_CUSTOM_CSS=NO
MINIMAL_RESPONSIVE_CSS_GUARD=YES
ABSOLUTE_POSITIONING_ADDED=NO
IMAGE_GENERATION=NO
IMAGE_SOURCE=EXISTING_APPROVED_MEDIA_LIBRARY_AND_EXISTING_TEMPLATE_ASSETS
OWNER_REPLACEABLE_MEDIA=YES
```

Home retained the existing Kadence hero/section structure and normalized hard-coded colors to global palette tokens; a responsive-only line break uses the existing `k1b-mobile-break` class. Product post `223` retained the WooCommerce title, price, inventory, gallery, SKU, and Add to Cart path; only the editable Gutenberg content below the commerce area was organized into factual columns, support links, and policy context. FAQ `1121`, Shipping & Returns `9`, and Contact `10` use editable core Gutenberg groups, headings, paragraphs, columns, lists, details, and buttons. Contact retains the native Kadence form block and now renders Name, Email, and Message inputs plus the submit button; no unconfirmed recipient channel was created and the form was not submitted.

Shop, Cart, Checkout, Thank You / Order Received, and My Account remain WooCommerce/Kadence structure and inherit global tokens only. No WooCommerce, PayPal, order, payment, or account markup was rebuilt.

### Gutenberg and runtime verification

```text
GUTENBERG_INVALID_BLOCK_COUNT=0
GUTENBERG_PARSE_RESULTS=HOME_101_BLOCKS_UNKNOWN_0;PRODUCT_25_UNKNOWN_0;FAQ_18_UNKNOWN_0;SHIPPING_27_UNKNOWN_0;CONTACT_21_UNKNOWN_0
CONTACT_FORM_FIELDS=3
CONTACT_FORM_RENDER=PASS_NOT_SUBMITTED
HOME_HTTP=200
SHOP_HTTP=200
PRODUCT_HTTP=200
FAQ_HTTP=200
SHIPPING_RETURNS_HTTP=200
CONTACT_HTTP=200
CART_HTTP=200
CHECKOUT_EMPTY_CART_HTTP=302_EXPECTED
CHECKOUT_AFTER_TEMP_ADD_TO_CART_HTTP=200
THANK_YOU_EXISTING_ORDER_1120_HTTP=200
MY_ACCOUNT_HTTP=200
WPJSON_HTTP=200
STORE_API_PRODUCTS_HTTP=200
STORE_API_CART_HTTP=200
ADD_TO_CART_TEMP_SESSION=200
DOCKER_WORDPRESS=UP
DOCKER_MARIADB=HEALTHY
HOME_RESPONSE=200_0.753453S_SMOKE
PHP_CPU_SAMPLE=0.01_PERCENT
MARIADB_CPU_SAMPLE=0.02_PERCENT
```

The temporary Add to Cart smoke used an isolated local cookie session only; it created no order and performed no payment action. Existing WooCommerce order `1120` remains WooCommerce `processing`, has a transaction ID, and was not modified. Product `223` remains SKU `MCK-LOCAL-TEST-001`, `instock`, stock `8`; no product/order business fields were changed by the shell implementation. Active versions remain Kadence `1.5.2`, Kadence Blocks `3.7.11`, Kadence Starter Templates `2.3.4`, WooCommerce `10.0.4`, and WooCommerce PayPal Payments `4.1.3`.

### Responsive evidence

```text
RESPONSIVE_WIDTH_MATRIX=320,375,390,430,768,820,1024,1280,1366,1440,1920,2048,2560
RESPONSIVE_MATRIX_SCREENSHOTS=65_OF_65
RESPONSIVE_MATRIX_PAGES=HOME,PRODUCT,FAQ,SHIPPING_RETURNS,CONTACT
COMMITTED_UI_SCREENSHOTS=10
COMMITTED_UI_SCREENSHOT_PATH=docs/ui-k4-shell/
COMMITTED_UI_SCREENSHOT_SET=HOME_PRODUCT_FAQ_SHIPPING_RETURNS_CONTACT_DESKTOP_1440_AND_MOBILE_390
HORIZONTAL_OVERFLOW=NO_DOCUMENT_OVERFLOW_IN_DOM_SMOKE
HEADER_NAVIGATION=PASS
MOBILE_STACKING=PASS
IMAGE_DISTORTION=NO_OBSERVED
FORM_LAYOUT=PASS
ULTRAWIDE_SMOKE=PASS
```

### Protected scope and safety

```text
WOOCOMMERCE_CANONICAL_COMMERCE_ORDER_SYSTEM=YES
PPCP_CONFIGURATION_TOUCHED=NO
PPCP_VERSION_CHANGED=NO
WOOCOMMERCE_VERSION_CHANGED=NO
WORDPRESS_VERSION_CHANGED=NO
PAYPAL_SANDBOX_CONNECTION=UNCHANGED_REDACTED
EXISTING_SANDBOX_ORDER_1120=PROCESSING_UNCHANGED
NEW_ORDER_ACTIONS=0
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
SECRET_VALUES_OUTPUT=NO
SECRET_VALUES_COMMITTED=NO
UNRELATED_PROJECTS_TOUCHED=NO
OLD_PROJECT_TOUCHED=NO
PASS_CANDIDATE_K4_REUSABLE_STOREFRONT_SHELL_IMPLEMENTATION
STOP_AT_REVIEWER=YES
```

The local rollback point remains available. Host-only helper and CDP inspection files remain contained under the active runtime `.artifacts` directory and are not part of the GitHub commit; no helper, credential, token, cookie, or environment file is included in the evidence commit.

## K4 Content Fill — Reviewer copy (2026-09-22)

This section records the text-only implementation authorized by `docs/REVIEWER_DECISION_K4_SHELL_PASS_CONTENT_FILL.md`. Reviewer-owned documents were not modified.

```text
GATE=K4_CONTENT_FILL_REVIEWER_COPY
TEXT_ONLY=YES
AUTHORITATIVE_COPY=docs/K4_FINAL_COPY_SPEC.md
ACTIVE_RUNTIME=http://localhost:8093/
ROLLBACK_POINT=PASS_LOCAL_ONLY
ROLLBACK_PATH=mini-craft-k3r4-mariadb-recovery/.artifacts/k4-copy-preflight-20260922-144817/pages.json
PAGES_UPDATED=HOME_939;PRODUCT_223_EDITABLE_CONTENT_AND_SHORT_DESCRIPTION;FAQ_1121;SHIPPING_RETURNS_9;CONTACT_10
```

### Copy implementation boundary

```text
HOME_COPY=APPLIED_TO_EXISTING_EDITABLE_SLOTS
PRODUCT_COPY=APPLIED_TO_EXISTING_EDITABLE_SLOTS_AND_SHORT_DESCRIPTION
FAQ_COPY=APPLIED_TO_EXISTING_DETAILS_AND_TEXT_SLOTS
SHIPPING_RETURNS_COPY=APPLIED_TO_EXISTING_TEXT_AND_LIST_SLOTS
CONTACT_COPY=APPLIED_TO_EXISTING_TEXT_SLOTS
NEW_BLOCKS=0
SECTION_ORDER_CHANGED=NO
LAYOUT_BLOCKS_CHANGED=NO
IMAGES_OR_MEDIA_CHANGED=NO
COLORS_CHANGED=NO
TYPOGRAPHY_CHANGED=NO
SPACING_OR_RADIUS_CHANGED=NO
CSS_OR_RESPONSIVE_LOGIC_CHANGED=NO
```

Where the accepted shell had fewer independent text slots than the full copy specification, the approved copy was consolidated into existing editable paragraphs/details/list items. No new block or layout was added, and existing valid link destinations were retained. WooCommerce-owned product title, price, inventory, SKU, gallery, quantity, and Add to Cart behavior were not edited.

### Runtime and commerce verification

```text
HOME_HTTP=200
PRODUCT_HTTP=200
FAQ_HTTP=200
SHIPPING_RETURNS_HTTP=200
CONTACT_HTTP=200
CART_HTTP=200
CHECKOUT_HTTP=200
PRODUCT_ADD_TO_CART_TEMP_SESSION=PASS
PRODUCT_CART_CHECKOUT_SMOKE=PASS
NEW_ORDER_ACTIONS=0
REAL_PAYMENT_ACTIONS=0
PAYPAL_CONFIGURATION_TOUCHED=NO
WOOCOMMERCE_CONFIGURATION_TOUCHED=NO
PPCP_CONFIGURATION_TOUCHED=NO
EXISTING_SANDBOX_ORDER_1120_WC_STATUS=PROCESSING
EXISTING_SANDBOX_ORDER_1120_TRANSACTION_ID_PRESENT=YES_REDACTED
PRODUCT_223_SKU=MCK-LOCAL-TEST-001
PRODUCT_223_STOCK_STATUS=INSTOCK
PRODUCT_223_STOCK=8
ACTIVE_THEME=KADENCE_1.5.2
ACTIVE_PLUGINS=KADENCE_BLOCKS_3.7.11;KADENCE_STARTER_TEMPLATES_2.3.4;WOOCOMMERCE_10.0.4;WOOCOMMERCE_PAYPAL_PAYMENTS_4.1.3
WORDPRESS=7.1.1
DOCKER_WORDPRESS=UP
DOCKER_MARIADB=HEALTHY
```

### Gutenberg, responsive, and visual evidence

```text
GUTENBERG_INVALID_BLOCK_COUNT=0
UNREGISTERED_BLOCK_COUNT=0_ALL_SCOPED_PAGES
UNPARSED_HTML_NODES=0_ALL_SCOPED_PAGES
BLOCK_STRUCTURE_SIGNATURE_UNCHANGED=PASS_5_OF_5
MEDIA_URL_SET_UNCHANGED=PASS_5_OF_5
RESPONSIVE_WIDTH_MATRIX=320,375,390,430,768,820,1024,1280,1366,1440,1920,2048,2560
RESPONSIVE_MATRIX=PASS_65_OF_65
DOM_DOCUMENT_HORIZONTAL_OVERFLOW=0_OF_65
TEXT_OR_BUTTON_CLIPPING=NOT_OBSERVED_IN_DESKTOP_MOBILE_CAPTURES
HOME_PRODUCT_FAQ_SHIPPING_CONTACT_SCREENSHOTS=10_OF_10
DESKTOP_VIEWPORT=1440x1000_FULL_PAGE
MOBILE_VIEWPORT=390x844_FULL_PAGE
SCREENSHOT_DIRECTORY=docs/ui-k4-copy/
SCREENSHOT_INDEX=docs/UI_COPY_FILL_SCREENSHOT_INDEX.md
```

The screenshot pack contains current Home, Product, FAQ, Shipping & Returns, and Contact desktop/mobile captures after the copy fill. No image generation, media replacement, payment, order creation, PayPal action, VPS action, Secret output, or production action occurred.

```text
PASS_CANDIDATE_K4_CONTENT_FILL_REVIEWER_COPY
OWNER_ACTION=NONE
NEXT=STOP_AT_REVIEWER
```

## K4 Full Visual Audit + Product Gallery Repair — 2026-09-23

```text
GATE=K4_FULL_VISUAL_AUDIT_PRODUCT_GALLERY_REPAIR
RESULT=PASS_CANDIDATE_K4_FULL_VISUAL_AUDIT_PRODUCT_GALLERY_REPAIR
ACTIVE_RUNTIME=http://localhost:8093/
WORDPRESS_CONTAINER=UP
MARIADB_CONTAINER=UP_HEALTHY
HOME_HTTP=200
PRODUCT_HTTP=200
WOO_VERSION=10.0.4
PPCP_VERSION=4.1.3
```

### Product gallery diagnosis

The defect was reproduced on the canonical WooCommerce product page before the fix. The initial desktop gallery showed a large active image, but repeated native thumbnail clicks produced an active image as small as `105x96` with a `96px` flex viewport; the mobile path reproduced the same thumbnail-like active state. Refresh restored the first image. The native gallery had six thumbnails and one active slide throughout, so the failure was a sizing/reflow consequence rather than a missing gallery mount.

```text
PRODUCT_ID=223
PRODUCT_GALLERY_IDS=1032,1033,1034,1035,1036
PRODUCT_GALLERY_ROOT_CAUSE=GALLERY_MEDIA_FULL_DIMENSIONS_ARE_INTRINSICALLY_LOW_RES_90_TO_281PX;NATIVE_WOO_FLEX_VIEWPORT_SIZED_ACTIVE_SLIDE_TO_INTRINSIC_IMAGE_DIMENSIONS
PRE_FIX_DESKTOP_AFTER_THUMBNAIL=ACTIVE_IMAGE_105x96;VIEWPORT_HEIGHT_96;LARGE_ACTIVE_IMAGE=NO
PRE_FIX_MOBILE_AFTER_THUMBNAIL=ACTIVE_IMAGE_105x96;VIEWPORT_HEIGHT_96;LARGE_ACTIVE_IMAGE=NO
PRE_FIX_REFRESH=FIRST_IMAGE_RESTORED
```

### Minimal repair

The repair preserves the WooCommerce canonical gallery, native thumbnails, native zoom/lightbox markup, product content, and commerce flow. A rollback point was created for the existing Customizer CSS (`sha256=e1e7c2d7ea7ec8083a4cb7727c32168d6a544aa55f83adf93d47bc6504ac31c2`) before adding one scoped rule through WordPress Custom CSS:

```text
.single-product .woocommerce-product-gallery .woocommerce-product-gallery__image img { width:100%; height:auto; display:block; }
```

```text
PRODUCT_GALLERY_FIX=MINIMAL_SCOPED_CUSTOM_CSS_WIDTH_100_HEIGHT_AUTO_DISPLAY_BLOCK
CANONICAL_WOOCOMMERCE_GALLERY=RETAINED
CUSTOM_CAROUSEL_OR_REBUILD=NO
PRODUCT_MEDIA_ASSIGNMENTS=UNCHANGED
THUMBNAIL_COUNT=6
ZOOM_LIGHTBOX=NATIVE_MARKUP_PRESERVED
CUSTOM_CSS_AFTER_SHA256=04c837e3b1891e54d80083c2c031c807c6ed41bfe2e3351992a1c4a516d7d04d
```

After the fix, all five repeated interactions at every tested width kept one active image at least 50% of the viewport width, with the active image rendered at the gallery width and the thumbnails remaining `60x65`-class thumbnails. Refresh and both desktop/mobile paths remained stable.

```text
PRODUCT_GALLERY_INTERACTION_MATRIX=PASS_65_OF_65
PRODUCT_GALLERY_REFRESH=PASS_13_OF_13
PRODUCT_GALLERY_ACTIVE_IMAGE_SIZE=PASS_13_OF_13
THUMBNAIL_PRESERVATION=PASS_13_OF_13
```

### Full visual audit and regression evidence

```text
AUDIT_VIEWPORTS=DESKTOP_1440;MOBILE_390
AUDIT_SURFACES=HOME;SHOP;PRODUCT;FAQ;SHIPPING_RETURNS;CONTACT;CART;CHECKOUT;ACCOUNT
PNG_COUNT=22
SCREENSHOT_ROOT=docs/ui-k4-full-visual-audit/
PRODUCT_GALLERY_SCREENSHOTS=product-gallery/desktop-product-initial.png;product-gallery/desktop-product-after-thumbnail.png;product-gallery/mobile-product-initial.png;product-gallery/mobile-product-after-thumbnail.png
THANK_YOU_CAPTURE=NOT_CAPTURED
THANK_YOU_REASON=ORDER_RECEIVED_URL_WITHOUT_PRIVATE_ORDER_KEY_RENDERED_ANONYMOUS_NO_KEY_GATE;NO_NEW_ORDER_OR_PAYMENT_CREATED
```

Home and Product were tested at `320,375,390,430,768,820,1024,1280,1366,1440,1920,2048,2560`.

```text
HOME_RESPONSIVE_MATRIX=PASS_13_OF_13
PRODUCT_RESPONSIVE_MATRIX=PASS_13_OF_13
HOME_PRODUCT_HORIZONTAL_OVERFLOW=0_OF_26
HOME_PRODUCT_INVALID_BLOCK_TEXT=0_OF_26
MOBILE_NAV=PASS_13_OF_13
GUTENBERG_INVALID_BLOCK_COUNT=0
HOME_UNREGISTERED_BLOCK_COUNT=0
HOME_PAGE_ID=939
HOME_CONTENT_UNTOUCHED=YES
HOME_BASELINE_PROTECTED=YES
HEADER_LOGO_PROTECTED=YES
HOME_PRODUCT_MEDIA_PROTECTED=YES
DELETED_HOME_SECTIONS_RESTORED=NO
```

The Home capture shows the currently saved wide Hero/overlay/copy/CTA, Header/logo, current four product-display images/order, remaining section order, Story, FAQ, reassurance, CTA, and Footer. The repair selector is limited to `.single-product .woocommerce-product-gallery`, so no Home/Header selector or content was changed.

```text
PRODUCT_CART_CHECKOUT_SMOKE=PASS
ADD_TO_CART_ACTIONS=1_SESSION_ONLY
NEW_ORDER_ACTIONS=0
PAYMENT_ACTIONS=0
WOO_PAYPAL_CONFIG_MUTATION=0
EXISTING_SANDBOX_ORDER_MUTATION=0
OBSERVED_ORDER_STATUS_COUNTS=processing_2;pending_2;checkout-draft_2
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
SECRET_OUTPUT=0
```

The visual-review ZIP contains only the 22 current-Gate PNGs and `manifest.txt`; no logs, cookies, credentials, database export, provider payload, or unrelated project files are included.

```text
VISUAL_REVIEW_PACKAGE=K4_FULL_VISUAL_AUDIT_PRODUCT_GALLERY_REPAIR-visual-review.zip
VISUAL_REVIEW_DELIVERY=OWNER_UPLOAD_ZIP_REQUIRED
OWNER_ACTION=UPLOAD_VISUAL_REVIEW_ZIP
NEXT=STOP_AT_REVIEWER
```

## K4 Local Artifact Hygiene — 2026-09-22

```text
GATE=K4_LOCAL_ARTIFACT_HYGIENE
RESULT=PASS_CANDIDATE_K4_LOCAL_ARTIFACT_HYGIENE
SHARED_ROOT=C:\Users\34707\Documents\ChatGPT\VPS基建
COMMITTED_K4_EVIDENCE=docs/ui-current/;docs/ui-k4-shell/;docs/ui-k4-copy/
```

### Pre-cleanup attribution and action

The following root-level names were positively attributed to this project's K4 screenshot/responsive work by their `.tmp-k4-*` / `.tmp-mc-*` naming, same-day timestamps, and matching committed screenshot evidence. They were reproducible browser capture/profile directories and were not runtime, rollback, database, or media dependencies:

```text
CLEANED=.tmp-k4-* (40 directories: matrix, shell, shell2, shell3, shell4, shell5, single);.tmp-mc-* (22 directories: current UI snapshot captures)
CLEANED_COUNT=62
CLEANED_BYTES=1071221612
ARCHIVED=NONE
```

The uncertain `.tmp-cdp-test2` directory was not opened or removed. It remains in place because current evidence does not positively prove ownership by this K4 run. `.git`, `.clone-ui`, existing project directories, and other root entries were left untouched.

### Post-cleanup regression and safety

```text
SHARED_WORKSPACE_ROOT_K4_TEMP_ARTIFACTS=REMOVED
UNCLASSIFIED_LEFT_IN_PLACE=.tmp-cdp-test2
UNRELATED_PROJECTS_TOUCHED=NO
HOME_HTTP=200
WORDPRESS_CONTAINER=running
MARIADB_CONTAINER=running|healthy
DOCKER_VOLUMES_DELETED=NO
PAGE_MODIFICATIONS=0
MEDIA_MODIFICATIONS=0
CONFIG_MODIFICATIONS=0
WOOCOMMERCE_PAYPAL_ORDER_PAYMENT_MODIFICATIONS=0
SECRET_OUTPUT=0
VPS_WRITES=ZERO
LATEST_HYGIENE_DECISION_RE_READ=PASS
LATEST_OWNER_GPT6_HOME_MEDIA_PROJECT_DOCS=PROTECTED
```

No WordPress, media, configuration, WooCommerce, PayPal, order, payment, Docker container, or volume action was performed in this hygiene Gate. No archive was needed because the confirmed temporary directories were already superseded by committed evidence and had no rollback/debug retention requirement.

## K4 Home Detail Polish — 2026-09-22

```text
GATE=K4_HOME_DETAIL_POLISH
RESULT=PASS_CANDIDATE_K4_HOME_DETAIL_POLISH
FRONT_PAGE_ID=939
HOME_PAGE_ID=939
HOME_HTTP=200
CURRENT_CONTENT_HASH=b7fc2a62de4582b840d1db240051b8caa1596068b0411a6d25ed5bf01535fb27
ROLLBACK_BASELINE_HASH=282f03edd866d94603cfdfb15ebbd6d56d823165192cf6de72ddf05a162c3ad9
HERO_CURRENT_HASH=02e430c1abae85725fae44aea78bbfb7562904f28618ea717c1638da99694a37
HERO_BASELINE_HASH=02e430c1abae85725fae44aea78bbfb7562904f28618ea717c1638da99694a37
HERO_CHANGED=NO
OFFER_REPLACEABLE_MEDIA_SLOTS=4
OFFER_MEDIA_RATIO=4:3
OFFER_MEDIA_LIBRARY_ASSETS=1164;1165 (existing approved assets reused, alternated; no new media generated)
NATIVE_ICON_BLOCKS=7
ICON_PLACEMENT=3_STEP_ITEMS;3_VALUE_ITEMS;1_TRUST_ITEM
ICON_COLOR=existing palette3 burgundy token
GUTENBERG_INVALID_BLOCK_COUNT=0
GUTENBERG_EDITOR_CHECK=EDITOR_OPENED_NO_INVALID_BLOCK_WARNING;REGISTERED_BLOCK_RENDER_PROXY=0
RESPONSIVE_WIDTHS=320,375,390,430,768,820,1024,1280,1366,1440,1920,2048,2560
RESPONSIVE_MATRIX=PASS_13_OF_13
HORIZONTAL_OVERFLOW=NO
MOBILE_NAV=PASS
OFFER_IMAGE_RATIO_CHECK=1.333_AT_ALL_TESTED_WIDTHS
HOME_SCREENSHOTS=docs/ui-k4-detail-polish/home-desktop-1440.png;docs/ui-k4-detail-polish/home-mobile-390.png
PRODUCT_CART_CHECKOUT_SMOKE=PASS_ROUTE_AND_FORM_NO_ORDER_CREATED
PRODUCT_HTTP=200
CART_HTTP=200
CHECKOUT_ROUTE=302_EMPTY_CART_BASELINE
PRODUCT_ADD_TO_CART_UI=VISIBLE_IN_LOCAL_BROWSER
WOOCOMMERCE_PAYPAL_CONFIGURATION=UNCHANGED
EXISTING_SANDBOX_ORDER=UNCHANGED
GLOBAL_PALETTE=UNCHANGED
TYPOGRAPHY=UNCHANGED
HEADER_FOOTER=UNCHANGED
IMAGE_GENERATION=NOT_USED
REAL_PAYMENT_ACTIONS=0
SECRET_OUTPUT=0
VPS_WRITES=ZERO
TEMP_HELPER_CLEANUP=PASS
TEMP_CAPTURE_PROFILE_CLEANUP=PASS
```

The change was limited to the existing Home page 939: four Owner-replaceable Offer media slots and seven native Kadence icon blocks. The Hero block hash is identical before/after. Existing Media Library assets were reused; no image-generation or web-download action occurred. Product UI was opened read-only and showed the existing Add to Cart control; route checks returned Product 200, Cart 200, and the expected empty-cart Checkout redirect. No order, payment, WooCommerce, PayPal, global style, or Docker/MariaDB configuration was changed.

## K4 Home Visual Review Capture — 2026-09-22

```text
GATE=K4_HOME_VISUAL_REVIEW_CAPTURE
RESULT=PASS_CANDIDATE_K4_HOME_VISUAL_REVIEW_CAPTURE
PAGE_ID=939
HOME_HTTP=200
HOME_PAGE_MODIFIED_READONLY=2026-09-22T11:25:09
PAGE_MUTATION=0
CONFIG_MUTATION=0
CAPTURE_METHOD=read-only headless browser navigation and scroll-triggered lazy-load capture
DESKTOP_CAPTURE=docs/ui-k4-visual-review-capture/home-desktop-1440.png
DESKTOP_VIEWPORT=1440px_FULL_PAGE_1440x3968
MOBILE_CAPTURE=docs/ui-k4-visual-review-capture/home-mobile-390.png
MOBILE_VIEWPORT=390px_FULL_PAGE_390x6839
TEMP_CAPTURE_PROFILE_CLEANUP=PASS
SHARED_ROOT_CAPTURE_DEBRIS=0
WOOCOMMERCE_PAYPAL_ORDER_PAYMENT_MUTATION=0
SECRET_OUTPUT=0
VPS_WRITES=ZERO
```

This is a read-only visual inventory for Reviewer consolidation. No Home block, image/media, icon, color, spacing, CSS, responsive rule, Header/Footer, WooCommerce, PayPal, order, payment, or configuration was changed. The capture preserves the current real state, including the observed missing/non-rendering Footer visual state; no repair or design variant was attempted.

## K4 Home Final Density & Alignment Polish — 2026-09-22

```text
GATE=K4_HOME_FINAL_DENSITY_ALIGNMENT_POLISH
RESULT=PASS_CANDIDATE_K4_HOME_FINAL_DENSITY_ALIGNMENT_POLISH
PAGE_ID=939
FRONT_PAGE_ID=939
HOME_HTTP=200
CURRENT_CONTENT_HASH=ded17a654c2a6c206805349778a0b4ff0b437bca610c9854f05665692d2b18f0
ROLLBACK_BASELINE_HASH=b7fc2a62de4582b840d1db240051b8caa1596068b0411a6d25ed5bf01535fb27
HERO_COPY_IMAGE_CTA_UNCHANGED=YES
HERO_H1_DESKTOP=68px_FROM_62px_APPROX_9_7_PERCENT
HERO_H1_TABLET=52px
HERO_H1_MOBILE=42px_FROM_40px
THREE_STEP_PADDING=DESKTOP_24PX_24PX_TABLET_36PX_28PX_MOBILE_24PX_22PX
THREE_STEP_LAYOUT=FLAT_ROW_NATIVE_ICONS_ALIGNED
THREE_VALUE_TILES=3
THREE_VALUE_TILE_BORDER=1px_SOLID_E3D5CB
THREE_VALUE_TILE_RADIUS=16px
THREE_VALUE_TILE_LAYOUT=EQUAL_DESKTOP_HEIGHT_COMPACT_MOBILE_STACK
STORY_LAYOUT=VERTICAL_CENTER_TIGHTER_GAP_RESPONSIVE_STACK
OFFER_SLOTS=4
OFFER_MEDIA_RATIO=4:3_AT_ALL_TESTED_WIDTHS
OFFER_MEDIA_IDS=1164;1165_UNCHANGED
FAQ_REASSURANCE_LAYOUT=TOP_ALIGNED_TIGHTER_SPACING
CLOSING_CTA=LIGHTLY_COMPRESSED_NO_COPY_CHANGE
NATIVE_HOME_ICONS=7
NATIVE_HOME_ICON_SIZE=22PX_STEPS_TRUST;23PX_VALUE_TILES
NATIVE_HOME_ICON_COLOR=EXISTING_BURGUNDY_TOKEN
FOOTER_BROKEN_IMAGE=0
FOOTER_NATIVE_ICON=PASS_FE_HEART
FOOTER_BRAND_LOCKUP=MINI_CRAFT_NIGHT_KIT_TEXT
FOOTER_CREDIT=REMOVED_VIA_NATIVE_THEME_SETTING
FOOTER_NAV_LINKS=3_FAQ_SHIPPING_RETURNS_CONTACT
FOOTER_MOBILE_LAYOUT=COLUMN
RESPONSIVE_WIDTHS=320,375,390,430,768,820,1024,1280,1366,1440,1920,2048,2560
RESPONSIVE_MATRIX=PASS_13_OF_13
HORIZONTAL_OVERFLOW=0_OF_13
CONTENT_RIGHT_OR_LEFT_OVERFLOW=0_OF_13
TEXT_OR_BUTTON_CLIPPING=NOT_OBSERVED
MOBILE_NAV=PASS
FOOTER_ICON_AND_LINKS=PASS_13_OF_13
GUTENBERG_INVALID_BLOCK_COUNT=0
UNREGISTERED_BLOCK_COUNT=0
PRODUCT_CART_CHECKOUT_SMOKE=PASS_NO_ORDER_OR_PAYMENT
PRODUCT_HTTP=200
CART_HTTP=200
CHECKOUT_HTTP=200
ADD_TO_CART_SESSION_SMOKE=PASS_PRODUCT_CART_CHECKOUT
WOOCOMMERCE_PAYPAL_CONFIGURATION=UNCHANGED
EXISTING_SANDBOX_ORDER=UNCHANGED
IMAGE_GENERATION=NOT_USED
REAL_PAYMENT_ACTIONS=0
VPS_WRITES=ZERO
SECRET_OUTPUT=0
TEMP_CAPTURE_PROFILE_CLEANUP=PASS
TEMP_HELPER_CLEANUP=PASS
CONTAINER_ROLLBACK_CLEANUP=PASS
SCREENSHOTS=docs/ui-k4-final-density-polish/home-desktop-1440.png;docs/ui-k4-final-density-polish/home-mobile-390.png
```

The final polish reused the existing Kadence/Gutenberg structure. It adjusted only the requested Home density/alignment attributes, increased Hero heading weight within the approved range without changing Hero copy/image/CTA, differentiated the three value items with native 1px bordered tiles, preserved the four editable 4:3 Offer slots, standardized the existing native burgundy icons, tightened the requested section spacing, and replaced the broken Footer brand image with a native Kadence heart icon plus editable text. The public Footer theme credit was removed through the native Kadence setting; FAQ, Shipping & Returns, and Contact links remain present.

The final 13-width browser matrix found no horizontal overflow, clipping, invalid-block text, broken Footer image, or missing Home/Footer icon. Product 200, Cart 200, Checkout 200, and a fresh-session Add to Cart → Cart → Checkout smoke passed without creating an order or invoking payment. No WooCommerce, PayPal, Sandbox order, version, VPS, or secret state was changed.

```text
OWNER_ACTION=NONE
NEXT=STOP_AT_REVIEWER
```

## K4 Artifact-Backed Block Recovery — Executor candidate (2026-09-23)

```text
GATE=K4_ARTIFACT_BACKED_BLOCK_RECOVERY
RESULT=PASS_CANDIDATE_K4_ARTIFACT_BACKED_BLOCK_RECOVERY
ACTIVE_RUNTIME=http://localhost:8093/
WORDPRESS=7.1.1
KADENCE_BLOCKS=3.7.11
WOOCOMMERCE=10.0.4
PPCP=4.1.3
THEME=KADENCE_1.5.2
ROLLBACK_POINT=PASS_LOCAL_ONLY
PAGE_LOCAL_ROLLBACKS=.artifacts/k4-artifact-backed-block-recovery/page-10-before.json;.artifacts/k4-artifact-backed-block-recovery/page-1121-before.json
ROLLBACK_MANIFEST=.artifacts/k4-artifact-backed-block-recovery/rollback-pages-preflight.json
ROLLBACK_MANIFEST_SHA256=1150F4678FFEEAAD04483CE6C9E829579B9FC1CE3774C3D2565CD7737EA42572
PAGE_10_ROLLBACK_SHA256=CBC24C66BDDBA36AFD1833B2E97D28EAC928EDA8549345347B7073EE4D028012
PAGE_1121_ROLLBACK_SHA256=7E789D7A2C3D3C02DF7E0CEF6AF41F797F99E2946579955591C30C03A251EC6E
K4_RECOVERY_SOURCE=.artifacts/k4-copy-preflight-20260922-144817/pages.json
K4_RECOVERY_SOURCE_FILE_SHA256=4431FC0E0D81B248023A71DD74D7359C6CAF40D740186DD746C64617DB72F3CB
RECOVERY_SOURCE_MODIFIED=2026-09-22T14:48:21+08:00
KADENCE_FORM_RECOVERY_SOURCE=k4-copy-preflight-20260922-144817/pages.json#page-10:path-2.2.1.0
KADENCE_FORM_SOURCE_HASH=631b0ec76dae167a22751608b399f147ab799a0c1c5100ea651ef3f91fb53348
KADENCE_FORM_SOURCE_VALIDATION=PASS_REGISTERED_SCHEMA_3.7.11;EXACT_SERIALIZER_BYTES;HISTORICAL_K4_RENDER_AND_EDITOR_PASS
KADENCE_FORM_FIELDS=Name:text:required;Email:email:required;Message:textarea:required
KADENCE_FORM_BUTTON=Send message
KADENCE_FORM_HONEYPOT=PRESERVED
KADENCE_FORM_EXPLICIT_PUBLIC_EMAIL=NONE
KADENCE_FORM_THIRD_PARTY_OR_WEBHOOK=NONE
CONTACT_INVALID_BLOCKS_BEFORE=4
CONTACT_INVALID_TARGETS_REPAIRED=1_KADENCE_FORM_PLUS_3_CORE_COLUMN
CONTACT_TARGET_PATHS=FORM_2.2.1.0;COLUMNS_2.3.0,2.3.1,2.3.2
CONTACT_TARGET_BLOCK_HASHES=FORM:be0edd1d47a03a720c97aa62607af23ffc637339034758a542657621fdeedff1->631b0ec76dae167a22751608b399f147ab799a0c1c5100ea651ef3f91fb53348;COLUMN_2.3.0:2d86e2dca767e3e129c898b88b8cfa909fea9437ff18b6440b342b77d0a99f87->974eaa309526aaf154e84940e059a960f082174dc302cb254eebdc8d0cb3ac4b;COLUMN_2.3.1:d6bccefb83b0ab615734f16fe48b8596048ee131721f252608a7200e3573bb32->b51558871d5bb8c653084f411eb3ee28c830c03c1a5ae8c6c005b01140ff9bec;COLUMN_2.3.2:e1db4c29af36219449595bdc01da0a5e8e4abf397fd0c7e492f884bc42dfe5f4->3a9e4beeebdd4684e5b87df1ce31ce5506cc302f5693c42763efe4b5e33efedb
CONTACT_INVALID_BLOCKS_AFTER=0_DETERMINISTIC_NATIVE_SERIALIZER
FAQ_INVALID_BLOCKS_BEFORE=7
FAQ_INVALID_TARGETS_REPAIRED=7_CORE_DETAILS
FAQ_TARGET_PATHS=0.3,0.4,0.5,0.7,0.8,0.9,0.11
FAQ_TARGET_BLOCK_HASHES=0.3:bda7a09af553bab24aeeb9022357caa2c152759a68e42c9988c5574daee27925->00d1583df4e262686b880a3ec700ce49ba22bf98fa5cf91c1e73b7dcd68711d9;0.4:bc4e1e75dca56069fc155c5145926ad70bb2f5db63d10d7994681333e41247ca->78a5ff2d889e57182b9194211b3afeae948890d251df1cec3cfdb153aa11464c;0.5:814a921c0c7a7553ea5f2cdbde6b7334680bad038aa59ae73a024d015fe34622->107dc6b1da0604c2e95e80f01db2955323966dc1dec8ac72341fd7b3bc9a633b;0.7:ebb4dcb8de3fe41fc21ec3c88b83019f42b4375fde1663e4d93da4b127fb7da0->dc090e895e78b41b7126a327fda602a96299aaeabd68d4e20fcd25f3d626d2ae;0.8:17ee4c2e4b12b52f9cef0034e38fd21a6ba0918215aa785a87a49d586fafec5e->6d03fbd48ff94c0da0a977849f4cc7a3ddcec92048c7679fdb7eb5c7d7a52f85;0.9:cb2ac169a544cc2b368ea659f225cc8bd9b28af15320cd6d61dae1e42ff9843b->ceaec977be8d85536953c50ba8005f243321b6cf9425ec371d0bb3dbf0ca165f;0.11:4cac0fec1697ce98d4e4ea02b8203687c045c93f650c66acafa476c594afa837->33359b2aaf252d45696421c6f106614c530c75f26e4d5913447f443001085371
FAQ_DETAILS_FRONTEND_COUNT=7
FAQ_SUMMARY_ANSWER_LINK_HASHES=PRESERVED_7_OF_7;LINKS_1_OF_1
FAQ_INVALID_BLOCKS_AFTER=0_DETERMINISTIC_NATIVE_SERIALIZER
CONTACT_FRONTEND_FIELDS=NAME_EMAIL_MESSAGE_SEND
CONTACT_FORM_SUBMIT=NOT_EXECUTED
NON_TARGET_BLOCK_SIGNATURES_PRESERVED=YES_EXACT_BYTES_OUTSIDE_TARGETS_AND_EXISTING_COLUMN_CHILDREN
WHOLE_PAGE_PARSE_SERIALIZE=NO
HAND_AUTHORED_KADENCE_MARKUP=NO
WORDPRESS_CORE_PARSE_AND_SERIALIZE=PASS
REGISTERED_BLOCKS=PASS
UNREGISTERED_BLOCK_COUNT=0
UNPARSED_HTML_NODES=0
GUTENBERG_EDITOR_VISUAL_VALIDATION=PENDING_SESSION
GUTENBERG_EDITOR_INVALID_COUNT=NOT_MEASURED_PENDING_SESSION
GUTENBERG_GUI_AUTOMATION=NOT_RETRIED
TRANSIENT_HELPERS=HOST_REMOVED_CONTAINER_TMP_REMOVED
PAGE_CONTENT_MUTATIONS=CONTACT_10_AND_FAQ_1121_ONLY
CONTACT_PAGE_10_HASH_BEFORE=e2ff7bfff31e3d426a1a50f052d1ed6c6077590c1c837fd920d1105d7b0a57fb
FAQ_PAGE_1121_HASH_BEFORE=070ee640fbd96d2cf50633567cfee0e99529369e00958f1837dfeef4d36620ec
HOME_PAGE_939_HASH=07093dcd9a3ecaac4f09e9e9c56c82a957ec1cfcf17d7375fe2ba0baf4e97831_UNCHANGED
PRODUCT_PAGE_223_HASH=7a8dee19692b87d364f51cccbcc7edcafd779de12e17bfd750e453a3d423d446_UNCHANGED
SHIPPING_PAGE_9_HASH=3e0c39b34b44cd1fc8af65ce9ffa8d50b0d9d0fb407b230012ea239b7d67bc52_UNCHANGED
CONTACT_PAGE_10_HASH_AFTER=ebdceb296de1b9382ab027e1d761551a9f4e5ce63e84cb2d53f0028d08e3de3b
FAQ_PAGE_1121_HASH_AFTER=6d1538381b29e71c2c3b127027c84d6ccaea98e7e51823dc55e0561139e5619b
SITE_LOCALE=zh_CN_UNCHANGED
PRODUCT_223_SKU=MCK-LOCAL-TEST-001_UNCHANGED
PRODUCT_223_PRICE=1_UNCHANGED
PRODUCT_223_STOCK=8_INSTOCK_UNCHANGED
EXISTING_ORDER_1120=PROCESSING_TRANSACTION_PRESENT_UNCHANGED
ACTIVE_PLUGINS=KADENCE_BLOCKS_3.7.11;KADENCE_STARTER_TEMPLATES_2.3.4;WOOCOMMERCE_10.0.4;WOOCOMMERCE_PAYPAL_PAYMENTS_4.1.3_UNCHANGED
HOME_HTTP=200
PRODUCT_HTTP=200
FAQ_HTTP=200
SHIPPING_RETURNS_HTTP=200
CONTACT_HTTP=200
WPJSON_HTTP=200
DOCKER_WORDPRESS=UP
DOCKER_MARIADB=HEALTHY
SCREENSHOTS=docs/ui-k4-artifact-backed-block-recovery/desktop/contact-1440.png;docs/ui-k4-artifact-backed-block-recovery/desktop/faq-1440.png;docs/ui-k4-artifact-backed-block-recovery/mobile/contact-390.png;docs/ui-k4-artifact-backed-block-recovery/mobile/faq-390.png
VISUAL_REVIEW_PACKAGE=K4_ARTIFACT_BACKED_BLOCK_RECOVERY-visual-review.zip_LOCAL_ONLY
VISUAL_REVIEW_DELIVERY=OWNER_UPLOAD_ZIP_REQUIRED
NEW_ORDER_ACTIONS=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
VPS_WRITES=ZERO
SECRET_OUTPUT=0
SECRET_COMMITTED=0
```

The Form was restored byte-for-byte from the retained K4 copy-preflight snapshot (file hash and block hash above), before the later content-fill write. Its schema matches active Kadence Blocks 3.7.11, the original raw bytes round-trip identically through the registered block serializer, and server rendering exposes the required Name, Email, Message and Send message controls. The retained K4 shell evidence records the corresponding native form render and zero invalid blocks. Contact's three affected columns were rebuilt with registered `core/paragraph` children; FAQ's seven saved summaries, answer HTML and link bytes were preserved while each answer became a registered `core/paragraph` child. Writes were surgical block-range replacements; all non-target serialized bytes and existing column children were verified unchanged.

The current Gutenberg editor session remains unavailable, so editor-side visual invalid-block validation is explicitly pending. Independent headless screenshots are archived above and included in the local review ZIP. No Home, Product, Gallery/CSS, Shipping, locale, WooCommerce/PayPal configuration, product business data, order/payment state, or other project was changed.

## K4 Workspace Hygiene V2 — Executor candidate (2026-09-23)

```text
GATE=K4_WORKSPACE_HYGIENE_V2
RESULT=PASS_CANDIDATE_K4_WORKSPACE_HYGIENE_V2
ROOT_ITEMS_CLASSIFIED=16
ROOT_ITEMS_AFTER_ARCHIVE_MOVE=15
KEEP_ACTIVE=mini-craft-k3r4-mariadb-recovery
KEEP_PROJECT_SOURCE=mini-craft-night-kit;project-github-sync;.git
KEEP_ROLLBACK_REFERENCED=mini-craft-k3r4-docker-mariadb;mini-craft-kadence-poc
ARCHIVED=K4_FULL_VISUAL_AUDIT_PRODUCT_GALLERY_REPAIR-visual-review.zip
CLEANED=NONE
DELETE_ELIGIBLE_TRANSIENTS=0
UNCLASSIFIED_LEFT_IN_PLACE=.tmp-cdp-test2;.tmp-k4-detail-browser-desktop;.tmp-k4-detail-browser-mobile
UNRELATED_LEFT_UNTOUCHED=.clone-ui;formwork-design;g4-5-owner-visual-review-runtime;SHARED_VPS_HANDOFF.md;workspaces;existing_conversion-leak-audit_archive
ACTIVE_RUNTIME_UNCHANGED=YES
ACTIVE_RUNTIME_PATH=mini-craft-k3r4-mariadb-recovery
SITE_HTTP_200=YES
HOME_HTTP=200
PRODUCT_HTTP=200
CONTACT_HTTP=200
FAQ_HTTP=200
SHIPPING_RETURNS_HTTP=200
WORDPRESS_CONTAINER=UP_RESTART_COUNT_0
MARIADB_CONTAINER=HEALTHY_RESTART_COUNT_0
ACTIVE_RUNTIME_PATH_UNCHANGED=YES_COMPOSE_WORKING_DIR_MATCHES
HOME_HASH_UNCHANGED=YES_NO_PAGE_WRITES
PRODUCT_GALLERY_CSS_UNCHANGED=YES_NO_RUNTIME_FILE_WRITES
CONTACT_FAQ_RECOVERY_UNCHANGED=YES_NO_DATABASE_WRITES;BOTH_HTTP_200
SITE_LOCALE_CHANGE=0;PUBLIC_HTML_LANG=zh-Hans
PRODUCT_STATE_UNCHANGED=YES_NO_DATABASE_WRITES
PAYPAL_CONFIG_UNCHANGED=YES_NO_DATABASE_OR_CONFIG_WRITES
EXISTING_SANDBOX_ORDER_UNCHANGED=YES_NO_ORDER_ACTIONS
PAGE_CONFIG_MEDIA_MUTATION=0
WOOCOMMERCE_PAYPAL_ORDER_PAYMENT_MUTATION=0
NEW_ORDER_ACTIONS=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
DOCKER_VOLUMES_DELETED=0
VPS_WRITES=ZERO
SECRET_OUTPUT=0
WORKSPACE_TEMP_CLEANUP=PASS
WORKSPACE_TEMP_CLEANUP_NOTE=UNCLASSIFIED_ROOT_ITEMS_RETAINED_BY_RULE
ROOT_TRANSIENTS_CREATED=NONE
ROOT_TRANSIENTS_REMAINING=.tmp-cdp-test2;.tmp-k4-detail-browser-desktop;.tmp-k4-detail-browser-mobile
LOCAL_HELPERS_CLEANED=NO_HELPERS_CREATED_BY_THIS_GATE
BROWSER_PROFILES_CLEANED=NO_PROFILES_CREATED_BY_THIS_GATE;UNCLASSIFIED_EXISTING_PROFILES_RETAINED
DELIVERABLE_LOCATION=_project-artifacts/mini-craft-night-kit/k4-full-visual-audit-product-gallery-repair/deliverables/K4_FULL_VISUAL_AUDIT_PRODUCT_GALLERY_REPAIR-visual-review.zip
ROLLBACK_LOCATION=ARCHIVE_MOVE_REVERSIBLE_FROM_DELIVERABLE_LOCATION;EXISTING_PAGE_ROLLBACKS_UNCHANGED_UNDER_ACTIVE_RUNTIME/.artifacts/k4-artifact-backed-block-recovery/
ANTI_REGRESSION_POLICY_RECORDED=YES
OWNER_ACTION=NONE
NEXT=STOP_AT_REVIEWER
```

### Read-only root inventory and disposition

The shared root had 16 immediate entries before the single archive move and 15 afterward. No recursive inspection was made of unrelated projects. Folder sizes below are metadata totals only where a focused Mini Craft/runtime check was needed; protected or unrelated folders were not recursively sized.

| Root entry | Observed size / modified | Attribution and current references | Disposition |
| --- | --- | --- | --- |
| `.git` | Directory; not sized; 2026-09-23 08:06 | Workspace VCS metadata; explicitly protected | KEEP_PROJECT_SOURCE / never touched |
| `.clone-ui` | Directory; not sized; 2026-09-17 09:10 | Generic visual tooling; no inspection | UNRELATED_LEAVE |
| `.tmp-cdp-test2` | Directory; not sized; 2026-09-23 09:31 | Nine running `msedge.exe` command lines reference it; provenance/current session ownership not resolved | UNCLASSIFIED_LEFT_IN_PLACE |
| `.tmp-k4-detail-browser-desktop` | 1,065,020 bytes, 5 Crashpad files; 2026-09-22 19:21 | No process reference; only crash metrics/settings observed. Existing shared archive index still marks ownership unproven, so name alone is insufficient | UNCLASSIFIED_LEFT_IN_PLACE |
| `.tmp-k4-detail-browser-mobile` | 1,065,020 bytes, 5 Crashpad files; 2026-09-22 19:21 | Same ownership limitation as desktop; no source, rollback, or screenshot payload identified | UNCLASSIFIED_LEFT_IN_PLACE |
| `_project-artifacts` | Directory; not recursively sized; modified 2026-09-23 09:40 by this archive operation | Its existing `conversion-leak-audit/00_INDEX.md` documents the local review/archive role and GitHub as source of truth; existing subtree was not changed | Existing archive retained; dedicated Mini Craft sibling used |
| `formwork-design` | Directory; not sized; 2026-09-12 14:45 | Explicitly unrelated by project name; not inspected | UNRELATED_LEAVE |
| `g4-5-owner-visual-review-runtime` | 8,281 bytes across 2 log files; newest 2026-09-22 23:32 | Separate visual-review runtime; a local listener/process remains active; logs not read and directory not changed | UNRELATED_LEAVE |
| `K4_FULL_VISUAL_AUDIT_PRODUCT_GALLERY_REPAIR-visual-review.zip` | 8,548,199 bytes; 2026-09-23 02:54; SHA-256 `C940A0213987AD58F3ED9518A8FDDD44F805BD1AAE63DA70F6742F29CA48DC49` | 23 ZIP entries: 22 PNGs plus `manifest.txt`; all 22 PNG paths exist in committed `docs/ui-k4-full-visual-audit/`; no process reference or credential-value pattern found | ARCHIVE_PROJECT_ARTIFACT; moved with hash verification to the location above |
| `mini-craft-k3r4-docker-mariadb` | 1,610 bytes; 2026-09-21 12:22 | Compose working directory of two running containers with distinct named WordPress and DB volumes | KEEP_ROLLBACK_REFERENCED |
| `mini-craft-k3r4-mariadb-recovery` | 1,769,661,390 bytes / 43,711 files; 2026-09-21 12:55 root timestamp | Exact Compose working directory for active 8093 WordPress/MariaDB containers; three project-named data/content volumes | KEEP_ACTIVE; path and runtime dependencies untouched |
| `mini-craft-kadence-poc` | 935,833,119 bytes / 38,122 files; 2026-09-21 09:18 root timestamp | K0 PoC Compose working directory; WordPress/DB containers and dedicated core/uploads/database volumes remain active | KEEP_ROLLBACK_REFERENCED |
| `mini-craft-night-kit` | 564,150,470 bytes / 1,236 files; 2026-09-17 14:51 root timestamp | Old project source; two running containers reference its Compose path, scripts, `.htaccess`, `wp-content`, and unique DB volume | KEEP_PROJECT_SOURCE; untouched |
| `project-github-sync` | Directory; not sized; 2026-09-22 19:01 | Existing checkout reports 14 pre-existing changed/untracked status entries; filenames/content not inspected or modified | KEEP_PROJECT_SOURCE; untouched |
| `SHARED_VPS_HANDOFF.md` | 5,081 bytes; 2026-09-19 02:29 | Shared handoff file, outside this local cleanup scope | UNRELATED_LEAVE |
| `workspaces` | Directory; not sized; 2026-09-23 08:44 | Workspace collection for other work; no recursive inspection | UNRELATED_LEAVE |

The `_project-artifacts` index explicitly identifies that root as a local archive rather than canonical source. The Mini Craft ZIP move was reversible and kept its original bytes; the old root ZIP path is now absent. This did not move or alter the active runtime directory. The two `.tmp-k4-detail-browser-*` folders remain because provenance was not proven, while `.tmp-cdp-test2` remains because nine Edge processes reference it and it changed during inventory. No Docker command stopped, recreated, or removed containers/volumes.

### Permanent workspace anti-regression contract

This Gate records the following mandatory closeout fields for every future Mini Craft Executor Gate:

```text
WORKSPACE_TEMP_CLEANUP=<PASS | RETURN>
ROOT_TRANSIENTS_CREATED=
ROOT_TRANSIENTS_REMAINING=
LOCAL_HELPERS_CLEANED=
BROWSER_PROFILES_CLEANED=
DELIVERABLE_LOCATION=
ROLLBACK_LOCATION=
```

Gate temporaries belong under the active runtime `.artifacts/<gate>/{rollback,screenshots,browser-profile,helpers,deliverables}/` or OS temp, never as new shared-root `.tmp-k4-*` / `.tmp-mc-*` entries. Remove helpers and browser profiles created by the Gate before return unless a retained artifact has an explicit purpose/manifest. Keep durable screenshots in GitHub; keep a visual ZIP under the Gate's deliverables. Cross-runtime artifacts may use `_project-artifacts/mini-craft-night-kit/<gate>/` only after archive purpose is verified. Classify before cleanup; unknown provenance, active sessions, other projects, `.git`, `.clone-ui`, runtimes, volumes, source, and referenced rollback stay untouched and are reported rather than guessed away.

Post-cleanup checks: `http://localhost:8093/`, Product, Contact, FAQ, and Shipping & Returns all returned HTTP 200. The active WordPress container remained running with restart count 0 and its Compose working directory unchanged; MariaDB remained healthy with restart count 0. Public HTML language remains `zh-Hans`, consistent with the previously recorded `zh_CN` site locale. This Gate made no WordPress, page, media, configuration, product, PayPal, order, payment, Docker-volume, or VPS writes.

## K4 Strict Storefront Cleanup Resume — Executor candidate (2026-09-23)

Authority was re-synced to Reviewer Hand-off and `docs/REVIEWER_DECISION_K4_STRICT_STOREFRONT_CLEANUP_RESUME.md` at base commit `5e7adfcffbdbbf6975cf198fac4429ec5e963490`. `PROJECT_RECORD.md` still carries an older 2026-09-21 status snapshot; the newer 2026-09-23 Reviewer Hand-off and the Gate-specific decision authorize this bounded resume and are recorded as the operative status.

```text
GATE=K4_STRICT_STOREFRONT_CLEANUP_RESUME
RESULT=PASS_CANDIDATE_K4_STRICT_STOREFRONT_CLEANUP_RESUME
ACTIVE_RUNTIME=mini-craft-k3r4-mariadb-recovery
LOCAL_URL=http://localhost:8093/
WORDPRESS=7.1.1
KADENCE_THEME=1.5.2
ACTIVE_PLUGINS=Kadence_Blocks_3.7.11;Kadence_Starter_Templates_2.3.4;WooCommerce_10.0.4;WooCommerce_PayPal_Payments_4.1.3
CUSTOMER_FRONTEND_LANGUAGE=ENGLISH_en_US;ADMIN_USER_LANGUAGE=zh_CN
```

Implemented only the authorized storefront edits: set the effective site locale to WordPress English while retaining the admin user's Chinese locale; set legacy demo products 222/224/117 to reversible `draft` status; assigned product 223 to the native top-level `Craft Kits` category; reduced Shop title height desktop 240→150px and tablet 200→130px; explicitly disabled native Kadence result-count/sorting controls; removed Contact internal-governance copy while preserving the exact native Kadence Form bytes (SHA-256 `631b0ec76dae167a22751608b399f147ab799a0c1c5100ea651ef3f91fb53348`); replaced the FAQ Orders & Support prose with two native `core/details` blocks, leaving the existing seven items in place (nine total); removed the duplicate inner Shipping & Returns H1 and consolidated its support CTA; made only scoped mobile Product-description typography and Shipping page heading/spacing CSS changes; and rearranged the Kadence Footer into one native row with brand → navigation → copyright, desktop row / mobile column.

```text
HOME_PAGE_939_SHA256=07093dcd9a3ecaac4f09e9e9c56c82a957ec1cfcf17d7375fe2ba0baf4e97831_UNCHANGED
PRODUCT_PAGE_223_SHA256=7a8dee19692b87d364f51cccbcc7edcafd779de12e17bfd750e453a3d423d446_UNCHANGED
PRODUCT_223_SKU=MCK-LOCAL-TEST-001_UNCHANGED
PRODUCT_223_PRICE=1_UNCHANGED
PRODUCT_223_STOCK=8_INSTOCK_UNCHANGED
PRODUCT_CATEGORY=Craft_Kits
LEGACY_DEMO_PRODUCTS=222_DRAFT;224_DRAFT;117_DRAFT;NOT_DELETED
CONTACT_FORM_STRUCTURE=BYTE_IDENTICAL_TO_PRE_GATE_VALID_FORM
CONTACT_FRONTEND_FIELDS=NAME_EMAIL_MESSAGE_SEND
CONTACT_INTERNAL_GOVERNANCE_COPY_REMAINING=NO
FAQ_NATIVE_DETAILS=9;EXISTING_7_RETAINED;TWO_ORDERS_SUPPORT_ITEMS_ADDED
FAQ_INTERNAL_GOVERNANCE_COPY_REMAINING=NO
SHIPPING_RETURNS=ONE_VISIBLE_THEME_H1;SHIPPING_RETURNS_DAMAGED_OR_MISSING_ITEMS_RETAINED
SHIPPING_POLICY_FACTS=UNCHANGED
SHOP_SINGLE_PRODUCT_CONTROLS=HIDDEN_NATIVE
PRODUCT_GALLERY_CANONICAL_INTERACTION=PASS
PRODUCT_GALLERY_SCOPED_RULE_SHA256=1cd56ca9d8a7590233c8b84e1a099506a13ca2aeb5fe518506989549bfd251dc_UNCHANGED
CUSTOM_CSS_SHA256_AFTER_SCOPED_MOBILE_RULES=950fd2490ff0f5e8aa39e1b257819bd58dd316f8c98b8641cafdb3488eb42ecd
```

Anonymous isolated-browser evidence: Home, Shop, Product, FAQ, Shipping & Returns, Contact, Cart, populated Checkout, and Account were captured at 1440px desktop / 390px mobile. All captured page responses were HTTP 200; customer-visible strings were English; no horizontal overflow was measured (desktop deltas -15px to 0px; mobile 0px); mobile navigation opened; Shop exposed only Mini Craft Night Kit; Contact fields and all nine FAQ details rendered; populated Cart contained one item; populated Checkout exposed billing, order summary, and payment sections, with Place order never clicked. Product thumbnail switching changed the active image while keeping it at gallery width (desktop 565/565px; mobile 326/326px), with six thumbnails and zoom available. The temporary cart was cleared after screenshots.

```text
GUTENBERG_EDITOR_VISUAL_VALIDATION=PENDING_SESSION
GUTENBERG_DETERMINISTIC_PARSE=PASS;UNREGISTERED_BLOCKS=0_HOME_PRODUCT_CONTACT_FAQ_SHIPPING
HTTP_HOME_SHOP_PRODUCT_FAQ_SHIPPING_CONTACT_CART_ACCOUNT=200
HTTP_POPULATED_CART_CHECKOUT_CAPTURE=200
EMPTY_CHECKOUT_AFTER_TEST_CART_CLEANUP=302_EXPECTED_EMPTY_CART_REDIRECT
EXISTING_ORDER_1120=PROCESSING;PPCP_GATEWAY;TRANSACTION_PRESENT_UNCHANGED
NEW_ORDER_ACTIONS=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
PAYPAL_CONFIGURATION_MUTATION=0
VPS_WRITES=ZERO
SECRET_OUTPUT=0
```

Screenshot manifest and 22 durable PNGs are under `docs/ui-k4-strict-storefront-cleanup-resume/`, first archived in commit `45727c0092146b6b5d5e4d8601c81e6d7705b85c`. Local review ZIP SHA-256: `106DBC238DD52A09F5EF59484DA463801D9EFF4F04A2ABF84A0692ABFAD529D5`; it contains only `desktop/`, `mobile/`, `product-gallery/`, and `manifest.txt`.

Rollback point: active-runtime local-only SQL export at `mini-craft-k3r4-mariadb-recovery/.artifacts/k4-strict-storefront-cleanup-resume/rollback/pre-gate.sql`, SHA-256 `94F9E4C57CA03E57A70EEEF20C28A62AEB318DFC6D1F8A02861A6556059A6A0C`. It is not uploaded or included in the ZIP.

```text
WORKSPACE_TEMP_CLEANUP=PASS
ROOT_TRANSIENTS_CREATED=NONE
ROOT_TRANSIENTS_REMAINING=.tmp-cdp-test2;.tmp-k4-detail-browser-desktop;.tmp-k4-detail-browser-mobile (pre-existing, deliberately untouched under Hygiene V2)
LOCAL_HELPERS_CLEANED=PASS
BROWSER_PROFILES_CLEANED=PASS
DELIVERABLE_LOCATION=mini-craft-k3r4-mariadb-recovery/.artifacts/k4-strict-storefront-cleanup-resume/deliverables/
ROLLBACK_LOCATION=mini-craft-k3r4-mariadb-recovery/.artifacts/k4-strict-storefront-cleanup-resume/rollback/pre-gate.sql
UNRELATED_PROJECTS_TOUCHED=NO
DOCKER_VOLUMES_DELETED=NO
PRODUCT_MODEL_STRATEGY_DECISION=PENDING_OWNER_REVIEW
TEST_PRICE_PENDING_PRODUCTION=YES
TEST_STOCK_PENDING_PRODUCTION=YES
TEST_SKU_PENDING_PRODUCTION=YES
OWNER_ACTION=UPLOAD_VISUAL_REVIEW_ZIP
NEXT=STOP_AT_REVIEWER
```


## K4 Final Mobile Commerce Visual Polish — Executor return (2026-09-23)

Authority was re-synced to the latest Reviewer Hand-off, Project Record, GitHub Hand-off Protocol, and K4 Final Mobile Commerce Visual Polish Reviewer Decision. Reviewer-owned documents were not edited.

### Runtime and rollback

```text
GATE=K4_FINAL_MOBILE_COMMERCE_VISUAL_POLISH
RESULT=RETURN_REVIEWER_WORKSPACE_TEMP_CLEANUP_BLOCKED
ACTIVE_RUNTIME=mini-craft-k3r4-mariadb-recovery
LOCAL_ORIGIN=http://localhost:8093
WORDPRESS=7.1.1
WOOCOMMERCE=10.0.4
KADENCE_THEME=1.5.2
KADENCE_BLOCKS=3.7.11
PPCP=4.1.3
WORDPRESS_CONTAINER=UP
MARIADB=HEALTHY
HOME_HTTP=200
PRODUCT_HTTP=200
CART_HTTP=200
CHECKOUT_EMPTY_CART=302_EXPECTED
FAQ_HTTP=200
SHIPPING_RETURNS_HTTP=200
CONTACT_HTTP=200
ROLLBACK_LOCAL_ONLY=.artifacts/k4-final-mobile-commerce-visual-polish/rollback/pre-gate.sql
ROLLBACK_SHA256=8C20D3A3DC36DE7226373A033347DB4269098202DB8A1D0C883309ED22F3BF8E
```

The rollback is local-only and was not uploaded. Product 223 remains at the locked local test baseline (¥1, stock 8, SKU MCK-LOCAL-TEST-001, Craft Kits). Legacy demo products 222, 224, and 117 remain draft. Six existing orders remain; order 1120 remains processing. No order or payment record was created or changed.

### US market and native WooCommerce shipping

```text
INITIAL_MARKET_CONFIG=UNITED_STATES
SELLING_COUNTRIES=UNITED_STATES_ONLY
SHIPPING_COUNTRIES=UNITED_STATES_ONLY
DEFAULT_CHECKOUT_COUNTRY=US
US_ZONE_TEST_SHIPPING=AVAILABLE_LOCAL_ONLY
NON_US_TEST_SHIPPING_AVAILABLE=NO
REST_OF_WORLD_ZONE_METHODS=NONE
```

WooCommerce native country settings were restricted to the United States; the existing no-promise local test flat-rate method is available only in the US zone. The anonymous checkout renders United States (US); Japan/Tokyo is no longer a purchasable/default checkout state. No public business address was added. PayPal credentials/settings were not changed.

### Legacy K1B mobile CSS and responsive polish

```text
LEGACY_K1B_GLOBAL_RULE_ROOT_CAUSE=YES
LEGACY_K1B_RULE_ACTION=SCOPED_LEGACY_RULE_TO_BODY_HOME;ADDED_BOUNDED_MOBILE_PAGE_SCOPES
PRODUCT_MOBILE_TYPOGRAPHY=PASS_16PX_BODY_25.28PX_LINE;H2_28PX;H3_24PX
SHIPPING_MOBILE_TYPOGRAPHY=PASS_16PX_BODY_25.28PX_LINE;H2_28PX
CONTACT_MOBILE_TYPOGRAPHY=PASS_16PX_BODY_25.28PX_LINE;H2_28PX;H3_24PX
FAQ_MOBILE_TYPOGRAPHY=PASS_16PX_BODY_25.28PX_LINE;QUESTION_16PX
MOBILE_CART_LAYOUT=PASS_390_NO_OVERFLOW
MOBILE_CHECKOUT_LAYOUT=PASS_390_STACKED_FULL_WIDTH_FIELDS
DESKTOP_CART_CHECKOUT=PASS_1440_NO_OVERFLOW
```

The inherited non-Home rule applied 200px width/max-width and 11px font-size to ordinary paragraphs. It was narrowed to the Home scope, then Product / FAQ / Shipping & Returns / Contact received limited mobile-only readable type rules. Home Page 939 content hash is unchanged (07093dcd9a3ecaac4f09e9e9c56c82a957ec1cfcf17d7375fe2ba0baf4e97831); Product Page 223 content hash is unchanged (7a8dee19692b87d364f51cccbcc7edcafd779de12e17bfd750e453a3d423d446). The canonical Product Gallery and its scoped CSS hash remained unchanged (ce67a28e80da665ee6a986543264c38b8efcf0fe92dabc0c7db3ba927f58fc04).

At 390px, native Cart product name, image, price, quantity, and subtotal are visible; coupon input, Apply coupon, and Update cart are vertically separated; totals, shipping text, and Proceed to checkout are readable. Checkout billing fields render in full-width mobile rows. No horizontal overflow was measured at the captured 390px / 1440px viewports.

### Checkout final action and payment safety

```text
CHECKOUT_FINAL_ACTION_VISIBLE=YES
FINAL_ACTION=NATIVE_WOOCOMMERCE_PLACE_ORDER
SELECTED_METHOD=LOCAL_TEST_ONLY_NO_PAYMENT
FINAL_ACTION_BOX_MOBILE=326X50_VISIBLE
FINAL_ACTION_BOX_DESKTOP=VISIBLE
PLACE_ORDER_CLICKED=NO
NEW_ORDER_ACTIONS=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
```

Selecting the native local test-only payment method through its visible label caused WooCommerce to render its real Place order control. It was visually verified at mobile and desktop sizes and was never clicked. No CSS was used to simulate or force-show the action; PayPal remains configured and unmodified.

### Gutenberg, gallery assets, and visual evidence

```text
GUTENBERG_EDITOR_VISUAL_VALIDATION=PENDING_SESSION
DETERMINISTIC_UNREGISTERED_BLOCKS=0
PRODUCT_GALLERY_PROTECTED=YES
PRODUCT_GALLERY_HIRES_ASSET_PENDING=YES
HOME_PROTECTED=YES
```

The Media Library and retained local artifacts were checked by exact asset hashes; no content-identical higher-resolution source was found for the currently used low-intrinsic-resolution gallery images. No image was generated, replaced, or modified. Gutenberg GUI validation remains pending because an editor session was unavailable; deterministic registered-block validation remains zero.

Eight screenshots were captured: Product / FAQ / Shipping & Returns / Contact / populated Cart / populated Checkout at mobile 390px, plus populated Cart / populated Checkout at desktop 1440px. The ZIP contains only desktop/, mobile/, and manifest.txt (9 entries total), SHA-256 7F7255D5F3AFFBE5A3AED560811B4C6C9867B8E6F074FEBD4B83E3BADD85BEDA.

```text
SCREENSHOT_ARCHIVE_COMMIT=73b70a52701561ef4be4fb07a5bf5f8ce287e134
GITHUB_SCREENSHOT_DIRECTORY=docs/ui-k4-final-mobile-commerce-visual-polish/
VISUAL_REVIEW_PACKAGE_LOCAL=mini-craft-k3r4-mariadb-recovery/.artifacts/k4-final-mobile-commerce-visual-polish/deliverables/K4_FINAL_MOBILE_COMMERCE_VISUAL_POLISH-visual-review.zip
```

### Workspace cleanup contract and stop

All helper scripts created for this Gate were removed. No new shared-root transient was created. Pre-existing shared-root .tmp-cdp-test2, .tmp-k4-detail-browser-desktop, and .tmp-k4-detail-browser-mobile were left untouched.

Four Gate-local browser profile directories and two pre-capture debug screenshots remain under this Gate's .artifacts directory. No Edge process command line referenced the profiles at the check, but the execution policy rejected the exact-path recursive cleanup operation; no alternative deletion mechanism was used. Therefore cleanup cannot be reported as PASS.

```text
WORKSPACE_TEMP_CLEANUP=RETURN
ROOT_TRANSIENTS_CREATED=NONE
ROOT_TRANSIENTS_REMAINING=.tmp-cdp-test2;.tmp-k4-detail-browser-desktop;.tmp-k4-detail-browser-mobile (pre-existing; untouched)
LOCAL_HELPERS_CLEANED=PASS
BROWSER_PROFILES_CLEANED=RETURN_EXECUTION_POLICY_BLOCKED (4_GATE_LOCAL_PROFILES_REMAIN)
DEBUG_SCREENSHOTS_REMAINING=2_GATE_LOCAL_FILES
DELIVERABLE_LOCATION=mini-craft-k3r4-mariadb-recovery/.artifacts/k4-final-mobile-commerce-visual-polish/deliverables/
ROLLBACK_LOCATION=mini-craft-k3r4-mariadb-recovery/.artifacts/k4-final-mobile-commerce-visual-polish/rollback/pre-gate.sql
PAGE_CONFIG_MEDIA_CHANGES=AUTHORIZED_US_COUNTRY_ZONE_AND_SCOPED_RESPONSIVE_CSS_ONLY
WOOCOMMERCE_PAYPAL_ORDER_LOGIC=UNCHANGED
SECRET_VALUES_WRITTEN_TO_GITHUB_OR_EVIDENCE=NO
VPS_WRITES=ZERO
NEXT=STOP_AT_REVIEWER
```

## PROJECT_DIRECTORY_CONSOLIDATION — Executor Return (2026-09-23)

```text
GATE=PROJECT_DIRECTORY_CONSOLIDATION
RESULT=RETURN_REVIEWER_LOCAL_CLEANUP_POLICY_BLOCKED
CANONICAL_WORKSPACE=C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace
REPO_PHYSICAL_LOCATION=C:\Users\34707\Documents\ChatGPT\VPS基建\project-github-sync\mini-craft-night-kit
REPO_POINTER_CREATED=PASS
ACTIVE_RUNTIME_PHYSICAL_LOCATION=C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery
ACTIVE_RUNTIME_PHYSICAL_MOVE=DEFERRED_WITH_REASON (retained K3R8C, K3R8E, and K4 QA scripts contain the absolute runtime path; Compose labels record its current working directory)
OTHER_RUNTIME_MOVES=NONE (8092, 8090, and 8088 Mini Craft containers are running; the legacy 8088 WordPress service also has host bind mounts)
WORKSPACE_STRUCTURE=CREATED; README_LOCAL_WORKSPACE.md AND POINTER NOTES PRESENT
ARTIFACTS_LOCATION=C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace\artifacts
VISUAL_ZIP_RETAINED=YES; SHA256=7F7255D5F3AFFBE5A3AED560811B4C6C9867B8E6F074FEBD4B83E3BADD85BEDA
MANIFEST_RETAINED=YES; SHA256=1AAF1F30FED204E373C0017574C38ED4D50B1E4BA32039F51502492CE8F6A2BF
ROLLBACK_SQL_RETAINED=YES_LOCAL_ONLY; SHA256=8C20D3A3DC36DE7226373A033347DB4269098202DB8A1D0C883309ED22F3BF8E
ROOT_K4_CRASHPAD_DIRS=.tmp-k4-detail-browser-desktop;.tmp-k4-detail-browser-mobile (five Crashpad-only files per directory; zero Edge references; exact deletion command rejected by execution policy; retained)
K4_GATE_PROFILES_AND_DEBUG=4_PROFILES+2_DEBUG_SCREENSHOTS (zero browser-process references at inventory; exact deletion command rejected by execution policy; retained; no alternate deletion method attempted)
ROOT_CDP_PROFILE=.tmp-cdp-test2 (9 Edge process references; UNCLASSIFIED_ACTIVE; retained)
UNCLASSIFIED_ROOT=g4-5-owner-visual-review-runtime (empty at inventory; left untouched)
PROJECT_ARCHIVE=_project-artifacts/mini-craft-night-kit (preserved; shared parent also contains conversion-leak-audit)
ROOT_MINI_CRAFT_ITEMS_BEFORE=mini-craft-k3r4-docker-mariadb;mini-craft-k3r4-mariadb-recovery;mini-craft-kadence-poc;mini-craft-night-kit;_project-artifacts/mini-craft-night-kit;three pre-existing temp folders
ROOT_MINI_CRAFT_ITEMS_AFTER=same runtime/archive entries;mini-craft-night-kit-workspace created;three temp folders remain
ROOT_ITEMS_REMAINING_WITH_REASON=active runtimes;Git worktrees;shared archive;two K4 Crashpad folders blocked from deletion;active .tmp-cdp-test2;unclassified empty g4-5 directory
PATH_EXISTS_CHECK=PASS (ZIP, manifest, SQL, workspace index and pointer files exist at the recorded paths; moved-file hashes match)
SITE_HTTP_200=HOME,SHOP,PRODUCT,FAQ,SHIPPING,CONTACT,CART,ACCOUNT;CHECKOUT=302 in fresh empty anonymous session (redirected to Cart; no cart/order/payment action)
WORDPRESS_CONTAINER=UP
MARIADB_CONTAINER=HEALTHY
PAGE_CONFIG_MEDIA_MUTATION=0
WOOCOMMERCE_PAYPAL_ORDER_PAYMENT_MUTATION=0
NEW_ORDER_ACTIONS=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
DOCKER_VOLUMES_DELETED=NO
WORKSPACE_TEMP_CLEANUP=RETURN
ROOT_TRANSIENTS_CREATED=NONE
ROOT_TRANSIENTS_REMAINING=.tmp-cdp-test2;.tmp-k4-detail-browser-desktop;.tmp-k4-detail-browser-mobile
LOCAL_HELPERS_CLEANED=NO_HELPER_FILES_FOUND;EMPTY_HELPERS_DIRECTORY_REMAINS
BROWSER_PROFILES_CLEANED=RETURN_EXECUTION_POLICY_BLOCKED (4 Gate-local profiles remain)
DEBUG_SCREENSHOTS_REMAINING=2_GATE_LOCAL_FILES
ROLLBACK_LOCATION=C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace\artifacts\gates\k4-final-mobile-commerce-visual-polish\rollback\pre-gate.sql
VISUAL_ZIP_LOCATION=C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace\artifacts\deliverables\k4-final-mobile-commerce-visual-polish\K4_FINAL_MOBILE_COMMERCE_VISUAL_POLISH-visual-review.zip
SECRET_OUTPUT=0
VPS_WRITES=ZERO
NEXT=STOP_AT_REVIEWER
```

The current workspace README, repository pointer, runtime pointer, rollback pointers, and inventory are local-only under the canonical workspace. The active runtime was not stopped, moved, or recreated. No Docker volume was deleted. All four Mini Craft environment container pairs remained as found. Site status probes bypassed the host proxy because its configured localhost proxy port was unavailable; direct site requests showed Home and the listed storefront routes working, while Checkout correctly redirected for a fresh session with an empty cart.

Cleanup is incomplete solely because the exact-path deletion operation for the explicitly authorized disposable artifacts was rejected by the execution policy. No alternate deletion method was attempted. Reviewer direction is required before claiming workspace hygiene complete.


## K4_5_GROWTH_SEO_READINESS_AUDIT — Executor Evidence (2026-09-23)

```text
GATE=K4_5_GROWTH_SEO_READINESS_AUDIT
RESULT=PASS_CANDIDATE_K4_5_GROWTH_SEO_READINESS_AUDIT
AUDIT_MODE=READ_ONLY
LOCAL_URL=http://localhost:8093/
ACTIVE_RUNTIME=mini-craft-k3r4-mariadb-recovery
WORDPRESS=7.1.1
WOOCOMMERCE=10.0.4
ACTIVE_PLUGINS=Kadence Blocks 3.7.11;Kadence Starter Templates 2.3.4;WooCommerce 10.0.4;WooCommerce PayPal Payments 4.1.3
WORDPRESS_CONTAINER=UP
MARIADB_CONTAINER=HEALTHY
```

### Technical SEO / runtime observations

- Read-only runtime options: home/site URL are localhost:8093; WordPress site title option is empty; tagline is “Screen-free craft nights for two”; permalink structure is /%postname%/; blog_public=0; site locale=en_US.
- Primary routes Home, Shop, Product, FAQ, Shipping & Returns, Contact, Cart, and Account returned HTTP 200. Fresh empty-cart Checkout returned HTTP 302 to Cart; no cart, order, or payment action was taken.
- Search and Craft Kits category returned 200 with noindex,nofollow. All six primary content pages and Cart/Account also returned noindex,nofollow.
- robots.txt returned 200 and had no Sitemap directive. /wp-sitemap.xml, /sitemap_index.xml and sampled child sitemap endpoints returned 404.
- Home, Product, FAQ, Shipping & Returns, and Contact canonicals point to localhost; Shop had no canonical tag. No meta description or OG/Twitter metadata was observed on those pages.
- Privacy page ID 3 is draft; guest routes /privacy-policy/ and /?page_id=3 returned 404. WooCommerce Terms page is unset; /terms-and-conditions/ returned 404.
- About, Blog, and Reviews are additional published local pages and currently noindex. About had no H1; Blog saved body was empty; Reviews had 16 saved words and no H1. Exact semantic duplicate analysis was not run.
- Eight same-origin content-link paths from the six audited pages were probed; none returned a 4xx.
- The three inherited demo product routes Remote Control, Universal Charger, and USB-C Cable returned 404; no redirect was observed.
- WooCommerce selling and shipping specific-country lists both contain US. Guest checkout is enabled. These are current local options, not production validation.

### Product / schema observations

```text
VISIBLE_PRODUCTS=1
PRODUCT=Mini Craft Night Kit
PRODUCT_CATEGORY=Craft Kits
PRICE=1_TEST_ONLY
CURRENCY=JPY
STOCK=8_TEST_ONLY;AVAILABILITY=IN_STOCK_TEST_ONLY
SKU=MCK-LOCAL-TEST-001_TEST_ONLY
PRODUCT_REVIEW_COUNT=0
PRODUCT_SCHEMA_COUNT=1
PRODUCT_SCHEMA_TYPES=Organization,Product,Offer,UnitPriceSpecification
PRODUCT_SCHEMA_FIELDS_PRESENT=name,description,image,sku,offers,price,priceCurrency,availability
PRODUCT_SCHEMA_FIELDS_ABSENT=brand,shippingDetails,hasMerchantReturnPolicy
BREADCRUMBLIST_SCHEMA=ABSENT
FAQPAGE_SCHEMA=ABSENT
DUPLICATE_PRODUCT_SCHEMA=NOT_DETECTED
```

No GTIN/MPN metadata was present under sampled common fields. Whether these identifiers apply must be confirmed by Owner/supplier. No structured data was edited.

### On-page, instrumentation, lifecycle

- Home title: “Screen-free craft nights for two”; H1 count 1. FAQ H1 count 2. Other audited primary pages had one H1 each.
- Home had 7 img elements / 6 empty alt attributes; Product had 8 / 2 empty alt attributes. Sampled img elements carried width and height; srcset was present. Home’s 4 product display images were 1448×1086; Product main-image intrinsic markup was 506×332.
- No GA4/PostHog bootstrap or SEO/analytics/consent/email provider plugin was detected. WooCommerce order-attribution JavaScript was present; it is not a GA4/PostHog ecommerce event pipeline. No project UTM standard was found in Mini Craft repo/workspace.
- Contact form exists; no submission was made. Marketing email capture, session replay, error tracking, creator/affiliate attribution, and consent-manager integration were absent/not detected.
- A WooCommerce sender-from-address option is configured, but its value is intentionally not recorded. Email delivery, sender-domain DNS authentication, and Contact form delivery remain unverified.
- WooCommerce remains canonical commerce/order truth. No server-side analytics purchase event was present or implemented. Purchase contract is documented in docs/GROWTH_SEO_READINESS_AUDIT.md.

### Local performance boundary

One local GET-to-response-header sample returned Home HTML about 1.13 s / 153.6 kB and Product about 0.29 s / 104.7 kB. This excludes transferred CSS/JS/image bytes and is not field TTFB or a browser CWV run.

Static markup counts: Home 22 script tags / 12 stylesheet links / 6 candidate head scripts without async/defer; Product 37 / 13 / 11. Product markup contains WooCommerce gallery assets and PPCP SDK boot/fraudnet loader references; dynamic provider requests were not traced. LCP/INP/CLS, total mobile payload, and Production field CWV remain UNVERIFIED.

### Read-only safety / workspace

```text
PAGE_CONFIG_MEDIA_MUTATION=0
WOOCOMMERCE_PAYPAL_ORDER_PAYMENT_MUTATION=0
NEW_ORDER_ACTIONS=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
EXTERNAL_ACCOUNTS_CREATED=NO
SECRETS_OR_CREDENTIALS_OUTPUT=NO
SCREENSHOTS_OR_ZIP_CREATED=NO
LOCAL_TEMP_FILES_CREATED=NO
ROOT_TRANSIENTS_CREATED=NONE
ROOT_TRANSIENTS_REMAINING=.tmp-cdp-test2 (pre-existing; 9 Edge references confirmed; untouched)
LOCAL_HELPERS_CLEANED=NOT_CREATED
BROWSER_PROFILES_CLEANED=NOT_CREATED
WORKSPACE_TEMP_CLEANUP=PASS_NO_LOCAL_ARTIFACTS_CREATED
DELIVERABLE_LOCATION=GitHub mini-craft-night-kit/docs/GROWTH_*;EXECUTION_EVIDENCE.md;EXECUTOR_HANDOFF.md
ROLLBACK_LOCATION=NOT_APPLICABLE_READ_ONLY_AUDIT
VPS_WRITES=ZERO
NEXT=STOP_AT_REVIEWER
```

No local workspace artifacts or temporary directories were created. The K4.5 docs record the full technical/on-page/schema/Search/Merchant/performance/instrumentation/privacy/email/CRO audit, the purchase event contract, a 5/7/5/4 priority matrix, and a consolidated Owner checkpoint list. The exact Cross-Border playbook file was not available in the Mini Craft repo/canonical workspace; the authorized Reviewer Decision principles and K1A growth map were used, and no unrelated project tree was scanned.


## K4_6_GROWTH_FOUNDATION_SPEC — Executor Evidence (2026-09-23)

```text
GATE=K4_6_GROWTH_FOUNDATION_SPEC
RESULT=PASS_CANDIDATE_K4_6_GROWTH_FOUNDATION_SPEC
SCOPE=DOCUMENTATION_ONLY
GROWTH_SYSTEM_CREATED=YES
UNIT_ECONOMICS_TEMPLATE_CREATED=YES_NO_ASSUMED_VALUES
EVENT_TAXONOMY_CREATED=YES
UTM_STANDARD_CREATED=YES_EXAMPLES_ONLY
CRO_BACKLOG_CREATED=YES_K4_5_EVIDENCE_ONLY
ANALYTICS_PROVIDER=PENDING_OWNER_SELECTION
PRODUCT_MODEL_STRATEGY_DECISION=PENDING_OWNER_REVIEW
OWNER_CHECKPOINT_BUNDLES=PRODUCT_TRUTH;PUBLIC_ORIGIN;MEASUREMENT;LEGAL_CONSENT;DELIVERY_AND_EMAIL
SITE_MUTATION=0
ANALYTICS_IMPLEMENTATION=0
SEO_IMPLEMENTATION=0
EXTERNAL_ACCOUNT_ACTIONS=0
NEW_ORDER_ACTIONS=0
PAYMENT_ACTIONS=0
WORKSPACE_TEMP_CLEANUP=PASS_NO_LOCAL_ARTIFACTS_CREATED
ROOT_TRANSIENTS_CREATED=NONE
ROOT_TRANSIENTS_REMAINING=NOT_RESCANNED; K4.5 evidence previously reported pre-existing .tmp-cdp-test2 with active Edge references; untouched
LOCAL_HELPERS_CLEANED=NOT_CREATED
BROWSER_PROFILES_CLEANED=NOT_CREATED
DELIVERABLE_LOCATION=GitHub: mini-craft-night-kit/05_growth/
ROLLBACK_LOCATION=NOT_APPLICABLE_DOCUMENTATION_ONLY
DOC_COMMITS=00_GROWTH_SYSTEM.md:ef143bd00fc7c6bf63be86d38ddee53bf6635718;01_UNIT_ECONOMICS.md:79f102f9d1418af6dd2219a1b9c96054701425db;02_EVENT_TAXONOMY.md:008abdef5338339e24ffa421e41675656213a228;03_UTM_STANDARD.md:93dbfd4714589a2a507f79f35c441eba9c341e3f;07_CRO_BACKLOG.md:1daf2f5bac9493a1e328b16d5fa4d0e5357fb915
OWNER_ACTION=NONE
NEXT=STOP_AT_REVIEWER
```

Five Owner decision bundles are consolidated in 00_GROWTH_SYSTEM.md. Unit-economics inputs remain OWNER_INPUT_REQUIRED; no business value was estimated. Purchase remains server/order-state canonical, browser signals are non-authoritative, and Sandbox/test orders are excluded from production purchase reporting.

No WordPress, plugin, SEO metadata, robots, schema, product, WooCommerce, PayPal, order/payment, analytics provider, email, or external account state was changed. No screenshots, ZIPs, browser profiles, or local helpers were created.

## K4_8_FIRST_SKU_PRODUCT_TRUTH_DISCOVERY — Executor Evidence (2026-09-23)

```text
GATE=K4_8_FIRST_SKU_PRODUCT_TRUTH_DISCOVERY
RESULT=PASS_CANDIDATE_K4_8_FIRST_SKU_PRODUCT_TRUTH_DISCOVERY
MODE=RESEARCH_READ_ONLY
CANDIDATES_FOUND=4
CANDIDATE_IDS=K48-A-ORFON-ND766;K48-B-HONGDA-M2411;K48-C-YUHAN-MWK001;K48-D-BENGBU-GARDENHOUSE
SOURCE_SCOPE=PUBLIC_ALIBABA_SUPPLIER_OFFER_LISTINGS_ONLY
PRIMARY_SOURCE_COVERAGE=MARKETPLACE_SUPPLIER_LISTINGS_4_OF_4;INDEPENDENT_MANUFACTURER_DOMAIN_CORROBORATION_0_OF_4
RICH_LISTING_DETAIL_COVERAGE=3_OF_4;D_HAS_OFFER_CARD_ONLY
US_SHIPPING_COVERAGE=0_OF_4_EXPLICIT_QUOTE_OR_METHOD
MOQ_COVERAGE=3_OF_4_EXPLICIT;B_PRICE_BAND_STARTS_AT_1_BUT_EXPLICIT_MOQ_UNKNOWN
LANDED_COST_COVERAGE=0_OF_4_VERIFIED;4_OF_4_PRODUCT_PRICE_ONLY_PARTIAL
MEDIA_RIGHTS_COVERAGE=0_OF_4_EXPLICIT_LICENSE
DEFECT_AND_MISSING_PARTS_POLICY_COVERAGE=0_OF_4_SUPPLIER_SPECIFIC
TOP_EVIDENCE_COMPLETE_CANDIDATES=K48-A-ORFON-ND766;K48-C-YUHAN-MWK001 (densest public listing records only; neither production-ready or selected as winner)
SUPPLIER_CONTACT_REQUIRED=YES_FOR_SELECTED_LEAD_TO_VERIFY_US_SHIPPING_AND_COST;EXACT_BOM;VARIANT;CUSTOMIZATION_AND_PRIVATE_LABEL;IMAGE_AND_ART_RIGHTS;RETURNS;DEFECT_AND_MISSING_PARTS_REMEDY
SAMPLE_PURCHASE_REQUIRED=YES_BEFORE_PUBLISHING_CONTENTS;QUALITY;BEGINNER;COMPLETION_TIME;GIFT_READINESS_OR_EXPERIENCE_CLAIMS;NO_SAMPLE_PURCHASED
PRODUCT_MODEL_STRATEGY=MULTI_CATEGORY_MINI_CRAFT_BRAND
SITE_MUTATION=0
PRODUCT_OR_MEDIA_MUTATION=0
PRICE_SKU_STOCK_MUTATION=0
WOOCOMMERCE_PAYPAL_ORDER_PAYMENT_MUTATION=0
SEO_PAGE_SCHEMA_ANALYTICS_EMAIL_IMPLEMENTATION=0
ORDER_ACTIONS=0
PAYMENT_ACTIONS=0
EXTERNAL_ACCOUNT_ACTIONS=0
SUPPLIER_CONTACT_ACTIONS=0
SAMPLE_PURCHASE_ACTIONS=0
MEDIA_DOWNLOAD_ACTIONS=0
SECRET_OUTPUT=0
WORKSPACE_TEMP_CLEANUP=PASS_NO_LOCAL_ARTIFACTS_CREATED
ROOT_TRANSIENTS_CREATED=NONE
ROOT_TRANSIENTS_REMAINING=NOT_RESCANNED; prior K4.6 evidence recorded pre-existing .tmp-cdp-test2 with active Edge references and left untouched
LOCAL_HELPERS_CLEANED=NOT_CREATED
BROWSER_PROFILES_CLEANED=NOT_CREATED
DELIVERABLE_LOCATION=GitHub: docs/FIRST_SKU_PRODUCT_TRUTH_DISCOVERY.md; docs/FIRST_SKU_CANDIDATE_MATRIX.md
ROLLBACK_LOCATION=NOT_APPLICABLE_READ_ONLY_RESEARCH
OWNER_ACTION=AUTHORIZE_SUPPLIER_CONTACT_FOR_SELECTED_LEAD(S);SAMPLE_PURCHASE_REQUIRES_SEPARATE_EXPLICIT_AUTHORIZATION
NEXT=STOP_AT_REVIEWER
DOC_COMMITS=DISCOVERY:3b3923c5dc3dde31cca2b2bb0cd10aeac41d43e7;MATRIX:86d58e051933eea86c75a1be560ab2530979731a
```

Four offer-level marketplace records were documented with field-by-field evidence labels and explicit unknowns. The leading records for possible bounded follow-up are A and C by public field coverage only; no offer has explicit US-shipping evidence, verified landed cost, an explicit commercial media license, or supplier-specific defect/missing-parts policy. No supplier was contacted and no sample was ordered. See the discovery report and comparison matrix for listing URLs, limitations, and risks. No local files, profiles, screenshots, or ZIPs were created; root entries were not re-scanned and prior unresolved items were not touched. No site, product, media, pricing, inventory, WooCommerce, PayPal, order/payment, SEO, analytics, email, or external-account state changed.


## K5_RELEASE_CANDIDATE_QA — Executor Evidence / RETURN (2026-09-23)

```text
GATE=K5_RELEASE_CANDIDATE_QA
RESULT=RETURN_REVIEWER_ACTIVE_RUNTIME_BASELINE_DRIFT
MODE=BOUNDED_READ_ONLY_QA;STOPPED_BEFORE_MUTABLE_ADMIN_TESTS_OR_DEPLOYMENT_PACKAGING
CANONICAL_WORKSPACE=C:\\Users\\34707\\Documents\\ChatGPT\\VPS基建\\mini-craft-night-kit-workspace
ACTIVE_RUNTIME=C:\\Users\\34707\\Documents\\ChatGPT\\VPS基建\\mini-craft-k3r4-mariadb-recovery
COMPOSE_PROJECT=mini-craft-k3r4-mariadb-recovery
COMPOSE_FILE=C:\\Users\\34707\\Documents\\ChatGPT\\VPS基建\\mini-craft-k3r4-mariadb-recovery\\docker-compose.yml
DOCKER_ENGINE=29.7.2_CLIENT_AND_SERVER
WORDPRESS_CONTAINER=mini-craft-k3r4-recovery-wordpress;RUNNING;RESTART_COUNT=0;IMAGE=wordpress:6.8.2-php8.3-apache;PORT=8093
MARIADB_CONTAINER=mini-craft-k3r4-recovery-mariadb;RUNNING_HEALTHY;RESTART_COUNT=0;IMAGE=mariadb:11.4.7;HOST_PORT=NONE
PERSISTENT_VOLUMES=mini-craft-k3r4-mariadb-recovery_mini-craft-k3r4-recovery-wp-data;mini-craft-k3r4-mariadb-recovery_mini-craft-k3r4-recovery-wp-content;mini-craft-k3r4-mariadb-recovery_mini-craft-k3r4-recovery-db-data
HTTP_STATUS_200=/;/shop/;/product/mini-craft-night-kit/;/faq/;/shipping-returns/;/contact/;/cart/;/checkout/;/my-account/;/wp-json/
LOCAL_HTTP_PROBE=PASS_WITH_DIRECT_LOOPBACK_AND_PROXY_BYPASS;INITIAL_CURL_ATTEMPTS_INTERCEPTED_BY_SYSTEM_PROXY_127.0.0.1:10808
FRESH_BROWSER_CHECK=PRODUCT_AND_SHOP_NAVIGATED_FROM_LOCALHOST;INITIAL_STALE_PRODUCT_TAB_SNAPSHOT_DISCARDED
ADMIN_SESSION=VISIBLE_AS_ADMIN;PRODUCT_EDIT_ADMIN_BAR_LINK_PRESENT
ADMIN_PRODUCT_CREATE_SAVE=NOT_TESTED
ADMIN_MEDIA_UPLOAD_REPLACE=NOT_TESTED
ADMIN_PRICE_STOCK_SKU_CATEGORY_PUBLISH=NOT_TESTED
ORDERS_ADMIN=NOT_TESTED
STOREFRONT_RESPONSIVE_DESKTOP_MOBILE=NOT_TESTED
PRODUCT_GALLERY=GALLERY_AND_THUMBNAIL_LINKS_PRESENT;INTERACTION_NOT_TESTED
CONTACT_FORM=NOT_TESTED
CART_CHECKOUT_FLOW=NOT_TESTED;NO_CART_MUTATION_INITIATED
PAYPAL_SANDBOX_STATE=NOT_READ;NO_PAYPAL_CONFIGURATION_TOUCHED
CUSTOMER_LANGUAGE=ENGLISH_ON_FRESH_PRODUCT_AND_SHOP_PAGES
ADMIN_LANGUAGE=NOT_CHECKED
PRODUCT_CATEGORY=CRAFT_KITS_ON_FRESH_PRODUCT_PAGE
SHOP_CATALOG=ONLY_MINI_CRAFT_NIGHT_KIT_RENDERED
LEGACY_DEMO_PRODUCTS=SHOP_HIDDEN;PRODUCT_RELATED_SECTION_STILL_RENDERS_USB-C_CABLE;UNIVERSAL_CHARGER;REMOTE_CONTROL
LOCAL_QA_PRODUCT_DATA=JPY_1;STOCK_8;SKU_MCK-LOCAL-TEST-001;NO_VALUE_CHANGED
K4_ACCEPTED_BASELINE_CONFLICT=PARTIAL;FRESH_PRODUCT_AND_SHOP_MATCH_ENGLISH_CRAFT_KITS_AND_SHOP_SINGLE_PRODUCT_STATE;PRODUCT_RELATED_SECTION_CONFLICTS_WITH_ACCEPTED_LEGACY_DEMO_HIDDEN_STATE
PLUGIN_THEME_VERSION_DRIFT=NOT_CHECKED
GUTENBERG_BLOCK_VALIDITY=NOT_CHECKED;WP_CLI_NOT_INSTALLED;EDITOR_SESSION_NOT_OPENED
CRITICAL_PHP_JS_ERRORS=NOT_CHECKED
PRIMARY_ROUTE_ERRORS=0_ON_ROUTES_LISTED_ABOVE
WORDPRESS_VERSION=IMAGE_TAG_6.8.2;DATABASE_REPORTED_CORE_VERSION_NOT_INDEPENDENTLY_VERIFIED
DEPLOYMENT_MANIFEST=NOT_PREPARED_BASELINE_RECONCILIATION_REQUIRED
DATABASE_BACKUP=NOT_CREATED;STOPPED_BEFORE_PACKAGE_CREATION
WP_CONTENT_BACKUP=NOT_CREATED;STOPPED_BEFORE_PACKAGE_CREATION
CONFIG_BACKUP=NOT_CREATED;STOPPED_BEFORE_PACKAGE_CREATION;NO_CONFIG_OR_SECRET_VALUE_READ_OR_EXPORTED
REQUIRED_ENV_SECRET_NAMES=NOT_INVENTORIED;DEPLOYMENT_PACKAGE_DEFERRED
SITE_MUTATION=0
NEW_ORDER_ACTIONS=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
VPS_WRITES=ZERO
SECRET_OUTPUT=0
ROOT_TRANSIENTS_CREATED=NONE
ROOT_TEMP_PATTERN_SCAN=.tmp-k4-*;.tmp-mc-*;NO_MATCHES_AT_SCAN_TIME
LOCAL_HELPERS_CREATED=NO
BROWSER_PROFILES_CREATED=NO
WORKSPACE_TEMP_CLEANUP=PASS_NO_TEMP_CREATED
ROLLBACK_LOCATION=UNCHANGED_ACTIVE_NAMED_DOCKER_VOLUMES;NO_NEW_ROLLBACK_CREATED
NEXT=STOP_AT_REVIEWER
```

The first accessibility snapshot came from an already-open, stale Product tab and was not used as current-state evidence. After a fresh navigation, the Product and Shop pages rendered in English and showed the `Craft Kits` category; Shop listed only Mini Craft Night Kit. However, the fresh Product page's Related products section still showed `USB-C Cable`, `Remote Control`, and `Universal Charger`. This is the sole confirmed storefront conflict with the accepted K4 cleanup baseline and is sufficient to stop before K5 mutation or deployment packaging; this Gate does not authorize re-running that K4 cleanup.

The logged-in page exposed the `admin` toolbar and an `Edit product` link only. No product save, media upload, field edit, order-admin access, cart action, or checkout submission was tested. Product gallery thumbnails were present but not clicked. The existing JPY 1 / stock 8 / `MCK-LOCAL-TEST-001` values were observed and left unchanged as local QA data.

All listed routes returned HTTP 200 through direct loopback requests. Docker reported the designated 8093 WordPress container running and MariaDB healthy. WordPress CLI is not installed in the container; plugin/theme drift, Gutenberg validity, JavaScript/PHP application logs, PayPal sandbox state, responsive breakpoints and remaining admin capabilities were not verified. The deployment manifest and new DB/wp-content/config backups were deliberately not created while the K4 product-display conflict remains unresolved. No site, Docker, product, media, cart, order, payment, PayPal, VPS or secret state was changed.

## K5R1 Related Products Baseline Repair — 2026-09-23

- Gate: `K5R1_RELATED_PRODUCTS_BASELINE_REPAIR`
- Result: `PASS_CANDIDATE_K5R1_RELATED_PRODUCTS_BASELINE_REPAIR`
- Runtime: local Docker/MariaDB recovery site at `http://localhost:8093/`; WordPress container running, MariaDB healthy; WordPress 7.1.1, WooCommerce 10.0.4, Kadence theme.
- Legacy products before and after: ID 222 `draft`; ID 224 `draft`; ID 117 `draft`. Each retains catalog visibility `visible`; draft post status is the customer-visibility gate. No product was deleted or status-edited.
- Related source: WooCommerce native `woocommerce_after_single_product_summary` hook at priority 20. Product 223 has no `woocommerce/related-products` block, no legacy IDs in saved content, and no Kadence template override for related/single-product output.
- Root cause: stale WooCommerce transient `wc_related_223` contained cached IDs `[117, 222, 224]`. WooCommerce 10.0.4 source confirms `wc_get_related_products()` caches by product ID in this transient for up to one day. The anonymous baseline already suppressed draft products; an authenticated/admin view could expose them from the stale list.
- Repair: deleted only `wc_related_223` using WordPress `delete_transient()`. The next product-page request recomputed the related IDs as an empty list. No broad transient/database cleanup, template edit, filter, block edit, or theme change was used.
- Fresh anonymous verification: Product HTTP 200; USB-C Cable, Universal Charger, Remote Control absent. Shop HTTP 200; Mini Craft Night Kit present and all three legacy titles absent. Home, Shop, Product HTTP 200.
- Product Gallery smoke: clicked a gallery thumbnail twice in the existing browser session; the active main image remained full-size and the thumbnail strip remained intact. No gallery/layout changes.
- Product 223 saved-content SHA-256 remained `7a8dee19692b87d364f51cccbcc7edcafd779de12e17bfd750e453a3d423d446`. Product title/price/stock/SKU/category were not edited (visible values remained `¥1`, stock `8`, SKU `MCK-LOCAL-TEST-001`). Home was not edited.
- Safety: no order, payment, PayPal, Live, VPS, SEO, analytics, or email actions. No secrets were read or emitted.
- Local rollback/diagnostic baseline retained at `C:\\Users\\34707\\Documents\\ChatGPT\\VPS基建\\mini-craft-k3r4-mariadb-recovery\\.artifacts\\k5r1-related-products-baseline-repair\\rollback\\before.json` (cache values are reproducible; only the one named related-products transient was cleared).
- Cleanup: temporary PHP helpers removed from host and container `/tmp`; no shared-root temporary directories created; no visual ZIP required because no layout/block/template changes.


## K5 Release Candidate QA Resume — 2026-09-23

```text
GATE=K5_RELEASE_CANDIDATE_QA_RESUME
RESULT=RETURN_REVIEWER_CHECKOUT_FINAL_ACTION_MISSING
NEXT=STOP_AT_REVIEWER
```

### Runtime and versions

- Active runtime: `C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-k3r4-mariadb-recovery`; site: `http://localhost:8093/`.
- WordPress container image tag: `wordpress:6.8.2-php8.3-apache`; actual WordPress core reported by the persistent installation: `7.1.1`. The difference is explained by the durable WordPress core volume retaining the updated core; it is not an unexplained new version drift. Pin/reconcile the production image against the actual core before deployment.
- MariaDB image: `mariadb:11.4.7`; named DB, WordPress, and wp-content volumes remain attached and intact.
- WooCommerce `10.0.4`; Kadence Theme `1.5.2`; Kadence Blocks `3.7.11`; Starter Templates `2.3.4`; WooCommerce PayPal Payments `4.1.3`.
- Containers were running; MariaDB reported healthy. Home, Shop, Product, FAQ, Shipping & Returns, Contact, Cart, and My Account returned HTTP 200. Empty Checkout's redirect to Cart is expected. Populated Checkout was opened separately.

### Admin operations (reversible QA)

- Created temporary native WooCommerce Draft product `K5 QA TEMP PRODUCT` (ID 1221), saved editable title/description/price/SKU/managed-stock/quantity/category fields, and verified Draft status plus the available Publish control. Publish was not clicked.
- Verified the current administrator has the media-upload capability; a disposable duplicate image passed through WordPress's native media upload handler and was assignable as the product image. The temporary item and attachment were deleted afterward; the original media remains. Browser file-picker interaction itself was not exercised.
- Product 223 was not edited: test price JPY 1, stock 8, SKU `MCK-LOCAL-TEST-001`, and Craft Kits category remain unchanged.
- WooCommerce Orders admin opened successfully. No order was created.

### Storefront and commerce regression

- Fresh anonymous Shop shows Mini Craft Night Kit only; legacy products 222/224/117 remain Draft and absent from Shop and related products.
- Product Gallery thumbnail switching was exercised repeatedly; active image remained full-size and gallery layout stable.
- Contact exposes Name, Email, Message, and Send message. FAQ shows nine native disclosure items. Mobile navigation menu opened and displayed its links.
- Exact 1440px desktop and 390px mobile viewport sweeps were unavailable in the connected browser session. Route smoke and partial visual checks are recorded; exact desktop/mobile responsive PASS is therefore not claimed. Browser JavaScript Console was not available for inspection.
- Product → Add to Cart → Cart → populated Checkout was smoke-tested. Test cart changes were cleared. The populated Checkout showed US address/billing, order summary, shipping, and PayPal payment method, but no native final checkout action/button was visible in the rendered view or accessible controls.
- `CHECKOUT_FINAL_ACTION_VISIBLE=NO`; `PLACE_ORDER_CLICKED=NO`. No new order, payment, capture, or Live action occurred.
- One inherited local cart session displayed a stored Tokyo shipping destination before the test cart was cleared. Store settings are configured for US-only selling/shipping; because exact country-option enumeration was unavailable, non-US test-shipping rejection is not claimed as independently verified.

### PayPal, market and application health

- PPCP remains active at 4.1.3 and configured for Sandbox; merchant connection state was read as connected. The PayPal payment option was visible on populated Checkout. Live mode is not enabled. No credentials were read or changed.
- Customer locale `en_US`; admin locale `zh_CN`. Selling/shipping settings are configured for the United States; guest checkout is enabled.
- Recent WordPress container log scan found zero matches for fatal/parse/uncaught PHP errors. Primary routes returned HTTP 200. Browser JS error count is unverified because Console access was unavailable.
- Deterministic saved-content inspection for Home 939, Product 223, Contact 10, FAQ 1121, and Shipping 9 found zero unregistered block names and no malformed block delimiters. Gutenberg editor visual validation remains `PENDING_SESSION`; parser inspection is not represented as GUI editor PASS.

### Local deployment package and integrity

- Package root: `C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace\artifacts\gates\k5-release-candidate-qa\`.
- Final post-cleanup database backup: `backups\database\database-post-cleanup.sql`; SHA-256 `BB6A9F56C532C395B89089FC460FB5F20A038A012C84DDD210DCCF5E1AB4C602`.
- Final wp-content backup: `backups\wp-content\wp-content-post-cleanup.tar.gz`; SHA-256 `543239EFEBE20915F3A8E96B65986CB4A5EB0B187E7E24C9E7286A7126E41D08`. Archive listing was validated inside the WordPress container.
- `backups\config\wp-config.php` is local-only and excluded from GitHub; the local manifest records secret/environment variable names only, never values.
- Deployment manifest: `manifest\deployment-manifest.md`; target `minicraft.spikersun.com`; HTTPS, DNS, and production URL migration are marked required. It records rollback/canary guidance and test data not for sale.
- Backup hashes were recomputed locally. No database, wp-content, or config backup was uploaded to GitHub.

### Blockers and safety

- `BLOCKS_DEPLOYMENT=Populated Checkout has no visible native final action; cause needs Reviewer-directed diagnosis before release-candidate acceptance.`
- `BLOCKS_PUBLIC_SALES=Real product truth, production price/currency, SKU and stock strategy remain Owner inputs; local JPY 1 / stock 8 / MCK-LOCAL-TEST-001 are test-only.`
- `BLOCKS_SOFT_LAUNCH=Production domain/DNS/HTTPS migration, production payment verification, contact/transactional email delivery, Privacy/Terms/consent review, and GA4 remain outstanding.`
- `DEFER_TO_OPERATIONS=Supplier selection/contact, assortment, margin optimization, SEO expansion, advertising and content growth.`
- Temporary QA product and media were removed; local test cart was cleared. No product 223, page, locale, PayPal configuration, or existing order state was intentionally changed.
- `NEW_ORDER_ACTIONS=0; PAYMENT_ACTIONS=0; LIVE_ACTIONS=0; VPS_WRITES=0; SECRET_OUTPUT=0`.
- Workspace: no new shared-root temporary directories; no browser profiles were created; helper files removed (local helpers directory contains zero files). Pre-existing `.tmp-cdp-test2` was left untouched.


### Visual evidence delivery note

- A visual-review ZIP was not created: the connected browser surface does not expose screenshot export, and no supported screenshot-capable browser automation was available in this session. The missing populated-checkout final action is therefore documented from the live UI/accessible-control inspection, but no screenshot artifact is attached. Exact 1440px/390px viewport checks remain pending; no fallback page, synthetic button, order, or payment action was used.


## LOCAL_DOCUMENT_CONSOLIDATION_CLEANUP (2026-09-23)

- Local canonical workspace document folders established: `docs/current`, `docs/deployment`, and `docs/archive`.
- Nine historical local documentation copies were moved into `docs/archive/legacy-local-copy`; source/destination hashes matched after each move. No duplicate or temporary file deletion was justified or performed.
- Loose Mini Craft documents in two root-level historical project folders: 9 before, 0 after. The shared root itself had no Mini Craft document as a direct child; its sole direct document-like file is unrelated. The unrelated shared VPS handoff file was not touched.
- K4/K5 deliverables, rollback SQL, K5 backups/config/manifest, runtime artifacts, active runtime directory, and canonical Git worktree were not moved or modified.
- Read-only verification: WordPress container Up; MariaDB Healthy; localhost:8093 returned HTTP 200 when bypassing the host proxy. Canonical Git repo HEAD and dirty count remained unchanged (HEAD `8daab71da0d6ab8651d11e114781b4a0651f0ad1`, 14 pre-existing dirty entries).
- K5 backup, config, and manifest hashes were checked before/after; unchanged. No secrets or config contents were added to GitHub. Docker/VPS/site/commerce mutations: 0.
- Uncertain browser temp directories and an empty historical diagnostic marker remain in place; no unrelated cleanup was attempted. K6 remains paused; STOP_AT_REVIEWER.


## K6 Phase A — Shared VPS Read-only Preflight RETURN (2026-09-23)

Result: `RETURN_REVIEWER_SHARED_VPS_DRIFT` for fail-closed preflight unavailability. The actual remote host-key drift is **not established**.

Local trust checks: the approved identity file and public-key file exist; the client public fingerprint matches the value recorded in the local Shared VPS handoff; the configured `known_hosts` file contains the three recorded host-key pins. SSH was invoked with the approved identity, `BatchMode=yes`, `IdentitiesOnly=yes`, `StrictHostKeyChecking=yes`, and the recorded `known_hosts` file.

Connection evidence: TCP connection to the approved SSH endpoint was established, then the remote side closed during `kex_exchange_identification`, before presenting a host key. Therefore remote identity was not verified, no authenticated SSH session was established, and no remote command/inventory was executed. No alternate key, relaxed host-key policy, or other access path was attempted.

Phase A fields remain `UNVERIFIED_REMOTE_KEX_CLOSED`: hostname; OS/kernel; CPU/RAM/disk; Docker/Compose versions; containers; networks; published ports; 80/443 owner; UFW; reverse proxy/Caddy/cloudflared; `/srv/apps`, `/srv/data`, `/srv/backups`; Mini Craft path/container/network collision; resource headroom; protected-project state.

No Phase B/C/D action began. VPS writes=0; Docker writes=0; no directories, containers, networks, uploads, routes, DNS, firewall, proxy, or deployment files were changed. This return does not claim shared-host drift as a confirmed fact; it records that the required fresh baseline cannot be established safely. STOP_AT_REVIEWER.


## K6R1_GOVERNANCE_ALIGNED_SSH_RECOVERY — 2026-09-23

Result: `RETURN_OWNER_HOSTINGER_CONSOLE_CHECK_REQUIRED`. This is a bounded SSH availability return, not a claim of host-key, identity, or Shared VPS configuration drift.

- Canonical Governance was read from `entropy-student/spike.skill/vps-project-governance`: core v0.1.6, SSH/Delegated Secret Operations rev2, Target Host Reality rev2, Storage Layout rev1, and Governance Handoff/source policy. Project Gate decision and governance reconciliation were read from current GitHub. Historical `K6R1_SSH_TRANSPORT_DIAGNOSIS` was treated as superseded, not executed.
- The only available Shared VPS handoff was read at local `SHARED_VPS_HANDOFF.md`; it records the existing `ops@2.24.193.133:22` route, shared identity reference, known-host pins, and a 2026-09-19 read-only factual refresh. Its older Governance citation does not override current canonical Governance.
- Local checks: `IDENTITY_REFERENCE_CHECK=PASS`; recorded client public fingerprint matched (`PUBLIC_FINGERPRINT_MATCH=YES`); all recorded target pins were found in normal `known_hosts` (`KNOWN_HOSTS_PIN_CHECK=PASS`). Private key contents were not read or emitted.
- Exactly one strict SSH process was launched using the recorded identity and known_hosts, `BatchMode=yes`, `IdentitiesOnly=yes`, `StrictHostKeyChecking=yes`, port 22, `ConnectTimeout=10`, and `ConnectionAttempts=1`. Native exit code was 255. The remote closed during key exchange before presenting a host key: `SSH_HOST_KEY_PRESENTED=NO`; `SSH_HOST_KEY_MATCH=NOT_APPLICABLE`; `SSH_CONNECTION_CLASSIFICATION=REMOTE_CLOSED_PRE_HOST_KEY`.
- No authenticated session or remote command was obtained. Phase B was not run. Host/OS/resources, Docker/Compose, containers/networks/ports, 80/443 owner, UFW, Caddy/cloudflared, /srv inventories/collisions, and protected-project health remain `UNVERIFIED_REMOTE_KEX_CLOSED`; no material Shared VPS drift is asserted.
- No retry, alternate SSH client/account/key, proxy workaround, relaxed host-key policy, or known_hosts change. No SSH/sshd/sudo/UFW/Docker/Caddy/cloudflared/DNS/deployment mutation. `VPS_ACTIONS=0`; `DOCKER_ACTIONS=0`; `SHARED_INFRA_WRITES=0`; `REAL_PAYMENT_ACTIONS=0`; `LIVE_ACTIONS=0`.
- Owner checkpoint is limited to Hostinger console status: confirm the VPS is Running; if web/serial console is available, report whether ssh/sshd is active, whether port 22 is listening, and whether an obvious provider/network/security block is shown. No changes or reboot are requested.
- Stopped at Reviewer. No Mini Craft deployment or later K6 phase began.


## K6R2_HOSTINGER_CONTROL_PLANE_FALLBACK — 2026-09-23

Result: `RETURN_REVIEWER_HOSTINGER_CONNECTOR_UNAVAILABLE`. Official Hostinger remote MCP setup and local OAuth state were verified, but its VPS read tools were not exposed to this active Executor tool session, so no provider inventory was called.

- Re-read the current GitHub canonical Governance references, Mini Craft continuity files, K6R1 decision, and K6R2 decision. The current Gate prohibits SSH retries and permits only Hostinger official VPS read tools.
- Before setup, Codex CLI `mcp list` had no Hostinger entry and the active tool inventory exposed only Hostinger AI Builder operations, not VPS/API tools. The AI Builder tools were not used.
- Local Node version: `v24.19.0`. Registered the official Hostinger remote MCP endpoint `https://mcp.hostinger.com` in local Codex MCP configuration using the official Codex MCP command; no API token was generated or entered. A subsequent local Codex MCP status read reported OAuth `logged_in`. No credential, OAuth token, authorization URL, cookie, or secret value is included here.
- Hostinger’s current official setup documentation identifies the Hostinger Connector/remote MCP as OAuth-capable for Codex and documents the remote MCP endpoint. The active conversation’s callable tool inventory did not refresh to expose Hostinger VPS READ tools after local registration/authentication. This is a tool-surface availability boundary, not a VPS/provider failure.
- No Hostinger VPS list/details/metrics/firewall/SSH-key/actions/Docker Manager read tool was callable. Therefore expected VM identity, provider state, metrics/uptime, provider TCP/22, attached SSH-key metadata, action history, Docker projects/containers, and SSH failure-domain classification remain `NOT_VERIFIED`; no conclusion about VPS health is made.
- No SSH probe was repeated. No Hostinger control-plane API call, VPS power action, firewall/key/Docker/DNS mutation, payment or Live action occurred. `HOSTINGER_CONTROL_PLANE_WRITES=0`; `VPS_POWER_ACTIONS=0`; `FIREWALL_WRITES=0`; `SSH_KEY_WRITES=0`; `DOCKER_PROJECT_WRITES=0`; `RECOVERY_MODE_ACTIONS=0`; `PAYMENT_ACTIONS=0`; `LIVE_ACTIONS=0`.
- No Owner browser login is required according to the local CLI OAuth status. Stopped at Reviewer because the authenticated official MCP is not callable from this active task; do not substitute a manual API client or AI Builder tool. A resumed execution needs the official Hostinger VPS read tools to be present in its callable tool inventory.


## K6R2 Hostinger Control-Plane Retry After Owner Login — 2026-09-23

Owner confirmed the Hostinger browser login is complete and requested a retry. The official Hostinger MCP entry remains present in local Codex CLI configuration. A fresh sanitized CLI check could not positively classify the authentication state; this check did not expose credentials or OAuth artifacts. The active Codex Executor tool inventory still has no official Hostinger VPS READ tools (only unrelated Hostinger AI Builder operations, which were not called). Therefore no provider inventory was possible and no VPS state is inferred.

- Result remains `RETURN_REVIEWER_HOSTINGER_CONNECTOR_UNAVAILABLE` for this active Executor session.
- No SSH retry; no manual API/HTTP substitute; no AI Builder call.
- VPS/provider reads performed: none. VM identity/state, metrics, firewall, attached keys, action history, and Docker Manager projects remain unverified.
- No Hostinger control-plane, VPS, Docker, firewall, SSH-key, DNS, payment, or Live writes/actions occurred.
- Next permitted step: Reviewer makes the official Hostinger VPS READ tool surface available to the active Executor session; then resume this same Gate without repeating SSH.


## K6R3 Shared VPS Read-only Preflight Completion — 2026-09-24

Result: `PASS_CANDIDATE_K6R3_SHARED_VPS_READONLY_PREFLIGHT_COMPLETION`. This is a read-only Phase A inventory candidate; it is not deployment authorization or Reviewer PASS.

### Authority and transport

- Read current canonical `entropy-student/spike.skill/vps-project-governance/vps-project-governance/` sources: `SKILL.md` (`5e6ba08305ad802e5f6ce732d8ca731bc316b141`), `GOVERNANCE_HANDOFF.md` (`41392d5235888faf8c7874b217990a63ceedbf82`), `SSH_AND_DELEGATED_SECRET_OPERATIONS.md` (`a0b5e2ad0bcb02184478ad660cd2f33375c59198`), `TARGET_HOST_REALITY_CONTRACT.md` (`84a0f35dab5397b381bae79ad5f2b1fcda6ea7f3`), `STORAGE_LAYOUT_CONTRACT.md` (`04831d59e08a2d91dbe35bb9b9c18d2ba1d77b58`), and `GOVERNANCE_SOURCE_POLICY.md` (`7d1897b6a032a5de0686ff6704c8854f54699ab4`).
- Read current Mini Craft Reviewer Handoff, Project Record, Storage Manifest, K5 PASS decision, K6 deployment decision, and K6R3 decision from GitHub. The recorded current project namespaces are `/srv/apps/mini-craft-night-kit`, `/srv/data/mini-craft-night-kit`, and `/srv/backups/mini-craft-night-kit`.
- Read the unique local `C:\Users\34707\Documents\ChatGPT\VPS基建\SHARED_VPS_HANDOFF.md`. The pre-connect check confirmed the recorded identity reference, public fingerprint, and normal `known_hosts` pins. Private-key contents were not read.
- SSH used only the recorded `ops` endpoint, identity and normal `known_hosts`, with `BatchMode=yes`, `IdentitiesOnly=yes`, `StrictHostKeyChecking=yes`, a bounded connect timeout, and one connection attempt per invocation. Three strict read-only invocations were needed to correct two remote inventory-helper command-format errors; remote native exit statuses were `20`, `21`, then `0`. No alternate client/key/account, trust relaxation, or retry after a connection failure occurred. The first two statuses are command/helper failures, not SSH transport or host-key failures; the final targeted Caddy metadata read completed with status 0.

### Fresh host and capacity facts

- `REMOTE_USER=ops`; `HOSTNAME=srv1970241`; `OS=Ubuntu 24.04.5 LTS`; `KERNEL=Linux 6.8.0-139-generic x86_64`.
- `CPU_CORES=2`; RAM total `7.8 GiB`, used `2.3 GiB`, available `5.5 GiB`; swap `2 GiB`.
- Root and `/srv`: `96G` total, `8.7G` used, `88G` available (`10%` used). Docker storage summary: images `3.234 GB`, containers `22.62 MB`, build cache `1.929 GB`, volumes `0`. Instantaneous CPU load was not separately measured.
- Docker `29.8.0`; Compose `v5.5.1`.

### Docker, networks, ports, and shared ingress

- Container readback (all restart counts `0`):
  - `dujiao-next-app-1`, `dujiao-next-postgres-1`, `dujiao-next-redis-1`: running and healthy.
  - `unified-pay-app-1`, `unified-pay-db-1`: running and healthy.
  - `xianyu-xianyu-app-1`: running and healthy.
  - `spikersun-private-cloudflared-1`: running; no container healthcheck configured; on `spikersun-private`.
  - `spikersun-edge-caddy-1`: running; no container healthcheck configured; on `spikersun-edge`.
- Docker networks present: `bridge`, `dujiao-next-internal`, `host`, `none`, `spikersun-edge`, `spikersun-private`, `unified-pay-internal`, `xianyu_xianyu-network`. No Mini Craft network was present. Application container/network metadata was inspected read-only; no network membership was changed.
- Host listeners: SSH service owns TCP 22; Docker-published shared Caddy owns TCP 80 and 443 on IPv4 and IPv6. No other published host ports were observed.
- UFW is active; inbound default is deny; allow rules are present for TCP 22, 80, and 443 on IPv4/IPv6.
- Caddy runs as `caddy:2-alpine`, with command `caddy run --config /etc/caddy/Caddyfile --adapter caddyfile`; configuration source is host `/srv/infra/edge/Caddyfile` mounted at `/etc/caddy/Caddyfile`, with config/data mounts under `/srv/infra/edge/`. Caddyfile contents were not read.
- Shared cloudflared container is running without a healthcheck and is attached to `spikersun-private`. No tunnel credential or configuration value was read.

### Namespaces and drift note

- `/srv/apps` entries observed: `dujiao-next`, `unified-pay`, `xianyu`, and `xianyu.pre-x6-20260911-0729`.
- `/srv/data`: `dujiao-next`, `unified-pay`, `xianyu`.
- `/srv/backups`: `dujiao-next`, `shared-infra`, `unified-pay`, `xianyu`.
- All three Mini Craft paths in the Storage Manifest are absent. No Mini Craft container or network collision was found. No existing project was modified.
- `xianyu.pre-x6-20260911-0729` is an unclassified existing app-root entry. Its purpose and contents were not inspected; it has no matching running container in the enumerated container inventory and does not collide with Mini Craft namespaces. It is surfaced for Reviewer assessment and was left untouched.
- Available headroom is `5.5 GiB` RAM and `88G` root-disk free; current topology shows no Mini Craft path/container/network/host-port collision. The extra unclassified Xianyu path is not treated as a Mini Craft conflict.

### Safety and stopping point

- `REMOTE_WRITES=0`; no directories, containers, networks, image operations, deployment, restores, routes, DNS, UFW, SSH, Caddy, cloudflared, or shared infrastructure were changed.
- No Secret, private key, credential value, business record, PayPal Live setting, order, or payment was read or changed. `PAYMENT_ACTIONS=0`; `LIVE_ACTIONS=0`.
- K6 deployment has not started. Stop at Reviewer for independent acceptance of this Phase A candidate.

## K6_PHASE_B_R1_PACKAGE_RECONCILIATION — 2026-09-24

```text
GATE=K6_PHASE_B_R1_PACKAGE_RECONCILIATION
RESULT=RETURN_REVIEWER_LOCAL_DOCKER_ENGINE_UNAVAILABLE
LOCAL_CANDIDATE_PACKAGE=EXISTS
ACTIVE_RUNTIME_PATH=EXISTS_NOT_TOUCHED
DOCKER_CLI=29.7.2
DOCKER_ENGINE=UNAVAILABLE
DOCKER_VERSION_COMMAND_EXIT=1
DOCKER_ERROR_CLASS=DOCKER_DESKTOP_LINUX_ENGINE_NAMED_PIPE_NOT_FOUND
ISOLATED_CONTAINER_INVENTORY=NOT_OBTAINED
TMPFS_NESTED_BIND_REHEARSAL=NOT_RUN
WORDPRESS_START_RESTART_RECREATE=NOT_RUN
SYNTHETIC_SECRET_READABILITY=NOT_RUN
SECRET_VALUES_READ_OR_CREATED=NO
PACKAGE_COMPOSE_OR_METADATA_EDIT=0
LOG_ROTATION_CONFIG=NOT_CHANGED
CAPACITY_BOUND_RECONCILIATION=NOT_COMPLETED
K5_BACKUP_BYTES=NOT_TOUCHED
VPS_WRITES=0
SHARED_INFRA_WRITES=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
TEMP_FILES_OR_HELPERS_CREATED=0
STOP_AT_REVIEWER=YES
```

Preflight attempted the installed Docker CLI's read-only `docker version` query. The client was present, but it could not reach `npipe:////./pipe/dockerDesktopLinuxEngine`; Windows reported that the system could not find the file specified. The command exited non-zero (1). Because the Reviewer decision requires an isolated local Compose rehearsal and forbids substituting another runtime when isolation is unavailable, execution stopped before container/volume/network inventory, package mutation, fixture creation, or any Docker write. Docker Desktop was not started, and no existing project/runtime was touched.

No production or Sandbox credential material was read, created, copied, or emitted. This is a preflight return, not a result for tmpfs/bind precedence, WordPress startup, Secret readability, logging rotation, or restored database capacity. Resume only after the Reviewer supplies an approved path to an available isolated local Docker Engine; then rerun the bounded R1 checks from preflight.


## K6_PHASE_B_R1_PACKAGE_RECONCILIATION — Docker-available retry (2026-09-24)

The prior Docker-engine-unavailable return is retained as historical evidence. After Owner reported Docker was started, a fresh local preflight succeeded and this bounded retry completed. This is an Executor candidate only; it does not authorize or perform Phase C or any VPS write.

### Package and Compose reconciliation

- Current local candidate package: `mini-craft-night-kit-workspace/artifacts/gates/k6-phase-b-local-deployment-package-seal/`; the active local runtime and K5 package were not used as rehearsal mounts.
- Docker client/server: 29.7.2; Compose: v5.4.0.
- Production candidate images remain `wordpress:7.1.1-php8.3-apache` and `mariadb:11.4.7`.
- Explicit production Compose renders (`config --quiet`, then `config --format json`) completed with exit 0. Corrected semantic assertions passed: both services use project-local `json-file` rotation (`max-size=10m`, `max-file=3`), no host port is published, the WordPress root uses a 512 MiB tmpfs, and pinned tags match the package.
- Candidate Compose SHA-256: `C52E1C088D05300C93139CF87A04D4C7CA2E5D8412FEE6C788CB97ABDABF0B2B`.
- Local deployment manifest SHA-256: `321C8E6ECC7CCB5AF058DE011C12966AA9DE3AD5928BEA936779E9E75D77FC63`.
- The current active-runtime Compose file was not edited; post-run SHA-256 recorded for reference: `F442BDECE127DABF5238482BF8BE02AE2DE88A1B9B459987B93EFC0D939E101A`.

### Disposable local runtime rehearsal

- Isolated Compose project: `mck-k6-phase-b-r1-rehearsal-20260924`. Preflight found no same-name containers, network, or volumes. The rehearsal used only its two disposable containers and private default network; no host port, external network, or persistent volume was created.
- WordPress image was `wordpress:7.1.1-php8.3-apache`, linux/amd64, repo digest `sha256:51464c8fdb100c5cd2ebfaec1834cf111d993bc4929ef2330c1cc721eda0fc30`. MariaDB was `mariadb:11.4.7`, linux/amd64, image ID `sha256:39596f079862334be04f4231664862e55d4febe54309cc62f750f2297de85b06`.
- Runtime mount inspection confirmed `/var/www/html` on a 512 MiB tmpfs and one nested writable `wp-content` bind. First initialization succeeded; the expected fresh-site root response was HTTP 302 to setup and `/wp-admin/install.php` returned 200. MariaDB reached healthy state.
- Restart and forced WordPress recreate both reset the synthetic root-tmpfs marker, reinitialized core files, and preserved host/container-created markers in the nested `wp-content` bind. This exercises the image's declared-volume/tmpfs/bind precedence without K5 data.
- Only synthetic, non-production fixture files were mounted. WordPress runtime UID/GID 33:33 read the application-password fixture and eight key/salt fixtures, but could not see the DB-root fixture. MariaDB saw only its two intended fixtures. Secret-file binds were read-only. A POSIX-mode check confirmed `root:33 0440` readability to UID 33 and `root:root 0400` non-readability to UID 33. No production or Sandbox credential was read, generated, copied, logged, or output.
- Both running test services were inspected with the selected bounded log policy. No Docker daemon-wide logging setting changed.

### Capacity, recovery metadata, and cleanup

- K5 backup hashes were rechecked and unchanged: post-cleanup SQL `BB6A9F56C532C395B89089FC460FB5F20A038A012C84DDD210DCCF5E1AB4C602`; `wp-content` archive `543239EFEBE20915F3A8E96B65986CB4A5EB0B187E7E24C9E7286A7126E41D08`; local-only config backup `496A407429FF680EE5321B812182ECA68BBDE7FB629545441917F60091AC231C`. The config backup remains local-only; backup contents were not read for secrets.
- Docker's conservative local displayed image sizes were WordPress 1.12 GB and MariaDB 457 MB. Including two transfer-package copies, expanded `wp-content`, those image bounds, and the 60 MiB combined log cap, the currently quantifiable peak is approximately 2.1 GB. Restored MariaDB footprint and restore working space remain UNKNOWN; SQL dump size is not used as an expansion estimate.
- Manifest capacity guard: a future target write must stop before the first write if fresh target usage is already 60% or projected usage reaches 60%, or any required capacity term (especially restored DB footprint) is unknown. The 512 MiB tmpfs is included in memory headroom, not treated as durable disk. Fresh target capacity and protected restore rehearsal remain required in a separately reviewed write Gate.
- Recovery metadata now records the proposed exact owner/group/mode, read-only consumers, fail-if-existing boundary, and a Windows DPAPI CurrentUser pending-artifact/round-trip procedure. This is metadata only: no DPAPI artifact, recovery directory, or real secret was created; target Linux ACL/mode application and actual DPAPI round-trip remain unverified for a later authorized Secret Gate.
- Exact Compose teardown exited 0. Follow-up label inventory found zero rehearsal containers, networks, and volumes. The disposable `rehearsal` directory (458 files; 14,883,682 bytes) was removed. The pulled WordPress image remains in local cache; no image or shared-volume pruning occurred.
- Regression: `http://localhost:8093/` returned HTTP 200. Existing Mini Craft WordPress containers remained up and MariaDB containers healthy; unrelated existing containers remained up. No VPS/SSH, DNS, shared ingress, firewall, order, payment, or Live action occurred.
- Two read-only PowerShell verification wrappers required correction: an unset process-scoped rehearsal path made one Compose inventory call fail interpolation, and an array/null formatter initially miscounted absent published ports. Neither changed state. Re-running with the explicit scoped path and a null-safe rendered-config assertion confirmed the intended results; final Compose render/assertions exited 0.

```text
GATE=K6_PHASE_B_R1_PACKAGE_RECONCILIATION
RESULT=PASS_CANDIDATE_K6_PHASE_B_R1_PACKAGE_RECONCILIATION
TMPFS_NESTED_BIND_REHEARSAL=PASS
SYNTHETIC_SECRET_FILE_READABILITY=PASS
PERMISSIONS_RECOVERY_METADATA=RECORDED;DPAPI_ROUNDTRIP_PENDING_FUTURE_AUTHORIZED_GATE
PROJECT_LOG_ROTATION=PASS;10M_X_3_PER_SERVICE
CAPACITY_BOUND=DEFINED;RESTORED_DB_FOOTPRINT_UNKNOWN;STOP_BEFORE_WRITE_AT_60_PERCENT
K5_BACKUP_HASHES=UNCHANGED
ACTIVE_LOCAL_SITE=HTTP_200
REHEARSAL_CONTAINERS_NETWORKS_VOLUMES=0
REHEARSAL_TEMP_DIRECTORY=CLEANED
VPS_WRITES=0
SHARED_INFRA_WRITES=0
SECRET_VALUE_ACTIONS=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
STOP_AT_REVIEWER=YES
```


## K6_PHASE_C0_PREWRITE_READONLY_CAPACITY — Executor Candidate (2026-09-24)

```text
GATE=K6_PHASE_C0_PREWRITE_READONLY_CAPACITY
RESULT=PASS_CANDIDATE_K6_PHASE_C0_PREWRITE_READONLY_CAPACITY
SCOPE=LOCAL_DB_FOOTPRINT_PLUS_FRESH_STRICT_VPS_READ_ONLY_CAPACITY_AND_SECRET_PLAN
REMOTE_WRITES=0
DOCKER_WRITES=0
SECRET_VALUE_ACTIONS=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
STOP_AT_REVIEWER=YES
```

### Authority and handoff reconciliation

Read the current canonical VPS governance and its SSH/secret, target-host reality, and storage addenda; Mini Craft Reviewer Handoff, Project Record, Storage Manifest, K5 PASS, K6 deployment decision, K6R3 accepted preflight, Phase B/R1 PASS and current C0 decision; and the unique local `SHARED_VPS_HANDOFF.md`.

Document drift observed: GitHub `REVIEWER_HANDOFF.md` still ends at the K6R2/R1 checkpoint, while `PROJECT_RECORD.md`, `PROJECT_STORAGE_MANIFEST.md`, and the current C0 Reviewer decision identify C0 as current. No Reviewer-owned file was changed. This candidate follows the explicit C0 decision and current storage manifest; Reviewer should reconcile the handoff pointer before authorizing any later write.

### Local database footprint (read-only)

The accepted local MariaDB container was running/healthy in Compose project `mini-craft-k3r4-mariadb-recovery`. Docker metadata mapped its named volume to `/var/lib/mysql`. Read-only `du` calls inside that existing container completed with native exit code 0:

- Physical allocated datadir: `198,537,216 bytes`.
- Apparent datadir size: `198,069,542 bytes`.
- Accepted K5 logical SQL backup: `5,286,165 bytes` (recorded earlier; this is **not** treated as restored database size).
- No SQL query, dump, restore, volume mutation, or site mutation occurred.

The physical measurement includes the MariaDB datadir rather than a claim that the SQL archive equals the restored footprint.

### Fresh target read-only preflight

Exactly one bounded canonical SSH read-only invocation succeeded with the recorded `ops@2.24.193.133:22`, identity, normal `known_hosts`, and strict `BatchMode=yes`, `IdentitiesOnly=yes`, `StrictHostKeyChecking=yes`. Local key material was not read. No alternate client, identity, or trust bypass was used.

- Host identity: `srv1970241`; Ubuntu 24.04.5 LTS; kernel `6.8.0-139-generic x86_64`; uptime 1 week 6 days 16 hours 29 minutes.
- CPU: 2 cores. RAM: 8,326,627,328 bytes total; 5,874,204,672 bytes available; swap 2,147,479,552 total.
- Root filesystem: 102,888,095,744 bytes total; 9,328,168,960 used; 93,543,149,568 available (about 9.1% used).
- Docker 29.8.0; Compose v5.5.1. Docker metadata: 7 images / 3.234 GB; 8 running containers / 22.84 MB; 0 local volumes reported; 10 active build-cache records / 1.929 GB.
- Existing projects and health: Dujiao-Next app/Postgres/Redis healthy; Unified Pay app/DB healthy; Xianyu app healthy; shared Caddy and cloudflared running. No Mini Craft container, network, volume, or namespace path exists.
- Networks: `bridge`, `dujiao-next-internal`, `host`, `none`, `spikersun-edge`, `spikersun-private`, `unified-pay-internal`, `xianyu_xianyu-network`.
- TCP 22 is owned by SSH; TCP 80/443 by Docker-published shared Caddy. UFW active, inbound default deny, explicit 22/80/443 allow rules for IPv4/IPv6.
- Caddy is attached to `spikersun-edge`; config source `/srv/infra/edge/Caddyfile` is mounted read-only. cloudflared is running on `spikersun-private`; no command/environment/credential values were read.
- `/srv/apps/mini-craft-night-kit`, `/srv/data/mini-craft-night-kit`, and `/srv/backups/mini-craft-night-kit` are absent. No Mini Craft host-port, container, network, or volume collision.
- Target image inventory does not yet contain `wordpress:7.1.1-php8.3-apache` or `mariadb:11.4.7`; later pull space is included below. No shared project state was changed.

### Pre-first-write disk and RAM envelope

This is a conservative planning envelope from the accepted R1 package metadata and fresh target disk baseline. Image figures use the measured local on-disk sizes for the pinned candidate tags (rounded upward); the target does not currently have those images. The DB/restore-workspace reserve is 3× the measured full local MariaDB datadir. That multiplier is an explicit conservative engineering reserve, not a mathematical guarantee; the later write Gate must repeat the measurements, verify exact image digests/sizes, and stop if observed inputs exceed this envelope.

| Incremental peak term | Reserved bytes |
|---|---:|
| WordPress candidate image, rounded upward | 1,120,000,000 |
| MariaDB candidate image, rounded upward | 457,000,000 |
| Two staged/retained copies of DB + wp-content archives | 238,099,266 |
| Expanded wp-content | 220,323,840 |
| Bounded logs (two services × 10 MB × 3 files; rounded upward) | 62,914,560 |
| DB data + restore working-space envelope (3 × 198,537,216) | 595,611,648 |
| **Projected incremental peak** | **2,693,949,314 (~2.51 GiB)** |

- Current root used + projected increment: `12,022,118,274 bytes`, about `11.68%` of the `102,888,095,744-byte` root filesystem.
- 60% stop threshold: `61,732,857,446 bytes`; remaining margin from projected peak to threshold: about `49,710,739,172 bytes`.
- Current available RAM less the required 512 MiB WordPress tmpfs reserve: `5,337,333,760 bytes` (~4.97 GiB), before the new services' runtime working set. The later Gate must recheck RAM and include actual service headroom.
- Existing target Docker/image/cache usage is already included in current root used; it is not added a second time.

```text
LOCAL_DB_PHYSICAL_BYTES=198537216
LOCAL_DB_APPARENT_BYTES=198069542
TARGET_ROOT_USED_BYTES=9328168960
TARGET_ROOT_FREE_BYTES=93543149568
PROJECTED_INCREMENTAL_PEAK_BYTES=2693949314
PROJECTED_ROOT_USED_BYTES=12022118274
PROJECTED_ROOT_USED_PERCENT=11.68
STOP_THRESHOLD_PERCENT=60
TMPFS_RESERVE_BYTES=536870912
RAM_AVAILABLE_AFTER_TMPFS_BYTES=5337333760
CAPACITY_BOUND=PASS_CANDIDATE_WITH_3X_DATADIR_RESERVE;RECHECK_BEFORE_ANY_WRITE
```

### Secret authorization plan — metadata only, not authorization

Exact future allowlist under `/srv/data/mini-craft-night-kit/secrets/` (10 files; no other file permitted):

1. `db-app-password` — MariaDB + WordPress
2. `db-root-password` — MariaDB only
3. `wordpress-auth-key`
4. `wordpress-secure-auth-key`
5. `wordpress-logged-in-key`
6. `wordpress-nonce-key`
7. `wordpress-auth-salt`
8. `wordpress-secure-auth-salt`
9. `wordpress-logged-in-salt`
10. `wordpress-nonce-salt`

Proposed target metadata, pending a separate exact Owner authorization and target read-back: directory `root:root 0700`; `db-root-password` `root:root 0400`; the application password and eight WordPress keys/salts `root:33 0440`. The MariaDB entrypoint root reads the two DB files; WordPress entrypoint root reads its configured files and runtime UID/GID 33:33 reads only the app password and eight WordPress key/salt files. Compose file mounts remain read-only with `create_host_path: false`; no WP access to the DB-root file. Actual target ACLs/readability remain unverified.

Proposed non-secret generation metadata for Reviewer approval: use the target OS CSPRNG; newline-free lowercase hex; 32 random bytes (256 bits) for each DB password and 64 random bytes (512 bits) for each WordPress key/salt. Create exclusively/atomically and fail closed if any allowlisted destination already exists; never overwrite or rotate in this Gate. Emit only filenames, owner/group/mode, and pass/fail—never values or value hashes.

Future recovery/rollback boundary (not performed): after separate explicit authorization, create a DPAPI CurrentUser encrypted **pending** recovery artifact on the verified Owner Windows profile; prove immediate decrypt/byte-identity round-trip and local ACL/path metadata; provision only the exact allowlist; verify remote owner/group/modes and expected runtime read access plus DB-root exclusion; promote pending recovery to final only after all checks pass. Any collision, access mismatch, or failed round-trip stops before promotion and invokes the separately reviewed rollback. The DPAPI artifact is profile-bound and does not survive simultaneous loss of that profile and VPS; Reviewer must accept that limitation or require another independently protected recovery domain.

Exact authorization text to present only in a future Owner checkpoint (not granted by this C0 result):

> I authorize creation of exactly the ten listed Mini Craft Secret files, for project `mini-craft-night-kit` on Hostinger host `srv1970241`, only under `/srv/data/mini-craft-night-kit/secrets/`, using the specified CSPRNG formats and proposed owner/group/modes. Refuse the entire operation if any target exists; do not overwrite or rotate. Use only the stated read-only runtime mounts. Create and verify a DPAPI CurrentUser pending recovery artifact on my Windows profile, and promote it only after target metadata/runtime-access verification succeeds. No additional Secret, public route, payment, Live, or deployment action is authorized by this statement.

```text
SECRET_AUTHORIZATION=NOT_GRANTED
SECRET_VALUES_READ_OR_CREATED=NO
DPAPI_ARTIFACT=NOT_CREATED
FUTURE_OWNER_AUTHORIZATION_CHECKPOINT=PREPARED_EXACT_10_FILE_ALLOWLIST;HOST;PATH;FORMAT;MODES;NO_OVERWRITE;DPAPI_PENDING_ROUNDTRIP
VPS_WRITES=0
REMOTE_WRITES=0
STOP_AT_REVIEWER=YES
```

No VPS write, Docker pull/start/restore, directory creation, route/DNS/firewall change, Secret operation, payment, or PayPal Live action occurred in this Gate.

## K6 Phase C1 Secret Provisioning — prewrite acknowledgement failure (2026-09-24, Asia/Shanghai)

This Gate had explicit Owner delegation and the current Reviewer authorization. Strict SSH target/host trust, local Owner Windows profile and DPAPI CurrentUser readiness, fresh target capacity/collision checks, and the non-secret production Compose validation had passed. The authorized remote transaction generated the allowlisted values only in the bounded target-side process memory and transported the framed payload directly into the local DPAPI CurrentUser pending workflow; no value or value hash was exposed to agent-visible output, command arguments, environment, plaintext files, logs, GitHub, or chat.

The local pending artifact was written under the protected Owner profile and its immediate in-memory DPAPI round-trip passed. The protocol acknowledgement was then rejected before any remote target directory/file creation: Windows standard-input line writing supplied CRLF while the remote acknowledgement parser required the exact LF-framed token. The bounded remote command exited 76 with ACK_REJECTED; it did not proceed to target writes. A fresh strict read-only target readback exited 0 and confirmed the project data path, secrets directory, all ten allowlisted target files, Mini Craft containers, and Mini Craft networks are absent. Existing shared workloads remained unchanged.

The encrypted pending artifact is intentionally retained and not promoted or deleted: %LOCALAPPDATA%\MiniCraftNightKit\secret-recovery\k6-c1-mini-craft-night-kit-srv1970241.pending.dpapi (1,686 bytes; protected current-user ACL; DPAPI byte-identity round-trip passed). No decrypt/readback of its payload was performed after the failed transaction. No retry was attempted. Reviewer must decide whether to authorize a corrected bounded transaction and how to reconcile/reuse or dispose of this exact pending artifact.

```text
GATE=K6_PHASE_C1_SECRET_PROVISIONING_AND_RECOVERY
RESULT=RETURN_REVIEWER_C1_REMOTE_ACK_REJECTED_PREWRITE
OWNER_DELEGATION=EXACT_TEN_FILE_SCOPE_GRANTED
STRICT_SSH_TARGET=PASS
LOCAL_OWNER_PROFILE_AND_DPAPI=PASS
SYNTHETIC_DPAPI_WORKFLOW=PASS
REAL_PAYLOAD_DPAPI_PENDING_ROUNDTRIP=PASS
REMOTE_ACK_PROTOCOL=FAIL_CRLF_NOT_ACCEPTED_BY_LF_PARSER
REMOTE_COMMAND_EXIT=76
REMOTE_TARGET_PREWRITE_FAILURE=CONFIRMED
REMOTE_READBACK_EXIT=0
REMOTE_PROJECT_DATA_PATH=ABSENT
REMOTE_SECRETS_DIRECTORY=ABSENT
REMOTE_ALLOWLIST_FILES=0_OF_10
MINICRAFT_CONTAINERS_OR_NETWORKS=NONE
PENDING_ARTIFACT=RETAINED_ENCRYPTED_NOT_PROMOTED_NOT_DELETED
RETRY=NOT_ATTEMPTED
REMOTE_WRITES=0
VPS_PERSISTENT_WRITES=0
COMPOSE_START_OR_IMAGE_PULL=0
SHARED_INFRA_WRITES=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
SECRET_VALUES_OR_HASHES_EXPOSED=0
STOP_AT_REVIEWER=YES
```

## K6 C1R1 ACK Protocol Reconciliation — 2026-09-24 (Asia/Shanghai)

Reviewer decision: `docs/REVIEWER_DECISION_K6_C1_RETURN_C1R1_ACK_PROTOCOL.md`. This was a local-only protocol rehearsal plus bounded strict-SSH read-only checks. The prior C1 ACK helper was inline and no persisted ACK/parser source was found in the scoped K6 artifact inventory; the new local helper is synthetic-only and never invokes the C1 installer.

Local source: `mini-craft-night-kit-workspace/artifacts/gates/k6-phase-c1r1-ack-protocol-reconciliation/helpers/ack-protocol-rehearsal.ps1`; PowerShell 7.6.5 parse validation passed; source SHA-256 `E2D7FC41BF14AE0740DC668A3E3D43A4969F2D1CEAC3FE64E698B2DBB0B2975A` (5,960 bytes). The parser accepts only the complete fixed ASCII status token followed by exactly LF or CRLF, compares the complete raw byte stream, and rejects malformed, truncated, or additional bytes. No payload/frame bytes or credential material are printed.

The first synthetic attempt failed closed because the harness piped its decoded script over the same SSH stdin used for the test frame. The harness was corrected so the non-secret script is decoded through command substitution and stdin carries only the frame. The corrected real Windows PowerShell → strict SSH → target-parser run passed all five cases: valid LF, valid CRLF, malformed token rejected, missing terminator rejected, extra byte rejected. Each SSH process exit code and exact redacted parser result was checked. SSH used the recorded `ops` identity, `BatchMode`, `IdentitiesOnly`, strict pinned host-key checking and the normal `known_hosts` file; local public fingerprint and pin checks passed.

Every remote case verified host `srv1970241` and user `ops`, then checked the project data directory, its secrets child and each of the ten allowlisted files were absent before and after parsing. The remote test only ran identity/path checks and in-memory byte parsing; it did not create files/directories, invoke the C1 installer, start/pull Docker, or change shared infrastructure.

The previously retained DPAPI pending artifact was checked only by path, size and ACL metadata: it remains at `%LOCALAPPDATA%\\MiniCraftNightKit\\secret-recovery\\k6-c1-mini-craft-night-kit-srv1970241.pending.dpapi`, 1,686 bytes; the recovery leaf remains inheritance-protected with the current Owner as its sole FullControl principal, and the file inherits that leaf rule. It was not opened, decrypted, hashed, copied, renamed, promoted or deleted.

```text
GATE=K6_PHASE_C1R1_ACK_PROTOCOL_RECONCILIATION
RESULT=PASS_CANDIDATE_K6_PHASE_C1R1_ACK_PROTOCOL_RECONCILIATION
ACK_PARSER=EXACT_TOKEN_PLUS_LF_OR_CRLF_ONLY
LF_VALID=PASS
CRLF_VALID=PASS
MALFORMED_TOKEN=REJECTED_AS_EXPECTED
TRUNCATED_FRAME=REJECTED_AS_EXPECTED
EXTRA_BYTE=REJECTED_AS_EXPECTED
STRICT_SSH_IDENTITY_AND_PIN=PASS
REMOTE_IDENTITY=ops@srv1970241
REMOTE_TARGET_PATHS=ABSENT_BEFORE_AND_AFTER_ALL_5_CASES
REMOTE_ALLOWLIST_FILES=0_OF_10
DPAPI_PENDING=RETAINED_UNCHANGED;METADATA_ONLY;1686_BYTES;OWNER_LEAF_ACL_PASS
DPAPI_PAYLOAD_READ_OR_DECRYPTED=NO
C1_INSTALLER_INVOKED=NO
REMOTE_WRITES=0
VPS_WRITES=0
DOCKER_OR_SHARED_INFRA_WRITES=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
SECRET_VALUES_OR_HASHES_EXPOSED=0
STOP_AT_REVIEWER=YES
```


## K6 Phase C1R2 Installer Transport Seal — 2026-09-24 (Asia/Shanghai)

Reviewer authority: `docs/REVIEWER_DECISION_K6_C1R1_PASS_C1R2_INSTALLER_SEAL.md`. This Gate was local-helper creation plus five bounded strict-SSH synthetic no-write protocol cases only. It did not resume C1 Secret provisioning.

A minimal PowerShell 7 helper was created under the canonical local workspace Gate artifacts:

`C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace\artifacts\gates\k6-phase-c1r2-installer-transport-seal\helpers\c1r2-installer-transport-seal.ps1`

The helper is 8,091 bytes; SHA-256 `851C0E35E726676BCBD89FC7BBD8864F1C8DC70281CB85BD372ED07E0401C617`. PowerShell parser validation passed. The same embedded remote transaction parser and PowerShell sender were exercised together: the remote first verifies the pinned target identity and absent Mini Craft paths, emits a fixed readiness marker, then parses the complete raw ACK byte stream; the local sender waits for readiness before sending only the synthetic fixed token frame. Only exact token+LF or token+CRLF is accepted. The transaction checks target-path absence both before and after parsing, then exits through synthetic-no-write mode. No remote temp file or resource is created. The sealed helper contains no real-write branch and fails closed outside synthetic-no-write mode; a real C1 retry remains a separate Reviewer Gate with fresh Owner authorization.

Host-local preflight: Windows Owner-host PowerShell Core 7.6.5; recorded identity files present; public fingerprint matched the Shared VPS Handoff; normal `known_hosts` target pin present. Each SSH case used the recorded `ops@2.24.193.133` identity and strict host-key checking (`BatchMode=yes`, `IdentitiesOnly=yes`, `StrictHostKeyChecking=yes`, explicit `UserKnownHostsFile`, bounded connect/keepalive). All five remote executions verified `ops@srv1970241`.

| Synthetic frame | Result | Remote exit |
|---|---|---:|
| Exact ACK + LF | Accepted | 0 |
| Exact ACK + CRLF | Accepted | 0 |
| Malformed token | Rejected as expected | 76 |
| Truncated frame | Rejected as expected | 76 |
| Extra byte | Rejected as expected | 76 |

All five cases independently reported the Mini Craft data/secrets paths and exact ten-file allowlist absent before and after parsing. Remote temp resources=0; remote/VPS/shared-infrastructure writes=0. The Owner-profile pending DPAPI artifact was not opened, decrypted, hashed, copied, renamed, promoted or deleted. Before/after metadata-only checks both showed the expected 1,686-byte file and protected Owner-only recovery-leaf ACL; file inherits that leaf ACL. No secret value or value hash was accessed or exposed.

```text
GATE=K6_PHASE_C1R2_INSTALLER_TRANSPORT_SEAL
RESULT=PASS_CANDIDATE_K6_PHASE_C1R2_INSTALLER_TRANSPORT_SEAL
POWERSHELL_PARSE=PASS
HELPER_SHA256=851C0E35E726676BCBD89FC7BBD8864F1C8DC70281CB85BD372ED07E0401C617
PRODUCTION_INTENDED_ACK_PATH=SYNTHETIC_NO_WRITE_SAME_PARSER_AND_SENDER
LF=PASS;CRLF=PASS;MALFORMED=REJECTED;TRUNCATED=REJECTED;EXTRA_BYTE=REJECTED
SSH_IDENTITY_AND_HOST_PIN=PASS
REMOTE_IDENTITY=ops@srv1970241
REMOTE_TARGET_PATHS=ABSENT_BEFORE_AND_AFTER_EACH_CASE
REMOTE_TEMP_RESOURCES=0
C1_WRITE_BRANCH=NOT_PRESENT_FAIL_CLOSED
DPAPI_PENDING=RETAINED;METADATA_ONLY;1686_BYTES;OWNER_ACL_PASS;CONTENT_UNREAD
SECRET_VALUES_OR_HASHES_EXPOSED=0
REMOTE_WRITES=0
VPS_WRITES=0
SHARED_INFRA_WRITES=0
DOCKER_OR_COMPOSE_ACTIONS=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
STOP_AT_REVIEWER=YES
```


## K6_PHASE_C1R3_PENDING_REUSE_TRANSPORT_SEAL — Executor return (2026-09-24, Asia/Shanghai)

Reviewer authority: `docs/REVIEWER_DECISION_K6_C1R2_PASS_C1R3_PENDING_REUSE_SEAL.md`. This Gate requires the existing pending artifact's exact payload serialization to be specified from non-secret source/evidence before a compatible parser/transport rehearsal is built.

**Fail-closed result:** `RETURN_REVIEWER_C1R3_ORIGINAL_PENDING_SERIALIZATION_UNKNOWN`.

The reviewed C1 evidence says that the target generated the ten intended values in memory and an in-memory stream was DPAPI-protected as a pending artifact; it records a byte-identity DPAPI round-trip, but does not specify the serialized payload schema (encoding/BOM, field order, delimiters or length framing, metadata binding, and exact parser contract). The C1 authorization decision specifies the ten filenames, per-value format/length and target permissions, not the bytes/schema of the already-created pending payload. The C1R1/C1R2 retained helpers cover only synthetic ACK framing and do not contain the original C1 payload serializer/parser. The scoped local K6 C1 artifact inventory contains those C1R1/C1R2 helpers only; the original C1 transaction was inline and was not retained as reviewable source. Therefore a compatible pending-reuse parser cannot be established without opening/decrypting the protected artifact, which this Gate explicitly forbids. No new serialization format was guessed or substituted.

Metadata-only local read-back: pending artifact exists, size 1,686 bytes; the recovery leaf has inheritance protected and one explicit Owner FullControl allow rule; the file inherits the leaf ACL. Artifact bytes were not opened, decrypted, hashed, copied, renamed, promoted or deleted.

No C1R3 helper or fixture was created; no synthetic transport/SSH probe was run because the required exact payload parser could not be specified. No SSH invocation, remote target read-back, remote temporary resource, Docker/Compose action, VPS/shared-infrastructure write, Secret action, payment or Live action occurred in this Gate. Earlier C1R2 PASS evidence remains historical and is not represented as a fresh C1R3 transport result.

```text
GATE=K6_PHASE_C1R3_PENDING_REUSE_TRANSPORT_SEAL
RESULT=RETURN_REVIEWER_C1R3_ORIGINAL_PENDING_SERIALIZATION_UNKNOWN
ORIGINAL_PENDING_SERIALIZATION=UNKNOWN_NON_SECRET_SOURCE_NOT_FOUND
C1R1_R2_HELPERS=ACK_PARSER_ONLY_NO_PENDING_PAYLOAD_PARSER
LOCAL_PENDING_METADATA=EXISTS;1686_BYTES;OWNER_ONLY_LEAF_ACL_PASS
PENDING_CONTENT_ACCESSED=NO
LOCAL_HELPER_CREATED=NO
SYNTHETIC_TRANSPORT=NOT_RUN_FAIL_CLOSED
SSH_INVOCATIONS=0
REMOTE_WRITES=0
VPS_WRITES=0
SHARED_INFRA_WRITES=0
SECRET_VALUES_OR_HASHES_EXPOSED=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
OWNER_ACTION=NONE
NEXT=STOP_AT_REVIEWER
```


## K6 Phase C1R4 Pending Recovery Local Seal — RETURN (2026-09-25, Asia/Shanghai)

Reviewer authority: `docs/REVIEWER_DECISION_K6_C1R3_RETURN_C1R4_CONSOLIDATED_PENDING_RECOVERY.md`. Owner's explicit chat authorization was received for the bounded C1R4 in-memory DPAPI CurrentUser inspection and the conditional C1R5 scope. C1R4 local inspection proceeded. Under the decision, because C1R4 returns, the conditional C1R5 authorization expires; no C1R5 action was taken.

```text
GATE=K6_PHASE_C1R4_PENDING_RECOVERY_LOCAL_SEAL
RESULT=RETURN_K6_C1R4_PENDING_PAYLOAD_SCHEMA_AMBIGUOUS
OWNER_C1R4_AUTHORIZATION=GRANTED
CONDITIONAL_C1R5_AUTHORIZATION=EXPIRED_ON_C1R4_RETURN
```

### Owner-profile pending payload inspection

The existing protected pending artifact was read only in the current Owner Windows profile and decrypted in process memory with DPAPI CurrentUser. No plaintext file, environment variable, command-line argument, transcript, log, GitHub content, value output, or value hash was created. The decrypted and ciphertext byte arrays, character buffer, and temporary value buffers are zeroed in the helper's finally path. The pending file remains at its original path, size 1,686 bytes, protected Owner-only recovery-leaf ACL; it was not modified, promoted, copied, moved, or deleted.

Safe metadata findings:

- Encoding UTF-8, no BOM; LF line endings; terminal LF present.
- Twelve parseable records in the expected order: project/host binding followed by the ten authorized secret field names.
- Both project and host binding checks passed.
- The ten allowlisted fields were each present once; required lowercase-hex lengths and pairwise uniqueness checks passed.
- The physical payload also contains two non-record text lines at positions 1 and 14 (lengths 16 and 20). Their syntax/role is not specified by the retained non-secret source; they are not recognized framing or registered schema records.
- The helper therefore reports `STRUCTURE_VALID=False` and exits 23 (`RETURN_AMBIGUOUS`). It does not silently discard, reinterpret, or normalize those lines. Exact serialization/framing is not sealed, so no payload parser/sender or synthetic transport rehearsal was approved or run.

This is a schema/provenance return, not evidence of invalid credential values. No real pending bytes or Secret values were sent to the VPS.

### Fresh strict read-only target and package checks

One corrected, bounded strict-SSH read-only probe used the recorded `ops@2.24.193.133` identity, explicit normal known_hosts, `BatchMode=yes`, `IdentitiesOnly=yes`, `StrictHostKeyChecking=yes`, no agent forwarding, and bounded connection/command time. The remote identity and pinned host matched: `ops@srv1970241`. A first local probe draft exited early because of a local shell-string newline serialization error; it performed no write. The corrected probe completed with native exit 0.

- Host: Ubuntu 24.04, kernel 6.8.0-139-generic; 2 vCPU.
- RAM: 8,326,627,328 bytes total; 5,862,903,808 bytes available at probe time.
- Root and `/srv/data`: 102,888,095,744 bytes total; 93,532,176,384 bytes available.
- Docker 29.8.0; Compose v5.5.1; `sudo -n` passed.
- Existing application containers reported healthy; shared Caddy and private cloudflared containers remained up. Caddy owns host TCP 80/443; UFW is active with the existing 22/80/443 allow rules. Existing `spikersun-edge` and `spikersun-private` networks were observed unchanged.
- `/srv/apps/mini-craft-night-kit`, `/srv/data/mini-craft-night-kit`, and `/srv/backups/mini-craft-night-kit` were absent. No Mini Craft Compose-labelled container or network collision was reported.
- The sealed local production Compose rendered successfully with only non-secret validation placeholders for the two required database-name/user interpolation inputs. Rendered images were `wordpress:7.1.1-php8.3-apache` and `mariadb:11.4.7`; no host ports are published; the database network is internal; WordPress joins the existing external `spikersun-edge`; all ten unique authorized secret targets are mounted read-only (the DB app password target is mounted into both services). The temporary placeholder env file was removed after validation. Rendered JSON was not printed or persisted.
- Existing local K5 compressed backups were only statted, not changed: post-cleanup SQL 5,286,165 bytes and wp-content archive 113,763,468 bytes. This is a compressed-input reference only, not an estimate of expanded runtime usage.

### Local Gate helpers and safety

Retained reviewable local-only helper sources under:

`C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace\artifacts\gates\k6-phase-c1r4-pending-recovery-local-seal\helpers\`

- `c1r4-pending-recovery-seal.ps1` — SHA-256 `7FCB2F9A25D5741FCBC1ACFC7C619D1728EE73AFE37E31382BEAF79BA99E78AF`; PowerShell parse errors=0; deliberately fails closed on the observed ambiguous framing (native exit 23).
- `c1r4-readonly-vps-probe.ps1` — SHA-256 `E8F8082609EC33975F30CBAF74DB464A61FA6CE35EAAF654BE2C161227D7B24D`; PowerShell parse errors=0; corrected strict read-only probe succeeded.
- Synthetic framing/identity/collision rehearsal was not run because the exact pending payload schema could not be sealed. There is no C1 write branch in these helpers.

```text
PENDING_PROMOTED=NO
PENDING_DELETED=NO
PENDING_MODIFIED_BY_GATE=NO
REAL_PENDING_BYTES_SENT=NO
SYNTHETIC_TRANSPORT_REHEARSAL=NOT_RUN_FAIL_CLOSED_SCHEMA_UNRESOLVED
REMOTE_WRITES=0
VPS_WRITES=0
SHARED_INFRA_WRITES=0
DOCKER_OR_COMPOSE_MUTATIONS=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
SECRET_VALUES_OR_HASHES_EXPOSED=0
STOP_AT_REVIEWER=YES
```

No subsequent Gate is started. Reviewer must decide how to establish/provide the exact non-secret serialization source or disposition the retained pending artifact before any C1R4 retry. Because this result is RETURN, the conditional C1R5 authorization no longer applies.


## K6_PHASE_C1R5_FRESH_SECRET_REGENERATION_AND_PROVISIONING — Execution Evidence (2026-09-25)

Authority: the current C1R5 pre-execution governance reconciliation, Revision 2 execution pack, current project handoff, and explicit bounded Owner authorization. This later authorized C1R5 execution supersedes the earlier C1R4 return for current execution only; prior history is retained unchanged.

### Phase A — serializer/parser and DPAPI rehearsal

- Local PowerShell helper parsed with zero parser errors; executed helper SHA-256: `808760C349D83492AF54E6EFC2E76E32231C30D74DD88F2705656C6C0724F083`.
- Canonical schema and synthetic validation: 15/15 cases passed, including canonical LF and uniform CRLF, wrong project/host binding, missing/duplicate/extra/reordered fields, invalid hex/length, blank/trailing data, BOM, mixed line endings, and absent terminal LF.
- CurrentUser DPAPI synthetic round-trip passed.
- Strict pinned SSH synthetic transport passed and its fixed acknowledgment confirmed no remote namespace/container writes.
- Native PowerShell exit code: 0. No generated Secret value or Secret-value hash was emitted.

### Target and package preflight

- Strict SSH used the recorded `ops@2.24.193.133:22` identity and normal known_hosts with BatchMode, IdentitiesOnly, StrictHostKeyChecking=yes, agent forwarding disabled, and bounded timeouts. Identity and host pins matched; native SSH exit code: 0.
- Fresh pre-write host/capacity/runtime and namespace collision checks passed for `srv1970241`; accepted Ubuntu 24.04, Docker 29.8.0, Compose 5.5.1, and the sealed deployment package remained in force.
- The local production Compose was re-rendered using only non-secret validation placeholders. Sealed compose/manifest hashes matched. WordPress and MariaDB image tags matched the approved package; no host ports were published.
- Compose secret mount validation matched the exact allowlist and targets: 9 read-only WordPress mounts and 2 read-only MariaDB mounts; the root DB secret is not mounted into WordPress. No unrelated container inspect/config/environment data was read.

### Fresh generation, pending recovery, and provisioning

- Exactly ten fresh values were generated using the approved CSPRNG path in the target process memory. The canonical payload was streamed over the strict SSH process channel only; it was not placed in command arguments, environment variables, files, logs, or GitHub.
- Before the remote write acknowledgment, a new unique CurrentUser DPAPI pending recovery was created locally with CreateNew. The encrypted bytes were read back from disk, compared in memory, decrypted from the persisted bytes, and validated for project/host binding, exact ten-field cardinality/order, lowercase-hex lengths, and uniqueness. Owner-only recovery directory/file ACL checks passed.
- Only after pending readback passed, exactly the ten authorized files were created under `/srv/data/mini-craft-night-kit/secrets` using exclusive/no-follow creation. Directories are root:root 0700; nine files are root:33 0440; `db-root-password` is root:root 0400. No newline was added. Remote verification checked exact inventory, metadata, format, and pairwise uniqueness without returning file contents or hashes.
- Runtime access/exclusion was verified statically from the sealed read-only Compose mount mapping and target ownership/modes; no Mini Craft service was started.
- An independent strict read-only metadata-only post-check returned native exit 0: exact ten filenames and required permissions; Mini Craft container count=0; Mini Craft database-network count=0; services started=NO.
- After remote verification, the new DPAPI pending file was promoted to a final recovery artifact. Final artifact size=1,686 bytes; persisted location is under the Owner profile's protected `%LOCALAPPDATA%\\MiniCraftNightKit\\secret-recovery\\` directory; Owner-only ACL verified. The previous C1 pending artifact was not accessed, read, modified, reused, moved, or deleted.
- The independent verifier's first local draft piped its base64-decoded Python body to Bash and exited 2; it performed no writes. The corrected read-only verifier piped to Python and passed (SSH exit 0).

```text
PHASE_A_SYNTHETIC_CASES=15_OF_15
DPAPI_PENDING_DISK_READBACK_AND_ROUNDTRIP=PASS
FRESH_SECRET_VALUES_GENERATED=10
REMOTE_SECRET_FILES_CREATED_AND_VERIFIED=10
REMOTE_SECRET_FILE_PERMISSIONS=ROOT_33_0440_X9;ROOT_0400_X1
RUNTIME_ACCESS=PASS_STATIC_COMPOSE_BIND_AND_MODE;SERVICE_NOT_STARTED
NEW_C1R5_RECOVERY=PROMOTED_FINAL;OWNER_ONLY_ACL
OLD_C1_PENDING=NOT_ACCESSED
SECRET_VALUES_OR_HASHES_EXPOSED=0
MINICRAFT_SERVICE_STARTS=0
UNRELATED_CONTAINER_CONFIG_OR_ENV_READS=0
SHARED_INFRA_WRITES=0
DOCKER_OR_COMPOSE_WRITES=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
STOP_AT_REVIEWER=YES
```

No Mini Craft containers, database, or wp-content were created/restored. No payment, Live, shared-ingress, DNS, firewall, or other VPS mutation occurred. The only authorized VPS writes were the ten allowlisted secret files and their two containing directories. No next Gate was started.

LOCAL_HELPER_CLEANUP=PASS; one-time local source removed after evidence publication; final DPAPI recovery retained locally.


---

## K6_PHASE_C1R5R1_POSTWRITE_EVIDENCE_RECONCILIATION — 2026-09-25

Result: RETURN_C1R5R1_EXECUTED_HELPER_SOURCE_UNRECOVERABLE. This entry records bounded metadata-only checks; it does not assert C1R5R1 PASS.

### Authority and source reads
- Read the current Reviewer Handoff, Project Storage Manifest, current R1 Reviewer Decision, R1 execution pack, latest Evidence/Handoff, and canonical VPS Project Governance v0.1.6 with active SSH / target-host / storage addenda.
- SHARED_VPS_HANDOFF_SOURCE_READ=YES. Read the unique local Shared VPS Handoff at C:\Users\34707\Documents\ChatGPT\VPS基建\SHARED_VPS_HANDOFF.md before the strict SSH check.
- No Reviewer-owned file or storage manifest was modified.

### Executed helper source recovery
- Required executed helper SHA-256: 808760C349D83492AF54E6EFC2E76E32231C30D74DD88F2705656C6C0724F083.
- The recorded local helper path under mini-craft-night-kit-workspace\artifacts\gates\k6-phase-c1r5-fresh-secret-regeneration-and-provisioning\helpers\c1r5-secret-transaction.ps1 is absent.
- Searched the exact expected path/name in the current Gate artifacts, retained project artifacts, local GitHub-sync worktree, local temp location, and Mini Craft archive. A metadata/hash-only scan of four retained PowerShell candidates found no matching hash. The project Git worktree has no tracked copy or path history; exact GitHub filename search returned no source.
- EXECUTED_HELPER_SOURCE_RECOVERED=NO; EXECUTED_HELPER_SHA_MATCH=UNVERIFIED; STATIC_HELPER_REVIEW=BLOCKED_SOURCE_UNRECOVERABLE. No reconstructed source was substituted or retained.

### Owner-host SSH and recovery metadata
- Identity reference exists; public-key fingerprint matched the previously recorded fingerprint SHA256:qFlRXelvzDEFpatrcX7T4dUBKPAC7YqFqNkyFZh5rYw. Private key content was not read.
- Normal known_hosts contained three pinned host-key algorithms; their fingerprints matched the previously recorded pins. StrictHostKeyChecking remained enabled; no trust file was changed.
- The one strict SSH read-only audit reached ops@srv1970241 with sudo -n available. SSH transport and pinned host identity succeeded. The remote audit returned native status 2 because the nine host-path UID 33 permission probes failed; this was not an SSH transport failure.
- Recovery directory: %LOCALAPPDATA%\MiniCraftNightKit\secret-recovery. Metadata-only ACL check: owner-only FullControl DACL, inheritance protected.
- New final artifact: k6-c1r5-mini-craft-night-kit-srv1970241-20260925T144404Z-a93f21724d554fde90d91b949d8acc6e.final.dpapi. Exists; 1,686 bytes; created/last-write 2026-09-25T14:44:08.4373453Z; Owner-only FullControl ACE inherited from the protected recovery directory.
- Historical C1 pending: k6-c1-mini-craft-night-kit-srv1970241.pending.dpapi. Exists; 1,686 bytes; created 2026-09-24T04:32:45.2646290Z; last-write 2026-09-24T04:32:45.2712493Z; Owner-only FullControl ACE inherited from the protected recovery directory. Only filesystem metadata was queried; no content comparison is claimed.
- No recovery payload was opened, decrypted, hashed, copied, renamed, promoted, modified, or deleted.

### VPS Secret metadata and bounded access checks
- Exact target directory /srv/data/mini-craft-night-kit/secrets: root:root 0700. Exact allowlist count=10 and exact basenames matched the R2 pack.
- Metadata-only file inventory: db-app-password root:33 0440 size 64; db-root-password root:root 0400 size 64; eight WordPress key/salt files root:33 0440 size 128 each. No file contents, values, or hashes were read.
- UID 33 test-read checks against the host source paths failed for all nine WordPress-permitted files. The parent Mini Craft data directory is root:root 0700, so host-path access is blocked before the file ACL is reached. This does not establish the result of a container single-file bind mount; effective in-container access remains UNVERIFIED.
- UID 33 was unable to read db-root-password; host root read-permission checks for db-app-password and db-root-password passed. These are access-permission probes only; no file was opened/read.
- Sealed production Compose source (SHA256 C52E1C088D05300C93139CF87A04D4C7CA2E5D8412FEE6C788CB97ABDABF0B2B) was inspected locally without starting services: it maps nine read-only individual secret files to WordPress and maps db-root-password only to MariaDB. This is configuration evidence, not runtime read proof.

### Docker isolation and runtime boundary
- Read-only Docker metadata showed 8 existing running containers, 0 Mini Craft Compose containers, and 0 Mini Craft Compose networks.
- Docker mount metadata was inspected for each of the 8 running containers. None mounted /srv/data/mini-craft-night-kit or a descendant; unrelated Mini Craft secret mount count=0.
- Existing shared edge/private networks, Caddy, and cloudflared were present. No container, network, service, or shared infrastructure was changed.

### Boundary and disposition
EXECUTED_HELPER_SOURCE_RECOVERED=NO
EXECUTED_HELPER_SHA_MATCH=UNVERIFIED
STATIC_HELPER_REVIEW=BLOCKED_SOURCE_UNRECOVERABLE
TARGET_SECRET_METADATA_READBACK=PASS
RUNTIME_ACCESS_AND_UNRELATED_MOUNT_EXCLUSION=PARTIAL;UNRELATED_MOUNT_EXCLUSION=PASS;WORDPRESS_EFFECTIVE_RUNTIME_READ=UNVERIFIED
NEW_FINAL_RECOVERY_METADATA_READBACK=PASS
OLD_PENDING_METADATA_READBACK=PASS;CONTENT_UNCHANGED_COMPARISON=NOT_AVAILABLE;NO_ACTION_TAKEN
SHARED_VPS_HANDOFF_SOURCE_READ=YES
SECRET_VALUE_OR_HASH_ACCESS=0
RECOVERY_CONTENT_ACCESS=0
REMOTE_WRITES=0
SERVICE_STARTS=0
SHARED_INFRA_WRITES=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
STOP_AT_REVIEWER=YES


---

## K6_PHASE_C1R5R2_CURRENT_STATE_REQUALIFICATION — EXECUTION RESULT

Execution date: 2026-09-26 (Asia/Shanghai)  
Result: `PASS_CANDIDATE_K6_PHASE_C1R5R2_CURRENT_STATE_REQUALIFICATION`

### Authority and boundary

- Re-read the current Reviewer handoff, C1R5R1-return/C1R5R2 decision, C1R5R2 execution pack, latest Evidence and Executor Handoff, current Shared VPS Handoff, and canonical VPS Project Governance v0.1.6 plus active SSH, target-host, storage, and source-policy references.
- Used the registered `ops@2.24.193.133:22` identity and normal `known_hosts` with strict host-key checking. Target identity/trust matched the recorded handoff; the bounded SSH command exited 0.
- No Secret or recovery value was read, printed, hashed, copied, changed, or deleted. No recovery content was opened/decrypted/hashed.
- No production WordPress/MariaDB service, database restore, Shared Infra, DNS, payment, or Live action occurred.

### Target Secret metadata-only recheck

- Exact allowlist inventory: 10 regular files, no extra/missing names.
- Secret directory: `root:root 0700`.
- `db-app-password`: `root:33 0440`, 64 bytes.
- Eight WordPress key/salt files: `root:33 0440`, 128 bytes each.
- `db-root-password`: `root:root 0400`, 64 bytes.
- Metadata matched the accepted manifest. Only directory entries and filesystem metadata were queried; Secret file contents were not opened.
- VPS initially had no Mini Craft production containers. Existing local validation image `redis:7-alpine` was already present; WordPress/MariaDB production images were not pulled or built.

### Disposable effective-access checks

A bounded remote verifier ran two short-lived containers from the already-present local image, overriding its entrypoint with the POSIX shell (no Redis service started). Both used network mode `none`, no published ports, read-only root filesystem, dropped capabilities, no-new-privileges, small CPU/memory/PID bounds, tmpfs-only writable scratch/data paths, and exact individual read-only secret-file binds. Container mount configuration was inspected by metadata; the checks inside the containers used only identity checks and `test -r` / path-presence checks.

- WordPress access-boundary test ran as UID/GID 33:33; all nine approved WordPress files were readable. The expected bind allowlist matched exactly and `db-root-password` was neither mounted nor present in the WordPress secret path. Process exit status was 0.
- MariaDB access-boundary test ran as UID/GID 0:0; only `db-app-password` and `db-root-password` were bound read-only, and both passed `test -r`. Process exit status was 0. This was an access-boundary check, not a MariaDB application startup.
- Unrelated running containers: 8 before and after; their IDs, names, running/health status and mount metadata matched. None mounted the Mini Craft secret directory.
- Both uniquely named verifier containers were removed. No validation container remained. Docker network IDs were unchanged (8); Docker volume inventory remained unchanged (0). No port bindings or persistent volume mounts were used.
- A first no-write inventory implementation used a multi-container inspect template that returned a nonzero status before any verifier container was created. It was replaced with per-container mount-metadata inspection; the repeated read-only preflight passed before the bounded tests began. No target state was changed by the failed preflight.

### Local recovery metadata-only readback

- New final artifact `k6-c1r5-mini-craft-night-kit-srv1970241-20260925T144404Z-a93f21724d554fde90d91b949d8acc6e.final.dpapi`: present, 1,686 bytes; created/written `2026-09-25T14:44:08.4373453Z`; recovery directory DACL inheritance is protected and directory/file access remains Owner-only.
- Historical C1 pending artifact `k6-c1-mini-craft-night-kit-srv1970241.pending.dpapi`: present, 1,686 bytes; created `2026-09-24T04:32:45.2646290Z`, written `2026-09-24T04:32:45.2712493Z`; Owner-only ACL remains. These metadata match the prior recorded baseline. Neither artifact's content or hash was accessed.

### Gate result

```text
TARGET_SECRET_METADATA_READBACK=PASS
WORDPRESS_UID33_EFFECTIVE_READ_9_OF_9=PASS
WORDPRESS_DB_ROOT_NOT_MOUNTED=PASS
MARIADB_REQUIRED_SECRET_ACCESS=PASS
UNRELATED_RUNNING_SERVICE_SECRET_MOUNTS=0
DISPOSABLE_VALIDATION_NETWORK=NONE
DISPOSABLE_VALIDATION_PORTS=NONE
DISPOSABLE_VALIDATION_PERSISTENT_STATE=0
VALIDATION_RESOURCES_AFTER_CLEANUP=0
NEW_FINAL_RECOVERY_METADATA_READBACK=PASS
OLD_PENDING_METADATA_UNCHANGED=PASS
SECRET_VALUE_OR_HASH_ACCESS=0
RECOVERY_CONTENT_ACCESS=0
MINICRAFT_PRODUCTION_SERVICE_STARTS=0
SHARED_INFRA_WRITES=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
STOP_AT_REVIEWER=YES
```

This current-state qualification does not repair or upgrade the historical C1R5 executed-helper-source auditability RETURN.

---

## K6_PHASE_D_PRIVATE_RUNTIME_DEPLOYMENT_AND_RESTORE — EXECUTION RESULT

Execution date: 2026-09-26 (Asia/Shanghai)  
Result: RETURN_REVIEWER_IMAGE_ACQUISITION_AUTHORIZATION_REQUIRED

### Authority and bounded scope

- Re-read the current Reviewer handoff, Project Storage Manifest, K6 C1R5R2 PASS / Phase D decision, Phase D Execution Pack, latest Evidence and Executor Handoff, local Shared VPS Handoff, and canonical VPS Project Governance v0.1.6 and active addenda.
- Used only the recorded ops@2.24.193.133:22 identity, normal known_hosts, and strict host-key verification. The single bounded read-only SSH audit reached ops@srv1970241; native SSH exit code was 0.
- No project directories, files, images, containers, networks, or runtime services were created or changed. No image was pulled or built. No SQL/wp-content package was transferred and no restore or URL migration was attempted.

### Fresh target read-only preflight

- Host identity: srv1970241, Ubuntu 24.04.5 LTS, kernel 6.8.0-139-generic, 2 vCPU.
- RAM: 8,131,472 kB total; 5,736,896 kB available at the snapshot.
- Root filesystem: 102,888,095,744 bytes total; 9,362,104,320 used; 93,509,214,208 available; 10% reported used.
- Docker 29.8.0; Compose v5.5.1. Docker reported 8 existing running containers, all existing application containers healthy; Caddy and cloudflared were up. No Mini Craft Compose container/network was present.
- Existing networks include the previously recorded spikersun-edge (same inspected ID b7d77d484427...); no network mutation was performed.
- Host TCP 80/443 remain owned by spikersun-edge-caddy-1; current UFW is active with the existing 22/80/443 rules. Caddy's read-only mount metadata identifies /srv/infra/edge/Caddyfile as its read-only Caddyfile source and /srv/infra/edge/config / data as its mounted state paths. Shared cloudflared remains running. No shared ingress/configuration was changed.
- Exact Mini Craft app, mysql, wp-content, and backup target paths were absent. The existing /srv/data/mini-craft-night-kit/secrets tree was present.
- A first unprivileged existence test could not traverse the root-only project data parent and was inconclusive; it was not treated as evidence that Secrets were missing. Follow-up checks used sudo -n and confirmed metadata without opening file content.
- Secret metadata-only readback: directory root:root 0700; exact 10-file allowlist; nine runtime files root:33 0440; DB root file root:root 0400. Names/count/modes/sizes match the accepted manifest. No Secret values or hashes were read or emitted.
- Accepted K5 SQL and wp-content archive hashes each matched their sealed expected hashes locally. The canonical production Compose file matched its previously sealed hash. Hash values are intentionally omitted here.
- Target image inspection returned native status 1 for both wordpress:7.1.1-php8.3-apache and mariadb:11.4.7: neither accepted image is cached on the VPS. The sealed deployment material does not provide an explicitly authorized exact immutable acquisition path for both images. Per the Phase D decision/pack, no pull/build may be inferred; execution stops for Reviewer direction before any write.

### Gate disposition

    FRESH_SHARED_VPS_PREFLIGHT=PASS_HOST_AND_SHARED_BASELINE
    TARGET_HOST_IDENTITY=PASS
    RESOURCE_HEADROOM=PASS_AT_SNAPSHOT;DEPLOYMENT_NOT_STARTED
    SECRET_STATE_PREDEPLOY_READBACK=PASS_METADATA_ONLY
    ACCEPTED_K5_SQL_PACKAGE_HASH=PASS_LOCAL_MATCH
    ACCEPTED_K5_WP_CONTENT_PACKAGE_HASH=PASS_LOCAL_MATCH
    CANONICAL_COMPOSE_PACKAGE_HASH=PASS_LOCAL_MATCH
    TARGET_WORDPRESS_IMAGE=CACHE_MISS;NO_PULL
    TARGET_MARIADB_IMAGE=CACHE_MISS;NO_PULL
    IMAGE_ACQUISITION_AUTHORIZATION=REVIEWER_REQUIRED
    CANONICAL_COMPOSE_RENDER=NOT_RUN;STOPPED_BEFORE_WRITE
    APPS_PATH=NOT_CREATED
    DATA_MYSQL_PATH=NOT_CREATED
    DATA_WP_CONTENT_PATH=NOT_CREATED
    BACKUP_PATH=NOT_CREATED
    ACCEPTED_K5_SQL_TRANSFER=NOT_STARTED
    ACCEPTED_K5_WP_CONTENT_TRANSFER=NOT_STARTED
    MARIADB_RESTORE=NOT_STARTED
    WP_CONTENT_RESTORE=NOT_STARTED
    URL_MIGRATION=NOT_STARTED
    DB_PUBLIC_PORT=NONE
    WORDPRESS_HOST_PORT=NONE
    PUBLIC_INGRESS_CHANGE=0
    PUBLIC_ROUTE_ENABLED=NO
    UNRELATED_SERVICES_CHANGED=NO
    ROLLBACK_READY=NOT_APPLICABLE;NO_TARGET_MUTATION
    RESOURCE_DELTA_RECORDED=NO_CHANGE
    REMOTE_TEMP_CLEANUP=NOT_APPLICABLE;NO_TEMPORARY_REMOTE_ARTIFACTS
    SECRET_VALUE_OR_HASH_ACCESS=0
    REMOTE_WRITES=0
    DOCKER_WRITES=0
    SHARED_INFRA_WRITES=0
    PAYMENT_ACTIONS=0
    LIVE_ACTIONS=0
    STOP_AT_REVIEWER=YES

Reviewer action required before retry: explicitly decide an immutable, verifiable acquisition method for the two missing approved images (or supply another already-sealed image package/path). Do not pull/build, transfer, create directories, or start services until that decision is recorded. No Owner Secret action is requested.


## K6 Phase D-R1 — Image Acquisition Seal / Private Deployment Resume (2026-09-26)

GATE=K6_PHASE_D_R1_IMAGE_ACQUISITION_SEAL_AND_PRIVATE_DEPLOYMENT_RESUME
RESULT=RETURN_REVIEWER_K6_D_R1_COMPOSE_SOURCE_HASH_MISMATCH

### Image resolution and acquisition

- WordPress official repository `docker.io/library/wordpress`, requested tag `7.1.1-php8.3-apache`: top-level OCI index `sha256:51464c8fdb100c5cd2ebfaec1834cf111d993bc4929ef2330c1cc721eda0fc30`; unique `linux/amd64` child `sha256:f5413918c7858c97bb7d2b65f68d3ed38a97472deba9eb58eb3e1ab1eb2c4beb`. Child manifest digest response matched.
- MariaDB official repository `docker.io/library/mariadb`, requested tag `11.4.7`: top-level OCI index `sha256:39596f079862334be04f4231664862e55d4febe54309cc62f750f2297de85b06`; unique `linux/amd64` child `sha256:b105d14ee1f4688769a57d432a9b52179e4d95f4495783ca8a41f3c783eab03c`. Child manifest digest response matched.
- Both exact child digests were pulled only after both read-only resolutions passed. No tag-only pull, build, or additional image acquisition occurred.
- Local image identity checks matched each exact child digest, with `OS=linux`, `Architecture=amd64`. Bounded disposable no-network/no-port/no-persistent-state probes passed: WordPress `7.1.1` / PHP `8.3.33`; MariaDB `11.4.7`.
- Disposable probe containers were auto-removed. Mini Craft application containers, networks, and volumes were not created. A bounded check found WP-CLI absent in the WordPress image; no migration tool was installed or migration attempted.

### Compose seal reconciliation — blocking return

The K6 Phase B execution record seals `compose.production.yaml` at SHA-256 `03DCB12E3B8FCFC1A58329CCACE3949DEEAB64DA292AF885FA8817A16DA829BF`. The only local K6B source candidate was `C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace\artifacts\gates\k6-phase-b-local-deployment-package-seal\compose.production.yaml`; its observed SHA-256 was `C52E1C088D05300C93139CF87A04D4C7CA2E5D8412FEE6C788CB97ABDABF0B2B`. No exact-hash copy was found in the scoped Mini Craft workspace/archive. This is a material canonical-source integrity mismatch.
- A candidate digest-pinned Compose was mechanically derived and rendered locally with explicit project/file selection. The render resolved exactly two services, the two approved digests, and zero host ports; after normalization, only the two image references differed from the current local candidate.
- Because the source candidate did not match its sealed hash, that candidate was **not accepted or used**. No remote Compose command was run. The temporary candidate Compose on VPS was removed; no WordPress/MariaDB application service was started.

### Accepted backup transfer and current remote state

- Accepted K5 SQL (`5,286,165` bytes) and wp-content archive (`113,763,468` bytes) revalidated against K5 manifest locally and after transfer; transfer matches passed. Only the accepted SQL/wp-content recovery inputs and non-secret manifests were staged.
- SQL header metadata identifies database `wordpress`. A project-scoped non-secret DB-user candidate `mini_craft_app` was documented locally but **not applied**; no `.env` was created.
- Project app/mysql/wp-content directories created during staging were removed while empty after the source mismatch. Current remote residuals are only the accepted recovery inputs/manifests under `/srv/backups/mini-craft-night-kit`; files are root-owned, SQL/archive mode `0600`, manifests mode `0640`. The existing Secret tree remains at its original path.
- Fresh post-pull prewrite snapshot: target `ops@srv1970241`, Ubuntu 24.04, Docker `29.8.0`, Compose `5.5.1`, 2 vCPU, RAM available `5,922,300 kB`, root filesystem available `91,942,862,848` bytes. Existing eight shared containers remained healthy; existing `spikersun-edge` ID unchanged. After staging, root filesystem available `91,823,329,280` bytes.
- Final read-only check: Mini Craft container count `0`; Docker network count `8` (unchanged); Docker volume count `0`; app/mysql/wp-content paths absent; backups path retained. Existing Secret tree metadata (10 exact files, owner/group/mode/size) matched prewrite readback; no Secret content or hash was accessed.

### Gate boundary and next decision

```text
IMAGE_RESOLUTION_AND_DIGEST_SEAL=PASS
EXACT_DIGEST_PULLS=PASS
DIGEST_PLATFORM_VERSION_VERIFICATION=PASS
RESOLVED_COMPOSE_LOCAL_RENDER=PASS
CANONICAL_COMPOSE_SOURCE_HASH_MATCH=FAIL
COMPOSE_USED_FOR_DEPLOYMENT=NO
ACCEPTED_K5_SQL_TRANSFER=PASS
ACCEPTED_K5_WP_CONTENT_TRANSFER=PASS
MARIADB_RESTORE=NOT_STARTED
WP_CONTENT_RESTORE=NOT_STARTED
URL_MIGRATION=NOT_STARTED
WORDPRESS_HEALTH=NOT_STARTED
MARIADB_HEALTH=NOT_STARTED
PAYPAL_STATE_READBACK=NOT_STARTED
PUBLIC_INGRESS_CHANGE=0
PUBLIC_ROUTE_ENABLED=NO
UNRELATED_SERVICES_CHANGED=NO
SECRET_VALUE_OR_HASH_ACCESS=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
SHARED_INFRA_WRITES=0
DOCKER_APPLICATION_WRITES=0
REMOTE_WRITES=PROJECT_SCOPED_ARTIFACT_STAGING_ONLY
STOP_AT_REVIEWER=YES
```

Reviewer action required: reconcile the current K6B Compose source against the accepted seal—restore the exact sealed artifact or issue an updated accepted source/hash and deployment instruction. Do not resume runtime creation, restore, or URL migration until the Compose source identity is resolved.


---

## K6_PHASE_D_R2_COMPOSE_SOT_RECONCILIATION_AND_PRIVATE_RESTORE — Executor return (2026-09-26)

```text
GATE=K6_PHASE_D_R2_COMPOSE_SOT_RECONCILIATION_AND_PRIVATE_RESTORE
RESULT=RETURN_D_R2_MARIADB_RESTORE_INCOMPLETE
CANONICAL_SOURCE_SHA=C52E1C088D05300C93139CF87A04D4C7CA2E5D8412FEE6C788CB97ABDABF0B2B
STALE_03DC_RECORD_IGNORED=YES
RESOLVED_COMPOSE_SHA=85ABEAAE1C75D775937EA2DDD7395E39F364044CC03DCF317861FDED2110EA8C
SEMANTIC_DIFF_IMAGE_REFS_ONLY=PASS;WORDPRESS_AND_MARIADB_ONLY
RESOLVED_COMPOSE_RENDER=PASS;TWO_SERVICES;NO_HOST_PORTS;DB_NETWORK_INTERNAL;EDGE_EXTERNAL
FRESH_SHARED_VPS_PREFLIGHT=PASS;STRICT_RECORDED_HOST_KEY;HOST=srv1970241
ROOT_FILESYSTEM_BEFORE=102888095744_TOTAL;11049127936_USED;91822190592_AVAILABLE;11_PERCENT
STAGED_K5_SQL_HASH=PASS;BB6A9F56C532C395B89089FC460FB5F20A038A012C84DDD210DCCF5E1AB4C602
STAGED_K5_WP_CONTENT_HASH=PASS;543239EFEBE20915F3A8E96B65986CB4A5EB0B187E7E24C9E7286A7126E41D08
BACKUP_RETRANSFER=NO
IMAGE_DIGESTS=PASS;WORDPRESS=f5413918c7858c97bb7d2b65f68d3ed38a97472deba9eb58eb3e1ab1eb2c4beb;MARIADB=b105d14ee1f4688769a57d432a9b52179e4d95f4495783ca8a41f3c783eab03c
PROJECT_PATHS_CREATED=YES;/srv/apps/mini-craft-night-kit;/srv/data/mini-craft-night-kit/mysql;/srv/data/mini-craft-night-kit/wp-content
NON_SECRET_COMPOSE_ENV=INSTALLED;DATABASE=wordpress;APP_USER=mini_craft_app
WP_CONTENT_RESTORE=PASS;FILES=10972;APPARENT_BYTES=207282778;OWNER=33:33;UPLOADS_PRESENT=YES
SQL_RESTORE=NOT_ACCEPTABLE;INIT_SCRIPT_INVOKED_AND_MARIADB_HEALTHY;APPLICATION_SCHEMA_TABLES_VISIBLE=0;WP_OPTIONS_TABLE=ABSENT
WP_RUNTIME=CONTAINER_HEALTHY_BUT_INSTALL_REDIRECT_302_TO_WP_ADMIN_INSTALL;APPLICATION_READY=NO
HOME_SITEURL_SCALAR_UPDATE=NOT_EXECUTED;REASON=WP_OPTIONS_ABSENT
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
MARIADB_STATE=STOPPED_AFTER_FAILED_RESTORE_VERIFICATION
WORDPRESS_STATE=STOPPED_AFTER_FAILED_RESTORE_VERIFICATION
HOST_PORTS=NONE;PUBLIC_ROUTE_ENABLED=NO
NETWORK=MINICRAFT_INTERNAL_DATABASE_NETWORK_CREATED;SHARED_EDGE_MEMBERSHIP_ONLY;NO_SHARED_NETWORK_CONFIGURATION_CHANGE
DOCKER_VOLUMES_CREATED=0
UNRELATED_SERVICES_CHANGED=NO;ORIGINAL_8_SHARED_CONTAINERS_UNCHANGED
SECRET_METADATA=UNCHANGED;10_FILES;NINE_ROOT_33_MODE_0440;ONE_ROOT_ROOT_MODE_0400;NO_CONTENT_OR_HASH_ACCESS
K5_RECOVERY_SOURCES=RETAINED_AND_HASH_MATCHING
REMOTE_TEMP_SQL=REMOVED;REMOTE_HELPER=REMOVED;HOST_TMP_FILES=0
ROLLBACK_READY=PARTIAL;ONLY_MINI_CRAFT_CONTAINERS_STOPPED;K5_SOURCES_AND_SECRET_TREE_RETAINED;PARTIAL_DB_STATE_PRESERVED_FOR_REVIEW
PUBLIC_INGRESS_CHANGE=0
PAYPAL_MODE=NOT_RECONFIGURED;HISTORICAL_SANDBOX_STATE_NOT_REQUALIFIED_IN_THIS_FAILED_RESTORE
PAYPAL_LIVE=NO
PAYMENT_ACTIONS=0
VPS_WRITES=YES;PROJECT_SCOPED_ONLY
SHARED_INFRA_WRITES=0
SECRET_VALUE_OR_HASH_ACCESS=0
STOP_AT_REVIEWER=YES
```

The accepted SQL and wp-content package were reused from the already staged, hash-matching recovery inputs. The SQL package structurally contains 52 table-creation statements and 36 insert statements; only statement counts were checked. MariaDB’s official initialization log was processed through a field-filtering classifier (no raw log lines emitted): it recorded the restore script as invoked and no error line, and the service healthcheck passed. Nevertheless, the WordPress runtime’s database connection reported the selected `wordpress` schema with zero visible tables, and `wp_options` was absent. This fails the required restore verification; container health alone was not treated as application restore success.

No URL option was changed, no full serialized URL migration was attempted, and no public ingress or shared service configuration was modified. The incomplete Mini Craft containers are stopped (not removed); the partial project data remains preserved, with the accepted K5 sources and unchanged Secret tree available for Reviewer-directed recovery. The exact cause of the import/schema discrepancy is unresolved and requires Reviewer direction before any restore retry.

Local non-secret Gate artifacts: `mini-craft-night-kit-workspace/artifacts/gates/k6-phase-d-r2-compose-sot-reconciliation-and-private-restore/` (resolved Compose retained; temporary PHP helper removed).

### K6 D-R2 post-return helper cleanup verification (2026-09-26)

A stopped-container layer diff initially showed the non-secret temporary PHP helper as an added path. To avoid leaving it in the stopped container, only the Mini Craft WordPress container was briefly started; the helper was removed as container root, its in-container existence check passed absent, and the container was immediately stopped. A second Docker layer diff reported no entry for the helper. MariaDB remained stopped throughout this cleanup. Final state: both Mini Craft containers exited, both port-binding sets empty, eight pre-existing shared containers still running, and no additional temp SQL/helper file remains on the VPS.

## K6_PHASE_D_R3_DB_RESTORE_DIAGNOSIS_AND_CONDITIONAL_RETRY — RETURN (2026-09-26)

Authority: current K6 D-R3 Reviewer decision and execution pack; canonical VPS Project Governance v0.1.6 with active SSH, Target Host Reality, Storage, and Governance Source Policy addenda. Current Shared VPS Handoff was read from its unique local path. Strict pinned SSH connected as `ops@srv1970241`; no host-key relaxation or trust-file change.

### Preflight and accepted recovery source

- MariaDB and WordPress were both stopped at Gate entry; the staged database dump and wp-content archive remain in the existing project backup namespace.
- Staged SQL: `/srv/backups/mini-craft-night-kit/database-post-cleanup.sql`; 5,286,165 bytes; SHA-256 `BB6A9F56C532C395B89089FC460FB5F20A038A012C84DDD210DCCF5E1AB4C602`, matching the accepted K5 SQL source. No retransmission or wp-content action.
- Disk snapshot: root 102,888,095,744 bytes total, 11,454,128,128 used, 91,417,190,400 available (12%).
- Only the existing Mini Craft MariaDB container was started via the explicitly selected project Compose service; native start exit 0 and health `running|healthy`. WordPress remained exited (previous exit 137); MariaDB has no published host port (`3306/tcp:null`). No image pull, rebuild, recreate, DB reset, or other service start.

### Metadata-only dump structure

The accepted SQL was parsed in process; no INSERT row contents were emitted.

```text
SQL_HASH=PASS
DUMP_EXPECTED_TABLE_COUNT=52
DUMP_EXPECTED_TABLE_NAMES=wp_actionscheduler_actions,wp_actionscheduler_claims,wp_actionscheduler_groups,wp_actionscheduler_logs,wp_commentmeta,wp_comments,wp_kb_optimizer,wp_kb_optimizer_viewport_hashes,wp_links,wp_options,wp_postmeta,wp_posts,wp_term_relationships,wp_term_taxonomy,wp_termmeta,wp_terms,wp_usermeta,wp_users,wp_wc_admin_note_actions,wp_wc_admin_notes,wp_wc_category_lookup,wp_wc_customer_lookup,wp_wc_download_log,wp_wc_order_addresses,wp_wc_order_coupon_lookup,wp_wc_order_operational_data,wp_wc_order_product_lookup,wp_wc_order_stats,wp_wc_order_tax_lookup,wp_wc_orders,wp_wc_orders_meta,wp_wc_product_attributes_lookup,wp_wc_product_download_directories,wp_wc_product_meta_lookup,wp_wc_rate_limits,wp_wc_reserved_stock,wp_wc_tax_rate_classes,wp_wc_webhooks,wp_woocommerce_api_keys,wp_woocommerce_attribute_taxonomies,wp_woocommerce_downloadable_product_permissions,wp_woocommerce_log,wp_woocommerce_order_itemmeta,wp_woocommerce_order_items,wp_woocommerce_payment_tokenmeta,wp_woocommerce_payment_tokens,wp_woocommerce_sessions,wp_woocommerce_shipping_zone_locations,wp_woocommerce_shipping_zone_methods,wp_woocommerce_shipping_zones,wp_woocommerce_tax_rate_locations,wp_woocommerce_tax_rates
CREATE_DATABASE_COUNT=1
CREATE_DATABASE_TARGET=wordpress
CREATE_DATABASE_IF_NOT_EXISTS=NO
USE_COUNT=1
USE_TARGET=wordpress
SCHEMA_QUALIFIED_DDL=NONE
CREATE_TABLE_TARGETS=UNQUALIFIED
INSERT_STATEMENT_COUNT=36
DROP_TABLE_IF_EXISTS_COUNT=52
DROP_TABLE_TARGET_SET_MATCHES_CREATE=YES
DROP_TABLE_TARGETS=UNQUALIFIED;ALL_MATCH_EXPECTED_52_TABLES
DROP_DATABASE=0
DROP_USER=0
ALTER_USER=0
GRANT=0
REVOKE=0
CREATE_USER=0
SET_PASSWORD=0
SET_GLOBAL=0
```

The 52 `DROP TABLE IF EXISTS` statements are unqualified and their target set exactly matches the 52 expected CREATE TABLE names. No database/account mutation or cross-schema DDL was found. The dump has one **unguarded** `CREATE DATABASE wordpress` statement.

### Root / app-user readback

Authentication used the existing mounted Secret files only in process memory to create a root-only mode 0600 client option file under container `/dev/shm`; `/dev/shm` was verified as tmpfs. The option file was verified absent before exit. No credential value, hash, argv, environment variable, or log content was emitted or recorded.

- Root/admin query passed. The only non-system schema is `wordpress`; its table count is 0, its table-name set is empty, and `wp_options` is absent.
- Existing `mini_craft_app@%` account is present. Metadata reports global `USAGE` and an existing schema-level privilege set on `wordpress` (including SELECT/INSERT/UPDATE/DELETE/CREATE/ALTER/DROP); no missing schema grant explains visibility.
- App-user authentication/query passed against `wordpress`; it also sees 0 tables and no `wp_options`.
- Therefore the authorized permission-repair branch does not apply; both identities see the same empty target.

### Branch result and stop boundary

```text
RESULT=RETURN_REVIEWER_D_R3_SCHEMA_OR_DUMP_DRIFT
ROOT_WORDPRESS_TABLE_SET=EMPTY
APP_WORDPRESS_TABLE_SET=EMPTY
WP_OPTIONS=ABSENT
RESTORE_PATH=NOT_EXECUTED
DATABASE_IMPORT_RETRIES=0
DB_PERMISSION_MUTATION=0
WORDPRESS_START=0
HOME_SITEURL_SCALAR_UPDATE=NOT_EXECUTED
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
```

The existing `wordpress` schema conflicts with the dump's unguarded `CREATE DATABASE wordpress`. The reviewed import path does not authorize altering/filtering the accepted dump stream, ignoring the database-exists error with a force mode, or dropping/recreating the schema. This is therefore an import-path ambiguity; no import was attempted. The 52 table-level DROP statements were not executed.

Per the Gate's RETURN rule, all remote container operations stopped immediately after classification. **MariaDB is left running and healthy; WordPress remains stopped.** No post-RETURN container cleanup/check was run. No URL option was changed.

Earlier bounded read-only probes had nonzero exits caused by a wrong container-name probe, a permission-denied non-root SQL-file read, and a Python syntax error in a metadata-only scanner draft; none made a database or host mutation. Corrected strict probes completed successfully. These failures are retained here for transparent execution history.

```text
PUBLIC_INGRESS_CHANGE=0
SHARED_INFRA_WRITES=0
SECRET_VALUE_OUTPUT=0
SECRET_VALUE_HASHING=0
SECRET_FILE_READ=IN_MEMORY_AUTH_ONLY_AS_REVIEWER_AUTHORIZED
PAYMENT_ACTIONS=0
PAYPAL_LIVE=NO
STOP_AT_REVIEWER=YES
```


## K6_PHASE_D_R4_DETERMINISTIC_FILTERED_IMPORT_RETRY — RETURN_D_R4_WORDPRESS_CORE_FILES_MISSING (2026-09-26)

Authority read before execution: canonical VPS Project Governance v0.1.6 and active SSH/Secret, Target Host Reality, Storage Layout, and Governance Source Policy addenda; current Mini Craft Reviewer Handoff, Storage Manifest, D-R4 Reviewer Decision and Execution Pack, latest Evidence/Handoff, and the unique local Shared VPS Handoff. Strict recorded SSH identity/known_hosts fingerprint checks passed; each remote command used a bounded strict SSH session with the same recorded identity and pinned known_hosts; no trust or key changes occurred. SSH login was ops; privileged probe/runner executed through sudo -n.

### Fresh pre-import state and immutable source

- Target: srv1970241 / Ubuntu 24.04; root filesystem 12% used at preflight.
- At entry: existing MariaDB container running/healthy; WordPress stopped; MariaDB published-port binding 3306/tcp=null; WordPress 80/tcp=null; WordPress attached to the existing Mini Craft database and shared edge networks as previously configured. Shared Caddy remained the only host 80/443 owner; no shared network or ingress configuration was changed.
- Accepted K5 SQL source /srv/backups/mini-craft-night-kit/database-post-cleanup.sql: 5,286,165 bytes; SHA-256 BB6A9F56C532C395B89089FC460FB5F20A038A012C84DDD210DCCF5E1AB4C602 (PASS). The source was opened read-only and not modified.
- Deterministic lexical scan: 246 source statements; exactly one unguarded CREATE DATABASE wordpress; one USE wordpress; 52 CREATE TABLE targets; 52 DROP TABLE IF EXISTS targets exactly matching the CREATE set; 36 INSERT statements; zero prohibited account/database statements; zero schema-qualified DDL. INSERT values/content were not emitted.
- The in-memory filtered byte stream was formed by removing exactly the statement byte span, then independently reparsed. All retained statement byte slices matched source byte-for-byte and in order; CREATE/DROP table sets, INSERT count and USE wordpress remained unchanged; no new statement was introduced. Filtered length 5,286,040 bytes; SHA-256 78d0d25abceabeec37a663fca482d2ba03ea62d7345be0fd83999a47c21d17a8. The stream existed only in runner memory and was piped directly to the MariaDB client; no derived SQL file was persisted.

### Single import and verification

Immediately before import, root and app identities again saw wordpress = 0 tables; wp_options absent; only non-system schema was wordpress. Existing DB Secret files were used only in process memory to create mode-0600 client option files on MariaDB /dev/shm for authentication. Secret values were not emitted, hashed, logged, or recorded; the temporary option files were removed and absence verified after the DB readback.

FILTERED_STATEMENT_REMOVED=CREATE_DATABASE_WORDPRESS_EXACTLY_ONE
FILTERED_STREAM_INVARIANTS=PASS
FILTERED_STREAM_SHA256=78d0d25abceabeec37a663fca482d2ba03ea62d7345be0fd83999a47c21d17a8
IMPORT_RETRY_COUNT=1
IMPORT_NATIVE_EXIT=0
POSTIMPORT_ROOT_TABLE_COUNT=52
POSTIMPORT_ROOT_TABLE_SET_MATCH=PASS
POSTIMPORT_APP_TABLE_COUNT=52
POSTIMPORT_APP_TABLE_SET_MATCH=PASS
WP_OPTIONS_PRESENT=YES
NON_SYSTEM_SCHEMA_SET_MATCH=PASS
MARIADB_HEALTH=PASS

No --force, database drop/recreate, datadir reset, second import, or source SQL mutation occurred.

### WordPress continuation and stop boundary

After DB verification, the existing private WordPress service alone was started with the explicit production Compose file (compose start wordpress; native command exit 0). It remained running, restart count 0, with no host-port binding; MariaDB remained running/healthy, with no published port. The first WordPress bootstrap probe exited 255 with a PHP fatal: wp-load.php could not require /var/www/html/wp-includes/version.php because the file was reported absent. The command sequence stopped there; no follow-up route probe, file inspection, cleanup, or container stop was performed after the failure.

RESULT=RETURN_D_R4_WORDPRESS_CORE_FILES_MISSING
WORDPRESS_BOOTSTRAP=FAIL;NATIVE_EXIT=255
INSTALL_REDIRECT=NOT_CHECKED
HOME_SITEURL_SCALAR_UPDATE=NOT_EXECUTED
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
MARIADB=RUNNING_HEALTHY
WORDPRESS=RUNNING_BUT_BOOTSTRAP_FAILED
PUBLIC_INGRESS_CHANGE=0
SHARED_INFRA_WRITES=0
SECRET_VALUE_OR_HASH_ACCESS=0
PAYPAL_LIVE=NO
PAYMENT_ACTIONS=0
POST_RETURN_VPS_OPERATIONS=0
STOP_AT_REVIEWER=YES

No public route, DNS, Caddy, cloudflared, UFW, SSH, Docker daemon, or other-project change was made. No PayPal action or payment occurred. Reviewer direction is required before further WordPress inspection or recovery.

---

## K6_PHASE_D_R5_WORDPRESS_CORE_RUNTIME_DIAGNOSIS_AND_CONDITIONAL_RECREATE — RETURN (2026-09-26)

Authority read: canonical GitHub `entropy-student/spike.skill/vps-project-governance` v0.1.6 and current active addenda (Governance Handoff, SSH/Delegated Secret Operations rev2, Target Host Reality rev2, Storage Layout rev1, Governance Source Policy rev1); Mini Craft current Reviewer Handoff, Storage Manifest, D-R5 Decision/Execution Pack, latest Evidence/Handoff, and unique local Shared VPS Handoff. The recorded identity/public fingerprint and normal known_hosts pin matched. Strict SSH to `ops@2.24.193.133:22` succeeded; remote identity was `ops@srv1970241`, Ubuntu 24.04.5 LTS. No trust change or alternate client/key was used.

### Read-only runtime diagnosis

The explicit production Compose file was rendered/read in memory for metadata-only inspection; resolved config environment values were not emitted. The container/image/mount state was read through `sudo -n docker`; no start/stop/recreate/pull/build or database query/import occurred.

```text
WORDPRESS_IMAGE_REF=docker.io/library/wordpress@sha256:f5413918c7858c97bb7d2b65f68d3ed38a97472deba9eb58eb3e1ab1eb2c4beb
WORDPRESS_IMAGE_DIGEST=PASS
WORDPRESS_PLATFORM=linux/amd64
WORDPRESS_ENTRYPOINT=["docker-entrypoint.sh"]
WORDPRESS_COMMAND=["apache2-foreground"]
WORDPRESS_ENTRYPOINT_COMMAND=PASS
WORDPRESS_TMPFS_SPEC=rw,nosuid,nodev,size=512m
WORDPRESS_TMPFS_SIZE_BYTES=536870912
WORDPRESS_TMPFS_MOUNT=PASS
WORDPRESS_WP_CONTENT_BIND=PASS;/srv/data/mini-craft-night-kit/wp-content -> /var/www/html/wp-content
WORDPRESS_SECRET_MOUNTS=PASS;9_OF_9_READ_ONLY
WORDPRESS_DB_ROOT_MOUNTED=NO
WORDPRESS_CONTAINER=RUNNING;RESTARTS=0;HOST_PORTS=NONE
MARIADB_CONTAINER=RUNNING;HEALTHY
/usr/src/wordpress/wp-includes/version.php=PRESENT;1103_BYTES;0644;33:33
/usr/src/wordpress/index.php=PRESENT;405_BYTES;0644;33:33
/var/www/html/wp-includes/version.php=PRESENT;1103_BYTES;0644;33:33
/var/www/html/index.php=PRESENT;405_BYTES;0644;33:33
/var/www/html/wp-content=PRESENT;DIRECTORY;33:33
WORDPRESS_RECREATE_COUNT=0
STARTUP_LOG_CLASSIFICATION=NO_MATCHES_FOR_PHP_FATAL_ENTRYPOINT_COPY_PERMISSION_DENIED_INSTALLER_OR_DB_APACHE_ERROR
```

The first diagnostic draft exited before executing its Python probe because of a syntax error (SSH exit 1; no Docker command ran). A subsequent read-only checker initially classified the accepted `512m` tmpfs notation as mismatch because it expected a raw byte count (checker exit 43); a corrected unit-aware probe converted it to exactly 536,870,912 bytes and exited 0. This was an executor-side false-negative, not target runtime drift. The corrected strict read-only probe and separate host identity probe exited 0.

### Branch decision / stop

Fresh read-back differs from D-R4's first failed bootstrap observation: the official image source core and both runtime core files are now present, while image digest, linux/amd64 platform, entrypoint/command, tmpfs, wp-content bind, nine read-only Secret mounts, no-db-root boundary, no-host-port boundary, running WordPress and healthy MariaDB all match the accepted contract. The runtime core is present **before any recreate**, so the D-R5 conditional “recreate only if runtime core is missing/incomplete” is not triggered. No WordPress recreate was performed.

The D-R5 Decision/Pack gives post-bootstrap URL/route/WooCommerce checks only after its authorized conditional recreate path. Since that precondition no longer holds, this Executor did not run WordPress bootstrap/installer checks, did not update `home` or `siteurl`, and did not query or modify the accepted database. These remaining actions need Reviewer reconciliation for the newly observed state.

```text
RESULT=RETURN_REVIEWER_D_R5_RUNTIME_CORE_PRESENT_BEFORE_RECREATE_RECONCILIATION_REQUIRED
WORDPRESS_INSTALL_REDIRECT=NOT_CHECKED
HOME_SITEURL_SCALAR_UPDATE=NOT_EXECUTED
WORDPRESS_INTERNAL_PRIMARY_ROUTES=NOT_CHECKED
WOOCOMMERCE_CORE_STATE=NOT_CHECKED
MARIADB_RESTORE_STATE=PRIOR_ACCEPTED_52_TABLES;NOT_REQUERIED
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
VPS_WRITES=0
DOCKER_MUTATIONS=0
SHARED_INFRA_WRITES=0
PUBLIC_INGRESS_CHANGE=0
SECRET_VALUE_OR_HASH_ACCESS=0
PAYPAL_LIVE=NO
PAYMENT_ACTIONS=0
POST_RETURN_VPS_OPERATIONS=0
STOP_AT_REVIEWER=YES
```

No post-classification remote operation or cleanup was performed. No Secret/config/file contents were read or emitted.

---

## K6_PHASE_D_R6_BOOTSTRAP_RECONCILIATION_AND_PRIVATE_APP_VALIDATION — RETURN (2026-09-26)

Authority re-read: canonical `entropy-student/spike.skill/vps-project-governance` (`GOVERNANCE_HANDOFF.md`, `SKILL.md`, Governance v0.1.6, Governance Source Policy, SSH/Delegated Secret Operations rev2, Target Host Reality rev2, Storage Layout rev1); current Mini Craft `REVIEWER_HANDOFF.md`, `PROJECT_STORAGE_MANIFEST.md`, D-R6 Reviewer Decision and Execution Pack, latest Evidence/Handoff; and the unique local `SHARED_VPS_HANDOFF.md`.

Local SSH contract checks passed without reading private-key contents:
`IDENTITY_REFERENCE_CHECK=PASS`
`PUBLIC_FINGERPRINT_MATCH=PASS`
`KNOWN_HOSTS_PIN_CHECK=PASS`

A canonical strict SSH command was invoked for the bounded read-only Phase A, using the recorded `ops@2.24.193.133:22` identity, normal `known_hosts`, BatchMode, IdentitiesOnly, StrictHostKeyChecking, and bounded timeout. Native SSH exit status was 255. The wrapper had redirected SSH stderr, so the failure class and whether the remote read-only script began cannot be established from retained output. No alternate key/client, relaxed trust, or retry was attempted.

```text
RESULT=RETURN_SSH_CONNECTION_REQUIRED
SSH_CANONICAL_PROBE=NATIVE_EXIT_255
SSH_FAILURE_CLASS=UNCLASSIFIED_STDERR_NOT_RETAINED
PHASE_A=NOT_CONFIRMED
WORDPRESS/MARIADB_FRESH_STATE=NOT_CONFIRMED
DATABASE_ROOT_APP_TABLE_RECHECK=NOT_CONFIRMED
WORDPRESS_BOOTSTRAP=NOT_RUN
HOME_SITEURL_SCALAR_UPDATE=NOT_RUN
PRIVATE_ROUTE_VALIDATION=NOT_RUN
WORDPRESS_RECREATE_RESTART=0
DATABASE_IMPORT_OR_MUTATION=0
SECRET_VALUE_OUTPUT_HASH_ROTATION_OR_OVERWRITE=0
SHARED_INFRA_WRITES=0
REMOTE_WRITE_COMMANDS_INVOKED=0
PAYMENT_ACTIONS=0
PAYPAL_LIVE=NO_ACTION
POST_RETURN_REMOTE_OPERATIONS=0
STOP_AT_REVIEWER=YES
```

The remote payload contained only bounded read-only identity/container/network/UFW/Caddy-metadata and SQL SELECT checks; no lifecycle or write command was included. Because no successful remote result was received, no runtime, DB, bootstrap, or application PASS is claimed. Per the Gate stop rule, no further remote operation was made.

## K6_PHASE_D_R6R1_SSH_TRANSPORT_RECOVERY_AND_BOOTSTRAP_RESUME — STOP_AT_REVIEWER (2026-09-26)

```text
GATE=K6_PHASE_D_R6R1_SSH_TRANSPORT_RECOVERY_AND_BOOTSTRAP_RESUME
RESULT=RETURN_REVIEWER_D_R6R1_REMOTE_IDENTITY_PROBE_INVALID
LOCAL_IDENTITY_REFERENCE_CHECK=PASS
LOCAL_PUBLIC_FINGERPRINT_MATCH=PASS
LOCAL_KNOWN_HOSTS_PIN_CHECK=PASS
SSH_CANONICAL_PROBE=NATIVE_EXIT_0;EXACTLY_ONE_ATTEMPT
SSH_FAILURE_CLASS=NONE
SSH_HOST_KEY_PRESENTED=YES
SSH_HOST_KEY_MATCH=YES
SSH_AUTHENTICATED_TARGET=ops@2.24.193.133
REMOTE_HOSTNAME=srv1970241
REMOTE_IDENTITY_VERIFICATION=INCOMPLETE
PROBE_IMPLEMENTATION_NOTE=Username field queried the name for UID 0 rather than the effective SSH process identity; reported root@srv1970241 is not accepted as proof of the SSH user's identity.
D_R6_READINESS=NOT_RUN
WORDPRESS_BOOTSTRAP=NOT_RUN
HOME_SITEURL_SCALAR_UPDATE=NOT_RUN
REMOTE_APPLICATION_OR_DOCKER_CHECKS=0
REMOTE_WRITES=0
CONTAINER_LIFECYCLE_ACTIONS=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
POST_RETURN_REMOTE_OPERATIONS=0
STOP_AT_REVIEWER=YES
```

The strict SSH transport succeeded once with the recorded account and matching pinned host key. The remote probe printed the hostname, but its username check used UID 0 explicitly, so it could not certify the effective SSH user. The probe exited before Docker/application checks and made no remote changes. The one-attempt limit is exhausted; no retry or cleanup was performed. Reviewer direction is required before any further remote operation.


## K6_PHASE_D_R6R2_REMOTE_IDENTITY_RECONCILIATION_AND_BOOTSTRAP_RESUME — RETURN (2026-09-26)

Authority reread from current GitHub canonical versions: VPS Project Governance v0.1.6 and active references/addenda; Mini Craft Reviewer Handoff, Storage Manifest, R6R2 Decision and Execution Pack, original D-R6 Decision/Pack, latest Evidence/Handoff; and the unique local Shared VPS Handoff. Local identity reference, public fingerprint, and normal known_hosts pin set had already passed read-only verification. One strict SSH invocation was made; no retry or alternate trust path.

```text
SSH_NATIVE_EXIT=0
SSH_HOST_KEY_PRESENTED=YES
SSH_HOST_KEY_MATCH=YES
REMOTE_PRE_SUDO_WHOAMI=ops
REMOTE_PRE_SUDO_ID_UN=ops
REMOTE_PRE_SUDO_UID_NONZERO=YES
REMOTE_HOSTNAME=srv1970241
D_R6_READINESS=PASS
ROOT_TABLE_COUNT=52;ROOT_TABLE_SET_MATCH=YES
APP_TABLE_COUNT=52;APP_TABLE_SET_MATCH=YES
WP_OPTIONS_PRESENT=YES
WORDPRESS_RUNTIME_CORE=PASS
WP_CONTENT_BIND=PASS
WP_SECRET_ALLOWLIST=PASS_9_OF_9;DB_ROOT_NOT_MOUNTED
DB_SECRET_ALLOWLIST=PASS_2_OF_2
WP_TMPFS_512M=PASS
DB_NETWORK_PRIVATE=PASS
WORDPRESS_BOOTSTRAP=PASS
WORDPRESS_INSTALLED_STATE=YES
WOOCOMMERCE_CORE_STATE=PASS
HOME_SITEURL_ROW_CARDINALITY=2
HOME_SITEURL_PRESTATE=LOCALHOST_BOTH
HOME_SITEURL_SCALAR_UPDATE=COMMITTED_EXACTLY_TWO_ROWS
HOME_SITEURL_TRANSACTION=COMMITTED_AND_POSTREAD_VERIFIED
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
WORDPRESS_PRIVATE_PRIMARY_ROUTES=FAIL
PRIVATE_ROUTE_STATUS_SUMMARY=/:200;/shop/:200;/product/mini-craft-night-kit/:200;/cart/:200;/checkout/:302;/my-account/:200;/wp-json/:200
WP_CONTENT_MEDIA_STATE=PASS
PPCP_ACTIVE=YES
PAYPAL_MODE=UNVERIFIED
PAYPAL_LIVE=UNVERIFIED
WORDPRESS_RECENT_FATALS=0
WORDPRESS_RESTART_COUNT=0;STABLE=YES
MARIADB_HEALTH=HEALTHY
DB_PUBLIC_PORT=NONE
WORDPRESS_HOST_PORT=NONE
CADDY_STATE=UP
CLOUDFLARED_STATE=UP
CURRENT_80_443_OWNER=CADDY
UFW_STATE=ACTIVE
MINICRAFT_DOMAIN_IN_CADDY=NO;SHARED_CADDY_WILDCARD_PRESENT=NO
UNRELATED_SERVICES_CHANGED=NO
PUBLIC_INGRESS_CHANGE=0
SECRET_VALUE_OR_HASH_ACCESS=0
REMOTE_TMPFS_DB_AUTH_CLEANUP=PASS
LOCAL_SSH_DIAGNOSTIC_TEMP_CLEANUP=PASS
SHARED_INFRA_WRITES=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
RESULT=RETURN_REVIEWER_D_R6R2_PRIVATE_APP_VALIDATION_FAILED
STOP_AT_REVIEWER=YES
```

The exact-two-row scalar update was the only database write. Both values were verified after commit. No serialized content was migrated. Private GET probes did not follow redirects: six primary routes returned 200; Checkout returned 302 and was not classified as the expected same-path canonical HTTPS redirect. The redirect target was not retained or emitted. PPCP was active, but the bounded known-setting marker probe did not establish Sandbox mode; consequently neither Sandbox nor Live-disabled state is claimed as verified. These two validation gaps caused the RETURN. No further remote command, retry, lifecycle action, payment, or public-ingress action was performed.

DB authentication used only the existing mounted database credentials through short-lived mode-0600 option files in the MariaDB container's verified /dev/shm tmpfs; those files were removed and absence checked. No credential value or hash was inspected for reporting, emitted, or recorded. The one-time local non-secret executor and stderr sink are absent/cleaned.

## K6_PHASE_D_R6R3_PRIVATE_APP_VALIDATION_RECONCILIATION — RETURN (2026-09-26)

The current GitHub Reviewer Handoff, Storage Manifest, R6R3 Decision/Execution Pack, latest accepted project evidence, canonical Governance v0.1.6 and active addenda were read. The unique local Shared VPS Handoff was read. Local identity reference, recorded public fingerprint, and normal known_hosts entry were verified. No private-key material was read.

A single strict SSH invocation was submitted through the local PowerShell execution wrapper, but the wrapper returned no inspectable stdout/stderr/native exit metadata to this Executor. It is therefore not possible to establish whether SSH reached the host or whether the remote read-only payload began. No second SSH invocation was made. All fresh remote facts and all later phases remain unverified; no prior PASS is promoted to fresh evidence.

```text
GATE=K6_PHASE_D_R6R3_PRIVATE_APP_VALIDATION_RECONCILIATION
RESULT=RETURN_REVIEWER_D_R6R3_EXECUTOR_RESULT_UNAVAILABLE
SSH_NATIVE_EXIT=UNAVAILABLE_FROM_EXECUTION_WRAPPER
SSH_HOST_KEY_MATCH=UNVERIFIED_THIS_GATE
REMOTE_IDENTITY=UNVERIFIED
WORDPRESS_RUNTIME_CONTINUITY=UNVERIFIED
WORDPRESS_RESTART_COUNT=UNVERIFIED
MARIADB_HEALTH=UNVERIFIED
HOME_SITEURL_READBACK=UNVERIFIED
WORDPRESS_HOST_PORT=UNVERIFIED_THIS_GATE;PRIOR_ACCEPTED_NONE
DB_PUBLIC_PORT=UNVERIFIED_THIS_GATE;PRIOR_ACCEPTED_NONE
CHECKOUT_PRIVATE_STATUS=UNVERIFIED
CHECKOUT_REDIRECT_TARGET=NOT_CAPTURED
CHECKOUT_EMPTY_CART_BEHAVIOR=UNVERIFIED
PPCP_STATE_READ_METHOD=NOT_CONFIRMED_REACHED
PPCP_ACTIVE=UNVERIFIED
PPCP_MERCHANT_CONNECTED=UNVERIFIED
PPCP_SANDBOX_ENABLED=UNVERIFIED
PPCP_ONBOARDING_COMPLETED=UNVERIFIED
PPCP_LIVE_ENABLED=UNVERIFIED
WORDPRESS_PRIVATE_APP_VALIDATION=NOT_CLOSED
D_R6_PRIVATE_RUNTIME_VALIDATION=NOT_CLOSED
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
DB_WRITES=0
WORDPRESS_RESTART_RECREATE=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
LOCAL_TEMP_CLEANUP=PASS_NO_DISK_TEMP_CREATED
REMOTE_POST_RETURN_ACTIONS=0
STOP_AT_REVIEWER=YES
```

The submitted remote payload contained only read-only container/network metadata, bounded WordPress option-status comparisons, one anonymous private Checkout GET with redirect following disabled, and allowlisted PPCP REST GET state extraction; it contained no DB write, lifecycle operation, cart/session/order/payment action, Provider request, Secret inspection/hash, or infrastructure mutation. Because the execution result was not observable, none of those read results is claimed. No local diagnostic file or remote temporary file was intentionally created, so no post-return cleanup was run.



## K6_PHASE_D_R6R3R1_EXECUTION_WRAPPER_RECOVERY_AND_PRIVATE_VALIDATION_RESUME — RETURN (2026-09-26)

Authority reread from current GitHub: Reviewer Handoff, Storage Manifest, current D-R6R3R1 decision and pack, original D-R6R3 decision and pack, latest Evidence/Handoff, canonical Governance v0.1.6 and active SSH/Storage/Target Host addenda. The unique local Shared VPS Handoff was read. No Secret or private-key content was accessed.

```text
LOCAL_WRAPPER_STDOUT_CAPTURE=PASS
LOCAL_WRAPPER_STDERR_CAPTURE=PASS
LOCAL_WRAPPER_NATIVE_NONZERO_EXIT_CAPTURE=PASS_EXPECTED_7
LOCAL_OPENSSH_EXECUTABLE=C:\\WINDOWS\\System32\\OpenSSH\\ssh.exe
LOCAL_OPENSSH_VERSION_CAPTURE=PASS;OpenSSH_for_Windows_9.5p2, LibreSSL 3.8.2
LOCAL_OPENSSH_VERSION_NATIVE_EXIT=PASS;0
SSH_NATIVE_EXIT=0
SSH_HOST_KEY_PRESENTED=YES
SSH_HOST_KEY_MATCH=YES
SSH_FAILURE_CLASS=NONE
REMOTE_IDENTITY=ops@srv1970241;PRE_SUDO_WHOAMI=ops;ID_UN=ops;UID_NONZERO=YES
WORDPRESS_RUNTIME_CONTINUITY=RUNNING;PROJECT_CONTAINER_COUNT=2
WORDPRESS_RESTART_COUNT=0;STABLE=YES
WORDPRESS_RUNTIME_CORE=PASS
MARIADB_HEALTH=HEALTHY
HOME_SITEURL_READBACK=PASS_TARGET
WORDPRESS_HOST_PORT=NONE
DB_PUBLIC_PORT=NONE
MINICRAFT_PUBLIC_INGRESS=NONE
UNRELATED_SERVICES_CHANGED=NO;EIGHT_ACCEPTED_BASELINE_CONTAINERS_UP;SHARED_NETWORKS_PRESENT
CHECKOUT_PRIVATE_STATUS=302
CHECKOUT_REDIRECT_TARGET=https://minicraft.spikersun.com/cart/
CHECKOUT_EMPTY_CART_BEHAVIOR=PASS_EXPECTED_CART_REDIRECT
PPCP_STATE_READ_METHOD=ACCEPTED_REST_DO_REQUEST_GET_COMMON_AND_ONBOARDING
PPCP_ACTIVE=YES
PPCP_MERCHANT_CONNECTED=YES
PPCP_SANDBOX_ENABLED=YES
PPCP_ONBOARDING_COMPLETED=UNVERIFIED
PPCP_LIVE_ENABLED=NO
PPCP_STATE_RESULT=UNAVAILABLE
WORDPRESS_PRIVATE_APP_VALIDATION=NOT_CLOSED
D_R6_PRIVATE_RUNTIME_VALIDATION=NOT_CLOSED
PAYPAL_SANDBOX_LOCAL_CONFIG_STATE=PARTIAL;ONBOARDING_UNVERIFIED
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
REMOTE_WRITES=0
DB_WRITES=0
WORDPRESS_RESTART_RECREATE=0
CART_SESSION_SETUP_ACTIONS=0
ORDER_ACTIONS=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
SSH_RAW_STDERR_RECORDED=NO;IN_MEMORY_CLASSIFICATION_ONLY
LOCAL_TEMP_CLEANUP=PASS_NO_DISK_TEMP_CREATED
REMOTE_POST_RETURN_ACTIONS=0
STOP_AT_REVIEWER=YES
RESULT=RETURN_REVIEWER_D_R6R3R1_PPCP_MODE_READBACK_UNAVAILABLE
```

Phase 0 passed before the sole strict SSH invocation. The request used the recorded identity and normal known_hosts with strict checking; the presented host key matched the accepted pin. The one private anonymous Checkout GET did not follow redirects and returned the accepted same-canonical-origin Cart redirect. No cart/session setup, order, payment, provider request, or state write was performed.

The accepted PPCP common-state route returned connected=YES and Sandbox markers=YES; however, the bounded authoritative onboarding GET did not yield a confirmed `completed` boolean. This Gate therefore cannot close private application validation. No retry, alternative PPCP probe, or further remote operation was performed after the RETURN.


## K6_PHASE_E_SERIALIZED_SAFE_URL_MIGRATION — RETURN (2026-09-26)

Authority re-read from current GitHub: canonical VPS Project Governance v0.1.6 and active SSH/target/storage references, current Mini Craft Reviewer Handoff and Storage Manifest, Phase E Reviewer Decision and Execution Pack, latest Evidence/Handoff, and the unique local Shared VPS Handoff. No Secret values, hashes, private-key contents, or credential-bearing config values were accessed.

Fresh strict SSH continuity probe:
```text
SSH_NATIVE_EXIT=0
SSH_HOST_KEY_MATCH=YES
REMOTE_IDENTITY=ops@srv1970241
WORDPRESS_RUNTIME=RUNNING;RESTART_COUNT=0
MARIADB_RUNTIME=RUNNING;HEALTH=HEALTHY;RESTART_COUNT=0
WORDPRESS_HOST_PORT=NONE
DB_PUBLIC_PORT=NONE
ROOT_DISK_USED_PERCENT=12
ROOT_DISK_AVAILABLE_BYTES=91357675520
RAM_AVAILABLE_BYTES=5611958272
MINICRAFT_PUBLIC_INGRESS=NONE
```

Image/tool seal:
```text
APP_IMAGE_IDENTITY=PASS_EXACT_FROZEN_LINUX_AMD64_DIGEST
APP_IMAGE_CONFIG_REF_AND_REPODIGEST=PASS
WPCLI_IMAGE=docker.io/library/wordpress@sha256:aa31002b5ae67cfff25817c8f4379b0e84aa4f8cc9637c83e16757d435adaf49
WPCLI_IMAGE_PULL=PULLED_EXACT_DIGEST;PULL_NATIVE_RESULT=SUCCESS
WPCLI_IMAGE_IDENTITY=PASS_EXACT_LINUX_AMD64_REPODIGEST
```

An initial Executor-side app-digest literal omitted four characters from the GitHub-frozen digest; the exact comparison correctly stopped before helper creation. It was corrected to the full 64-hex Reviewer value. Fresh container config and RepoDigest then matched the frozen digest exactly; this was a command-copy error, not runtime image drift. No app image was pulled or changed.

A disposable extraction attempt successfully copied only `/usr/local/bin/wp` from the exact WP-CLI image. A disposable WordPress helper was then started from the accepted app image on the Mini Craft database-private network, with no host port, a 512MiB docroot tmpfs, the current wp-content bind read-only, and the nine intended WordPress secret file mounts read-only (the command did not include db-root). The official entrypoint did not reach the bounded core-ready check; the helper attempt returned before WP-CLI/DB validation. The helper, extraction container, and project-scoped temporary binary/path were removed. Final read-only reconciliation confirmed:
```text
EXTRACTION_CONTAINER=PRESENT_NONE
MIGRATION_HELPER=PRESENT_NONE
PROJECT_TEMP_TOOL_PATH=PRESENT_NONE
WORDPRESS_RUNTIME=RUNNING;RESTART_COUNT=0
MARIADB_RUNTIME=RUNNING;HEALTH=HEALTHY
HOST_PORT_BINDINGS=NONE
```

No WP-CLI command was run against the database. The following were therefore not reached and are not claimed:
```text
WPCLI_VERSION=UNVERIFIED_HELPER_NOT_READY
MIGRATION_HELPER=RETURN_CORE_READY_TIMEOUT
OLD_ORIGIN_A_DRYRUN_COUNT=NOT_RUN
OLD_ORIGIN_B_DRYRUN_COUNT=NOT_RUN
PRE_MIGRATION_BACKUP=NOT_CREATED_NOT_REACHED
OLD_ORIGIN_A_REPLACED=NOT_RUN
OLD_ORIGIN_B_REPLACED=NOT_RUN
POST_MIGRATION_OLD_ORIGIN_A=NOT_RUN
POST_MIGRATION_OLD_ORIGIN_B=NOT_RUN
HOME_SITEURL=NOT_REVERIFIED_THIS_GATE;D_R6_ACCEPTED_TARGET_REMAINS_BASELINE
WORDPRESS_PRIVATE_ROUTES=NOT_RUN
PPCP_STATE=NOT_REQUERIED;ACCEPTED_D_R6R3R1_BASELINE_REMAINS
WORDPRESS_RECENT_FATALS=NOT_RECHECKED
```

The D-R6 accepted 52-table baseline was not re-imported or rewritten. Since helper readiness failed, no search-replace dry-run, pre-migration backup, or migration was attempted:
```text
MARIADB_TABLE_SET=UNCHANGED_BY_THIS_GATE;NO_DB_COMMANDS
GUID_MUTATIONS=0
DB_WRITES=0
WORDPRESS_RESTART_RECREATE=0
PUBLIC_INGRESS_CHANGE=0
PAYMENT_ACTIONS=0
LIVE_ACTIONS=0
SECRET_VALUE_OR_HASH_ACCESS=0
SHARED_INFRA_WRITES=0
TEMP_HELPERS_CLEANED=PASS
CACHED_WPCLI_IMAGE=RETAINED_AS_AUTHORIZED
FULL_SERIALIZED_URL_MIGRATION=DEFERRED_NOT_WAIVED
RESULT=RETURN_REVIEWER_E_MIGRATION_HELPER_INITIALIZATION_FAILED
STOP_AT_REVIEWER=YES
```

Reviewer follow-up is required to resolve the disposable helper's official-entrypoint/core initialization constraint while preserving the read-only wp-content bind. No public ingress, webhook/provider action, payment, or Live action was entered.
