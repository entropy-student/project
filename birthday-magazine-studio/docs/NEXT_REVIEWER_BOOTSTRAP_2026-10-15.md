# Birthday Magazine Studio — Next Reviewer Bootstrap

> Updated: 2026-10-15
> Purpose: sufficient handoff for a NEW Reviewer when chat context runs out
> Canonical truth: **current** `birthday-magazine-studio/REVIEWER_HANDOFF.md` + **current Gate** on GitHub `main`. This file is a concise locator/status snapshot and never overrides them.
> Governance: `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md`, v0.2.7 ACTIVE_PROVISIONAL.

## Operating roles / mandatory protocol

- Owner = user; Reviewer = current ChatGPT; Executor = Codex. Reviewer **must not write application implementation as Executor**.
- Loop: Current State -> Gate -> Preflight -> Execute -> Evidence -> Review -> New State.
- `PASS_CANDIDATE != PASS`. Executor output in Owner chat is owner-relayed, not independently validated host proof.
- Reviewer must read current governance universal text (header, 0–10, trigger matrix, 12–13) and all triggered specialist sections (11A–11G). Never load retired governance or broad incident history by default.
- Reviewer independently verifies fresh project-scoped Git source, current Gate, accepted Evidence and required runtime facts before declaring PASS or RETURN.
- `UNKNOWN` must remain UNKNOWN; stopped containers do not prove plugin flags or database contents.
- Reviewer alone owns formal decision/Gate design; Executor receives narrow `REVIEWER_TO_EXECUTOR_RELAY` and need not reread all history.
- Every consequential Reviewer round updates durable project-scoped decision/evidence/Handoff on main and fresh-reads before declaring completion.
- Never re-run accepted consequential payment, model or image work to recreate evidence.
- No credentials, Stripe bank/KYC documents, buyer PII, Woo order private payloads, full DB dumps or live Provider logs in GitHub/review chat.

## Repositories and immutable checkpoints

```text
GOVERNANCE_REPO=entropy-student/spike.skill
GOVERNANCE_CANONICAL=vps-project-governance/VNEXT.md
PROJECT_REPO=entropy-student/project
PROJECT_DIR=birthday-magazine-studio/
PROJECT_HANDOFF=birthday-magazine-studio/REVIEWER_HANDOFF.md
PR_NUMBER=64
PR_HEAD_REVIEWED_G3S0=c90e6f93803ad861745cd476106e00d01c68debb
PR_STATUS_G3S0=OPEN_UNMERGED_MERGEABLE_FALSE
FRONTEND_OWNER_VISUAL=PASS_FROZEN
G3S0_REVIEWER_DECISION=PASS_READINESS_CLASSIFICATION_ONLY
CURRENT_GATE_AT_HANDOFF=G3S1_LOCAL_STRIPE_GATEWAY_STAGING
STRIPE_ACCOUNT_EXISTS=UNKNOWN
STRIPE_LIVE_ELIGIBILITY_AND_PAYOUT=UNKNOWN
PAYPAL_RETIREMENT=NOT_AUTHORIZED
```

Do not assume these commits remain tips; **refresh PR #64 and main** every new Reviewer round. There are known old PR/document conflicts; never blind rebase, reset, squash, merge or discard accepted evidence. Shared monorepo unrelated changes do not by themselves block project-scoped freshness.

## Product contract — business invariants

Product: US-first, English-language, personalized **12-page US Letter digital birthday magazine**, test price **USD 39.99**; print deferred. Personal photos + short structured answers, no user editing a magazine manually.

Canonical buyer flow:
```text
Homepage
-> Free Preview (recipient name/age/style + optional ONE browser-local photo)
-> CTA to separate Core Function page
-> full intake: 12-25 photographs, up to 3 must-use, 6 required short answers
-> server-validated immutable/identified pre-payment draft snapshot
-> WooCommerce checkout/payment
-> authenticated customer account/private order workspace
-> verified paid entitlement binds exact draft to Woo order/customer
-> one generation-ready job maximum per paid order
-> personalized PDF proof/revision/private download/delivery
```

