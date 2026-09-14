# G2 Manual Narrative MVP — Recipe

## Goal
Produce one original 30–45 s visual-narrative clip that validates the grammar before building automation.

## Baseline Constraints
- original content and original character
- 16:9 for the first test unless Owner later selects another priority
- 12–18 shots for 30–45 s
- target median shot duration: ~2.2 s
- default transition: hard cut
- default camera: hold
- no wipe reveal
- no requirement for Live2D
- no requirement for Remotion automation

## Required Visual Mix
The MVP must contain at least:
- 4 `CHARACTER_POSE` beats
- 2 `METAPHOR_GAG` beats
- 2 `NARRATIVE_TABLEAU` beats
- 1 `ICON_CARD` or `SUMMARY_BOARD`
- 1 deliberate reused composition
- 1 one-to-many narration mapping
- 1 many-to-one narration mapping

## Production Order
1. Lock 30–45 s voiceover/script.
2. Director pass: create visual beats only; no image generation yet.
3. Reviewer checks that each beat has a narrative job.
4. Resolve each beat to `REUSE / VARIANT / NEW_ART / EXTERNAL_INSERT`.
5. Generate only missing art.
6. Assemble on a simple timeline.
7. Add original subtitle treatment and sparse SFX.
8. Export MP4.
9. Review whether the picture adds meaning beyond the words, shot changes follow meaning rather than punctuation, metaphors become visual gags, reuse works in context, and motion/transition has a narrative reason.

## G2 PASS Criteria
- 30–45 s finished MP4
- >= 12 meaningful visual beats
- no sentence-to-image mechanical pattern
- at least one successful 1→N and N→1 mapping
- visual changes average roughly every 1.5–3.5 s without feeling forced
- Owner judges the result materially closer to the target than rigid story-to-image generation
- record manual time, new assets, reused assets and revision count

## First Implementation Recommendation
Optimize **Director quality**, not animation technology.

Recommended stack:

`script/voiceover → SHOTBOOK → AI still art / reusable character poses → simple hard-cut edit → MP4`

Remotion is deferred until the visual grammar survives a manual edit.
