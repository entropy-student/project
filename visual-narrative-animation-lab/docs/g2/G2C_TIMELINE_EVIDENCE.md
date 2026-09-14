# G2C Timeline Evidence — Animatic v0

> Gate: G2C3 30–45s Timeline Assembly
> Status: PASS_CANDIDATE

## Output

- Duration: 38.482 s
- Resolution: 1280×720
- Frame rate: 30 fps
- Video: H.264
- Audio: temporary local Mandarin TTS, AAC
- Transition policy: hard cuts
- Runtime motion: none in v0; this intentionally matches the benchmark's static-within-shot baseline
- Text policy: all audience-readable copy is post-added Simplified Chinese; generated art contains no required final copy

## Timeline

18 visual beats from `G2A_TEST_SCRIPT_AND_SHOTBOOK.md` were assembled into 38.5 seconds.

The v0 assembly intentionally reuses eight major compositions rather than creating 18 unrelated images. Reuse covers callbacks, reaction holds, digital/new-conversation state, and the five-factor board across several spoken beats.

## Temporary voice

- local Mandarin TTS
- timing only, not final voice quality
- raw duration: ~47.09 s
- time-compressed to fit the 38.5 s shotbook

## Review target

This render answers one question:

> Does the many-to-many visual-beat structure feel more alive and narrative than sentence → single-image slideshow generation?

Do not judge final art polish, voice quality, or finished motion from v0.

## Known compromises

1. Image generation repeatedly returned a 2×4 contact sheet despite single-shot instructions.
2. Eight wide plates were extracted and used as source material.
3. 16:9 focus crops were derived for the draft timeline.
4. Some planned shot-specific gags are represented by overlays/reuse instead of bespoke art in v0.
5. No SFX/BGM in v0.

## Next review decision

- PASS if visual-beat cadence clearly improves narrative feel enough to justify refinement.
- RETURN if the result still feels like a slideshow; then diagnose whether the missing layer is shot-specific art, crop/camera staging, SFX, or more frequent visual beats.
