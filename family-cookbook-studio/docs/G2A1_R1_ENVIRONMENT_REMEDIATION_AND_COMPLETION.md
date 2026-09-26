# G2A1-R1 — OCR Runtime + WordPress Testbed Remediation / Completion

> Reviewer remediation contract  
> Status: **CURRENT / READY_FOR_EXECUTOR**  
> Parent truth: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)  
> Returned execution branch: `codex/family-cookbook-g2a1-input-ocr-component-feasibility`  
> Accepted RETURN evidence HEAD: `b1bf844096fed4761372f3beea6f9f2d7d081643`

## 1. Reviewer Decision

The original G2A1 execution is **RETURNED, not failed as an architecture**.

Accepted partial evidence from the returned branch:

- 20 synthetic fixture definitions + deterministic renderer exist;
- deterministic suspicious-value routing and provenance/schema tests passed (5/5);
- fail-closed engine disagreement behavior is implemented;
- static browser-local preview proved local blob usage, no HTTP/model call, no full-download path;
- no real payment, customer/private data, third OCR or VLM was used.

Still unproven / blocked:

- PaddleOCR full-page inference;
- TrOCR fallback inference;
- OCR accuracy, critical-field error rate, fallback value, user-confirmation burden;
- runtime latency / RAM / VRAM / CPU/GPU cost;
- Kadence-integrated Family Cookbook preview;
- Family Cookbook order-bound upload;
- Family Cookbook private proof/final delivery.

Therefore the Gate remains open.

## 2. Scope

This remediation must complete only the blocked parts. Do **not** repeat accepted partial evidence unless the related code changes materially.

Two bounded workstreams are authorized:

### A. OCR runtime remediation + real inference
### B. Dedicated local Family Cookbook WordPress/WooCommerce testbed + component probes

Both are local/test-only and Git-reversible.

## 3. Git / Branch Rule

Continue the existing branch:

`codex/family-cookbook-g2a1-input-ocr-component-feasibility`

Do not merge or rebase unrelated `main` changes merely to continue the Gate. The observed `main` drift after branch creation was Mini Craft-only and does not invalidate the Family Cookbook execution branch.

Before writes:
- read current GitHub `main` Reviewer truth;
- read branch HEAD and existing evidence/code;
- preserve prior evidence;
- append/supersede conclusions rather than deleting the first RETURN history.

Final delivery must again commit to the same branch and return exact HEAD SHA.

## 4. OCR Architecture — unchanged

The MVP OCR architecture remains:

```text
PaddleOCR primary
→ deterministic confidence / critical-value routing
→ suspicious crop only → Microsoft TrOCR
→ unresolved / disagreement → USER_CONFIRM_REQUIRED
```

No third OCR, cloud OCR or VLM may be added.

## 5. OCR Runtime Remediation Priority

The previous blocker occurred while downloading a PaddlePaddle wheel. This is an environment/install blocker, not evidence that PaddleOCR failed.

Use this remediation order:

### Route A — preferred: PaddleOCR with Transformers inference engine

Current PaddleOCR documentation supports PaddlePaddle **or Transformers** as the inference engine.

Prefer a clean project-local Python environment and current supported PaddleOCR API with a Transformers backend when practical. This avoids making the stalled PaddlePaddle wheel a mandatory dependency.

Reference:
- https://www.paddleocr.ai/main/en/quick_start.html

Requirements:
- record exact Python, PaddleOCR, Transformers and model revisions;
- adapt the existing benchmark code to the actual supported API rather than assuming the stale attempted runtime;
- CPU inference is acceptable for the PoC if it is the most reliable route;
- model/API Token remains 0.

### Route B — fallback within the same PaddleOCR architecture

If Route A is technically unsupported for the selected OCR pipeline on the actual host, use the official PaddlePaddle installation channel rather than the generic stalled download path.

For the observed Windows + CUDA 12.6 host, current PaddlePaddle Windows documentation provides an official CUDA 12.6 package path.

Reference:
- https://www.paddlepaddle.org.cn/documentation/docs/en/install/pip/windows-pip_en.html

Do not switch to a different OCR product.

## 6. TrOCR Runtime Remediation

Use Microsoft TrOCR only for suspicious cropped lines/regions.

For this remediation, prefer:

`microsoft/trocr-small-handwritten`

Reason: TrOCR is only a fallback path and the small handwritten checkpoint materially reduces initial download/runtime footprint compared with the previously planned base checkpoint.

Reference:
- https://huggingface.co/microsoft/trocr-small-handwritten

Requirements:
- record exact model revision/hash when available;
- follow the current Transformers/model-card loading API for the installed version;
- do not silently fall back to a larger model if the small checkpoint is inadequate;
- if the small checkpoint is materially inadequate, return that evidence to Reviewer.

