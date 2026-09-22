# G1 Execution Contract — Local Plumbing + Dry Run

Gate:

`G1_LOCAL_PLUMBING_DRY_RUN`

Status:

`RELEASED_TO_EXECUTOR`

## 1. Goal

Build and test the local plumbing required for browser-driven batch image generation **without submitting a real ChatGPT prompt and without consuming image quota**.

## 2. Mandatory preflight

Executor must read:

- `PROJECT_RECORD.md`
- `CURRENT_STATUS.json`
- `REVIEWER_HANDOFF.md`
- `docs/ARCHITECTURE.md`
- `docs/HANDOFF_PROTOCOL.md`
- `schemas/job.schema.json`
- canonical GitHub Governance latest for `vps-project-governance`

Record:

- local workspace root;
- OS;
- Node version;
- browser(s) detected, if any;
- whether `story-image-runner` source already existed locally;
- exact Git starting point.

If existing source is found and provenance is ambiguous, do not overwrite it. Return:

`RETURN_G1_EXISTING_SOURCE_PROVENANCE_UNRESOLVED`

## 3. Authorized implementation scope

Create a minimal source tree equivalent to:

```text
story-image-runner/
  package.json
  src/
    bridge/
    cli/
    shared/
  extension/
    manifest.json
    background.js
    content.js
  tests/
  examples/
```

Exact filenames can vary if the architecture remains clear.

### Bridge

Implement:

- bind `127.0.0.1` only;
- default port `8787`;
- `GET /health`;
- job enqueue endpoint;
- job/status endpoint;
- abort endpoint;
- extension heartbeat/readiness;
- central `SAFE_MODE=true` default;
- durable-enough local state for G1 tests;
- deterministic validation/error objects.

### CLI

Implement at least:

```text
--health
--dry-run --jobs <path>
--status
--abort
```

No live-generation flag is authorized in G1.

### Extension shell

Implement:

- MV3 manifest;
- permissions restricted to what G1/G1.5 reasonably needs;
- host access limited to ChatGPT + localhost bridge as required;
- heartbeat/polling;
- content script presence/readiness;
- central safe-mode check before any future generation action.

It may read whether a ChatGPT page is present/ready, but must not submit content.

## 4. Required negative tests

At minimum prove:

1. invalid schema rejected;
2. empty prompt rejected;
3. duplicate `project_id + shot_id` rejected;
4. `../` path traversal rejected;
5. absolute output path rejected unless explicitly allowed by a bounded config root;
6. bridge is not listening on `0.0.0.0`;
7. safe mode blocks any mocked submit action;
8. stale extension heartbeat reports not ready;
9. abort changes queued/in-flight dry-run state safely;
10. restart does not promote incomplete job to success;
11. malformed JSON does not crash the bridge;
12. no secret/session/cookie fields are emitted in status/manifest logs.

## 5. Test fixture

Use `examples/jobs.example.json`.

G1 dry-run should validate all 10 example jobs and resolve their deterministic names without generating them.

Expected conceptual outputs:

```text
demo-mcp/S001.png
...
demo-mcp/S010.png
```

No actual PNG needs to exist in G1.

## 6. Forbidden in G1

- clicking ChatGPT send;
- pressing Enter in a way that submits a ChatGPT prompt;
- real image generation;
- reference upload;
- scraping/copying browser cookies;
- DevTools extraction of auth/session tokens;
- captcha/anti-bot bypass;
- stealth/fingerprint evasion;
- account rotation;
- concurrency > 1;
- arbitrary broad Chrome permissions;
- writing outside project-local test temp or configured bounded output root;
- VPS/network deployment.

## 7. Evidence required

Write actual facts to:

- `EXECUTION_EVIDENCE.md`
- `EXECUTOR_HANDOFF.md`

Evidence must include:

- files changed;
- test commands;
- test counts/results;
- loopback bind evidence;
- SAFE_MODE positive + negative proof;
- example 10-job dry-run result;
- no-real-generation statement backed by implementation/test boundary;
- known limitations;
- cleanup result.

## 8. Exit conditions

Success:

```text
GATE=G1_LOCAL_PLUMBING_DRY_RUN
RESULT=PASS_CANDIDATE_G1_LOCAL_PLUMBING_DRY_RUN
OWNER_ACTION=NONE
NEXT=STOP_AT_REVIEWER
```

Failures must be precise, e.g.:

```text
RETURN_G1_TEST_FAILURE
RETURN_G1_SAFE_MODE_BYPASS
RETURN_G1_LOOPBACK_BOUNDARY_FAILURE
RETURN_G1_EXISTING_SOURCE_PROVENANCE_UNRESOLVED
RETURN_G1_SECRET_EXPOSURE_RISK
```

Do not enter G1.5 automatically.
