# G2A1 — Input / OCR / Reusable Component Feasibility PoC

> Reviewer execution contract  
> Status: READY_FOR_EXECUTOR  
> Parent truth: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)

## Goal

Before polishing UI, connecting payment or building the full cookbook generator, prove the hard technical boundaries with synthetic/public fixtures.

This Gate must answer:

1. whether the accepted PaddleOCR-primary + TrOCR-fallback route is viable without adding more OCR providers/models;
2. whether critical recipe fields can be structured with provenance;
3. whether ambiguity fails closed instead of being guessed;
4. whether order-bound image upload can be reused;
5. whether private proof/final delivery can be reused;
6. whether pre-payment preview can remain browser-local and zero-model-token.

## A. OCR benchmark

Use a mixed fixture set, not only clean text.

Minimum classes:
- printed/typed recipe;
- neat handwriting;
- difficult/cursive handwriting;
- skew/shadow phone photo;
- fractions/units/temperature/time;
- one mixed-language sample only if relevant to intended scope.

Validate only this accepted MVP route:
1. run **PaddleOCR** on each full-page fixture;
2. apply deterministic checks for low confidence and critical values (fractions, quantities, units, temperatures, timing);
3. crop only suspicious lines/regions and run **Microsoft TrOCR** on those;
4. when results still disagree/remain uncertain, mark `USER_CONFIRM_REQUIRED` and preserve the source crop;
5. measure how often TrOCR resolves the ambiguity and how often user confirmation is still required.

Do **not** add or benchmark Tesseract, cloud OCR or VLM/vision in the default Gate. If this route proves insufficient, return evidence to Reviewer instead of silently expanding the architecture.

Record:
- exact transcription;
- critical-field error;
- uncertainty recall;
- false confidence;
- latency;
- approximate cost;
- data path/privacy boundary;
- operational complexity.

## B. Recipe schema probe

For every fixture produce a structured object containing at least:

- title;
- source/person when present;
- ingredients with original text + parsed quantity/unit/name;
- steps with original text;
- temperature/time;
- notes;
- source spans/coordinates when available;
- confidence/uncertainty;
- correction state.

Prove that normalized output never destroys the original transcription.

## C. Critical-value fail-closed test

Construct adversarial fixtures such as:

- `1/2 tsp` vs `12 tsp`;
- `350°F` vs `350°C`;
- `15 min` vs `75 min`;
- fraction handwriting;
- ambiguous ingredient abbreviations.

PASS requires ambiguous/wrong critical values to be flagged rather than silently accepted.

## D. Browser-local preview probe

Using synthetic/local images:
- title/family name/style;
- optional one local image;
- immediate cover + sample recipe spread;
- **0 model Token**;
- no upload before payment;
- no OCR/model request;
- no downloadable full cookbook.

Use **Kadence as the first WordPress/theme shell PoC**. Brandy and Blocksy are accepted fallbacks if a concrete blocker appears. Do not purchase Pro functionality.

Record browser/network evidence.

## E. Order-bound upload probe

Using a local/test WooCommerce instance and synthetic files only:
- test the same generic upload candidates/pattern learned from Birthday Magazine;
- bind files to intended dummy order;
- basic file type/size handling;
- mobile upload behavior;
- unauthorized raw/public access must fail closed;
- record exact versions/sources.

Do not infer PASS from Birthday Magazine's result. This project requires its own test.

## F. Private proof/final delivery probe

Using a synthetic PDF/text fixture:
- authorized order context can access;
- unrelated/unauthorized context cannot;
- no public raw file URL as the access-control mechanism;
- record version/source and cleanup.

## Allowed

- local/test WordPress/WooCommerce;
- free/open-source components;
- public/synthetic recipe images;
- PaddleOCR + Microsoft TrOCR local/open-source OCR only;
- minimal glue code;
- screenshots/network/structured benchmark output;
- exact version/source recording.

## Forbidden

- real customer photos/recipes;
- real payment;
- paid plugin/provider purchase without Owner checkpoint;
- production account/Secret exposure;
- additional OCR engines, managed/cloud OCR or VLM/vision without a new Reviewer decision;
- domain/VPS/public deployment;
- full production cookbook generator;
- physical print order;
- silent correction of ambiguous recipe facts.

## Evidence

For each candidate/component:
- exact version/source;
- fixture class;
- behavior observed;
- error/critical-error counts;
- uncertainty behavior;
- privacy/data path;
- custom code required;
- positive/negative access checks;
- cleanup/rollback;
- blockers.

## PASS Criteria

G2A1 PASS requires:

- PaddleOCR has been exercised as the full-page primary engine;
- TrOCR has been exercised specifically on PaddleOCR's suspicious/ambiguous regions;
- routing criteria to TrOCR are explicit and evidence-backed;
- unresolved disagreements fail closed to `USER_CONFIRM_REQUIRED`;
- the resulting manual-confirmation burden is measured;
- the two-engine route is either evidence-backed as sufficient for MVP or a precise RETURN explains why it is not;
- recipe schema/provenance mapping works on fixtures;
- critical ambiguity fails closed;
- browser-local zero-token preview is feasible;
- order-bound private upload is proven reusable or explicitly rejected;
- private order-bound delivery is proven reusable or explicitly rejected;
- no real payment/customer data/production write occurred.

## Output

Executor creates/updates:
- `EXECUTOR_HANDOFF.md`
- `EXECUTION_EVIDENCE.md`

Return:

```text
PASS_CANDIDATE_G2A1_INPUT_OCR_COMPONENT_FEASIBILITY
STOP_AT_REVIEWER: YES
```

or a precise `RETURN_*`.
