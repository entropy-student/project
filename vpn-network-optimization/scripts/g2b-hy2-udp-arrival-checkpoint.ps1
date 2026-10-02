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
$markerPath = Join-Path $localStateRoot 'g2b-hy2-udp-arrival-probe.invoked'
$runtimeConfigPath = Join-Path $localStateRoot 'runtime\g2b-mihomo.yaml'

$stamp = [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ')
$tempRoot = Join-Path $env:TEMP "vpn-g2b-checkpoint-$stamp-$PID"
$tempProject = Join-Path $tempRoot 'vpn-network-optimization'
$tempScripts = Join-Path $tempProject 'scripts'
$tempConfig = Join-Path $tempProject 'config\clash'
$tempResults = Join-Path $tempProject 'results'
$runnerPath = Join-Path $tempScripts 'g2b-owner-runner.ps1'
$configPath = Join-Path $tempConfig 'sfo3-a-hy2.yaml'
$persistedResults = Join-Path $resultRoot "g2b-udp-arrival-probe-$stamp"
$checkpointLog = Join-Path $persistedResults 'checkpoint-output.txt'
$sshIdentityFile = Join-Path $env:USERPROFILE '.ssh\digitalocean_ed25519'
$knownHostsFile = Join-Path $env:USERPROFILE '.ssh\known_hosts'
$sshPath = $null
$observerProcess = $null
$observerStderrTask = $null
$observerCollected = $false
$udpInboundSeen = 'UNKNOWN'
$udpOutboundSeen = 'UNKNOWN'

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
    Assert-Checkpoint (-not (Test-Path -LiteralPath $markerPath)) 'UDP_ARRIVAL_PROBE_ALREADY_INVOKED'

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
    Assert-Checkpoint (Test-Path -LiteralPath $sshIdentityFile -PathType Leaf) 'SSH_IDENTITY_FILE_MISSING'
    Assert-Checkpoint (Test-Path -LiteralPath $knownHostsFile -PathType Leaf) 'SSH_KNOWN_HOSTS_FILE_MISSING'
    $sshPath = (Get-Command ssh.exe -ErrorAction Stop).Source
    Write-Output 'NETWORK_BASELINE_PREFLIGHT=PASS'

    $failureStage = 'START_UDP_OBSERVER'
    $remoteObserver = @'
set -eu
if ! command -v tcpdump >/dev/null 2>&1; then
  echo "UDP_OBSERVER_READY=NO"
  echo "UDP_OBSERVER_ERROR=TCPDUMP_MISSING"
  exit 42
fi

inpid=''
outpid=''
cleanup() {
  if [ -n "$inpid" ]; then
    kill "$inpid" 2>/dev/null || true
    wait "$inpid" 2>/dev/null || true
  fi
  if [ -n "$outpid" ]; then
    kill "$outpid" 2>/dev/null || true
    wait "$outpid" 2>/dev/null || true
  fi
}
trap cleanup HUP INT TERM EXIT

timeout 20 tcpdump -n -q -i eth0 -c 1 'udp dst port 8443' >/dev/null 2>&1 &
inpid=$!
timeout 20 tcpdump -n -q -i eth0 -c 1 'udp src port 8443' >/dev/null 2>&1 &
outpid=$!

echo "UDP_OBSERVER_READY=YES"
set +e
wait "$inpid"
inrc=$?
wait "$outpid"
outrc=$?
set -e
inpid=''
outpid=''

case "$inrc" in
  0) inbound='YES' ;;
  124) inbound='NO' ;;
  *) inbound='ERROR' ;;
esac
case "$outrc" in
  0) outbound='YES' ;;
  124) outbound='NO' ;;
  *) outbound='ERROR' ;;
esac

