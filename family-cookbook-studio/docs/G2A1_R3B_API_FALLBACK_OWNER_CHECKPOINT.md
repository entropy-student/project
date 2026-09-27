# G2A1-R3B — Bounded API Fallback Owner Checkpoint

> Reviewer / Owner checkpoint  
> Status: **CURRENT / OWNER APPROVAL REQUIRED**  
> Parent truth: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)  
> Accepted R3A primary: `PP-OCRv6_medium`  
> R3A evidence branch HEAD: `ad58cfe3b3fbfcca6a6f1ee3e929754c2c3b14e5`  
> R3A Actions evidence run: `36289130217`

## 1. Reviewer R3A Decision

R3A is accepted as PASS for local-primary selection.

Accepted primary:

`PP-OCRv6_medium`

Rejected as primary:

`PaddleOCR-VL-1.6`

Why PP-OCRv6_medium wins:
- 20/20 synthetic recipe pages required zero edits;
- 77/77 synthetic critical recipe facts were correct;
- 0 silent critical semantic errors;
- 0 confirmed hallucinations;
- only one critical miss on complete genuine handwriting: GH04 missed `8 eggs`;
- substantially lower runtime/storage footprint than PaddleOCR-VL;
- multilingual smoke probes remained nonblank;
- review class is `LIGHT_REVIEW`.

PaddleOCR-VL remains useful research evidence but is not retained in the MVP runtime.

## 2. Why R3B Is Still Worth Testing

R3A produced 11 hard-case handwriting crops requiring manual review.

These are not ordinary clean recipe pages. They are historical cursive/handwritten recipe snippets.

The product requirement is a single consolidated review stage with manual editing. The API fallback is therefore not intended to process every page. It is intended only to reduce the edit burden on the hardest handwriting cases before the single review screen.

R3B asks:

> Can one specialized external OCR materially reduce manual editing on the 11 PP-OCRv6 hard cases without introducing silent recipe-fact errors?

If not, the MVP should use PP-OCRv6 + manual review only.

## 3. Reviewer Recommended Provider Order

### First: Google Enterprise Document OCR

Reason:
- officially supports handwritten text;
- supports 200+ languages;
- supports language and handwriting hints;
- returns structured OCR/layout information;
- current public pricing lists the first 1,000 page-count units as free, then $1.50 / 1,000 pages in the main tier.

Use only the 11 public/non-private R3A hard-case samples.

### Second only if Google is insufficient: Mistral OCR 4.1

Reason:
- specialized OCR service;
- paragraph bounding boxes;
- structural block labels;
- block/word confidence support;
- multilingual;
- current public price $4 / 1,000 pages ($5 / 1,000 annotated pages).

For the current 11-page/crop evaluation, list-price usage is only a few cents.

### Reserve only: Gemini 3.8 Flash

Do not benchmark by default.

Use only if both specialized OCR options fail to materially reduce edit burden and Reviewer explicitly reopens it.

Reason: it is a general multimodal generative model, so Preserve-don't-invent risk is higher than with specialized OCR.

## 4. Owner Approval Requested

Approval authorizes only:

- creation/use of test-only provider credentials;
- public/non-private R3A handwriting samples only;
- Google Enterprise Document OCR first;
- Mistral OCR 4.1 only if Google is insufficient;
- maximum external API test spend: **USD 0.20 total**;
- no customer/private recipe data;
- no production integration;
- no persistent provider Secret in repository/chat.

Secret values must be entered by Owner through the provider/GitHub Secret mechanism and must never be pasted into ordinary repository files, evidence, logs, or chat.

## 5. R3B Success Criterion

The selected fallback must materially improve at least one of:

- critical fact recovery;
- manual-edit fields;
- manual-edit characters;
- whole-line retranscription burden;

without introducing:
- silent critical recipe-fact errors;
- unsupported hallucinated facts;
- materially worse fidelity.

If Google materially improves the 11 cases and satisfies fidelity requirements, stop and select Google.

Only if Google does not meet that bar should Mistral OCR 4.1 be tested.

If neither specialized OCR materially improves the primary:

```text
FALLBACK=NONE
ARCHITECTURE=PP-OCRv6_medium + single consolidated manual review
```

## 6. Stop Boundary

No R3B Executor dispatch until Owner explicitly approves this checkpoint.

No:
- production data;
- real buyer data;
- production deployment;
- payment integration;
- G2A2;
- main merge.
