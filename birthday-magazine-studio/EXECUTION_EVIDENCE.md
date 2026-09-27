# Birthday Magazine Studio — Execution Evidence

## Current Gate — G2BR3 Direct Codex Agent Real AI Proof

- **Gate:** `G2BR3_DIRECT_CODEX_AGENT_REAL_AI_PROOF`
- **Execution date:** 2026-09-27
- **Branch:** `codex/birthday-magazine-g2br3-direct-agent-proof`
- **Base:** latest GitHub `main` at `491a7eab7721bd9876e1ebc1292cfc382949c061`
- **Result:** `PASS_CANDIDATE_G2BR3_DIRECT_AGENT_REAL_AI_PROOF`; Reviewer decision required; this is not a formal PASS.
- **Stop point:** `STOP_AT_REVIEWER=YES`; `G3_STARTED=NO`.

### Direct model generation and provenance

The current interactive Codex Agent authored `poc/g2b/artifacts/g2br3/generated-content.json` directly from the synthetic intake and the existing `CONTENT_SCHEMA`. There was exactly one primary generation and zero correction generations. The first JSON Schema validation passed with zero errors, so the authorized correction was not used. The historical `reference-content.json` was not opened/read, copied, adapted, or used as fallback. The strict content JSON contains no provenance-only extra fields; `model-execution-status.json` and `generation-provenance.json` record the required flags and bind provenance to the content SHA-256.

```text
MODEL_AUTHORED_BY_INTERACTIVE_CODEX_AGENT=YES
REFERENCE_FIXTURE_FALLBACK=NO
REAL_MODEL_RUN_COUNT=1
SUCCESSFUL_GENERATION_COUNT=1
CORRECTION_GENERATION_COUNT=0
API_KEY_USED=NO
NESTED_CODEX_EXEC_USED=NO
G3_STARTED=NO
```

The current authenticated ChatGPT interactive session authored the content. The project did not invoke a model-provider API or nested Codex process. Production provider integration remains deferred for a later Owner decision.

### Validation, grounding and modules

- `synthetic-intake.json` snapshots the accepted G2B fictional Mira Vale fixture: six completed narrative answers, 16 deterministic synthetic illustration files, and three must-use IDs (`photo-01`, `photo-02`, `photo-04`). The product contract was not changed.
- `content-schema.json` is exported from the existing `src/provider.mjs` `CONTENT_SCHEMA`. `structured-schema-report.json` records `PASS`, 0 errors, and the SHA-256 of the generated content.
- `grounding-report.json` records 12 grounded fact claims, 17 exact intake excerpts, resolving source references, and the birthday/age check. Every content unit carries sourceRefs; the executor reviewed the synthetic prose against those cited answers.
- Exactly two distinct supported modules passed: The Lore / inside jokes (Q2/Q4) and Current Obsessions (Q5).
- `photoMapping=PASS_METADATA_ONLY`: 12 unique images were selected from 16 using the accepted deterministic synthetic metadata ranking. All three must-use photos are assigned. This is not a visual-semantic photo understanding claim.

### Renderer, PDF and deterministic QA

The existing page architecture and renderer produced `proof-magazine-soft-warm.pdf`: 12 US Letter pages (612 × 792 points each), 379,787 bytes, SHA-256 `a3ed604ae21119d9a073474463dd11d898329b826ce3ed9215a6f59e972f044a`. `pdf-lib` opened the PDF and read 12 pages. Browser read-back found all required page sections, consistent recipient fields, every image loaded, no measured text overflow, and no page overflow. The 375px viewport has no horizontal or text overflow. All 15 existing negative QA mutations were rejected.

Bold Editorial, Soft / Warm, and Retro / Playful retain the same page-architecture hash `fb70862addef3f032be9319d345a98f638bd057c415f24c3c12bd4a21a309ea8`. The browser renderer made 93 loopback requests and 0 external browser requests. Screenshots and a 12-page contact sheet are committed under `poc/g2b/artifacts/g2br3/screenshots/`.

`idempotency-report.json` is explicitly `NOT_TESTED_DIRECT_AGENT_NO_PROVIDER_BOUNDARY`: this proof did not create a provider job or test production provider spend idempotency. No idempotency PASS is claimed for G2BR3.

### Durable artifacts and runtime

The `poc/g2b/artifacts/g2br3/` directory contains the generated content, synthetic intake snapshot, schema snapshot, schema/grounding/QA reports, provenance/status, idempotency limitation, PDF, screenshots, style proof, dependency report, run summary, and SHA-256 manifest. Dependencies/runtime: Node.js 24.19.0; Playwright 1.62.1 (Apache-2.0); pdf-lib 1.17.1 (MIT); Chrome 153.0.8010.54.

No API key, additional credits, real customer data, payment, PayPal, production provider, public deployment, VPS, Cloudflare/Shared Infra change, or G3 work occurred. `MVP_PRODUCT_CONTRACT.md` and Reviewer-owned `REVIEWER_HANDOFF.md` are unchanged. The only shared-pipeline code change adds G2BR3 provenance labeling so the accepted validator/renderer can classify direct interactive Agent output accurately; schema, renderer layout and page architecture were not changed.

### GitHub review handoff

