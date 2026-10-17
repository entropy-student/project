# MokerSaaS G1X — Reviewer decision: first localhost site operational

> REVIEW_DATE: 2026-10-17
> GATE_ID: MOKER-G1X-DOCKER-NATIVE-LOCAL-FIRST-BOOT-20261017
> EXECUTOR_RESULT: PASS_CANDIDATE
> REVIEWER_MILESTONE_DECISION: SITE_UP_ACCEPTED_FOR_OWNER_LOCAL_EVALUATION
> FORMAL_GOVERNANCE_PASS: NOT_ATTESTED_BY_REVIEWER — detailed Owner-relayed Executor DIRECT_READBACK packet was inspected, but independent Docker/HTTP raw artifacts are unavailable to this Reviewer; per VNEXT.md §7 Executor self-report alone is not independently verified control-plane Evidence. This is NOT a new RETURN or a request to repeat the successful first boot.
> STOP_AT_REVIEWER=YES; G2/REAL_PAYMENTS/PRODUCTION=NOT_AUTHORIZED
> CURRENT_SITE_OWNER_LOCAL: http://127.0.0.1:3077 (reported running, HTTP 200 on Windows Owner device)

## Decision summary
**The practical first-boot objective has been achieved according to the detailed Owner-local Executor report.** The site and new DB remain running for Owner to open and explore. The previous Windows-host Secret mount and .NET stdin fixes were eliminated from the active path by NEW Docker-native synthetic credentials and isolated volumes. No further first-boot Gate is necessary. The exact positive/negative observations below are Owner-relayed local DIRECT_READBACK, not first-hand Reviewer host inspection.

## Scope-by-scope adjudication

| Gate acceptance element | Local Executor evidence | Reviewer judgment |
|---|---|---|
| Fixed source, previously built app | Pinned `c98f68c68de312cc1378130b96f82418e22bd5f3`, 22 retained edits; existing G1P2 image immutable ID unchanged | ACCEPTED AS REPORTED |
| Docker-native Secrets | Two isolated new Secret volumes, OS CSPRNG 32-byte entropy each; initial empty, initializer container IDs `ac7e66c0a192…` and `d4fe813af2e9…` exit 0; no values/hashes exposed; 0:31001:0440 and 0:31002:0440 | ACCEPTED AS REPORTED (synthetic-only; not production Secret lifecycle approval) |
| Service authorization | Four separate DB predicates PASS; app UID 1000 can read DB+NextAuth; migrator UID 1000 only DB; DB not granted NextAuth; readonly mounts | ACCEPTED AS REPORTED |
| New DB/schema | NEW G1S Postgres healthy, OOM false, authenticated read; 17 public tables, 155 constraints, one synthetic account with role=user; old DB healthy and identity unchanged | ACCEPTED AS REPORTED; no old-DB byte-level comparison |
| Actual localhost | App healthy, Windows loopback 127.0.0.1:3077, HTTP 200; G1P2 image ID unchanged | **SITE_UP accepted** based on Owner-local direct readback; Reviewer cannot connect to Owner's localhost |
| Authentication/admin | Signup HTTP 200, credential login 302, session 200/user exists; nonadmin admin/users 403; anonymous set-admin GET/POST 404 | BASIC_AUTH_AND_ADMIN_GUARDS accepted AS REPORTED; 302 redirect by itself not login success, but session confirms |
| Provider blocking | Credentials-only OAuth provider list; local email suppression; Stripe checkout/session/portal/webhook, withdrawal, cron 503; LOCAL_LAB=1; third-party key env count=0 | SAFE-LOCAL-SMOKE accepted AS REPORTED. No real Stripe/Resend/Neon/OAuth calls; negative checks don't prove complete zero egress globally |
| Asset preservation | OLD DB container/volume/network healthy and identity preserved, old Windows Secrets/images and historical named volumes kept; new DB volume/network reused; no down -v | ACCEPTED AS REPORTED |
| Build/call details | First offline migrator build failed at Corepack; one online bounded build fetched fixed pnpm from npm registry; new migrator image `sha256:63afa66cbc871809288bb2b4273b24f6d28823b9b38d0658d026f0cd7b1d36e5` | BUILD COMPLETED; npm registry is a build-time package source, **not** a business Provider call; strict air-gap NOT established |
| Migration attempts | First init failed Corepack/DNS BEFORE Drizzle, fresh DB readback showed 0 tables; corrected command then ran schema exactly once successfully | No evidence of duplicate schema mutation; ACCEPTED AS REPORTED |
| Extra anonymous volume | Audit of Postgres image created anonymous volume, inspected empty, retained | NONBLOCKING inventory/cleanup debt; not an excuse for another boot or destructive cleanup |

