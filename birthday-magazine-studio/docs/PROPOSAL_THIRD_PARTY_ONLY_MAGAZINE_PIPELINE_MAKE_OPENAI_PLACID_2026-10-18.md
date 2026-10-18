# PROPOSAL — THIRD-PARTY COMPONENTS ONLY: Make + OpenAI API + Placid

Date: 2026-10-18
STATUS=RESEARCH_PROPOSAL_ONLY; OWNER_APPROVAL_PENDING; NO_IMPLEMENTATION; NO_DESIGN_EXECUTION
Supersedes the Reviewer candidate approach **for assessment only**, NOT the frozen Owner product intent. Do not interpret this proposal as approval to install, purchase, build or run anything.

## Owner's revised requirement
Do NOT use our own G2BR3 content schema, own HTML/PDF generator, own Playwright/pdf-lib renderer, or OG Image Studio's small MVP core. Keep existing customer-input storefront as a boundary only (WordPress/WooCommerce five-step intake, payment/workspace). **All magazine production functions should come from mature, third-party existing products with minimal configuration and integration**. Owner's frozen outcome remains photos+answers→one of ~6 style families × 12 editorial page roles→12-page PDF, with AI creative visual work.

## Rank after renewed verification (2026-10-18)

| Tier | Third-party combination | Why | Material limit |
|---|---|---|---|
| **A, proposed choice** | [Make](https://www.make.com/en/) + [OpenAI API](https://developers.openai.com/api/) + [Placid](https://placid.app/) | Native Make WooCommerce integration, OpenAI text/image modules + official Placid Create PDF/Upload Media integration. Placid REST `POST /api/rest/pdfs` takes `pages:[{template_uuid,layers}]`, generates full merged multipage PDF **directly**; no custom JS renderer, Chrome, pdf-lib, full SDK or server needed for production pages. | **Not one-click magic:** one-time design of page layouts/template IDs and input field mapping; image/text privacy and storage, small secure WordPress data bridge, longer-content overflow, external paid SaaS. |
| B | [Make](https://www.make.com) + OpenAI API + [Canva Connect Autofill](https://www.canva.dev/docs/apps/rest-apis/autofill-guide/) | Strong editor/visual templates and automated text/image field binding + PDF export. **As of Sep 23 2026, Autofill officially available on Canva Pro/Teams/Enterprise**, no longer Enterprise-only. | OAuth acting as user with paid Canva account; configuring autofillable data fields, async jobs, export and public integration terms; not as directly aligned with anonymous customer input→single PDF REST job; still author brand magazine designs. Older docs suggesting Enterprise-only are stale. |
| C | [IMG.LY Photobook Editor starter](https://img.ly/docs/cesdk/js/starterkits/photobook-editor-pbedit/) + image AI | Official auto-fill of user photos+texts, layout library, validation, PDF/X; very close to personalized photobook. Supports Node rendering | SDK licensed commercially with quote, initial React/TS + scene/assets+Node service integration, not smallest retrofit into existing WP; templates and style scenes still must be authored. |
| D | Small GitHub agents/repos | Style ideas, proof components | Insufficient maturity/maintenance, missing licenses, incompatible editor; not recommended core. |
| E | self-host [n8n](https://n8n.io) + Placid | Verified Placid community node and Woo triggers; own workflow hosting possible | **Commercial licensing requires analysis** for SaaS backend, see [n8n OEM/backend clarification](https://n8n.io/oem/); Make avoids backend/OEM interpretation and operation overhead for fastest launch. The 2026-10-06 [SUL Help Center](https://support.n8n.io/article/can-i-use-your-license-for-my-use-case) nuances internal/client output-only use; seek counsel for a product backend. |

## Selected architecture — exact existing provider modules

1. **Existing WordPress front-end ONLY**: customer selects one visual style; uploads 12–25 original photos; answers name, age/birthday, relationship, personality/interests, 2–3 actual memorable episodes and short messages. Forms currently largely browser-local; production still needs authenticated persistent upload and a server-to-Make data contract (minimal site-specific bridge; **cannot be eliminated just by using APIs**). No customer images until data/privacy contracts approved.
2. **Make scenario**, via WooCommerce order event or an authenticated custom webhook tied to authorized paid order; validates order job id and deduplicates by exact order+revision; reads photo IDs/secure files and fields. This is automation wiring/configuration, not custom magazine-generation code. Make has documented WooCommerce + OpenAI + official Placid modules.
3. **OpenAI structured text generation**, configured in Make: produce a 12-page content manifest (page role, short exact headline/captions/story blocks, photo IDs, AI asset prompts) using user's evidence. This is 3rd-party LLM, **not G2BR3**; contract still must be authored minimally as Make mapping/JSON schema and validated (names, dates, verbatim quotes).
4. **OpenAI Images edits/generations API**, configured in Make: selectively generate 2–4 core artistic visuals for cover and feature pages with chosen editorial style; optional more per-page for quality. **Do not instruct model to generate dense exact text** or blindly transform all photos; preserve originals in separate Placid image layers. A true whole-page one-model bitmap version may be evaluated later, but is not safe primary option. Cost/latency and visual QA not benchmarked.
5. **Placid Upload Media** (first-party Make module) transfers original customer photo files + AI artistic assets, returning Placid media references; provider storage and retention policy/privacy must be independently confirmed.
6. **Placid multi-page PDF API**, first-party Make `Create PDF` module: pre-authored 12 page-role templates in Placid drag-and-drop designer; map dynamic picture/text/colors/font to layers, choose one of six thematic variants; send a 12-item `pages` list (one template UUID/page) **in one PDF generation request**, wait webhook/poll for `finished`, return PDF. This replaces *all* G2BR3 renderer, OG Image Studio, Playwright, pdf-lib, Paged.js. Dynamic layer API supports `text_color`, `font`, picture `image`, and shapes; some styles can share page templates (12 roles × style parameter), but visually distinct designs may still require up to 72 authored templates. **No promise of fully dynamic 6x12 distinct high-quality layouts from six plain prompts without page authoring.**
7. **Make secure delivery handoff** returns approved generated PDF to existing private WordPress work area or private object storage via minimal authenticated site bridge. Add status, async exception path, retry/idempotency budget, check 12 pages + legibility/overflow/photo mismatches, bounded source/intermediate deletion and provider media retention confirmations. For launch the existing site must be continuously reachable; the previously Owner-controlled **foreground Cloudflare Tunnel is NOT always-on production hosting**.

## Development difficulty: honest bounded estimates (one skilled developer with AI coding assistant; configuration still takes work)

| Scope | Calendar effort (rough working days; not a quote) | What this covers |
|---|---|---|
| Vendor sandbox viability check | 1–3 d | Register trial accounts, use synthetic photos/text, show one Placid template fill and two-page combined PDF + OpenAI art; no real photo/order. |
| One chosen style, 12-page standalone *demo* | **5–10 d** | Author ~12 page layouts in Placid, Make/OpenAI manifest+image+PDF+quality checks, synthetic fixture; no real storefront or billing. |
| Single style + actual WordPress form/secure job/delivery | **~2–4 weeks total** | Persist data, file privacy, Make webhook, retries, valid 12 pages, test order scope, access revocation, retention and fallback. |
| All six polished styles, production-fit QA | **~4–8 weeks total** | ~6 visual style rule sets, 12 page roles (and possibly much more than 12 concrete visual templates), content-length/photo variability tests and QA. Real world may take longer if 72 manual designs or vendor/privacy limitations. |

**Output economics:** Official Placid base is **2 credits per PDF page for page size up to 4,000px longest side**; 12 × 2 = **24 Placid credits per standard PDF magazine**, *before* model API expenses and Make operations. Higher-resolution rasterized PDFs may cost more; vendor [credit details](https://placid.app/help/how-do-placid-credits-work). [Make pricing](https://www.make.com/en/pricing): free plan plus Core shown as $12/month for 10k credits, **at 2026-10-18 search**; price/region/volume variable. Placid Basic **500 credits/mo** published, visible price not reliably retrieved from current dynamic page; do not invent dollar price.

## One essential feasibility fork

If "6 styles × 12 pages" means **72 artistic presentations** per user, API render/generation volume and cost explode. The sensible frozen interpretation is **72 reusable combinations / template/style configurations** (or fewer if style variables sufficient), but **only 12 output pages for a customer who chooses one style**. Creative per-user image generation is primarily hero visual/background, with exact source photos and quotes inserted by deterministic Placid layers. Thus it is still *generative visual design*, not merely twelve stock photo album pages.

## Sources checked from provider's official docs

- [Placid multitemplate PDF `pages[]`](https://placid.app/docs/2.0/rest/pdfs), [dynamic image/text/color/font layers](https://placid.app/docs/2.0/rest/layers), [Upload Media](https://placid.app/docs/2.0/rest/media).
- [Make native WooCommerce + OpenAI](https://www.make.com/integrations/woocommerce/openai-gpt-3), [Make Placid integration](https://www.make.com/en/integrations/placid-app), [Make pricing](https://www.make.com/en/pricing).
- [OpenAI image edits multi-image](https://developers.openai.com/api/reference/resources/images/methods/edit).
- [Canva Autofill Pro 2026 announcement](https://community.canva.dev/t/autofill-apis-are-now-available-on-canva-pro-and-above/8922), [Canva Autofill guide](https://www.canva.dev/docs/apps/rest-apis/autofill-guide/).
- [IMG.LY photobook starter](https://img.ly/docs/cesdk/js/starterkits/photobook-editor-pbedit/), [IMG.LY licensing/pricing](https://img.ly/pricing/?product=vesdk).
- [n8n licensing](https://n8n.io/oem/), [license help](https://support.n8n.io/article/can-i-use-your-license-for-my-use-case).

## Status / governance

No new G4D0 design or 6×12 prompt/template created, no trial account/provider keys accessed, no Make/Woo/webhook changes, no code changes, no new charge. G4D0 remains on HOLD. Stripe phase remains PARTIAL with prior pre-Live obligations. This alternative route **replaces previous recommendation only in advisory content**, not the Owner frozen product direction or executed project state. Owner must choose/pay/authorize separate sandbox Gate before implementation.
