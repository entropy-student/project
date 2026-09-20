# Context / Memory G4A2 Visual Beat Density Review v1

## Result
`PASS_CANDIDATE`

- semantic shots: 43
- visual beats: 63
- provisional duration: 2:52 (172.19s)
- average visual beat: 2.73s

## Timing fit

The average visual beat lands almost exactly on the calibrated Jingsui median (~2.7s).

Most long semantic shots split only when the metaphor/action state changes:
- repeated requirements → character reaction;
- files accumulating → desk saturation;
- old material displaced → wrong diagnosis;
- empty new task → missing preference;
- notebook persistence → later retrieval.

## Important finding

Metaphor-driven narration needs **more continuity discipline than more visual novelty**.
The desk must evolve as one spatial object across many states rather than becoming a different random desk every image.

## Risk

If image generation treats every beat independently, the desk-size progression will drift and destroy the metaphor.

Therefore G5 must define explicit scene-state variants for:
`DESK_NORMAL → DESK_EXPANDED → DESK_FULL → DESK_FLOOR_OVERFLOW → NEW_TASK_EMPTY → NOTEBOOK_PERSISTENT`.

## Gate
`CONTEXT_MEMORY_G4A2 = PASS_CANDIDATE`