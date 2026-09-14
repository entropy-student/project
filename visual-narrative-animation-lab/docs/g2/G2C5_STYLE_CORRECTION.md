# G2C5 Style Correction — 2026-09-14

Status: RETURN / DIRECTION CORRECTION

## Owner feedback

Current G2C5 images have drifted away from the target. They increasingly look like Xiaohongshu covers, promotional posters, or finished manga/info-graphics instead of natural frames from a continuous narrative video.

## Diagnosis

The drift is caused by composition and rendering choices, not by the character identity itself:

- each image tries to communicate a complete thesis instead of one visual beat;
- excessive decorative text, UI panels, stickers, cards and callouts;
- poster-like centered composition and high information density;
- overly polished anime/cinematic rendering;
- too many props and background details competing with the action;
- frames do not feel like neighboring moments from the same scene;
- generated images behave like standalone social-media graphics rather than temporal shots.

## Correct target

Production frames must look like ordinary screenshots from a narrative video.

Required characteristics:

1. One frame = one moment / one visual beat, never a complete poster.
2. No title card composition, no infographic layout, no promotional typography.
3. Prefer simple staging: character + one action + only necessary props/background.
4. Lower detail density; backgrounds may be simplified or partially omitted.
5. Character pose/expression and shot choice carry the meaning.
6. Neighboring shots should feel spatially and temporally connected.
7. Hard cuts, crop changes and pose swaps are created downstream; the still image itself does not need to look "finished".
8. Audience-readable text remains downstream overlay only.

## Video-frame test

Before accepting any generated production asset, ask:

> If this were paused at a random timestamp inside a video, would it look natural?

Reject if it looks more like:

- a Xiaohongshu cover;
- a thumbnail;
- a tutorial poster;
- an infographic;
- a manga page / multi-panel comic;
- a promotional key visual.

## G2C5 reset

Do not continue S04-S07 using the current poster-like visual language.

Next action:

- generate three single-frame calibration shots only;
- use the canonical character identity;
- no readable text, UI, cards, badges or callouts;
- simple narrative staging;
- compare these against the benchmark frame language before resuming Animatic v1.

The three calibration frames should test:

A. ordinary conversational/setup frame;
B. exaggerated reaction/pose frame;
C. visual-metaphor frame.

Only after these three pass should the remaining G2C5 shots be regenerated.
