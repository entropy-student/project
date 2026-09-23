# Reviewer Decision — K4.6 Growth Foundation Specification

Date: 2026-09-23
Status: AUTHORIZED
Parent: K4.5 Growth / SEO Readiness Audit PASS

## Gate

GATE=K4_6_GROWTH_FOUNDATION_SPEC

## Purpose

Create the smallest durable growth operating system needed before implementation.

This is specification/documentation work only.

Do not:
- change WordPress
- install plugins
- connect GA4/PostHog
- send analytics events
- create Search Console/Merchant Center
- change robots/noindex/canonical
- create SEO landing pages
- change product price/SKU/stock
- change WooCommerce/PayPal/orders
- send email
- enter K5

## 1. 05_growth/00_GROWTH_SYSTEM.md

Define:
- current growth stage
- current highest-value unknowns
- P0/P1/P2/Defer logic
- funnel:
  Impression/Visit → Product View → Add to Cart → Cart → Checkout → Payment → Paid Order
- WooCommerce paid order/payment state as canonical purchase truth
- one-experiment-at-a-time principle
- no scale until measurement + product truth
- product-model strategy remains pending
- review cadence

Keep it short and operational.

## 2. 05_growth/01_UNIT_ECONOMICS.md

Create a calculation template only.

Fields:
- production price
- product cost
- packaging
- payment fee
- shipping subsidy
- returns/refunds allowance
- creator/affiliate cost
- contribution margin before CAC
- target CAC
- break-even CAC
- AOV

Do not invent values.

Mark unknowns:
OWNER_INPUT_REQUIRED

Include formulas and the minimum inputs Owner must later provide.

## 3. 05_growth/02_EVENT_TAXONOMY.md

Define the minimum funnel event contract:

- view_item
- add_to_cart
- view_cart
- begin_checkout
- add_payment_info
- purchase

For each:
- event purpose
- trigger
- browser/client signal
- authoritative source
- dedupe key
- minimum properties
- privacy-sensitive properties to avoid
- validation method

Purchase rules:
- browser event is NOT canonical truth
- WooCommerce paid/captured order state is canonical
- purchase event must reconcile exactly once to a real paid order
- no raw PayPal credentials/provider payloads

Also define:
ANALYTICS_PROVIDER=PENDING_OWNER_SELECTION

Compare only at a high level:
GA4 vs PostHog
without selecting or integrating one.

## 4. 05_growth/03_UTM_STANDARD.md

Define one simple convention.

Required:
utm_source
utm_medium
utm_campaign

Optional:
utm_content
utm_term

Define naming:
- lowercase
- hyphenated
- stable
- no PII
- no random free-text drift

Provide examples for:
organic social
creator
email
paid social
search

Define how WooCommerce order attribution and analytics UTM should be reconciled.

Do not create live campaigns.

## 5. 05_growth/07_CRO_BACKLOG.md

Seed only evidence-backed items from the audit.

Buckets:
P0
P1
P2
Defer

Include:
- production product truth
- public origin/indexability
- analytics/event tracking
- privacy/terms/consent
- contact/email delivery
- Product schema completion
- meta/OG/canonical
- image resolution/alts
- auxiliary pages
- Merchant/Search readiness
- real proof/reviews only after real customers
- field CWV after production traffic

Do not invent CRO experiments without data.

## 6. Owner checkpoint compression

Do not create another long 13-item checklist.

At the end, compress future Owner decisions into five bundles:

A. PRODUCT_TRUTH
- product model
- actual kit contents
- production price/currency
- SKU/stock
- brand/GTIN/MPN applicability
- approved product imagery

B. PUBLIC_ORIGIN
- production domain/hosting/DNS/HTTPS

C. MEASUREMENT
- choose GA4 or PostHog
- account ownership

D. LEGAL_CONSENT
- Privacy/Terms/consent behavior

E. DELIVERY_AND_EMAIL
- shipping/fulfillment operational facts
- sender/support mailbox/provider
- transactional/contact delivery destination

Record these five bundles in the Growth System.

Do not ask Owner to resolve them inside this Gate.

## 7. Workspace

Use canonical repo/document location.

No new shared-root temporary files.

No browser automation is needed.

Return workspace cleanup contract fields.

## 8. Deliverables

Create:
- 05_growth/00_GROWTH_SYSTEM.md
- 05_growth/01_UNIT_ECONOMICS.md
- 05_growth/02_EVENT_TAXONOMY.md
- 05_growth/03_UTM_STANDARD.md
- 05_growth/07_CRO_BACKLOG.md

Update:
- EXECUTION_EVIDENCE.md
- EXECUTOR_HANDOFF.md

## Return

GATE=K4_6_GROWTH_FOUNDATION_SPEC
RESULT=<PASS_CANDIDATE_K4_6_GROWTH_FOUNDATION_SPEC | RETURN_REVIEWER_*>
SUMMARY=
GROWTH_SYSTEM_CREATED=
UNIT_ECONOMICS_TEMPLATE_CREATED=
EVENT_TAXONOMY_CREATED=
UTM_STANDARD_CREATED=
CRO_BACKLOG_CREATED=
ANALYTICS_PROVIDER=PENDING_OWNER_SELECTION
PRODUCT_MODEL_STRATEGY_DECISION=PENDING_OWNER_REVIEW
OWNER_CHECKPOINT_BUNDLES=PRODUCT_TRUTH;PUBLIC_ORIGIN;MEASUREMENT;LEGAL_CONSENT;DELIVERY_AND_EMAIL
SITE_MUTATION=0
ANALYTICS_IMPLEMENTATION=0
SEO_IMPLEMENTATION=0
EXTERNAL_ACCOUNT_ACTIONS=0
NEW_ORDER_ACTIONS=0
PAYMENT_ACTIONS=0
WORKSPACE_TEMP_CLEANUP=
ROOT_TRANSIENTS_CREATED=
ROOT_TRANSIENTS_REMAINING=
LOCAL_HELPERS_CLEANED=
BROWSER_PROFILES_CLEANED=
DELIVERABLE_LOCATION=
ROLLBACK_LOCATION=
EVIDENCE=
COMMIT=
OWNER_ACTION=NONE
NEXT=STOP_AT_REVIEWER

Do not enter K5.
