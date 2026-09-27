# Family Cookbook Studio — Executor Handoff

## Gate

- Gate: `G2A1 — Input / OCR / Reusable Component Feasibility PoC`
- Execution state: `RETURN_G2A1_OCR_ENVIRONMENT_BLOCKED`
- Branch: `codex/family-cookbook-g2a1-input-ocr-component-feasibility`
- Branch baseline: `d61a2bf6098e91d8e5df0db464473df4ff9a07c6`
- Evidence snapshot commit / HEAD immediately before this handoff commit: `af0da16409bd5277015476b5f3d120b9967bf04c`.
- Final branch HEAD: supplied in the post-commit GitHub read-back / Executor return.
- GitHub delivery: `COMMITTED`
- Main merged: `NO`
- Stop at Reviewer: `YES`

## Completed facts

- Generated a 20-page synthetic fixture set and committed its metadata and deterministic renderer. Coverage includes printed/script-font text, skew, shadow, low contrast, mixed recipe sections, margin notes, abbreviations, mixed English/French, and required critical values.
- Implemented deterministic risk rules, crop-only TrOCR routing adapter, and a provenance-preserving recipe schema probe. Five local unit checks passed, including adversarial critical values, engine conflict fail-closed behavior, raw-text retention, and unresolved-unit uncertainty.
- Ran a static browser-local preview in Chrome 153.0.8010.54. It rendered a cover and sample spread, read a synthetic local file through a blob URL, issued zero HTTP/API attempts, had no upload form/download link, and removed its temporary Chrome profile.
- Wrote structured OCR output with explicit `null` for all inference metrics that were not measured.
- No payment, production write, customer data, or third OCR/VLM was used.

## Incomplete / blocked

- PaddleOCR full-page inference: **not run**. `paddlepaddle==3.3.1` / `paddleocr==3.7.0` install stalled at the 104.8 MB PaddlePaddle wheel download and was stopped after approximately 20 minutes.
- TrOCR crop inference: **not run**. Paddle output did not exist; Transformers/model weights were not installed/downloaded.
- OCR error rates, fallback resolution, user-confirmation burden, inference latency/CPU/GPU/RAM/VRAM, and MVP sufficiency: **UNKNOWN**.
- Kadence-integrated Family Cookbook browser preview: **BLOCKED**. The only observed Kadence WordPress install belonged to an unrelated local test project and was not modified; host port checks timed out. This is not evidence of a Kadence defect.
- Family Cookbook WooCommerce order-bound upload positive/negative checks: **BLOCKED**; no Family test instance/component was exercised.
- Synthetic private PDF positive/negative delivery checks: **BLOCKED**; no Family order-bound private storage/access path was exercised.

## Gate conclusions

- OCR primary: PaddleOCR remains the only primary engine by Reviewer architecture; performance is **unmeasured**.
- OCR fallback: TrOCR remains the only fallback by Reviewer architecture; value in reducing confirmation is **unmeasured**.
- Final uncertainty: `USER_CONFIRM_REQUIRED` remains the prescribed fail-closed rule; its actual burden is **unmeasured**.
- Preview: static browser-local, zero-token boundary is `PROVEN`; WordPress/Kadence integration is **not proven**.
- Upload: **BLOCKED / no result**.
- Private delivery: **BLOCKED / no result**.
- Third OCR/VLM: `NOT_USED`.

## Cleanup

- No test service was started or changed; unrelated WordPress containers were read-only inspected.
- The temporary Chrome profile was removed.
- The interrupted Python environment and incomplete zero-byte Git clone remain in local temporary locations because recursive cleanup outside the current workspace was denied by the Windows execution policy. Their processes were stopped; no model cache, secret, or private file was produced. Neither is part of the GitHub branch.

## Recommended Reviewer decision

Return this Gate for a bounded rerun in an environment that can finish local PaddleOCR/TrOCR dependency and checkpoint setup and exposes a dedicated Family Cookbook WordPress/WooCommerce test instance. Do not add a third OCR/VLM and do not open G2A2. Current recommendation: `RETURN_G2A1_OCR_ENVIRONMENT_BLOCKED`.


## G2A1-R1 Remediation Update — 2026-09-27

