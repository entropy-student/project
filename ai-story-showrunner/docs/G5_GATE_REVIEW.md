# G5 Gate Review

Date: 2026-09-21

## Current decision

`G5 = PASS_CANDIDATE_BLOCKED_BY_REAL_REFERENCE_PERSISTENCE`

## PASS criteria review

| Criterion | Status |
|---|---|
| one Frame Blueprint per Visual Beat | PASS — 44/44 |
| Blueprint preserves accepted G4 meaning | PASS |
| Beat assets bound after Blueprint | PASS |
| exactly one execution mode per Beat | PASS |
| high-risk Pilot | PASS_CANDIDATE — 8/8 accepted |
| no fake references | PASS — no fake path invented |
| real executable canonical references | BLOCKED |
| executor has no missing creative identity decision | BLOCKED until real refs are bound |

## Why G5 is not final PASS yet

The logic/compiler layer is validated, but the production package still references canonical assets whose binaries are not persisted into executable paths.
Pilot evidence showed repeated recurring-character drift when the real canonical identity image was not bound.

Final G5 PASS requires:
1. persisted `CHAR_IP_001` canonical image reference;
2. persisted approved recurring scene/UI masters needed by execution rows;
3. populated `canonical_paths` in the Reference Manifest;
4. machine validation that required rows resolve those paths.

## G6 release condition

`REFERENCE_PATH_VALIDATION = PASS`

Then:
`G5 = PASS`
→ `G6 = READY`.

No full 44-image generation is required before G5 PASS; that is downstream execution evidence.
