# Story Image Runner — PROJECT RECORD

> Long-term project truth. Reviewer / Executor should read this before consequential work.

Last updated: 2026-09-22

## 1. Final objective

Build a reusable local automation component that converts structured video shot jobs into reliably named image assets using the user's signed-in ChatGPT browser session, with deterministic manifests, bounded retries, safe stop/resume, and later integration into the existing story-video production pipeline.

Target flow:

```text
Topic / Script / SRT
→ Shotbook
→ structured shot jobs
→ local queue
→ Chromium extension
→ owned background ChatGPT tab
→ generated image detection
→ deterministic export
→ per-shot manifest
→ visual QA / regeneration
→ video assembly
```

## 2. Governance

Canonical Governance source:

```text
Repository: entropy-student/spike.skill
Path: /vps-project-governance
Core baseline: v0.1.6
```

Project repository:

```text
entropy-student/project/story-image-runner/
```

Role boundary:

- Owner: product direction, account/identity authorization, first real browser canary, consequential actions.
- Reviewer: architecture, Gate definition, acceptance, PASS / RETURN, project truth.
- Executor/Codex: implementation, tests, evidence, PASS_CANDIDATE / RETURN only.

`PASS_CANDIDATE != PASS`.

## 3. Current truth

```text
P0_PROJECT_INTAKE_GOVERNANCE=PASS
P0A_ARCHITECTURE_SAFETY_FREEZE=PASS
G1_LOCAL_PLUMBING_DRY_RUN=NEXT_RELEASED_TO_EXECUTOR
G1_5_SINGLE_IMAGE_CANARY=PENDING
G2_BOUNDED_10_IMAGE_BATCH=PENDING
G3_REFERENCE_ASPECT_RESUME=PENDING
G4_VIDEO_PROJECT_ADAPTER=PENDING
G5_VISUAL_QA_REGEN=PENDING
G6_REMOTION_HANDOFF=PENDING
```

No runtime code or real browser-generation evidence exists yet.

## 4. Frozen architecture direction

V1 architecture:

```text
CLI / jobs.json
    ↓
Local Bridge (127.0.0.1 only)
    ↓
Durable local queue / state
    ↓
Chromium MV3 extension
    ↓
owned background ChatGPT tab
    ↓
content-script DOM adapter
    ↓
fresh image detection
    ↓
download/export
    ↓
manifest + checksum
```

Principles:

1. No OpenAI API key is required for the web-session path.
2. Never export or persist ChatGPT cookies/session tokens.
3. DOM selectors are an adapter, not business logic.
4. Queue/job state must survive an extension/service-worker restart where practical.
5. Every shot has a stable `job_id` / `shot_id`.
6. Output naming is deterministic.
7. Duplicate prevention is explicit.
8. Concurrency = 1 until later Reviewer approval.
9. Fail closed on auth, rate limit, ambiguous fresh-image detection, unexpected ChatGPT UI state, or path validation failure.
10. Real generation is impossible while `SAFE_MODE=true`.

## 5. Output contract

Initial job identity:

```text
project_id + shot_id
```

Initial output naming:

```text
<project_id>/<shot_id>.png
<project_id>/<shot_id>.manifest.json
```

A manifest must distinguish at least:

```text
QUEUED
VALIDATED
SUBMITTED
GENERATING
DOWNLOADED
VERIFIED
FAILED
ABORTED
```

Do not treat `DOWNLOADED` as automatically equivalent to visually approved.

## 6. Initial error taxonomy

At minimum:

```text
NOT_READY
SAFE_MODE_BLOCKED
NOT_LOGGED_IN
UI_SELECTOR_MISSING
SUBMIT_FAILED
RATE_LIMITED
REFUSED
TIMEOUT
NO_FRESH_IMAGE
MULTIPLE_AMBIGUOUS_IMAGES
DOWNLOAD_FAILED
PATH_REJECTED
DUPLICATE_JOB
ABORTED
UNKNOWN
```

Retry policy is typed. Auth/rate-limit/ambiguous-state failures must not enter blind retry loops.

## 7. Current Gate

`G1_LOCAL_PLUMBING_DRY_RUN`

G1 intentionally consumes zero image quota.

G1 builds only:

- local bridge;
- queue/state model;
- CLI;
- Chromium extension shell;
- extension ↔ bridge readiness heartbeat;
- job schema validation;
- deterministic output-path resolution;
- abort path;
- central `SAFE_MODE`;
- non-generating tests.

No real prompt submit is authorized in G1.

Contract:

`docs/G1_EXECUTION_CONTRACT.md`

## 8. Third-party / licensing boundary

Observable behavior from public projects can inform architecture.

One reference project, `fortun8te/simpletics-imagegen`, visibly demonstrates a local bridge + Chrome extension + background-tab + manifest approach, but no license was visible in the repository root during the 2026-09-22 review. Therefore its code is **not** an implementation source for this project unless a compatible license is later verified.

A separate public project, `yuyou-dev/ChatGPT-Bridge`, states an MIT license. It may be used only if the Executor explicitly records the reused component/license/notice. Default G1 remains clean-room.

## 9. Known unknowns

- Exact current ChatGPT DOM selectors: UNKNOWN until live canary preparation.
- Stable original-image extraction strategy across current ChatGPT UI: UNKNOWN until G1.5.
- Browser choice for first real canary: Chromium-compatible Chrome/Edge supported in design; exact owner runtime confirmed at canary.
- Current ChatGPT account image-generation quota behavior: runtime-dependent; do not hard-code.
- Whether final pipeline should keep files under browser Downloads or move through the bridge into the video project workspace: decide after G2 evidence.

## 10. Do not do yet

Until the relevant Gate is released:

- no mass generation;
- no concurrency > 1;
- no CAPTCHA/anti-bot bypass;
- no cookie/token extraction;
- no stealth or fingerprint-evasion work;
- no account rotation;
- no quota bypass;
- no automatic paid/API fallback;
- no VPS deployment;
- no Remotion integration;
- no auto-regeneration loop.

## 11. Next action

Executor reads `docs/G1_EXECUTION_CONTRACT.md`, implements G1 locally, writes actual facts to `EXECUTION_EVIDENCE.md` and `EXECUTOR_HANDOFF.md`, returns a structured receipt, and stops at Reviewer.
