# Birthday Magazine Studio — Document Index

> Purpose: prevent research, historical snapshots and prototypes from competing with the canonical current project truth.

## Authority map

| Path | Role | Status / rule |
|---|---|---|
| `../REVIEWER_HANDOFF.md` | Current Reviewer/project truth | **AUTHORITATIVE** |
| `../00_START_HERE.md` | Navigation | Not a truth source |
| `../README.md` | Project overview/navigation | Summary only; Handoff wins |
| `../PROJECT_RECORD.md` | Legacy compatibility pointer | **DO NOT UPDATE AS CURRENT TRUTH** |
| `archive/PROJECT_RECORD_PRE_GOVERNANCE_2026-09-26.md` | Pre-governance snapshot | Historical evidence |
| `PROJECT_CHARTER.md` | Original charter | Historical baseline; some assumptions were superseded |
| `G1_DESK_RESEARCH.md` | Market/problem research | Research snapshot; not current Gate truth |
| `G1_REMAINING_RESEARCH.md` | Product/economics/WordPress research | Research snapshot; contains superseded recommendations |
| `WORDPRESS_STACK_RESEARCH.md` | Theme/plugin research | Candidate research only; no architecture approval |
| `G1_US_FIRST_EXPERIMENT.md` | US-first offer/experiment support | Supporting design; Handoff defines current Gate |
| `TECHNICAL_ROUTE.md` | Reuse-vs-custom architecture / implementation sequence | **Current supporting architecture** |
| `G2A_FRONTEND_COMPONENT_POC.md` | Legacy combined G2A pointer | **SUPERSEDED — DO NOT EXECUTE** |
| `REVIEWER_DECISION_G2A1_PASS.md` | Final Reviewer decision for G2A1 | **CURRENT REVIEW DECISION — PASS** |
| `REVIEWER_DECISION_G2A1_RETURN.md` | Earlier Reviewer return | Historical; superseded by final PASS decision |
| `G2A1R1_EVIDENCE_CLOSURE.md` | G2A1 evidence-closure execution contract | Executed / closed |
| `G2A1_COMPONENT_FEASIBILITY_POC.md` | Frontend + reusable component feasibility | Executed / **PASS at parent Gate** |
| `REVIEWER_DECISION_G2A2_PASS.md` | Final Reviewer decision for G2A2 | **CURRENT REVIEW DECISION — PASS** |
| `MVP_PRODUCT_CONTRACT.md` | Frozen MVP product contract | **AUTHORITATIVE PRODUCT CONTRACT FOR G2B** |
| `G2A2_MVP_PRODUCT_CONTRACT_FREEZE.md` | Exact MVP contract freeze | Executed / **PASS** |
| `REVIEWER_DECISION_G2B_RETURN.md` | Earlier Reviewer decision on G2B PR #30 | Historical partial RETURN; superseded for content/rendering by G2BR3 PASS |
| `G2B_LOCAL_AI_PDF_SOLUTION_PROOF.md` | Local AI → 12-page magazine → PDF proof | Executed / partial evidence accepted / overall RETURN |
| `OWNER_DECISION_G2BR1_BOUNDED_AI_CALLS.md` | Owner authorization for bounded real-AI closure | **APPROVED — MAX 3 SYNTHETIC CALLS** |
| `REVIEWER_DECISION_G2BR1_CODEX_PLUS_ROUTE.md` | Reviewer/Owner decision to use ChatGPT-authenticated Codex for G2BR1 | **CURRENT EXECUTION ROUTE** |
| `G2BR1_REAL_AI_GENERATION_CLOSURE.md` | Narrow real-AI proof closure | Executed / **RETURN — NESTED CODEX TRANSPORT FAILED** |
| `REVIEWER_DECISION_G2BR1_RETURN.md` | Reviewer decision on PR #40 | **CURRENT G2BR1 DECISION — RETURN** |
| `OWNER_DECISION_G2BR2_MAX2_HOST_CODEX_RUNS.md` | Owner authorization for G2BR2 host-context Codex runs | **APPROVED — MAX 2 REAL-MODEL RUNS** |
| `G2BR2_HOST_CODEX_TRANSPORT_CLOSURE.md` | Host-context Codex transport + real-AI closure | Executed / **RETURN** |
| `REVIEWER_DECISION_G2BR2_RETURN.md` | Reviewer decision on PR #43 | **CURRENT G2BR2 DECISION — RETURN** |
| `OWNER_DECISION_G2BR3_DIRECT_AGENT_PROOF.md` | Owner authorization for direct interactive Codex Agent proof | **APPROVED — 1 PRIMARY + MAX 1 CORRECTION** |
| `G2BR3_DIRECT_CODEX_AGENT_REAL_AI_PROOF.md` | Direct interactive Codex Agent real-AI content → PDF proof | Executed / **PASS** |
| `REVIEWER_DECISION_G2BR3_PASS.md` | Reviewer decision on PR #46 | **CURRENT G2BR3 / G2B CONTENT-RENDERING DECISION — PASS** |
| `G3A_WORDPRESS_WOOCOMMERCE_COMMERCE_LOOP.md` | Local WordPress + WooCommerce commerce/account loop | **CURRENT GATE CONTRACT — READY FOR EXECUTION** |
| `G2A2_PRODUCT_RESEARCH_2026-09-27.md` | Market / competitor / adjacent-product evidence for G2A2 | Supporting research — R1 |
| `G2A2_PRODUCT_RESEARCH_R2_DECISION_MATRIX.md` | Second-round evidence + explicit product decision matrix | **CURRENT SUPPORTING RESEARCH — NOT A FREEZE** |
| `G1_TWO_STEP_AI_PRODUCT_FLOW.md` | Two-step product-flow design | Current supporting design where consistent with Handoff |
| `ACQUISITION_GROWTH_PLAN.md` | Validation/acquisition plan | Supporting plan; not evidence of actual transactions |
| `../prototype/` | Browser sample | Prototype evidence only; not production |

## Governance rules

- Only `REVIEWER_HANDOFF.md` carries current stage, accepted decisions, current Gate, UNKNOWNs and next step.
- Research documents may contain recommendations that were later superseded. Keep them for provenance; do not rewrite history into current truth.
- Prototype code demonstrates intended interaction only unless a later Gate independently proves production behavior.
- `EXECUTOR_HANDOFF.md` and `EXECUTION_EVIDENCE.md` should be created/updated by the Execution Agent when the first execution Gate begins; they must not become architecture decision documents.
- Secret values, customer private data, payment credentials and tokens must never be stored in these documents.
