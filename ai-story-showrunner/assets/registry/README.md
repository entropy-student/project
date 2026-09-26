# Asset Registry — IMAGE_BATCH_V1

Purpose: make accepted production images searchable as future references without turning the library into a cut-and-paste compositing system.

Registry file:
`ai-story-showrunner/assets/registry/assets.jsonl`

One JSON object per accepted asset/frame.

## Minimum record

Recommended fields:

```json
{
  "asset_id": "",
  "file_path": "",
  "asset_type": "",
  "topic_id": "",
  "visual_beat_id": "",
  "semantic": "",
  "viewer_must_understand": "",
  "character_id": null,
  "pose": null,
  "expression": null,
  "gaze": null,
  "gesture": null,
  "body_orientation": null,
  "shot_size": "",
  "pov": "",
  "camera_angle": "",
  "background_mode": "NONE | MINIMAL | FULL",
  "scene_id": null,
  "props": [],
  "reference_refs": [],
  "derived_from": null,
  "generation_prompt": "",
  "provider_model": "",
  "width": 0,
  "height": 0,
  "qa_status": "ACCEPTED",
  "reuse_scope": "GLOBAL | CHARACTER | SCENE | EPISODE_ONLY",
  "reference_use": [],
  "tags": [],
  "created_at": ""
}
```

## asset_type

Use the closest semantic role:
- `CHARACTER_REFERENCE`
- `CHARACTER_REACTION`
- `CHARACTER_ACTION`
- `CHARACTER_POSE`
- `RELATIONAL_CHARACTER`
- `PROP_UI`
- `SCENE`
- `FINAL_FRAME`

A final frame may still be useful as a future reference. Do not duplicate the binary merely to give it another role; describe the roles in metadata/tags.

## reference_use

Examples:
- `CHARACTER_IDENTITY`
- `POSE`
- `EXPRESSION`
- `GAZE`
- `GESTURE`
- `COMPOSITION`
- `SCENE_STATE`
- `DERIVE_SOURCE`

## Reuse rule

Before generating a new frame, search accepted registry entries for compatible semantic/performance/camera references.

An accepted asset can:
- guide identity;
- guide pose/expression/gaze/gesture;
- guide scene/camera/composition;
- serve as a valid `DERIVE_EDIT` source when the target only changes a compatible local state.

It must NOT be cut out and assembled with other assets to manufacture a final frame.

## QA rule

Only `ACCEPTED` assets are reusable.
Rejected/drifted frames must never become future reference truth.
