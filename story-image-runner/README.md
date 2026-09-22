# Story Image Runner

A governed local browser-automation project for turning structured video shot prompts into image-generation jobs through a signed-in ChatGPT web session, then exporting deterministic assets for downstream video production.

## Goal

```text
Script / SRT
→ Shotbook
→ jobs.json
→ Story Image Runner
→ ChatGPT image generation
→ deterministic image files + manifests
→ later: visual QA / regeneration
→ later: Remotion or other video assembly
```

This project is intentionally **not** an OpenAI API wrapper. The planned web path uses a user-controlled signed-in Chromium browser session and a local bridge.

## Current status

```text
P0_PROJECT_INTAKE_GOVERNANCE = PASS
P0A_ARCHITECTURE_SAFETY_FREEZE = PASS
G1_LOCAL_PLUMBING_DRY_RUN = RELEASED_TO_EXECUTOR
G1_5_SINGLE_IMAGE_CANARY = PENDING
G2_BOUNDED_10_IMAGE_BATCH = PENDING
G3_REFERENCE_ASPECT_RESUME = PENDING
G4_VIDEO_PROJECT_ADAPTER = PENDING
G5_VISUAL_QA_REGEN = PENDING
G6_REMOTION_HANDOFF = PENDING
```

Read first:

1. `PROJECT_RECORD.md`
2. `CURRENT_STATUS.json`
3. `REVIEWER_HANDOFF.md`
4. `docs/G1_EXECUTION_CONTRACT.md`
5. `docs/ARCHITECTURE.md`
6. `docs/HANDOFF_PROTOCOL.md`

## Safety baseline

- `SAFE_MODE=true` by default.
- G1 must not submit a real ChatGPT prompt or consume image quota.
- Local bridge must bind to `127.0.0.1`, not `0.0.0.0`.
- Browser cookies/session credentials must never be copied into the repository, logs, manifests, or chat.
- First real generation is a separately authorized single-image canary.
- Concurrency starts at 1.
- Rate-limit / auth / ambiguous-result failures fail closed; no blind retry loops.

## Third-party reference policy

Public projects may be studied for observable architecture and behavior. Do not copy code from a repository unless its license has been verified as compatible and attribution/notice obligations are satisfied.

The initial implementation should be clean-room from the contracts in this repository.
