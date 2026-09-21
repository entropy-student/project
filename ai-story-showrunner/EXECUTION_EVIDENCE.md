# AI Story Showrunner — EXECUTION EVIDENCE

> Append-only evidence record.  
> Reviewer truth: `REVIEWER_HANDOFF.md`  
> 本文件不记录 Secret，也不把计划当事实。

---

## Gate: P0-GOVERNANCE-RECONCILIATION

- Date: 2026-09-20
- Purpose: 将已经建立的 AI Story Showrunner 项目重新对齐 canonical Governance，并通过 fresh authoritative read-back 核验当前仓库事实。
- Historical note: 项目最初 README / PROJECT_RECORD / docs 写入发生在正式 `REVIEWER_HANDOFF.md` 建立之前。本轮不伪造历史 Executor 证据，而是对当前事实重新核验。

### Preflight Evidence

Canonical Governance read:

- Repository: `entropy-student/spike.skill`
- Path: `vps-project-governance/SKILL.md`
- Core baseline: v0.1.6
- Governance Handoff reviewed: YES
- Relevant conclusion: Owner / Reviewer / Executor、Gate、Evidence、PASS/RETURN、唯一 Reviewer Handoff 均应保留；VPS-only addenda 可在当前非部署阶段标 N/A。

Project authoritative read-back reviewed:

- `ai-story-showrunner/README.md`
- `ai-story-showrunner/PROJECT_RECORD.md`
- `ai-story-showrunner/docs/ARCHITECTURE.md`
- `ai-story-showrunner/docs/PIPELINE_AND_GATES.md`
- `ai-story-showrunner/docs/WORKER_CONTRACTS.md`
- `ai-story-showrunner/docs/TOOL_INVENTORY.md`

### Findings Before Reconciliation

PASS-like strengths:

- 已有明确 Gate；
- 已有 nearest-gate rollback；
- 已区分 Showrunner / Worker；
- 已记录 UNKNOWN；
- 已禁止假自动化和 Provider lock-in。

Governance gaps:

1. 缺唯一 `REVIEWER_HANDOFF.md`；
2. `PROJECT_RECORD.md` 被写成“长期单一真相”，与 canonical Governance 的 current Reviewer truth 模型不完全一致；
3. 没有独立记录 bootstrap reconciliation evidence；
4. 没有明确说明哪些 VPS-only 条款 N/A、何时恢复；
5. 没有 machine-readable current status 镜像。

### Actual Writes

本轮新增：

- `REVIEWER_HANDOFF.md`
- `docs/GOVERNANCE_ADAPTATION.md`
- `EXECUTION_EVIDENCE.md`
- `CURRENT_STATUS.json`

本轮修改：

- `README.md`
- `PROJECT_RECORD.md`

### Verification

需要满足：

- Reviewer Handoff 能单独回答：目标、当前 Gate、已 PASS、UNKNOWN、下一步、Owner 是否需要介入；
- PROJECT_RECORD 不再与 Reviewer Handoff 竞争“当前唯一真相”；
- README 阅读顺序优先恢复 Reviewer Handoff；
- CURRENT_STATUS.json 与 Reviewer Handoff 的 current gate 一致；
- G1 保持 CURRENT / IN_PROGRESS，不因治理文档补齐而误判 PASS。

### Result

```text
PASS_CANDIDATE_P0_GOVERNANCE_RECONCILIATION
STOP_AT_REVIEWER: YES
```

Reviewer accepted decision: `PASS`，记录于 `REVIEWER_HANDOFF.md`。

---

## Secret / Private Data Statement

No private key, password, Cookie, Token, webhook URL, encryption-key value, decrypted private data, or private business identifiers are recorded here.

---

## G1 Design Decision — Low-Level Antigravity Execution

- Date: 2026-09-20
- Owner decision: Antigravity should act like the previous Execution Agent and complete image generation + timeline assembly in one run, with near-zero creative freedom.
- Production simplification: final video is primarily a sequence of generated still images placed at exact times; complex motion should normally be decomposed into more still-image shots.
- Cost assumption supplied by Owner: Nano Banana image generation is cheap enough that image count is not the primary optimization target.
- Audio path remains OPEN: upstream TTS vs Antigravity TTS from locked script/SRT.

### Accepted design changes

- Added `docs/LOW_LEVEL_EXECUTION_PACKAGE.md`.
- Frozen one-small-shot ≈ one-image default.
- Frozen Character / Scene / Style canonical-reference contracts.
- Frozen exact Shot Timeline + one-row-per-image generation sheet.
- Frozen `DO_NOT_ADD` default for unspecified effects.
- Antigravity cannot change story, text, shot count, timing, prompts, characters, scenes or edit style.

