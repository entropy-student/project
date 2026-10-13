# BettaFish Local Lab — REVIEWER_HANDOFF
> Updated: 2026-10-13
> Governance: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7 ACTIVE_PROVISIONAL
> Project: entropy-student/project main:bettafish-local-lab/
> Default executor: Owner Windows 11 local Codex; Reviewer GitHub records
> STOP_AT_REVIEWER: YES

## PROJECT_GOAL
Owner explicitly requested return to **Docker-based local deployment** for the existing BettaFish project, emphasizing quick relocation and a usable running application. First milestone: guarded localhost-only BettaFish web UI plus disposable PostgreSQL container; existing narrower business goal remains keyword-based XHS posts/comments → export JSON/CSV → Codex analysis. Do not imply Docker UI boot automatically proves crawler or paid AI analysis. No commercial/social-account/paid API authorization.

## PROJECT_STAGE
G1L static source/3-note+4-comment mock JSON result OWNER_REPORTED as PASS_CANDIDATE, Reviewer PARTIAL. Previous G2 isolated Windows Python/venv Gate was NOT EXECUTED; **superseded/deferred** by Owner-requested Docker route. Current G2D rapid Docker deployment Gate READY_FOR_EXECUTOR. No containers yet reported launched.

## SYSTEM_MAP
- Owner physical host (Owner-reported via Codex): HP OEM Windows 11 Home 26300, PowerShell 7.6.5, Docker Desktop Engine 4.88.1 / Compose 5.4.0 previously available. Host RAM total 15.28 GiB, G1L available RAM fluctuated 4.12 → 2.65 GiB (min 2.27). Docker Engine memory capacity 7.40 GiB, **not free/current use**. Official README recommends 2GB+ total machine RAM; prior Reviewer 4GiB FREE threshold was extra conservative and is NOT binding on revised scoped Docker Gate. Resources must be monitored at runtime and fail-closed if pressure.
- Existing checked-out source reportedly at `%LOCALAPPDATA%\BettaFishLocalLab\crawler-lite-smoke-v1`: BettaFish `b67928ff1ce515dd7672408221fb1e9500d0972d`, Gitlink MediaCrawler `4de2a325a9cd4f7de7dfb58204b154fc2bb86e40`. Keep this G1L source and fixtures untouched. Full Docker G2D will use **official prebuilt image**, tag resolved once to immutable digest at runtime, NOT a from-source build; digest-to-source SHA correspondence unverified, must not claim it.
- Official Compose: `ghcr.io/666ghj/bettafish:latest` + `postgres:15`. Default publishes app 5000/8501–8503 and DB 5444 broadly; **must not use unchanged**. G2D derives project-owned private Compose with proxy, isolated network/DB volume, no direct app or DB host published ports; only proxy `127.0.0.1:5000`. Optional three-image deployment: BettaFish, PostgreSQL, nginx:stable-alpine; pin all exact OCI digests after retrieval.
- Critical upstream bug reviewed directly: `app.py` `GET /api/config` enumerates DB_PASSWORD + LLM API_KEY and `POST /api/config` updates config without authentication. G2D proxy must **block `/api/config` both verbs, `/api/system/start`, `/api/search`, and default block other `/api/` except harmless read-only `/api/system/status`**; site is UI smoke, not working analysis suite. Never place real external credentials in this app now. URL accessibility alone does not constitute confidentiality.
- Upstream Flask `app.py` waits for front-end command before starting three Streamlit agents. In G2D do not invoke `/api/system/start`; only public site/UI and database process/readiness. The official image may not contain a ready standalone CLI or same source revision as pinned checkout; determine later.
- G2D path: brand-new project-only `%LOCALAPPDATA%\BettaFishLocalLab\docker-app-v1` (no overwrite). Compose namespace `btfl-local-docker-v1`; volumes/network namespaced. Test DB strictly disposable empty/new. Runtime secrets generated only under explicit Owner delegation for this named project+target in strict private store, not shown in logs or Compose command and not written to GitHub. Password matched through protected app.env bind and Postgres `_FILE` secret, not ordinary environment variable/Compose interpolation. App model keys empty.
- Source-only G1L established pinned independent MediaCrawler CLI JSON/CSV export; underlying MindSpider wrapper forces DB, and XHS `media_platform/xhs/core.py` overrides note count below 20 to 20. Any future real one-note canary requires a hard guard; no login/CDP/cookies in G2D. Latest MediaCrawler main != BettaFish pinned submodule.
- User Edge/ChatGPT/Codex, Docker system settings, VPN/Clash/HY2/WG and other projects are untouchable.

