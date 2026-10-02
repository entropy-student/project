[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

$publicVpsIp = '24.199.118.137'
$routePrefix = '24.199.118.137/32'
$wlanIndex = 18
$wlanAddress = '192.168.1.4'
$wlanGateway = '192.168.1.1'
$wgAdapterName = 'SFO2-A'

$sshIdentityFile = Join-Path $env:USERPROFILE '.ssh\digitalocean_ed25519'
$knownHostsFile = Join-Path $env:USERPROFILE '.ssh\known_hosts'

$observerProcess = $null
$observerReady = $false
$routeCreated = $false
$cleanupFailures = [Collections.Generic.List[string]]::new()

function Assert-Check {
    param(
        [Parameter(Mandatory=$true)][bool]$Condition,
        [Parameter(Mandatory=$true)][string]$Code
    )
    if (-not $Condition) { throw $Code }
}

function Get-ExactRoute {
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

function Get-PersistentRoute {
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
    $wgAdapter = Get-NetAdapter -Name $wgAdapterName -ErrorAction Stop
    Assert-Check ($wgManager.Status -eq 'Running') 'WIREGUARD_MANAGER_NOT_RUNNING'
    Assert-Check ($wgTunnel.Status -eq 'Running') 'WIREGUARD_TUNNEL_NOT_RUNNING'
    Assert-Check ($wgAdapter.Status -eq 'Up' -and [int]$wgAdapter.InterfaceIndex -eq 13) 'WIREGUARD_ADAPTER_BASELINE_INVALID'

    $wlan = Get-NetAdapter -InterfaceIndex $wlanIndex -ErrorAction Stop
    Assert-Check ($wlan.Status -eq 'Up' -and $wlan.Name -eq 'WLAN') 'WLAN_BASELINE_INVALID'
    $wlanConfig = Get-NetIPConfiguration -InterfaceIndex $wlanIndex -ErrorAction Stop
    $addresses = @($wlanConfig.IPv4Address | ForEach-Object { [string]$_.IPAddress })
    $gateways = @($wlanConfig.IPv4DefaultGateway | ForEach-Object { [string]$_.NextHop })
    Assert-Check ($addresses -contains $wlanAddress) 'WLAN_IPV4_MISMATCH'
    Assert-Check ($gateways -contains $wlanGateway) 'WLAN_GATEWAY_MISMATCH'

    Assert-Check ((Get-ExactRoute).Count -eq 0) 'OWNER_ROUTE_ALREADY_PRESENT'
    Assert-Check ((Get-PersistentRoute).Count -eq 0) 'PERSISTENT_OWNER_ROUTE_UNEXPECTED'
    Assert-Check (Test-Path -LiteralPath $sshIdentityFile -PathType Leaf) 'SSH_IDENTITY_FILE_MISSING'
    Assert-Check (Test-Path -LiteralPath $knownHostsFile -PathType Leaf) 'SSH_KNOWN_HOSTS_FILE_MISSING'
    Assert-Check ((Get-PublicExit) -eq $publicVpsIp) 'PUBLIC_EXIT_BASELINE_INVALID'
    Write-Output 'RAW_UDP_CONTROL_PREFLIGHT=PASS'

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
    $routeCreated = $true

    $routes = Get-ExactRoute
    Assert-Check ($routes.Count -eq 1) 'OWNER_ROUTE_CREATE_CARDINALITY_INVALID'
    Assert-Check (
        [int]$routes[0].InterfaceIndex -eq $wlanIndex -and
        [string]$routes[0].NextHop -eq $wlanGateway
    ) 'OWNER_ROUTE_CREATE_READBACK_INVALID'
    Write-Output 'OWNER_TEMP_ROUTE_CREATED=YES'

    $sshPath = (Get-Command ssh.exe -ErrorAction Stop).Source
    $remoteObserver = @'
set -eu
if ! command -v tcpdump >/dev/null 2>&1; then
  echo "RAW_UDP_OBSERVER_READY=NO"
  echo "RAW_UDP_OBSERVER_ERROR=TCPDUMP_MISSING"
  exit 42
fi
echo "RAW_UDP_OBSERVER_READY=YES"
set +e
timeout 15 tcpdump -n -q -i eth0 -c 1 'udp dst port 8443' >/dev/null 2>&1
rc=$?
set -e
case "$rc" in
  0) echo "RAW_UDP_8443_VPS_INBOUND_SEEN=YES" ;;
  124) echo "RAW_UDP_8443_VPS_INBOUND_SEEN=NO" ;;
  *) echo "RAW_UDP_8443_VPS_INBOUND_SEEN=ERROR" ;;
