# Reviewer Decision — G4.5 Owner Visual Review Return

Date: 2026-09-22

Role: Reviewer / Architect / Gatekeeper

## Decision

`RETURN_G4_5_VISUAL_OWNER_EDITABILITY_REWORK_REQUIRED`

The 23-image Owner visual-review package has been reviewed.

The current G4 product is functionally valid, but the visual/product-editing experience is not yet acceptable for G4.5 final PASS.

## High-level finding

The problem is not uniformly "too crowded."

Observed pattern:
- Desktop Home hero: relatively spacious.
- Mobile Home: too much content before the primary scan action.
- Top 3/result surfaces: text-heavy and vertically dense.
- Evidence detail: useful but too verbose as an always-inline expansion on mobile.
- Progress state: oversized/duplicated copy and mixed-language presentation.
- Secondary WordPress pages: visually under-designed and inconsistent with the G4 Home.
- Default SaasLauncher footer/navigation content introduces unrelated startup/agency/AI-product copy and weakens product trust.
- WordPress Owner editability is partial: Home editor content does not represent the actual front-end Home.

## Required corrections

### V1 — Move the primary scan action earlier

The mobile first viewport currently spends substantial space on:
- hero headline;
- hero explanation;
- three trust facts;
- decorative Free Top 3 preview.

The actual scan form appears later.

Required:
- preserve the core headline;
- reduce pre-form visual weight;
- move/raise the scan form so the primary action appears materially earlier on mobile;
- decorative report preview must not outrank the scan action.

### V2 — Reduce result-card information density

Current Top 3 cards expose, by default:
- title;
- observed fact;
- why it may matter;
- first move;
- evidence control.

On mobile this creates long repetitive reading blocks.

Required default card hierarchy:
- priority + rule id;
- finding title;
- concise observed fact;
- first move;
- evidence/details affordance.

Move lower-priority explanatory detail such as extended "why it may matter" into an expandable detail layer when practical.

Do not remove evidence or claim-boundary information.

### V3 — Improve Evidence-detail density

Evidence remains first-class, but the mobile expanded block is visually long.

Required:
- preserve source, references, Scanner decision and limitation;
- improve grouping/spacing;
- avoid repeating already-visible card copy;
- ensure mobile evidence reads as a secondary detail layer rather than another full article.

### V4 — Simplify Progress

Current progress state contains:
- large headline;
- near-duplicate supporting sentence;
- four stage labels;
- scan reference.

The screenshot also mixes Chinese state copy with an otherwise English public UI.

Required:
- use one consistent public UI language for this version;
- remove duplicate explanatory copy;
- keep the four truthful backend-driven stages;
- reduce headline scale, especially mobile;
- preserve honest progress and scan reference.

### V5 — Replace generic SaasLauncher footer content

The current footer contains unrelated template content such as:
- startup/agency marketing copy;
- AI Automation;
- Smart Notification;
- Real-time Analytics;
- Integrations;
- generic Company/Products/Features columns.

This is not Conversion Leak Audit product truth.

Required:
- remove generic template marketing/navigation items;
- replace with a minimal project-specific footer;
- keep only real routes/policies/product links that currently exist;
- no fake company, feature, social, customer or product claims.

### V6 — Normalize navigation

Current nav order and structure are visually inconsistent with product priority.

Required:
- make Home / How it works / Demo / Pricing / FAQ / Blog logically ordered;
- keep one clear primary action;
- mobile menu must remain simple.

### V7 — Bring secondary pages into the same design system

How it works / Demo / Pricing / FAQ / Blog currently read like mostly raw baseline content.

Required:
- apply the same width, type scale, spacing, section rhythm and navy/blue direction;
- do not overdesign;
- no new product features;
- preserve factual content unless Reviewer/Owner explicitly approves copy changes.

### V8 — Fix practical Owner editability

Current:
`WORDPRESS_OWNER_EDITABILITY=PARTIAL`

The stored Home Gutenberg content and Site Editor preview do not match the real front-end Home because the integration replaces `the_content`.

This is not acceptable for the Owner workflow requested in G4.5.

Required architecture:
- remove the full Home-page content replacement behavior;
- WordPress/Gutenberg owns static Home content/layout;
- dynamic Scanner remains project-owned code;
- expose the Scanner as shortcode/block placement within editable WordPress content;
- retain REST wiring, polling, rule/result rendering and safety logic in integration code;
- Owner must be able to edit static Home copy/sections/order in WordPress and see those changes on the front end.

Practical target:
`WORDPRESS_OWNER_EDITABILITY=FULL_FOR_STATIC_CONTENT_AND_LAYOUT`

Dynamic diagnostic logic may remain code-owned.

### V9 — Pretty-route issue

The capture manifest reports that pretty routes for secondary pages currently resolve to the front page in this local runtime, while `?page_id=` links show the stored pages.

This must be corrected before G4.5 PASS so normal navigation routes resolve to their intended pages.

## What remains accepted

Do not redo:
- G4 functionality;
- Scanner safety;
- 55/55 regression;
- WordPress 20/20 baseline;
- Top 3 rule semantics;
- real Scanner canary;
- analytics contract;
- Golden Demo evidence truth;
- payment/VPS boundaries.

## Visual direction

Keep:
- white canvas;
- deep navy;
- restrained blue;
- evidence-first editorial diagnostic direction.

Do not solve density by shrinking body text.

Use:
- less simultaneous information;
- stronger progressive disclosure;
- wider rhythm/spacing;
- clearer primary action ordering.

## Next candidate

After bounded rework:
- Owner opens real WordPress front end;
- Owner edits Home static content in Gutenberg and confirms visible front-end change;
- screenshot package is regenerated;
- functional regressions remain green;
- Reviewer performs another visual review.

Candidate:
`PASS_CANDIDATE_G4_5_OWNER_EDITABLE_VISUAL_REWORK`

Final G4.5 PASS remains forbidden until Owner visual confirmation.
