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
