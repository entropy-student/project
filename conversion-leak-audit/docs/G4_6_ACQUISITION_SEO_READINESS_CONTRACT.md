# G4.6 — Acquisition + SEO Readiness Contract

Date: 2026-09-23
Status: READY_FOR_EXECUTOR
Precondition: PASS_G4_5_VISUAL_FUNCTIONAL_ACCEPTANCE

## Goal

Prepare the current product for first acquisition experiments and future search indexing without turning this gate into a content factory, a marketing-scale project, or a production deployment.

This gate is based on:
- the accepted G4.5 product;
- Acquisition Growth Radar v0.2;
- current Google Search technical guidance;
- the current site content and WordPress architecture.

## Validation position

Current proven state:
- product mechanics work;
- evidence-backed Top 3 works;
- Owner can edit static WordPress content;
- solution mechanics have technical proof.

Not yet proven:
- Attention;
- Interest;
- real Activation/Aha with external users;
- Intent;
- Transaction;
- Repeatability;
- Economics.

Therefore the current growth bottleneck is not “more traffic.”

The immediate readiness problem is:
`Message + Proof/Trust + Activation path + search discoverability`.

Do not build a large SEO content program before real behavior data exists.

---

## P0 — Must complete in this gate

### P0.1 Home message must name the category and situation

Keep the approved visual structure.

Do not replace the current H1 unless necessary.

Make the page explicitly understandable as an ecommerce/storefront conversion audit.

Preferred approach:
- change the eyebrow from generic `EVIDENCE-FIRST STOREFRONT DIAGNOSTICS` to a category phrase such as `EVIDENCE-FIRST ECOMMERCE CONVERSION AUDIT`;
- adjust the lede so the target situation is clear: stores receiving visits but uncertain where storefront friction may exist.

Do not promise lost-revenue recovery or causal conversion uplift.

### P0.2 Add a low-friction proof path beside the primary scan CTA

The free scan remains the primary CTA.

Add one secondary text-link CTA:
`View sample audit`

Target:
`/demo/`

It must be visually secondary to `Scan my store`.

Purpose:
- reduce trust friction;
- let users see the value format before submitting a URL;
- support the Activation hypothesis without requiring signup.

### P0.3 Strengthen Demo as proof, not marketing

The Demo page must use the truthful synthetic Golden Demo.

Show:
- exactly three sample findings;
- evidence/source format;
- first move;
- limitation/claim boundary;
- clear label that the store is synthetic.

Do not imply a real merchant, real revenue loss, or measured uplift.

Add a CTA back to the free scan.

### P0.4 Remove unfinished surfaces from primary navigation

`Blog` currently has no published notes.

Until meaningful content exists:
- remove Blog from primary navigation;
- keep the page unpublished or noindex;
- exclude it from sitemap if technically present.

`Pricing` currently describes a future paid expansion but no actual purchasable offer exists.

Until G5/G9 freezes the paid product/price:
- remove Pricing from primary navigation;
- keep the page accessible only if needed for internal/product review;
- mark it noindex;
- exclude it from sitemap.

Do not pretend an unfinished offer is launch-ready.

### P0.5 Remove remaining internal implementation language

Customer-facing copy must not contain:
- G1/G2/G3/G4/G5;
- V1 as an internal project milestone;
- “frozen rule” language unless rewritten for customers;
- implementation/test terminology.

Rewrite FAQ sentence such as `Not in V1` into plain public language.

### P0.6 Page-specific search metadata

Provide explicit, deterministic metadata for indexable public pages.

At minimum:

Home:
- Title: `Free Ecommerce Conversion Audit | Conversion Leak Audit`
- Description: truthful description of the free Top 3, public-page-only boundary, and no-admin/no-signup flow.

How it works:
- specific title + description.

Demo:
- specific title + description centered on an example ecommerce/storefront audit.

FAQ:
- specific title + description.

Do not keyword-stuff.

Do not claim support beyond actual functionality.

### P0.7 Dynamic scan result indexing control

URLs containing:
`?scan_id=...`

must not become search-index inventory.

Required:
- `noindex` on scan-result query URLs;
- canonical points to the clean Home URL;
- no scan-result query URL in sitemap;
- preserve refresh/result functionality.

