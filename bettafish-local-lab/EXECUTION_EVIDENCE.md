# BettaFish Local Lab — EXECUTION_EVIDENCE

## Event 2026-10-13 — G0 RETURN; Owner relay of Codex completion
AUTHORIZED_GATE: `BTFL-G0-READONLY-DISCOVERY-20261013`
EXECUTOR_RESULT: `RETURN_NO_SAFE_CHECKOUT`; `STOP_AT_REVIEWER=YES`
REVIEWER_STATUS: `RETURN_NO_SAFE_CHECKOUT` (not PASS; not PASS_CANDIDATE accepted)
SOURCE: `OWNER_REPORTED` — text relayed by Owner from local Codex. These statements are NOT Reviewer `DIRECT_READBACK` from Owner Windows host.

PREFLIGHT_FACTS:
- Reported Windows 11 Home build 26300; PowerShell 7.6.5; non-admin.
- Reported Docker Desktop Engine 4.88.1; Docker Compose 5.4.0 usable.
- Reported target ports 5000, 8501-8503, 5444 unoccupied; BettaFish container/network/volume/image not detected.
- Reported C drive headroom approximately 205 GiB; available system RAM ~1.4 GiB. RAM headroom is inadequate for conservative initial multi-service rollout pending reconciliation.
- Reported Codex current workdir is not a Git repo; local canonical checkout/HEAD/worktree/path conflicts and remote/console target identity were not proven.
- Upstream official source/doc review reported: BettaFish at b67928ff1ce515dd7672408221fb1e9500d0972d, Compose references `latest`, Postgres 15, binds default 5000, 8501-8503, 5444, mounts .env/DB/reports; no healthcheck observed; GHCR metadata has amd64 digest but digest/source correspondence unproven.
- Platform-specific crawling, credentials/model use: not attempted.

ACTUAL_CHANGES: `NONE_TARGET` reported. No installation, image pull, container start, network/VPN/route/firewall mutation, or Secret reads reported. No new execution Evidence file was written to GitHub by Executor.

REASON_FOR_RETURN: Gate required safe management repo checkout and evidence write; current workdir was not a Git repo and source/worktree identity was unresolved.

OBJECTIVE_READBACK: Reviewer separately verified `entropy-student/project` main has `bettafish-local-lab/REVIEWER_HANDOFF.md` and `G0_LOCAL_READONLY_DISCOVERY_GATE.md`. Evidence files absent on GitHub before Reviewer record. Reviewer did not independently verify physical Windows probes.

ANOMALIES: Lack of local checkout is a reporting-workflow blocker, not proof that local Docker is broken. Some target physical-host identity and RAM capacity facts remain UNKNOWN. No proof of any BettaFish deployment.

ROLLBACK_EFFECT: Reported target unchanged; G0 does not need runtime rollback.

NEXT_ACTION: Reviewer avoids forcing a local management checkout. Run narrowly scoped G0R read-only physical-host/resource confirmation; report via sanitized completion text; Reviewer records Evidence to GitHub and gates G1 on resource safety and identity.

## Event 2026-10-13 — Reviewer canonical documentation
PROVENANCE: `DIRECT_READBACK` applies only to GitHub repository records through the connected GitHub connector, NOT Owner Windows runtime. This file records the G0 return from Owner-provided Codex text. Reviewer commits under isolated `bettafish-local-lab/` path; no target changes.

## Event 2026-10-13 — G0R resource read-back returned
AUTHORIZED_GATE: `BTFL-G0R-READONLY-TARGET-RESOURCE-20261013`
EXECUTOR_RESULT: `RETURN_RESOURCE_HEADROOM_INSUFFICIENT`; `STOP_AT_REVIEWER=YES`
REVIEWER_DECISION: `RETURN_RESOURCE_HEADROOM_INSUFFICIENT`; do NOT enter G1 Docker deployment.
SOURCE: `OWNER_REPORTED` from local Codex sanitized evidence relayed by Owner; this is not direct reviewer access to the Windows physical host.

