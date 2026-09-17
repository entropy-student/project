# Conversion Leak Audit — REVIEWER HANDOFF

> Role: Reviewer / Architect / Gatekeeper
> Source of truth: `../PROJECT_RECORD.md`

## Current Decision

```text
P0 / P0A / P0B = PASS
PF = PASS
G1 WordPress Local Baseline = PASS
G2 Safe Scanner V0 = PASS
G3 Rule Engine V0 = MERGED / CLOSED
G4 WordPress ↔ Scanner ↔ Top 3 Local Integration = NEXT
```

## Product Boundary

V1 scans public store URLs and reports observable on-site risks only.

Allowed claim:

> 发现可观察到的站内因素，这些因素可能增加购买犹豫、不信任或操作阻力。

Forbidden:
- root-cause claim from L0/L1 evidence;
- exact revenue-loss claim;
- guaranteed conversion uplift;
- free-form LLM diagnosis from raw HTML.

## Accepted Architecture

- Frontend/CMS: WordPress + SaasLauncher + project child theme
- Scanner: Python
- Static extraction: Scrapy first
- Dynamic fallback: bounded browser only when technically needed
- Persistence: SQLite for V0 local phase
- Rule set: frozen 17-rule MTRS
- LLM: explanation layer after deterministic findings

## Evidence Baseline

```text
Rule fixtures             51 / 51 PASS
Scanner project tests     55 / 55 PASS
Real-network facts        26 / 26 PASS
Real rule assertions      28 / 28 PASS
Unexpected ISSUE          0
Geo-context misuse        0
WordPress asset checks    20 / 20 PASS
```

G1 CI:
- workflow: Conversion Leak Audit G1 WordPress Baseline
- run id: 35237395508
- conclusion: success

G2 real-network CI:
- workflow: Independent Store Ops Real Crawl
- run id: 35235157740
- conclusion: success

## G4 Goal

```text
WordPress URL form
→ create local scan job
→ return scan id
→ poll progress/status
→ Scanner V0
→ evidence-backed issues
→ deterministic Top 3
→ WordPress result page
```

## G4 Acceptance

Must prove:
- valid public URL can start a job;
- unsafe URL is rejected before crawl;
- job survives normal local request flow;
- progress/status can be read;
- Top 3 contains evidence references;
- incomplete scans do not become false ISSUE;
- errors are visible to user;
- no payment required;
- no production Secret;
- no VPS write;
- no public production exposure.

## Reviewer Rules

1. Do not reopen theory without a real counterexample.
2. Do not alter frozen rules merely to make integration pass.
3. Keep `PROJECT_RECORD.md` and `CURRENT_STATUS.json` synchronized after Gate changes.
4. Every Executor completion must cite files/tests/commands, not only state “done”.
5. If a task needs payment, Secret, Shared Infra change, irreversible action, or production opening: RETURN to Owner.
