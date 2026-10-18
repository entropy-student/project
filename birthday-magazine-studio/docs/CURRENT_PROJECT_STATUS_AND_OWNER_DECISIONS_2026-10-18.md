# Birthday Magazine Studio — 2026-10-18 consolidated status and Owner decisions

STATUS=REVIEWER_RECONCILED_MAIN; THIRD_PARTY_PRODUCTION_RESEARCH_ONLY; OWNER_NOT_YET_APPROVED_PROVIDER; NO_EXECUTION
Date: 2026-10-18
Scope: Birthday Magazine Studio only. **Do not confuse this status memo with a new production Gate or a change to the old Stripe phase result.**
Canonical project handoff: [REVIEWER_HANDOFF](../REVIEWER_HANDOFF.md). Applicable governance: [spike.skill/vps-project-governance/VNEXT.md](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md) v0.2.7.

## 0. Exact current bottom line

- **Already built/tested:** current WordPress/WooCommerce storefront and account/private-workspace, five-step intake UI and browser-local free Preview, local payment/refund/entitlement TEST proof (partial Stripe phase closeout), and separate *simple synthetic* G2BR3 12-page HTML/PDF prototype.
- **Not built/proven:** durable submission of 12–25 customer photos and six answers, real asynchronous paid generation, production API text/image generation, polished 6-style × 12-page design system, third-party PDF template set, real automatic customer proof/revision/download workflow, retention across all third parties, production deployment/reliable 24×7 tunnel.
- **Owner's latest explicit architectural boundary:** magazine **production must reuse mature external third-party products**, minimally configured/composed; **do not take our G2BR3 content-generation/PDF renderer as the main production technology**. Existing WordPress/Woo front end/checkout/workspace is the retained customer interface, **not** the source for new magazine-generation code.
- **Recommended after desk research, NOT an Owner-frozen stack:** [Make](https://www.make.com/) (orchestration) + [OpenAI API](https://developers.openai.com/api/) (structured editorial text plus selected generative visual assets) + [Placid](https://placid.app/) (third-party image/text layers, templates, multi-page PDF REST API). **No account, integration, template, payment or runtime validation has been performed.**
- **Current execution authority: HOLD / research & handoff only.** Do not commission 6 × 12 prompts, design pages, install SDK, buy vendor credits, call any AI API on customer photos, change WP/Stripe or merge PR64 without next Owner-specific authorization.

## 1. Chronological Owner decisions / precedence (newer supersedes only conflicting part)

| Date/stage | Accepted or directed | Scope/qualification |
|---|---|---|
| Frozen earlier MVP contract | US-first, English-first personalized **12-page US Letter PDF**; trial offer **USD 39.99**; digital first; WordPress/Woo, full prepayment five-step intake, private proof/download, one bounded revision; customer images short retention | Remains baseline unless Owner explicitly changes item. [MVP contract](./MVP_PRODUCT_CONTRACT.md). |
| 2026-10-18 visual direction | Inputs: user-uploaded photos + answers. Output: **approximately 6 style families × 12 page-role visual variants** as image/HTML, ultimately an English 12-page PDF. **One chosen style means 12 output pages/order, not 72 pages/order**. User wishes to leverage image generation. | [Owner-frozen direction](./OWNER_FROZEN_DIRECTION_IMAGE_PLUS_TEXT_TO_SIX_STYLES_TWELVE_PAGES_2026-10-18.md). **No actual page layouts, prompts, models or 72 templates approved.** |
| 2026-10-18 Owner pause | “先不要立即开始设计” / stop old speculative G4D0 execution. | [G4D0](./G4D0_MAGAZINE_P1_P12_DESIGN_DISCOVERY_AND_VISUAL_CANDIDATE_GATE_2026-10-18.md) **HOLD / DO_NOT_EXECUTE**. |
| Latest Owner production requirement | “不使用我们自己的技术，而使用别人的技术，将别人的技术进行最小改动并拼接起来”; this is about magazine **production**, not replacing the already-existing WP front end. | **Do not recommend or start proprietary G2BR3 HTML renderer or own layout/template stack** as default. Historical G2BR3 evidence stays valid as proof, not an implementation requirement. |
| Latest Reviewer finding (proposal only) | [Make+OpenAI+Placid candidate](./PROPOSAL_THIRD_PARTY_ONLY_MAGAZINE_PIPELINE_MAKE_OPENAI_PLACID_2026-10-18.md), Canva Autofill and IMG.LY alternatives | **REVIEWER_RECOMMENDATION / OWNER_SELECTION_PENDING**, not frozen choice, no budget, access, vendor account, code or design authorization. |

**Conflict-resolution note:** Historical [MVP contract](./MVP_PRODUCT_CONTRACT.md) §§5–6/12 states **3 style presets** and **no AI-generated imagery** for then-authorized G2B, and a specific P1–P12 narrative spine. **The latest explicit Owner visual direction supersedes only the visual *target* limitations** (aim ~6 styles, permit generative imagery). Do not silently freeze 72 designs, change page-role specifics without discussion, or rewrite/delete historical contract. All unrelated privacy, data, proof, price, revision, entitlement boundaries remain unless expressly overridden. If a 12-page narrative structure change becomes material, present it to Owner rather than assuming prior layout is either fully discarded or automatically accepted.

## 2. Product input/output / data and quality contract (previously accepted)

- **Prepayment core intake:** 12–25 JPG/PNG/WebP source photos, mark up to 3 must-use, select one style, recipient name/age or birthday, relationship, desired tone, **six short responses**: personality/quirks; a specific memory; admiration and why; inside jokes/little things; current interests; birthday message/wishes. Optional favorites and one must-include phrase. Full input before checkout. Free *cover Preview* optional one local photo, **no server-upload/LLM/image API** at that stage.
- **Output:** coherent, person-specific, exactly 12-page US Letter digital PDF. Page visuals may use image generation, but original photos, recipient identity, proper names/dates and quoted user phrases require accuracy. The claimed 6 × 12 refers to reusable design variants, not model generations per order.
- **Payment/entitlement:** only one canonical job after valid server-frozen intake bound to Woo paid order; failed/cancelled payment = zero generation; duplicate callbacks/retries must not multiply AI spend. Private authenticated workspace/proof; one bounded revision batch including up to 3 photo swaps, then final private download.
- **Privacy:** photos, intermediate artifacts and superseded proofs deleted **within 24h after final approval/delivery**, final PDF deleted after **72h**, per frozen MVP. These deadlines have **not been proven end to end with any third-party provider**; verify contractual provider storage, temporary URL exposures, and deletion behavior before using private customer photos.
- **Quality checks still needed:** correctly preserve names/age/date/quotes, natural-looking and identifiable photos, 12 pages, page-role coverage, no wrong/missing photos, text overflow or cropped captions, consistent chosen style, private delivery. No readiness claim until tested.

## 3. Verified engineering status

| Component | Accepted/observed | Do not overclaim |
|---|---|---|
| WP/Woo UI/account/order/workspace | Existing project-scoped WordPress local Docker/MariaDB with Woo canonical; established UI, private-account entitlement tested | Five-step full intake currently mostly **browser memory**, not secure persistent photo/answers bound to paid order; not production-ready |
| Free Preview | Works with browser-local optional photo; no model or server photo upload by contract | It is not the paid 12-page preview |
| G2BR3 | [Historical accepted independent Reviewer PASS](./REVIEWER_DECISION_G2BR3_PASS.md): synthetic 16 PNGs + human-provided direct Codex editorial content → rudimentary HTML/12-page PDF; Playwright/pdf-lib tests | Not polished commercial magazine art, not real photos, no unattended production API; Owner **does not want this as production technology** |
| Stripe TEST original USD39.99 | Original single refund and Woo refund reconciled; authenticated user access revoked | **G3S4M phase PARTIAL_WITH_EXCEPTIONS, never strict PASS or Live** |
| Separate Stripe Sandbox HKD100 | One succeeded separate TEST charge (livemode=false), **no matching local Woo order** | Origin **UNKNOWN**; not attributed to project, user or same retry; don't refund/replay without authority |
| Woo Stripe webhook duplicate | Original resend HTTP 200; original refund/access state unchanged | Exact signed-event **plugin-level duplicate acknowledgement/log NOT RETAINED**, internal idempotence **UNVERIFIED** |
| Third-party production Make/OpenAI/Placid | Official [Placid PDF REST](https://placid.app/docs/2.0/rest/pdfs) supports `pages[]` of templates/layer values and merged single PDF; official [Make Placid integration](https://www.make.com/en/integrations/placid-app) lists Create PDF and Upload Media; [Canva Autofill](https://www.canva.dev/docs/apps/rest-apis/autofill-guide/) available on Pro/Teams/Enterprise; [IMG.LY Photobook Starter](https://img.ly/docs/cesdk/js/starterkits/photobook-editor-pbedit/) available as commercial SDK | **Desk documentation only**, no provider connected and no functional full-stack test. **UNKNOWN** whether Make's native Placid “Create PDF” module exposes the full multi-page `pages[]` API; if not, use Make HTTP request to Placid REST rather than custom renderer. |
| Deployment | Owner Windows local `127.0.0.1:8189` Docker WP; public `https://magazine.spikersun.com` via a foreground named Cloudflare Tunnel | If Owner stops approved foreground PowerShell with Ctrl+C, public domain / callbacks stop until restart. WP URL may redirect localhost to public HTTPS. No permanent public uptime evidenced. |
| GitHub | Monorepo `entropy-student/project`; PR [#64](https://github.com/entropy-student/project/pull/64) verified **OPEN / UNMERGED**, HEAD `e3d2608f89afe1da8bfb6b3cb8a8964821ffbeb6` when last read | **Do not merge**, do not infer PR contains new third-party-production implementation. Main documentation updates are separate. |

## 4. Latest minimal-change third-party production proposal — not approved

```text
Existing customer intake [keep existing WP front end]
   → secure private server-side intake/order bridge [small site-specific adapter STILL NEEDED]
   → Make scenario [vendor automation; paid entitlement / dedupe / retries]
   → OpenAI text API [editorial story + 12 page content fields + selected photo plan]
   → OpenAI image API [selected creative hero assets/backdrops; preserve unedited original customer photos for exact subjects]
   → Placid designer + media upload + dynamic layers [original photos, exact text, AI art, 12 templates or 6-style page-role variants]
   → Placid REST multi-page PDF [a `pages[]` request; check native Make module support or use Make HTTP]
   → secure Woo account workspace [status, one revision, private delivery, bounded deletion]
```

This **eliminates OUR magazine production renderer**; it does *not* eliminate required template design, provider subscriptions/usage, secure integration and privacy QA. Full-page generative raster is optional research only; unless proven, using models for visual assets and template layers for exact photo/text is more controllable. Existing G2BR3 should be preserved only as archival comparison/evidence. Third-party candidates not chosen for core: `html-magazine` small agent skill, `OG Image Studio MVP` tiny renderer, other unlicensed low-star book generators; alternative mature paid Canva API/IMG.LY subject to cost/terms. [Candidate report and technical limitations](./PROPOSAL_THIRD_PARTY_ONLY_MAGAZINE_PIPELINE_MAKE_OPENAI_PLACID_2026-10-18.md).

## 5. Time/budget unknowns (estimate, NOT delivery commitment)

- Provider synthetic sandbox capability check **1–3 working days** after accounts and trial access authorized.
- One style × 12-page standalone synthetic demonstration **~5–10 working days**, subject to editorial visual template effort.
- One-style end-to-end WP private intake/delivery **~2–4 weeks total**; six professional styles and QA **~4–8 weeks total** **only rough provisional estimates**; no runtime benchmark. **This is not a fixed Gate sequence or Owner-approved schedule.**
- Placid documented default **2 credits/PDF page** under their standard page-size bound = **24 Placid PDF credits for 12 pages before** Make ops, image/text APIs, subscriptions, retries and storage; confirm actual current price/usage terms later. No payment authorization.
- **Biggest uncertain cost/time:** authoring 6 visual art directions × 12 page roles (some templates can share layers), photo text overflow/quality corrections, third-party image consent/storage, and contract/connection from browser-local intake to backend.

## 6. Two pre-Live Stripe backlog obligations and evidence

Per [formal G3S4M closeout](./REVIEWER_DECISION_G3S4M_E3D260_STRIPE_TEST_PHASE_PARTIAL_CLOSEOUT_2026-10-18.md):
1. **Read-only provenance of unmatched HKD100 succeeded Stripe TEST charge** (metadata/request IDs matched internally, masked output; if still unknown retain block).
2. **Actual signed duplicate webhook plugin-level processing instrumentation/isolated safe nonfinancial proof**, without another refund/payment/event replay.
Do not restart Stripe provider tests during magazine design research. No Live until those obligations and other security/commerce readiness checks pass.

## 7. Next Reviewer work and authority boundary

1. Read Governance v0.2.7 sections 0–10, triggered 11*, 12–13, then this status, current Handoff, [Owner-frozen direction](./OWNER_FROZEN_DIRECTION_IMAGE_PLUS_TEXT_TO_SIX_STYLES_TWELVE_PAGES_2026-10-18.md), [third-party proposal](./PROPOSAL_THIRD_PARTY_ONLY_MAGAZINE_PIPELINE_MAKE_OPENAI_PLACID_2026-10-18.md), MVP contract, Stripe closeout, PR64 status. Use [Document Index](./DOCUMENT_INDEX.md) as full evidence directory; preserve history.
2. Treat **latest Owner instruction** to use **mature other people's tech** as active boundary. Do **not** steer back to G2BR3, custom renderer, OG Image Studio MVP or 72 bespoke prompt implementations without explicit Owner change.
3. Inform Owner third-party proposal and tradeoffs; obtain approval of **specific provider/cost/data-sharing and next bounded synthetic-only feasibility Gate** before creating even a single template or calling external APIs. No automatic launch. Can independently refine read-only documentation and compare solutions.
4. First possible Gate *only once authorized*: confirm trial pricing, multi-page Placid API and Make module exposure, whether six looks require 12 or 72 templates, exact/private photo storage contract, 2-page synthetic sample via trial, how Woo persists/exports intake, how Placid PDFs reach private workspace; STOP for Reviewer review.
5. Preserve PR64 as-is; no merge, Stripe financial writes, personal data uploads, environment installs or provider contracts without scope/Owner consent.

**Reference priorities:** Owner latest instruction > accepted latest Owner direction > this Reviewer-reconciled current status/Handoff > immutable prior MVP contract/evidence > earlier research/proposals. A new Owner approval can change the course but a Reviewer proposal alone cannot.

**Readback provenance:** GitHub `main` documentation and PR64 metadata independently fetched 2026-10-18. Local machine and provider private dashboards not directly accessed in this review; evidence about local runtime and paid provider is from previously accepted Executor/Owner reports with stated qualifications.
