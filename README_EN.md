<div align="center">

# 🗂️ Project Library

### A single entry point for long-running projects, current-state navigation, and handoff

**Projects stay self-contained; the repository root is a map, not a second source of project truth.**

[中文](./README.md)

![Projects](https://img.shields.io/badge/projects-14-blue?style=flat-square)
![Language](https://img.shields.io/badge/language-Chinese%20%2B%20English-success?style=flat-square)
![Status](https://img.shields.io/badge/status-active-orange?style=flat-square)

</div>

---

## Project catalog

> This catalog is navigation only. Project stage, current Gate, risks, and next action live in each project REVIEWER_HANDOFF.md. Projects without a Handoff use their own README/status files.

### Infrastructure and runtimes

| Project | Purpose | Current-state entry |
|---|---|---|
| **Shared VPS Infrastructure** | Shared Hostinger VPS, networks, Caddy/ingress, and cross-project infrastructure | [Handoff](./shared-vps-infrastructure/REVIEWER_HANDOFF.md) |
| **Unified Pay System** | Shared payment, refund, reconciliation, entitlement and fulfillment capabilities | [Handoff](./unified-pay-system/REVIEWER_HANDOFF.md) |
| **VPN Network Optimization** | Self-hosted VPN stability, tail latency, comparative validation, deployment and rollback | [Handoff](./vpn-network-optimization/REVIEWER_HANDOFF.md) |
| **Dujiao-Next** | Commerce runtime for products, orders, payments, and fulfillment | [Handoff](./dujiao-next/REVIEWER_HANDOFF.md) |
| **Xianyu** | Xianyu virtual-product demand catalog research (legacy runtime preserved) | [Handoff](./xianyu/REVIEWER_HANDOFF.md) |

### Product and commerce projects

| Project | Purpose | Current-state entry |
|---|---|---|
| **Conversion Leak Audit** | Storefront conversion-leak scanning, Top-3 findings, and fix queue | [Handoff](./conversion-leak-audit/docs/REVIEWER_HANDOFF.md) |
| **Mini Craft Night Kit** | WordPress/WooCommerce single-product ecommerce and physical-product validation | [Handoff](./mini-craft-night-kit/REVIEWER_HANDOFF.md) |
| **Birthday Magazine Studio** | Generate personalized birthday magazines from photos and memories | [Handoff](./birthday-magazine-studio/REVIEWER_HANDOFF.md) |
| **Family Cookbook Studio** | OCR, review, layout, and publishing of photographed/handwritten family recipes | [Handoff](./family-cookbook-studio/REVIEWER_HANDOFF.md) |
| **Music Taste Analyzer** | Permissioned playlist reading and explainable music-taste profiles | [README](./music-taste-analyzer/) |

### Story, visual, and media production

| Project | Purpose | Current-state entry |
|---|---|---|
| **AI Story Showrunner** | Topic, script, timing, directing, assets, and E2E validation for story-first knowledge video | [Handoff](./ai-story-showrunner/REVIEWER_HANDOFF.md) |
| **Story Image Runner** | Governed local browser image-generation queue, deterministic assets, and later QA | [Handoff](./story-image-runner/REVIEWER_HANDOFF.md) |
| **Story Visual Asset Engine** | Asset reuse/generation decisions, character/style consistency, and visual asset library | [Handoff](./story-visual-asset-engine/REVIEWER_HANDOFF.md) |
| **Visual Narrative Animation Lab** | Visual Beats, limited animation, and reusable narrative-motion production experiments | [Handoff](./visual-narrative-animation-lab/REVIEWER_HANDOFF.md) |

## How to resume a project

~~~text
repository README
→ project REVIEWER_HANDOFF
→ current Gate / latest accepted Evidence
→ project README / docs / code / deployment config
~~~

The root does **not** maintain a second dynamic project-status snapshot. If the catalog and a project Handoff disagree, the current Handoff plus fresh Evidence wins.

## Recommended project shape

~~~text
project-name/
├── README.md               # overview and navigation
├── REVIEWER_HANDOFF.md     # Reviewer-accepted current project truth
├── EXECUTION_EVIDENCE.md   # execution facts and redacted evidence
├── docs/                   # Gates / architecture / research / deep documentation
├── src/ / cmd/ ...         # source code
├── config/                 # non-secret configuration
├── deploy/                 # project-specific deployment assets
└── assets/                 # images and presentation assets when needed
~~~

Not every project needs every path. Legacy PROJECT_RECORD.md or EXECUTOR_HANDOFF.md files may remain for history/compatibility, but they should not compete with REVIEWER_HANDOFF.md as current truth.

## Repository boundaries

- **One top-level project directory = one project.**
- Root README files, .github, and repository-wide configuration are not projects.
- Root docs/ is reserved for existing repository-level or historical material; new project docs, screenshots, and runtime artifacts belong inside the relevant project directory.
- Project Dockerfiles, scripts, configs, Evidence, assets, and deployment files must not spill into the root.
- Never commit Secrets, .env files, private keys, payment/API secrets, cookies, browser credentials, or private customer data.
- Shared capabilities belong in explicit shared-infrastructure projects, not ad-hoc root files.

## Governance

Project work follows [VPS Project Governance](https://github.com/entropy-student/spike.skill/tree/main/vps-project-governance).

~~~text
Current State
→ Gate
→ Preflight
→ Execute
→ Evidence
→ Review
→ New State
~~~

Legacy projects are not bulk-rewritten for cosmetic consistency; they are reconciled to current Governance when they are next formally taken over.

---

<div align="center">

### Build once. Record clearly. Continue easily.

**Turn one-off development work into reusable project assets.**

</div>
