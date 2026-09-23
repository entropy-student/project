# Reviewer Decision — G6 Preflight Accepted / Owner Write Approval Request

Date: 2026-09-23

## Decision

`PASS_G6_READ_ONLY_PREFLIGHT`

The read-only VPS preflight is accepted.

G6 itself is **not** PASS yet because no project paths, backup/restore canaries, or remote-write evidence exist.

## Accepted preflight facts

- Target host identity verified: `srv1970241`.
- Ubuntu 24.04.5 LTS, 2 vCPU, 7.75 GiB RAM, 5.47 GiB available at probe.
- Root and `/srv` share the same filesystem; 87.14 GiB available at probe.
- Eight existing shared containers were running; none were modified.
- Shared Caddy owns host 80/443.
- cloudflared/shared Docker networks were observed read-only.
- CLA project roots are absent.
- Candidate private WordPress port `127.0.0.1:18085` was free at probe.
- Scanner is planned container-internal only; MariaDB has no host port.
- Scanner 55/55 and WordPress asset 20/20 regressions passed.
- VPS writes executed: 0.

## Reviewer assessment of proposed writes

### Stage A — low-risk project landing zone

Reviewer recommends Owner approval for:

- WRITE_01: create `/srv/apps/conversion-leak-audit`.
- WRITE_02: create CLA project data root/subdirectories.
- WRITE_03: create CLA project backup root/subdirectories.
- WRITE_04: copy the reviewed Compose design to the CLA application root.

Constraints:
- no service start;
- no public port;
- no shared network;
- no 80/443;
- no reverse-proxy/tunnel/firewall/DNS modification;
- no production Secret;
- per-service ownership must not be guessed before image runtime UID/GID verification.

### Stage B — disposable backup/restore canaries

Reviewer recommends Owner approval for WRITE_05–WRITE_09 only under these additional conditions:

1. Before any MariaDB canary write, perform a read-only `docker image inspect mariadb:11.4`.
2. If the image is already present, proceed with the isolated canary as documented.
3. If the image is absent, **do not pull it**. Return:
   `RETURN_G6_MARIADB_IMAGE_PULL_APPROVAL_REQUIRED`
   and report the expected image/tag before any pull.
4. No canary may publish a host port or join a shared Docker network.
5. Only synthetic data is allowed.
6. One-use canary credential must never be printed/logged and must be removed afterward.
7. Cleanup is restricted to the exact disposable CLA canary resources.
8. Existing shared containers must remain running.

## Hidden-write correction

A Docker image pull writes to host Docker storage. It was not separately listed in the original WRITE_01–WRITE_09 sequence.

Therefore Owner approval of WRITE_01–WRITE_09 does **not** imply approval of an unplanned image pull.

Any missing-image pull requires a separate explicit Owner approval.

## Resource-budget status

The proposed 1 GiB steady / 2 GiB hard aggregate memory limits are acceptable only as **G7 admission caps**, not measured production requirements.

They remain provisional until G7 records real steady/high-water usage.

## Current approval request

Owner is being asked to approve:

```text
Stage A: WRITE_01–WRITE_04
Stage B: WRITE_05–WRITE_09
          with NO unapproved Docker image pull
```

If Owner approves, Executor may resume the existing G6 branch after synchronizing latest Reviewer governance.

If Owner rejects or narrows the scope, execute only the approved subset.

## Next

After the approved writes/canaries:
- collect remote-write evidence;
- verify shared infrastructure unchanged;
- verify canary restore results;
- return `PASS_CANDIDATE_G6_VPS_ONBOARDING_STORAGE`;
- STOP_AT_REVIEWER.

No G7 deployment is authorized by this approval.
