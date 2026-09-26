# G2A2 — MVP Product Contract Freeze

> Reviewer / Owner decision gate  
> Status: HOLD — starts only after G2A1 PASS  
> Parent truth: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)

## Goal

Freeze the exact paid MVP contract before any AI→PDF implementation.

G2B must not start while the core output and intake schema are still moving.

## Working hypotheses to review

These are not yet final:
- 12-page US Letter PDF;
- 8–12 paid-intake photos;
- 6 structured questions;
- one free cover + 1–2 spread preview;
- fixed deterministic page templates;
- customer original photos as primary visual material.

## Must Freeze

### Free layer
- exact fields shown before payment;
- exact number of local photos allowed before payment;
- preview pages shown;
- watermark/export restriction;
- zero-model-token boundary.

### Paid intake
- required vs optional fields;
- minimum/maximum photo count;
- supported image formats/limits;
- exact structured question schema;
- incomplete-intake behavior.

### Magazine output
- exact page count;
- page-by-page content map;
- which pages are deterministic vs AI-written;
- text length bounds;
- image-to-page mapping rules;
- whether any AI-generated imagery exists in MVP.

### Proof / revision
- what the customer sees in proof;
- included revision/regeneration count;
- what can be revised;
- what triggers extra generation cost;
- final approval behavior.

### QA
- name/age consistency;
- missing image/content checks;
- text overflow;
- page count;
- file-open/render check;
- proof/final version consistency.

### Data handling
- minimum retention period needed for fulfillment;
- deletion policy;
- who/what can access uploaded photos;
- what is never sent to analytics;
- third-party AI/storage disclosure boundary.

## Required artifact

Create:

`docs/MVP_PRODUCT_CONTRACT.md`

It must be explicit enough that G2B can implement a synthetic fixture end-to-end without inventing product decisions.

## PASS Criteria

- every item above is frozen;
- remaining UNKNOWNs do not affect G2B implementation;
- Owner approves subjective product/visual/revision decisions;
- G2B can be written as one bounded local/test-only AI→PDF Gate.

## Output

```text
PASS_G2A2_MVP_PRODUCT_CONTRACT_FREEZE
CURRENT_GATE=G2B_LOCAL_AI_PDF_SOLUTION_PROOF
```
