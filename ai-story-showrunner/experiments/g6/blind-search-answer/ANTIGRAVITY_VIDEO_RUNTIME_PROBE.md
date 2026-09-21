# Antigravity Video Runtime Probe v0.2

## Goal

Determine what deterministic video-production backend Antigravity can actually use **in the current local environment** before we freeze the full Production Package.

Known prior:
the Owner previously used/downloaded Remotion and Hyperframe through Codex on this machine, but their locations are unknown.

Therefore the probe must **search for and reuse existing local installations/projects before considering any installation**.

## Scope

This is a capability/discovery spike, not the real episode render.

Do NOT:
- generate the full episode;
- use the real 44-frame production assets;
- freeze the final Production Package;
- change script/timing contracts;
- publish anything.

## Installation policy

### Phase A — zero installation only

During discovery and first render attempt:
- do not run `npm install`;
- do not run `pip install`;
- do not download FFmpeg;
- do not install Remotion/Hyperframe;
- do not modify global PATH;
- do not upgrade Node/package managers.

First establish what already exists.

### Phase B — if nothing usable exists

Stop and report:
`INSTALL_REQUIRED`

Include the smallest recommended install/reuse plan.

Do not install automatically in this probe.

## Phase 1 — runtime discovery

Inspect:

### Basic runtime
- shell / PowerShell
- `where.exe ffmpeg`
- `ffmpeg -version`
- `ffprobe -version`
- `node -v`
- `npm -v`
- `npx --version`
- browser/HTML rendering tools already exposed by Antigravity

### Existing Codex/local projects

Search for existing Remotion / Hyperframe resources.

Look for:
- `package.json` containing `remotion`, `@remotion/*` or `hyperframe`;
- `remotion.config.*`;
- Remotion `Root.*` / compositions;
- directories named `remotion`, `hyperframe`, `video-talkcraft`;
- existing render scripts such as `render.*`, `video.*`, `export.*`;
- existing local node_modules only when tied to a real project.

Prioritize likely Owner project locations:
- Desktop
- Documents
- Downloads
- known video-production folders
- Git/project workspaces
- folders previously created by Codex

Use available indexed/file-search tools or `rg`/`fd` if present.

Do **not** blindly crawl the entire system drive if a narrower search can answer the question.

If an existing project is found:
- report exact path;
- inspect its package scripts/dependencies;
- try to reuse it without reinstalling dependencies.

### Antigravity-native capability

Inspect whether Antigravity exposes:
- native timeline API;
- native media composition/export API;
- internal browser/video renderer;
- GUI editor automation.

Do not infer native capability merely from UI appearance.

## Capability report

For each candidate:

```text
backend
available: yes/no
exact path / detection evidence
already installed: yes/no
requires install: yes/no
can consume structured exact durations: yes/no/unknown
can place audio: yes/no/unknown
can place subtitles: yes/no/unknown
can render MP4: yes/no/unknown
reproducible from files/source: yes/no/unknown
manual GUI required: yes/no/unknown
notes
```

Candidate backends:
- FFmpeg
- existing Remotion
- existing Hyperframe
- Antigravity native timeline/runtime
- other already-installed reproducible renderer

## Phase 2 — select backend

Select the smallest **already available** deterministic backend that can satisfy:
- structured timeline input;
- still-image durations;
- audio placement;
- subtitle placement;
- MP4 export;
- reproducible rerender.

Do not prefer Remotion merely because it is Remotion.

Decision guidance:
- FFmpeg is acceptable for simple stills/audio/subtitles.
- Existing Remotion is attractive if code-driven visual motion/layout is already usable.
- Existing Hyperframe is attractive only if its local project/runtime works.
- Native Antigravity timeline is acceptable if it has a reproducible artifact/API.
- GUI-only manual editing should be classified separately.

## Phase 3 — 12-second probe

Create:

```text
video-runtime-probe/
├─ inputs/
├─ source/
├─ outputs/
│  ├─ probe_v1.mp4
│  └─ probe_v2.mp4
└─ VIDEO_RUNTIME_PROBE_REPORT.json
```

Use three simple local 1920×1080 placeholder stills:
- FRAME_A
- FRAME_B
- FRAME_C

No image model required.

Timeline v1:

```text
0–4s   FRAME_A
4–8s   FRAME_B
8–12s  FRAME_C
```

Add:
- deterministic local 12s audio; silence is acceptable;
- subtitle cues matching A/B/C.

Render:
`outputs/probe_v1.mp4`

Target:
- 1920×1080
- 30 fps
- 12s
- H.264 preferred
- audio track present

## Phase 4 — structured mutation

Using the same backend/source artifact:

```text
FRAME_B: 4–7s
FRAME_C: 7–12s
```

Change matching subtitle timing.

Render:
`outputs/probe_v2.mp4`

This must be a structured edit/rerender, not a manual rebuild.

## Phase 5 — verify

Use ffprobe or backend-equivalent technical inspection.

For both files record:
- container
- codec
- resolution
- fps
- duration
- audio presence
- render success

Also record:
- exact reusable source/project/command artifact;
- whether rerun reproduces the render;
- manual GUI interaction required;
- whether backend can later consume resolved real-TTS timing.

## Overall result

One of:

- `PASS_PROGRAMMATIC`
- `PASS_NATIVE_TIMELINE`
- `PASS_GUI_ONLY`
- `INSTALL_REQUIRED`
- `RETURN_NO_VIDEO_RUNTIME`

## Production-package recommendation

The report must explicitly answer:

> If the real episode were delivered once with semantic anchors + Runtime Timeline Resolver outputs, what should the final Production Package target?

Examples:
- FFmpeg command/script project
- existing Remotion project
- existing Hyperframe project
- Antigravity-native timeline artifact
- GUI automation package

Do not freeze the answer beyond the evidence.

## Final response

Return only:

1. selected backend/result;
2. FFmpeg availability/path;
3. Node/npm availability;
4. existing Remotion path/result;
5. existing Hyperframe path/result;
6. Antigravity-native timeline result;
7. whether anything would require installation;
8. `probe_v1.mp4` and `probe_v2.mp4` paths;
9. reusable source/project/command artifact path;
10. report path;
11. one-sentence recommended Production Package target.

Do not start real episode production.
