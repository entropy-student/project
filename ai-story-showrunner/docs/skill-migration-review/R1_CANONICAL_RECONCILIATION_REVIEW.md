# Skill Extraction R1 — Canonical Reconciliation Review

Date: 2026-09-22

Result:
`PASS`

## Scope

R1 repaired the nine P0 conflicts identified by the migration review and normalized project current truth before any write to the Skill repository.

## Canonical decisions after R1

```text
Writer
→ Timing Compiler
→ Voice Timing Profile
→ Production SRT + TTS Manifest
→ Director
→ Asset Compiler
→ Production Compiler
→ Executor
```

Audio mode:
`EXECUTOR_LOCKED_COSYVOICE`

G4:
speech timing authority = NONE;
visual timing maps onto Production SRT.

G5:
`PASS`;
manual Pilot = calibration exception only.

Core mechanism:
`CausalMechanism / KnowledgeCore`;
AI = first Domain Adapter.

Skill lifecycle:
`CANDIDATE_EXTRACTION_NOW → CANONICAL_AFTER_E2E_PASS`

## Stale-rule audit

Audited canonical docs for:
- `AUDIO_MODE=A_UPSTREAM_COSYVOICE`
- `AUDIO_MODE=TBD`
- Writer `5.0 chars/s` production timing
- routine post-TTS realignment
- `G5 = IN_PROGRESS`
- normal `G5 Pilot QA`
- `AI mechanism as causal rule`
- `locked AI mechanism`
- old symmetric Timing acceptance thresholds
- “Do NOT migrate until E2E”

Result:
`0 active canonical hits`

G4 retains a historical ~5.9 chars/s mention only as explicitly non-authoritative validation evidence.

## Source-of-truth cleanup

- `CURRENT_STATUS.json` → schema v2.0, current facts only.
- `REVIEWER_HANDOFF.md` → current truth only.
- chronology remains in `PROJECT_RECORD.md` / Evidence / experiments.
- README current G6 task updated.

## Release

`SKILL_EXTRACTION_R2` is authorized.

Target:
`entropy-student/spike.skill/story-showrunner`

Candidate label:
`CANDIDATE / E2E_NOT_YET_PROVEN`
