# G2BR3 — Direct Codex Agent Real-AI Content → PDF Proof

> Reviewer execution contract  
> Status: OWNER AUTHORIZED — 1 PRIMARY + MAX 1 CORRECTION PASS  
> Parent: G2B Local AI/PDF Solution Proof  
> Accepted prior evidence: PR #30, PR #40, PR #43

## Goal

Close the remaining **content/rendering Solution Proof** without requiring the failed programmatic ChatGPT-subscription CLI transport.

Required path:

```text
existing synthetic intake
→ current authenticated Codex Agent directly authors schema-conforming generated-content.json
→ existing grounding/schema validator
→ existing deterministic renderer
→ 12-page US Letter PDF
→ existing deterministic QA
```

The Agent must itself produce the model-generated content. It must not call nested `codex exec`, use an API key, or copy the human-authored reference fixture.

## What this can prove

- a real Codex model can transform the frozen intake into the required structured content;
- actual model output can pass grounding/hallucination checks;
- exactly two supported dynamic modules can be selected from evidence;
- actual model content can render through the existing deterministic 12-page PDF pipeline;
- downstream deterministic QA works with real model content.

## What this does NOT prove

- unattended server-side generation;
- production provider authentication;
- provider-spend idempotency at a remote API boundary;
- production cost per order.

Those remain a later production-provider/runtime integration Gate.

## Owner authorization

Owner authorization is **complete**.

Authorized bound:

- one synthetic fixture;
- one primary direct-agent generation;
- at most one direct-agent correction pass only if schema/grounding validation fails;
- no API key;
- no extra credit purchase;
- no real customer data.

Production AI API/provider integration is explicitly deferred until the Owner supplies that interface later.

## Execution requirements

1. Start from latest `main`.
2. Dedicated branch, suggested:
   `codex/birthday-magazine-g2br3-direct-agent-proof`
3. Reuse the accepted G2B/G2BR1/G2BR2 fixture, schema, grounding, renderer and QA.
4. Create a fresh `artifacts/g2br3/` namespace.
5. The current Codex Agent reads the synthetic intake and schema and writes `generated-content.json` directly.
6. The generated artifact must be clearly labeled as model-authored by the interactive Codex Agent.
7. Run the existing local validators/renderer/QA against that file.
8. Never substitute `reference-content.json` for PASS.
9. No product-contract, page-architecture or style redesign.

## PASS_CANDIDATE requirements

- DIRECT_AGENT_REAL_AI_CONTENT=PASS
- STRUCTURED_SCHEMA=PASS
- GROUNDING_AUDIT=PASS
- DYNAMIC_MODULES=PASS
- ACTUAL_AI_PDF_12_PAGES=PASS
- DETERMINISTIC_QA=PASS
- REFERENCE_FIXTURE_FALLBACK=NO
- API_KEY_USED=NO
- G3_STARTED=NO

A PASS here closes the **G2B content/rendering Solution Proof** only. It does not freeze or approve a production generation provider.

## Handoff

Update `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md`; retain generated JSON, grounding report, QA report, PDF and contact sheet/screenshots; commit, push, open PR to `main`; do not merge; STOP_AT_REVIEWER.
