# G3S4L Reviewer — Stripe TEST payment/refund/workspace revocation PASS; identical-event replay not tested

Date: 2026-10-17
PR #64 latest verified HEAD: `577bb700de71a399bd52780d5a33eaeaca9d33ea`, OPEN and UNMERGED.
Prior source fix commit: `dcb10c560215194d8f0ea2e58949f2cf8b873f24`.
Evidence path: `birthday-magazine-studio/docs/evidence/g3s4/G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_2026-10-17.md` on PR64 @ 577bb700.
Current governing G3S4L Gate is `G3S4L_ORIGINAL_WP_CLOUDFLARE_TEST_ROUTE_GATE_2026-10-17.md`. Reviewed in accordance with `entropy-student/spike.skill/vps-project-governance/VNEXT.md` v0.2.7, notably §§5–9 and 11B–11E.

## Formal Reviewer classification

```text
RESULT=PASS_BOUNDED_STRIPE_TEST_PAYMENT_REFUND_WORKSPACE_REVOCATION
OVERALL_G3S4L=PARTIAL_DYNAMIC_REPLAY_NOT_TESTED
ONE_TEST_ORDER_PAYMENT=PASS
PROVIDER_PAYMENT_SUCCESS=PASS_EXECUTOR_EVIDENCE
SIGNED_PAYMENT_CALLBACK=CORRELATED_PROVIDER_EVENT_WOO_RUNTIME_EVIDENCE
SINGLE_39_99_TEST_GATEWAY_REFUND=PASS
STRIPE_REFUND_STATUS=SUCCEEDED;LIVEMODE_FALSE;AMOUNT_REFUNDED_3999
WOOCOMMERCE_REFUND_COUNT=ONE;ORDER_STATUS_REFUNDED;AMOUNT_REFUNDED_39_99
REFUND_ON_UNCERTAIN_SCRIPT_REPORT=READONLY_RECONCILIATION_BEFORE_ANY_RETRY;NO_RETRY
WORKSPACE_ENTITLEMENT=OWNER_PAID_ALLOW_BEFORE;OWNER_AFTER_FULL_REFUND_DENY
WORKSPACE_MYACCOUNT_ACTION_AFTER_REFUND=ABSENT
OTHER_USER_ANONYMOUS_UNPAID_FIXTURE=DENIED
DIRECT_ANONYMOUS_ROUTE=HTTP_403
DIRECT_LOGGED_IN_OWNER_AFTER_REFUND=SHARED_SERVER_PREDICATE_READBACK;SEPARATE_HTTP_AUTHENTICATED_GET_NOT_REPORTED
INVALID_SIGNATURE=APPLICATION_LEVEL_REJECTED_BUSINESS_STATE_STABLE;HTTP_204_NOT_4XX
DUPLICATE_REFUND_ID_GUARD=SOURCE_INSPECTED;DOES_NOT_PROVE_DYNAMIC_DELIVERY
IDENTICAL_EVENT_REDELIVERY=NOT_TESTED
SECOND_TEST_CHARGE_OR_REFUND=NONE
STRIPE_LIVE=NONE
PR64_MERGE=NO
```

## Inspected evidence and source identity

