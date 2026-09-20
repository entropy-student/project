# G4 Validation Review — PASS

Date: 2026-09-20

## 1. Decision

Reviewer decision: **PASS**

Scope:
Script / accepted narrative → Semantic Director → Jingsui-paced VisualBeat Shotbook.

G4 does not generate final images and does not execute Antigravity.

---

## 2. Canonical G4 Architecture

```text
Locked Script / KnowledgeCore
→ G4A1 Semantic Director
→ G4A2 Visual Beat Compiler
→ G4B Reference Timeline / SRT Compiler
→ Shotbook
```

Canonical schemas:
- `schemas/semantic_shot.schema.json`
- `schemas/visual_beat.schema.json`

Final low-level `shot.schema.json` is downstream after image prompts and canonical references exist.

---

## 3. Timing Basis

Owner approved using Jingsui-calibrated timing as the current planning/production baseline.

Source profile:
- speech ≈ 5.9 Chinese chars/s;
- visual beat median ≈ 2.7s;
- normal visual range ≈ 1.3–4.5s;
- fast reaction/punchline ≈ 0.8–1.8s;
- explanation/landing may hold ≈ 4–8s.

Current timing source:
`JINGSUI_CALIBRATED_REFERENCE`

Real audio may later trigger timing-only recompilation.

---

## 4. Cross-topic Validation

| Episode | Semantic shots | Visual beats | Duration | Avg beat | Result |
|---|---:|---:|---:|---:|---|
| Agent | 36 | 61 | 150.14s | 2.46s | PASS |
| Context / Memory | 43 | 63 | 172.19s | 2.73s | PASS |
| MCP | 44 | 63 | 166.38s | 2.64s | PASS |

All three machine checks:
- zero structural field errors;
- zero invalid continuity roles;
- zero invalid transitions;
- zero negative/overlapping timing errors.

---

## 5. What G4 Proved

### A. Visual-state cutting works
Shot boundaries follow meaningful changes in action, reaction, object state, story consequence, metaphor state or payoff—not punctuation.

### B. Semantic shot ≠ final image
One semantic event may expand into multiple image-level beats.

Observed:
- Agent: 36 → 61
- Memory: 43 → 63
- MCP: 44 → 63

This preserves story coherence while matching Jingsui-like visual pacing.

### C. Mechanism does not need PPT regression
- Agent mechanism remains embodied in workflow action and human handoff;
- Memory mechanism remains embodied in desk/notebook state changes;
- MCP mechanism remains embodied in department-door friction and standardized service placards.

### D. Cross-topic portability
The Director works across:
- action/risk;
- metaphor/cognitive distinction;
- interoperability/system friction.

---

## 6. Known Risks — downstream, not G4 blockers

1. Character identity consistency has not yet been image-validated.
2. Scene-state continuity is especially important for Memory.
3. Repeated desk/hallway locations can become visually monotonous if G5 does not define composition variants.
4. UI/service placard text must stay concise.
5. Literalizing every joke/metaphor would become visually noisy.
6. Real TTS may require timing-only recompile.

---

## 7. Gate Outcome

```text
G4 = PASS
G5 = READY
```

Next gate:
**G5 — Shotbook → Image Asset Package MVP**

G5 must lock identity/scene/style/props and compile executable image-generation rows without changing Director intent.