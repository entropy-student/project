# Family Cookbook Studio — Technical Route

> Status: CURRENT SUPPORTING ARCHITECTURE  
> Current truth / Gate authority: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)  
> This file defines the accepted reuse-vs-custom direction. It does not prove implementation.

## 1. Architecture Principle

Do not build a full custom ecommerce site and do not reduce the product to “run OCR and dump text”.

Reuse mature commerce/upload/delivery capabilities. Custom-build only the family-cookbook engine:

```text
WordPress / Theme
    ↓
WooCommerce
    ↓
paid entitlement + complete intake
    ↓
private recipe images
    ↓
image preprocessing
    ↓
OCR / handwriting recognition
    ↓
recipe schema extraction
    ↓
uncertainty review
    ↓
deterministic cookbook templates
    ↓
PDF QA
    ↓
private proof / final delivery
```

## 2. Stack Map

| Problem | Planned component | Status | Custom work |
|---|---|---|---|
| Site shell / responsive pages | WordPress | ACCEPTED | Low |
| Store / product / cart / order | WooCommerce | ACCEPTED | Low |
| Theme / visual foundation | **Kadence first PoC**; Brandy / Blocksy fallbacks | ACCEPTED POC SHORTLIST | Visual adaptation |
| Free preview | Browser-local deterministic template | ACCEPTED PATTERN | Small |
| Payment | WooCommerce-compatible Provider; reuse Birthday/Mini Craft sequence | UNKNOWN / HOLD | No custom payment API unless later required |
| Post-payment recipe-image intake | Order-bound upload component | POC | Small mapping glue |
| Optional story/context intake | Order-bound fields / thin project plugin | ACCEPTED PATTERN | Small |
| Background orchestration | Action Scheduler pattern | ACCEPTED PATTERN | Job definitions |
| Image preprocessing | OpenCV/library-backed rotate/deskew/crop/contrast/quality checks | ACCEPTED DIRECTION | Yes |
| Handwriting OCR | **PP-OCRv6_medium primary + Baidu Handwriting OCR critical-field second opinion + one consolidated manual-edit review** | G2A1 PASS | Thin adapter |
| Recipe extraction | Structured schema + provenance | CUSTOM CORE | Yes |
| Uncertainty policy | confidence/rules + review queue | CUSTOM CORE | Yes |
| Correction/review UI | order/private review surface | CUSTOM CORE | Yes |
| Cookbook composition | deterministic HTML/CSS templates | CUSTOM CORE | Yes |
| PDF render | browser/server renderer, exact engine TBD | POC | Small/medium |
| QA | key-value fidelity + overflow/pages/files | CUSTOM CORE | Yes |
| Private proof/final delivery | Woo order-bound private file access | POC | Small |
| Email | Woo transactional email first | ACCEPTED PATTERN | Low |
| File storage | private project storage first; object store later if needed | POC | Low |
| Analytics | privacy-minimized first-party events | LATER | Low |
| Physical print | external print/POD/manual vendor | DEFERRED | Later |

## 3. Free vs Paid Compute Boundary

Default free path:

```text
style / title / family name
+ optional ONE local cover/recipe image
→ browser-side cover + sample spread
→ 0 LLM
→ 0 OCR cloud API
→ 0 vision/image-generation Token
```

This only previews the artifact style. It must not pretend that the user's handwritten recipe has already been accurately transcribed.

**Accepted MVP boundary:** no real OCR/model inference occurs before payment. Any future free OCR sample requires a separate Reviewer/Owner experiment and must not silently change this rule.

Paid processing starts only when:

```text
payment_entitlement_confirmed
AND intake_complete
AND canonical_processing_job_absent
```

Default paid compute path:

```text
private source image
→ local/library image preprocessing
→ PP-OCRv6_medium primary
→ deterministic semantic critical-value/schema checks
→ if critical-risk crop: Baidu Handwriting OCR second opinion
→ preserve PP + Baidu separately; never wholesale overwrite
→ if still uncertain/disagrees: one consolidated user review
→ approved canonical recipe
→ deterministic HTML/CSS → PDF
```

Token policy:
- browser-local free preview: **0 model Token**;
- MVP paid OCR path: **0 model/API Token** by design;
- local CPU/GPU/runtime cost is still real and must be benchmarked;
- cloud OCR and VLM/vision are outside MVP unless a later Gate explicitly reopens the architecture.

## 4. Canonical Recipe Data Model

Every recipe should have layered data rather than one overwritten text blob:

```text
source_image[]
raw_ocr
normalized_transcription
recipe_schema
  title
  source/person
  ingredients[]
    original_text
    quantity
    unit
    ingredient
    confidence
    source_span
  steps[]
    original_text
    normalized_text
    confidence
    source_span
  temperature[]
  timing[]
  notes[]
uncertainties[]
corrections[]
approval_state
```

Important: normalized fields are not allowed to destroy original text.

## 5. Confidence / Review Rules

Do not trust one opaque model confidence score as truth.

Use combined checks:

- OCR/provider confidence when available;
- parser/schema validation;
- critical-token heuristics for numbers, fractions, units, °F/°C, minutes/hours;
- disagreement between OCR passes/providers when tested;
- image quality signals;
- missing-field or impossible-structure checks;
- explicit user correction.

