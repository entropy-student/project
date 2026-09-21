# Blind Search — Runtime Timeline Resolver Rules v0.1

Date: 2026-09-22

Status:
`CANDIDATE / REQUIRED_FOR_ONE-DELIVERY_EXECUTION`

## Goal

Allow Antigravity to receive the episode once, generate real TTS, resolve the final absolute timeline locally, and continue to video production without returning real SRT to the Showrunner for recompilation.

## Planned inputs

- `timing/01_SPEECH_UNITS.json`
- `timing/02_PRODUCTION_SUBTITLES.srt`
- `timing/03_TTS_MANIFEST.json`

Current planned total:
`146.7209s`

This is a **planned timeline**, not the final millisecond authority.

## Runtime outputs

After real TTS, generate:

```text
timing/runtime/
├─ FINAL_SUBTITLES.srt
├─ FINAL_TIMELINE.json
├─ FINAL_SHOT_TIMELINE.csv
└─ TIMELINE_RESOLUTION_REPORT.json
```

## Runtime truth

Real normalized TTS duration is authoritative for speech length.

The resolver must not materially speed up or time-stretch speech merely to preserve planned absolute timestamps.

## Unit order

Speech Unit order is immutable.

There are:
- 44 total units;
- 43 voiced TTS units;
- 1 explicit silent reaction unit.

The explicit silent reaction remains a 1.4s HARD_ANCHOR.

## Per-unit resolution

For each voiced Speech Unit, in order:

1. take actual normalized TTS duration;
2. final_start = previous resolved window end;
3. final_speech_end = final_start + actual normalized duration;
4. preserve semantic/authored pause intent;
5. apply any allowed ELASTIC rebalance;
6. final_window_end = final_speech_end + final resolved pause;
7. next unit begins at final_window_end.

## Automatic repair ladder

### Level 1 — actual duration
Accept actual speech duration and shift downstream absolute timestamps.

### Level 2 — ELASTIC slack
ELASTIC pause may be reduced toward zero or expanded if needed.

Do not remove a HARD_ANCHOR.

### Level 3 — visual hold
If a visual state still semantically applies, extend its hold to cover the resolved window.

### Level 4 — total duration
Allow the final episode to become longer.

Do not force audio acceleration merely to retain the planned total of 146.7209s.

## Diagnostic profile drift

For every voiced unit calculate:

`required_extra_speed_if_forced_to_plan = actual_duration / planned_speech_duration`

If > 1.05:
record `VOICE_TIMING_PROFILE_DRIFT`.

This is diagnostic by default.

It becomes blocking only if runtime resolution cannot preserve a locked constraint.

## Blocking conditions

Return:
`RETURN_TIMELINE_RESOLUTION_INFEASIBLE`

only when one of these cannot be resolved automatically:
- Speech Unit order would need to change;
- text would need to change;
- pace class/speed would need a creative redesign;
- HARD_ANCHOR meaning would need to be removed;
- a locked external sync/max-duration constraint exists and cannot be met;
- a Visual Beat's meaning/POV would need to change;
- two non-elastic hard constraints conflict.

## Visual timing anchors

The current G4/G5 absolute timestamps are planning/debug evidence.

For downstream runtime mapping, each Visual Beat should anchor primarily to its corresponding Speech Unit:

```text
visual_beat_id ↔ speech_unit_id
start = speech_unit.final_start
end = speech_unit.final_window_end
```

If a future Beat spans a subset/superset of a Speech Unit, use explicit offset/anchor rules in the Production Package.

Do not require re-running Director merely because absolute milliseconds shift.

## Final subtitle generation

`FINAL_SUBTITLES.srt` must:
- preserve exact subtitle text;
- preserve unit order;
- use resolved absolute timestamps;
- contain no overlaps;
- reflect the explicit 1.4s silent reaction hold in timeline continuity.

## Final shot timeline

`FINAL_SHOT_TIMELINE.csv` must at minimum contain:

```text
visual_beat_id
speech_unit_id
final_start
final_end
timing_source=RESOLVED_RUNTIME_TIMELINE
delta_vs_planned_ms
repair_level_used
```

## One-delivery rule

Normal target:

```text
Showrunner package
→ Antigravity
→ real TTS
→ Runtime Timeline Resolver
→ final timeline
→ video runtime
→ final video
```

The Owner must not need to bring the real SRT back for a second package compilation.
