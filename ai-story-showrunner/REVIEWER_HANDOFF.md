# Story Showrunner Validation Workspace — REVIEWER HANDOFF

Date: 2026-09-23  
Status: `CURRENT TRUTH ONLY / TAKEOVER REVIEW RECONCILED`

Historical chronology belongs in:
- `PROJECT_RECORD.md`
- `EXECUTION_EVIDENCE.md`
- `experiments/`

Current documentation map:
- `docs/CURRENT_DOC_INDEX.md`

## 1. Final goal

Validate and promote the reusable:

`entropy-student/spike.skill/story-showrunner`

The current `ai-story-showrunner` repository remains the validation/runtime workspace.

Promotion rule remains:

```text
Candidate contracts
→ current episode final-video E2E
→ final QA
→ story-showrunner CANONICAL
```

## 2. Accepted pipeline

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

## 3. Gate truth after 2026-09-23 takeover review

```text
P0 / G1 / G2 / G2.5 / G3 / G3R / G4 / G5
= ACCEPTED WITH THEIR ORIGINAL VALIDATION SCOPE

G6R = PASS
G6A First-E2E Asset Calibration Gate = READY_NOT_EXECUTED
G7 Final End-to-End Validation = BLOCKED_BY_G6A
```

Important interpretation:

- G2/G3/G4/G5 PASS means their declared contract/quality gates passed.
- It does **not** mean production throughput or full Candidate E2E already passed.
- Do not reopen accepted story/director/asset semantics unless a new failure invalidates them.

## 4. Why G6R exists

The takeover review found a post-extraction seam:

1. Candidate Timing Compiler already produced 44 Speech Units, Production SRT and TTS Manifest.
2. The current G6 package still consumed the older G4 Visual Beat artifact whose `timing_source` is `JINGSUI_PRIOR_ESTIMATE`.
3. Candidate runtime rules now require planned/final timing semantics and durable Speech Unit anchors.
4. The Runtime Timeline Resolver contract described those anchors, but the current Visual Beat schema/package did not encode them as a required executable contract.

Therefore the existing G6 package v1 is retained as historical evidence but is **not current Candidate E2E proof**.

## 5. Preserved truth — do not redo

G6R must not redesign:

- locked Blind Search script;
- KnowledgeCore / Story meaning;
- the 44 accepted Visual Beat meanings;
- Visual Beat order;
- accepted POV decisions;
- G5 Frame Blueprint creative intent;
- character identity/style rules;
- Voice Timing Profile v2.1;
- FFmpeg baseline renderer decision.

This is a runtime-contract reconciliation, not a creative rebaseline.

## 6. G6R current artifacts

Timing already compiled:

- 44 Speech Units;
- 43 voiced TTS rows;
- 1 explicit 1.4s silent HARD_ANCHOR;
- planned total: 146.7209s;
- exact locked-script coverage: PASS.

New reconciliation binding:

`experiments/g6/blind-search-answer/timing/05_VISUAL_BEAT_TIMING_BINDINGS.json`

It provides 44/44:

```text
visual_beat_id
↔ speech_unit_id
+ START anchor
+ WINDOW_END anchor
+ timing_flex / lock class
```

Historical absolute G4 timestamps are planning evidence only.

## 7. Runtime resolver truth

The Candidate resolver must:

- treat real normalized TTS duration as final speech-clock truth;
- preserve text/order/semantic pace/authored pauses;
- resolve final absolute timestamps from durable anchors;
- emit FINAL_SUBTITLES / FINAL_TIMELINE / FINAL_SHOT_TIMELINE;
- treat profile drift as diagnostic unless a locked hard constraint becomes infeasible;
- never require an ordinary Owner round-trip for retiming.

A deterministic reference implementation and schema alignment belong to the Candidate Skill repository and are part of G6R.

## 8. FFmpeg truth

Video runtime probe already passed programmatically.

Baseline first E2E renderer:

`FFmpeg / deterministic still-first assembly`

Remotion / Hyperframe are optional later renderers, not baseline blockers.

The earlier Handoff statement saying the renderer probe was still pending is superseded.

## 9. Production package truth

`production-package-v1` remains historical candidate evidence.

Current execution package:

`experiments/g6/blind-search-answer/production-package-v2`

It is rebuilt against:
- Candidate planned timing;
- durable 44/44 Visual Beat anchors;
- Candidate-compliant Visual Beats;
- executable Runtime Timeline Resolver;
- current Candidate schemas.

Package v1 remains historical evidence only.

## 10. G6R acceptance

G6R may PASS only when:

- [x] 44/44 Speech Unit ↔ Visual Beat binding exists;
- [x] no missing/duplicate Visual Beat IDs in the validation fixture;
- [x] planned binding total remains 146.7209s;
- [x] Candidate Visual Beat schema requires durable anchors;
- [x] deterministic Timeline Resolver reference implementation exists;
- [x] resolver smoke test passes without creative mutation;
- [x] Candidate Skill status docs are synchronized;
- [x] current execution package is rebuilt from reconciled contracts.

Reviewer result:

`PASS_G6R_CANDIDATE_RUNTIME_RECONCILIATION`

## 11. Owner intervention

`OWNER_ACTION_REQUIRED = NO`

Normal technical reconciliation remains Reviewer/maintainer work.

## 12. Immediate next action

Run:

`G6A_FIRST_E2E_ASSET_CALIBRATION`

using:

`experiments/g6/blind-search-answer/production-package-v2/ANTIGRAVITY_ASSET_GATE_TASK.md`

This gate may generate real TTS + resolved timeline + 44 production frames, then stop for one calibration review before final FFmpeg assembly.

The Asset review is a **FIRST_E2E_CALIBRATION_EXCEPTION**, not a permanent per-episode Owner gate.

Do not promote the Skill to CANONICAL until final-video E2E PASS.
