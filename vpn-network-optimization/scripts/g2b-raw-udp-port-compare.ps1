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

function Send-RawUdpProbe {
    param([Parameter(Mandatory=$true)][int]$Port)

    $udp = [Net.Sockets.UdpClient]::new([Net.Sockets.AddressFamily]::InterNetwork)
    try {
        $bindEp = [Net.IPEndPoint]::new([Net.IPAddress]::Parse($script:wlanAddress), 0)
        $udp.Client.Bind($bindEp)
        $udp.Connect($script:publicVpsIp, $Port)

        $payload = [byte[]](0x47,0x32,0x42,0x50,0x52,0x4F,0x42)
        $sent = $udp.Send($payload, $payload.Length)
        Assert-Check ($sent -eq 7) "RAW_UDP_PORT_$($Port)_SEND_LENGTH_MISMATCH"

        $localEp = [Net.IPEndPoint]$udp.Client.LocalEndPoint
        Assert-Check ($localEp.Address.ToString() -eq $script:wlanAddress) "RAW_UDP_PORT_$($Port)_LOCAL_BIND_MISMATCH"

        Write-Output "RAW_UDP_PORT_$($Port)_WINDOWS_SEND_BYTES=$sent"
        Write-Output "RAW_UDP_PORT_$($Port)_LOCAL_ADDRESS=$($localEp.Address)"
        Write-Output "RAW_UDP_PORT_$($Port)_WINDOWS_SEND_CALL=PASS"
    }
    finally {
        $udp.Dispose()
    }
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
    Write-Output 'RAW_UDP_PORT_COMPARE_PREFLIGHT=PASS'

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
  echo "RAW_UDP_COMPARE_OBSERVER_READY=NO"
  echo "RAW_UDP_COMPARE_OBSERVER_ERROR=TCPDUMP_MISSING"
  exit 42
fi

p51820=''
p8443=''
cleanup() {
  if [ -n "$p51820" ]; then
    kill "$p51820" 2>/dev/null || true
    wait "$p51820" 2>/dev/null || true
  fi
  if [ -n "$p8443" ]; then
    kill "$p8443" 2>/dev/null || true
    wait "$p8443" 2>/dev/null || true
  fi
}
trap cleanup HUP INT TERM EXIT

# Probe payload is exactly 7 bytes, so UDP length is 15 bytes.
# This isolates the synthetic 51820 probe from ordinary WireGuard traffic
# without recording packet payload.
timeout 15 tcpdump -n -q -i eth0 -c 1 'udp dst port 51820 and udp[4:2] = 15' >/dev/null 2>&1 &
p51820=$!
timeout 15 tcpdump -n -q -i eth0 -c 1 'udp dst port 8443 and udp[4:2] = 15' >/dev/null 2>&1 &
p8443=$!

echo "RAW_UDP_COMPARE_OBSERVER_READY=YES"
set +e
wait "$p51820"
rc51820=$?
wait "$p8443"
rc8443=$?
set -e
p51820=''
p8443=''

case "$rc51820" in
  0) seen51820='YES' ;;
  124) seen51820='NO' ;;
  *) seen51820='ERROR' ;;
esac
case "$rc8443" in
  0) seen8443='YES' ;;
  124) seen8443='NO' ;;
  *) seen8443='ERROR' ;;
esac