### Result

```text
DESIGN_DECISION_ACCEPTED_WITHIN_G1
G1 remains IN_PROGRESS
```

---

## Gate G1 — Worker Inventory + Canonical Contracts

- Date: 2026-09-20
- Reviewer decision: PASS

### Read-back Evidence

Confirmed present and readable:

- `docs/CONTENT_STRATEGY_AND_CONVERSION.md`
- `docs/WORKER_ADAPTER_PLAN.md`
- `docs/ADAPTER_FIELD_MAPPINGS.md`
- `docs/LOW_LEVEL_EXECUTION_PACKAGE.md`
- `docs/ANTIGRAVITY_POC.md`
- `schemas/topic_opportunity.schema.json`
- `schemas/episode.schema.json`
- `schemas/shot.schema.json`

### Worker Findings

- No canonical standalone Topic Skill found in current `spike.skill` root + recursive path scan.
- No canonical standalone McKee Skill found in current scan.
- Jingsui is admitted only as a candidate Writer Style Engine behind a restrictive Adapter.
- acquisition-growth-radar is positioned at Publish/Learning, not Topic selection.
- entertainment-rander is optional Signal Intake only.
- Antigravity integration classification: `MANUAL_EXECUTOR / NOT_YET_POC_VALIDATED`.

### Accepted Design

- Topic contract uses hard gates before comparative scoring.
- Every episode has one primary content job: DISCOVERY / TRUST / SOLUTION.
- Metrics are separated into Traffic / Trust / Conversion.
- Visual Repetition Gate is required.
- One video defaults to one core AI mechanism.
- McKee-style causal structure belongs to internal Story Engine Gate for now.

### Result

```text
PASS_G1_WORKER_INVENTORY_AND_CANONICAL_CONTRACTS
NEXT_GATE: G2
```

---

## Owner Review Hold After G1

- Date: 2026-09-20
- Owner instruction: stop after G1 completion and review the overall direction before continuing.
- Authoritative state: `G1 PASS / HOLD BEFORE G2`.
- A MCP G2 preflight draft had already been created before the stop instruction was processed.
- That MCP material is retained for traceability but explicitly downgraded to `DRAFT_HOLD_NOT_ACCEPTED`; it is **not** counted as G2 progress or evidence.
- No Agent / Memory G2 validation was performed.
- No G3+ work is accepted.

### Result

```text
G1 PASS
PROJECT HOLD FOR OWNER REVIEW
G2 PENDING
```

---

## Gate G2 — Topic → Human Problem → Story MVP

- Date: 2026-09-20
- Reviewer decision: PASS
- Validation episodes:
  - `episodes/20260920-mcp/`
  - `episodes/20260920-agent/`
  - `episodes/20260920-context-memory/`
- Cross-topic review: `docs/G2_VALIDATION_REVIEW.md`

### Current official evidence used

MCP:
- Model Context Protocol specification 2026-07-28
- MCP server primitives / tools specification
- MCP 2026-07-28 release notes

Agent:
- OpenAI practical guide to building agents
- OpenAI Workspace Agents
- OpenAI Agents API / long-running agent infrastructure

Context / Memory:
- OpenAI conversation state / context window guide
- OpenAI Agents API context management
- OpenAI Dreaming / Memory
- OpenAI Memory FAQ

### Result

```text
PASS_G2_TOPIC_TO_HUMAN_PROBLEM_TO_STORY_MVP
NEXT_GATE: G3
```

No script, image, video, or Antigravity execution was accepted as part of G2.

---

## Gate G2.5 — Topic Supply / Ledger / Dedup

- Date: 2026-09-20
- Status: PASS_CANDIDATE / OWNER REVIEW
- Reason: Owner requires topic supply and duplicate prevention to be solved before G3.

### Artifacts created

- `docs/TOPIC_OPERATING_SYSTEM.md`
- `topic-ledger/README.md`
- `topic-ledger/topic-registry.jsonl`
- `topic-ledger/daily/TEMPLATE.json`
- `topic-ledger/calendar/2026-09.md`
- `topic-ledger/EVERGREEN_BANK.md`
- `schemas/topic_registry_entry.schema.json`

### Decisions

