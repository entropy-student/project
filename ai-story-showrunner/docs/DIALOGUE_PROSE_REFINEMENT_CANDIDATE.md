# Dialogue / Prose Refinement Candidate v0.1 — SUPERSEDED

> Status: SUPERSEDED on 2026-09-20. Stable rules promoted into `docs/NARRATIVE_STYLE_CONTRACT.md` v0.2 and `docs/WRITER_QUALITY_CONTRACT.md` v0.3. Kept only as historical review evidence.
>
> Purpose: consolidate the dialogue-level recommendations from the current McKee research and the attached "退款文案修改建议（麦基视角）" into one non-canonical candidate. After Owner confirms the rewritten sample, merge the accepted rules into NARRATIVE_STYLE_CONTRACT / WRITER_QUALITY_CONTRACT.

## 1. Seven executable rules

### R1 — Dialogue is verbal action
Every spoken line / first-person narration should do something:
- pressure;
- evade;
- reclaim control;
- test;
- justify;
- bargain;
- hide panic;
- provoke;
- decide.

Do not keep a line merely because it accurately states an idea.

### R2 — Preserve subtext
If the audience can infer the feeling or conclusion from action/context, do not name it again.

Bad:
- 我特别快乐。
- 我突然没那么快乐了。
- 这下我才发现两边都不对。

Prefer:
- concrete action;
- silence;
- reaction;
- the next decision.

### R3 — Character-specific vocabulary
The recurring IP should not sound like a generic narrator.

Preferred lexical world:
- 自动化;
- 外包;
- bug;
- 退货;
- 审批;
- 插件;
- 成本;
- 偷懒;
- 工位 / 上班.

This is a thinking vocabulary, not a forced catchphrase list.

### R4 — Dramatic economy
Delete:
- structural signposts that add no action ("后来我又想了一下");
- emotion labels already conveyed by behavior;
- summaries that the next lines already prove;
- repeated payoff statements.

If the next sentence lets the audience infer the conclusion, remove the explanatory sentence before it.

### R5 — Action / reaction / silence may replace speech
At reversals and turning points, a pause, look, click, physical reaction or screen state may carry more weight than another explanatory line.

Use silence sparingly at genuine turns.

### R6 — Line design / key-word placement
At selected punchlines or reversals, delay the key image/word to the end.

Example:
- 昨天订单是我自己查。
- 今天它什么都查完了。
- 最后只把一样东西还给我——鼠标。

Do not apply mechanically to every sentence.

### R7 — Make methods concrete before abstracting
If a transferable rule exists, show it through concrete cases first.

Example:
- low value + clear rule + easy rollback → execute;
- high value + conflicting context + hard rollback → stop.

Name the mental model only if naming adds value. Do not turn it into a tutorial.

## 2. Specific fixes from the attached review

Apply to Agent draft:
- remove "那一瞬间我特别快乐"; let behavior / fantasy imply it;
- remove "突然就没那么快乐了"; keep the stare/pause;
- replace "心想谢谢 + explanation" with reaction/action;
- remove "后来我又想了一下";
- replace literary "畅想" with concrete daily behavior;
- remove "再有人问我" ending frame;
- compress flat three-sentence method explanation when possible.

## 3. Interaction with existing Narrative Style Contract

These rules DO NOT change:
- Controlling Question;
- Idea vs Counter-Idea;
- McKee causal skeleton;
- Jingsui lightness;
- one-mechanism rule;
- viewpoint boundary;
- STORY_MODEL / STORY_ACTION modes.

They refine the surface language only.

Canonical intent:
> McKee remains under the surface; dialogue/prose should feel more human, less explanatory, and more character-specific.

## 4. Candidate Dialogue Gate

For each important line ask:

1. ACTION — what is the speaker trying to do with this line?
2. SUBTEXT — what is left unsaid?
3. CHARACTER — could another narrator say this unchanged?
4. ECONOMY — is this line repeating what action/next line already proves?
5. DESIGN — can placement, pause, action, or a stronger final word carry more weight?

Return if:
- narrator labels emotions that are already visible;
- explanation outruns experience;
- structural signposts expose the outline;
- generic narrator vocabulary dominates;
- ending steps out of story into a podium summary.

Failure:
RETURN_DIALOGUE_TOO_ON_THE_NOSE

## 5. Packaging rule

Do NOT promote this file to canonical policy yet.

After Owner approves the rewritten sample:
- merge stable rules into docs/NARRATIVE_STYLE_CONTRACT.md;
- merge QA items into docs/WRITER_QUALITY_CONTRACT.md;
- append evidence / handoff;
- keep specific Agent line edits as episode-level evidence, not universal rules.
