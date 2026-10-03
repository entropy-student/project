# Owner Decision — G3CR6R3B Visual + Motion Lab

> Date: 2026-10-04  
> Status: **CURRENT OWNER DECISION**  
> Parent: G3CR6R3A Magazine Visual Redesign  
> PR: #64  
> G4 authority: NONE

## Decision

Before expanding into the complete 12-page magazine redesign, the Owner wants the visual direction validated in a smaller, higher-signal design lab.

The product should be treated as one unified **1 + 1 + 12** visual system:

- **1 marketing homepage**
- **1 high-impact core interaction**
- **12 static magazine pages**

These are not fourteen unrelated pages. They must share one web-native editorial design system.

## Core product/visual principle

The website and the delivered magazine should come from the same visual source of truth.

Preferred architecture:

```text
shared design tokens
+ reusable editorial components
+ deterministic HTML/CSS magazine renderer
→ website product proof
→ Preview states
→ final 12 static pages
→ PDF
```

The website may use motion.  
The magazine deliverable remains a **static PDF**.

## Homepage role

The homepage must feel like a premium interactive gift experience rather than a static WordPress/ecommerce page.

Motion should be:
- visible enough to make the page feel alive;
- editorial and premium;
- purposeful rather than decorative noise;
- mobile/touch aware;
- reduced-motion aware.

Preferred motion vocabulary:
- Reveal
- Depth
- Morph
- Stack

## Core interaction role

The current upload-photo → instant cover interaction is not accepted.

The target Aha is:

> “My photo is becoming a real magazine about this person.”

Preferred interaction model for the lab:

```text
upload/select one local photo
→ photo enters a designed magazine composition
→ reveal 3 deterministic cover directions
→ user chooses one
→ selected cover becomes the lead magazine object
→ 2–3 static interior pages/spreads are revealed
→ CTA to create the complete 12-page issue
```

The chosen cover may become a lightweight personalization preference for the paid product.

Free Preview remains:
- browser-local;
- zero server photo upload;
- zero model call;
- deterministic.

## Magazine role

The final product remains a static 12-page magazine, but each page should be designed as a web-native editorial canvas that can also render to PDF.

The 12-page product should be assembled from reusable page archetypes rather than twelve unrelated one-off designs.

## Lab-first decision

Do **not** immediately build all 12 pages again.

First validate:
- three core-interaction directions;
- three cover directions;
- four representative magazine page directions:
  - Cover;
  - Feature Story / Spread;
  - Photo Story;
  - Birthday Letter.

Only the selected direction expands into the full 12-page system.

## Current style-preset contract

The existing three-preset MVP contract remains unchanged for now.

The lab should focus primarily on one strongest master art direction, with enough tokenization to show that other presets can later derive from the same architecture.

No Owner decision has yet removed the three-preset requirement.

## State

```text
G3CR6R3A_FULL_MAGAZINE_REDESIGN=SUPERSEDED_BEFORE_EXECUTION
G3CR6R3B_VISUAL_MOTION_LAB=CURRENT
G3CR6R3_WEBSITE_INTEGRATION=HOLD_PENDING_LAB_SELECTION
OWNER_MAGAZINE_VISUAL_FREEZE=PENDING
OWNER_SITE_VISUAL_FREEZE=PENDING
G4=HOLD_NOT_AUTHORIZED
```