- Calendar alone is insufficient; Registry is canonical topic memory.
- Topic supply is HOT + EVERGREEN.
- Qualified HOT candidates have scheduling preemption; unqualified trends do not.
- Daily task is recommended as signal radar / shortlist only.
- Automatic publishing and automatic `published` state are forbidden.
- Automation has not been enabled.
- G3 remains blocked pending Owner review.


---

## G2.5 Owner Acceptance + Automation Enablement

- Date: 2026-09-20
- Owner accepted Topic Operating System.
- Reviewer decision: PASS.
- Daily Topic Radar scheduled task: ENABLED.
- Timezone: Asia/Shanghai.
- Cadence: daily, flexible morning window around 08:00.
- Rolling planning horizon: 7 days.
- GitHub owner view: `topic-ledger/calendar/YYYY-MM.md`.
- Initial 2026-09 rolling calendar seeded with 2026-09-21 through 2026-09-27 planned topics.
- Hot candidates may replace only `planned` slots.
- `locked` / `published` slots are immutable to the daily radar.
- Automatic publishing remains forbidden.

### Result

```text
PASS_G2_5_TOPIC_SUPPLY_LEDGER_DEDUP
DAILY_TOPIC_RADAR_ENABLED
READY_FOR_G3
```

---

## Gate G3 — Story → Script / SRT MVP

- Date: 2026-09-20
- Reviewer decision: PASS
- Writer quality contract: `docs/WRITER_QUALITY_CONTRACT.md`
- Validation review: `docs/G3_VALIDATION_REVIEW.md`

### Validation

Episodes:
- MCP
- Agent
- Context / Memory

Mechanical QA:
- Script↔SRT exact text consistency: 3/3 PASS
- forced self-intro: 0
- forced English sign-off: 0
- tutorial regression: no material failure
- locked mechanism drift: no material failure

### Important limitation

Writer policy/Adapter quality is validated manually under Showrunner control.
Programmatic orchestration is NOT yet proven.

### Result

```text
PASS_G3_STORY_TO_SCRIPT_SRT_MVP
NEXT_GATE: G4
```

---

## G3R — Bilibili Editorial / Narrative Rebaseline

- Date: 2026-09-20
- Status: PASS_CANDIDATE / OWNER REVIEW
- G4: BLOCKED

### Evidence reviewed
- accepted project contracts and G1–G3 artifacts;
- Acquisition Growth Radar v0.2;
- Jingsui v3.4;
- Bilibili official creator Data Center documentation;
- Bilibili official 2025 investor materials on mid/long-form, AI category growth and creator monetization.

### Candidate artifacts
- `docs/BILIBILI_CHANNEL_STRATEGY.md`
- `docs/G3R_EDITORIAL_REVIEW.md`
- `docs/DAILY_TOPIC_AUTOMATION_V2_PROPOSAL.md`
- proposed v0.2 additions to Writer / Content Strategy contracts.

### Governance note
No G4 production work was started.
The live scheduled Daily Topic Radar was not changed to the proposed v0.2 planner before Owner approval.

---

## G3R Refinement — Tutorial Module Removed

- Date: 2026-09-20
- Owner decision: remove tutorial as editorial mode.
- Remaining modes: STORY_MODEL / STORY_ACTION.
- Proposed weekly mix: 5 / 2.
- Added optional bounded Viewpoint Gate.
- Added scene/beat causal progression contract.
- G4 remains BLOCKED pending final Owner PASS.

---

## G3R Documentation Consolidation — Owner Aligned / Not Pass

- Date: 2026-09-20
- Owner allowed documentation consolidation.
- Owner did NOT issue G3R PASS.
- Two unresolved editorial questions remain.
- Tutorial mode removed from current candidate baseline.
- Candidate modes: STORY_MODEL / STORY_ACTION.
- Candidate primary duration: 3–5 min with justified exceptions.
- Candidate weekly mix: 5 / 2.
- Live Daily Topic Radar v0.1 not changed.
- No G4 work started.

```text
G3R HOLD
OPEN_QUESTIONS = 2
G4 BLOCKED
```

---

## G3R Narrative Style Contract + Agent Smoke Test

- Date: 2026-09-20
- New candidate contract: `docs/NARRATIVE_STYLE_CONTRACT.md`
- Owner alignment: narrative/viewpoint direction strongly accepted for consolidation.
- Overall G3R: HOLD; one Owner editorial question remains.

Safeguards added:
- Controlling Question before thesis;
- Idea vs Counter-Idea;
- Lightness Guard;
- climax should carry meaning where possible;
- fixed IP remains participant/fallible narrator, not teacher.

