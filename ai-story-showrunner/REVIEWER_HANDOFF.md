# Story Showrunner Validation Workspace — REVIEWER HANDOFF

Date: 2026-09-22  
Status: `CURRENT TRUTH ONLY`

Historical chronology belongs in:
- `PROJECT_RECORD.md`
- `EXECUTION_EVIDENCE.md`
- `experiments/`

## 1. Final goal

Extract and validate a reusable:

`entropy-student/spike.skill/story-showrunner`

The current `ai-story-showrunner` repository is the validation/runtime workspace, not the permanent product boundary.

Skill lifecycle:

```text
candidate extraction now
→ current project remains E2E fixture
→ final video PASS
→ promote story-showrunner to CANONICAL
```

## 2. Current accepted pipeline

```text
TopicProvider
→ DomainAdapter
→ Knowledge / CausalCore
→ StoryEngine
→ Writer
→ TimingCompiler
→ Director
→ Frame / AssetCompiler
→ ProductionCompiler
→ ExecutorAdapter
→ QA
```

AI is the first Domain Adapter, not the core boundary.

## 3. Gate state

```text
P0 / G1 / G2 / G2.5 / G3 / G3R / G4 / G5 = PASS
G6 = IN_PROGRESS
G7 = BLOCKED_BY_G6
```

G6 current production task:

```text
locked script
→ Production SRT
→ TTS_MANIFEST.json
→ full Antigravity Production Package
→ Antigravity TTS + images + edit + export
→ final QA
```

## 4. Timing truth

Canonical:
- `docs/SRT_AUDIO_TIMING_STANDARD.md` v0.4
- `docs/VOICE_TIMING_PROFILE_SPEC.md` v0.3
- `profiles/voice/VOICE_TIMING_PROFILE_COSYVOICE_300M_V2_1.json`

Profile status:
`FROZEN / PASS_WITH_MINOR`

Audio mode:
`EXECUTOR_LOCKED_COSYVOICE`

Authority:
- Writer locks spoken text and dramatic meaning.
- Timing Compiler owns Speech Units, semantic pace, authored pauses, Production SRT and TTS Manifest.
- G4 consumes Production SRT and owns visual rhythm only.
- Antigravity executes the locked TTS recipe and may not rewrite or creatively retime speech.

No routine post-TTS creative SRT realignment.

## 5. G4 truth

G4 = PASS.

Canonical:
- `docs/G4_DIRECTOR_LANGUAGE_RULES.md`
- `docs/G4_DIRECTOR_COMPILER_CONTRACT.md`
- `docs/G4_VIEWPOINT_GRAMMAR.md`

G4 no longer uses 5.9 chars/s or Jingsui timing as production authority.

Historical timing observations remain evidence only.

Human-readable Director Shotboard is observability/debug output, not a mandatory Owner approval Gate.

## 6. G5 truth

G5 = PASS.

Canonical:
- `docs/G5_IMAGE_ASSET_PACKAGE_CONTRACT.md`
- `docs/VISUAL_FRAME_BLUEPRINT_RULES.md`
- `docs/CHARACTER_IDENTITY_LOCK.md`

Manual/high-risk Pilot:
`CALIBRATION_EXCEPTION_ONLY`

Normal episodes do not require Owner first-key-frame review.

## 7. Current validation episode

Episode:
`blind-search-answer`

Locked script:
`experiments/g4r-v03/blind-search-answer/02_SCRIPT.md`

Legacy reference SRT:
`experiments/g4r-v03/blind-search-answer/08_REFERENCE_TIMING.srt`

Legacy SRT role:
`SEMANTIC_PRIOR_ONLY / NOT PRODUCTION CLOCK`

Persistent G5 reference package:
`/ai-story-showrunner/g5/blind-search-answer/reference-package-v1`

## 8. Topic/runtime state

Default topic resolution:

```text
explicit user topic
> explicit user override
> today's Calendar
> Topic Radar
> Evergreen Bank
```

Live Calendar / Registry / daily ledger remain runtime state outside Skill source.

## 9. Owner intervention policy

Normal run:

```text
optional invocation override
→ autonomous pipeline
→ final video review
```

No routine Owner approval for:
- final script;
- Production SRT;
- Director plan;
- first-batch key frames;
- individual TTS lines.

Escalate only unresolved RETURN/BLOCKED states or explicit Owner policy choices.

## 10. Skill extraction state

Review artifacts:
- `docs/skill-migration-review/MIGRATION_MAP_V1.md`
- `docs/skill-migration-review/CONFLICT_REGISTER_V1.md`
- `docs/skill-migration-review/R1_CANONICAL_RECONCILIATION_REVIEW.md`
- `docs/skill-migration-review/R2_CANDIDATE_MIGRATION_REVIEW.md`

`SKILL_EXTRACTION_R1 = PASS`
`SKILL_EXTRACTION_R2 = PASS`

Candidate now exists:
`entropy-student/spike.skill/story-showrunner`

Candidate status:
`CANDIDATE / E2E_NOT_YET_PROVEN`

Resolved:
- all 9 P0 canonical conflicts;
- all P1 core/profile/adapter/runtime splits;
- all 4 P2 source-of-truth cleanup issues;
- schema identity/timing-source migration;
- portable voice profile path externalization.

Next:
resume G6 using Candidate contracts.

## 11. Remaining unknowns

- Antigravity programmatic integration availability remains unknown; current trigger is manual.
- Full Production Package E2E has not yet produced a final video.

## 12. Immediate next action

Candidate migration is complete.

Resume the validation episode at:

```text
locked Blind Search script
→ Candidate Timing Compiler
→ Production SRT
→ TTS Manifest
→ full Antigravity Production Package
```

Do not label the Skill CANONICAL until final-video E2E PASS.
