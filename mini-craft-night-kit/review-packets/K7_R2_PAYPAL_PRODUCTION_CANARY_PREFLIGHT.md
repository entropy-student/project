# K7 R2 — PayPal Production Canary Preflight

Gate:
K7_R2_PAYPAL_PRODUCTION_CANARY_PREFLIGHT

Status:
AUTHORIZED_READONLY_AWAIT_EXECUTOR

Read:
- REVIEWER_HANDOFF.md
- PROJECT_RECORD.md
- PROJECT_STORAGE_MANIFEST.md
- docs/REVIEWER_DECISION_K7_R1_PASS_K7_R2_PRODUCTION_CANARY_PREFLIGHT.md
- accepted K7 R1 Evidence/Handoff
- canonical VPS Governance latest
- Production Provider Canary and Recovery Contract rev2
- payment-integration-governance latest

Goal:
Freeze every non-secret Production PayPal Canary invariant before asking Owner to authorize Live/payment/refund.

No mutation or provider buyer action is authorized.

Must seal:
- fresh PPCP Sandbox/Live state;
- Provider merchant/application/permission identity map;
- Live enablement path and Owner interaction;
- webhook/callback model;
- buyer/merchant separation;
- Product1224 qty1 JPY500;
- expected WooCommerce/order/payment/email semantics;
- full JPY500 refund path;
- merchant fee recovery status if safely observable;
- no-blind-replay limits;
- exact future Owner authorization package.

Forbidden:
PayPal Live/login/OAuth, order creation, payment, refund, webhook replay/mutation, product/email/DNS/VPS mutation, Secret output, Soft Launch.

Success:
PASS_CANDIDATE_K7_R2_PAYPAL_PRODUCTION_CANARY_PREFLIGHT
STOP_AT_REVIEWER=YES
