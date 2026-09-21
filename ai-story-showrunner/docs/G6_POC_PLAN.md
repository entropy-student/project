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
3. Segment the locked script into natural Speech Units under `docs/SRT_AUDIO_TIMING_STANDARD.md`.
4. Run the fixed CosyVoice Voice Profile at one episode-level base speed; measure real duration for every Speech Unit.
5. Normalize technical head/tail silence and author explicit pause intervals.
6. Assemble and lock `FINAL_AUDIO.wav`.
7. Compile `FINAL_AUDIO_ALIGNED.srt` from the measured audio timeline.
8. Retime the accepted Visual Beats against FINAL_AUDIO while preserving order, dramatic job, POV and setup/payoff relationships.
9. Generate `07_SHOT_TIMELINE.csv`.
10. Generate `08_IMAGE_GENERATION.csv` from the accepted 44 G5 execution rows.
11. Generate `09_EDIT_INSTRUCTIONS.md` and output spec.
12. Run a small Antigravity execution slice before full-episode execution.

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
old timestamps inherited G4 Visual Beat pacing estimates. They are not valid speech-duration contracts.

Therefore:
- Audio Master becomes the production clock;
- exact SRT is generated from measured audio;
- Visual Beats are retimed after audio lock;
- per-cue major speed-up is prohibited as a rescue mechanism;
- planning `5 chars/sec` remains planning-only and cannot create production timestamps.
