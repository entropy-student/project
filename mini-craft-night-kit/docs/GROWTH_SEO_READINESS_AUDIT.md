# K4.5 Growth & SEO Readiness Audit

GATE=K4_5_GROWTH_SEO_READINESS_AUDIT  
AUDIT_DATE=2026-09-23  
AUDIT_MODE=READ_ONLY  
SITE=http://localhost:8093/  
RESULT=PASS_CANDIDATE_K4_5_GROWTH_SEO_READINESS_AUDIT  
PRODUCT_MODEL_STRATEGY_DECISION=PENDING_OWNER_REVIEW

## Scope and evidence boundary

This is a read-only audit of the active local Docker/MariaDB storefront. No page, media, metadata, schema, plugin, configuration, product, order, PayPal, or account state was changed. No external account was created or connected; no payment, email, form submission, or analytics event was sent.

The active runtime answered locally with WordPress 7.1.1 and WooCommerce 10.0.4. Active plugins observed: Kadence Blocks 3.7.11, Kadence Starter Templates 2.3.4, WooCommerce 10.0.4, WooCommerce PayPal Payments 4.1.3. No SEO, analytics, consent, email-provider, session-replay, or error-monitoring plugin appeared in that active list.

The titled “Mini Craft Night Kit Growth Playbook” and “Cross-Border Growth / Acquisition / Conversion Playbook” files were not found in the Mini Craft repository tree or canonical workspace. To avoid scanning unrelated projects, this audit uses the explicit principles and seed-intent set in the current Reviewer Decision plus the project’s K1A_VISUAL_DIRECTION_AND_GROWTH_MAP.md. The missing playbook files are a source limitation, not a reason to expand scope.

No screenshot, ZIP, browser profile, helper, or local audit artifact was created. The runtime was queried with read-only HTTP GETs and read-only WordPress/Docker inspection. Checkout’s fresh anonymous GET redirected to Cart because the test session had an empty cart; no cart mutation or order action was taken.

## Executive finding

The storefront is a working local implementation, not a production search or growth surface. The dominant constraint is not content volume: it is the absence of a stable public production origin and production-truth product data, combined with the local WordPress “discourage indexing” state. Analytics events, purchase measurement, consent/legal readiness, and email delivery are also not ready for first qualified traffic.

TECHNICAL_SEO_STATUS=LOCAL_DEV_NOINDEX;NOT_PRODUCTION_READY  
STRUCTURED_DATA_STATUS=PARTIAL  
SEARCH_CONSOLE_READINESS=NOT_READY_LOCALHOST  
MERCHANT_CENTER_READINESS=NOT_READY_TEST_DATA  
ONPAGE_SEO_STATUS=PARTIAL  
CORE_WEB_VITALS_LOCAL_STATUS=STATIC_ONLY;FIELD_UNVERIFIED  
GA4_STATUS=ABSENT  
POSTHOG_STATUS=ABSENT  
ECOMMERCE_TRACKING_STATUS=PARTIAL  
UTM_STANDARD_STATUS=ABSENT  
SERVER_PURCHASE_TRUTH_STATUS=WOOCOMMERCE_ORDER_PAYMENT_STATE_IS_CANONICAL;ANALYTICS_EVENT_ABSENT  
EMAIL_CAPTURE_STATUS=ABSENT  
CONSENT_PRIVACY_STATUS=NOT_READY_OWNER_LEGAL_REVIEW  
CRO_TRUST_STATUS=PARTIAL;PRODUCTION_TRUTH_PENDING

## 1. Technical SEO

### Site and crawl state

