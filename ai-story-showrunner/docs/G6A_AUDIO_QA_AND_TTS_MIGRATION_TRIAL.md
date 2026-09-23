# G6A Audio QA + Candidate TTS Migration Trial

Date: 2026-09-23  
Status: `IN_PROGRESS / COSYVOICE AUDIO QA RETURN / GPT-SOVITS MANUAL QA PASS_CANDIDATE / API DETERMINISM NEXT`

## 1. Purpose

Record the first real G6A production-audio execution, Owner listening findings, targeted repair plan, and the ongoing local GPT-SoVITS candidate trial.

This document is current execution evidence / handoff material. It does **not** promote GPT-SoVITS into the canonical Story Showrunner Skill.

Current rule:

```text
CosyVoice-300M = current canonical timing/voice baseline
GPT-SoVITS = manual listening QA PASS_CANDIDATE
final audio baseline changes only after GPT-SoVITS official API/runtime validation + its own Voice Timing Profile held-out validation
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

## 8. Current local environment state

The installation blocker is closed for WebUI launch.

Latest local environment check:

- workspace: `C:\\AI\\GPT-SoVITS`;
- Python: `C:\\Users\\34707\\miniconda3\\envs\\GPTSoVits\\python.exe`;
- Python 3.10.21;
- `PYTHONNOUSERSITE=1` effective;
- CUDA = true;
- RTX 4050 Laptop GPU detected;
- Gradio 4.44.1;
- FastAPI 0.115.14;
- Starlette 0.46.2;
- `shellingham`, `rapidfuzz`, `platformdirs`, `onnxruntime`, `jieba`, `opencc`, `pyopenjtalk` imports all PASS;
- project config import PASS;
- main port = 9874;
- device = `cuda:0`;
- `zh_CN` locale available;
- Owner confirmed the WebUI opened successfully.

Remaining environment note:

`pip check` reports that `faster-whisper 1.2.1` requires the distribution `onnxruntime`, while the current environment uses `onnxruntime-gpu` and the `onnxruntime` module imports successfully. Treat this as a non-blocking packaging metadata warning unless a real faster-whisper runtime failure appears.

Next technical action:

```text
run prepared official API determinism smoke with e5 + e8
→ listen to retained API sample
→ if API path PASS, run one-time GPT-SoVITS Voice Timing Profile calibration + held-out validation
→ validate provider adapter/runtime duration handoff
→ only then decide canonical audio migration and episode regeneration scope
```

Do not reinstall or rebuild the environment merely to clear the metadata warning.

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


## 11. GPT-SoVITS fine-tune + representative listening QA closeout

Fine-tune execution is complete for experiment `narrator01_v2pp` / `v2ProPlus`.

Current candidate:

```text
GPT: narrator01_v2pp-e5.ckpt
SoVITS: narrator01_v2pp_e8_s248.pth
temperature: 0.8
top_k: 15
top_p: 1
speed: 1
parallel inference: false
```

Checkpoint QA:
- e15 produced an abnormal / near-empty result in the current inference path;
- e10 could sound good but repeated QA exposed phrase repetition and sparse/non-speech collapse;
- e5 + e8 produced 3/3 successful repeated generations in the stability check and remained the strongest current candidate.

Representative Owner listening QA:
- neutral narration: accepted;
- curiosity / suspicion: accepted;
- reversal / surprise: accepted;
- serious closing: accepted;
- short reaction: accepted with a punctuation caveat.

Punctuation evidence:
- leading ellipsis on a short reaction could cause synthesis failure;
- ordinary Chinese comma succeeded but can pause slightly long;
- removing the comma removed the pause entirely;
- Chinese enumeration comma caused a failed synthesis in that probe;
- Owner decision: keep ordinary Chinese comma as the default and do not add systematic post-processing pauses.

Same-text WebUI cache/freeze produced perceptually identical replay, but production automation must validate the official API seed/runtime path rather than depend on UI cache state.

Reviewer state:
`GPT_SOVITS_MANUAL_LISTENING_QA = PASS_CANDIDATE`.

## 12. Prepared API automation gate

Prepared project helpers:

- `tools/gpt-sovits/PATCH_API_TORCHCODEC.bat`
- `tools/gpt-sovits/START_GPT_SOVITS_API.bat`
- `tools/gpt-sovits/RUN_API_DETERMINISM_SMOKE.bat`
- `tools/gpt-sovits/API_DETERMINISM_SMOKE.py`

Owner-designated local reference for the next API smoke:

```text
audio:
C:\Users\34707\Downloads\morning.mp3

