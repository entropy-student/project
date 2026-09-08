<div align="center">

# Project Library

**A home for independent runnable projects, each archived in its own subdirectory instead of taking over the repository root.**

[中文](./README.md) · [Music Taste Analyzer](./music-taste-analyzer/) · [Unified Pay System](./unified-pay-system/)

</div>

---

## Projects

| Project | Status | Description | Location |
|---|---|---|---|
| **Music Taste Analyzer** | Active | Reads private playlists after explicit user authorization and builds a music-taste profile. User data is not written into the project directory by default. | [`music-taste-analyzer/`](./music-taste-analyzer/) |
| **Unified Pay System** | Archived / Existing | Reusable payment orchestration and entitlement infrastructure. It was only moved out of the repository root; no functional optimization was applied during this reorganization. | [`unified-pay-system/`](./unified-pay-system/) |

## Repository convention

```text
project/
├── README.md
├── README_EN.md
├── music-taste-analyzer/   # actively maintained here
└── unified-pay-system/     # existing project, archived as-is
```

- One subdirectory represents one independent project.
- The repository root is reserved for the **project index and navigation**.
- Project code, documentation, build scripts and dependency notices stay inside that project's own directory.
- Future projects should not place their own README, Dockerfile or deployment artifacts directly in the library root.

## Current focus

### Music Taste Analyzer

The project aims to turn:

> **authorization → private playlists → data cleaning → behavioral/semantic analysis → music-taste profile**

into a lightweight, privacy-friendly local application with an integrated Web UI and Go backend.

The current Web flow supports NetEase Cloud Music, QQ Music and Kugou Music. Soda Music playlist access exists upstream, while QR login remains unstable and is therefore not exposed as a normal Web login option yet. See [`music-taste-analyzer/README_EN.md`](./music-taste-analyzer/README_EN.md) for details.

---

> This repository is a collection of independent projects. Once inside a project directory, follow that project's own README, licensing notes and third-party notices.
