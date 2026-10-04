[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$projectRoot = Split-Path -Parent $PSScriptRoot
$runner = Join-Path $PSScriptRoot 'g4b0-owner-interface-bypass-canary.ps1'
$validator = Join-Path $PSScriptRoot 'g4b0-interface-bypass-package-validator.ps1'
$handoff = Join-Path $projectRoot 'REVIEWER_HANDOFF.md'

function Assert-G4B0Checkpoint {
    param([bool]$Condition,[string]$Code)
    if (-not $Condition) { throw $Code }
}

foreach($path in @($runner,$validator,$handoff)){
    Assert-G4B0Checkpoint (Test-Path -LiteralPath $path -PathType Leaf) 'G4B0_CHECKPOINT_REQUIRED_FILE_MISSING'
}

$handoffText = [IO.File]::ReadAllText($handoff,[Text.Encoding]::UTF8)
Assert-G4B0Checkpoint ($handoffText.Contains('GATE_ID=G4B0_WINDOWS_MIHOMO_INTERFACE_BYPASS_CANARY_R1')) 'G4B0_CHECKPOINT_GATE_MISMATCH'
Assert-G4B0Checkpoint ($handoffText.Contains('STATE=REPAIR_VALIDATION_PENDING')) 'G4B0_CHECKPOINT_STATE_MISMATCH'

foreach($path in @($runner,$validator)){
    $tokens = $null
    $errors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($path,[ref]$tokens,[ref]$errors) | Out-Null
    Assert-G4B0Checkpoint (@($errors).Count -eq 0) 'G4B0_CHECKPOINT_AST_PARSE_FAILED'
}

Write-Output 'G4B0_REPAIRED_AST=PASS'

$pwsh = (Get-Command pwsh.exe -ErrorAction Stop).Source
$output = @(& $pwsh -NoProfile -File $validator 2>&1)
$exitCode = $LASTEXITCODE

foreach($line in $output){ Write-Output ([string]$line) }

Assert-G4B0Checkpoint ($exitCode -eq 0) 'G4B0_CHECKPOINT_VALIDATOR_FAILED'
Assert-G4B0Checkpoint (($output -join [Environment]::NewLine).Contains('G4B0_OFFLINE_PACKAGE_VALIDATION=PASS')) 'G4B0_CHECKPOINT_VALIDATOR_MARKER_MISSING'
Assert-G4B0Checkpoint (($output -join [Environment]::NewLine).Contains('G4B0_UDP_READINESS_REPAIR=PASS')) 'G4B0_CHECKPOINT_UDP_REPAIR_MARKER_MISSING'
Assert-G4B0Checkpoint (($output -join [Environment]::NewLine).Contains('G4B0_FAILURE_PHASE_TELEMETRY=PASS')) 'G4B0_CHECKPOINT_PHASE_MARKER_MISSING'

Write-Output 'G4B0_REPAIR_CHECKPOINT=PASS'
Write-Output 'NETWORK_MUTATION=NO'
Write-Output 'SECRET_ACCESS=NO'
Write-Output 'EXTERNAL_REQUESTS=0'
Write-Output 'LIVE_AUTHORIZATION_REQUIRED_BEFORE_RETRY=YES'
