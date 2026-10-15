# G3S1SH — HOLD: Codex Windows execution policy, preserve backup and Stripe staging

> Date: 2026-10-15
> Governance: vps-project-governance v0.2.7
> Parent Reviewer RETURN: `docs/REVIEWER_DECISION_G3S1SR_RETURN_EXECUTOR_POLICY_HOLD_2026-10-15.md`
> Source PR #64 Evidence: `docs/evidence/g3s1sr/G3S1SR_DB_RESTORE_DIAGNOSTIC_CONDITIONAL_STRIPE_INACTIVE_2026-10-15.md` at `d13b27fd8290d0575bd3ac7733f3f3039b415a21`

## Gate / HOLD contract

```text
GATE_ID=G3S1SH_CODEX_POLICY_HOLD_AND_RESUME_CRITERIA
OBJECTIVE=Preserve original local site and its unproven but intact private recovery artifacts while awaiting an officially supported Codex Windows execution-policy resolution; prevent repeat blocked local restore attempts and unintended Stripe payment changes.
MAX_ENDPOINT_THIS_ROUND=Documentation/official policy support only, no Codex host execution or WordPress/plugin/DB mutation.
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Owner local Windows G3C site, existing project-local backup archive, GitHub project scope and official Codex support channels.
APPLICABLE_CRITICAL_CONSTRAINTS=NO_REPEAT_DB_RESTORE_DIAGNOSTIC; NO_EXECUTOR_POLICY_BYPASS_ALTERNATE_SHELL_SDK_GUI_AGENT; NO_HOST_POLICY_CHANGE_OR_BLANKET_FULL_ACCESS_RETOGGLE; NO_WORDPRESS_REINSTALL_RESET; NO_LIVE_DB_OR_VOLUME_CHANGE; NO_STRIPE_PACKAGE_INSTALL_ACTIVATE_ACCOUNT_ACTION; NO_PAYPAL_MODIFICATION; NO_CHECKOUT_PAYMENT_REFUND; NO_PUBLIC_ROUTE; NO_PR64_MERGE; NO_SECRET_CUSTOMER_SQL_BACKUP_CONTENT_DISCLOSURE.
PREFLIGHT=Current Reviewer RETURN and PR G3S1SR Evidence retained; original G3S1R runtime PASS, G3S1S backup partials retained.
REQUIRED_EVIDENCE=OFFICIAL_DOCUMENTED_EXECUTOR_REMEDIATION_OR_EXPLICIT_OWNER_NEW_RISK_DECISION; SAME_TARGET_RECOVERY_BARRIER_FOR_NEXT_WRITE; PRESERVED_ORIGINAL_SITE; NO_CONSEQUENTIAL_ACTION_THIS_GATE.
ACCEPTANCE_CRITERIA=Hold and preservation correctly recorded; a future execution Gate is only designed after a legitimate supported execution fix or fresh Owner-approved bounded alternative risk contract. No claim of DB restore or Stripe PASS from this HOLD.
ROLLBACK_STATUS_OR_PLAN=No target mutations; SQL dump and WordPress archives remain in private restricted storage, checksums match Executor reports, database restored compatibility remains UNKNOWN; current original site intact. Backups are not yet validated rollback points.
OWNER_ONLY_ACTIONS=Optional official Codex support ticket with sanitized failure evidence. Do not submit raw command containing secrets, local private user paths, private backup bytes or live data.
```

## Known current truth

- G3S1R local WordPress / WooCommerce runtime PASS (GET smoke, DB healthy, retained original containers).
- G3S1S backup: 9.8 MB DB SQL archive private checksum PASS; 126 MB WordPress files and 23.7 MB mount-source archives checksum + isolated extraction PASS; **isolated DB import exit 1, error UNKNOWN**.
- G3S1SR isolated diagnostic did NOT execute; Codex Windows `CreateProcess` was denied before PowerShell started, no new MariaDB exit code.
- No official Stripe Gateway installed, no payment/provider actions. PPCP absent and legacy Woo PayPal disabled in local G3C; historical G3B PayPal Sandbox PASS preserved. Owner wants future PayPal retirement only after complete Stripe end-to-end PASS.

## Reviewer to Owner / Execution relay

**Do not dispatch a Codex Executor host-operation prompt while this HOLD is active.** The latest user reports Full Access is enabled; another permission toggle, app restart, or equivalent speculative retry is not the plan. This Gate is for support escalation and evidence preservation only.

Suggested official channel: OpenAI support from help.openai.com, with the redacted `CreateProcess blocked by policy` error, app/Windows environment, and observed behavior. Comparable existing public Codex issues do not prove exact root cause or permission to override safeguards.

Once a documented official remediation changes the actual execution restriction, **Reviewer** opens a new scoped Gate to redo just the missing isolated database recovery proof, then permits inactive Stripe staging conditionally. If Owner separately asks to reconsider the backup-barrier risk for this disposable local lab, Reviewer must explicitly review unique business data and define a new threshold and rollback before authorizing any plugin installation; no unilateral assumption of acceptable data loss.

No Codex-to-Reviewer execution packet required for a HOLD. If Owner supplies an official fix or new decision, review against this Gate and update main before any target mutations.
