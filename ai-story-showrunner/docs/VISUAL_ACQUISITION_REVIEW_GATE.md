# Visual Acquisition Review Gate v0.1

## Status

`CANONICAL / REQUIRED BETWEEN G5B AND G5C PILOT`

Purpose:
Before scaling a visual production style, review it through the acquisition-growth framework and external evidence.

This Gate exists to prevent:
> “我们自己觉得好看” → “直接锁成长期频道视觉系统”.

---

## 1. Framework

Source:
`entropy-student/spike.skill/acquisition-growth-radar/SKILL.md`

Apply:

```text
Evidence
→ Bottleneck
→ Lever
→ Experiment
→ Decision
```

Visual style is treated as:
`Message / Creative Lever`

It is NOT automatically treated as proven acquisition evidence.

---

## 2. Validation Spine for Visual Style

### Attention
Does the visual system help viewers know where to look and keep watching?

### Interest
Does the style make the story feel worth continuing rather than merely understandable?

### Trust
Does the recurring IP/world feel intentional, credible and recognisable rather than like generic AI art?

### Activation / Value Experience
Does the visual system actually help the viewer understand the AI mechanism/story payoff faster?

### Repeatability
Can the style be produced repeatedly without drift, excessive cost or visual fatigue?

---

## 3. Current External Evidence

Current research direction:
- lower per-frame visual complexity can improve attentional guidance;
- shorter/simple scenes can help sustained attentional synchrony;
- lower visual complexity can improve attention allocation in instructional video.

Platform observation:
- simple line-art / doodle storytelling can succeed;
- richer drawing/animation storytelling can also succeed;
- no platform evidence supports a universal “simpler always wins” rule;
- one same-creator simplified remake did not outperform its preceding non-simplified version, but repeat-exposure confounds prevent causal interpretation.

Therefore:
`SIMPLIFY != SWITCH_TO_STICK_FIGURE`

---

## 4. Current Decision

### Control
`SIMPLIFIED_FLAT_NARRATIVE_COMIC`

Keep:
- recurring human IP;
- wine-red identity cue;
- stable story world;
- character acting;
- causal UI/prop integration.

Reduce:
- hair micro-strands;
- clothing folds;
- shading layers;
- decorative background objects;
- texture/noise;
- simultaneous focal elements.

Target:
roughly 15–25% lower visual complexity than current calibration frames.

### Challenger
`ULTRA_SIMPLE_NARRATIVE_LINE_CARTOON`

Rules:
- retain recognisable IP silhouette / hair / wine-red cue;
- simplify facial detail and environment strongly;
- must still support acting and object interaction;
- do NOT degrade into generic stick figure.

Pure faceless stick figure is NOT a default Challenger because it sacrifices too much IP identity / trust / long-term recognition.

---

## 5. Lite Experiment

Current bottleneck:
`ATTENTION / CREATIVE FIT NOT YET PROVEN WITH REAL AUDIENCE`

Hypothesis:
A moderately simplified narrative comic will preserve IP/trust while gaining most of the attention/clarity benefit of lower visual complexity.

This round changes only:
`VISUAL COMPLEXITY / RENDER DETAIL`

Hold constant:
- script;
- narration/audio;
- beat timing;
- shot structure;
- story;
- core composition;
- CTA;
- title/thumbnail when measuring in-video retention.

### Pilot comparison

Use the same 20–30 second story segment.

Variant A:
current simplified flat narrative comic.

Variant B:
ultra-simple narrative line/cartoon Challenger.

Evaluate:
- first 3–5s comprehension;
- first 30s retention / equivalent short-sample hold;
- whether viewers can identify focal object immediately;
- perceived story attractiveness;
- perceived trust / intentionality;
- character recognisability;
- production drift/retry rate.

Do not choose a winner from “which one looks prettier”.

---

## 6. Decision Rule

### KEEP
Control remains visually clear, recognisable and production-stable.

### ITERATE
Control is good but visually too dense / drifts more than Challenger.

### KILL
Only if audience/production evidence shows the current visual system materially harms attention, understanding or repeatability.

### SCALE
Not allowed from internal preference or three calibration images alone.

Require:
- real production repeatability;
- real audience evidence across multiple samples/episodes.

---

## 7. Current Project Decision

`DECISION = KEEP + ITERATE`

Meaning:
- keep simplified flat narrative comic as Production Control;
- simplify it further by 15–25%;
- do not pivot to pure stick figures;
- introduce ultra-simple line/cartoon as Challenger;
- proceed with G5C Pilot using Control;
- include a small paired style test before full long-term style lock / scale.

---

## 8. Gate Placement

```text
G5A Asset Requirement Extraction
→ G5B Canonical Reference / Style Direction Lock
→ G5B.5 Visual Acquisition Review
→ G5C Image Generation Compiler / Pilot
→ G5 Final Review
```

This Gate may reopen only when:
- real audience evidence contradicts the current style;
- production drift is materially worse than expected;
- channel positioning changes;
- a Challenger repeatedly outperforms Control.
