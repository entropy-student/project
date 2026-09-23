# Current Documentation Index

Date: 2026-09-23  
Purpose: prevent historical validation documents from being mistaken for current runtime authority.

## Current operational truth

Read in this order:

1. `../REVIEWER_HANDOFF.md` — Reviewer current project truth.
2. `../CURRENT_STATUS.json` — machine-readable mirror.
3. `G6A_AUDIO_QA_AND_TTS_MIGRATION_TRIAL.md` — active G6A audio execution, listening QA, repair and candidate TTS trial.
4. `GPT_SOVITS_QUICKSTART.md` — concise Owner-facing usage guide for the current local GPT-SoVITS candidate.
5. `../tools/gpt-sovits/README.md` — current GPT-SoVITS local runtime/API helper gate and candidate settings.
6. `G6R_CANDIDATE_RUNTIME_RECONCILIATION.md` — accepted runtime reconciliation gate.
7. `../../spike.skill/story-showrunner/SKILL.md` — portable Candidate entrypoint.
8. Candidate core contracts under `entropy-student/spike.skill/story-showrunner/references/`.
9. `../EXECUTION_EVIDENCE.md` — accepted/reviewable execution evidence when auditing facts.
10. `../PROJECT_RECORD.md` — chronology and historical decisions.

## Current project contracts still active

- `G4_DIRECTOR_COMPILER_CONTRACT.md`
- `G4_DIRECTOR_LANGUAGE_RULES.md`
- `G4_VIEWPOINT_GRAMMAR.md`
- `G5_IMAGE_ASSET_PACKAGE_CONTRACT.md`
- `VISUAL_FRAME_BLUEPRINT_RULES.md`
- `CHARACTER_IDENTITY_LOCK.md`
- `SRT_AUDIO_TIMING_STANDARD.md`
- `VOICE_TIMING_PROFILE_SPEC.md`
- `OUTPUT_RECORD_STANDARD.md`
- `CONTENT_STRATEGY_AND_CONVERSION.md`
- `DAILY_TOPIC_AUTOMATION_V2.md`

When a portable Candidate contract conflicts with a historical project copy, the current Reviewer Handoff decides project truth and the Candidate Skill repository is the target portable contract.

## Historical validation evidence — retain, do not use as current timing authority

These files remain valuable evidence of how a gate was validated, but their embedded timing/status statements may have been superseded:

- `G2_VALIDATION_REVIEW.md`
- `G3_VALIDATION_REVIEW.md` — includes old ~70–85s / 5.0 chars/s planning assumptions.
- `G3R_EDITORIAL_REVIEW.md`
- `G4_VALIDATION_REVIEW.md` — includes old Jingsui timing baseline.
- `G4_JINGSUI_TIMING_PROFILE.md`
- `G4_DIRECTOR_RULES_FINAL_REREVIEW_V03.md`
- `G5_GATE_REVIEW.md`
- older `*_CANDIDATE*` Director/visual research documents.

Historical files are not deleted because they are audit evidence.

## Experiments

`experiments/` = validation/R&D evidence, not automatically current production truth.

Especially:

- `experiments/g4r-v03/.../07_VISUAL_BEAT_PLAN.json` preserves accepted visual semantics but its legacy absolute timing is not Candidate timing authority.
- `experiments/g5/...` preserves accepted asset/identity/frame-design evidence.
- `experiments/g6/.../production-package-v1` is historical Candidate package evidence and is superseded for current execution by G6R reconciliation.

## Outputs

`outputs/` records retained production runs only.

Do not use `outputs/` to infer a PASS that is not recorded in the current Reviewer Handoff.
