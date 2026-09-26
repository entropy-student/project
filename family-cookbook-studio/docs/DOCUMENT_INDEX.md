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
| `OCR_PIPELINE_RESEARCH.md` | Accepted PaddleOCR-primary + TrOCR-fallback MVP route and deferred alternatives | Architecture decision + research context; performance still unproven |
| `G2A1_INPUT_OCR_COMPONENT_POC.md` | Original input/OCR/reusable-component feasibility Gate | **RETURNED; partial evidence accepted** |
| `G2A1_R1_ENVIRONMENT_REMEDIATION_AND_COMPLETION.md` | OCR runtime + Family WP/Woo testbed remediation/completion | **RETURNED; local resource blocked** |
| `G2A1_R2_ISOLATED_ACTIONS_RUNNER_COMPLETION.md` | Remaining OCR + Family WP/Woo PoC on isolated GitHub Actions runner | **CURRENT GATE CONTRACT** |
| `G2A2_MVP_PRODUCT_CONTRACT_FREEZE.md` | Exact MVP contract freeze | **NEXT / HOLD** |
| `ACQUISITION_GROWTH_PLAN.md` | Demand/acquisition validation plan | Supporting plan; not transaction evidence |

## Governance rules

- Only `REVIEWER_HANDOFF.md` carries current stage, accepted decisions, current Gate, UNKNOWNs and next step.
- The two-engine OCR architecture is accepted, but its performance is not proven. G2A1 execution evidence must prove sufficiency; otherwise return to Reviewer instead of adding providers/models ad hoc.
- Future prototypes demonstrate interaction/technical feasibility only unless a later Gate proves production behavior.
- `EXECUTOR_HANDOFF.md` and `EXECUTION_EVIDENCE.md` are created by the Execution Agent when execution begins; they record facts, not architecture decisions.
- G2A1 returned execution at `codex/family-cookbook-g2a1-input-ocr-component-feasibility@b1bf844096fed4761372f3beea6f9f2d7d081643`; Reviewer accepted only the bounded partial evidence documented in `REVIEWER_HANDOFF.md`.
- G2A1-R1 returned at `f79891f20c973e93586e41319c0abb7e78b3af4c` because the user workstation had only 0.62 GiB available RAM with unrelated workloads active.
- G2A1-R2 continues on the same execution branch but moves remaining work to an isolated GitHub Actions runner; work/evidence must be committed and returned with branch + HEAD SHA + Actions run ID.
- Real customer recipe images, family stories, names, addresses, payment credentials, Secrets and private order identifiers must not be stored in ordinary project documentation.
