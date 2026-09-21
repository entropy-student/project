# Blind Search Answer — Frame Blueprint v0.4 Recompile Review

Status: `FAIL`

## Counts
- Visual Beats: 44
- Frame Blueprints: 44
- Execution Rows: 44
- Validation issues: 1

## Execution modes
- GENERATE: 14
- DERIVE_EDIT: 26
- COMPOSITE_CROP: 4

## Structural changes vs historical G5C v0.1
- Frame Blueprint now precedes Beat asset binding.
- Brand defaults to NONE.
- Exact UI text uses POST_OVERLAY.
- Setup/Reveal carries explicit withheld information.
- DUAL_COMPARE prefers source crops.
- Continuity-critical states can use DERIVE_EDIT.
- Evidence comparison can use COMPOSITE_CROP.
- Non-adjacent callback uses composition_callback_ref.

## High-risk verified beats
- VB001 — clean character reaction
- VB009 — causal cost-sheet action
- VB012 — policy-page context
- VB015 — neutral withhold
- VB016 — matched reveal
- VB022 — source-crop dual compare
- VB025 — analogy payoff
- VB044 — opening/ending callback

## Historical files
`10_IMAGE_GENERATION_ROWS.json`, `11_IMAGE_GENERATION_PLAN.md`, and `12_PILOT_BATCH.json` are preserved but SUPERSEDED.

## Next
Run the 8-beat Pilot from the new Blueprint/Execution package. Do not use historical v0.1 rows.