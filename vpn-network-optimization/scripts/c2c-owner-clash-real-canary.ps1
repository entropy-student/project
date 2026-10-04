[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$PSNativeCommandUseErrorActionPreference = $false

$script:phase = 'START'
$script:startedAt = [DateTimeOffset]::UtcNow
Write-Output ('ROUND_STARTED_AT=' + $script:startedAt.ToString('o'))

$script:routePrefix = '24.199.118.137/32'
$script:secretHelper = Join-Path $PSScriptRoot 'c2c-secret-profile-helper.ps1'
$script:proxyProbe = Join-Path $PSScriptRoot 'c2c-bounded-proxy-probe.ps1'
$script:profileStoreRoot = $null
$script:profileBefore = $null
$script:baselineState = $null
$script:profilePath = $null
$script:proxyPort = $null
$script:routeCreated = $false
$script:routeIfIndex = $null
$script:routeNextHop = $null
$script:secretCleanupPassed = $false
$script:realCanaryPassed = $false
$script:failureClass = 'NONE'
$script:cleanupFailures = [Collections.Generic.List[string]]::new()

function Assert-C2C {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
}

function Test-HighIntegrity {
    $groups = (& whoami.exe /groups 2>&1) -join [Environment]::NewLine
    $match = [regex]::Match($groups, 'S-1-16-(\d+)')
    return ($match.Success -and [int]$match.Groups[1].Value -ge 12288)
}

function Get-TunCount {
    return @(
        Get-NetAdapter -IncludeHidden -ErrorAction Stop |
        Where-Object {
            $_.Status -eq 'Up' -and
            $_.Name -cne 'SFO2-A' -and
            $_.InterfaceDescription -notmatch '(?i)WireGuard' -and
            ($_.Name -match '(?i)(?:mihomo|clash|tun)' -or
             $_.InterfaceDescription -match '(?i)(?:mihomo|clash|tun)')
        }
    ).Count
}

function Get-RouteSnapshot {
    return @(
        Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -ErrorAction Stop |
        ForEach-Object {
            '{0}|{1}|{2}|{3}' -f $_.DestinationPrefix, $_.NextHop, $_.InterfaceIndex, $_.RouteMetric
        } |
        Sort-Object
    )
}

function Get-State {
    $manager = Get-Service -Name 'WireGuardManager' -ErrorAction Stop
    $tunnel = Get-Service -Name 'WireGuardTunnel$SFO2-A' -ErrorAction Stop
    $wg = @(Get-NetAdapter -Name 'SFO2-A' -ErrorAction Stop)
    Assert-C2C ($wg.Count -eq 1) 'WIREGUARD_ADAPTER_CARDINALITY_INVALID'
    $clash = Get-Service -Name 'clash_verge_service' -ErrorAction Stop
    $internet = Get-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -ErrorAction Stop
    Assert-C2C ($null -ne $internet.PSObject.Properties['ProxyEnable']) 'SYSTEM_PROXY_STATE_MISSING'

    return [pscustomobject]@{
        Manager = [string]$manager.Status
        Tunnel = [string]$tunnel.Status
        Adapter = [string]$wg[0].Status
        WgIfIndex = [int]$wg[0].InterfaceIndex
        Clash = [string]$clash.Status
        ProxyEnable = [int]$internet.ProxyEnable
        TunCount = Get-TunCount
        Routes = Get-RouteSnapshot
    }
}

function Assert-SafeState {
    param([object]$State)
    Assert-C2C ($State.Manager -ceq 'Running') 'WIREGUARD_MANAGER_NOT_RUNNING'
    Assert-C2C ($State.Tunnel -ceq 'Running') 'WIREGUARD_TUNNEL_NOT_RUNNING'
    Assert-C2C ($State.Adapter -ceq 'Up') 'WIREGUARD_ADAPTER_NOT_UP'
    Assert-C2C ($State.Clash -ceq 'Running') 'CLASH_VERGE_SERVICE_NOT_RUNNING'
    Assert-C2C ($State.ProxyEnable -eq 0) 'SYSTEM_PROXY_NOT_OFF'
    Assert-C2C ($State.TunCount -eq 0) 'CLASH_TUN_NOT_OFF'
}

function Assert-SameState {
    param([object]$Before, [object]$After)
    Assert-C2C ($Before.Manager -ceq $After.Manager) 'WIREGUARD_MANAGER_CHANGED'
    Assert-C2C ($Before.Tunnel -ceq $After.Tunnel) 'WIREGUARD_TUNNEL_CHANGED'
    Assert-C2C ($Before.Adapter -ceq $After.Adapter) 'WIREGUARD_ADAPTER_CHANGED'
    Assert-C2C ($Before.WgIfIndex -eq $After.WgIfIndex) 'WIREGUARD_IFINDEX_CHANGED'
    Assert-C2C ($Before.Clash -ceq $After.Clash) 'CLASH_SERVICE_CHANGED'
    Assert-C2C ($Before.ProxyEnable -eq $After.ProxyEnable) 'SYSTEM_PROXY_CHANGED'
    Assert-C2C ($Before.TunCount -eq $After.TunCount) 'TUN_STATE_CHANGED'
    Assert-C2C (($Before.Routes -join [Environment]::NewLine) -ceq ($After.Routes -join [Environment]::NewLine)) 'ROUTE_SNAPSHOT_CHANGED'
}

function Resolve-ProfileStore {
    $roaming = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData)
    Assert-C2C (-not [string]::IsNullOrWhiteSpace($roaming)) 'CLASH_PROFILE_STORE_ROOT_UNAVAILABLE'
    $roots = @(Get-ChildItem -LiteralPath $roaming -Directory -Force -ErrorAction Stop |
        Where-Object { $_.Name -match '(?i)(?:clash.*verge|verge.*clash)' })
    $stores = @($roots | ForEach-Object { Join-Path $_.FullName 'profiles' } |
        Where-Object { Test-Path -LiteralPath $_ -PathType Container })
    Assert-C2C ($stores.Count -eq 1) 'CLASH_PROFILE_STORE_AMBIGUOUS'
    return (Resolve-Path -LiteralPath $stores[0] -ErrorAction Stop).Path
}

