# G2BR2 — Host Codex Transport and Real-AI Closure

> Reviewer execution contract  
> Status: OWNER AUTHORIZED — MAX 2 HOST-CONTEXT REAL-MODEL RUNS  
> Parent: G2B Local AI/PDF Solution Proof  
> Accepted prior evidence: PR #30 + PR #40

## Goal

Close the remaining real-AI proof without repeating accepted work and without nesting Codex CLI inside the Codex Agent command sandbox.

Required path:

```text
Owner host Windows process / terminal
→ ChatGPT-authenticated codex exec
→ existing CONTENT_SCHEMA
→ actual structured JSON
→ existing grounding
→ existing deterministic renderer
→ 12-page US Letter PDF
→ existing deterministic QA
→ duplicate guard
```

## Why this follow-up exists

G2BR1 proved that the nested topology failed before a model response:

```text
Codex Agent sandbox → nested codex exec → network/transient failure
```

G2BR2 changes only the **transport launch context**. It must not redesign the product, schema, renderer, styles or QA.

## Owner authorization

Owner authorization is **complete**.

Authorized ceiling: **maximum 2 additional real-model runs total**:
1. primary host-context run;
2. one retry only for transport/schema/transient failure.

No automatic purchase of credits is allowed.
If available ChatGPT/Codex plan allowance is exhausted, stop with `RETURN_CODEX_PLAN_LIMIT_REACHED`.

## Execution requirements

1. Start from latest `main`.
2. Use a dedicated branch, suggested:
   `codex/birthday-magazine-g2br2-host-codex-closure`
3. Reuse the existing G2B/G2BR1 harness.
4. Do not delete or rewrite G2BR1 failed-attempt evidence.
5. Use a fresh G2BR2 canonical job record/artifact namespace so prior exhausted G2BR1 counters remain historical evidence.
6. The real `codex exec` process must be launched from the Owner host Windows terminal/process context, **not from an Agent-executed child shell inside Codex**.
7. ChatGPT login may be reused from the host Codex credential store. Do not export, print or commit session/auth tokens.
8. No API key route unless a later Owner decision explicitly changes the route.

A minimal host launcher script is acceptable if useful, but it must only invoke the existing runner and must not contain secrets.

## Must prove

- at least one successful real Codex model response;
- structured output conforms to the existing `CONTENT_SCHEMA`;
- no `reference-content.json` fallback;
- grounding/hallucination audit PASS on actual model output;
- exactly two distinct supported dynamic modules;
- actual model output renders into exactly 12 US Letter pages;
- no broken images or text overflow;
- deterministic QA PASS;
- one successful canonical generation;
- duplicate invocation rejected before a second unnecessary real-model run.

## Failure handling

If host-context Codex still fails before a model response:
- retain sanitized diagnostic category and enough non-secret error text to distinguish DNS/TLS/WebSocket/HTTP/rate-limit/auth/CLI argument failure;
- do not store URLs containing tokens, Authorization headers, cookies or session IDs;
- return exact failure;
- do not fall back to human reference content.

## Forbidden

- product-contract changes;
- AI-generated imagery;
- real customer data;
- PayPal/payment;
- WordPress/WooCommerce G3 work;
- VPS/public deployment;
- automatic credit purchase;
- ChatGPT token/session extraction;
- G3.

## Handoff

Update:
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Commit, push, open PR to `main`, do not merge, STOP_AT_REVIEWER.
