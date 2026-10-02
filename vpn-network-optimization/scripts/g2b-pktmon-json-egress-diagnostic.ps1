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

$pktmonPath = $null
$pktmonStarted = $false
$pktmonFilterAdded = $false
$diagnosticCompleted = $false
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
    Assert-Check ((Get-PublicExit) -eq $publicVpsIp) 'PUBLIC_EXIT_BASELINE_INVALID'

    $pktmonPath = (Get-Command pktmon.exe -ErrorAction Stop).Source

    $statusText = (& $pktmonPath status 2>&1 | Out-String).Trim()
    Assert-Check ($LASTEXITCODE -eq 0) 'PKTMON_STATUS_QUERY_FAILED'
    $statusLines = @($statusText -split "[\r\n]+" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    Assert-Check ($statusLines.Count -eq 1) 'PKTMON_ACTIVE_OR_STATUS_UNCLEAR'

    $filterText = (& $pktmonPath filter list 2>&1 | Out-String).Trim()
    Assert-Check ($LASTEXITCODE -eq 0) 'PKTMON_FILTER_LIST_FAILED'
    $filterLines = @($filterText -split "[\r\n]+" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    Assert-Check ($filterLines.Count -le 2) 'PKTMON_EXISTING_FILTERS_OR_UNCLEAR'

    Write-Output 'PKTMON_JSON_DIAGNOSTIC_PREFLIGHT=PASS'

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
    Write-Output 'VPS_EXACT_ROUTE_READBACK=WLAN_DIRECT'
    Write-Output 'RAW_UDP_SOCKET_BIND_TARGET=192.168.1.4'

    & $pktmonPath filter add 'G2B-RAW-UDP8443' -i $publicVpsIp -t UDP -p 8443 | Out-Null
    Assert-Check ($LASTEXITCODE -eq 0) 'PKTMON_FILTER_ADD_FAILED'
    $pktmonFilterAdded = $true

    & $pktmonPath start --capture --counters-only --comp all | Out-Null
    Assert-Check ($LASTEXITCODE -eq 0) 'PKTMON_START_FAILED'
    $pktmonStarted = $true

    & $pktmonPath reset | Out-Null
    Assert-Check ($LASTEXITCODE -eq 0) 'PKTMON_RESET_FAILED'
    Write-Output 'PKTMON_COMPONENT_SCOPE=ALL'
    Write-Output 'PKTMON_JSON_OBSERVER_READY=YES'

    $udp = [Net.Sockets.UdpClient]::new([Net.Sockets.AddressFamily]::InterNetwork)
    try {
        $bindEp = [Net.IPEndPoint]::new([Net.IPAddress]::Parse($wlanAddress), 0)
        $udp.Client.Bind($bindEp)
        $udp.Connect($publicVpsIp, 8443)
        $payload = [byte[]](0x47,0x32,0x42,0x50,0x52,0x4F,0x42)
        $sent = $udp.Send($payload, $payload.Length)
        Assert-Check ($sent -eq 7) 'RAW_UDP_8443_SEND_LENGTH_MISMATCH'
        $localEp = [Net.IPEndPoint]$udp.Client.LocalEndPoint
        Assert-Check ($localEp.Address.ToString() -eq $wlanAddress) 'RAW_UDP_8443_LOCAL_BIND_MISMATCH'
        Write-Output "RAW_UDP_8443_WINDOWS_SEND_BYTES=$sent"
        Write-Output "RAW_UDP_8443_LOCAL_ADDRESS=$($localEp.Address)"
        Write-Output 'RAW_UDP_8443_WINDOWS_SEND_CALL=PASS'
    }
    finally {
        $udp.Dispose()
    }

    Start-Sleep -Milliseconds 500

    $jsonText = (& $pktmonPath counters --type all --json 2>&1 | Out-String).Trim()
    Assert-Check ($LASTEXITCODE -eq 0) 'PKTMON_COUNTERS_JSON_FAILED'
    Assert-Check (-not [string]::IsNullOrWhiteSpace($jsonText)) 'PKTMON_COUNTERS_JSON_EMPTY'

    try {
        $null = $jsonText | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        throw 'PKTMON_COUNTERS_JSON_INVALID'
    }

    Write-Output 'PKTMON_COUNTERS_JSON_VALID=YES'
    Write-Output 'PKTMON_COUNTERS_JSON_BEGIN'
    Write-Output $jsonText
    Write-Output 'PKTMON_COUNTERS_JSON_END'

    & $pktmonPath stop | Out-Null
    Assert-Check ($LASTEXITCODE -eq 0) 'PKTMON_STOP_FAILED'
    $pktmonStarted = $false

    & $pktmonPath filter remove | Out-Null
    Assert-Check ($LASTEXITCODE -eq 0) 'PKTMON_FILTER_REMOVE_FAILED'
    $pktmonFilterAdded = $false
    Write-Output 'PKTMON_JSON_OBSERVER_STOPPED=YES'
    Write-Output 'PKTMON_PACKET_LOGGING=NO'
    Write-Output 'PKTMON_JSON_DIAGNOSTIC_COMPLETE=YES'
    $diagnosticCompleted = $true
}
catch {
    $message = [string]$_.Exception.Message
    if ($message -match '^[A-Z][A-Z0-9_]*$') {
        Write-Output "PKTMON_JSON_DIAGNOSTIC_RETURN_CODE=$message"
    }
    else {
        Write-Output "PKTMON_JSON_DIAGNOSTIC_RETURN_ERROR_CLASS=$($_.Exception.GetType().Name)"
    }
}
finally {
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
        Write-Output 'FINAL_PKTMON_STATE_CLEAN=YES'
    }
    catch {
        Add-CleanupFailure 'FINAL_PKTMON_CLEANUP_FAILED'
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

Write-Output "DIAGNOSTIC_COMPLETED=$diagnosticCompleted"
Write-Output "CLEANUP_FAILURE_COUNT=$($cleanupFailures.Count)"
if (-not $diagnosticCompleted -or $cleanupFailures.Count -gt 0) {
    Write-Output 'OWNER_PKTMON_JSON_DIAGNOSTIC_RESULT=RETURN_TO_REVIEWER'
    exit 1
}
Write-Output 'OWNER_PKTMON_JSON_DIAGNOSTIC_RESULT=COMPLETE'
exit 0