**Important:** visually working five-step intake currently stores data only in the browser; the durable server-side pre-payment draft is **NOT BUILT**. No generation before exact paid Woo entitlement; checkout/order alone is not proof of fulfillment.

Free Preview: zero model, vision/image generation, third-party upload or server photo POST; optional local image remains browser-local. Production PDF architecture deterministic + grounded AI text; no AI portraits. Exactly 12 pages; fixed emotional spine + 2 data-supported modules; 3 style presets; one bounded revision batch. Paid proof/final access authenticated/order-owned. After final delivery delete sources/intermediates within 24h, final PDF within 72h; abandoned prepayment draft TTL still implementation-dependent.

## Accepted layers vs missing capabilities

| Layer | Status |
|---|---|
| G2BR3 structured AI text + deterministic 12-page PDF | PASS solution proof, not full unattended service |
| G3A WordPress/WooCommerce + account/private-workspace foundation | PASS historical scope |
| G3B/G3BR1 PayPal Sandbox payment/paid entitlement/refund/revocation | PASS historical PayPal-only |
| G3CR6 homepage/FREE Preview and G3CR7 five-step frontend | Owner visual PASS 2026-10-15; technical source latest candidate still has separate review caveat |
| G3CR7 standalone payment/generation status sample | QA_ONLY; actual status belongs in Woo order/private workspace |
| G3S0 Stripe account/plugin/webhook readiness | Reviewer PASS classification only, not operational |
| G3S1 local Woo/Stripe staging | NEXT; no execution evidence yet |
| Stripe install/test/live/merchant/KYC/payout | UNKNOWN / NOT DONE |
| Pre-payment server draft/snapshot linkage | NOT DONE |
| Stripe synthetic test capture, webhook signature, refund and replay | NOT DONE |
| Automatic model dispatch, storage/private delivery, P1-P12 final design | NOT DONE |
| Real customer payment, CAC/economics, production launch | NOT PROVEN |

Frontend visual style: Stripe-inspired SaaS application structure + Birthday Magazine mulberry `#713F5D`; no decorative SVG/mesh/abstract face figures. Final UI visually accepted by Owner at PR #64 c90e6f...; DO NOT reopen visual work absent new Owner demand. The separate latest technical PASS_CANDIDATE source check is not automatically cleared by visual approval.

Local historical stack: Owner Windows 11; G3C isolated Docker WordPress 7.1.1/PHP8.3, MariaDB 11.4.7, Mailpit 1.31.2, WooCommerce 11.1.2, Woo product 1113 virtual USD39.99; localhost `127.0.0.1:8189` / Mailpit 8190. G3S0 Executor **reported all three containers STOPPED, volumes/networks retained**, and did not restart; active plugins/payment settings/products are **NOT fresh read back**.

## Current payment choice and limitations

- Owner selects **Stripe as TARGET PRIMARY payment provider**.
- Existing PayPal Payments Sandbox evidence preserved; do not disable/uninstall unless Owner separately authorizes a post-validation migration.
- WooCommerce continues to own canonical checkout/orders/paid status.
- Preferred official plugin: `woocommerce-gateway-stripe`. Do not create homemade payment logic or switch to WooPayments by default.
- Stripe account existence/merchant country/legal entity/KYB/payout bank remain UNKNOWN from G3S0 evidence. Wise HK receiving account is NOT a proof of valid Stripe merchant region or payout capability.
- Local HTTP loopback is NOT an accepted public HTTPS webhook origin; no active tunnel/config recipe established. Provider login, Test OAuth, HTTPS callback, synthetic/real payment, refund and live enablement each require their own reviewed gates/Owner checkpoints.
- Woo static plugin compatibility read-only PASS for release 11.1.0 on known historical versions; not runtime compatibility or operational proof.

## G3S0 result provenance and current Gate

**Authoritative decision:** `docs/REVIEWER_DECISION_G3S0_PASS_READINESS_WITH_RUNTIME_UNKNOWN_2026-10-15.md`.

**Preserved owner-relayed Executor report and evidence limitations:** `docs/evidence/g3s0/OWNER_RELAY_AND_REVIEW_COVERAGE_2026-10-15.md`.

