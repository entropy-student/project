# SRT / Audio Timing Standard v0.4 — CANONICAL

## Status

`CANONICAL / TIMING COMPILER BEFORE DIRECTOR / VOICE PROFILE v2.1`

Date: 2026-09-22

## 1. Purpose

Production speech timing is solved **before Director work**.

```text
locked spoken script
→ Speech Units
→ semantic timing intent
→ Voice Timing Profile
→ Production SRT + TTS Manifest
→ Director
→ Assets
→ Production Package
→ Executor TTS
```

Real TTS is execution/QA, not a normal second creative timing pass.

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
- Production SRT start/end;
- TTS Manifest timing/speed intent.

### Voice Timing Profile
Provides the reusable empirical duration/safety model for one stable production voice.

Current canonical profile:
`profiles/voice/VOICE_TIMING_PROFILE_COSYVOICE_300M_V2_1.json`

### Director
Consumes Production SRT.

Director may arrange visual beats inside the locked speech timeline, but may not invent speech duration or TTS speed.

### Executor
Executes the locked TTS recipe.

Material mismatch:
`RETURN_VOICE_TIMING_PROFILE_MISS`

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

## 6. Production-SRT compilation

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

Then perform a **whole-script timeline pass**:
- preserve order;
- preserve HARD_ANCHOR;
- prevent overlap;
- inspect cumulative pacing;
- keep local rhythm coherent;
- avoid drift from independently rounded cue durations.

Therefore:

> **逐段计算 duration，整篇统一编排 start/end，输出一个完整 Production SRT。**

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

## 8. Voice-profile acceptance — canonical v2.1 model

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

## 9. Canonical CosyVoice v2.1 safety branches

The generic Timing Compiler reads these from the profile rather than hard-coding them.

Current profile includes:
- short NORMAL floor: 1.4715s;
- mixed Latin + Arabic margin: 0.3178s;
- CONTROLLED safety floor: 5.0 CJK chars/s;
- FINAL safety floor: 5.5 CJK chars/s.

These are **profile parameters**, not universal Story Showrunner constants.

## 10. TTS Manifest

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

## 11. Executor policy

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

## 12. Recalibration triggers

Do not recalibrate for every episode.

Recalibrate/review only when:
- TTS engine/model materially changes;
- reference voice changes;
- speaking style changes;
- language changes;
- generation settings materially change;
- repeated production `RETURN_VOICE_TIMING_PROFILE_MISS` occurs.

## 13. Historical calibration evidence

V1 symmetric-error regression was rejected.

Targeted v2 repaired:
- short NORMAL unsafe under-allocation;
- mixed Latin + Arabic additive over-count.

v2.1 blind closeout validated CONTROLLED and FINAL safety floors.

Canonical result:
`VOICE_TIMING_PROFILE_COSYVOICE_300M_V2_1 = PASS_WITH_MINOR / FROZEN`

Detailed calibration artifacts remain historical evidence under:
`experiments/g6/voice-timing-calibration/`

## 14. Human intervention

Normal production requires no Owner approval of:
- final script;
- Production SRT;
- individual TTS lines;
- Director timing mapping.

Escalate only for an unresolved RETURN/BLOCKED state or explicit owner override.

## 15. Core principle

> **语义决定怎么说；Voice Timing Profile 让 Timing Compiler 在生成真实音频前就分配安全时间；Director 只在这条已锁定时间轴上设计画面。**
