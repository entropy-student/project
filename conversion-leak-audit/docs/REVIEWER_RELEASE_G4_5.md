# Reviewer Release — G4.5 Visual + Functional Acceptance

Date: 2026-09-22

Role: Reviewer / Architect / Gatekeeper

## Release

`G4_5_VISUAL_FUNCTIONAL_ACCEPTANCE = RELEASED_TO_CODEX`

Precondition:

`PASS_G4_WORDPRESS_SCANNER_TOP3_LOCAL_INTEGRATION`

Canonical execution contract:

`docs/G4_5_ACCEPTANCE_CONTRACT.md`

## Repository execution rule

G4.5 must run from a fresh project-scoped Git workspace based on the latest `origin/main`.

Use sparse checkout (or equivalent) so the working tree exposes only:

`conversion-leak-audit/`

Do not use the old shared monorepo worktree for G4.5 changes.

Create a dedicated branch:

`codex/g4-5-visual-functional-acceptance`

Do not merge to `main` before Reviewer PASS.

## Acceptance-first rule

G4.5 is not a feature-development Gate.

Executor must first rerun acceptance without editing product source.

Only if a frozen acceptance criterion fails may Executor make the smallest bounded correction required by the existing G3.5/G4 contracts.

No redesign, no new feature, no new rule, no G5 work.

## Required sequence

1. Fetch latest `origin/main`.
2. Create clean project-scoped workspace and dedicated branch.
3. Read all canonical G4.5 references.
4. Run functional acceptance before edits.
5. Capture deterministic Golden screenshots before edits.
6. Compare against frozen contracts.
7. If all pass, make no product change.
8. If an acceptance item fails, make only bounded correction(s), record each reason, and rerun all affected acceptance.
9. Rerun Scanner 55/55 and WordPress 20/20.
10. Verify scope: all changes under `conversion-leak-audit/**`.
11. Commit/push dedicated branch only.
12. Return `PASS_CANDIDATE_G4_5_VISUAL_FUNCTIONAL_ACCEPTANCE`.
13. `STOP_AT_REVIEWER`.

## Evidence minimum

Evidence must explicitly state:
- base `origin/main` SHA;
- branch/commit;
- whether product source changed;
- if changed, exact acceptance failure that justified each edit;
- Scanner 55/55;
- WordPress 20/20;
- functional acceptance matrix;
- viewport matrix: 1440×900, 1280×800, 390×844, 360×800;
- Golden screenshot paths;
- responsive checks;
- issue evidence detail;
- incomplete/error;
- paid-expansion/full-report shell boundary;
- accessibility/tap-target/body-text observations;
- visual diff method/tolerance if used;
- out-of-scope changes;
- Payment/VPS/production-secret actions = 0.

## Boundaries

Payment, PayPal, Unified Pay, VPS, domain/HTTPS, production Secret, public production Scanner, new Scanner rules, G5 Full Fix Queue, and LLM report work remain forbidden.

Owner intervention required: `NO`.
