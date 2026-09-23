# Reviewer Decision — K4.7 Owner Launch Truth Checkpoint

Date: 2026-09-23
Status: OWNER CHECKPOINT
Parent: K4.6 Growth Foundation Spec PASS

## Purpose

Resolve only the Owner decisions that materially affect the first P0 implementation Gate.

Do not send credentials, tokens, verification codes, payment secrets, raw provider payloads, customer data, or mailbox passwords.

## Immediate decisions required

### A. PRODUCT_TRUTH — launch model

Reviewer recommendation for first launch:
SINGLE_PLANNED_DATE_NIGHT_KIT

Reason:
- current Shop has one approved customer-facing product;
- current positioning already centers on a planned date-night experience;
- a single-product launch minimizes taxonomy/feed/schema/SEO rework while real demand is still unproven;
- multi-category expansion can follow real demand.

Owner may override and choose:
MULTI_CATEGORY_MINI_CRAFT_BRAND

This checkpoint does NOT require final supplier contents yet, but the model must be chosen before public category/collection/SEO URL work.

### B. PUBLIC_ORIGIN — production domain family

Owner chooses the production domain/host family to be used for the public store.

Only the chosen domain name is needed here.
DNS credentials stay Owner-only.

### C. MEASUREMENT — initial analytics provider

Reviewer recommendation:
GA4_FIRST

Reason:
- the immediate need is acquisition + ecommerce funnel measurement;
- Search Console / Merchant Center / future Google Ads ecosystem is likely relevant;
- session replay and deeper product analytics are intentionally deferred;
- avoid running GA4 + PostHog simultaneously before a clear need exists.

Owner may override:
POSTHOG_FIRST

### D. LEGAL_CONSENT

Owner confirms one of:
1. OWNER_WILL_SUPPLY_APPROVED_PRIVACY_TERMS
2. DRAFT_FIRST_FOR_OWNER_LEGAL_REVIEW

No legal certification is implied. Tracking implementation remains blocked until this path is chosen.

### E. DELIVERY_AND_EMAIL

Reviewer recommendation:
RESEND_OR_EQUIVALENT_TRANSACTIONAL_PROVIDER + support mailbox on production domain

Owner only needs to choose:
- support/sender mailbox naming convention (for example support@production-domain), without sharing credentials;
- whether Resend is acceptable as the initial provider.

Operational shipping ETA/return address can remain pending if not yet supplier-confirmed, but no public false promise may be introduced.

## Output

Owner should return five short values:
PRODUCT_MODEL=
PUBLIC_ORIGIN=
ANALYTICS_PROVIDER=
LEGAL_CONSENT_PATH=
EMAIL_PROVIDER_AND_MAILBOX=

After these are supplied, Reviewer will authorize a bounded P0 implementation Gate.

Do not enter K5 before the P0 implementation/verification Gate is complete.
