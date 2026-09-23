# Reviewer Decision — K5 Release Candidate QA Resume

Date: 2026-09-23
Status: AUTHORIZED
Parent: K5R1 Related Products Baseline Repair PASS

## Gate

GATE=K5_RELEASE_CANDIDATE_QA_RESUME

## Principle

Continue only the K5 checks that were not completed before the valid stop.

Do not replay already-accepted K4 visual work.
Do not deploy to VPS in this Gate.
Do not enable Live PayPal.

## 1. Runtime/version reconciliation

Verify and distinguish:
- Docker WordPress image tag
- actual WordPress core version reported by runtime/database/admin
- WooCommerce version
- Kadence Theme version
- Kadence Blocks version
- WooCommerce PayPal Payments version

The earlier K5 return reported image tag wordpress:6.8.2-php8.3-apache while prior runtime evidence reported WordPress core 7.1.1.

Return both facts explicitly:
WORDPRESS_IMAGE_TAG=
WORDPRESS_CORE_VERSION=

Do not label the image tag as application core version.

If actual core/plugin/theme versions have unexpected drift from accepted baseline, RETURN_REVIEWER_VERSION_DRIFT.

## 2. Admin owner-operability QA

Prove that the Owner can operate the store from WordPress/WooCommerce admin.

Use a temporary, clearly named QA draft product rather than editing the approved Mini Craft product if practical.

Preferred test object:
K5 QA TEMP PRODUCT

Test:
- create draft product
- title/description save
- price save
- SKU save
- stock management/quantity save
- category assignment save
- media upload + assignment
- draft state retained
- publish control exists / state transition capability demonstrated without making the temporary product customer-visible if avoidable
- Orders admin accessible

Cleanup:
- remove only the temporary product/media created by this Gate after evidence is captured;
- if safe cleanup is blocked, leave it draft/non-customer-visible and report exactly.

Do not alter Product 223 price, stock, SKU, media or publication state.

## 3. Storefront regression smoke

Fresh anonymous checks:

Desktop and mobile:
- Home
- Shop
- Product
- FAQ
- Shipping & Returns
- Contact
- Cart
- Checkout
- Account

Verify:
- navigation usable
- no horizontal overflow at 390 and 1440
- no legacy demo products in Shop or Product Related Products
- Product Gallery thumbnail switching works
- Contact form fields visible
- footer/nav not broken

This is a regression smoke, not a redesign review.

No screenshot ZIP is required if no visual regression is found.
If a visual regression is found and screenshots are used for Reviewer judgment, package all current-Gate visual evidence in one ZIP.

## 4. Commerce flow

Use local/test-only state.

Verify:
Product → Add to Cart → Cart → Checkout

No real payment.
Prefer no new order.

Confirm final native checkout action can render without clicking it.

Return:
NEW_ORDER_ACTIONS=0 unless strictly required and separately justified.

## 5. PayPal Sandbox read-only state

Verify current accepted Sandbox state without changing credentials/settings.

Check:
- official WooCommerce PayPal Payments active/version
- Sandbox mode/state
- payment method availability on local Checkout where applicable
- no Live mode
- no credentials displayed in evidence

Do not re-authorize or rotate anything.

## 6. Language/market

Verify:
CUSTOMER_LANGUAGE=ENGLISH
ADMIN_LANGUAGE=zh_CN if current accepted admin locale persists
SELLING_COUNTRIES=US_ONLY
SHIPPING_COUNTRIES=US_ONLY
NON_US_TEST_SHIPPING_AVAILABLE=NO
GUEST_CHECKOUT=<PASS/FAIL>

## 7. Gutenberg/application health

Verify:
- deterministic block validation on Home/Product/Contact/FAQ/Shipping
- unregistered/invalid count
- no critical PHP errors in bounded available logs
- no critical JS errors on primary customer pages
- primary routes no 4xx/5xx

Do not force unavailable Gutenberg GUI merely to clear the existing deferred GUI marker.

## 8. Deployment package preparation

Prepare local-only deployment package/evidence under:

C:\Users\34707\Documents\ChatGPT\VPS基建\mini-craft-night-kit-workspace\artifacts\gates\k5-release-candidate-qa\

