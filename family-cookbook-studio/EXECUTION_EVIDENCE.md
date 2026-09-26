# G2A1 — Execution Evidence

> Execution date: 2026-09-26 (Asia/Shanghai)  
> Gate result: `RETURN_G2A1_OCR_ENVIRONMENT_BLOCKED`  
> Governance source: GitHub `entropy-student/spike.skill/vps-project-governance`, latest read during this execution (core v0.1.6 + Governance Source Policy rev1).  
> Branch: `codex/family-cookbook-g2a1-input-ocr-component-feasibility`  
> Branch baseline / HEAD before Gate artifacts: `d61a2bf6098e91d8e5df0db464473df4ff9a07c6`.

## Status legend

- `PROVEN`: directly exercised and recorded here.
- `OBSERVED`: read-only host/repository observation; not proof of project behavior.
- `UNKNOWN`: not measured.
- `BLOCKED`: required test could not run in this execution environment.

## Repository and scope

- `PROVEN` The dedicated branch was absent at preflight and created from the then-current GitHub `main` at `d61a2bf6098e91d8e5df0db464473df4ff9a07c6`.
- `OBSERVED` Later, while this Gate was running, GitHub `main` advanced to `24644ae2007ac7f9303506ad5f4802f3f2295e35`. GitHub compare reports six commits touching only `mini-craft-night-kit/**`. The G2A1 branch was left on its start baseline; no merge or rebase of `main` was performed.
- `PROVEN` No payment, production deployment/write, customer file, private recipe, secret, or third OCR/VLM call was used.
- `PROVEN` All sample recipe text/images below are synthetic. No Birthday Magazine result is used as Family Cookbook evidence.

## Environment

| Item | Evidence |
|---|---|
| OS/runtime | Windows; Python 3.10.11 available; Node.js v24.19.0 |
| Browser | Chrome 153.0.8010.54, Chrome DevTools Protocol 1.3 |
| CPU/RAM | AMD Ryzen 5 7640HS, 6 cores / 12 logical; 15.28 GiB RAM; initial OCR preflight had 0.96 GiB available |
| GPU | NVIDIA GeForce RTX 4050 Laptop GPU; 6141 MiB VRAM, 5923 MiB free at probe; CUDA-enabled Torch was available in the system Python 3.10 environment (`2.14.0+cu126`, CUDA 12.6) |
| Free disk | C: 153.53 GiB at probe |
| OCR runtime | `BLOCKED`: PaddleOCR/PaddlePaddle/Transformers were absent before the attempt; checked Paddle/Transformers model cache locations had no relevant checkpoints |

### PaddleOCR install attempt

- Requested versions: `paddlepaddle==3.3.1`, `paddleocr==3.7.0`; `pip index versions` reported both versions available for Python 3.10 on this host.
- Action: created a temporary Python 3.10 virtual environment, upgraded pip, and attempted the two pinned installs. Dependency resolution reached the 104.8 MB PaddlePaddle Windows wheel download.
- Result: no install completion or further transfer progress for approximately 20 minutes. The executor stopped the installer processes. PaddleOCR/PaddlePaddle did not import; no model download or inference began. This is recorded as a stalled install, not an OCR model failure.
- Microsoft fallback candidate: `microsoft/trocr-base-handwritten`, with `transformers==5.17.0` specified in the replay requirements. Neither package nor model was installed/loaded; model revision remains `UNKNOWN`.
- No cloud model/OCR API was called: model/API Token usage was `0`. This does not establish zero local cost: package transfer/installation time and local storage are nonzero; inference CPU/GPU/RAM cost was not measured.

## Fixture set

`PROVEN` `node ocr/render-fixtures.mjs ocr/fixtures` rendered 20 pages from generated SVG to PNG with local headless Chrome; exit status 0. Full labels and literal ground truth are in `g2a1/ocr/fixtures.json`; `g2a1/ocr/render-fixtures.mjs` regenerates them. Generated PNGs are reproducible runtime outputs and are not committed.