- Branch: `codex/birthday-magazine-g2br3-direct-agent-proof`, from `491a7eab7721bd9876e1ebc1292cfc382949c061`.
- Evidence commit: `0b5c3ef4ff2e6581efc021fa2c62700d1f44af2b`.
- Reviewer PR: [#46 — G2BR3 direct interactive Codex Agent real AI proof](https://github.com/entropy-student/project/pull/46), open against `main`, unmerged. The final Evidence/Handoff reconciliation is pushed as a follow-up commit on this PR.
- GitHub `main` advanced from the execution base `491a7eab7721bd9876e1ebc1292cfc382949c061` to `da09dd1b0e83e614c18980ca043ffab359cd963a` while this run was in progress; the intervening commits concern unrelated mini-craft documentation. PR #46 targets `main`.
- Reviewer is the next decision point. This execution does not make the formal Gate decision or start G3.



## Current Gate — G2BR2 final host result

- **Gate:** `G2BR2_HOST_CODEX_TRANSPORT_AND_REAL_AI_CLOSURE`
- **Date:** 2026-09-27
- **Branch:** `codex/birthday-magazine-g2br2-host-codex-closure`
- **Base:** GitHub `main` at `d3249013f01fdc60b2fc728d0a8f197255643182`.
- **Result:** `RETURN_CODEX_CHATGPT_LOGIN_REQUIRED`; this is not PASS or PASS_CANDIDATE.
- **Stop point:** `STOP_AT_REVIEWER=YES`; G3 not started.

### Bounded real-model attempts

| Attempt | Transport/provider | Result | Safe diagnostic |
|---|---|---|---|
| 1 | Default Codex provider | `RETURN_CODEX_EXEC_FAILED` | `WEBSOCKET_FAILURE`; retry category `TRANSIENT_RUNTIME` |
| 2 | `g2br2_chatgpt_http`, HTTP-only Responses | `RETURN_CODEX_CHATGPT_LOGIN_REQUIRED` | `AUTHENTICATION`, HTTP 401; retry category `null` |

```text
Host codex login status immediately before attempt 2: Logged in using ChatGPT
Codex CLI: 0.149.1
Authorized/consumed model runs: 2 / 2
Successful structured responses: 0
schemaConstrained: true
apiKeyUsed: false
retryCategory after attempt 2: null
```

The preflight result records the host CLI login state. The HTTP-only custom provider request still received HTTP 401; this evidence does not establish successful authentication with that provider. Both actual model-run slots are consumed. No third run or additional retry is authorized or performed.

### AI pipeline result

```text
grounding: NOT RUN (no structured model output)
actual-AI PDF: NOT RUN
deterministic AI QA: NOT RUN
G3: NO
```

No G2BR2 generated-content JSON or actual-AI PDF exists. `poc/g2b/fixtures/reference-content.json` remains only the historical, human-authored G2B renderer fixture and was not used or represented as AI output. The final G2BR2 result is a RETURN because the model output needed for grounding, rendering and QA was not produced.

### Transport repair and scope

- Attempt 2 used the per-invocation custom provider `g2br2_chatgpt_http` with `requires_openai_auth=true`, `supports_websockets=false`, `wire_api="responses"`, and the ChatGPT Codex backend. Its scope was `PER_INVOCATION_CODEX_EXEC_OVERRIDES`.
- The G2BR2 retry reused the accepted G2B/G2BR1 fixture, `CONTENT_SCHEMA`, prompt builder, canonical-job helper, grounding checks, deterministic renderer, PDF path and QA. No product contract, schema, renderer or page architecture was changed.
- No API key or additional credits were used or purchased. No global `~/.codex/config.toml` or project config was changed. G2BR1 history and artifacts remain unchanged.

### Durable sanitized evidence

The final `poc/g2b/artifacts/g2br2/model-execution-status.json` and canonical record under `poc/g2b/artifacts/g2br2/jobs/` retain both attempt outcomes, the two-run count and the HTTP 401 category/status. The synthetic prompt and schema remain alongside them. No token, session/account identifier, cookie, auth header, raw URL credential or raw provider log is recorded.

### GitHub review handoff

- Branch: `codex/birthday-magazine-g2br2-host-codex-closure`, based on `d3249013f01fdc60b2fc728d0a8f197255643182`.
- Final evidence commit: see the current branch head.
- Existing Reviewer PR: [#43 — Prepare G2BR2 host Codex launch path](https://github.com/entropy-student/project/pull/43), open against `main`, unmerged; updated with the final sanitized attempt evidence and this handoff.
- Reviewer is the next decision point. Do not retry, use an API key, or enter G3.

No payment, PayPal, customer data, public deployment, VPS, Cloudflare/Shared Infra change or G3 action occurred. `MVP_PRODUCT_CONTRACT.md` and Reviewer-owned `REVIEWER_HANDOFF.md` are unchanged. `namespace.json` retains the initial preparation snapshot and is not the final run-count evidence.

## Current Gate — G2BR1 Real AI Generation Closure

- **Gate:** G2BR1_REAL_AI_GENERATION_CLOSURE
- **Execution date:** 2026-09-27
- **Branch:** codex/birthday-magazine-g2br1-real-ai-closure
- **Base:** GitHub main at c22f1478973bcee11097c2473ee726925613fc81
- **Result:** RETURN_CODEX_EXEC_FAILED
**Stop point:** STOP_AT_REVIEWER=YES; G3 not started.

### Result separation

| Boundary | Result | Evidence |
|---|---|---|
| Existing G2B intake, photos, schema and renderer | **REUSED** | No fixture or renderer rebuild; accepted baseline remains under poc/g2b/fixtures/ and poc/g2b/src/proof.mjs. |
| ChatGPT login preflight | **PASS** | Both local Codex CLI installations reported ChatGPT login. A first wrapper preflight issue (login text was on stderr) was corrected before any model process started. |
| Codex execution | **RETURN_CODEX_EXEC_FAILED** | Three codex exec child processes started, each exited with code 1; the 3-attempt cap is exhausted. |
| Structured AI output | **NOT PRODUCED** | Successful structured responses = 0; no generated-content.json was created. |
| Grounding and dynamic modules | **NOT RUN** | No successful AI JSON existed to audit. |
| Actual AI PDF and deterministic QA | **NOT RUN** | No G2BR1 PDF or G2BR1 screenshots were produced. The prior G2B reference PDF is not AI output and is not counted here. |
| Duplicate-generation guard | **PASS — failed-job duplicate path only** | A later invocation was rejected before a fourth codex exec; the canonical record remained at 3 invocations and 0 successful generations. This does not pass the overall G2BR1 Gate. |

### Codex attempt record

- Authentication mode was the local ChatGPT login; OPENAI_API_KEY was absent, no API key or account/session identifier was written, and no extra credits were purchased or reset.
- Attempt 1 used Codex CLI 0.155.0-alpha.16.3; it exited nonzero. The initial wrapper did not retain diagnostic output.
- Attempt 2 used Codex CLI 0.155.0-alpha.16.3; it exited 1. The sanitized diagnostic classifier recorded NETWORK_OR_TRANSIENT.
- Attempt 3 used Codex CLI 0.149.1; it exited 1. The sanitized diagnostic classifier recorded NETWORK_OR_TRANSIENT.
- No model identifier was exposed because no Codex process returned a final response.
- The safe diagnostic is a category, not a verified root cause. A TCP check to chatgpt.com:443 succeeded, which does not establish connectivity to the Codex inference route.
- The initial runner preflight rejection was corrected before model execution and did not start a model process. The three process starts above are the complete bounded attempt count.
- No retry remains within this Gate. No purchase or reset was made.

### Local implementation and durable evidence

The branch adds the Codex provider wrapper, G2BR1 orchestration runner, shared canonical-job helper, and G2BR1-mode renderer path. The runner sends the synthetic prompt under --output-schema, strips API-key/endpoint overrides from the child environment, rejects duplicate canonical jobs before provider construction, and never falls back to the human-authored reference fixture for a G2BR1 pass.

Sanitized files retained under poc/g2b/artifacts/g2br1/:

- content-schema.json and synthetic-generation-prompt.txt — inputs to the attempted structured generation.
- model-execution-status.json — CLI versions, invocation count, sanitized outcomes and no-output status.
- jobs/<sha256>.json — one synthetic canonical job, three failed process attempts, zero successful generations.
- idempotency-report.json — follow-up duplicate rejected before a fourth Codex process.

The branch has no G2BR1 generated JSON, grounding report, QA report, PDF or screenshots because the provider did not return structured content. The G2B human-authored reference JSON and PDF remain only historical baseline evidence below.

### Forbidden-action record

No payment, PayPal, API key, AI imagery, real customer data, production email, VPS/public deployment, Cloudflare/Shared Infra change, paid purchase, or G3 work occurred. The product contract and Reviewer-owned handoff were not edited.

### GitHub review handoff

- Branch: codex/birthday-magazine-g2br1-real-ai-closure, based on main commit c22f1478973bcee11097c2473ee726925613fc81.
- Initial implementation/evidence commit: 8de30bfd295a916e8f620fe290b418490746b66d.
- PR: [#40 — G2BR1 bounded Codex execution return](https://github.com/entropy-student/project/pull/40), open against main and unmerged. The PR head contains the final Evidence/Handoff reconciliation.
- Reviewer remains the next decision point; no merge or G3 work is authorized in this execution.

## Historical Gate — G2B Local AI/PDF Solution Proof (accepted partial baseline)

**Gate:** G2B_LOCAL_AI_PDF_SOLUTION_PROOF  
**Execution date:** 2026-09-27  
**Branch:** codex/birthday-magazine-g2b-local-ai-pdf-proof  
**Base:** GitHub main at 77186cac9b01009c401be23e27c998c2b27ee339  
**Result:** RETURN_AI_PROVIDER_CREDENTIAL_REQUIRED  
**Stop point:** STOP_AT_REVIEWER=YES; G3A/G3B not started.

### Result separation

| Boundary | Result | Evidence |
|---|---|---|
| Synthetic intake validation | **PASS** | poc/g2b/artifacts/qa-report.json |
| Deterministic reference render pipeline | **PASS — renderer reference only** | 12-page PDF and browser/PDF QA below |
| Real structured AI generation | **BLOCKED** | No approved protected provider credential/runtime is supplied by the current project handoff/G2B authorization. No model request was made. |
| Grounding | **PASS — human-authored reference fixture only** | 10 fact records; 9 exact source excerpts plus age/date arithmetic; this is not a live-AI grounding result. |
| Metadata photo mapping / must-use | **PASS — metadata only** | 16 source PNGs, 12 unique selected/mapped, all 3 must-use images included. No visual-semantic model was used. |
| Two dynamic modules | **PASS — reference fixture only** | The Lore / inside jokes and Current Obsessions; distinct and supported by Q4/Q5 fixture text. |
| PDF and deterministic QA | **PASS — reference pipeline only** | 12 pages, each US Letter 612 × 792 pt; 376,319 bytes; opens with pdf-lib; SHA-256 82647bf4bc8b178dca8597b1cd25d7f6c96782d223a47904780481a68426205b. Two consecutive renders produced the same size and hash. |
| Local idempotency boundary | **PASS** | One canonical active synthetic job; duplicate rejected before provider boundary; model spend attempts = 0. |

The content fixture at poc/g2b/fixtures/reference-content.json is explicitly human-authored and synthetic. It proves the renderer's downstream input contract only; it is **not** AI-generated content and must not be presented as AI proof.

### Intake, content and photo evidence

- poc/g2b/fixtures/intake.json contains fictional recipient Mira Vale, age 25 on fixture date 2026-09-27, an older-sister relationship, balanced tone, optional pronouns, six complete narrative answers, quick facts, style soft-warm, 16 non-private PNG scene fixtures, and 3 must-use markers.
- Required factual fields, six answers, photo count/type/bytes, age/date consistency, evidence cues and must-use limit passed. Incomplete answers, 11/26 photos, unsupported type and four must-use markers fail closed. The runner validates intake before claiming a generation job or approaching a provider.
- The selected set is 12 unique images. Must-use IDs photo-01, photo-02, photo-04 are all assigned. P4–P5 use Q2-linked metadata; P8–P9 use Q5-linked metadata. P10's Current Obsessions module uses the Q5-linked Sunday-walk/music image.
- The PNG images are deterministic geometric illustrations generated from local SVG scene markup with Playwright. They contain no people or private/customer photos and are not AI-generated. The deterministic metadata cues prove supported-file selection/mapping, not photographic visual understanding.
- Grounding audit checks every structured source reference, exact supporting excerpts, age/birthday arithmetic, and module source eligibility. The audit is limited to the human-authored reference content; semantic entailment of future model prose still needs actual model output review.

### Page, style, PDF and QA evidence

The one shared page schema rendered the frozen map: P1 cover; P2 opening note; P3 profile; P4–P5 memory; P6 module A; P7 why they matter; P8–P9 current-era photo story; P10 module B; P11 birthday letter; P12 back cover. No contents page or extra page was added.

Bold Editorial, Soft / Warm, and Retro / Playful use the same page-layout hash fb70862addef3f032be9319d345a98f638bd057c415f24c3c12bd4a21a309ea8; browser read-back found distinct palette/frame variables and identical 12-page layout order. The complete PDF uses Soft / Warm.

Deterministic QA passed all 15 negative mutation checks, including missing required answer, photo count/type/must-use limits, duplicate/unsupported module, unsupported source quote, omitted must-use image, unknown photo ID, missing page, overlong copy, browser-measured text overflow, broken image detection and missing provider credential fail-closed behavior. Actual browser read-back found 12 required sections, consistent name/age/birthday, all images loaded, no clipping/overflow, and no duplicate unique photo assignments.

poc/g2b/artifacts/qa-report.json records PDF page sizes, file size/hash, browser results, negative checks, style proof, local network counts and limitations. The browser ran against a short-lived 127.0.0.1 server: 93 local renderer requests, 0 external browser requests, 0 AI API requests.

### Durable artifacts

- PDF: poc/g2b/artifacts/proof-magazine-soft-warm.pdf
- Contact sheet: poc/g2b/artifacts/screenshots/12-page-contact-sheet.png
- Desktop: cover-soft-warm-desktop.png, feature-memory-desktop.png, current-era-desktop.png, birthday-letter-desktop.png
- 375px: cover-soft-warm-375px.png (375px document/page width; no horizontal or text overflow)
- Other preset covers: cover-bold-editorial-desktop.png, cover-retro-playful-desktop.png
- Reports: qa-report.json, grounding-report.json, idempotency-report.json, style-proof.json, ai-provider-status.json, dependency-report.json, artifact-hashes.json, run-summary.json
- Fixture and provider contract: poc/g2b/fixtures/, poc/g2b/src/provider.mjs

### Runtime, dependency and cleanup evidence

- Node.js 24.19.0; Playwright 1.62.1 (Apache-2.0); pdf-lib 1.17.1 (MIT); Google Chrome 153.0.8010.54. Exact npm package versions are pinned in package.json / package-lock.json.
- Playwright printed the actual PDF as US Letter; pdf-lib parsed it and independently read all 12 page sizes. No PDF screenshot was substituted for the PDF.
- Dependency installation contacted npm for the pinned open-source packages. The proof runtime made no request to an AI/model endpoint or any non-loopback browser origin.
- Temporary local job registry, loopback HTTP server, browser process, and project-local `node_modules` were removed/stopped after capture. No Docker container, WordPress runtime, email, payment, public route or service was created. Generated synthetic fixture PNGs, PDF, screenshots and reports are deliberate retained evidence.
- No secrets, real customer data, payment data or external provider calls were used. MVP_PRODUCT_CONTRACT.md and REVIEWER_HANDOFF.md were not modified.

### Git submission state

Pushed implementation commit: 8b39e1ab9261d4bcf610f04add5059c4d791f4c4 on codex/birthday-magazine-g2b-local-ai-pdf-proof.
Reviewer PR: [#30 — G2B local AI-to-PDF solution proof](https://github.com/entropy-student/project/pull/30), open against main and unmerged.
This Evidence/Handoff reconciliation is included as a follow-up commit on the same PR.

---

# G2A1 Execution Evidence — Frontend and Reusable Component Feasibility (historical, preserved)

**Original Gate:** `G2A1_FRONTEND_AND_REUSABLE_COMPONENT_FEASIBILITY_POC`
**Original execution date:** 2026-09-26
**Current closure Gate:** `G2A1R1_EVIDENCE_CLOSURE`
**R1 closure date:** 2026-09-27
**Original G2A1 branch:** `codex/birthday-magazine-g2a1-component-feasibility`
**R1 closure branch:** `codex/birthday-magazine-g2a1r1-evidence-closure`
**Pushed evidence commit:** `5ae191b61e2323657c422a22b927cd3845fc5ec3` (ancestor of the current PR head)
**Reviewer PR:** [#22 — G2A1R1 guest evidence closure](https://github.com/entropy-student/project/pull/22), open against `main`, unmerged
**Environment:** disposable local Docker Compose stack at `http://127.0.0.1:8127`; WordPress 7.0.4, PHP 8.3.33, MariaDB 11.4.13, WooCommerce 11.1.2; local Mailpit v1.31.2 added for G2A1R1.
**Scope:** synthetic inputs, no external payment, no customer data, no AI/API credentials, no production or public host.

## Result summary

| Question | Evidence-based finding |
|---|---|
| Frontend route | Route C is the only route that met the current browser-local preview and WooCommerce-path requirements in the installed runtime. It is a Good Issue-style experience rendered by a small WordPress plugin/shortcode and links to a native WooCommerce product. This is a feasibility preference for Reviewer consideration, not a product/contract decision. |
| Storelly | Not accepted for the free preview. The free builder’s image editor uploads to the WordPress server, so a selected photo leaves the browser. In addition, the tested Storelly product page raised a PHP fatal error and returned HTTP 500. Storelly Cloud was not connected. |
| Upload Files | Registered-account order binding, two one-file slots, and the 375px account upload passed. Guest order page could not be fully verified because WooCommerce requires email verification and this local environment has no working mail transport. Return the guest path for Reviewer decision. |
| Attach Me | Registered order access control passed positive and negative checks; direct uploads URL was denied. Guest order delivery was not fully verified because the same WooCommerce email verification step could not be completed. Return the guest path for Reviewer decision. |
| Commerce | Each preview CTA reached the $39.99 WooCommerce product, add-to-cart and cart. Checkout rendered but had no payment method configured. No payment was attempted or submitted. |

## Current G2A1R1 closure result — supersedes the earlier guest-path gaps below

The original G2A1 findings remain historical context. This section records the later guest-order checks and controls the current handoff. The Gate remains open for Reviewer because both plugins' guest download links were replayable from an unrelated guest context.

| Check | Latest result | Evidence |
|---|---|---|
| Local email capture | **PASS** | Mailpit `axllent/mailpit:v1.31.2` (MIT; image digest `sha256:74d609a42ec279aa63c6b4622a6fa9b5408d1ad5b1d76a1c4be40a265ce0863d`). The service UI binds to `127.0.0.1:8128`; SMTP port 1025 has no host port mapping and is reachable by Compose services only. A synthetic `.invalid` `wp_mail()` probe was captured and the inbox was cleared. Guest verification began and ended with zero captured messages: this WooCommerce 11.1.2 flow compares the entered billing email on the order-received page and does not send a verification email/code. The local-only PHPMailer helper points to `mailpit:1025`; no external SMTP provider or relay was configured, and no production mail was sent. |
| Guest upload positive | **PASS** | A verified synthetic guest selected `synthetic-cover.png` in the order page at a 375px viewport. The browser sent the upload to the local WordPress `admin-ajax.php` path (three observed AJAX responses were HTTP 200); the file then appeared in that guest order's plugin metadata and order page. Stored size was 19,575 bytes under `wp-content/uploads/wcuf/{order}/{line}/`. The persisted result is shown in the guest upload screenshot. |
| Guest upload negative and raw file | **PARTIAL / RETURN** | A wrong email remained at the verification form; an unrelated guest order showed no upload record; raw storage URL returned HTTP 403. However, replaying the plugin's secure download link from the unrelated guest context returned HTTP 200. The link is a bearer capability after issuance, so the required unrelated-context denial did not pass. The secure URL is omitted from this document. |
| Guest private delivery positive | **PASS** | The synthetic text fixture was attached to the guest order through the Attach Me HPOS order panel. A verified guest order page displayed the attachment, and an actual download returned HTTP 200. Downloaded size was 112 bytes; SHA-256 `BD0BB9457A549F5C96A149308A8888E3B4B19FAB77311E4D0F72CC35FFE0A115` matched the committed `poc/g2a1/fixtures/synthetic-proof.txt`. |
| Guest private delivery negative and raw file | **PARTIAL / RETURN** | The unrelated guest order page did not list the attachment and the raw protected storage URL returned HTTP 403. Replaying the Attach Me download link in the unrelated guest context returned HTTP 200, so the required unrelated-context denial did not pass. No signed URL, order key, cookie, or token is included here. |
| Browser-local preview | **PASS; existing accepted result re-read** | Fresh run with the optional synthetic cover showed all preview images using `blob:` sources, no HTTP request or POST after selection, no external origin, and the preview CTA reached the dummy WooCommerce product, cart, and checkout routes. No model/API call was made. |
| Durable screenshots | **PASS** | `docs/evidence/g2a1r1/good-issue-wordpress-desktop.png`, `good-issue-wordpress-375px.png`, `guest-upload-result-375px.png`, and `guest-private-delivery-result-375px.png`. Guest screenshots use synthetic data and mask the email value. |

**Current component disposition:** `ORDER_UPLOAD=RETURN` and `PRIVATE_DELIVERY=RETURN` for the strict guest-context boundary. The plugins did bind the uploaded file and attachment to their orders, and raw storage URLs failed closed. The reproducible cross-context replay of each issued guest download link is a material limitation. Do not describe either plugin as accepted for guest delivery on this evidence.

## Test object inventory

| Object | Exact installed version | Source / license boundary | Install and runtime |
|---|---:|---|---|
| WordPress | 7.0.4 | Official WordPress image; GPL project | Local only; bound to loopback. |
| WooCommerce | 11.1.2 | [WordPress.org plugin directory](https://wordpress.org/plugins/woocommerce/); GPL | Active. Dummy product, cart and checkout routes worked. No gateway configured. |
| Kadence theme | 1.5.2 | [WordPress.org theme directory](https://wordpress.org/themes/kadence/); free theme with paid commercial upgrades | Active for Route A shell and shared preview pages. The named Jewelry Shop starter site was not imported. |
| Kadence Starter Templates | 2.3.4 | WordPress.org plugin; free plugin with optional paid template/content offerings | Active. No starter-site import was run. |
| Blocksy theme | 2.1.57 | [WordPress.org theme directory](https://wordpress.org/themes/blocksy/); free theme with paid commercial upgrades | Installed, inactive in final runtime. Route B page was rendered with the Blocksy shell. The named Modern Shop starter site was not imported. |
| Blocksy Companion | 2.1.57 | [WordPress.org plugin directory](https://wordpress.org/plugins/blocksy-companion/); free plugin with optional paid features | Active during Route B capture. No starter-site import was run. |
| Storelly Product Builder for WooCommerce | 1.7.1 | [WordPress.org plugin directory](https://wordpress.org/plugins/storelly-product-builder-for-woocommerce/); free local plugin; optional cloud rendering, dashboard/analytics and premium templates are separate paid capabilities | Installed, activated for runtime probe, then deactivated after product-page fatal. See Storelly evidence below. |
| Vanquish Upload Files for WooCommerce | 1.6.0 | [WordPress.org plugin directory](https://wordpress.org/plugins/vanquish-upload-files-for-woocommerce/); free version; multiple files per field and cloud storage are Premium | Installed and active. Account orders A/B each exposed two one-file fields. Order A desktop upload and Order B 375px upload were bound to their respective orders. |
| Vanquish Attach Me for WooCommerce | 1.1.0 | [WordPress.org plugin directory](https://wordpress.org/plugins/vanquish-attach-me-for-woocommerce/); free version; customer approval, expiry/download limits and some convenience surfaces are Premium | Installed and active. Synthetic proof fixture attached to Order A. Positive/negative authorization checks passed for registered users. |
| `Birthday Magazine G2A1 Preview` local plugin | 0.1.0 | Local PoC code, GPL-2.0-or-later header | Active and mounted read-only. Provides the Good Issue-like input/preview and WooCommerce CTA. |

The official WordPress.org pages above provide the current free/Premium boundary descriptions. The precise installed versions are from the local WordPress plugin/theme inventory. No premium plugin, license or cloud account was purchased or connected. Optional Freemius opt-ins were skipped.

Official ZIP archives were retained temporarily in `poc/g2a1/packages/` during installation. SHA-256 before cleanup:

| Archive | SHA-256 |
|---|---|
| `woocommerce-11.1.2.zip` | `9DE9350A1CF5671B9960AFB3151F40F7980E223217A441BF2EA5921B5FCE8E9E` |
| `kadence-1.5.2.zip` | `4773B41CD2DA71BDD2519AEDC8BB671EC0D4BEC33ACF6DB6592A40C614C2461B` |
| `kadence-starter-templates-2.3.4.zip` | `7EA5234938C589BB9C1B76A5EB97FAC7A17154F74511A0538732AC32E39CD8B8` |
| `blocksy-2.1.57.zip` | `077BA9E5001D01B08A06360E0E0CB4659842C7C5AF7EAAA58B92945E5982173D` |
| `blocksy-companion-2.1.57.zip` | `F77F6738F71F9C18020F576676D6FC829D70323C712AF09AD290D2BAB6C55072` |
| `storelly-1.7.1.zip` | `11906D9BC346B03AD6F5FA1C9C038190A40188929102A7778DC35AADA1A56706` |
| `vanquish-upload-files-1.6.0.zip` | `79D49FDAF7033FD2357CA106F5A850FFB956BB0B8840CD102BF1A0136A38DAC6` |
| `vanquish-attach-me-1.1.0.zip` | `FED1FA68D8D8DDCD0AFCFE847ED85D4A566819676AC9D4D7B1548A381C3E8C64` |

Synthetic fixture SHA-256:

| Fixture | SHA-256 |
|---|---|
| `synthetic-cover.png` | `BD36A1AF8B85EF8CAD9CEAC6FD048FEBF5F5578E3D77FE07D6ED9B404B41339D` |
| `synthetic-detail.png` | `9F1465BC1208D3CE671E44E4E33CD950E56485D9FB557479C48D6BEB55BEC910` |
| `synthetic-proof.txt` | `B4B4CADE0C5F226A25E7C5C9512F5C17A726C63BBCF4DDCAC25BCE2C7F21480D` |

## Routes A/B/C

All three routes used the same minimal WordPress page content and Good Issue-style `[bms_preview product_id="11"]` shortcode to keep the test bounded. Route A used the Kadence shell, Route B the Blocksy shell, and Route C applied the Good Issue page shell inside the same WordPress site. These were not three completed websites. The named Kadence Jewelry Shop and Blocksy Modern Shop starter sites were not imported, so their demo-page fidelity, block composition and import-time dependency/licensing behavior remain unverified.

| Route | Runtime page | Desktop and 375px result | Good Issue migration / code | Editor and WooCommerce fit | Result |
|---|---|---|---|---|---|
| A — Kadence Jewelry Shop + Storelly | `/?page_id=12` | Kadence header/footer around the page. 375px preview fit without body horizontal overflow after a small route CSS override. | Storelly is not viable for the photo-local preview; fallback shortcode is the same local code as C. | Theme header/footer and page shell stay editable in WP. Preview UI labels, copy and behavior are hardcoded in the custom shortcode. The shortcode page links into native WooCommerce. Exact Jewelry Shop starter import not tested. | Return Storelly path; base Kadence shell is feasible but not enough evidence to accept the named starter-site combination. |
| B — Blocksy Modern Shop + Storelly | `/?page_id=125` | Blocksy shell and preview visible at 1440px and 375px. 375px body/document width remained at the 375px viewport. | Same Storelly constraint. Fallback preview uses the same local code as C. | Theme/page shell is WP-editable. Preview UI labels, copy and behavior are hardcoded in the custom shortcode. Native WooCommerce product/cart path remained available. Exact Modern Shop starter import not tested. | Return Storelly path; base Blocksy shell is feasible but not enough evidence to accept the named starter-site combination. |
| C — Good Issue moved into WP + WooCommerce | `/?page_id=126` | Good Issue-style page shell rendered inside WordPress at 1440px and 375px, with no horizontal document overflow. | Approx. 6.5 KB PHP, 2.6 KB JS, 12.2 KB CSS and 1.1 KB route CSS in the local PoC. The JS uses `URL.createObjectURL()` and revokes the blob URL. | Page shell and the shortcode placement are editable in WP. Preview UI content/controls are in custom PHP/CSS/JS and are not field-editable in the WP editor. CTA uses `get_permalink(11)` and the native Woo product, cart and checkout. | Preferred feasibility route, subject to Reviewer decision. |

### Frontend evidence details

- Inputs are name, age, cover style, and optional one local image. The screen renders one cover plus one sample spread immediately; no LLM, vision, image-generation or server-side image rendering is used.
- Synthetic local image preview displayed from a `blob:http://127.0.0.1:8127/...` URL. The browser Network/WordPress access-log check showed page asset GETs but no image POST during this preview. This is distinct from the upload plugin, which intentionally transfers order files to the local WordPress server.
- The local photo was not persisted in WordPress Media Library or an order by the preview code. The selected file remains in the browser page context; `pagehide` revokes the object URL.
- Storelly’s frontend source uses its upload/AJAX path and WordPress sideload handling, which stores the image on the WordPress server. This is a code-inspection finding; the Storelly image editor itself could not be exercised on the test product because the product page failed first.
- Storelly product request for the dummy magazine returned HTTP 500. Local PHP log pointed to `includes/class-request-quote.php:335`, where `SPBWC_Request_Quote->enqueue_assets()` called `get_id()` on a string. Storelly was then deactivated; no patch/workaround was applied.
- No Storelly Cloud account, PDF export, premium template import or external service was connected. Optional Cloud PDF/dashboard capabilities are outside the free local builder boundary.
- Admin editing boundary: WordPress can edit the page and shortcode placement; the preview interface's copy, controls and generation behavior currently require PHP/CSS/JS edits. Theme shell settings remain in the theme editor/customizer. The Vanquish upload/order metadata and Attach Me order attachment records are plugin-specific; no cross-plugin migration was tested.
- The label “US$39.99” on the preview CTA leads to dummy Woo product ID 11, whose WooCommerce price is 39.99. Add-to-cart added one item and the Cart showed that item. Checkout loaded with “There are no payment methods available.” No gateway setup, payment submission or checkout order was performed.
- Desktop and 375px screenshots for A/B/C were captured in the CUA browser during the execution. The 375px Order B upload screen/result was also captured inline in the execution transcript. Screenshot bytes were not exported as project files by the browser-control surface; the project evidence therefore records viewport/DOM measurements rather than linking image files. Reviewer should treat this as a packaging gap if persistent screenshot artifacts are required.
- Syntax checks: local preview PHP passed `php -l`; `node --check` passed for `preview.js`.

## Vanquish Upload Files — order-bound customer uploads

**Exact object:** Vanquish Upload Files for WooCommerce 1.6.0, free WordPress.org build.
**Local synthetic test objects:** dummy product ID 11 at $39.99; registered account Order A ID 128; registered account Order B ID 129; guest Order ID 130. Orders were synthetic and their status was manually set to `processing` for the local order-page probe; that status does not represent a payment.

| Requirement | Evidence |
|---|---|
| Install/runtime | Installed and active. Two independent “Order photo slot” fields appeared on the customer order page. Each input had `multiple=false`, `accept=".jpg,.jpeg,.png,.webp"`, and a one-file maximum. |
| Multiple images | Free version supports one file per configured field. Two fields accepted cover and detail as separate files. Multiple files in one field is Premium. Per-product/category field restriction and per-field size settings are Premium. |
| Order binding | Order A stored `synthetic-cover` and `synthetic-detail` under `wp-content/uploads/wcuf/128/11-0/`. At 375px, customer B uploaded `synthetic-detail.png`; it appeared on Order B #129 and the file existed under `wp-content/uploads/wcuf/129/11-0/`. Customer B could not open Order A (WooCommerce displayed “Invalid order”). |
| Mobile | At a 375px browser viewport, the upload field remained selectable and the synthetic file appeared in the order details. The underlying order table measured about 456px wide while the viewport was 375px, so some table content can be clipped horizontally even though the outer document reports no horizontal overflow. A physical phone was not tested. |
| Format and size | File inputs accepted JPG/JPEG, PNG and WebP. PHP limits were `upload_max_filesize=2M`, `post_max_size=8M`, `wp_max_upload_size=2,097,152` bytes. Free UI did not expose per-field min/max size controls; practical upload ceiling is constrained by the 2 MiB server setting and available disk/time. |
| Storage/URL | Files were stored on the local WordPress server under `wp-content/uploads/wcuf/{order_id}/{product-line}/`. Secure links were enabled (`vanupfi_secure_links=1`) with `order_placed` association. The generated parent `.htaccess` denied direct access; a raw file URL returned HTTP 403. Authorized order page used the plugin’s order access path. |
| Positive access | Customer A’s Order A page displayed both files. Customer B’s Order B page displayed its own uploaded file. |
| Negative access | Customer B requested Order A and received WooCommerce “Invalid order”. A request without the order key did not reveal Order A file content. Raw static uploads URL returned 403. |
| Guest behavior | **Historical initial G2A1 probe; superseded by the G2A1R1 closure section above.** That probe stopped at WooCommerce's guest email-comparison form before local mail capture was added. |
| Network | Order files were intentionally uploaded to the local WordPress instance. No third-party cloud destination was configured; Dropbox/S3/Google Drive are Premium choices and were not enabled. |
| Limitations | Two separate fields are needed for two free uploads. We did not test physical iOS/Android picker behavior, large uploads, every MIME edge case, or guest verification delivery. The plugin exposes separate Free/Premium capability boundaries rather than requiring a custom upload system for the registered-account path. |
| Cleanup | Order files and test orders live only in the disposable project-scoped DB/files volumes, scheduled for removal at the end of this Gate. Synthetic fixtures remain under the PoC directory. |

## Vanquish Attach Me — private proof delivery

**Exact object:** Vanquish Attach Me for WooCommerce 1.1.0, free WordPress.org build.
**Fixture:** synthetic `synthetic-proof.txt` (111 bytes). Attached to Order A ID 128 only.

| Requirement | Evidence |
|---|---|
| Install/runtime | Installed and active. Admin HPOS order screen showed the Attachments panel; the fixture saved with title “Synthetic proof fixture” and a customer order-details link. No email options were selected and no message was sent. |
| Positive access | Customer A’s Order A page showed an Attachments section with a signed Download/View action. The plugin’s actual `Delivery::can_access()` check returned `true` for the owning registered customer. |
| Negative access | The same authorization check returned `false` for unrelated customer B. B could not view Order A through WooCommerce. |
| Storage/URL | Fixture stored under `wp-content/uploads/vanquish-attach-me/128/{unguessable-folder}/synthetic-proof-….txt`; the folder `.htaccess` denies all direct requests. Raw storage URL returned HTTP 403. Customer access routes through the plugin download handler with entitlement checking; it is not merely a hidden `/uploads/...` link. No signed bearer URL is reproduced here. |
| Download verification | Authorized UI link was visible and source/access checks were positive; the browser download event did not complete in this harness, so content delivery was not confirmed by a completed browser download. Reviewer should distinguish the access decision from a confirmed downloaded-byte response. |
| Guest behavior | **Historical initial G2A1 probe; superseded by the G2A1R1 closure section above.** The later verified guest download succeeded, but the issued guest download link replayed successfully in an unrelated guest context, so the current result remains `RETURN`. |
| Free boundary | Free order attachments and protected order access worked. Customer approval and availability/expiry/download-limit controls are Premium. Free files can be kept local and are not sent to an external service unless the optional Freemius opt-in/licensing flow is enabled; opt-in was skipped. |
| Cleanup | Attachment and metadata are confined to the disposable project-scoped WordPress/DB volumes and will be removed with this stack. |

## Network, privacy and external-service record

- No PayPal, payment gateway, sandbox, real payment, production domain, VPS, Cloudflare or shared infrastructure was used.
- No AI, LLM, vision or image-generation API was invoked. No API key or secret was added.
- The free preview used a browser `blob:` URL and made no photo upload request. Storelly’s source path is server-upload based; it did not pass the current photo-local criterion even without an external cloud request.
- Vanquish Upload Files intentionally sent order fixtures to the local WordPress host. Vanquish Attach Me stored its fixture in the local order-bound protected folder. Neither was configured for external cloud storage.
- Optional plugin telemetry/licensing opt-ins were declined/skipped; no plugin account or Storelly Cloud connection was made.
- The original G2A1 run had no local mail transport (sendmail connection refused); G2A1R1 added a loopback-only Mailpit capture sink. The guest order verification flow itself sent no message, and the inbox was empty after the flow. No customer/guest email was sent externally.
- Protected static URL probes returned HTTP 403 for the Order B Upload Files fixture and the Order A Attach Me fixture. Attach Me's `Delivery::can_access()` returned `owner_allowed=true` for Order A customer A and `unrelated_allowed=false` for customer B.

## Original G2A1 cleanup plan — historical, superseded by the R1 read-back below

- Active stack is the project-scoped Compose project `birthday-magazine-g2a1`; cleanup command is `docker compose -p birthday-magazine-g2a1 -f birthday-magazine-studio/poc/g2a1/compose.yaml down --volumes`.
- Remove only the exact temporary plugin/theme ZIPs and WooCommerce split download parts under `birthday-magazine-studio/poc/g2a1/packages/` after retaining source/version/hash evidence. Do not use global Docker prune or remove any other project’s resources.
- Disposable users, orders, uploaded files, local options and dummy product are in this stack’s data volumes and are removed by project-scoped `down --volumes`.
- Keep only the small PoC source and synthetic fixtures in the repository for Reviewer inspection. No changes were made to `REVIEWER_HANDOFF.md` and no commit was created.

## G2A1R1 cleanup and final runtime read-back

- Executed `docker compose -p birthday-magazine-g2a1r1 -f birthday-magazine-studio/poc/g2a1/compose.yaml down --volumes` after capturing evidence. Docker confirmed removal of the three project containers, both named project volumes, and the default network.
- Read-back after cleanup: `birthday-magazine-g2a1r1` containers/volumes/networks = `0/0/0`; the earlier typo-scoped project `birthday-magazine-g2a1` also has `0/0/0` resources.
- Docker inventory returned to the pre-execution counts: 40 containers, 87 volumes, and 21 networks. The pre-execution inventory digest was `95F7B566D566F6298A4ECC9E346EE00ED127CE5BAA60BFAD97CDFA660414AE61`; no broad Docker prune command was run, and cleanup targeted only this PoC's Compose labels.
- `poc/g2a1/.tmp-g2a1r1/` (including extracted source, browser profiles/screens, private seed data, and generated diagnostics) and `poc/g2a1/packages/` (temporary ZIPs) were removed. The durable evidence screenshots and deliberate local Mailpit Compose/MU-plugin wiring remain.
- Mailpit inbox was empty (`total=0`) immediately before teardown. No production or external mail provider was configured.
- No VPS, public domain, Cloudflare, shared infrastructure, payment, AI/API, or paid-plugin actions were used. `REVIEWER_HANDOFF.md` was not changed.

## Original G2A1 reviewer prompts — historical, superseded by the R1 return below

1. Decide whether Route C is preferred for continued WordPress/WooCommerce MVP work, noting the exact A/B starter-site imports were intentionally not run.
2. Decide whether Upload Files is acceptable for registered-account uploads while the guest flow remains unverified, or return for a test environment with local email capture.
3. Decide whether Attach Me is acceptable for registered-account private delivery while the guest flow and completed file download remain unverified, or return for a test environment with local email capture and byte-level download confirmation.
4. Keep this Gate separate from G2A2. This evidence is not a Reviewer PASS and does not freeze product specifications.

## Current G2A1R1 reviewer decision required

1. Decide whether to reject or replace Vanquish Upload Files for guest orders because its issued secure file link returned HTTP 200 when replayed from an unrelated guest context.
2. Decide whether to reject or replace Vanquish Attach Me for guest private delivery because its issued attachment link also returned HTTP 200 when replayed from an unrelated guest context, despite the raw storage URL returning HTTP 403.
3. Keep this Gate at Reviewer. Do not start G2A2 until the Reviewer resolves the two guest-link access-control failures.
