# Agent Case — G4R v0.3 Experimental Review

## Result
`PASS_CANDIDATE_WITH_SCHEMA_REFINEMENT`

This case supports the six-layer architecture.

It does NOT yet justify canonical promotion.

---

## 1. Output

New v0.3 experiment:
- Dramatic Sequences: 6
- Semantic Shots: 36
- Visual Beats: 67
- Reference duration: ~177.22s / 2:57
- Average Visual Beat: ~2.65s

Historical v0.1:
- Semantic Shots: 36
- Visual Beats: 61
- Reference duration: ~150.14s / 2:30
- Average Visual Beat: ~2.46s

The matching Semantic Shot count is coincidental.
The decision logic is materially different.

---

## 2. What improved

### A. Global visual system exists before shot design

v0.1:
shots were individually coherent but the whole episode relied heavily on one desk.

v0.3:
the same shop world is divided into three stable functional zones:
- IP desk;
- AI workstation;
- shared decision / handoff station.

This lets control move spatially through the episode without random location changes.

### B. Control ownership becomes a visual arc

The mouse motif now evolves:

```text
IP clicks everything
→ IP leaves mouse
→ AI executes
→ IP grabs mouse back
→ AI returns only mouse
→ final AI stops before control and hands decision back
```

This gives the episode a visual thesis independent of narration.

### C. Shot selection is motivated by audience need

Example — large refund:

Historical:
- over-shoulder;
- large amount visible;
- visual state changes from leisure to danger.

v0.3:
- PRIMARY intention = EXPERIENCE_REVERSAL;
- SECONDARY = SHARE_POV;
- prior eye position is the cafe/phone;
- large amount appears near the previous eye position;
- viewer attention is pulled back into work;
- IP posture snaps upright;
- intensity rises to HIGH.

The new design explains why this visual transition exists.

### D. Overcorrection is spatial, not explanatory

“All refunds ask me first” becomes a physical bottleneck between:
AI workstation → shared decision station.

When twenty approval windows appear, frame density rises sharply.

The later rule redesign physically clears the same space.

### E. Montage vs continuity is explicit

- repetitive refund work = MONTAGE;
- successful Agent workflow = CONTINUITY;
- all-approval overload = MONTAGE;
- low-risk pass vs high-risk stop = CONTRAST;
- final handoff = CONTINUITY.

This is more robust than treating every image as one continuous camera scene.

---

## 3. Timing finding

The v0.3 case lands near 2:57, closer to the script's own performance estimate.

Important:
This was not achieved by targeting 3 minutes.

It emerged from:
- more meaningful setup/reaction/punchline states;
- reaction and reversal holds;
- the same ~5.92 chars/s prior.

Therefore:
`2.68s average beat` is evidence, not a target.

---

## 4. Two rule/schema refinements discovered

### Finding 1 — exact shot size belongs at Visual Beat level

Current candidate asks Semantic Shot to lock `shot_size`.

But one Semantic Shot may compile into:
```text
POV insert
→ medium reaction
```
or:
```text
close reaction
→ two-shot confrontation
```

Therefore Semantic Shot should lock:
- framing strategy;
- allowed/expected shot-size progression;
- spatial/staging logic.

Each Visual Beat should lock the actual:
- shot size;
- POV;
- angle/composition delta.

This is a schema refinement, not an architecture change.

### Finding 2 — Visual Beat may need a local intention override

A Semantic Shot has a primary visual intention.

But its image-level beats can shift locally:
```text
Beat A: NOTICE_OBJECT
Beat B: READ_REACTION
```

Therefore Visual Beat should support:
- `local_visual_intention`

while still inheriting the Semantic Shot's main intention.

Again: schema refinement only.

---

## 5. Does the six-layer architecture survive the case?

Yes.

No new layer is needed.

Agent required only episode-specific configuration:
- ACTION_REACTION visual engine;
- shop-zone layout;
- mouse/control motif;
- frame-density intensity arc;
- continuity/montage/contrast routing.

The architecture itself did not need modification.

---

## 6. Current recommendation

Keep the six layers.

Before Context / Memory rerun, make only these two candidate refinements:
1. Semantic Shot: `shot_size` → `framing_strategy / shot_size_plan`
2. Visual Beat: lock actual shot size/POV and allow `local_visual_intention`

Do not change:
- McKee hierarchy;
- Visual Strategy layer;
- Visual Intention layer;
- Semantic Shot concept;
- Visual Beat concept;
- timing-last principle.

---

## 7. Representative decomposition

Narration:
> 昨天订单是我自己查。今天它什么都查完了。最后只把一样东西还给我——鼠标。

Dramatic meaning:
The human is no longer doing the work but remains the final bottleneck.

Visual Strategy:
CONTRAST + mouse/control motif.

Semantic Shot:
one PAYOFF event.

Visual Beats:
1. callback — IP used to own the whole workflow;
2. AI has now completed all upstream work;
3. setup — AI begins returning one object, but its identity is withheld;
4. reveal — 鼠标 becomes the sole focal object.

Why four:
the third image creates anticipation, while the fourth image owns the actual punchline reveal. Revealing the mouse in image 3 collapses setup and payoff into one state.

Timing:
the fourth mouse image receives the landing hold.

This is the intended use of the six-layer system.


## 8. Owner refinement accepted

Owner explicitly preferred four images for the mouse payoff.

This produces a useful general rule:

> **When a punchline depends on object identity, setup and reveal may deserve separate Visual Beats even inside one Semantic Shot.**

The setup image must withhold the final object clearly enough that the reveal still has value.
