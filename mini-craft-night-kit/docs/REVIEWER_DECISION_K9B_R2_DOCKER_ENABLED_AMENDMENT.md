# Reviewer Decision — K9B-R2 Docker Enabled Amendment

Date: 2026-09-28
Role: Reviewer / Architect / Gatekeeper

## Owner update

Owner confirms Docker Desktop / local Docker daemon is now available and explicitly requests local Docker cleanup to be completed together with the existing K9B-R2 filesystem decommission.

This amendment extends the current Gate only. It does not alter VPS production or payment scope.

## Current Gate

```text
CURRENT_GATE=K9B_R2_LOCAL_FILESYSTEM_AND_DOCKER_DECOMMISSION_WITH_PROTECTED_RECOVERY_EXCEPTIONS
CURRENT_GATE_STATUS=AUTHORIZED_CONDITIONAL_LOCAL_CLEANUP
```

The existing protected-recovery and filesystem rules remain in force.

## Docker cleanup objective

Identify and remove exact Mini Craft local Docker resources that are no longer required after VPS cutover.

Allowed resource classes, only after fresh ownership and dependency proof:

- Mini Craft-only containers;
- Mini Craft-only Compose networks;
- Mini Craft-only named volumes containing no unique retained state;
- Mini Craft-only custom images built specifically for this project.

Shared upstream images such as generic WordPress/MariaDB images are not deletion targets merely because Mini Craft used them.

## Docker preflight

Freshly record:

```text
DOCKER_DAEMON_AVAILABLE=YES
DOCKER_SERVER_VERSION=
DOCKER_CONTEXT=
DOCKER_DESKTOP_ENGINE=
```

Inventory all local:

- containers;
- compose project labels;
- working-directory labels;
- networks;
- volumes;
- images;
- bind mounts;
- named-volume mounts.

Correlate against known historical Mini Craft local runtimes:

```text
mini-craft-k3r4-mariadb-recovery
mini-craft-k3r4-docker-mariadb
mini-craft-kadence-poc
mini-craft-night-kit
```

Do not infer ownership from name alone. Use labels, mounts, working directories, Compose project, container config and resource references.

## Docker deletion safety barrier

Before deleting any Docker resource, prove:

```text
PRODUCTION_VPS_PUBLIC_HEALTH=PASS
PRODUCTION_VPS_BACKUP_NAMESPACE_PRESENT=YES
RESOURCE_PROJECT_OWNERSHIP=MINICRAFT
RESOURCE_SHARED_REFERENCE_COUNT=0
RESOURCE_REQUIRED_BY_RUNNING_NON_MINICRAFT_CONTAINER=NO
RESOURCE_CONTAINS_UNIQUE_CURRENT_BUSINESS_STATE=NO
RESOURCE_REQUIRED_FOR_PROTECTED_RECOVERY=NO
```

For a volume that contains a database/uploads/runtime state:

- do not read business contents merely for cleanup;
- use metadata, historical accepted project evidence, container mounts and current project continuity state;
- if it may be the only retained copy of state not covered by current VPS + validated backup/recovery material, RETURN and keep it.

## Deletion order

When exact Mini Craft-only resources are proven obsolete:

1. stop only exact Mini Craft local containers;
2. remove those exact containers;
3. remove exact Mini Craft-only networks after reference count reaches zero;
4. remove exact Mini Craft-only named volumes only after no-unique-state proof;
5. remove exact Mini Craft-only custom images only when no remaining container references them.

No broad prune.

## Strictly forbidden

Do not run:

```text
docker system prune
docker system prune -a
docker container prune
docker image prune
docker image prune -a
docker volume prune
docker network prune
docker builder prune
```

Do not delete Docker Desktop / WSL internal storage manually.

Do not remove shared upstream images solely for disk cleanup.

Do not touch non-Mini-Craft containers/networks/volumes.

## Required evidence

Add to K9B-R2 Evidence:

```text
DOCKER_DAEMON_AVAILABLE=YES
DOCKER_SERVER_VERSION=
MINICRAFT_DOCKER_CONTAINER_COUNT_BEFORE=
MINICRAFT_DOCKER_NETWORK_COUNT_BEFORE=
MINICRAFT_DOCKER_VOLUME_COUNT_BEFORE=
MINICRAFT_DOCKER_CUSTOM_IMAGE_COUNT_BEFORE=

MINICRAFT_DOCKER_CONTAINERS_REMOVED=
MINICRAFT_DOCKER_NETWORKS_REMOVED=
MINICRAFT_DOCKER_VOLUMES_REMOVED=
MINICRAFT_DOCKER_CUSTOM_IMAGES_REMOVED=

SHARED_DOCKER_IMAGES_REMOVED=0
NON_MINICRAFT_DOCKER_RESOURCES_TOUCHED=0
BROAD_PRUNE_USED=NO

MINICRAFT_DOCKER_CONTAINER_COUNT_AFTER=
MINICRAFT_DOCKER_NETWORK_COUNT_AFTER=
MINICRAFT_DOCKER_VOLUME_COUNT_AFTER=
MINICRAFT_DOCKER_CUSTOM_IMAGE_COUNT_AFTER=
```

Any retained Docker resource must be listed with exact reason.

## Final target

```text
LOCAL_DEDICATED_MINICRAFT_WORKSPACES=ZERO_OR_EXACT_EXCEPTION
LOCAL_UNTRACKED_MINICRAFT_GIT_ARTIFACTS=ZERO
LOCAL_MINICRAFT_DOCKER_CONTAINERS=0
LOCAL_MINICRAFT_DOCKER_NETWORKS=0
LOCAL_MINICRAFT_DOCKER_VOLUMES=0_OR_EXACT_RECOVERY_EXCEPTION
LOCAL_MINICRAFT_DOCKER_CUSTOM_IMAGES=0_OR_EXACT_SHARED_REFERENCE
LOCAL_PROTECTED_ROLLBACK_METADATA=RETAINED_PROTECTED_EXCEPTION
LOCAL_DPAPI_RECOVERY=RETAINED_PROTECTED_EXCEPTION
SHARED_GIT_WORKTREE=PROTECTED_SHARED_EXCEPTION
```

## Production boundary

No VPS mutation, product mutation, currency mutation, PayPal mutation, order creation, payment or refund is authorized.

## Success

```text
PASS_CANDIDATE_K9B_R2_LOCAL_FILESYSTEM_AND_DOCKER_DECOMMISSION_WITH_PROTECTED_RECOVERY_EXCEPTIONS
STOP_AT_REVIEWER=YES
```

Do not enter K9C automatically.
