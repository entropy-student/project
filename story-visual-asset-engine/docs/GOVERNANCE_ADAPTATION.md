# Governance Adaptation — Story Visual Asset Engine

## Baseline

Canonical governance:
`entropy-student/spike.skill/vps-project-governance`

This project is visual R&D + production tooling, so VPS-specific operational clauses are N/A until infrastructure is introduced.

## Retained rules

- Owner / Reviewer / Executor separation.
- Reviewer is sole formal PASS/RETURN authority.
- `PASS_CANDIDATE != PASS`.
- Current truth lives in `REVIEWER_HANDOFF.md`.
- Facts / inference / UNKNOWN must be separated.
- Evidence before PASS.
- Executor stays within the current Gate.
- Project-local reversible work may be delegated.
- Consequential actions remain Owner-only.
- Accepted Gates are not reopened without material drift/new evidence.

## Project evidence

Relevant evidence types:
- source-backed research facts;
- exact provider settings;
- prompt and reference inputs;
- generated asset IDs;
- measured usage/cost when available;
- first-pass/retry counts;
- character/style consistency review;
- reuse/derive/composite lineage;
- before/after asset-library counts;
- cross-episode reuse rate;
- quality review.

## Current source-of-truth order

1. Owner current instruction.
2. `REVIEWER_HANDOFF.md`.
3. Fresh read-back + accepted `EXECUTION_EVIDENCE.md`.
4. `PROJECT_RECORD.md`.
5. historical chat/notes.

## Executor rule

No independent Executor exists yet, so no `EXECUTOR_HANDOFF.md` is created. Add it only when a separate Executor is assigned.
