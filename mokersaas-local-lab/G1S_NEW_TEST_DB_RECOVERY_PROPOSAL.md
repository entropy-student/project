# MokerSaaS G1S — New Isolated Synthetic DB + Local Smoke (PROPOSAL)

> ARCHIVED 2026-10-17: Owner's decision has been recorded. Do not execute this planning proposal. The sole live execution Gate is G1TR_ACL_COMPAT_DB_LOCALHOST_CONTINUATION_GATE.md; see REVIEWER_HANDOFF.md.
> PROPOSAL_ID: MOKER-G1S-NEW-SYNTHETIC-DB-AND-SMOKE-20261017
> STATUS: HISTORICAL_SUPERSEDED — **NOT EXECUTABLE**
> Governance: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7; no Governance amendment
> Source baseline: ItusiAI/MokerSaaS c98f68c68de312cc1378130b96f82418e22bd5f3 + 18 uncommitted Owner-local lab changes
> MAX_ENDPOINT_IF_APPROVED: one policy-permitted Owner-local checkpoint to create a fresh separately named synthetic DB credential + test DB volume, guarded schema bootstrap, app localhost-only start and small negative smoke. No old DB mutation.
> MANDATORY_REVIEW_STOP: YES; STOP_AT_REVIEWER=YES

## OBJECTIVE AND AUTHORITY
G1R diagnostic is PASS but G1 remains RETURN_LOCAL_DB_CREDENTIAL_RECOVERY_BLOCKED. Previous attempts to alter the old DB role password were blocked at process creation before any DB write, and approved password recovery does not exist in verified evidence. This proposal does NOT authorize use of a different shell/agent/SQL route to retry that blocked action.
Only after Owner explicitly approves this exact proposal and Reviewer updates STATUS, the Owner's Windows-local Executor may create an entirely separate, project-owned synthetic **new** test DB and credential in a permitted channel, preserving the original DB container/volume and original 18 local source changes. An operation denied by the execution platform's actual policy must STOP and require policy-authorized review, not attempt alternative transport/processes.
This is a new bounded disposable test target, not recovery, restoration, replacement, or deletion of the old volume. Old project DB role/password remains unchanged. This distinction must be proven from changed targets/identities before writes; if it is actually the blocked prior write in disguise, DO NOT EXECUTE.

## REQUIRED OWNER APPROVAL (not yet received)
Owner must clearly authorize `MOKER-G1S-NEW-SYNTHETIC-DB-AND-SMOKE-20261017` to:
1. create a new project-owned DB/volume/service name **different from** existing `mokersaas-local-lab-db-1` / `mokersaas-local-lab-db-data`;
2. generate/store one new synthetic DB credential with protected Owner-local Secret custody + encrypted recovery design, using an execution method independently confirmed allowed by the applicable policy;
3. make tightly scoped new lab Compose/database adapter config changes and at most one bounded rebuild IF necessary for file-secret handling;
4. initialize new empty database schema, launch lab app only at `127.0.0.1:3077`, run negative/basic localhost smoke;
5. preserve existing DB container, image and volume untouched and return at Reviewer.
Owner authorization never overrides execution-tool safety policy; rejects continue to mean STOP.

## PRECONDITIONS / SAFETY
- Target actual Owner Windows 11 native PowerShell/Codex, source checkout already at `%LOCALAPPDATA%\ChatGPT-Labs\mokersaas-local-lab`, origin/HEAD pinned; no discovery/clone/rebuild replay if source retained. Confirm source status and no foreign files/changes; original 18 changes preserved. Never touch existing SaSS or unrelated worktrees.
- Read-only inventory proves new volume/service name unused, old named volume and container identity preserved. Fresh app host port 3077 checked before start, and server binds **127.0.0.1 only**. New Postgres service uses same project-only internal network but no published DB port and no external network.
- Do not treat the old public schema 0 tables as authorization to delete old DB; no `down -v`, Docker prune, volume recreation, existing role-password change or overwrite/rename of existing Secret paths.
- No numeric RAM gate; actual OOM/build crash/disk failure stops. No Docker daemon/WSL/host-global networking/VPN/proxy alterations, admin elevation, paid API/real mail/Stripe/provider calls, account login, real payouts or customer data.
- Credential format/entropy: generate an adequate random secret with approved OS CSPRNG in the protected target process only; one new credential, separate app auth/session secret as needed. Not a PowerShell GUID fallback, hardcoded test password, or printed password. No Secret values/hashes in stdout, CLI arguments, git, chat, normal environment, unprotected .env, build args, ordinary logs or Docker image layers.
- Credential storage: establish one exact project-owned Secret reader/mount path **outside source/git and build context**. Use file-backed Compose Secret / PostgreSQL `POSTGRES_PASSWORD_FILE` where supported; application/migrator reads a protected Secret file rather than requiring plaintext `DATABASE_URL` in Compose environment. If adapters cannot support this without violating policy, return `RETURN_SECRET_BOUNDARY_UNRESOLVED`; do not install a weak workaround. Freeze actual Windows path/ACL permissions and container reader identity; test access allow/deny using metadata-only Evidence.
- Recovery: encrypted recovery artifact outside the sole local failure domain, Owner-controlled; DPAPI CurrentUser can be supplementary, not sole durable recovery. Validate format/reader consistency and encrypted recovery roundtrip without disclosing Secret. If approved path/storage not available, STOP before DB creation, `RETURN_SECRET_RECOVERY_UNAVAILABLE`.
- Explicit policy access: before any consequential action, confirm the exact proposed new-target creation process is **allowed by actual command-execution policy**. If the previous process policy refuses it, STOP and do not reroute through different shell, Docker exec, helper, task scheduler, API or alternate agent. No speculative retries.
- Separate current app security review: before app startup, prove GET and POST `/api/admin/set-admin` are server-disabled without role writes, OAuth/Stripe/Resend/Cron/Umami/affiliate endpoints fail-closed, and app services have no ability to call real providers. Existing 14 source diffs need bounded non-secret evidence for Reviewer; runtime negative tests are mandatory after safe start.

