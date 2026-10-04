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
CORE_AHA_INTERACTION=UNRESOLVED_NOT_PART_OF_THIS_GATE
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
