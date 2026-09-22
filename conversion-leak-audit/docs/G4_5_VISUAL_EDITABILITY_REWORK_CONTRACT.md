# G4.5 — Visual Density + Owner Editability Rework Contract

Date: 2026-09-22
Status: READY_FOR_EXECUTOR
Precondition: RETURN_G4_5_VISUAL_OWNER_EDITABILITY_REWORK_REQUIRED

## Goal

Perform the smallest bounded corrections required by the Owner/Reviewer visual review.

This is not a redesign and not a new feature Gate.

## Accepted foundations

Do not reopen:
- G1;
- G2;
- G3;
- G4 functionality;
- Scanner 55/55;
- WordPress baseline 20/20;
- real Scanner canary;
- analytics contract;
- frozen 17 rules;
- Golden Demo truth;
- payment/VPS holds.

## Required corrections

### A. Home hierarchy / mobile density
- move the scan action materially earlier;
- keep the core hero headline;
- reduce the visual priority of the decorative report preview;
- preserve trust microcopy;
- do not shrink body text below frozen accessibility thresholds.

### B. Top 3 progressive disclosure
Default card should prioritize:
- priority / rule id;
- finding title;
- concise observed fact;
- first move;
- evidence/detail affordance.

Move lower-priority explanatory detail such as extended "why it may matter" into expandable detail where practical.

Evidence remains first-class.

### C. Evidence density
Preserve:
- source;
- evidence refs;
- Scanner decision;
- limitation.

Improve grouping and reduce duplicated prose.

### D. Progress simplification
- one public UI language;
- keep four real backend-driven stages;
- remove duplicate progress explanatory copy;
- reduce oversized progress heading, especially mobile;
- preserve scan reference;
- no fake percentage or timer-driven stages.

### E. Navigation + footer cleanup
Navigation should use logical order:
Home → How it works → Demo → Pricing → FAQ → Blog

Keep one clear primary action.

Remove generic SaasLauncher/template footer content that is not product truth.

Replace with minimal real project footer using only existing real routes/content.

### F. Secondary page design normalization
How it works / Demo / Pricing / FAQ / Blog:
- same width system;
- same typography hierarchy;
- same spacing rhythm;
- same navy/blue direction;
- restrained styling;
- no invented claims/features.

### G. Owner editability architecture
Current problem:
Home Gutenberg content is overridden by the G4 `the_content` filter.

Required architecture:
- WordPress/Gutenberg owns static Home content and section order;
- dynamic Scanner stays in project-owned integration code;
- Scanner is inserted into editable WordPress content through shortcode/block placement;
- do not move scanner logic into editable raw HTML;
- REST wiring, polling, Top 3, evidence, analytics and safety remain code-owned;
- static Home text/layout edits made in WordPress must visibly affect the front end.

Target:
`WORDPRESS_OWNER_EDITABILITY=FULL_FOR_STATIC_CONTENT_AND_LAYOUT`

Dynamic diagnostic internals may remain code-owned.

### H. Pretty routes
Normal routes must resolve to the intended pages:
- /how-it-works/
- /demo/
- /pricing/
- /faq/
- /blog/

Do not rely on `?page_id=` for normal navigation.

## Functional safety

After changes, rerun:
- Scanner regression 55/55;
- WordPress baseline 20/20;
- G4 browser integration;
- real Scanner canary;
- analytics contract;
- Golden Demo;
- refresh result;
- mobile form submit;
- no payment call.

## Owner-editability proof

Must prove with a local-only reversible test:
1. change one harmless Home static text fragment in Gutenberg;
2. verify front end changes accordingly;
3. revert the fragment;
4. verify front end returns to canonical content.

Do not use scanner dynamic output for this test.

Record:
`OWNER_EDITABILITY_PROOF=PASS`

## Visual evidence

Regenerate visual-review screenshots after rework.

At minimum:
- Home desktop viewport/full;
- Home mobile viewport/full;
- Progress desktop/mobile;
- Top 3 desktop/mobile;
- Evidence desktop/mobile;
- Incomplete desktop/mobile;
- Pricing or representative secondary page;
- Home editor;
- Site Editor.

Package them for Owner/Reviewer review.

## Repository

Use clean project-scoped workspace from latest `origin/main`.

Dedicated branch:
`codex/g4-5-visual-editability-rework`

All changes must remain under:
`conversion-leak-audit/**`

Do not merge to main before Reviewer PASS.

## Forbidden

No:
- new product features;
- new Scanner rules;
- rule-semantic changes;
- G5 Full Fix Queue;
- LLM report;
- Payment / PayPal / Unified Pay;
- VPS / domain / HTTPS;
- production Secret;
- public production Scanner;
- broad clone-ui rewrite.

## Candidate return

`PASS_CANDIDATE_G4_5_OWNER_EDITABLE_VISUAL_REWORK`

Then STOP_AT_REVIEWER.
