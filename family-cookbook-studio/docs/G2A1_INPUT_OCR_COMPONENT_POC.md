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

## Git / Delivery Contract

Execution branch:

`codex/family-cookbook-g2a1-input-ocr-component-feasibility`

Required behavior:
- create/use this dedicated branch for G2A1 writes;
- before changing files, read the current branch state and avoid overwriting unrelated work;
- commit all Gate-scoped implementation, test/fixture metadata, benchmark artifacts that belong in Git, and required handoff/evidence documents;
- required committed project documents:
  - `family-cookbook-studio/EXECUTION_EVIDENCE.md`
  - `family-cookbook-studio/EXECUTOR_HANDOFF.md`
- supporting benchmark files may be committed under a clearly named project-local G2A1 path if useful;
- do not commit Secrets, customer/private data, model caches, huge binaries, generated dependency/vendor trees or disposable runtime files;
- after the final commit, read back the branch HEAD from GitHub;
- final response must include:
  - `BRANCH=<exact branch>`
  - `HEAD_COMMIT=<40-char SHA>`
  - Gate result;
- **do not merge to `main`**;
- **do not start G2A2**;
- stop at Reviewer.

A local-only result, uncommitted evidence, or a chat-only summary is not sufficient delivery.

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

Executor must create/update and commit:
- `EXECUTOR_HANDOFF.md`
- `EXECUTION_EVIDENCE.md`
- all bounded G2A1 PoC/supporting artifacts needed for Reviewer verification

Successful return format:

```text
PASS_CANDIDATE_G2A1_INPUT_OCR_COMPONENT_FEASIBILITY
BRANCH=codex/family-cookbook-g2a1-input-ocr-component-feasibility
HEAD_COMMIT=<40-char git commit sha>
GITHUB_DELIVERY=COMMITTED
MAIN_MERGED=NO
STOP_AT_REVIEWER=YES
```

Failure/blocked return must use a precise `RETURN_*` and must still commit the evidence/handoff when repository writes are available, then return branch + HEAD SHA. If GitHub write/commit itself is unavailable, return a precise delivery blocker rather than claiming completion.