transcript:
睡得好吗？希望你今天顺利，别遇到那种一大早就能惹你生气的人。
```

This absolute path is runtime configuration only; it is not portable Skill identity.

The next gate is:

```text
official API smoke
→ deterministic/reproducible output evidence
→ retained listening sample
→ GPT-SoVITS Voice Timing Profile calibration
```

No full-episode regeneration is authorized before this gate passes.


## 11. GPT-SoVITS representative listening QA closeout

Current candidate:

```text
GPT: narrator01_v2pp-e5.ckpt
SoVITS: narrator01_v2pp_e8_s248.pth
temperature: 0.8
top_k: 15
top_p: 1
speed: 1
parallel inference: false
```

Observed checkpoint behavior:
- e15 produced an abnormal / near-empty synthesis in the current QA path;
- e10 could sound good, but repeated QA exposed phrase repetition and sparse/non-speech collapse;
- e5 + e8 produced repeated successful generations and is the current candidate pair.

Representative Owner listening QA covered:
- neutral narration;
- curiosity / suspicion;
- reversal / surprise;
- short reaction;
- serious closing.

Result:
`GPT_SOVITS_MANUAL_LISTENING_QA = PASS_CANDIDATE`.

Known minor:
- ordinary Chinese comma can pause slightly long;
- short-reaction leading ellipsis can destabilize synthesis;
- Owner decision is to keep ordinary Chinese comma as default and avoid systematic pause post-processing.

Same-text WebUI cache/freeze replay proved identical replay is possible, but production automation must validate the official API seed/runtime path rather than depend on UI cache state.

Prepared next-gate helpers:
- `tools/gpt-sovits/PATCH_API_TORCHCODEC.bat`
- `tools/gpt-sovits/START_GPT_SOVITS_API.bat`
- `tools/gpt-sovits/RUN_API_DETERMINISM_SMOKE.bat`
- `tools/gpt-sovits/API_DETERMINISM_SMOKE.py`

No full-episode regeneration is authorized before API/runtime and timing-profile validation pass.


## 13. Asset-generation timing policy — SRT1 / SRT2 / SRT3

Owner decision on 2026-09-23:

The current phase is still **material / asset generation**. Audio duration does not need to match the planned duration exactly at this stage, but the actual generated duration must be measured and recorded precisely.

Working timing layers:

```text
SRT1 = planned/compiler timing
SRT2 = actual GPT-SoVITS generated-audio timing
SRT3 = final post-assembly timing after redundant breath-gap cleanup
```

Rules for current SRT2 stage:
- do not force a sentence into an exact planned number of seconds;
- do not compress or time-stretch voiced speech simply to satisfy SRT1;
- record every generated unit's actual duration precisely;
- use actual recorded duration as runtime timing truth for material assembly;
- accept occasional overlong internal breath/punctuation pauses as a known material-stage issue when speech itself is otherwise usable.

Final cleanup:
- after the first video assembly, perform a dedicated final timing pass;
- trim redundant breath gaps / overlong **non-semantic** pauses where appropriate;
- do not remove authored semantic pauses or HARD_ANCHOR meaning;
- after that cleanup, regenerate final subtitle/timeline timestamps as SRT3.

This is a project-level E2E validation decision. Do not promote it into the portable canonical Skill until the final-video E2E validates the workflow.
