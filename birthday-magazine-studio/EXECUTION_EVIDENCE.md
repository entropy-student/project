# G2A1 Execution Evidence — Frontend and Reusable Component Feasibility

**Original Gate:** `G2A1_FRONTEND_AND_REUSABLE_COMPONENT_FEASIBILITY_POC`
**Original execution date:** 2026-09-26
**Current closure Gate:** `G2A1R1_EVIDENCE_CLOSURE`
**R1 closure date:** 2026-09-27
**Original G2A1 branch:** `codex/birthday-magazine-g2a1-component-feasibility`
**R1 closure branch:** `codex/birthday-magazine-g2a1r1-evidence-closure`
**Environment:** disposable local Docker Compose stack at `http://127.0.0.1:8127`; WordPress 7.0.4, PHP 8.3.33, MariaDB 11.4.13, WooCommerce 11.1.2; local Mailpit v1.31.2 added for G2A1R1.
**Scope:** synthetic inputs, no external payment, no customer data, no AI/API credentials, no production or public host.

## Result summary

| Question | Evidence-based finding |
|---|---|
| Frontend route | Route C is the only route that met the current browser-local preview and WooCommerce-path requirements in the installed runtime. It is a Good Issue-style experience rendered by a small WordPress plugin/shortcode and links to a native WooCommerce product. This is a feasibility preference for Reviewer consideration, not a product/contract decision. |
| Storelly | Not accepted for the free preview. The free builder’s image editor uploads to the WordPress server, so a selected photo leaves the browser. In addition, the tested Storelly product page raised a PHP fatal error and returned HTTP 500. Storelly Cloud was not connected. |
| Upload Files | Registered-account order binding, two one-file slots, and the 375px account upload passed. Guest order page could not be fully verified because WooCommerce requires email verification and this local environment has no working mail transport. Return the guest path for Reviewer decision. |
| Attach Me | Registered order access control passed positive and negative checks; direct uploads URL was denied. Guest order delivery was not fully verified because the same WooCommerce email verification step could not be completed. Return the guest path for Reviewer decision. |
| Commerce | Each preview CTA reached the $39.99 WooCommerce product, add-to-cart and cart. Checkout rendered but had no payment method configured. No payment was attempted or submitted. |

## Current G2A1R1 closure result — supersedes the earlier guest-path gaps below

The original G2A1 findings remain historical context. This section records the later guest-order checks and controls the current handoff. The Gate remains open for Reviewer because both plugins' guest download links were replayable from an unrelated guest context.

| Check | Latest result | Evidence |
|---|---|---|
| Local email capture | **PASS** | Mailpit `axllent/mailpit:v1.31.2` (MIT; image digest `sha256:74d609a42ec279aa63c6b4622a6fa9b5408d1ad5b1d76a1c4be40a265ce0863d`). The service UI binds to `127.0.0.1:8128`; SMTP port 1025 has no host port mapping and is reachable by Compose services only. A synthetic `.invalid` `wp_mail()` probe was captured and the inbox was cleared. Guest verification began and ended with zero captured messages: this WooCommerce 11.1.2 flow compares the entered billing email on the order-received page and does not send a verification email/code. The local-only PHPMailer helper points to `mailpit:1025`; no external SMTP provider or relay was configured, and no production mail was sent. |
| Guest upload positive | **PASS** | A verified synthetic guest selected `synthetic-cover.png` in the order page at a 375px viewport. The browser sent the upload to the local WordPress `admin-ajax.php` path (three observed AJAX responses were HTTP 200); the file then appeared in that guest order's plugin metadata and order page. Stored size was 19,575 bytes under `wp-content/uploads/wcuf/{order}/{line}/`. The persisted result is shown in the guest upload screenshot. |
| Guest upload negative and raw file | **PARTIAL / RETURN** | A wrong email remained at the verification form; an unrelated guest order showed no upload record; raw storage URL returned HTTP 403. However, replaying the plugin's secure download link from the unrelated guest context returned HTTP 200. The link is a bearer capability after issuance, so the required unrelated-context denial did not pass. The secure URL is omitted from this document. |
| Guest private delivery positive | **PASS** | The synthetic text fixture was attached to the guest order through the Attach Me HPOS order panel. A verified guest order page displayed the attachment, and an actual download returned HTTP 200. Downloaded size was 112 bytes; SHA-256 `BD0BB9457A549F5C96A149308A8888E3B4B19FAB77311E4D0F72CC35FFE0A115` matched the committed `poc/g2a1/fixtures/synthetic-proof.txt`. |
| Guest private delivery negative and raw file | **PARTIAL / RETURN** | The unrelated guest order page did not list the attachment and the raw protected storage URL returned HTTP 403. Replaying the Attach Me download link in the unrelated guest context returned HTTP 200, so the required unrelated-context denial did not pass. No signed URL, order key, cookie, or token is included here. |
| Browser-local preview | **PASS; existing accepted result re-read** | Fresh run with the optional synthetic cover showed all preview images using `blob:` sources, no HTTP request or POST after selection, no external origin, and the preview CTA reached the dummy WooCommerce product, cart, and checkout routes. No model/API call was made. |
| Durable screenshots | **PASS** | `docs/evidence/g2a1r1/good-issue-wordpress-desktop.png`, `good-issue-wordpress-375px.png`, `guest-upload-result-375px.png`, and `guest-private-delivery-result-375px.png`. Guest screenshots use synthetic data and mask the email value. |

