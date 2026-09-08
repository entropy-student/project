<div align="center">

# 🗂️ Project Library

### A long-term repository for building, documenting, and resuming real projects

**Not a pile of unrelated files: every project lives in its own directory with its own documentation, status, deployment assets, and handoff record.**

[中文](./README.md)

![Projects](https://img.shields.io/badge/projects-2-blue?style=flat-square)
![Language](https://img.shields.io/badge/language-Chinese%20%2B%20English-success?style=flat-square)
![Status](https://img.shields.io/badge/status-active-orange?style=flat-square)

</div>

---

## Current Projects

| Project | What it solves | Type | Status | Entry |
|---|---|---|---:|---|
| 🎧 **Music Taste Analyzer** | Reads private playlists after explicit authorization and produces an explainable music taste profile | App / Tool | Active | [Open](./music-taste-analyzer/) |
| 💳 **Unified Pay System** | A once-deployed shared payment, verification, refund, reconciliation, and entitlement layer for multiple products | Shared Infrastructure | **Deploying** | [Open](./unified-pay-system/) |

---

## What this repository is for

Long-running projects often fail operationally because context gets scattered across chats, folders, and platforms. This repository turns each project into an independent unit that is easy to inspect, resume, and hand off:

```text
Real project
    ↓
Independent project directory
    ↓
README / status / architecture
    ↓
PROJECT_RECORD long-term handoff
    ↓
Code / config / deployment assets
    ↓
Continuous iteration
```

---

## Recommended project structure

```text
project-name/
├── README.md           # Primary overview, usage, current status
├── README_EN.md        # English overview when useful
├── CHANGELOG.md        # Version changes
├── PROJECT_RECORD.md   # Long-term decisions, progress, next step, handoff
├── docs/               # Architecture and deeper references
├── src/ / cmd/ ...     # Source code
├── config/             # Non-secret configuration
├── deploy/ / railway/  # Project-specific deployment assets
└── assets/             # Images and presentation resources
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
README.md
   ↓
PROJECT_RECORD.md
   ↓
docs/
   ↓
code / deployment configuration
```

`PROJECT_RECORD.md` should always make four things clear:

1. the final goal;
2. what has already been completed;
3. the current blocker or stage;
4. the next action.

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
Important decisions, status, and next steps belong in `PROJECT_RECORD.md`.

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