- Gate: `G2A1-R1 — OCR Runtime + WordPress Testbed Remediation / Completion`
- Execution state: `RETURN_G2A1_R1_RESOURCE_BLOCKED`
- Branch: `codex/family-cookbook-g2a1-input-ocr-component-feasibility`
- Branch HEAD at preflight: `b1bf844096fed4761372f3beea6f9f2d7d081643` (latest `main` Reviewer Handoff and R1 Contract re-read at `96b05c00ad8e5601dd4cef428709086ef1eb2991`; no merge/rebase).
- Carried-forward source: `b1bf844096fed4761372f3beea6f9f2d7d081643`; accepted prior evidence remains unchanged and the original `RETURN_G2A1_OCR_ENVIRONMENT_BLOCKED` history is preserved.
- New preflight: Windows 11, Python 3.10.11 x64, RAM 15.28 GiB total / 0.62 GiB available at latest sample; RTX 4050 with 5923/6141 MiB VRAM free; C: 152.7 GiB free; Torch 2.14.0+cu126 / CUDA 12.6. Package and Hugging Face metadata reachable, but OCR dependencies/models are not installed/cached.
- OCR conclusion: official PaddleOCR Transformers engine route is documented, but no PaddleOCR full-page inference or TrOCR crop inference ran. TrOCR small model revision and remote weight size are recorded as metadata only. Genuine handwriting results and all quality/fallback/confirmation metrics remain UNKNOWN.
- Preview: static browser-local preview is carried forward; Kadence + WordPress integration was not exercised.
- Upload: Family-specific order-bound upload positive/negative checks were not run.
- Delivery: Family-specific private PDF positive/negative checks were not run.
- Blocker: latest measured available host RAM was 0.62 GiB while unrelated WordPress/MariaDB stacks were active. No unrelated process/container was stopped, and no new test stack/model load was started.
- Cleanup: no new package cache, model weights, containers, orders, uploads or PDF test artifacts were created. Existing unrelated containers were left untouched.
- R1 evidence snapshot commit: `1483671c78b831686175c2cd35542087ad1baca3` (parent `b1bf844096fed4761372f3beea6f9f2d7d081643`), containing this remediation evidence and `g2a1/r1/preflight.json`.
- GitHub read-back immediately after that evidence commit showed this branch at `1483671c78b831686175c2cd35542087ad1baca3`; no `main` merge/rebase occurred. The final branch ref is read back again after this Handoff update and returned below.
- Recommended Reviewer decision: `RETURN_G2A1_R1_RESOURCE_BLOCKED`; keep the current OCR architecture and resume on this branch after fresh safe resource capacity is available. Stop at Reviewer; do not enter G2A2.

## G2A1-R2 — Isolated GitHub Actions Runner

- Gate: G2A1-R2 — Isolated GitHub Actions Runner Completion.
- Execution state: RETURN_G2A1_R2_OCR_ROUTE_INSUFFICIENT (Reviewer decision requested). Prior RETURN_G2A1_OCR_ENVIRONMENT_BLOCKED and RETURN_G2A1_R1_RESOURCE_BLOCKED history is preserved.
- Branch: codex/family-cookbook-g2a1-input-ocr-component-feasibility.
- Completed benchmark/testbed evidence: Actions run 36262841714, commit 9e803d04e40c7359096be10d3777a209f11161e4. This job concluded failure only on a preview harness field-name typo; it recorded real OCR outputs, full WordPress versions, and passing upload/private-delivery checks. Corrected final rerun 36263385997 was still in_progress at step 8 (PaddleOCR Transformers inference) at 2026-09-26 19:09 UTC; its conclusion and remaining steps were unavailable. It is not counted as a successful run. The completed benchmark/testbed evidence from run 36262841714 is sufficient to request Reviewer decision on measured OCR-route insufficiency.
- Actual completed scope:
  - Bounded, marker-guarded hosted GitHub Actions workflow and resource preflight. No repository Secrets. Random dummy credentials were generated and masked on-runner and removed. No Windows OCR/WP load; unrelated projects untouched.
  - PaddleOCR 3.7.0 full-page CPU inference with Transformers engine on 20 synthetic typography pages and 8 public genuine-handwriting samples. Benchmark: 62 erroneous lines, 32 missing lines, 13 critical-field errors, 60 suspicious regions.
  - TrOCR small handwritten model called on only 60 routed crops; 0 resolved, 60 unresolved, 60 disagreements. Manual confirmation: 69 / 28 pages = 2.464/page; no page without confirmation. TrOCR reduced confirmations by 0.
  - Family-specific ephemeral WordPress 7.1.2 + WooCommerce 11.1.2 + MariaDB 11.4.13 + free Kadence 1.5.2 created. Local preview used blob image, HTTP request delta 0 after file selection, zero OCR/model/token call. The completed run's aggregate assertion was false from a misspelled property; corrected in the latest rerun source.
  - Project-local order-bound adapter proved own-order upload/read, user B's own-order upload, anonymous/unrelated user/order denial, unsupported-type and over-size rejection, and responsive mobile width.
  - Synthetic PDF delivery positive/negative checks passed, including raw URL denial. Cleanup removed containers, volumes, network, test credential file and temporary swap.
