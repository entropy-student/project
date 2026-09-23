# Reviewer Decision — Supplier Discovery Deferred / K5 RC QA Authorized

Date: 2026-09-23
Status: AUTHORIZED

## Owner direction

Owner has clarified that supplier selection, product sourcing, merchandising, pricing optimization, and profit validation belong to later operations.

Current project objective is now explicitly:

**Launch a technically complete Mini Craft storefront that the Owner can operate from WooCommerce admin: upload products, change images, prices, stock, SKU, publish/unpublish products, manage orders, and receive payments.**

Supplier discovery is therefore not a blocker for platform launch.

## Superseded checkpoint

K4_9_SUPPLIER_CONTACT_OWNER_CHECKPOINT is DEFERRED_TO_OPERATIONS.

No supplier contact is authorized or required now.

K4.8 research remains retained as optional future sourcing evidence only.

## Product truth boundary

Current test product data remains non-production:
- JPY 1
- stock 8
- SKU MCK-LOCAL-TEST-001
- test/local shipping configuration where applicable

These values may remain in the local RC environment for QA.

They MUST NOT become publicly sellable production truth.

Before public sales are enabled, Owner must upload/approve the real product, price, stock/SKU and product media through WooCommerce admin.

## Launch sequence

1. K5_RC_QA
2. VPS production deployment
3. Production Canary on https://minicraft.spikersun.com
4. Owner uploads/approves real sellable product data
5. Production payment/email/domain checks
6. Soft Launch
7. Operations / sourcing / SEO expansion / profit optimization

## K5 Gate

GATE=K5_RELEASE_CANDIDATE_QA

Purpose:
Validate the local storefront as a release candidate for deployment.

This Gate must test platform capability, not supplier economics.

## K5 required checks

### Commerce/admin
- WooCommerce admin accessible
- existing test product editable
- image/media upload path works
- product title/description editable
- price editable
- SKU editable
- stock quantity/status editable
- product can be drafted/published
- category assignment works
- Orders admin accessible
- no destructive product/order cleanup

Use reversible/local-only checks. Do not permanently alter the approved storefront baseline except where needed for bounded QA and restored before return.

### Storefront
- Home
- Shop
- Product
- FAQ
- Shipping & Returns
- Contact
- Cart
- Checkout
- Account
- desktop/mobile
- no broken navigation
- no horizontal overflow
- Contact form visible
- Product Gallery intact

### Commerce flow
- Product → Cart → Checkout
- PayPal Sandbox availability/state as previously accepted
- no Live mode
- no real payment
- no production order
- do not place a new order unless the existing K5 protocol explicitly requires a local reversible test; prefer no new order

### Language/market
- customer frontend English
- admin locale Chinese if retained
- selling/shipping country US
- non-US test shipping unavailable

### Technical
- WordPress container UP
- MariaDB HEALTHY
- no unexpected plugin/theme/version drift
- deterministic Gutenberg/block validation
- no malformed blocks
- no critical PHP/JS errors on core customer pages
- no broken 4xx/5xx on primary routes

### Release blockers classification

Return blockers in:
- BLOCKS_DEPLOYMENT
- BLOCKS_PUBLIC_SALES
- BLOCKS_SOFT_LAUNCH
- DEFER_TO_OPERATIONS

Important:
Supplier/product sourcing issues belong in BLOCKS_PUBLIC_SALES or DEFER_TO_OPERATIONS, not BLOCKS_DEPLOYMENT, unless they break the platform itself.

### Growth/SEO

Do not expand SEO content.

Growth/SEO foundation remains documented but implementation is deferred until production origin exists.

Do not install GA4/PostHog/SEO/email integrations during K5 unless separately authorized.

### Production deployment handoff

Prepare:
- exact active runtime source
- database backup/checkpoint
- wp-content/config backup
- deployment manifest
- required environment variables/secrets list without values
- domain target: minicraft.spikersun.com
- required production-only changes
- list of local-only test data that must not be exposed as sellable production data

Do not deploy to VPS in this Gate.

## Return

GATE=K5_RELEASE_CANDIDATE_QA
RESULT=<PASS_CANDIDATE_K5_RELEASE_CANDIDATE_QA | RETURN_REVIEWER_*>
SUMMARY=
ADMIN_PRODUCT_EDIT_CAPABILITY=
ADMIN_MEDIA_UPLOAD_CAPABILITY=
ADMIN_PRICE_STOCK_SKU_CAPABILITY=
ADMIN_PUBLISH_DRAFT_CAPABILITY=
ORDERS_ADMIN=
STOREFRONT_DESKTOP=
STOREFRONT_MOBILE=
PRODUCT_GALLERY=
CONTACT_FORM=
CART_CHECKOUT=
PAYPAL_SANDBOX_STATE=
CUSTOMER_LANGUAGE=
ADMIN_LANGUAGE=
US_MARKET_CONFIG=
WORDPRESS_CONTAINER=
MARIADB_CONTAINER=
GUTENBERG_VALIDATION=
PRIMARY_ROUTE_ERRORS=
BLOCKS_DEPLOYMENT=
BLOCKS_PUBLIC_SALES=
BLOCKS_SOFT_LAUNCH=
DEFER_TO_OPERATIONS=
DEPLOYMENT_MANIFEST=
BACKUP_STATUS=
SITE_MUTATION=
NEW_ORDER_ACTIONS=
PAYMENT_ACTIONS=
LIVE_ACTIONS=
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
Do not enable Live PayPal.
