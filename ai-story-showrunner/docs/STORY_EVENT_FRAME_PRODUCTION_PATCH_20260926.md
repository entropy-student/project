# Story Event Frame Production Patch — 2026-09-26

Status: `OWNER-APPROVED PROJECT PRODUCTION PATCH`  
Applies to: new AI story-video G4/G5 packages in this project, beginning with `ep-agent-permission-boundary-20260926`.  
Authority: explicit Owner review of the partial 71-frame run. The portable `story-showrunner` Skill remains Candidate; packages must carry these rules as a named runtime override until its own contracts are updated.

This patch adds production gates to `G4_DIRECTOR_LANGUAGE_RULES.md`, `G4_VIEWPOINT_GRAMMAR.md`, `VISUAL_FRAME_BLUEPRINT_RULES.md`, and `G5_IMAGE_ASSET_PACKAGE_CONTRACT.md`. It does not change locked spoken scripts, planned SRT, or accepted historical validation results.

## 1. Story-event gate before Frame Blueprint

For every Visual Beat, answer: **“这一刻故事世界里实际发生了什么？”** Record the observable actor/action or external event, state before/after, and who experiences the consequence. The image must make the Beat's viewer meaning legible through behavior, a physical object, a real interface/document, a spatial event, a human reaction, or a real-world consequence.

`ABSTRACT_EXPLANATORY_GRAPHICS = FORBIDDEN` for this production profile. Do not use free-floating task/choice/rule cards, flow charts, paths, arrows, threshold plates, tracks, relationship lines, branch diagrams, a personified phone/AI proxy, literal doors/steering wheels for spoken metaphors, or visualized narration text to explain concepts. Real diegetic phone UI, receipts, calendars, messages, documents, and other objects remain allowed when they are causally present in the story. A native app card is allowed as an app UI state; a floating card outside the device is not.

The arrow ban applies to explanatory marks added to visualize a concept. A native back button, list chevron, ordinary navigation icon, or functional arrow on a real object/UI is allowed when it belongs to that object/UI and does not become a floating explanation. Do not reject a frame solely because a real phone interface contains a back arrow. Read any broader row-level phrase such as “不得出现箭头” with this distinction.

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

Classify deviations before retrying:

- **Hard failure:** the viewer reads the wrong event or before/after state; an action is falsely completed; a required string is wrong; a causally important quantity or identity changes; the camera/screen/gaze geometry is impossible; an invented readable UI fact changes the story or timeline; an abstract explanatory graphic replaces the event; a prohibited assembly/overlay is used; or a `DERIVE_EDIT` source/target is incompatible. Reject and record the specific cause.
- **Minor deviation:** a fingertip's exact gap from the screen, a slightly different shot size or partial hair crop, a small phone hardware detail, or harmless native UI chrome differs while the intended event, identity, readable facts, and continuity remain clear. Record it as `minor_deviation` and accept; do not spend another image attempt solely to correct it. If one of these details actually changes the event (for example, a visible send/accept action when no action should have occurred), it becomes a hard failure.

Treat `viewer_must_understand`, causal `state_before/state_after`, exact text, and physical possibility as the meaning to preserve. Do not turn every gesture, camera-distance phrase, or pixel-level position in an execution row into a separate hard gate. A visible empty reply field with no outgoing message can establish “invitation received, no reply sent” without a precisely measured hovering finger. Conversely, an extra legible meeting title, date, sender, or order state may add an unapproved story fact even if it looks like ordinary UI.

At G4/G5 planning, prefer a clear observable action, consequence, or state change over a barely perceptible pose difference; this does not require exaggerated movement in every frame. For `DERIVE_EDIT`, favor one meaningful change on a compatible accepted source. If the target needs new hand geometry, a different layout, and new exact text together, check source compatibility before repeated edits and use only the declared `GENERATE` fallback when needed. At execution, do not rewrite a locked Beat to make it easier to generate. Diagnose a hard failure before retrying; after the same hard failure recurs twice, use the declared fallback or put that Beat on `HOLD_REVIEW` with evidence instead of repeatedly spending attempts. A minor deviation is not a retry reason.

## 6. Durable output and registry

Distinguish `frame_qa_status`, `story_review_status`, and `storage_status`. A local accepted frame is not automatically a durable, reusable repository asset. Registry `file_path` must resolve in the declared storage location; when binaries remain local, record that scope explicitly and exclude the entry from cross-run reuse until accessible. Do not mark an image as an accepted DERIVE source solely because a metadata record exists.

