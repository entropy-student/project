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
$runtimeConfigPath = Join-Path $localStateRoot 'runtime\g2b-mihomo.yaml'

$stamp = [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ')
$tempRoot = Join-Path $env:TEMP "vpn-g2b-checkpoint-$stamp-$PID"
$tempProject = Join-Path $tempRoot 'vpn-network-optimization'
$tempScripts = Join-Path $tempProject 'scripts'
$tempConfig = Join-Path $tempProject 'config\clash'
$tempResults = Join-Path $tempProject 'results'
$runnerPath = Join-Path $tempScripts 'g2b-owner-runner.ps1'
$configPath = Join-Path $tempConfig 'sfo3-a-hy2.yaml'
$persistedResults = Join-Path $resultRoot "g2b-comparative-validation-$stamp"
$checkpointLog = Join-Path $persistedResults 'checkpoint-output.txt'

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

    $encodedPath = ($RelativePath -split '/' | ForEach-Object { [uri]::EscapeDataString($_) }) -join '/'
    $url = "https://api.github.com/repos/entropy-student/project/contents/vpn-network-optimization/$encodedPath" +
        "?ref=$script:acceptedCommit"

    try {
        $response = Invoke-RestMethod -Uri $url -Headers @{
            'Accept' = 'application/vnd.github+json'
            'User-Agent' = 'vpn-network-optimization-checkpoint'
        } -Method Get -TimeoutSec 60 -ErrorAction Stop
    }
    catch {
        throw 'ACCEPTED_SOURCE_API_DOWNLOAD_FAILED'
    }

    Assert-Checkpoint ($null -ne $response) 'ACCEPTED_SOURCE_API_RESPONSE_EMPTY'
    Assert-Checkpoint ([string]$response.encoding -eq 'base64') 'ACCEPTED_SOURCE_API_ENCODING_INVALID'
    Assert-Checkpoint (-not [string]::IsNullOrWhiteSpace([string]$response.content)) 'ACCEPTED_SOURCE_API_CONTENT_EMPTY'

    try {
        $bytes = [Convert]::FromBase64String(([string]$response.content -replace '\s',''))
        [IO.File]::WriteAllBytes($Destination, $bytes)
    }
    catch {
        throw 'ACCEPTED_SOURCE_API_DECODE_FAILED'
    }

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

    $failureStage = 'FORMAL_RUNNER_INVOCATION'
    $runnerInvoked = $true
    Write-Output 'FORMAL_COMPARATIVE_VALIDATION_INVOCATION=START'

    try {
        & $runnerPath 2>&1 | Tee-Object -FilePath $checkpointLog
        $runnerCompleted = $true
    }
    catch {
        $runnerCompleted = $false
        Write-Output "FORMAL_RUNNER_RETURNED_ERROR_CLASS=$($_.Exception.GetType().Name)"
    }

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
Write-Output "CHECKPOINT_CLEANUP_FAILURE_COUNT=$($cleanupFailures.Count)"

if ($runnerInvoked -and $runnerCompleted -and -not $checkpointFailed) {
    Write-Output 'OWNER_POST_KILLSWITCH_COMPARATIVE_RESULT=COMPLETE'
    exit 0
}

Write-Output 'OWNER_POST_KILLSWITCH_COMPARATIVE_RESULT=RETURN_TO_REVIEWER'
exit 1
