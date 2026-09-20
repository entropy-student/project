# AI Story Showrunner — REVIEWER HANDOFF

> Maintainer: Reviewer / Architect / Gatekeeper only  
> Governance baseline: `entropy-student/spike.skill/vps-project-governance` v0.1.6 + active addenda  
> Project-specific adaptation: `docs/GOVERNANCE_ADAPTATION.md`  
> Detailed evidence: `EXECUTION_EVIDENCE.md`

## 1. Current Authoritative State

```text
P0   PASS
G1   PASS
G2   PASS
G2.5 PASS
G3   PASS
G3R  PASS

G4   IN_PROGRESS
  G4A Semantic Director: Agent PASS_CANDIDATE
  G4B Exact Timeline Compiler: BLOCKED_BY_AUDIO_MASTER

G5   BLOCKED
```

Owner explicitly started G4.

## 2. Final Goal

```text
AI signal / concept
→ human problem
→ one locked mechanism
→ story
→ script / SRT
→ Semantic Director
→ exact timeline compiler
→ Character / Scene / Style locks
→ low-level execution package
→ Antigravity image generation + timeline assembly
→ video draft
→ QA / publish / learning
```

## 3. G3R Canonical Editorial Baseline

- Bilibili primary;
- DAILY editorial target;
- production throughput UNPROVEN;
- default 3–5 min;
- first-person recurring channel IP;
- STORY_MODEL / STORY_ACTION only;
- 5 / 2 initial weekly hypothesis;
- viewpoint can be story meaning but may not become author lecture;
- Narrative Style Contract v0.3;
- Writer Quality Contract v0.4.

## 4. Current Gate — G4

Canonical contract:
`docs/G4_DIRECTOR_COMPILER_CONTRACT.md`

### G4A — Semantic Director

Locks:
- shot boundary by visual state;
- narration span;
- story function;
- visual state;
- character IDs;
- scene ID;
- action/expression;
- composition/camera;
- image intent;
- continuity role;
- transition intent;
- forbidden visuals;
- acceptance criteria.

Does NOT lock final timestamps.

### G4B — Exact Timeline Compiler

Requires:
- final audio master;
- final SRT matching locked script;
- accepted G4A plan.

Outputs final rows conforming to:
- `schemas/shot.schema.json`;
- `docs/LOW_LEVEL_EXECUTION_PACKAGE.md`.

Exact timing follows audio only.

## 5. Why G4 Was Split

The existing final shot schema requires exact timecodes, but the accepted G3R long-form scripts do not yet have final audio.

Creating exact timecodes now would be fake precision.

Accepted rule:

> **Semantic shot decisions may be locked before audio; exact timestamps may not.**

If audio changes later:
`RETURN_TIMELINE_MISMATCH`
and rerun G4B only, unless visual semantics also changed.

## 6. First G4A Evidence — Agent

Source:
`episodes/20260920-agent/G3R_narrative_test_v2.md`

Plan:
`episodes/20260920-agent/G4A_semantic_shot_plan_v1.json`

Review:
`episodes/20260920-agent/G4A_semantic_shot_review_v1.md`

Result:
`PASS_CANDIDATE`

Counts:
- semantic shots: 36;
- expected images at one-shot/one-image: ~36;
- recurring characters: 2;
- primary scene IDs: 2.

Validated:
- cuts follow visual-state changes, not punctuation;
- story/reactions remain character-led;
- mechanism reveal does not become an architecture diagram;
- UI appears only when screen state is itself a story event;
- method examples remain actions rather than list slides;
- final viewpoint remains character/action-led.

Risks:
1. same-desk visual fatigue;
2. literalizing every joke/metaphor;
3. UI text density;
4. no exact timing until audio lock.

## 7. G4 Validation Sequence

1. Agent — event/action/reaction heavy — **PASS_CANDIDATE**
2. Context / Memory — metaphor/continuity heavy — NEXT
3. MCP — interoperability/repeated-friction — PENDING

Do not promote Director Compiler to canonical until cross-topic evidence exists.

## 8. Production Boundary

Still not started:
- G5 Character / Scene / Style lock;
- image generation;
- Antigravity execution;
- video assembly.

Antigravity remains:
`MANUAL_EXECUTOR / NOT_YET_POC_VALIDATED`

Audio mode remains:
`TBD`

## 9. Next Action

Continue **within G4 only**:

