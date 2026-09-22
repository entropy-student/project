# Story Image Runner — Architecture

## 1. Components

### A. CLI

Responsibilities:

- load one job or a jobs file;
- validate against schema;
- normalize IDs and output names;
- submit to local bridge;
- query status;
- abort;
- dry-run;
- emit machine-readable result codes.

The CLI never reads browser cookies.

### B. Local Bridge

Default:

```text
127.0.0.1:8787
```

Responsibilities:

- local-only HTTP API;
- queue/state;
- duplicate prevention;
- extension heartbeat/readiness;
- safe-mode state;
- output bookkeeping;
- manifest writing;
- abort signal;
- later: moving/exporting downloaded files.

Do not bind to a LAN/public interface in V1.

### C. Chromium MV3 Extension

Responsibilities:

- connect/poll local bridge;
- own browser tabs created for image generation;
- later: inject ChatGPT DOM adapter;
- later: upload reference assets through browser UI;
- later: detect fresh generated image;
- later: export/download result;
- close/reclaim owned tabs.

It must not inspect or mutate unrelated tabs.

### D. ChatGPT DOM Adapter

Not implemented in G1.

Keep all selectors and UI-specific logic behind one adapter boundary so ChatGPT UI changes do not contaminate queue/business state.

Expected later operations:

```text
readiness
→ ensure composer
→ attach refs
→ input prompt
→ submit once
→ detect generation state
→ detect fresh image set
→ validate cardinality
→ export selected image
```

### E. Manifest

Per-shot manifest records metadata, never account secrets.

Suggested shape:

```json
{
  "schema_version": 1,
  "project_id": "demo",
  "shot_id": "S001",
  "status": "VERIFIED",
  "attempt": 1,
  "aspect": "16:9",
  "output_file": "S001.png",
  "sha256": "<hex>",
  "width": 0,
  "height": 0,
  "error_code": null,
  "started_at": "<iso>",
  "finished_at": "<iso>"
}
```

Prompt text may remain in the local job source. Shared evidence should avoid unnecessary prompt/session/chat URL leakage.

## 2. State machine

```text
QUEUED
  ↓
VALIDATED
  ↓
READY
  ↓
SUBMITTED
  ↓
GENERATING
  ↓
DOWNLOADED
  ↓
VERIFIED
```

Failure exits:

```text
FAILED
ABORTED
```

A restart must never infer `VERIFIED` from file existence alone.

## 3. Idempotency

Canonical identity:

```text
(project_id, shot_id)
```

Rules:

- duplicate active identity → reject;
- existing verified output → default skip/reject, not silent overwrite;
- explicit regeneration later increments attempt and preserves prior manifest/history;
- retry must be tied to the same logical shot but a new attempt identifier.

## 4. Safe mode

`SAFE_MODE=true` is the default and must be enforced centrally by the bridge and again at the extension action boundary.

While safe mode is true:

- queue validation allowed;
- health/readiness allowed;
- dry-run allowed;
- no ChatGPT submit action;
- no reference upload;
- no generation-triggering click/keypress;
- no file treated as newly generated.

## 5. Rate-limit behavior

If ChatGPT indicates a rate limit or generation unavailability:

```text
mark typed failure
→ stop affected execution
→ preserve queue state
→ no blind rapid retry
→ return to Reviewer / later policy
```

## 6. Download/export strategy

G1 does not finalize the browser download mechanism.

G1.5/G2 should compare:

1. extension/browser download into a bounded Downloads subtree; versus
2. authenticated in-page fetch → extension/bridge transfer → local file writer.

Decision criteria:

- original asset quality;
- reliability;
- memory overhead;
- browser security constraints;
- deterministic output path;
- ease of restart/resume.

No arbitrary filesystem path supplied by a job may escape the configured output root.

## 7. Privacy

Forbidden persistence:

- cookies;
- session tokens;
- Authorization headers;
- password material;
- private browser profile data.

The browser owns its login state.

## 8. Browser support

Architecture target: Chromium MV3.

Initial compatibility target:

- Google Chrome;
- Microsoft Edge.

Browser-specific differences must stay behind adapter/config boundaries.
