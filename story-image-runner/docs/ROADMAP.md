# Story Image Runner — ROADMAP

## Final product

```text
Prompt list / JSON / TXT
→ Chrome / Edge extension queue
→ signed-in ChatGPT
→ sequential image generation
→ automatic image downloads
→ deterministic filenames
→ progress / pause / retry
```

The project ends at reliable bulk image generation. Video assembly is out of scope.

## Current map

```text
P0    Project Intake + Governance          PASS
P0A   Plugin Architecture + Safety         PASS
G1    Plugin Core Static Implementation    PASS
G1.5  Browser Load + Dry Run               PARTIAL OWNER EVIDENCE
G2    Single Real Image Canary             PENDING
G3    Bounded 10-Image Batch               PENDING
G4    Bulk Usability Hardening             PENDING
G5    Plugin Release Package               PENDING
```

## G1 — Plugin Core Static Implementation — PASS

Delivered:

- Chrome / Edge MV3 extension;
- side panel;
- prompt paste + JSON/TXT import;
- persistent queue;
- start / pause / stop / retry;
- new-chat-every-N setting;
- aspect instruction;
- background ChatGPT tab ownership;
- DOM prompt submission adapter;
- fresh-image detection;
- automatic downloads;
- deterministic file naming;
- Live generation OFF by default;
- typed error handling.

Static evidence: 11/11 tests PASS and extension static check PASS.

## G1.5 — Browser Load + Dry Run

Load unpacked extension with Live generation OFF.

Acceptance:

- extension loads without manifest/service-worker errors;
- toolbar click opens side panel;
- prompts can be imported;
- queue persists;
- Live OFF blocks generation;
- signed-in ChatGPT tab readiness is visible to the extension;
- no image generation occurs.

## G2 — Single Real Image Canary

Enable Live generation for exactly one simple task.

Acceptance:

- exactly one prompt submitted;
- exactly one fresh generated image selected;
- exactly one image downloaded;
- deterministic filename;
- queue marks the task completed;
- no unrelated browser download renamed;
- Live generation turned OFF afterward.

## G3 — Bounded 10-Image Batch

Run 10 prompts sequentially.

Acceptance:

- 10 intended jobs accounted for;
- completed/failed cardinality is exact;
- no duplicate silent submissions;
- pause/resume behaves correctly;
- rate limit pauses the run;
- failures are visible and retryable.

## G4 — Bulk Usability Hardening

Harden for dozens/hundreds of queued tasks:

- selector fallbacks from real evidence;
- long-run service-worker resilience;
- clearer progress;
- download fallback reliability;
- queue export/import if needed;
- optional per-job custom filenames;
- optional reference-image support only if still wanted.

## G5 — Plugin Release Package

Freeze V1:

- installable extension folder / ZIP;
- user instructions;
- known limitations;
- version;
- checksum;
- release acceptance.


## Deferred backlog — recorded, not scheduled

The following future capabilities are documented but are not part of the currently authorized work:

```text
D1  copies=N / multiple images from one prompt
D2  real reference-image attachment from GitHub/URL/local source
D3  true image-format validation and optional PNG normalization
D4  interrupted-job reconciliation before retry
D5  long-run batch stress validation: 10 → 50 → 100+
D6  optional flexible output-location workflow
```

See `CAPABILITY_BOUNDARIES_AND_DEFERRED_BACKLOG.md` for exact current behavior and limitations.
