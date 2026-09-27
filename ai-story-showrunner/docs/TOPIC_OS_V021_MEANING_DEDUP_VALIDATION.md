# Topic OS v0.2.1 — Human Process + Meaning Dedup Validation

Date: 2026-09-27
Status: PASS_CANDIDATE → Owner accepted for contract integration
Scope: Topic Supply / dedup only. No G6A production changes.

## 1. Question

After Topic OS v0.2 moved discovery from AI-first to human-world-first, two risks remained:

1. one X domain might only generate many surface variants of the same idea;
2. different X domains might hide the same underlying meaning and bypass D2/D3 duplicate checks.

Proposed additions:
- `human_process_family`: what the human is actually doing;
- `meaning_fingerprint`: normalized semantic key derived from Human Tension + Controlling Question;
- D5 Meaning Duplicate: cross-domain semantic dedup.

## 2. Single-domain stress test — Food

Food was decomposed across materially different human processes, including:
- taste formation;
- skill learning;
- tacit cooking judgment;
- family recipe transmission;
- group dining coordination;
- nutrition / bodily sensing;
- review interpretation;
- restaurant discovery;
- restaurant innovation;
- grocery planning;
- food culture / authenticity;
- food content / authorship.

Result:
- 50 food candidates are structurally plausible before full factual/mechanism review;
- the domain is not inherently limited to one thesis;
- the main failure mode is not topic exhaustion but repeated Meaning families.

## 3. Cross-domain stress test — 5 × 10

Domains:
- food;
- relationships;
- MBTI / personality;
- work;
- entertainment / games.

Raw candidates: 50.

Coarse Meaning Fingerprints after first semantic pass: 43.

Clear cross-domain collisions:

| Meaning Fingerprint | Surface topics that collided |
|---|---|
| `OPTIMIZATION_VS_EXPLORATION` | food recommendation; personality-career matching; entertainment recommendation |
| `GUIDANCE_VS_SKILL_FORMATION` | AI cooking guidance; junior-work automation; game copilot |
| `EFFICIENCY_VS_SERENDIPITY` | meal planning; dating planning; work scheduling |
| `CORRECTNESS_VS_AUTHENTIC_EXPRESSION` | relationship reply rewriting; professional email rewriting |

Interpretation:
different X domains and titles can still be the same canonical meaning problem.

## 4. Five deliberately different Meaning families → Story Premise test

### A. STANDARDIZATION_VS_TACIT_EXPERIENCE
Food: AI converts a grandmother's vague recipe into exact grams/time/temperature, yet the result remains unlike hers. Turning point: the missing information lives in tasting, sensing and adaptive judgment, not only written measurements.

### B. HARMONY_VS_NECESSARY_FRICTION
Relationship: a couple routes every conflict through AI rewriting and becomes unusually peaceful. A major life decision reveals that neither has learned how to expose and negotiate real disagreement.

### C. UNDERSTANDING_VS_DEFINITION
Personality: AI analysis describes the protagonist increasingly well. The description starts being used as a boundary on future choices until the protagonist deliberately makes a choice that the past profile could not predict.

### D. EFFICIENCY_VS_SKILL_FORMATION
Work: AI removes all junior tasks and the employee becomes the fastest producer. When AI is unavailable, the employee can output work but cannot independently explain or make the underlying judgment.

### E. RESPONSIVENESS_VS_OTHERNESS
Game / entertainment: AI NPCs remember, understand and adapt perfectly. The protagonist eventually discovers that even serious provocation cannot make the NPC truly leave, exposing the difference between a responsive system and an independent other.

Result:
all five remained distinct after Desire → Action → Complication → Turning Point → Payoff expansion.

## 5. Decision

PASS for contract integration:

```text
X Domain
→ Human Process Family
→ Observed Paradox
→ WHY
→ Human Tension
→ Meaning Fingerprint
→ AI Changed Process
→ Mechanism
→ Story
```

Dedup layers become:

```text
D1 Signal
D2 Topic
D3 Angle
D4 Story / Visual Motif
D5 Meaning
```

Important:
`meaning_fingerprint` is not a locked thesis. It records the semantic tension/question for dedup. The final meaning remains governed downstream by Controlling Question First, Idea vs Counter-Idea and Climax proves → narrator lightly names.

## 6. Backward compatibility

- Existing Topic Registry entries are not rewritten.
- Existing Calendar / Daily snapshots are not rewritten.
- New schema fields are optional.
- AI-first Topic Supply remains a valid compatibility route.
- G3+ narrative contracts remain unchanged.
- Current G6A production workstream remains unchanged.

Rollback baseline:
`rollback/ai-story-showrunner-topic-os-v02-before-meaning-20260927`
from main `080b3cea54e640c75d7f11b265c8fa6397661192`.
