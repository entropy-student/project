# Birthday Magazine Studio — Technical Route

> Status: CURRENT SUPPORTING ARCHITECTURE  
> Current truth / Gate authority: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)  
> This file defines the accepted technical direction and the reuse-vs-custom boundary. It does not prove implementation.

## 1. Architecture Principle

Do not build a full custom ecommerce site.

Reuse mature WordPress/WooCommerce capabilities for generic commerce and operations. Custom-build only the product-specific "birthday magazine engine".

```text
WordPress / Theme
    ↓
WooCommerce
    ↓
PayPal
    ↓
Paid order + complete intake
    ↓
Generation job
    ↓
AI content + deterministic layout + PDF QA
    ↓
Private proof / final PDF
```

## 2. Stack Map

| Problem | Planned component | Status | Custom work |
|---|---|---|---|
| Site shell / responsive pages | WordPress | ACCEPTED | Low |
| Store / product / cart / checkout / order | WooCommerce | ACCEPTED | Low |
| Theme / visual foundation | Kadence Jewelry Shop first PoC; Blocksy Modern Shop backup | POC | Visual adaptation |
| Editorial visual identity | Existing Good Issue prototype | ACCEPTED REFERENCE | Adapt into chosen WordPress base |
| Free preview | Storelly Product Builder first PoC; existing Good Issue local preview as fallback/reference | POC | Only glue if needed |
| Payment | Official WooCommerce PayPal Payments | ACCEPTED | No custom PayPal API |
| Post-payment photo intake | Vanquish Upload Files first PoC | POC | Small order mapping glue if needed |
| Structured questions | WooCommerce order-bound custom fields / thin project plugin | ACCEPTED PATTERN | Small |
| Background job scheduling | WooCommerce/WordPress Action Scheduler pattern | ACCEPTED PATTERN | Job definitions only |
| AI story/copy generation | Provider adapter + structured prompts/schema | CUSTOM CORE | Yes |
| Page composition | Deterministic HTML/CSS magazine templates | CUSTOM CORE | Yes |
| PDF render | Browser/server render path, exact engine TBD | POC | Small/medium |
| QA | Deterministic checks: fields/pages/images/overflow/file-open | CUSTOM CORE | Yes |
| Private proof/final delivery | Woo order-bound private file path; Vanquish Attach Me first PoC | POC | Small if plugin passes |
| Email | WooCommerce transactional email first | ACCEPTED PATTERN | Low |
| File storage | Private project storage first; external object store later only if needed | POC | Low |
| Analytics | Minimal first-party event contract | LATER | Low |

## 3. Free vs Paid Compute Boundary

Free path must stay deterministic and zero-model-token:

```text
Name / age / style / optional local cover photo
→ browser-side template preview
→ 0 LLM
→ 0 vision
→ 0 image generation
```

Paid generation may start only when:

```text
WooCommerce/PayPal paid entitlement confirmed
AND required intake complete
AND no canonical generation job exists
```

A payment return page alone must never start generation.

## 4. Payment Route

Reuse the Mini Craft implementation pattern:

```text
Local WooCommerce commerce loop
→ official WooCommerce PayPal Payments
→ PayPal Sandbox connection
→ checkout / capture
→ Woo order ↔ provider correlation
→ callback/webhook
→ refund
→ bounded Live transaction Canary
```

Do not hand-code the PayPal API for MVP.

## 5. Custom Product Core

The project-specific code should remain intentionally small:

```text
birthday-magazine-core
├─ intake validation
├─ paid-entitlement guard
├─ generation job idempotency
├─ structured AI content schema
├─ magazine page mapping
├─ HTML/CSS templates
├─ PDF render orchestration
├─ deterministic QA
└─ proof/final file attachment
```

Generic ecommerce/account/payment/upload/email capabilities should not be rebuilt unless the PoC proves a reusable component cannot satisfy the requirement safely.

## 6. Frontend Foundation PoC

Compare only these three routes:

### A — Kadence Jewelry Shop + Storelly
Goal: maximum reuse of a proven WooCommerce-friendly theme and visual-product-builder path.

### B — Blocksy Modern Shop + Storelly
Goal: lighter store shell with the same preview-product-builder experiment.

### C — Existing Good Issue prototype ported into WordPress
Goal: preserve the best current editorial UX and measure how much custom WordPress adaptation it would require.

This route is **not** permission to run a separate standalone production frontend. WordPress + WooCommerce remains the accepted commerce architecture.

Decision is based on implementation cost and product fit, not visual preference alone.

## 7. PoC Decision Criteria

Each route must be judged on:

- editorial / gift-product visual fit;
- mobile 375px behavior;
- WooCommerce product/cart/checkout compatibility;
- zero-token local preview feasibility;
- local image handling before payment;
- ability to preserve Good Issue's "form left / magazine preview right" core interaction;
- plugin coupling and lock-in;
- amount of custom CSS/JS/PHP required;
- editability from WordPress admin;
- accessibility/basic performance;
- path to paid intake without rebuilding the page later.

## 8. Development Order

```text
G2A1 Frontend + reusable component feasibility
→
G2A2 Exact MVP product contract freeze
→
G2B  Local AI → magazine pages → PDF solution proof
→
G3A  WordPress + WooCommerce local commerce loop
→
G3B  PayPal Sandbox + paid entitlement + intake/private delivery
→
G4   bounded Live PayPal Canary
→
G5   acquisition / repeatability / economics
→
G6   production hardening / scale
```

## 9. Explicitly Deferred

- physical print/POD;
- multi-language;
- customer self-serve full-page editor;
- large AI image-generation workload;
- Redis/Celery/RabbitMQ unless real queue load requires them;
- custom payment layer;
- Shared VPS deployment until the local product path is proven.

## 10. Current Decision

Current recommendation to test first:

```text
Kadence Jewelry Shop + Storelly
```

This is not final theme selection. It is the first PoC candidate because it maximizes reuse while still allowing the Good Issue editorial identity to be overlaid.

Final frontend foundation is selected only after G2A1 evidence.

Before G2B, G2A2 must additionally freeze the exact page count, paid photo count, question schema, page-by-page output map, proof/revision policy, deterministic QA and customer-data handling.
