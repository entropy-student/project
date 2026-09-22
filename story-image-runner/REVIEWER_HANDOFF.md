# Story Image Runner — REVIEWER HANDOFF

> Role: Reviewer / Architect / Gatekeeper
> Source of truth: `PROJECT_RECORD.md`

## Current decision

Owner corrected the project goal on 2026-09-22:

> Final product is a plugin/tool like the referenced video whose core purpose is batch image generation and automatic download.

Therefore the former video-pipeline / Remotion roadmap is superseded.

Current state:

```text
P0_PROJECT_INTAKE_GOVERNANCE = PASS
P0A_PLUGIN_ARCHITECTURE_SAFETY_FREEZE = PASS
G1_PLUGIN_CORE_STATIC_IMPLEMENTATION = PASS
G1_5_BROWSER_LOAD_DRY_RUN = NEXT
```

## Implementation

Branch:

`story-image-runner/plugin-v1`

The extension is now pure MV3 and does not require a Local Bridge for V1.

Implemented:

- side-panel batch UI;
- TXT / JSON prompt import;
- local persistent queue;
- Start / Pause / Stop / Retry;
- deterministic filenames;
- owned ChatGPT tab;
- prompt submit adapter;
- fresh-image detection;
- automatic download;
- new-chat-every-N;
- typed failures;
- rate-limit pause;
- Live mode safety switch.

## Independent static checks

```text
JavaScript syntax checks = PASS
npm test = 7/7 PASS
extension static check = PASS
real image generations during implementation = 0
```

## Current Owner checkpoint

Load the unpacked extension in Chrome / Edge with **Live generation OFF**.

If that passes, Reviewer can authorize exactly one real image Canary.

No Codex work is currently required unless the browser-runtime test returns a concrete defect.