The 20 synthetic pages cover clear print, neat/script handwriting fonts, skew, shadow, low contrast, ingredients plus instructions, margin notes, abbreviations, multiline layouts, mixed English/French, and critical values `1/2`, `1/4`, `1.5`, `tsp`, `tbsp`, `cup`, `g`, `ml`, `°F`, `°C`, `min`, and `hr`.

Limit: these are typographic synthetic images, not genuine handwriting. Their results cannot establish handwriting coverage even if the OCR replay later succeeds.

## Deterministic routing and recipe schema

`PROVEN` The bounded routing/schema unit suite ran locally: `python -m unittest -v test_poc.py` → 5 passed, 0 failed. `py_compile` succeeded for `routing.py`, `schema.py`, and `run_benchmark.py`.

Rules implemented (the rule only flags; it never corrects OCR text):

| Rule | Action |
|---|---|
| Paddle line confidence `<0.88`; critical field confidence `<0.93` | Route the source line crop to TrOCR |
| `tsp` / `tbsp`, any fraction, temperature, or timing token | TrOCR cross-check on the line crop |
| Fraction outside common recipe range; two-digit/large spoon amount (`12 tsp`); extreme °F/°C; `>60 min` or `>24 hr` | Route crop and keep `USER_CONFIRM_REQUIRED` if the suspicious value remains |
| Number and unit split across adjacent OCR lines | Route both crops and flag separation failure |
| `c.`, `T.`, `t.`, `pkg.`, `scant`, `heaping` | Route the source line crop |
| Ingredients/Method section missing or fewer than two quantity+unit lines | Page-level `USER_CONFIRM_REQUIRED` |
| PaddleOCR and TrOCR disagree, or a required crop/coordinates are unavailable | `USER_CONFIRM_REQUIRED`; never call a third recognizer |

The unit probes explicitly cover the adversarial candidates `12 tsp`, `350°C`, `75 min`, tsp/tbsp disagreement, low confidence, missing sections, separated quantity/unit, and engine disagreement. They are rule-function tests, not OCR inference results.

`PROVEN` The schema probe preserves `source_image`, verbatim `raw_ocr`, independent `normalized_transcription`, recipe fields, line/bbox source spans, confidence, uncertainty, corrections, and approval state. A test mutates normalized text and verifies the original raw text remains; an unparsed `1 c milk` remains unit-unknown, creates an uncertainty, leaves corrections empty, and enters `USER_CONFIRM_REQUIRED`.

## OCR benchmark results

`BLOCKED` No PaddleOCR page was processed and no TrOCR crop was processed. Therefore these metrics are **not zero-error results**; they remain unmeasured:

| Metric | Result |
|---|---:|
| Fixture pages available | 20 |
| PaddleOCR pages processed | 0 |
| Raw OCR line errors | `UNKNOWN` |
| Critical-field errors | `UNKNOWN` |
| Missing lines | `UNKNOWN` |
| Suspicious regions from OCR | `UNKNOWN` |
| TrOCR calls / rate | 0 actual calls / rate `UNKNOWN` (primary outputs never existed) |
| TrOCR resolved / unresolved / engine conflicts | `UNKNOWN` |
| `USER_CONFIRM_REQUIRED` total / per page / pages without confirmation | `UNKNOWN` |
| OCR latency, CPU, GPU, RAM, VRAM | `UNKNOWN` |
| Local inference compute requirement / MVP acceptability | `UNKNOWN` |

`g2a1/ocr/benchmark-output.json` contains machine-readable nulls for unmeasured fields, the fixture classes, runtime attempt, and explicit routing rules. `g2a1/ocr/run_benchmark.py` implements full-page PaddleOCR, deterministic crop selection, crop-only TrOCR, provenance mapping, and resource/latency collection for a replay; the runner itself was syntax-checked but could not be executed without the blocked dependencies.

**TrOCR value:** `UNKNOWN`. This execution has no evidence that it reduced manual confirmation. The approved architecture was not expanded.

## Browser-local preview

`PROVEN` The static preview PoC ran in Chrome 153.0.8010.54 via `file://`. DevTools observed only the local document and a `blob:` object URL for `sample-local-image.svg`. The UI accepted family name, cookbook title, style, and an optional local image; it rendered a cover plus sample recipe spread.