| Check | Read-only observation | Readiness |
|---|---|---|
| WordPress site title | blogname is empty. Tagline is “Screen-free craft nights for two.” | P1: set intentional production site title when production identity is confirmed. |
| WordPress visibility | blog_public=0; the six primary content pages and Cart/Account/search/category responses emit noindex, nofollow. | Expected for local/dev; production release must deliberately change this and retain selective exclusions. |
| Permalinks | /%postname%/; primary routes use readable slugs. | PASS locally. |
| Canonicals | Home, Product, FAQ, Shipping & Returns, Contact, Cart, and Account canonical URLs point to localhost. Shop has no canonical tag in observed HTML. | Not production-stable. |
| Meta description | No description meta observed on Home, Shop, Product, FAQ, Shipping & Returns, or Contact. | P1 after approved product model and public domain. |
| Open Graph / social metadata | No OG title/description/image tags observed on the six primary pages; no Twitter card metadata observed. | P1; no social metadata configuration was added. |
| robots.txt | HTTP 200. It disallows admin and selected WooCommerce private upload/log paths, but does not globally disallow site content. No Sitemap directive is present. | Crawl access is not the present blocker; page-level noindex is. |
| XML sitemap | /wp-sitemap.xml, /sitemap_index.xml, and sampled WordPress sitemap children returned 404. | Not submit-ready. Observed alongside blog_public=0; sitemap generation should be rechecked on the final public configuration. |
| Cart / Checkout / Account | All observed public responses carry noindex. A fresh empty-cart Checkout request returned 302 to Cart. | Commerce pages are not intended as search landing pages; verify selective noindex persists after production crawl is enabled. |
| Internal search | /?s=craft returns 200 and noindex, nofollow. | Appropriate local behavior; retain noindex for internal result pages. |
| Product category/archive | Craft Kits archive returns 200 and noindex. One visible published product is in Craft Kits. | Production indexability depends on Owner’s product-model decision. |
| Duplicate/auxiliary pages | No duplicate slug was found among the six primary routes. Additional published About, Blog, and Reviews pages exist; they are currently noindex. About had no H1, Blog had zero saved words, Reviews had 16 saved words and no H1. Exact semantic duplicate analysis was not run. | Decide whether these auxiliary pages should be published, expanded, redirected, or kept non-indexable before crawl is enabled. |
| Legacy demo URLs | /product/remote-control/, /product/universal-charger/, and /product/usb-c-cable/ return 404 with no redirect observed. | No current demo product is exposed; review redirects only if real backlinks or acquisition traffic exist. |

The WordPress privacy-policy page is ID 3 but remains draft and its guest-facing routes (/privacy-policy/ and /?page_id=3) return 404. WooCommerce Terms page is unset and /terms-and-conditions/ returns 404. These are not legal findings; they are publication/readiness facts.

### Primary page inventory

| Page | HTTP | Title / H1 observation | Canonical / index state |
|---|---:|---|---|
| Home | 200 | Title “Screen-free craft nights for two.”; one H1, “Your next date night is already planned.” | localhost canonical; noindex |
| Shop | 200 | Title/H1 “Shop”; one visible product card | No canonical observed; noindex |
| Product | 200 | Title/H1 “Mini Craft Night Kit” | localhost canonical; noindex |
| FAQ | 200 | Two H1 elements (“FAQ” and “Questions, answered.”); section H2s are present | localhost canonical; noindex |
| Shipping & Returns | 200 | One H1; Shipping, Returns, Damaged or Missing Items, and help sections | localhost canonical; noindex |
| Contact | 200 | One H1, “Need a hand?”; native form markup present | localhost canonical; noindex |

Eight same-origin content-link paths discovered on these pages were probed; none returned a 4xx during this audit. This is a bounded link smoke test, not a complete crawler audit.

### Production Search Console readiness

SEARCH_CONSOLE_READINESS=NOT_READY

The current origin is HTTP localhost, not a public HTTPS production domain; pages are noindex; canonical URLs reference localhost; and no sitemap endpoint was available. Search Console property creation and verification were not attempted.

