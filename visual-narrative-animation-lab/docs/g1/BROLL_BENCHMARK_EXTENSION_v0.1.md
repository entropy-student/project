# B-roll Benchmark Extension v0.1

The same benchmark/deconstruction workflow can be used for videos that mix character/host visuals with B-roll. B-roll is treated as another visual storytelling class, not as an exception.

## Extended visual classes

- `CHARACTER_ART`
- `BROLL_FOOTAGE`
- `SCREEN_RECORDING`
- `SCREENSHOT`
- `ARCHIVAL_OR_OWNED_CLIP`
- `PROP_CLOSEUP`
- `GRAPHIC`
- `TEXT_CARD`
- `CALLBACK_REUSE`

## Additional analysis fields

For every Visual Beat record:

1. start/end time
2. narration beat
3. visual class
4. what is shown
5. why this visual appears here
6. source type: original / owned / licensed / generated / screenshot
7. B-roll in/out timecode when applicable
8. crop / speed / stabilization / freeze-frame treatment
9. whether source audio is kept, ducked or removed
10. overlay/subtitle/graphic relationship
11. transition type
12. narrative job: evidence / example / atmosphere / joke / reset / explanation / proof

## Director rule

The Director should choose the **best visual carrier for the meaning**, not force every line into character art.

Example:

```text
Narration: “我打开后台一看，延迟已经冲到三秒。”

Priority:
1. actual screen recording / screenshot of latency panel
2. simplified recreated UI graphic
3. character pointing to a generic dashboard
```

If real B-roll communicates the fact faster, use it.

## B-roll trigger patterns

B-roll is especially useful for concrete actions, places/objects, visible examples, evidence/proof, product/software usage, before/after comparison, and pacing resets.

Character/illustration is stronger for internal emotion, exaggeration, metaphor, comedy, abstract concepts without usable footage, callbacks and identity continuity.

## Rights boundary

Prefer:

1. user's own footage;
2. user's licensed/authorized assets;
3. properly licensed stock/public-domain material;
4. generated original visuals.

A benchmark video's B-roll may be analyzed for timing and narrative role, but its copyrighted footage should not be copied into production unless separately authorized/licensed.

## Multimodal pipeline

```text
Voiceover
  ↓
Director / Visual Beats
  ↓
choose visual carrier per beat
  ├─ character art
  ├─ B-roll
  ├─ screen recording
  ├─ screenshot
  ├─ prop close-up
  └─ graphic
  ↓
Asset Resolver + provenance
  ↓
Timeline / subtitles / SFX
  ↓
MP4
```
