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

## Mandatory source-baseline precheck

Before changing any product source:

1. Locate the existing reviewed `scanner/` and `wordpress-g1-baseline/` trees.
2. Record their workspace-relative roots.
3. Record source provenance and revision: Git repository/ref/commit when tracked; otherwise the existing snapshot/provenance identifier available locally.
4. Rerun and record the frozen pre-change regression commands/results.
5. Confirm the baseline corresponds to the previously reviewed G1/G2 assets.

If either source tree is missing, recreated, ambiguous, or cannot be tied to the validated baseline:

`RETURN_G4_SOURCE_BASELINE_UNRESOLVED`

Stop at Reviewer. Do not rebuild G1/G2 as a substitute.

## Reviewer-resolved recovery source — 2026-09-22

The previous local precheck returned `RETURN_G4_SOURCE_BASELINE_UNRESOLVED` correctly because the source trees were absent from that workspace.

Reviewer has now recovered and independently verified the canonical package:

`conversion-leak-audit-final-2026-09-17.zip`

Expected SHA256:

`e5c3aa1da7a8fe5a431eade38f2b45fc48862b21470e413f4a034f150f59df03`

It contains the canonical handoff snapshots:
- `conversion-leak-audit/scanner/`
- `conversion-leak-audit/wordpress-g1-baseline/`

After Owner places this package in the local workspace, Executor must:

1. Verify the ZIP SHA256 exactly.
2. Extract/restore only the canonical `scanner/` and `wordpress-g1-baseline/` trees into the project workspace; do not reconstruct them from Skill validation files.
3. Record the restored workspace-relative paths and package provenance.
4. Run Scanner regression from `scanner/`: `python -m pytest -q` (expected 55/55).
5. Run WordPress asset regression: `python wordpress-g1-baseline/acceptance/run_asset_checks.py` (expected 20/20).
6. If both pass, continue G4 under the existing contract. If checksum or either regression differs, stop at Reviewer.

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
