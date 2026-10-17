# Owner Authorization — G3S4A recover local WordPress administrator login

> Date: 2026-10-17
> Authority source: Owner directly replied **"我同意，请开始。"** to the Reviewer proposal to look up the *current local WordPress administrator account* and safely reset its login password on the Owner machine, with the new password remaining local and absent from GitHub/chat.
> Provenance: OWNER_REPORTED authority, **not** proof of actual identity/password changes.
> Scope: `docs/G3S4A_LOCAL_WP_ADMIN_DISCOVERY_AND_PASSWORD_RESET_2026-10-17.md` only.
> Validity: one verified, bounded recovery of ONE existing local G3C WordPress administrator account; expires at Executor STOP/RETURN and Reviewer disposition.

## Approved

1. Inspect only the exact existing Owner-Windows G3C WP/Woo containers and selected read-only administrator account metadata necessary to identify the account.
2. If exactly one verified existing administrator and all target/secret safeguards pass, ask Owner to enter a **new password privately via a trusted local no-echo prompt** and, after matching confirmation, overwrite that account's WordPress password using a proven safe stdin/process-memory path into an already-existing target-bound WP runtime. The reset may invalidate old login sessions. Verify only password-update success/hashed credential change and WordPress/Woo site health **without ever reading or displaying password values**.
3. If multiple administrators or uncertain identity, STOP before resetting and request exact Owner account selection without exposing accounts in public files.
4. Record only sanitized result, host/container role, whether admin discovered/reset performed, post-write success/negative checks, no raw username/email if unnecessary and no secrets. STOP for Reviewer.

```text
GATE_ID=G3S4A_LOCAL_WP_ADMIN_DISCOVERY_AND_PASSWORD_RESET_20261017
OWNER_AUTHORIZATION=APPROVED_SCOPE_ONE_EXISTING_LOCAL_ADMIN
ADMIN_METADATA_READONLY_DISCOVERY=YES
RESET_ONE_IDENTIFIED_ADMIN_PASSWORD=CONDITIONAL_OWNER_PRIVATE_INPUT_ONLY
PASSWORD_OR_PASSWORD_HASH_OUTPUT_TO_CHAT_GITHUB_LOGS=NO
PASSWORD_IN_CLI_ARGUMENT_ENV_SHELL_HISTORY_TEMP_FILE=NO
REQUIRE_TRUSTED_HIDDEN_OWNER_PROMPT=YES
MUTATE_OTHER_ADMIN_ACCOUNTS_ROLES_EMAILS_ORDERS=NO
STRIPE_PLUGIN_ACTIVATION_TEST_PAYMENTS_REFUNDS=NO
NETLIFY_PAYPAL_DOCKER_RECREATE_DATABASE_IMPORT_GIT_RESET_PR_MERGE=NO
REVIEWER_STOP=YES
```

This authorization is **not** G3S4M Stripe test-write consent. It permits no plugin, payment provider, checkout, Woo order/fulfillment, public site or deployment mutation. A previously reported `admin` username from a historical environment is **not** sufficient target proof; discover the actual local WordPress administrator(s). Owner retains their own chosen password/password-manager custody; no agent-secret recovery material is stored in GitHub, chat, or plain files. No credentials should be sent back in completion messages.