- OCR conclusion: dual OCR path runs technically but measured evidence is insufficient for an MVP that reduces review burden. TrOCR resolved none of the routed cases; all 28 pages still required confirmation. OCR architecture unchanged; no third model.
- Preview result: measured browser blob source, no HTTP request delta after local file selection, zero OCR/model/token calls in run 36262841714. Run 36262841714 measured the preview request delta and browser-local path; the aggregate boolean was false from a property-name defect. The corrected assertion is present in source and was being rerun in Actions run 36263385997, which remained in progress at the recorded status check.
- Upload result: positive and negative HTTP checks passed in run 36262841714. Custom adapter, private outside-document-root storage.
- Delivery result: positive and negative checks passed in run 36262841714; raw URL returned 404.
- Blocker: RETURN_G2A1_R2_OCR_ROUTE_INSUFFICIENT due critical-field errors and zero TrOCR resolution/manual-review reduction. Latest marked run 36263385997 was in_progress at OCR step 8 at the recorded status check; no success is claimed. The completed run 36262841714 independently shows OCR-route insufficiency.
- Cleanup: completed run 36262841714 had Compose down exit 0, no containers/volumes/networks, credentials file removed and no swap left. Earlier run-specific bounded workflow defects/fixes are listed in EXECUTION_EVIDENCE.md.
- Recommended Reviewer decision: RETURN_G2A1_R2_OCR_ROUTE_INSUFFICIENT; retain PaddleOCR → deterministic suspicious routing → TrOCR crop fallback → USER_CONFIRM_REQUIRED unchanged and decide if measured burden meets product scope. Do not enter G2A2 from Executor.


## G2A1-R3A — Free / Local Primary Benchmark