echo "RAW_UDP_51820_VPS_INBOUND_SEEN=$seen51820"
echo "RAW_UDP_8443_VPS_INBOUND_SEEN=$seen8443"
echo "RAW_UDP_51820_OBSERVER_EXIT=$rc51820"
echo "RAW_UDP_8443_OBSERVER_EXIT=$rc8443"
echo "RAW_UDP_COMPARE_PAYLOAD_CAPTURED=NO"
trap - HUP INT TERM EXIT
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
    Assert-Check ($observerProcess.Start()) 'RAW_UDP_COMPARE_OBSERVER_SSH_START_FAILED'
    $stderrDrain = $observerProcess.StandardError.ReadToEndAsync()
    $observerProcess.StandardInput.Write($remoteObserver)
    $observerProcess.StandardInput.Close()

    $readyLine = $observerProcess.StandardOutput.ReadLine()
    if ($readyLine -eq 'RAW_UDP_COMPARE_OBSERVER_READY=NO') {
        $errLine = $observerProcess.StandardOutput.ReadLine()
        if ($errLine -match '^RAW_UDP_COMPARE_OBSERVER_ERROR=[A-Z0-9_]+$') { Write-Output $errLine }
    }
    Assert-Check ($readyLine -eq 'RAW_UDP_COMPARE_OBSERVER_READY=YES') 'RAW_UDP_COMPARE_OBSERVER_NOT_READY'
    Write-Output 'RAW_UDP_COMPARE_OBSERVER_READY=YES'

    Start-Sleep -Milliseconds 300
    Send-RawUdpProbe -Port 51820
    Start-Sleep -Milliseconds 150
    Send-RawUdpProbe -Port 8443

    if (-not $observerProcess.WaitForExit(20000)) {
        try { $observerProcess.Kill($true) } catch { }
        throw 'RAW_UDP_COMPARE_OBSERVER_TIMEOUT'
    }

    $tail = $observerProcess.StandardOutput.ReadToEnd()
    $seen51820 = 'UNKNOWN'
    $seen8443 = 'UNKNOWN'
    foreach ($line in @($tail -split "[\r\n]+" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })) {
        if ($line -match '^RAW_UDP_51820_VPS_INBOUND_SEEN=(YES|NO|ERROR)$') {
            $seen51820 = $Matches[1]
        }
        elseif ($line -match '^RAW_UDP_8443_VPS_INBOUND_SEEN=(YES|NO|ERROR)$') {
            $seen8443 = $Matches[1]
        }
        elseif ($line -match '^RAW_UDP_(51820|8443)_OBSERVER_EXIT=\d+$') {
            Write-Output $line
        }
        elseif ($line -eq 'RAW_UDP_COMPARE_PAYLOAD_CAPTURED=NO') {
            Write-Output $line
        }
    }

    Assert-Check ($observerProcess.ExitCode -eq 0) 'RAW_UDP_COMPARE_OBSERVER_REMOTE_FAILED'
    Assert-Check ($seen51820 -in @('YES','NO')) 'RAW_UDP_51820_OBSERVER_RESULT_INVALID'
    Assert-Check ($seen8443 -in @('YES','NO')) 'RAW_UDP_8443_OBSERVER_RESULT_INVALID'

    Write-Output "RAW_UDP_51820_VPS_INBOUND_SEEN=$seen51820"
    Write-Output "RAW_UDP_8443_VPS_INBOUND_SEEN=$seen8443"

    if ($seen51820 -eq 'YES' -and $seen8443 -eq 'NO') {
        Write-Output 'RAW_UDP_PORT_COMPARE_CLASSIFICATION=PORT_SPECIFIC_8443_FILTERING'
    }
    elseif ($seen51820 -eq 'YES' -and $seen8443 -eq 'YES') {
        Write-Output 'RAW_UDP_PORT_COMPARE_CLASSIFICATION=BOTH_PORTS_REACH_VPS'
    }
    elseif ($seen51820 -eq 'NO' -and $seen8443 -eq 'NO') {
        Write-Output 'RAW_UDP_PORT_COMPARE_CLASSIFICATION=RAW_CONTROL_PATH_NOT_REACHING_VPS'
    }
    else {
        Write-Output 'RAW_UDP_PORT_COMPARE_CLASSIFICATION=ASYMMETRIC_UNEXPECTED'
    }

    Write-Output 'RAW_UDP_PORT_COMPARE_COMPLETE=YES'
}
catch {
    $message = [string]$_.Exception.Message
    if ($message -match '^[A-Z][A-Z0-9_]*$') {
        Write-Output "RAW_UDP_PORT_COMPARE_RETURN_CODE=$message"
    }
    else {
        Write-Output "RAW_UDP_PORT_COMPARE_RETURN_ERROR_CLASS=$($_.Exception.GetType().Name)"
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
        Write-Output 'RAW_UDP_COMPARE_OBSERVER_STOPPED=YES'
    }
    catch {
        Add-CleanupFailure 'RAW_UDP_COMPARE_OBSERVER_STOP_FAILED'
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
    Write-Output 'OWNER_RAW_UDP_PORT_COMPARE_RESULT=RETURN_TO_REVIEWER'
    exit 1
}
Write-Output 'OWNER_RAW_UDP_PORT_COMPARE_RESULT=COMPLETE'
exit 0
