# Conversion Leak Audit — ROADMAP

## Current Map

```text
P0   Product / Governance                    PASS
P0A  WordPress-first                         PASS
P0B  Shared VPS final target                 PASS
PF   Theory / Rules / Pre-development        PASS

G1   WordPress Local Baseline                PASS
G2   Safe Scanner V0                         PASS
G3   Rule Engine V0                          MERGED / CLOSED
G3.5 UI + Growth Design Freeze               PASS
G4   WordPress ↔ Scanner ↔ Top 3 Local Loop   PASS
G4.5 Visual + Functional Acceptance          NEXT / EXECUTOR READY
G5   Full Fix Queue + LLM + Skill Dogfood    PENDING
G6   VPS Onboarding / Storage                HOLD
G7   VPS Private Deployment                  HOLD
G8   Domain / HTTPS / Shared Ingress          HOLD
G9   Payment / Controlled Go-live            HOLD
G10  Production Acceptance                   HOLD
G11  Acquisition / Business Validation       HOLD
```

## G3.5 — UI + Growth Design Freeze

Owner + Reviewer Gate. Before Codex product implementation, freeze:

- customer journey and core Aha;
- page information architecture;
- Trust / Proof / Offer / CTA;
- desktop + mobile high-fidelity references;
- Design System;
- loading / progress / error / incomplete states;
- Analytics Event Contract;
- Visual Acceptance / Golden Screenshots;
- Functional Acceptance;
- Free → Paid boundary.

Core Activation hypothesis:

```text
URL submitted
→ scan completes
→ evidence-backed Top 3 viewed
→ user experiences “this found something concrete about my store”
```

`clone-ui` is reference extraction only. It must not directly rewrite the product architecture or broad existing source code.

Acceptance: the implementation brief is sufficiently precise that Codex does not need to invent product/UI decisions while coding.

## G4 — Local Free Loop

G4 is PASS. The accepted implementation is merged to `main`; `G4_EXECUTION_CONTRACT.md` remains the historical implementation contract.

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

## G4.5 — Visual + Functional Acceptance

Current Gate. Released to Codex under `G4_5_ACCEPTANCE_CONTRACT.md`. Run after G4 implementation and before expanding product scope.

Must prove:
- functional acceptance suite passes;
- desktop/mobile golden screenshots exist;
- Playwright screenshot comparison is within accepted tolerance;
- loading/error/incomplete states match design contract;
- implementation did not break Scanner safety or WordPress baseline;
- analytics events fire according to contract.

## G5 — Full Fix Queue + LLM + Skill Dogfood

Goal:
- complete Fix Queue;
- prioritization;
- model explanation from structured findings;
- optional downloadable/shareable result;
- Free vs Paid value boundary;
- record real product hypotheses in `SKILL_DOGFOOD_LOG.md`.

LLM explains evidence; it does not replace deterministic facts. Free scan should remain low/zero-token where practical.

## G6 — VPS Storage / Onboarding

Freeze project storage, backup, restore, Secret metadata, Compose and isolation before deployment.

## G7 — Private VPS Deployment

Deploy privately without taking ownership of shared 80/443 or shared infrastructure.

## G8 — Domain / HTTPS

Public ingress only after Shared Infra Gate.

## G9 — Payment / Controlled Go-live

Payment is deliberately deferred until the product loop is already working.

Current provider decision:
- tentative default: **Direct PayPal**;
- Unified Pay is not a current dependency because it still needs separate fixes and production validation;
- re-open payment architecture only at G9 or by explicit Owner decision.

Required at G9:
- scan/report entitlement mapping;
- idempotency;
- webhook verification;
- refund/rights revocation;
- Secret safety;
- small controlled canary.

The product is not a generic card-key delivery flow. Payment must unlock the correct `scan_id/report entitlement`.

## G10 — Production Acceptance

Only call the product online when HTTPS, WordPress, Scanner, free loop, approved payment scope, persistence, security, backup/restore and rollback all pass.

## G11 — Acquisition / Business Validation

Measure:

```text
Solution Proof
→ Activation
→ Intent
→ Transaction
→ Retention / Referral as applicable
```

Use behavior data to validate/reject product and Skill hypotheses. Do not scale acquisition before the product/trust loop has meaningful evidence.
