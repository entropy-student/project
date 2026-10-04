# Owner Decision — G3CR6R3D Focusly-Inspired Homepage Redesign

> Date: 2026-10-04

## Decision

~~~text
FOCUSLY_HOMEPAGE_DIRECTION=AUTHORIZED_AS_PUBLIC_VISUAL_REFERENCE
FOCUSLY_TEMPLATE_PURCHASE=NOT_REQUIRED
PROPRIETARY_SOURCE_OR_ASSET_COPYING=NOT_AUTHORIZED
INDEPENDENT_HIGH_FIDELITY_REIMPLEMENTATION=AUTHORIZED
CURRENT_HOMEPAGE_FUNCTIONAL_ARCHITECTURE=FROZEN
EXISTING_PROJECT_IMAGES=ALLOWED
DESIGN_TIME_IMAGE_GENERATION=ALLOWED_WITHIN_EXISTING_ENTITLEMENT_NO_EXTERNAL_SECRET_OR_PAID_PROVIDER
CORE_AHA_INTERACTION_DIRECTION=PERSISTENT_LIVE_MAGAZINE_COVER_PREVIEW_ACCEPTED
CORE_AHA_EXACT_PRESENTATION=PENDING_D1_BENCHMARK_MAPPING
CORE_AHA_BROWSER_LOCAL_PHOTO_REPLACEMENT=REQUIRED
MAGAZINE_P1_P12_VISUAL_SYSTEM=UNRESOLVED_NOT_PART_OF_THIS_GATE
MAGAZINE_WEB_VIEWER_DIRECTION=CONFIRMED_PRESERVED
IMPLEMENTATION_REQUIRES_REVIEWER_MAPPING_PASS_FIRST=YES
~~~

## Intent

The Owner wants the existing Birthday Magazine homepage visually redesigned to closely resemble the publicly observable visual language and motion behavior of the Focusly Webflow template, while replacing all content with Birthday Magazine Studio content and preserving the existing product/commerce functionality.

Reference:
- https://webflow.com/templates/html/focusly-website-template

The task is an independent implementation from public visual/behavioral reference. Do not obtain, copy, extract, vendor, or redistribute proprietary paid-template source, assets, fonts, or protected brand content.

Existing project-owned images may be reused. New static design assets may be generated only through already-authorized/available generation capability that does not require a new external paid account/API key/Secret. Runtime/free-preview model calls remain forbidden.

## Frozen functional boundary

Do not change the semantics or business logic of:
- browser-local Free Preview and its privacy contract;
- WooCommerce Product/Cart/Checkout/Order flow;
- PayPal/payment provider integration;
- account/authentication/private workspace;
- order ownership/entitlement/generation-job semantics;
- database schema;
- production provider/runtime;
- checkout prices/currency/product identity.

Homepage navigation/CTA presentation may be visually restyled, but existing canonical destinations and behaviors must remain equivalent.

## Sequencing

1. G3CR6R3D1: read-only Focusly visual/interaction capture + current-homepage mapping.
2. Mandatory Reviewer stop.
3. Only after Reviewer PASS: G3CR6R3D2 bounded homepage implementation.
4. Core Aha interaction and P1-P12 magazine visual research resume separately afterward.


## Preview interaction direction — Owner update 2026-10-04

The Owner accepts the following product-interaction direction for the homepage Preview:

- the finished birthday-magazine cover/product remains visibly present before upload;
- the shopper replaces the sample portrait with their own local photo rather than entering an empty uploader-first state;
- after selection, the photo appears immediately inside the magazine-cover composition;
- crop/position/zoom may be available when feasible;
- the preview must remain browser-local and must not introduce runtime model calls or server/external photo upload;
- overall visual styling remains governed by the Focusly-inspired homepage direction.

Benchmark references to inspect in G3CR6R3D1:

1. YourCover — exact personalized magazine-cover product flow:
   https://www.yourcover.com/create/happy-birthday
2. DigitalPrank Magazine Cover Generator — direct browser-based cover editor/live preview:
   https://digitalprank.com/tools/custom-magazine-cover/
3. Customily Product Page Preview — generic proven live-personalization interaction:
   https://customily-2-0.myshopify.com/products/preview-style-demo-product-page-preview
4. Corjl / Funtastic Idea public birthday-magazine demo — exact cover-editing reference:
   https://www.corjl.com/d/17L5NO/s

These are behavior/product references only. Do not copy proprietary code/assets.

The Owner prefers combining this Preview interaction implementation with the Focusly homepage implementation in the same subsequent bounded implementation Gate if D1 proves that the shared rollback/evidence boundary is safe.
