# Reviewer Decision — K4 Strict Storefront Cleanup After Full Visual Audit

Date: 2026-09-23
Status: AUTHORIZED
Supersedes: docs/REVIEWER_DECISION_K4_FULL_VISUAL_AUDIT_RETURN_STOREFRONT_CLEANUP.md
Parent checkpoint: K4

## Visual-review basis

Reviewer directly inspected the full visual-review ZIP returned from:
- Executor commit: 7db4f27f647611d0a4702b2b95bc63617f1786cc
- Gate: K4_FULL_VISUAL_AUDIT_PRODUCT_GALLERY_REPAIR

The Product gallery technical repair remains accepted and protected.

K4 is NOT visually closed. The following customer-facing issues are now the authoritative remediation scope.

## Gate

GATE=K4_STRICT_STOREFRONT_CLEANUP

## 1. Home — protect, do not redesign

The current Home is the strongest/most complete surface and is NOT the focus of this Gate.

Protect exactly:
- current Hero image / overlay / copy / CTA;
- Header / logo;
- current four product-media images and their order;
- current section order and all Owner-deleted sections;
- Story / FAQ / reassurance / CTA / Footer unless a global locale/mobile-footer fix requires a bounded shared change.

Do NOT redesign Home.

### Strategic flag — do not auto-resolve

Current Home visually suggests multiple craft categories (painting / miniature house / weaving / cross-stitch), while current customer-facing catalog still effectively behaves like a single Mini Craft Night Kit product.

This creates a product-positioning mismatch:
- single date-night kit brand vs.
- multi-category mini craft brand.

Executor must NOT invent a strategy or add products in this Gate.
Record this as:
PRODUCT_MODEL_STRATEGY_DECISION=PENDING_OWNER_REVIEW

## 2. Customer storefront language — English only

Current customer-facing WooCommerce surfaces contain Chinese UI strings inside an otherwise English storefront.

Examples observed:
- Shop result count / sorting;
- Product stock / Add to Cart;
- Cart empty-state;
- Account login fields and labels.

Target:
CUSTOMER_FRONTEND_LANGUAGE=ENGLISH

Requirements:
- prefer native WordPress / WooCommerce locale mechanisms;
- do not hardcode individual translated strings;
- do not modify WooCommerce core/plugin source;
- preserve Owner admin usability in Chinese where WordPress user-language settings allow it;
- do not change commerce logic, prices, stock, orders, or payment settings.

Verify all customer-facing core surfaces:
Shop / Product / Cart / Checkout / Account.

## 3. Legacy demo products — remove from customer-visible catalog

The following inherited demo products must NOT appear to customers:
- Remote Control
- Universal Charger
- USB-C Cable

Observed locations:
- Shop
- Product Related Products

Rules:
- do NOT hard-delete;
- preserve database/history;
- use the safest reversible WooCommerce visibility/status option (draft/private/catalog hidden) that removes them from customer-facing catalog and related products;
- do not affect the current Mini Craft Night Kit product or existing orders.

Target:
LEGACY_DEMO_PRODUCTS_CUSTOMER_VISIBLE=NO

## 4. Product page cleanup

The Product gallery bug repair is LOCKED and must remain unchanged:
`.single-product .woocommerce-product-gallery .woocommerce-product-gallery__image img { width:100%; height:auto; display:block; }`

Do not rebuild the WooCommerce Product template.

Required cleanup:
- legacy Related Products cards disappear through product/catalog visibility changes, not CSS hiding;
- current category `Accessories` is visually/semantically wrong for Mini Craft; change the Mini Craft product to a suitable customer-facing category such as `Craft Kits` using native WooCommerce taxonomy;
- preserve current verified product copy;
- preserve current K4 local-test price / stock / SKU in this Gate;
- record these as production blockers, not K4 visual changes:
  - TEST_PRICE_PENDING_PRODUCTION=YES
  - TEST_STOCK_PENDING_PRODUCTION=YES
  - TEST_SKU_PENDING_PRODUCTION=YES

