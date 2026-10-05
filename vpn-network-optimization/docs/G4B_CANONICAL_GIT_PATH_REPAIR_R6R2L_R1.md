# G4-B Canonical Git Path Repair R6R2L-R1

Status: ACTIVE / OWNER_LOCAL_OFFLINE_VALIDATION

## GATE_ID

`G4B_CANONICAL_GIT_PATH_REPAIR_R6R2L_R1`

## PREVIOUS_RESULT

`RETURN_R6R2L_P0_CANONICAL_GIT_QUERY_FAILED`

## FAILURE FACTS

```text
RUNNER_FAILED_PHASE=P0_CANONICAL_SOURCE
FAILURE_CODE=CANONICAL_GIT_QUERY_FAILED
CONSEQUENTIAL_MUTATION_STARTED=NO
```

No live mutation, provider upload, VPS change, Clash change or rollback occurred.

## ROOT CAUSE

The runner executed Git with `-C <vpn-network-optimization subdirectory>` while passing repository-root-relative pathspecs such as `vpn-network-optimization/scripts/...` to `git ls-files` and `git status`.

Git pathspecs are resolved relative to the `-C` working directory, so the project prefix was effectively applied twice and the canonical-source query failed before P1.

## REPAIR

All pathspec-sensitive canonical Git queries now execute from the discovered repository root:

```text
git -C $repoRoot ls-files ...
git -C $repoRoot status ...
```

The repository-relative runner/handoff paths and blob identity checks remain unchanged.

Locked repaired sources:

```text
LIVE_RUNNER_BLOB=ad990886a6e0853c5b30828c5afbcc37d2290c71
LIVE_RUNNER_VALIDATOR_BLOB=baf2fb35e9a3ea8644f9fdbf151a2a560bbef98d
```

## OBJECTIVE

Run the full live-runner fixture validator locally. It now includes real read-only Git root/path queries against the current checkout in addition to the existing static and negative fixtures.

## REQUIRED PASS

At minimum:

```text
G4B_FIXTURE_R6R2L_R1_GIT_ROOT_DISCOVERY=PASS
G4B_FIXTURE_R6R2L_R1_GIT_PROJECT_PREFIX=PASS
G4B_FIXTURE_R6R2L_R1_GIT_RUNNER_ROOT_PATH_QUERY=PASS
G4B_FIXTURE_R6R2L_R1_GIT_HANDOFF_ROOT_PATH_QUERY=PASS
G4B_FIXTURE_R6R2L_R1_GIT_STATUS_ROOT_PATH_QUERY=PASS
G4B_FIXTURE_R6R2L_R1_CANONICAL_GIT_ROOT_PATH_SCOPE=PASS
G4B_LIVE_RUNNER_FIXTURES=PASS
NEGATIVE_FIXTURES=PASS
NETWORK_MUTATION=NO
DPAPI_OR_REAL_SECRET_ACCESS=NO
EXTERNAL_REQUESTS=0
```

## FORBIDDEN

- live runner invocation;
- real Baidu `who` or file operations;
- authentication/re-authentication;
- Secret/DPAPI access;
- VPS/SSH/Clash/service/route/proxy/TUN mutation;
- G4-C.

## STOP

`STOP_AT_REVIEWER=YES`
