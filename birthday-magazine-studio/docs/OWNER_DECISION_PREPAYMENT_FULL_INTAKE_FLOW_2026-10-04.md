# Owner Decision — Pre-payment Full Intake Flow

> Date: 2026-10-04
> Evidence provenance: OWNER_REPORTED
> Project: Birthday Magazine Studio

## Canonical customer flow

```text
Homepage
-> Free Preview (basic information + optional one browser-local photo)
-> Homepage / Free Preview CTA
-> Core function page
-> Upload 12–25 photos + answer structured questions
-> Submit complete intake
-> WooCommerce payment
-> Automatic generation
-> Complete private magazine viewer / proof
```

## Product meaning

The dedicated core function page is the full creation/intake surface.

The user completes the real material handoff **before payment**. After payment, the user should not be asked to continue supplying the normal required intake; successful payment should transition directly into generation/progress and then the complete result.

## Boundaries

- The **free Preview remains browser-local and zero-model**; its optional one photo is not uploaded by that Preview component.
- The **core function page is separate** and may upload/store the complete 12–25 photo set and structured answers as a temporary pre-payment draft.
- Submitting the intake does **not** authorize generation.
- Production generation starts only after server-side paid entitlement is confirmed and the exact submitted intake snapshot is bound to the paid WooCommerce order/customer.
- Payment failure/cancellation leaves generation at zero.
- No separate registration page is required before checkout; checkout creates/attaches the authenticated customer workspace.
- Abandoned/unpaid pre-payment drafts require short-lived automatic deletion; exact TTL is an implementation detail for a later Gate.

## Superseded wording

Any earlier project text describing the 12–25 photo / six-question intake as beginning **after payment** is superseded by this decision.
