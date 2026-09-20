# Blind Search Answer — Scene Bible v0.1

## SCENE_WORKDESK_001 — Primary Work Desk

Status:
`SPEC_LOCKED / CANONICAL_IMAGE_TO_GENERATE`

## Story role

One stable workspace carries:
- the original query;
- AI answer/source trust;
- cost-sheet decision;
- source verification;
- evidence challenge;
- final callback.

The scene should feel like one real recurring room, not a new background every beat.

## Stable geometry

Lock:
- IP seat on the same side of the desk;
- monitor position;
- mouse/hand operating zone;
- cost-sheet working area;
- desk edge and primary screen axis;
- stable wall/background anchor.

Do not move the monitor to the opposite side between adjacent beats.

## Canonical camera anchors

### CAM_A — Observer medium
IP + desk + monitor relationship.

### CAM_B — Observer medium-close
IP reaction + partial screen/source cue.

### CAM_C — IP POV
Monitor/screen normal view.

These are anchors, not mandatory camera presets for every beat.

## State variants

- DESK_QUERY
- DESK_TRUSTED_ANSWER
- DESK_COST_SHEET
- DESK_INVESTIGATION
- DESK_EVIDENCE_CHALLENGE
- DESK_FINAL_CALLBACK

State changes should alter story objects, not room geometry.

## Lighting / time

Keep one neutral working-session lighting baseline unless the script explicitly changes time.

## Forbidden drift

- random new room;
- desk direction flips without intent;
- monitor moves sides;
- unrelated decorative props appear/disappear;
- dramatic lighting changes used only for emphasis.

Failure:
`RETURN_SCENE_DRIFT`

---

## SCENE_PHONEBOOK_ANALOGY_001 — Compact Analogy Scene

Status:
`SPEC_LOCKED / CANONICAL_IMAGE_TO_GENERATE`

Purpose:
briefly explain “correct record, wrong answer facet”.

Keep deliberately simple.

Required states:
1. question: 老板今天来不来？
2. correct boss contact record opened;
3. wrong-facet answer: 老板电话是 138…

Rules:
- maximum 2–3 image states;
- fictional contact data only;
- do not develop a second recurring world;
- exit immediately back to primary work desk.
