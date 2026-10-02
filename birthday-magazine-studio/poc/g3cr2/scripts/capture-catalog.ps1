$ErrorActionPreference = 'Stop'

$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$ComposeFile = Join-Path $ProjectRoot 'compose.yaml'
$ReportRoot = Join-Path $ProjectRoot 'artifacts\reports'
New-Item -ItemType Directory -Force -Path $ReportRoot | Out-Null

$engine = & docker version --format '{{.Server.Version}}'
if ($LASTEXITCODE -ne 0 -or -not $engine) { throw 'Docker Engine is unavailable.' }
$services = & docker compose -p birthday-magazine-g3cr2 -f $ComposeFile ps --status running --services
if ($LASTEXITCODE -ne 0 -or $services -notcontains 'wpcli') { throw 'The G3CR2 WP-CLI service is not running.' }

# Read-only: this lists the live Blocksy importer catalog and does not import a starter.
$catalog = & docker compose -p birthday-magazine-g3cr2 -f $ComposeFile exec -T wpcli wp blocksy demo list --format=json
if ($LASTEXITCODE -ne 0) { throw 'Blocksy importer catalog query failed.' }
$catalogText = $catalog -join "`n"
$catalogPath = Join-Path $ReportRoot 'blocksy-demo-catalog.raw.json'
[IO.File]::WriteAllText($catalogPath, $catalogText + "`n", [Text.UTF8Encoding]::new($false))
$entries = $catalogText | ConvertFrom-Json
$wedding = @($entries | Where-Object { $_.name -eq 'Wedding' })
if ($wedding.Count -ne 1) { throw 'The catalog does not contain exactly one Wedding entry.' }

[pscustomobject]@{
	capturedAtUtc = (Get-Date).ToUniversalTime().ToString('o')
	gate = 'G3CR2_BLOCKSY_WEDDING_WOOCOMMERCE_CANARY'
	engineVersion = $engine.Trim()
	query = 'wp blocksy demo list --format=json'
	readOnly = $true
	wedding = $wedding[0]
	weddingBuilderSpecificDependencyMap = $false
	decision = 'RETURN_G3CR2_GUTENBERG_DEPENDENCY_AMBIGUOUS'
} | ConvertTo-Json -Depth 12 | Set-Content -Encoding utf8 (Join-Path $ReportRoot 'blocksy-demo-catalog-analysis.json')
