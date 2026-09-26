# Family Cookbook Studio — Document Index

> Purpose: prevent research, plans and future prototypes from competing with the canonical current project truth.

## Authority map

| Path | Role | Status / rule |
|---|---|---|
| `../REVIEWER_HANDOFF.md` | Current Reviewer/project truth | **AUTHORITATIVE** |
| `../00_START_HERE.md` | Navigation | Not a truth source |
| `../README.md` | Project overview/navigation | Summary only; Handoff wins |
| `../PROJECT_RECORD.md` | Legacy compatibility pointer | **DO NOT UPDATE AS CURRENT TRUTH** |
| `PROJECT_CHARTER.md` | Initial charter | Historical/strategic baseline |
| `TECHNICAL_ROUTE.md` | Reuse-vs-custom architecture, theme shortlist, free/paid compute boundary | **CURRENT SUPPORTING ARCHITECTURE** |
| `OCR_PIPELINE_RESEARCH.md` | OCR/handwriting recognition candidates and accepted benchmark order | Research + test strategy; not implementation proof |
| `G2A1_INPUT_OCR_COMPONENT_POC.md` | Input/OCR/reusable-component feasibility | **CURRENT GATE CONTRACT** |
| `G2A2_MVP_PRODUCT_CONTRACT_FREEZE.md` | Exact MVP contract freeze | **NEXT / HOLD** |
| `ACQUISITION_GROWTH_PLAN.md` | Demand/acquisition validation plan | Supporting plan; not transaction evidence |

## Governance rules

- Only `REVIEWER_HANDOFF.md` carries current stage, accepted decisions, current Gate, UNKNOWNs and next step.
- Research documents may contain candidates; the accepted **benchmark order** does not mean a candidate has passed. Production selection still requires execution evidence and Reviewer acceptance.
- Future prototypes demonstrate interaction/technical feasibility only unless a later Gate proves production behavior.
- `EXECUTOR_HANDOFF.md` and `EXECUTION_EVIDENCE.md` are created by the Execution Agent when execution begins; they record facts, not architecture decisions.
- Real customer recipe images, family stories, names, addresses, payment credentials, Secrets and private order identifiers must not be stored in ordinary project documentation.
