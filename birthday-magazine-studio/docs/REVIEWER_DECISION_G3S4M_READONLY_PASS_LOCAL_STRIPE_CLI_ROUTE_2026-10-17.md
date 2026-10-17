# Reviewer Decision — G3S4M read-only local preflight PASS; Stripe TEST still blocked

> Date: 2026-10-17
> Project: Birthday Magazine Studio
> Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7; triggered 11A/11B/11C/11D/11E
> PR #64 / Executor Evidence commit: `5930438afd19af5cf718389ee4356a62fb22e705`
> Reviewed Evidence: `birthday-magazine-studio/docs/evidence/g3s4/G3S4M_MANUAL_CHANNEL_AND_STRIPE_TEST_2026-10-17.md`
> Current accepted Gate: `docs/G3S4M_OWNER_MANUAL_AUTH_AND_VERIFIED_LOCAL_STRIPE_TEST_CHANNEL_2026-10-17.md`
> Action: Reviewer audit/document-only. No local machine, account, Provider, secret or VPS mutation.

## Independent Reviewer disposition

```text
G3S4M_READ_ONLY_PREFLIGHT=PASS
REVIEWED_PR_HEAD=5930438afd19af5cf718389ee4356a62fb22e705
EVIDENCE_COMMIT_SCOPE=ONE_NEW_EVIDENCE_MARKDOWN_ONLY
WORDPRESS_WOO_LOCAL_PRESENCE=PASS_EXECUTOR_DIRECT_READBACK
BACKUP_SELECTED_THREE_FILE_HASH_AND_SIZE=PASS_EXECUTOR_DIRECT_READBACK
STRIPE_PLUGIN=OFFICIAL_11_1_0_INSTALLED_INACTIVE
STRIPE_TEST_READY=BLOCKED_WEBHOOK_CHANNEL_UNESTABLISHED
G3S4M_FULL_TEST_GATE=IN_PROGRESS_NOT_PASS
STRIPE_CONNECTION_PAYMENT_WEBHOOK_REFUND=NOT_EXECUTED
CREDENTIAL_ROTATION=UNVERIFIED_OWNER_ONLY
STRIPE_TEST_WRITES_OWNER_APPROVAL=NOT_YET_RECORDED_FOR_G3S4M
PUBLIC_WEBHOOK_OR_TUNNEL=NOT_AUTHORIZED
OLD_OR_REPLACEMENT_VPS=OUT_OF_SCOPE
PR64_MERGE=NO
```

This PASS accepts the defined bounded **read-only preflight** alone. It is not Stripe TEST end-to-end acceptance, payment/provider authorization, webhook proof, or independent possession of the Owner's Windows machine.

## Actually inspected evidence and boundaries

- Commit `5930438...` is the current PR #64 head, open/unmerged. GitHub commit diff adds **exactly one** new G3S4M Evidence Markdown (74 lines) and no application, payment, infrastructure, or local-host source.
- The evidence gives host-local readback of original Windows 11 Docker Desktop context and project `birthday-magazine-g3c`: WordPress `wordpress:7.1.1-php8.3-apache` loopback-only `127.0.0.1:8189`, WordPress 7.1.1; WP-CLI; MariaDB 11.4.7 running healthy; Mailpit stopped. WooCommerce 11.1.2 active, virtual product #1113 USD39.99, read-only GET 200, current order count 1. Host data is Executor direct readback, not Reviewer-host direct readback.
- Four project source bind mounts correlated, accepted earlier 44-file source fingerprint reused; dirty working tree (3 modified, 17 deleted, 180 untracked) unchanged.
- Three existing project-owned backup artifacts were size/SHA-256 verified against accepted G3S4R; historical isolated restore accepted at that older scope, **not** a new restore or blanket ability to undo current payments.
- Official Woo Stripe 11.1.0 plugin is **inactive** and no saved Stripe gateway options/hook appear; local GET 400 to `/?wc-api=wc_stripe` is **not** a signed POST and neither proves a functioning webhook nor signals a current provider outage. No Stripe CLI/ngrok/cloudflared was found locally.
- Local generation remains disabled according to inspected project option/source; no automatic-generation proof is promoted from a negative readback. No provider connection, payment, webhook, refund, order/DB change, shared-host, public exposure or VPS mutation in this Gate.

## Reviewer-approved route, with explicit uncertainty

**Preferred technical candidate:** official Stripe CLI's outbound `stripe listen --forward-to` forwarding to the current loopback Woo Stripe route, **not a public ngrok/cloudflared/SSH tunnel and not a public WordPress endpoint**. According to Stripe official documentation, CLI `listen` can forward sandbox/test-mode webhook events to a locally bound HTTP endpoint without registering a public webhook destination. WooCommerce's official Stripe docs state the extension uses `/?wc-api=wc_stripe`. Sources:

