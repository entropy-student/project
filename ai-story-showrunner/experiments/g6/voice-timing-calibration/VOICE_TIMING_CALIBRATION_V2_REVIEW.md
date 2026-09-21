# Voice Timing Calibration v2 — Reviewer Result

Date: 2026-09-21

Status: `PASS_WITH_MINOR_TARGETED / NOT_YET_CANONICAL`

## Frozen targeted parameters

- `short_normal_floor_sec = 1.4715`
- `mixed_margin_sec = 0.3178`

## Held-out

| id | branch | allocated | actual | required extra speed | tail slack | result |
|---|---|---:|---:|---:|---:|---|
| V2B001 | short_normal | 1.4715s | 0.8061s | 1.0000x | 0.6654s | PASS_WITH_MINOR |
| V2B002 | mixed_latin_arabic | 3.1309s | 2.6793s | 1.0000x | 0.4516s | PASS |
| V2B003 | unchanged_v1 | 3.4885s | 3.5324s | 1.0126x | 0 | PASS |

Targeted result:
`PASS_WITH_MINOR`

The two targeted failure classes from v1 are considered repaired sufficiently for continued validation:
1. short NORMAL unsafe under-allocation;
2. additive Latin + Arabic over-count.

## Blocking control finding

V2C003:

- semantic class: FINAL
- intended speed: 0.96x
- v1 predicted: 2.6114s
- actual normalized: 3.2824s
- actual/predicted = 1.257x

Flag:
`SEMANTIC_SPEED_MAP_REVIEW_REQUIRED`

Reviewer interpretation:
this is not enough evidence to blame the 0.96 speed itself. The stronger finding is that the base point predictor can under-allocate a medium/long semantic landing sentence that has few explicit punctuation features.

Therefore the full Voice Timing Profile must NOT be frozen yet.

## Final micro-closeout design

Use conservative semantic-duration floors as a backstop:

### CONTROLLED floor candidate

Evidence:
- CAL009 plain CONTROLLED: 22 CJK / 4.2408s ≈ 5.188 CJK/s at 1.0x.

Candidate safe rate:
`CONTROLLED_SAFE_CPS = 5.0`

### FINAL floor candidate

Base-speed-equivalent evidence:
- CAL010: ≈ 6.47 CJK/s
- BLD004: ≈ 6.13 CJK/s
- V2C003: ≈ 5.71 CJK/s

Candidate safe rate:
`FINAL_SAFE_CPS = 5.5`

For these classes:

`semantic_floor_duration = cjk_char_count / SAFE_CPS / intended_speed`

Final allocation candidate:

`allocated = max(v2_prediction, semantic_floor_duration)`

This floor is a safety backstop, not the primary predictor.

## Next

Run exactly two new blind samples:
- one CONTROLLED;
- one FINAL.

If neither requires >1.05x extra speed and neither creates excessive semantic tail slack, freeze Voice Timing Profile v2.1 and proceed directly to Production SRT.
