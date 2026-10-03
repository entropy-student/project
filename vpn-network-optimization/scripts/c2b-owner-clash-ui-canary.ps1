[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$script:phase = 'START'
$script:roundStartedAt = [DateTimeOffset]::UtcNow
Write-Output ('ROUND_STARTED_AT=' + $script:roundStartedAt.ToString('o'))

$script:ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
$script:runtimeRoot = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'
$script:runtimeDirectory = $null
$script:runtimeConfigPath = $null
$script:markerPath = $null
$script:createdRuntimeRoot = $false
$script:createdRuntimeDirectory = $false
$script:markerCreated = $false
$script:configCreated = $false
$script:configTestOutput = $null
$script:failureClass = 'NONE'
$script:cleanupPassed = $false
$script:uiCleanupAcknowledged = $false
$script:cleanupErrors = [Collections.Generic.List[string]]::new()
$script:renderedText = $null
$script:configBytes = $null
$script:profileStoreRoot = $null
$script:profileSnapshotBefore = $null
$script:profileSnapshotAfter = $null

function Assert-C2B {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
}

function New-C2BOwnerAcl {
    param([switch]$Directory)
    if ($Directory) {
        $acl = [Security.AccessControl.DirectorySecurity]::new()
        $inheritance = [Security.AccessControl.InheritanceFlags]::ContainerInherit -bor
                       [Security.AccessControl.InheritanceFlags]::ObjectInherit
    }
    else {
        $acl = [Security.AccessControl.FileSecurity]::new()
        $inheritance = [Security.AccessControl.InheritanceFlags]::None
    }
    $acl.SetAccessRuleProtection($true, $false)
    $rule = [Security.AccessControl.FileSystemAccessRule]::new(
        $script:ownerSid,
        [Security.AccessControl.FileSystemRights]::FullControl,
        $inheritance,
        [Security.AccessControl.PropagationFlags]::None,
        [Security.AccessControl.AccessControlType]::Allow
    )
    [void]$acl.AddAccessRule($rule)
    return $acl
}

function Assert-C2BOwnerAclRules {
    param([object[]]$Rules, [switch]$Directory)
    if ($Rules.Count -eq 0) { throw 'OWNER_ACL_RULES_MISSING' }
    $direct = [long]0
    $container = [long]0
    $object = [long]0
    foreach ($rule in $Rules) {
        if ($rule.IsInherited) { throw 'OWNER_ACL_INHERITED_RULE_PRESENT' }
        $ruleSid = if ($rule.IdentityReference -is [Security.Principal.SecurityIdentifier]) {
            $rule.IdentityReference.Value
        }
        else {
            $rule.IdentityReference.Translate([Security.Principal.SecurityIdentifier]).Value
        }
        if ($ruleSid -ne $script:ownerSid.Value) { throw 'OWNER_ACL_UNAUTHORIZED_PRINCIPAL' }
        if ($rule.AccessControlType -ne [Security.AccessControl.AccessControlType]::Allow) {
            throw 'OWNER_ACL_DENY_RULE_PRESENT'
        }
        $rights = [long]$rule.FileSystemRights
        if (($rule.PropagationFlags -band [Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0) {
            $direct = $direct -bor $rights
        }
        if ($Directory) {
            if (($rule.InheritanceFlags -band [Security.AccessControl.InheritanceFlags]::ContainerInherit) -ne 0) { $container = $container -bor $rights }
            if (($rule.InheritanceFlags -band [Security.AccessControl.InheritanceFlags]::ObjectInherit) -ne 0) { $object = $object -bor $rights }
        }
        elseif ($rule.InheritanceFlags -ne [Security.AccessControl.InheritanceFlags]::None -or
                $rule.PropagationFlags -ne [Security.AccessControl.PropagationFlags]::None) {
            throw 'OWNER_ACL_FILE_FLAGS_INVALID'
        }
    }
    $full = [long][Security.AccessControl.FileSystemRights]::FullControl
    if (($direct -band $full) -ne $full) { throw 'OWNER_ACL_FULLCONTROL_MISSING' }
    if ($Directory -and ((($container -band $full) -ne $full) -or (($object -band $full) -ne $full))) {
        throw 'OWNER_ACL_CHILD_INHERITANCE_MISSING'
    }
}

function Assert-C2BOwnerAcl {
    param([string]$Path)
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    $acl = Get-Acl -LiteralPath $Path -ErrorAction Stop
    if (-not $acl.AreAccessRulesProtected) { throw 'OWNER_ACL_INHERITANCE_ENABLED' }
    $owner = ([Security.Principal.NTAccount]::new($acl.Owner)).Translate(
        [Security.Principal.SecurityIdentifier]
    ).Value
    if ($owner -ne $script:ownerSid.Value) { throw 'OWNER_ACL_OWNER_MISMATCH' }
    $rules = @($acl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier]))
    Assert-C2BOwnerAclRules -Rules $rules -Directory:$item.PSIsContainer
}

function Get-C2BState {
    $manager = Get-Service -Name 'WireGuardManager' -ErrorAction Stop
    $tunnel = Get-Service -Name 'WireGuardTunnel$SFO2-A' -ErrorAction Stop
    $wgAdapter = @(Get-NetAdapter -Name 'SFO2-A' -ErrorAction Stop)
    if ($wgAdapter.Count -ne 1) { throw 'WIREGUARD_ADAPTER_CARDINALITY_INVALID' }
    $proxy = Get-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -ErrorAction Stop
    if ($null -eq $proxy.PSObject.Properties['ProxyEnable']) { throw 'SYSTEM_PROXY_STATE_MISSING' }
    $proxyEnable = [int]$proxy.ProxyEnable
    $tun = @(Get-NetAdapter -IncludeHidden -ErrorAction Stop | Where-Object {
        $_.Status -eq 'Up' -and $_.Name -cne 'SFO2-A' -and
        $_.InterfaceDescription -notmatch '(?i)WireGuard' -and
        ($_.Name -match '(?i)(?:mihomo|clash|tun)' -or $_.InterfaceDescription -match '(?i)(?:mihomo|clash|tun)')
    })
    $routeSnapshot = @(Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -ErrorAction Stop | ForEach-Object {
        '{0}|{1}|{2}|{3}|{4}' -f $_.DestinationPrefix, $_.NextHop, $_.InterfaceIndex, $_.RouteMetric, $_.PolicyStore
    } | Sort-Object)
    return [pscustomobject]@{
        Manager = [string]$manager.Status
        Tunnel = [string]$tunnel.Status
        Adapter = [string]$wgAdapter[0].Status
        ProxyEnable = $proxyEnable
        TunUpCount = $tun.Count
        Routes = $routeSnapshot
    }
}

function Assert-C2BState {
    param([object]$State)
    if ($State.Manager -cne 'Running' -or $State.Tunnel -cne 'Running' -or $State.Adapter -cne 'Up') {
        throw 'WIREGUARD_BASELINE_INVALID'
    }
    if ($State.ProxyEnable -ne 0) { throw 'SYSTEM_PROXY_NOT_OFF' }
    if ($State.TunUpCount -ne 0) { throw 'CLASH_TUN_NOT_OFF' }
}

function Assert-C2BSameState {
    param([object]$Before, [object]$After)
    if ($Before.Manager -cne $After.Manager -or $Before.Tunnel -cne $After.Tunnel -or
        $Before.Adapter -cne $After.Adapter) { throw 'WIREGUARD_STATE_CHANGED' }
    if ($Before.ProxyEnable -ne $After.ProxyEnable) { throw 'SYSTEM_PROXY_CHANGED' }
    if ($Before.TunUpCount -ne $After.TunUpCount) { throw 'TUN_STATE_CHANGED' }
    if (($Before.Routes -join "`n") -cne ($After.Routes -join "`n")) { throw 'ROUTE_SNAPSHOT_CHANGED' }
}

function Write-C2BNewFile {
    param([string]$Path, [byte[]]$Bytes, [scriptblock]$OnCreate)
    $stream = [IO.File]::Open($Path, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
    try {
        if ($null -ne $OnCreate) { & $OnCreate }
        $stream.Write($Bytes, 0, $Bytes.Length)
        $stream.Flush($true)
    }
    finally { $stream.Dispose() }
}

function Resolve-C2BProfileStoreRoot {
    $roamingRoot = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData)
    if ([string]::IsNullOrWhiteSpace($roamingRoot) -or
        -not (Test-Path -LiteralPath $roamingRoot -PathType Container)) {
        throw 'CLASH_PROFILE_STORE_ROOT_UNAVAILABLE'
    }
    $applicationRoots = @(Get-ChildItem -LiteralPath $roamingRoot -Directory -Force -ErrorAction Stop |
        Where-Object { $_.Name -match '(?i)(?:clash.*verge|verge.*clash)' })
    $profileStores = @($applicationRoots | ForEach-Object {
        Join-Path $_.FullName 'profiles'
    } | Where-Object { Test-Path -LiteralPath $_ -PathType Container })
    if ($profileStores.Count -ne 1) { throw 'CLASH_PROFILE_STORE_AMBIGUOUS' }
    return (Resolve-Path -LiteralPath $profileStores[0] -ErrorAction Stop).Path
}

function Get-C2BProfileSnapshot {
    param([string]$Root)
    $snapshot = [Collections.Generic.SortedDictionary[string,string]]::new([StringComparer]::OrdinalIgnoreCase)
    $pending = [Collections.Generic.Stack[string]]::new()
    $pending.Push($Root)
    while ($pending.Count -gt 0) {
        $directory = $pending.Pop()
        foreach ($item in @(Get-ChildItem -LiteralPath $directory -Force -ErrorAction Stop)) {
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw 'CLASH_PROFILE_STORE_REPARSE_POINT_PRESENT'
            }
            $relative = [IO.Path]::GetRelativePath($Root, $item.FullName).Replace('\', '/')
            if ($item.PSIsContainer) {
                $snapshot.Add($relative, 'DIRECTORY')
                $pending.Push($item.FullName)
            }
            else {
                $hash = (Get-FileHash -LiteralPath $item.FullName -Algorithm SHA256 -ErrorAction Stop).Hash
                $snapshot.Add($relative, $hash)
            }
        }
    }
    return ,$snapshot
}

function Assert-C2BProfileSnapshotUnchanged {
    param(
        [Collections.Generic.SortedDictionary[string,string]]$Before,
        [Collections.Generic.SortedDictionary[string,string]]$After
    )
    if ($Before.Count -ne $After.Count) { throw 'CLASH_PROFILE_STORE_RESIDUE_OR_CHANGED' }
    foreach ($key in $Before.Keys) {
        if (-not $After.ContainsKey($key) -or $Before[$key] -cne $After[$key]) {
            throw 'CLASH_PROFILE_STORE_RESIDUE_OR_CHANGED'
        }
    }
}

try {
    $script:phase = 'PRECHECK_RUNTIME'
    Assert-C2B ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
    Assert-C2B ($null -ne $script:ownerSid) 'OWNER_SID_UNAVAILABLE'
    $baseProject = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization'
    $templatePath = Join-Path $PSScriptRoot '..\templates\clash\c2b-wg-hy2-canary.yaml.template'
    $mihomoPath = 'C:\Program Files\Clash Verge\verge-mihomo.exe'
    Assert-C2B (Test-Path -LiteralPath $templatePath -PathType Leaf) 'CANARY_TEMPLATE_MISSING'
    Assert-C2B (Test-Path -LiteralPath $mihomoPath -PathType Leaf) 'MIHOMO_BINARY_MISSING'
    $mihomoVersion = @(& $mihomoPath -v 2>&1)
    if ($LASTEXITCODE -ne 0 -or ($mihomoVersion -join ' ') -notmatch '\bv1\.19\.32\b') { throw 'MIHOMO_VERSION_MISMATCH' }
    $script:profileStoreRoot = Resolve-C2BProfileStoreRoot
    $script:profileSnapshotBefore = Get-C2BProfileSnapshot -Root $script:profileStoreRoot
    Write-Output 'CLASH_PROFILE_STORE_BASELINE=PASS'

    $script:phase = 'PRECHECK_NETWORK_STATE'
    $script:before = Get-C2BState
    Assert-C2BState -State $script:before

    $script:phase = 'CREATE_OWNER_RUNTIME'
    $runtimeParent = Split-Path -Parent $script:runtimeRoot
    Assert-C2B (Test-Path -LiteralPath $runtimeParent -PathType Container) 'PROJECT_LOCALDATA_DIRECTORY_MISSING'
    if (Test-Path -LiteralPath $script:runtimeRoot) {
        Assert-C2BOwnerAcl -Path $script:runtimeRoot
    }
    else {
        [void][IO.Directory]::CreateDirectory($script:runtimeRoot, (New-C2BOwnerAcl -Directory))
        $script:createdRuntimeRoot = $true
        Assert-C2BOwnerAcl -Path $script:runtimeRoot
    }
    $script:runtimeDirectory = Join-Path $script:runtimeRoot ('c2b-' + [Guid]::NewGuid().ToString('N'))
    $script:runtimeConfigPath = Join-Path $script:runtimeDirectory 'c2b-wg-hy2-canary.yaml'
    $script:markerPath = Join-Path $script:runtimeDirectory 'owner-canary.marker'
    [void][IO.Directory]::CreateDirectory($script:runtimeDirectory, (New-C2BOwnerAcl -Directory))
    $script:createdRuntimeDirectory = $true
    Assert-C2BOwnerAcl -Path $script:runtimeDirectory
    $markerBytes = [Text.UTF8Encoding]::new($false).GetBytes('C2B_OWNER_CANARY_RUNTIME_V1')
    Write-C2BNewFile -Path $script:markerPath -Bytes $markerBytes -OnCreate { $script:markerCreated = $true }
    Set-Acl -LiteralPath $script:markerPath -AclObject (New-C2BOwnerAcl)
    Assert-C2BOwnerAcl -Path $script:markerPath

    $script:phase = 'RENDER_SYNTHETIC_PROFILE'
    $script:renderedText = [IO.File]::ReadAllText($templatePath)
    $profile = ConvertFrom-Json -InputObject $script:renderedText -AsHashtable -ErrorAction Stop
    Assert-C2B ($profile['proxies'].Count -eq 2 -and
        $profile['proxies'][0]['name'] -ceq 'WG-BASELINE' -and
        $profile['proxies'][0]['type'] -ceq 'direct' -and
        $profile['proxies'][1]['name'] -ceq 'HY2-SFO3' -and
        $profile['proxies'][1]['server'] -ceq '203.0.113.77' -and
        $profile['proxies'][1]['password'] -ceq '__C2B_SYNTHETIC_AUTH_FIXTURE_ONLY__' -and
        $profile['proxies'][1]['fingerprint'] -ceq '00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00' -and
        $profile['proxy-groups'].Count -eq 1 -and
        $profile['proxy-groups'][0]['type'] -ceq 'select' -and
        $profile['proxy-groups'][0]['proxies'][0] -ceq 'WG-BASELINE') 'SYNTHETIC_PROFILE_CONTRACT_INVALID'
    $script:configBytes = [Text.UTF8Encoding]::new($false).GetBytes($script:renderedText)
    Write-C2BNewFile -Path $script:runtimeConfigPath -Bytes $script:configBytes -OnCreate { $script:configCreated = $true }
    Set-Acl -LiteralPath $script:runtimeConfigPath -AclObject (New-C2BOwnerAcl)
    Assert-C2BOwnerAcl -Path $script:runtimeConfigPath
    $script:configTestOutput = @(& $mihomoPath -t -f $script:runtimeConfigPath 2>&1)
    if ($LASTEXITCODE -ne 0) { throw 'MIHOMO_CONFIG_TEST_FAILED' }

    Write-Output 'C2B_PREFLIGHT=PASS'
    Write-Output 'OWNER_ONLY_RUNTIME_ACL=PASS'
    Write-Output 'MIHOMO_CONFIG_TEST=PASS'
    Write-Output 'WIREGUARD_CONNECTED=YES'
    Write-Output 'SYSTEM_PROXY=OFF'
    Write-Output 'TUN=OFF'
    Write-Output 'ROUTE_MUTATION=NONE'
    Write-Output 'REALITY_LIVE_NODE=ABSENT'
    Write-Output 'HY2_CONNECTIVITY=NOT_TESTED'
    Write-Output ('TEMP_PROFILE_PATH=' + $script:runtimeConfigPath)
    Write-Output 'OWNER_UI_STEP=Import only this synthetic profile for visual inspection; keep the active production profile, WG, system proxy, and TUN unchanged. Confirm WG/HY2 nodes and the manual selector with WG as current/default. Do not select HY2 or send traffic. Remove the imported profile in Clash Verge, then enter the exact acknowledgement requested below.'
    $expectedAck = 'C2B_ACK|IMPORT=YES|WG_VISIBLE=YES|HY2_SYNTHETIC_VISIBLE=YES|SELECTOR_VISIBLE=YES|CURRENT=WG-BASELINE|HY2_TRAFFIC=NO|PROFILE_REMOVED=YES'
    $ack = Read-Host ('Type exact acknowledgement: ' + $expectedAck)
    if ($ack -cne $expectedAck) { throw 'OWNER_UI_STRUCTURED_ACK_INVALID' }
    $script:uiCleanupAcknowledged = $true

    $script:phase = 'POST_UI_READBACK'
    $after = Get-C2BState
    Assert-C2BState -State $after
    Assert-C2BSameState -Before $script:before -After $after
    $script:profileSnapshotAfter = Get-C2BProfileSnapshot -Root $script:profileStoreRoot
    Assert-C2BProfileSnapshotUnchanged -Before $script:profileSnapshotBefore -After $script:profileSnapshotAfter
    Write-Output 'CLASH_PROFILE_STORE_POSTREMOVE=PASS'
    Write-Output 'POST_UI_NETWORK_READBACK=PASS'
}
catch {
    $script:failureClass = $_.Exception.GetType().Name
    $safeFailureCode = [string]$_.Exception.Message
    Write-Output ('C2B_FAILED_PHASE=' + $script:phase)
    Write-Output ('C2B_FAILURE_CLASS=' + $script:failureClass)
    if ($safeFailureCode -cmatch '^[A-Z][A-Z0-9_]{1,79}$') {
        Write-Output ('C2B_FAILURE_CODE=' + $safeFailureCode)
    }
    else {
        Write-Output 'C2B_FAILURE_CODE=UNCLASSIFIED'
    }
}
finally {
    $script:completionPhase = $script:phase
    $script:phase = 'CLEANUP'
    if ($null -ne $script:configTestOutput) { $script:configTestOutput = $null }
    if ($null -ne $script:configBytes) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($script:configBytes) }
    $script:renderedText = $null
    if ($null -ne $script:profileSnapshotBefore) { $script:profileSnapshotBefore.Clear() }
    if ($null -ne $script:profileSnapshotAfter) { $script:profileSnapshotAfter.Clear() }
    foreach ($ownedPath in @(
        @{ Path = $script:runtimeConfigPath; Created = $script:configCreated; Kind = 'FILE' },
        @{ Path = $script:markerPath; Created = $script:markerCreated; Kind = 'FILE' },
        @{ Path = $script:runtimeDirectory; Created = $script:createdRuntimeDirectory; Kind = 'DIRECTORY' },
        @{ Path = $script:runtimeRoot; Created = $script:createdRuntimeRoot; Kind = 'DIRECTORY' }
    )) {
        if (-not $ownedPath.Created -or $null -eq $ownedPath.Path) { continue }
        try {
            if (Test-Path -LiteralPath $ownedPath.Path) {
                if ($ownedPath.Kind -eq 'FILE') {
                    Remove-Item -LiteralPath $ownedPath.Path -Force -ErrorAction Stop
                }
                else {
                    Remove-Item -LiteralPath $ownedPath.Path -ErrorAction Stop
                }
            }
        }
        catch { $script:cleanupErrors.Add($ownedPath.Kind + '_REMOVE_FAILED') }
    }
    $script:cleanupPassed =
        ($script:cleanupErrors.Count -eq 0) -and
        ($null -eq $script:runtimeConfigPath -or -not (Test-Path -LiteralPath $script:runtimeConfigPath)) -and
        ($null -eq $script:runtimeDirectory -or -not (Test-Path -LiteralPath $script:runtimeDirectory)) -and
        (-not $script:createdRuntimeRoot -or -not (Test-Path -LiteralPath $script:runtimeRoot))
    $script:roundFinishedAt = [DateTimeOffset]::UtcNow
    $script:elapsed = $script:roundFinishedAt - $script:roundStartedAt
    Write-Output ('LOCAL_RUNTIME_CLEANUP=' + $(if ($script:cleanupPassed) { 'PASS' } else { 'FAIL' }))
    if ($script:cleanupErrors.Count -gt 0) {
        Write-Output ('CLEANUP_FAILURE_CLASS=' + (($script:cleanupErrors | Sort-Object -Unique) -join ','))
    }
    Write-Output ('OWNER_UI_PROFILE_REMOVED=' + $(if ($script:uiCleanupAcknowledged) { 'ACKNOWLEDGED' } else { 'NO_ACK' }))
    Write-Output 'SECRET_VALUES_EMITTED=0'
    Write-Output ('ROUND_FINISHED_AT=' + $script:roundFinishedAt.ToString('o'))
    Write-Output ('ACTUAL_ELAPSED=' + $script:elapsed.ToString('c'))
    Write-Output ('TIME_OVERRUN=' + $(if ($script:elapsed -gt [TimeSpan]::FromMinutes(25)) { 'YES' } else { 'NO' }))
    Write-Output ('TIME_OVERRUN_PHASE=' + $script:completionPhase)
}

if (-not $script:cleanupPassed -or $script:failureClass -cne 'NONE') { exit 1 }
Write-Output 'C2B_OWNER_CHECKPOINT=COMPLETE'
exit 0
