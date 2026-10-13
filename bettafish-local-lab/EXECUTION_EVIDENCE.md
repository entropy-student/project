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