Smoke test:
- `episodes/20260920-agent/G3R_narrative_test_v1.md`
- `episodes/20260920-agent/G3R_narrative_test_review_v1.md`
- result: PASS_CANDIDATE / OWNER REVIEW
- estimated spoken target: roughly 3–3.5 minutes before final voice alignment.

No G4 production work was started.

---

## G3R Dialogue Promotion + Context/Memory Cross-topic Test

- Date: 2026-09-20
- Dialogue/prose candidate rules promoted into Narrative Style Contract v0.2 and Writer Quality Contract v0.3.
- No G4 work started.

Agent narrative test:
- `episodes/20260920-agent/G3R_narrative_test_v2.md`
- self-review: 91/100.

Context / Memory narrative test:
- `episodes/20260920-context-memory/G3R_narrative_test_v1.md`
- self-review: 89/100.

Cross-topic portability:
- PASS_CANDIDATE.
- Risk/permission conflict is not required for the format to work.
- Conceptual misunderstanding + character-caused escalation can sustain the same story-first model.

Governance:
```text
G3R HOLD
READY_FOR_OWNER_PASS_DECISION
G4 BLOCKED
```

---

## G3R Patch Integration + Three-Case Narrative Evidence

Date: 2026-09-20

Owner accepted the latest copywriting patch for formal project-space integration.

Contracts updated:
- Narrative Style Contract v0.3
- Writer Quality Contract v0.4

Added:
- Hook Strength Gate;
- Event-driven / Metaphor-driven narrative engine selection;
- Mechanism Definition Compression;
- Formatting as Semantic Rhythm.

Final script evidence:
- Agent v2: `episodes/20260920-agent/G3R_narrative_test_v2.md` — 91/100 self-review.
- Context / Memory v2: `episodes/20260920-context-memory/G3R_narrative_test_v2.md` — 92/100 self-review.
- MCP v1: `episodes/20260920-mcp/G3R_narrative_test_v1.md` — 90/100 self-review.

Result:
- cross-topic portability = PASS_CANDIDATE;
- three distinct story engines/conflict textures retain KnowledgeCore and IP-first storytelling;
- no G4 production work started.

State:
`G3R HOLD / READY FOR EXPLICIT OWNER PASS / G4 BLOCKED`.

---

## G3R Final PASS Closeout

Date: 2026-09-20

Owner decision:
**PASS**

Reviewer decision after final consistency review:
**PASS**

Final canonical editorial baseline:
- Bilibili primary;
- daily editorial target;
- production throughput unproven;
- 3–5 min standard target;
- first-person recurring IP;
- STORY_MODEL / STORY_ACTION only;
- tutorial mode removed;
- viewpoint may be story meaning but must be dramatized, bounded, and evidence-grounded.

Final three-case validation:
- Agent v2 — accepted validation — 91/100 self-review;
- Context / Memory v2 — accepted validation — 92/100 self-review;
- MCP v1 — accepted validation — 90/100 self-review.

Final consistency cleanup:
- removed current-state NOT PASS markers from canonical contracts;
- superseded 4–6 / 3–8 duration proposal with 3–5 target;
- superseded STORY_TUTORIAL;
- superseded “观点是余味，不是承重墙” with “观点可以是故事的灵魂，但不能是作者的演讲”;
- rewrote G3R final review;
- rewrote Reviewer Handoff as current authoritative state;
- activated Daily Topic Planner v0.2 by updating the existing scheduled task in place;
- did not start G4.

Gate result:
```text
G3R = PASS
G4 = READY_NOT_STARTED
OWNER_HOLD_BEFORE_G4 = YES
```

---

## G4 Start — Two-phase Director / Shot Compiler + Agent G4A

Date: 2026-09-20

Owner explicitly authorized entering the next round.

New G4 contract:
- `docs/G4_DIRECTOR_COMPILER_CONTRACT.md`

New intermediate schema:
- `schemas/semantic_shot.schema.json`

Architecture correction:
- G4A locks semantic shot decisions without final timestamps.
- G4B compiles exact start/end/duration only after final audio/SRT is locked.
- This prevents fake precision while preserving the existing final `shot.schema.json` contract.

Agent G4A:
- source script: `episodes/20260920-agent/G3R_narrative_test_v2.md`
- plan: `episodes/20260920-agent/G4A_semantic_shot_plan_v1.json`
- review: `episodes/20260920-agent/G4A_semantic_shot_review_v1.md`
- semantic shots: 36
- result: PASS_CANDIDATE

