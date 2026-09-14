# visual-narrative-animation-lab — REVIEWER HANDOFF

> Maintainer: Reviewer / Architect / Gatekeeper only
> Governance: VPS Project Governance v0.1.6 adapted for local/content-production engineering
> Project type: Visual narrative / animatic / limited-animation production system

## 1. Project Goal

- Final goal: Build a repeatable, low-cost production system that turns narration/script + voiceover into lively hand-drawn narrative videos driven by visual beats rather than sentence-to-image mapping.
- Target experience: Similar production grammar to strong Bilibili hand-drawn comedic/narrative creators (benchmark: “是景岁啊”), without copying a specific creator’s protected characters/assets or requiring traditional full-frame animation.
- Long-term automation goal: script/voiceover -> Director Shotbook -> asset resolution/generation -> camera/pose/action timeline -> render -> finished MP4.
- Near-term goal: Prove a 30–60s manual/semi-manual reference workflow that feels alive before automating it.

## 2. Authority / Source of Truth

1. Owner latest explicit instruction
2. This `REVIEWER_HANDOFF.md`
3. Current Reviewer Gate Prompt / decision
4. `EXECUTION_EVIDENCE.md` (when execution starts)
5. `EXECUTOR_HANDOFF.md` (when execution starts)
6. Supporting docs / README / history / chat

## 3. Core Architecture Hypothesis

```text
Script + Voiceover
        ↓
AI Director / Human Director
        ↓
Visual Beat Timeline / SHOTBOOK
        ↓
Asset Resolver
  ┌─────┴─────────────┐
  ↓                   ↓
Reusable library      Missing shot/pose
(character/props/bg)  AI-generated art
  └──────────┬────────┘
             ↓
Timeline performance
(CapCut/Jianying first; Remotion later)
             ↓
Camera + pose changes + props + SFX + subtitles
             ↓
MP4
```

Key rule: narration sentences and visual shots are many-to-many. A sentence may map to multiple visual beats; one visual composition may span multiple sentences.

## 4. Current State

```text
P0 Discovery / Project Intake             ✅ PASS
G1A Corpus + Analysis Schema             ✅ PASS
G1B Frame-level Deconstruction           ✅ PASS
G2A Script + Director SHOTBOOK             ✅ PASS
G2B Character + Style Proof                ✅ PASS
G2C1 Shot Asset Resolution + Clean Core Art ✅ PASS
G2C2 Major Art Plates + 16:9 Crops           ✅ PASS_CANDIDATE
G2C3 30–45s Timeline Assembly                ✅ PASS_CANDIDATE
G2C4 Owner/Reviewer Visual Comparison         ← HERE
G3 Character / Scene Asset System         ⏳
G4 Director SHOTBOOK Specification        ⏳
G5 Semi-Automated Asset + Shot Pipeline   ⏳
G6 Rendering Automation (Remotion test)   ⏳
G7 Batch Production Validation            ⏳
G8 Package as reusable Skill/Workflow     ⏳
```

## 5. Accepted Gates

### P0 Discovery / Project Intake
- Reviewer decision: PASS
- Accepted baseline:
  - The desired product is not a “sentence -> one image -> wipe reveal” slideshow.
  - The core capability sought is visual storytelling: dynamic shot/pose/camera decisions tied to narration and comedic/emotional beats.
  - The first production baseline should be manual/semi-manual, using AI for art and a timeline editor for performance.
  - Remotion/Live2D/PSD2Live are possible later-stage components, not the initial core.
  - Long-term automation is allowed only after the visual grammar is proven by real samples.

### G1 Benchmark A Deconstruction
- Reviewer decision: PASS for full-video evidence; grammar remains provisional pending cross-video validation.
- Accepted baseline:
  - 159.38 s / 62 detected shots / median shot ~2.2 s.
  - Hard cuts dominate; within-shot image motion is near-zero for almost the entire video.
  - The perceived vitality is driven by semantic shot changes, expressive still poses, metaphors/gags, visual callbacks, graphic punctuation and tight timing.
  - Exact full-composition reuse is observed and acceptable.
  - Runtime camera animation is optional, not a G2 requirement.
  - Visual Beat Grammar v0.1 is sufficient to begin a manual original prototype.

## 6. Current Gate — G2 Manual Narrative MVP

- Goal: Produce one original 30–45 s clip that proves the newly observed visual grammar works outside the benchmark.
- Allowed scope:
  - Original script/voiceover or a user-owned narration excerpt.
  - Original character/pose concepts and AI-generated still assets.
  - Hard-cut timeline assembly, subtitles and sparse SFX.
  - Manual/semi-manual editing in Jianying/CapCut for the first baseline.
- Forbidden scope:
  - Copying the benchmark creator's character/artwork.
  - Building a generalized Remotion/Live2D automation layer before the manual baseline works.
  - Decorative wipes/transitions that are not narratively justified.
