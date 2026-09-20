# Blind Case 04 — G4R v0.3 Review

## Result
`BLIND_PASS`

Topic:
AI 都搜到官网了，为什么还能答错？

Frozen rule source:
- docs/G4_DIRECTOR_LANGUAGE_RULES_CANDIDATE_V03.md
- SHA: fccc6a6bad667d6a013183f8d0a9f998d448b5d4

Important:
The frozen rules were NOT modified during this blind run.

## 1. Output
- Dramatic Sequences: 6
- Semantic Shots: 19
- Visual Beats: 44
- Reference duration: ~142.21s / 2:22
- Average Visual Beat: ~3.23s
- P25 / Median / P75: ~2.29 / 3.04 / 4.05s
- Locked-script coverage: 100%

## 2. Episode-specific configuration

Primary visual engine:
`INVESTIGATION_DISCOVERY`

Secondary:
- OBJECT_LED
- CONTRAST_COMPARISON
- limited ASSOCIATIVE_MONTAGE

Dominant visual components:
- eye-trace / focal position;
- evidence contrast;
- frame simplification at discovery/reversal.

Recurring motifs:
- official-source trust cue;
- evidence highlight / eye path;
- cost-sheet consequence.

These are new episode configurations.
No seventh Director layer was required.

## 3. What this blind case proves

### A. The architecture handles evidence-led stories

The story does not rely primarily on:
- action/reaction control transfer;
- evolving spatial metaphor;
- repeated multi-location friction.

It instead relies on:
`question → answer → source → exact sentence → next sentence → contradiction → evidence challenge`.

The same six layers were sufficient.

### B. Visual Intention prevents text-card collapse

Evidence text appears only when the exact wording is itself causal:
- 服务费;
- 订单款项;
- 平台服务费不予退还;
- 会 / 不予退还.

Long narration is not automatically rendered as text.
Human reaction, cursor movement, cost-sheet action, page continuity and matched eye-trace carry the rest.

### C. The same source page can drive a full visual sequence

Instead of generating random webpages:
- one official page layout is established;
- first line becomes focal;
- eye moves downward;
- exception line becomes focal;
- answer/page are compared;
- later the same page is rechecked.

This makes information discovery a visual action.

### D. Jingsui timing remains a prior, not a target

Final median beat ~3.04s, slower than the historical ~2.7s prior.

This is accepted because evidence-reading / matched comparison beats need more time.
No shot was added merely to force the median toward 2.7s.

### E. Montage and continuity both remain valid

Relation mix:
- CONTINUITY: 14
- CONTRAST: 15
- POV_DISCOVERY: 4
- INSERT_LED: 4
- ASSOCIATIVE_MONTAGE: 3
- MONTAGE: 3
- MATCHED_INSERT: 1

Evidence-heavy storytelling therefore does not require abandoning the existing image-relation framework.

## 4. Blind-run issues encountered

### Execution issue 1 — paragraph overlap

Paragraph 32 was initially bound to two Semantic Shots.
The 100% script-coverage Gate caught it.

Resolution:
fix case data only.

Architecture impact:
NONE.

### Execution issue 2 — risk-boundary hold too long

The final practical method initially combined:
- low-stakes answers can pass casually;
- high-stakes decisions trigger verification.

These were split into distinct Visual Beats because behavior meaning changed.

Architecture impact:
NONE.

## 5. Knowledge integrity

Locked mechanism remained:
> correct/relevant source retrieval does not guarantee correct evidence selection/integration during answer generation.

The visual story did NOT claim:
- search always retrieves correctly;
- citations guarantee support;
- all searched-answer errors share this cause;
- MCP/permissions/context are the same issue.

No extra AI mechanism was introduced.

## 6. Representative decomposition

Narration:
> 我往下又看了一行。 “平台服务费不予退还。”

Dramatic change:
the correct source itself now contradicts the AI conclusion.

Visual Strategy:
`POV_DISCOVERY` inside the same stable webpage.

Semantic Shot:
one REVERSAL.

Visual Beats:
1. anticipation — eye/cursor moves one line down without revealing the final sentence;
2. reveal — 平台服务费不予退还 becomes the dominant focal line.

Why two:
the eye movement creates discovery; the second image owns the reversal.

## 7. Blind-test verdict

PASS criterion:
new script requires only episode-specific configuration, not architectural redesign.

Observed:
`PASS`.

The six-layer architecture survived an unseen fourth visual engine.

## 8. Recommendation

v0.3 now has:
- 3 known-case PASS_CANDIDATE validations;
- 1 unseen BLIND_PASS validation.

Technical recommendation:
v0.3 is mature enough for Owner review for canonical promotion.

Do NOT promote automatically.
Do NOT enter G5 until Owner explicitly approves integration.