# Story Image Runner — PROJECT RECORD

> Long-term project truth. Reviewer / Executor should read this before consequential work.

Last updated: 2026-09-22

## 1. Final objective

Build a reusable Chrome / Edge extension whose complete product purpose is:

```text
paste/import many prompts
→ queue them
→ use the user's already signed-in ChatGPT web session
→ generate images one by one
→ automatically download and name the images
→ show progress / failures
→ pause / resume / retry
```

Video production, SRT, Shotbook, visual QA, and Remotion are **not** part of the core project goal. Other projects may consume this plugin's downloaded images later, but this project ends at reliable batch image generation and export.

## 2. Product shape

Canonical V1 product:

```text
Chrome / Edge MV3 extension
  ├─ side-panel UI
  ├─ persistent local queue
  ├─ owned ChatGPT background tab
  ├─ DOM automation adapter
  ├─ fresh-image detection
  ├─ deterministic download naming
  └─ typed status / failure handling
```

A local Bridge is no longer required for V1. Browser extension storage and the downloads API are sufficient for the primary use case.

## 3. Current truth

```text
P0_PROJECT_INTAKE_GOVERNANCE=PASS
P0A_PLUGIN_ARCHITECTURE_SAFETY_FREEZE=PASS
G1_PLUGIN_CORE_STATIC_IMPLEMENTATION=PASS
G1_5_BROWSER_LOAD_DRY_RUN=PARTIAL_OWNER_EVIDENCE
G2_SINGLE_REAL_IMAGE_CANARY=PENDING_CONTROLLED_RETEST
G3_BOUNDED_10_IMAGE_BATCH=PENDING
G4_BULK_USABILITY_HARDENING=PENDING
G5_PLUGIN_RELEASE_PACKAGE=PENDING
```

Implementation branch:

`story-image-runner/plugin-v1`

Implemented V1 components:

- MV3 manifest;
- side-panel UI;
- TXT / JSON import;
- persistent queue;
- start / pause / stop;
- failed-item retry;
- deterministic project/shot naming;
- owned ChatGPT background tab;
- ChatGPT composer/send DOM adapter;
- fresh generated-image detection;
- direct download + UI-download fallback;
- per-job typed failure state;
- rate-limit pause;
- Live-generation safety switch.

## 4. Safety baseline

- Live generation defaults OFF.
- Live generation resets OFF after browser restart.
- No cookie, password, token, or browser-profile export.
- No CAPTCHA / anti-bot bypass.
- No account rotation.
- No quota bypass.
- Concurrency = 1.
- Ambiguous submitted failures pause rather than blindly regenerate.

## 5. Static evidence

Local independent checks on 2026-09-22:

```text
node --check extension/background.js = PASS
node --check extension/content.js = PASS
node --check extension/sidepanel.js = PASS
node --check extension/shared.js = PASS
npm test = 11/11 PASS
npm run check = PASS
```

Packaged extension SHA256:

`5192d2a24fa9dce856af7ebdc89d7a9410164994846d96695e1c3690d7ee1860`

No real ChatGPT image generation was performed during static implementation.

## 6. Remaining uncertainty

Only browser-runtime behavior remains unproven:

- whether current ChatGPT DOM selectors match the Owner's live UI;
- whether the current generated-image DOM structure is detected correctly;
- whether direct download works for the current image URL form or requires the UI-download fallback;
- exact browser-specific behavior in the Owner's Chrome / Edge version.

These must be proven by a local browser load dry run and then one real image canary.

## 7. Next action

Owner loads the unpacked extension in the same Chrome / Edge profile where ChatGPT is already signed in.

First checkpoint is **browser load only** with Live generation OFF.

No Codex handoff is required unless the browser test exposes a defect.


## 8. Current capability boundaries

V0.1.3 current behavior:

```text
1 job → 1 prompt submission → 1 expected generated image
MAX_QUEUE_JOBS = 500
CONCURRENCY = 1
DEFAULT_IMPORT_MODE = whole textarea is one prompt
```

The 500-job limit is a plugin queue limit, not a proven promise that one browser/account can finish 500 image generations continuously.

Owner runtime observations now prove that the side panel, Storage, queue write/read and ChatGPT content-script connection work. Automatic task navigation also started in the browser. Final generated-image detection and automatic download are still not formally verified.

Detailed boundaries and deferred items:
`docs/CAPABILITY_BOUNDARIES_AND_DEFERRED_BACKLOG.md`

Recorded but not yet authorized for implementation:
- multiple images/copies per prompt;
- true reference-image attachment from repository/URL/local source;
- actual image MIME validation / optional true-PNG normalization;
- interruption reconciliation before retry;
- long-run batch stress validation;
- optional more flexible output-location workflow.

## 9. Current next action

No new feature implementation is authorized by the latest Owner instruction.

Documentation is current. Resume with one controlled image Canary only when Owner chooses to continue validation.
