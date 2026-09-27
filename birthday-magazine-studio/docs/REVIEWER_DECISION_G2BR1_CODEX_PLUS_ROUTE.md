# Reviewer Decision — G2BR1 Codex Plus Route

Date: 2026-09-27  
Gate: `G2BR1_REAL_AI_GENERATION_CLOSURE`

## Decision

Owner approved using the existing ChatGPT Plus/Codex allowance for G2BR1 instead of purchasing separate OpenAI API usage.

For this Solution Proof, the preferred real-model execution path is now:

```text
ChatGPT-authenticated Codex CLI
→ codex exec
→ --output-schema CONTENT_SCHEMA
→ structured magazine JSON
→ existing renderer
→ 12-page PDF
→ QA
```

No OpenAI API key is required for this route.

## Evidence boundary

This proves:
- a real OpenAI model can turn the frozen synthetic intake into the required structured magazine content;
- that real model output can pass grounding, module, layout and PDF QA.

It does **not** freeze the eventual production provider/runtime for unattended customer generation.

Production provider remains a later architecture decision.

## Usage / cost boundary

- use the Owner's existing ChatGPT-authenticated Codex allowance;
- maximum 3 Codex model runs for this closure;
- retries only for schema/runtime/transient failure;
- do not purchase extra credits automatically;
- if the included/available Codex allowance is exhausted, return `RETURN_CODEX_PLAN_LIMIT_REACHED`.

## Security

- no API key needed;
- do not export ChatGPT auth tokens;
- do not copy Codex auth storage into the repo;
- do not commit account/session identifiers;
- run only on synthetic project data.

## Local execution requirement

The G2BR1 real-model run must execute in a Codex client/CLI already signed in with the Owner's ChatGPT account.

A remote Reviewer/chat sandbox without that local login state cannot impersonate or reuse the Owner's Plus session.