The existing `OUTPUT_RECORD_STANDARD.md` structure stays in force: `outputs/<episode>/INDEX.md` and `runs/<run>/RUN_RECORD.json` plus retained outputs. A run may be `HOLD` with partial local frames; do not imply the episode image batch is complete.

## 7. Episode-level visual variety gate

Passing the story-event gate one frame at a time is insufficient if the full episode repeats the same desk, phone, and over-shoulder composition. Before G5 execution, G4 must review the ordered shotboard as a continuous video: for each sequence, record the physical location, visible actor/action, primary prop, viewpoint, and whether the screen or a real-world consequence carries the meaning. Identify long runs of similar read-screen frames and repeated reaction poses. These are editorial review signals, not fixed quotas or automatic failures.

Use real phone UI when an exact message, decision state, or authorization action is necessary evidence. Let the next meaningful Beat show what that action changes for a person, object, relationship, schedule, or place. A phone notification followed by another phone page and a seated reaction should not be the default treatment for every complication. Preserve short same-camera UI chains when the before/after transition itself is the story; use a different physical action or viewpoint when the story focus changes. Do not add locations, people, or decorative backgrounds solely to manufacture variety.

Give distinct complications distinct visible consequences. Prefer a full-body action, changed use of a recurring object, another person's response, or a spatial transition when those events are truthful to the script. Minimal background means only the anchors needed to read the event; it does not require every Beat to happen at the same desk. In still-image production, favor legible changes such as sitting/standing, taking/putting down an object, leaving/returning, or approaching/withdrawing over a sequence whose only difference is fingertip distance or a barely changed expression. Recurring characters and props still require the identity and continuity locks in section 3.

If a 3–5 minute script repeatedly explains rules or principles without enough enactable events, return it to G3 for a deliberate editorial decision before compiling more frames. G4 may not turn a hypothetical future outcome into an event that already happened, and G5 may not invent actions to solve a monotonous shotboard. When the script is locked, G4 should first test whether the existing narration permits a more varied but truthful action/consequence treatment; if it does not, record the limitation rather than disguising it with screen layouts or abstract graphics.

The visual-variety review must state the tradeoff: new locations, supporting characters, and changed camera geometry can improve story comprehension but require new references and more `GENERATE` frames; compatible same-camera state changes can use `DERIVE_EDIT`. Preserve the whole-frame image and exact-text rules above. Do not pursue a target edit percentage or a fixed number of locations at the expense of causality.

## 8. Current episode pilot: coverage and lesson

The v3 image pilot for `ep-agent-permission-boundary-20260926` deliberately selected 11 of 71 Visual Beats: `VB001–VB006`, `VB013–VB015`, and `VB028–VB029`. It was a bounded production check before paying for the remaining frames, not a new storyboard or a representative random sample.

- `VB001–VB004` check the opening hook, early causal setup, V2 character/prop continuity, hand POV, and whether real tasks read as a story event without explanatory graphics.
- `VB005–VB006` check exact native Chinese UI text and an OFF→ON authorization transition using `GENERATE` then `DERIVE_EDIT`.
- `VB013–VB015` check withheld→revealed friend-message information, no-reply versus order confirmation, same-camera continuity, and whether the planned edit source is actually suitable.
- `VB028–VB029` check pending→accepted calendar state, exact `07:30`/`已接受` text, and another full-frame edit on a stable UI layout.

The run `20260926-1746-images-v3-pilot-r1` accepted 11 final full frames, with 17 rejected candidates retained for audit. Actual accepted modes were 8 `GENERATE` and 3 `DERIVE_EDIT`; `VB014` used its declared `GENERATE` fallback after edits failed. These results support using edits for compatible local state changes, but expose overstrict retries on fingertip position and framing. A `VB013` candidate was wrongly rejected for a native back arrow; that is not an abstract explanatory graphic. A `VB028` candidate invented readable meeting/date details, which can alter story facts and remains a valid hard failure. The pilot remains `HOLD_OWNER_REVIEW`; its success does not certify the other 60 frames or authorize automatic registry promotion or GitHub upload.

