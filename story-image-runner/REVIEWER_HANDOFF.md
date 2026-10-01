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
G1_5_BROWSER_LOAD_DRY_RUN = PARTIAL OWNER EVIDENCE
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
npm test = 11/11 PASS
extension static check = PASS
real image generations during implementation = 0
```

## Current Owner checkpoint

Load the unpacked extension in Chrome / Edge with **Live generation OFF**.

If that passes, Reviewer can authorize exactly one real image Canary.

No Codex work is currently required unless the browser-runtime test returns a concrete defect.


## Browser evidence now observed

Owner-provided runtime evidence:

```text
background runtime = 0.1.2 observed during live test
Storage = PASS
queue write/read = PASS
queue observed = 7 total / 6 pending
Live = ON
ChatGPT content-script = READY
automatic task navigation = OBSERVED
final generated image completion = NOT YET VERIFIED
automatic download = NOT YET VERIFIED
```

The 7-job queue came from the older per-line parsing behavior and must not be treated as intended V0.1.3 grouping evidence.

V0.1.3 has since changed prompt import behavior to:
```text
single textarea = 1 prompt by default
optional blank-line split
optional per-line split
queue preview
MAX_QUEUE_JOBS = 500
```

## Deferred backlog

Canonical detail:
`docs/CAPABILITY_BOUNDARIES_AND_DEFERRED_BACKLOG.md`

Deferred and not currently authorized:
```text
multiple images/copies per prompt
reference-image attachment from repository/URL/local source
binary image-format validation / normalization
interruption reconciliation before retry
long-run stress validation
flexible output-location workflow
```

Current action: documentation only. Resume controlled Canary when Owner requests.