Example:

```text
"1/2 tsp salt" detected as "12 tsp salt"
→ critical quantity anomaly
→ UNCERTAIN
→ show image crop + OCR candidate
→ require confirmation
→ do not auto-publish
```

## 6. OCR Adapter Boundary

Do not couple the whole product to one OCR vendor.

```text
ocr_adapter(image)
→ {
    text,
    blocks,
    coordinates?,
    confidence?,
    language?,
    provider_meta
  }
```

Current OCR contract after G2A1:
1. **PP-OCRv6_medium** is the accepted full-page free/local primary.
2. Product scope is English-first, not English-only.
3. Deterministic rules score **semantic critical facts**, not typography alone.
4. **Baidu Handwriting OCR** is accepted only as a bounded second opinion for high-risk quantity/unit/temperature/time/critical-field crops.
5. Baidu output must never wholesale-replace the PP transcript. Raw outputs and provider provenance remain separate.
6. On the 11 hard cases, Baidu recovered the only critical fact missed by PP-OCRv6 (`8 eggs`) but worsened whole-transcript edit burden, so canonical transcript fallback remains `NONE`.
7. `PaddleOCR-VL-1.6` is rejected as primary; `microsoft/trocr-small-handwritten` remains deprecated.
8. Google Document AI remains a technically viable deferred provider adapter; Mistral Free mode remains availability-blocked by persistent HTTP 429.
9. **One consolidated user review with manual editing** remains the final fail-closed stage.
10. External OCR providers sit behind an `OCRFallbackProvider` / second-opinion adapter and emit the canonical result schema; business flow remains provider-swappable.

Explicitly deferred from MVP: broad multi-provider OCR bake-offs, cloud OCR and VLM/vision OCR.

## 7. Frontend / Theme Baseline

Accepted free/open WordPress PoC shortlist:

1. **Kadence — first PoC choice**: warm editorial/lifestyle structure suits family memory + recipe storytelling.
2. **Brandy — fallback**: stronger ecommerce/product-page orientation.
3. **Blocksy — fallback**: cleaner modern/editorial presentation with strong WooCommerce compatibility.

Rules:
- use free/open functionality first;
- do not purchase Pro templates/plugins in G2A1;
- theme choice is a shell, not the personalized cookbook generator;
- the actual cookbook preview/generation surface remains project-specific HTML/CSS/JS;
- final visual style remains a G2A2 Owner decision after the technical PoC.

Reference pages:
- https://wordpress.org/themes/kadence/
- https://wordpress.org/themes/brandy/
- https://wordpress.org/themes/blocksy/

## 8. Reuse from Birthday Magazine Studio

Reuse only where the capability is generic:

- WordPress/WooCommerce shell;
- theme PoC methodology;
- browser-local zero-token preview pattern;
- order-bound upload test pattern;
- private order-bound file delivery test pattern;
- Action Scheduler orchestration pattern;
- deterministic HTML/CSS → PDF concept;
- PayPal/Sandbox/Canary sequence if the same Provider is later accepted.

Do **not** reuse as if proven:

- Birthday OCR does not exist;
- Birthday question schema/page map;
- Birthday price/market;
- Birthday payment evidence;
- Birthday privacy/retention policy;
- Birthday plugin candidates without Family Cookbook's own access/upload tests.

## 9. Custom Product Core

Keep the project-specific code intentionally small and separable:

```text
family-cookbook-core
├─ intake validation
├─ paid-entitlement guard
├─ processing-job idempotency
├─ image preprocessing
├─ PaddleOCR primary adapter
├─ Baidu critical-field second-opinion adapter
├─ recipe schema extraction
├─ provenance mapping
├─ uncertainty detection
├─ correction/review workflow
├─ cookbook page mapping
├─ HTML/CSS templates
├─ PDF rendering
├─ deterministic QA
└─ proof/final attachment
```

## 10. Development Order

```text
G2A1 OCR + input + reusable-component feasibility
→
G2A2 exact MVP product contract freeze
→
G2B local OCR → recipe schema → review → cookbook PDF proof
→
G3A WordPress + WooCommerce local commerce loop
→
G3B payment Sandbox + entitlement + private intake/delivery
→
G4 bounded Live transaction Canary
→
G5 acquisition / repeatability / economics
→
G6 production hardening / physical print decision
```

## 11. Explicitly Deferred

- physical print/POD;
- unlimited recipes/pages;
- open-ended drag/drop editor;
- automatic recipe “improvement”;
- broad multilingual promise before benchmark;
- additional OCR/cloud/VLM providers beyond the accepted PP-OCRv6 + Baidu critical-second-opinion route unless new evidence justifies reopening architecture;
- AI-generated food imagery;
- Redis/Celery/RabbitMQ until observed queue load requires them;
- custom payment layer;
- Shared VPS deployment before local solution proof.

## 12. Shared-Core Rule

Birthday Magazine Studio and Family Cookbook Studio may eventually share:

- order/intake abstractions;
- job/idempotency primitives;
- private-file delivery;
- template/PDF utilities;
- QA helpers.

Do not create a shared platform yet. Extraction is authorized only after both projects independently prove stable contracts, because premature sharing would couple two moving product schemas.
