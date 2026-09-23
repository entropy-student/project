# Story Showrunner Validation Workspace — REVIEWER HANDOFF

Date: 2026-09-23  
Status: `CURRENT TRUTH ONLY / G6A IN_PROGRESS / AUDIO QA RETURN / GPT-SOVITS FINETUNE PASS / INFERENCE QA NEXT / A-B PENDING`

Historical chronology belongs in:
- `PROJECT_RECORD.md`
- `EXECUTION_EVIDENCE.md`
- `experiments/`

Current documentation map:
- `docs/CURRENT_DOC_INDEX.md`

## 1. Final goal

Validate and promote the reusable:

`entropy-student/spike.skill/story-showrunner`

The current `ai-story-showrunner` repository remains the validation/runtime workspace.

Promotion rule remains:

```text
Candidate contracts
→ current episode final-video E2E
→ final QA
→ story-showrunner CANONICAL
```

## 2. Accepted pipeline

```text
TopicProvider
→ DomainAdapter
→ Knowledge / CausalCore
→ StoryEngine
→ Writer
→ TimingCompiler
→ Director
→ Frame / AssetCompiler
→ ProductionCompiler
→ ExecutorAdapter
→ QA
```

AI is the first Domain Adapter, not the core boundary.

## 3. Gate truth after 2026-09-23 takeover review

```text
P0 / G1 / G2 / G2.5 / G3 / G3R / G4 / G5
= ACCEPTED WITH THEIR ORIGINAL VALIDATION SCOPE

G6R = PASS
G6A First-E2E Asset Calibration Gate = IN_PROGRESS / AUDIO_QA_RETURN / FRAME_ASSETS_PARTIAL
G7 Final End-to-End Validation = BLOCKED_BY_G6A
```

Important interpretation:

- G2/G3/G4/G5 PASS means their declared contract/quality gates passed.
- It does **not** mean production throughput or full Candidate E2E already passed.
- Do not reopen accepted story/director/asset semantics unless a new failure invalidates them.

## 4. Why G6R exists

The takeover review found a post-extraction seam:

1. Candidate Timing Compiler already produced 44 Speech Units, Production SRT and TTS Manifest.
2. The current G6 package still consumed the older G4 Visual Beat artifact whose `timing_source` is `JINGSUI_PRIOR_ESTIMATE`.
3. Candidate runtime rules now require planned/final timing semantics and durable Speech Unit anchors.
4. The Runtime Timeline Resolver contract described those anchors, but the current Visual Beat schema/package did not encode them as a required executable contract.

Therefore the existing G6 package v1 is retained as historical evidence but is **not current Candidate E2E proof**.

## 5. Preserved truth — do not redo

G6R must not redesign:

- locked Blind Search script;
- KnowledgeCore / Story meaning;
- the 44 accepted Visual Beat meanings;
- Visual Beat order;
- accepted POV decisions;
- G5 Frame Blueprint creative intent;
- character identity/style rules;
- Voice Timing Profile v2.1;
- FFmpeg baseline renderer decision.

This is a runtime-contract reconciliation, not a creative rebaseline.

## 6. G6R current artifacts

Timing already compiled:

- 44 Speech Units;
- 43 voiced TTS rows;
- 1 explicit 1.4s silent HARD_ANCHOR;
- planned total: 146.7209s;
- exact locked-script coverage: PASS.

New reconciliation binding:

`experiments/g6/blind-search-answer/timing/05_VISUAL_BEAT_TIMING_BINDINGS.json`

It provides 44/44:

```text
visual_beat_id
↔ speech_unit_id
+ START anchor
+ WINDOW_END anchor
+ timing_flex / lock class
```

Historical absolute G4 timestamps are planning evidence only.

## 7. Runtime resolver truth

The Candidate resolver must:

- treat real normalized TTS duration as final speech-clock truth;
- preserve text/order/semantic pace/authored pauses;
- resolve final absolute timestamps from durable anchors;
- emit FINAL_SUBTITLES / FINAL_TIMELINE / FINAL_SHOT_TIMELINE;
- treat profile drift as diagnostic unless a locked hard constraint becomes infeasible;
- never require an ordinary Owner round-trip for retiming.

