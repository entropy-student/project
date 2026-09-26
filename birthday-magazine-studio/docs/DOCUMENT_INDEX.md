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
| `REVIEWER_DECISION_G2A1_RETURN.md` | Reviewer decision on G2A1 evidence | **CURRENT REVIEW DECISION — RETURN** |
| `G2A1_COMPONENT_FEASIBILITY_POC.md` | Frontend + reusable component feasibility | Executed; overall PASS not granted |
| `G2A2_MVP_PRODUCT_CONTRACT_FREEZE.md` | Exact MVP contract freeze | **NEXT / HOLD** |
| `G1_TWO_STEP_AI_PRODUCT_FLOW.md` | Two-step product-flow design | Current supporting design where consistent with Handoff |
| `ACQUISITION_GROWTH_PLAN.md` | Validation/acquisition plan | Supporting plan; not evidence of actual transactions |
| `../prototype/` | Browser sample | Prototype evidence only; not production |

## Governance rules

- Only `REVIEWER_HANDOFF.md` carries current stage, accepted decisions, current Gate, UNKNOWNs and next step.
- Research documents may contain recommendations that were later superseded. Keep them for provenance; do not rewrite history into current truth.
- Prototype code demonstrates intended interaction only unless a later Gate independently proves production behavior.
- `EXECUTOR_HANDOFF.md` and `EXECUTION_EVIDENCE.md` should be created/updated by the Execution Agent when the first execution Gate begins; they must not become architecture decision documents.
- Secret values, customer private data, payment credentials and tokens must never be stored in these documents.