### Product mobile typography

Current mobile Product lower content is too text-heavy and hierarchy is unbalanced.

Allowed bounded adjustments:
- reduce oversized mobile H2/H3 where needed;
- normalize paragraph spacing / line-height;
- improve section rhythm;
- do not rewrite business copy;
- do not rebuild WooCommerce core structure.

## 5. Contact — functional repair + copy cleanup

Current Contact page is a MUST-FIX.

Observed defect:
- Name*, Email*, Message* labels are visible;
- Name and Email input controls are not visibly rendered;
- Message textarea is visible.

Required visible native Kadence form:
- Name
- Email
- Message
- Send message

Rules:
- keep native Kadence form;
- no custom form framework;
- no real form submission;
- no invented email/phone/address.

### Remove internal-governance copy from customer view

Customer-facing Contact must NOT contain implementation/governance language such as:
- “No made-up contact information”
- “We will publish ... only after formally confirmed”
- similar internal-process wording.

Rewrite/simplify only where required so customer sees:
- how to contact;
- what information to include;
- links to FAQ / Shipping & Returns where useful.

Do not invent new contact facts.

## 6. FAQ — strict structure cleanup

Preserve existing factual answers.

Current defect:
`Orders & Support` renders as raw continuous prose and breaks the pattern of the rest of the FAQ.

Required:
- convert:
  - How do I contact support?
  - Do you have a public support email or phone number?
  into the same native FAQ / accordion / item pattern used elsewhere.

Remove internal-governance phrasing from customer-facing answers.
State only confirmed customer facts.

Do not add a public email/phone.

## 7. Shipping & Returns — hierarchy + mobile cleanup

Observed:
- page hero title says “Shipping & Returns”;
- inner content card repeats “Shipping & Returns” again;
- mobile page uses too many large headings in sequence;
- lower CTA/support sections feel stacked and visually heavy.

Required:
- keep hero title;
- remove or demote redundant inner title;
- preserve all policy facts exactly;
- keep the three policy areas:
  - Shipping
  - Returns
  - Damaged or Missing Items
- reduce mobile heading scale by one level where necessary;
- tighten mobile vertical spacing;
- consolidate lower FAQ/help calls-to-action into a simpler support area if possible with existing native blocks.

No policy rewrite.

## 8. Shop — strict visual cleanup

After demo-product removal:
- only approved Mini Craft customer-visible catalog items remain;
- reduce excessive desktop whitespace between Shop title and product area by roughly 30–40% if the native layout permits;
- if only one customer-visible product remains:
  - hide/disable result count and sorting controls if WooCommerce/Kadence provides a native reversible option;
  - do not hardcode CSS solely to fake their absence unless no native option exists and Reviewer evidence justifies a minimal scoped rule.

Do not redesign the Shop page.

## 9. Cart — require populated visual state

Previous audit only showed empty-cart state.

This Gate must capture BOTH:
- empty Cart state (optional but useful);
- populated Cart state after adding one current Mini Craft product in the test session.

Required:
- Desktop 1440
- Mobile 390

Do not create an order.

## 10. Checkout — require real current visual evidence

Previous audit did not visually validate the actual populated Checkout because empty cart redirected.

This Gate must:
1. add one current Mini Craft product to the test session cart;
2. open Checkout;
3. capture the actual Checkout form/layout;
4. do NOT place order;
5. do NOT pay.

Required:
- Desktop 1440
- Mobile 390

## 11. Account — English + layout check

Keep native WooCommerce Account.

Required:
- customer-facing labels/fields in English;
- no horizontal overflow;
- mobile login form readable;
- no structural rebuild.

## 12. Footer / global mobile cleanup

Desktop Footer is acceptable.

Mobile Footer is too compressed horizontally.