Network/browser evidence in `g2a1/preview/preview-observation.json` records:

- fetch/XHR/beacon/WebSocket attempts: `0`;
- observed HTTP/HTTPS requests: `0`;
- local file read: `true`;
- forms/upload endpoint: `0`;
- downloadable cookbook links: `0`;
- OCR/model/cloud calls: `0` by source boundary and observed network evidence;
- temporary Chrome profile cleanup: passed.

`BLOCKED` This was the standalone browser-local preview; it was not embedded in WordPress/Kadence. A read-only unrelated local Kadence test stack showed WordPress 6.8.2, WooCommerce files 10.0.4, Kadence 1.5.2, and Kadence Blocks 3.7.11, but it was not used as Family Cookbook evidence or modified. Host checks to ports 8088, 8090, 8092, and 8093 timed out. No dedicated Family Cookbook WordPress/WooCommerce test site was available. No fallback theme was tried; this is an environment blocker, not a Kadence technical defect.

## Order-bound upload and private delivery

- Order-bound upload positive binding, file type/size, mobile behavior, unrelated-order denial, and anonymous direct access: `BLOCKED`; no Family Cookbook test instance/component was exercised.
- Private proof/final delivery: `BLOCKED`; no synthetic PDF was placed in an order-bound store, and no positive/negative authorization requests ran.
- Exact Family Cookbook plugin/component versions and cleanup: `UNKNOWN` (there were no test uploads, orders, PDFs, or delivery artifacts to clean up).
- Existing unrelated WordPress test containers were inspected read-only only. No install, activation, content/order creation, or write was made to them.

## Commands / actions and outcomes

| Command/action | Result |
|---|---|
| `git ls-remote` before Gate branch creation | `main` and target branch baseline both `d61a2bf6098e91d8e5df0db464473df4ff9a07c6`; target ref absent before creation |
| GitHub `create_branch` from `main` | Completed; target branch starts at `d61a2bf...` |
| `node ocr/render-fixtures.mjs ocr/fixtures` | Exit 0; 20 synthetic pages rendered |
| `python -m unittest -v test_poc.py` | Exit 0; 5 passed |
| `python -m py_compile routing.py schema.py run_benchmark.py` | Exit 0 |
| `node preview/verify-preview.mjs ...` | Exit 0; all six preview/network assertions passed |
| `pip index versions paddlepaddle` / `paddleocr` | Completed; requested versions available |
| `pip install paddlepaddle==3.3.1 paddleocr==3.7.0` in temporary venv | Stalled during wheel download; stopped; no OCR run |
| `Invoke-WebRequest` local WordPress port probes | Ports 8088/8090/8092/8093 each timed out after 2 seconds |
| Existing test WordPress container inspection | Read-only; unrelated project; no writes |

## Cleanup and Git delivery

- `PROVEN` Temporary Chrome profile was removed. No WordPress stack was started/stopped or changed. No test order, uploaded file, synthetic PDF delivery, model cache, or customer data was created by a model run.
- `OBSERVED` The interrupted temporary Python environment and incomplete Git clone directories remain local because Windows execution policy rejected recursive deletion outside the current workspace. Their clone/install processes were stopped; no credentials or model weights were written there. Neither directory is in the GitHub commit.
- GitHub branch changes use GitHub Git Data API commits after the full local smart-clone stalled at a zero-byte pack; the branch starts from the read-back baseline above.
- `MAIN_MERGED=NO`. `EXECUTOR_HANDOFF.md` and all evidence/artifacts are committed to the dedicated branch; final branch HEAD is independently read back and reported in the Executor return.


## G2A1-R1 — OCR runtime + Family WordPress testbed remediation preflight

> Evidence committed: 2026-09-27 (Asia/Shanghai); measured preflight snapshots: 2026-09-26 23:49–23:56 (Asia/Shanghai)  
> Execution state: `RETURN_G2A1_R1_RESOURCE_BLOCKED`  
> `CARRIED_FORWARD_FROM=b1bf844096fed4761372f3beea6f9f2d7d081643`  
> Branch at start: `codex/family-cookbook-g2a1-input-ocr-component-feasibility@b1bf844096fed4761372f3beea6f9f2d7d081643`  
> Latest `main` Reviewer / R1 snapshot before Git write: `96b05c00ad8e5601dd4cef428709086ef1eb2991`; it was not merged or rebased.

