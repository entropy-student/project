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

Prefer the upstream Stripe-inspired tokens directly:

```text
primary            #533afd
primary-deep       #4434d4
primary-press      #2e2b8c
primary-soft       #665efd
brand-dark-900     #1c1e54

ink                #0d253d
ink-secondary      #273951
ink-mute           #64748d

canvas             #ffffff
canvas-soft        #f6f9fc
hairline           #e3e8ee
hairline-input     #a8c3de
```

Ruby / magenta may appear only as tiny atmospheric gradient-mesh accents. They are not CTA colors.

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

## Gradient mesh

The upstream design treats a gradient mesh as a marketing signature.

Project adaptation:
- allowed and encouraged in the **homepage Preview/core-entry intro/hero band**;
- keep it atmospheric and behind white product UI panels;
- do not cover the entire application with gradients;
- intake and Woo/status pages should remain predominantly `canvas` / `canvas-soft`;
- do not use Stripe logos or proprietary mesh assets;
- implement an original local mesh treatment, not copied Stripe artwork.

## Homepage Preview/core-entry

Use the upstream “product UI mockup floating above a soft marketing field” principle:

- one cool `canvas-soft` product-demo shell;
- optional original Stripe-like mesh in the upper/outer background;
- one white control panel;
- one white product-preview panel;
- indigo pill CTA;
- magazine object may retain ivory/serif styling;
- surrounding UI must remain cool white/blue-gray.

## Intake

Treat intake as dashboard/product UI, not marketing editorial:

- `canvas-soft` page;
- white work panel;
- thin hairlines;
- compact stepper;
- indigo progress/focus/CTA;
- 6px form-field radius;
- 12px cards;
- no cream background;
- no serif headings;
- no giant display typography.

## Status / Woo continuation

Use dashboard/product-state language:

- white status card over `canvas-soft`;
- compact soft-indigio/info pill;
- order/count values use tabular numerics;
- progress rows separated with hairlines;
- one indigo active/current state;
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
