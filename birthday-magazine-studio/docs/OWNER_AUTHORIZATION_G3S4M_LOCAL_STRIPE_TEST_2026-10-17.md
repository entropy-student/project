# Owner authorization — G3S4M local Stripe TEST phase

> Owner approval relayed directly in the current conversation, 2026-10-17: “我批准开始吧”.
> Immediately preceding scoped question: authorize local G3S4M Stripe TEST-mode plugin activation, Owner's Stripe TEST account connection, one synthetic USD39.99 checkout, signed webhook/duplicate/invalid-signature tests and one TEST refund/revocation, conditional on Owner-private rotation of the previously disclosed WordPress administrator password.
> Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7
> Current Reviewer decision: `docs/REVIEWER_DECISION_G3S4M_CLI_STAGING_PASS_CONDITIONAL_MANUAL_TEST_ROUTE_2026-10-17.md`
> Existing Gate: `docs/G3S4M_OWNER_MANUAL_AUTH_AND_VERIFIED_LOCAL_STRIPE_TEST_CHANNEL_2026-10-17.md`
> Current PR baseline: #64 `5ee2531818b8cdf79f03cca8860f297152ac9d09`

## Explicitly accepted write scope

**APPROVAL_STATE=OWNER_AUTHORIZED_CONDITIONAL_TEST_ONLY.** One bounded sequence using **Owner's existing local** Windows 11/Docker WordPress at `http://127.0.0.1:8189`, official installed Woo Stripe v11.1.0, Woo product #1113 virtual **USD39.99** and the already verified private Stripe CLI v1.53.1 staging:

1. After mandatory readiness checks, activate only the existing official Woo Stripe plugin if activation can be proven to stay TEST-only and isolated from Live/unrelated providers.
2. Use the official plugin's normally supported Owner-visible TEST-only account/key configuration; the Owner personally authenticates to Stripe, supplies keys and listener signing secret **privately**, and approves any Stripe-side consent. No request or remote service in this chat obtains the keys, signing secret or session.
3. Operate a bounded Stripe CLI **outbound-only** TEST event listener to the native local Woo webhook endpoint, no public WordPress exposure, no public tunnel and no old/replacement VPS.
4. Execute **one** synthetic buyer checkout for exact Woo virtual #1113 **$39.99 USD**, inspect provider TEST outcome, verify actual signed first Webhook delivery, negative signature, replay/duplicate handling, Woo order/state/entitlement and no double job; bounded cancel/failure testing only when safe.
5. Execute **one TEST-only refund** for the verified corresponding TEST charge, inspect provider refund and local entitlement revocation, record one scrubbed Evidence result to PR #64 and mandatory Reviewer STOP.

## Hard pre-write preconditions — no duplicate approval needed

- **Password rotation checkpoint remains UNVERIFIED.** The Owner previously supplied a WordPress administrator password through chat/orchestration, so it must be treated as compromised and independently rotated in Owner's browser. Before plugin/account/payment/secret-bearing writes, obtain only non-secret `OWNER_PRIVATE_WP_PASSWORD_ROTATION_CONFIRMED=YES`; do **not** ask for either old/new password, claim rotation happened, or run earlier failed credential recovery scripts. If not yet done, Executor can continue **non-mutating** TEST configuration/official UI inspection but must stop before any consequential write.
- Confirm exact original localhost target, runtime roles, TEST vs Live payment settings, protected existing backups/source, one-product order/amount/currency and rollback. Reuse recently accepted preflight hashes and offline-restored evidence unless there is material change. Do not recreate Docker, repeat backups/restores, reset dirty worktree or merge PR #64.
- **Normal plugin TEST-only UI is not yet proven available.** Find exact Owner-visible supported manual TEST-key route prior to key submission or plugin/gateway write; account-key REST controller or settings fields in source alone are insufficient. If manual TEST UI is inaccessible, mandates HTTPS OAuth on loopback, or causes unplanned Live/other-provider/provider-webhook mutations, stop with `RETURN_MANUAL_TEST_UI_UNAVAILABLE`; do not bypass via direct WP option/SQL/REST/CLI eval, source patch, false connected state, signature bypass or arbitrary public tunnel. Request separate Reviewer technical remedy, **not** a repeat of the authorization.
- Stripe TEST and Live capabilities are separate. No real charge, real shopper, production enablement, payout, automatic fulfillment, public tunnel, remote VPS access, broad resource cleanup, source changes or payment retry after an ambiguous state.
- Manual user account consent/OAuth/2FA remains Owner-only. This is authorization to begin scoped work, **not** assertion that private credential rotation, Stripe login, Stripe account verification or any TEST payment has happened.

## Handoff

`NEXT=EXECUTOR_G3S4M_OWNER_AUTHORIZED_CONDITIONAL_LOCAL_TEST`.

Executor: use latest main Handoff, this explicit approval, existing Gate/Reviewer decision and PR #64 Evidence. Do targeted no-write preflight for current supported TEST UI and the private-rotation checkpoint, then perform ONLY the permitted TEST-only bounded actions if all preconditions are true. Append sanitized evidence to **existing** PR #64 `docs/evidence/g3s4/G3S4M_MANUAL_CHANNEL_AND_STRIPE_TEST_2026-10-17.md` and stop for Reviewer. A missing Owner rotation confirmation is a **single named prerequisite**, not authority to repeat the whole project discovery or request approval again.

`PROJECT_HOST_RUNTIME_CHANGED=NO`. `STRIPE_CONNECTED=NOT_CLAIMED`. `PAYMENT_TESTED=NOT_CLAIMED`.
