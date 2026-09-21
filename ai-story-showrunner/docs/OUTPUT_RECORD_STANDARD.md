# Project Output Record Standard v0.1

Date: 2026-09-22

Status:
`CANONICAL / SIMPLE`

## Purpose

Use the project repository as the persistent production-output ledger without turning it into a heavy artifact-management system.

The rule is intentionally small:

> Every meaningful production run gets one run folder and one `RUN_RECORD.json`.  
> Every episode gets one `INDEX.md` that points to the latest accepted run for each stage.

## Structure

```text
ai-story-showrunner/
└─ outputs/
   └─ <episode_id>/
      ├─ INDEX.md
      └─ runs/
         └─ <run_id>/
            ├─ RUN_RECORD.json
            └─ <retained outputs>
```

## run_id

Recommended:

`YYYYMMDD-HHMM-<stage>-rN`

Example:

`20260922-0215-tts-r1`

Do not depend on run_id ordering as the only current-truth mechanism; `INDEX.md` explicitly marks accepted runs.

## RUN_RECORD.json — required fields

```json
{
  "run_id": "",
  "episode_id": "",
  "stage": "",
  "status": "PASS | PASS_WITH_MINOR | RETURN | HOLD | BLOCKED",
  "created_at": "",
  "inputs": [],
  "skill_version": "",
  "profiles": [],
  "executor": "",
  "backend": "",
  "outputs": [],
  "return_code": null,
  "notes": ""
}
```

Keep it small. Add stage-specific fields only when they materially help reproducibility.

## INDEX.md

One page per episode.

It should answer:
- current accepted run for each stage;
- where its artifacts live;
- which stage is next;
- which run was superseded.

Example:

```text
Timing        → run_001 PASS
TTS           → run_002 PASS
Video Probe   → run_003 PASS_PROGRAMMATIC
Images        → pending
Final Video   → pending
```

## What to retain

Retain:
- accepted/failing evidence needed for diagnosis;
- final SRT/timeline;
- production master audio;
- selected/generated production images;
- renderer source/project used for an accepted render;
- final video;
- compact execution report.

Do not retain by default:
- disposable caches;
- package-manager cache;
- duplicate intermediates;
- debug logs with no diagnostic value;
- regenerated identical assets.

## Relationship to experiments/

`experiments/` = validation and R&D evidence.

`outputs/` = actual retained production runs.

A probe may begin in `experiments/`. Once a run becomes a real accepted production artifact, record it under `outputs/`.

## Current truth

`CURRENT_STATUS.json` tracks project state.

`outputs/<episode_id>/INDEX.md` tracks accepted production artifacts for that episode.

`RUN_RECORD.json` tracks one execution.
