# G3S4L Reviewer — one successful Stripe TEST payment reported; refund and workspace revocation remain unverified

Date: 2026-10-17
Authority: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7 §§5–9, 11B–11E. Scope: original WordPress/WooCommerce, public `https://magazine.spikersun.com`, Stripe TEST only.
GitHub state independently read back: PR #64 OPEN/UNMERGED, HEAD `728609c54b68ae955150fd4957af93cac2f4d815`; existing G3S4L Evidence last section is still the previously accepted targeted navigation repair. **This NEW one-payment report is Owner-provided Codex relay, NOT backed by a new PR Evidence appendix.**

## Formal decision

```text
REVIEWER=PARTIAL_PASS_CANDIDATE_TEST_PAYMENT;CLOSED_LOOP_NOT_PASSED
STRIPE_TEST_ONE_PAYMENT=EXECUTOR_REPORTED_SUCCESS_NOT_IN_PR_EVIDENCE
ORDER=EXECUTOR_REPORTED_PROCESSING
WEBHOOK=EXECUTOR_REPORTED_VALID_SIGNED_RECEIVED
WEBHOOK_TEST_ENDPOINT=https://magazine.spikersun.com/?wc-api=wc_stripe
LIVE_TRANSACTIONS=EXECUTOR_REPORTED_NONE
NEW_ORDER_ALLOWED=NO_DO_NOT_SUBMIT_SECOND_CHECKOUT
REFUND=NOT_SUBMITTED_NOT_VERIFIED
INVALID_SIGNATURE_AND_REPLAY=NOT_TESTED
WORKSPACE_REVOCATION=NOT_TESTED
WORKSPACE_CODE_STATIC_FINDING=NO_PAID_STATE_OR_FULL_REFUND_GATE
COMPUTER_USE_STRIPE_DASHBOARD=STOP_URL_CONFIDENCE_LOW;DO_NOT_BYPASS
PR64_EVIDENCE_FROM_LATEST_RUN=NONE
ACTIVE_NEXT=DOCUMENT_SINGLE_EXISTING_TEST_ORDER_AND_REPAIR_ACCESS_PREDICATE_THEN_ONE_NATIVE_WOO_STRIPE_TEST_REFUND
OWNER_ACTION_NOW=NONE
```

## Reviewer source inspection — concrete code risk, not assumed runtime proof

Code inspected at PR branch `codex/birthday-magazine-g3c-blocksy-wedding-productization`:
- `birthday-magazine-studio/poc/g3c/commerce-workspace-plugin/bms-g3a-commerce-loop.php` (125 lines, blob `33ee82dd1c79c8e5f0c6ff85855b3a3537520b8c`).
- Function `bms_g3a_bind_workspace_to_order` at lines 50–59 writes `_bms_g3a_workspace_order_id` and `_bms_g3a_workspace_owner_id` for any order with customer_id>0, **without status/payment/refund eligibility**. It is invoked from `woocommerce_checkout_order_processed` and **on every** `woocommerce_order_status_changed` at lines 61–64; refunded/cancelled changes can re-save ownership bindings.
- `woocommerce_my_account_my_orders_actions` at lines 66–80 displays "Open Birthday Magazine workspace" based solely on owner identity/binding. `template_redirect` lines 82–104 checks signed-in user and matching owner/order binding but **not paid status, full refund, cancellation or remaining entitlement**. That allows a plausible persisted-access bug even for non-paid orders; this is a **source risk**, not yet a confirmed test of this specific Stripe order.
- `birthday-magazine-studio/poc/g3c/scripts/provision-workspace-fixture.php` creates an **unpaid on-hold** synthetic test order with workspace binding for legacy local tests. That fixture demonstrates old ownership-only design, **not a paid entitlement**. Never conflate it with the new Stripe test transaction. Guest checkout with `customer_id=0` is intentionally skipped by the binding helper; whether the paid test order has a real linked Owner account and any live workspace entitlement must be read back **before** claiming revocation.
- The plugin PHP is read-only mounted to WordPress via `poc/g3c/compose.yaml`; check the actual running plugin activation and deployed source identity before changing anything. No assumption that checkout was authenticated or that this source is active in the running container.

**Correct model:** preserve ownership binding as historical/audit metadata if appropriate; **grant** workspace/download/intake access only by a centralized server-side entitlement predicate, checked on **both** account link rendering and every actual workspace/access endpoint. Require verified paid/eligible order status and not failed/cancelled/fully refunded; full refund must remove entitlement even if binding metadata remains. Partial-refund policy should be explicit and separate, not silently treated as full revoke. For status events, prevent re-grant on refunded/cancelled/failed status, and ensure repeated event delivery cannot flip a revoked entitlement back on. Do not delete all order meta, real customer records or original fixture just to force a superficial PASS. Confirm guest no owner binding case honestly.

