# Antigravity Task — Blind Search Production TTS + Runtime Timeline Resolution

## Scope

Produce the real narration audio for this episode and resolve the **final absolute timeline** locally from actual TTS durations.

This is part of the one-delivery architecture.

Do NOT:
- generate images;
- edit/render the real episode video;
- build/freeze the full Antigravity Production Package;
- return actual SRT to the Owner for a second Showrunner compile.

Inputs, relative to:
`ai-story-showrunner/experiments/g6/blind-search-answer/`

- `timing/01_SPEECH_UNITS.json`
- `timing/02_PRODUCTION_SUBTITLES.srt`  ← planned timeline
- `timing/03_TTS_MANIFEST.json`
- `TIMELINE_RESOLVER_RULES.md`

## Fixed TTS runtime

Use the already validated local setup:

- CosyVoice:
  `C:\Users\34707\Desktop\视频制作流\5.音频制作\CosyVoice`
- venv:
  `C:\Users\34707\Desktop\视频制作流\5.音频制作\cosyvoice-venv`
- reference WAV:
  `C:\Users\34707\Desktop\视频制作流\5.音频制作\reference-clone.wav`
- reference transcript:
  `C:\Users\34707\Desktop\视频制作流\5.音频制作\reference-clone-text.txt`
- model: CosyVoice-300M
- mode: zero_shot
- seed: 1986
- sample rate: 22050 Hz

Load model once.
Cache speaker prompt once.
Use one process/session when practical.

## Resume-safe execution

Generate by Speech Unit, not one giant request.

For each completed unit:
1. write normalized production WAV immediately;
2. append/update the execution report immediately;
3. mark the unit complete.

If the agent/session/network is interrupted:
- do not regenerate already completed PASS units;
- verify their files/report entries;
- resume from the first incomplete unit.

## Production outputs

Generate and retain:

```text
tts/
├─ units/
│  ├─ SU001.wav
│  └─ ... 43 voiced units
├─ narration_master.wav
└─ tts_execution_report.json

timing/runtime/
├─ FINAL_SUBTITLES.srt
├─ FINAL_TIMELINE.json
├─ FINAL_SHOT_TIMELINE.csv
└─ TIMELINE_RESOLUTION_REPORT.json
```

The explicit 1.4s silent reaction unit is not sent to TTS.

## Per-unit TTS

For every manifest row:

1. exact text;
2. exact generation speed;
3. deterministic seed/settings;
4. generate once; no aesthetic retry loop;
5. normalize technical head/tail silence with the validated VAD rule;
6. preserve internal semantic pauses;
7. save as `tts/units/<speech_unit_id>.wav`;
8. record raw/normalized durations.

Also calculate:

`required_extra_speed_if_forced_to_plan = actual_normalized / planned_speech_window`

This metric is for profile diagnostics.

If >1.05:
record `VOICE_TIMING_PROFILE_DRIFT`.

Do NOT automatically fail the current episode only because the actual speech is longer than planned.

## Runtime Timeline Resolver

After all 43 voiced units exist, follow:
`TIMELINE_RESOLVER_RULES.md`

Core rule:

> actual normalized speech duration becomes final runtime clock truth.

Automatically:
- shift downstream absolute timestamps;
- preserve Speech Unit order;
- preserve authored semantic pauses;
- preserve the explicit 1.4s HARD_ANCHOR;
- rebalance only ELASTIC slack;
- extend semantically valid visual holds;
- allow total episode duration to expand.

Do NOT:
- rewrite text;
- change pace class;
- choose a new speed;
- delete/reorder Speech Units;
- change Visual Beat meaning/order/POV;
- force major time-stretch to retain planned total duration.

## FINAL_SUBTITLES.srt

Generate from resolved actual timing.

Text/order must remain exactly aligned to the locked Speech Units.

No overlaps.

## FINAL_TIMELINE.json

For every Speech Unit include:
- speech_unit_id;
- planned_start/end;
- actual_duration;
- final_start;
- final_speech_end;
- final_window_end;
- resolved_pause_after;
- delta_vs_planned_ms;
- profile_drift flag;
- repair_level_used.

## FINAL_SHOT_TIMELINE.csv

For the current one-Speech-Unit-per-Visual-Beat mapping include:

- visual_beat_id
- speech_unit_id
- final_start
- final_end
- timing_source = RESOLVED_RUNTIME_TIMELINE
- delta_vs_planned_ms
- repair_level_used

## Master narration

Build `tts/narration_master.wav` from the resolved timeline:
- place each normalized Speech Unit at its final start;
- preserve resolved pauses;
- preserve 1.4s silent reaction;
- no forced stretching to fill planned windows.

Its duration should match the resolved final episode timeline, not necessarily 146.7209s.

## Blocking return

Return:
`RETURN_TIMELINE_RESOLUTION_INFEASIBLE`

only if a locked constraint cannot be preserved without changing creative/semantic truth.

Examples:
- Speech Unit order must change;
- HARD_ANCHOR must be removed;
- text/speed/pace must be creatively redesigned;
- Visual Beat meaning or POV must change;
- two hard constraints conflict.

## Final response

Return only:

- TTS rows completed / resumed count;
- profile-drift row IDs, if any;
- overall timeline-resolution result;
- final total duration;
- `tts/narration_master.wav` path;
- `tts/tts_execution_report.json` path;
- `timing/runtime/FINAL_SUBTITLES.srt` path;
- `timing/runtime/FINAL_TIMELINE.json` path;
- `timing/runtime/FINAL_SHOT_TIMELINE.csv` path;
- `timing/runtime/TIMELINE_RESOLUTION_REPORT.json` path.

Do not start real episode video production.
