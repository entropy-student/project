# Family Cookbook Studio — OCR / Handwriting Pipeline Research

> Status: RESEARCH SNAPSHOT / MVP ROUTE ACCEPTED, PERFORMANCE UNPROVEN  
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

## 2. Accepted MVP pair and deferred alternatives

### A. Google Cloud Vision handwriting OCR — DEFERRED / NOT MVP

Official Google documentation explicitly supports handwriting extraction via `DOCUMENT_TEXT_DETECTION`, returning document hierarchy such as pages, blocks, paragraphs and words.

Sources:
- https://docs.cloud.google.com/vision/docs/handwriting
- https://docs.cloud.google.com/vision/docs/ocr

Do not implement or benchmark this in the default G2A1 path. Revisit only if the accepted local two-engine route fails.

### B. PaddleOCR — ACCEPTED MVP PRIMARY

PaddleOCR's current OCR pipeline documentation describes recognition across printed and handwritten text and multilingual document OCR.

Source:
- https://github.com/PaddlePaddle/PaddleOCR/blob/main/docs/version3.x/pipeline_usage/OCR.en.md

Potential advantage: self-hosting/data-path control.  
Unknown until benchmark: accuracy on cursive family recipe handwriting, operational footprint and whether the chosen model fits the eventual runtime.

### C. Microsoft TrOCR — ACCEPTED MVP FALLBACK

Microsoft TrOCR provides transformer-based optical character recognition models, including handwritten checkpoints. It is accepted for G2A1 as a second local handwriting candidate so that difficult fields can be compared against PaddleOCR without immediately requiring a paid cloud/VLM path.

Reference:
- https://huggingface.co/microsoft/trocr-base-handwritten

Unknown until benchmark:
- whole-page/layout behavior versus cropped line/region recognition;
- accuracy on recipe-specific fractions, temperatures and abbreviations;
- runtime footprint on the actual available hardware;
- language coverage beyond the chosen checkpoint.

### D. Tesseract — DEFERRED / NOT MVP

Tesseract's own FAQ says it can be used for handwriting but will not work very well because it is designed for printed text.

Source:
- https://tesseract-ocr.github.io/tessdoc/FAQ.html

Keep only as historical research context. Do not add it to the MVP implementation or G2A1 unless the Reviewer explicitly reopens the test scope.

### E. VLM-assisted transcription — DEFERRED / NOT MVP

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

## 7. Accepted MVP OCR architecture

```text
original image
→ quality/preprocess
→ PaddleOCR full-page primary
→ critical-token + confidence QA
→ suspicious region only → TrOCR fallback
→ still uncertain / disagreement
→ user/reviewer confirmation against source crop
→ approved canonical recipe
```

The architecture deliberately stops here. It does not add Tesseract, cloud OCR or a VLM as a third automatic guesser.

## 8. Current decision

**Architecture is selected; performance is not yet proven.**

G2A1 now answers only:
- is PaddleOCR good enough as the primary engine on the target fixture mix;
- does TrOCR reduce manual confirmation on PaddleOCR's difficult regions;
- what triggers should route a region to TrOCR;
- how often the user still needs to confirm a critical field;
- latency and local CPU/GPU footprint;
- whether this simple two-engine route is sufficient for MVP.

If it is insufficient, return evidence to Reviewer. Do not expand the stack automatically.