echo "UDP_8443_INBOUND_SEEN=$inbound"
echo "UDP_8443_OUTBOUND_SEEN=$outbound"
echo "UDP_OBSERVER_INBOUND_EXIT=$inrc"
echo "UDP_OBSERVER_OUTBOUND_EXIT=$outrc"
echo "UDP_OBSERVER_PAYLOAD_CAPTURED=NO"
trap - HUP INT TERM EXIT
exit 0
'@

    $observerStart = [Diagnostics.ProcessStartInfo]::new()
    $observerStart.FileName = $sshPath
    $observerStart.UseShellExecute = $false
    $observerStart.RedirectStandardInput = $true
    $observerStart.RedirectStandardOutput = $true
    $observerStart.RedirectStandardError = $true
    foreach ($arg in @(
        '-F', 'none', '-T', '-p', '22', '-i', $sshIdentityFile,
        '-o', 'BatchMode=yes',
        '-o', 'IdentitiesOnly=yes',
        '-o', 'PreferredAuthentications=publickey',
        '-o', 'StrictHostKeyChecking=yes',
        '-o', 'UpdateHostKeys=no',
        '-o', "UserKnownHostsFile=$knownHostsFile",
        '-o', 'GlobalKnownHostsFile=none',
        '-o', 'HostKeyAlias=24.199.118.137',
        '-o', 'CheckHostIP=no',
        '-o', 'HostName=10.66.21.1',
        '-o', 'ProxyCommand=none',
        '-o', 'ProxyJump=none',
        '-o', 'PermitLocalCommand=no',
        '-o', 'ControlMaster=no',
        '-o', 'ControlPath=none',
        '-o', 'ForwardAgent=no',
        '-o', 'ConnectTimeout=15',
        '-o', 'ServerAliveInterval=10',
        '-o', 'ServerAliveCountMax=3',
        'root@10.66.21.1', 'bash -s'
    )) {
        [void]$observerStart.ArgumentList.Add($arg)
    }

    $observerProcess = [Diagnostics.Process]::new()
    $observerProcess.StartInfo = $observerStart
    Assert-Checkpoint ($observerProcess.Start()) 'UDP_OBSERVER_SSH_START_FAILED'
    $observerStderrTask = $observerProcess.StandardError.ReadToEndAsync()
    $observerProcess.StandardInput.Write($remoteObserver)
    $observerProcess.StandardInput.Close()

    $readyLine = $observerProcess.StandardOutput.ReadLine()
    if ($readyLine -eq 'UDP_OBSERVER_READY=NO') {
        $observerErrorLine = $observerProcess.StandardOutput.ReadLine()
        if ($observerErrorLine -match '^UDP_OBSERVER_ERROR=[A-Z0-9_]+$') { Write-Output $observerErrorLine }
    }
    Assert-Checkpoint ($readyLine -eq 'UDP_OBSERVER_READY=YES') 'UDP_OBSERVER_NOT_READY'
    Write-Output 'UDP_OBSERVER_READY=YES'

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
    Set-Content -LiteralPath $markerPath -Value "$stamp|$acceptedCommit" -NoNewline -Encoding ascii
    $runnerInvoked = $true
    Write-Output 'FORMAL_UDP_ARRIVAL_HANDSHAKE_INVOCATION=START'

    try {
        & $runnerPath -HandshakeOnly 2>&1 | Tee-Object -FilePath $checkpointLog
        $runnerCompleted = $true
    }
    catch {
        $runnerCompleted = $false
        Write-Output "FORMAL_RUNNER_RETURNED_ERROR_CLASS=$($_.Exception.GetType().Name)"
    }

    $failureStage = 'COLLECT_UDP_OBSERVER'
    if ($null -eq $observerProcess) { throw 'UDP_OBSERVER_PROCESS_MISSING' }
    if (-not $observerProcess.WaitForExit(30000)) {
        try { $observerProcess.Kill($true) } catch { }
        throw 'UDP_OBSERVER_TIMEOUT'
    }
    $observerTail = $observerProcess.StandardOutput.ReadToEnd()
    $observerLines = @($observerTail -split "[\r\n]+" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    foreach ($line in $observerLines) {
        if ($line -match '^UDP_8443_INBOUND_SEEN=(YES|NO|ERROR)$') {
            $udpInboundSeen = $Matches[1]
        }
        elseif ($line -match '^UDP_8443_OUTBOUND_SEEN=(YES|NO|ERROR)$') {
            $udpOutboundSeen = $Matches[1]
        }
        elseif ($line -match '^UDP_OBSERVER_(INBOUND|OUTBOUND)_EXIT=\d+$') {
            Write-Output $line
        }
        elseif ($line -eq 'UDP_OBSERVER_PAYLOAD_CAPTURED=NO') {
            Write-Output $line
        }
    }
    Assert-Checkpoint ($observerProcess.ExitCode -eq 0) 'UDP_OBSERVER_REMOTE_FAILED'
    Assert-Checkpoint ($udpInboundSeen -in @('YES','NO')) 'UDP_OBSERVER_INBOUND_RESULT_INVALID'
    Assert-Checkpoint ($udpOutboundSeen -in @('YES','NO')) 'UDP_OBSERVER_OUTBOUND_RESULT_INVALID'
    Write-Output "UDP_8443_INBOUND_SEEN=$udpInboundSeen"
    Write-Output "UDP_8443_OUTBOUND_SEEN=$udpOutboundSeen"
    $observerCollected = $true

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
        if ($null -ne $observerProcess) {
            if (-not $observerProcess.HasExited) {
                $observerProcess.Kill($true)
                if (-not $observerProcess.WaitForExit(10000)) { throw 'UDP_OBSERVER_PROCESS_STOP_TIMEOUT' }
            }
            if (-not $observerCollected) {
                $tail = $observerProcess.StandardOutput.ReadToEnd()
                $tailLines = @($tail -split "[\r\n]+" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
                foreach ($line in $tailLines) {
                    if ($line -match '^UDP_8443_INBOUND_SEEN=(YES|NO|ERROR)$') {
                        $udpInboundSeen = $Matches[1]
                    }
                    elseif ($line -match '^UDP_8443_OUTBOUND_SEEN=(YES|NO|ERROR)$') {
                        $udpOutboundSeen = $Matches[1]
                    }
                }
            }
            $observerProcess.Dispose()
            $observerProcess = $null
        }
        Write-Output 'UDP_OBSERVER_STOPPED=YES'
    }
    catch {
        Add-CleanupFailure 'UDP_OBSERVER_STOP_FAILED'
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
Write-Output "UDP_ARRIVAL_PROBE_AUTHORIZATION_CONSUMED=$runnerInvoked"
Write-Output "CHECKPOINT_CLEANUP_FAILURE_COUNT=$($cleanupFailures.Count)"

if ($runnerInvoked -and $runnerCompleted -and -not $checkpointFailed) {
    Write-Output 'OWNER_UDP_ARRIVAL_PROBE_RESULT=COMPLETE'
    exit 0
}

Write-Output 'OWNER_UDP_ARRIVAL_PROBE_RESULT=RETURN_TO_REVIEWER'
exit 1
