# G3CR7 — Three Frontend Surfaces

## Gate

```text
GATE_ID=G3CR7_THREE_FRONTEND_SURFACES
OBJECTIVE=Close the three near-term frontend shells before P1-P12: homepage entry, pre-payment full-intake onboarding, and post-payment generation/status presentation
MAX_ENDPOINT_THIS_ROUND=Reviewable PR-branch frontend candidate + source/evidence; no production deployment or backend draft/generation implementation
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=birthday-magazine-studio/poc/g3c/preview-plugin presentation layer + project-scoped docs/evidence
APPLICABLE_CRITICAL_CONSTRAINTS=REAL_MONEY_ACTIONS_0; PAYPAL_ACTIONS_0; CHECKOUT_SUBMISSIONS_0; PRODUCTION_DEPLOYMENT_0; SHARED_INFRA_MUTATIONS_0; PR64_MERGE_0; P1_P12_BUILD_0
ROLLBACK_STATUS_OR_PLAN=Git/source rollback to pre-G3CR7 PR #64 head; existing homepage remains frozen outside bounded offer/entry unit
OWNER_ONLY_ACTIONS=NONE
```

Governance: **vps-project-governance v0.2.7**.

## Accepted product flow

```text
Homepage
-> Free Preview (basic info + optional one browser-local photo)
-> Homepage / Preview CTA
-> Core function page
-> 12–25 photos + structured answers
-> Submit
-> WooCommerce checkout
-> automatic generation
-> complete private result
```

## Design strategy

### A. Homepage entry

- Keep the accepted homepage composition frozen.
- Only the existing core-function/offer entry unit may receive a bounded visual skin and route update.
- Use the existing Good Issue / homepage palette and editorial object language.
- This surface has the highest visual bar of the three.

### B. Core function page

Use a familiar **full-page SaaS onboarding / multi-step form**.

Reference pattern:
- Flowbase — Webflow Onboarding Form (Full Page): https://webflow.com/made-in-webflow/website/webflow-onboarding-form-clone
- BRIX — Multi-step Form Webflow Cloneable Template: https://webflow.com/made-in-webflow/website/multi-step-form-webflow-cloneable-template-brix-templates

Do not copy Webflow-specific code into WordPress. Reimplement the layout pattern with the existing project frontend to avoid a new framework/platform dependency.

Target steps:
1. About them
2. Photos
3. Their story
4. The little things
5. Review -> checkout

The frontend shell should support:
- responsive step navigation;
- required-field validation;
- 12–25 local photo selection;
- up to 3 must-use selections;
- six required prompts;
- review summary;
- WooCommerce checkout handoff.

### C. Payment / status / success

- WooCommerce remains canonical commerce.
- Do not rebuild checkout.
- Use WooCommerce core checkout handoff.
- Skin the post-payment/order-confirmation continuation with a simple generation-status card.
- Show: intake received -> payment confirmed -> designing -> final QA -> ready.
- A ready state may be previewable for visual QA without claiming production generation exists.

## Explicitly deferred

This Gate does **not** implement:
- server persistence for the anonymous pre-payment draft;
- upload retention/deletion scheduler;
- draft -> paid-order binding;
- production generation provider;
- P1-P12 page renderer/visual system;
- live PayPal or real-money checkout;
- production deploy.

Those are separate backend/production Gates after the frontend is visually accepted.

## Acceptance criteria

PASS_CANDIDATE requires:

1. Homepage entry is visually coordinated with the accepted homepage and does not broadly restyle it.
2. Free Preview CTA and homepage offer CTA can route to the core-function surface.
3. Core-function surface is a coherent full-page onboarding flow at desktop/mobile.
4. Frontend supports the complete visible intake structure: 12–25 photos, <=3 must-use, six prompts, review.
5. Final frontend handoff uses WooCommerce core checkout rather than custom payment UI.
6. Woo order-received presentation can show the generation-status continuation without changing payment semantics.
7. Dedicated status shell has generating and ready presentation states.
8. No model/provider call, real payment, runtime/production deployment, P1-P12 build, or Shared Infra mutation occurs.
9. PHP and JavaScript syntax checks pass for changed source.
10. Reviewer visual/structural review occurs before PASS; Owner visual acceptance remains a separate checkpoint.

## Stop boundary

Stop after the reviewable frontend candidate. Do not continue into backend pre-payment draft persistence or P1-P12.
