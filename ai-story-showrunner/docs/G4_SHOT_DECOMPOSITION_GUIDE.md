# G4 Shot Decomposition Guide — Human-readable

> Purpose: make the Director / Shot Compiler logic understandable to a human reviewer.
> This guide summarizes the accepted G4 method. It does not start G5.

## 1. The hierarchy

Do not think in `sentence → image`.

Think in three layers:

```text
Script
→ Semantic Shot
→ 1..N Visual Beats
→ Jingsui-calibrated timing
```

### Script
The spoken story and locked meaning.

### Semantic Shot
One complete **visual/story event**.

A new Semantic Shot starts only when something meaningful changes:
- action;
- reaction;
- subject;
- location;
- information state;
- metaphor state;
- story consequence;
- reversal/payoff.

### Visual Beat
The image-level unit closest to the final still image.

One Semantic Shot may need multiple Visual Beats when it contains:
- setup → action → reaction;
- joke setup → landing;
- focal object/UI change;
- material pose/expression change;
- metaphor progression;
- camera/composition change needed for rhythm.

Rule:
> **Semantic Shot protects story logic; Visual Beat protects viewing rhythm.**

---

## 2. The Director's six questions

For every piece of narration ask:

1. What must the audience understand **right now**?
2. What concrete person/object/action can show it?
3. What changes compared with the previous image?
4. What is the visual result at the end of this beat?
5. Does that result force the next story state?
6. Can this stay one image, or does setup/reaction/payoff require multiple images?

If nothing visually changes, do not cut merely because punctuation changed.

If two distinct actions/reactions are forced into one still image, split.

---

## 3. Two separate decisions

### Decision A — Should this become a new Semantic Shot?

YES when the **meaningful visual state** changes.

Example:
```text
AI processes refunds successfully
→ large complex refund suddenly appears
```

This is a new Semantic Shot because the story state changes from relief to danger.

### Decision B — Should one Semantic Shot become multiple Visual Beats?

YES when one semantic event contains more than one useful image state.

Example:
```text
Semantic meaning:
AI 查完了所有东西，最后只把鼠标还给我。

Possible visual beats:
1. AI has finished checking everything
2. the desk is clean / work is done
3. only the mouse is slid back to IP
```

The story meaning is one unit; the viewing rhythm needs three images.

---

## 4. Timing rule

Current accepted planning source:
`JINGSUI_CALIBRATED_REFERENCE`

Reference:
- speech ≈ 5.9 Chinese chars/s;
- median visual beat ≈ 2.7s;
- ordinary beat ≈ 1.3–4.5s;
- fast reaction/punchline ≈ 0.8–1.8s;
- explanation/landing may hold 4–8s.

Important:
> **Timing does not decide where the story cuts. Meaning decides first; timing decides whether that semantic event needs more visual states.**

Do not mechanically cut every 2.7 seconds.

---

## 5. Case A — Agent

### Narration
> 昨天订单是我自己查。今天它什么都查完了。最后只把一样东西还给我——鼠标。

### Semantic decision
This is one semantic payoff:
> AI looks autonomous, but the human is still the approval bottleneck.

### Visual decomposition
```text
Beat A — AI 已经把订单/规则全部查完
Beat B — IP 没有参与前面的工作
Beat C — AI 把唯一剩下的东西推回来：鼠标
```

Why split?
- three distinct visual states;
- the last word `鼠标` is a punchline landing;
- one still image would destroy setup → payoff rhythm.

Bad version:
> one slide showing AI + mouse + explanation text.

---

## 6. Case B — Context / Memory

### Narration
> 今天的文件放上去。昨天的讨论放上去。前天改过三版、我自己都快忘了为什么改的东西，也放上去。

### Semantic decision
One semantic event:
> current working context keeps accumulating.

### Visual decomposition
```text
Beat A — 今天的材料占据桌面
Beat B — 昨天的讨论继续叠上去
Beat C — 更旧的版本把桌子进一步塞满
```

Why split?
- the metaphor itself is progressing;
- each image changes the desk state;
- accumulation is the story action.

Continuity requirement:
`DESK_NORMAL → DESK_EXPANDED → DESK_FULL → FLOOR_OVERFLOW`

Bad version:
> every image generates a completely different desk.

That destroys the causal metaphor.

---

## 7. Case C — MCP

### Narration
> 它又问：“在哪看？”我说：“财务系统。”“哪个页面？”“账单。”“怎么进？”

### Semantic decision
One semantic event:
> a capable AI hits another system-specific integration convention.

### Possible visual decomposition
```text
Beat A — AI 到财务部门门口
Beat B — 它发现当地入口/规则和库存部门完全不同
Beat C — 回头再次问 IP 怎么进去
```

Why split?
- question/answer changes who is acting;
- the local rule becomes a new focal object;
- repetition itself is the comic friction.

Bad version:
> Inventory → Finance → Contract boxes connected with MCP arrows.

That explains architecture but kills the story.

---

## 8. Three different visual engines

### Agent — action / reaction engine
Main change source:
- person does something;
- AI does something;
- consequence happens;
- character reacts.

Director priority:
> blocking, reaction, object state, UI insert.

### Memory — evolving metaphor engine
Main change source:
- the same visual world changes state over time.

Director priority:
> spatial continuity and state progression.

### MCP — repeated-friction engine
Main change source:
- similar human problem repeats in different local contexts.

Director priority:
> shared world grammar + meaningful prop/location variation.

---

## 9. Anti-PPT rule

Whenever tempted to draw:
```text
Box A → Arrow → Box B
```

ask first:
> Can a character, prop, location, or consequence perform this relationship?

Examples:
- Agent workflow → AI physically moves the task forward;
- Context → files occupy the desk;
- Compaction → thick discussion becomes one summary page;
- Memory retrieval → notebook note returns to current desk;
- MCP discovery → AI reads the department's service placard;
- Human handoff → AI stops before an irreversible action and turns to IP.

Use diagrams only when the story cannot communicate the distinction accurately without them.

---

## 10. Density / image-count heuristic

Current validation:

| Episode | Semantic Shots | Visual Beats | Reference Duration | Avg Beat |
|---|---:|---:|---:|---:|
| Agent | 36 | 61 | 2:30 | 2.46s |
| Context / Memory | 43 | 63 | 2:52 | 2.73s |
| MCP | 44 | 63 | 2:46 | 2.64s |

Practical lesson:
> A ~2.5–3 minute story currently lands around 60+ image-level beats under this style.

This is not a quota.
The number is a consequence of story-state changes + Jingsui pacing.

---

## 11. Duration note for future scripts

The earlier editorial target of `3–5 min` was decided before G4 timing calibration.

The first three G4 reference-timed episodes actually land at:
- 2:30;
- 2:52;
- 2:46.

Therefore future script length should temporarily treat **~2:30–3:00 as a validated center**, rather than padding to reach 3–5 minutes.

Do not immediately rewrite the canonical duration policy from only three samples.
Recommended next step:
- use the G4-calibrated timing for several more episodes;
- compare retention/production feel;
- then decide whether the editorial duration baseline should become e.g. 2:30–3:30 or remain wider.

Rule for now:
> **If the story finishes naturally at ~2:40, do not add material merely to hit 3 minutes.**

---

## 12. One-line decomposition formula

> **先按故事状态切 Semantic Shot，再按动作/反应/笑点/物件变化把它展开成 Visual Beats，最后用景岁节奏校准每张图停多久。**