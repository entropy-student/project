# K7 R2R1 — PayPal Live Connection + Webhook Recovery

Status: AWAIT_OWNER_AUTHORIZATION

Required Owner marker:
`AUTHORIZE_K7_R2R1_PAYPAL_LIVE_CONNECTION_AND_WEBHOOK_RECOVERY`

Read:
- `REVIEWER_HANDOFF.md`
- `PROJECT_RECORD.md`
- `PROJECT_STORAGE_MANIFEST.md`
- `docs/REVIEWER_DECISION_K7_R2_RETURN_K7_R2R1_PAYPAL_LIVE_CONNECTION_WEBHOOK_OWNER_CHECKPOINT.md`
- latest accepted `EXECUTION_EVIDENCE.md`
- latest `EXECUTOR_HANDOFF.md`
- canonical VPS Governance latest
- Production Provider Canary and Recovery Contract rev2
- payment-integration-governance latest

Do nothing until Owner authorization exists.

After authorization:
1. Owner completes official PayPal Live login/OAuth/consent directly.
2. No credential/2FA/token is recorded.
3. Freshly verify Live merchant/product-permission/binding state.
4. Verify production webhook target exactly:
   `https://minicraft.spikersun.com/wp-json/paypal/v1/incoming`
5. If and only if unhealthy/wrong, one PPCP Resubscribe action maximum.
6. If supported, one webhook simulation/test maximum after exact target is present.
7. Seal expected paid status, email path, refund path, buyer separation, no-blind-replay limits, fee-risk awareness.
8. No order/payment/refund.
9. Evidence + Handoff + GitHub readback.
10. STOP_AT_REVIEWER.

Success:
`PASS_CANDIDATE_K7_R2R1_PAYPAL_LIVE_CONNECTION_AND_WEBHOOK_RECOVERY`

Forbidden:
order creation, buyer action, payment, capture, refund, Product mutation, real webhook replay, email resend, infrastructure mutation, Secret output, Soft Launch.