**Current Gate:** `docs/G3S1_LOCAL_STRIPE_GATEWAY_STAGING.md`. The Gate already exists on main and must be used as written, not re-designed by default.

G3S1 phases:
1. fresh PR/main project-scoped comparison, confirm actual Owner Windows target and correct retained G3C containers/mounts/ports;
2. safe start of **existing** stopped containers only, no rebuild/pull/recreate/delete; separately verify HTTP, DB, Woo and product metadata;
3. redacted plugin inventory and PPCP/Stripe settings status (do not read Secret values);
4. consistent DB + file backup and prove recovery compatibility/rollback; do not store it in Git;
5. if absent and safe, install pinned official Stripe Gateway package **INACTIVE** only, locally. If prior install/connection or material drift, fail closed and RETURN to Reviewer;
6. minimal front-end/checkout GET smoke and current plugin readback, stop.

Do **not** connect Stripe account/Test mode, expose HTTPS tunnel, create test checkout/charge/refund, activate gateway, alter PayPal, use Shared VPS, start model jobs, merge PR #64, or implement prepayment drafts under this Gate.

## Later sequence (NOT authorized merely by this bootstrap)

- Independent Reviewer accepts G3S1 staged runtime.
- Separate Stripe account region/entity/KYC and test login/OAuth Owner checkpoint.
- Separate HTTPS webhook test ingress/negative access and distinct Test-mode connector Gate.
- Separately authorized limited synthetic Stripe payment/3DS/cancel, server-signed webhook authenticity, exact merchant/environment/amount/currency/order match, durable first-event and replay idempotence, refund + entitlement revocation with strict no-double-spend guards.
- Prepayment durable draft design/build and server-validated order snapshot linking before a real payment-to-generation chain.
- Paid order -> at most one canonical generation job with 0 job on unpaid or incomplete draft; only after fully proven provider correlation; then PDF generation QA/private proof/revision/download, 24h/72h deletion.
- Pre-merge reconciliation of PR #64 separately, and explicit live merchant/payout and Owner cutover/PayPal retirement approval later.

## Reviewer next-turn instructions

If the next message is a Codex G3S1 result:

1. Read canonical governance and the triggered specialists, `REVIEWER_HANDOFF.md`, current `G3S1` Gate, then the Executor's evidence (not broad history).
2. Fresh GitHub main + PR head + project-scoped changes.
3. Verify exact Owner-local Windows execution identity, same G3C container IDs/mounts, no recreation; health separated into container/HTTP/DB/Woo.
4. If staged, check backup is DB-consistent and restorable, source/version/hash of official Stripe package, plugin inactive/not checkout-offered, PayPal unchanged.
5. Verify mutation counters: **0 provider auth/API / payment / refund / public tunnel / live checkout / model / production / Shared VPS / PR merge**.
6. Preserve UNKNOWN merchant/KYC/payout until separately Owner-verified.
7. Reviewer writes independent PASS/RETURN and scoped evidence to main, updates Handoff, and opens only the next justified Gate.

If the next user request is ONLY to hand off this chat, do not run G3S1 yourself. Provide compact Owner-facing progress + a copyable next-Reviewer starter prompt pointing at this bootstrap and current Gate.

## Read order for new Reviewer

1. `entropy-student/spike.skill/main/vps-project-governance/VNEXT.md` (current full required slices + triggers).
2. `entropy-student/project/main/birthday-magazine-studio/REVIEWER_HANDOFF.md`.
3. `entropy-student/project/main/birthday-magazine-studio/docs/NEXT_REVIEWER_BOOTSTRAP_2026-10-15.md` (this summary).
4. `entropy-student/project/main/birthday-magazine-studio/docs/G3S1_LOCAL_STRIPE_GATEWAY_STAGING.md`.
5. G3S0 Reviewer decision/evidence index, Owner Stripe decision, MVP contract (only the relevant sections), accepted PayPal invariants as needed.
6. Incoming Executor G3S1 report, actual evidence, then any exact source/host file needed.

**Do not take broad history or prior chat assistant statements as higher authority than fresh GitHub current state.**