When a production domain exists, Owner will need to create/choose the property and verify ownership. Google documents DNS verification for Domain properties and other methods for URL-prefix properties. A sitemap may be submitted after verification; Google notes that sitemap submission is optional for discovery but useful for monitoring.  
References: [Search Console setup](https://developers.google.com/search/docs/monitor-debug/search-console-start), [ownership verification methods](https://support.google.com/webmasters/answer/9008080?hl=en), [build and submit a sitemap](https://developers.google.com/search/docs/crawling-indexing/sitemaps/build-sitemap).

## 2. Structured data

STRUCTURED_DATA_CURRENT=One Product JSON-LD block on Product; types observed: Organization, Product, Offer, UnitPriceSpecification.  
STRUCTURED_DATA_MISSING=WebSite; BreadcrumbList; Product brand; shippingDetails; hasMerchantReturnPolicy; FAQPage.  
STRUCTURED_DATA_CONFLICTS=No duplicate Product node detected on Product; no conflicting second Product schema observed.

Product JSON-LD contains name, description, image, SKU, Offer, price, currency, and availability. It currently reflects the test fixture: price 1, currency JPY, availability InStock, SKU MCK-LOCAL-TEST-001. This is not production data.

The Product node has no brand, shippingDetails, or hasMerchantReturnPolicy. The data needed to fill those fields must come from Owner/supplier/business truth; do not infer or fabricate them. A single Organization type occurs in the product JSON-LD graph; no standalone site-wide WebSite or BreadcrumbList was found. The Product page has no WooCommerce breadcrumb class in rendered markup.

FAQ is rendered with native details, but no FAQPage JSON-LD was found. Google currently limits FAQ rich-result display to well-known authoritative government/health sites; adding FAQ schema is not a priority for this store and would not change the visible FAQ.  
References: [Google product structured data](https://developers.google.com/search/docs/appearance/structured-data/product), [merchant listing data](https://developers.google.com/search/docs/appearance/structured-data/merchant-listing), [FAQ rich-result change](https://developers.google.com/search/blog/2023/08/howto-faq-changes).

## 3. Merchant Center / Free Listings

MERCHANT_CENTER_READINESS=NOT_READY_TEST_DATA

No Merchant Center account, feed, or Google integration was created or detected. The only visible product is Mini Craft Night Kit, currently with JPY 1, stock quantity 8 / InStock, and SKU MCK-LOCAL-TEST-001. All three values remain test data. The approved initial market is United States, so the current JPY test currency also does not represent the production market.

Readiness gaps:

- Production price and currency, stable SKU/ID, stock model, and availability are Owner decisions.
- Supplier confirmation is needed for contents, brand/manufacturer identity, and whether a GTIN or MPN exists/apply. Current product metadata and Product JSON-LD have no GTIN/MPN/brand values; do not invent identifiers.
- Product page has a single product JSON-LD with price/currency/availability but is not a public HTTPS landing page and is globally noindex.
- Product structured data lacks brand, shipping, and return-policy properties. Merchant Center account-level shipping/returns can also matter; any feed/site/settings values must match the approved public policy.
- Current WooCommerce US-only selling and shipping country configuration was confirmed, but its shipping method/data remain local test configuration.
- Home has four replaceable product-display images with empty alt text; Product’s main image markup is 506×332 and gallery thumbnails have generic labels. Prior accepted K4 evidence records no content-identical higher-resolution gallery source found; high-resolution production assets remain pending.
- The Privacy and Terms URLs are not guest-accessible, and the public production domain/HTTPS is absent.

Google’s current free-listing guidance lists product ID, title, link, image link, price, description, and availability among required attributes; brand is required when clearly associated, GTIN when assigned by the manufacturer, and image quality/landing-page consistency matter. Confirm the exact target-country requirements at implementation time.  
References: [Free listings attributes](https://support.google.com/merchants/answer/13889434?hl=en), [product data specification](https://support.google.com/merchants/answer/7052112), [product image/data quality](https://support.google.com/merchants/answer/7380908?hl=en), [Merchant Center return-policy requirements](https://support.google.com/merchants/answer/14011730?hl=en).

## 4. Search-intent architecture (not page creation)

| Seed intent | Intent class | Future page type | Strategy dependency |
|---|---|---|---|
| date night kit for couples | Transactional | Product | Core single-product candidate; keep one canonical Product URL if model A wins. |
| couples craft kit | Commercial investigation | Product comparison or Category/Collection | A comparison is only useful if real alternatives exist; a category page depends on model B. |
| at home date night kit | Use case / problem-aware | Use Case | Could support either model, but should land on the actual purchasable experience. |
| craft date night | Use case / informational | Guide or Use Case | Keep advice genuinely useful; no mass AI article program. |
| couples activity gift | Commercial investigation | Collection or Product | A single kit is one gift option; a broader collection requires a broader catalog. |
| screen-free date night | Use case / problem-aware | Use Case or Guide | Fits the current hypothesis; validate with real query/session data. |
| anniversary activity / gift | Use case / problem-aware | Use Case or Collection | Could be one use-case landing page or a collection only if several real offers exist. |
| rainy day date night | Use case / problem-aware | Guide or Use Case | Do not create a thin city/season page solely for keyword coverage. |
| cozy couple activity | Use case / problem-aware | Use Case or Guide | Supporting intent; test against actual search and conversion signals. |

### Product-model impact — decision remains Owner-owned

**If single planned date-night kit:** Shop can stay a simple route to the one canonical Product; taxonomy should be minimal or Shop may be de-emphasized; SEO should concentrate on the Product plus a small number of useful use-case pages; the feed represents one SKU; Home imagery should clarify the one actual offer rather than imply unconfirmed catalog breadth.

**If multi-category Mini Craft brand:** establish product-category/collection taxonomy before publishing more products; plan category and collection landing pages, breadcrumbs, Product schema per real product, feed identifiers, and stable category/product URLs; Home can represent breadth only where the products and images correspond to real offers.

Postponing the decision until after new category/collection URLs, feed identifiers, or indexable SEO landing pages are created risks taxonomy, canonical, internal-link, feed, schema, and redirect rework. Safe deadline: before those assets are created or before a public growth/content rollout—not a decision made by this Executor.

## 5. On-page SEO

ONPAGE_FINDINGS=PARTIAL

- **Home:** one clear H1 and clear emotional/use-case framing; title is relevant but does not include a stable site/brand title because WordPress site title is empty. Four Home product-display images have empty alt attributes. The broad craft imagery remains visibly tied to the unresolved product-model decision.
- **Shop:** one H1, but generic title and no canonical tag observed. It contains one visible product and little authored intro text (the WordPress page body is empty; WooCommerce renders the product loop). Avoid adding copy before model/offer truth is decided.
- **Product:** one H1 and a clear product name; title could be assessed against transactional intent after model and production product facts are confirmed. Product schema uses test price/currency/SKU. Gallery alt text is mostly generic (“Image 2” etc.); do not invent visual contents.
- **FAQ:** two H1s, while remaining heading levels are structured. Native details render; no FAQPage data. No copy was changed.
- **Shipping & Returns:** one H1 and clear policy section structure. Policy is not a target for keyword expansion; no delivery ETA should be invented.
- **Contact:** one H1 and a native contact form. No public support email/phone/address was detected or added; the approved channel is the form. Form delivery itself has not been tested.
- **Shared:** no meta descriptions or OG/Twitter tags across the six pages; every page is noindex on the local configuration. Eight same-origin content-link paths passed the bounded HTTP smoke check. No keyword-density/volume research was performed.
- **Adjacent published pages:** About has no H1; Blog is empty; Reviews has only 16 saved words and no H1. They currently emit noindex but need an Owner/reviewer publication decision before crawl is enabled.
- **Old demo product URLs:** three tested routes return 404, with no redirect. No backlink history is available in this local audit.

ONPAGE_P0=Resolve public-origin/indexability and production product truth before traffic.  
ONPAGE_P1=After model/domain decisions, add accurate metadata/canonicals/social tags, fix Home image alts, reduce FAQ to one H1, and decide auxiliary page visibility.

## 6. Performance / Core Web Vitals

LOCAL_MEASUREMENT=STATIC_HTTP_AND_MARKUP_SNAPSHOT_ONLY  
PRODUCTION_UNVERIFIED=YES

A single local GET-to-response-header sample (proxy bypassed) returned Home HTML at about 1.13 s / 153.6 kB and Product at about 0.29 s / 104.7 kB; other primary content pages were roughly 0.19–0.31 s in that sample. These are local response samples, not laboratory or field TTFB/CWV.

Static markup inspection found:

- Home: 22 script tags, 12 stylesheet links, 6 head script tags that appear to lack async/defer.
- Product: 37 script tags, 13 stylesheet links, 11 head script tags that appear to lack async/defer. WooCommerce gallery scripts and PPCP SDK boot/fraudnet loader references are present.
- WooCommerce core scripts, including order attribution/cart-related scripts, appear across non-commerce pages too. This is an enqueue-cost signal only; transferred bytes and execution cost were not measured.
- All sampled img tags had width/height attributes; Home had 7 images (4 lazy), Product 8 images (5 lazy). All had srcset markup. Home’s 4 product-display images are 1448×1086; the editorial image is 1536×1024. Product main-image intrinsic markup is 506×332 and gallery thumbnails are much smaller; the previously accepted exact-asset check found no identical higher-resolution source, so PRODUCT_GALLERY_HIRES_ASSET_PENDING=YES.
- Empty alt attributes occur on the logo and several Home/Product images; some may be decorative, but the Home product-display images need Owner-approved descriptive alt text before indexing.
- No external script host appeared in the static HTML. PPCP’s runtime SDK may load provider resources dynamically; that cost was not traced.

LCP candidate is likely the Home hero image / Product main image; CLS risk from sampled image elements is reduced by explicit dimensions, but CSS backgrounds, font swaps, and runtime layout were not profiled. INP, actual LCP/CLS, mobile total-resource weight, and PayPal dynamic requests remain UNKNOWN. Do not claim local measurements as Search Console field data. Current “good” field thresholds are evaluated at the 75th percentile: LCP ≤2.5 s, INP ≤200 ms, CLS ≤0.1.  
Reference: [Web Vitals thresholds](https://web.dev/articles/vitals).

## 7. Growth instrumentation

| Capability | Status | Evidence |
|---|---|---|
| GA4 | ABSENT | No active analytics plugin or gtag/GTM bootstrap observed in sampled page markup. |
| PostHog | ABSENT | No active plugin or PostHog marker observed. |
| Ecommerce event tracking | PARTIAL | WooCommerce order-attribution script is present, but no GA4/PostHog event pipeline for view_item/add_to_cart/view_cart/begin_checkout/add_payment_info/purchase was detected. Attribution script alone is not the requested analytics layer. |
| UTM standard | ABSENT | No project UTM specification found in the Mini Craft repo/workspace. Woo attribution may parse campaign parameters, but there is no agreed naming contract. |
| Session replay | ABSENT | No replay vendor/plugin marker observed. |
| Error tracking | ABSENT | No Sentry/Bugsnag-style integration observed. |
| Creator / affiliate attribution | ABSENT | No project system or integration observed. |
| Email capture | ABSENT | Contact form is support/contact, not a marketing opt-in. |
| Consent management | ABSENT | No consent platform/banner detected in sampled pages. |

No analytics or consent script was installed. Because no analytics tags were detected, no current analytics-before-consent execution was observed; consent gating is still required before adding tracking or marketing-email flows.

## 8. Purchase truth contract (recommendation only)

PURCHASE_CANONICAL_TRUTH=WOOCOMMERCE_ORDER_PAYMENT_STATE

| Event | Trigger | Source of truth | Dedupe key | Minimum properties | Browser-only limitation |
|---|---|---|---|---|---|
| view_item | Product detail rendered/visible | WooCommerce product identity + page view | Session + product ID + event/view ID | product_id, sku, name, currency, price, category | A page load is a view signal, not intent or a sale. |
| add_to_cart | Woo cart mutation succeeds | Woo cart/session item state | Cart session + cart-item key + operation ID | product_id, quantity, item price, currency, cart hash | Clicks can fail, repeat, or be blocked; reconcile to actual cart mutation. |
| view_cart | Cart page rendered with cart snapshot | WooCommerce cart/session | Session + cart hash + view ID | item IDs/quantities, value, currency, cart hash | A browser view is not an order. |
| begin_checkout | Checkout is initialized for a non-empty cart | WooCommerce checkout/cart state | Session + cart hash + checkout attempt ID | cart items, value, currency, shipping country | Redirects/refreshes can duplicate; no PII in analytics. |
| add_payment_info | Customer selects a payment method or completes the safe method-selection step | Woo checkout state; method name only | Session + cart hash + method + attempt ID | method category, currency, value | Never capture payment credentials, secrets, or provider payload. |
| purchase | Woo order transitions to the accepted paid state after provider confirmation | WooCommerce order/payment state; provider transaction correlation is secondary evidence | Stable Woo order ID / idempotency key | order reference, currency, total, item IDs/quantities, paid state | Thank-you-page/browser events can replay or be blocked; never use them as canonical truth. |

This contract is not implemented in this Gate. Server-side purchase measurement is absent even though WooCommerce remains the canonical commerce/order system.

## 9. Privacy, consent, lifecycle email

CONSENT_PRIVACY_STATUS=NOT_READY_OWNER_LEGAL_REVIEW

The assigned Privacy Policy page is draft and guest-facing URLs return 404; no Terms page is configured; no cookie/analytics consent system was observed. No legal compliance certification is made. Owner/legal review is needed for the actual data collection, analytics/marketing consent choices, and US-market operation before implementation.

EMAIL_CAPTURE_STATUS=ABSENT

- No marketing/newsletter capture was observed.
- WooCommerce provides native transactional email templates; a sender-from-address setting is present, but its value is intentionally not reproduced and external delivery/DNS authentication was not tested.
- Active plugins include no SMTP/email-provider integration. Sender domain, SPF, DKIM, DMARC, bounce/complaint, suppression, and deliverability remain UNKNOWN.
- Contact form fields are present in the page implementation, but no submission was sent; delivery to the approved support channel is unverified.
- Welcome, browse/cart abandonment, post-purchase, review request, and referral flows are absent.

## 10. CRO / trust status

| Item | Status | Evidence / boundary |
|---|---|---|
| Real product proof / genuine customer proof | UNKNOWN | No verified customer proof was established by this audit; Woo product review count is 0. Do not create reviews or ratings. |
| Exact kit contents / supplier confirmation | OWNER_DECISION_REQUIRED | No contents list was inferred or added. |
| Completion time / difficulty | UNKNOWN | No verified numeric claim established. |
| Production price/currency | TEST_DATA | Current JPY 1 is a local test price; US production pricing is not confirmed. |
| Stock model/quantity | TEST_DATA | Current quantity 8 / InStock is test inventory. |
| Production SKU | TEST_DATA | MCK-LOCAL-TEST-001 is test-only. |
| Brand / GTIN / MPN | UNKNOWN | No Product schema brand or identifier fields observed; supplier/Owner must confirm whether identifiers apply. |
| Shipping promise | CONFIRMED_NO_FIXED_ETA_UNTIL_VERIFIED | This is the approved policy boundary; final fulfillment facts/costs still need operational confirmation. |
| Returns | PARTIAL | Approved 14 days after delivery; return method/fees/public return address and Merchant Center mapping require confirmation. |
| Damaged/missing item remedy | CONFIRMED | Replacement-first approved rule; no extra guarantee inferred. |
| Support channel | CONFIRMED_CHANNEL; DELIVERY_UNVERIFIED | Contact form is the approved public channel; no test submission was performed. |
| Checkout | PARTIAL_LOCAL | Guest checkout is enabled and US-only selling/shipping lists were read as US; current currency/product/shipping remain local test state. Checkout’s fresh empty-cart GET redirects normally. |
| Payment trust | TEST_ONLY | Local PPCP Sandbox history is not production payment readiness; this audit made no payment/config change. |
| Mobile checkout / final action | PRIOR_K4_ACCEPTED; NOT_RETESTED_HERE | Prior visual Gate accepted native checkout layout/action without clicking Place order; no new screenshot or order was created here. |
| Gallery resolution | PENDING | Main intrinsic markup is 506×332; prior exact source search found no content-identical higher-resolution replacement. |

## 11. Minimal Growth subsystem recommendation

Audit only—no folder/files were created.

**Prepare now (lightweight docs):** 00_GROWTH_SYSTEM.md, 02_EVENT_TAXONOMY.md, 03_UTM_STANDARD.md, 07_CRO_BACKLOG.md. These should establish the constraint, measurement contract, campaign naming, and evidence-backed backlog before traffic.

**Before soft launch, once facts exist:** 01_UNIT_ECONOMICS.md (actual COGS/fulfillment/payment fees), 04_CREATIVE_LIBRARY.md (approved real assets/rights), 08_WEEKLY_GROWTH_REVIEW.md and a lightweight 09_CHANNEL_SCORECARD.md. Add 06_EMAIL_FLOWS.md only after sender, consent, and provider decisions.

**After a real channel/partner exists:** 05_CREATOR_CRM.csv; dashboards/experiments only when there is enough reliable traffic and instrumentation to answer a concrete question.

**Defer as overengineering now:** automated multi-channel attribution, complex dashboards, session replay before a documented need/consent plan, broad automation, large-scale AI SEO/article production, and a creator CRM before creators are active.

## 12. Priority map and Owner checkpoints

See:
- [Growth Readiness Matrix](GROWTH_READINESS_MATRIX.md)
- [Growth Owner Checkpoints](GROWTH_OWNER_CHECKPOINTS.md)

P0_COUNT=5  
P1_COUNT=7  
P2_COUNT=5  
DEFER_COUNT=4  
OWNER_ACTION_REQUIRED=CONSOLIDATED_IN_GROWTH_OWNER_CHECKPOINTS.md

## 13. Official references

- [Google Search Console setup](https://developers.google.com/search/docs/monitor-debug/search-console-start)
- [Google Search Console ownership verification](https://support.google.com/webmasters/answer/9008080?hl=en)
- [Google sitemap guidance](https://developers.google.com/search/docs/crawling-indexing/sitemaps/build-sitemap)
- [Google Product structured data](https://developers.google.com/search/docs/appearance/structured-data/product)
- [Google Merchant listings structured data](https://developers.google.com/search/docs/appearance/structured-data/merchant-listing)
- [Google free-listing product attributes](https://support.google.com/merchants/answer/13889434?hl=en)
- [Google product data specification](https://support.google.com/merchants/answer/7052112)
- [Google Merchant Center returns](https://support.google.com/merchants/answer/14011730?hl=en)
- [Google FAQ rich-result change](https://developers.google.com/search/blog/2023/08/howto-faq-changes)
- [Web Vitals](https://web.dev/articles/vitals)
