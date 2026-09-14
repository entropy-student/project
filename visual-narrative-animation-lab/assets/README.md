# Assets

This folder documents the project's visual working set and restoration boundary.

## Current policy

The Git repository stores:

- asset lineage and generation records;
- Art Bible / shot / timeline documentation;
- exact SHA-256 fingerprints for the current binary working set;
- a snapshot manifest describing the important character, pose, production, and Animatic files.

High-resolution binary assets are not yet duplicated into normal Git history. They remain in the current project snapshot until a stable Git LFS or release-asset policy is selected.

## Restore / verify

Read:

1. `ASSET_SNAPSHOT_MANIFEST.md`
2. `../ASSET_HASHES.sha256`
3. `../docs/g2/G2B_ASSET_REGISTRY.md`
4. `../docs/g2/G2C_ASSET_REGISTRY.md`

The SHA-256 values are the authoritative identity check for restoring the same working files.

## Copyright boundary

Third-party benchmark videos and extracted reference-frame sheets are deliberately excluded from this repository. Only derived analysis, timing data, and methodology are preserved.
