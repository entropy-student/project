# Owner Decision — One-round G3C local recovery after Codex desktop restart

> Date: 2026-10-15
> Project: Birthday Magazine Studio
> Provenance: OWNER_REPORTED
> Governance: v0.2.7
> Supersedes only the paused G3S1P permission-checkpoint waiting posture; original data/payment/production constraints remain.
> Implementation authority: see `G3S1R_ONE_ROUND_WORDPRESS_LOCAL_RECOVERY_GATE_2026-10-15.md`

## Owner instruction

Owner says the Windows Codex desktop application has just been **restarted**, Full Access had already been enabled, and requests a single practical round to restore the local WordPress site rather than continue repeated abstract diagnostics. If WordPress is **actually** broken, Owner is willing to reinstall it.

```text
OWNER_OBJECTIVE=RESTORE_EXISTING_G3C_LOCAL_WORDPRESS_SITE_IN_ONE_EXECUTOR_ROUND_IF_FEASIBLE
CODEX_DESKTOP_RESTARTED=OWNER_REPORTED
FULL_ACCESS_ALREADY_ENABLED=OWNER_REPORTED
NORMAL_EXACT_EXISTING_WORDPRESS_START_ATTEMPT=AUTHORIZED_ONCE_IF_APPROVED_TOOL_NOW_PERMITS
CONDITIONAL_APP_ONLY_REPAIR_OR_REINSTALL=AUTHORIZED_ONLY_AFTER_PROVEN_WORDPRESS_RUNTIME_FAILURE_AND_VERIFIED_RECOVERABLE_BACKUP
DATABASE_RESET_OR_REPLACE=FORBIDDEN
DATABASE_OR_WORDPRESS_NAMED_VOLUME_DELETE=FORBIDDEN
WORDPRESS_WP_CONTENT_CONFIG_UPLOADS_PLUGINS_THEMES_OVERWRITE=FORBIDDEN
PROVIDER_PAYMENT_SETTINGS_OR_PAYPAL_MUTATION=FORBIDDEN
EXECUTOR_SECURITY_POLICY_BYPASS_OR_PERMISSION_MODIFICATION=FORBIDDEN
NO_BROAD_REINSTALL=YES
STRIPE_GATEWAY_INSTALL=DEFERRED
G3S1_STAGING=STILL_ON_HOLD_UNTIL_SEPARATE_REVIEWER_RELEASE
```

## Scope and distinction

1. Earlier Executor-local evidence shows the same four project-labeled G3C containers, the two retained named volumes, network, images and project source exist. Last state: MariaDB running/healthy, WordPress/Mailpit/wpcli stopped. These are Executor source/target readbacks, not direct current Reviewer host observation.
2. The last actual attempted WordPress start never reached Docker; it was rejected by the Codex command executor at CreateProcess. That does **not** prove WordPress damage. The restarted desktop session is new Owner-reported context. One ordinary same-approved-tool start attempt is conditionally permitted, **not** any route-around of a renewed policy denial.
3. If that same approved normal execution surface allows start and the WordPress/Woo smoke checks pass, **do not reinstall**.
4. If process execution is allowed but the existing WordPress image/container or WordPress core is demonstrably defective, permit **only the smallest app-only reversible repair** under Gate conditions: first valid restricted DB-consistent backup plus WordPress files/config/plugins/uploads backup, integrity/read compatibility and exact rollback; retain all durable data. No broad delete or blank replacement. If backup unavailable, RETURN without reinstall.
5. If the tool still refuses process creation, immediately RETURN `RETURN_EXECUTOR_POLICY_STILL_BLOCKED_AFTER_RESTART`. Do not use PowerShell/CMD/Docker GUI/API/alternate agent or elevate/change security policy to circumvent.
6. This does not authorize merchant/KYC, Stripe connection/install, real/test checkout, refund, PayPal removal, public tunnel, production deployment or PR #64 merge. Protect the Owner-frozen visual frontend and dirty worktree.

## Success criterion

Reused or safely repaired WordPress available at local-only `127.0.0.1:8189`, non-secret evidence of health and intact WooCommerce/core buyer flow, unchanged database identity/project volumes and payment settings. A command that exits 0 is not alone proof of site recovery.

## Owner action

No additional settings check is needed now. Owner sends the current Gate to the **restarted normal Codex desktop executor** and reports its outcome for independent Reviewer decision.
