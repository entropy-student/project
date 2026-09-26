# G2A1-R2 — Isolated GitHub Actions Runner Completion

> Reviewer remediation contract  
> Status: **CURRENT / READY_FOR_EXECUTOR**  
> Parent truth: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)  
> Execution branch: `codex/family-cookbook-g2a1-input-ocr-component-feasibility`  
> Accepted R1 RETURN HEAD: `f79891f20c973e93586e41319c0abb7e78b3af4c`

## 1. Reviewer Decision

G2A1-R1 is formally **RETURNED: RESOURCE BLOCKED**.

Accepted R1 facts:

- latest local Windows preflight measured only **0.62 GiB available RAM** on a 15.28 GiB host;
- unrelated WordPress/MariaDB workloads were already running;
- Executor correctly did not stop unrelated workloads and did not start model/testbed load;
- GPU VRAM and disk were available, but host RAM remained the controlling safety blocker;
- PaddleOCR/TrOCR inference and Family Cookbook WordPress/WooCommerce probes therefore remain unmeasured.

This is **not evidence against the OCR architecture**.

Reviewer decision: stop retrying this Gate on the current user workstation. Move the remaining PoC to an isolated, ephemeral, non-production GitHub Actions runner.

The repository is public and already has successful GitHub Actions history. Exact runner capacity, quota and workflow permissions must still be preflighted at execution time.

## 2. Goal

Complete only the still-unproven G2A1 evidence on an isolated runner:

1. real PaddleOCR full-page inference;
2. real TrOCR fallback on routed crops;
3. genuine-handwriting benchmark subset;
4. user-confirmation burden and resource measurements;
5. dedicated ephemeral WordPress + WooCommerce + Kadence testbed;
6. order-bound upload positive/negative checks;
7. private delivery positive/negative checks.

Do not repeat accepted deterministic routing/schema/static preview work unless required by an integration change.

## 3. Execution Environment

Preferred environment:

**GitHub Actions hosted Ubuntu runner**

Reason:
- isolated from the user's resource-constrained workstation;
- ephemeral and non-production;
- repository already has working Actions history;
- supports reproducible test evidence;
- does not require touching Shared VPS or unrelated local projects.

This Gate does not authorize:
- Shared VPS use;
- production deployment;
- paid cloud/GPU purchase;
- RunPod purchase/start;
- secrets beyond ephemeral test-only generated values.

If GitHub Actions cannot run because of repository quota/billing/permission restrictions, return:

`RETURN_G2A1_R2_ACTIONS_UNAVAILABLE`

Do not silently switch to a paid environment.

## 4. Git / Branch Contract

Continue the same branch:

`codex/family-cookbook-g2a1-input-ocr-component-feasibility`

Read current `main` Reviewer truth first.

Preserve both prior returns:
- `RETURN_G2A1_OCR_ENVIRONMENT_BLOCKED`
- `RETURN_G2A1_R1_RESOURCE_BLOCKED`

Do not merge/rebase unrelated `main` project drift merely to execute this Gate.

A Gate-scoped workflow may be added under:

`.github/workflows/family-cookbook-g2a1-r2.yml`

The workflow must be branch-scoped and bounded so it does not become a generic production workflow.

Recommended trigger:
- push to the exact execution branch;
- job-level guard requiring a clear commit marker such as `[g2a1-r2-run]`.

Do not merge the workflow to `main` in this Gate.

## 5. Actions Safety / Permissions

Use minimum permissions.

Default:
```yaml
permissions:
  contents: read
```

The workflow itself should not commit back to the repository and should not require repository Secrets.

Evidence may be:
- workflow logs;
- uploaded Actions artifacts;
- Executor read-back;
- then committed by Executor to the execution branch.

Use ephemeral test credentials generated inside the job only. Never print sensitive generated values unnecessarily and never commit them.

## 6. Runner Resource Preflight

First job step must record:

- runner OS/image;
- CPU count/model if available;
- total/available RAM;
- free disk;
- Docker availability;
- Python version;
- network reachability to required public package/model sources.

Safe minimum guidance for combined model/test work:
- if available RAM is materially insufficient before model load, stop that job and return measured evidence;
- do not manufacture PASS by killing unrelated runner/system processes;
- an ephemeral swap file may be used only if clearly recorded and only on the isolated runner.

Do not assume the hosted runner has enough memory; measure it.

## 7. OCR Architecture — unchanged

```text
PaddleOCR primary
→ deterministic confidence / critical-value routing
→ suspicious crop only → Microsoft TrOCR
→ unresolved / disagreement → USER_CONFIRM_REQUIRED
```

Forbidden:
- Tesseract;
- cloud OCR;
- GPT/Gemini/Claude Vision;
- third OCR/model.

## 8. PaddleOCR on Actions

Prefer the currently documented PaddleOCR Transformers inference route when compatible with the selected pipeline.

Requirements:
- pin exact versions;
- record exact model/revision where available;
- use CPU if that is the reliable hosted-runner route;
- model/API Token = 0;
- adapt existing runner code to the actual installed API;
- do not rely on the previous Windows-specific PaddlePaddle wheel path.

