$ErrorActionPreference = 'Stop'
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
  Write-Error 'RETURN_G1_LOCAL_RUNTIME_UNAVAILABLE: docker not found'
  exit 2
}
Set-Location (Split-Path $PSScriptRoot -Parent)
if (-not (Test-Path .env)) { Copy-Item .env.example .env }
New-Item -ItemType Directory -Force -Path runtime/db, runtime/wordpress | Out-Null

docker compose -f docker-compose.local.yml up -d db wordpress
for ($i=0; $i -lt 60; $i++) {
  docker compose -f docker-compose.local.yml exec -T wordpress test -f /var/www/html/wp-load.php
  if ($LASTEXITCODE -eq 0) { break }
  Start-Sleep -Seconds 2
}

$port = if ($env:WP_PORT) { $env:WP_PORT } else { '8080' }

docker compose -f docker-compose.local.yml --profile tools run --rm wpcli core install `
  --url="http://localhost:$port" `
  --title="Conversion Leak Audit" `
  --admin_user="cla_admin" `
  --admin_password="change-me-local-only-admin" `
  --admin_email="admin@example.test" `
  --skip-email

docker compose -f docker-compose.local.yml --profile tools run --rm wpcli theme install saaslauncher --version=2.0.18 --activate
docker compose -f docker-compose.local.yml --profile tools run --rm wpcli theme activate conversion-leak-audit-child
docker compose -f docker-compose.local.yml --profile tools run --rm wpcli eval-file /workspace/scripts/seed-content.php
& ./scripts/verify-g1.ps1
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