A deterministic reference implementation and schema alignment belong to the Candidate Skill repository and are part of G6R.

## 8. FFmpeg truth

Video runtime probe already passed programmatically.

Baseline first E2E renderer:

`FFmpeg / deterministic still-first assembly`

Remotion / Hyperframe are optional later renderers, not baseline blockers.

The earlier Handoff statement saying the renderer probe was still pending is superseded.

## 9. Production package truth

`production-package-v1` remains historical candidate evidence.

Current execution package:

`experiments/g6/blind-search-answer/production-package-v2`

It is rebuilt against:
- Candidate planned timing;
- durable 44/44 Visual Beat anchors;
- Candidate-compliant Visual Beats;
- executable Runtime Timeline Resolver;
- current Candidate schemas.

Package v1 remains historical evidence only.

## 10. G6R acceptance

G6R may PASS only when:

- [x] 44/44 Speech Unit ↔ Visual Beat binding exists;
- [x] no missing/duplicate Visual Beat IDs in the validation fixture;
- [x] planned binding total remains 146.7209s;
- [x] Candidate Visual Beat schema requires durable anchors;
- [x] deterministic Timeline Resolver reference implementation exists;
- [x] resolver smoke test passes without creative mutation;
- [x] Candidate Skill status docs are synchronized;
- [x] current execution package is rebuilt from reconciled contracts.

Reviewer result:

`PASS_G6R_CANDIDATE_RUNTIME_RECONCILIATION`

## 11. Owner intervention

`OWNER_ACTION_REQUIRED = NO`

Normal technical reconciliation remains Reviewer/maintainer work.

## 12. Immediate next action

G6A has now been partially executed.

Current facts:

- real CosyVoice production TTS executed;
- Runtime Timeline Resolver executed against real durations;
- runtime master duration is approximately 143.0936s;
- Owner listening QA returned the master for breathing-gap, cut-tail, pronunciation, articulation and prosody issues;
- a targeted CosyVoice repair candidate exists but is not yet accepted;
- first production-frame snapshot reached 20 / 44;
- final render remains blocked.

A local GPT-SoVITS candidate trial is now active because the remaining complaint is not only timing/joins but also synthetic timbre, voiced noise and weak emotion.

Local environment read-back now confirms:
- GPT-SoVITS workspace and dedicated Conda Python resolve correctly;
- Python user-site isolation is active;
- CUDA / RTX 4050 are available;
- required WebUI imports pass;
- `zh_CN` locale is available;
- the WebUI has opened successfully on the Owner machine;
- `pip check` still reports a non-blocking package-name mismatch for `faster-whisper → onnxruntime` while `onnxruntime-gpu` imports successfully.

Local GPT-SoVITS fine-tune status on 2026-09-23:

