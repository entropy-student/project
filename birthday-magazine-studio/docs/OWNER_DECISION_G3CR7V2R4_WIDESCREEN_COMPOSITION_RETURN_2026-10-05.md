# Owner Decision — G3CR7V2R4 Widescreen Composition RETURN

> Date: 2026-10-05
> Evidence provenance: OWNER_REPORTED + direct inspection of Owner screenshots
> Prior candidate: `43ebf7bb732e9e3be8d547364ca7b018f7f505f8`
> Owner screenshots: 2048px-wide live Edge viewport captures

## Decision

```text
G3CR7V2R3_REVIEWER_PASS=TECHNICAL_EVIDENCE_RETAINED
G3CR7V2R3_OWNER_VISUAL=RETURN
PRIMARY_DESKTOP_REVIEW_WIDTH=2048
HOMEPAGE_PLACEHOLDER_ART=REMOVE
HOMEPAGE_PLACEHOLDER_REPLACEMENT=EMPTY_NEUTRAL_FRAME
HOMEPAGE_FEATURE_BACKGROUND=LIGHT_MULBERRY_TINT
HOMEPAGE_CTA=SIMPLIFY
HOMEPAGE_PRICE_META=SEPARATE_FROM_BUTTON
HOMEPAGE_COMPOSITION=SCALE_UP_AND_REBALANCE
INTAKE_COMPOSITION=SCALE_UP_FOR_WIDESCREEN
INTAKE_EMPTY_SPACE=REDUCE
STATUS_STANDALONE=QA_ONLY_NOT_PRODUCT_SURFACE
BUSINESS_LOGIC=FROZEN
MULBERRY_BRAND=KEEP
STRIPE_DERIVED_COMPONENT_LANGUAGE=KEEP
```

## Why the previous passes looked acceptable in evidence but not live

Previous desktop evidence was primarily captured at 1440px.

The Owner's actual live review screenshots are 2048px wide. At that width:
- the homepage Preview demo occupies too little visual mass;
- typography reads undersized;
- the action bar feels detached from the demo;
- intake max-width caps too early, leaving excessive side whitespace;
- the UI feels timid/small despite technically larger 1440px measurements.

From this Gate forward, **2048px is the primary Owner desktop visual viewport**. 1440px remains a compatibility viewport, not the quality ceiling.

## Homepage decisions

### Placeholder art

The current no-photo artwork is not an SVG. It is CSS-generated placeholder art:

- `.bms-cover-art`: radial gradients approximating a human silhouette;
- `.bms-spread-art`: diagonal linear gradient block.

Owner rejects both.

Required:
- remove these generated visual shapes;
- no SVG;
- no gradient illustration;
- no cartoon/person silhouette;
- no replacement generated art;
- when no photo exists, show a quiet empty neutral photo frame only.

### Feature background

The Preview/core-entry should be intentionally emphasized, not merely placed on the generic page background.

Use a very light Birthday Magazine mulberry-tinted feature field, approximately:

```text
feature-bg: #F3EEF1
```

Exact accessible near-equivalent may be adjusted by Reviewer/Executor if required, but it should:
- clearly distinguish this product-demo section from the surrounding page;
- remain much lighter than the primary `#713F5D`;
- not read as beige/paper;
- let the white controls/demo surfaces remain the focus.

### CTA

Current CTA overloads one small button with:
- action;
- page count;
- price.

Owner rejects this hierarchy.

Required:
- primary button contains only the action, e.g. **Create the full magazine →**;
- `12 pages · US$39.99` becomes adjacent/supporting metadata outside the button;
- browser-local/privacy note remains separate;
- CTA bar must visually belong to the Preview demo rather than appear as a small detached box at the lower right.

## Intake decisions

Keep the existing design system, but redesign the **scale/composition** for widescreen.

At 2048px the application must feel deliberately large:
- substantially wider useful canvas;
- larger headings and UI text;
- less dead space above/beside the form;
- larger controls;
- stronger card/stepper presence;
- no tiny centered-document feeling.

This is not a new style direction.
