# Reviewer Decision — G3CR2 Dependency Ambiguity RETURN

Date: 2026-09-30  
Reviewed PR: #60  
Executor result: `RETURN_G3CR2_GUTENBERG_DEPENDENCY_AMBIGUOUS`

## Result

**RETURN ACCEPTED AS VALID G3CR2 EVIDENCE.**

The Executor correctly stopped before starter import because the active G3CR2 contract required a builder-specific dependency boundary and the initial CLI read-back did not provide one.

Accepted facts:

- Blocksy Theme 2.1.57 and Blocksy Companion 2.1.57 were installed from official WordPress.org packages.
- The current importer catalogue exposes Wedding and builders `gutenberg, elementor`.
- The `wp blocksy demo list --format=json` output contains one merged plugin list including Gutenberg-oriented and Elementor-oriented plugins.
- Elementor was not installed.
- Wedding was not imported.
- WooCommerce canary and private-workspace regression were not run after the Phase A RETURN.
- Project-scoped cleanup passed and unrelated Docker fingerprint remained stable.
- Payment, model, production and Shared Infrastructure action counters remained zero.

## Reviewer interpretation

The dependency ambiguity is an artifact of the **merged list command**, not evidence that the Gutenberg variant itself requires Elementor.

Current Blocksy Companion source shows that:

1. `DemoCli::demo_list()` merges catalogue records sharing the same demo name and unions their builder/plugin arrays.
2. `DemoInstall::fetch_single_demo()` accepts an explicit builder.
3. The importer plugin phase calls `fetch_single_demo(['demo' => <name>, 'builder' => <builder>])` before installing dependencies.

Therefore the next bounded step is a read-only builder-specific query for:

`Wedding:gutenberg`

Blocksy Wedding remains the Owner-selected candidate.

## Current state

```text
G3CR2=RETURN_ACCEPTED
BLOCKSY_WEDDING_SELECTION=RETAINED
ROOT_CAUSE_OF_AMBIGUITY=MERGED_CLI_LIST_VIEW
G3CR2R1_VARIANT_DEPENDENCY_CLOSURE=CURRENT
FULL_G3C_IMPLEMENTATION=HOLD
G4=HOLD_NOT_AUTHORIZED
```

## PR #60 handling

PR #60 remains valid RETURN evidence and must not be treated as a PASS candidate.

The next closure contract is:

`G3CR2R1_BLOCKSY_WEDDING_VARIANT_DEPENDENCY_CLOSURE.md`
