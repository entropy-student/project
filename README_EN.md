<div align="center">

# Project Library

**One repository, multiple isolated project directories. The repository root is an index, not a runtime directory for any single project.**

[中文](./README.md)

</div>

---

## Projects

| Project | Type | Status | Description |
|---|---|---|---|
| [Music Taste Analyzer](./music-taste-analyzer/) | App / Tool | Active | Generates a music taste profile after explicit user authorization. |
| [Unified Pay System](./unified-pay-system/) | Shared Infrastructure | Active / Deploying | A once-deployed payment and entitlement orchestration service reusable by multiple products. |

## Repository layout

```text
project/
├── README.md
├── README_EN.md
├── .gitignore
├── .github/                  # Repository-wide CI / automation
├── music-taste-analyzer/     # Independent project
└── unified-pay-system/       # Independent shared payment infrastructure
```

## Repository rules

1. **One child directory equals one project.**
2. The root only contains the project index and repository-wide files such as `.gitignore` and `.github/`.
3. Project Dockerfiles, runtime configs, deployment assets and project documentation stay inside their own project directory.
4. New projects should preferably include `README.md`, `README_EN.md`, `CHANGELOG.md`, `PROJECT_RECORD.md`, and `docs/`.
5. Secrets, `.env` files, database passwords and payment credentials must never be committed.

## Current focus

### Unified Pay System

The goal is not to rebuild payment integration for every product. It is a shared internal payment hub:

```text
Products / Extensions / Websites / Apps
                 ↓
          Unified Pay Hub
                 ↓
     Alipay / PayPal / GMPay / ...
                 ↓
Payment confirmation → entitlement / license / fulfillment
```

Adding a new product should normally mean registering an **App + SKU + fulfillment route**, not deploying another payment stack.

---

For project-specific details, use the README and PROJECT_RECORD inside that project directory.
