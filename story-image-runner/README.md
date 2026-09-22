# Story Image Runner

Chrome / Edge batch image-generation plugin for ChatGPT.

## Final product goal

```text
Paste/import prompts
→ queue them
→ use the user's signed-in ChatGPT web session
→ generate images one by one
→ automatically download and name them
```

Video assembly is out of scope.

## Current status

```text
G1_PLUGIN_CORE_STATIC_IMPLEMENTATION = PASS
G1_5_BROWSER_LOAD_DRY_RUN = NEXT
G2_SINGLE_REAL_IMAGE_CANARY = PENDING
G3_BOUNDED_10_IMAGE_BATCH = PENDING
G4_BULK_USABILITY_HARDENING = PENDING
G5_PLUGIN_RELEASE_PACKAGE = PENDING
```

Implementation branch: `story-image-runner/plugin-v1`.

## Implemented

- MV3 Chrome/Edge extension
- side-panel UI
- TXT / JSON import
- persistent queue
- start / pause / stop / retry
- deterministic filenames
- background ChatGPT tab
- prompt-submit DOM adapter
- fresh-image detection
- automatic download with fallback
- rate-limit pause
- Live generation safety switch

Live generation defaults OFF and resets OFF after browser restart.

## Install for browser test

1. Download/extract the extension package.
2. Open `chrome://extensions/` or `edge://extensions/`.
3. Enable Developer mode.
4. Click Load unpacked.
5. Select the `extension/` folder.
6. Keep ChatGPT signed in in the same browser profile.
7. Click the extension icon to open the side panel.

First test must keep Live generation OFF.
