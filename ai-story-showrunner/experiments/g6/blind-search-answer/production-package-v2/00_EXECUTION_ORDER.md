# G6R Package v2 — Execution Order

## Precondition

Use only after the project + `story-showrunner` G6R reconciliation changes are merged.

## Stage

This package releases the first-E2E **Asset Calibration Gate**, not final render.

```text
preflight current Candidate contracts
→ real production TTS
→ runtime timeline resolver
→ FINAL_* timing artifacts
→ 44 production frames
→ asset mechanical QA
→ STOP_AT_REVIEWER
```

Do not final-render during this gate.

## Timing source

Use:
- `05_VISUAL_BEATS.json` for Candidate-compliant visual semantics + durable anchors;
- actual normalized TTS durations as runtime clock truth;
- `story-showrunner/runtime/timeline_resolver.py` or a proven-equivalent implementation.

Do not use legacy `JINGSUI_PRIOR_ESTIMATE` absolute timestamps as production authority.

## Preserve

- locked script;
- Speech Unit order;
- authored pauses;
- 44 Visual Beat meaning/order/POV;
- G5 Frame Blueprint intent;
- character identity/style contracts.

## Return

Success:
`PASS_CANDIDATE_G6A_ASSET_CALIBRATION`

Failure:
return the smallest exact timing/asset/provider RETURN code.

Always stop at Reviewer after the Asset Gate.
