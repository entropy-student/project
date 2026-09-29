# Reviewer Decision — M2A-R4 RETURN Accepted / R5 Parser-independent Conditional Execution

Date: 2026-09-30
Role: Reviewer / Architect / Gatekeeper

## Independent review

Reviewed:

- Evidence commit `ca34c98560b292aff0f391eaf76a0fe304c75872`
- Executor Handoff commit `3de90798ba79c5fc00dd2fcd9a3ed29c71838bfd`

The R4 RETURN is accepted as fail-closed.

## Important classification correction

R4 did **not** observe a new contradictory WordPress private-network endpoint.

Both R4 read rounds reported:

```text
WORDPRESS_CONTAINER_ID_UNCHANGED=YES
WORDPRESS_PRIVATE_ENDPOINT=NO
PRIVATE_NETWORK_WORDPRESS_ENDPOINT=NO
TARGET_ALIAS_COLLISIONS=0
MARIADB_HEALTH=healthy
```

The failure was in evidence extraction:

- network-name formatting produced a leading empty delimiter;
- alias extraction hit a Go-template parse error;
- environment-file enumeration hit a shell syntax error;
- canonical Compose validation therefore did not run.

Formal ruling:

```text
R4_RETURN_ACCEPTED=YES
R4_RUNTIME_CHANGE_PROVEN=NO
R4_RUNTIME_INSTABILITY_PROVEN=NO
R4_EVIDENCE_EXTRACTION_INCOMPLETE=YES
R4_FAILURE_CLASS=PARSER_AND_SHELL_EVIDENCE_EXTRACTION_FAILURE
```

The earlier R3 provenance conflict remains historically unresolved, but the latest repeated R4 runtime observations are mutually consistent.

## Current Gate

```text
CURRENT_GATE=M2A_R5_PARSER_INDEPENDENT_STABLE_BASELINE_AND_CONDITIONAL_EXECUTION
CURRENT_GATE_STATUS=CONDITIONAL_BOUNDED_WRITE
```

## R5 strategy

Do not use fragile Go-template loops or ad-hoc environment-file enumeration.

Use parser-independent JSON readback:

1. obtain raw JSON from `docker inspect` and `docker network inspect`;
2. parse only allowlisted fields with `python3` or another already-installed local JSON parser;
3. never print container environment values, command arrays, labels beyond the exact Compose project/config metadata, Secret values, or tokens.

For Compose validation:

- change directory to `/srv/apps/mini-craft-night-kit`;
- use the canonical project/file invocation from that working directory;
- allow Docker Compose to resolve the already-installed project environment by its normal mechanism;
- do not enumerate or print environment values;
- if validation fails only because required variables are missing, stop with `RETURN_COMPOSE_ENV_RESOLUTION_UNAVAILABLE`.

## Write authorization

Only after parser-independent stable prewrite + unmodified Compose validation PASS, R5 may execute the same bounded M2A mutation:

- reuse existing verified pre-change backup;
- add existing external `spikersun-private` to WordPress only;
- add unique alias `mini-craft-night-kit-wordpress`;
- keep MariaDB isolated;
- validate edited Compose;
- recreate WordPress only;
- prove private endpoint/origin and public Caddy regression.

No M2B action is authorized.