The follow-up was a **read-only re-adjudication**, not another paid 11-frame generation pilot. Retained candidates `VB003/2` (finger contact and native list chevrons), `VB005/1` (closer framing), `VB013/1` (native back arrow), `VB014/Generate 2` (finger farther from reply field), and `VB028/3` (phone hardware detail) would pass under the clarified rule with minor deviations. `VB028/2` still fails because it invents readable meeting/date/sender facts. The result is 5 would accept / 1 still reject; historical run statuses and accepted final files remain unchanged. A separate local Reviewer-only handoff retains the image-by-image reasoning and evidence. Only an unresolved rule conflict would justify a small new image trial before continuing the remaining Beats.

## 9. Beat economy and pilot-to-batch handoff — 2026-09-27

The 4:06 `ep-ai-noodle-preference-20260927` package initially had 86 Visual Beats. A 12-image cross-scene pilot confirmed character/scene direction but also exposed image states that were too similar for separate still frames: the third bowl being set down versus the protagonist starting to smile, and three consecutive phone settings screens whose middle state added little viewer meaning. The Owner approved reviewing a 62-frame plan before further production. **A Beat count is not a quota**; neither SRT cue count nor a desired average image duration decides boundaries. Merge when one complete frame can carry adjacent narration without losing a distinct audience focus, real action, causal state, or physically valid viewpoint. Preserve the first bite and the reaction after tasting as separate states; they are meaningfully different.

Before dispatch, calculate the hold time of every proposed frame after merging. A long hold is an editorial review signal, not an automatic failure. In this episode, a direct merge would have held one phone/reflection image for 9.352 seconds and another records image for 7.640 seconds; a different truthful grouping kept the longest planned still at 6.943 seconds. Use the planned SRT only as an observability estimate. Real TTS may move image cut points without rewriting the Beat meaning or authored speech.

When remapping Beat IDs after a pilot, publish an explicit old-to-new mapping and regenerate the Visual Beats, Semantic Shots, Frame Blueprints, execution rows, source-frame paths, timing bindings, manifest and prompts as one versioned package. Do not tell an executor to skip rows in the old package. Keep old run records and image hashes immutable. A pilot image may be proposed as a full-frame carry-over candidate only after it is inspected against the new Beat; retain its source run, old ID, hash, frame QA, story-review status and storage scope. A local QA accept is not automatic Owner approval, GitHub publication, Registry READY status or cross-run reuse eligibility. A retired picture may remain a provenance/edit source without being placed on the final video timeline.

Pilot QA should enforce the **meaningful action**, not a literal fingertip or cup position. In the noodle pilot, a friend asking a question while still holding a glass was rejected for not yet setting it down; because the question and relationship were already clear, that cup detail was minor and should not alone have triggered another paid attempt. A rain-night phone shown only from the back failed to show the causally important black/off screen, and a supposed after-bite frame with noodles still suspended before the mouth failed the before/after state; those rejections were justified. Do not retroactively overwrite historical candidate status; record the re-adjudication separately.

For recurring story objects, continuity means both stable identity **and visual recognizability**. Keep the same bowl geometry, phone shell, friend identity and shop layout, but also make the causal ingredient or object readable at first glance. In this episode the meat strips and bowl were consistent, while the pickled cabbage read only as tiny green garnish; future frames should show recognizable light yellow-green pickled-cabbage strips without inventing a new recipe. For a repeated listing, preserve its food photo and UI shell across list/detail/save states unless a genuine navigation change explains the layout. Native UI text remains exact-image text; accept a native back arrow, reject invented readable copy. Background detail may exceed a strict blank backdrop when rain, shop entry or interpersonal space carries the event, but ordinary home decor and tableware should not compete with the action.

## 10. Owner review of the noodle v2-62 batch — 2026-09-28

The local `20260927-1816-images-v2-62-r1` run produced 62 reviewable complete frames for `ep-ai-noodle-preference-20260927`. Its executor reported 25 `ACCEPTED` and 37 `ACCEPTED_WITH_MINOR`; these are **executor frame-QA decisions**, not a final Owner-approved playback manifest. The Owner accepted the overall story treatment and the minor weather/window variations in `VB035`, `VB036`, and `VB050`, but found two missed hard failures and approved two first-visit flashback replacements:

