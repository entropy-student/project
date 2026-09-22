# Reviewer Decision — G4 Source Baseline Recovery

Date: 2026-09-22

Role: Reviewer / Architect / Gatekeeper

## Decision

`RESOLVED_G4_SOURCE_BASELINE_FROM_CANONICAL_2026_09_17_PACKAGE`

The prior Executor return `RETURN_G4_SOURCE_BASELINE_UNRESOLVED` was correct for the local workspace it inspected: the reviewed source trees were absent and no G4 edit was made.

Reviewer subsequently recovered the canonical final handoff package from the Owner's ChatGPT Library:

`conversion-leak-audit-final-2026-09-17.zip`

Verified SHA256:

`e5c3aa1da7a8fe5a431eade38f2b45fc48862b21470e413f4a034f150f59df03`

The checksum exactly matches the stored companion `.sha256` file from 2026-09-17.

## Canonical recovered source

The package contains:

- `conversion-leak-audit/scanner/`
- `conversion-leak-audit/wordpress-g1-baseline/`

The package's own `SOURCE_LOCATION_AUDIT.md` and `PACKAGE_MANIFEST.md` identify these two trees as the canonical handoff snapshots and explicitly forbid rebuilding from older validation snapshots.

## Independent Reviewer re-run

Reviewer extracted the verified package and reran the frozen local regressions on 2026-09-22.

Scanner:

```text
python3 -m pytest -q
55 / 55 PASS
```

WordPress baseline:

```text
python3 wordpress-g1-baseline/acceptance/run_asset_checks.py
TOTAL=20 PASS=20 FAIL=0
```

Historical network/runtime evidence remains:

- G2 real-network workflow run `35235157740`, commit `4ad4fe0750a2781ce7c965fa2cb8e48641884d13`, success.
- G1 WordPress runtime workflow run `35237395508`, commit `eae557fa643e7082aa18ecb99f72f4e9633606bc`, success.

## Reviewer ruling

The source-baseline blocker is resolved.

Do not reopen G1 or G2. Do not reconstruct Scanner or WordPress from theory/validation snapshots.

Before G4 edits, Executor must restore the two canonical directories from the verified package into the local project workspace, verify the package SHA256, rerun 55/55 and 20/20 locally, record the restored source paths, then continue `G4_EXECUTION_CONTRACT.md`.

If the local restored copy does not match the verified package hash or the regressions fail, STOP_AT_REVIEWER.

## Scope remains unchanged

G4 remains local only. Payment, VPS, production Secret, public production scanner, new Scanner rules, and G5 LLM full-report work remain forbidden.

## Next

```text
Owner downloads verified recovery package once
→ restore canonical scanner/ + wordpress-g1-baseline/ into local workspace
→ Codex verifies SHA256
→ Codex reruns 55/55 + 20/20
→ Codex executes G4 only
→ Codex writes EXECUTION_EVIDENCE
→ PASS_CANDIDATE_G4_LOCAL_FREE_LOOP
→ STOP_AT_REVIEWER
```
