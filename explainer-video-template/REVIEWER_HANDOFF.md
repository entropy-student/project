# REVIEWER_HANDOFF — CURRENT TRUTH
PROJECT_GOAL: Reproducible low-cost 16:9 narrated explainer videos from a structured script and actual assets.
PROJECT_STAGE: V6_LOCAL_BROWSER_VERIFIED / REPOSITORY_DOCS_PR_ONLY / PRODUCTION_NOT_READY
SYSTEM_MAP: HTML/CSS/JS browser preview with 6 fixed demo scenes + optional uploaded scene 7, CSS animations, setInterval auto paging, 1920x1080 canvas, 1600x900 content stage, VP9 transparent presenter, no backend/database/network/Secrets or MP4 renderer.
CURRENT_ACCEPTED_STATE: Local 2026-10-28 Chromium test passed 6 scene hard-cuts/animations, video pause/resume, custom media, 75/120/150/170% caption safety and default 120% presenter; full evidence in offline private work package. This draft GitHub PR is not main.
CURRENT_GATE: G1_DATA_DRIVEN_RENDER_POC; 3 scenes only, json input, voice/SRT, frame-based renderer, 1920x1080 30fps H.264/AAC MP4.
CRITICAL_CONSTRAINTS: Black/silver-green layout, scene/REC, white centered caption safety, real transparent WebM 120%, zero crossfade, distinct scene animation, Windows CPU-first, no unnecessary costs, no public upload of presenter video.
DEFAULT_EXECUTION_CHANNEL: Owner local Windows Codex; independent Git branch PR; technical environment UNKNOWN pending Executor readback.
CURRENT_ROLLBACK_STATUS: V5 ZIP and V6 offline work package retained; new renderer must not overwrite V6.
UNRESOLVED: No MP4 renderer, audio/SRT, arbitrary scene input, 52-scene performance, Windows CPU render benchmark, external asset rights.
NEXT_STEP: Code executor follows prompts/03_CODEX_EXECUTOR_GATE_G1.md after obtaining and validating offline work package. Stop at Reviewer.
OWNER_ACTION_REQUIRED: Only before public/private media publication or paid service; otherwise NONE.
EVIDENCE_POINTERS: offline work package evidence/v6_full_frame.png, tests/smoke_test.py, ASSET_HASHES.sha256; EXECUTION_EVIDENCE.md.
GATE_ID: G1_DATA_DRIVEN_RENDER_POC
OBJECTIVE: Prove three real scenes with audio, subtitle, own motion, hard cuts and deterministic MP4 output.
MAX_ENDPOINT_THIS_ROUND: Local 3-scene proof + tests/evidence + PR; no 52-scene automation or publication.
MANDATORY_REVIEW_STOP: YES
TARGET_AND_SCOPE: explainer-video-template only.
PREFLIGHT: Source package SHA, worktree/branch, local CPU/Node/FFmpeg/permissions.
REQUIRED_EVIDENCE: Source/storyboard/voice/SRT, command logs, ffprobe, timestamps, cut-boundary frames, alpha/composition QA, reproducibility, runtime cost.
ACCEPTANCE_CRITERIA: Offline package docs/ACCEPTANCE.md G1 list, and docs/READINESS_GAPS.md.
ROLLBACK_STATUS_OR_PLAN: V6 source and WebM remain untouched; new candidate in isolated directory/branch.
OWNER_ONLY_ACTIONS: Public publishing, private asset upload, external paid API, other-project changes.
REVIEWER_TO_EXECUTOR_RELAY: prompts/03_CODEX_EXECUTOR_GATE_G1.md
EXECUTOR_TO_REVIEWER_RELAY: Result/change/validation/issues/rollback/reviewer action/owner relay.
