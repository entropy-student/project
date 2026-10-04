# Owner Decision — G3CR7 Three Frontend Surfaces

> Date: 2026-10-04
> Evidence provenance: OWNER_REPORTED
> Project: Birthday Magazine Studio

## Decision

Before P1-P12 magazine visual work continues, complete the three currently missing frontend surfaces:

1. **Homepage core-function entry unit**
   - highest visual bar of the three, but still bounded;
   - must coordinate with the already accepted/frozen homepage;
   - no global homepage redesign.

2. **Core function / full-intake page**
   - standard SaaS onboarding / multi-step form is preferred;
   - reuse mature existing patterns as much as practical;
   - changing colors/skin is acceptable;
   - prioritize speed and low implementation complexity over bespoke interaction design.

3. **Post-submit / payment / generation-success surface**
   - conventional SaaS status/success presentation is acceptable;
   - reuse WooCommerce checkout/order-confirmation capability wherever practical;
   - no need for a bespoke payment UI.

## Priority

- Complete these three surfaces before returning to the final P1-P12 visual system.
- P1-P12 is intentionally deferred.
- The previously researched motion-heavy Core Aha is no longer the immediate implementation priority.

## Canonical flow

```text
Homepage
-> Free Preview
-> Homepage / Preview CTA
-> Core function page
-> Full intake
-> Submit
-> WooCommerce payment
-> Generation/status
-> Complete magazine
```

This decision authorizes a bounded frontend implementation/review round. It does **not** authorize real-money testing, production generation, P1-P12 build, Shared Infra mutation, production deployment, or PR #64 merge.
