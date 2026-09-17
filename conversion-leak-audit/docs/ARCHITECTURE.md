# Conversion Leak Audit — ARCHITECTURE

## 1. Product Shape

A diagnostic digital product, not a generic website score.

```text
Public store URL
→ safe facts
→ calibrated rules
→ evidence-backed Top 3
→ complete Fix Queue
→ optional LLM explanation
```

## 2. Frontend / CMS

WordPress-first.

Responsibilities:
- Landing / SEO / Blog;
- How it works / Demo / Pricing / FAQ;
- public URL input;
- scan progress;
- free Top 3 result UI;
- later full-report / paid-unlock UI.

Baseline:
- WordPress 7.1
- SaasLauncher 2.0.18
- project child theme
- Gutenberg / Full Site Editing

The G1 baseline is functional scaffolding, not final UI. Final visual/product behavior must pass G3.5 before Codex implements G4.

## 3. UI / Growth Design Layer

Canonical design decisions live in `G3_5_UI_GROWTH_FREEZE.md` and future `design/` assets.

High-fidelity must be expressed as implementable contracts, not only screenshots:
- Design System;
- page contracts;
- interaction states;
- desktop + mobile golden screenshots;
- analytics event contract;
- functional acceptance;
- visual regression acceptance.

`clone-ui` may extract visual language from references, but must not directly take ownership of the product source tree or rewrite unrelated functionality.

## 4. Integration Layer

Project-owned WordPress plugin/integration layer.

Responsibilities:
- URL form;
- nonce/CSRF;
- call Scanner API;
- scan_id / status mapping;
- polling;
- render evidence-backed results;
- emit analytics events;
- future entitlement hook.

Forbidden:
- running Scrapy / Chromium inside PHP request;
- bypassing Scanner security gates;
- embedding production Secrets in WordPress source.

## 5. Scanner V0

Python service.

```text
Request URL
↓
Syntax / scheme / port gate
↓
DNS / SSRF validation
↓
connection-time pinning
↓
Scrapy static-first crawl
↓
limited browser fallback if technically incomplete
↓
Normalized Facts
↓
Store / transaction applicability
↓
17-rule frozen Rule Engine
↓
Evidence-backed Issue / PASS / NOT_APPLICABLE / CONTEXT_INSUFFICIENT
↓
Job / Report API
```

V0 persistence: SQLite for local product-development phase.

## 6. Rule / Theory Boundary

Canonical theory/rule source: `entropy-student/spike.skill/independent-store-operations/`.

V0 automatic set: 17 trusted rules.

Do not automatically add experiment variables such as ideal price, discount size, shipping threshold, CTA copy, popup timing or generic trust score.

## 7. LLM Boundary

Forbidden:

```text
raw page HTML → LLM → free-form CRO conclusions
```

Allowed:

```text
structured facts
+ calibrated issue
+ evidence reference
→ LLM explanation / prioritization / wording assistance
```

Free Top 3 should remain deterministic and low/zero-token where practical.

API credentials must live only in environment/Secret Store, never chat/GitHub/source.

## 8. Analytics / Operations Boundary

Instrumentation is required before acquisition scaling.

Preferred approach:
- project-owned event emission;
- PostHog or equivalent as analytics backend candidate;
- avoid adding a large plugin stack when a small integration is sufficient.

Event contract candidate:

```text
landing_view
scan_started
scan_completed
top3_viewed
issue_expanded
pricing_viewed
checkout_started
payment_completed
full_report_viewed
```

Operational integrations are added only when a real requirement appears. SEO/Search, email and backup are separate operational concerns, not reasons to overload WordPress early.

## 9. Skill Dogfood Boundary

This product is also a real-world validation environment for `independent-store-operations`.

Skill-derived product/operations hypotheses must be logged before observing results. After real behavior data exists, mark each hypothesis `SUPPORTED / REJECTED / INCONCLUSIVE`. Do not treat implementation choice as validation.

## 10. Network / Data Boundary

Scanner needs network to inspect real public sites. WordPress local development and fixtures can run without public internet once dependencies are local.

Security:
- public URL only;
- no localhost/private/link-local/metadata targets;
- same-origin bounded crawl;
- redirect revalidation;
- connection-time IP pinning;
- fail closed;
- browser never used to bypass explicit blocking/rate limits.

Local V0 stores job/report metadata and structured findings. Raw scraped HTML is not normal durable product data.

## 11. Payment Boundary

Payment is intentionally deferred to G9.

Current default candidate: **Direct PayPal**.

Unified Pay is explicitly not a current dependency because its production path still needs separate fixes/validation.

Payment must map the correct `scan_id/report` to an entitlement; do not model this product as generic card-key/file delivery.

Before G9 there must be no production payment Secret and no payment-driven blocker for UI, Scanner integration, report logic or VPS staging.

## 12. Production Target

Shared VPS, project-isolated Compose.

Planned paths:

```text
/srv/apps/conversion-leak-audit
/srv/data/conversion-leak-audit
/srv/backups/conversion-leak-audit
```

Shared reverse proxy / tunnel / firewall / Docker daemon remain shared-infrastructure concerns and cannot be modified by the project without the Shared Infra Gate.
