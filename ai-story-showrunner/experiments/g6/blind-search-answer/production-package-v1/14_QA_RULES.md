# E2E v1 QA Rules

## Hard

- exact locked spoken text
- 44 Visual Beats in order
- 44 accepted frames
- no missing source references
- no character maturity/costume drift
- no POV redesign
- no invented brand/logo
- no explainer-poster regression
- real narration audio present
- FINAL timing used, not planned timing
- H.264 1920x1080 30fps
- subtitles present and ordered

## Timing

Video visual boundaries may quantize to 30fps.
Audio/SRT retain runtime-resolved timing.

No visual gap > one frame.
No overlap causing wrong Beat order.

## Return codes

- RETURN_E2E_SOURCE_MISSING
- RETURN_TTS_EXECUTION
- RETURN_TIMELINE_RESOLUTION_INFEASIBLE
- RETURN_IMAGE_EXECUTION
- RETURN_CHARACTER_DRIFT
- RETURN_RENDER_PLAN_INVALID
- RETURN_FFMPEG_EXECUTION
- RETURN_FINAL_QA