esac
echo "RAW_UDP_OBSERVER_EXIT=$rc"
echo "RAW_UDP_OBSERVER_PAYLOAD_CAPTURED=NO"
exit 0
'@

    $psi = [Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $sshPath
    $psi.UseShellExecute = $false
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true

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
        [void]$psi.ArgumentList.Add($arg)
    }

    $observerProcess = [Diagnostics.Process]::new()
    $observerProcess.StartInfo = $psi
    Assert-Check ($observerProcess.Start()) 'RAW_UDP_OBSERVER_SSH_START_FAILED'
    $stderrDrain = $observerProcess.StandardError.ReadToEndAsync()
    $observerProcess.StandardInput.Write($remoteObserver)
    $observerProcess.StandardInput.Close()

    $readyLine = $observerProcess.StandardOutput.ReadLine()
    if ($readyLine -eq 'RAW_UDP_OBSERVER_READY=NO') {
        $errLine = $observerProcess.StandardOutput.ReadLine()
        if ($errLine -match '^RAW_UDP_OBSERVER_ERROR=[A-Z0-9_]+$') { Write-Output $errLine }
    }
    Assert-Check ($readyLine -eq 'RAW_UDP_OBSERVER_READY=YES') 'RAW_UDP_OBSERVER_NOT_READY'
    $observerReady = $true
    Write-Output 'RAW_UDP_OBSERVER_READY=YES'

    Start-Sleep -Milliseconds 300

    $udp = [Net.Sockets.UdpClient]::new()
    try {
        $udp.Connect($publicVpsIp, 8443)
        $payload = [Text.Encoding]::ASCII.GetBytes('G2B-RAW-UDP8443-PATH-CONTROL')
        $sent = $udp.Send($payload, $payload.Length)
        Assert-Check ($sent -eq $payload.Length) 'RAW_UDP_SEND_LENGTH_MISMATCH'
        Write-Output "RAW_UDP_WINDOWS_SEND_BYTES=$sent"
        Write-Output 'RAW_UDP_WINDOWS_SEND_CALL=PASS'
    }
    finally {
        $udp.Dispose()
    }

    if (-not $observerProcess.WaitForExit(20000)) {
        try { $observerProcess.Kill($true) } catch { }
        throw 'RAW_UDP_OBSERVER_TIMEOUT'
    }

    $tail = $observerProcess.StandardOutput.ReadToEnd()
    $seen = 'UNKNOWN'
    foreach ($line in @($tail -split "[\r\n]+" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })) {
        if ($line -match '^RAW_UDP_8443_VPS_INBOUND_SEEN=(YES|NO|ERROR)$') {
            $seen = $Matches[1]
        }
        elseif ($line -match '^RAW_UDP_OBSERVER_EXIT=\d+$') {
            Write-Output $line
        }
        elseif ($line -eq 'RAW_UDP_OBSERVER_PAYLOAD_CAPTURED=NO') {
            Write-Output $line
        }
    }

    Assert-Check ($observerProcess.ExitCode -eq 0) 'RAW_UDP_OBSERVER_REMOTE_FAILED'
    Assert-Check ($seen -in @('YES','NO')) 'RAW_UDP_OBSERVER_RESULT_INVALID'
    Write-Output "RAW_UDP_8443_VPS_INBOUND_SEEN=$seen"
    Write-Output 'RAW_UDP_PATH_CONTROL_COMPLETE=YES'
}
catch {
    $message = [string]$_.Exception.Message
    if ($message -match '^[A-Z][A-Z0-9_]*$') {
        Write-Output "RAW_UDP_CONTROL_RETURN_CODE=$message"
    }
    else {
        Write-Output "RAW_UDP_CONTROL_RETURN_ERROR_CLASS=$($_.Exception.GetType().Name)"
    }
}
finally {
    try {
        if ($null -ne $observerProcess) {
            if (-not $observerProcess.HasExited) {
                $observerProcess.Kill($true)
                [void]$observerProcess.WaitForExit(10000)
            }
            $observerProcess.Dispose()
            $observerProcess = $null
        }
        Write-Output 'RAW_UDP_OBSERVER_STOPPED=YES'
    }
    catch {
        Add-CleanupFailure 'RAW_UDP_OBSERVER_STOP_FAILED'
    }

    try {
        $routes = Get-ExactRoute
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
        Assert-Check ((Get-ExactRoute).Count -eq 0) 'OWNER_ROUTE_STILL_PRESENT'
        Write-Output 'FINAL_OWNER_TEMP_ROUTE_ABSENT=YES'
    }
    catch {
        Add-CleanupFailure 'FINAL_OWNER_ROUTE_CLEANUP_FAILED'
    }

    try {
        $wgManagerFinal = Get-Service -Name 'WireGuardManager' -ErrorAction Stop
        $wgTunnelFinal = Get-Service -Name 'WireGuardTunnel$SFO2-A' -ErrorAction Stop
        $wgAdapterFinal = Get-NetAdapter -Name $wgAdapterName -ErrorAction Stop
        Assert-Check ($wgManagerFinal.Status -eq 'Running') 'FINAL_WG_MANAGER_NOT_RUNNING'
        Assert-Check ($wgTunnelFinal.Status -eq 'Running') 'FINAL_WG_TUNNEL_NOT_RUNNING'
        Assert-Check ($wgAdapterFinal.Status -eq 'Up' -and [int]$wgAdapterFinal.InterfaceIndex -eq 13) 'FINAL_WG_ADAPTER_INVALID'
        Assert-Check ((Get-PublicExit) -eq $publicVpsIp) 'FINAL_PUBLIC_EXIT_INVALID'
        Write-Output 'FINAL_PRODUCTION_WIREGUARD=RESTORED'
    }
    catch {
        Add-CleanupFailure 'FINAL_WIREGUARD_READBACK_FAILED'
    }
}

Write-Output "CLEANUP_FAILURE_COUNT=$($cleanupFailures.Count)"
if ($cleanupFailures.Count -gt 0) {
    Write-Output 'OWNER_RAW_UDP_CONTROL_RESULT=RETURN_TO_REVIEWER'
    exit 1
}
Write-Output 'OWNER_RAW_UDP_CONTROL_RESULT=COMPLETE'
exit 0
