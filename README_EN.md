<div align="center">

# 🗂️ Project Library

### A long-term repository for building, documenting, and resuming real projects

**Not a pile of unrelated files: every project lives in its own directory with its own documentation, status, deployment assets, and handoff record.**

[中文](./README.md)

![Projects](https://img.shields.io/badge/projects-8-blue?style=flat-square)
![Language](https://img.shields.io/badge/language-Chinese%20%2B%20English-success?style=flat-square)
![Status](https://img.shields.io/badge/status-active-orange?style=flat-square)

</div>

---

## Current Projects

| Project | What it solves | Type | Status | Entry |
|---|---|---|---:|---|
| 🎧 **Music Taste Analyzer** | Reads private playlists after explicit authorization and produces an explainable music taste profile | App / Tool | Active | [Open](./music-taste-analyzer/) |
| 💳 **Unified Pay System** | A once-deployed shared payment, verification, refund, reconciliation, and entitlement layer for multiple products | Shared Infrastructure | **Deploying** | [Open](./unified-pay-system/) |
| 🎬 **Visual Narrative Animation Lab** | Turns narration into Visual Beats and develops a reusable hand-drawn narrative-video production and automation workflow | Content Production / AI Workflow | **Prototype** | [Open](./visual-narrative-animation-lab/) |
| 🔎 **Conversion Leak Audit** | Scans public storefronts and produces evidence-backed conversion-leak findings and a prioritized fix queue | Diagnostic Product / Commerce Tool | **Local Integration Next** | [Open](./conversion-leak-audit/) |
| 🎨 **Mini Craft Night Kit** | Uses WordPress + Kadence + WooCommerce to build a sellable single-product commerce site quickly | Ecommerce / Physical Product | **Kadence PoC** | [Open](./mini-craft-night-kit/) |
| 🎁 **Birthday Magazine Studio** | Turns a gift-giver’s photos and memories into a personalized birthday magazine that can be previewed and delivered | Personalized Gift / Publishing | **G2A1 Component PoC** | [Open](./birthday-magazine-studio/) |
| 🍲 **Family Cookbook Studio** | Faithfully turns handwritten family recipes, old recipe cards, and memories into a reviewable, deliverable family cookbook | Personalized Publishing / Family Archive | **G2A1 OCR PoC** | [Open](./family-cookbook-studio/) |
| 🎭 **AI Story Showrunner** | Translates AI changes into human stories and orchestrates topic, story, script, directing, image, render, and feedback workers | Content Operating System / Orchestration | **G1 Contracts** | [Open](./ai-story-showrunner/) |

---

## What this repository is for

Long-running projects often fail operationally because context gets scattered across chats, folders, and platforms. This repository turns each project into an independent unit that is easy to inspect, resume, and hand off:

```text
Real project
    ↓
Independent project directory
    ↓
REVIEWER_HANDOFF current project truth
    ↓
docs / current Gate / Evidence
    ↓
Code / config / deployment assets
    ↓
Continuous iteration
```

---

## Recommended project structure

```text
project-name/
├── 00_START_HERE.md        # Optional navigation; not a second truth source
├── README.md               # Project overview and navigation
├── REVIEWER_HANDOFF.md     # Canonical current Reviewer/project truth
├── PROJECT_RECORD.md       # Historical/compatibility pointer where needed
├── EXECUTOR_HANDOFF.md     # Execution facts once execution Gates begin
├── EXECUTION_EVIDENCE.md   # Redacted detailed evidence
├── docs/                   # Architecture, current Gates, research, references
├── src/ / cmd/ ...         # Source code
├── config/                 # Non-secret configuration
├── deploy/                 # Project-specific deployment assets
└── assets/                 # Images and presentation resources
```

Not every project needs every directory, but project-specific runtime files must stay inside that project's directory.

---

## Naming and organization

- Use lowercase English slugs for folders, such as `music-taste-analyzer`.
- Prefer display names in the form `English（中文）` where useful.
- One top-level child directory equals one project.
- The repository root is reserved for navigation and repository-wide configuration.
- Dockerfiles, deployment scripts, runtime configs, and project docs must not spill into the root.
- Secrets, `.env` files, private keys, database passwords, and payment secrets must never be committed.

---

## How to continue a project

Recommended reading order:

```text
REVIEWER_HANDOFF.md
   ↓
docs/DOCUMENT_INDEX.md (when present)
   ↓
current Gate contract / latest accepted Evidence
   ↓
README / code / deployment configuration
```

`REVIEWER_HANDOFF.md` should always make four things clear:

1. the final goal;
2. which Gates/baselines are accepted;
3. the current Gate, UNKNOWNs, and risks;
4. the next Reviewer, Executor, and Owner actions.

Older `PROJECT_RECORD.md` files may remain as historical records or compatibility pointers, but they should not compete with `REVIEWER_HANDOFF.md` as a second current truth source.

---

## Current focus: Unified Pay System

Unified Pay is being built as shared payment infrastructure rather than product-specific payment code:

```text
Products / Extensions / Websites / Apps
                 ↓
          Unified Pay Hub
                 ↓
     Alipay / PayPal / GMPay / ...
                 ↓
Payments / Refunds / Reconciliation
                 ↓
License / Entitlement / Fulfillment
```

A future product should normally only need:

```text
Register App
+ Register SKU
+ Configure Origins
+ Configure Fulfillment
```

instead of rebuilding payment infrastructure.

---

## Design principles

### 1. One project, one directory
Project files and deployment assets should stay self-contained.

### 2. Record before forgetting
Important decisions, current status, current Gate, and next steps belong in the single `REVIEWER_HANDOFF.md`. Execution facts and detailed evidence belong in `EXECUTOR_HANDOFF.md` and `EXECUTION_EVIDENCE.md`.

### 3. Reuse infrastructure
Shared capabilities such as payments and entitlement should be built once and reused.

### 4. Keep secrets outside GitHub
Repositories may document secret names and locations, never secret values.

### 5. Make continuation cheap
A project should be understandable again within minutes even after months away.

---

<div align="center">

### Build once. Record clearly. Continue easily.

**Turn one-off development work into reusable project assets.**

</div>
