# G2A1 — Frontend + Reusable Component Feasibility PoC

> Reviewer execution contract  
> Status: READY_FOR_EXECUTOR  
> Parent truth: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)

## Goal

Before polishing UI or building AI/PDF, prove which mature WordPress/WooCommerce components can actually be reused without breaking the product boundary.

This Gate must answer:

1. which frontend foundation requires the least custom work;
2. whether the free preview can stay browser-local and zero-model-token;
3. whether post-payment/order-bound image upload can be reused instead of custom-built;
4. whether private proof/final file delivery can be reused safely.

## Frontend routes

Compare only minimal product-page implementations:

1. Kadence Jewelry Shop + Storelly
2. Blocksy Modern Shop + Storelly
3. Good Issue interaction ported into WordPress/WooCommerce as the custom-reference route

Route 3 does **not** authorize a separate standalone production frontend. If it wins, the Good Issue interaction/visual language must be implemented inside the accepted WordPress/WooCommerce architecture.

## Current free-preview contract

The current target is intentionally lightweight:

```text
name / age / style
+ optional ONE local cover photo
→ immediate cover + 1–2 spread preview
→ photo remains local to the browser
→ 0 LLM
→ 0 vision
→ 0 image-generation Token
```

The old prototype's "up to six photos + memory" free flow is reference behavior only and is not the current MVP requirement.

## Reusable component probes

### A. Storelly preview probe
Verify with browser/network evidence:
- one local image can be previewed without being uploaded before payment;
- no AI/model request occurs;
- critical preview capability is available without paid-only/cloud-only dependency;
- WooCommerce product/cart path remains usable.

If Storelly sends the pre-payment image to a server/cloud for the critical preview, record that as a boundary failure and keep the Good Issue local-preview implementation as fallback.

### B. Theme shell comparison
For Kadence and Blocksy:
- minimal product landing only;
- preserve "simple inputs → immediate magazine result";
- desktop + 375px;
- measure custom CSS/JS/PHP needed;
- do not build two full polished stores.

### C. Order-bound upload probe
Using synthetic files and a local dummy WooCommerce order only:
- test Vanquish Upload Files or equivalent first candidate;
- confirm upload binds to the intended order;
- confirm mobile/basic file validation;
- confirm no public unauthenticated file exposure;
- no real payment required.

This is a component feasibility test, not G3A commerce-loop validation.

### D. Private proof/final file probe
Using a synthetic PDF/text fixture:
- test Vanquish Attach Me / Woo order-bound private delivery candidate;
- authorized order context can access;
- unrelated/unauthorized access fails closed;
- no public raw file URL may become the product access-control mechanism.

## Allowed

- local/test WordPress;
- free/open-source theme/plugin installs;
- synthetic/demo photos and files;
- local dummy WooCommerce order created without external payment;
- minimal CSS/JS/PHP needed for feasibility;
- screenshots/network observations;
- exact version/source recording.

## Forbidden

- PayPal connection;
- real checkout payment;
- AI/model API calls;
- real customer data;
- paid plugin purchase;
- VPS/domain/public production deployment;
- full 12-page generator;
- broad visual redesign.

## Evidence

For each candidate/component record:
- exact version/source;
- behavior observed;
- custom code required;
- network/data boundary;
- 375px result where applicable;
- positive and negative access checks;
- blockers;
- cleanup/rollback.

## PASS Criteria

G2A1 PASS requires:

- a preferred WordPress frontend foundation is evidence-backed;
- Storelly is either accepted for the zero-token preview or rejected with a specific boundary reason;
- an order-bound upload path is proven reusable or explicitly rejected;
- a private order-bound delivery path is proven reusable or explicitly rejected;
- Route 3, if preferred, remains a WordPress/WooCommerce implementation path;
- no PayPal, AI, real customer data or production writes occurred.

## Output

Executor creates/updates:
- `EXECUTOR_HANDOFF.md`
- `EXECUTION_EVIDENCE.md`

Return:

```text
PASS_CANDIDATE_G2A1_COMPONENT_FEASIBILITY
STOP_AT_REVIEWER: YES
```

or a precise `RETURN_*`.
