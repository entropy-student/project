# Conversion Leak Audit — EXECUTOR HANDOFF

> Intended executor: Codex / local development agent
> Current State: `HOLD_FOR_G3_5_UI_GROWTH_DESIGN_FREEZE`

## Read First

1. `../README.md`
2. `../PROJECT_RECORD.md`
3. `REVIEWER_HANDOFF.md`
4. `ROADMAP.md`
5. `G3_5_UI_GROWTH_FREEZE.md`
6. `HANDOFF_PROTOCOL.md`

## Current Instruction

Do **not** start G4 product implementation yet.

Wait until Reviewer marks:

```text
PASS_G3_5_UI_GROWTH_DESIGN_FREEZE
```

Only after that will this document be updated with the frozen implementation contract.

## Do Not Repeat

Do not redo:
- theory research;
- 77-rule catalog;
- 17-rule MTRS selection;
- 51 fixtures;
- G1 WordPress baseline;
- G2 Safe Scanner V0;
- old standalone G3 Rule Engine.

## Frozen Technical Assets

Current reviewed source assets:
- `scanner/` — Python Scanner V0
- `wordpress-g1-baseline/` — WordPress baseline

Recovery checks:
- Scanner tests: `55 / 55 PASS`
- WordPress asset checks: `20 / 20 PASS`

## Future G4 Boundary

After G3.5 PASS, Codex will implement:

```text
WordPress form
→ Scanner job create API
→ scan_id
→ status polling
→ Scanner result
→ deterministic Top 3
→ WordPress free result page
```

Implementation must follow the frozen UI/design/analytics/acceptance contracts. Codex must not invent visual direction, payment flow or new scanner rules during implementation.

## Future Visual Acceptance

Codex will be required to:
- implement against design tokens/page contracts;
- reproduce desktop/mobile golden screenshots;
- run Playwright screenshots / visual regression;
- pass functional acceptance separately from visual acceptance.

`clone-ui` output, if supplied, is reference material only. Do not let clone code replace project architecture or overwrite unrelated functionality.

## Payment

Payment is not part of G4.

Current future candidate: Direct PayPal at G9. Unified Pay is not a current dependency.

## Required Completion Report

When implementation resumes, update GitHub docs with:

```text
Gate:
Files changed:
Commands/tests run:
Results:
Screenshots/evidence:
Known limitations:
Risks:
Next action:
Owner intervention required: YES/NO
```

Write factual execution evidence to `EXECUTION_EVIDENCE.md`. Reviewer, not Codex, declares Gate PASS.
