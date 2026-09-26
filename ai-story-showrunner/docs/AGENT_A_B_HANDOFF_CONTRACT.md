# Agent A → Owner → Agent B Handoff Contract — IMAGE_BATCH_V1

Status: `ACTIVE_RUNTIME_CONTRACT`

Transfer mode:
Agent A creates local ZIPs. Owner manually gives each ZIP to Agent B.

No GitHub-based A→B package handoff is required.

## Agent A input

Agent A reads:
- `entropy-student/project/ai-story-showrunner`
- `entropy-student/spike.skill/story-showrunner`
- current topic ledger/runtime state
- current batch policy and canonical character/style references

Agent A does not generate images.

## One ZIP per topic

Required package:

```text
<TOPIC_ID>.zip
├─ 00_PACKAGE_MANIFEST.json
├─ 01_SCRIPT.md
├─ 02_PRODUCTION_SUBTITLES.srt
├─ 03_DIRECTOR_SHOTBOARD.md
├─ 04_VISUAL_BEATS.json
├─ 05_FRAME_BLUEPRINTS.json
├─ 06_IMAGE_EXECUTION_ROWS.json
├─ 07_CHARACTER_BIBLE.md
├─ 08_STYLE_BIBLE.md
├─ 09_ASSET_REQUIREMENTS.json
├─ 10_QA_RULES.md
└─ references/
   └─ CHAR_IP_001_V2_turnaround.jpg
```

The ZIP must be self-contained for image execution.
The turnaround binary copied into `references/` must be non-empty and readable.

## Image execution row

One final frame = one execution row.

Current portable schema remains structurally authoritative.
Batch-specific additions such as `viewer_must_understand`, performance fields and `background_mode` may be included because the schema permits additional properties.

Batch hard rules:
- only `GENERATE` or `DERIVE_EDIT`;
- no `COMPOSITE_CROP`;
- `text_render_mode = IMAGE_NATIVE` when causal readable text is required;
- no overlay/SVG/HTML/programmatic drawing dependency;
- background defaults to NONE/MINIMAL.

## Agent B output

Agent B reads the ZIP plus relevant GitHub contracts and generates all final raster frames.

Accepted episode frames go under:
`ai-story-showrunner/outputs/<episode_id>/runs/<run_id>/frames/`

Agent B also:
- writes/updates `RUN_RECORD.json`;
- updates the episode `INDEX.md` according to OUTPUT_RECORD_STANDARD;
- appends accepted reference metadata to `assets/registry/assets.jsonl`;
- writes one `ASSET_OUTPUT_MANIFEST.json` mapping Visual Beat → final asset/path/mode/QA status;
- commits outputs to GitHub and returns the commit SHA.

Do not rewrite upstream story/director semantics during execution.
