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
| Handwriting OCR | **PaddleOCR first → TrOCR fallback benchmark → Tesseract print control** | POC | Adapter |
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
→ PaddleOCR primary attempt
→ deterministic critical-token/schema checks
→ if ambiguous: TrOCR/second local pass
→ if still ambiguous: optional bounded VLM/vision region fallback
→ if still uncertain: user/reviewer confirmation
→ approved canonical recipe
→ deterministic HTML/CSS → PDF
```

Token policy:
- browser-local free preview: **0 model Token**;
- ordinary paid path can remain **0 model Token** if local OCR + rules are sufficient;
- VLM/vision Token is allowed only as a bounded ambiguity fallback after G2A1 proves value/cost/privacy;
- exact per-order Token/API cost is not yet known and must come from benchmark evidence.

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

G2A1 comparison order:
1. **PaddleOCR** — primary open-source/self-host candidate;
2. **Microsoft TrOCR** — second local handwriting candidate / fallback benchmark;
3. **Tesseract** — printed-text baseline/control only;
4. managed handwriting OCR — optional comparator when credentials/cost boundary safely permit;
5. VLM-assisted transcription — optional ambiguous-region fallback only.

This is a benchmark order, not a production selection. G2A1 evidence decides the actual primary/fallback route.

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
├─ ocr adapters
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
