# G6R — Candidate Runtime Reconciliation

Date: 2026-09-23  
Status: `IN_PROGRESS_CROSS_REPO`

## Goal

Close the post-extraction contract seam between:

```text
Candidate Timing Compiler
→ planned Production SRT
→ Director Visual Beats
→ durable semantic timing anchors
→ Runtime Timeline Resolver
→ final runtime timeline
```

without reopening already accepted creative work.

## Root cause

The first G6 package combined:

- new Candidate Timing Compiler output;
- old accepted G4 Visual Beats whose absolute timing source remained `JINGSUI_PRIOR_ESTIMATE`;
- a newer Runtime Timeline Resolver contract that assumes durable Speech Unit anchors.

That combination can be useful for migration, but a successful render from it would not by itself prove the portable Candidate pipeline.

## Scope

Allowed:

- timing/Visual Beat binding metadata;
- Candidate schema alignment;
- resolver implementation/QA;
- Production Package contract;
- current status/handoff/index documentation.

Forbidden:

- script rewrite;
- story redesign;
- Visual Beat semantic reorder;
- POV redesign;
- character/style redesign;
- unrelated G4/G5 rework.

## Reconciliation artifact

`experiments/g6/blind-search-answer/timing/05_VISUAL_BEAT_TIMING_BINDINGS.json`

Validation fixture policy:

```text
44 Speech Units
↔ 44 accepted Visual Beats
start = SpeechUnit.START
end   = SpeechUnit.WINDOW_END
timing_flex = SpeechUnit.lock_class
```

The mapping is semantic. Old G4 milliseconds are not production authority.

## Acceptance criteria

### Mapping

- 44 Speech Units.
- 44 unique Visual Beats.
- exact ID-set equality.
- no duplicate binding.
- planned total remains 146.7209s.
- no creative field is changed.

### Candidate schema

Visual Beat runtime contract must carry:

- `speech_unit_id`;
- `start_anchor`;
- `end_anchor`;
- `timing_flex`;
- planned or resolved timing source.

### Runtime resolver

A deterministic implementation must prove:

- actual normalized TTS duration controls final clock;
- authored pauses survive;
- silent HARD_ANCHOR survives;
- downstream timestamps shift deterministically;
- 44/44 Visual Beat mapping survives;
- no text/pace/POV/beat-order mutation;
- final artifacts are emitted without an Owner round-trip.

### Package

The next executable package must be built from the reconciled Candidate contract, not from legacy absolute G4 timing.

## Gate transition

```text
G6R PASS
→ G6A FIRST_E2E_ASSET_CALIBRATION
→ real TTS + final timeline + 44 frames
→ one calibration review
→ final FFmpeg render
→ G7 final-video E2E review
```

The G6A review is calibration-only and must not become a routine per-episode approval gate.
