# Agent G4A2 Visual Beat Density Review v1

## Result
`PASS_CANDIDATE`

- semantic shots: 36
- visual beats: 61
- provisional duration: 2:30 (150.14s)
- average visual beat: 2.46s

## Finding

The original 36 semantic shots were correct as story/visual-event units, but too sparse if mapped one-to-one to final images.

Using the calibrated Jingsui rhythm, 36 semantic shots expand to 61 visual beats.

This is the intended hierarchy:
`36 semantic events → 61 image-level visual beats`.

## Why this is better
- preserves story causality;
- avoids punctuation-based cutting;
- keeps most image holds close to the calibrated 2–4s region;
- allows setup → reaction / object insert → payoff inside one semantic event;
- remains compatible with one-small-shot ≈ one-image.

## Timing status
`JINGSUI_CALIBRATED_PROVISIONAL`

These timestamps are valid for pacing/image-count planning only. Final audio will recompile timing in G4B.