### Source-of-truth read

- `PROVEN` Read GitHub canonical Governance from `entropy-student/spike.skill/vps-project-governance`: `SKILL.md` (blob `5e6ba08305ad802e5f6ce732d8ca731bc316b141`), `GOVERNANCE_HANDOFF.md` (blob `d290694148348a2e02e5143415bd277b11f5fba7`), and `references/GOVERNANCE_SOURCE_POLICY.md` (blob `7d1897b6a032a5de0686ff6704c8854f54699ab4`). Current core is v0.1.6 and Source Policy rev1.
- `PROVEN` Read latest `main` Reviewer Handoff, Document Index, R1 Contract, original G2A1 contract and Technical Route at `331547fb123bb91afbb07720aae7e3fc0b2b26d2`, then read the existing execution branch at `b1bf844096fed4761372f3beea6f9f2d7d081643`, including its full `g2a1/**` tree. Immediately before writing, `main` advanced; its latest Reviewer Handoff and R1 Contract were re-read at `96b05c00ad8e5601dd4cef428709086ef1eb2991` (blobs `c7d66853c42f23821d3f7600b216739c24218944` and `5bc788b528d10714a034c039753e0a190053128e`). R1 remains current and authorizes the same branch. Branch and main were not synchronized because the R1 contract says not to merge/rebase unrelated main drift.

### Carried-forward accepted evidence

The following was not rerun or relabeled as new R1 evidence; it remains accepted from `b1bf844096fed4761372f3beea6f9f2d7d081643`:

- `CARRIED_FORWARD` 20 synthetic typography fixture definitions and deterministic renderer;
- `CARRIED_FORWARD` deterministic suspicious routing and provenance/schema unit tests (5/5), including raw OCR retention and disagreement fail-closed behavior;
- `CARRIED_FORWARD` static browser-local preview, local blob image, zero HTTP/model requests, and no full cookbook download.

The carried-forward pages are synthetic typography, not genuine handwriting. The prior `RETURN_G2A1_OCR_ENVIRONMENT_BLOCKED` remains intact above.

### New read-only runtime preflight

Structured measurements are in `g2a1/r1/preflight.json`.

- `NEW_PROVEN` Windows 11 Home, Python 3.10.11 64-bit, AMD Ryzen 5 7640HS / 12 logical processors, 15.28 GiB installed RAM, C: free 152.7 GiB.
- `NEW_PROVEN` Available RAM samples during read-only preflight were 1.67 GiB (23:49), 1.23 GiB (23:53), and 0.62 GiB (23:56). These are separate snapshots; no causal attribution is made.
- `NEW_PROVEN` RTX 4050 Laptop GPU: 6141 MiB VRAM, 5923 MiB free and 0% utilization at 23:53; existing system Torch is 2.14.0+cu126 and reports CUDA 12.6 available.
- `NEW_PROVEN` Docker 29.7.2 client/daemon are available. Read-only inventory showed multiple already-running unrelated WordPress/MariaDB services; no project service was stopped, started, inspected for private data, or modified.
- `NEW_PROVEN` No PaddleOCR, PaddlePaddle or Transformers Python package is installed. `.paddleocr` and `.paddlex` caches are absent. Hugging Face cache is 15.2 MiB and contains only `FunAudioLLM/Fun-ASR-Nano-2512`; the target OCR/TrOCR weights are not cached.
- `NEW_PROVEN` PyPI PaddleOCR/Transformers metadata and Hugging Face model metadata endpoints returned HTTP 200. The TrOCR weight endpoint answered HEAD 200 with `Content-Length=245933041`; no weight payload was downloaded. Docker registry `/v2/` returned 401; no registry authentication was attempted.

### OCR route status

