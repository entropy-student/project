# Conversion Leak Audit — EXECUTOR HANDOFF

> Intended executor: Codex / local development agent
> Current Gate: `G4_WORDPRESS_SCANNER_TOP3_LOCAL_INTEGRATION`

## Read First

1. `../README.md`
2. `../PROJECT_RECORD.md`
3. `REVIEWER_HANDOFF.md`
4. `ROADMAP.md`
5. `HANDOFF_PROTOCOL.md`

## Do Not Repeat

Do not redo:
- theory research;
- 77-rule knowledge catalog;
- 17-rule MTRS selection;
- 51-rule fixture design;
- G1 WordPress baseline;
- G2 Safe Scanner V0;
- old standalone G3 Rule Engine.

## Current Source Assets

The reviewed handoff snapshot contains:
- `scanner/` — current Python Scanner V0
- `wordpress-g1-baseline/` — current WordPress baseline

Recovery checks before GitHub document migration:
- Scanner tests: `55 / 55 PASS`
- WordPress asset checks: `20 / 20 PASS`

When the product source is placed on the Owner Windows machine, preserve the same logical directories.

## G4 Required Work

Build the local-only integration:

```text
WordPress form
→ Scanner job create API
→ scan_id
→ status polling
→ Scanner result
→ deterministic Top 3
→ WordPress free result page
```

Recommended implementation boundary:

### WordPress integration layer
Owns:
- public URL form;
- nonce/CSRF;
- normalized API request;
- scan_id/status mapping;
- polling UI;
- free Top 3 rendering;
- explicit incomplete/error states.

Must NOT:
- run Scrapy/Chromium inside PHP request;
- directly modify frozen Scanner rules;
- expose internal Scanner unrestricted to public internet.

### Scanner
Keep existing boundaries:
- public URL safety validation;
- bounded crawl;
- evidence-backed findings;
- fail closed;
- `/healthz`;
- job/report API;
- SQLite local persistence.

## G4 Forbidden

- production payment;
- live payment Secret;
- VPS deployment;
- domain cutover;
- Shared reverse-proxy/tunnel modification;
- production login/auth design;
- new uncalibrated rules;
- unbounded crawling;
- raw HTML → LLM free-form diagnosis.

## Required Completion Report

Update GitHub docs with:

```text
Gate:
Files changed:
Commands/tests run:
Results:
Screenshots/evidence if applicable:
Known limitations:
Risks:
Next action:
Owner intervention required: YES/NO
```

Write factual execution evidence to `EXECUTION_EVIDENCE.md`.
Do not declare Gate PASS yourself unless instructed; Reviewer decides Gate status.
