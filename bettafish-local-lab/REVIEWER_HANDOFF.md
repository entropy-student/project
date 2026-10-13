# BettaFish Local Lab — REVIEWER_HANDOFF
> PAUSED_BY_OWNER: 2026-10-13. Owner's active goal moved to a NEW independent original MediaCrawler Windows WebUI project at `mediacrawler-local-lab/`. Preserve all BettaFish G0/G1L/G2D history and existing local files; **do not execute** conditional Hostinger G2H or retry Docker G2D without new Owner approval.
> Updated: 2026-10-13
> Governance: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7 ACTIVE_PROVISIONAL
> Project: entropy-student/project main:bettafish-local-lab/
> Default executor: Owner Windows 11 local Codex; Reviewer GitHub records
> STOP_AT_REVIEWER: YES

## PROJECT_GOAL
Historically BettaFish served as a candidate for keyword-based collection and AI sentiment analysis. **Owner switched active product on 2026-10-13 to independent original MediaCrawler local Windows WebUI**. This BettaFish project is a preserved **PAUSED_BY_OWNER** historical project; do not redeploy it or resume full Docker/Hostinger evaluation without new explicit Owner choice.

## PROJECT_STAGE
**PAUSED_BY_OWNER — NO ACTIVE EXECUTION GATE.** Historical: G1L locked source and simulated notes/comments partial, G2D Docker official image pull returned `RETURN_RESOURCE_PRESSURE` before deployment, possible partial Docker pull cache left; G2H conditional Hostinger preflight not executed. No further local/network actions authorized for BettaFish.

## SYSTEM_MAP
- Owner physical host (Owner-reported via Codex): HP OEM Windows 11 Home 26300, PowerShell 7.6.5, Docker Desktop Engine 4.88.1 / Compose 5.4.0 previously available. Host RAM total 15.28 GiB, G1L available RAM fluctuated 4.12 → 2.65 GiB (min 2.27). Docker Engine memory capacity 7.40 GiB, **not free/current use**. Official README recommends 2GB+ total machine RAM; prior Reviewer 4GiB FREE threshold was extra conservative and is NOT binding on revised scoped Docker Gate. Resources must be monitored at runtime and fail-closed if pressure.
- Existing checked-out source reportedly at `%LOCALAPPDATA%\BettaFishLocalLab\crawler-lite-smoke-v1`: BettaFish `b67928ff1ce515dd7672408221fb1e9500d0972d`, Gitlink MediaCrawler `4de2a325a9cd4f7de7dfb58204b154fc2bb86e40`. Keep this G1L source and fixtures untouched. Full Docker G2D will use **official prebuilt image**, tag resolved once to immutable digest at runtime, NOT a from-source build; digest-to-source SHA correspondence unverified, must not claim it.
- Official Compose: `ghcr.io/666ghj/bettafish:latest` + `postgres:15`. Default publishes app 5000/8501–8503 and DB 5444 broadly; **must not use unchanged**. G2D derives project-owned private Compose with proxy, isolated network/DB volume, no direct app or DB host published ports; only proxy `127.0.0.1:5000`. Optional three-image deployment: BettaFish, PostgreSQL, nginx:stable-alpine; pin all exact OCI digests after retrieval.
- Critical upstream bug reviewed directly: `app.py` `GET /api/config` enumerates DB_PASSWORD + LLM API_KEY and `POST /api/config` updates config without authentication. G2D proxy must **block `/api/config` both verbs, `/api/system/start`, `/api/search`, and default block other `/api/` except harmless read-only `/api/system/status`**; site is UI smoke, not working analysis suite. Never place real external credentials in this app now. URL accessibility alone does not constitute confidentiality.
- Upstream Flask `app.py` waits for front-end command before starting three Streamlit agents. In G2D do not invoke `/api/system/start`; only public site/UI and database process/readiness. The official image may not contain a ready standalone CLI or same source revision as pinned checkout; determine later.
- Historically planned G2D path (NOT active after resource RETURN): brand-new project-only `%LOCALAPPDATA%\BettaFishLocalLab\docker-app-v1` (no overwrite). Compose namespace `btfl-local-docker-v1`; volumes/network namespaced. Test DB strictly disposable empty/new. Runtime secrets generated only under explicit Owner delegation for this named project+target in strict private store, not shown in logs or Compose command and not written to GitHub. Password matched through protected app.env bind and Postgres `_FILE` secret, not ordinary environment variable/Compose interpolation. App model keys empty.
- Source-only G1L established pinned independent MediaCrawler CLI JSON/CSV export; underlying MindSpider wrapper forces DB, and XHS `media_platform/xhs/core.py` overrides note count below 20 to 20. Any future real one-note canary requires a hard guard; no login/CDP/cookies in G2D. Latest MediaCrawler main != BettaFish pinned submodule.
- User Edge/ChatGPT/Codex, Docker system settings, VPN/Clash/HY2/WG and other projects are untouchable.

