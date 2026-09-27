# G2A1-R3B — Bounded API Fallback Benchmark

> Reviewer execution contract  
> Status: **RETURNED / GOOGLE BILLING OWNER ACTION**  
> Parent truth: [../REVIEWER_HANDOFF.md](../REVIEWER_HANDOFF.md)  
> Owner approval: **GRANTED 2026-09-27**  
> Accepted primary: `PP-OCRv6_medium`  
> R3A evidence HEAD: `ad58cfe3b3fbfcca6a6f1ee3e929754c2c3b14e5`

## 1. Owner Authorization

Owner authorizes this bounded R3B test only:

- dataset: the 11 public/non-private hard handwriting samples from R3A;
- provider order:
  1. Google Enterprise Document OCR first;
  2. Mistral OCR 4.1 only if Google is materially insufficient;
- Gemini/general VLM is not authorized in this Gate;
- total real external API test budget cap: **USD 0.20**;
- no customer/private recipe data;
- no production integration;
- no main merge;
- no G2A2;
- Secrets must never appear in repository files, evidence, logs, or chat.

This approval does not authorize broader cloud spend, production provider onboarding, or customer-data processing.

## 2. Goal

Determine whether one specialized API fallback materially improves PP-OCRv6_medium on its 11 unresolved/high-risk handwriting cases.

The product architecture under test is:

```text
PP-OCRv6_medium
→ semantic/critical-risk routing
→ only hard pages/crops → at most one specialized OCR API
→ one consolidated user review with manual editing
```

R3B must select exactly one of:

- `FALLBACK=GOOGLE_ENTERPRISE_DOCUMENT_OCR`
- `FALLBACK=MISTRAL_OCR_4_1`
- `FALLBACK=NONE`

## 3. Fixed Evaluation Set

Use exactly the R3A committed:

`family-cookbook-studio/g2a1/r3a/fallback-evaluation-set.json`

Count: 11.

Do not expand the dataset during this Gate except to repair a broken/non-reproducible source reference; any replacement must be explicitly documented and must remain public/non-private.

Do not send:
- synthetic pages already solved by PP-OCRv6;
- normal/easy pages;
- customer/private images;
- unrelated documents.

## 4. Google First

First provider:

**Google Enterprise Document OCR**

Use its handwritten-document OCR capability on only the 11 hard cases.

Expected test inputs/metadata:
- public image/crop;
- language hint when supported and appropriate;
- handwriting hint when supported;
- no customer identifiers.

Capture:
- raw OCR text;
- confidence where available;
- bounding/layout data where useful;
- latency;
- request/page count;
- estimated/list-price cost;
- HTTP/API status without leaking credentials.

## 5. Google Decision Rule

Compare Google result against PP-OCRv6 on the same 11 cases.

Google is considered materially useful if it improves at least one of:

- critical fact recovery;
- manual edit fields;
- manual edit characters;
- whole-line retranscription burden;

while introducing **no**:
- silent wrong critical fact;
- unsupported hallucinated recipe fact;
- materially worse fidelity on previously correct content.

If Google meets this bar:

```text
FALLBACK=GOOGLE_ENTERPRISE_DOCUMENT_OCR
MISTRAL_TESTED=NO
```

Stop. Do not call Mistral.

If Google does not materially improve the hard-case set, proceed to Mistral.

## 6. Mistral Second

Only if Google is insufficient:

**Mistral OCR 4.1**

Use the same 11 hard cases or the subset still unresolved after Google, but comparison reporting must remain traceable to all 11 IDs.

Capture:
- raw OCR text;
- confidence/bbox/blocks where available;
- latency;
- request/page count;
- estimated/list-price cost;
- API status without credentials.

Use the same semantic/manual-edit scoring rules as Google.

If Mistral materially improves fidelity/edit burden without new silent critical errors:

`FALLBACK=MISTRAL_OCR_4_1`

Otherwise:

`FALLBACK=NONE`

## 7. Gemini Not Authorized

Do not call:
- Gemini;
- OpenAI Vision;
- Claude Vision;
- any general VLM;
- any third OCR provider.

If both specialized OCR providers fail, return `FALLBACK=NONE` rather than expanding the Gate.

