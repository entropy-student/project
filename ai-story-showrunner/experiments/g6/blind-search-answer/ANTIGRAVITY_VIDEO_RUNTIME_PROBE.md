# Antigravity Video Runtime Probe v0.1

## Goal

Determine **how Antigravity can actually produce deterministic video** before we freeze the full Production Package contract.

This probe is intentionally small and must answer:

1. Can Antigravity produce an MP4 from exact timeline instructions?
2. What runtime/backend does it actually use?
3. Can it call a programmable renderer such as:
   - FFmpeg;
   - Remotion;
   - Hyperframe;
   - another local CLI/library;
   - an internal timeline/rendering API?
4. If only a GUI/editor-like workflow is available, is it deterministic enough to replay from structured instructions?
5. Can it re-render after one controlled edit without rebuilding everything manually?

Do **not** infer or claim a backend without testing it.

## Scope

This is a runtime capability spike, not a real episode render.

Do NOT:
- generate the full 44-frame episode;
- build the final Production Package;
- redesign current Director/Asset contracts;
- change Production SRT;
- publish anything.

## Phase 1 — Capability discovery

Inspect the current Antigravity environment and report availability of:

- shell / command execution;
- FFmpeg / ffprobe;
- Node.js / npm;
- Remotion or ability to install/use an existing local Remotion project without redesigning the environment;
- Hyperframe or any existing local Hyperframe runtime;
- browser/HTML rendering capability;
- native/internal media timeline APIs;
- GUI editor automation, if that is the only path.

For each candidate backend report:

```text
backend
available: yes/no
how detected
can consume exact durations: yes/no/unknown
can place audio: yes/no/unknown
can place subtitles: yes/no/unknown
can render MP4: yes/no/unknown
reproducible from files: yes/no/unknown
notes
```

Do not reinstall large dependencies merely to make a backend appear available.

## Phase 2 — Choose the smallest deterministic backend

Preference is **not** “use Remotion no matter what”.

Choose the backend that is:
1. already available;
2. programmatically controllable;
3. deterministic from files;
4. able to render MP4;
5. simplest for the current still-image + narration workflow.

Examples:
- FFmpeg may be enough for stills + exact durations + audio + subtitles.
- Remotion may be preferable if later visual motion/layout logic needs React/code.
- Hyperframe may be preferable only if it is actually available and materially useful.
- An Antigravity-native timeline API is acceptable if it can export a reproducible project/instruction artifact.
- GUI-only/manual editing is a warning signal and must be reported clearly.

## Phase 3 — 12-second probe render

Create a disposable probe workspace:

```text
video-runtime-probe/
├─ inputs/
├─ source/
├─ outputs/
│  ├─ probe_v1.mp4
│  └─ probe_v2.mp4
└─ VIDEO_RUNTIME_PROBE_REPORT.json
```

Create or use three simple 1920×1080 placeholder stills:
- FRAME_A
- FRAME_B
- FRAME_C

They may be plain generated cards for the purpose of this probe.
No image model is required.

Create a 12-second deterministic timeline:

```text
0.0–4.0s   FRAME_A
4.0–8.0s   FRAME_B
8.0–12.0s  FRAME_C
```

Add:
- one audio track (a generated 12s silent WAV or another deterministic local test WAV is acceptable);
- three subtitle cues:
  - 0–4s: FRAME A
  - 4–8s: FRAME B
  - 8–12s: FRAME C

Render:
`outputs/probe_v1.mp4`

Target:
- 1920×1080
- 30 fps
- H.264 video preferred
- AAC or compatible audio
- 12 seconds

## Phase 4 — Controlled mutation test

Without changing backend/toolchain, make exactly one structured change:

```text
FRAME_B end changes:
8.0s → 7.0s

FRAME_C start changes:
8.0s → 7.0s

FRAME_C remains until 12.0s.
```

Subtitle cue timing must change correspondingly.

Render:
`outputs/probe_v2.mp4`

The purpose is to prove that the timeline can be recompiled from structured instructions rather than manually rebuilt.

## Phase 5 — Verification

Use available technical inspection such as ffprobe or equivalent.

For both videos record:
- container;
- codec;
- resolution;
- fps;
- actual duration;
- audio presence;
- render success.

Also record:
- exact command/source/project file used;
- whether the render can be reproduced by rerunning that artifact;
- whether Antigravity required manual GUI interaction;
- whether the backend supports future still-image duration control, subtitle placement and narration placement.

## Required output

Create:
`video-runtime-probe/VIDEO_RUNTIME_PROBE_REPORT.json`

Minimum structure:

```json
{
  "overall_result": "PASS_PROGRAMMATIC | PASS_NATIVE_TIMELINE | PASS_GUI_ONLY | RETURN_NO_VIDEO_RUNTIME",
  "capabilities": [],
  "selected_backend": "",
  "selection_reason": "",
  "probe_v1": {},
  "probe_v2": {},
  "reproducible": true,
  "manual_gui_required": false,
  "recommended_production_architecture": "",
  "retained_paths": []
}
```

## Decision rules

### PASS_PROGRAMMATIC
A deterministic file/code/CLI-based render path works.

### PASS_NATIVE_TIMELINE
An Antigravity-internal timeline/render API works and produces a reproducible project/instruction artifact.

### PASS_GUI_ONLY
Video can be made, but only through opaque/manual editor operations.

This is not a production-package PASS; it means the package design must explicitly account for GUI automation limitations.

### RETURN_NO_VIDEO_RUNTIME
Antigravity cannot produce/export video in the current environment.

## Final response

Return only:

1. selected backend;
2. overall result;
3. whether shell/FFmpeg/Remotion/Hyperframe/native timeline were available;
4. probe_v1 and probe_v2 paths;
5. source/project/command artifact path;
6. report path;
7. one-sentence recommendation for how the future Production Package should target Antigravity.

Do not start real episode video production after the probe.
