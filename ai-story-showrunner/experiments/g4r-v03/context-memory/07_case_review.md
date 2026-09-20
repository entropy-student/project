# Context / Memory Case — G4R v0.3 Experimental Review

## Result
`PASS_CANDIDATE_WITH_RULE_REFINEMENTS`

This case supports the six-layer architecture.
It does not require a new layer.

## 1. Output

New v0.3 experiment:
- Dramatic Sequences: 6
- Semantic Shots: 44
- Visual Beats: 82
- Reference duration: ~212.64s / 3:33
- Average Visual Beat: ~2.59s
- P25 / Median / P75: ~1.77 / 2.33 / 3.26s
- Locked-script coverage: 100%

Historical v0.1:
- Semantic Shots: 43
- Visual Beats: 63
- Reference duration: ~172.19s / 2:52

Important:
Historical v0.1 semantic narration covered only ~931 Chinese characters, while the locked spoken script contains ~1093 Chinese characters.
Therefore the older duration estimate was materially biased low by script-coverage gaps.

## 2. What improved

### A. The episode has a global visual strategy

The story is no longer a series of locally plausible desk shots.
The whole episode follows two state machines:

Desk:
`NORMAL → BUSY → EXPANDED → FULL → OVERFLOW → ABSURDLY_EXPANDED → NEW_TASK_CLEAN → REASONABLE_WORK_SURFACE`

Notebook:
`ABSENT → INTRODUCED → SELECTIVELY_WRITTEN → PERSISTS → RETRIEVED_FROM → NOTE_RETURNS_TO_DESK`

This makes Context vs Memory visually legible before terminology appears.

### B. Same-world continuity is doing conceptual work

The new-task reversal does not use a random new room.
It uses the same room geometry with a clean active desk.

This lets the audience feel:
- the current work surface changed/reset;
- the world did not disappear;
- later, the notebook can persist independently.

### C. Full-vs-empty is stronger than extra camera variety

The major turning point is a matched spatial contrast:
`maximally expanded/cluttered work surface → same room, clean active desk`.

The new rules correctly prefer this story-state contrast over random shot-angle changes.

### D. Mechanism explanation reuses prior story evidence

Context explanation reuses:
- active desk;
- crowding;
- moving material;
- compaction.

Memory explanation reuses:
- selective notebook;
- persistence into new task;
- retrieval back onto active desk.

No Context/Memory box diagram is required.

## 3. Two important rule discoveries

### Finding 1 — Script Coverage must be a hard Gate

The first pass of this rerun exposed omitted spoken lines.
After audit, Semantic Shot narration spans and Visual Beat narration bindings both cover 100% of the locked script in order.

General rule added:
`RETURN_SCRIPT_COVERAGE_GAP`

Why it matters:
missing lines distort both visual design and duration estimates.

### Finding 2 — spoken enumeration is not automatically montage

The first v0.3 compilation produced 89 Visual Beats and felt over-segmented.

Redundant cuts were merged when multiple spoken items could coexist in one meaningful visual state:
- three opening preferences;
- the demand '我说过 / 你记住 / 别让我说第二遍';
- some desk-expansion wording;
- three notebook preference examples;
- the balanced 'larger desk is still useful' statement.

Final count: 82 Visual Beats.

General rule added:
`RETURN_MONTAGE_INFLATION`

Meaningful visual change, not verbal enumeration, determines image count.

## 4. Timing finding

Raw locked script length is about 1093 Chinese characters.
At the current 5.92 chars/s prior, raw speech alone is already about 185 seconds / 3:05.

Therefore a ~3:33 reference duration with reactions and reversals is plausible.

This is stronger evidence than the old ~2:52 estimate, because the new timeline covers the full spoken script.

Do not use this one case to create a universal 3:30 target.

## 5. Does the six-layer architecture survive?

Yes.

Context / Memory required different episode configuration from Agent:
- visual engine: EVOLVING_METAPHOR;
- dominant visual components: clutter + spatial scale;
- image relation: continuity / montage / contrast;
- continuity priority: same room geometry;
- motifs: active desk + persistent notebook.

But the architecture remained:
1. Dramatic Hierarchy
2. Visual Strategy
3. Visual Intention
4. Semantic Shot
5. Visual Beat
6. Timing & Edit.

No seventh layer is needed.

## 6. Representative decomposition

Narration:
> 直到第二周，我开了一个新任务。桌面干干净净。

Dramatic meaning:
The previous 'bigger desk = better memory' model is about to fail.

Visual Strategy:
CONTRAST inside the same room geometry.

Semantic Shot:
one major REVERSAL.

Visual Beats:
1. same room / new task begins;
2. hard reveal: current active desk is clean.

Why not a new location:
the conceptual difference is stronger when the world stays constant and only the active work surface changes.

## 7. Current recommendation

Keep the six-layer architecture.

Keep the two new refinements:
- 100% script-coverage Gate;
- anti-montage-inflation Gate.

Proceed to MCP only after Owner reviews this case.

Do not promote v0.3 to canonical yet.