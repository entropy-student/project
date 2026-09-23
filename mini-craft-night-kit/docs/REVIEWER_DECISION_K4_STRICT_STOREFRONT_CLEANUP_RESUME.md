# Reviewer Decision — Resume K4 Strict Storefront Cleanup After Recovery + Hygiene

Date: 2026-09-23
Status: AUTHORIZED
Parent Gate: K4_STRICT_STOREFRONT_CLEANUP

## Preconditions now satisfied

Accepted:
- K4_ARTIFACT_BACKED_BLOCK_RECOVERY at commit e1a64a1e5092142b1391961c28ce4ddd0c428f6d
- K4_WORKSPACE_HYGIENE_V2 at commit d0b821c91f433ce6cf8e3c534fa6a87d91c43b90

Known deferred limitation:
- Gutenberg editor GUI/session validation remains pending.
- Do not force risky GUI automation merely to clear this marker.
- Deterministic block validation and frontend rendering currently pass for Contact/FAQ.

Workspace policy now mandatory:
- no new shared-root .tmp-k4-* / .tmp-mc-* leftovers;
- all temporary/browser/helper/deliverable/rollback files stay under active runtime .artifacts/<gate>/ or verified _project-artifacts archive;
- every return must include the workspace cleanup contract fields.

## Gate

GATE=K4_STRICT_STOREFRONT_CLEANUP_RESUME

Continue the previously authorized strict storefront cleanup, but treat the repaired Contact/FAQ block structures as protected valid baselines.

## Required work

1. Customer-facing WooCommerce strings English
2. Hide inherited demo products from Shop/Related Products without hard deletion
3. Correct Mini Craft product category from Accessories to an appropriate native WooCommerce category such as Craft Kits
4. Product mobile typography/spacing polish only; preserve canonical gallery and gallery CSS
5. Contact:
   - preserve repaired native Kadence Form exactly
   - remove internal-governance customer copy
   - keep Name/Email/Message/Send visible
6. FAQ:
   - preserve repaired native details blocks
   - convert Orders & Support into the same native FAQ/details pattern
   - remove internal-governance wording only
7. Shipping & Returns:
   - remove/demote duplicate inner title
   - tighten mobile hierarchy and support CTA area
   - preserve policy facts
8. Shop:
   - reduce excessive whitespace natively where possible
   - if only one approved product remains, hide result/sort controls natively if available
9. Cart:
   - capture populated cart desktop/mobile
10. Checkout:
   - capture actual populated checkout desktop/mobile, no order/payment
11. Account:
   - English customer-facing UI
12. Mobile footer:
   - simple vertical stack using native Kadence controls

## Strategic hold

Do not resolve:
PRODUCT_MODEL_STRATEGY_DECISION=PENDING_OWNER_REVIEW

Do not create additional products or change Home strategy.

## Protected

- Home current saved state
- Hero/Header/Logo
- Home four product images/order
- Owner-deleted Home sections
- Product gallery canonical behavior
- Product gallery scoped CSS
- repaired Contact form block structure
- repaired FAQ valid block structure except explicitly authorized Orders & Support restructuring
- WooCommerce/PayPal/order/payment logic
- current business-policy facts
- current K4 test price/stock/SKU

## Validation

At minimum:
- Shop/Product/FAQ/Shipping & Returns/Contact/Cart/Checkout/Account desktop 1440 + mobile 390
- Home desktop/mobile read-only regression capture
- Product gallery initial/after-thumbnail desktop/mobile
- populated Cart desktop/mobile
- populated Checkout desktop/mobile
- no horizontal overflow
- mobile nav pass
- Contact fields remain visible
- FAQ details remain valid
- no demo products visible
- customer-facing Woo strings English
- Product→Cart→Checkout smoke
- NEW_ORDER_ACTIONS=0
- PAYMENT_ACTIONS=0
- LIVE_ACTIONS=0

If Gutenberg editor session becomes available, verify invalid count 0 on edited pages.
If unavailable, return:
GUTENBERG_EDITOR_VISUAL_VALIDATION=PENDING_SESSION
and rely on deterministic block parse/render checks; do not claim GUI PASS.

## Visual package

Create:
K4_STRICT_STOREFRONT_CLEANUP_RESUME-visual-review.zip

Store local deliverable under:
mini-craft-k3r4-mariadb-recovery/.artifacts/k4-strict-storefront-cleanup-resume/deliverables/

Commit durable screenshots to GitHub.

## Workspace closeout contract

Return all:
WORKSPACE_TEMP_CLEANUP=
ROOT_TRANSIENTS_CREATED=
ROOT_TRANSIENTS_REMAINING=
LOCAL_HELPERS_CLEANED=
BROWSER_PROFILES_CLEANED=
DELIVERABLE_LOCATION=
ROLLBACK_LOCATION=

A successful Gate must not create new shared-root temp clutter.

## Return

GATE=K4_STRICT_STOREFRONT_CLEANUP_RESUME
RESULT=<PASS_CANDIDATE_K4_STRICT_STOREFRONT_CLEANUP_RESUME | RETURN_REVIEWER_*>
SUMMARY=
CUSTOMER_FRONTEND_LANGUAGE=
LEGACY_DEMO_PRODUCTS_CUSTOMER_VISIBLE=
PRODUCT_CATEGORY=
CONTACT_FORM_VISIBLE_FIELDS=
CONTACT_INTERNAL_GOVERNANCE_COPY_REMOVED=
FAQ_ORDERS_SUPPORT_STRUCTURE=
FAQ_INTERNAL_GOVERNANCE_COPY_REMOVED=
SHIPPING_RETURNS_HIERARCHY=
SHOP_SINGLE_PRODUCT_CONTROLS=
CART_POPULATED_CAPTURE=
CHECKOUT_POPULATED_CAPTURE=
MOBILE_FOOTER=
PRODUCT_GALLERY_PROTECTED=
HOME_PROTECTED=
GUTENBERG_EDITOR_VISUAL_VALIDATION=
NEW_ORDER_ACTIONS=
PAYMENT_ACTIONS=
LIVE_ACTIONS=
PRODUCT_MODEL_STRATEGY_DECISION=PENDING_OWNER_REVIEW
TEST_PRICE_PENDING_PRODUCTION=YES
TEST_STOCK_PENDING_PRODUCTION=YES
TEST_SKU_PENDING_PRODUCTION=YES
WORKSPACE_TEMP_CLEANUP=
ROOT_TRANSIENTS_CREATED=
ROOT_TRANSIENTS_REMAINING=
LOCAL_HELPERS_CLEANED=
BROWSER_PROFILES_CLEANED=
DELIVERABLE_LOCATION=
ROLLBACK_LOCATION=
EVIDENCE=
COMMIT=
VISUAL_REVIEW_PACKAGE=
VISUAL_REVIEW_DELIVERY=OWNER_UPLOAD_ZIP_REQUIRED
OWNER_ACTION=UPLOAD_VISUAL_REVIEW_ZIP
NEXT=STOP_AT_REVIEWER

Do not enter K5.
