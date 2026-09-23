# Reviewer Decision — K4.7 Owner Launch Truth Checkpoint Resolved

Date: 2026-09-23
Status: RESOLVED

## Owner decisions

PRODUCT_MODEL=MULTI_CATEGORY_MINI_CRAFT_BRAND

Interpretation:
- Mini Craft is treated as a brand umbrella intended to support multiple real craft product categories over time.
- The current Mini Craft Night Kit remains the first approved customer-facing product/offer.
- Do not create empty/fake categories or unverified products merely to make the brand look broad.
- SEO architecture may expand through real category/collection/use-case clusters only when real products exist.

PUBLIC_ORIGIN=https://minicraft.spikersun.com

Interpretation:
- use the existing spikersun.com domain family for the first public validation/soft-launch origin;
- no separate domain purchase is required for the subdomain;
- DNS/HTTPS setup remains an implementation task;
- before large-scale SEO/link-building, Reviewer should revisit whether a dedicated standalone brand domain is worth migrating to.

ANALYTICS_PROVIDER=GA4_FIRST

Interpretation:
- start with one analytics system;
- use GA4 for acquisition/ecommerce funnel measurement;
- defer PostHog/session replay until a demonstrated need exists;
- WooCommerce paid order/payment state remains canonical purchase truth.

LEGAL_CONSENT_PATH=DRAFT_FIRST_FOR_OWNER_LEGAL_REVIEW

Interpretation:
- create implementation-aware Privacy/Terms/Consent drafts first;
- Owner performs final review / obtains qualified legal review as appropriate;
- no legal certification is implied.

EMAIL_PROVIDER=RESEND
SUPPORT_ADDRESS=support@minicraft.spikersun.com
INBOUND_INITIAL_PATH=CLOUDFLARE_EMAIL_ROUTING_OR_EQUIVALENT_FORWARDING

Interpretation:
- Resend is the first-choice transactional outbound provider;
- support address uses the public storefront host naming;
- credentials/API keys remain Owner-only;
- a full paid mailbox is not required for the initial validation if inbound forwarding is sufficient.

## Cost posture

Incremental launch-foundation target is $0 where practical:
- existing subdomain: no new domain purchase;
- GA4 Standard: free;
- Resend: begin on free tier within limits;
- Cloudflare Email Routing: free for inbound forwarding;
- Privacy/Terms drafting in-project: no software fee.

Potential later costs:
- dedicated standalone brand domain;
- Resend paid tier above free limits;
- paid mailbox/Google Workspace/other hosted inbox if required;
- qualified legal review;
- paid advertising or other acquisition spend.

## Architectural impact of product model B

Compared with a single-product model, multi-category brand architecture means future SEO/navigation/feed work should be organized around:

Brand
→ real Product Categories / Collections
→ Products
→ Use-case / problem-aware landing pages

This decision affects future:
- taxonomy
- URL architecture
- navigation
- internal linking
- Merchant Center/feed organization
- structured data
- keyword clustering
- homepage merchandising

It does not authorize creating empty categories, fake breadth, or unverified product claims.

## Next implementation dependency

Before production commerce launch, PRODUCT_TRUTH still requires:
- actual first-product contents/claims
- production price and currency
- final SKU
- stock/inventory model
- brand/manufacturer/GTIN/MPN applicability
- approved product/gallery assets

These remain the next Owner/supplier truth inputs.