- `OBSERVED` Current official PaddleOCR docs support `engine="transformers"` and `PaddleOCR(...).predict(...)`; the docs show PP-OCRv5 server detection/recognition as supported options. The detailed inference-engine page specifies Transformers `>=5.10.0`. References: [Quick Start](https://www.paddleocr.ai/main/en/quick_start.html), [Inference Engine](https://www.paddleocr.ai/main/en/version3.x/inference_deployment/local_inference/inference_engine.html), [OCR Pipeline](https://www.paddleocr.ai/main/en/version3.x/pipeline_usage/OCR.html).
- `BLOCKED` Route A was not installed or executed. PaddleOCR/Transformers exact installed versions and Paddle model revision/hash are therefore `UNKNOWN`. The previous benchmark runner still requires review/update to the current engine API; no runtime compatibility is claimed.
- `OBSERVED` The authorized TrOCR candidate is `microsoft/trocr-small-handwritten`; Hugging Face metadata currently reports revision `b4648cfa171985a6745f37ddd637e98c0da958ac`, weight file `pytorch_model.bin`, 245,933,041 bytes. This is metadata/HEAD only: model not downloaded/loaded, device not selected, fallback latency not measured. Source: [model card](https://huggingface.co/microsoft/trocr-small-handwritten).
- `BLOCKED` Inference was deliberately not started at the latest 0.62 GiB available host RAM while unrelated project containers remained active. No user process was killed. Route architecture remains PaddleOCR → deterministic routing → suspicious crop → TrOCR → `USER_CONFIRM_REQUIRED`.
- R1 Paddle page count is 0 because no inference was started, not because there were zero errors. Raw OCR errors, missing lines, critical-field errors, suspicious regions, fallback resolution/conflict, confirmation burden, latency and runtime resource peaks are all `UNKNOWN`. R1 TrOCR calls: 0. No third OCR/VLM used. Model/API Token usage: 0. Local compute cost remains unmeasured and nonzero by design.
- `BLOCKED` No genuine-handwriting image subset was acquired. Genuine handwriting count is 0 in this R1 attempt; no license/source claims are made. The carried synthetic script-font set is not genuine handwriting.

### Family Cookbook WordPress / WooCommerce testbed

- `BLOCKED` A dedicated Family Cookbook WordPress/WooCommerce instance was not created. No Family-specific WordPress, WooCommerce, or Kadence version is claimed.
- `BLOCKED` Kadence-integrated browser-local preview, dummy order creation, upload positive/negative tests, synthetic PDF private-delivery positive/negative tests and mobile upload behavior were not run. Existing static preview remains only `CARRIED_FORWARD`; it is not WP integration evidence.
- Reason: with only 0.62 GiB available system RAM at the latest sample and unrelated WP/database services active, starting model loading or another PHP + database stack without a validated resource limit could exhaust host RAM and affect other projects. Disk and GPU headroom do not resolve the host-RAM constraint. The existing stacks were left unchanged.
- No local containers, package environments, target models, synthetic orders, uploads or PDF files were created in this R1 attempt; no cleanup was needed. Prior cleanup notes remain preserved in the original section.

### Gate assessment

`RETURN_G2A1_R1_RESOURCE_BLOCKED` — R1 cannot PASS. The PaddleOCR/TrOCR inference evidence, genuine-handwriting subset and Family-specific WP/Woo/Kadence preview/upload/private-delivery evidence remain outstanding. Reviewer should resume this same branch only when a fresh preflight shows enough safe host RAM to load/run the two OCR engines and an isolated WP+Woo+database testbed without stopping unrelated services. No architecture change is requested.

## G2A1-R2 — Isolated GitHub Actions Runner

Execution record appended; prior RETURN sections and R1 evidence above remain intact.

### Provenance and run history

- CARRIED_FORWARD_FROM=b1bf844096fed4761372f3beea6f9f2d7d081643: accepted 20 synthetic typography fixtures/renderer, deterministic routing and provenance/schema implementation, unit tests 5/5, disagreement fail-closed behavior, static browser-local zero-network/zero-token preview.
- CARRIED_FORWARD_FROM=f79891f20c973e93586e41319c0abb7e78b3af4c: Windows host 0.62 GiB available-RAM blocker and decision to leave unrelated WordPress/MariaDB services untouched.
- Bounded workflow: .github/workflows/family-cookbook-g2a1-r2.yml; workflow blob SHA 4401f38ccade5634ad6e96acf199ae05fdb9a531 at this evidence draft. Branch-scoped, guarded by [g2a1-r2-run], permissions contents: read, no repository Secrets, workflow does not commit.
- Actions run history (all on isolated hosted Ubuntu; skipped rows are unmarked intermediate code commits):
  - 36258313310 — workflow validation blocked by runner.temp in job-level expressions; fixed to use shell $RUNNER_TEMP.
  - 36258483569 — initial OCR import path and root WP-CLI invocation incompatible. Early revision wrote runner-only dummy test values to the Actions environment summary; actual values are intentionally not reproduced here. Not a repository Secret or real credential. Later revision uses a mode-0600 masked runner-temp file and cleanup verified removal.
  - 36259393875 — PaddleOCR official CPU-runtime route completed inference; Route A lacked torchvision. WP plugin-install stage failed. Cleanup code in that revision did not source runtime compose variables; later corrected. Runner was ephemeral.
  - 36260579694 — PaddlePaddle fallback benchmark ran. Transformers tokenization failed because protobuf and tiktoken were missing. WP 6.8 was incompatible with current WooCommerce (minimum WP 7.0). Cleanup succeeded.
  - 36261369003 — skipped (no execution marker).
  - 36261384623 — PaddleOCR Transformers route succeeded. WP core/plugin/theme installed; dummy setup stopped because the WP-CLI eval script lacked global $wpdb. Cleanup succeeded.
  - 36261864126 — Transformers route and WP bootstrap succeeded; browser could not resolve Playwright from temporary ESM package path. Cleanup succeeded.
  - 36262311531 — Transformers route succeeded; browser checks ran and recorded upload/delivery outcomes. Bounded harness/adapter defects found: a blob: URL request counted as HTTP, PHP upload-size errors mapped to 400, and CLI-created 0600 PDF was unreadable by the web user. Later revisions fix all three.
  - 36262839382 and 36262840477 — skipped (unmarked intermediate commits).
  - 36262841714 — job conclusion failure only because preview assertion read a misspelled/undefined count field. Actual run recorded PaddleOCR Transformers success; WP 7.1.2 / WooCommerce 11.1.2 / Kadence 1.5.2; passing upload and private-delivery positive/negative checks; preview used two blob: image URLs with HTTP request count unchanged (17 before/17 after selection), but aggregate harness boolean was false. Cleanup succeeded.
  - 36263385997 — latest marked rerun with corrected property name; last polled status was in_progress at PaddleOCR Transformers step. Conclusion was not yet available. Do not report this run as successful.
- Run 36262841714 uploaded artifact 10913315438, family-cookbook-g2a1-r2-36262841714, 1,321,797 bytes, SHA-256 22fd40d543f9e0aba794062167d55d7f730673edd51e81a6e6bb75116a10b45c. Artifact metadata and download reference were read. Selected compact JSON sections were independently parsed from workflow log markers and are committed below; ZIP was not unpacked locally. Workflow logs include full selected JSON before upload.

### Runner preflight and compute

NEW_PROVEN_ACTIONS — run 36262841714, Ubuntu hosted runner:

- Ubuntu 24.04.5, runner image 20260920.314.1, Python 3.12.3 x64; AMD EPYC 7763, 4 logical CPUs.
- RAM 16,766,414,848 bytes total; 15,809,798,144 bytes available before model work. Runner had 3 GiB swap available; no new swap created. resource_blocked=false.
- Root filesystem free before OCR: 92,343,398,400 bytes; after OCR model load: 89,714,991,104 bytes. This includes runtime/model writes; no cache committed.
- Docker 28.0.4; Compose 2.38.2. GPU absent; VRAM N/A.
- PyPI, PyTorch CPU wheels, Hugging Face, Zenodo, Docker Registry and WordPress download endpoints were reachable for the workflow. Paddle model source preflight GET returned 403, but the supported Transformers route retrieved the models and ran.
- OCR initialization 10.975 s; Paddle inference 176.684 s for 28 pages; OCR-process CPU 408.451 s; process RAM start 450,240,512 bytes, peak sampled 3,881,517,056 bytes, delta 1,149,591,552 bytes; system available RAM minimum sampled 12,352,163,840 bytes.
- Model weights in runner temp: 418,275,740 bytes total (Paddle models 172,436,604 bytes; TrOCR 245,839,136 bytes). CPU only; no cloud inference. Model/API Token=0. Hosted Actions compute consumed CPU, memory, disk and runner time; account charge/quota valuation was not exposed and remains UNKNOWN. No paid cloud/GPU resource was started.

### PaddleOCR runtime and benchmark

NEW_PROVEN_ACTIONS:

- PaddleOCR 3.7.0 + PaddleX 3.7.0, official Transformers inference engine; Transformers 5.10.0; Torch 2.8.0+cpu; TorchVision 0.23.0; protobuf 6.33.3; tiktoken 0.14.0. PaddlePaddle was not installed for this successful Route A run; official CPU fallback was skipped.
- PaddleOCR is the sole full-page primary. PP-OCRv5 server detector/recognizer, CPU; model family PaddleX/PaddleOCR release 3.7 (package source exposes no separate Hub revision). Model file names and hashes are in g2a1/r2/results/36262841714-ocr-benchmark.json.
- TrOCR only: microsoft/trocr-small-handwritten, revision/commit 959398e1e35ce99c83e60f83b35c1187d4508a0b, CPU; model.safetensors 245,839,136 bytes, SHA-256 aff90cf2fb583df6bc7122b62eaafbbaa5d87a7b9d8cf77472eff747934fa7ef. Mean fallback crop latency 406.89 ms / 60 calls; per-call records are committed.
- Genuine-handwriting set: 8 images from ScaDS.AI German Line- and Word-Level Handwriting Dataset v1.0, DOI 10.5281/zenodo.18301532; dataset CC BY 4.0; source transcriptions from Wikipedia CC BY-SA 4.0. Public/open, non-customer data; demographic columns excluded. Archive MD5 and sample IDs G01–G08 are in source metadata. These are handwritten images, not script-font renders.
- Total: 28 full-page inputs, 127 recognized lines; 62 raw erroneous lines, 32 missing lines, 13 critical-field errors (synthetic recipe fixtures), 60 suspicious regions.
- SYNTHETIC_TYPOGRAPHY: 20 pages, 117 recognized lines; 44 raw erroneous lines; 24 missing lines; 13 critical-field errors; 49 suspicious regions; 58 confirmations; 2.90 confirmations/page; zero pages without confirmation; mean Paddle latency 8,685.29 ms/page.
- GENUINE_HANDWRITING: 8 pages, 10 recognized lines; 18 raw erroneous lines; 8 missing lines; 11 suspicious regions; 11 confirmations; 1.375 confirmations/page; zero pages without confirmation; mean Paddle latency 372.33 ms/page. Recipe critical-field accuracy is not applicable to these non-recipe line/word samples.
- Per-fixture full-page raw OCR, line text/confidence/bounding coordinates, source hashes, preprocessing, missing/extra lines, critical-field outcomes, routing, schema probe and latency are in committed benchmark JSON. Raw OCR and normalized transcription are distinct; no correction overwrote raw OCR.

### Routing, TrOCR fallback and confirmation burden

NEW_PROVEN_ACTIONS:

- 60 deterministic suspicious crop/line fallbacks from 28 pages; 27/28 pages had at least one fallback (96.43% page fallback rate), 2.1429 crop calls/page.
- Each crop's relative source path/hash, Paddle result/confidence/coordinates, TrOCR result, reason, latency, resolution and confirmation flag are in 36262841714-trocr-fallback-results.json.
- TrOCR resolved 0/60; unresolved 60/60; engine disagreements 60/60. TrOCR reduced manual confirmations by 0.
- USER_CONFIRM_REQUIRED=69, 2.464 items/page; zero pages without confirmation (0%). Synthetic typography accounts for 58; genuine-handwriting samples account for 11.
- The paired route is not enough for an OCR MVP that should reduce manual review on this fixture set: 13 critical-field errors, all pages still require confirmation, and TrOCR resolved none. Evidence supports RETURN_G2A1_R2_OCR_ROUTE_INSUFFICIENT. No third OCR/VLM was added; reviewer decision required.

### Recipe schema / provenance

CARRIED_FORWARD: accepted provenance/schema implementation and unit tests 5/5 remain intact. NEW_PROVEN_ACTIONS: each measured fixture JSON carries source image identifier/hash, raw full-page OCR, line text/confidence/coordinates, normalized transcription, schema probe, uncertainty and approval state. The benchmark keeps raw_ocr alongside normalized_transcription; normalization does not overwrite raw OCR. Uncertain/suspicious critical fields route to uncertainty and/or USER_CONFIRM_REQUIRED, not guessed corrections.

### Family Cookbook WordPress / WooCommerce / Kadence

NEW_PROVEN_ACTIONS — run 36262841714:

- Ephemeral local Compose namespace family-cookbook-g2a1-r2-36262841714; WordPress 7.1.2 (wordpress:7.1.2-php8.3-apache), WooCommerce 11.1.2, MariaDB 11.4.13, Kadence free 1.5.2, Chromium 153.0.8010.52 / Playwright 1.55.0. Local-only port 8871. No public domain/VPS, real payment/provider, real order or customer.
- Preview shortcode integrated the carried preview. Family/title/style bindings passed; image source was blob:, local object URL true, browser fetch/XHR/beacon/WebSocket attempts all 0, model/OCR/token calls 0. HTTP request count before/after local file selection 17/17 (delta 0); no server upload after selection. Aggregate assertion failed only because a later field-name typo returned false; corrected in the latest rerun source. Mobile iframe/document width 300/300 at 390px outer viewport; no horizontal overflow. Two preview sections, no download link/form.
- Order-bound upload adapter: minimal project-local proof adapter (CUSTOM; WooCommerce order ownership, order-bound metadata and private file storage), no external upload plugin. Synthetic PNG 39,666 bytes; MIME and SHA-256 recorded. User A/order A upload 201 PASS; same user read 200 PASS. User B/order B own upload 201. Anonymous 401; user B accessing order A 403; unrelated order 404; unsupported text 415; 2 MiB+ upload 413 after mapping PHP upload-size error. Mobile form 390px viewport/document with no horizontal overflow. Files live outside document root.
- Private delivery: synthetic PDF 607 bytes. Intended user/order 200 PASS, %PDF-1.4, SHA-256 6bff45561968b5a7a5a210f6be80c518178787772c0bccbb3906779ed598cc9e. Anonymous 401; unrelated user 403; unrelated order 404; direct public raw URL 404. Private path outside document root; fixture mode 0600 and owned by the web runtime.
- Detailed versions and browser request paths: 36262841714-wp-test-summary.json. Dummy WooCommerce orders were pending; no payment occurred.
- Cleanup JSON: compose_down_exit=0, no remaining containers/volumes/networks, credentials_file_removed=true, swap_removed=true. No local Windows workload or other project touched.

### R2 conclusion

RETURN_G2A1_R2_OCR_ROUTE_INSUFFICIENT

NEW_PROVEN_ACTIONS: PaddleOCR Transformers full-page inference; actual suspicious-crop TrOCR calls; public handwriting subset; local Kadence/browser preview measurements; Family-specific order-bound upload and private-delivery access checks. UNKNOWN: representative handwriting/language/recipe accuracy beyond these fixtures, production latency/economics, hosted Actions billing/quota valuation. BLOCKED for PASS: the OCR-route review criterion; TrOCR resolved no routed cases and did not reduce confirmation burden. As checked at 2026-09-26 19:09 UTC, marked run 36263385997 remained in_progress at step 8 (PaddleOCR Transformers inference); conclusion, remaining job steps and final artifacts were not yet available. This run is not represented as successful. Run 36262841714 is the completed benchmark source used for the OCR insufficiency determination. No main merge; no G2A2.

