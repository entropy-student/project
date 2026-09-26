# Story Event Frame Production Patch — 2026-09-26

Status: `OWNER-APPROVED PROJECT PRODUCTION PATCH`  
Applies to: new AI story-video G4/G5 packages in this project, beginning with `ep-agent-permission-boundary-20260926`.  
Authority: explicit Owner review of the partial 71-frame run. The portable `story-showrunner` Skill remains Candidate; packages must carry these rules as a named runtime override until its own contracts are updated.

This patch adds production gates to `G4_DIRECTOR_LANGUAGE_RULES.md`, `G4_VIEWPOINT_GRAMMAR.md`, `VISUAL_FRAME_BLUEPRINT_RULES.md`, and `G5_IMAGE_ASSET_PACKAGE_CONTRACT.md`. It does not change locked spoken scripts, planned SRT, or accepted historical validation results.

## 1. Story-event gate before Frame Blueprint

For every Visual Beat, answer: **“这一刻故事世界里实际发生了什么？”** Record the observable actor/action or external event, state before/after, and who experiences the consequence. The image must make the Beat's viewer meaning legible through behavior, a physical object, a real interface/document, a spatial event, a human reaction, or a real-world consequence.

`ABSTRACT_EXPLANATORY_GRAPHICS = FORBIDDEN` for this production profile. Do not use free-floating task/choice/rule cards, flow charts, paths, arrows, threshold plates, tracks, relationship lines, branch diagrams, a personified phone/AI proxy, literal doors/steering wheels for spoken metaphors, or visualized narration text to explain concepts. Real diegetic phone UI, receipts, calendars, messages, documents, and other objects remain allowed when they are causally present in the story. A native app card is allowed as an app UI state; a floating card outside the device is not.

If the only answer to the event question is “this diagram explains the narration,” return to G4. If the locked script offers no truthful concrete action, return to G3 for an explicit script decision. Do not invent events in G5 or the image executor. Hypothetical narration (for example “如果发出一封邮件”) may be shown as a clearly planned/considered action before confirmation; it must not be represented as an accomplished fact in the episode timeline.

Failure: `RETURN_NO_STORY_EVENT` or `RETURN_HYPOTHETICAL_AS_FACT`.

## 2. Physical viewpoint gate

POV labels alone do not prove a frame is possible. For any readable screen/object and visible character, specify camera position, screen facing, character gaze target, and what the viewer can actually see. A screen turned toward the camera cannot simultaneously be read by a front-facing character behind it. Choose `OBSERVER` for reaction with the screen back/side visible, `IP_POV` for what the character reads, or `OVER_SHOULDER_IP`/a physically valid three-quarter camera for both. If one frame cannot carry both jobs, use adjacent reaction and discovery Beats when meaning changes.

Failure: `RETURN_PHYSICAL_VIEWPOINT_CONFLICT`.

## 3. Recurring identity and continuity

Before G5 compilation, give every recurring character, causal prop, and UI shell a stable ID and a small master: visible silhouette/geometry, color, placement or camera side, allowed state variants, and reference path. Lock counts when causal (one phone, one bag, three meals). A transition may change only what the event changes. Repeated poses should express changed emotion or behavior, not merely decorate a list of accomplishments.

For the current episode, the Owner-provided `CHAR_IP_001 V2` four-view in the package is the highest-priority character identity. The older dark-hair/wine-red outfit in existing documents does not apply to this episode. V2 locks identity; a separate approved full-frame style/UI master should lock rendering and device treatment. Do not silently mix V1 and V2.

If a recurring supporting character is visible across Beats, prepare and lock at least a simple two-view reference before producing those frames. If that sheet is absent, mark those rows `HOLD_REFERENCE`, not `ACCEPTED`.

Failure: `RETURN_PROP_IDENTITY_DRIFT`, `RETURN_CHARACTER_REFERENCE_MISSING`, or `RETURN_UI_SHELL_DRIFT`.

## 4. Generate / derive planning

The G4/G5 package, not the executor, chooses the preferred execution mode. `DERIVE_EDIT` means editing one accepted complete image into one new complete image while preserving a compatible viewpoint, subject set, main geometry, character identity, and UI shell. Plan it for same-camera setup/reveal or one local state change. A planned forward source may be named by the preceding `visual_beat_id`; it becomes eligible only after that frame passes story-level QA and the source binary is available. Record `source_frame_ref`, preserved elements, and one main `edit_delta`.

If the source fails QA or the target needs a changed POV/camera side/crop/visible subject set/primary geometry, use `GENERATE` and log `RETURN_DERIVE_SOURCE_INCOMPATIBLE`. There is no percentage quota for edits. The V2 identity reference remains mandatory when the character appears, even with a source frame.

Owner image constraints for the current pipeline: `COMPOSITE_CROP = FORBIDDEN`; no SVG, HTML, Canvas, PIL text, cut-and-paste assembly, external layers, or post-production text overlays. Each Beat's final deliverable is one complete generated or edited image. This explicit Owner rule supersedes the optional `COMPOSITE_CROP` and `POST_OVERLAY` defaults in older project/Candidate contracts for these packages.

## 5. Text and frame QA

Use `NONE` or `IMAGE_NATIVE` for text render mode. Put any causally necessary exact Chinese text in `exact_required_text`; compare the final raster character by character. If it cannot be generated legibly and exactly, return `UI_TEXT_FAILURE`; do not repair it with overlay or accept an incorrect frame.

Frame QA must separately pass: story event/causality, physical viewpoint, recurring prop and UI continuity, V2 identity, approved style, withheld/reveal state, exact text, single full-image output, and source compatibility for `DERIVE_EDIT`. A polished image fails if it relies on explanatory graphics or contradicts story physics. Only story-level accepted frames may seed future edits.

## 6. Durable output and registry

Distinguish `frame_qa_status`, `story_review_status`, and `storage_status`. A local accepted frame is not automatically a durable, reusable repository asset. Registry `file_path` must resolve in the declared storage location; when binaries remain local, record that scope explicitly and exclude the entry from cross-run reuse until accessible. Do not mark an image as an accepted DERIVE source solely because a metadata record exists.

The existing `OUTPUT_RECORD_STANDARD.md` structure stays in force: `outputs/<episode>/INDEX.md` and `runs/<run>/RUN_RECORD.json` plus retained outputs. A run may be `HOLD` with partial local frames; do not imply the episode image batch is complete.