1. GitHub PR64 HEAD `577bb700...` contains ONLY the append to existing G3S4L Evidence; earlier source change `dcb10c56...` modified only `poc/g3c/commerce-workspace-plugin/bms-g3a-commerce-loop.php`. Compared `728609c5...577bb700`: three commits, only the evidence file and this PHP plugin source changed. Inspected complete current PHP source blob `30c7d928916f686aa4aeff6c26615b43783344dd`, which matches the identity stated by Executor. Reported active deployed source SHA-256 `9FE3093E4D1ADBE1DE237A819822A048A5D5A20154E556B19BAF4A69AC11A348`, PHP lint and runtime bind mount are **Executor DIRECT_READBACK evidence**, not an independent Reviewer shell inspection of Owner's machine.
2. Reconciling before refund: Executor verified unique existing TEST Woo USD39.99 order, PaymentIntent succeeded/livemode=false, matching TEST `payment_intent.succeeded` event, bound registered Owner and original workspace entitlement; both Woo and Stripe refund count zero. Safe identifiers in Evidence are short hashes only, no credentials, raw customer data or payment IDs.
3. Workspace plugin `bms_g3a_user_can_access_workspace($order,$user_id)` now guards **both** My Account workspace action and direct `template_redirect` route, requires current `$order->is_paid()`, positive total, status not failed/cancelled/refunded, refund total less than order total, and matching customer/order/owner meta. Partial refund retains access as an explicit current policy; full refund denies. Historical ownership binding remains as audit metadata and may be updated on status changes, but cannot by itself re-grant actual access while shared predicate denies. This fixes the prior ownership-only access weakness **for these two implemented workspace surfaces**. It is not a universal audit of every possible future download/intake/generation endpoint, which this proof-of-concept explicitly does not implement.
4. Actual refund used **one** Woo Stripe gateway request `refund_payment=true` against that matching TEST order, not a manual status-only refund. The post-call report errored because an unsupported `WC_Order_Refund` method was read; this was classified as ambiguous diagnostic extraction, followed by **read-only** provider/Woo reconciliation with **no repeat** payment/refund. Stripe TEST `charge.refunded=true`, amount_refunded 3999 cents, one refund status `succeeded` and `livemode=false`; Woo has exactly one matching 39.99 refund record, order `refunded`. This is sufficient to accept actual gateway refund, not to infer webhook replay correctness.
5. Owner paid positive pre-refund access and post-refund owner link removal/server predicate denying were Executor-tested; other existing user, anonymous, bound unpaid on-hold fixture denied. In-memory failed/cancelled/full-refund deny and partial-refund allow scenarios were executed without storing duplicate transactions. Anonymous direct URL 403 was observed. The production-like **authenticated owner HTTP GET to refunded direct route was not separately reported**; shared server predicate used by direct route is inspected, so source-level denial is supported, but do not invent an independent browser GET.
6. Stripe TEST refund `charge.refunded` event `pending_webhooks=0` and its event time matching Woo plugin `last_webhook_success_at`, plus handler validation-before-processing, **support/correlate authentic delivery**. Exact raw signed POST transcript was not independently captured by Reviewer. A minimal invalid signature request resulted in plugin response HTTP **204**, with log reason signature mismatch and unchanged Woo/order/access state. **204 is a successful HTTP acknowledgment code; the invalid event was discarded at application logic**, NOT an HTTP 4xx rejection. Keep that distinction for audit.
7. Identical TEST event **was not delivered twice**. The Woo extension's recorded refund-ID duplicate short-circuit and stored provider refund-ID are source/id correlation, **not a behavioral replay test**. Stripe Events retrieve/list APIs are read-only. The Codex configured PowerShell lacked an executable Stripe CLI, and the earlier Stripe Dashboard browser URL-confidence stop was respected. No reason to create second charges/refunds or bypass Browser safety to claim replay PASS.

## Reviewer decisions, next action and non-blockers

- **Accept and freeze bounded core payment/refund/revocation** as `PASS`. Do not repeat the same TEST purchase, gateway refund, Woo status transition, CSS/cart/navigation/Tunnel checks, or reopen the resolved original refund bug. Preserve the current fixed workspace entitlement guard; reverting to old source is unsafe for previously refunded orders.
- **Overall G3S4L formal completeness remains PARTIAL**, because a mandatory identical signed event replay/side-effect-idempotency criterion is `NOT_TESTED`. This may be a separately tracked one-target webhook replay test **only if an officially supported TEST event redelivery mechanism is available with trusted authorization** (e.g. official Stripe test event resend in provider UI/Stripe CLI, not mere Events retrieve/list). Do not use unofficial token harvesting, signing-secret copying, handcrafted valid signatures, or workaround of Computer Use's safety STOP. One replay of the **existing** event only; no new payment/refund; before/after Woo/provider refund count, order status and access state; if unavailable, record `REPLAY_UNAVAILABLE` as a release-hardening item, not fictitious PASS. Do not make all future non-payment feature development wait for a new infrastructure setup.
- The dormant `widget_text-3` URL debt, final rendered visual screenshot, individual protected-file synthetic URL are previously acknowledged and remain outside this limited payment canary. Do not claim a fully production-ready storefront, customer-fulfillment system or Live onboarding on the strength of a test-mode transaction.
- PR64 remains **OPEN and UNMERGED**; actual external-domain Woo/Stripe credentials or LIVE transactions are not authorized in this decision. **Owner action NOW: NONE**. Keep Docker and Cloudflare Tunnel running only as needed for subsequent work.
