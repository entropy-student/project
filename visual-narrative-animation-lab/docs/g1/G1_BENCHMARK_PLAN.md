# G1 Benchmark Deconstruction Plan

## Goal
Extract a reusable visual-narrative grammar from representative videos by 是景岁啊. The goal is not to copy artwork or characters, but to understand how narration, visual beats, pose changes, camera moves, holds, props, text and SFX interact.

## G1A — Corpus + Analysis Schema — PASS

### Benchmark A — Recent / contrast-heavy comedy
- Title: 关于从低能量从高能量，只需要一年时间这件事
- BVID: BV1sKabz9E48
- Published: 2025-09-05
- Duration: 02:40
- Why selected: recent production grammar; explicit before/after contrast; strong visual metaphors; suitable for studying metaphor shots, reactions and contrast editing.

### Benchmark B — Social / internal-state comedy
- Title: 关于我觉得做i人太太太太太难了这件事
- BVID: BV1qu411J7rt
- Published: 2023-08-19
- Why selected: abstract/internal-state narration requires visualization rather than literal illustration.

### Benchmark C — Narrative / scene progression
- Title: 搬家，生活的凌迟
- BVID: BV1U84y177jQ
- Published: 2023-02-26
- Duration: 04:53
- Why selected: longer autobiographical narrative useful for studying continuity, repeated locations and emotional pacing.

## Analysis Unit: Visual Beat, not sentence

A Visual Beat is the smallest meaningful visual change that affects storytelling. Triggers include new composition, crop/zoom/pan, pose/expression change, props, entrances/exits, background change, text emphasis, metaphor insert, purposeful hold and SFX impact.

## Shot Table Contract

For every 20–40s segment record: `t_in/t_out`, spoken beat, visual state, beat type, asset change, camera, motion, transition, text/SFX, reuse, narrative job and evidence note.

## Quantities to Measure

1. visual beats per 10 seconds
2. full-new-art changes per 10 seconds
3. pose/expression-only changes per 10 seconds
4. camera-only changes per 10 seconds
5. percentage of beats achieved by reuse
6. average hold duration
7. 1→N and N→1 narration/visual mappings
8. punchline pattern: setup → hold → reaction/payoff

## Evidence status

Owner supplied the complete Benchmark A MP4. The full 159.38 s video was analyzed, yielding 62 detected shots and enough evidence for Visual Beat Grammar v0.1. Cross-video validation remains a later refinement before freezing the final Director spec.
