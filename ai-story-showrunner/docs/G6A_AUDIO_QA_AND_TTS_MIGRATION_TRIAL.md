# G6A Audio QA + Candidate TTS Migration Trial

Date: 2026-09-23  
Status: `IN_PROGRESS / COSYVOICE AUDIO QA RETURN / GPT-SOVITS CANDIDATE NOT YET PROVEN`

## 1. Purpose

Record the first real G6A production-audio execution, Owner listening findings, targeted repair plan, and the ongoing local GPT-SoVITS candidate trial.

This document is current execution evidence / handoff material. It does **not** promote GPT-SoVITS into the canonical Story Showrunner Skill.

Current rule:

```text
CosyVoice-300M = current proven timing baseline
GPT-SoVITS = candidate voice-quality replacement under A/B validation
final audio baseline changes only after an explicit A/B PASS
```

## 2. Real production audio actually executed

The Blind Search episode has now executed the previously planned production TTS path:

- 44 semantic/timeline units;
- 43 voiced TTS units;
- 1 silent reaction anchor;
- runtime timeline resolver executed against real normalized speech durations;
- final runtime artifacts were produced:
  - `tts/units/*.wav`
  - `tts/narration_master.wav`
  - `tts/tts_execution_report.json`
  - `timing/runtime/FINAL_SUBTITLES.srt`
  - `timing/runtime/FINAL_TIMELINE.json`
  - `timing/runtime/FINAL_SHOT_TIMELINE.csv`
  - `timing/runtime/TIMELINE_RESOLUTION_REPORT.json`
- resulting master duration: approximately **143.0936s**.

This proves the one-delivery runtime-timeline architecture can consume real TTS durations. It does **not** prove final audio quality.

## 3. Owner listening QA — RETURN

Owner listening found the following defects in the generated master:

| Approx. time | Observed issue | Working location |
|---|---|---|
| ~13s | adjacent segments have no breathing gap | SU003 → SU004 |
| ~16s | adjacent segments have no breathing gap | SU004 → SU005 |
| ~18s | hard join plus audible interruption | SU005 → SU006 |
| ~47s | adjacent segments have no breathing gap | SU013 → SU014 |
| ~51s | adjacent segments have no breathing gap | SU014 → SU015 |
| ~55s | pause / interruption is too long | SU016 → SU017 → SU018 |
| ~58s | articulation unclear; tail-cut risk observed | SU018 / SU019 |
| ~68s | “正确的官网” is mispronounced | SU021 |
| ~1:23 | numeric reading in the boss-phone-number line is wrong | SU025 |
| ~2:02 | “AI” pronunciation is inaccurate | SU038 |
| ~2:08 | several syllables sound overlapped / crowded | SU040 |

Additional qualitative feedback:

- voice does not sound sufficiently human;
- voiced regions have a noisy / synthetic grain;
- emotional variation is weak;
- the single neutral zero-shot reference plus per-unit generation likely resets prosody too aggressively.

Therefore:

`AUDIO_MASTER = RETURN_FOR_LISTENING_QUALITY`

## 4. Targeted CosyVoice repair candidate

A targeted repair package was prepared instead of regenerating the whole episode.

Candidate repair scope:

- add small semantic breathing gaps at the hard joins;
- shorten the explicit silent reaction hold from 1.4s to about 0.75s for this episode;
- regenerate only the problematic speech units:
  - `SU018`
  - `SU019`
  - `SU021`
  - `SU025`
  - `SU038`
  - `SU040`
- keep subtitle text unchanged while permitting synthesis-only pronunciation normalization:
  - displayed `138` → synthesis reads `一三八`;
  - displayed `AI` → synthesis uses separated letter pronunciation;
- split SU040 internally to avoid local syllable crowding;
- add edge-energy QA so a unit cannot PASS while its tail is still clearly voiced;
- add master-level listening QA; file existence / duration alone is no longer sufficient.

Important:

This repair package is **prepared but not yet accepted as the final master**.

