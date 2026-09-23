# G5 — Full Fix Queue + LLM Explanation + Skill Dogfood Execution Contract

Date: 2026-09-23
Status: READY_FOR_EXECUTOR
Precondition: PASS_G4_6_ACQUISITION_SEO_READINESS

## Goal

Extend the accepted free Top 3 product into a complete evidence-linked Fix Queue and add optional model-generated explanation over structured findings, while preserving deterministic Scanner truth.

This Gate does **not** add payment, entitlement, VPS deployment, public production exposure, or new Scanner rules.

## Product boundary

Existing free path remains:

```text
Public URL
→ Safe Scanner
→ evidence-backed findings
→ deterministic Free Top 3
```

G5 adds:

```text
structured report
→ complete evidence-backed Fix Queue
→ deterministic ordering
→ optional LLM explanation for existing structured issues
→ full-report shell / local preview
```

The LLM explains; it does not diagnose raw pages.

## Non-negotiable LLM boundary

Forbidden:

```text
raw HTML / screenshot / arbitrary page text
→ LLM
→ new CRO issue
```

Allowed:

```text
existing structured issue
+ rule id
+ observed fact
+ evidence refs
+ applicability/context
+ deterministic first move
+ explicit limitation
→ LLM explanation
```

The model may:
- rewrite for clarity;
- explain why the finding may matter within the existing claim boundary;
- summarize evidence;
- explain the first move;
- produce a concise implementation-oriented explanation.

The model may **not**:
- create new issues;
- change PASS / ISSUE / NOT_APPLICABLE / CONTEXT_INSUFFICIENT;
- change rule priority;
- invent evidence;
- infer revenue loss;
- claim causal lift;
- invent merchant metrics;
- override Scanner limitations.

## G5A — Complete Fix Queue

Build a complete queue from all existing evidence-backed ISSUE findings in the Scanner report.

Requirements:
- no fabricated padding;
- every queue item maps to one existing issue/rule;
- evidence remains traceable;
- duplicate issue ids are not duplicated;
- queue length truthfully reflects available issues;
- zero findings produces an honest empty state;
- incomplete audit remains visibly incomplete.

### Ordering

Do not invent a new numeric impact score.

Use the existing deterministic priority/order already present in the structured report/rule system.

If the current report lacks enough deterministic information to order the full queue without inventing semantics, STOP_AT_REVIEWER with:
`RETURN_G5_FIX_QUEUE_ORDERING_UNRESOLVED`

Do not silently create a severity model.

### Queue item

At minimum expose:
- position;
- rule id;
- title;
- concise observed fact;
- evidence affordance;
- deterministic first move;
- limitation / claim boundary;
- applicability/context when relevant.

Long explanation should be progressive disclosure.

## G5B — Full report local shell

Add a local full-report view/surface connected to a `scan_id`.

No payment gate yet.

It must clearly indicate that paid access is not active in this Gate.

Requirements:
- refresh-safe scan binding;
- correct report belongs to the correct `scan_id`;
- no cross-scan leakage;
- invalid/missing scan id fails closed;
- incomplete report remains incomplete;
- no entitlement bypass concept is introduced prematurely.

The full report may be accessible through a development/local preview path only.

Do not expose a production paid route.

## G5C — LLM provider abstraction

Implement a provider-neutral explanation adapter.

Requirements:
- application code depends on a small internal interface, not a specific vendor throughout the codebase;
- tests must run with a deterministic fake provider;
- no live API key is required for the core test suite;
- live provider invocation is optional and must be explicitly enabled by environment;
- missing key/provider must degrade gracefully to deterministic non-LLM content.

No Secret may be committed.

### Structured input contract

Create a minimal versioned input object containing only the data needed to explain the existing issue.

Recommended fields:

```text
schema_version
scan_id or opaque report reference
rule_id
title
observed_fact
evidence_refs
first_move
limitation
applicability/context summary
```

Do not include raw page HTML.

If URLs are included for evidence display, avoid sending unnecessary query parameters or unrelated user data to the model.

### Structured output contract

Output must be schema-validated.

At minimum:

```text
summary
why_it_may_matter
recommended_next_step
caveat
```

The output must not create another finding or alter the deterministic decision.

Validation failure:
- do not render untrusted malformed model output;
- fall back to deterministic content.

## G5D — Prompt / claim safety

The prompt must explicitly state:
- explain only the provided issue;
- do not invent facts/evidence;
- do not infer causal conversion impact;
- do not estimate revenue loss;
- preserve uncertainty;
- do not claim the finding is the reason for low sales.

Add tests using adversarial/faulty fake outputs:
- invented revenue number;
- invented evidence;
- changed rule id;
- causal uplift claim;
- malformed JSON/schema;
- timeout/provider error.

