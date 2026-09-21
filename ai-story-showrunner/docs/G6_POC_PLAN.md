# G6 PoC Plan — Blind Search Answer

Date: 2026-09-21

Status: `READY`

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
2. Resolve `AUDIO_MODE` through a real PoC:
   - A = upstream final TTS/audio;
   - B = Antigravity TTS from locked script/SRT.
3. Once audio is final, compile exact timecodes from locked audio/SRT.
4. Generate `07_SHOT_TIMELINE.csv`.
5. Generate `08_IMAGE_GENERATION.csv` from the accepted 44 G5 execution rows.
6. Generate `09_EDIT_INSTRUCTIONS.md` and output spec.
7. Run a small Antigravity execution slice before full-episode execution.

## PoC acceptance

- references resolve without manual guessing;
- character refs are actually attached on every recurring-IP generation;
- no executor-added bubbles/arrows/checklists/brand;
- timeline follows final audio exactly;
- executor returns instead of improvising when a contract is unresolved.

## Deferred

Hotspot portfolio ratio, hotspot integration policy and expanded IP narrative-engine design remain outside this G6 main-line task.


## SRT timing clarification

`experiments/g4r-v03/blind-search-answer/08_REFERENCE_TIMING.srt` is validated as a **reference timing** file only.

It preserves the accepted 44 Visual Beat timing estimate, but it is not yet waveform-aligned final subtitle timing. After final voice/TTS is locked, G6 must produce `FINAL_AUDIO_ALIGNED.srt` and compile the production Shot Timeline from that real audio.
