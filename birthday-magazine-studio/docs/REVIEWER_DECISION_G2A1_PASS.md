# Reviewer Decision — G2A1 PASS with Guest Plugin Rejection

Date: 2026-09-27  
Parent Gate: `G2A1_FRONTEND_AND_REUSABLE_COMPONENT_FEASIBILITY_POC`  
Closure run: `G2A1R1_EVIDENCE_CLOSURE`

## Decision

```text
G2A1_REVIEW_DECISION=PASS_G2A1_COMPONENT_FEASIBILITY
G2A1R1_EXECUTOR_RESULT=RETURN_GUEST_ACCESS_CONTROL_FAILED
G2A2_STARTED=NO
STOP_AT_REVIEWER=YES
```

The G2A1R1 Executor correctly returned because the strict guest negative checks failed. Reviewer nevertheless closes the **parent feasibility Gate G2A1 as PASS** because the failure produced a definitive technical disposition rather than an unresolved unknown.

The original G2A1 acceptance criteria allowed a component path to be either proven reusable or explicitly rejected. The guest paths are now explicitly rejected.

## Accepted architecture facts

### Frontend
- **Good Issue-style preview inside WordPress + WooCommerce** is the accepted technical foundation candidate.
- The free preview stays browser-local and uses zero LLM/vision/image-generation Token.
- Storelly is rejected for the current free-preview path.

### Upload Files
- Registered-account order-bound upload behavior passed the tested isolation checks.
- Raw storage URLs fail closed.
- The guest-issued secure file link is a bearer capability: once the issued link is known, it replayed successfully from an unrelated guest context.
- Therefore **Vanquish Upload Files is not accepted as a strict guest-private download/access mechanism**.

### Attach Me
- Registered-account authorization behavior passed the tested owning-vs-unrelated-account checks.
- Raw storage URLs fail closed.
- Authorized byte-level download and fixture SHA-256 verification passed.
- The guest-issued attachment link replayed successfully from an unrelated guest context.
- Therefore **Vanquish Attach Me is not accepted for strict guest-private delivery**.

## Security interpretation

The evidence does **not** show that unrelated guests can discover arbitrary files or enumerate another order. Wrong-email/order visibility checks failed closed and raw storage URLs returned 403.

The finding is narrower:

> an already-issued guest link behaves as a bearer capability rather than remaining bound to the current guest order/session context.

That is incompatible with this project's strict private guest-delivery requirement, so the guest plugin paths are rejected.

## What is closed

No further retry of the same guest-link behavior is required.

Accepted and closed:
- browser-local free preview;
- Good Issue-in-WordPress technical route;
- Storelly rejection;
- registered-account partial reuse evidence for Upload Files;
- registered-account private-delivery evidence for Attach Me;
- guest positive upload/delivery behavior;
- guest bearer-link replay finding;
- actual file download/hash;
- durable screenshots;
- project-scoped cleanup/read-back;
- GitHub Evidence/Handoff submission.

## What remains a product decision

G2A2 must decide the customer access model:

### Option A — authenticated customer account required
Then the tested registered-account plugin paths may remain candidates for reuse.

### Option B — guest/no-account fulfillment required
Then the current Vanquish guest delivery/access paths must not be used as-is. A later bounded technical Gate must select or implement a guest-safe access-control mechanism before production checkout/private delivery.

Reviewer does not choose A or B in this decision.

## Scope state

- G2A1: **PASS**
- G2A1R1: execution RETURN fact preserved; no retry required
- G2A2: **HOLD / NOT STARTED**
- G2B+: HOLD

## Final result

```text
GATE=G2A1_FRONTEND_AND_REUSABLE_COMPONENT_FEASIBILITY_POC
REVIEW_DECISION=PASS_G2A1_COMPONENT_FEASIBILITY
FRONTEND_TECHNICAL_ROUTE=GOOD_ISSUE_IN_WORDPRESS_WOOCOMMERCE
STORELLY=REJECTED
REGISTERED_ACCOUNT_UPLOAD=REUSABLE_CANDIDATE
REGISTERED_ACCOUNT_PRIVATE_DELIVERY=REUSABLE_CANDIDATE
GUEST_UPLOAD_PRIVATE_LINK=REJECTED_AS_IS
GUEST_PRIVATE_DELIVERY_LINK=REJECTED_AS_IS
G2A2_STARTED=NO
STOP_AT_REVIEWER=YES
```