- Gate: `G2A1-R3A — Free / Local Primary Benchmark`.
- Execution state: `PASS_CANDIDATE_G2A1_R3A_LOCAL_PRIMARY_SELECTION` (Executor candidate only; independent Reviewer decision required).
- Branch: `codex/family-cookbook-g2a1-input-ocr-component-feasibility`.
- Benchmark artifacts/source update commit: `2a9f242defc3f80f2e1b720b2db03a256c765070`, parent `3058603e6620617520335d06857e384b6eaf045d`. Evidence/Handoff finalization is committed immediately afterward; final branch HEAD is returned only after GitHub read-back.
- Actions evidence source: run `36289130217`, conclusion `success`, input commit `e9897c20dbe62fabd3a7e83f6de04966c28675dc`, artifact `10921757339`. PP-OCRv6_medium and PaddleOCR-VL-1.6 each processed all 35 inputs; per-sample input SHA-256 had zero mismatches. Run `36288635585` failed PaddleOCR-VL setup before its successful rerun due the missing official `doc-parser` extra. Run `36290381171` remained in progress at PaddleOCR-VL inference at 2026-09-27 04:23:38 UTC and is excluded from the selected evidence.
- Corpus: 20 synthetic typography recipe pages; 12 public English handwriting crops (7 complete transcriptions, 5 partial); 3 generated French/German/Spanish smoke probes. Handwriting sources are two historic Wellcome recipe manuscripts under CC BY 4.0. Complete-crop English handwriting score: PP 82.73%, VL 89.98%; partial transcripts are excluded from CER and extra text remains unverified.
- Semantic results: PP synthetic critical facts 77/77 correct, 0 synthetic critical errors, 0 confirmed hallucinations; one complete-handwriting critical miss, GH04 `8 eggs`. VL had 4 missing synthetic temperatures (F01/F02/F13/F20), 0 confirmed hallucinations. Both had 0 silent critical errors as measured; no missing full recipe lines or blank English output.
- Single-review burden on 20 full synthetic pages: PP 0 edit fields, 0 edited characters, 20/20 zero-edit pages; VL 8 fields, 24 chars, four critical fields manually corrected, 16/20 zero-edit pages. Both classify as `LIGHT_REVIEW`. Handwriting crop edits are reported separately: PP 8 fields / 43 chars on 7 complete crops (13 / 69 including partial labels); VL 6 / 22 on 7 complete crops (11 / 123 including partial labels), with one whole-line retype on partial-scope GH08.
- OCR conclusion: select `PP-OCRv6_medium`; reject `PaddleOCR-VL-1.6` as primary. The selection follows semantic-fidelity priority: PP has no synthetic critical errors; VL misses four expected temperatures and is substantially heavier. VL's higher handwriting score remains visible in `comparison.json`. Residual risk: GH04 missed count and sparse historical handwriting sample.
- Runtime: PaddleOCR 3.7.0 / PaddleX 3.7.0 / Transformers 5.10.0 / Torch 2.8.0+cpu; CPU only. PP inference 133.675 s, 2.02 GB sampled process RSS, 164.8 MB model storage. VL inference 520.060 s, 3.92 GB sampled process RSS, 2.05 GB model storage. Exact checkpoint hashes and runner preflight are committed in `g2a1/r3a/`.
- `fallback-evaluation-set.json` contains 11 primary unresolved/manual-review sample IDs for a later R3B evaluation. No API tested or called; Owner checkpoint required before R3B. No third OCR/VLM, Secrets, customer data, payment, production write, or main merge.
- Review burden applies to full synthetic pages; handwriting corrections are separate crop-level data. WordPress/WooCommerce/Kadence evidence remains carried forward from R2 and was not rerun in this OCR-only gate. Existing RETURN history remains preserved above.
- Recommended Reviewer decision: accept the R3A primary-selection candidate `PP-OCRv6_medium` for the current English-first MVP benchmark, retaining unified user correction/approval for critical and uncertain content; assess GH04, partial transcript scope, and the limited historical handwriting sample before a formal PASS. Require Owner checkpoint before any R3B cloud/API fallback work.
- Stop at Reviewer: `YES`; no G2A2, main merge, or production action.


## G2A1-R3B — Bounded API Fallback Benchmark

