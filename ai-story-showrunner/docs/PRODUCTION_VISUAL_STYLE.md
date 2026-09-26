# Production Visual Style v0.2

## Status

`CANONICAL CONTROL / G5B OWNER-APPROVED / G5B.5 ACQUISITION REVIEWED`

This document defines the reusable production visual baseline for AI Story Showrunner.

Episode-specific Bibles may specialize it, but may not silently contradict it.

---

## 1. Production Style

Canonical direction:

> **扁平简化漫画风 / Simplified Flat Narrative Comic**

Purpose:
- preserve a recognizable recurring IP;
- reduce character/style drift across dozens of generated stills;
- remain expressive enough for story acting;
- integrate naturally with workspaces, props, documents and UI;
- support limited-animation / still-image video production.

This is NOT:
- high-detail standalone anime illustration;
- stick figure;
- chibi / Q-style mascot;
- PPT / infographic style;
- neon cyber-AI aesthetic.

---

## 2. Character Identity Baseline

Current recurring IP:

`CHAR_IP_001`

Identity source:
Owner-approved IP image supplied in conversation.

Preserve:
- clearly adult young-male narrator identity;
- dark, tousled short-hair silhouette;
- warm / rational / gentle baseline expression;
- wine-red top;
- cream/off-white collar;
- black trousers;
- simple white shoes.

Production simplification:
- hair micro-strands reduced to stable major clumps while preserving canonical silhouette/fringe;
- skin/render shading limited to 1–2 broad flat levels;
- only major clothing folds; canonical costume geometry remains unchanged;
- clean stable outline;
- no decorative micro-detail added between beats.

Canonical character policy:
`docs/CHARACTER_IDENTITY_LOCK.md`

Character simplification boundary:
render complexity may decrease; identity anatomy may not.

Never simplify:
- adult maturity;
- face outline / jaw / chin;
- eye scale;
- nose structure;
- adult body proportion;
- costume identity;
- major hair silhouette.

Per-beat generation should attach:
- canonical identity reference whenever the recurring IP appears;
- approved angle/pose reference when useful;
- scene reference;
- style reference;
- causal prop/UI reference.

Previous generated frames are secondary continuity references only; they never replace canonical identity.

---

## 3. Scene Baseline

Recurring scenes must be designed as stable story worlds, not regenerated backgrounds.

For every recurring Scene ID lock:
- room geometry;
- major furniture positions;
- screen axis;
- stable camera anchors;
- lighting baseline;
- recurring props;
- allowed state variants;
- prohibited geometry drift.

Primary current scene:
`SCENE_WORKDESK_001`

Validated visual roles:
- character + workdesk;
- character + UI/evidence;
- pure evidence insert.

Background rule:
> only keep decorative objects that help place, orient or characterize the story world.

Reduce arbitrary books, plants, ornaments and lighting changes if they increase drift without narrative value.

---

## 4. UI / Document Baseline

UI must exist inside the story world.

Do not turn the episode into a tutorial screenshot sequence.

Use UI/document close-ups only when exact state or wording is causal.

For exact critical text:
`TEXT_RENDER_MODE = POST_OVERLAY` by default.

Reason:
image-generation text fidelity should not control story correctness.

A stable UI/document master should lock:
- layout;
- text regions;
- state variants;
- geometry;
- fictional branding treatment.

Do not generate a new random webpage/interface for every beat.

---

## 5. Composition Philosophy

A frame should read as:

> one clear story moment in a recurring world.

Priority:
1. story action / reaction;
2. subject hierarchy;
3. spatial relation;
4. causal prop/UI state;
5. style decoration.

No camera variation only for visual novelty.

G4 decides:
- visual intention;
- shot size;
- POV;
- image relation;
- beat state.

G5 must faithfully implement those choices.

---

## 6. Production Simplification Guard

Mandatory for batch generation:

- fewer stable hair clumps;
- 1–2 flat shadow levels;
- restrained clothing folds;
- simplified background geometry;
- stable recurring props;
- no unnecessary texture/noise;
- no random decorative objects;
- no poster-like background graphics unless the story explicitly requires them.

Calibration frames may be richer than final batch images.
They are composition/integration references, not authorization for extra micro-detail.

Failure:
`RETURN_STYLE_DRIFT`

---

## 7. Current Calibration Evidence

The Search Answer MVP validated three frame categories:

### A. Character + Workdesk
PASS.

### B. Character + UI / Evidence Conflict
PASS.

### C. Pure Evidence Insert
PASS.

Evidence record:
`experiments/g5/blind-search-answer/09_CALIBRATION_REVIEW.md`

Therefore:
- `STYLE_CHANNEL_001 = VISUAL_DIRECTION_LOCKED`
- `SCENE_WORKDESK_001 = GEOMETRY_DIRECTION_LOCKED`
- `UI_POLICY_PAGE_001 = LAYOUT_DIRECTION_LOCKED`
- `CHAR_IP_001 = IDENTITY_DIRECTION_LOCKED`

Reference binaries currently available through the active conversation are not yet persisted as repository binaries.

---

## 8. Batch Generation Rule

Default:
`1 Visual Beat ≈ 1 generated still`.

For every beat:
- attach canonical identity where character appears;
- enforce `docs/CHARACTER_IDENTITY_LOCK.md`;
- attach canonical scene when recurring geometry matters;
- attach UI/prop master where causal;
- use previous accepted image only as continuity support, never as replacement for canonical identity;
- reject and break the derivation chain if the source frame already shows maturity/face/costume drift;
- use exact output names;
- run beat fidelity / identity / scene / style QA before timeline assembly.

---

## 9. Long-Term Goal

The production visual system should optimize for:

> **角色稳定、场景稳定、叙事清楚、批量可复现。**

Single-image polish is subordinate to cross-video consistency and story readability.


---

## 10. Acquisition Review Decision

Canonical review:
`docs/VISUAL_ACQUISITION_REVIEW_GATE.md`

Decision:
`KEEP + ITERATE`

The current style remains the Production Control.

Adjustment:
- reduce per-frame micro-detail / decoration by approximately 15–25% relative to current calibration images;
- protect focal hierarchy and fast readability;
- do not switch the channel to pure stick figures.

Challenger:
`ULTRA_SIMPLE_NARRATIVE_LINE_CARTOON`

The Challenger retains the recurring IP silhouette and identity cues but uses substantially simpler facial/environment rendering.

Long-term style SCALE requires real audience + repeatability evidence.


---

## 11. Character Drift Guard

Observed Pilot failure proved that "simplified comic style" can be misread as juvenile/cute character redesign.

Therefore:

> **Simplified rendering != simplified anatomy.**

Hard failures:
- teen/child appearance;
- oversized eyes;
- shorter/rounder juvenile jaw;
- weakened nose structure;
- oversized head / shortened adult body;
- blush/cute reinterpretation;
- wine-red collared top replaced by hoodie or other costume.

Any such frame is rejected before it may become a continuity source.

## 2026-09-26 episode identity and production-style note

The old dark-hair/wine-red costume descriptions above remain historical project calibration for V1. For `ep-agent-permission-boundary-20260926`, the Owner's original `CHAR_IP_001 V2` four-view in its handoff package overrides those V1 appearance details. Identity and rendering style are separate: the V2 sheet locks the person; the episode Style Bible locks a consistent restrained paper-line treatment across person, phone, UI and props. Apply `STORY_EVENT_FRAME_PRODUCTION_PATCH_20260926.md` before accepting any new story frame.
