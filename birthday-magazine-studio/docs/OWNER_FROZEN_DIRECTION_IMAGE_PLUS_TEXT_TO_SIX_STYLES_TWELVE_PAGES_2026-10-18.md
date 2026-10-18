# OWNER FROZEN DIRECTION — Personalized magazine from photo + answers to 6 styles × 12 pages

Date: 2026-10-18
STATUS=FROZEN_OWNER_DIRECTION; RESEARCH_ONLY; NO_DESIGN_OR_IMPLEMENTATION_AUTHORIZED
Project: Birthday Magazine Studio
Authority: direct Owner instruction: "我觉得最终的模板我打算通过生图实现。大概就6种风格提示词❌12页样式设计，这是输出，输入就是用户自己的图片和填写的信息。" Owner then: "我认可，但先不要立即开始设计。这个方向先冻结记录。完成后你去网上搜搜有没有类似的……如果能找到我们就最小化改动进行复用。"

## Frozen WHAT (intent and interface only)

- **Inputs:** customer's own photos/images plus customer-provided structured free-text/form answers.
- **Target outputs:** visual magazine pages; **approximately 6 selectable visual styles × 12 page roles** for one personalized English-first 12-page digital magazine. Pages may be AI-generated imagery, image layers, or HTML/CSS rendered visuals, provided result meets personalization/fidelity needs; PDF eventual product deliverable remains original MVP, NOT yet selected as immediate renderer architecture.
- **Composition concept:** style-level prompts / visual-system rules + page-role/layout prompts or schemas + bound user photo/text variables → each magazine page, with across-page continuity. Avoid 72 unrelated prompts if a composable style × page system yields better consistency, but **modularity is a technical suggestion, not frozen implementation or a commitment to one model**.
- **Styles under study:** fashion-celebrity editorial, warm memory/scrapbook, minimalist photographic editorial, vintage newspaper, pop/youthful playful, classic biography. These six are candidate labels from research, NOT six approved final style samples or immutable prompt texts.
- **12 page roles / detailed layouts NOT FROZEN.** User has NOT approved a precise P1–P12 content map, typography, layouts, or a specific image model/provider. Do not invent an approved page contract.
- **Business/quality invariants:** preserve original identifiable people/photos without unauthorized face mutation, exact names/dates/custom factual content and readable text, coherent twelve-page visual language and exportable result. These are review/feasibility criteria, not claims any provider passes them.
- **Existing product scope:** WordPress + WooCommerce, five-step intake visual accepted, English-first 12-page digital PDF, payment-bound access and later automated delivery. Stripe TEST prior stage partial closeout with logged exceptions stays unchanged.

## Owner STOP / next authorized step

- **RESEARCH ONLY:** investigate existing open source products/frameworks and optionally services able to ingest user's photos + text and output styled page images, HTML layouts or printable magazine-like PDF. Read implementation, licenses, API/data/privacy limits, maintenance and fit to existing WP/PDF proof. Favor minimal-change **reuse** rather than a new renderer.
- **NO design execution:** no prompt engineering, no P1–P12 prototype production, no image model generating magazine pages, no code implementation, no WordPress migration, no deployment, no file/DB/customer edits, no new transaction/refund. The old G4D0 proposed "make one candidate" remains **HOLD / superseded as production plan**.
- Research produces an evidence-linked comparative report and recommendable reuse shortlist plus smallest proposed spike validation, **not a decision to implement**. User approval needed for candidate selection and revised implementation Gate.
- No new payments/Stripe/Webhook replay, no PR64 merge. Owner will discuss candidate findings and specific design/production approach later.

## Hard unknowns to evaluate in research

1. What can accept **real photo(s) as reference identity / immutable insertion**, rather than only text prompts or a single image? Can it keep original faces unchanged?
2. Can user-entered **names/quotes/dates stay byte-exact and legible**? Prefer post-render typesetting/HTML layers if diffusion model cannot assure it.
3. Can it reliably and repeatably produce **12 pages under six visual systems** with configurable aspect/page size, text/image overflow control, and PDF?
4. Is the software OSS? distinguish an OSS editor/library from a paid model API, service TOS, and hosted proprietary product. Inspect license/commercial use and third-party templates/fonts/models.
5. Can reuse as a locally callable API / Node/Python process in current WordPress stack without building a new customer-facing product?
6. Cost/time for 12 pages, privacy/storage, queue/retry and deterministic regeneration, model/provider dependency and security of customer-uploaded photos.

## Traceability

Project Handoff is authoritative for current status; this file is the specific Owner frozen direction. Future Reviewer may expand research findings elsewhere but **not alter this Owner direction** without explicit new consent.