> Compile Context / Memory into a G4A semantic shot plan and compare with Agent.

No Owner action required yet.

## G4 Final Closeout — PASS / Owner Hold

G4 cross-topic validation is complete.

Final review:
- `docs/G4_VALIDATION_REVIEW.md`

Accepted timing basis:
- `JINGSUI_CALIBRATED_REFERENCE`
- ~5.9 Chinese chars/s
- visual beat median target ~2.7s
- final audio may later trigger timing-only realignment

Validated episodes:
- Agent: 36 semantic shots → 61 visual beats → 150.14s → PASS
- Context / Memory: 43 → 63 → 172.19s → PASS
- MCP: 44 → 63 → 166.38s → PASS

Machine checks:
- structural field errors: 0
- invalid roles/transitions: 0
- timing overlap/nonpositive duration errors: 0

Final G4 architecture:
```text
Locked Script / KnowledgeCore
→ G4A1 Semantic Director
→ G4A2 Visual Beat Compiler
→ G4B Jingsui-calibrated reference timing / SRT
→ Shotbook
```

Canonical G4 schemas:
- `schemas/semantic_shot.schema.json`
- `schemas/visual_beat.schema.json`

Important boundary:
G4 locks what each image-level beat must communicate.
Final image-generation prompts and canonical reference-asset paths remain downstream after Character / Scene / Style locking.

Current state:
```text
G4 = PASS
G5 = READY_NOT_STARTED
OWNER_HOLD_BEFORE_G5 = YES
```

Do not enter G5 until explicit Owner approval.

## G4 Director-Language Rebaseline Candidate — Owner Review

Owner identified a process-quality issue:

> G4 v0.1 used case-first discovery, then backfilled rules.  
> Before rerunning cases, establish a theory-first Director rule system.

New candidate artifacts:
- `docs/G4_DIRECTOR_LANGUAGE_RULES_CANDIDATE.md`
- `docs/G4_DIRECTOR_REBASELINE_RESEARCH.md`

Candidate source responsibilities:
- McKee → dramatic beat / action-reaction / meaningful state change
- Murch → cut priority
- Katz / Rabiger → staging / framing / POV / continuity / camera grammar
- Bruce Block → visual structure / intensity
- Jingsui → surface pacing calibration only

Proposed candidate pipeline:
```text
Locked Script
→ Dramatic Beat Map
→ Visual Intention Map
→ Semantic Shot
→ Visual Beat
→ Timing Calibration
```

Important:
- Existing G4 v0.1 remains PASS as historical MVP evidence.
- Candidate is NOT canonical yet.
- Agent / Context-Memory / MCP have NOT been rerun under the candidate.
- G5 remains READY_NOT_STARTED / BLOCKED by Owner review.

Current action:
Owner reviews candidate rules.  
Only after explicit approval should the three cases be rerun from scratch.

## G4 Director Rebaseline v0.3 — Final Candidate

Final rereview changed the proposed architecture from five to six layers.

Final candidate:
- `docs/G4_DIRECTOR_LANGUAGE_RULES_CANDIDATE_V03.md`
- `docs/G4_DIRECTOR_RULES_FINAL_REREVIEW_V03.md`

Proposed stable pipeline:
```text
Dramatic Hierarchy Map
→ Episode / Sequence Visual Strategy
→ Visual Intention Map
→ Semantic Shot Design
→ Visual Beat Compilation
→ Timing & Edit Calibration
```

Key corrections:
- McKee: Sequence → Scene → Beat, not Beat-only.
- Beat need not create a major value turn; Scene/Sequence carry larger turns.
- Jingsui timing is a small-sample surface prior, not a target/quota.
- 2.7s does not justify a cut.
- Explicitly support continuity + montage/contrast/metaphor image relations.
- New scripts should change episode configuration, not Director architecture.

Known unresolved cross-document conflicts after approval:
- Writer provisional SRT still contains 5.0 chars/s vs current ~5.9 calibrated prior.
- old 3–5 min duration guidance vs current G4 cases at ~2:30–2:52.

No canonical contract changed yet.
No case rerun started.
G5 remains blocked.

## G4 Owner Acceptance / G5 Start — 2026-09-21

Owner explicitly accepted G4 and authorized the next gate.

### G4 final state

```text
G4 = PASS
G4 Director Language v0.3 = CANONICAL
G5 owner hold = RELEASED
```