## 7. Resource Preflight

Before model installation/inference, record:

- free RAM;
- free disk;
- GPU/VRAM;
- Python architecture/version;
- network/download reachability;
- existing relevant caches.

Do not kill unrelated user applications/processes merely to manufacture free RAM.

If the environment is too constrained for safe inference, return a precise resource blocker with measured values.

## 8. Fixtures

Reuse the committed synthetic fixture set.

Additionally add a **small public/open genuine-handwriting subset** (target 5–10 samples) with source/license/provenance recorded. It may be general handwriting rather than private family recipes.

Why:
- script fonts are not genuine handwriting;
- synthetic critical-value pages remain useful for recipe-specific adversarial fields;
- genuine handwriting samples are needed to avoid claiming handwriting viability from typography alone.

Do not use private/customer data.

## 9. OCR Completion Evidence

Run PaddleOCR on the full-page fixtures and TrOCR only on routed crops.

At minimum record:

- pages processed;
- raw OCR errors / missing lines;
- critical-field errors;
- suspicious regions;
- Paddle confidence/coordinates when available;
- TrOCR fallback count;
- TrOCR resolved count;
- unresolved / engine disagreements;
- `USER_CONFIRM_REQUIRED` count;
- confirmations per page/recipe;
- pages without confirmation ratio;
- average latency;
- RAM/VRAM/CPU/GPU observations;
- model/API Token usage;
- local runtime/storage footprint.

The output must distinguish synthetic-font evidence from genuine-handwriting evidence.

## 10. WordPress / WooCommerce Dedicated Testbed

The previous run had no Family Cookbook test site. Create a dedicated **local/test-only** Family Cookbook WordPress + WooCommerce environment.

Requirements:
- project-local/reversible;
- unique project namespace/ports;
- do not modify unrelated WordPress projects;
- install/use Kadence free as the first shell;
- no production domain/VPS/public deployment;
- no paid plugin purchase.

Prove:

### Browser-local preview
- embedded into or reachable from the Family Cookbook test site;
- optional local image remains browser-local before payment;
- no OCR/model request;
- no image upload before payment;
- 0 model Token.

### Order-bound upload
Using dummy orders + synthetic files:
- file is associated with intended order;
- unrelated/anonymous access fails;
- direct public raw URL is not the authorization model;
- file type/size behavior recorded;
- mobile/basic responsive upload behavior recorded.

### Private delivery
Using synthetic PDF:
- authorized intended order/user can access;
- unrelated order/user cannot;
- anonymous access cannot;
- no public raw-file access bypass.

If a free reusable plugin/component cannot satisfy the access contract, a minimal project-local proof adapter is allowed, but record exactly what is reused versus custom.

## 11. Accepted Prior Evidence — do not unnecessarily repeat

Unless related code is changed, the following can be carried forward from HEAD `b1bf844096fed4761372f3beea6f9f2d7d081643`:

- fixture metadata/renderer;
- deterministic routing unit tests;
- provenance/schema unit tests;
- static browser-local zero-network preview proof.

The final evidence must explicitly cite which facts are carried forward and which are newly measured.

## 12. Forbidden

- real payment;
- customer/private family data;
- third OCR;
- cloud OCR;
- GPT/Gemini/Claude vision;
- production VPS/domain;
- Shared Infra changes;
- paid plugin/provider purchase;
- Secret exposure;
- physical printing;
- merge to `main`;
- starting G2A2.

## 13. PASS_CANDIDATE Criteria

Return PASS_CANDIDATE only if:

- PaddleOCR runs on the benchmark fixture set;
- TrOCR runs on actual routed suspicious crops;
- critical-value ambiguity remains fail-closed;
- user-confirmation burden is measured;
- genuine-handwriting results are explicitly separated from synthetic typography;
- the two-engine route has enough evidence for Reviewer to judge MVP sufficiency;
- a dedicated Family Cookbook WordPress/WooCommerce testbed exists;
- Kadence/browser-local preview is exercised there;
- order-bound upload positive + negative access checks exist;
- private delivery positive + negative access checks exist;
- prior RETURN history remains preserved;
- all new evidence/handoff/code is committed to the same branch;
- `main` is not merged.

Successful return:

```text
PASS_CANDIDATE_G2A1_R1_ENVIRONMENT_REMEDIATION_COMPLETION
BRANCH=codex/family-cookbook-g2a1-input-ocr-component-feasibility
HEAD_COMMIT=<40-char SHA>
GITHUB_DELIVERY=COMMITTED
MAIN_MERGED=NO
STOP_AT_REVIEWER=YES
```

Otherwise return a precise `RETURN_*` and commit the new evidence when GitHub remains writable.