The product must fail gracefully.

## G5E — Cost / token boundary

Free Top 3 remains zero-LLM-token by default.

LLM explanation is only for the full-report/local expansion path.

Add bounded controls:
- max issues explained per request;
- max prompt payload;
- timeout;
- retry cap;
- no unbounded recursive model calls;
- cache/reuse explanation for the same immutable issue input where practical.

Record the chosen bounds.

Do not optimize prematurely for a specific paid provider.

## G5F — UI

Do not redesign G4.5.

Reuse existing design system.

Full Fix Queue should preserve:
- evidence-first hierarchy;
- progressive disclosure;
- mobile readability;
- incomplete-state honesty.

Required views:
- full queue with >3 findings;
- 1–3 findings;
- zero findings;
- incomplete audit;
- one LLM explanation expanded;
- LLM unavailable/fallback state.

No payment button in G5.

A future paid-expansion affordance may remain clearly non-transactional.

## G5G — Optional downloadable/shareable artifact

This is **optional**, not required for G5 PASS.

Do not build PDF/export unless the existing architecture makes it low-cost and does not delay the core queue + explanation loop.

If deferred, record it.

## G5H — Analytics

Preserve existing events.

Add only the minimum provider-independent events needed for G5 product learning, for example:
- `full_report_viewed`;
- `full_issue_expanded`;
- `llm_explanation_requested`;
- `llm_explanation_viewed`;
- `llm_explanation_failed`.

Before adding names, update the analytics contract and automated assertions.

Do not add a third-party analytics provider in this Gate.

No raw URL, evidence text, or model prompt should be emitted as analytics properties.

## G5I — Skill Dogfood

Update `docs/SKILL_DOGFOOD_LOG.md` **before real external-user evidence exists**.

Keep D001–D003 as `INCONCLUSIVE`.

Add product hypotheses for the full queue / explanation layer, such as:
- whether users need depth beyond Top 3;
- whether explanation increases comprehension/trust;
- whether evidence remains more important than generic AI prose.

Do not mark hypotheses SUPPORTED merely because the feature was implemented.

No Skill source modification in G5.

## G5J — Data / privacy

Persist only what is necessary for local product behavior.

Do not newly persist raw HTML.

Model explanation records, if stored locally, must be tied to:
- report/scan;
- rule id;
- schema/input version;
- provider/model identifier if a real provider is used;
- creation time/status.

Do not store API keys, full prompts containing secrets, or unrelated page content.

## Functional acceptance

Required:
- full queue contains exactly all eligible ISSUE findings;
- deterministic order;
- zero/1/2/3/>3 cases;
- incomplete audit;
- evidence traceability;
- scan/report binding;
- refresh;
- fake LLM success;
- fake LLM timeout;
- malformed output fallback;
- hallucination/claim guard tests;
- no LLM call on default Free Top 3;
- provider missing gracefully falls back;
- mobile queue readability;
- analytics contract;
- no payment action.

## Regression

Must preserve:
- Scanner 55/55;
- WordPress 20/20;
- G4 browser regression;
- SEO readiness acceptance 44/44;
- G4.6 metadata/canonical/noindex/sitemap behavior.

## Repository

Use a fresh project-scoped sparse workspace from latest `origin/main`.

Dedicated branch:

`codex/g5-full-fix-queue-llm-dogfood`

Do not merge to main before Reviewer PASS.

All changes must remain under:

`conversion-leak-audit/**`

## Local artifact rule

Temporary G5 screenshots/review ZIPs go under:

`VPS基建/_project-artifacts/conversion-leak-audit/`

not the VPS root and not the Git repository unless they are deliberate tracked evidence.

Active Git workspaces remain under `workspaces/`.

## Forbidden

No:
- new Scanner rules;
- rule-semantic changes;
- raw-page-to-LLM diagnosis;
- payment / PayPal / Unified Pay;
- entitlement;
- VPS/domain/HTTPS;
- production Secret;
- public production Scanner;
- bulk SEO content;
- broad visual redesign.

## Evidence

Update:
- `docs/EXECUTION_EVIDENCE.md`
- `docs/EXECUTOR_HANDOFF.md`
- `docs/SKILL_DOGFOOD_LOG.md`
- analytics contract if new events are added.

Record:
- base main;
- branch/commit;
- architecture changes;
- queue ordering source;
- LLM input/output schemas;
- provider abstraction;
- prompt/claim guards;
- token/cost bounds;
- tests;
- regression;
- screenshots;
- known limitations;
- deferred export;
- out-of-scope actions;
- Owner intervention.

## Candidate

`PASS_CANDIDATE_G5_FULL_FIX_QUEUE_LLM_DOGFOOD`

Then `STOP_AT_REVIEWER`.

Reviewer alone declares final G5 PASS.