## 8. Secret Boundary

Executor may use only GitHub Actions Secrets / provider-side credentials supplied by Owner.

### Google expected secret interface

Use repository Actions secrets such as:

- `GOOGLE_DOC_AI_CREDENTIALS_JSON`
- `GOOGLE_CLOUD_PROJECT`
- `GOOGLE_DOC_AI_LOCATION`
- `GOOGLE_DOC_AI_PROCESSOR_ID`

Exact provider-side configuration may vary with current Google Document AI setup, but credential values must never be committed or echoed.

If required Google credentials / processor configuration are absent:

`RETURN_G2A1_R3B_GOOGLE_CREDENTIAL_REQUIRED`

Do not create billing/account resources autonomously.

### Mistral expected secret interface

Only if Google is insufficient and R3B proceeds to Mistral:

- `MISTRAL_API_KEY`

If Mistral becomes necessary but its credential is absent:

`RETURN_G2A1_R3B_MISTRAL_CREDENTIAL_REQUIRED`

Do not paste any key into code, docs, evidence, logs, or chat.

## 9. Budget Guard

Hard cap:

**USD 0.20 total external API test spend.**

Before any request:
- estimate maximum call/page count;
- confirm the planned run remains clearly below the cap;
- avoid repeated retries that multiply billable calls.

If expected spend could exceed the cap:

`RETURN_G2A1_R3B_BUDGET_CHECKPOINT_REQUIRED`

Do not exceed the cap.

## 10. GitHub Actions

Use a Gate-scoped workflow such as:

`.github/workflows/family-cookbook-g2a1-r3b.yml`

Requirements:
- only the current execution branch;
- clear marker such as `[g2a1-r3b-run]`;
- minimum permissions;
- Secrets referenced only through GitHub Actions secret context;
- no secret echo;
- compact artifact upload;
- workflow does not commit to repository.

The workflow may perform a credential-presence preflight without printing secret values.

## 11. Branch

Continue:

`codex/family-cookbook-g2a1-input-ocr-component-feasibility`

Do not merge `main`.

Read latest `main` Reviewer truth before writes.

Preserve all prior evidence and Gate history.

## 12. Scoring

Use the same semantic scoring philosophy as R3A.

Priority:
1. silent critical semantic errors;
2. missing critical facts;
3. unsupported hallucinated facts;
4. manual edit burden;
5. whole-line retranscription;
6. latency/cost/integration overhead.

Do not reward stylistic normalization.

Examples:
- `350°F → 350F`: formatting only if value+scale remain recoverable;
- `15 min → 75 min`: critical semantic error;
- guessed ingredient not supported by image: hallucination.

## 13. Review-Burden Comparison

For every sample/provider record:

- PP-OCRv6 output;
- fallback raw output;
- semantic critical facts;
- missing critical facts;
- manual-edit fields;
- manual-edit chars;
- whole-line retype required;
- final preferred transcript/source;
- whether API materially helped.

Summarize:
- hard cases solved;
- hard cases improved;
- unchanged;
- worsened;
- remaining review burden.

## 14. Required Artifacts

Create/update under:

`family-cookbook-studio/g2a1/r3b/`

Suggested:
- `provider-preflight.json`
- `google-results.json`
- `google-comparison.json`
- `mistral-results.json` only if called
- `mistral-comparison.json` only if called
- `final-fallback-decision.json`
- `cost-summary.json`

Update:
- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Never commit provider credential material.

## 15. PASS_CANDIDATE Outcomes

### Google selected

```text
PASS_CANDIDATE_G2A1_R3B_API_FALLBACK_SELECTION
PRIMARY=PP-OCRv6_medium
FALLBACK=GOOGLE_ENTERPRISE_DOCUMENT_OCR
GOOGLE_TESTED=YES
MISTRAL_TESTED=NO
TOTAL_API_TEST_COST_USD=<value>
STOP_AT_REVIEWER=YES
```

### Mistral selected

```text
PASS_CANDIDATE_G2A1_R3B_API_FALLBACK_SELECTION
PRIMARY=PP-OCRv6_medium
FALLBACK=MISTRAL_OCR_4_1
GOOGLE_TESTED=YES
MISTRAL_TESTED=YES
TOTAL_API_TEST_COST_USD=<value>
STOP_AT_REVIEWER=YES
```

