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
