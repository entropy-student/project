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
| `G2A1_R2_ISOLATED_ACTIONS_RUNNER_COMPLETION.md` | OCR + Family WP/Woo PoC on isolated GitHub Actions runner | **RETURNED; component feasibility accepted, OCR observations accepted** |
| `G2A1_D1_TARGET_LANGUAGE_OCR_ACCEPTANCE.md` | Target language + review UX decision | **OWNER DECISIONS RESOLVED** |
| `G2A1_R3_OCR_ARCHITECTURE_BENCHMARK.md` | Local primary + bounded second-opinion selection | **PASS** |
| `G2A1_R3B_API_FALLBACK_OWNER_CHECKPOINT.md` | External OCR credential/budget/data boundary | **OWNER APPROVED** |
| `G2A1_R3B_API_FALLBACK_BENCHMARK.md` | Hard-case provider benchmark history | **PASS via Baidu critical-second-opinion decision** |
| `G2A1_R3B_GOOGLE_PROVIDER_SETUP.md` | Google Document AI WIF/processor setup history | **DEFERRED; technical integration proven, Billing prepayment not accepted for current test** |
| `G2A1_R3B_MISTRAL_PROVIDER_SETUP.md` | Mistral Studio/API-key setup + Free-mode probe | **DEFERRED; persistent HTTP 429 before OCR** |
| `G2A1_R3B_BAIDU_PROVIDER_SETUP.md` | Baidu Handwriting OCR free-quota setup/history | **PROVEN / 11 OF 11 CALLS SUCCESSFUL** |
| `G2A1_R3C_CODEX_PLUS_VISION_INTERNAL_BENCHMARK.md` | ChatGPT-plan Codex vision benchmark on the same 11 public hard cases | **CURRENT GATE** |
| `G2A2_MVP_PRODUCT_CONTRACT_FREEZE.md` | Exact MVP contract freeze | **HOLD until R3C closes** |
| `ACQUISITION_GROWTH_PLAN.md` | Demand/acquisition validation plan | Supporting plan; not transaction evidence |

## Governance rules

- Only `REVIEWER_HANDOFF.md` carries current stage, accepted decisions, current Gate, UNKNOWNs and next step.
- The two-engine OCR architecture is accepted, but its performance is not proven. G2A1 execution evidence must prove sufficiency; otherwise return to Reviewer instead of adding providers/models ad hoc.
- Future prototypes demonstrate interaction/technical feasibility only unless a later Gate proves production behavior.
- `EXECUTOR_HANDOFF.md` and `EXECUTION_EVIDENCE.md` are created by the Execution Agent when execution begins; they record facts, not architecture decisions.
- G2A1 returned execution at `codex/family-cookbook-g2a1-input-ocr-component-feasibility@b1bf844096fed4761372f3beea6f9f2d7d081643`; Reviewer accepted only the bounded partial evidence documented in `REVIEWER_HANDOFF.md`.
- G2A1-R1 returned at `f79891f20c973e93586e41319c0abb7e78b3af4c` because the user workstation had only 0.62 GiB available RAM with unrelated workloads active.
- G2A1-R2 evidence at `1d2abddc6e0ea58ec55c75a29033fe1233a34ada` proves WP/Woo/Kadence preview/upload/private-delivery feasibility and provides real OCR observations. The tested TrOCR-small fallback is deprecated; broader OCR product sufficiency is not decided until target language and semantic UX threshold are frozen.
- G2A1-D1 is resolved: English-first/not-English-only + one consolidated manual-edit review stage.
- G2A1-R3A PASS: `PP-OCRv6_medium` is the accepted local primary; PaddleOCR-VL-1.6 is rejected as primary.
- R3B Owner approval is granted: 11 public hard cases only, Google first, Mistral only if needed, total API test budget ≤ USD 0.20.
- R3B credential preflight at `dd9c07bbe64a3076bcfd38d27259ff56c2ed013a` originally returned for absent Google credentials.
- WIF has since replaced the blocked JSON-key approach. Processor metadata is proven accessible.
- Diagnostic run `36301652196` reached Document AI `:process` and returned `BILLING_DISABLED`; `FALLBACK=UNKNOWN` remains correct.
- Mistral Free-mode probe is blocked by persistent HTTP 429 even after bounded backoff; no OCR quality result exists.
- Owner preference is to return to Google rather than enable paid Mistral access.
- Baidu Handwriting OCR free-quota benchmark completed on all 11 fixed hard cases in Actions run `36305680927`.
- Baidu is rejected as whole-transcript replacement but accepted as critical-field second opinion: it recovered GH04 `8 eggs` while whole-transcript edit burden worsened.
- Final G2A1 OCR contract: PP-OCRv6_medium primary + Baidu critical-field second opinion + one consolidated manual-edit review.
- G2A1 is PASS. Current Gate is G2A2 MVP Product Contract Freeze.
- Real customer recipe images, family stories, names, addresses, payment credentials, Secrets and private order identifiers must not be stored in ordinary project documentation.


### R3C authority note

R3C is an internal-only evidence Gate. It does not reopen customer-data processing or production-provider authorization. The accepted production OCR path remains PP-OCRv6 + Baidu critical-field second opinion until Reviewer explicitly changes it after R3C evidence.
