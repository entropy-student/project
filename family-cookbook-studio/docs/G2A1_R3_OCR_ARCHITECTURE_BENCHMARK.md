# G2A1-R3 — OCR Architecture Benchmark

> Reviewer execution contract  
> Status: **CURRENT / R3A READY_FOR_EXECUTOR**  
> Parent truth: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)  
> Owner decisions resolved in: [G2A1_D1_TARGET_LANGUAGE_OCR_ACCEPTANCE.md](./G2A1_D1_TARGET_LANGUAGE_OCR_ACCEPTANCE.md)

## 1. Goal

Select the lowest-complexity OCR architecture that can support:

- English-first, not English-only input;
- one consolidated user review/approval screen;
- manual editing of any uncertain field;
- no silently accepted wrong quantity, unit, temperature, or timing;
- review burden low enough that the user is verifying/correcting, not retranscribing.

Final MVP architecture remains:

```text
ONE free/local primary
→ deterministic semantic risk checks
→ AT MOST ONE bounded API fallback
→ one consolidated manual-edit review
```

R3 is split into two bounded phases so paid-provider credentials are not required before a local primary is selected.

---

## 2. R3A — Free / Local Primary Benchmark — CURRENT

Benchmark exactly these two primary candidates:

### Candidate A — PP-OCRv6_medium
- free/local/open-source PaddleOCR stack;
- single recognition model supports English plus broad multilingual coverage;
- preferred baseline because it is small, conventional OCR, and lower hallucination risk.

### Candidate B — PaddleOCR-VL-1.6
- free/local/open-source PaddleOCR document VLM;
- challenger for photographed, warped, complex, or difficult document images;
- must be penalized for any hallucinated/normalized text that is not visibly supported by the image.

Do not add more local OCR candidates in R3A.

### R3A output
Select exactly one:
- `PRIMARY=PP-OCRv6_medium`, or
- `PRIMARY=PaddleOCR-VL-1.6`, or
- precise RETURN if neither is viable.

No API fallback is called in R3A.

---

## 3. R3B — Bounded API Fallback Benchmark — HOLD

R3B starts only after Reviewer accepts the R3A primary.

Use only the R3A primary's unresolved/high-risk pages or crops.

Benchmark at most:
1. Mistral OCR 4.1
2. Google Enterprise Document OCR
3. Gemini 3.8 Flash as a general multimodal challenger

R3B requires an Owner checkpoint before any credential entry, billing/account action, paid API request, or Secret use.

Do not silently substitute another provider.

R3B selects exactly one fallback or concludes no API fallback is needed.

---

## 4. Accepted Evidence — Do Not Repeat

Do not rerun:
- WordPress;
- WooCommerce;
- Kadence;
- browser-local preview;
- order-bound upload;
- private delivery.

Those feasibility facts were accepted from G2A1-R2.

Carry forward:
- synthetic recipe fixtures;
- routing/provenance/schema logic where still applicable;
- prior PaddleOCR R2 outputs as historical comparison only.

---

## 5. Benchmark Corpus

R3A must use a coherent English-first corpus.

Target:
- 20 existing synthetic recipe/adversarial pages;
- 12–20 public/open genuine English handwriting samples;
- prefer recipe-like or note-like handwriting where legally/technically available;
- add 3–5 small multilingual probes from languages already supported by the candidate stack, but do not combine those into the English primary score.

Record source, license/use basis, language, and provenance.

No customer/private family data.

---

## 6. Scoring — Semantic, Not Exact-String Only

Do not use exact line equality as the primary product metric.

For critical recipe facts score separately:

- quantity numeric value;
- fraction;
- unit;
- ingredient association;
- temperature numeric value;
- temperature scale;
- timing numeric value;
- timing unit.

Examples:

`350°F → 350F`
- semantic temperature value = correct;
- temperature scale = recoverable/correct;
- typography mismatch only.

`1/2 cup → 1/2cup`
- quantity = correct;
- unit = correct;
- spacing mismatch only.

`15 min → 75 min`
- critical semantic error.

`1/2 tsp → 12 tsp`
- critical semantic error.

Also measure:
- missing ingredient/step lines;
- hallucinated lines;
- unsupported auto-normalization;
- blank/failed page;
- noncritical text error/edit burden.

---

## 7. Preserve-Don't-Invent Rule

For both candidates:

