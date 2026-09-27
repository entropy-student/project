# G2A1-R3C — ChatGPT-Plan Codex Vision Internal Benchmark

> Reviewer execution contract  
> Status: **CURRENT / READY_FOR LOCAL CODEX EXECUTION**  
> Parent truth: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)  
> Owner approval: **GRANTED 2026-09-27**  
> Scope: internal benchmark only; no production acceptance implied.

## 1. Goal

Test whether the user's existing ChatGPT-plan Codex vision capability materially improves the same 11 public handwriting hard cases already used in R3A/R3B.

This Gate answers:

> Does ChatGPT-authenticated Codex vision provide enough transcription / critical-fact improvement to justify keeping it as an internal development-time second opinion?

It does **not** decide that Codex CLI or a ChatGPT subscription is an accepted production API.

## 2. Fixed comparison

Use the exact same 11 public/non-private hard cases from:

`g2a1/r3a/fallback-evaluation-set.json`

Compare:

1. `PP-OCRv6_medium` baseline;
2. Baidu Handwriting OCR evidence from R3B;
3. ChatGPT-plan Codex vision result from this Gate.

Do not add new samples during R3C.

## 3. Authentication boundary

R3C must use the user's **existing ChatGPT-authenticated Codex CLI session**.

Required:
- `codex login status` must indicate a ChatGPT login/session rather than an API-key login;
- `OPENAI_API_KEY` must not be present;
- `OPENAI_BASE_URL` must not redirect Codex to Sub2API or another gateway;
- `CODEX_API_KEY`, `CODEX_ACCESS_TOKEN`, workload-identity variables, and other explicit machine credentials must not be used.

If authentication cannot be classified as ChatGPT-plan login:

`RETURN_G2A1_R3C_AUTH_NOT_CHATGPT_PLAN`

Do not fall back to API billing.

## 4. No Sub2API in R3C

Sub2API has been researched separately and is technically capable of wrapping OpenAI OAuth / ChatGPT Codex access behind an API-shaped gateway.

However R3C deliberately does **not** deploy or use Sub2API.

Reason:
- first test the underlying ChatGPT-plan Codex visual capability through the official Codex client;
- avoid adding a gateway, refresh-token store, account proxy, or production coupling before quality is proven.

Sub2API may be revisited only after R3C if there is a compelling internal-only workflow need.

## 5. Public data only

Allowed:
- the 11 already accepted public/open benchmark handwriting crops.

Forbidden:
- customer recipes;
- private family photos;
- private documents;
- production order data.

## 6. Fair benchmark isolation

Codex must not see the ground truth, R3A corpus annotations, Baidu outputs, PP outputs, or benchmark scoring files while transcribing a crop.

For every sample:
- create an isolated temporary working directory;
- place only the crop image + JSON output schema in that directory;
- run `codex exec` from that directory;
- prompt Codex to inspect only the local image using its image-view capability;
- do not use web search;
- do not use repository/search tools;
- do not infer recipe content from culinary knowledge.

This avoids benchmark leakage.

## 7. Transcription prompt invariant

Use the same instruction for every crop:

```text
This is an OCR fidelity benchmark.

Inspect sample.jpg with the local image-view tool.

Transcribe only what is visibly supported by the image.
Preserve spelling, punctuation, line breaks, numbers, fractions, units and abbreviations as faithfully as possible.
Do not rewrite for grammar.
Do not normalize a recipe.
Do not use culinary knowledge to fill missing text.
If a character or span cannot be read with confidence, use ? rather than guessing.

Return only the structured result required by the supplied JSON schema.
```

## 8. Structured output

Use official `codex exec --output-schema` support.

Each result must contain:
- sample_id;
- transcription;
- uncertain_segments[];
- critical_candidates[].

The transcription itself is the input to the existing R3A semantic/edit-burden scorer.

## 9. Image capability

The Codex run may use the local `view_image` capability to attach the crop image to the turn.

If the current ChatGPT-authenticated Codex model/session cannot inspect the local image:

`RETURN_G2A1_R3C_CODEX_IMAGE_INPUT_BLOCKED`

Do not switch to an API key or external VLM.

## 10. Execution environment

Preferred: the Owner's already logged-in local Codex environment.

This is intentionally not GitHub Actions because personal ChatGPT-plan login credentials must not be exported into repository Secrets or CI.

The benchmark itself is lightweight locally:
- public image download/crop preparation;
- remote Codex inference;
- local JSON scoring.

No Paddle/PaddleOCR inference is rerun.

## 11. Runner evidence

Record only non-secret facts:
- `codex --version`;
- sanitized authentication classification: `CHATGPT_PLAN`;
- OS/Python;
- sample count;
- elapsed time per sample;
- success/failure;
- result JSON.

Do not commit:
- auth files;
- OAuth/access/refresh tokens;
- account email;
- account IDs;
- home-directory auth/config contents;
- raw `codex login status` output if it contains identifying information.

## 12. Scoring

Use the same R3A scorer and accepted hard-case baseline.

Required metrics:
- critical semantic errors;
- silent critical errors;
- missing critical facts;
- unsupported hallucinations;
- manual edit fields;
- manual edit characters;
- whole-line retypes;
- per-sample improved / unchanged / worsened.

Compare directly to:

### PP-OCRv6 baseline
- manual edit fields: 13
- manual edit chars: 69
- critical errors: 1
- silent critical errors: 0

### Baidu whole-text candidate
- manual edit fields: 12
- manual edit chars: 100
- critical errors: 0
- silent critical errors: 0

Baidu's accepted role remains critical-field second opinion unless R3C evidence justifies a later Reviewer architecture change.

## 13. Decision classes

### A. Codex materially better as internal whole-transcript verifier

Possible only if:
- critical errors = 0;
- silent critical errors = 0;
- confirmed hallucinations = 0;
- manual edit burden is materially lower than PP;
- no benchmark leakage.

Return:

`PASS_CANDIDATE_G2A1_R3C_CODEX_INTERNAL_WHOLE_TRANSCRIPT_BETTER`

This still does not authorize production website use.

### B. Codex useful only as critical second opinion

If it recovers critical facts / resolves risky crops but whole-text improvement is not strong enough:

`PASS_CANDIDATE_G2A1_R3C_CODEX_CRITICAL_SECOND_OPINION_ONLY`

### C. No material benefit

If it does not beat the existing PP + Baidu critical-opinion design:

`PASS_CANDIDATE_G2A1_R3C_CODEX_NO_MATERIAL_BENEFIT`

## 14. Production boundary

Even if Codex wins this benchmark:

- do not replace the production provider contract;
- do not add `shell_exec("codex exec")` to WordPress;
- do not deploy ChatGPT login credentials to a server;
- do not enable Sub2API automatically;
- do not send customer/private images through this path.

A positive R3C result means only:

> ChatGPT-plan Codex vision is useful for the Owner's internal development / difficult-case inspection.

Any customer-facing use requires a separate architecture, privacy and terms review.

## 15. Required artifacts

Under:

`family-cookbook-studio/g2a1/r3c/`

Create:
- `codex-transcription.schema.json`
- `run_codex_plan_benchmark.py`
- `codex-results.json` after execution
- `codex-comparison.json` after execution
- `final-internal-benchmark-decision.json` after execution

Update after execution:
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

## 16. Stop boundary

R3C temporarily precedes G2A2 because a strong vision result could change the internal fallback strategy.

Do not:
- use API billing;
- use Sub2API;
- use private/customer data;
- merge execution branch to main;
- enter G2B.

Stop at Reviewer.