function Get-ProfileSnapshot {
    param([string]$Root)
    $snapshot = [Collections.Generic.SortedDictionary[string,string]]::new([StringComparer]::OrdinalIgnoreCase)
    $stack = [Collections.Generic.Stack[string]]::new()
    $stack.Push($Root)
    while ($stack.Count -gt 0) {
        $directory = $stack.Pop()
        foreach ($item in @(Get-ChildItem -LiteralPath $directory -Force -ErrorAction Stop)) {
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw 'CLASH_PROFILE_STORE_REPARSE_POINT_PRESENT' }
            $relative = [IO.Path]::GetRelativePath($Root, $item.FullName).Replace('\','/')
            if ($item.PSIsContainer) {
                $snapshot.Add($relative, 'DIRECTORY')
                $stack.Push($item.FullName)
            }
            else {
                $snapshot.Add($relative, (Get-FileHash -LiteralPath $item.FullName -Algorithm SHA256 -ErrorAction Stop).Hash)
            }
        }
    }
    return ,$snapshot
}

function Test-SnapshotSame {
    param(
        [Collections.Generic.SortedDictionary[string,string]]$Before,
        [Collections.Generic.SortedDictionary[string,string]]$After
    )
    if ($Before.Count -ne $After.Count) { return $false }
    foreach ($key in $Before.Keys) {
        if (-not $After.ContainsKey($key) -or $Before[$key] -cne $After[$key]) { return $false }
    }
    return $true
}

function Resolve-LocalProxyPort {
    $internet = Get-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -ErrorAction Stop
    Assert-C2C ($null -ne $internet.PSObject.Properties['ProxyServer']) 'CLASH_LOCAL_PROXY_METADATA_MISSING'
    $value = [string]$internet.ProxyServer
    Assert-C2C (-not [string]::IsNullOrWhiteSpace($value)) 'CLASH_LOCAL_PROXY_METADATA_MISSING'
    $matches = [regex]::Matches($value, '(?i)(?:127\.0\.0\.1|localhost):(?<p>\d{2,5})')
    $ports = @($matches | ForEach-Object { [int]$_.Groups['p'].Value } | Sort-Object -Unique)
    Assert-C2C ($ports.Count -eq 1) 'CLASH_LOCAL_PROXY_PORT_AMBIGUOUS'
    Assert-C2C ($ports[0] -ge 1024 -and $ports[0] -le 65535) 'CLASH_LOCAL_PROXY_PORT_INVALID'
    return [int]$ports[0]
}