TARGET_LOCAL_PROOF: Codex host-process ancestry on Windows 11 and HP OEM mobile workstation; WSL/SSH context markers absent; console/RDP markers unavailable. No identifying host/user values output. This makes Owner-local execution plausible, with session type remaining UNKNOWN.
PS_VERSION: 7.6.5.
OS: Windows 11 Home Chinese edition, build 26300.
HOST_TOTAL_RAM_GiB: 15.28.
HOST_AVAILABLE_RAM_GiB: 1.78 (G0R instant sample).
DOCKER_ENGINE_RAM_GiB: 7.40 (engine's visible total capacity, **not** Docker's free RAM nor current consumption).
DOCKER_RESPONSE_EXIT: 0.
RESOURCE_CRITERION: ~4 GiB currently available host RAM for conservative app + PostgreSQL first run; project-specific planning criterion, NOT validated upstream minimum. Current shortfall ~2.22 GiB. Host fails, engine reported capacity above criterion; neither alone proves successful startup.
ACTUAL_CHANGES: `NONE` reported; no process termination, config/network/VPN mutation, image pull, container execution, or Secret use.
ANOMALIES: Console/RDP markers unavailable; memory dynamic and must be freshly rechecked before any resource-consequential start.
ROLLBACK_EFFECT: NONE_TARGET reported; no target rollback.
FOLLOW_UP: Owner may choose to save work and close **their own** nonessential apps (no automatic killing). Only then perform a bounded read-only RAM + engine recheck under `G0M_MEMORY_RECHECK_GATE.md`; return to Reviewer to decide whether to authorize a separate G1. No next Gate is implicitly preauthorized to deploy.


## Event 2026-10-13 — Reviewer source read-back and Owner direction change (no Executor runtime)

SOURCE: `DIRECT_READBACK` of GitHub upstream at identified immutable Git refs, not Owner-local runtime.
OWNER_DIRECTION: Keep BettaFish as canonical project; prioritize its embedded crawling module + data export, let existing local Codex analyze; no separate BettaFish AI analysis or full Compose startup unless justified later.
UPSTREAM_BETTAFISH_COMMIT: `b67928ff1ce515dd7672408221fb1e9500d0972d`.
PINNED_SUBMODULE: `MindSpider/DeepSentimentCrawling/MediaCrawler` Git tree mode 160000 SHA `4de2a325a9cd4f7de7dfb58204b154fc2bb86e40`; this SHA differs from any moving upstream MediaCrawler main branch and must be honored.
SOURCE_FILES_READ: BettaFish `.gitmodules`, `MindSpider/main.py`, `MindSpider/README.md`, `MindSpider/DeepSentimentCrawling/platform_crawler.py`; MediaCrawler at pinned submodule SHA `cmd_arg/arg.py`, `config/base_config.py`, `tools/async_file_writer.py`, `store/xhs/__init__.py`, `docs/data_storage_guide.md`, `main.py`, `pyproject.toml`, `LICENSE`.
FINDINGS:
- Parent MindSpider wrapper depends on database-sourced extracted keywords for deep sentiment; overrides MediaCrawler output to `postgres` or `db`. It writes generated database configuration (potential plaintext credentials) into MediaCrawler `config/db_config.py`. Do NOT use this wrapper in a lightweight export probe or let it touch a real Secret.
- Pinned MediaCrawler itself has CLI `--platform xhs`, `--type search`, `--save_data_option json|csv|excel|sqlite|postgres...`; the pinned version's option enumeration does NOT list JSONL. Latest upstream may support JSONL, but that does not apply to pinned candidate. Choose JSON for first export.
- Pinned xhs `store/xhs/__init__.py` builds note/comment dictionaries including note_id, note_url, source_keyword, xsec_token and comment_id/note_id/content. Treat raw links, tokens, author IDs and comments as private/sensitive; logs can include them.
- Pinned MediaCrawler `config/base_config.py` defaults `ENABLE_CDP_MODE=True` and `SAVE_LOGIN_STATE=True`, risking reuse/control of existing Chrome/Edge profiles when real crawler starts. Offline Gate must not run crawler, browsers, CDP, or read browser profiles. Future separate Gate must isolate browser profile/cookies and authorize platform login.
- Pinned MediaCrawler `LICENSE` is NON-COMMERCIAL LEARNING LICENSE 1.1; learning/research only, cannot assume commercial redistribution/service rights. Platform rules and access rights still apply.
- Current G0R `1.78 GiB` RAM sample is outdated after Owner voluntarily closed apps; later informal 3.1 and 3.6 GB readings are Owner-reported approximate different units, not a validated G0M pass. Full Compose's ~4 GiB RAM criterion remains intact; source-only smoke does not start Compose.
ACTUAL_CHANGES: Reviewer documentation only; no Owner host installation/start/credential/platform action.
NEXT_GATE: `BTFL-G1L-ISOLATED-CRAWLER-EXPORT-OFFLINE-20261013`; code/data fixture smoke, no crawler execution. Formal PASS of offline export does NOT imply authentic crawl works.

