# Story Showrunner Skill Migration Map v1

Date: 2026-09-22

Status: `REVIEW_COMPLETE / READY_FOR_OWNER_MIGRATION_PASS`

## Goal

Extract the stable reusable capability from `ai-story-showrunner` into a candidate Skill:

`entropy-student/spike.skill/story-showrunner`

The current project remains the validation/runtime workspace until end-to-end Antigravity production is proven.

## Target structure

```text
story-showrunner/
├─ SKILL.md
├─ references/
│  ├─ ARCHITECTURE.md
│  ├─ PIPELINE.md
│  ├─ STORY_ENGINE.md
│  ├─ WRITER_CONTRACT.md
│  ├─ TIMING_COMPILER.md
│  ├─ DIRECTOR_LANGUAGE.md
│  ├─ VIEWPOINT_GRAMMAR.md
│  ├─ FRAME_BLUEPRINT.md
│  ├─ CHARACTER_IDENTITY_CONTRACT.md
│  ├─ ASSET_COMPILER.md
│  ├─ EXECUTOR_CONTRACT.md
│  └─ QA_AND_RETURN_CODES.md
├─ schemas/
│  ├─ semantic-shot.schema.json
│  ├─ visual-beat.schema.json
│  ├─ frame-blueprint.schema.json
│  ├─ frame-execution-row.schema.json
│  └─ shot.schema.json
├─ templates/
│  ├─ episode/
│  └─ production-package/
├─ adapters/
│  ├─ domains/
│  │  └─ ai/
│  ├─ executors/
│  │  └─ antigravity/
│  ├─ tts/
│  │  └─ cosyvoice/
│  └─ image/
│     └─ nano-banana/
└─ profiles/
   ├─ editorial/
   │  └─ bilibili-first-person-story/
   ├─ visual/
   │  └─ simplified-flat-narrative-comic/
   ├─ character/
   │  └─ char-ip-001/
   └─ voice/
      └─ cosyvoice-300m-v2.1.json
```

## Classification rules

### A — MIGRATE_CORE
Generic, cross-domain, validated logic.

### B — SPLIT
Contains a reusable contract mixed with current-channel/project specifics. Split before migration.

### C — ADAPTER
Provider/domain-specific behavior that should not live in core.

### D — PROFILE
Current editorial, visual, character, or voice configuration. Reusable, but not universal.

### E — RUNTIME_STATE
Live changing state. The Skill may read it, but must not bake it into Skill source.

### F — HISTORY_ONLY
Validation evidence, Pilot records, episode artifacts, superseded versions. Keep in the project.

---

## Migration map