function Assert-LocalProxyListener {
    param([int]$Port)
    $listeners = @(Get-NetTCPConnection -State Listen -LocalPort $Port -ErrorAction SilentlyContinue)
    Assert-C2C ($listeners.Count -gt 0) 'CLASH_LOCAL_PROXY_LISTENER_MISSING'
    $owned = $false
    foreach ($listener in $listeners) {
        try {
            $process = Get-Process -Id $listener.OwningProcess -ErrorAction Stop
            if ($process.ProcessName -match '(?i)(?:mihomo|clash)') { $owned = $true; break }
        }
        catch { }
    }
    Assert-C2C $owned 'CLASH_LOCAL_PROXY_LISTENER_OWNER_INVALID'
}

function Get-ExactRoute {
    try {
        return ,@(Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -DestinationPrefix $script:routePrefix -ErrorAction Stop)
    }
    catch {
        if ($_.CategoryInfo.Category -eq [System.Management.Automation.ErrorCategory]::ObjectNotFound -and
            $_.FullyQualifiedErrorId -eq 'CmdletizationQuery_NotFound,Get-NetRoute') { return ,@() }
        throw
    }
}

function Get-PersistentRoute {
    try {
        return ,@(Get-NetRoute -AddressFamily IPv4 -PolicyStore PersistentStore -DestinationPrefix $script:routePrefix -ErrorAction Stop)
    }
    catch {
        if ($_.CategoryInfo.Category -eq [System.Management.Automation.ErrorCategory]::ObjectNotFound -and
            $_.FullyQualifiedErrorId -eq 'CmdletizationQuery_NotFound,Get-NetRoute') { return ,@() }
        throw
    }
}

function Resolve-PhysicalEgress {
    param([int]$WireGuardIfIndex)
    $defaults = @(Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -DestinationPrefix '0.0.0.0/0' -ErrorAction Stop)
    $candidates = [Collections.Generic.List[object]]::new()
    foreach ($route in $defaults) {
        $ifIndex = [int]$route.InterfaceIndex
        $nextHop = [string]$route.NextHop
        if ($ifIndex -eq $WireGuardIfIndex) { continue }
        if ([string]::IsNullOrWhiteSpace($nextHop) -or $nextHop -eq '0.0.0.0') { continue }
        $adapter = @(Get-NetAdapter -InterfaceIndex $ifIndex -ErrorAction SilentlyContinue)
        if ($adapter.Count -ne 1 -or $adapter[0].Status -ne 'Up') { continue }
        if ($adapter[0].Name -match '(?i)(?:wireguard|clash|mihomo|tun|loopback|wsl|vmware|virtualbox|hyper-v)' -or
            $adapter[0].InterfaceDescription -match '(?i)(?:wireguard|clash|mihomo|tun|loopback|wsl|vmware|virtualbox|hyper-v)') { continue }
        $config = Get-NetIPConfiguration -InterfaceIndex $ifIndex -ErrorAction SilentlyContinue
        if ($null -eq $config) { continue }
        $gateways = @($config.IPv4DefaultGateway | ForEach-Object { [string]$_.NextHop })
        $addresses = @($config.IPv4Address | ForEach-Object { [string]$_.IPAddress })
        if ($gateways -notcontains $nextHop -or $addresses.Count -eq 0) { continue }
        $interfaces = @(Get-NetIPInterface -AddressFamily IPv4 -InterfaceIndex $ifIndex -ErrorAction SilentlyContinue)
        if ($interfaces.Count -lt 1) { continue }
        $candidates.Add([pscustomobject]@{
            InterfaceIndex = $ifIndex
            NextHop = $nextHop
            Score = ([int]$route.RouteMetric + [int]$interfaces[0].InterfaceMetric)
        })
    }
    Assert-C2C ($candidates.Count -gt 0) 'PHYSICAL_EGRESS_NOT_FOUND'
    $ordered = @($candidates | Sort-Object Score, InterfaceIndex, NextHop)
    if ($ordered.Count -gt 1 -and $ordered[0].Score -eq $ordered[1].Score) { throw 'PHYSICAL_EGRESS_AMBIGUOUS' }
    return $ordered[0]
}

