# Reference Library Production Workflow

Status: Owner-directed project production workflow, 2026-09-28. Apply with `assets/reference-library/README.md`, the current G4/G5 contracts, the episode's named Owner override, and `OUTPUT_RECORD_STANDARD.md`. This document defines a reusable procedure; episode IDs below are examples only.

## 1. Three records, one complete image

- For a published run, `outputs/<episode>/runs/<run>/frames/` holds every final playback frame, including accepted frames with minor deviations. A Visual Beat always resolves to one complete raster frame. Two Beats may intentionally point to byte-identical full frames.
- `assets/registry/assets.jsonl` records production history: execution mode, source, QA, run, and storage state. A production record is not automatically a reusable library asset.
- `assets/reference-library/catalog.jsonl` is the searchable reuse index. After final Owner review, catalog every valid unique final image rather than applying a numeric selection quota. A catalog record can point to the existing `outputs/` binary; do not copy every image into `assets/reference-library/images/`. Rejected candidates stay in run audit records. A replaced, defective image may retain a retired catalog record for provenance but can never be `READY`.

The canonical character turnaround and Style Bible remain higher-priority references. An episode image never replaces character identity truth.

A local, ZIP-only handoff is a transport snapshot, not a published `outputs/` run or a repository image path. It may contain every playback frame, source/provenance map, QA, and catalog draft while loose local image attempts are removed after archive verification. Keep the episode `INDEX.md` and production Registry truthful: mark removed local paths unavailable or superseded and point the current local handoff to the ZIP plus its SHA-256. Before cross-run reuse, publish individual complete frame binaries under the project's `outputs/` convention (or a curated canonical path), verify hashes, and then update the catalog's repository `file_path`. Do not label a ZIP member as a GitHub-readable frame path.

## 2. Mode is a use of an image, not an image type

One complete image may be permitted for several `reuse_modes`. For a particular target Beat, choose exactly one primary execution decision:

1. `EXACT_FRAME`: use an identical complete binary only when viewer meaning, event/action, character identity, prop count, physical viewpoint, scene and temporal state, exact text, and withheld/reveal state all match. Log source asset ID and hash. The playback manifest may map multiple Beat IDs to one asset ID; each Beat still has a complete frame path.
2. `DERIVE_EDIT_SOURCE`: select exactly one accepted complete base image. Keep POV family, camera side, visible subjects, primary geometry, character identity and UI shell compatible; prescribe one meaningful state delta, immutable elements, and a declared fallback. The edit returns a new complete image. Canonical identity reference still applies.
3. `REFERENCE`: specify the allowed aspects (for example pose, expression, gaze, scene layout, composition, or UI shell) and generate a new complete image. Several supporting references may be listed, with their roles distinct from the one primary edit source.
4. `GENERATE` without a library match: use canonical episode references and the locked execution row.

The order above is a compatibility check, not a cost quota. Do not use an exact or editable candidate merely because it is cheaper when it changes the Beat's meaning or viewpoint. Never crop and assemble multiple images into a final frame.

## 3. Agent A: search and lock the target decision

For each locked Visual Beat, Agent A reads the current catalog, filters `READY` records by scope, and opens promising binaries. It records the target's observable event and viewer meaning before considering reuse. In the one-image-one-row execution plan, record:

- preferred mode and one selected primary asset ID/hash for `EXACT_FRAME` or `DERIVE_EDIT_SOURCE`, if compatible;
- `source_frame_ref`, preserve list, one `edit_delta`, and declared fallback for an edit;
- supporting `REFERENCE` IDs and the exact aspect borrowed from each;
- positive and negative matching reasons, including time/weather, exact text, identity version and reveal state;
- an explicit `GENERATE` fallback or `HOLD` when a conditional candidate fails verification.

Do not present an unordered list of images marked `REFERENCE`/`DERIVE_EDIT_SOURCE` and leave Agent B to direct the Beat. A catalog entry's `reuse_modes` states eligibility in general; the execution row states the selected use for this particular target. Keep the current schema's execution-mode values; if an exact-frame candidate is represented through a package extension, log the actual carry-over decision in the output manifest rather than silently redefining `GENERATE`.

## 4. Agent B: verify and execute

Agent B checks the selected record's `library_status=READY`, non-null repository `file_path`, actual readable binary and matching SHA-256 for cross-run use. It opens the image and checks the row's meaning, identity, prop counts, camera/screen/gaze geometry, time/weather, exact text and withheld information. For same-episode in-package sources, use the package/run's explicit story-QA and source-hash gate; they need not be mislabelled cross-run `READY`.

If the selected mode fails compatibility, use only the row's declared fallback and record why. A `REFERENCE` guides a newly generated complete frame; an edit source contributes the one complete base frame. Agent B does not change script, SRT, Visual Beat, viewer meaning or camera strategy to make a library image fit. Record actual mode, source asset/frame ID and hash, supporting reference IDs, attempted candidates, and final QA in the run manifest.

## 5. Post-production catalog gate

First complete the final frame revision, Owner story review, 1920×1080 delivery and SHA-256/output-record reconciliation. Then create one catalog record per valid unique final binary, with no arbitrary count limit. Record what the raster actually shows, not just the planned prompt. A frame accepted with a minor deviation may be `READY` for narrow aspects; explicitly exclude the aspect that carries the deviation. Set `reuse_scope` to the narrowest truthful ceiling (`EPISODE_ONLY`, `SCENE`, `CHARACTER`, or rarely `GLOBAL`) and `reuse_modes` to only the uses that passed review. Local-only or unavailable binaries remain `HOLD_EPISODE_REVIEW`/not reusable across runs.

The current catalog fields remain required. Add these optional, searchable fields when useful: `identity_ref`, `temporal_state`, `reference_aspects`, `use_when`, `avoid_when`, `continuity_group_id`, and `state_label`. `use_when`/`avoid_when` must describe observable target conditions, not vague similarity. `reference_aspects` limits what an otherwise approved image may teach the next generation. These fields refine `reuse_modes` and `reuse_scope`; they do not replace the visual compatibility check.

## 6. Multi-image continuity groups

Index each distinct complete image once, with its own asset ID, binary hash, state and permitted uses. Give related before/after images the same `continuity_group_id` and different `state_label` values. Keep actual generation provenance in the run manifest (`derived_from`); being in the same group does not imply that one image was technically derived from another. Search may return the whole group, but each target Beat still chooses one exact binary, one edit source, or supporting references. No parent collage, group sprite or second image copy is needed.

Example: a phone list before a selection, after one state change, and after confirmation can be three catalog records in one group. The earlier frame may be an edit source for the next when geometry is compatible. In `ep-ai-noodle-preference-20260927`, the accepted rainy-night `VB032` may also play as memory `VB039`, and `VB034` as memory `VB049`; those are exact full-frame mappings, not new unique library binaries. The Owner-supplied corrected `VB037`/`VB041` require final delivery hashes before catalog activation. The defective originals remain audit-only.

