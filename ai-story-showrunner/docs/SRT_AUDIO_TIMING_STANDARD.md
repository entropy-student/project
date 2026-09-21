# SRT / Audio Timing Standard v0.5 — CANONICAL

## Status

`CANONICAL / TIMING COMPILER BEFORE DIRECTOR / VOICE PROFILE v2.1`

Date: 2026-09-22

## 1. Purpose

Production speech timing is **planned before Director work**. Final absolute timestamps are resolved automatically after real TTS.

```text
locked spoken script
→ Speech Units
→ semantic timing intent
→ Voice Timing Profile
→ PLANNED Production SRT + TTS Manifest
→ Director
→ Assets
→ Production Package
→ Executor TTS
```

Real TTS is execution/QA and the source of final absolute speech duration. It does not trigger a second creative timing pass; a Runtime Timeline Resolver automatically derives the final timeline.

## 2. Authority

### Writer / Story
Owns:
- locked spoken text;
- dramatic meaning;
- optional semantic timing hints.

### Timing Compiler
Owns:
- Speech Unit segmentation;
- semantic pace classification;
- timing lock class;
- authored semantic pauses;
- planned Production SRT start/end;
- TTS Manifest timing/speed intent.

### Voice Timing Profile
Provides the reusable empirical duration/safety model for one stable production voice.

Current canonical profile:
`profiles/voice/VOICE_TIMING_PROFILE_COSYVOICE_300M_V2_1.json`

### Director
Consumes the planned Production SRT.

Director may arrange visual beats inside the locked speech timeline, but may not invent speech duration or TTS speed.

### Runtime Timeline Resolver
After real TTS, owns:
- actual normalized durations;
- final absolute start/end timestamps;
- downstream cumulative shifts;
- ELASTIC slack rebalance;
- final subtitle timeline;
- final Visual Beat / Shot Timeline timestamps.

It may not change text, semantic pace, Visual Beat meaning/order, POV or HARD_ANCHOR meaning.

### Executor
Executes the locked TTS recipe and then runs the Runtime Timeline Resolver.

A profile drift is diagnostic by default. Use `RETURN_VOICE_TIMING_PROFILE_MISS` only when locked constraints cannot be reconciled automatically.

## 3. Timing units

### Speech Unit
Natural spoken/prosody unit, split by meaning, breath, setup/answer, reversal, punch or authored pause.

### Subtitle Cue
Readability unit derived from locked speech. Maximum two visible lines by default.

### Semantic Pause
Intentional authored silence/hold. It is not disposable TTS padding.

### Visual Beat
Visual meaning/state unit. It may be many-to-many with subtitle cues.

## 4. Dramatic timing kind → voice pace class

| dramatic timing kind | voice pace class |
|---|---|
| NORMAL | NORMAL |
| BUILD / BUILD_PATTERN | FAST_NORMAL |
| PUNCH_SETUP | NORMAL |
| PUNCH | FAST_CLEAR |
| REVERSAL | CONTROLLED |
| REACTION | SLOW_NORMAL or authored silent hold |
| FINAL | FINAL |

The mapping is semantic. Exact speed comes from the selected Voice Timing Profile.

## 5. Timing lock classes

### HARD_ANCHOR
Deliberate silence, setup/reveal gap, reversal hold, or explicitly protected timing anchor.

### SEMANTIC_RANGE
Pace matters; exact milliseconds may flex inside the profile-safe range.

### ELASTIC
Ordinary narration may donate/borrow small amounts of time during compile-time solving.

## 6. Planned Production-SRT compilation

For each Speech Unit:

1. classify dramatic timing kind;
2. map to voice pace class;
3. assign lock class;
4. collect profile features;
5. predict safe duration;
6. apply profile safety branches/floors;
7. add authored semantic pause;
8. solve local timeline;
9. emit cue start/end;
10. emit corresponding TTS Manifest row.

Then perform a **whole-script planned-timeline pass**:
- preserve order;
- preserve HARD_ANCHOR;
- prevent overlap;
- inspect cumulative pacing;
- keep local rhythm coherent;
- avoid drift from independently rounded cue durations.

Therefore:

> **逐段计算 duration，整篇统一编排 planned start/end，输出一个完整 planned Production SRT。**

## 7. Legacy/reference timing

Historical G4/Jingsui/reference-SRT timings may be imported only as **optional semantic priors** for legacy episodes.

They are not production timing authority.

For new episodes, Timing Compiler does not wait for G4 to create speech timing.

