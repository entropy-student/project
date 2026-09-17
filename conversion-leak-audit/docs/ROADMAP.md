# Conversion Leak Audit — ROADMAP

## Current Map

```text
P0   Product / Governance                   PASS
P0A  WordPress-first                        PASS
P0B  Shared VPS final target                PASS
PF   Theory / Rules / Pre-development       PASS

G1   WordPress Local Baseline               PASS
G2   Safe Scanner V0                        PASS
G3   Rule Engine V0                         MERGED / CLOSED

G4   WordPress ↔ Scanner ↔ Top 3 Local Loop  NEXT
G5   Complete Fix Queue + LLM Explanation   PENDING
G6   VPS Onboarding / Storage               HOLD
G7   VPS Private Deployment                 HOLD
G8   Domain / HTTPS / Shared Ingress         HOLD
G9   Production Payment / Controlled Go-live HOLD
G10  Production Acceptance                  HOLD
G11  Acquisition / Business Validation      HOLD
```

## G4 — Local Free Loop

Goal:

```text
URL input
→ scan job
→ progress
→ evidence-backed findings
→ deterministic Top 3
→ WordPress result page
```

Acceptance:
- local-only end-to-end works;
- unsafe URLs fail closed;
- incomplete scan never becomes fabricated issue;
- evidence is rendered;
- user sees progress/errors;
- no payment / VPS / production Secret.

## G5 — Paid-value Product Layer

Goal:
- complete Fix Queue;
- prioritization;
- model explanation from structured findings;
- downloadable/shareable result if useful;
- paid/unpaid content boundary ready, but real payment still not required until approved Gate.

Important:
- LLM explains evidence; it does not replace deterministic scan facts.
- free scan should remain low/zero LLM-token where practical.

## G6 — VPS Storage / Onboarding

Before deployment, freeze:

```text
/srv/apps/conversion-leak-audit
/srv/data/conversion-leak-audit
/srv/backups/conversion-leak-audit
```

Must define:
- DB/storage location;
- Secret metadata and runtime reader;
- backup method;
- restore method;
- retention;
- project-specific Compose;
- no anonymous durable volumes;
- no cross-project durable sharing.

## G7 — Private VPS Deployment

Deploy project privately on Shared VPS without taking ownership of shared 80/443 or modifying shared infrastructure.

## G8 — Domain / HTTPS

Only through Shared Infra Gate when public ingress is needed.

Project must not independently modify:
- SSH;
- firewall;
- Docker daemon;
- shared reverse proxy;
- shared tunnel;
- shared network ownership.

## G9 — Production Payment / Controlled Go-live

Payment remains separate Gate.

Requirements:
- provider/account ready;
- entitlement contract;
- idempotency;
- refund/rights revocation;
- Secret safety;
- small controlled canary.

Prefer reuse of Unified Pay when it is the approved production route.

## G10 — Production Acceptance

Only call the product “online” when all applicable conditions hold:
- correct HTTPS domain;
- WordPress healthy;
- Scanner healthy;
- free scan loop works;
- payment loop works within approved scope;
- internal endpoints protected;
- persistent data survives restart;
- backup/restore path verified;
- rollback executable;
- VPS readback evidence exists.

## G11 — Acquisition / Business Validation

Measure:

```text
Solution Proof
→ Activation
→ Intent
→ Transaction
→ Retention / Referral as applicable
```

Do not scale acquisition before trust/product loop shows meaningful behavior evidence.