## CONDITIONAL SEQUENCE ONLY IF AUTHORIZED
A. Fresh same-target preflight, scope/ports, policy-permitted command path and immutable backup/rollback plan. If not proven, STOP without writes.
B. Create NEW project-specific volume, DB service and protected Secret file in exact approved project scope. Existing DB service/container/volume stays unchanged and is not stopped. Verify new identities (metadata only), ACL/effective reader permissions and encrypted recovery. No raw Secret/env inspect.
C. Minimal necessary Compose, `lib/db.ts`/migrator file-secret config changes and bounded rebuild **only if** existing built images cannot consume the new protected file path. Don't edit unrelated routes or code. Verify resolved Compose keeps DB internal/no host publish; app 127.0.0.1:3077 only; `.dockerignore` excludes Secret and .env.
D. New DB initialized empty with proven unique identity, then project-only `drizzle-kit push` or reviewed schema bootstrap; independently read back essential table and constraints (no private data). Existing old DB not targeted or touched.
E. Start the exact project-only app at localhost after static auth/provider protections confirmed. Check separate container/DB/app HTTP layers, then minimal synthetic login/signup and ordinary/anonymous authorization negative checks, Stripe/email/cron/withdraw 503 behavior; no real money/email/provider. Use limited local disposable fixtures only and no automatic network jobs.
F. Return sanitized statuses, exact filenames/diff summary, new DB/Secret storage existence/reader evidence, negative tests and restart/persistence/rollback scope if tested; STOP_AT_REVIEWER. No production/pass claim from Executor.

## REQUIRED EVIDENCE / STOP
OWNER_APPROVAL_REFERENCE, POLICY_ALLOWED_CHANNEL_PROOF, SAME_HOST_TARGET, SOURCE_18_CHANGES_PRESERVED, OLD_DB_IDENTITY_AND_NO_DELTA, NEW_DB_IDENTITY_AND_VOLUME, GENERATED_SECRET_ENTROPY_AND_CUSTODY_PROOF (no value/hash), ENCRYPTED_RECOVERY_PROOF, ACL_READER_PROOF, COMPOSE_PORTS_AND_NETWORK, EXACT_SCOPED_CHANGES, TS/BUILD_NATIVE_EXIT_IF_CHANGED, SCHEMA_TABLE_CONSTRAINT_READBACK, APP_LOCAL_URL_HTTP, ADMIN_NEGATIVE_TESTS, PROVIDER_DISABLED_NEGATIVE_TESTS, RESOURCE_OR_BUSINESS_DELTA, ROLLBACK, ANOMALIES, EXECUTOR_RESULT.
No missing critical property may be filled with assumption or fixed PASS. If any prerequisite denied, return precise RETURN_* with preserved state and no bypass. Reviewer alone judges G1S outcome.

## ROLLBACK / RETENTION
Keep original DB (container `mokersaas-local-lab-db-1`, volume `mokersaas-local-lab-db-data`), its internal network and both built images until later distinct Owner-approved retention/cleanup. Keep new synthetic DB volume on failure as reviewable state; do not auto-delete it. Exact app/service stop allowed only if confirmed owned and unsafe; never delete unknown data. Do not commit/push runtime Secret, encrypted recovery or private DB bytes to GitHub. Canonical Evidence/Handoff updates belong to Reviewer.

## REVIEWER_TO_EXECUTOR_RELAY (INACTIVE UNTIL OWNER APPROVAL)
This proposal is **not executable**. Owner approval and Reviewer activation must precede any code change or new DB/Secret actions. Once activated, Executor reads the new active Gate, not this proposal alone, and obeys all previous policy stops.

## EXECUTOR_TO_REVIEWER_RELAY
Result: PASS_CANDIDATE / RETURN_*
Changes: exactly new project-owned resources/source changes only; old DB untouched
Verification: authorized policy-permitted new DB credential+recovery, schema/app/localhost negative tests, no real providers
Problem: precise blocker if any
Rollback: exact project-only retained resources and safe stop
Reviewer checks: evidence, source diff, Secret/DB isolation, runtime outcomes
Owner transfer: NONE or exact policy-authorized next checkpoint
