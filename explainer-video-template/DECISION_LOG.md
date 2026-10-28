# DECISION_LOG

## 2026-10-28 — Planning-first architecture
SOURCE: Owner dialogue, not a production test.
DECISION: Video production = fixed V6 outer shell + Chapter/Beat/Scene planner + independently produced per-scene inner media + eventual compositor. Script length, output duration, and scene count are not hard-coded. Scene-to-scene hard cut, local animation inside each scene. Reviewer only is ChatGPT; Codex is Executor.
RATIONALE: Improve visual controllability, allow scene-local rework and independent review.
STATUS: ACCEPTED_DIRECTION (not implementation PASS).

## 2026-10-28 — G0 before G1
SOURCE: Owner "先把规范立住了再说下一步" and "开始吧".
DECISION: Review/storyboard planning gate G0 precedes formerly planned three-scene MP4 renderer gate G1.
RATIONALE: Prevent rendering machinery being built on a weak or ambiguous storyboard contract.
EVIDENCE: docs/STORYBOARD_METHOD_COMPARISON_20261028.md compares historic 52-scene outline A with Reviewer-produced 8-scene specimen for three segments. A: 15 scenes vs B: 8 scenes within same excerpts. Neither output is an independent double-agent benchmark, neither was video rendered. This supports principle "multiple visual events can live within one Scene", NOT automatic acceptance of shorter scene count as better.
STATE: G0_SPEC_CANDIDATE; freeze and G1 reactivation require Reviewer judgment and Owner acceptance.

## 2026-10-28 — Script fidelity and evidence discipline
DECISION: Default verbatim script; distinguish voiceover from headlines, code, stage directions; price/technical claims and risky operations must be verified. Never present synthetic imagery as proof.
STATUS: RULE_CANDIDATE pending G0.

## 2026-10-28 — Owner HOLD / V6 baseline preserved
SOURCE: Owner explicitly requested '暂时hold一下，视频模版保留封存，具体如何划分分镜进一步制作视频再讨论后续。'
DECISION: Set project ON_HOLD. Preserve V6 private offline HTML/WebM work package and existing storyboard candidate/methodology notes. No new storyboard planning, Agent tests, coding, production, rendering, PR merge, or release while paused.
GATES: G0_STORYBOARD_PLAN_VALIDATION and G1_DATA_DRIVEN_RENDER_POC both SUSPENDED; old relay prompts no longer authorize action. Resume only after new explicit Owner instruction and Reviewer reconciliation.
SCOPE: Documentation of hold only; project software, media, and draft PR remain unchanged.
STATUS: ACTIVE_HOLD, not decommissioned.