## Why browser failure need not stop the payment test

Official Woo Stripe extension supports gateway refunds directly inside **WooCommerce Orders**, without using the Stripe Dashboard; see https://woocommerce.com/document/stripe/admin-experience/refunding-orders/ and https://woocommerce.com/document/woocommerce-refunds/ . **Refund via Stripe** is a gateway request, whereas **manual refund/status edit** does not return payment. Do not claim a native refund executed merely because Woo status is `refunded`. Legitimate native Woo server-side gateway API/Order UI is a separate existing authorized path, **not** an alternate browser automation workaround. Continue to respect Computer Use's unsafe Stripe-dashboard tab URL-confidence STOP; no token/cookie extraction or browser substitution.

## Next single bounded Executor round — no second payment

1. **Evidence-first safe reconciliation** on the actual Owner WordPress runtime, using existing order/payment references only. Locate **the unique latest TEST order** by Woo native query and Stripe TEST gateway payment intent metadata; prove match on exact total/currency, order created_at, `processing` and genuine signed Webhook log/event ID/response (record **redacted fingerprints** only). If there are multiple plausible orders or PaymentIntents, STOP without choosing arbitrarily. Check current refund already zero (not just Woo status), pending provider refund and gateway TEST account; do not repeat charge or broadcast event. Append sanitized proof **to existing PR64 G3S4L Evidence** before mutating.
2. **Code fix, only if deployed behavior is affected:** inspect actual deployed `bms-g3a-commerce-loop.php` and all reachable workspace routes/actions; use minimal change in PR64 existing commerce-plugin source (not `main`) that **separates ownership from server-side paid entitlement**. Verify unpaid/on-hold, failed/cancelled and fully refunded **deny** (including direct URL), paid `processing/completed` owner **allow**, other user/anonymous **deny**, partial refund behavior as explicitly defined, repeated status hook does not regrant. Avoid any live order writes; use safe non-payment synthetic fixtures for logic tests. Preserve activated plugin and rollbacks. No broad Woo plugin reinstall, unrelated schema migration or new test purchase.
3. **Single TEST gateway refund** for the SAME uniquely matched USD39.99 TEST order **after entitlement fix is deployed and verified** and once there is no prior provider refund: prefer existing authorized WooCommerce native order refund API/official `Refund via Stripe` integration, **not** Stripe-dashboard Computer Use. Before write inspect gateway method `stripe`, TEST flags, refund capability, order total and existing refunds/provider status. Use only one full amount TEST refund request. On timeout/uncertain result, **read back actual Woo refund records + provider TEST payment/refund status first**, never blindly retry; use supported idempotency controls where available. Distinguish Woo "Refund manually" and status-only update (NOT proof gateway refund).
4. **Observe and test:** check official gateway TEST refund confirmation, Woo native order refund record/paid-state transition and webhook delivery. Check legitimate existing authenticated owner/workspace link and **direct URL** now deny if full refund. For webhook duplicates, use a controlled replay of the **same legitimate TEST event** if officially supported without causing another charge/refund; for invalid signature, use a minimal harmless negative test body/header at **the original callback** only if compliant and separately inspect denial/non-side-effects. Do not forge a valid signature, turn off signature enforcement, edit a real event payload, share signing secret or abuse an existing production account. If no safe replay feature, report precisely `REPLAY_NOT_TESTED`, not PASS. Verify event idempotency by state/side-effects, not solely HTTP 2xx.
5. **Evidence only, sanitized:** link to one actual PR64 G3S4L Evidence appendix; include static code fix commit, TEST order ↔ intent matched redacted, signed webhook first/invalid/replay results actually observed, one provider TEST refund ID fingerprint, order refund record and access checks. No card number, email, customer names, auth headers, secret, Stripe live account. STOP at Reviewer. PR64 OPEN/UNMERGED.

**If existing TEST purchase was guest and no workspace entitlement was ever issued**, complete its legitimate refund independently after verifying; do not claim "revocation tested" on an entitlement that never existed. Validate server-side entitlement logic with an isolated existing synthetic owned-order fixture, and document the remaining direct-paid-owned-order E2E gap rather than creating a second payment without separate authorization.

**Owner interaction:** none requested now. Keep existing Docker WP and Cloudflare Tunnel running; do not perform another browser Stripe Dashboard login. Any material provider permission or irreversible write failure is one exact narrow checkpoint. Live payments, other customers/order changes, VPS, new WordPress, PR merge are prohibited.