## 5. Why a candidate TTS replacement is being tested

The repair above can address:

- hard joins;
- unsafe VAD trimming;
- numbers / abbreviations;
- isolated bad generations.

It does not necessarily solve:

- synthetic timbre;
- noisy voiced texture;
- weak long-form emotion;
- repeated neutral prosody.

Therefore the Owner approved a local TTS A/B trial rather than continuing to patch CosyVoice indefinitely.

## 6. Candidate selected for local trial

Candidate:

`GPT-SoVITS / V2Pro-family path`

Reason for trial:

- local Windows use;
- compatible with the available RTX 4050 Laptop GPU / 6GB VRAM target;
- zero-shot / few-shot voice cloning;
- reference-audio-driven emotional variation;
- script/API integration is compatible with the current executor architecture.

The intended long-term interface remains provider-neutral:

```text
locked text
+ emotion / delivery class
+ reference voice asset
→ TTS adapter
→ wav unit
→ audio QA
→ runtime timeline resolver
```

## 7. Local GPT-SoVITS installation state

Workspace:

`C:\AI\GPT-SoVITS`

Conda environment:

`GPTSoVits / Python 3.10.21`

Verified:

- RTX 4050 Laptop GPU visible to CUDA;
- PyTorch CUDA path is operational;
- FFmpeg 9.0 available;
- CMake 4.4.3 available;
- pretrained GPT-SoVITS models downloaded;
- G2PW model downloaded;
- ONNX Runtime exposes CUDA / TensorRT providers;
- faster-whisper imports successfully;
- OpenCC Windows wheel installed;
- pyopenjtalk compatibility path installed.

Windows compatibility adjustments made during installation:

1. reuse external FFmpeg/CMake instead of repeatedly pulling them through Conda;
2. replace `jieba_fast` usage with standard `jieba` for this Windows environment;
3. use `pyopenjtalk-plus` instead of compiling `pyopenjtalk` from source;
4. use a prebuilt Windows OpenCC wheel;
5. isolate the Conda environment from roaming/user Python packages with `PYTHONNOUSERSITE=1`;
6. pin Gradio-compatible FastAPI / Starlette versions during WebUI troubleshooting;
7. bypass localhost proxying with `NO_PROXY=localhost,127.0.0.1,0.0.0.0`.

## 8. Current installation blocker

The environment is not yet declared PASS.

Latest WebUI start attempt exposed missing transitive packages in the isolated Conda environment:

- `shellingham` — immediate startup blocker;
- `rapidfuzz>=3.0.0` — required by FunASR;
- `platformdirs>=2.5.0` — required by pooch.

Next technical action:

```text
complete isolated-environment dependency sync
→ pip check
→ launch WebUI successfully
→ generate a short A/B test set
```

Do not reinstall the whole environment unless this targeted repair fails.

## 9. A/B acceptance plan

Do not render the full episode with the candidate model first.

Use a small representative set:

1. neutral narration;
2. curiosity / suspicion;
3. reversal / surprise;
4. speechless reaction;
5. serious closing line.

Compare against the existing CosyVoice output on:

- speaker similarity;
- human-likeness;
- voiced noise / grain;
- pronunciation correctness;
- emotional fit;
- local continuity;
- generation stability;
- runtime cost on the current machine.

Decision:

```text
GPT-SoVITS PASS
→ make a new voice timing profile / adapter contract
→ regenerate only required episode units
→ resolve final runtime timeline again

GPT-SoVITS RETURN
→ retain CosyVoice baseline
→ execute the targeted CosyVoice repair candidate
```

## 10. G6A relationship

G6A is no longer `READY_NOT_EXECUTED`.

Actual state:

- real production TTS: executed;
- runtime timeline resolution: executed;
- final audio quality: RETURN / repair pending;
- production frames: partially generated (20 / 44 reported at the latest asset snapshot);
- final render: still blocked;
- G7: still blocked by G6A.

No Skill canonical promotion is authorized from this work.
