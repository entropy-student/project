# Skill Extraction R2 — Candidate Migration Review

Date: 2026-09-22

Result:
`PASS`

Target:
`entropy-student/spike.skill/story-showrunner`

Candidate status:
`CANDIDATE / E2E_NOT_YET_PROVEN`

## Scope completed

R2 created the portable Story Showrunner candidate and resolved all remaining P1 structural splits.

Extracted candidate layers:
- Core references;
- AI Domain Adapter;
- Antigravity / CosyVoice / Nano Banana provider adapters;
- editorial / visual / character / voice profiles;
- reusable schemas;
- episode + production package templates;
- runtime-state locator;
- candidate/migration metadata.

Approximately 33 candidate files were created or migrated under:
`story-showrunner/`

## P1 resolution

### C10 Writer vs editorial profile
PASS.
Generic Writer rules are in Core; Bilibili/Jingsui/first-person behavior is in editorial profile.

### C11 Identity contract vs CHAR_IP_001
PASS.
Generic reference precedence/drift policy is Core; exact adult male/burgundy/cream identity lives in the character profile.

### C12 Visual style
PASS.
Simplified Flat Narrative Comic is a visual profile, not Core.

### C13 Provider lock
PASS.
Core Executor Contract is provider-neutral; Antigravity, CosyVoice and Nano Banana are adapters.

### C14 Local machine paths
PASS.
Portable voice profile uses logical resource IDs; no Owner-machine absolute path is canonical Skill content.

### C15 Live Calendar/Registry
PASS.
RuntimeStateLocator resolves live Calendar/Registry/Radar/Evergreen data outside Skill source.

### C16 Schema identity
PASS.
Migrated schema `$id` / titles use `story-showrunner`.

### C17 Visual Beat timing source
PASS.
Candidate Visual Beat schema locks `timing_source = PRODUCTION_SRT`.

### C18 Timing vocabulary
PASS.
Timing Compiler contains one explicit dramatic-kind → voice-pace mapping.

Additional self-review finding:
the generic table originally allowed `REACTION → SLOW_NORMAL`, but the current CosyVoice v2.1 profile has no independently calibrated SLOW_NORMAL speed.
Repair:
- current profile: voiced REACTION → NORMAL;
- dramatic breathing → authored pause/hold;
- optional SLOW_NORMAL only when a selected future profile explicitly supports it;
- unsupported pace class returns `RETURN_TIMING_PROFILE_CLASS_UNSUPPORTED`.

## Stale-rule audit on candidate repo

Searched for:
- `AUDIO_MODE=A_UPSTREAM_COSYVOICE`
- `AUDIO_MODE=TBD`
- Owner Windows absolute path `C:\\Users\\34707`
- old Writer `5.0 chars/s`
- `FINAL_AUDIO_ALIGNED`
- `G5 = IN_PROGRESS`

Result:
`0 candidate hits`

## Intentional exclusions

Not migrated:
- project CURRENT_STATUS / historical handoff;
- episode artifacts;
- G4/G5 Pilot history;
- raw v1/v2 calibration evidence;
- generated binary assets;
- live Calendar/Registry;
- machine-specific runtime paths.

## E2E boundary

R2 proves **clean extraction**, not production completion.

Canonical promotion remains blocked until the current validation episode runs:

```text
story-showrunner candidate
→ Production SRT
→ TTS Manifest
→ Director/Asset mapping
→ full Production Package
→ Antigravity
→ final video
→ final QA
```

## Decision

`SKILL_EXTRACTION_R2 = PASS`

Next:
resume G6 in the validation project.

Immediate next task:
compile the locked Blind Search Answer script into Production SRT + TTS Manifest using the portable candidate Timing Compiler and CosyVoice v2.1 profile.
