# Conversion Leak Audit — EXECUTOR HANDOFF

> Intended executor: Codex / local development agent
> Current State: `G4_READY_FOR_EXECUTION`

## Reviewer authorization

```text
PASS_G3_5_UI_GROWTH_DESIGN_FREEZE
G4_RELEASED_TO_CODEX=YES
```

You may begin G4.

## Read First

1. `../PROJECT_RECORD.md`
2. `../CURRENT_STATUS.json`
3. `REVIEWER_HANDOFF.md`
4. `G4_EXECUTION_CONTRACT.md`
5. `G3_5_UI_GROWTH_FREEZE.md`
6. `../design/FINAL_GOLDEN_SCREEN_SPEC.md`
7. `../design/DEMO_FIXTURE_GOLDEN.md`
8. `../design/FUNCTIONAL_ACCEPTANCE.md`
9. `../design/VISUAL_ACCEPTANCE.md`
10. `HANDOFF_PROTOCOL.md`

## Execute

Implement only:

```text
WordPress form
→ Scanner job create API
→ scan_id
→ status polling
→ honest progress states
→ Scanner report
→ deterministic Top 3
→ evidence detail
→ WordPress free result page
```

Full requirements and tests are canonical in:

`G4_EXECUTION_CONTRACT.md`

## Source assets

Use the reviewed local trees:
- `scanner/`
- `wordpress-g1-baseline/`

Do not recreate G1/G2.

Before edits, record current regression results. After edits, rerun them.

## Visual rule

Implement the frozen design; do not invent a new UI direction.

`clone-ui` may only provide reference extraction. Do not paste a cloned site over the validated product architecture.

Generated mockup text is not authoritative. GitHub design contracts are authoritative.

## Forbidden in G4

Do not implement:
- PayPal / payment;
- Unified Pay;
- checkout / entitlement;
- LLM full report;
- VPS / domain / HTTPS;
- production Secrets;
- public production scanner;
- new Scanner rules;
- unrelated WordPress plugin stack.

## Completion

Update `EXECUTION_EVIDENCE.md` with:

```text
Gate: G4
Commit / local revision:
Files changed:
Architecture changes:
Commands run:
Regression results:
Integration results:
Screenshots:
Known limitations:
Risks:
Owner intervention required: YES/NO
Recommended Reviewer decision:
```

Candidate result:

`PASS_CANDIDATE_G4_LOCAL_FREE_LOOP`

Do not declare final PASS yourself. Reviewer will read GitHub evidence and decide.