- target experiment: `narrator01_v2pp`, model family `v2ProPlus`;
- training source prepared from the Owner-selected clean voice sample and produced 13 aligned segments;
- the first fine-tune attempts exposed several Windows-specific runtime failures that the WebUI incorrectly surfaced as "training completed";
- `7-sv_cn` was initially empty because the SV extractor used `torchaudio.load()` and hit the same TorchCodec path previously seen in inference; the local extractor was patched to load WAV through librosa and 13 SV embeddings were then produced;
- SoVITS on Windows single RTX 4050 crashed at the first batch through `mp.spawn + Gloo + DDP` with exit code `3221225477 / 0xC0000005`; the local `s2_train.py` path was patched to bypass DDP for single-GPU Windows execution;
- GPT training had the same unnecessary single-GPU distributed path; `s1_train.py` was patched to use `devices=1 / strategy=auto` for one GPU, and `AR/data/bucket_sampler.py` was patched to use `num_replicas=1 / rank=0` when torch.distributed is not initialized;
- PyTorch Lightning Rich teardown then raised a Windows GBK encoding error after a successful epoch; the local GPT training path now disables the Rich progress bar;
- final SoVITS weights now exist at epochs 4 and 8, with `narrator01_v2pp_e8_s248.pth` as the latest trained SoVITS candidate;
- final GPT weights now exist at epochs 5, 10 and 15, with `narrator01_v2pp-e15.ckpt` as the latest trained GPT candidate;
- the earlier zero-shot listening test used a different target-speaker reference than the voice used for `narrator01_v2pp` fine-tuning, so that earlier listening result is retained only as functional zero-shot evidence and is NOT a valid speaker-similarity A/B baseline for the fine-tuned narrator;
- the fair speaker-similarity comparison must use the same narrator voice reference (preferably a clean held-out 3–10s clip), same target sentence and same inference settings for both base/zero-shot and fine-tuned conditions;
- this establishes local fine-tune execution PASS only; voice similarity / naturalness is not yet accepted and no canonical TTS migration has occurred;
- first post-finetune inference check found `narrator01_v2pp-e15.ckpt` produced an abnormal/near-empty result with the same SoVITS e8 model and reference conditions;
- `narrator01_v2pp-e10.ckpt + SoVITS e8` could sound good on individual runs, but repeated testing exposed semantic-generation instability: one run duplicated the phrase "我才意识到", and subsequent runs could collapse into sparse/non-speech output;
- reducing `temperature` from 1.0 to 0.8 did not make e10 sufficiently stable;
- switching only the GPT checkpoint to `narrator01_v2pp-e5.ckpt`, while keeping SoVITS e8, the same reference audio/text, target text, speed 1, top_k 15, top_p 1 and temperature 0.8, produced 3/3 successful generations;
- current GPT-SoVITS QA candidate is therefore `narrator01_v2pp-e5.ckpt + narrator01_v2pp_e8_s248.pth` with `temperature=0.8`; e10 and e15 are rejected from the current candidate path for stability;
- follow-up repeated QA on the curiosity/suspicion sentence produced 3/3 successful generations with speaker timbre judged similar to the target voice, but the three runs had noticeably different prosody/intonation;
- enabling the WebUI option `是否直接对上次合成结果调整语速和音色，防止随机性` for the same sentence produced 3/3 perceptually identical outputs;
- therefore same-text deterministic replay is available through the inference cache/freeze path; this control is suitable for reusing an accepted semantic/prosody realization, but it must be cleared when moving to a new sentence so a new semantic realization can be generated;
- current interpretation: speaker-similarity, basic generation stability and same-text replay determinism are promising; cross-sentence prosody control is still not yet validated;
- follow-up reversal/surprise sentence QA with cache/freeze disabled was judged by Owner as having no material problem, with no reported repetition/collapse or obvious delivery defect;
- short-reaction QA using the target text `……等等，这也能算正常？` failed on the first attempt; this case is not accepted yet and is being treated as a short-utterance / punctuation robustness probe rather than a reason to reject the whole candidate;
- removing only the leading ellipsis in synthesis text (`等等，这也能算正常？`) produced a successful generation, which supports a synthesis-text normalization rule that strips leading ellipsis while preserving the display/subtitle text;
- the successful short reaction still had a slightly overlong internal pause, so punctuation/short-utterance pause shaping remains a minor QA issue rather than a generation failure;
- removing the internal comma entirely (`等等这也能算正常？`) eliminated the pause altogether, confirming the desired delivery sits between the current comma realization (too long) and no-punctuation realization (too short/no pause);
- this strengthens the current `e5 + e8` candidate, but broader cross-sentence delivery coverage is still pending before canonical promotion;
- this is still a candidate-quality result, not canonical promotion.

Current technical next action:

```text
load narrator01_v2pp-e15.ckpt + narrator01_v2pp_e8_s248.pth in 1C inference
→ use the same clean 3–10s reference and the same comparison sentence
→ judge whether fine-tune materially improves speaker similarity over zero-shot
→ if promising, run the 5-case GPT-SoVITS vs CosyVoice A/B
→ choose audio baseline
→ repair/regenerate only failed units
→ regenerate runtime timeline
→ only then decide whether to resume the remaining frame gate
```

Current audio-trial handoff:

`docs/G6A_AUDIO_QA_AND_TTS_MIGRATION_TRIAL.md`

CosyVoice remains the current canonical timing/voice baseline until the A/B trial passes. Do not mutate the portable Skill merely because the candidate is installed.

Do not promote the Skill to CANONICAL until final-video E2E PASS.