Required:
- fresh MariaDB backup
- wp-content backup/archive
- wp-config/config backup local-only
- deployment manifest
- hashes
- exact active runtime source
- Docker Compose source path
- persistent volume names
- target domain: minicraft.spikersun.com

Do NOT put secret-bearing config contents in GitHub.

GitHub deployment manifest may list only secret/environment variable NAMES, never values.

## 9. Deployment manifest content

Record:
- source runtime
- WordPress image tag
- actual WordPress core version
- MariaDB image/version
- plugins/themes and versions
- DB backup location/hash
- wp-content backup location/hash
- config backup location/hash (local-only)
- target domain
- expected HTTPS
- required DNS action
- required production URL replacement/migration step
- required secrets by NAME only
- local/test data that must not be publicly sellable
- production-only checks after deploy
- rollback approach

## 10. Blocker classification

BLOCKS_DEPLOYMENT:
Only technical conditions preventing VPS deployment.

BLOCKS_PUBLIC_SALES:
May include current test product values and Owner need to enter real product data before enabling sales.

BLOCKS_SOFT_LAUNCH:
May include production-domain, production email, production payment, Privacy/Terms/consent, GA4/Search Console readiness that must be validated on public origin.

DEFER_TO_OPERATIONS:
supplier sourcing, merchandising optimization, SEO expansion, margin optimization, ads/content growth.

Do not convert operational work back into deployment blockers.

## 11. Safety

No VPS writes.
No Live PayPal.
No real payment.
No supplier contact.
No GA4/Resend/Search Console/Merchant implementation.
No SEO expansion.
No production DNS changes.

## Return

GATE=K5_RELEASE_CANDIDATE_QA_RESUME
RESULT=<PASS_CANDIDATE_K5_RELEASE_CANDIDATE_QA | RETURN_REVIEWER_*>
SUMMARY=
WORDPRESS_IMAGE_TAG=
WORDPRESS_CORE_VERSION=
WOOCOMMERCE_VERSION=
KADENCE_THEME_VERSION=
KADENCE_BLOCKS_VERSION=
PPCP_VERSION=
ADMIN_PRODUCT_CREATE_SAVE=
ADMIN_MEDIA_UPLOAD=
ADMIN_PRICE_STOCK_SKU=
ADMIN_CATEGORY=
ADMIN_DRAFT_PUBLISH_CAPABILITY=
TEMP_QA_PRODUCT_CLEANUP=
ORDERS_ADMIN=
STOREFRONT_DESKTOP=
STOREFRONT_MOBILE=
LEGACY_DEMO_VISIBILITY=
PRODUCT_GALLERY=
CONTACT_FORM=
CART_CHECKOUT=
FINAL_CHECKOUT_ACTION_VISIBLE=
PAYPAL_SANDBOX_STATE=
CUSTOMER_LANGUAGE=
ADMIN_LANGUAGE=
US_MARKET_CONFIG=
GUEST_CHECKOUT=
WORDPRESS_CONTAINER=
MARIADB_CONTAINER=
GUTENBERG_VALIDATION=
CRITICAL_PHP_ERRORS=
CRITICAL_JS_ERRORS=
PRIMARY_ROUTE_ERRORS=
BLOCKS_DEPLOYMENT=
BLOCKS_PUBLIC_SALES=
BLOCKS_SOFT_LAUNCH=
DEFER_TO_OPERATIONS=
DEPLOYMENT_MANIFEST=
DATABASE_BACKUP=
WP_CONTENT_BACKUP=
CONFIG_BACKUP=
BACKUP_HASH_VERIFICATION=
SITE_MUTATION=
NEW_ORDER_ACTIONS=
PAYMENT_ACTIONS=
LIVE_ACTIONS=
VPS_WRITES=0
WORKSPACE_TEMP_CLEANUP=
ROOT_TRANSIENTS_CREATED=
ROOT_TRANSIENTS_REMAINING=
LOCAL_HELPERS_CLEANED=
BROWSER_PROFILES_CLEANED=
EVIDENCE=
COMMIT=
OWNER_ACTION=NONE
NEXT=STOP_AT_REVIEWER

Do not deploy to VPS.
