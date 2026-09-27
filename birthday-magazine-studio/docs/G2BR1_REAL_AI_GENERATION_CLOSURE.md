# G2BR1 — Real AI Generation Closure

> Reviewer execution contract  
> Status: BLOCKED_BY_OWNER_CHECKPOINT — authorized only after protected provider credential + bounded call approval  
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

## Owner-only checkpoint before execution

Required:

- one approved provider/model/runtime;
- protected credential available to the Executor runtime;
- explicit approval for the bounded synthetic-only model calls.

Never store or print the credential.

Existing optional runtime interface:

```text
BMS_AI_CALL_APPROVED=true
BMS_AI_CHAT_COMPLETIONS_URL=<protected runtime value>
BMS_AI_MODEL=<approved model>
BMS_AI_API_KEY=<protected secret>
```

Equivalent protected injection is acceptable.

No `.env` file should be committed.

## Call limit

Unless Owner explicitly approves otherwise:

- one fixture;
- maximum three provider requests total;
- retries only for provider/schema/transient failure;
- no exploratory model bakeoff;
- no real customer data.

Record request count and reason for any retry without recording secrets or private authorization headers.

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
- provider request count >= 1;
- no human reference fixture fallback;
- model output conforms to `CONTENT_SCHEMA`;
- exact provider/model identifier recorded, but no credential.

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

### 5. Provider-spend idempotency
Prove the local canonical-job boundary prevents a duplicate invocation from creating a second provider spend.

Required evidence:

```text
canonical_jobs=1
successful_generation_for_job=1
duplicate_invocation_rejected_before_provider_call=PASS
provider_request_count_for_canonical_job=1
```

If a retry is required due provider/schema failure, distinguish:
- retry within the same canonical job;
- duplicate job invocation.

Do not claim duplicate-spend proof merely from zero provider calls.

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
- AI provider status report;
- actual-AI 12-page PDF;
- QA report;
- provider request-count/idempotency evidence;
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
PROVIDER_SPEND_IDEMPOTENCY=PASS

PROVIDER=<sanitized provider name>
MODEL=<model identifier>
PROVIDER_REQUEST_COUNT=<integer>

GIT_BRANCH=<branch>
GIT_COMMIT=<final sha>
GITHUB_PR=<number/url>

FORBIDDEN_ACTIONS=0
G3_STARTED=NO
STOP_AT_REVIEWER=YES
```

If provider access still cannot be safely supplied:

`RETURN_AI_PROVIDER_CREDENTIAL_REQUIRED`

If actual model output cannot pass grounding/schema/layout within the bounded attempts:

return the exact failure; do not fall back to the human reference fixture and claim PASS.
