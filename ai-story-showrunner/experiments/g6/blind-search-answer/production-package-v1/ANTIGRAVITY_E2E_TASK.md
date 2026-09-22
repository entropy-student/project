# Antigravity E2E Task — Blind Search Answer v1

## Mission

Produce the first complete final video from the already validated Story Showrunner artifacts.

This run validates:
- one-delivery execution;
- real production TTS;
- automatic final-timeline resolution;
- resume-safe 44-frame generation;
- deterministic FFmpeg assembly;
- final QA.

## Hard rule

Do not redesign the episode.

You are Executor, not Writer/Director.

## Preflight

Locate the project artifacts listed in `PACKAGE_MANIFEST.json`.

Required exact source files:
- `02_SCRIPT.md`
- `01_SPEECH_UNITS.json`
- `03_TTS_MANIFEST.json`
- `TIMELINE_RESOLVER_RULES.md`
- `07_VISUAL_BEAT_PLAN.json`
- `13_FRAME_BLUEPRINTS_V04.json`
- `14_EXECUTION_ROWS_V02.json`
- `08_REFERENCE_MANIFEST.json`

Resolve the G5 reference package.

If an artifact cannot be located, do not fabricate it.
Return `RETURN_E2E_SOURCE_MISSING` with the missing path.

## Stage A — Production TTS + final timeline

Follow the existing production TTS contract.

Generate Speech Units separately, model loaded once when practical.

Checkpoint every completed unit.

Then run Runtime Timeline Resolver.

Required:
- `tts/narration_master.wav`
- `timing/runtime/FINAL_SUBTITLES.srt`
- `timing/runtime/FINAL_TIMELINE.json`
- `timing/runtime/FINAL_SHOT_TIMELINE.csv`

Actual normalized TTS duration is final speech-clock truth.

Do not bring the real SRT back to the Owner for recompilation.

## Stage B — Images

Execute `14_EXECUTION_ROWS_V02.json` in row order.

Output:
```text
frames/
SRCH_VB001.png
...
SRCH_VB044.png
```

Rules:
- obey GENERATE / DERIVE_EDIT / COMPOSITE_CROP;
- bind all declared references;
- enforce CHAR_IP_001 identity/maturity/costume lock;
- exact causal UI/document wording uses POST_OVERLAY where declared;
- no invented brands/logos;
- no decorative lesson cards/checklists;
- no POV changes;
- no changing story meaning.

For DERIVE_EDIT:
- source frame must already be accepted;
- canonical identity reference remains authoritative;
- edit only declared delta.

For COMPOSITE_CROP:
- use deterministic source crops/layout;
- do not replace with a regenerated explanatory poster.

### Resume

After each accepted frame:
- save immediately;
- append checkpoint status;
- never regenerate accepted earlier rows after network/session interruption.

Equivalent retry limit:
up to 2 retries for technical/model execution failure or direct acceptance failure, with the same semantic contract and references.

Do not rewrite the prompt meaning to “improve taste”.

If still failing:
return the exact image RETURN code and preserve all completed outputs.

## Stage C — Compile render plan

Read:
`timing/runtime/FINAL_SHOT_TIMELINE.csv`

For E2E v1:
- every Visual Beat render mode = STATIC/HOLD;
- use one accepted frame per Beat;
- no Remotion;
- no Hyperframe;
- no invented transition;
- cuts are hard cuts unless a transition is explicitly locked upstream.

Create:
`render/render_plan.json`

Each row:
- visual_beat_id
- frame
- final_start
- final_end
- duration
- render_mode = STATIC

Visual boundaries are quantized to 30fps only at render time.

## Stage D — FFmpeg render

Use the validated installed FFmpeg backend.

Inputs:
- 44 accepted PNG frames;
- `tts/narration_master.wav`;
- `timing/runtime/FINAL_SUBTITLES.srt`;
- `render/render_plan.json`.

Target:
- 1920x1080
- 30fps
- H.264 / yuv420p
- AAC audio
- subtitles burned in
- no BGM
- no SFX

Output:
`final/blind-search-answer.mp4`

Use `renderer/ffmpeg_render.py`.

If final render fails, retry render only.
Do not regenerate TTS/images because of an FFmpeg failure.

## Stage E — Final QA

Verify with ffprobe and timeline checks:

- output exists;
- H.264;
- 1920x1080;
- 30fps;
- audio exists;
- all 44 Visual Beats appear in correct order;
- no missing/black gap frames;
- subtitle text/order matches FINAL_SUBTITLES;
- final duration matches resolved timeline within one video frame plus encoder tail tolerance;
- opening/ending callback preserved;
- no unrequested BGM/SFX.

Create:
- `FINAL_QA_REPORT.json`
- `RUN_RECORD.json`

## PASS

Return:
`PASS_CANDIDATE_E2E_FINAL_VIDEO`

only when the final MP4 and QA report pass.

## Final response

Return only:
1. overall result;
2. final duration;
3. TTS unit count;
4. frame count;
5. FFmpeg backend path/version;
6. final video path;
7. FINAL_SUBTITLES path;
8. FINAL_SHOT_TIMELINE path;
9. FINAL_QA_REPORT path;
10. RUN_RECORD path;
11. any minor issues.

Do not start a second creative pass after PASS.
