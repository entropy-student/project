# G4-B Canonical Git / CRLF Repair R6R2L-R2

Status: ACTIVE / OWNER_LOCAL_OFFLINE_VALIDATION

## GATE_ID

`G4B_CANONICAL_GIT_AND_CRLF_REPAIR_R6R2L_R2`

## PREVIOUS_RESULT

`RETURN_R6R2L_R1_GIT_RUNNER_ROOT_PATH_QUERY_FAILED`

## FAILURE FACTS

```text
OWNER_RUNTIME=PASS
HEAD_AT_OWNER_RUN=e5152337720618ce88657c5ae01e4bdcc66383a2
ORIGIN_MAIN_AT_OWNER_RUN=e5152337720618ce88657c5ae01e4bdcc66383a2
R6R2L_R1_GIT_RUNNER_ROOT_PATH_QUERY=FAIL
CONSEQUENTIAL_MUTATION_STARTED=NO
VPS_OR_SSH_ACTION=NO
BAIDU_PROVIDER_ACTION=NO
SECRET_OR_DPAPI_ACCESS=NO
NETWORK_MUTATION=NO
```

The later manually printed PASS_CANDIDATE lines are not accepted evidence because the Owner pasted the checkpoint interactively and subsequent statements continued after earlier terminating errors.

## ROOT CAUSES

1. The R6R2L-R1 validator and live runner still reused native Git `rev-parse --show-toplevel` text as a Windows `-C` filesystem path. The repository path contains non-ASCII `VPS搭建`, and this project has already observed mojibake on native Git path output.
2. The live runner's canonical Handoff line regexes used `$` without optional carriage-return handling, while the Owner checkout uses CRLF.
3. Five pre-existing untracked `vpn-network-optimization/results/*` benchmark artifacts are accepted historical local results and must not be deleted merely to satisfy source provenance.

## REPAIR

- Derive repository root from the already resolved .NET Unicode project path only after Git proves the project prefix is exactly `vpn-network-optimization`; prove the derived parent is Git root scope with `rev-parse --show-prefix`.
- Never reuse native `--show-toplevel` output as a Windows filesystem locator.
- Keep root-relative `ls-files` and `status` queries at the proven repository root.
- Exclude only untracked entries below `vpn-network-optimization/results/` from source cleanliness; tracked drift or untracked paths elsewhere still fail closed.
- Accept LF or CRLF for the three canonical Handoff markers.
- Add behavioral fixtures for Unicode-safe root, accepted-results-only status, and CRLF Handoff matching.

Locked repaired sources:

```text
LIVE_RUNNER_BLOB=8b099e4229642bf439eb03c0d1e9cce0f8e698bd
LIVE_RUNNER_VALIDATOR_BLOB=770f70119040993a66e9b3b3cb25f5d5075b0ec0
```

## OBJECTIVE

Run only the full live-runner fixture validator on the Owner Windows host after safe fast-forward to current `origin/main`.

## REQUIRED PASS

```text
G4B_FIXTURE_R6R2L_R1_GIT_PROJECT_PREFIX=PASS
G4B_FIXTURE_R6R2L_R2_DOTNET_REPO_PARENT=PASS
G4B_FIXTURE_R6R2L_R1_GIT_ROOT_DISCOVERY=PASS
G4B_FIXTURE_R6R2L_R2_UNICODE_SAFE_GIT_ROOT=PASS
G4B_FIXTURE_R6R2L_R1_GIT_RUNNER_ROOT_PATH_QUERY=PASS
G4B_FIXTURE_R6R2L_R1_GIT_HANDOFF_ROOT_PATH_QUERY=PASS
G4B_FIXTURE_R6R2L_R1_GIT_STATUS_ROOT_PATH_QUERY=PASS
G4B_FIXTURE_R6R2L_R2_PROJECT_STATUS_ACCEPTED_RESULTS_ONLY=PASS
G4B_FIXTURE_R6R2L_R2_CRLF_HANDOFF_CONTRACT=PASS
G4B_FIXTURE_R6R2L_R1_CANONICAL_GIT_ROOT_PATH_SCOPE=PASS
G4B_LIVE_RUNNER_FIXTURES=PASS
NEGATIVE_FIXTURES=PASS
NETWORK_MUTATION=NO
DPAPI_OR_REAL_SECRET_ACCESS=NO
EXTERNAL_REQUESTS=0
```

## FORBIDDEN

- live runner invocation;
- deleting, moving, overwriting or committing the pre-existing `results/` artifacts;
- Baidu provider file actions or re-authentication;
- Secret/DPAPI access;
- VPS/SSH/Clash/service/route/proxy/TUN mutation;
- G4-C.

## ROLLBACK

Source-only repair. If validation fails, revert this R2 source/document repair. No runtime state was changed by this repair.

## STOP

`STOP_AT_REVIEWER=YES`