- raw OCR/model output must be preserved;
- normalization must be separate;
- no model-generated correction may silently replace source facts;
- any candidate output unsupported by visible source text is a hallucination/fidelity failure;
- uncertain critical fields must remain uncertain.

---

## 8. Single Review UX Metric

The product has one consolidated review stage, not repeated popups.

Simulate the final review payload:

```text
page
→ recognized recipe
→ highlighted uncertain/high-risk fields
→ editable values
→ one final Confirm
```

Measure:

- number of fields requiring manual edit;
- number of fields requiring only visual confirmation;
- percentage of pages needing whole-line retranscription;
- percentage of pages needing image re-upload;
- total edit characters / changed critical fields where practical.

Do not use the old `≤2 confirmations/page` as an automatic PASS/FAIL threshold.

Reviewer should judge whether the experience is:
- LIGHT_REVIEW
- MODERATE_REVIEW
- HEAVY_RETRANSCRIPTION

based on evidence.

---

## 9. Candidate Comparison

Compare PP-OCRv6_medium vs PaddleOCR-VL-1.6 on:

1. silent critical semantic errors — highest priority;
2. missing critical facts;
3. hallucinated/unsupported facts;
4. review/edit burden;
5. genuine English handwriting coverage;
6. multilingual probe behavior;
7. latency;
8. RAM / peak memory;
9. model/storage footprint;
10. install/runtime reliability;
11. integration complexity;
12. deterministic coordinates/confidence/provenance support where available.

Do not pick a candidate solely because its prose output looks cleaner.

---

## 10. Execution Environment

Use GitHub Actions hosted Ubuntu runner again.

Do not return to the resource-constrained Windows workstation.

A Gate-scoped workflow may be created/updated on the existing execution branch.

No repository Secret is needed in R3A.

Workflow should:
- run only on the execution branch;
- use a clear marker such as `[g2a1-r3a-run]`;
- use minimum GitHub permissions;
- upload compact benchmark artifacts;
- not commit from inside Actions.

---

## 11. Git / Branch Contract

Continue:

`codex/family-cookbook-g2a1-input-ocr-component-feasibility`

Preserve all prior RETURN/history/evidence.

Do not merge `main`.

Read latest `main` Reviewer truth before execution.

Commit R3A code/evidence/handoff back to the same branch after Actions read-back.

---

## 12. Required Artifacts

Create/update compact artifacts such as:

- `g2a1/r3a/corpus.json`
- `g2a1/r3a/ppocrv6-results.json`
- `g2a1/r3a/paddleocr-vl-results.json`
- `g2a1/r3a/semantic-score.json`
- `g2a1/r3a/review-burden.json`
- `g2a1/r3a/comparison.json`

Update:
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Do not commit:
- model weights/cache;
- private data;
- huge rendered fixture outputs when reproducible;
- dependency trees;
- credentials.

---

## 13. R3A PASS_CANDIDATE

Return PASS_CANDIDATE only if both local candidates were actually run on the same benchmark corpus and semantic scoring is complete.

Successful format:

```text
PASS_CANDIDATE_G2A1_R3A_LOCAL_PRIMARY_SELECTION

BRANCH=codex/family-cookbook-g2a1-input-ocr-component-feasibility
HEAD_COMMIT=<40-char SHA>
ACTIONS_RUN_ID=<run id>
ACTIONS_CONCLUSION=<success or evidence-valid failure explained>

PRIMARY=<PP-OCRv6_medium | PaddleOCR-VL-1.6>
SECOND_LOCAL_PRIMARY=REJECTED
API_FALLBACK_TESTED=NO
R3B_OWNER_CHECKPOINT=REQUIRED

GITHUB_DELIVERY=COMMITTED
MAIN_MERGED=NO
STOP_AT_REVIEWER=YES
```

If neither candidate is sufficient, return:

`RETURN_G2A1_R3A_LOCAL_PRIMARY_INSUFFICIENT`

with exact semantic/error/edit-burden evidence.

---

## 14. Forbidden in R3A

- Mistral API calls;
- Google Document AI calls;
- Gemini API calls;
- any API key/Secret entry;
- paid cloud/GPU purchase;
- customer/private recipes;
- WordPress/Woo/Kadence retesting;
- third local OCR candidate;
- production deployment;
- main merge;
- G2A2.

Stop at Reviewer.