If a legacy reference conflicts with the Voice Timing Profile:
1. preserve semantic intent;
2. preserve HARD_ANCHOR where possible;
3. solve inside profile-safe pace;
4. borrow/donate from ELASTIC neighbors;
5. expand a local section only when necessary.

## 8. Runtime resolution

After real TTS:

```text
planned timeline
→ actual normalized durations
→ Runtime Timeline Resolver
→ FINAL_SUBTITLES.srt
→ FINAL_TIMELINE.json
→ FINAL_SHOT_TIMELINE.csv
```

Automatic resolution may:
- shift downstream timestamps;
- shrink/expand ELASTIC slack;
- extend valid visual holds;
- extend total episode duration.

It may not:
- rewrite speech;
- change pace class/speed;
- remove HARD_ANCHOR meaning;
- reorder Speech Units/Visual Beats;
- change POV/visual meaning.

The Owner should not have to return the real SRT for a second package compilation.

## 9. Voice-profile acceptance — canonical v2.1 model

Absolute error is diagnostic only.

Primary safety metric:

`required_extra_speed = max(1.0, actual_duration / allocated_window)`

- <= 1.03x → PASS
- >1.03x and <=1.05x → PASS_WITH_MINOR
- >1.05x → RETURN_PROFILE_MISS

Over-allocation:

`tail_slack = max(0, allocated_window - actual_duration)`

Guidance:
- PUNCH / FAST_CLEAR preferred <= 0.30s;
- NORMAL / FAST_NORMAL preferred <= 0.60s;
- CONTROLLED / FINAL preferred <= 0.70s;
- up to 0.90s may be PASS_WITH_MINOR for CONTROLLED / FINAL when semantic pacing remains acceptable;
- material excess returns for profile/compiler review.

Do not treat under-allocation and over-allocation as equivalent failure modes.

## 10. Canonical CosyVoice v2.1 safety branches

The generic Timing Compiler reads these from the profile rather than hard-coding them.

Current profile includes:
- short NORMAL floor: 1.4715s;
- mixed Latin + Arabic margin: 0.3178s;
- CONTROLLED safety floor: 5.0 CJK chars/s;
- FINAL safety floor: 5.5 CJK chars/s.

These are **profile parameters**, not universal Story Showrunner constants.

## 11. TTS Manifest

Each row must include at least:
- speech_unit_id;
- exact text;
- target start/end;
- dramatic timing kind;
- voice pace class;
- intended generation speed;
- Voice Profile ID;
- seed / deterministic settings;
- logical reference-audio/reference-text IDs;
- authored pause;
- allowed technical alignment tolerance.

Machine-specific absolute paths belong runtime configuration, not the canonical profile/Skill contract.

## 12. Executor policy

Executor may:
- load model once;
- cache speaker prompt once;
- generate locked Speech Units;
- normalize technical leading/trailing silence;
- perform bounded technical alignment;
- assemble final audio track.

Executor may NOT:
- rewrite text;
- choose new semantic pace;
- move authored pauses;
- redesign SRT;
- use major time-stretch to rescue a compiler/profile miss.

## 13. Recalibration triggers

Do not recalibrate for every episode.

Recalibrate/review only when:
- TTS engine/model materially changes;
- reference voice changes;
- speaking style changes;
- language changes;
- generation settings materially change;
- repeated production `RETURN_VOICE_TIMING_PROFILE_MISS` occurs.

## 14. Historical calibration evidence

V1 symmetric-error regression was rejected.

Targeted v2 repaired:
- short NORMAL unsafe under-allocation;
- mixed Latin + Arabic additive over-count.

v2.1 blind closeout validated CONTROLLED and FINAL safety floors.

Canonical result:
`VOICE_TIMING_PROFILE_COSYVOICE_300M_V2_1 = PASS_WITH_MINOR / FROZEN`

Detailed calibration artifacts remain historical evidence under:
`experiments/g6/voice-timing-calibration/`

## 15. Human intervention

Normal production requires no Owner approval of:
- final script;
- Production SRT;
- individual TTS lines;
- Director timing mapping.

Escalate only for an unresolved RETURN/BLOCKED state or explicit owner override.

## 16. Core principle

> **语义决定怎么说；Voice Timing Profile 负责提前规划安全时间；真实 TTS 决定最终绝对时间；Runtime Timeline Resolver 自动校准；Director 的语义/视觉决策不因普通时长偏差而重做。**
