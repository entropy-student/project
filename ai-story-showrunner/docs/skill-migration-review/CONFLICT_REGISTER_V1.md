# Story Showrunner Conflict Register v1

Date: 2026-09-22

Status: `R2_PASS / P0_P1_P2_RESOLVED / CANDIDATE_EXTRACTED`

## R1 resolution outcome

| Conflict | R1 result |
|---|---|
| C01 Audio mode | RESOLVED — `EXECUTOR_LOCKED_COSYVOICE` |
| C02 Timing ownership | RESOLVED — Timing Compiler before G4; G4 visual timing only |
| C03 Writer SRT Gate | RESOLVED — Writer locks text; Timing Compiler creates Production SRT |
| C04 Timing acceptance | RESOLVED — one-sided under-allocation safety + tail slack |
| C05 Voice Profile Spec | RESOLVED — v0.3 describes frozen-profile lifecycle |
| C06 G5 Pilot path | RESOLVED — calibration exception only |
| C07 G5 status | RESOLVED — PASS / canonical |
| C08 AI leakage in core | RESOLVED for P0 named fields — core uses causal mechanism/domain adapter |
| C09 migration lifecycle | RESOLVED — candidate now, canonical after E2E |

Additional cleanup completed:
- C18 timing-kind → voice-pace mapping is now explicit in Timing Standard v0.4.
- C19 REVIEWER_HANDOFF rewritten as current truth only.
- C20 CURRENT_STATUS normalized to schema v2.0.
- C21 README current execution focus updated.
- C22 Director human-readable output redefined as observability/debug, not Owner Gate.

Severity:
- P0 = must resolve before candidate migration
- P1 = resolve during migration
- P2 = cleanup/history issue; does not block extraction

## P0 conflicts — RESOLVED IN R1

### C01 — Audio mode has three incompatible truths

Evidence:
- `docs/PIPELINE_AND_GATES.md`: `AUDIO_MODE=A_UPSTREAM_COSYVOICE`
- `docs/WORKER_CONTRACTS.md`: `AUDIO_MODE=TBD`
- `docs/LOW_LEVEL_EXECUTION_PACKAGE.md` + `CURRENT_STATUS.json`: `EXECUTOR_LOCKED_COSYVOICE`

Decision:
`EXECUTOR_LOCKED_COSYVOICE` is canonical.

Repair:
update Pipeline + Worker Contracts before migration.

---

### C02 — Speech timing ownership is circular

Old/current mixed model:
- G4 still says it owns `timing_kind`, speech planning prior ~5.9 chars/s and reference durations;
- G4 contract says G6 later solves voice feasibility;
- current architecture says Production SRT is compiled from Voice Timing Profile BEFORE G4.

Decision:
- Writer/Timing Compiler owns Speech Units, semantic pace class, authored pauses and Production SRT.
- G4 owns visual rhythm and maps visuals onto the already-realistic Production SRT.
- G4 may adjust visual beat boundaries inside spoken windows, but may not invent speech duration.
- 5.9 chars/s survives only as historical validation evidence, not production timing authority.

Repair:
rewrite G4 timing section + Timing Standard + Visual Beat timing-source semantics.

---

### C03 — Writer SRT Gate is obsolete

`docs/WRITER_QUALITY_CONTRACT.md` still says:
- use 5.0 chars/s;
- cue 1.4–3.5s;
- after real TTS, realign again.

This directly contradicts frozen Voice Timing Profile v2.1.

Decision:
Writer outputs locked spoken script + semantic timing annotations.
Timing Compiler creates Production SRT.
No routine post-TTS creative realignment.

---

### C04 — Timing acceptance rules are stale across documents

`SRT_AUDIO_TIMING_STANDARD.md` still contains the old symmetric calibration target:
median AE <= 150ms / p90 <= 300ms.

v2/v2.1 changed the production objective to:
- unsafe under-allocation / required extra speed first;
- semantic tail slack second;
- absolute error diagnostic only.

Decision:
v2.1 one-sided safety model is canonical.

---

### C05 — Voice Profile Spec still describes a future v2

`VOICE_TIMING_PROFILE_SPEC.md` v0.2 says “A v2 profile should include...” while v2.1 is already frozen canonical.

Decision:
advance spec and describe current generic contract; calibration history remains evidence.

---

### C06 — G5 Pilot appears as a normal pipeline stage

`G5_IMAGE_ASSET_PACKAGE_CONTRACT.md` ends:
`→ G5 Pilot QA`.

Current owner decision:
manual/high-risk Pilot is calibration-only, not a recurring per-episode gate.

Decision:
normal G5 ends at executable package + automatic QA.
Pilot becomes an exception triggered by new model/style/character/executor/failure class.

---

### C07 — G5 contract status is stale

`G5_IMAGE_ASSET_PACKAGE_CONTRACT.md` says:
`G5 = IN_PROGRESS`.

Current project truth:
`G5 = PASS`.

Decision:
fix source status before migration.

---

### C08 — Generic core still leaks AI-specific semantics

Examples:
- `ARCHITECTURE.md` StoryPremise still says `AI mechanism as causal rule`;
- Pipeline TopicOpportunity still names `AI Mechanism`;
- Writer invariants still say `locked AI mechanism`.

Decision:
core uses `KnowledgeCore / CausalMechanism`.
AI wording moves to `adapters/domains/ai/`.

---

### C09 — Skill target migration rule is now too strict

`STORY_SHOWRUNNER_SKILL_TARGET.md` says “Do NOT migrate until end-to-end validation.”