Required mobile behavior:
- brand/logo block;
- navigation links;
- copyright
should stack in a simple vertical hierarchy instead of feeling like a desktop footer squeezed into mobile width.

Use native Kadence footer controls where possible.
Do not introduce new social links.

## 13. Gutenberg validity

For every edited Gutenberg/Kadence page:
GUTENBERG_INVALID_BLOCK_COUNT=0

If repair would require destructive recovery or broad reserialization:
STOP and return Reviewer issue instead of forcing it.

## 14. Regression / protected systems

Do not modify:
- WooCommerce order logic;
- PayPal configuration;
- existing Sandbox orders;
- product-gallery canonical Woo behavior;
- Product gallery scoped CSS;
- business-policy facts;
- Home current visual baseline.

Smoke:
Product → Add to Cart → Cart → Checkout

Restrictions:
- NEW_ORDER_ACTIONS=0
- PAYMENT_ACTIONS=0
- LIVE_ACTIONS=0

## 15. Visual evidence

Capture post-fix screenshots:

Desktop 1440:
- Home
- Shop
- Product
- FAQ
- Shipping & Returns
- Contact
- Cart populated
- Checkout populated
- Account

Mobile 390:
- same surfaces

Product gallery:
- desktop initial
- desktop after thumbnail
- mobile initial
- mobile after thumbnail

Optional:
- empty Cart state

## 16. ZIP package

Commit screenshots to GitHub and additionally package one ZIP:

`K4_STRICT_STOREFRONT_CLEANUP-visual-review.zip`

ZIP contains only:
- desktop/
- mobile/
- product-gallery/
- manifest.txt

manifest.txt includes:
- Gate
- commit SHA
- page/surface
- screenshot filename
- viewport
- Product gallery state where applicable
- cart/checkout state
- any NOT_CAPTURED reason

No logs, secrets, cookies, credentials, DB exports, provider payloads, or unrelated files.

Return:
VISUAL_REVIEW_PACKAGE=<absolute local zip path>
VISUAL_REVIEW_DELIVERY=OWNER_UPLOAD_ZIP_REQUIRED

## Stop / return

Return:

GATE=K4_STRICT_STOREFRONT_CLEANUP
RESULT=<PASS_CANDIDATE_K4_STRICT_STOREFRONT_CLEANUP | RETURN_REVIEWER_*>
SUMMARY=
EVIDENCE=
COMMIT=
HOME_PROTECTED=YES
PRODUCT_GALLERY_PROTECTED=YES
CUSTOMER_FRONTEND_LANGUAGE=ENGLISH
LEGACY_DEMO_PRODUCTS_CUSTOMER_VISIBLE=NO
PRODUCT_CATEGORY=<final customer-facing category>
CONTACT_FORM_VISIBLE_FIELDS=NAME_EMAIL_MESSAGE
FAQ_ORDERS_SUPPORT_STRUCTURE=PASS
SHIPPING_RETURNS_HIERARCHY=PASS
SHOP_SINGLE_PRODUCT_CONTROLS=<HIDDEN_NATIVE | RETAINED_WITH_REASON>
CART_POPULATED_CAPTURE=PASS
CHECKOUT_POPULATED_CAPTURE=PASS
MOBILE_FOOTER=PASS
GUTENBERG_INVALID_BLOCK_COUNT=
PRODUCT_MODEL_STRATEGY_DECISION=PENDING_OWNER_REVIEW
TEST_PRICE_PENDING_PRODUCTION=YES
TEST_STOCK_PENDING_PRODUCTION=YES
TEST_SKU_PENDING_PRODUCTION=YES
VISUAL_REVIEW_PACKAGE=<absolute local zip path>
VISUAL_REVIEW_DELIVERY=OWNER_UPLOAD_ZIP_REQUIRED
OWNER_ACTION=UPLOAD_VISUAL_REVIEW_ZIP
NEXT=STOP_AT_REVIEWER

Do not enter K5.