Do not expose raw evidence through SEO metadata.

### P0.8 Canonical / robots / sitemap readiness

Verify locally:
- exactly one canonical per indexable page;
- normal public pages are indexable in a production-ready configuration;
- scan-result query URLs are noindex;
- WordPress sitemap endpoint works;
- sitemap includes only intended indexable pages;
- hidden Blog/Pricing are excluded while not launch-ready;
- robots behavior does not accidentally block core public pages.

Record evidence.

### P0.9 Heading and duplicate-content sanity

For each indexable page:
- one primary H1;
- descriptive heading hierarchy;
- no duplicate Home copy rendered through multiple templates;
- no accidental Sample Page / starter content;
- no query-param duplicate canonicalization problem.

### P0.10 Preserve measurement

Do not add a new analytics provider.

Use the existing event contract to preserve:
`landing_view → scan_started → top3_viewed → paid_expansion_viewed`.

The next real growth experiment will use these as behavioral evidence.

---

## P1 — Strongly recommended, bounded

### P1.1 Rewrite How it works in customer language

Current technical phrases such as:
- normalized facts;
- context gates;
- frozen set of high-confidence rules

are transparent but too implementation-oriented.

Rewrite to plain language while preserving truth:
1. verify the public URL is safe/reachable;
2. inspect a bounded set of storefront pages;
3. record observable facts;
4. apply relevant evidence checks;
5. show only supported findings;
6. say when evidence is incomplete.

Keep the “what a public scan cannot know” section.

### P1.2 Improve trust through methodology, not fake social proof

Do not invent:
- reviews;
- customer counts;
- revenue impact;
- logos;
- testimonials.

Allowed proof:
- transparent methodology;
- synthetic Demo;
- evidence location;
- public-page boundary;
- exact limitations;
- factual count of implemented checks if phrased accurately.

### P1.3 Do not build an SEO content factory yet

No bulk blog generation.

After first external-user Activation evidence exists, content can be selected from actual objections/findings.

Potential future seed topics:
- what a public ecommerce conversion audit can and cannot tell you;
- price visibility near purchase actions;
- shipping and returns discoverability;
- evidence-backed CRO vs generic AI critique.

These are future content experiments, not required output for this gate.

### P1.4 Platform landing pages are experiments, not a template farm

Search results show strong demand around Shopify/store audit terms.

A future `/shopify-store-audit/` page may be tested only if:
- the product truthfully supports Shopify public storefronts;
- the page contains unique useful platform-specific scope;
- it is not copied into many thin doorway pages.

Do not generate Shopify/WooCommerce/Wix pages in bulk.

---

## Deferred until public-domain / production gates

Do not block this local gate on:
- Search Console verification;
- real production sitemap submission;
- final HTTPS canonical domain;
- public robots.txt validation against production;
- production favicon/site-name appearance;
- final Organization schema requiring real organization/contact details;
- final Privacy/Terms legal review;
- live Core Web Vitals.

These belong to domain/production readiness gates.

However, record them as explicit future requirements.

---

## SEO implementation rule

Prefer a small project-owned SEO layer over installing a large WordPress plugin stack solely for this gate.

Acceptable:
- child-theme/project MU-plugin hooks for title/meta/robots/canonical/sitemap filtering;
- WordPress-native sitemap support.

Do not add an SEO plugin unless a concrete requirement cannot be met cleanly otherwise.

---

## Required tests

Automate or script evidence for:
- Home title + description;
- How it works title + description;
- Demo title + description;
- FAQ title + description;
- exactly one H1 each;
- canonical correctness;
- scan_id noindex + clean canonical;
- sitemap HTTP 200;
- sitemap inclusion/exclusion;
- primary nav excludes unfinished Blog/Pricing;
- Demo CTA returns to scan;
- no internal Gate/version strings in public copy;
- Scanner 55/55;
- WordPress 20/20;
- no payment actions;
- out-of-scope changes = 0.

## Repository

Use a clean project-scoped workspace from latest `origin/main`.

Dedicated branch:
`codex/g4-6-acquisition-seo-readiness`

Do not merge to main before Reviewer PASS.

## Candidate result

`PASS_CANDIDATE_G4_6_ACQUISITION_SEO_READINESS`

Then STOP_AT_REVIEWER.