Owner has now approved:
review + candidate extraction now, while final canonical promotion waits for E2E.

Decision:
two-stage lifecycle:
`CANDIDATE_EXTRACTION_NOW → CANONICAL_AFTER_E2E_PASS`.

## R2 P1 outcome

| Conflict | R2 result |
|---|---|
| C10 Writer/editorial split | RESOLVED |
| C11 Identity/profile split | RESOLVED |
| C12 Visual style profile | RESOLVED |
| C13 Provider adapter split | RESOLVED |
| C14 Local path externalization | RESOLVED |
| C15 Runtime state locator | RESOLVED |
| C16 Schema identity | RESOLVED |
| C17 Visual Beat timing source | RESOLVED |
| C18 Timing vocabulary map | RESOLVED |

Candidate:
`entropy-student/spike.skill/story-showrunner`

All migration conflicts are closed. Remaining work is E2E validation, not migration reconciliation.

## P1 conflicts / splits — RESOLVED IN R2

### C10 — Bilibili/Jingsui/first-person rules are mixed into core writer

These are channel/editorial profile choices, not universal Showrunner laws.

Decision:
generic Writer Contract in core;
Bilibili + Jingsui + first-person recurring IP + STORY_MODEL/ACTION in editorial profile.

---

### C11 — Visual identity contract mixes generic drift logic with CHAR_IP_001 specifics

Generic:
- reference precedence;
- no drift propagation;
- canonical identity always outranks previous generated frame;
- visibility-scoped QA.

Profile-specific:
- adult young male;
- wine-red top + cream collar;
- hair silhouette;
- black trousers / white shoes.

Decision:
split contract vs character profile.

---

### C12 — Production visual style is a profile, not core

`SIMPLIFIED_FLAT_NARRATIVE_COMIC` is the current Control.

Decision:
move to visual profile.
Frame Blueprint remains generic core.

---

### C13 — Executor contract is provider-locked

Low-Level package directly names:
- Antigravity;
- Nano Banana;
- CosyVoice.

Decision:
core defines executor permissions and package schema.
Provider implementation moves to:
- `adapters/executors/antigravity/`
- `adapters/image/nano-banana/`
- `adapters/tts/cosyvoice/`.

---

### C14 — Voice profile contains machine-specific paths

Frozen profile currently references `C:\Users\...`.

Decision:
Skill profile stores calibrated timing/model parameters + logical resource IDs.
Machine paths belong runtime config and must not be canonical Skill source.

---

### C15 — Live Calendar/Registry cannot be static Skill content

The Skill must auto-read today's Calendar, but calendar/registry/daily records change continuously.

Decision:
Skill contains a `TopicProvider / RuntimeStateLocator` contract.
Actual calendar/registry stay in runtime/project state.

---

### C16 — Schema identity still says AI Story Showrunner

`$id` / title values use `ai-story-showrunner`.

Decision:
rename to `story-showrunner` during migration, without changing validated field semantics unless required by timing repair.

---

### C17 — Visual Beat timing source needs new canonical meaning

Visual Beat schema requires exact start/end/duration, but old evidence was `JINGSUI_CALIBRATED_REFERENCE`.

Decision:
after migration:
- Production SRT exists before G4;
- Visual Beat exact time is derived from Production SRT/semantic pauses;
- `timing_source` should identify `PRODUCTION_SRT` / resolved timeline.

---

### C18 — Timing vocabulary has aliases without one mapping table

Observed terms:
- `PUNCH_SETUP`
- `PUNCH`
- `FAST_CLEAR`
- `REVERSAL`
- `CONTROLLED`
- `FINAL`
- `SLOW_NORMAL`.

Decision:
Skill must define:
`dramatic timing kind → voice pace class`
as one explicit mapping table.

## P2 source-of-truth / cleanup issues

### C19 — REVIEWER_HANDOFF violates its own “current truth” role

It contains many old current states:
- G4-only;
- G5 blocked;
- Audio TBD;
- A_UPSTREAM_COSYVOICE;
- timing calibration still next.

A top “LATEST OVERRIDE” prevents operational failure, but the file is too historical to remain a clean current truth.

Decision:
rewrite `REVIEWER_HANDOFF.md` to current state only.
Move chronology to `PROJECT_RECORD.md` / Evidence.

---

### C20 — CURRENT_STATUS contains stale nested fields

Examples include:
- `PASS_CANDIDATE_ON_AGENT` inside an overall PASS G4;
- old `g4_release=READY_BUT_OWNER_HOLD`;
- old `next_validation` references;
- historical source-recovery next-steps inside G5 after G5 PASS.

Decision:
normalize current machine state before using it as Skill migration input.

---

### C21 — README current execution focus is stale

README still says first G6 task is the 15–24 sentence timing calibration.

Current truth:
Voice Timing Profile v2.1 is frozen; next is Production SRT + TTS Manifest.

Decision:
update project README, but do not migrate project Gate status into Skill.

---

### C22 — “Human Review Output” naming can imply a recurring approval gate

G4's human-readable Shotboard is useful for debugging/audit, but normal production no longer requires Owner approval.

Decision:
keep a human-readable `DIRECTOR_SHOTBOARD` as observability output.
Rename semantics from approval gate to review/debug view.

## Migration blockers summary

P0 blockers:
`NONE`

P2 current-truth cleanup:
`COMPLETE`

Remaining migration blockers:
`NONE`

Candidate migration:
`PASS`

Canonical promotion blocker:
`END_TO_END_FINAL_VIDEO_VALIDATION`
