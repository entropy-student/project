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
- later paid unlock UI.

Baseline:
- WordPress 7.1
- SaasLauncher 2.0.18
- project child theme
- Gutenberg / Full Site Editing

## 3. Integration Layer

Project-owned WordPress plugin/integration layer.

Responsibilities:
- URL form;
- nonce/CSRF;
- call Scanner API;
- scan_id / status mapping;
- polling;
- render evidence-backed results;
- future entitlement hook.

Forbidden:
- running Scrapy / Chromium inside PHP request;
- bypassing Scanner security gates;
- embedding production Secrets in WordPress source.

## 4. Scanner V0

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

## 5. Scanner Rules

Canonical theory/rule source:
`entropy-student/spike.skill/independent-store-operations/`

V0 automatic set: 17 trusted rules.

Do not automatically add commercial-experiment variables such as:
- ideal price;
- discount size;
- free-shipping threshold;
- CTA copy;
- popup timing;
- generic trust score.

These require store-specific evidence / experiment.

## 6. LLM Boundary

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

## 7. Network Boundary

Scanner needs network to inspect real public sites.

WordPress local development and fixture tests can run without public internet after dependencies/images are available locally.

Security principles:
- public URL only;
- no localhost/private/link-local/metadata targets;
- same-origin bounded crawl;
- redirect revalidation;
- connection-time IP pinning;
- fail closed;
- browser never used to bypass explicit blocking / rate limits.

## 8. Data Boundary

Local V0 stores job/report metadata and structured findings.

Do not treat raw scraped HTML as normal durable product data.

Production data/storage layout will be frozen at G6 before VPS deployment.

## 9. Production Target

Shared VPS, project-isolated Compose.

Planned project-scoped paths:

```text
/srv/apps/conversion-leak-audit
/srv/data/conversion-leak-audit
/srv/backups/conversion-leak-audit
```

Shared reverse proxy / tunnel / firewall / Docker daemon remain shared-infrastructure concerns and cannot be modified by the project without the Shared Infra Gate.