**Current component disposition:** `ORDER_UPLOAD=RETURN` and `PRIVATE_DELIVERY=RETURN` for the strict guest-context boundary. The plugins did bind the uploaded file and attachment to their orders, and raw storage URLs failed closed. The reproducible cross-context replay of each issued guest download link is a material limitation. Do not describe either plugin as accepted for guest delivery on this evidence.

## Test object inventory

| Object | Exact installed version | Source / license boundary | Install and runtime |
|---|---:|---|---|
| WordPress | 7.0.4 | Official WordPress image; GPL project | Local only; bound to loopback. |
| WooCommerce | 11.1.2 | [WordPress.org plugin directory](https://wordpress.org/plugins/woocommerce/); GPL | Active. Dummy product, cart and checkout routes worked. No gateway configured. |
| Kadence theme | 1.5.2 | [WordPress.org theme directory](https://wordpress.org/themes/kadence/); free theme with paid commercial upgrades | Active for Route A shell and shared preview pages. The named Jewelry Shop starter site was not imported. |
| Kadence Starter Templates | 2.3.4 | WordPress.org plugin; free plugin with optional paid template/content offerings | Active. No starter-site import was run. |
| Blocksy theme | 2.1.57 | [WordPress.org theme directory](https://wordpress.org/themes/blocksy/); free theme with paid commercial upgrades | Installed, inactive in final runtime. Route B page was rendered with the Blocksy shell. The named Modern Shop starter site was not imported. |
| Blocksy Companion | 2.1.57 | [WordPress.org plugin directory](https://wordpress.org/plugins/blocksy-companion/); free plugin with optional paid features | Active during Route B capture. No starter-site import was run. |
| Storelly Product Builder for WooCommerce | 1.7.1 | [WordPress.org plugin directory](https://wordpress.org/plugins/storelly-product-builder-for-woocommerce/); free local plugin; optional cloud rendering, dashboard/analytics and premium templates are separate paid capabilities | Installed, activated for runtime probe, then deactivated after product-page fatal. See Storelly evidence below. |
| Vanquish Upload Files for WooCommerce | 1.6.0 | [WordPress.org plugin directory](https://wordpress.org/plugins/vanquish-upload-files-for-woocommerce/); free version; multiple files per field and cloud storage are Premium | Installed and active. Account orders A/B each exposed two one-file fields. Order A desktop upload and Order B 375px upload were bound to their respective orders. |
| Vanquish Attach Me for WooCommerce | 1.1.0 | [WordPress.org plugin directory](https://wordpress.org/plugins/vanquish-attach-me-for-woocommerce/); free version; customer approval, expiry/download limits and some convenience surfaces are Premium | Installed and active. Synthetic proof fixture attached to Order A. Positive/negative authorization checks passed for registered users. |
| `Birthday Magazine G2A1 Preview` local plugin | 0.1.0 | Local PoC code, GPL-2.0-or-later header | Active and mounted read-only. Provides the Good Issue-like input/preview and WooCommerce CTA. |

The official WordPress.org pages above provide the current free/Premium boundary descriptions. The precise installed versions are from the local WordPress plugin/theme inventory. No premium plugin, license or cloud account was purchased or connected. Optional Freemius opt-ins were skipped.

Official ZIP archives were retained temporarily in `poc/g2a1/packages/` during installation. SHA-256 before cleanup:

| Archive | SHA-256 |
|---|---|
| `woocommerce-11.1.2.zip` | `9DE9350A1CF5671B9960AFB3151F40F7980E223217A441BF2EA5921B5FCE8E9E` |
| `kadence-1.5.2.zip` | `4773B41CD2DA71BDD2519AEDC8BB671EC0D4BEC33ACF6DB6592A40C614C2461B` |
| `kadence-starter-templates-2.3.4.zip` | `7EA5234938C589BB9C1B76A5EB97FAC7A17154F74511A0538732AC32E39CD8B8` |
| `blocksy-2.1.57.zip` | `077BA9E5001D01B08A06360E0E0CB4659842C7C5AF7EAAA58B92945E5982173D` |
| `blocksy-companion-2.1.57.zip` | `F77F6738F71F9C18020F576676D6FC829D70323C712AF09AD290D2BAB6C55072` |
| `storelly-1.7.1.zip` | `11906D9BC346B03AD6F5FA1C9C038190A40188929102A7778DC35AADA1A56706` |
| `vanquish-upload-files-1.6.0.zip` | `79D49FDAF7033FD2357CA106F5A850FFB956BB0B8840CD102BF1A0136A38DAC6` |
| `vanquish-attach-me-1.1.0.zip` | `FED1FA68D8D8DDCD0AFCFE847ED85D4A566819676AC9D4D7B1548A381C3E8C64` |

Synthetic fixture SHA-256:

| Fixture | SHA-256 |
|---|---|
| `synthetic-cover.png` | `BD36A1AF8B85EF8CAD9CEAC6FD048FEBF5F5578E3D77FE07D6ED9B404B41339D` |
| `synthetic-detail.png` | `9F1465BC1208D3CE671E44E4E33CD950E56485D9FB557479C48D6BEB55BEC910` |
| `synthetic-proof.txt` | `B4B4CADE0C5F226A25E7C5C9512F5C17A726C63BBCF4DDCAC25BCE2C7F21480D` |

## Routes A/B/C

All three routes used the same minimal WordPress page content and Good Issue-style `[bms_preview product_id="11"]` shortcode to keep the test bounded. Route A used the Kadence shell, Route B the Blocksy shell, and Route C applied the Good Issue page shell inside the same WordPress site. These were not three completed websites. The named Kadence Jewelry Shop and Blocksy Modern Shop starter sites were not imported, so their demo-page fidelity, block composition and import-time dependency/licensing behavior remain unverified.

| Route | Runtime page | Desktop and 375px result | Good Issue migration / code | Editor and WooCommerce fit | Result |
|---|---|---|---|---|---|
| A — Kadence Jewelry Shop + Storelly | `/?page_id=12` | Kadence header/footer around the page. 375px preview fit without body horizontal overflow after a small route CSS override. | Storelly is not viable for the photo-local preview; fallback shortcode is the same local code as C. | Theme header/footer and page shell stay editable in WP. Preview UI labels, copy and behavior are hardcoded in the custom shortcode. The shortcode page links into native WooCommerce. Exact Jewelry Shop starter import not tested. | Return Storelly path; base Kadence shell is feasible but not enough evidence to accept the named starter-site combination. |
| B — Blocksy Modern Shop + Storelly | `/?page_id=125` | Blocksy shell and preview visible at 1440px and 375px. 375px body/document width remained at the 375px viewport. | Same Storelly constraint. Fallback preview uses the same local code as C. | Theme/page shell is WP-editable. Preview UI labels, copy and behavior are hardcoded in the custom shortcode. Native WooCommerce product/cart path remained available. Exact Modern Shop starter import not tested. | Return Storelly path; base Blocksy shell is feasible but not enough evidence to accept the named starter-site combination. |
| C — Good Issue moved into WP + WooCommerce | `/?page_id=126` | Good Issue-style page shell rendered inside WordPress at 1440px and 375px, with no horizontal document overflow. | Approx. 6.5 KB PHP, 2.6 KB JS, 12.2 KB CSS and 1.1 KB route CSS in the local PoC. The JS uses `URL.createObjectURL()` and revokes the blob URL. | Page shell and the shortcode placement are editable in WP. Preview UI content/controls are in custom PHP/CSS/JS and are not field-editable in the WP editor. CTA uses `get_permalink(11)` and the native Woo product, cart and checkout. | Preferred feasibility route, subject to Reviewer decision. |

### Frontend evidence details

- Inputs are name, age, cover style, and optional one local image. The screen renders one cover plus one sample spread immediately; no LLM, vision, image-generation or server-side image rendering is used.
- Synthetic local image preview displayed from a `blob:http://127.0.0.1:8127/...` URL. The browser Network/WordPress access-log check showed page asset GETs but no image POST during this preview. This is distinct from the upload plugin, which intentionally transfers order files to the local WordPress server.
- The local photo was not persisted in WordPress Media Library or an order by the preview code. The selected file remains in the browser page context; `pagehide` revokes the object URL.
- Storelly’s frontend source uses its upload/AJAX path and WordPress sideload handling, which stores the image on the WordPress server. This is a code-inspection finding; the Storelly image editor itself could not be exercised on the test product because the product page failed first.
- Storelly product request for the dummy magazine returned HTTP 500. Local PHP log pointed to `includes/class-request-quote.php:335`, where `SPBWC_Request_Quote->enqueue_assets()` called `get_id()` on a string. Storelly was then deactivated; no patch/workaround was applied.
- No Storelly Cloud account, PDF export, premium template import or external service was connected. Optional Cloud PDF/dashboard capabilities are outside the free local builder boundary.
- Admin editing boundary: WordPress can edit the page and shortcode placement; the preview interface's copy, controls and generation behavior currently require PHP/CSS/JS edits. Theme shell settings remain in the theme editor/customizer. The Vanquish upload/order metadata and Attach Me order attachment records are plugin-specific; no cross-plugin migration was tested.
- The label “US$39.99” on the preview CTA leads to dummy Woo product ID 11, whose WooCommerce price is 39.99. Add-to-cart added one item and the Cart showed that item. Checkout loaded with “There are no payment methods available.” No gateway setup, payment submission or checkout order was performed.
- Desktop and 375px screenshots for A/B/C were captured in the CUA browser during the execution. The 375px Order B upload screen/result was also captured inline in the execution transcript. Screenshot bytes were not exported as project files by the browser-control surface; the project evidence therefore records viewport/DOM measurements rather than linking image files. Reviewer should treat this as a packaging gap if persistent screenshot artifacts are required.
- Syntax checks: local preview PHP passed `php -l`; `node --check` passed for `preview.js`.

## Vanquish Upload Files — order-bound customer uploads

**Exact object:** Vanquish Upload Files for WooCommerce 1.6.0, free WordPress.org build.
**Local synthetic test objects:** dummy product ID 11 at $39.99; registered account Order A ID 128; registered account Order B ID 129; guest Order ID 130. Orders were synthetic and their status was manually set to `processing` for the local order-page probe; that status does not represent a payment.

| Requirement | Evidence |
|---|---|
| Install/runtime | Installed and active. Two independent “Order photo slot” fields appeared on the customer order page. Each input had `multiple=false`, `accept=".jpg,.jpeg,.png,.webp"`, and a one-file maximum. |
| Multiple images | Free version supports one file per configured field. Two fields accepted cover and detail as separate files. Multiple files in one field is Premium. Per-product/category field restriction and per-field size settings are Premium. |
| Order binding | Order A stored `synthetic-cover` and `synthetic-detail` under `wp-content/uploads/wcuf/128/11-0/`. At 375px, customer B uploaded `synthetic-detail.png`; it appeared on Order B #129 and the file existed under `wp-content/uploads/wcuf/129/11-0/`. Customer B could not open Order A (WooCommerce displayed “Invalid order”). |
| Mobile | At a 375px browser viewport, the upload field remained selectable and the synthetic file appeared in the order details. The underlying order table measured about 456px wide while the viewport was 375px, so some table content can be clipped horizontally even though the outer document reports no horizontal overflow. A physical phone was not tested. |
| Format and size | File inputs accepted JPG/JPEG, PNG and WebP. PHP limits were `upload_max_filesize=2M`, `post_max_size=8M`, `wp_max_upload_size=2,097,152` bytes. Free UI did not expose per-field min/max size controls; practical upload ceiling is constrained by the 2 MiB server setting and available disk/time. |
| Storage/URL | Files were stored on the local WordPress server under `wp-content/uploads/wcuf/{order_id}/{product-line}/`. Secure links were enabled (`vanupfi_secure_links=1`) with `order_placed` association. The generated parent `.htaccess` denied direct access; a raw file URL returned HTTP 403. Authorized order page used the plugin’s order access path. |
| Positive access | Customer A’s Order A page displayed both files. Customer B’s Order B page displayed its own uploaded file. |
| Negative access | Customer B requested Order A and received WooCommerce “Invalid order”. A request without the order key did not reveal Order A file content. Raw static uploads URL returned 403. |
| Guest behavior | **Historical initial G2A1 probe; superseded by the G2A1R1 closure section above.** That probe stopped at WooCommerce's guest email-comparison form before local mail capture was added. |
| Network | Order files were intentionally uploaded to the local WordPress instance. No third-party cloud destination was configured; Dropbox/S3/Google Drive are Premium choices and were not enabled. |
| Limitations | Two separate fields are needed for two free uploads. We did not test physical iOS/Android picker behavior, large uploads, every MIME edge case, or guest verification delivery. The plugin exposes separate Free/Premium capability boundaries rather than requiring a custom upload system for the registered-account path. |
| Cleanup | Order files and test orders live only in the disposable project-scoped DB/files volumes, scheduled for removal at the end of this Gate. Synthetic fixtures remain under the PoC directory. |

## Vanquish Attach Me — private proof delivery

**Exact object:** Vanquish Attach Me for WooCommerce 1.1.0, free WordPress.org build.
**Fixture:** synthetic `synthetic-proof.txt` (111 bytes). Attached to Order A ID 128 only.

| Requirement | Evidence |
|---|---|
| Install/runtime | Installed and active. Admin HPOS order screen showed the Attachments panel; the fixture saved with title “Synthetic proof fixture” and a customer order-details link. No email options were selected and no message was sent. |
| Positive access | Customer A’s Order A page showed an Attachments section with a signed Download/View action. The plugin’s actual `Delivery::can_access()` check returned `true` for the owning registered customer. |
| Negative access | The same authorization check returned `false` for unrelated customer B. B could not view Order A through WooCommerce. |
| Storage/URL | Fixture stored under `wp-content/uploads/vanquish-attach-me/128/{unguessable-folder}/synthetic-proof-….txt`; the folder `.htaccess` denies all direct requests. Raw storage URL returned HTTP 403. Customer access routes through the plugin download handler with entitlement checking; it is not merely a hidden `/uploads/...` link. No signed bearer URL is reproduced here. |
| Download verification | Authorized UI link was visible and source/access checks were positive; the browser download event did not complete in this harness, so content delivery was not confirmed by a completed browser download. Reviewer should distinguish the access decision from a confirmed downloaded-byte response. |
| Guest behavior | **Historical initial G2A1 probe; superseded by the G2A1R1 closure section above.** The later verified guest download succeeded, but the issued guest download link replayed successfully in an unrelated guest context, so the current result remains `RETURN`. |
| Free boundary | Free order attachments and protected order access worked. Customer approval and availability/expiry/download-limit controls are Premium. Free files can be kept local and are not sent to an external service unless the optional Freemius opt-in/licensing flow is enabled; opt-in was skipped. |
| Cleanup | Attachment and metadata are confined to the disposable project-scoped WordPress/DB volumes and will be removed with this stack. |

## Network, privacy and external-service record

- No PayPal, payment gateway, sandbox, real payment, production domain, VPS, Cloudflare or shared infrastructure was used.
- No AI, LLM, vision or image-generation API was invoked. No API key or secret was added.
- The free preview used a browser `blob:` URL and made no photo upload request. Storelly’s source path is server-upload based; it did not pass the current photo-local criterion even without an external cloud request.
- Vanquish Upload Files intentionally sent order fixtures to the local WordPress host. Vanquish Attach Me stored its fixture in the local order-bound protected folder. Neither was configured for external cloud storage.
- Optional plugin telemetry/licensing opt-ins were declined/skipped; no plugin account or Storelly Cloud connection was made.
- The original G2A1 run had no local mail transport (sendmail connection refused); G2A1R1 added a loopback-only Mailpit capture sink. The guest order verification flow itself sent no message, and the inbox was empty after the flow. No customer/guest email was sent externally.
- Protected static URL probes returned HTTP 403 for the Order B Upload Files fixture and the Order A Attach Me fixture. Attach Me's `Delivery::can_access()` returned `owner_allowed=true` for Order A customer A and `unrelated_allowed=false` for customer B.

## Original G2A1 cleanup plan — historical, superseded by the R1 read-back below

- Active stack is the project-scoped Compose project `birthday-magazine-g2a1`; cleanup command is `docker compose -p birthday-magazine-g2a1 -f birthday-magazine-studio/poc/g2a1/compose.yaml down --volumes`.
- Remove only the exact temporary plugin/theme ZIPs and WooCommerce split download parts under `birthday-magazine-studio/poc/g2a1/packages/` after retaining source/version/hash evidence. Do not use global Docker prune or remove any other project’s resources.
- Disposable users, orders, uploaded files, local options and dummy product are in this stack’s data volumes and are removed by project-scoped `down --volumes`.
- Keep only the small PoC source and synthetic fixtures in the repository for Reviewer inspection. No changes were made to `REVIEWER_HANDOFF.md` and no commit was created.

## G2A1R1 cleanup and final runtime read-back

- Executed `docker compose -p birthday-magazine-g2a1r1 -f birthday-magazine-studio/poc/g2a1/compose.yaml down --volumes` after capturing evidence. Docker confirmed removal of the three project containers, both named project volumes, and the default network.
- Read-back after cleanup: `birthday-magazine-g2a1r1` containers/volumes/networks = `0/0/0`; the earlier typo-scoped project `birthday-magazine-g2a1` also has `0/0/0` resources.
- Docker inventory returned to the pre-execution counts: 40 containers, 87 volumes, and 21 networks. The pre-execution inventory digest was `95F7B566D566F6298A4ECC9E346EE00ED127CE5BAA60BFAD97CDFA660414AE61`; no broad Docker prune command was run, and cleanup targeted only this PoC's Compose labels.
- `poc/g2a1/.tmp-g2a1r1/` (including extracted source, browser profiles/screens, private seed data, and generated diagnostics) and `poc/g2a1/packages/` (temporary ZIPs) were removed. The durable evidence screenshots and deliberate local Mailpit Compose/MU-plugin wiring remain.
- Mailpit inbox was empty (`total=0`) immediately before teardown. No production or external mail provider was configured.
- No VPS, public domain, Cloudflare, shared infrastructure, payment, AI/API, or paid-plugin actions were used. `REVIEWER_HANDOFF.md` was not changed.

## Original G2A1 reviewer prompts — historical, superseded by the R1 return below

1. Decide whether Route C is preferred for continued WordPress/WooCommerce MVP work, noting the exact A/B starter-site imports were intentionally not run.
2. Decide whether Upload Files is acceptable for registered-account uploads while the guest flow remains unverified, or return for a test environment with local email capture.
3. Decide whether Attach Me is acceptable for registered-account private delivery while the guest flow and completed file download remain unverified, or return for a test environment with local email capture and byte-level download confirmation.
4. Keep this Gate separate from G2A2. This evidence is not a Reviewer PASS and does not freeze product specifications.

## Current G2A1R1 reviewer decision required

1. Decide whether to reject or replace Vanquish Upload Files for guest orders because its issued secure file link returned HTTP 200 when replayed from an unrelated guest context.
2. Decide whether to reject or replace Vanquish Attach Me for guest private delivery because its issued attachment link also returned HTTP 200 when replayed from an unrelated guest context, despite the raw storage URL returning HTTP 403.
3. Keep this Gate at Reviewer. Do not start G2A2 until the Reviewer resolves the two guest-link access-control failures.
