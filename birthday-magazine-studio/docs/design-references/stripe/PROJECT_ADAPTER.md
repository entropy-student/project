# Birthday Magazine Studio — Stripe DESIGN.md Adapter

## Authority order

For G3CR7V2 visual implementation, use this order:

1. Owner explicit decisions.
2. This project adapter.
3. `docs/design-references/stripe/DESIGN.md`.
4. Existing application behavior/markup constraints.
5. Executor discretion only where the above are silent.

The vendored DESIGN.md is the primary visual-system reference. This adapter only removes rules that would incorrectly copy Stripe branding/marketing behavior into Birthday Magazine Studio.

## Canonical tokens to use

The project keeps Stripe's **component geometry, spacing, hierarchy and elevation**, but the Owner has explicitly replaced Stripe's brand palette with Birthday Magazine Studio's own palette.

### Birthday Magazine brand palette — authoritative override

```text
primary            #713F5D
primary-deep       #5B314B
primary-press      #472439
primary-soft       #8E5B78
primary-bg-subdued #F4EBF0

ink                #182230
ink-secondary      #344054
ink-mute           #667085

canvas             #FFFFFF
canvas-soft        #F7F8FB
hairline           #E5E7EB
hairline-input     #CBD5E1
```

Use Stripe DESIGN.md values for structural guidance when this adapter is silent, but do **not** reintroduce Stripe's `#533afd` as the primary product color.

The intent is:
- Stripe-like SaaS structure;
- Birthday Magazine brand identity;
- cool neutral shell;
- the magazine artifact remains the visual/emotional focal point.

## Typography

- Do **not** use proprietary Sohne font files.
- Preferred substitute: Inter at light/regular weights if already safely available to the project.
- Otherwise use `system-ui, -apple-system, "Segoe UI", sans-serif`.
- Application UI is sans-serif.
- Display/application headings should usually remain 20–32px; the upstream 48–56px marketing tiers are not default form-step sizes.
- Use weight 300/400 and restrained negative tracking where supported.
- Use tabular numerics for prices, counts and order IDs.
- Serif is reserved for the actual magazine artifact only.

## Shapes and controls

Follow upstream closely:

- form inputs: 6px radius;
- compact cards: 8px;
- main cards/panels: 12px;
- hero/product mockup chrome: up to 16px;
- primary/secondary action buttons: pill geometry;
- inputs use `hairline-input`; focus swaps to `primary`;
- primary CTA uses `primary`, pressed state `primary-press`.

Do not convert every component into oversized 20–28px soft cards.

## Spacing

Use the upstream 8px-based scale:

```text
2 / 4 / 8 / 12 / 16 / 24 / 32 / 64
```

For application surfaces:
- typical card padding: 24–32px;
- form-row gaps: 12–16px;
- section gaps: 24–32px;
- reserve 64px+ gaps for true section boundaries, not ordinary form steps.

## Elevation

Use upstream Level 1 / Level 2 logic:

- cards: subtle 1–3px lift;
- major preview/product panels: restrained 8–24px soft blue-gray shadow;
- avoid thick gray drop shadows or paper-like floating-sheet shadows in the SaaS shell.

## Decorative background / mesh

The Owner has explicitly rejected the decorative mesh for the current MVP frontend.

Project adaptation:
- **no SVG mesh asset**;
- **no replacement decorative illustration**;
- **no gradient blob background**;
- leave the surrounding SaaS canvas intentionally quiet and mostly empty;
- homepage Preview/core-entry uses `canvas-soft` / `canvas` plus the product cards themselves for hierarchy;
- the magazine artifact is the primary visual focus.

If a later Owner decision reintroduces atmospheric decoration, it requires a new bounded visual decision.

## Homepage Preview/core-entry

Use the upstream “product UI mockup floating above a soft marketing field” principle:

- one cool `canvas-soft` product-demo shell;
- no decorative mesh/background artwork;
- one white control panel;
- one white product-preview panel;
- Birthday Magazine mulberry pill CTA using `primary` `#713F5D`;
- magazine object may retain ivory/serif styling;
- surrounding UI must remain cool white/blue-gray.

## Intake

Treat intake as dashboard/product UI, not marketing editorial:

- `canvas-soft` page;
- white work panel;
- thin hairlines;
- compact stepper;
- mulberry `primary` progress/focus/CTA;
- 6px form-field radius;
- 12px cards;
- no cream background;
- no serif headings;
- no giant display typography.

## Status / Woo continuation

Use dashboard/product-state language:

- white status card over `canvas-soft`;
- compact soft-mulberry/info pill;
- order/count values use tabular numerics;
- progress rows separated with hairlines;
- one mulberry `primary` active/current state;
- pending/success colors remain semantic and subdued;
- Woo payment truth remains unchanged.

## Photography / fixtures

- No cartoon/SVG human placeholders.
- Use approved project-local photography where available.
- If an image is only QA filler, neutral non-human local imagery is preferred over synthetic faces.
- Do not hotlink external image assets.

## Do not copy

Do not use:
- Stripe logo/wordmark;
- Stripe proprietary source code;
- proprietary Stripe imagery;
- proprietary font files;
- external Stripe dashboard screenshots as product assets.

This project is inspired by the documented visual system, not pretending to be Stripe.