Canonical:
- `docs/G4_DIRECTOR_LANGUAGE_RULES.md`
- `docs/G4_DIRECTOR_COMPILER_CONTRACT.md`
- `schemas/semantic_shot.schema.json`
- `schemas/visual_beat.schema.json`

Validation evidence:
- Agent — PASS_CANDIDATE
- Context / Memory — PASS_CANDIDATE
- MCP — PASS_CANDIDATE
- unseen Search Answer — BLIND_PASS
- summary: `experiments/g4r-v03/VALIDATION_SUMMARY.md`

### Current Gate — G5

Name:
`Shotbook → Image Asset Package MVP`

Contract:
`docs/G5_IMAGE_ASSET_PACKAGE_CONTRACT.md`

Internal phases:
```text
G5A Asset Requirement Extraction
→ G5B Canonical Reference Lock
→ G5C Image Generation Compiler
```

First MVP:
`blind-search-answer`

G5A outputs:
- `experiments/g5/blind-search-answer/01_ASSET_MANIFEST.json`
- `experiments/g5/blind-search-answer/02_BEAT_ASSET_MATRIX.json`
- `experiments/g5/blind-search-answer/03_ASSET_INVENTORY.md`

G5A result:
`PASS`

Finding:
- 44 Visual Beats
- 8 reusable asset definitions
- `CHAR_IP_001 = MISSING_REAL_ASSET`
- 37/44 beats depend on the recurring IP reference
- project repo currently contains no real IP three-view file

Do not fabricate the missing character reference.

G5B may continue with scene / UI / prop / style specifications and canonical non-character assets.
Character-dependent generation remains blocked until the real IP reference is available.

Current:
```text
G5 = IN_PROGRESS
G5A = PASS
G5B = READY_IN_PROGRESS
G5C = NOT_STARTED
G6 = BLOCKED_BY_G5
```

## G5B Spec Lock — Blind Search Answer

G5B text/spec layer completed:

- `04_CHARACTER_BIBLE.md`
- `05_SCENE_BIBLE.md`
- `06_STYLE_BIBLE.md`
- `07_PROP_UI_BIBLE.md`
- `08_REFERENCE_MANIFEST.json`

Status:
```text
G5A = PASS
G5B = SPEC_LOCKED_BLOCKED_BY_REAL_IP_REFERENCE
G5C = READY_FOR_DRAFT_COMPILATION
```

Important:
- no image generation has started;
- no fake reference path was created;
- `CHAR_IP_001` remains the only real-input blocker currently identified;
- non-character canonical scene/UI/prop/style refs can be generated/approved in G5B;
- G5C may draft all image rows, but rows requiring IP cannot be marked execution-ready until the actual canonical three-view reference is available.

## G5C Compile — 44 Image Rows / Pilot Ready

Canonical docs aligned:
- `docs/PRODUCTION_VISUAL_STYLE.md`
- `docs/G5_IMAGE_ASSET_PACKAGE_CONTRACT.md`
- `docs/PIPELINE_AND_GATES.md` v0.2
- `docs/LOW_LEVEL_EXECUTION_PACKAGE.md` v0.2

G5C outputs:
- `experiments/g5/blind-search-answer/10_IMAGE_GENERATION_ROWS.json`
- `experiments/g5/blind-search-answer/11_IMAGE_GENERATION_PLAN.md`
- `experiments/g5/blind-search-answer/12_PILOT_BATCH.json`

Validation:
```text
Visual Beats = 44
Image Rows = 44
Beat order/ID mapping = PASS
Duplicate image IDs = 0
Duplicate output names = 0
Required prompt fields = PASS
Acceptance criteria = PASS
POST_OVERLAY rows = 33
Continuity-ref rows = 36
Structural issues = 0
```

High-risk Pilot:
- SRCH_VB001 — character + workdesk baseline
- SRCH_VB009 — character + cost-sheet causal prop
- SRCH_VB012 — official-page master
- SRCH_VB015 — setup must withhold reveal
- SRCH_VB016 — matched same-page reveal
- SRCH_VB022 — question/evidence semantic comparison
- SRCH_VB025 — temporary phonebook analogy world
- SRCH_VB044 — opening callback / final behavior change

Current:
```text
G5A = PASS
G5B = PASS_DIRECTION_LOCKED
G5C = PASS_CANDIDATE_PILOT_READY
Full 44-image batch = NOT_STARTED
Next = Generate + QA 8 pilot images
```