| Current source | Class | Candidate destination | Action |
|---|---|---|---|
| `docs/ARCHITECTURE.md` | SPLIT | `references/ARCHITECTURE.md` + AI adapter | Keep generic control-plane/state/domain-object model; replace remaining AI-mechanism wording with causal mechanism |
| `docs/PIPELINE_AND_GATES.md` | MIGRATE_CORE after conflict repair | `references/PIPELINE.md` | Fix audio mode, Timing ownership and calibration-only Pilot wording first |
| `docs/WORKER_CONTRACTS.md` | MIGRATE_CORE after conflict repair | `references/WORKER_CONTRACTS.md` | Replace stale AUDIO_MODE=TBD |
| `docs/WORKER_ADAPTER_PLAN.md` | HISTORY + partial core | `references/ADAPTER_CONTRACT.md` | Extract admission/permission model; do not migrate old G1 next-actions or old worker inventory as canonical |
| `docs/G4_DIRECTOR_LANGUAGE_RULES.md` | MIGRATE_CORE | `references/DIRECTOR_LANGUAGE.md` | Keep visual semantics/cut/POV/visual intensity; remove speech-timing authority |
| `docs/G4_DIRECTOR_COMPILER_CONTRACT.md` | SPLIT | `references/DIRECTOR_COMPILER.md` | Director consumes Production SRT; G4 no longer owns speech timing calibration |
| `docs/G4_VIEWPOINT_GRAMMAR.md` | MIGRATE_CORE | `references/VIEWPOINT_GRAMMAR.md` | Generic and well validated |
| `docs/VISUAL_FRAME_BLUEPRINT_RULES.md` | MIGRATE_CORE | `references/FRAME_BLUEPRINT.md` | Generic frame/attention contract |
| `docs/G5_IMAGE_ASSET_PACKAGE_CONTRACT.md` | SPLIT | `references/ASSET_COMPILER.md` | Remove normal `G5 Pilot QA`; Pilot becomes calibration exception |
| `docs/CHARACTER_IDENTITY_LOCK.md` | SPLIT | generic identity contract + `profiles/character/char-ip-001/` | Generic precedence/drift rules to core; adult male/clothing/IP specifics to profile |
| `docs/PRODUCTION_VISUAL_STYLE.md` | PROFILE | `profiles/visual/simplified-flat-narrative-comic/` | Current channel visual profile, not universal core |
| `docs/LOW_LEVEL_EXECUTION_PACKAGE.md` | SPLIT | `references/EXECUTOR_CONTRACT.md` + Antigravity/Nano Banana adapters | Keep deterministic package contract in core; provider instructions move to adapters |
| `docs/SRT_AUDIO_TIMING_STANDARD.md` | MIGRATE_CORE after rewrite | `references/TIMING_COMPILER.md` | Make Timing Compiler upstream of Director; align acceptance with v2.1 |
| `docs/VOICE_TIMING_PROFILE_SPEC.md` | MIGRATE_CORE after rewrite | `references/VOICE_PROFILE_CONTRACT.md` | Remove stale “v2 should” language; specify generic profile contract |
| `profiles/voice/VOICE_TIMING_PROFILE_COSYVOICE_300M_V2_1.json` | PROFILE | `profiles/voice/cosyvoice-300m-v2.1.json` | Migrate calibrated rules/parameters; strip machine-specific absolute paths into runtime config |
| `docs/NARRATIVE_STYLE_CONTRACT.md` | PROFILE | `profiles/editorial/bilibili-first-person-story/NARRATIVE_STYLE.md` | Jingsui/McKee/first-person channel style is a profile |
| `docs/WRITER_QUALITY_CONTRACT.md` | SPLIT | generic writer contract + editorial profile | Generic story/script invariants to core; Bilibili/Jingsui/IP rules to profile; remove old SRT 5 chars/s gate |
| `docs/CONTENT_STRATEGY_AND_CONVERSION.md` | SPLIT/PROFILE | editorial profile + optional growth policy | DISCOVERY/TRUST/SOLUTION can be reusable; Bilibili/AI framing stays profile/adapter |
| `docs/TOPIC_OPERATING_SYSTEM.md` | AI ADAPTER + partial core | `adapters/domains/ai/TOPIC_SYSTEM.md` + generic topic-provider contract | HOT/EVERGREEN concept reusable; AI sources/mechanism fingerprints belong AI adapter |
| `docs/DAILY_TOPIC_AUTOMATION_V2.md` | AI ADAPTER | `adapters/domains/ai/DAILY_TOPIC_PROVIDER.md` | “fetch public AI signals” is domain-specific |
| `topic-ledger/EVERGREEN_BANK.md` | RUNTIME_STATE / AI data | remain outside Skill source | The Skill reads it through adapter; it is content inventory, not code/rule |
| `topic-ledger/calendar/*.md` | RUNTIME_STATE | remain runtime workspace | Skill default invocation resolves current date from configured calendar source |
| `topic-ledger/topic-registry.jsonl` + daily records | RUNTIME_STATE | remain runtime workspace | Persistent content memory/state, not Skill source |
| `schemas/semantic_shot.schema.json` | MIGRATE_CORE | `schemas/semantic-shot.schema.json` | Rename title/`$id` from AI Story Showrunner |
| `schemas/visual_beat.schema.json` | MIGRATE_CORE after timing update | `schemas/visual-beat.schema.json` | `timing_source` should resolve to Production SRT, not old G4 reference timing |
| `schemas/frame_blueprint.schema.json` | MIGRATE_CORE | same | Rename title/`$id` |
| `schemas/frame_execution_row.schema.json` | MIGRATE_CORE | same | Generic, but provider fields remain adapter-neutral |
| `schemas/shot.schema.json` | MIGRATE_CORE | same | Rename title/`$id`; align with production package naming |
| `docs/GOVERNANCE_ADAPTATION.md` | PROJECT GOVERNANCE | remain project | Skill should reference generic governance only when needed, not copy project history |
| `CURRENT_STATUS.json` | RUNTIME_STATE | remain project/runtime | Never migrate project Gate state into Skill |
| `REVIEWER_HANDOFF.md` | RUNTIME_STATE | remain project/runtime | Rewrite to current truth; do not migrate historical sections |
| `PROJECT_RECORD.md` / `EXECUTION_EVIDENCE.md` | HISTORY_ONLY | remain project | Evidence/history |
| `experiments/g4r-v03/**` | HISTORY_ONLY | remain project | Validation fixtures/evidence |
| `experiments/g5/**` | HISTORY_ONLY | remain project | Pilot/calibration evidence |
| `experiments/g6/voice-timing-calibration/**` | HISTORY_ONLY except frozen profile | remain project | Calibration evidence; only frozen profile migrates |
| `experiments/.../blind-search-answer/**` | HISTORY_ONLY / episode | remain project | Current validation episode |
| reference binaries / generated images / WAVs | RUNTIME/HISTORY | remain project or external asset store | Skill stores contracts/IDs, not episode binaries |

## Core boundary after migration

The Skill core should know:

```text
TopicProvider
→ DomainAdapter
→ Knowledge/CausalCore
→ StoryEngine
→ Writer
→ TimingCompiler
→ Director
→ Frame/AssetCompiler
→ ProductionCompiler
→ ExecutorAdapter
→ QA
```

The Skill core should NOT hard-code:
- AI as the only domain;
- Bilibili as the only platform;
- Jingsui as the only voice/style;
- CHAR_IP_001 as the only character;
- Antigravity as the only executor;
- Nano Banana as the only image provider;
- CosyVoice as the only TTS;
- one Windows absolute path;
- one episode/calendar as static Skill content.

## Migration sequence

1. Repair P0 conflicts in `CONFLICT_REGISTER_V1.md`.
2. Create `story-showrunner/SKILL.md` as candidate entrypoint.
3. Move generic contracts/schemas.
4. Create AI / Antigravity / CosyVoice / Nano Banana adapters.
5. Create editorial / visual / character / voice profiles.
6. Add runtime-state locator contract for Calendar/Registry.
7. Keep current project as validation fixture.
8. Run current Blind Search episode through the candidate Skill contracts.
9. Only after final video PASS promote Skill from `CANDIDATE` to `CANONICAL`.
