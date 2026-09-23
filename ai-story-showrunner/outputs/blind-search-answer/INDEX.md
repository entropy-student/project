# blind-search-answer — Output Index

Current accepted/active production state:

- Timing compile → PASS / planned timeline compiled
- Video Runtime Probe → PASS_PROGRAMMATIC / FFmpeg selected
- Real CosyVoice production TTS → EXECUTED / LISTENING_QA_RETURN
- Runtime Final Timeline → EXECUTED from real normalized durations
- Narration master → ~143.0936s / NOT ACCEPTED
- GPT-SoVITS local WebUI → PASS / 5-case A/B pending
- Production Frames → PARTIAL / 20 of 44 latest reported snapshot
- Final Video → BLOCKED_BY_G6A

Active package:
`experiments/g6/blind-search-answer/production-package-v2`

Current audio handoff:
`docs/G6A_AUDIO_QA_AND_TTS_MIGRATION_TRIAL.md`

Current next action:
`GPT-SoVITS vs CosyVoice 5-case A/B → choose audio baseline → targeted repair/regeneration → runtime timeline re-resolve`

Expected final:
`final/blind-search-answer.mp4`

Do not infer a production PASS from this index. Reviewer truth remains `REVIEWER_HANDOFF.md`.