## Noteworthy network boundary / limited assurance
- Docker Compose initially attached app to internal network only; reported host publish not operational. App subsequently attached to a **dedicated new project-only bridge** with IP masquerading disabled, while remaining on internal G1S network to reach DB. DB does NOT join host-facing bridge; no host DB port. Host binding verified by Executor at **127.0.0.1:3077 only**. This is a pragmatic G1S-only publishing correction within the local test maximum endpoint, not a global Docker/network change.
- Docker bridge documentation describes distinct port publishing and masquerade options. `enable_ip_masquerade=false` disables IPv4 source NAT on that bridge, **not a rigorous proof of no possible outbound traffic over all protocols/routes**; because current environment includes multiple networks, no generalized network isolation or future public deployment certification is inferred. Official reference: https://docs.docker.com/engine/network/drivers/bridge/
- No runtime business Provider calls reported and API guard smoke 503 where relevant. Scope is strictly **synthetic local lab** and loopback; no real checkout, webhooks, refunds, referral payouts, public deployment, real users or production deployment.

## Evidence/provenance
- Reviewer directly inspected this conversation's detailed Owner-forwarded Executor packet, source of every runtime detail above. Executor marked host test values DIRECT_READBACK and physical Owner device identity OWNER_REPORTED. **Reviewer has not directly inspected raw Docker inspect/logs, original local Compose diff, container filesystem, HTTP transcripts, or Linux provenance artifacts.** As Governance v0.2.7 §7 says `Executor self-report is a claim, not proof`, formal audited `PASS` is intentionally not asserted. This limitation does not negate the materially successful Owner-local site launch or require a new test cycle simply to access the site.
- Source/decision documents read by Reviewer: latest `G1X_DOCKER_NATIVE_LOCAL_FIRST_BOOT_GATE.md`, `REVIEWER_HANDOFF.md`, `DECISION_LOG.md`, prior G1U/G1TRF Evidence, and Governance `VNEXT.md` v0.2.7.
- G1X is **operationally completed for first local use**, with state `PASS_CANDIDATE_REVIEWED__SITE_UP_ACCEPTED`, no active Executor Gate after this closeout. No reexecution requested. In a later, **separately requested production or full evidence-audit stage**, exact redacted Docker/HTTP control-plane artifacts and source/Compose diff would need Reviewer inspection before claiming formal security audit PASS or widening access.

## Owner now
Open `http://127.0.0.1:3077` **on the Windows host running Docker Desktop**. No need to restart or redeploy. Test and judge UI features and commercial fit. Keep app and new DB running. Avoid entering real credentials, customer data or making real payments. A future UI/product evaluation is distinct from G1X installation; only pursue it if Owner asks.

## No cleanup automatic
Old DB/container/volumes/network, all original Windows protected credentials, old+new Docker secret volumes, new DB network/volume, previous audit containers, 22 local source changes, G1P2 image, new migrator image, and one empty anonymous audit volume are to remain as reported. Any later cleanup must have exact-object allowlist and Owner scope; no speculative prune/down -v/Secret rotation.

## Project governance
Use `VNEXT.md` v0.2.7 §5 combined Gate, §6 classify prior attempts, §7 independent reviewable evidence, §10 durable Evidence/Handoff, §11B runtime Secret boundary, §11C host vs bridge/private network and frontend/DB health distinction. No operational Governance change is justified solely by this local first-boot process. Historical RETURN Gates remain non-executable.