function Add-TempRoute {
    param([int]$InterfaceIndex, [string]$NextHop)
    Assert-C2C ((Get-ExactRoute).Count -eq 0) 'OWNER_ROUTE_ALREADY_PRESENT'
    Assert-C2C ((Get-PersistentRoute).Count -eq 0) 'PERSISTENT_OWNER_ROUTE_UNEXPECTED'
    New-NetRoute -AddressFamily IPv4 -DestinationPrefix $script:routePrefix -InterfaceIndex $InterfaceIndex -NextHop $NextHop -RouteMetric 1 -PolicyStore ActiveStore -ErrorAction Stop | Out-Null
    $routes = Get-ExactRoute
    Assert-C2C ($routes.Count -eq 1) 'OWNER_ROUTE_CREATE_CARDINALITY_INVALID'
    Assert-C2C ([int]$routes[0].InterfaceIndex -eq $InterfaceIndex) 'OWNER_ROUTE_CREATE_INTERFACE_INVALID'
    Assert-C2C ([string]$routes[0].NextHop -ceq $NextHop) 'OWNER_ROUTE_CREATE_NEXTHOP_INVALID'
    $script:routeCreated = $true
    $script:routeIfIndex = $InterfaceIndex
    $script:routeNextHop = $NextHop
}

function Remove-TempRoute {
    if (-not $script:routeCreated) { return }
    $routes = Get-ExactRoute
    Assert-C2C ($routes.Count -eq 1) 'OWNER_ROUTE_CLEANUP_CARDINALITY_INVALID'
    Assert-C2C ([int]$routes[0].InterfaceIndex -eq [int]$script:routeIfIndex) 'OWNER_ROUTE_CLEANUP_INTERFACE_INVALID'
    Assert-C2C ([string]$routes[0].NextHop -ceq [string]$script:routeNextHop) 'OWNER_ROUTE_CLEANUP_NEXTHOP_INVALID'
    Remove-NetRoute -InputObject $routes[0] -Confirm:$false -ErrorAction Stop
    Assert-C2C ((Get-ExactRoute).Count -eq 0) 'OWNER_ROUTE_STILL_PRESENT'
    $script:routeCreated = $false
}

function Invoke-SecretHelper {
    param([ValidateSet('Prepare','VerifyCleanup')][string]$Mode)
    $pwsh = (Get-Command pwsh.exe -ErrorAction Stop).Source
    if ($Mode -eq 'Prepare') {
        $output = @(& $pwsh -NoProfile -File $script:secretHelper -Prepare 2>&1)
    }
    else {
        $output = @(& $pwsh -NoProfile -File $script:secretHelper -VerifyCleanup -ProfilePath $script:profilePath 2>&1)
    }
    $exitCode = $LASTEXITCODE
    foreach ($line in $output) { Write-Output $line }
    Assert-C2C ($exitCode -eq 0) ('C2C_SECRET_HELPER_' + $Mode.ToUpperInvariant() + '_FAILED')
    return ,$output
}

function Require-Markers {
    param([object[]]$Output, [string[]]$Markers, [string]$Prefix)
    $text = $Output -join [Environment]::NewLine
    foreach ($marker in $Markers) {
        Assert-C2C ($text -match [regex]::Escape($marker)) ($Prefix + '_MARKER_MISSING')
    }
}

function Add-CleanupFailure {
    param([string]$Code)
    $script:cleanupFailures.Add($Code)
    Write-Output ('C2C_CLEANUP_FAILED=' + $Code)
}

