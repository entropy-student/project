# Reviewer Decision — K4.8 First SKU Product Truth Discovery

Date: 2026-09-23
Status: AUTHORIZED
Parent: K4.7 Owner Launch Truth Resolved

## Why this Gate is first

The growth audit identified production product truth as a P0 blocker.

Owner has chosen:
PRODUCT_MODEL=MULTI_CATEGORY_MINI_CRAFT_BRAND

This means Mini Craft is the long-term brand umbrella, but the current store still needs one real first launch SKU with verified commercial and supplier facts before production SEO, Merchant Center, feed/schema completion, paid acquisition, or real orders.

The current Mini Craft Night Kit remains a concept/offer shell until a concrete SKU/source is selected.

## Gate

GATE=K4_8_FIRST_SKU_PRODUCT_TRUTH_DISCOVERY

## Mode

RESEARCH / READ-ONLY

Do not:
- purchase samples
- contact suppliers
- create supplier accounts
- place orders
- change WooCommerce
- change Product copy/images
- change price/SKU/stock
- publish SEO pages
- create Merchant Center feeds
- create analytics accounts
- expose Owner credentials or personal data

## Target market

INITIAL_MARKET=UNITED_STATES

## Research objective

Find a bounded shortlist of real candidate first-launch products/sources that can support the Mini Craft positioning:

- tactile craft activity
- suitable for an at-home couple/date-night experience
- visually giftable / demonstrable
- reasonable for a small independent store to test
- not dependent on large initial inventory
- supplier/product facts can be verified

Do not assume a winning craft family in advance.

Use current project evidence and prior product direction as context, but distinguish:
- VERIFIED supplier/product fact
- supplier claim
- marketplace listing claim
- inference
- unknown

## Candidate scope

Return 3–5 concrete candidate SKUs/supplier offers.

Prefer candidates where the research can establish:
- actual supplier/store identity
- listing/source URL
- exact product name/model
- MOQ
- unit price range
- sample availability
- customization/private-label availability
- dropship / small-order feasibility
- US shipping option or stated lead time
- product dimensions / package dimensions if available
- weight if available
- materials
- exact included components
- skill/difficulty description if documented
- completion-time claim only if documented
- battery/LED/electrical components
- age/safety/compliance notes where relevant
- brand/manufacturer
- GTIN/UPC/EAN/MPN if actually assigned
- image/media usage rights or whether supplier permission is still required
- return/defect handling
- missing-parts/replacement policy if published

Never invent missing data.

## Economics

For each candidate, estimate only when supported by visible supplier/listing values:

PRODUCT_COST=
SAMPLE_COST=
MOQ=
SHIPPING_TO_US=
LANDED_COST_STATUS=<VERIFIED | PARTIAL | UNKNOWN>

Do not invent a retail selling price or margin.

If shipping cannot be quoted without address/account/login:
SHIPPING_TO_US=UNKNOWN_REQUIRES_SUPPLIER_OR_CHECKOUT

## Risk review

For each candidate record:
- fragile parts
- missing-part risk
- assembly failure risk
- excessive size/weight
- batteries/LED/electrical
- age/safety labeling
- intellectual-property/licensing risk
- image-rights uncertainty
- long shipping
- high MOQ
- inconsistent variants
- weak supplier evidence

## Fit with current brand

Assess each candidate against the current proposition:
"Sell the night, not the supplies."

Use descriptive fit only:
- date-night experience fit
- visual/demo content potential
- giftability
- beginner accessibility evidence
- repeat/category expansion potential

Do not state unverified experiential claims as facts.

## Multi-category architecture impact

Owner chose a multi-category brand.

For each candidate, state the likely future category family if it became the first real SKU, for example:
- Miniature Kits
- Painting Kits
- Weaving Kits
- Cross-Stitch Kits
- another evidence-backed category

Do not create categories on the site in this Gate.

## Source quality

Prefer:
1. manufacturer / supplier primary listing
2. recognized wholesale marketplace supplier listing
3. logistics/marketplace listing as secondary corroboration

Avoid treating social posts or copied reseller pages as production truth.

Record source date and source type.

## Output

Create:
- docs/FIRST_SKU_PRODUCT_TRUTH_DISCOVERY.md
- docs/FIRST_SKU_CANDIDATE_MATRIX.md

Update:
- EXECUTION_EVIDENCE.md
- EXECUTOR_HANDOFF.md

## Candidate matrix fields

For each candidate:
CANDIDATE_ID=
PRODUCT_FAMILY=
SOURCE=
SUPPLIER=
LISTING=
MOQ=
UNIT_COST=
SAMPLE_AVAILABLE=
CUSTOMIZATION=
DROPSHIP_SMALL_ORDER=
US_SHIPPING=
LEAD_TIME=
DIMENSIONS=
WEIGHT=
MATERIALS=
CONTENTS=
DIFFICULTY=
COMPLETION_TIME=
ELECTRICAL_COMPONENTS=
BRAND_MANUFACTURER=
GTIN_MPN=
MEDIA_RIGHTS=
DEFECT_REPLACEMENT=
LANDED_COST_STATUS=
KEY_RISKS=
DATE_NIGHT_FIT=
SEO_CATEGORY_FIT=
EVIDENCE_CONFIDENCE=

## Reviewer output requirement

Do not pick or buy the product for Owner.

At the end identify:
- 1–2 candidates with the strongest evidence completeness
- which missing facts require supplier contact/sample inspection
- the minimum next Owner action:
  SELECT_CANDIDATE_FOR_SAMPLE
  or
  AUTHORIZE_SUPPLIER_CONTACT

This is not a purchase authorization.

## Workspace

No shared-root temp folders.
No image downloads unless necessary for evidence comparison.
Do not copy supplier copyrighted image catalogs into GitHub.
Use links and textual evidence.

## Return

GATE=K4_8_FIRST_SKU_PRODUCT_TRUTH_DISCOVERY
RESULT=<PASS_CANDIDATE_K4_8_FIRST_SKU_PRODUCT_TRUTH_DISCOVERY | RETURN_REVIEWER_*>
SUMMARY=
CANDIDATES_FOUND=
PRIMARY_SOURCE_COVERAGE=
US_SHIPPING_COVERAGE=
MOQ_COVERAGE=
LANDING_COST_COVERAGE=
MEDIA_RIGHTS_COVERAGE=
TOP_EVIDENCE_COMPLETE_CANDIDATES=
SUPPLIER_CONTACT_REQUIRED=
SAMPLE_PURCHASE_REQUIRED=
PRODUCT_MODEL_STRATEGY=MULTI_CATEGORY_MINI_CRAFT_BRAND
SITE_MUTATION=0
ORDER_ACTIONS=0
PAYMENT_ACTIONS=0
EXTERNAL_ACCOUNT_ACTIONS=0
WORKSPACE_TEMP_CLEANUP=
ROOT_TRANSIENTS_CREATED=
ROOT_TRANSIENTS_REMAINING=
LOCAL_HELPERS_CLEANED=
BROWSER_PROFILES_CLEANED=
EVIDENCE=
COMMIT=
OWNER_ACTION=<SELECT_CANDIDATE_FOR_SAMPLE | AUTHORIZE_SUPPLIER_CONTACT | NONE>
NEXT=STOP_AT_REVIEWER

Do not enter K5.
Do not implement GA4/Resend/SEO yet.
