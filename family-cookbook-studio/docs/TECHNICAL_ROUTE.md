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
| Theme / visual foundation | Reuse Birthday Magazine PoC learnings; exact theme TBD | POC | Visual adaptation |
| Free preview | Browser-local deterministic template | ACCEPTED PATTERN | Small |
| Payment | WooCommerce-compatible Provider; reuse Birthday/Mini Craft sequence | UNKNOWN / HOLD | No custom payment API unless later required |
| Post-payment recipe-image intake | Order-bound upload component | POC | Small mapping glue |
| Optional story/context intake | Order-bound fields / thin project plugin | ACCEPTED PATTERN | Small |
| Background orchestration | Action Scheduler pattern | ACCEPTED PATTERN | Job definitions |
| Image preprocessing | Rotate/deskew/crop/contrast/quality checks | CUSTOM CORE / library-backed | Yes |
| Handwriting OCR | Benchmark provider/open-source candidates | POC | Adapter |
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

If later evidence shows that conversion requires a free real OCR sample, open a separate cost/privacy experiment instead of silently weakening this boundary.

Paid processing starts only when:

```text
payment_entitlement_confirmed
AND intake_complete
AND canonical_processing_job_absent
```

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

G2A1 may compare:
- handwriting-capable cloud OCR;
- PaddleOCR/other self-hosted OCR;
- VLM-assisted transcription;
- hybrid/reconciliation approach.

Tesseract can remain a printed-text baseline but should not be assumed as the primary handwriting engine.

## 7. Reuse from Birthday Magazine Studio

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

## 8. Custom Product Core

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

## 9. Development Order

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

## 10. Explicitly Deferred

- physical print/POD;
- unlimited recipes/pages;
- open-ended drag/drop editor;
- automatic recipe “improvement”;
- broad multilingual promise before benchmark;
- AI-generated food imagery;
- Redis/Celery/RabbitMQ until observed queue load requires them;
- custom payment layer;
- Shared VPS deployment before local solution proof.

## 11. Shared-Core Rule

Birthday Magazine Studio and Family Cookbook Studio may eventually share:

- order/intake abstractions;
- job/idempotency primitives;
- private-file delivery;
- template/PDF utilities;
- QA helpers.

Do not create a shared platform yet. Extraction is authorized only after both projects independently prove stable contracts, because premature sharing would couple two moving product schemas.