If PaddleOCR cannot run on the Actions runner after bounded remediation, return a precise runtime blocker.

## 9. TrOCR on Actions

Use:

`microsoft/trocr-small-handwritten`

Only for actual routed suspicious crops.

Record:
- model revision/hash;
- weight size;
- device;
- fallback count;
- latency;
- Paddle result;
- TrOCR result;
- resolution outcome;
- `USER_CONFIRM_REQUIRED`.

No larger model substitution without Reviewer return.

## 10. Genuine Handwriting

Add 5–10 public/open genuine-handwriting samples with source/license/provenance metadata.

Keep results separated into:
- `SYNTHETIC_TYPOGRAPHY`
- `GENUINE_HANDWRITING`

Do not claim real handwriting performance from synthetic fonts.

## 11. OCR Evidence Required

Measure at minimum:

- Paddle pages processed;
- raw/missing-line error metrics where ground truth exists;
- critical-field errors;
- suspicious regions;
- TrOCR fallback count/rate;
- TrOCR resolved/unresolved;
- engine disagreements;
- `USER_CONFIRM_REQUIRED` total;
- confirmations per page;
- pages without confirmation ratio;
- latency;
- peak/process RAM observations;
- disk/model footprint;
- model/API Token usage.

## 12. WordPress / WooCommerce Ephemeral Testbed

Use an Actions job with ephemeral Docker/Compose or equivalent.

Create a dedicated Family Cookbook test stack only inside the runner.

Components:
- WordPress;
- MariaDB/MySQL;
- WooCommerce;
- Kadence free;
- project-local preview/proof adapter as needed.

Requirements:
- unique local ports/network;
- no public deployment;
- no production domain;
- no real payment/provider;
- no external private data;
- no persistent DB after job completion.

## 13. Preview Integration

Prove inside the Family testbed:

- local image preview works before payment;
- image remains browser-local;
- no OCR/model call;
- no server upload before payment;
- 0 model Token;
- no full cookbook download.

Browser/network automation evidence is preferred.

## 14. Order-bound Upload Probe

Using dummy WooCommerce orders + synthetic images:

Positive:
- intended order/user upload/access works.

Negative:
- anonymous denied;
- unrelated user/order denied;
- raw public URL does not bypass authorization.

Record:
- component/plugin/custom adapter;
- file type/size behavior;
- binding metadata;
- positive and negative HTTP/browser outcomes.

## 15. Private Delivery Probe

Using a synthetic PDF:

Positive:
- intended order/user can access.

Negative:
- anonymous denied;
- unrelated user denied;
- unrelated order denied;
- no public raw-file bypass.

## 16. Workflow Artifacts

Upload compact artifacts only, for example:

- OCR benchmark JSON;
- genuine-handwriting source metadata;
- fallback result JSON;
- WordPress test summary JSON;
- selected screenshots/log excerpts if needed.

Do not upload:
- model caches;
- full dependency trees;
- DB volumes;
- credentials;
- large disposable binaries.

## 17. Carry-forward Evidence

Accepted from earlier runs:

From `b1bf844096fed4761372f3beea6f9f2d7d081643`:
- synthetic fixture renderer;
- deterministic routing/schema tests;
- static zero-network preview.

From `f79891f20c973e93586e41319c0abb7e78b3af4c`:
- local Windows resource blocker;
- package/model metadata reachability observations;
- decision not to disturb unrelated workloads.

Final evidence must clearly distinguish:
- `CARRIED_FORWARD`
- `NEW_PROVEN_ACTIONS`
- `UNKNOWN`
- `BLOCKED`.

## 18. Forbidden

- real payment;
- customer/private recipe data;
- third OCR/VLM;
- production/VPS deployment;
- Shared Infra mutation;
- paid cloud/GPU purchase;
- repository Secrets unless a new Reviewer/Owner checkpoint explicitly authorizes one;
- workflow committing/merging to `main`;
- starting G2A2.

## 19. PASS_CANDIDATE Criteria

PASS_CANDIDATE requires:

- GitHub Actions run completed with reproducible evidence;
- PaddleOCR real inference ran;
- TrOCR real routed-crop inference ran;
- genuine handwriting was separately measured;
- user-confirmation burden measured;
- two-engine route provides enough evidence for Reviewer judgment;
- ephemeral Family WP/Woo/Kadence testbed ran;
- preview integration proved;
- upload positive + negative access proved;
- private delivery positive + negative access proved;
- no third OCR/VLM/payment/production work;
- Actions artifacts/logs read back;
- Evidence + Handoff updated and committed to the same execution branch;
- `main` not merged.

Return:

```text
PASS_CANDIDATE_G2A1_R2_ISOLATED_RUNNER_COMPLETION
BRANCH=codex/family-cookbook-g2a1-input-ocr-component-feasibility
HEAD_COMMIT=<40-char SHA>
ACTIONS_RUN_ID=<run id>
ACTIONS_CONCLUSION=success
GITHUB_DELIVERY=COMMITTED
MAIN_MERGED=NO
STOP_AT_REVIEWER=YES
```

Otherwise return a precise `RETURN_*`, including Actions run ID when a run exists.
