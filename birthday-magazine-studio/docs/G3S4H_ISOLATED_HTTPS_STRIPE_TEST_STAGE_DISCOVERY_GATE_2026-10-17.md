# G3S4H — isolated HTTPS WordPress Stripe TEST staging discovery (READ-ONLY)

Date: 2026-10-17
Status: `AUTHORIZED_READ_ONLY_DISCOVERY; NO_DEPLOYMENT`
Parent Reviewer decision: `docs/REVIEWER_DECISION_G3S4M_RETURN_MANUAL_UI_SELECT_HTTPS_STAGE_2026-10-17.md`
Parent G3S4M Evidence PR #64 @ `3d460070f8eb61f4e47118e41a398fa14cc5b53f`.
Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` v0.2.7, triggered 11A (isolation and backups), 11B (host identity and Secrets), 11C (HTTPS/ingress), 11D (auth/automated fulfillment) and 11E (Provider/payment).

## Gate contract

```text
GATE_ID=G3S4H_HTTPS_WP_STRIPE_TEST_STAGE_DISCOVERY_20261017
OBJECTIVE=Identify a supportable minimal isolated public-HTTPS Woo/Stripe TEST staging target after local manual UI unavailability; do not start deployment/payment.
CURRENT=G3S4M_RETURN_MANUAL_TEST_UI_UNAVAILABLE;LOCAL_WOO_STRIPE_PLUGIN_ACTIVE_GATEWAY_DISABLED;NO_STRIPE_ACCOUNT_CONNECTED
MAX_ENDPOINT_THIS_ROUND=READ_ONLY_TARGET_DISCOVERY_AND_DESIGN_EVIDENCE
HOST_LOCATION=UNKNOWN_NO_OLD_VPS_REUSE
BUDGET_AUTHORIZED=NO
PROVISION_AUTHORIZED=NO
PUBLIC_INGRESS_AUTHORIZED=NO
STRIPE_PROVIDER_WRITE_AUTHORIZED_FOR_NEW_TARGET=NO
SECRETS_OR_OWNER_SESSION_ACCESS=NO
PR64=OPEN_UNMERGED;NO_MERGE
MANDATORY_REVIEW_STOP=YES
```

## Ordered preflight/discovery (no external writes)

1. Read main `REVIEWER_HANDOFF.md` latest section, parent G3S4M RETURN, this Gate, scoped project structure and latest accepted PR evidence. Reuse known local Docker/backup/CLI checks; do not re-run or alter the original local stack.
2. From existing **non-secret** project inventory only, verify if an already-owned WordPress/PHP-capable HTTPS staging service/domain can host an isolated clone. Do not assume Netlify's static site can run PHP/Woo; do not assume former VPS identity/configuration exists or replacement VPS is approved.
3. If unavailable, select **one concrete minimal externally hosted HTTPS WordPress staging option** using up-to-date verifiable terms and availability, plus one fallback only if technically distinct. State price when verified, else `PRICE_UNVERIFIED`; never create/purchase an account/domain/service.
4. Define minimum reproducible **synthetic checkout** staging package: WordPress/Woo verified compatible versions; official Woo Stripe 11.1.0; virtual USD39.99 #1113-equivalent fixture; only needed payment/entitlement lifecycle logic. No copy of actual buyer orders, admin users/passwords, business/Stripe Secrets, uploaded photos, or old DB directly. If an isolated staging data copy is essential, design a scrubbed export and verify it before any upload.
5. Sketch public boundary: isolated host DNS/TLS, anonymous test product/checkout plus signed `/?wc-api=wc_stripe` webhook only as required, private admin protection; no public debug page, browsing of uploads, raw payment logs, or tunnel. Ensure Stripe can reach HTTPS and that Woo can complete Owner-managed TEST OAuth. Check cross-site/account-webhook conflicts before creating an endpoint in a future approved Gate.
6. Give prewrite proof/rollback/teardown: precise target identity, domain ownership, cert, tested backup recoverability, reversible deployment manifest, access control, test-mode/live-negative checks, synthetic order bound, signed first/replay/invalid and refund, plus restoration of prior local unaffected state.
7. Identify any required **new explicit Owner authorization** for target hosting cost, public endpoint/domain, provisioning and provider TEST-site connection. Earlier `G3S4M` authorization was **localhost-only** and cannot be silently reused for remote/public work. Compromised local WordPress admin password rotation remains `UNVERIFIED`, no credential reuse.

## Exclusions and fail-closed

No deployment, VPS SSH, public tunneling, domain/DNS, cloud service mutations, host firewall/network, HTTPS endpoint creation, CI deploy, Git merge, Stripe login/Connect/Webhook, real/Test charge or refund, plugin enable/disable, database/backup creation/import, source changes or local credential rotation in this Gate. Do not repeatedly attempt the failed local TEST Webhook CLI/UI route. A discovered hostname or proposal does not prove ownership or readiness. If no identifiable feasible HTTPS target, report `RETURN_HTTPS_STAGE_TARGET_UNSELECTED` **with alternatives and exact missing fact**, not another large bootstrap sweep. Keep existing local Woo Stripe plugin `active`, gateway disabled, no settings and local stack otherwise unchanged.

## Required Evidence / relay

Produce a **short, sanitized** target recommendation with:
`RECOMMENDED_STAGE_TARGET | HOST_VERIFICATION | COST | DNS_HTTPS | DATA_SCOPE | SECURITY_EXPOSURE | PROVIDER_ACCOUNT_SEPARATION | MINIMAL_STAGE_ARTIFACT | ROLLBACK | OWNER_REQUIRED | NEXT_TEST_GATE`.
If no host verified, mark facts UNKNOWN rather than invent.
Commit one new `birthday-magazine-studio/docs/evidence/g3s4/G3S4H_HTTPS_STAGE_DISCOVERY_2026-10-17.md` **only** to the existing PR #64 branch without staging or changing local dirty sources, and stop for Reviewer. Before write check actual PR head and evidence-only scope; on material drift return for reconciliation. This plan is not authorization to start hosting or payment. Separate next write Gate begins only once a real host and explicit external-exposure Owner consent exist.