| Beat | Owner review decision | Required disposition before final playback |
|---|---|---|
| `VB037` | The selected local frame has a third visible hand. This is an anatomy/continuity hard failure, regardless of its executor `ACCEPTED_WITH_MINOR` label. | Use the Owner-supplied complete corrected frame, subject to full-frame delivery sizing and record reconciliation. Preserve the defective original as rejected provenance, never a reference source. |
| `VB041` | The selected local frame exposes the laptop display to the viewer while the character appears to read the other side. This is a physical-viewpoint hard failure. | Use the Owner-supplied complete corrected frame with the laptop back facing the observer and the screen facing the character. The narration may identify the subject of research; the screen text is not required to be visible. Preserve the defective original as rejected provenance. |
| `VB039` | Its first-visit memory shows a bright day outside, while the established first visit was a rainy night. | Reuse the complete accepted rainy-night `VB032` frame as the first-bite reaction memory. Record `CARRY_OVER_FULL_FRAME` from `VB032`; do not crop, composite, or regenerate merely to duplicate this event. |
| `VB049` | Its first-visit memory also shows a bright day outside. | Reuse the complete accepted rainy-night `VB034` frame as the hesitant continuation of that first meal. Record `CARRY_OVER_FULL_FRAME` from `VB034` after confirming the action still reads as continuing to eat. |
| `VB035`, `VB036`, `VB050` | Daylight with residual rain-like window detail is acceptable in this episode. | Keep these selected frames. This tolerance does not permit a clear night-to-day contradiction in an explicitly identified first-visit memory. |

The two Owner-supplied corrected PNGs are 1672×941 source images. The output contract remains 1920×1080: resize each **whole frame** without crop, assembly, added text, or other content edits; retain source hashes and new output hashes. The original local `r1` images and run evidence are historical records. Publish a versioned review revision or explicit amendment instead of silently replacing binaries beneath old hashes. Reconcile the 62-frame playback index, per-frame QA, output manifest, run record, and production Registry links/statuses together. Old `VB037`/`VB041` Registry records must not remain eligible despite their executor `qa_status=ACCEPTED`; mark them as rejected/retired provenance and give corrected binaries new provenance IDs. A repeated full-frame binary may serve multiple Beats, with each Beat's playback mapping and source hash explicit.

Generalize these gates for future batches: inspect all visible arms/hands and their body attachment; check the camera, viewer, object face/back, and character gaze as one physical layout; and compare flashbacks with the established weather/time/scene state of the event they recall. An extra limb, an impossible readable-screen orientation, or a memory contradicting a causally important time/weather anchor is a hard failure, even if the image is polished and the action description sounds plausible. A minor label may cover harmless décor or window texture only when the event and chronology remain understandable. Owner review may overturn executor QA; keep the original decision and the later adjudication separately.

This section records Owner decisions and reconciliation requirements; it does not claim that the `r1` files, GitHub storage, or Reference Library have already been updated. Until the versioned final binaries and hashes are in their declared storage location, they remain local review assets and must not be promoted to cross-run `READY` reuse.

## 11. Reference Library handoff rule — reusable production contract

Use `docs/REFERENCE_LIBRARY_PRODUCTION_WORKFLOW.md` with `assets/reference-library/README.md` as the general library procedure. Sections 8–10 above are case evidence; their episode counts, Beat IDs and particular images are not quotas or universal defaults.

Agent A must search the library before finalizing each image execution row and choose the target-specific primary mode/source, supporting reference roles and a declared fallback. A catalog image may advertise several permitted `reuse_modes`, but Agent B must not be left to choose the story meaning or camera. Agent B verifies the chosen binary, hash, scope, physical viewpoint and state, then executes that row or its declared fallback. `REFERENCE` and `DERIVE_EDIT_SOURCE` are uses of complete images, not separate asset-file classes. An edit takes one complete source image; supporting canonical/pose/style references do not become pasted layers.

After final Owner story review and versioned output reconciliation, index every valid unique complete final binary with an explicit reuse scope and permitted uses; there is no fixed per-episode image quota. Keep each distinct image/state as one catalog record. Related images may share a continuity-group ID, and identical full-frame playback across Beats may share one library asset ID with separate Beat mappings. A locally accepted or Owner-approved image without a durable, hash-matching repository binary is not cross-run `READY`. Rejected original versions remain audit-only and may not seed references or edits.

A ZIP-only local image handoff may retain the final frames and catalog draft as one portable result after its contents are verified. It does not fulfill the published `outputs/<episode>/runs/<run>/frames/` path contract. Update the episode index and local Registry to identify the ZIP as the local handoff and retired loose paths as unavailable; on later GitHub publication, place complete frame binaries in the output run, verify hashes, and only then promote eligible catalog rows to `READY`.
