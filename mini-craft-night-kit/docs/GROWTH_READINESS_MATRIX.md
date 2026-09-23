# K4.5 Growth Readiness Matrix

GATE=K4_5_GROWTH_SEO_READINESS_AUDIT  
AS_OF=2026-09-23  
P0_BEFORE_FIRST_QUALIFIED_TRAFFIC=5  
P1_BEFORE_SOFT_LAUNCH=7  
P2_AFTER_FIRST_REAL_SESSIONS=5  
DEFER_UNTIL_DATA=4  
AUDIT_ONLY=YES

This is sequencing, not an implementation authorization. The site remains local-only; all current product price/stock/SKU and checkout shipping are test state. Use the smallest measurement plan that can answer the highest-value question. Do not begin with article volume or channel sprawl.

## P0 — Before first qualified traffic (5)

| ID | Constraint / required outcome | Current evidence | Exit evidence (future Gate) |
|---|---|---|---|
| P0-1 | Establish one stable public HTTPS production origin; replace local canonicals, resolve local noindex state deliberately, expose intended indexable pages, keep Cart/Checkout/Account/search non-indexable, and make a valid sitemap reachable. | Active site is HTTP localhost; WordPress blog_public=0; all sampled pages emit noindex/nofollow; canonical tags point to localhost (Shop has none); sitemap endpoints 404. | Public unauthenticated HTTPS checks, stable canonical host, production robots/noindex matrix, valid sitemap URL and successful crawl test. |
| P0-2 | Replace test commercial/product facts with Owner/supplier-approved truth: actual kit contents, production price/currency, stable SKU, inventory model, truthful availability, image rights/resolution, brand, and GTIN/MPN applicability. | JPY 1, stock 8/InStock, MCK-LOCAL-TEST-001; schema reflects test data; exact contents and identifiers remain unconfirmed. | Approved product fact sheet and matching product page, WooCommerce state, schema, checkout, and feed fields. |
| P0-3 | Provide a minimal measurable funnel before first qualified visits; choose GA4 or PostHog (not both by default), define the event/UTM contract, and keep WooCommerce paid order state canonical for purchase. | GA4/PostHog absent; Woo order-attribution script only; no project UTM standard or ecommerce-event pipeline. | Owner-selected property/project; event test for view_item → add_to_cart → view_cart → begin_checkout → add_payment_info → purchase; purchase reconciles to a server-side WooCommerce paid order exactly once. |
| P0-4 | Resolve privacy/terms/consent publication with Owner/legal review before any tracking or marketing-email capture. | Privacy page is draft and guest routes return 404; Terms page unset; no consent manager detected. No legal certification has been attempted. | Owner/legal-approved public policy/terms and documented consent behavior for selected analytics/email tools. |
| P0-5 | Verify that support/contact submissions and required transactional messages reach the intended Owner-controlled destination before paid acquisition. | Native Contact form exists; no form submission was performed. Woo sender-from-address option is set, but delivery, domain authentication, and inbox handling are unverified. | Synthetic/local controlled test plan with Owner mailbox; confirm contact and order notifications without putting addresses or content into public evidence. |

## P1 — Before soft launch (7)

| ID | Work | Dependency / reason |
|---|---|---|
| P1-1 | Owner verifies the final domain in Search Console; submit the production sitemap and review URL coverage. | Requires stable public domain/HTTPS and P0-1. Google’s Search Console setup calls for ownership verification; sitemap submission is optional for discovery but useful for monitoring. |
| P1-2 | Decide whether to claim/operate Merchant Center and free listings; configure truthful US product, shipping, and return data. | Requires P0-1/P0-2 and a public landing page whose price, availability, shipping, and return information match the feed. No account is created in this audit. |
| P1-3 | After commercial facts are confirmed, validate Product/Offer schema and add only substantiated brand, shipping, return, and identifier data. | Current single Product JSON-LD lacks brand/shippingDetails/hasMerchantReturnPolicy; never fabricate properties. Run current Rich Results / Merchant diagnostics in an authorized later Gate. |
| P1-4 | Prepare accurate page titles, meta descriptions, canonical/OG data, and selective index policy for Home, Shop, Product, FAQ, Shipping, and Contact. | Currently no meta descriptions/OG; canonical host is local, Shop canonical is absent; Home site title is empty. Requires domain and product-model decisions. |
| P1-5 | Finalize high-resolution approved product/gallery assets and descriptive alt text for meaningful product imagery. | Product gallery main intrinsic markup is 506×332; prior exact-source search found no identical high-resolution source. Home product-display images currently have empty alt. Owner must supply/approve source and content description. |
| P1-6 | Decide public state for auxiliary About/Blog/Reviews pages and any legacy demo URL redirect policy before allowing crawl. | These routes are currently noindex; Blog is empty, Reviews has 16 words/no H1, About no H1. No link/backlink history was available. |
| P1-7 | Configure sender domain/provider and validate SPF/DKIM/DMARC, transactional delivery, suppression/complaint handling, and any opted-in lifecycle flows. | No email provider integration or marketing capture is present; sender domain and DNS remain unknown. Build lifecycle flows only after consent and provider are approved. |

## P2 — After first real sessions (5)

| ID | Work | Why it waits |
|---|---|---|
| P2-1 | Use Search Console queries/impressions and actual landing-page sessions to refine the intent map and internal links. | No production query/session data exists. |
| P2-2 | Review field Core Web Vitals by device at the 75th percentile and prioritize the largest observed issue. | Local HTML/markup sampling is not field data; production field collection needs a public site and real visits. |
| P2-3 | Build CRO experiments around observed funnel drop-off, not assumed friction. | There are no real session/event baselines yet. |
| P2-4 | Request and publish genuine reviews/creator proof only after real customers/partners exist and applicable consent/permissions are established. | Current review count is zero; no testimonial/UGC may be fabricated. |
| P2-5 | Compare channel/cohort performance and refine source attribution after a small number of channels are deliberately selected. | Avoid multi-touch complexity before enough campaign data exists. |

## Defer until data / explicit Owner strategy (4)

| ID | Defer | Reason |
|---|---|---|
| D-1 | Large-scale or programmatic AI SEO article production. | No evidence of query demand, product-model decision, or conversion constraint to justify content volume. |
| D-2 | Session replay and complex cross-domain/multi-touch attribution. | Adds privacy/consent and operational burden before a demonstrated measurement need. |
| D-3 | Dashboards, broad experiments, and growth automation. | Build only after trusted event definitions and enough observations exist to change decisions. |
| D-4 | Creator CRM/affiliate program and cross-border expansion. | No active creator/channel program; initial market is US and cross-border economics/fulfillment/legal facts are not established. |

## Gating notes

- PRODUCT_MODEL_STRATEGY_DECISION=PENDING_OWNER_REVIEW; do not create categories, content pages, feed taxonomy, or new products as part of this audit.
- Production price, stock, SKU, GTIN/MPN, supplier contents, and media remain Owner/supplier checkpoints.
- Search Console, Merchant Center, GA4/PostHog, DNS, and email-provider accounts were not created or connected.
- P0/P1 are readiness findings only; no SEO, analytics, consent, or customer-copy changes were made.