try {
    $script:phase = 'PREFLIGHT'
    Assert-C2C ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
    Assert-C2C (Test-HighIntegrity) 'HIGH_INTEGRITY_REQUIRED'
    $principal = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
    Assert-C2C ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 'ADMINISTRATOR_REQUIRED'
    Assert-C2C (Test-Path -LiteralPath $script:secretHelper -PathType Leaf) 'C2C_SECRET_HELPER_MISSING'
    Assert-C2C (Test-Path -LiteralPath $script:proxyProbe -PathType Leaf) 'C2C_PROXY_PROBE_MISSING'

    $script:baselineState = Get-State
    Assert-SafeState -State $script:baselineState
    Assert-C2C ((Get-ExactRoute).Count -eq 0) 'OWNER_ROUTE_ALREADY_PRESENT'
    Assert-C2C ((Get-PersistentRoute).Count -eq 0) 'PERSISTENT_OWNER_ROUTE_UNEXPECTED'

    $egress = Resolve-PhysicalEgress -WireGuardIfIndex $script:baselineState.WgIfIndex
    $script:proxyPort = Resolve-LocalProxyPort
    Assert-LocalProxyListener -Port $script:proxyPort
    $script:profileStoreRoot = Resolve-ProfileStore
    $script:profileBefore = Get-ProfileSnapshot -Root $script:profileStoreRoot

    Write-Output 'C2C_PREFLIGHT=PASS'
    Write-Output 'WIREGUARD_CONNECTED=YES'
    Write-Output 'SYSTEM_PROXY=OFF'
    Write-Output 'TUN=OFF'
    Write-Output 'PHYSICAL_EGRESS_RESOLVED=PASS'
    Write-Output 'CLASH_LOCAL_PROXY_LISTENER=PASS'
    Write-Output 'CLASH_PROFILE_STORE_BASELINE=PASS'

    $script:phase = 'SECRET_PROFILE_PREPARE'
    $prepareOutput = Invoke-SecretHelper -Mode Prepare
    Require-Markers -Output $prepareOutput -Prefix 'C2C_SECRET_PREPARE' -Markers @(
        'DPAPI_UNPROTECT=PASS',
        'REAL_HY2_AUTH_FORMAT=PASS',
        'CERTIFICATE_FINGERPRINT_MATCH=PASS',
        'CLASH_REAL_AUTH_PREEXISTING=NO',
        'OWNER_ONLY_REAL_PROFILE=PASS',
        'MIHOMO_REAL_PROFILE_PARSE=PASS',
        'C2C_SECRET_PREPARE=PASS',
        'SECRET_VALUES_EMITTED=0'
    )
    $paths = @($prepareOutput | ForEach-Object { [string]$_ } | Where-Object { $_ -like 'TEMP_REAL_PROFILE_PATH=*' })
    Assert-C2C ($paths.Count -eq 1) 'TEMP_REAL_PROFILE_PATH_CARDINALITY_INVALID'
    $script:profilePath = $paths[0].Substring('TEMP_REAL_PROFILE_PATH='.Length)
    Assert-C2C (Test-Path -LiteralPath $script:profilePath -PathType Leaf) 'TEMP_REAL_PROFILE_MISSING'

    Write-Output 'OWNER_UI_STEP_1=Import and activate only TEMP_REAL_PROFILE_PATH. Confirm SELF-VPN-C2C, WG-BASELINE and HY2-SFO3-REAL are visible. Keep WG-BASELINE selected. Keep system proxy OFF and TUN OFF. Do not select HY2 yet.'
    Write-Output ('TEMP_REAL_PROFILE_PATH=' + $script:profilePath)
    $expected1 = 'C2C_IMPORT_ACK|IMPORT=YES|PROFILE_ACTIVE=YES|WG_VISIBLE=YES|HY2_REAL_VISIBLE=YES|SELECTOR_VISIBLE=YES|CURRENT=WG-BASELINE|SYSTEM_PROXY=OFF|TUN=OFF'
    $ack1 = Read-Host ('Type exact acknowledgement: ' + $expected1)
    Assert-C2C ($ack1 -ceq $expected1) 'C2C_IMPORT_ACK_INVALID'

    $script:phase = 'POST_IMPORT_READBACK'
    $postImport = Get-State
    Assert-SafeState -State $postImport
    Assert-SameState -Before $script:baselineState -After $postImport
    Assert-LocalProxyListener -Port $script:proxyPort
    $during = Get-ProfileSnapshot -Root $script:profileStoreRoot
    Assert-C2C (-not (Test-SnapshotSame -Before $script:profileBefore -After $during)) 'C2C_PROFILE_IMPORT_NOT_OBSERVED'
    $during.Clear()
    Write-Output 'C2C_IMPORT_READBACK=PASS'

    $script:phase = 'CREATE_TEMP_OUTER_ROUTE'
    Add-TempRoute -InterfaceIndex $egress.InterfaceIndex -NextHop $egress.NextHop
    $withRoute = Get-State
    Assert-SafeState -State $withRoute
    Write-Output 'C2C_TEMP_OUTER_ROUTE=PASS'

    Write-Output 'OWNER_UI_STEP_2=In SELF-VPN-C2C select HY2-SFO3-REAL. Keep system proxy OFF and TUN OFF. Do not run any delay test or other traffic.'
    $expected2 = 'C2C_HY2_ACK|CURRENT=HY2-SFO3-REAL|SYSTEM_PROXY=OFF|TUN=OFF'
    $ack2 = Read-Host ('Type exact acknowledgement: ' + $expected2)
    Assert-C2C ($ack2 -ceq $expected2) 'C2C_HY2_ACK_INVALID'

    $script:phase = 'REAL_HY2_CANARY'
    $hy2State = Get-State
    Assert-SafeState -State $hy2State
    Assert-LocalProxyListener -Port $script:proxyPort

    $pwsh = (Get-Command pwsh.exe -ErrorAction Stop).Source
    $probeOutput = @(& $pwsh -NoProfile -File $script:proxyProbe -ProxyPort $script:proxyPort 2>&1)
    $probeExit = $LASTEXITCODE
    foreach ($line in $probeOutput) { Write-Output $line }
    Assert-C2C ($probeExit -eq 0) 'C2C_BOUNDED_PROXY_PROBE_FAILED'
    Require-Markers -Output $probeOutput -Prefix 'C2C_PROXY_PROBE' -Markers @(
        'C2C_OPENAI_CURL_EXIT=0',
        'C2C_OPENAI_HTTP_STATUS=401',
        'C2C_OPENAI_PROXY_USED=1',
        'C2C_PUBLIC_EXIT=EXPECTED_SFO3',
        'REAL_CANARY_REQUEST_COUNT=2',
        'C2C_BOUNDED_PROXY_PROBE=PASS'
    )
    $script:realCanaryPassed = $true
    Write-Output 'REAL_HY2_IN_CLASH_CANARY=PASS'

    Write-Output 'OWNER_UI_STEP_3=Switch SELF-VPN-C2C back to WG-BASELINE, then remove only the unique C2C profile. Keep system proxy OFF and TUN OFF.'
    $expected3 = 'C2C_CLEANUP_ACK|CURRENT_BEFORE_REMOVE=WG-BASELINE|PROFILE_REMOVED=YES|SYSTEM_PROXY=OFF|TUN=OFF'
    $ack3 = Read-Host ('Type exact acknowledgement: ' + $expected3)
    Assert-C2C ($ack3 -ceq $expected3) 'C2C_CLEANUP_ACK_INVALID'

    $script:phase = 'POST_UI_CLEANUP'
    $afterProfiles = Get-ProfileSnapshot -Root $script:profileStoreRoot
    Assert-C2C (Test-SnapshotSame -Before $script:profileBefore -After $afterProfiles) 'CLASH_PROFILE_STORE_RESIDUE_OR_CHANGED'
    $afterProfiles.Clear()

    $cleanupOutput = Invoke-SecretHelper -Mode VerifyCleanup
    Require-Markers -Output $cleanupOutput -Prefix 'C2C_SECRET_CLEANUP' -Markers @(
        'CLASH_REAL_AUTH_RESIDUE=ABSENT',
        'PROJECT_RUNTIME_REAL_AUTH_RESIDUE=ABSENT',
        'REAL_PROFILE_RUNTIME_CLEANUP=PASS',
        'C2C_SECRET_CLEANUP_VERIFY=PASS',
        'SECRET_VALUES_EMITTED=0'
    )
    $script:secretCleanupPassed = $true

    Remove-TempRoute
    Write-Output 'C2C_TEMP_OUTER_ROUTE_REMOVED=YES'

    $finalState = Get-State
    Assert-SafeState -State $finalState
    Assert-SameState -Before $script:baselineState -After $finalState
    Write-Output 'CLASH_PROFILE_STORE_POSTREMOVE=PASS'
    Write-Output 'POST_C2C_NETWORK_READBACK=PASS'
}
catch {
    $script:failureClass = $_.Exception.GetType().Name
    $safe = [string]$_.Exception.Message
    Write-Output ('C2C_FAILED_PHASE=' + $script:phase)
    Write-Output ('C2C_FAILURE_CLASS=' + $script:failureClass)
    if ($safe -cmatch '^[A-Z][A-Z0-9_]{1,95}$') { Write-Output ('C2C_FAILURE_CODE=' + $safe) }
    else { Write-Output 'C2C_FAILURE_CODE=UNCLASSIFIED' }
}
finally {
    $script:completionPhase = $script:phase
    $script:phase = 'CLEANUP'

    try {
        if ($script:routeCreated) { Remove-TempRoute }
        Assert-C2C ((Get-ExactRoute).Count -eq 0) 'FINAL_OWNER_ROUTE_PRESENT'
        Write-Output 'FINAL_C2C_TEMP_ROUTE_ABSENT=YES'
    }
    catch { Add-CleanupFailure 'FINAL_OWNER_ROUTE_CLEANUP_FAILED' }

    if ($null -ne $script:profilePath -and -not $script:secretCleanupPassed) {
        try {
            $fallbackOutput = Invoke-SecretHelper -Mode VerifyCleanup
            Require-Markers -Output $fallbackOutput -Prefix 'C2C_FALLBACK_SECRET_CLEANUP' -Markers @(
                'CLASH_REAL_AUTH_RESIDUE=ABSENT',
                'PROJECT_RUNTIME_REAL_AUTH_RESIDUE=ABSENT',
                'REAL_PROFILE_RUNTIME_CLEANUP=PASS',
                'C2C_SECRET_CLEANUP_VERIFY=PASS',
                'SECRET_VALUES_EMITTED=0'
            )
            $script:secretCleanupPassed = $true
        }
        catch { Add-CleanupFailure 'FINAL_SECRET_CLEANUP_VERIFY_FAILED' }
    }

    try {
        if ($null -ne $script:profileBefore -and $null -ne $script:profileStoreRoot) {
            $finalProfiles = Get-ProfileSnapshot -Root $script:profileStoreRoot
            Assert-C2C (Test-SnapshotSame -Before $script:profileBefore -After $finalProfiles) 'FINAL_CLASH_PROFILE_STORE_MISMATCH'
            $finalProfiles.Clear()
            Write-Output 'FINAL_CLASH_PROFILE_STORE_BASELINE=RESTORED'
        }
    }
    catch { Add-CleanupFailure 'FINAL_CLASH_PROFILE_STORE_READBACK_FAILED' }

    try {
        if ($null -ne $script:baselineState) {
            $final = Get-State
            Assert-SafeState -State $final
            Assert-SameState -Before $script:baselineState -After $final
            Write-Output 'FINAL_PRODUCTION_WIREGUARD=RESTORED'
            Write-Output 'FINAL_SYSTEM_PROXY=OFF'
            Write-Output 'FINAL_TUN=OFF'
            Write-Output 'FINAL_ROUTE_SNAPSHOT=RESTORED'
        }
    }
    catch { Add-CleanupFailure 'FINAL_NETWORK_READBACK_FAILED' }

    if ($null -ne $script:profileBefore) { $script:profileBefore.Clear(); $script:profileBefore = $null }

    $secretCleanupSatisfied = ($null -eq $script:profilePath -or $script:secretCleanupPassed)
    $cleanupPass = ($script:cleanupFailures.Count -eq 0 -and $secretCleanupSatisfied)
    Write-Output ('C2C_SECRET_CLEANUP=' + $(if ($script:secretCleanupPassed) { 'PASS' } elseif ($null -eq $script:profilePath) { 'NOT_REQUIRED' } else { 'FAIL' }))
    Write-Output ('REAL_HY2_CANARY_PASSED=' + $(if ($script:realCanaryPassed) { 'YES' } else { 'NO' }))
    Write-Output ('C2C_CLEANUP=' + $(if ($cleanupPass) { 'PASS' } else { 'FAIL' }))
    if ($script:cleanupFailures.Count -gt 0) {
        Write-Output ('C2C_CLEANUP_FAILURE_CLASS=' + (($script:cleanupFailures | Sort-Object -Unique) -join ','))
    }
    Write-Output 'SECRET_VALUES_EMITTED=0'

    $finishedAt = [DateTimeOffset]::UtcNow
    $elapsed = $finishedAt - $script:startedAt
    Write-Output ('ROUND_FINISHED_AT=' + $finishedAt.ToString('o'))
    Write-Output ('ACTUAL_ELAPSED=' + $elapsed.ToString('c'))
    Write-Output ('TIME_OVERRUN=' + $(if ($elapsed -gt [TimeSpan]::FromMinutes(20)) { 'YES' } else { 'NO' }))
    Write-Output ('TIME_OVERRUN_PHASE=' + $script:completionPhase)
    $script:finalExit = $(if ($cleanupPass -and $script:failureClass -ceq 'NONE' -and $script:realCanaryPassed) { 0 } else { 1 })
}

if ($script:finalExit -ne 0) { exit 1 }
Write-Output 'C2C_OWNER_CHECKPOINT=COMPLETE'
exit 0