- Gate: G2A1-R3B — Bounded API Fallback Benchmark.
- Execution state: RETURN_G2A1_R3B_GOOGLE_CREDENTIAL_REQUIRED; the workflow completed its no-secret preflight successfully, but this is not an API benchmark result.
- Branch: codex/family-cookbook-g2a1-input-ocr-component-feasibility.
- Carried forward from 58030c1f7d611c5672bdeb0359d2df933704b9a2: Reviewer-accepted PRIMARY=PP-OCRv6_medium, fixed 11-case GH02–GH12 set, baseline 13 manual-edit fields / 69 characters / 1 critical error, and all earlier Gate/RETURN history.
- Actions input HEAD: 5febf66502c9bf9ef12c1a47926cb78180bb3f55; Actions run: 36297499256, conclusion success; hosted Ubuntu 24.04.5. Workflow installed pinned dependencies, passed pip check and Python syntax compilation, validated the fixed corpus, and wrote compact preflight/results artifacts.
- Implemented: Google Enterprise Document OCR client and Google-first/Mistral-only-if-insufficient dispatch; fixed dataset mapping; reuse of the R3A semantic/manual-edit scorer; conservative budget guard; Secret-presence-only preflight. Google client: YES; scoring implemented: YES; scoring executed: NO because the run exited at credential preflight.
- Secret presence: Google credentials/project/location/processor and MISTRAL_API_KEY were all absent. No credential value was exposed.
- OCR/API outcome: GOOGLE_API_CALLED=NO; MISTRAL_TESTED=NO; request attempts 0; provider OCR cost $0.00; token cost 0. Max planned API page-list-price spend if fully exercised is $0.0605 against the authorized $0.20 ceiling.
- Hard-case edit burden after API: UNKNOWN; PP baseline remains 13 fields / 69 characters. Critical errors, hallucinations, latencies, and provider comparison remain UNKNOWN.
- Selection: PRIMARY=PP-OCRv6_medium; FALLBACK=UNKNOWN. Do not interpret the absence of calls as evidence for FALLBACK=NONE.
- Artifacts committed under g2a1/r3b/: provider preflight, 11 not-called Google rows, not-run comparison, decision, and cost summary. There is no Mistral artifact because Phase B did not run. Artifact source: run 36297499256, archive digest sha256:4cfe44a32bc385f84d45023ec8effd52bc592df53bb1eebf2fc754828ba06ca9.
- Blocker: Owner/provider setup must add the exact Google Document AI test credentials/configuration as GitHub Actions Secrets through GitHub's protected settings, then a separately authorized marked rerun can test Google; do not send Secret values in chat. If Google is insufficient, only then evaluate Mistral under the same cap.
- Cleanup: Actions runner temp data and venv were deleted; temporary local downloaded artifact ZIP was deleted. No source crops, model cache, API responses, or credentials were retained.
- Main merged: NO. G2A2 entered: NO. Stop at Reviewer: YES.
- Recommended Reviewer decision: RETURN_G2A1_R3B_GOOGLE_CREDENTIAL_REQUIRED for provider setup; do not decide API fallback selection yet. The final branch HEAD is in the post-commit GitHub read-back / Executor return.

- Final source recheck: GitHub main HEAD was 0da0ff21823d6cade2b34d9ab623fc2be92e85a8. Latest Family Cookbook Reviewer Handoff, Document Index, R3B Owner Checkpoint, R3B Benchmark, and R3 architecture docs were re-read; their blob SHAs match the initial R3B truth snapshot. The execution branch remains separate; no merge/rebase.


## G2A1-R3B Mistral Free-Mode Return — 2026-09-27

```text
RETURN_G2A1_R3B_MISTRAL_FREE_MODE_RATE_LIMIT_BLOCKED

ACTIONS_RUN_ID=36303291445
MISTRAL_API_KEY_PRESENT=YES
MISTRAL_OCR_SUCCESSFUL_PAGES=0
HTTP_402_PAYMENT_REQUIRED=NO
HTTP_429_RATE_LIMIT=YES
FALLBACK=UNKNOWN
SECRET_VALUE_EXPOSED=NO
MAIN_MERGED=NO
STOP_AT_REVIEWER=YES
```

Reviewer direction: stop Mistral Free-mode retries; restore Google WIF path and wait for Google Billing activation.


## G2A1-R3B Baidu Handwriting OCR — Reviewer Evidence

```text
PASS_CANDIDATE_G2A1_R3B_BAIDU_CRITICAL_SECOND_OPINION

ACTIONS_RUN_ID=36305680927
PRIMARY=PP-OCRv6_medium
CANONICAL_TRANSCRIPT_FALLBACK=NONE
CRITICAL_SECOND_OPINION=BAIDU_HANDWRITING_OCR

BAIDU_ATTEMPTED_PAGES=11
BAIDU_SUCCESSFUL_PAGES=11

BASELINE_MANUAL_EDIT_FIELDS=13
BAIDU_MANUAL_EDIT_FIELDS=12

BASELINE_MANUAL_EDIT_CHARS=69
BAIDU_MANUAL_EDIT_CHARS=100

BASELINE_CRITICAL_ERRORS=1
BAIDU_CRITICAL_ERRORS=0

NEW_SILENT_CRITICAL_ERRORS=0
NEW_HALLUCINATIONS=0

FREE_PATH_ONLY=YES
PAID_MODE_AUTHORIZED=NO

MAIN_MERGED=NO
STOP_AT_REVIEWER=YES
```

Reviewer interpretation: Baidu is useful only as a critical-field second opinion, not as wholesale transcript replacement.
