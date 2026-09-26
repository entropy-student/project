# G2A2 — MVP Product Contract Freeze

> Reviewer / Owner decision gate  
> Status: HOLD — starts only after G2A1 PASS  
> Parent truth: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)

## Goal

Freeze the exact paid MVP contract before implementing the full OCR→cookbook PDF flow.

G2B must not start while the number of recipes, fidelity rules, correction flow and output contract are still moving.

## Working hypotheses to review

These are **not** final:
- digital PDF first;
- fixed cookbook size and template family;
- bounded number of recipes per order;
- original recipe photo optionally shown as a memory element on selected pages;
- one structured review/proof cycle;
- no automatic recipe “improvement”;
- physical print deferred.

## Must Freeze

### Offer / package
- target market/language;
- price;
- recipes per package;
- maximum source images;
- page-count range or deterministic mapping;
- turnaround promise;
- digital-only vs print option.

### Free layer
Already accepted baseline:
- browser-local preview;
- **0 model Token**;
- **no real OCR/model inference before payment**;
- optional local image may be previewed without upload.

G2A2 still freezes:
- exact fields before payment;
- whether one local image is included in the final MVP UX;
- exact preview pages;
- watermark/export restriction.

### Paid intake
- required vs optional fields;
- supported image formats/limits;
- one recipe per image vs multi-page recipe behavior;
- duplicate/continuation-page behavior;
- family source/person/context fields;
- incomplete-intake behavior.

### Transcription fidelity
- what counts as critical field;
- OCR confidence/uncertainty threshold;
- exact triggers for the TrOCR fallback pass and for `USER_CONFIRM_REQUIRED`;
- what is never auto-corrected;
- exact user/reviewer confirmation behavior;
- whether original transcription and normalized version are both visible.

### Recipe schema
- title;
- source/person;
- ingredients;
- steps;
- temperature/timing;
- notes;
- yield/servings if present;
- provenance fields;
- optional story/memory fields.

### Cookbook output
- trim/page size;
- exact template set;
- cover;
- TOC/index;
- recipe page layouts;
- family story pages;
- source-image treatment;
- font policy;
- photo/image resolution policy;
- PDF output requirements.

### Proof / revision
- what customer sees;
- included correction/revision count;
- difference between correcting OCR error and asking for editorial redesign;
- final approval behavior;
- extra-cost behavior if any.

### QA
- page count;
- missing recipe;
- missing critical field;
- unresolved uncertainty count = 0 before final;
- quantity/unit/temp/time consistency;
- text overflow;
- image resolution/crop;
- PDF open/render;
- proof/final consistency.

### Data handling
- upload retention;
- derived OCR/render artifact retention;
- deletion policy;
- access roles;
- analytics exclusions;
- storage/processing disclosure and any later third-party processing if architecture changes;
- whether original images remain downloadable to buyer.

## Required artifact

Create:

`docs/MVP_PRODUCT_CONTRACT.md`

It must be explicit enough that G2B can implement a synthetic fixture end-to-end without inventing product decisions.

## PASS Criteria

- every product-critical item above is frozen;
- fidelity/uncertainty behavior is unambiguous;
- remaining UNKNOWNs do not affect G2B implementation;
- Owner approves price/package/subjective visual/revision/business decisions;
- G2B can be written as one bounded local/test-only OCR→PDF Gate.

## Output

```text
PASS_G2A2_MVP_PRODUCT_CONTRACT_FREEZE
CURRENT_GATE=G2B_LOCAL_OCR_STRUCTURED_RECIPE_PDF_SOLUTION_PROOF
```
