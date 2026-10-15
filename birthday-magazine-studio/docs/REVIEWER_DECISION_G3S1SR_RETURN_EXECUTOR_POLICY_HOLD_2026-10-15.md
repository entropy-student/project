# Reviewer Decision — G3S1SR RETURN: Codex Windows execution-policy block

> Date: 2026-10-15
> Governance: vps-project-governance/VNEXT.md v0.2.7
> Reviewed Gate: `G3S1SR_DB_RESTORE_DIAGNOSTIC_CONDITIONAL_STRIPE_INACTIVE`
> PR #64 Evidence: `docs/evidence/g3s1sr/G3S1SR_DB_RESTORE_DIAGNOSTIC_CONDITIONAL_STRIPE_INACTIVE_2026-10-15.md` at `d13b27fd8290d0575bd3ac7733f3f3039b415a21`
> Reviewer provenance: GitHub source/PR/Evidence read back independently; Owner Windows local Docker/backup state was reported by Executor in durable Evidence, not directly accessible to Reviewer.

## Formal result

```text
GATE=G3S1SR_DB_RESTORE_DIAGNOSTIC_CONDITIONAL_STRIPE_INACTIVE
REVIEWER_DECISION=RETURN_EXECUTION_POLICY_BLOCKED_DB_DIAGNOSTIC
POLICY_DENIAL=CODEX_EXECUTOR_CREATEPROCESS_BEFORE_PROCESS_START
DIAGNOSTIC_COMMAND_STARTED=NO
SCRATCH_CONTAINER_CREATED=NO
DB_IMPORT_THIS_GATE=NOT_RUN
OLDER_ISOLATED_DB_IMPORT=EXIT_1_ERROR_CLASS_UNKNOWN
WORDPRESS_AND_DB_FILE_BACKUP_CHECKSUMS=PASS_EXECUTOR_READBACK
WP_AND_BIND_SOURCE_RESTORE_EXTRACT=PRIOR_PASS_EXECUTOR_READBACK
DB_BACKUP_RESTORE_COMPATIBILITY=NOT_PROVEN
FULL_BACKUP_ROLLBACK_BARRIER=NOT_MET
STRIPE_PACKAGE_DOWNLOADED=NO
STRIPE_PLUGIN_INSTALLED=NO
ORIGINAL_SITE=HTTP_200_EXECUTOR_READBACK
ORIGINAL_DB_AND_VOLUME_MUTATION=NONE_EXECUTOR_REPORTED
PAYPAL_CHANGES=NONE_EXECUTOR_REPORTED
NEXT_STATUS=HOLD_CODEX_WINDOWS_EXECUTION_POLICY_REMEDIATION
REPEATED_CODEX_LOCAL_DB_DIAGNOSTIC=NOT_AUTHORIZED
CURRENT_STRIPE_INACTIVE_STAGING=ON_HOLD_PENDING_BACKUP_RECOVERABILITY
PR64=OPEN_UNMERGED
```

## Reviewed evidence and material drift

1. Reviewer fetched PR #64 at head `d13b27fd8290d0575bd3ac7733f3f3039b415a21`, Open/unmerged/mergeable=false. Compared with previous PR `d0ae16640fe01db90093ca00738c130a6f8a9915`, only one sanitized new G3S1SR Evidence Markdown was added; no business/source code changes by Executor.
2. Executor reported fresh main `1a0267c53a5d154317f4a13667e55b0eff64ee77` and authorized Gate/Handoff read. Reviewer independently checked those documents, PR and prior G3S1S evidence. New latest main source shifts are in unrelated project paths only; project critical baselines remain accepted.
3. Protected LocalAppData backups were reported existing with matching sizes/private checksums and restricted ACL; the original WordPress/MariaDB/WP-CLI container IDs, two named volumes/private network and HTTP 200 remained. The previous WordPress files and mounted-binding archives already passed isolated extraction; repeat not warranted. A read-only source inventory showed 58 InnoDB tables and aggregate 1,311 rows, not a validated restore.
4. The prior G3S1S database import **actually exited 1** with unknown diagnostic output, so backup recoverability was unproven. In THIS Gate the one scheduled isolated diagnostic was **rejected by the Codex PowerShell executor at CreateProcess before command start**. It created no scratch resources, did not run MariaDB, and produced **no new import exit code or SQL error**. Refusal cannot diagnose SQL dump corruption.
5. No Stripe package/install/activation, provider/account action, checkout/refund, PayPal change, original DB write, named-volume cleanup or PR merge was reported. The untouched original runtime needed no rollback. No new backup was proven restorable.

## Decision and allowed path

**RETURN for G3S1SR, not PASS.** This is the second consecutive attempt to resolve the failed backup restore that was stopped by a Codex executor policy denial or unavailable error capture. A further substantially equivalent same-channel Codex diagnostic is not authorized just to generate another RETURN. Preserve prior accepted runtime/file-backup results and private backup bytes; do not recreate/restage WordPress.

**Current project status is HOLD, not an execution Gate:** `docs/G3S1SH_CODEX_POLICY_HOLD_AND_RESUME_CRITERIA_2026-10-15.md`. No immediate Codex host action, plugin install or PayPal retirement.

Official Codex desktop support/engineering resolution is the preferred path to a legitimate execution channel. Comparable public reports exist under `openai/codex` Windows-desktop policy-block issues (e.g. #47213, #43633), but they do NOT establish the precise rejecting rule in this project's command. Owner has already reported Full Access enabled and restarted the desktop, so do not request another identical permission-toggle/restart loop. Do not bypass with another shell, program, SDK, GUI automation, separate agent or concealed scripting.

**Resume criteria:** an authoritative documented tool-policy fix/permission path for the exact intended isolated DB restore, or an explicit future **new Owner-approved risk/acceptance decision** with a proportionate alternative recovery barrier, plus a new Reviewer Gate that documents changes to current restore requirements before any plugin file write. An unresolved DB restore cannot be silently declared PASS or waived by an Executor. No real checkout, provider authorizations, Stripe activation, PayPal removal, production or PR merge.

Backup integrity and file extraction are reusable facts but no substitute for DB restore/read compatibility. This HOLD preserves future reversibility.

## Support escalation packet (sanitized)

- Product: Codex desktop app on Windows 11, Full Access enabled by Owner, app restarted; some normal commands worked previously (existing WordPress `docker start`).
- Current symptom: `CreateProcess ... rejected: blocked by policy`, before PowerShell startup, during isolated read-only/temporary MariaDB restore validation.
- Prior distinct symptom: an earlier disposable MariaDB SQL import returned native exit 1, stderr was not preserved; this is not a tool-policy exit.
- Security requirements: diagnostic only in disposable `network=none`, tmpfs-only MariaDB 11.4.7, no original DB mounts, sensitive SQL stays private.
- Request: identify exact enforcing rule and a **supported review/approval or bug-fix path**, without broad disabling of protection.
- Attach only sanitized error/state evidence, never credentials, raw SQL dumps, machine-private paths, personal user identifiers or payment/order data.

Owner action: submit support report if desired; no immediate Docker action. When a documented fix is available, Reviewer may reopen a bounded test with actual evidence and pre-write backup verification.

## Governance scan

Applicable: Storage/backup (11A), Owner Windows execution and privilege (11B), local Docker resources (11C), automation authorization (11D), payment/provider protection (11E), preserved data/cleanup (11F). Image generation not triggered (11G). No Governance rule modification.
