# G6 E2E v1 — Execution Order

## Goal

One handoff:
```text
package
→ real TTS
→ Runtime Timeline Resolver
→ 44 production frames
→ FFmpeg render
→ final QA
→ final.mp4
```

No Owner round-trip is expected during a normal PASS path.

## Order

1. Preflight
2. Resolve reference package
3. Production TTS
4. Runtime Timeline Resolver
5. Image execution rows
6. Image QA/checkpoint
7. Compile FFmpeg render plan from FINAL_SHOT_TIMELINE
8. Render final video
9. ffprobe verification
10. Final QA
11. Write RUN_RECORD.json

## Stop only on real blockers

Do not stop merely because:
- actual TTS differs from planned time;
- final total duration changes;
- FFmpeg needs a technical rerun;
- an already accepted frame needs to be held longer.

Return only when a locked semantic/identity/runtime constraint cannot be satisfied.
