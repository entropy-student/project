# Dujiao-Next — PROJECT STORAGE MANIFEST

Status: ACTIVE_RUNTIME / PROJECT_STAGE_CLOSED

```text
PROJECT=dujiao-next
APPS_PATH=/srv/apps/dujiao-next
DATA_PATH=/srv/data/dujiao-next
BACKUPS_PATH=/srv/backups/dujiao-next
PROJECT_INTERNAL_NETWORK=dujiao-next-internal
SHARED_APP_NETWORK=spikersun-private
PUBLIC_HOST=shop.spikersun.com
```

Durable runtime includes PostgreSQL and Redis project state under the Dujiao namespace.

R16 ephemeral runtime is absent, while R16/history recovery files remain intentionally retained pending retention review.

No Secret values belong in this manifest.