- https://docs.stripe.com/webhooks#local-listener
- https://docs.stripe.com/cli/listen
- https://docs.stripe.com/cli/install
- https://woocommerce.com/document/stripe/setup-and-configuration/stripe-webhooks/

**Candidate is NOT integration proof.** WooCommerce Stripe 11.1.0 is currently inactive; its actual registered webhook handler, TEST-mode behavior, event subscriptions, CLI listener account scope, signing secret validation, and support for configuring the CLI-issued `whsec` separately from the plugin-managed official Woo/Stripe webhook connection must be proven on the installed version. Woo's standard connected-account onboarding/webhook provisioning may require a publicly reachable HTTPS site, even if the CLI can forward events; do not assume CLI bypasses the official plugin requirements. If the exact native Woo TEST adapter cannot accept the local CLI listener's signing secret without modifying unrelated plugin/source or weakening verification, **STOP and RETURN precise compatibility gap** for Reviewer choice of an isolated dedicated HTTPS test environment. Never bypass signature checks or return static 200.

**Next allowed bounded preparation** (existing G3S4M Gate, no new Gate for each substep):

1. **No provider writes:** perform narrow read-only compatibility/source/official-document review for *installed Woo Stripe 11.1.0*, identify the precise local webhook endpoint, whether a TEST signing secret can be set by supported plugin UI/config safely, and whether Stripe CLI authentication/forwarding is compatible with the official plugin account/Connect setup. Inspect event type requirements and confirm no false success/duplicate event handling. No login or secret retrieval at this stage.
2. If compatible, Executor may stage the official Windows-compatible Stripe CLI **only in a project/Owner-user-scoped reversible tool location** after pinning official source/version/integrity, checking native exit and no auto-update/background service/global PATH/port or shared changes. Installation is not Stripe login. If install is forbidden by actual execution environment or official verified artifact is unavailable, return a precise installation/transport issue; no speculative alternate tunnel.
3. For a non-Provider dry run, inspect CLI help/version and exact loopback URL/path plus plugin inactive baseline; no `stripe login`, `stripe listen` connected to an account, event trigger, signing-secret output, WordPress plugin activation or business mutations under the preparation authorization.
4. Preserve existing backups/dirty checkout and PR #64 source, record minimal sanitized results in the same project's G3S4M Evidence (append stage/results without erasing earlier Evidence), and mandatory Reviewer stop if new source/host mutation occurs. No need to repeat 44-file compare or 3-file backup hash unless material drift.
5. **Before any subsequent Stripe TEST plugin activation/account connection/signed event/payment/refund** require a newly bounded explicit G3S4M Owner TEST-write authorization, Owner-private rotation of the exposed WordPress administrator credential, positive real-local target and rollback proof, isolated TEST/Sandbox mode, and Owner-only authentication/OAuth; secrets never go in chat/tool input/repo/argv/logs.
6. For any future TEST listener, preserve raw request body, verify `Stripe-Signature` against the correct **CLI listener TEST signing secret** as safely configured for the installed Woo Stripe test handler; test first authentic delivery, duplicate/replay, invalid signature, incorrect order/amount/currency/account, and local Woo/fulfillment state independently. Synthetic fixture `stripe trigger` alone is **not** proof of a native Woo checkout-correlated purchase. No paid retry when previous provider outcome is ambiguous.

## Reviewer-to-Executor relay for immediate next substep

Start with current `REVIEWER_HANDOFF.md`, this Reviewer decision, existing G3S4M Gate and this accepted G3S4M read-only Evidence. Evaluate only *installed Woo Stripe v11.1.0 ↔ official Stripe CLI local TEST forwarding compatibility*, and if clearly compatible stage only an official verified reversible CLI binary in project/private user scope. Distinguish CLI capability from working Woo integration. No Owner actions for documentation research or non-secret CLI staging. Do not touch old/replacement VPS, open a tunnel, login to Stripe, read/store tokens, install globally, alter plugin/Woo/database, send events or check out; do not re-run accepted host/backup proof. Report exact evidence of integration eligibility or precise `RETURN_STRIPE_LOCAL_WEBHOOK_ADAPTER_INCOMPATIBLE` / `RETURN_STRIPE_CLI_STAGING_UNAVAILABLE` and stop at Reviewer.

## Owner action

- Owner independently rotates the exposed WordPress password in existing local WP admin UI and reports only that it was done. **Not confirmed in this review.**
- No new Owner authorization is needed for this read-only planning or non-secret reversible local CLI preparation. Later Provider TEST authentication/activation/payment/refund **requires a separate explicit Owner authorization** under G3S4M.
