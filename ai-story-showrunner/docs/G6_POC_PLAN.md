# G6 PoC Plan — Blind Search Answer

Date: 2026-09-21

Status: `IN_PROGRESS`

## Goal

Turn accepted G4/G5 outputs into a deterministic low-level package that Antigravity can execute without creative interpretation.

## Entry conditions

- G4 = PASS;
- G5 = PASS;
- high-risk Pilot = PASS;
- reference-path validation = PASS;
- persistent reference package v1 = available.

## First sequence

1. Materialize `g5-reference-package-v1` into the G6 working package.
2. Use `AUDIO_MODE=A_UPSTREAM_COSYVOICE`.
3. Segment the locked script into Speech Units while preserving G4 `timing_kind`, pace intent, timing anchors and reference durations.
4. Run the fixed CosyVoice Voice Profile at calibrated base speed to measure feasibility for every Speech Unit.
5. Build `TIMING_CALIBRATION.json`: compare reference windows against semantic speed envelopes and identify infeasible regions.
6. Keep feasible reference windows; locally reallocate time only where needed, protecting anchors and semantic pace.
7. Generate semantic-paced TTS at the solved per-unit speed and assemble `FINAL_AUDIO.wav` with authored pauses.
8. Compile `FINAL_AUDIO_ALIGNED.srt` from the solved audio timeline.
9. Retime the accepted Visual Beats only where exact timing changed, preserving order, dramatic job, POV and setup/payoff relationships.
10. Generate `07_SHOT_TIMELINE.csv`.
11. Generate `08_IMAGE_GENERATION.csv` from the accepted 44 G5 execution rows.
12. Generate `09_EDIT_INSTRUCTIONS.md` and output spec.
13. Run a small Antigravity execution slice before full-episode execution.

## PoC acceptance

- references resolve without manual guessing;
- character refs are actually attached on every recurring-IP generation;
- no executor-added bubbles/arrows/checklists/brand;
- timeline follows final audio exactly;
- executor returns instead of improvising when a contract is unresolved.

## Deferred

Hotspot portfolio ratio, hotspot integration policy and expanded IP narrative-engine design remain outside this G6 main-line task.


## SRT / Audio timing decision

Canonical contract:
`docs/SRT_AUDIO_TIMING_STANDARD.md`

`experiments/g4r-v03/blind-search-answer/08_REFERENCE_TIMING.srt` is a **planning/reference artifact only**.

PoC evidence showed:
- baseline natural TTS: 2.5542s inside a 2.680s old window — PASS;
- tight sentence natural TTS: 4.2493s inside a 3.020s old window — would require 1.407x and sounded unacceptable;
- punch natural TTS: 1.2771s inside a 1.350s old window — PASS.

Root cause:
old timestamps mixed useful semantic rhythm intent with numeric windows that were not always voice-feasible.

Therefore:
- keep `timing_kind`, relative pacing and protected anchors as upstream creative constraints;
- use raw TTS only to measure physical feasibility, not to flatten the whole episode to one natural pace;
- keep old reference windows when they are feasible inside the semantic speed envelope;
- when a window is infeasible, borrow/donate time locally before changing section/episode duration;
- major per-cue speed-up is prohibited as a rescue mechanism;
- final Audio Master freezes the solved semantic-paced schedule.
