[CmdletBinding()]
param(
  [switch]$RetryFailed
)

$ErrorActionPreference = 'Stop'
$node = Get-Command node.exe -ErrorAction SilentlyContinue
$codex = Get-Command codex.exe -ErrorAction SilentlyContinue
if (-not $node) { Write-Error 'RETURN_NODE_RUNTIME_UNAVAILABLE'; exit 2 }
if (-not $codex) { Write-Error 'RETURN_CODEX_CLI_UNAVAILABLE'; exit 2 }

$env:BMS_G2BR2_HOST_MODE = '1'
$env:BMS_CODEX_EXECUTABLE = $codex.Source
$runner = Join-Path $PSScriptRoot 'src\g2br1-run.mjs'
if (-not (Test-Path -LiteralPath $runner -PathType Leaf)) { Write-Error 'RETURN_EXISTING_G2B_HARNESS_UNAVAILABLE'; exit 2 }

$runnerArgs = @($runner)
if ($RetryFailed) { $runnerArgs += '--retry-failed' }
& $node.Source @runnerArgs
$runnerExitCode = $LASTEXITCODE
if ($runnerExitCode -ne 0) { exit $runnerExitCode }
exit 0
