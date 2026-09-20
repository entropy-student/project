# G3R Overall Editorial Review — PASS_CANDIDATE

Date: 2026-09-20

## Scope

Re-review triggered by Owner clarification:
- Bilibili is primary platform;
- daily publishing is desired;
- channel should not become pure science/explainer;
- fixed channel IP will exist;
- future goal includes traffic, trust and monetization/acquisition.

## What remains valid

PASS and keep:
- Story-first translation;
- HOT + EVERGREEN topic system;
- one core mechanism by default;
- KnowledgeCore lock;
- McKee-style causality before voice styling;
- Jingsui as style layer, not global brain;
- Topic Registry / dedup;
- fixed cast + flexible world;
- Traffic / Trust / Conversion metrics separation;
- Antigravity as restricted executor.

## What was wrong / incomplete

### 1. Short-form duration leaked into channel strategy
70–85s was useful for G3 writer validation but is not appropriate as the Bilibili default.

Action:
- downgrade old scripts to short-form reference;
- establish 3–8 minute Bilibili bands.

### 2. Third-person validation stories underused the planned channel IP
Third person made the stories clear, but weaker as a recurring channel identity.

Action:
- first-person fictional/stylized IP becomes default POV;
- third/second person become routed tools rather than defaults.

### 3. “Story vs tutorial” was treated too much like a binary
Pure concept can lack practical payoff; mandatory tutorial can corrupt story and audience positioning.

Action:
- separate Business Job from Editorial Mode:
  - STORY_MODEL
  - STORY_ACTION
  - STORY_TUTORIAL.

### 4. Daily radar and daily publishing were conflated with production proof
Owner wants daily output, but the production chain has not yet proven one 4–6min episode/day.

Action:
- lock daily editorial target;
- leave throughput unproven until production gates.

### 5. Long-form story requirements were underspecified
A longer script cannot be created by padding explanation.

Action:
- Bilibili story contract must add escalating complications, false solution/misjudgment when useful, stronger turning point and repeated action-consequence cycles.

## External evidence used

- Bilibili official creator data center exposes average watch duration, retention curve, play-to-follow rate and audience/fan preferences.
- Bilibili official Q3 2025 investor materials describe mid-to-long-form as a platform hallmark and report ~20% YoY growth in watch time for videos over five minutes.
- Bilibili official materials identify AI as a fast-growing content category and creator-led storytelling as engagement/commercially relevant.
- Acquisition Growth Radar: early-stage focus should remain Audience / Situation + Message / Creative + Trust evidence, not premature offer optimization.

## Reviewer judgment

Architecture remains sound.

The main correction is editorial, not technical:

```text
FROM:
short-form storyized AI explainer

TO:
daily Bilibili story-driven AI knowledge channel
with recurring IP and optional actionable payoff
```

## Proposed canonical decisions

1. Primary platform = Bilibili.
2. Editorial target = daily publishing.
3. Default POV = first-person channel IP.
4. Default duration = 4–6 min, with 3–8 min routed bands.
5. Business job remains DISCOVERY / TRUST / SOLUTION.
6. Editorial modes = STORY_MODEL / STORY_ACTION only.
7. Season 0 = first 21 published episodes.
8. Initial weekly portfolio hypothesis = 5 model / 2 action.
9. Daily Radar remains active; calendar remains daily.
10. G4 remains blocked until Owner approves this rebaseline.

Status:
`G3R PASS_CANDIDATE / OWNER REVIEW`


## Owner refinement — tutorial mode removed

Owner explicitly removed tutorial as a channel module.

Updated candidate:
- STORY_MODEL
- STORY_ACTION

Initial weekly hypothesis:
- 5 STORY_MODEL
- 2 STORY_ACTION

Opinion is not a third mode. It is optional and must pass the bounded Viewpoint Gate.
