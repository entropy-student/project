# Owner Decision — G3CR7V2R2 Brand Palette + No Mesh

> Date: 2026-10-05
> Evidence provenance: OWNER_REPORTED
> Project: Birthday Magazine Studio

## Decision

```text
STRIPE_COMPONENT_SYSTEM=KEEP
STRIPE_BRAND_PURPLE=REPLACE
BIRTHDAY_MAGAZINE_PRIMARY=#713F5D
BIRTHDAY_MAGAZINE_PRIMARY_DEEP=#5B314B
BIRTHDAY_MAGAZINE_PRIMARY_PRESS=#472439
BIRTHDAY_MAGAZINE_PRIMARY_SUBDUED=#F4EBF0
APPLICATION_BACKGROUND=#F7F8FB
APPLICATION_CANVAS=#FFFFFF
APPLICATION_INK=#182230
APPLICATION_MUTED=#667085
APPLICATION_HAIRLINE=#E5E7EB
DECORATIVE_MESH=REMOVE
MESH_REPLACEMENT_ARTWORK=NONE
SVG_DECORATIVE_ASSET=REMOVE
LAYOUT_REDESIGN=NO
CONTENT_REWRITE=NO
BUSINESS_LOGIC_CHANGE=NO
```

## Owner intent

Keep the successful SaaS structure from the Stripe DESIGN.md implementation, but stop visually imitating Stripe's own brand identity.

The product should become:

> Stripe-like product-system discipline + Birthday Magazine Studio brand palette.

The application shell should be quiet enough that the magazine artifact itself is the main visual focus.

## Required visual change

1. Delete `assets/g3cr7v2r1-soft-mesh.svg`.
2. Remove its CSS background/pseudo-element usage rather than hiding it.
3. Do not replace it with another illustration, SVG, gradient blob or generated asset.
4. Replace the current Stripe indigo primary system with the Birthday Magazine mulberry palette.
5. Keep current layout, cards, form geometry, stepper, status structure, spacing system, shadows and responsive composition.
6. Keep ivory/serif styling only inside the magazine artifact itself.

## Scope

This is a bounded brand-polish decision, not a new visual redesign.

The current Stripe-based layout remains Reviewer-approved as the structural baseline.
