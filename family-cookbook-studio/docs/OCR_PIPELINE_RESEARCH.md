# Family Cookbook Studio — OCR / Handwriting Pipeline Research

> Status: RESEARCH SNAPSHOT / CANDIDATES ONLY  
> Date: 2026-09-26  
> Current Gate authority: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)

## 1. Why OCR is a product risk, not a library checkbox

The product contains handwritten quantities, fractions, temperatures, timing, abbreviations and family-specific notes. A visually plausible transcription can still be materially wrong.

Therefore the selection criterion is not “which OCR returns text”, but:

```text
accuracy on our fixture mix
+ critical-field fidelity
+ uncertainty visibility
+ provenance / bounding info
+ language coverage
+ cost
+ privacy/data path
+ latency
+ self-host/managed tradeoff
```

## 2. Candidate families

### A. Google Cloud Vision handwriting OCR — benchmark candidate

Official Google documentation explicitly supports handwriting extraction via `DOCUMENT_TEXT_DETECTION`, returning document hierarchy such as pages, blocks, paragraphs and words.

Sources:
- https://docs.cloud.google.com/vision/docs/handwriting
- https://docs.cloud.google.com/vision/docs/ocr

Use only as a G2A1 benchmark candidate. It is not accepted production architecture.

### B. PaddleOCR — self-host/open-source benchmark candidate

PaddleOCR's current OCR pipeline documentation describes recognition across printed and handwritten text and multilingual document OCR.

Source:
- https://github.com/PaddlePaddle/PaddleOCR/blob/main/docs/version3.x/pipeline_usage/OCR.en.md

Potential advantage: self-hosting/data-path control.  
Unknown until benchmark: accuracy on cursive family recipe handwriting, operational footprint and whether the chosen model fits the eventual runtime.

### C. Tesseract — printed-text baseline, not primary handwriting choice

Tesseract's own FAQ says it can be used for handwriting but will not work very well because it is designed for printed text.

Source:
- https://tesseract-ocr.github.io/tessdoc/FAQ.html

Use as a baseline/control for clean printed recipes, not as an assumed primary handwriting engine.

### D. VLM-assisted transcription — candidate

A multimodal model may help with difficult handwriting and recipe context, but it introduces:

- model cost;
- privacy/data transfer;
- hallucination risk;
- weaker deterministic confidence semantics;
- possible tendency to “repair” an implausible recipe.

If tested, prompts/schema must explicitly separate:
1. literal transcription;
2. normalized extraction;
3. uncertainty;
4. optional suggestion.

Suggested corrections must never overwrite the canonical source without approval.

## 3. Proposed benchmark

Use 20–40 cropped/page fixtures across these classes:

| Class | Examples |
|---|---|
| Clean print | typed/printed recipe |
| Neat handwriting | block/clear handwriting |
| Cursive/difficult | connected or idiosyncratic handwriting |
| Bad capture | skew, shadow, low contrast, phone photo |
| Critical tokens | fractions, decimals, °F/°C, tsp/tbsp, minutes/hours |
| Layout complexity | ingredients + steps + margin notes |
| Mixed language | only if product scope may include it |

No real customer private data is needed for G2A1.

## 4. Metrics

Do not rely only on generic character/word error rate.

Record:

- exact transcription error rate;
- **critical-field error rate** for quantity/unit/temp/time;
- missing-line rate;
- recipe-section segmentation success;
- uncertainty recall: how often a wrong critical field was flagged;
- false-confidence rate: wrong critical fields incorrectly marked safe;
- manual correction minutes per recipe;
- provider/API cost per page where applicable;
- processing latency;
- data leaving local environment: YES/NO and destination.

## 5. Acceptance philosophy

A production-quality pipeline may intentionally choose a system that flags more uncertainty if it reduces silent critical errors.

Priority:

```text
silent wrong critical value  = worst
flagged uncertainty          = acceptable / reviewable
correct transcription        = best
```

## 6. Image preprocessing candidates

Before OCR, test bounded preprocessing:

- EXIF orientation;
- rotate/deskew;
- crop/page detection;
- contrast/brightness normalization;
- shadow reduction;
- resolution/blur quality checks.

Keep the original image immutable; preprocessing outputs are derived artifacts.

## 7. Recommended initial architecture hypothesis

Not yet accepted:

```text
original image
→ quality/preprocess
→ primary handwriting OCR
→ structured extraction
→ critical-token QA
→ uncertainty queue
→ optional second-pass/VLM only for ambiguous regions
→ user/reviewer correction
→ approved canonical recipe
```

This avoids paying a high-cost model for every field while keeping a fallback for difficult handwriting.

## 8. Current decision

No OCR provider is selected yet.

G2A1 must produce evidence before Reviewer chooses:
- primary OCR;
- fallback path;
- confidence/review thresholds;
- whether any provider is allowed to receive customer images.
