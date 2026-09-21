# Antigravity Task — Blind Search TTS Execution Only

## Scope

Execute **TTS only** for the already-compiled Blind Search timing artifacts.

Do NOT build the full Antigravity Production Package.
Do NOT generate images.
Do NOT edit video.
Do NOT remap Director/Visual Beats.
Do NOT modify Production SRT.

Inputs:

- `timing/02_PRODUCTION_SUBTITLES.srt`
- `timing/03_TTS_MANIFEST.json`
- `timing/01_SPEECH_UNITS.json`

Relative to:
`ai-story-showrunner/experiments/g6/blind-search-answer/`

## Fixed runtime

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
Reset seed exactly as required by the validated deterministic setup.

## Execution

There are:
- 43 TTS rows;
- 1 explicit silent hold, which must NOT be sent to TTS.

For every TTS row:

1. use exact `text`;
2. use exact `generation_speed`;
3. generate once;
4. do not retry for aesthetic variation;
5. normalize technical leading/trailing silence using the validated deterministic VAD rule;
6. preserve internal semantic pauses;
7. record:
   - raw duration;
   - normalized duration;
   - target speech-window duration = `end - start`;
   - required_extra_speed = max(1.0, actual_normalized / target_speech_window);
   - speech_tail_slack = max(0, target_speech_window - actual_normalized);
   - result.

## Per-row timing result

PASS:
- required_extra_speed <= 1.03x.

PASS_WITH_MINOR:
- >1.03x and <=1.05x.

RETURN:
- >1.05x.

Tail slack is diagnostic here.
Do not rewrite timing merely because actual speech is shorter than the safe window.

## Critical rule

This task is a **Voice Timing execution verification**, not a new timing-design pass.

Do NOT:
- change SRT;
- change semantic pace class;
- change generation speed;
- move authored pauses;
- stretch audio materially;
- tune Voice Profile against these episode rows.

If any row returns >1.05x:
`RETURN_VOICE_TIMING_PROFILE_MISS`

Retain the failed WAV(s) needed for diagnosis and stop before full audio/video assembly.

## If all rows have no RETURN

Create:

1. `tts_execution_report.json`
2. `tts_wavs/` containing the 43 normalized unit WAVs

Do not yet assemble the final master audio unless separately authorized after Production Package discussion.

## Output report

For each row:
- speech_unit_id
- raw_duration_sec
- normalized_duration_sec
- target_speech_window_sec
- required_extra_speed
- speech_tail_slack_sec
- PASS / PASS_WITH_MINOR / RETURN

Summary:
- row count;
- PASS count;
- PASS_WITH_MINOR count;
- RETURN count;
- worst required_extra_speed;
- largest speech-tail slack;
- overall result.

Final response:
return only the summary, any failed row IDs, and retained output paths.
