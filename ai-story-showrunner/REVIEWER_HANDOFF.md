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

G4   READY_NOT_STARTED
OWNER_HOLD_BEFORE_G4 = YES
```

Owner explicitly PASSed G3R on 2026-09-20 and asked for an overall review before starting the next gate.

Therefore:
- G3R is final for the current editorial baseline;
- G4 is technically next but MUST NOT start without explicit Owner instruction;
- Daily Topic Planner v0.2 may continue because it is editorial planning, not G4 production.

## 2. Final Goal

Build a reusable AI Story Showrunner that converts:

```text
AI signal / concept
→ human problem
→ one locked mechanism
→ story
→ script / SRT
→ Director / Shot Compiler
→ low-level execution package
→ Antigravity image generation + timeline assembly
→ video draft
→ QA / publish / feedback learning
```

Showrunner remains the control plane.
Workers do not own global truth.

## 3. Current Canonical Editorial Baseline

Primary platform:
**Bilibili**

Editorial cadence target:
**DAILY**

Production throughput:
**UNPROVEN**

Default duration:
**3–5 min**, with longer exceptions only when narrative need justifies them.

Default POV:
**first-person recurring channel IP**

Editorial modes:
- `STORY_MODEL`
- `STORY_ACTION`

Tutorial mode:
**REMOVED**

Initial seven-day portfolio hypothesis:
- 5 STORY_MODEL
- 2 STORY_ACTION

Business jobs remain independent:
- DISCOVERY
- TRUST
- SOLUTION

## 4. Canonical Narrative / Writer Contracts

- `docs/BILIBILI_CHANNEL_STRATEGY.md`
- `docs/NARRATIVE_STYLE_CONTRACT.md` v0.3
- `docs/WRITER_QUALITY_CONTRACT.md` v0.4
- `docs/CONTENT_STRATEGY_AND_CONVERSION.md`
- `docs/G3R_EDITORIAL_REVIEW.md`

Current style:

> **景岁的轻盈口述 × McKee 的因果/意义 × AI机制作为世界规则 × 第一人称IP的认知变化。**

Portable causal invariant:

```text
character desire
→ character action
→ mechanism response
→ meaningful state change
→ next choice
→ recognition / payoff
```

Do NOT standardize one plot formula.

## 5. Final Viewpoint Rule

Superseded:
> “观点是余味，不是承重墙。”

Current:

> **观点可以是故事的灵魂，但不能是作者的演讲。**

Use:
- Controlling Question;
- Idea vs Counter-Idea when relevant;
- story consequences;
- climax / meaningful choice;
- light explicit naming only when still needed.

No universal prophecy from one anecdote.

## 6. Sentence-Level Rules

Accepted:
- dialogue = verbal action;
- preserve subtext;
- character-specific vocabulary;
- dramatic economy;
- action/reaction/silence can replace explanation;
- selective line design;
- concrete method before abstraction;
- mechanism-definition compression;
- formatting as semantic rhythm, used sparingly.

## 7. G3R Validation Evidence

### Agent
`episodes/20260920-agent/G3R_narrative_test_v2.md`  
Accepted validation. Self-review: 91/100.  
Type: event-driven permission/action.

### Context / Memory
`episodes/20260920-context-memory/G3R_narrative_test_v2.md`  
Accepted validation. Self-review: 92/100.  
Type: metaphor-driven cognitive distinction.

### MCP
`episodes/20260920-mcp/G3R_narrative_test_v1.md`  
Accepted validation. Self-review: 90/100.  
Type: repeated integration friction / interoperability.

Cross-topic result:
**PASS**

## 8. Topic Operating System

G2.5 remains PASS.

Daily Topic Planner:
- active contract: `docs/DAILY_TOPIC_AUTOMATION_V2.md`;
- scheduled task updated in place;
- 7-day rolling schedule;
- each slot records Business Job + Editorial Mode + Target Duration;
- HOT may override only `planned` slots;
- planner never enters G4+, publishes, or claims production throughput.

Season 0:
- `docs/SEASON0_21_DAY_PLAN.md`
- APPROVED / NOT STARTED.

## 9. Production Boundary — Not Yet Started

Antigravity:
`MANUAL_EXECUTOR / NOT_YET_POC_VALIDATED`

Current frozen principles:
- Antigravity = restricted Execution Agent;
- one small shot ≈ one generated image;
- motion preferably represented by multiple still images;
- executor has near-zero creative freedom;
- missing / conflicting execution instructions → RETURN, not improvisation;
- Character / Scene consistency comes from canonical references + per-shot contract.

Audio mode:
**TBD**
- upstream TTS, or
- restricted executor TTS.

No G4 artifact is accepted yet.

## 10. Remaining Risks / Unknowns

These did not block G3R:
1. IP recognizability is not yet audience-validated.
2. DAILY production throughput is unproven.
3. Visual execution can still regress into PPT/explainer style.
4. Antigravity programmatic integration remains unknown.
5. Audio path remains unresolved.
6. Season 0 metrics are still hypotheses until publication.

## 11. Next Gate — Owner Hold

Next gate:
**G4 — Script / SRT → Director / Shot Compiler MVP**

But current instruction is:

> **Do not start the next round yet.**

Required next action:
Owner reviews this closeout and explicitly says whether to enter G4.

Until then:
`G4 = READY_NOT_STARTED / OWNER_HOLD`.
