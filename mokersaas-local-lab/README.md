# MokerSaaS Local Lab — start here

> LAST_REVIEWED: 2026-10-17
> CANONICAL_HANDOFF: [REVIEWER_HANDOFF.md](REVIEWER_HANDOFF.md)
> G1X_REVIEW_DECISION: [G1X_REVIEWER_ACCEPTANCE_2026-10-17.md](G1X_REVIEWER_ACCEPTANCE_2026-10-17.md)
> CURRENT_EXECUTOR_GATE: NONE (G1X operationally complete, not executable again)
> STOP_AT_REVIEWER=YES; G2 / real payments / production NOT AUTHORIZED

## Current result

**Owner-local Windows first boot has succeeded according to Codex DIRECT_READBACK.** MokerSaaS app and independent new G1S PostgreSQL container are running/healthy. The Owner Windows browser site `http://127.0.0.1:3077` reported actual HTTP **200**. New schema: 17 public tables, 155 constraints. Local synthetic signup/signin/session, ordinary nonadmin rejection, anonymous set-admin GET/POST denial and local provider fail-closed tests reported.

**Reviewer decision:** SITE_UP_ACCEPTED_FOR_OWNER_LOCAL_EVALUATION. No additional first-boot repair Gate and no need to re-run the successful setup. Formal independently audited Governance PASS is **not attested** because Reviewer has inspected the supplied detailed Owner-forwarded Executor results, not raw native Docker/HTTP artifacts (§7). This limitation does not require another deployment loop merely to browse the site.

## Owner — next action

On the **same Windows machine** where Docker Desktop runs, open:

**http://127.0.0.1:3077**

Use only synthetic data. Leave the local app/database running for browsing. No new credentials, purchases or approvals needed. Do not type live Provider secrets or accept real customer payments in this sandbox.

## Important architecture and retained assets

- G1X moved disposable credentials generation **inside Docker**, avoiding prior Windows single-file bind and PowerShell stdin transport failures. TWO separate lab-only Secret volumes and least-privilege read-only DB/app/migrator mounts; original Windows protected credential files untouched. G1P2 app image reused, a new migrator image built.
- Old DB `mokersaas-local-lab-db-1`, old data volume/network, 22 locally modified MokerSaaS files, prior images, old G1U Secret volumes and all historical audit artifacts remain. No delete/reset/cleanup. New G1S DB volume/private network reused.
- App is attached to project internal network and a dedicated project-only bridge with masquerading off so Windows loopback publishing works; **DB has no host 5432 publish**. Loopback 127.0.0.1:3077 is the only reported host app listener. Masquerading off is not a complete universal egress guarantee.
- Migrator build downloaded a fixed pnpm version from npm registry after offline Corepack build failed; **no real business Provider calls** were reported. One verified-empty anonymous Postgres audit volume was retained.
- G1X is **a local synthetic smoke test**, NOT authorization for real Stripe/Resend/OAuth, money, webhook processing, automatic cron/payout, real users, production deployment or public routing.

## New Reviewer — exact reading order

1. [REVIEWER_HANDOFF.md](REVIEWER_HANDOFF.md) — unique current state, old/new resources and no active Gate.
2. [G1X_REVIEWER_ACCEPTANCE_2026-10-17.md](G1X_REVIEWER_ACCEPTANCE_2026-10-17.md) — review disposition, evidence-by-acceptance matrix, limitations.
3. [EXECUTION_EVIDENCE.md](EXECUTION_EVIDENCE.md) — read latest G1X section and only earlier relevant historical incidents.
4. [DECISION_LOG.md](DECISION_LOG.md) — Owner synthetic new DB, disposable-only Secret-recovery and simplified native Docker first-boot decisions. [G1X first-boot Gate](G1X_DOCKER_NATIVE_LOCAL_FIRST_BOOT_GATE.md) is completed history, NOT executable.

## Governance

Cross-project operating standard: [vps-project-governance/VNEXT.md](https://github.com/entropy-student/spike.skill/blob/main/vps-project-governance/VNEXT.md) v0.2.7. No global governance update and no further automatic G1X/repair cycles. GitHub `main:mokersaas-local-lab/` contains **project management documents**, not the 22 uncommitted Owner-local source edits, local Docker volume data or Secret bytes. Production/full-scope audit needs separate authorization and primary Evidence.
