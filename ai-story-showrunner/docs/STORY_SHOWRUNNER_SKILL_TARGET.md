# Story Showrunner Skill Productization Target v0.2

## Status

`CANDIDATE EXTRACTION APPROVED / CANONICAL PROMOTION AFTER END-TO-END VALIDATION`

Date: 2026-09-21

## 1. Decision

`ai-story-showrunner` is the current validation workspace, not the intended permanent product boundary.

The intended long-term artifact is a reusable Skill:

`story-showrunner`

The Skill owns the generic narrative-video production control plane. AI is only the first Domain Adapter.

Do not copy the repository wholesale. Extract the stable generic contracts into a **candidate Skill now**, after canonical-conflict reconciliation. Keep the current project as the validation/runtime fixture. Promote the candidate Skill to CANONICAL only after end-to-end production validation.

## 2. Default invocation

When the user invokes Story Showrunner without an explicit topic:

1. read today's Topic Calendar;
2. use today's scheduled topic;
3. if no valid scheduled topic exists, ask/use Topic Radar;
4. if Radar has no suitable result, fall back to Evergreen Bank.

Topic precedence:

```text
EXPLICIT USER TOPIC
> EXPLICIT USER CONSTRAINT / OVERRIDE
> TODAY'S CALENDAR
> TOPIC RADAR
> EVERGREEN BANK
```

The user should not need to manually restate the planned daily topic.

## 3. Generic pipeline

```text
Topic Provider
→ Domain Research Adapter
→ Knowledge / Causal Core
→ Story Engine
→ Writer
→ Timing Compiler
→ Director
→ Asset Compiler
→ Production Compiler
→ Executor
→ QA
```

The generic system is domain-neutral.

Domain Adapters may specialize:
- research/evidence requirements;
- factual schemas;
- terminology;
- causal-model rules;
- visual source requirements.

Initial adapters may include:
- AI / technology;
- business;
- economics;
- science;
- history;
- psychology.

## 4. Default human-intervention policy

Normal production should not require the owner to approve:
- topic translation;
- story premise;
- final script;
- SRT;
- timing;
- Director plan;
- key-frame samples;
- image-generation prompts;
- Production Package.

Default owner interaction:

```text
invoke / optional override
→ autonomous production
→ final video review
```

The system should interrupt only on a real RETURN/BLOCKED state that cannot be resolved inside its contract.

Examples:
- `RETURN_FACT_UNRESOLVED`
- `RETURN_STORY_WEAK`
- `RETURN_TIMING_INFEASIBLE`
- `RETURN_CHARACTER_DRIFT`
- `RETURN_EXECUTION_FAILURE`

## 5. Key-frame calibration policy

Manual first-batch / critical-frame generation is NOT part of the normal per-episode workflow.

It exists only for calibration when:
- a new image model/provider is introduced;
- a new recurring character is introduced;
- a new visual style is introduced;
- a materially new scene/reference system is introduced;
- the executor or prompt compiler changes materially;
- automated QA repeatedly returns a new failure class.

The G5 high-risk Pilot was a system test used to strengthen constraints. Its successful lessons must be encoded into machine contracts so future episodes do not require the same manual sampling loop.

## 6. Timing Compiler placement

Production-grade SRT timing should be compiled close to the Writer stage, before Director work.

Target flow:

```text
Writer locked script
→ semantic Speech Units
→ semantic timing class
→ reusable Voice Timing Profile
→ predicted production SRT
→ Director
```

Later TTS generation is primarily an execution/QA step, not a normal second creative timing pass.

A large mismatch during TTS indicates a Timing Compiler / Voice Timing Profile defect and should RETURN for system correction.

## 7. Two-stage migration lifecycle

### Stage A — Candidate extraction now

Allowed after:
- project-wide migration review exists;
- P0 canonical conflicts are reconciled;
- stable core vs domain adapter vs profile vs runtime-state boundaries are explicit.

Candidate extraction moves:
- generic contracts;
- schemas;
- templates;
- provider/domain adapters;
- reusable profiles.

It does **not** move:
- episode artifacts;
- Pilot history;
- calibration history except the frozen production profile;
- live project Gate state.

Candidate status:
`CANDIDATE / VALIDATION_REQUIRED`

### Stage B — Canonical promotion after E2E

Promote `story-showrunner` to CANONICAL only after:
- frozen Voice Timing Profile is used to compile a Production SRT;
- one complete Production Package is compiled;
- executor completes TTS + image generation + edit + export;
- final QA localizes failures correctly;
- the current validation episode reaches a reviewable final video.

After PASS:
- the Skill becomes the default reusable control plane;
- the current `ai-story-showrunner` project becomes a validation/history workspace;
- future episode runtime state lives outside Skill source.

