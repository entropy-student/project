# Story Image Runner — ROADMAP

## Current map

```text
P0    Project Intake + Governance              PASS
P0A   Architecture + Safety Freeze             PASS
G1    Local Plumbing + Dry Run                 NEXT / EXECUTOR READY
G1.5  Single Real Image Canary                 PENDING
G2    Bounded 10-Image Batch                   PENDING
G3    References + Aspect + Resume             PENDING
G4    Video Project Adapter                    PENDING
G5    Visual QA + Controlled Regeneration      PENDING
G6    Remotion / Video Assembly Handoff        PENDING
```

## G1 — Local Plumbing + Dry Run

Build bridge, CLI, queue, extension shell, heartbeat, validation, SAFE_MODE, abort, tests.

Real ChatGPT submission: forbidden.

Acceptance: local plumbing is demonstrably safe and deterministic without image quota use.

## G1.5 — Single Real Image Canary

One prompt, one output, one background tab, one expected image.

Acceptance must prove:

- explicit live authorization;
- account is already signed in by Owner;
- no cookie export;
- exactly one submitted job;
- exactly one fresh generated image selected;
- deterministic output;
- manifest;
- checksum/dimensions;
- non-target generation delta = 0;
- safe state restored afterward.

## G2 — Bounded 10-Image Batch

Use 10 deliberately simple independent jobs.

Concurrency remains 1 unless Reviewer changes it.

Must prove:

- exact-cardinality outputs;
- no duplicate shot IDs;
- no overwrite without explicit policy;
- typed failure behavior;
- abort and resume;
- rate-limit stops rather than hammering;
- deterministic manifests.

## G3 — References + Aspect + Resume

Add:

- reference-image attachment;
- supported aspect ratios;
- robust restart/resume;
- retry budget by error type;
- browser-tab lifecycle cleanup.

## G4 — Video Project Adapter

Input becomes video-production data:

```text
project_id
shot_id
start/end
prompt
aspect
refs
character identity metadata
```

Output becomes deterministic shot assets that downstream tooling can consume without manual renaming.

## G5 — Visual QA + Controlled Regeneration

Add a separate QA state:

```text
GENERATED != APPROVED
```

QA can flag:

- character mismatch;
- wrong composition;
- unwanted text;
- wrong subject count;
- missing required prop;
- aspect mismatch.

Regeneration is bounded and auditable; no unbounded self-loop.

## G6 — Video Assembly Handoff

Emit a stable manifest for Remotion or another renderer:

```text
shot_id → file → start/end → duration → approval state
```

Rendering remains a separate subsystem.
