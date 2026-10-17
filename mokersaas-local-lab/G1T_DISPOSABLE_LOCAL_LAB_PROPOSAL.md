# MokerSaaS G1T — Disposable Local Test Database Proposal
> PROPOSAL_ID: MOKER-G1T-DISPOSABLE-LOCAL-DB-20261017
> STATUS: PENDING_EXPLICIT_OWNER_EXCEPTION_APPROVAL — NOT EXECUTABLE
> Governance: entropy-student/spike.skill main:vps-project-governance/VNEXT.md v0.2.7
> MAX_ENDPOINT_IF_APPROVED: create one **new** disposable synthetic lab PostgreSQL database + protected local credential, initialize empty schema, reuse valid images and run bounded localhost-only app/auth/provider-negative smoke. Original database unchanged. Mandatory STOP_AT_REVIEWER=YES.

## Reviewer rationale
G1S returned BEFORE any mutation because (1) policy permission for **new** object creation was UNKNOWN (not actually denied), and (2) no independent encrypted recovery destination was available. G1R had proven only the previous **existing role password reset** process creation was denied. A denied old-password-reset operation and an unattempted new disposable service creation are different actions. Do not write `POLICY_BLOCKED` as a verified current-G1S fact.
The full off-host encrypted credential recovery requirement of Governance section 11B is proportionate for unique/real business data. For this single-project zero-real-data disposable lab, requiring a separate external failure domain has stalled the actual product evaluation. Reviewer proposes one explicit, scoped and temporary Owner exception **only** to the off-host encrypted credential-recovery copy. Owner approval has not yet been given.

## Exact new Owner decision required
Approve temporary exception `MOKER-EXC-20261017-DISPOSABLE-SECRET-NO-OFFHOST`:
- ONLY for **new disposable lab-only** synthetic Postgres/NextAuth credentials in `mokersaas-local-lab-g1t`. Do NOT waive the requirement for real Stripe/Resend/OAuth/provider keys, production Secrets, existing DB, genuine users or transaction data.
- Authorize in-place protection of generated lab-only credentials on Owner Windows host using OS CSPRNG, a path outside source/build context, restrictive Windows ACL and Compose file-backed secrets / runtime file readers (or equivalent least-privilege secret handling). No plaintext Secret/value/hash in chat, Git, command args, normal environment, stdout, logs or image layers. A local encrypted DPAPI copy is optional, **not** claimed to be off-host recovery.
- Waive ONLY separate failure-domain encrypted backup/recovery for these disposable lab credentials, on condition that all test DB rows and new volume are explicitly classified **regenerable / disposable** and loss means controlled abandonment/recreation of the **new** lab DB by later Owner-authorized action, never recovery/reset of old DB.
- Exception automatically EXPIRES before any real customer data, permanent entitlement, real payment/provider, public exposure, reuse as production/unique business DB, or project closeout. At that point restore full Secret recovery/backup controls under a new reviewed Gate.
- Keep all other Governance v0.2.7 safeguards: identity/preflight, known source diff, same-host write read-back, native exits, policy stops, admin route negative test, localhost-only port, no access to unrelated containers, rollback/evidence, no numeric RAM threshold.

## What is currently authorized vs not
Existing `MOKER-D-20261017-APPROVE-G1S-NEW-DB` authorized side-by-side new DB, protected credentials and local smoke; it did **not** explicitly waive the off-host Secret recovery rule. This G1T proposal is a scope **change** requiring separate explicit Owner acceptance before any write.
Earlier blocked attempts to reset the password of `mokersaas-local-lab-db-1` remain forbidden. Preserve old container, volume `mokersaas-local-lab-db-data`, network and original two images plus 18 local source changes. No `down -v`, volume deletion, password resets, or global Docker/WSL/network changes.

## Conditional execution plan after approval (NOT authorized yet)
1. Use the same existing Owner Windows-local Codex execution environment previously authorized for G1; prove protected new project workspace, source HEAD, source diff, 3077 free, old DB and old volumes untouched. Do not demand advance proof of every permitted new process before a first safe new action; **if** actual host execution policy rejects a new action, immediately STOP, record stage/non-secret denial, do not route around with another shell/agent/SQL/Docker helper.
2. Source-review non-secret subset of existing 18 modifications: admin GET/POST, fail-closed provider routes, local auth, file Secret reader, .dockerignore exclusions, Dockerfile and Compose manifest. If blockers, modify only project-owned source with exact bounded diff and image build only if affected code changed.
3. Create NEW project-only `mokersaas-local-lab-g1t` services/volume/network without managing the old project. Generate a high-entropy synthetic DB password using OS CSPRNG within a protected process, store as restrictive file secret outside Git/build context; validate permitted app/db/migrator reader identity and no unprotected exports. Prefer `POSTGRES_PASSWORD_FILE`. No off-host backup under explicit narrow waiver. Generate any required local auth secret with same disposable classification and protection.
4. Initialize schema ONLY on new, proven empty disposable DB; verify table/constraints from direct DB read-back, no real data. Start app on `127.0.0.1:3077:3000` only; no published DB port, no public routing or provider outbound.
5. Execute limited synthetic homepage/signup/login, set-admin GET+POST 404/403 and role unchanged, ordinary-user admin rejection, disabled Stripe/Resend/OAuth/Cron/withdraw checks. Never test a real purchase/refund/mail or customer account. Record actual native exit codes, container/app DB HTTP states and any defect as RETURN, not PASS.
6. Preserve new disposable volume for Reviewer, even if test fails; avoid deletion in this round. Only target-scoped owned-service stop for an unsafe live process. No replay of G1 or G1S failed writes. STOP_AT_REVIEWER=YES.

## Consequences / Owner tradeoffs
- Benefit: proceed toward functional localhost evaluation without unrelated external drive/VPS access.
- Tradeoff: if the protected lab-only credential or disk is lost, **new test DB data may be irrecoverable** and must be regenerated; never make it a durable customer or production datastore.
- No change in permission to bypass any command-execution policy; action must be performed through ordinarily authorized local channel and a real denial causes stop.

## Reviewer/Executor handoff
No active G1T Executor Gate until Owner explicitly approves exception ID above. Reviewer will then activate a scoped executable Gate, update Handoff/Evidence, and send a concise relay. Do not execute this proposal directly.