- Acceptance criteria: see `G2_MVP_RECIPE.md`.
- Evidence required:
  - final 30–45 s MP4
  - SHOTBOOK / visual-beat table
  - asset list with reuse/new-art counts
  - manual time and revision count
  - Owner qualitative judgement versus the earlier rigid story-to-image approach
- Rollback: discard the prototype assets/timeline; no production dependency exists.

## 7. Confirmed Facts

- `gnipbao/story-to-handdrawn-video` is useful as a storyboard/rendering reference but its default reveal grammar is too rigid for the target.
- The target needs many-to-many mapping between narration and visuals.
- Benchmark A shows camera movement is not required: the main field is overwhelmingly static within shots; pose/composition replacement via hard cuts is the dominant rhythm.
- Pose/expression choice, visual metaphor and cut timing are first-class narrative elements.
- Exact full-composition reuse is observed in Benchmark A and is a valid production technique; character/pose asset reuse is therefore a major cost/time lever.
- AI image generation is better positioned as an asset/shot generator than as the director.

## 8. UNKNOWN / Open Risks

- Exact software/workflow used by “是景岁啊”: UNKNOWN.
- Best final editor/render engine for the automated version: UNKNOWN; CapCut/Jianying is the initial manual baseline.
- Desired final aspect ratio and platform priority: UNKNOWN; do not block G1.
- Final original character art direction: UNKNOWN; intentionally deferred until G2/G3.
- How much manual intervention is acceptable per finished minute: UNKNOWN; will be measured during G2/G7.
- Whether Live2D/PSD2Live adds enough value versus simple pose libraries: UNKNOWN; defer until after G2.

## 9. Owner-only Checkpoints

- Payment/purchase: only if paid software/assets/models become necessary.
- Identity/account authorization: only if a platform login is required.
- Secret/API keys: Owner-only unless exact delegated scope is explicitly authorized.
- Irreversible operation: Owner approval required.
- Major direction change: Owner approval required.
- Current Gate owner intervention required: NO.

## 10. Quality Principles

1. Audio is the master timeline.
2. Visual beats follow meaning/emotion/comedy, not punctuation.
3. Hold frames are allowed; motion is purposeful, not constant.
4. A visual change can be a new shot, crop, camera move, pose, expression, prop, text, or staging change.
5. Reuse is a feature, not a defect, if staging/camera creates fresh meaning.
6. Automation may not reduce narrative quality below the manually validated baseline.

## 11. Gate Roadmap

### G1 — Benchmark Deconstruction
Understand what makes the reference videos feel alive.

### G2 — Manual Narrative MVP
Create an original 30–60s clip with AI-generated still assets + timeline editing. Prove the grammar before automation.

### G3 — Asset System
Build an original reusable character kit, expressions, poses, props, and backgrounds based on actual G2 usage.

### G4 — Director Spec
Encode visual storytelling as a SHOTBOOK/JSON contract supporting many-to-many speech/visual mapping.

### G5 — Semi-Automation
AI generates Director Shotbook, resolves existing assets, and generates only missing art.

### G6 — Rendering Automation
Translate validated camera/pose recipes into Remotion or another programmable renderer and compare against the manual baseline.

### G7 — Batch Validation
Produce multiple 60–120s pieces consecutively; measure quality, asset reuse, manual touches, generation cost, and failure modes.

### G8 — Skill Packaging
Package the proven workflow into a reusable Skill with clear inputs, gates, artifacts, and regression examples.

## 12. Next Step

- Reviewer next action: Review `renders/G2C_animatic_v0/G2C_animatic_v0.mp4` against Benchmark A and decide PASS/RETURN for the visual-beat grammar.
- Executor next action: Hold further art generation until the animatic review identifies concrete deficiencies.
- Owner intervention required: YES — qualitative judgement of narrative feel is required before polishing.

## 13. Status Summary

- Overall progress: P0 ✅ / G1A ✅ / G1B ✅ / G2A ✅ / G2B ✅ / G2C1 ✅ / G2C2 PASS_CANDIDATE / G2C3 PASS_CANDIDATE / G2C4 ← HERE / G3–G8 ⏳
- Final goal: Repeatable low-cost visual-narrative hand-drawn video pipeline with eventual automation.
- Current Gate: G2C4 Owner/Reviewer Visual Comparison.
- This round completed: G2B accepted; working Art Bible locked; text policy corrected; 18-shot asset manifest created. The first G2C proof frames containing embedded English/Traditional copy are retained only as rejected/proof evidence.
- Key correction: The benchmark's vitality comes primarily from semantic redraws, pose-specific illustration, visual gags, callbacks and ~2.2 s hard-cut cadence — not continuous camera animation.
- Next: review the 38.48s animatic v0. If it still feels too slideshow-like, identify the exact missing layer before generating more assets.
- Attention: all audience-readable production copy must be Simplified Chinese overlays, never image-generator text. Cross-video validation remains useful before freezing G4 Director Spec, but it does not block G2.
