# Reviewer Decision — G3CR6R3D2 RETURN / Visual Evidence Closure

> Date: 2026-10-04
> Reviewed candidate: `d2e31c532ace82c688554cad68e0464702268b24`

## Decision

~~~text
GATE=G3CR6R3D2_FOCUSLY_HOMEPAGE_IMPLEMENTATION
EXECUTOR_RESULT=PASS_CANDIDATE
REVIEWER_DECISION=RETURN_G3CR6R3D2_VISUAL_EVIDENCE_NOT_DIRECTLY_REVIEWABLE
IMPLEMENTATION_REPLAY_REQUIRED=NO
TECHNICAL_ACCEPTANCE=PASS
SOURCE_SCOPE=PASS
RUNTIME_REGRESSION=PASS
MOTION_BEHAVIOR=PASS
REDUCED_MOTION=PASS
NO_JS_FALLBACK=PASS
MOBILE_375_GEOMETRY=PASS
DESKTOP_1440_GEOMETRY=PASS
PREVIEW_FREEZE=PASS
WOO_ACCOUNT_PAYMENT_FREEZE=PASS
FONT_LICENSE_PROVENANCE=PASS
ROLLBACK_PACKAGE=PASS
IMAGEGEN_CALLS=0
VISUAL_FIDELITY_TO_FOCUSLY=UNVERIFIED_BY_CURRENT_REVIEWER
OWNER_VISUAL_FREEZE=PENDING
NEXT_GATE=G3CR6R3D2R1_VISUAL_REVIEW_BUNDLE
~~~

## Accepted technical evidence

Reviewer directly inspected the D2 implementation source, runtime/browser machine evidence, font provenance, source-correlation report and rollback proof.

Accepted:

- Home 858 remains eight editable Gutenberg Groups and all six required anchors occur exactly once.
- Desktop 1440 and mobile 375 both report document width equal to viewport width with no page errors, failed required resources or broken images.
- Motion is behaviorally proven: hero blur/opacity/translation settles to final state; sample cards show bounded perspective/scale changes at multiple scroll positions; keyboard focus outline is present.
- Reduced-motion, no-JS and controller-unavailable contexts retain complete visible content and flat/static fallbacks.
- Preview JS/CSS/shortcode internals remain correlated to the accepted pre-D2 implementation and the current Owner KEEP-AS-IS decision.
- Product 1113 remains virtual USD 39.99; Product/Cart/Account read-only routes pass and empty-cart Checkout redirects to Cart as previously accepted.
- No Add-to-Cart, checkout submission, order creation, payment, provider, model, P1-P12, core-Aha, production or shared-infrastructure action occurred.
- Mobile menu item 1098 was narrowly corrected from `/#sample-pages` to `/#samples`.
- The Privacy Policy page is still draft, so the Footer empty link was correctly left unchanged rather than inventing legal content or a destination.
- Instrument Serif was independently sourced from Google Fonts under SIL OFL 1.1, with exact provenance and hashes; no Focusly font/source package was copied.
- Rollback package covers Home 858, touched source and menu state; dry restore/integrity proof passes.
- Design-time image generation count is 0. This is not a quality failure by itself; visual quality must be judged from the visual evidence rather than from generation count.

The design-detector warning for gradient text corresponds to the bounded closing-section reveal effect. It is not by itself a rejection; visual review decides whether the treatment is appropriate.

## Why formal PASS is blocked

D2 explicitly requires current Reviewer inspection of the 1440/375 visual result and material fidelity to the accepted Focusly reference. The 53 PNG evidence files exist in GitHub and their hashes/geometry are proven, but the current Reviewer GitHub connector cannot directly decode repository binary PNGs.

Governance requires required evidence to be available, reviewable by the current Reviewer and actually inspected. Executor/internal craft review cannot substitute for that final Reviewer visual inspection.

Therefore the implementation is **not returned for redesign**. Only the visual evidence presentation must be made directly reviewable.

## No implementation replay

Do not:
- modify Home 858;
- modify CSS/JS/PHP/menu/footer;
- generate new images;
- restart/recreate runtime;
- recrawl Focusly;
- repeat browser functional regressions.

Reuse the existing accepted D1 Focusly screenshots and D2 round2 screenshots.

The next Gate is an evidence-format closure only.
