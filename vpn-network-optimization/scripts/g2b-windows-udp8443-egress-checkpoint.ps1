[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$PSNativeCommandUseErrorActionPreference = $false

$acceptedCommit = '4e10db6fb3db68b20f6dff29c42d0ec0ee2c3206'
$acceptedRunnerBlob = '04fa524b05a9cecc408e8e4ef46ffcd649fd096e'
$acceptedConfigBlob = 'd522326919a64059fa7f214095e16e9a731819c6'

$publicVpsIp = '24.199.118.137'
$routePrefix = '24.199.118.137/32'
$wlanIndex = 18
$wlanAddress = '192.168.1.4'
$wlanGateway = '192.168.1.1'
$wgAdapterName = 'SFO2-A'
$proxyPort = 17890

$localStateRoot = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization'
$resultRoot = Join-Path $localStateRoot 'results'
$markerPath = Join-Path $localStateRoot 'g2b-windows-udp8443-egress-probe.invoked'
$runtimeConfigPath = Join-Path $localStateRoot 'runtime\g2b-mihomo.yaml'

$stamp = [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ')
$tempRoot = Join-Path $env:TEMP "vpn-g2b-checkpoint-$stamp-$PID"
$tempProject = Join-Path $tempRoot 'vpn-network-optimization'
$tempScripts = Join-Path $tempProject 'scripts'
$tempConfig = Join-Path $tempProject 'config\clash'
$tempResults = Join-Path $tempProject 'results'
$runnerPath = Join-Path $tempScripts 'g2b-owner-runner.ps1'
$configPath = Join-Path $tempConfig 'sfo3-a-hy2.yaml'
$persistedResults = Join-Path $resultRoot "g2b-windows-egress-probe-$stamp"
$checkpointLog = Join-Path $persistedResults 'checkpoint-output.txt'
$pktmonPath = $null
$pktmonStarted = $false
$pktmonFilterAdded = $false
$pktmonTxPackets = 0L
$pktmonRxPackets = 0L
$windowsUdpOutboundSeen = 'UNKNOWN'
$windowsUdpInboundSeen = 'UNKNOWN'

$runnerInvoked = $false
$runnerCompleted = $false
$checkpointFailed = $false
$failureStage = $null
$cleanupFailures = [Collections.Generic.List[string]]::new()

function Assert-Checkpoint {
    param(
        [Parameter(Mandatory=$true)][bool]$Condition,
        [Parameter(Mandatory=$true)][string]$Code
    )
    if (-not $Condition) { throw $Code }
}

function Get-ExactOwnerRoute {
    try {
        $items = @(Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -DestinationPrefix $script:routePrefix -ErrorAction Stop)
        return ,$items
    }
    catch {
        if ($_.CategoryInfo.Category -eq [System.Management.Automation.ErrorCategory]::ObjectNotFound -and
            $_.FullyQualifiedErrorId -eq 'CmdletizationQuery_NotFound,Get-NetRoute') {
            return ,@()
        }
        throw
    }
}

function Get-PersistentOwnerRoute {
    try {
        $items = @(Get-NetRoute -AddressFamily IPv4 -PolicyStore PersistentStore -DestinationPrefix $script:routePrefix -ErrorAction Stop)
        return ,$items
    }
    catch {
        if ($_.CategoryInfo.Category -eq [System.Management.Automation.ErrorCategory]::ObjectNotFound -and
            $_.FullyQualifiedErrorId -eq 'CmdletizationQuery_NotFound,Get-NetRoute') {
            return ,@()
        }
        throw
    }
}

function Get-PublicExit {
    $curl = (Get-Command curl.exe -ErrorAction Stop).Source
    $output = & $curl -fsS --connect-timeout 10 --max-time 20 'https://api.ipify.org'
    if ($LASTEXITCODE -ne 0) { throw 'PUBLIC_EXIT_QUERY_FAILED' }
    return ([string]$output).Trim()
}

function Get-GitBlobSha {
    param([Parameter(Mandatory=$true)][string]$Path)
    $git = (Get-Command git.exe -ErrorAction Stop).Source
    $sha = & $git hash-object -- $Path
    if ($LASTEXITCODE -ne 0) { throw 'GIT_HASH_OBJECT_FAILED' }
    return ([string]$sha).Trim()
}

function Download-ExactFile {
    param(
        [Parameter(Mandatory=$true)][string]$RelativePath,
        [Parameter(Mandatory=$true)][string]$Destination
    )
    $curl = (Get-Command curl.exe -ErrorAction Stop).Source
    $url = "https://raw.githubusercontent.com/entropy-student/project/$script:acceptedCommit/vpn-network-optimization/$RelativePath"
    & $curl -fsSL --retry 2 --connect-timeout 10 --max-time 60 -o $Destination $url
    if ($LASTEXITCODE -ne 0) { throw 'ACCEPTED_SOURCE_DOWNLOAD_FAILED' }
    Assert-Checkpoint (Test-Path -LiteralPath $Destination -PathType Leaf) 'ACCEPTED_SOURCE_DOWNLOAD_MISSING'
}

function Add-CleanupFailure {
    param([Parameter(Mandatory=$true)][string]$Code)
    $script:cleanupFailures.Add($Code)
    Write-Output "CHECKPOINT_CLEANUP_FAILED=$Code"
}

try {
    $failureStage = 'OWNER_AND_SOURCE_PREFLIGHT'

    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    Assert-Checkpoint ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 'ADMINISTRATOR_ELEVATION_REQUIRED'
    Assert-Checkpoint ($PSVersionTable.PSVersion.ToString() -eq '7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
    Assert-Checkpoint (-not (Test-Path -LiteralPath $markerPath)) 'WINDOWS_EGRESS_PROBE_ALREADY_INVOKED'

    [void][IO.Directory]::CreateDirectory($tempScripts)
    [void][IO.Directory]::CreateDirectory($tempConfig)
    [void][IO.Directory]::CreateDirectory($persistedResults)

    Download-ExactFile -RelativePath 'scripts/g2b-owner-runner.ps1' -Destination $runnerPath
    Download-ExactFile -RelativePath 'config/clash/sfo3-a-hy2.yaml' -Destination $configPath

    Assert-Checkpoint ((Get-GitBlobSha -Path $runnerPath) -eq $acceptedRunnerBlob) 'RUNNER_SOURCE_IDENTITY_MISMATCH'
    Assert-Checkpoint ((Get-GitBlobSha -Path $configPath) -eq $acceptedConfigBlob) 'CLIENT_CONFIG_IDENTITY_MISMATCH'
    Write-Output 'ACCEPTED_SOURCE_IDENTITY=PASS'

    $failureStage = 'NETWORK_BASELINE_PREFLIGHT'

    $wgManager = Get-Service -Name 'WireGuardManager' -ErrorAction Stop
    $wgTunnel = Get-Service -Name 'WireGuardTunnel$SFO2-A' -ErrorAction Stop
    $wgAdapter = Get-NetAdapter -Name $wgAdapterName -ErrorAction Stop
    Assert-Checkpoint ($wgManager.Status -eq 'Running') 'WIREGUARD_MANAGER_NOT_RUNNING'
    Assert-Checkpoint ($wgTunnel.Status -eq 'Running') 'WIREGUARD_TUNNEL_NOT_RUNNING'
    Assert-Checkpoint ($wgAdapter.Status -eq 'Up' -and [int]$wgAdapter.InterfaceIndex -eq 13) 'WIREGUARD_ADAPTER_BASELINE_INVALID'

    $wlan = Get-NetAdapter -InterfaceIndex $wlanIndex -ErrorAction Stop
    Assert-Checkpoint ($wlan.Status -eq 'Up' -and $wlan.Name -eq 'WLAN') 'WLAN_BASELINE_INVALID'
    $wlanConfig = Get-NetIPConfiguration -InterfaceIndex $wlanIndex -ErrorAction Stop
    $addresses = @($wlanConfig.IPv4Address | ForEach-Object { [string]$_.IPAddress })
    $gateways = @($wlanConfig.IPv4DefaultGateway | ForEach-Object { [string]$_.NextHop })
    Assert-Checkpoint ($addresses -contains $wlanAddress) 'WLAN_IPV4_MISMATCH'
    Assert-Checkpoint ($gateways -contains $wlanGateway) 'WLAN_GATEWAY_MISMATCH'

    Assert-Checkpoint ((Get-ExactOwnerRoute).Count -eq 0) 'OWNER_ROUTE_ALREADY_PRESENT'
    Assert-Checkpoint ((Get-PersistentOwnerRoute).Count -eq 0) 'PERSISTENT_OWNER_ROUTE_UNEXPECTED'
    Assert-Checkpoint (@(Get-NetTCPConnection -LocalPort $proxyPort -State Listen -ErrorAction SilentlyContinue).Count -eq 0) 'TEST_PROXY_TCP_LISTENER_PRESENT'
    Assert-Checkpoint (@(Get-NetUDPEndpoint -LocalPort $proxyPort -ErrorAction SilentlyContinue).Count -eq 0) 'TEST_PROXY_UDP_ENDPOINT_PRESENT'
    Assert-Checkpoint (-not (Test-Path -LiteralPath $runtimeConfigPath)) 'RUNTIME_CONFIG_RESIDUE_PRESENT'
    Assert-Checkpoint ((Get-PublicExit) -eq $publicVpsIp) 'PUBLIC_EXIT_BASELINE_INVALID'
    $pktmonPath = (Get-Command pktmon.exe -ErrorAction Stop).Source

    $pktmonStatusText = (& $pktmonPath status 2>&1 | Out-String).Trim()
    $pktmonStatusExit = $LASTEXITCODE
    Assert-Checkpoint ($pktmonStatusExit -eq 0) 'PKTMON_STATUS_QUERY_FAILED'
    $pktmonInactive = (
        $pktmonStatusText -match '(?i)no active|not running|stopped|inactive' -or
        $pktmonStatusText -match '没有.*活动|未运行|已停止|无活动'
    )
    Assert-Checkpoint $pktmonInactive 'PKTMON_ACTIVE_OR_STATUS_UNCLEAR'

    $pktmonFilterText = (& $pktmonPath filter list 2>&1 | Out-String).Trim()
    $pktmonFilterExit = $LASTEXITCODE
    Assert-Checkpoint ($pktmonFilterExit -eq 0) 'PKTMON_FILTER_LIST_FAILED'
    $pktmonNoFilters = (
        [string]::IsNullOrWhiteSpace($pktmonFilterText) -or
        $pktmonFilterText -match '(?i)no filters|no active filters' -or
        $pktmonFilterText -match '没有.*筛选|没有.*过滤|无.*筛选|无.*过滤'
    )
    if (-not $pktmonNoFilters) {
        Write-Output 'PKTMON_PREFLIGHT_FILTER_STATE=NONEMPTY_OR_UNCLEAR'
        $safeFilterPreview = ($pktmonFilterText -replace '[\r\n]+',' | ')
        if ($safeFilterPreview.Length -gt 240) { $safeFilterPreview = $safeFilterPreview.Substring(0,240) }
        Write-Output "PKTMON_FILTER_PREVIEW=$safeFilterPreview"
    }
    Assert-Checkpoint $pktmonNoFilters 'PKTMON_EXISTING_FILTERS_OR_UNCLEAR'
    Write-Output 'PKTMON_PREFLIGHT=PASS'
    Write-Output 'NETWORK_BASELINE_PREFLIGHT=PASS'

    $failureStage = 'CREATE_EXACT_TEMP_ROUTE'
    $routeArgs = @{
        AddressFamily = 'IPv4'
        DestinationPrefix = $routePrefix
        InterfaceIndex = $wlanIndex
        NextHop = $wlanGateway
        RouteMetric = 1
        PolicyStore = 'ActiveStore'
        ErrorAction = 'Stop'
    }
    New-NetRoute @routeArgs | Out-Null

    $createdRoutes = Get-ExactOwnerRoute
    Assert-Checkpoint ($createdRoutes.Count -eq 1) 'OWNER_ROUTE_CREATE_CARDINALITY_INVALID'
    Assert-Checkpoint (
        [int]$createdRoutes[0].InterfaceIndex -eq $wlanIndex -and
        [string]$createdRoutes[0].NextHop -eq $wlanGateway
    ) 'OWNER_ROUTE_CREATE_READBACK_INVALID'
    Write-Output 'OWNER_TEMP_ROUTE_CREATED=YES'

    $failureStage = 'START_WINDOWS_UDP_OBSERVER'
    & $pktmonPath filter add 'G2B-HY2-UDP8443' -i $publicVpsIp -t UDP -p 8443 | Out-Null
    Assert-Checkpoint ($LASTEXITCODE -eq 0) 'PKTMON_FILTER_ADD_FAILED'
    $pktmonFilterAdded = $true

    & $pktmonPath start --capture --counters-only --comp nics | Out-Null
    Assert-Checkpoint ($LASTEXITCODE -eq 0) 'PKTMON_START_FAILED'
    $pktmonStarted = $true

    & $pktmonPath reset | Out-Null
    Assert-Checkpoint ($LASTEXITCODE -eq 0) 'PKTMON_RESET_FAILED'
    Write-Output 'WINDOWS_UDP_OBSERVER_READY=YES'

    $failureStage = 'FORMAL_RUNNER_INVOCATION'
    Set-Content -LiteralPath $markerPath -Value "$stamp|$acceptedCommit" -NoNewline -Encoding ascii
    $runnerInvoked = $true
    Write-Output 'FORMAL_WINDOWS_EGRESS_HANDSHAKE_INVOCATION=START'

    try {
        & $runnerPath -HandshakeOnly 2>&1 | Tee-Object -FilePath $checkpointLog
        $runnerCompleted = $true
    }
    catch {
        $runnerCompleted = $false
        Write-Output "FORMAL_RUNNER_RETURNED_ERROR_CLASS=$($_.Exception.GetType().Name)"
    }

    $failureStage = 'COLLECT_WINDOWS_UDP_OBSERVER'
    $pktmonCounterText = (& $pktmonPath counters --type flow 2>&1 | Out-String).Trim()
    Assert-Checkpoint ($LASTEXITCODE -eq 0) 'PKTMON_COUNTERS_FAILED'

    foreach ($line in @($pktmonCounterText -split "[\r\n]+")) {
        if ($line -match '\bTx\s+([0-9,]+)\s+([0-9,]+)') {
            $txValue = [int64](($Matches[1] -replace ',',''))
            if ($txValue -gt $pktmonTxPackets) { $pktmonTxPackets = $txValue }
        }
        if ($line -match '\bRx\s+([0-9,]+)\s+([0-9,]+)') {
            $rxValue = [int64](($Matches[1] -replace ',',''))
            if ($rxValue -gt $pktmonRxPackets) { $pktmonRxPackets = $rxValue }
        }
    }

    $windowsUdpOutboundSeen = $(if ($pktmonTxPackets -gt 0) { 'YES' } else { 'NO' })
    $windowsUdpInboundSeen = $(if ($pktmonRxPackets -gt 0) { 'YES' } else { 'NO' })
    Write-Output "WINDOWS_UDP_8443_OUTBOUND_SEEN=$windowsUdpOutboundSeen"
    Write-Output "WINDOWS_UDP_8443_INBOUND_SEEN=$windowsUdpInboundSeen"
    Write-Output "PKTMON_MAX_NIC_TX_PACKETS=$pktmonTxPackets"
    Write-Output "PKTMON_MAX_NIC_RX_PACKETS=$pktmonRxPackets"
    Write-Output 'PKTMON_PAYLOAD_CAPTURED=NO'

    & $pktmonPath stop | Out-Null
    Assert-Checkpoint ($LASTEXITCODE -eq 0) 'PKTMON_STOP_FAILED'
    $pktmonStarted = $false

    & $pktmonPath filter remove | Out-Null
    Assert-Checkpoint ($LASTEXITCODE -eq 0) 'PKTMON_FILTER_REMOVE_FAILED'
    $pktmonFilterAdded = $false
    Write-Output 'WINDOWS_UDP_OBSERVER_STOPPED=YES'

    $failureStage = 'PERSIST_NON_SECRET_RESULTS'
    if (Test-Path -LiteralPath $tempResults -PathType Container) {
        Get-ChildItem -LiteralPath $tempResults -File -ErrorAction Stop |
            Where-Object { $_.Extension -in @('.csv','.json') } |
            Copy-Item -Destination $persistedResults -Force -ErrorAction Stop
    }
    Write-Output "NON_SECRET_RESULTS_PATH=$persistedResults"
}
catch {
    $checkpointFailed = $true
    $failureType = $_.Exception.GetType().Name
    $message = [string]$_.Exception.Message
    Write-Output "CHECKPOINT_RETURN_STAGE=$failureStage"
    if ($message -match '^[A-Z][A-Z0-9_]*$') {
        Write-Output "CHECKPOINT_RETURN_CODE=$message"
    }
    else {
        Write-Output "CHECKPOINT_RETURN_ERROR_CLASS=$failureType"
    }
}
finally {
    $failureStage = 'FINAL_FALLBACK_CLEANUP'

    try {
        if ($pktmonStarted -and $null -ne $pktmonPath) {
            & $pktmonPath stop | Out-Null
            if ($LASTEXITCODE -ne 0) { throw 'PKTMON_FINAL_STOP_FAILED' }
            $pktmonStarted = $false
        }
        if ($pktmonFilterAdded -and $null -ne $pktmonPath) {
            & $pktmonPath filter remove | Out-Null
            if ($LASTEXITCODE -ne 0) { throw 'PKTMON_FINAL_FILTER_REMOVE_FAILED' }
            $pktmonFilterAdded = $false
        }
        Write-Output 'FINAL_WINDOWS_UDP_OBSERVER_CLEAN=YES'
    }
    catch {
        Add-CleanupFailure 'FINAL_WINDOWS_UDP_OBSERVER_CLEANUP_FAILED'
    }

    try {
        $routes = Get-ExactOwnerRoute
        if ($routes.Count -gt 0) {
            $unexpected = @($routes | Where-Object {
                [int]$_.InterfaceIndex -ne $wlanIndex -or [string]$_.NextHop -ne $wlanGateway
            })
            if ($unexpected.Count -gt 0) {
                throw 'UNEXPECTED_OWNER_ROUTE_SHAPE_DURING_CLEANUP'
            }
            foreach ($route in $routes) {
                Remove-NetRoute -InputObject $route -Confirm:$false -ErrorAction Stop
            }
        }
        Assert-Checkpoint ((Get-ExactOwnerRoute).Count -eq 0) 'OWNER_ROUTE_STILL_PRESENT'
        Write-Output 'FINAL_OWNER_TEMP_ROUTE_ABSENT=YES'
    }
    catch {
        Add-CleanupFailure 'FINAL_OWNER_ROUTE_CLEANUP_FAILED'
    }

    try {
        $wgManagerFinal = Get-Service -Name 'WireGuardManager' -ErrorAction Stop
        $wgTunnelFinal = Get-Service -Name 'WireGuardTunnel$SFO2-A' -ErrorAction Stop
        $wgAdapterFinal = Get-NetAdapter -Name $wgAdapterName -ErrorAction Stop
        Assert-Checkpoint ($wgManagerFinal.Status -eq 'Running') 'FINAL_WG_MANAGER_NOT_RUNNING'
        Assert-Checkpoint ($wgTunnelFinal.Status -eq 'Running') 'FINAL_WG_TUNNEL_NOT_RUNNING'
        Assert-Checkpoint ($wgAdapterFinal.Status -eq 'Up' -and [int]$wgAdapterFinal.InterfaceIndex -eq 13) 'FINAL_WG_ADAPTER_INVALID'
        Assert-Checkpoint ((Get-PublicExit) -eq $publicVpsIp) 'FINAL_PUBLIC_EXIT_INVALID'
        Write-Output 'FINAL_PRODUCTION_WIREGUARD=RESTORED'
    }
    catch {
        Add-CleanupFailure 'FINAL_WIREGUARD_READBACK_FAILED'
    }

    try {
        Assert-Checkpoint (@(Get-NetTCPConnection -LocalPort $proxyPort -State Listen -ErrorAction SilentlyContinue).Count -eq 0) 'FINAL_PROXY_LISTENER_PRESENT'
        Assert-Checkpoint (@(Get-NetUDPEndpoint -LocalPort $proxyPort -ErrorAction SilentlyContinue).Count -eq 0) 'FINAL_PROXY_UDP_ENDPOINT_PRESENT'
        Assert-Checkpoint (-not (Test-Path -LiteralPath $runtimeConfigPath)) 'FINAL_RUNTIME_CONFIG_PRESENT'
        Write-Output 'FINAL_TEST_RUNTIME_RESIDUE=ABSENT'
    }
    catch {
        Add-CleanupFailure 'FINAL_TEST_RUNTIME_READBACK_FAILED'
    }

    try {
        if (Test-Path -LiteralPath $tempRoot) {
            Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction Stop
        }
        Write-Output 'TEMP_CHECKPOINT_WORKSPACE_REMOVED=YES'
    }
    catch {
        Add-CleanupFailure 'TEMP_CHECKPOINT_WORKSPACE_CLEANUP_FAILED'
    }
}

if ($cleanupFailures.Count -gt 0) { $checkpointFailed = $true }

Write-Output "RUNNER_INVOKED=$runnerInvoked"
Write-Output "RUNNER_COMPLETED=$runnerCompleted"
Write-Output "WINDOWS_EGRESS_PROBE_INVOKED=$runnerInvoked"
Write-Output "CHECKPOINT_CLEANUP_FAILURE_COUNT=$($cleanupFailures.Count)"

if ($runnerInvoked -and $runnerCompleted -and -not $checkpointFailed) {
    Write-Output 'OWNER_WINDOWS_EGRESS_PROBE_RESULT=COMPLETE'
    exit 0
}

Write-Output 'OWNER_WINDOWS_EGRESS_PROBE_RESULT=RETURN_TO_REVIEWER'
exit 1