## Event 2026-10-13 — Official memory recommendation independently verified
SOURCE: `DIRECT_READBACK` GitHub official `666ghj/BettaFish` `README.md` and `README-EN.md` from current upstream, section "运行环境要求" / Requirements.
FINDING: Official memory recommendation is "建议2GB以上" / "2GB+ recommended". Source does not assert 4 GiB currently free host RAM is necessary. Earlier Reviewer ~4 GiB free RAM planning condition was deliberately conservative for full multi-service Compose, not an upstream requirement and not applicable to G1L source-only Gate. This is a clarification, not a correction to the historical G0R raw measurement.
ACTUAL_CHANGES: GitHub project documentation only, no Owner-local host action.

## Event 2026-10-13 — G1L Codex result reviewed; accepted as PARTIAL / source readiness

AUTHORIZED_GATE: `BTFL-G1L-ISOLATED-CRAWLER-EXPORT-OFFLINE-20261013`.
EXECUTOR_RESULT: `PASS_CANDIDATE`; `STOP_AT_REVIEWER=YES`.
REVIEWER_STATUS: `PARTIAL` (bounded offline source-contract candidate supported; local synthetic artifacts, exact runtime workspace and resource use remain `OWNER_REPORTED`, not independently inspected by current Reviewer; formal full Gate PASS withheld). Low-risk G2 isolated preparation may still proceed without presuming real crawl or resource PASS.
PROVENANCE: `OWNER_REPORTED` for local Codex execution, checkout, filesystem, simulated files, system readings, subprocess actions. `DIRECT_READBACK` for Reviewer independent upstream GitHub source-file/gitlink review. No reviewer direct physical Windows files/runtime.
PREFLIGHT_FACTS:
- Same Windows 11 26300, PowerShell 7.6.5, HP OEM portable workstation, Codex parent, no WSL/SSH markers; console/RDP marker unavailable, no personal ID. Host facts only Owner relay.
- Root commit `b67928ff1ce515dd7672408221fb1e9500d0972d`; pinned MediaCrawler Gitlink `4de2a325a9cd4f7de7dfb58204b154fc2bb86e40`; source proven separately in GitHub.
- Host currently available RAM pre 4.12 GiB / after 2.65 GiB, low point 2.27 GiB; resource snapshot fluctuated. Cannot attribute ~1.47 GiB drop to git checkout alone. Target disk post free 204.68 GiB.
ACTUAL_CHANGES: Owner reports one newly created isolated checkout rooted under expected LOCALAPPDATA project namespace plus exactly three synthetic JSON files under offline-smoke. Reported checkout volume-delta 411.49 MiB, owned directory 383.96 MiB; no tracked-code changes; submodule clean; no deps install, crawl, browser, Docker, platform access or credentials.
OBJECTIVE_READBACK: Codex reports pinned independent CLI `main.py` with xhs/search/keywords/comments/save_data_option=json support; source-only not executed. Builtin JSON-array writer path `data/{platform}/{format}/{type}_{item}_{date}.{format}`; JSON/CSV supported, JSONL not proven. Reviewer independently confirms pinned source CLI/options/exporter and MindSpider wrapper DB coupling.
SYNTHETIC_VALIDATION (OWNER_REPORTED):
- 3 invented notes, 4 invented comments; 4 note_id joins, zero orphan comments; required keyword/time fields present. Initial PowerShell array parser issue corrected, no new failure after reread.
- Artifact SHA256 labels: notes.json `15b4d5f59f4fef49a5649ed93d690a34a9805a5d1b5b1a25d6187ed10865c5b9`; comments.json `a5b3da3eca51c832773082862dd3c7efde8f517c429b6d42994b1492cff9fa7d`; summary.json `d8544aff62b4456eccfa81bfdc1ac0f00e5bf560aeeed5ec86bbaaa42e9c542a`. SHA strings format-valid; file bytes never independently accessed or hashed by Reviewer.
RISKS: Pinned XHS note URL can embed sensitive xsec_token; code/console logs may carry credentials, profiles, IDs. CDP default true risks existing Chrome/Edge session. Noncommercial learning license. Real crawl untested.
ADDITIONAL_REVIEWER_DIRECT_SOURCE_FINDING: Pinned `media_platform/xhs/core.py` `search()` has `xhs_limit_count=20` and forcibly sets `CRAWLER_MAX_NOTES_COUNT` to at least 20 if smaller (lines 128–131). Therefore setting note limit=1 in config does NOT prove 1-note canary. An explicit reviewed execution-time guard before network/details/save is required before a real crawl; do not automatically authorize real social actions from this result. Comment count also requires a verified hard upper bound.
RESOURCE_OR_BUSINESS_DELTA: No report of charges/external actions; file staging ~0.4 GiB, free RAM variable. Real source-only lightweight candidate, NOT actual crawl or full Compose readiness.
ROLLBACK_EFFECT: Only project-new owned files; no deletion requested or authorized; G2 must verify source checkout state first.
NEXT_ACTION: G2 isolated dependency + true `AsyncFileWriter` synthetic export smoke; no real crawler/platform/browser/auth; bounded memory/disk and exact existing workspace. Future G3 authentication/real XHS crawl requires explicit Owner authorization + safe one-item hard guard verification and platform compliance.

