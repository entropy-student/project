# Blind Search Answer — Production Timing Compilation Audit

Date: 2026-09-22

Result:
`PASS_CANDIDATE_TIMING_COMPILED`

Production Package:
`HOLD_BY_OWNER`

This audit covers only:
- Speech Units;
- Production SRT;
- TTS Manifest.

It does **not** assemble the full Antigravity Production Package.

## Sources

- locked script: `experiments/g4r-v03/blind-search-answer/02_SCRIPT.md`
- accepted visual/semantic prior: `experiments/g4r-v03/blind-search-answer/07_VISUAL_BEAT_PLAN.json`
- candidate Timing Compiler: `spike.skill/story-showrunner/references/TIMING_COMPILER.md`
- frozen voice profile: `VOICE_TIMING_PROFILE_COSYVOICE_300M_V2_1`

## Segmentation

- locked-script paragraphs: 63
- accepted Visual Beats: 44
- compiled Speech Units: 44
- TTS units: 43
- explicit silent holds: 1
- locked-script coverage: **100% exact**
- rewritten spoken text: **0**

The accepted Visual Beat boundaries group semantically inseparable short lines and retain the already-reviewed dramatic timing-kind assignment. The Timing Compiler still recalculates all speech duration using Voice Timing Profile v2.1.

## Timing policy

For each spoken unit:

```text
profile_safe_speech_duration = Voice Timing Profile v2.1 prediction
semantic_prior_duration = old accepted Visual Beat duration

allocated_window =
max(profile_safe_speech_duration, semantic_prior_duration)
```

The legacy/Jingsui timing is **non-compressive**:
it may preserve breathing/landing space, but may never shorten Voice Profile safe speech duration.

When the semantic prior is longer:

```text
authored_pause_after =
semantic_prior_duration - profile_safe_speech_duration
```

## Result

- legacy semantic-prior total: **142.210s**
- Production SRT total: **146.721s**
- expansion vs legacy: **4.511s**
- units expanded by Voice Profile over legacy prior: **11**
- spoken units retaining authored hold from legacy prior: **32**
- explicit silent reaction hold: **1.400s**

Largest Voice Profile expansions:

- SRCH_VB038: +1.591s — 所以现在我看 AI 搜索结果，已经不太把“有引用”当成正确证明了。
- SRCH_VB040: +0.740s — 但如果这件事真的会让我花钱、改方案，或者做一个很难撤回来的决定，
- SRCH_VB039: +0.455s — 如果答案不重要，我当然也不会每次都去查。
- SRCH_VB013: +0.395s — 甚至 AI 刚才那句话，也真的能在上面找到。
- SRCH_VB005: +0.368s — 它搜了一下。 / 几秒钟以后，答案出来了：
- SRCH_VB033: +0.272s — 有没有例外。
- SRCH_VB003: +0.222s — 因为有一次，我只是想偷个懒，查一条特别简单的退款规则。 / 问题也很具体：
- SRCH_VB024: +0.185s — 他翻开通讯录，准确找到了老板那一页，然后特别自信地告诉我：

Largest semantic holds retained from legacy prior:

- SRCH_VB021: 1.046s — 它甚至把正确的官网放在了我面前。
- SRCH_VB025: 0.973s — “老板电话是 138……” / 资料没找错。 / 答案还是没回答问题。
- SRCH_VB020: 0.817s — 这时候最奇怪的地方就出现了。 / 它不是没联网。 / 也不是搜到了什么野鸡论坛。
- SRCH_VB010: 0.771s — 本来这件事到这里已经结束了。 / 但我那天可能刚好手比较欠。
- SRCH_VB002: 0.717s — 是先点开看看。
- SRCH_VB029: 0.717s — 然后答案变了。
- SRCH_VB042: 0.714s — “这个来源里的哪句话，真的支持你的结论？”
- SRCH_VB022: 0.714s — 但它拿着回答“订单款项去哪儿”的那句话，回答了我“服务费退不退”的问题。

## Known high-risk sentence repaired

Old reference window:
`所以现在我看 AI 搜索结果，已经不太把“有引用”当成正确证明了。`

Legacy:
**3.020s**

Voice Profile v2.1:
approximately **4.611s**

Production timing therefore uses the Voice Profile duration; the old infeasible window is not reused.

## Silent reaction

Locked-script `……` becomes:
- one 1.400s HARD_ANCHOR SRT hold;
- no TTS generation row.

## Technical alignment

Manifest:
`allowed_alignment_tolerance_ms = 120`

This is technical-only and tied to the validated normalization envelope. It cannot be used for creative retiming or to hide a Voice Profile miss.

## Gate

Timing artifacts:
`READY_FOR_TTS_EXECUTION_OR_DOWNSTREAM_RETIMING`

Allowed next:
- execute/review TTS Manifest;
- remap downstream Visual Beat exact times to Production SRT.

Held by Owner:
- full Antigravity Production Package assembly/discussion.
