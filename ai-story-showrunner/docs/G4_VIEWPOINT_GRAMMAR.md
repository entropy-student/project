# G4 Viewpoint Grammar v0.1 — CANONICAL

## Status

`CANONICAL / G4 POV PATCH / OWNER APPROVED`

Purpose:
choose camera/viewpoint from the dramatic job instead of defaulting to OBSERVER.

Core question:

> **这一刻，观众应该“看主人公”，还是“和主人公一起看”？**

POV is selected AFTER dramatic meaning / visual intention and BEFORE final Frame Blueprint.

---

## 1. Viewpoint modes

### OBSERVER

Audience watches the protagonist from outside.

Use when the Beat depends on:
- facial reaction;
- body language;
- hesitation;
- relationship/blocking;
- behavior change visible from outside;
- callback composition where the character's changed behavior is the payoff.

Typical:
`READ_REACTION / FEEL_RELATION / character-led FOLLOW_ACTION`

Do not use merely because the protagonist exists in the scene.

---

### IP_POV

Camera approximates what the recurring IP sees.

Use when the Beat depends on:
- reading;
- discovering evidence;
- inspecting exact wording;
- comparing two information states;
- entering a page/interface from the protagonist's experience.

Typical:
`NOTICE_OBJECT / EXPERIENCE_REVERSAL / POV_DISCOVERY`

The protagonist's face is normally absent.

---

### IP_POV_HANDS

First-person / near-first-person task view with the protagonist's hands/body cues visible.

Use when:
- the protagonist personally writes, selects, moves, signs, drags, pays, or manipulates a causal object;
- the hand action itself creates the story consequence;
- audience should experience “I did this”, not merely observe “he did this”.

Identity cues may include:
- canonical sleeve/cuff;
- hand;
- desk geometry.

Example:
`我在成本表里写下“服务费：可退”`.

---

### OVER_SHOULDER_IP

Near-subjective over-shoulder view.

Use when both are important:
- protagonist ownership of the action;
- readable target/interface/object.

Useful bridge:
`OBSERVER → OVER_SHOULDER_IP → IP_POV`

Typical:
click/open/inspect actions that lead into a subjective discovery.

---

### OBJECTIVE_INSERT

Character-neutral close view of a causal object/state.

Use when:
- exact object/UI state is the story;
- character reaction is not needed;
- viewer needs the evidence clearly, but it does not need to pretend to be literal eye POV.

Typical:
document line, conclusion, quote, prop state.

This is NOT a PPT card.
It must remain a story-world object/source.

---

### RELATIONAL_OBSERVER

External view optimized for two-subject relation.

Use for:
- dialogue/analogy;
- person-person relation;
- character vs object relation when spatial relation itself is the story.

---

### HYBRID_OBSERVER_POV

Semantic-shot strategy that intentionally alternates:
- external human state;
- subjective/object inserts.

Do not use as a lazy unspecified mode.
Child Visual Beats must still choose their actual mode.

---

## 2. Decision tree

For each Visual Beat:

### Q1
Is the character's reaction/body relation the meaning?

YES → `OBSERVER / RELATIONAL_OBSERVER`

### Q2
Must the viewer discover/read exactly what the IP sees?

YES → `IP_POV`

### Q3
Is the protagonist's own hand action the causal event?

YES → `IP_POV_HANDS`

### Q4
Do we need both protagonist ownership and a readable target?

YES → `OVER_SHOULDER_IP`

### Q5
Is the object/evidence itself causal, with no need for character subjectivity?

YES → `OBJECTIVE_INSERT`

If none apply:
choose the mode that best serves Emotion → Story → Rhythm → Eye-trace, and record the reason.

---

## 3. POV must have a reason

Every new Visual Beat should include:

`pov_reason`

Bad:
> OBSERVER because this is a desk scene.

Good:
> OBSERVER because the audience must read the character's hesitation.

Good:
> IP_POV_HANDS because the story consequence is created by the protagonist personally writing the assumption into the cost sheet.

Failure:
`RETURN_POV_UNMOTIVATED`

---

## 4. First-person narration does NOT mean all shots are first-person

Channel narration may be first person while visual viewpoint alternates.

Use:
- OBSERVER to see the narrator react;
- IP_POV to share discovery;
- IP_POV_HANDS to inhabit an action;
- OBJECTIVE_INSERT to isolate proof.

The alternation should follow dramatic function, not stylistic variety.

---

## 5. Reaction ↔ discovery grammar

A common investigation pattern:

```text
OBSERVER
see the human reaction
↓
OVER_SHOULDER_IP / IP_POV
enter what they inspect
↓
OBJECTIVE_INSERT / IP_POV
land exact evidence
↓
OBSERVER
return to reaction / changed behavior
```

This creates subjectivity without trapping the entire episode in literal first-person camera.

---

## 6. Hand-action rule

When narration uses:
- 我写下
- 我点开
- 我勾选
- 我拖动
- 我把……放进
- 我支付
- 我确认

ask:

> Is ownership of this action part of the consequence?

If YES:
default to `IP_POV_HANDS` or `OVER_SHOULDER_IP`.

Do not default to a third-party medium shot.

---

## 7. Evidence rule

Exact evidence can use:

### IP_POV
when discovery is the dramatic experience.

### OBJECTIVE_INSERT
when proof/state itself is the dramatic unit.

Difference:

`IP_POV = 我发现了它`

`OBJECTIVE_INSERT = 它本身需要被看清`

---

## 8. POV continuity

POV changes require a reason.

Allowed motivations:
- reaction → object;
- action → result;
- setup → discovery;
- evidence → reaction;
- relation → subjective detail.

Do not switch POV merely for visual variety.

Failure:
`RETURN_POV_SWITCH_UNMOTIVATED`

---

## 9. Still-image constraint

Because production uses still-image beats:

- a POV change may itself justify a new Visual Beat only if information/experience changes;
- do not create extra images merely to simulate a camera move;
- OVER_SHOULDER is useful when one frame must preserve actor ownership + target readability.

---

## 10. Search Answer POV audit result

44-Beat audit found the architecture sound, but a small subset had observer-default bias.

Required corrections:
- VB004 → IP_POV
- VB009 → IP_POV_HANDS
- VB011 → OVER_SHOULDER_IP
- VB027 → IP_POV
- VB031 → OBJECTIVE_INSERT
- VB036 → OBJECTIVE_INSERT
- VB037 → OBJECTIVE_INSERT
- VB042 → IP_POV

All other Beat POVs remain unchanged.

This is a bounded POV patch, not a G4 architecture rewrite.

## 2026-09-26 physical-viewpoint production gate

The mode name alone does not establish a valid camera. Apply the screen-facing, character-gaze and camera-position check in `STORY_EVENT_FRAME_PRODUCTION_PATCH_20260926.md` to every new story-video package. Return any frame in which a visible character is said to read a screen that actually faces only the viewer.