## Event 2026-10-13 — Reviewer inspected Docker deployment source, no local runtime action
SOURCE: `DIRECT_READBACK` GitHub `666ghj/BettaFish` at `b67928ff1ce515dd7672408221fb1e9500d0972d` for `docker-compose.yml`, `Dockerfile`, `.env.example`, `app.py`, `config.py`, `README.md`.
OWNER_DIRECTION: return to Docker/rapid application delivery instead of unexecuted Windows Python/venv G2.
FINDINGS:
- Official Compose image `ghcr.io/666ghj/bettafish:latest` and `postgres:15`; default `ports` publishes 5000 and 8501-8503 plus PG 5444 without localhost restriction. Default Compose NOT authorized as-is.
- Official `app.py` `CONFIG_KEYS` (lines 85–117) includes DB_PASSWORD and many LLM API_KEY fields; `read_config_values` (lines 134–151) returns literal values, and unauthenticated `GET /api/config` (lines 1203–1211) and `POST /api/config` (lines 1214–1235) expose/edit config. Material credential/data confidentiality risk. G2D requires deny guard through app-unpublished reverse proxy; no real credentials except disposable DB secret; no real API/model keys.
- `app.py` only initializes Streamlit/Forum/Report after user `POST /api/system/start` (lines 1249ff), thus frontend UI process can be smoke-checked without analytical engines; guarded proxy blocks this.
- Official Dockerfile installs large scientific Python, PyTorch dependency list and Playwright Chromium; prefer prebuilt official image pin-by-digest for speed. Image-to-source immutable correlation remains UNKNOWN.
- README officially recommends machine RAM >2GB (not 4 GiB currently free); no blanket available memory Gate for G2D. Memory must be monitored when starting actual containers.
- No Owner host Docker images/containers were started by Reviewer; no local credentials acquired.
NEXT_GATE: `BTFL-G2D-DOCKER-LOCALHOST-RAPID-BOOT-20261013`.