### No API fallback justified

```text
PASS_CANDIDATE_G2A1_R3B_NO_API_FALLBACK
PRIMARY=PP-OCRv6_medium
FALLBACK=NONE
GOOGLE_TESTED=YES
MISTRAL_TESTED=<YES|NO>
TOTAL_API_TEST_COST_USD=<value>
STOP_AT_REVIEWER=YES
```

All successful returns must also include:
- branch;
- final 40-char HEAD SHA;
- Actions run ID(s);
- GitHub delivery committed;
- main not merged.

## 16. Precise RETURNs

Use as applicable:
- `RETURN_G2A1_R3B_GOOGLE_CREDENTIAL_REQUIRED`
- `RETURN_G2A1_R3B_GOOGLE_PROVIDER_SETUP_BLOCKED`
- `RETURN_G2A1_R3B_MISTRAL_CREDENTIAL_REQUIRED`
- `RETURN_G2A1_R3B_BUDGET_CHECKPOINT_REQUIRED`
- `RETURN_G2A1_R3B_ACTIONS_BLOCKED`

When GitHub remains writable, commit the non-secret evidence/handoff before RETURN.

## 17. Forbidden

- customer/private recipe images;
- production integration;
- production credentials in repository;
- Secret printing;
- Gemini/general VLM;
- third OCR provider;
- spend above USD 0.20;
- WordPress/Woo/Kadence retesting;
- payment work;
- VPS/production deployment;
- main merge;
- G2A2.

Stop at Reviewer.


---

## 18. Latest Reviewer Return

Accepted execution:

- branch HEAD: `dd9c07bbe64a3076bcfd38d27259ff56c2ed013a`
- Actions run: `36297499256`
- conclusion: `success`
- Google client implemented: YES
- scoring implemented: YES
- Google API called: NO
- actual API cost: USD 0.00
- fallback: `UNKNOWN`

Reviewer decision:

`RETURN_G2A1_R3B_GOOGLE_CREDENTIAL_REQUIRED`

Owner setup guide:

[G2A1_R3B_GOOGLE_PROVIDER_SETUP.md](./G2A1_R3B_GOOGLE_PROVIDER_SETUP.md)

After setup, continue this same Gate; do not open a new OCR architecture Gate.


---

## 19. Provider Order Override — 2026-09-27

Owner chose not to activate Google Cloud Billing because the available Billing account requires a USD 30 one-time prepayment for an 11-case benchmark.

This is a **provider-friction decision**, not a technical rejection of Google Document AI.

Current R3B provider order is now:

1. **Mistral OCR 4.1**
2. no second provider in this Gate
3. Google Document AI remains a future adapter

Current expected result is exactly one of:

- `FALLBACK=MISTRAL_OCR_4_1`
- `FALLBACK=NONE`

The same fixed 11 public hard cases, semantic fidelity rules, Preserve-don't-invent invariant, and USD 0.20 budget cap remain unchanged.

Current setup guide:

[G2A1_R3B_MISTRAL_PROVIDER_SETUP.md](./G2A1_R3B_MISTRAL_PROVIDER_SETUP.md)


---

## 20. Mistral Free-Mode Probe Result / Google Restored — 2026-09-27

Mistral Free mode was tested only to avoid the account-level Google Billing prepayment requirement.

Observed:
- Actions run `36303206653`: first OCR request returned HTTP 429 `Rate limit exceeded`.
- Actions run `36303291445`: 15s → 30s → 60s → 90s backoff still returned HTTP 429.
- HTTP 402 Payment Required was not observed.
- successful Mistral OCR pages: 0.
- Mistral recognition quality remains unevaluated.
- `FALLBACK=UNKNOWN`.

Owner preference: do not enable paid Mistral access for this benchmark; return to Google Document AI.

The execution branch has been restored to the Google WIF benchmark path.

Current blocker:
`BILLING_DISABLED` on Google Document AI `:process`.

Current Owner action:
enable/link Billing for `family-cookbook-ocr-test`, then rerun the same R3B Google WIF workflow.

The USD 0.20 benchmark spend cap remains in force.
