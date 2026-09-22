#!/usr/bin/env bash
set -euo pipefail

if ! command -v docker >/dev/null 2>&1; then
  echo 'RETURN_G1_LOCAL_RUNTIME_UNAVAILABLE: docker not found' >&2
  exit 2
fi

cd "$(dirname "$0")/.."
[ -f .env ] || cp .env.example .env
mkdir -p runtime/db runtime/wordpress

docker compose -f docker-compose.local.yml up -d db wordpress

# Wait for WordPress files, then install WP via CLI container.
for i in $(seq 1 60); do
  if docker compose -f docker-compose.local.yml exec -T wordpress test -f /var/www/html/wp-load.php; then break; fi
  sleep 2
done

docker compose -f docker-compose.local.yml --profile tools run --rm wpcli core install \
  --url="http://localhost:${WP_PORT:-8080}" \
  --title="${WP_SITE_TITLE:-Conversion Leak Audit}" \
  --admin_user="${WP_ADMIN_USER:-cla_admin}" \
  --admin_password="${WP_ADMIN_PASSWORD:-change-me-local-only-admin}" \
  --admin_email="${WP_ADMIN_EMAIL:-admin@example.test}" \
  --skip-email || true

docker compose -f docker-compose.local.yml --profile tools run --rm wpcli theme install saaslauncher --version=2.0.18 --activate
docker compose -f docker-compose.local.yml --profile tools run --rm wpcli theme activate conversion-leak-audit-child
docker compose -f docker-compose.local.yml --profile tools run --rm wpcli eval-file /workspace/scripts/seed-content.php

./scripts/verify-g1.sh
