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

### B. PaddleOCR — FIRST self-host/open-source benchmark candidate

PaddleOCR's current OCR pipeline documentation describes recognition across printed and handwritten text and multilingual document OCR.

Source:
- https://github.com/PaddlePaddle/PaddleOCR/blob/main/docs/version3.x/pipeline_usage/OCR.en.md

Potential advantage: self-hosting/data-path control.  
Unknown until benchmark: accuracy on cursive family recipe handwriting, operational footprint and whether the chosen model fits the eventual runtime.

### C. Microsoft TrOCR — SECOND local handwriting benchmark candidate

Microsoft TrOCR provides transformer-based optical character recognition models, including handwritten checkpoints. It is accepted for G2A1 as a second local handwriting candidate so that difficult fields can be compared against PaddleOCR without immediately requiring a paid cloud/VLM path.

Reference:
- https://huggingface.co/microsoft/trocr-base-handwritten

Unknown until benchmark:
- whole-page/layout behavior versus cropped line/region recognition;
- accuracy on recipe-specific fractions, temperatures and abbreviations;
- runtime footprint on the actual available hardware;
- language coverage beyond the chosen checkpoint.

### D. Tesseract — printed-text baseline, not primary handwriting choice

Tesseract's own FAQ says it can be used for handwriting but will not work very well because it is designed for printed text.

Source:
- https://tesseract-ocr.github.io/tessdoc/FAQ.html

Use as a baseline/control for clean printed recipes, not as an assumed primary handwriting engine.

### E. VLM-assisted transcription — exception fallback candidate

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

## 7. Accepted benchmark architecture

The Owner has accepted this **validation order**:

```text
original image
→ quality/preprocess
→ PaddleOCR primary benchmark
→ structured extraction + critical-token QA
→ if ambiguous: TrOCR / second local pass
→ uncertainty queue
→ optional VLM/vision only for remaining ambiguous regions
→ user/reviewer correction
→ approved canonical recipe
```

Tesseract remains a printed-text control.

The objective is to keep routine processing local/open-source and potentially 0 model Token, while reserving paid model inference for exceptional hard regions only if evidence supports it.

## 8. Current decision

**Test order is selected; production OCR provider is not.**

G2A1 must still produce evidence before Reviewer chooses:
- whether PaddleOCR is good enough to be primary;
- whether TrOCR materially improves difficult handwriting;
- whether a VLM fallback is needed at all;
- confidence/review thresholds;
- manual correction burden;
- whether any external provider may receive customer images;
- expected compute/API cost per order.
