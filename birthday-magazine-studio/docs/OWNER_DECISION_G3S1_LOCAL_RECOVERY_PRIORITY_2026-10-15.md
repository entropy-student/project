# Owner Decision — Prioritize Safe Recovery of Existing Local G3C Runtime

> Date: 2026-10-15
> Provenance: OWNER_REPORTED in current Reviewer chat
> Scope: Birthday Magazine Studio Owner-local Windows G3C Docker lab only
> Related Reviewer RETURN: `REVIEWER_DECISION_G3S1_RETURN_LOCAL_WORDPRESS_START_BLOCKED_2026-10-15.md`
> Current active Gate: `G3S1D_LOCAL_START_EXECUTION_POLICY_DIAGNOSTIC` (read-only)

## Owner request

Owner says a recent cleanup may have removed something, and requests restoration of the previous working environment.

```text
OWNER_INTENT=RECOVER_EXISTING_LOCAL_G3C_RUNTIME
OWNER_CLEANUP_CLAIM=POSSIBLE_REMOVAL_NOT_PROVEN
PREFERRED_METHOD=REUSE_AND_RESTART_VERIFIED_EXISTING_CONTAINERS
DATA_OVERWRITE_OR_VOLUME_RECREATE=NOT_AUTHORIZED
PRODUCTION_OR_SHARED_INFRA_CHANGE=NOT_AUTHORIZED
EXECUTION_POLICY_BYPASS=NOT_AUTHORIZED
STRIPE_ACCOUNT_OR_PAYMENT_ACTIONS=NOT_AUTHORIZED
CURRENT_DIAGNOSTIC_GATE=G3S1D_READ_ONLY
G3S1_IMPLEMENTATION_GATE=ON_HOLD_UNTIL_POLICY_DIAG_REVIEW
```

## Reconciliation of cleanup hypothesis

At Executor's most recent local readback, the G3C Compose source defined four services: `db`, `wordpress`, `mailpit`, `wpcli`. Their container IDs, project labels, mounts, two named volumes and private network were reported present. Only `db` had started (running/healthy); the other containers were stopped. The first WordPress start was rejected by the local command-execution policy before execution. These are durable Executor facts, **not current Reviewer direct host readbacks**.

Thus prior cleanup is a plausible cause of **some** missing tool, command authorization, configuration or external artifact, but **is not evidence that WordPress/database containers or data were removed**. Never infer exact missing items or recreate what has not been proven missing.

## Authorized recovery direction — conditional only

1. Preserve all existing G3C containers, project named volumes, database and WordPress uploads/plugins, source mount/Compose identity, WooCommerce store/order state and historical PayPal Sandbox evidence.
2. First complete the existing **read-only** G3S1D Gate: classify the original execution-policy denial, permitted execution channel, and any proven cleanup-related missing resources. This Owner request does not waive active execution policy, allow alternate command surfaces or turn a denied start into an approved action.
3. After Reviewer accepts that diagnosis, prefer normal **authorized start of exact existing stopped G3C services**, if the approved execution channel actually permits it. Do not issue `compose up` with implicit recreate/pull/build, reinstall WordPress, replace the DB, or create blank volumes.
4. If anything is genuinely missing, STOP and return exact path/resource, evidence of ownership, data preservation and validated backup/restore plan. Reviewer must design a separate bounded recovery Gate before any recreation, restore or data-changing replacement; escalate irreversible loss or new authority to Owner.
5. After a permitted safe restart, re-check container/HTTP/DB/Woo/plugin/PayPal state, pre-install recovery barrier and only then determine whether the original G3S1 Stripe inactive staging may continue. All provider/payment/network constraints stay unchanged.

## Owner authorization boundaries

This records **recovery intent**, not a blanket operational override. No blanket administrator elevation, execution-policy change, alternative Docker SDK/GUI/shell bypass, secret disclosure, broad cleanup, volume deletion, production/public exposure, Stripe account connection, payment/refund, PayPal removal, PR merge or frontend redesign is authorized.

Owner action needed now: NONE for read-only diagnostic. New Owner checkpoint only if the classified compliant path needs consequential permission or irreversible action.
