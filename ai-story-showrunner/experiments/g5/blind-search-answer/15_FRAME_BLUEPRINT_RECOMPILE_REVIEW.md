# Blind Search Answer — Frame Blueprint v0.4 Recompile Review

Status: `PASS_CANDIDATE_AFTER_POV_EXECUTION_PATCH`

## Counts
- Visual Beats: 44
- Frame Blueprints: 44
- Execution Rows: 44
- Validation issues: 0

## Execution modes
- GENERATE: 15
- DERIVE_EDIT: 25
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

## POV execution compatibility patch — VB009
- POV audit changed VB009 from external OBSERVER to `IP_POV_HANDS`.
- VB008 remains an OBSERVER / MEDIUM_CLOSE reaction shot, so it cannot be a deterministic DERIVE_EDIT source for VB009.
- VB009 is therefore reclassified to `GENERATE`.
- `continuity_ref = SRCH_VB008` remains semantic/world continuity only; it is not a source-frame lock.
- Identity QA is visibility-scoped: hand + wine-red/cream cuff only; off-frame face/body checks are not required.

## Next
Generate and QA `SRCH_VB009` as a fresh downward first-person hand-action insert. If PASS, continue `SRCH_VB012`. Do not use historical v0.1 rows.

## Validation fix

Machine Gate initially caught:
`SRCH_VB043 setup missing withheld information`.

Fixed:
VB043 now explicitly withholds the final callback:
“它真的找对了网页”.

Final structural validation:
`PASS / 0 issues`.

