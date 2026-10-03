# Owner Decision — G3CR6 Warm Gift Frontend Redesign

> Date: 2026-10-01  
> Status: **CURRENT OWNER DECISION**  
> Parent: G3C Blocksy Wedding UI/UX Productization  
> PR: #64  
> G4 authority: NONE

## Decision

The Owner did **not** accept the G3CR5 visual state as the final visual freeze.

The Owner explicitly selected the **Option 2 — Warm Birthday Gift** direction as the new visual north star and authorized a further frontend experience / brand redesign.

The Owner also explicitly authorized the Execution Agent to use image generation for high-fidelity frontend visual assets.

## Visual direction

Target character:

- warm birthday-gift feeling;
- premium editorial magazine character;
- photo-led and human;
- cream / warm-white base;
- coral primary CTA;
- elegant serif display typography with restrained sans-serif UI typography;
- the personalized magazine remains the product hero;
- flowers, gift boxes, cards and paper elements are supporting atmosphere only;
- consumer gift brand, not SaaS, not default WordPress/WooCommerce, not a heavy scrapbook site.

The selected reference image is a **visual north star**, not a pixel-perfect structural contract.

## Scope boundary clarified by Owner

The Owner clarified that the project should not use a simplistic “UI may change / functions may not change” boundary.

### Frontend experience may change

User-visible experience may be redesigned when it improves usability or product quality, including:

- Hero;
- sample-magazine presentation;
- Free Preview upload UI;
- selected-photo state;
- replace / reselect controls;
- Preview layout and client-side presentation;
- What You Get / How It Works / Offer / FAQ presentation;
- WooCommerce Product / Cart / Checkout / My Account visual experience;
- mobile composition.

The current upload UI is explicitly **not frozen** merely because it is already functional.

### Frontend behavior may change with regression

User-visible behavior may change if necessary, but changed interactions must be re-tested.

The Free Preview may use a new frontend implementation only if it still preserves the accepted behavioral/privacy contract.

### Backend business/data layer remains protected

Without a new Reviewer authorization, do not replace or redesign:

- WooCommerce canonical cart / checkout / order logic;
- payment gateway logic;
- server-side checkout semantics;
- order state machine;
- account / authorization model;
- private-workspace ownership checks;
- entitlement / generation-job semantics;
- database schema;
- production AI/provider logic.

## Non-regression contracts

Free Preview must remain:

- browser-local for selected photos;
- zero server photo upload;
- zero third-party photo upload;
- zero model-provider request.

WooCommerce remains the canonical commerce/order system and native Product → Cart → Checkout → My Account path.

No payment mutation, real-money action, production deployment, shared-infrastructure change, G4 action, or PR merge is authorized by this decision.

## Current execution contract

See:

- `G3CR6_FRONTEND_EXPERIENCE_BRAND_REDESIGN.md`

Owner visual freeze remains **PENDING** until the redesigned frontend returns to Reviewer and then to Owner for final acceptance.
