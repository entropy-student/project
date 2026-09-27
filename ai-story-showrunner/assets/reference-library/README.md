# Visual Reference Library

This folder is a searchable library of **complete raster images**, not a bin of cut-out elements. `catalog.jsonl` has one record per photographed/generated frame. Each record says what is actually pictured, its scene and camera, and whether its binary can currently be used. The first 40 records document the partial `ep-agent-permission-boundary-20260926` image run. Ten selected, byte-identical PNGs are retained under `images/` as usable examples; the other 30 remain local-only or on hold and cannot be reused from this repository.

This library is separate from `assets/registry/assets.jsonl`, which contains historical production records. Neither an old registry `ACCEPTED` flag nor a matching caption proves that a current binary is available or suitable. The original V2 four-view remains the character identity authority; an episode frame is never a replacement identity master.

## Files

- `catalog.jsonl`: one UTF-8 JSON object per image, with a stable `asset_id` and searchable Chinese content/tags.
- `images/<episode_id>/`: curated complete PNGs only. Do not copy every final episode frame here. Once a final frame is durably stored under `outputs/<episode>/runs/<run>/frames/`, its catalog row may point there instead.

`file_path` is relative to the Git repository root (`project/`). It is `null` until the binary is in GitHub. `source_run_id`, `source_visual_beat_id`, and `sha256` preserve provenance. `library_status=READY` means a reviewer accepted this image for the listed library uses; it does **not** mark the entire episode complete. `HOLD_EPISODE_REVIEW` and `HOLD_REMAKE` rows are searchable audit records, never reuse candidates. Do not copy a local Windows path into a public catalog entry.

## Matching and use

1. Search `catalog.jsonl` by event/action, expression, gaze, gesture, scene, shot size, POV, props, or Chinese tags. Read the whole matching row and open the actual image. A metadata match alone is insufficient.
2. Filter to `library_status=READY`, a non-null `file_path`, and a readable binary whose SHA-256 equals `sha256`. Check the target's current character reference, style, causal prop counts, screen text, physical viewpoint, and withheld information.
3. Choose exactly one use listed in `reuse_modes`:
   - `REFERENCE`: guide pose, expression, gaze, camera, scene, or UI continuity. Produce a new complete frame for the target Beat.
   - `DERIVE_EDIT_SOURCE`: edit **one** accepted complete image into a new complete image when camera side, subject set, main geometry, and identity remain compatible and there is one meaningful state change. The target still needs its own execution row and QA.
   - `EXACT_FRAME`: reuse the identical binary only when the target's viewer meaning, character, props and quantities, temporal state, exact text, and reveal state all match. Log the source `asset_id` and hash. Similar mood alone is insufficient.
4. Otherwise use `GENERATE`. A rejected, unavailable, or context-specific frame cannot be promoted by search similarity. Never crop subjects from multiple images, assemble them, program-draw text, or add a post-production overlay.

For a quick text search, run `rg -n '愣住|低头思考|中近景' ai-story-showrunner/assets/reference-library/catalog.jsonl` from the repository root. A production agent should then parse matching JSON lines, filter on status and scope, and visually inspect each remaining image before choosing a mode.

`reuse_scope` further limits use: `CHARACTER` requires the same canonical character identity, `SCENE` the same scene continuity, and `EPISODE_ONLY` the same episode. `GLOBAL` is reserved for genuinely context-free references. These are ceilings, not automatic permissions. A frame with exact UI text is normally `EPISODE_ONLY` unless a new target truly requires the same text and state.

### Example decisions

| Query / target | Candidate | Decision |
|---|---|---|
| “愣住，看手机” with the same V2 protagonist and no new story fact | `RL-APB-20260926-VB020` | Inspect it for `EXACT_FRAME` or use its expression as `REFERENCE`; verify the target also has one phone and the same screen-facing logic. |
| Switch the current episode's `代办小事` setting from OFF to ON | `RL-APB-20260926-VB005` → `VB006` | The two published frames illustrate a valid same-camera state chain. Reuse the exact frame only for that same state; use `DERIVE_EDIT_SOURCE` for another compatible local change. |
| A new story has a person hesitating over a different app or message | `RL-APB-20260926-VB013` | Use camera/hand composition as `REFERENCE`; do not transplant its phone screen or treat the old message state as the new story. |
| Search returns `VB034` or any local-only row | `HOLD_REMAKE` / `HOLD_EPISODE_REVIEW` | Do not use it. Wait for a reviewed, published replacement and update its catalog record. |

## Catalog fields and maintenance

Required fields: `asset_id`, `file_path`, `sha256`, `source_episode_id`, `source_run_id`, `source_visual_beat_id`, `content`, `scene_id`, `shot_size`, `pov`, `camera_angle`, `character_ids`, `action`, `expression`, `gaze`, `props`, `background_mode`, `exact_text`, `tags`, `library_status`, `reuse_scope`, and `reuse_modes`. Optional `notes` may explain a visible deviation or a narrower use. Do not put an unverified planned description in `content`; correct it against the final raster during review.

When an episode is finally accepted, update its catalog row to a real repository path and hash rather than making a second binary copy. If a frame is replaced, retain its old ID as a historical record with `HOLD_REMAKE` or `RETIRED`, and add a new ID for the replacement; never silently repoint an existing `asset_id` to different pixels. Reviewers may narrow or revoke use at any time. The image executor records every match decision and actual source in its run manifest, including why it chose exact reuse, edit, reference, or generation.