## CURRENT_ACCEPTED_STATE
Reviewer DIRECT_READBACK: GitHub source/Compose/README and unauthenticated `/api/config` problem; current G2D documentation committed to main. Previous G1L runtime snapshots OWNER_REPORTED; no independent Reviewer verification of local G1L fixtures. No owner-local Docker app has been deployed by accepted evidence.

## CURRENT_GATE
`BTFL-G2D-DOCKER-LOCALHOST-RAPID-BOOT-20261013` at `G2D_DOCKER_LOCALHOST_RAPID_BOOT_GATE.md`, pending local Codex. The old `G2_ISOLATED_RUNTIME_EXPORT_SMOKE_GATE.md` is superseded before execution, not an active prerequisite.

## CRITICAL_CONSTRAINTS
- Only Owner's own local Windows host; no VPS/Grok Bot. No global Docker/WSL/OS/network/VPN/proxy changes; no unrelated workloads/process termination.
- Single new isolated Docker Compose project, no default upstream 0.0.0.0 ports, DB no exposed host port, app through guarded localhost proxy only. Only known project containers/images/volumes touched; no broad cleanup/prune.
- Image digests fixed, app source/image correspondence explicitly UNKNOWN until correlated. No from-source build or unbounded tooling.
- Never start analysis engines/crawler or real login/cookie/browser; no live social requests, paid model/API, real credentials or business data in disposable DB.
- API leak mitigation must pass GET + POST negative checks, plus blocked start/search and loopback-only port. Failure = contain app by stopping only project-owned containers.
- Named limited DB test password must be generated only under explicit Owner authorization in G2D relay, protected and never printed. Source .env values public examples are NOT to be used as production passwords. Stop if ACL/secret file design cannot be verified.
- Actual deployed resource/readiness evidence and safe rollback (only project compose stop/down without deleting volume) required.

## DEFAULT_EXECUTION_CHANNEL
Owner physical local Windows Codex; Reviewer owns project GitHub docs. No management repo checkout required on Executor.

## CURRENT_ROLLBACK_STATUS
G1L source/synthetic unchanged. G2D only additive project-owned folder / containers / images / namespaced Docker DB volume (disposable no real data); exact owned Compose stop/down preserves volume; removal/credential reset require further approval. Before data with value: backup/restore proof required.

## UNRESOLVED
Official GHCR image actual digest/provenance/version, image launch health and site startup, compatibility with disposable PostgreSQL, actual memory footprint, proxy guard negative access, data persistence/recovery beyond disposable smoke, embedded crawler inside image and file export, authorized login strategy, single-item XHS guard, legal/terms for commercial use.

## NEXT_STEP
Owner relays G2D only to local Codex with explicit, one-round approval for generation of disposable project-specific DB credential. Codex performs one bounded Compose deploy (pull digest → guarded localhost config → DB/Flask/proxy startup → UI/status + negative security + resource evidence). Stops at Reviewer. Then narrow real crawler acquisition/export later, with explicit owner permission.

## OWNER_ACTION_REQUIRED
Copy G2D relay into Windows Codex only if consenting to **isolated disposable test DB secret generation** in project-owned secure location. No existing credentials, app login or system settings required; report sanitized result to Reviewer.

## EVIDENCE_POINTERS
- `G2D_DOCKER_LOCALHOST_RAPID_BOOT_GATE.md` ACTIVE.
- `EXECUTION_EVIDENCE.md` historical G1L and Reviewer Docker findings.
- `DECISION_LOG.md` Docker pivot and remaining data acquisition scope.
- `G2_ISOLATED_RUNTIME_EXPORT_SMOKE_GATE.md` canceled/deferred before execution.
- `G0M_MEMORY_RECHECK_GATE.md` historical inactive full-stack memory preflight.
