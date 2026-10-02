[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

$publicVpsIp = '24.199.118.137'
$wgIfIndex = 13
$tempRoot = Join-Path $env:TEMP ('g2b-wireguard-killswitch-readonly-' + [guid]::NewGuid().ToString('N'))
$filtersPath = Join-Path $tempRoot 'filters.xml'
$statePath = Join-Path $tempRoot 'state.xml'
$cleanupFailures = [Collections.Generic.List[string]]::new()

function Assert-Check {
    param(
        [Parameter(Mandatory=$true)][bool]$Condition,
        [Parameter(Mandatory=$true)][string]$Code
    )
    if (-not $Condition) { throw $Code }
}

function Add-CleanupFailure {
    param([Parameter(Mandatory=$true)][string]$Code)
    $script:cleanupFailures.Add($Code)
    Write-Output "CLEANUP_FAILED=$Code"
}

try {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    Assert-Check ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 'ADMINISTRATOR_ELEVATION_REQUIRED'
    Assert-Check ($PSVersionTable.PSVersion.ToString() -eq '7.6.6') 'POWERSHELL_7_6_6_REQUIRED'

    $wgManager = Get-Service -Name 'WireGuardManager' -ErrorAction Stop
    $wgTunnel = Get-Service -Name 'WireGuardTunnel$SFO2-A' -ErrorAction Stop
    $wgAdapter = Get-NetAdapter -Name 'SFO2-A' -ErrorAction Stop
    Assert-Check ($wgManager.Status -eq 'Running') 'WIREGUARD_MANAGER_NOT_RUNNING'
    Assert-Check ($wgTunnel.Status -eq 'Running') 'WIREGUARD_TUNNEL_NOT_RUNNING'
    Assert-Check ($wgAdapter.Status -eq 'Up' -and [int]$wgAdapter.InterfaceIndex -eq $wgIfIndex) 'WIREGUARD_ADAPTER_INVALID'

    $routes = @(Get-NetRoute -AddressFamily IPv4 -InterfaceIndex $wgIfIndex -PolicyStore ActiveStore -ErrorAction Stop)
    $prefixes = @($routes | ForEach-Object { [string]$_.DestinationPrefix })
    $hasDefault = $prefixes -contains '0.0.0.0/0'
    $hasSplitA = $prefixes -contains '0.0.0.0/1'
    $hasSplitB = $prefixes -contains '128.0.0.0/1'

    Write-Output "WG_ROUTE_DEFAULT_V4_0_0_0_0_0=$(if($hasDefault){'YES'}else{'NO'})"
    Write-Output "WG_ROUTE_SPLIT_V4_0_0_0_0_1=$(if($hasSplitA){'YES'}else{'NO'})"
    Write-Output "WG_ROUTE_SPLIT_V4_128_0_0_0_1=$(if($hasSplitB){'YES'}else{'NO'})"

    New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null

    $netsh = (Get-Command netsh.exe -ErrorAction Stop).Source
    & $netsh wfp show filters file="$filtersPath" protocol=17 remoteaddr=$publicVpsIp remoteport=8443 dir=out verbose=on | Out-Null
    Assert-Check ($LASTEXITCODE -eq 0) 'WFP_FILTER_QUERY_FAILED'
    Assert-Check (Test-Path -LiteralPath $filtersPath -PathType Leaf) 'WFP_FILTER_OUTPUT_MISSING'

    & $netsh wfp show state file="$statePath" | Out-Null
    Assert-Check ($LASTEXITCODE -eq 0) 'WFP_STATE_QUERY_FAILED'
    Assert-Check (Test-Path -LiteralPath $statePath -PathType Leaf) 'WFP_STATE_OUTPUT_MISSING'

    $filterText = Get-Content -LiteralPath $filtersPath -Raw -ErrorAction Stop
    $stateText = Get-Content -LiteralPath $statePath -Raw -ErrorAction Stop

    $blockName = $filterText -match 'Block all outbound \(IPv4\)'
    $wireGuardInFiltered = $filterText -match '(?i)WireGuard'
    $wireGuardInState = $stateText -match '(?i)WireGuard'
    $wireGuardBlockInState = $stateText -match 'Block all outbound \(IPv4\)'

    Write-Output "WFP_TARGET_BLOCK_ALL_OUTBOUND_IPV4=$(
        if($blockName){'YES'}else{'NO'}
    )"
    Write-Output "WFP_TARGET_FILTER_TEXT_HAS_WIREGUARD=$(
        if($wireGuardInFiltered){'YES'}else{'NO'}
    )"
    Write-Output "WFP_STATE_HAS_WIREGUARD=$(
        if($wireGuardInState){'YES'}else{'NO'}
    )"
    Write-Output "WFP_STATE_HAS_BLOCK_ALL_OUTBOUND_IPV4=$(
        if($wireGuardBlockInState){'YES'}else{'NO'}
    )"

    if ($hasDefault -and $blockName -and $wireGuardInState -and $wireGuardBlockInState) {
        Write-Output 'WIREGUARD_KILLSWITCH_CONFIRMATION=CONFIRMED'
    }
    elseif ($hasDefault -and $blockName) {
        Write-Output 'WIREGUARD_KILLSWITCH_CONFIRMATION=HIGH_CONFIDENCE'
    }
    else {
        Write-Output 'WIREGUARD_KILLSWITCH_CONFIRMATION=NOT_CONFIRMED'
    }

    Write-Output 'READ_ONLY_MUTATION=NO'
    Write-Output 'SECRET_VALUES_EMITTED=0'
}
catch {
    $message = [string]$_.Exception.Message
    if ($message -match '^[A-Z][A-Z0-9_]*$') {
        Write-Output "WIREGUARD_KILLSWITCH_READONLY_RETURN_CODE=$message"
    }
    else {
        Write-Output "WIREGUARD_KILLSWITCH_READONLY_RETURN_ERROR_CLASS=$($_.Exception.GetType().Name)"
    }
}
finally {
    try {
        if (Test-Path -LiteralPath $tempRoot) {
            Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction Stop
        }
        Write-Output 'TEMP_WFP_READONLY_ARTIFACTS_REMOVED=YES'
    }
    catch {
        Add-CleanupFailure 'TEMP_WFP_READONLY_ARTIFACTS_REMOVE_FAILED'
    }

    try {
        $wgManagerFinal = Get-Service -Name 'WireGuardManager' -ErrorAction Stop
        $wgTunnelFinal = Get-Service -Name 'WireGuardTunnel$SFO2-A' -ErrorAction Stop
        $wgAdapterFinal = Get-NetAdapter -Name 'SFO2-A' -ErrorAction Stop
        Assert-Check ($wgManagerFinal.Status -eq 'Running') 'FINAL_WG_MANAGER_NOT_RUNNING'
        Assert-Check ($wgTunnelFinal.Status -eq 'Running') 'FINAL_WG_TUNNEL_NOT_RUNNING'
        Assert-Check ($wgAdapterFinal.Status -eq 'Up' -and [int]$wgAdapterFinal.InterfaceIndex -eq $wgIfIndex) 'FINAL_WG_ADAPTER_INVALID'
        Write-Output 'FINAL_PRODUCTION_WIREGUARD=UNCHANGED'
    }
    catch {
        Add-CleanupFailure 'FINAL_WIREGUARD_READBACK_FAILED'
    }
}

Write-Output "CLEANUP_FAILURE_COUNT=$($cleanupFailures.Count)"
if ($cleanupFailures.Count -gt 0) {
    Write-Output 'OWNER_WIREGUARD_KILLSWITCH_READONLY_RESULT=RETURN_TO_REVIEWER'
    exit 1
}
Write-Output 'OWNER_WIREGUARD_KILLSWITCH_READONLY_RESULT=COMPLETE'
exit 0
