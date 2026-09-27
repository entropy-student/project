# G2BR1 — Real AI Generation Closure

> Reviewer execution contract  
> Status: OWNER AUTHORIZED — preferred path is ChatGPT-authenticated Codex CLI; local signed-in Codex runtime required  
> Parent Gate: `G2B_LOCAL_AI_PDF_SOLUTION_PROOF`  
> Accepted partial evidence: PR #30 / merged G2B reference pipeline

## Goal

Close only the remaining G2B AI-proof gap:

```text
existing synthetic intake
→ REAL model structured generation
→ grounding/schema validation
→ existing deterministic page renderer
→ 12-page US Letter PDF
→ existing deterministic QA
```

Do not rebuild already accepted reference-pipeline work.

## Owner authorization / execution path

Owner authorization is **complete**.

### Preferred G2BR1 path — ChatGPT Plus / Codex

Run the real-model generation in a local Codex CLI/client signed in with the Owner's ChatGPT account.

Required pattern:

```text
existing synthetic intake
→ codex exec
→ --output-schema <content-schema.json>
→ generated structured JSON
→ existing grounding / renderer / QA pipeline
```

No OpenAI API key is required for this route.

The implementation should add the smallest possible `CodexExecProvider` (or equivalent wrapper) that:
- launches one `codex exec` process;
- supplies only the synthetic intake/prompt;
- constrains final output with the existing content JSON Schema;
- writes model output to a dedicated generated JSON artifact;
- never falls back to `reference-content.json` for PASS;
- can be blocked by the existing canonical-job/idempotency guard before launching Codex.

Use a read-only/suitably restricted Codex permission profile for the model-generation subprocess where practical; the subprocess only needs to read synthetic prompt/schema inputs and emit its final JSON output.

### API path — fallback only

The existing Chat Completions adapter may remain as an alternative, but G2BR1 does not require purchasing API usage if the Codex Plus path succeeds.

Never store or print credentials or ChatGPT session tokens.

## Run limit

Unless Owner explicitly approves otherwise:

- one fixture;
- maximum **three real-model runs total**;
- preferred mode: Codex CLI signed in with ChatGPT;
- retries only for schema/runtime/transient failure;
- no exploratory model bakeoff;
- no real customer data;
- do not automatically purchase extra Codex credits.

Record model-run count and reason for any retry without recording auth/session secrets.

If available plan allowance is exhausted, return:

`RETURN_CODEX_PLAN_LIMIT_REACHED`

## Reuse accepted work

Do not broadly rerun/rebuild:

- intake schema;
- synthetic photo fixtures;
- metadata mapping design;
- page architecture;
- style presets;
- PDF renderer;
- deterministic QA framework.

Use the existing G2B harness as the baseline.

## Must prove

### 1. Real structured generation
- real model run count >= 1;
- preferred evidence: successful ChatGPT-authenticated `codex exec`;
- no human reference fixture fallback;
- model output conforms to `CONTENT_SCHEMA`;
- execution mode + model identifier recorded where the client exposes it;
- no API key or ChatGPT auth token recorded.

### 2. Grounding
On actual model output:

- every factual claim has valid source references;
- source refs resolve to the synthetic intake;
- supporting quotes/excerpts are present and grounded;
- no invented trip/date/quote/hobby/achievement/relationship/preference;
- unsupported factual output fails closed.

If the current grounding implementation is insufficient for actual model prose, make only the smallest required validation change.

### 3. Dynamic modules
Actual model output must:

- choose exactly two;
- choose distinct modules;
- choose only from the frozen allowed pool;
- have source evidence supporting each selection.

### 4. Render actual model output
Use actual provider-generated structured content to produce:

- exactly 12 pages;
- US Letter;
- non-zero PDF;
- all required sections;
- no broken images;
- no text clipping/overflow;
- no fallback to `reference-content.json`.

### 5. Real-model-run idempotency
Prove the local canonical-job boundary prevents a duplicate invocation from launching a second paid/allowance-consuming model run.

Preferred Codex evidence:

```text
canonical_jobs=1
successful_generation_for_job=1
duplicate_invocation_rejected_before_codex_exec=PASS
codex_exec_run_count_for_canonical_job=1
```

If a retry is required due schema/runtime/transient failure, distinguish:
- retry within the same canonical job;
- duplicate job invocation.

Do not claim this proof merely from zero model runs.

## Accepted limitations

Photo mapping may remain metadata-only for this closure because that limitation was explicitly accepted in G2B partial evidence.

Do not add vision/model-based photo understanding in G2BR1.

## Evidence

Update:

- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Retain sanitized:

- actual model-generated structured JSON;
- grounding report;
- sanitized model-execution status report;
- actual-AI 12-page PDF;
- QA report;
- Codex/model-run-count + idempotency evidence;
- screenshots/contact sheet if output materially changed.

Do not commit:
- API key;
- Authorization header;
- secret environment dump;
- account identifiers not needed for evidence.

## GitHub handoff

Mandatory:

- dedicated branch, suggested:
  `codex/birthday-magazine-g2br1-real-ai-closure`
- commit;
- push;
- PR to `main`;
- do not self-merge;
- return final branch + final commit SHA + PR number/URL.

## Forbidden

- product-contract changes;
- AI-generated imagery;
- PayPal/payment;
- WordPress/WooCommerce commerce loop;
- real customer data;
- production email;
- VPS/public deployment;
- Shared Infra changes;
- G3 work.

## PASS_CANDIDATE

```text
GATE=G2BR1_REAL_AI_GENERATION_CLOSURE
RESULT=PASS_CANDIDATE_G2BR1_REAL_AI_GENERATION_CLOSURE

REAL_AI_CALL=PASS
STRUCTURED_SCHEMA=PASS
GROUNDING_AUDIT=PASS
DYNAMIC_MODULES=PASS
ACTUAL_AI_PDF_12_PAGES=PASS
DETERMINISTIC_QA=PASS
REAL_MODEL_RUN_IDEMPOTENCY=PASS

EXECUTION_MODE=CODEX_CHATGPT_LOGIN
MODEL=<model identifier if exposed>
MODEL_RUN_COUNT=<integer>

GIT_BRANCH=<branch>
GIT_COMMIT=<final sha>
GITHUB_PR=<number/url>

FORBIDDEN_ACTIONS=0
G3_STARTED=NO
STOP_AT_REVIEWER=YES
```

If the local Codex client is not signed in with ChatGPT:

`RETURN_CODEX_CHATGPT_LOGIN_REQUIRED`

If the available Codex plan allowance is exhausted:

`RETURN_CODEX_PLAN_LIMIT_REACHED`

If falling back to the API path and provider access cannot be safely supplied:

`RETURN_AI_PROVIDER_CREDENTIAL_REQUIRED`

If actual model output cannot pass grounding/schema/layout within the bounded attempts:

return the exact failure; do not fall back to the human reference fixture and claim PASS.