## CURRENT_ACCEPTED_STATE
Reviewer DIRECT_READBACK: GitHub source/Compose/README, unauthenticated `/api/config` problem and project documentation. G2D Docker Executor report OWNER_REPORTED: preflight available RAM low sample 4.349 GiB; during GHCR pull fell 0.793 GiB; after cancellation 0.587–0.606 GiB. Engine capacity 7.40 GiB; disk free 200.49 GiB. BettaFish image incomplete, PG/Nginx not pulled; no Compose manifest, project containers/networks/volumes/secrets/ports. Non-target services reported unchanged; partial Docker pull cache possible and must be left intact unless scoped cleanup authorized. No local app PASS or direct Windows Reviewer verification.

## CURRENT_GATE
**NONE (PAUSED_BY_OWNER).** Former G2H resource check is canceled from active queue and may not run without a new Owner decision. Active new project: `mediacrawler-local-lab/G1_WINDOWS_ORIGINAL_WEBUI_LAUNCH_GATE.md`.

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
G1L source/synthetic unchanged. G2D cancelled incomplete image pull; Owner reports zero project containers/volumes/networks, no credentials or app folder. Potential partial Docker download cache is UNKNOWN/left in place. No rollback action required; DO NOT execute global prune or delete other Docker artifacts. Future isolated server deployment needs its own rollback/backups and dedicated target/authority proof.

## UNRESOLVED
Root cause of temporary host memory reduction while pulling image UNKNOWN (no process-specific evidence); current host post-cancel RAM about 0.59 GiB at last reported sample. Hostinger KVM2 current free RAM, CPU, Docker presence, existing workloads and isolation are NOT freshly verified; consent to SSH/remote host checks has NOT been granted. Full-app vs embedded-crawler-only Docker deployment decision depends on target resource/readiness. Also image source/digest correlation, usable XHS login/network/terms, actual crawler export and 20-note default minimum guard remain unresolved.

## NEXT_STEP
NONE for BettaFish until Owner explicitly resumes it. The only currently authorized next installation Gate is the independent original MediaCrawler local Windows WebUI in `mediacrawler-local-lab/`.

## OWNER_ACTION_REQUIRED
NONE for BettaFish. Do not delete old BettaFish files, retry GHCR pulls, modify local Docker, or contact Hostinger as part of this paused project.

## EVIDENCE_POINTERS
- `G2D_DOCKER_LOCALHOST_RAPID_BOOT_GATE.md` historical resource RETURN (not active).
- `G2H_HOSTINGER_REMOTE_READONLY_CAPACITY_GATE.md` conditional proposed next Gate, not preauthorized.
- `EXECUTION_EVIDENCE.md` historical G1L and Reviewer Docker findings.
- `DECISION_LOG.md` Docker pivot and remaining data acquisition scope.
- `G2_ISOLATED_RUNTIME_EXPORT_SMOKE_GATE.md` canceled/deferred before execution.
- `G0M_MEMORY_RECHECK_GATE.md` historical inactive full-stack memory preflight.
