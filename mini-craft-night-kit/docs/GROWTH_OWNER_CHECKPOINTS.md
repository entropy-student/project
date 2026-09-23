# K4.5 Growth / SEO Owner Checkpoints

GATE=K4_5_GROWTH_SEO_READINESS_AUDIT  
AUDIT_ONLY=YES  
PRODUCT_MODEL_STRATEGY_DECISION=PENDING_OWNER_REVIEW

This is one consolidated Owner checklist for a later launch-readiness decision. None of these actions was performed in this audit. Credentials, verification tokens, DNS values, customer data, and payment secrets must remain Owner-only.

| # | Owner decision / action | Current state | Needed before |
|---|---|---|---|
| 1 | Choose the product model: (A) one planned date-night kit or (B) a multi-category Mini Craft brand. | PENDING_OWNER_REVIEW. Home imagery suggests variety while Shop has one product. | Before adding category/collection URLs, new feed taxonomy, or indexable growth landing pages; otherwise URL/taxonomy/schema/feed/internal-link rework is likely. |
| 2 | Confirm actual kit contents, supplier/source, and which product claims are supportable (including duration/difficulty, if any). | UNKNOWN / supplier confirmation needed; no contents were inferred. | Before final Product content, Merchant data, or acquisition creative promises specifics. |
| 3 | Confirm production price/currency, SKU, stock/inventory model, and whether GTIN/MPN are assigned/applicable; confirm public brand/manufacturer naming. | Current JPY 1, stock 8, SKU MCK-LOCAL-TEST-001 are test-only; current schema lacks brand/GTIN/MPN. | Before accepting production orders, feed submission, or paid acquisition. Do not invent identifiers. |
| 4 | Approve final product/gallery images and their rights, resolution, and accurate alt descriptions. | Production image package pending; current gallery high-resolution source was not found by prior exact-source audit. | Before soft launch / Merchant listing submission. |
| 5 | Confirm fulfillment facts: processing/transit expectations, shipping costs, regions, return method/fees/address, and operational handling for damaged/missing items. | Approved policy: US initial market, no fixed ETA until verified, 14-day return window after delivery, replacement-first for damaged/missing. Exact operational details/public return address remain pending. | Before publishing final Merchant shipping/return configuration or making more specific promises. |
| 6 | Approve production domain/hosting and Owner-controlled DNS/HTTPS work. | Current only audited origin is local HTTP localhost; no production domain is evidenced. | Before public crawl, Search Console, Merchant Center, or first qualified traffic. |
| 7 | Decide Privacy/Terms publication and consent policy with qualified legal review appropriate to the real US operating footprint and selected data collection. | Privacy page is draft and guest routes return 404; Terms is unset; no consent manager/tracker is present. | Before adding analytics/marketing email and before public launch. This audit is not legal advice or certification. |
| 8 | Choose one initial analytics property/project (GA4 or PostHog) and approve who owns access. | Both absent; neither account was created or connected. | Before first qualified traffic. Do not send credentials to Executor/chat. |
| 9 | Approve a UTM naming convention and minimum campaign parameters. | No project UTM standard found; WooCommerce order attribution alone is not a team convention. | Before sending tagged creator, email, or paid traffic. |
| 10 | Create/choose Search Console property and perform Owner-controlled verification (DNS TXT for a Domain property, or a supported URL-prefix method). | No property exists in evidence; localhost cannot serve as the production property. | After domain/HTTPS is stable and before soft launch monitoring. |
| 11 | Decide whether to create Merchant Center, claim the production domain, and enable Free Listings. | No account/feed exists; product data is still test-only. | Only after #1–#6 and matching public landing-page/feed data are ready. |
| 12 | Choose a sender domain/provider and approve transactional/support/lifecycle email behavior, including consent, suppression, SPF/DKIM/DMARC, and test destination. | No email-provider plugin/integration or marketing capture observed; Woo sender setting is present but deliverability is unverified. | Before relying on contact form delivery or sending customer lifecycle messages. |
| 13 | Approve product-model strategy deadline. | Recommended deadline: before any new category/collection/SEO landing-page URL, Merchant feed taxonomy, or public growth campaign is implemented. | Avoid expensive taxonomy, canonical, internal-link, schema, feed, and redirect rework. |

## Owner-only account actions

When later authorized, Owner signs in directly to Google/domain/email-provider dashboards and completes verification/configuration. Executor should receive only bounded, non-sensitive status results (for example, “property verified” or “DNS record published”), never passwords, tokens, verification secrets, payment credentials, or raw provider payloads.

## No immediate interruption

These are documented downstream checkpoints, not blockers to completing this read-only audit. No piecemeal Owner question is needed now; Reviewer can decide the next authorized Gate after reviewing the audit and matrix.
