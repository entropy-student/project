# MokerSaaS Local Lab — EXECUTION_EVIDENCE
> APPEND_ONLY; Reviewer-recorded from Owner-relayed local Codex report; 2026-10-13
> Governance: vps-project-governance v0.2.7
> Source baseline: ItusiAI/MokerSaaS c98f68c68de312cc1378130b96f82418e22bd5f3

## 2026-10-13 — G0 Local Read-only Discovery Review
- AUTHORIZED_GATE: `MOKER-G0-LOCAL-READONLY-DISCOVERY-20261013`
- SOURCE_OF_RUNTIME_FACTS: OWNER_REPORTED to Reviewer from Owner-local Codex; Executor labels narrow platform probes `DIRECT_READBACK`. Reviewer has no direct access to Owner's physical Windows host. GitHub source checks listed below are independently DIRECT_READBACK by Reviewer.
- EXECUTOR_RESULT: `RETURN_REVIEWER_REVIEW_REQUIRED` (a review stop, not a failed target execution); `STOP_AT_REVIEWER=YES`.
- ACTUAL_CHANGES: `NONE_TARGET` as reported; no install/checkout/pull/build/up/port bind/config mutation.
- TARGET_LOCAL_PROOF: native Windows PowerShell runtime; WSL/RDP/recognized VM markers absent; Docker via local named pipe reports Docker Desktop; physical device ownership remains OWNER_REPORTED and cannot be independently proven over chat.
- WINDOWS_VERSION: Windows 11 Home Chinese 10.0 build 26300; PS 7.6.5; X64; ADMIN_BOOL=false.
- HOST_RAM_TOTAL_GiB: 15.28; HOST_RAM_AVAILABLE_GiB: 0.81 earlier, 1.44 latest G0 observation; resource fluctuation noted.
- DISK_AVAILABLE_GiB: 205.25 on candidate workspace volume.
- DOCKER_ENGINE_STATUS: responding; client/server 29.7.2; Docker Desktop present; Docker service absence not classified as engine fault.
- DOCKER_ENGINE_RAM_GiB: 7.40 reported capacity, not physical free memory; COMPOSE_VERSION: 5.4.0.
- PORTS: 3077 and 5432 not listening/bound at G0; no matching Moker-named Docker containers/images/networks/volumes reported.
- SOURCE_CHECKOUT: current worktree is managed by Git but NOT a MokerSaaS checkout; no new checkout created. SOURCE_COMMIT checked c98f68c68de312cc1378130b96f82418e22bd5f3.
- DEPENDENCIES: Next.js 16.3.0 node >=20.9 per Executor package-manifest inspection (README's Node 18+ conflicts); pnpm 9.15.0 / lockfile v9; two lockfiles present. No root Dockerfile/Compose.
- DATABASE: `lib/db.ts` uses Neon HTTP client. Reviewer independently read back this file at pinned revision; local PostgreSQL via default TCP adapter cannot be assumed. `drizzle/meta/_journal.json` has entries=[], independently confirmed. Local migrations need verification and no blind `db:migrate` claim.
- EMAIL / PROVIDERS: `lib/email.ts` fails module import without RESEND_API_KEY; Stripe webhook imports mail and separately initializes Stripe; OAuth providers unconditionally configured; Vercel cron not automatically scheduled by Compose. Isolated local test requires fail-closed provider/mock boundaries and no real keys.
- SECURITY: Reviewer independently checked pinned `app/api/admin/set-admin/route.ts`: GET and POST update users.role='admin' with no isAdmin check; `proxy.ts` excludes /api as reviewed in initial source reconnaissance. Executor's additional 16/17 protected admin-route claim is EXECUTOR_REPORTED and not a complete Reviewer-authenticated full repo audit. Gate blocker: remove/disable unguarded admin route before functional accounts/privilege test.
- TRANSACTIONS: Executor reports non-atomic referral award writes, webhook idempotency relying on pre-check without DB unique constraint, and refund rights/points gap; categorized CODE_RISK_REPORTED requiring scoped independent code/behavior review before real provider test. No real payment/refund authorized.
- NATIVE_ERRORS: one unsupported read-only Docker formatter; subsequent bounded inventory succeeded; no target changes reported.
- G1_FEASIBILITY: INFERRED feasible with isolated project checkout + Compose app/internal PostgreSQL, local database adapter, inert email/OAuth/Stripe/Cron, localhost-only 127.0.0.1:3077, protected test admin bootstrap, migration proof and project-specific rollback. No build/runtime functional proof exists.
- RESOURCE_CONSTRAINT: 1.44 GiB free host RAM insufficient for safe confidence in first combined build/up. Conservative G0R project-specific planning target ~4.0 GiB currently available RAM, not an upstream-verified minimum or universal requirement; Reviewer must re-decide if not met.
- OBJECTIVE_READBACK: Reviewer fetched current Governance v0.2.7 SHA 3917c88a7f36df7a53758b3879a92703d659ef9d, G0/Handoff, upstream pinned `lib/db.ts`, `drizzle/meta/_journal.json` and `set-admin` at SHA 8bd0afdb4561c3ff97bee9aea3cb36aed09fb57b.
- ANOMALIES: Runtime evidence is relayed, not direct physical host access; no definitive proof of immutable physical machine identity; resource availability varied; final Docker/Node/Postgres readiness unverified.
- ROLLBACK_EFFECT: NOT_APPLICABLE; read-only target.
- REVIEWER_DECISION: `PASS` for G0 discovery boundary and risk inventory only; DOES NOT authorize installation, Docker build or payment; next `G0R_RESOURCE_READONLY` due low RAM and runtime resource ambiguity. G1_DEPLOYMENT=BLOCKED_RESOURCE until reviewed subsequent Evidence.

## 2026-10-16 — Owner decision: skip G0R and enter G1
- EVENT_TYPE: OWNER_DIRECTION_REVIEWER_RECONCILIATION (not Executor output, not runtime verification).
- OWNER_DECISION: User explicitly requested to remove memory occupancy limitation and advance to next phase.
- DECISION_ID: `MOKER-D-20261016-NO-RAM-NUMERIC-GATE`; durable rationale in `DECISION_LOG.md`.
- PRIOR_STATE: G0 PASS (discovery only); G0R_READY not executed; last host RAM reported available 0.81–1.44 GiB.
- EFFECTIVE_CHANGE: Only the project-specific conservative >=~4 GiB RAM admission line is waived; G0R becomes `SUPERSEDED_NOT_EXECUTED`, never `PASS`. Direct transition G0 -> G1 authorized at bounded scope.
- SAFETY_RETAINED: actual Docker/Windows OOM or severe runtime failure remains a stop; preserve target proof, no other project changes, localhost-only binding, known admin vulnerability remediation, no real Provider/Stripe/money/email, Secret and rollback Evidence requirements.
- NEXT_GATE: `MOKER-G1-LOCAL-HARDEN-COMPOSE-SMOKE-20261016`, authorized to have Executor prepare project-isolated source/security/adapter/Compose and only after all safe prerequisites perform one bounded localhost build/start/basic smoke.
- RUNTIME_MUTATION_THIS_REVIEW: NONE; Reviewer only added/updated canonical GitHub governance-application documents. G1 Executor has NOT started and no Docker images/services are asserted.
- REVIEWER_RESULT: G0R skipped by Owner scoped decision; G1 READY_FOR_EXECUTOR. Reviewer to verify later Executor Evidence before PASS.
