# Mini Craft Night Kit — Growth System

GATE=K4_6_GROWTH_FOUNDATION_SPEC
STAGE=PRE_FIRST_QUALIFIED_TRAFFIC
PRODUCT_MODEL_STRATEGY_DECISION=PENDING_OWNER_REVIEW
ANALYTICS_PROVIDER=PENDING_OWNER_SELECTION

## Operating state

The storefront is a local/test-state implementation, not a production growth surface. The current highest-value unknown is PRODUCT_TRUTH: which product model is approved and what the supplier-confirmed offer, economics, identifiers, inventory, and imagery actually are. Public origin, measurable events, legal/consent readiness, and reliable customer/transactional delivery are also pre-traffic constraints.

Growth work should resolve the largest decision-changing unknown, not maximize channel or content volume. The K4.5 readiness audit and matrix are the evidence baseline; the current CRO backlog is in 07_CRO_BACKLOG.md.

## Funnel and purchase truth

Visit → Product View → Add to Cart → View Cart → Begin Checkout → Payment → Paid Order

WooCommerce paid order/payment state = PURCHASE_CANONICAL_TRUTH. A browser purchase event is only an analytics signal; it is not proof of payment. A future purchase event must reconcile 1:1, exactly once, to a genuine WooCommerce paid/captured order. Sandbox/test orders must not be reported as production purchases.

The minimum event contract is in 02_EVENT_TAXONOMY.md. Campaign naming is in 03_UTM_STANDARD.md.

## Priority operating order

### P0 — before first qualified traffic

1. Establish stable public HTTPS origin and intentional crawl/index/canonical/sitemap behavior.
2. Replace all test commercial/product data with Owner/supplier-approved production truth.
3. Select one analytics provider and validate the minimal funnel plus UTM contract while preserving WooCommerce purchase truth.
4. Obtain Owner/legal review for public Privacy/Terms and consent behavior before tracking or marketing capture.
5. Verify Contact form and required transactional email delivery to Owner-controlled destinations.

### P1 — before soft launch

Search Console verification and sitemap monitoring; decide Merchant Center/free listings only when product/feed facts are ready; validate substantiated Product/Offer structured data; prepare accurate titles/meta/canonical/OG; approve high-resolution images and meaningful alt text; decide auxiliary page and legacy URL states; authenticate sender domain and verify email handling.

### P2 — after first real sessions

Use query/session and funnel evidence to refine intent/internal links; assess production field Core Web Vitals; run one evidence-based CRO experiment at a time; gather genuine customer/creator proof only with real participants and permission; optimize channels from observed cohorts.

### Defer

Do not scale before measurement and product truth. Defer mass/programmatic AI SEO, complex multi-touch attribution, session replay absent a demonstrated need and consent plan, large dashboards/automation, creator CRM before an active creator program, and cross-border expansion without approved economics/operations.

## Scale and experiment guardrails

- One experiment at a time; write its question, primary metric, guardrail, and stop rule before launch.
- No measurement, no scale. No production product truth, no scale.
- Do not fabricate reviews, UGC, stock, shipping promises, product contents, or performance claims.
- Do not treat SEO content volume or a dashboard as a substitute for resolving the current constraint.
- WooCommerce remains the canonical commerce/order system; no parallel purchase ledger.

## Review cadence and Soft Launch gate

Before qualified traffic, review readiness when a blocking Owner bundle or implementation changes; do not manufacture weekly optimization without data. After Soft Launch has trustworthy sessions, use a lightweight weekly review of funnel health, channel quality, customer issues, and one next experiment.

Soft Launch requires P0 resolved, an end-to-end measurable funnel, approved production product truth, stable public origin, Owner/legal-approved basic policies/consent, and verified payment plus Contact/transactional delivery. This is a readiness checklist, not authorization to implement or launch.

## Consolidated Owner checkpoints

Do not ask for these during this documentation Gate. Collect each bundle once when its implementation decision is scheduled.

### A. PRODUCT_TRUTH

Single product vs multi-category model; supplier-confirmed kit contents; production price/currency; SKU; stock strategy; brand; GTIN/MPN applicability; approved product images and rights.

### B. PUBLIC_ORIGIN

Production domain; hosting; Owner-controlled DNS; stable HTTPS.

### C. MEASUREMENT

Choose GA4 or PostHog (not both by default); confirm account/project ownership.

### D. LEGAL_CONSENT

Owner/legal-approved Privacy and Terms; analytics consent behavior; email-marketing consent behavior.

### E. DELIVERY_AND_EMAIL

Operational shipping ETA; return operations/details; support mailbox; sender domain; transactional email provider; Contact form delivery destination.