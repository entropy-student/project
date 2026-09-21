# Antigravity Task — Blind Search Production TTS

## Scope

Produce the **real production narration audio** for the current Blind Search episode and simultaneously verify it against the already-compiled timing contract.

This is no longer a disposable timing test.

Do NOT build the full Antigravity Production Package.
Do NOT generate images.
Do NOT edit video.

Inputs, relative to:
`ai-story-showrunner/experiments/g6/blind-search-answer/`

- `timing/01_SPEECH_UNITS.json`
- `timing/02_PRODUCTION_SUBTITLES.srt`
- `timing/03_TTS_MANIFEST.json`

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

Load the model once.
Cache the speaker prompt once.
Reset seed exactly as required by the validated deterministic setup.

## Production outputs

Generate and retain:

```text
tts/
├─ units/
│  ├─ SU001.wav
│  ├─ SU002.wav
│  └─ ... 43 voiced units total
├─ narration_master.wav
└─ tts_execution_report.json
```

The explicit 1.4s silent reaction hold is not sent to TTS. It must exist in `narration_master.wav` at the exact timeline position defined by Production SRT / Speech Units.

## Per-unit execution

For every TTS row:

1. use exact `text`;
2. use exact `generation_speed`;
3. generate once;
4. do not retry for aesthetic variation;
5. normalize technical leading/trailing silence using the validated deterministic VAD rule;
6. preserve internal semantic pauses;
7. save normalized production WAV as `tts/units/<speech_unit_id>.wav`;
8. record:
   - raw duration;
   - normalized duration;
   - target speech-window duration = `end - start`;
   - required_extra_speed = max(1.0, actual_normalized / target_speech_window);
   - speech_tail_slack = max(0, target_speech_window - actual_normalized);
   - result.

## Timing acceptance

PASS:
- required_extra_speed <= 1.03x.

PASS_WITH_MINOR:
- >1.03x and <=1.05x.

RETURN:
- >1.05x.

Tail slack is diagnostic.
Do not rewrite timing merely because actual speech is shorter than the safe window.

## Master narration assembly

If and only if all 43 rows have no RETURN:

1. place each normalized unit at its Production SRT target start;
2. preserve every `authored_pause_after`;
3. preserve the explicit 1.4s silent reaction hold;
4. use silence for safe unused tail windows;
5. produce:
   `tts/narration_master.wav`
6. target total timeline:
   approximately `146.7209s` (sample-rounding tolerance allowed).

Do NOT materially time-stretch individual speech units to fill safe slack.

## Critical rule

This is production TTS execution under a frozen timing contract.

Do NOT:
- change Production SRT;
- change text;
- change pace class;
- change generation speed;
- move authored pauses;
- tune the Voice Timing Profile against this episode;
- proceed to images/video/package assembly.

If any row requires >1.05x:

`RETURN_VOICE_TIMING_PROFILE_MISS`

Retain:
- failed unit WAV(s);
- execution report;
- already-successful unit WAVs.

Do not create `narration_master.wav` until the timing miss is resolved.

## Report

Create:
`tts/tts_execution_report.json`

For every row:
- speech_unit_id
- raw_duration_sec
- normalized_duration_sec
- target_speech_window_sec
- required_extra_speed
- speech_tail_slack_sec
- PASS / PASS_WITH_MINOR / RETURN
- production_wav_path

Summary:
- row count
- PASS count
- PASS_WITH_MINOR count
- RETURN count
- worst required_extra_speed
- largest speech-tail slack
- narration master duration, if produced
- overall result

## Final response

Return only:
- execution summary;
- any failed row IDs;
- `narration_master.wav` path if created;
- report path;
- units folder path.

Do not start video production.