G4 overall:
`IN_PROGRESS`

G4B:
`BLOCKED_BY_AUDIO_MASTER / AUDIO_MODE=TBD`

No G5 or Antigravity execution started.

---

## G4 Final PASS — Director / VisualBeat Shotbook

Date: 2026-09-20

Final review:
- `docs/G4_VALIDATION_REVIEW.md`

Timing source approved by Owner:
- `JINGSUI_CALIBRATED_REFERENCE`

Evidence:
- Agent: 36 semantic shots / 61 visual beats / 150.14s / avg 2.46s
- Context / Memory: 43 / 63 / 172.19s / avg 2.73s
- MCP: 44 / 63 / 166.38s / avg 2.64s

Machine validation:
- all semantic plans PASS structure checks;
- all visual-beat plans PASS timing continuity checks;
- no overlaps or nonpositive durations.

Gate:
`G4 = PASS`

Next:
`G5 = READY_NOT_STARTED`

Owner explicitly requested pause after G4 PASS. No G5 work started.



---

## G5 VB009 POV / Execution Compatibility Patch

Date: 2026-09-21

Trigger:
accepted POV audit changed VB009 from OBSERVER to IP_POV_HANDS.

Detected contradiction:
- VB008 source frame is OBSERVER / MEDIUM_CLOSE;
- VB009 target is IP_POV_HANDS / MEDIUM_INSERT;
- old execution row required both a POV reframe and preservation of source camera/crop.

Reviewer decision:
`RETURN_DERIVE_SOURCE_INCOMPATIBLE`.

Correction:
- VB009 `DERIVE_EDIT → GENERATE`;
- remove `source_frame_ref=SRCH_VB008.png`;
- retain VB008 only as semantic/world continuity;
- prompt locks downward first-person desk insert, own adult hand + wine-red/cream cuff + pen + cost sheet;
- exact Chinese remains POST_OVERLAY;
- identity QA is visibility-scoped.

Execution distribution:
- GENERATE: 15
- DERIVE_EDIT: 25
- COMPOSITE_CROP: 4

Result:
`VB009_RETRY_READY_FRESH_GENERATE_IP_POV_HANDS`.

Next:
`Generate/QA VB009 → PASS → VB012`.


---

## G5 Pilot — VB012 PASS_WITH_MINOR

Date: 2026-09-21

Result:
`SRCH_VB012 = PASS_WITH_MINOR`.

Accepted:
- IP_POV policy-page discovery works;
- viewer can tell the page is a refund-rules page;
- later “platform service fee non-refundable” reversal is not leaked;
- page remains readable enough for the Pilot.

Deferred minor issues:
- laptop/desk outer framing remains more visible than ideal;
- generated page included invented “示例平台” branding;
- production package should prefer direct page-view framing and brand NONE;
- exact Chinese remains POST_OVERLAY policy.

Decision:
do not rework VB012 during Pilot.
Continue to VB015.


---

## G5 Pilot — VB015 preflight correction

Date: 2026-09-21

Preflight found stale references inside the VB015 Blueprint:
- background anchor incorrectly said `answer-pane shell`;
- story prop incorrectly referenced `UI_AI_ANSWER_001`.

Both conflict with the actual locked policy-page sequence and were corrected to `UI_POLICY_PAGE_001`.

Execution interpretation:
- full-episode canonical VB015 remains `DERIVE_EDIT(source=VB014)`, because it is a same-page reading-focus shift;
- isolated Pilot does not include VB014, so Pilot validation may generate VB015 as a fresh matched-setup master;
- VB016 must preserve VB015 crop/page geometry and reveal only the previously withheld line.

No architecture change required.


---

## G5 Pilot — VB015 Attempt 1 RETURN_GENERATION_ONLY

Date: 2026-09-21

Result:
`SRCH_VB015 = RETURN_GENERATION_ONLY`.

What failed:
- output expanded into a full help-center page;
- sidebar/modules created excessive density;
- the intended reading movement from previous line to next-line region was not visually dominant;
- setup/reveal anticipation was weak.

What did NOT fail:
- G4 meaning;
- matched setup/reveal architecture;
- DERIVE_EDIT logic for full-episode production.

Retry constraint:
- tight crop only;
- previous policy-line tail may remain visible;
- next-line target region must be centered but blank/blurred/unreadable;
- no sidebar, brand, full-page context, warning icon, arrows, or red/green polarity;
- preserve exact crop/page geometry for VB016 reveal.

Decision:
no architecture rewrite; regenerate only.
