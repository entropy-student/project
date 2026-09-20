# Production Visual Style v0.1

## Status

`CANONICAL / G5B OWNER-APPROVED DIRECTION`

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
- youthful male narrator identity;
- dark, tousled short-hair silhouette;
- warm / rational / gentle baseline expression;
- wine-red top;
- cream/off-white collar;
- black trousers;
- simple white shoes.

Production simplification:
- hair reduced to stable major clumps rather than many individual strands;
- skin/render shading limited to 1–2 broad flat levels;
- only major clothing folds;
- clean stable outline;
- no decorative micro-detail added between beats.

Character Guide is a human reference.
Per-beat generation should attach only the minimum machine references required:
- canonical identity reference;
- relevant angle/pose reference;
- scene reference;
- style reference;
- causal prop/UI reference.

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
- attach canonical scene when recurring geometry matters;
- attach UI/prop master where causal;
- use previous accepted image only as continuity support, never as replacement for canonical identity;
- use exact output names;
- run beat fidelity / identity / scene / style QA before timeline assembly.

---

## 9. Long-Term Goal

The production visual system should optimize for:

> **角色稳定、场景稳定、叙事清楚、批量可复现。**

Single-image polish is subordinate to cross-video consistency and story readability.
