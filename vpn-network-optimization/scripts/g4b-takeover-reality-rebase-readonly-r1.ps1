[CmdletBinding()]
param(
    [string]$SshIdentityFile,
    [string]$KnownHostsFile,
    [string]$BaiduCliPath,
    [string]$BaiduCliArchivePath,
    [switch]$LibraryOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:gateId = 'G4B_TAKEOVER_REALITY_REBASE_READONLY_R1'
$script:projectName = 'vpn-network-optimization'
$script:originExpected = 'https://github.com/entropy-student/project.git'
$script:trustedAnchor = '85a33288c23e794d200ddf5e48d5bb7ae0d839c0'
$script:publicIp = '24.199.118.137'
$script:sshTarget = 'root@10.66.21.1'
$script:hostKeyAlias = '24.199.118.137'
$script:realityService = 'mihomo-reality-vpn-network-optimization.service'
$script:runtimeUser = 'reality-vpn-network-optimization'
$script:recoveryDirectory = '/vpn-network-optimization-g4b-recovery'
$script:recoveryFinalName = 'vpn-network-optimization-g4b.vpr1'
$script:archiveSha256 = 'ce72b3155a710b7c4a2b15611c3aebd11a057d7cccf0529e7703bdde04f0aa30'
$script:projectRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))

function Assert-R1 {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
}

function Get-OptionalPropertyValue {
    param([Parameter(Mandatory=$true)][object]$InputObject, [Parameter(Mandatory=$true)][string]$Name)
    $property = $InputObject.PSObject.Properties[$Name]
    if ($null -eq $property) { return $null }
    return $property.Value
}

function Get-IPv4PrefixLength {
    param([string]$Prefix)
    $match = [regex]::Match($Prefix, '^(?<ip>(?:\d{1,3}\.){3}\d{1,3})/(?<bits>\d{1,2})$')
    if (-not $match.Success) { return -1 }
    $address = $null
    if (-not [Net.IPAddress]::TryParse($match.Groups['ip'].Value, [ref]$address) -or $address.AddressFamily -ne [Net.Sockets.AddressFamily]::InterNetwork) { return -1 }
    $bits = [int]$match.Groups['bits'].Value
    if ($bits -lt 0 -or $bits -gt 32) { return -1 }
    return $bits
}

function Test-IPv4PrefixContains {
    param([string]$Address, [string]$Prefix)
    $bits = Get-IPv4PrefixLength -Prefix $Prefix
    if ($bits -lt 0) { return $false }
    $remote = $null
    $network = $null
    if (-not [Net.IPAddress]::TryParse($Address, [ref]$remote) -or $remote.AddressFamily -ne [Net.Sockets.AddressFamily]::InterNetwork) { return $false }
    $networkText = $Prefix.Substring(0, $Prefix.LastIndexOf('/'))
    if (-not [Net.IPAddress]::TryParse($networkText, [ref]$network) -or $network.AddressFamily -ne [Net.Sockets.AddressFamily]::InterNetwork) { return $false }
    $remoteBytes = $remote.GetAddressBytes()
    $networkBytes = $network.GetAddressBytes()
    $wholeBytes = [int][Math]::Floor($bits / 8)
    for ($index = 0; $index -lt $wholeBytes; $index++) {
        if ($remoteBytes[$index] -ne $networkBytes[$index]) { return $false }
    }
    $remainingBits = $bits % 8
    if ($remainingBits -gt 0) {
        $mask = [byte]((255 -shl (8 - $remainingBits)) -band 255)
        if (($remoteBytes[$wholeBytes] -band $mask) -ne ($networkBytes[$wholeBytes] -band $mask)) { return $false }
    }
    return $true
}

function Get-SelectedRouteForIPv4 {
    param([Parameter(Mandatory=$true)][object[]]$Routes, [Parameter(Mandatory=$true)][hashtable]$InterfaceMetrics, [Parameter(Mandatory=$true)][string]$Address)
    $routeMatches = [Collections.Generic.List[object]]::new()
    foreach ($route in $Routes) {
        $prefixValue = Get-OptionalPropertyValue -InputObject $route -Name 'DestinationPrefix'
        $indexValue = Get-OptionalPropertyValue -InputObject $route -Name 'InterfaceIndex'
        $metricValue = Get-OptionalPropertyValue -InputObject $route -Name 'RouteMetric'
        if ($prefixValue -isnot [string] -or $indexValue -isnot [ValueType] -or $metricValue -isnot [ValueType]) { throw 'ROUTE_OBJECT_SHAPE_INVALID' }
        if (Test-IPv4PrefixContains -Address $Address -Prefix $prefixValue) {
            $prefixLength = Get-IPv4PrefixLength -Prefix $prefixValue
            if ($prefixLength -lt 0) { throw 'ROUTE_PREFIX_INVALID' }
            $ifIndex = [int]$indexValue
            Assert-R1 ($InterfaceMetrics.ContainsKey($ifIndex)) 'ROUTE_INTERFACE_METRIC_MISSING'
            $routeMatches.Add([pscustomobject]@{ PrefixLength=$prefixLength; InterfaceIndex=$ifIndex; EffectiveMetric=([long]$metricValue + [long]$InterfaceMetrics[$ifIndex]) })
        }
    }
    if ($routeMatches.Count -eq 0) { return $null }
    $longest = ($routeMatches | Measure-Object -Property PrefixLength -Maximum).Maximum
    $atLongest = @($routeMatches | Where-Object { $_.PrefixLength -eq $longest })
    $bestMetric = ($atLongest | Measure-Object -Property EffectiveMetric -Minimum).Minimum
    $best = @($atLongest | Where-Object { $_.EffectiveMetric -eq $bestMetric })
    if ($best.Count -ne 1) { return $null }
    return $best[0]
}

function Get-RouteFingerprint {
    param([Parameter(Mandatory=$true)][ValidateSet('ActiveStore','PersistentStore')][string]$Store)
    $routes = @(Get-NetRoute -AddressFamily IPv4 -PolicyStore $Store -ErrorAction Stop)
    $rows = [Collections.Generic.List[string]]::new()
    foreach ($route in $routes) {
        $prefix = Get-OptionalPropertyValue -InputObject $route -Name 'DestinationPrefix'
        $nextHop = Get-OptionalPropertyValue -InputObject $route -Name 'NextHop'
        $ifIndex = Get-OptionalPropertyValue -InputObject $route -Name 'InterfaceIndex'
        $metric = Get-OptionalPropertyValue -InputObject $route -Name 'RouteMetric'
        if ($prefix -isnot [string] -or $nextHop -isnot [string] -or $ifIndex -isnot [ValueType] -or $metric -isnot [ValueType]) { throw 'ROUTE_OBJECT_SHAPE_INVALID' }
        $rows.Add(('{0}|{1}|{2}|{3}' -f $prefix,$nextHop,[int]$ifIndex,[long]$metric))
    }
    return ,@($rows | Sort-Object -CaseSensitive)
}

function Get-RouteState {
    $active = @(Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -ErrorAction Stop)
    $interfaces = @(Get-NetIPInterface -AddressFamily IPv4 -PolicyStore ActiveStore -ErrorAction Stop)
    $metrics = @{}
    foreach ($interface in $interfaces) {
        $index = Get-OptionalPropertyValue -InputObject $interface -Name 'InterfaceIndex'
        $metric = Get-OptionalPropertyValue -InputObject $interface -Name 'InterfaceMetric'
        if ($index -isnot [ValueType] -or $metric -isnot [ValueType] -or $metrics.ContainsKey([int]$index)) { throw 'ROUTE_INTERFACE_METRIC_INVALID' }
        $metrics[[int]$index] = [int]$metric
    }
    $wg = @(Get-NetAdapter -Name 'SFO2-A' -ErrorAction Stop)
    Assert-R1 ($wg.Count -eq 1 -and $wg[0].Status -ceq 'Up' -and [int]$wg[0].ifIndex -gt 0) 'WIREGUARD_ADAPTER_INVALID'
    $ifIndex = [int]$wg[0].ifIndex
    foreach ($prefix in @('0.0.0.0/1','128.0.0.0/1')) {
        $split = @($active | Where-Object { (Get-OptionalPropertyValue -InputObject $_ -Name 'DestinationPrefix') -ceq $prefix })
        Assert-R1 ($split.Count -eq 1 -and [int](Get-OptionalPropertyValue -InputObject $split[0] -Name 'InterfaceIndex') -eq $ifIndex) 'WIREGUARD_SPLIT_ROUTE_INVALID'
    }
    $selected = Get-SelectedRouteForIPv4 -Routes $active -InterfaceMetrics $metrics -Address '10.66.21.1'
    $controlViaWg = ($null -ne $selected -and [int]$selected.InterfaceIndex -eq $ifIndex)
    return [pscustomobject]@{ Healthy=$controlViaWg; InterfaceIndex=$ifIndex }
}

function Get-TunAdapterCount {
    $adapters = @(Get-NetAdapter -IncludeHidden -ErrorAction Stop)
    return @($adapters | Where-Object {
        $_.Status -ceq 'Up' -and $_.Name -cne 'SFO2-A' -and $_.InterfaceDescription -notmatch '(?i)WireGuard' -and
        ($_.Name -match '(?i)clash|mihomo|tun' -or $_.InterfaceDescription -match '(?i)clash|mihomo|tun')
    }).Count
}

function Get-WindowsBaseline {
    $manager = @(Get-Service -Name 'WireGuardManager' -ErrorAction Stop)
    $tunnel = @(Get-Service -Name 'WireGuardTunnel$SFO2-A' -ErrorAction Stop)
    $wg = @(Get-NetAdapter -Name 'SFO2-A' -ErrorAction Stop)
    $clash = @(Get-Service -Name 'clash_verge_service' -ErrorAction Stop)
    $settings = Get-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -ErrorAction Stop
    $proxyEnable = Get-OptionalPropertyValue -InputObject $settings -Name 'ProxyEnable'
    $routeState = Get-RouteState
    $tunCount = Get-TunAdapterCount
    $winHttp = Invoke-ReadOnlyNative -FileName 'netsh.exe' -Arguments @('winhttp','show','proxy') -TimeoutMilliseconds 15000 -OutputLimit 65536
    $wgHealthy = ($manager.Count -eq 1 -and $manager[0].Status -ceq 'Running' -and $tunnel.Count -eq 1 -and $tunnel[0].Status -ceq 'Running' -and $wg.Count -eq 1 -and $wg[0].Status -ceq 'Up' -and [int]$wg[0].ifIndex -eq $routeState.InterfaceIndex -and $routeState.Healthy)
    $clashHealthy = ($clash.Count -eq 1 -and $clash[0].Status -ceq 'Running')
    $proxyOff = ($null -ne $proxyEnable -and [int]$proxyEnable -eq 0)
    $tunOff = ($tunCount -eq 0)
    return [pscustomobject]@{
        Known=$true; Healthy=($wgHealthy -and $clashHealthy -and $proxyOff -and $tunOff -and $winHttp.ExitCode -eq 0)
        WireGuardHealthy=$wgHealthy; ClashHealthy=$clashHealthy; ProxyOff=$proxyOff; TunOff=$tunOff
        WireGuardIfIndex=[int]$wg[0].ifIndex; TunCount=$tunCount; WinHttpPass=($winHttp.ExitCode -eq 0)
    }
}

function Get-DirectMetadataItems {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return [pscustomobject]@{ State='ABSENT'; Items=@() } }
    $root = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    Assert-R1 (($root.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0 -and $root.PSIsContainer) 'LOCAL_METADATA_ROOT_INVALID'
    $items = @(Get-ChildItem -LiteralPath $Path -Force -ErrorAction Stop)
    Assert-R1 ($items.Count -le 4096) 'LOCAL_METADATA_ENTRY_LIMIT_EXCEEDED'
    foreach ($item in $items) { Assert-R1 (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'LOCAL_METADATA_REPARSE_POINT' }
    return [pscustomobject]@{ State='PRESENT'; Items=$items }
}

function Get-BoundedLocalArtifactCounts {
    param([Parameter(Mandatory=$true)][AllowEmptyCollection()][string[]]$RuntimeNames, [Parameter(Mandatory=$true)][AllowEmptyCollection()][string[]]$RuntimeKinds, [Parameter(Mandatory=$true)][AllowEmptyCollection()][string[]]$RecoveryNames, [Parameter(Mandatory=$true)][AllowEmptyCollection()][string[]]$ProfileNames)
    if ($RuntimeNames.Count -ne $RuntimeKinds.Count) { throw 'LOCAL_FIXTURE_SHAPE_INVALID' }
    $runtimeCount = 0
    $journalCount = 0
    for ($i=0; $i -lt $RuntimeNames.Count; $i++) {
        if ($RuntimeKinds[$i] -ceq 'DIR' -and $RuntimeNames[$i] -match '^g4b-.+$') { $runtimeCount++ }
        if ($RuntimeKinds[$i] -ceq 'FILE' -and $RuntimeNames[$i] -match '^g4b-[0-9a-f]{32}\.rollback\.json$') { $journalCount++ }
    }
    $finalPresent = @($RecoveryNames | Where-Object { $_ -ceq 'reality-g4b.dpapi' }).Count -gt 0
    $pending = @($RecoveryNames | Where-Object { $_ -match '^(?:reality-g4b\.dpapi\.pending|vpn-network-optimization-g4b-[0-9a-f]{32}\.vpr1\.pending)$' }).Count
    $profileCount = @($ProfileNames | Where-Object { $_ -match '(?i)^SELF-VPN-V1(?:[.-].*)?\.(?:yaml|yml)$' }).Count
    return [pscustomobject]@{ RuntimeCount=$runtimeCount; JournalCount=$journalCount; RecoveryFinal=$finalPresent; PendingCount=$pending; ProfileCount=$profileCount }
}

function Get-LocalArtifactSnapshot {
    $runtimeRoot = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'
    $recoveryRoot = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\recovery'
    $runtime = Get-DirectMetadataItems -Path $runtimeRoot
    $recovery = Get-DirectMetadataItems -Path $recoveryRoot
    $runtimeNames = @($runtime.Items | ForEach-Object { [string]$_.Name })
    $runtimeKinds = @($runtime.Items | ForEach-Object { if ($_.PSIsContainer) { 'DIR' } else { 'FILE' } })
    $recoveryNames = @($recovery.Items | ForEach-Object { [string]$_.Name })
    $finalItem = Join-Path $recoveryRoot 'reality-g4b.dpapi'
    $finalPresent = $false
    if (Test-Path -LiteralPath $finalItem) {
        $item = Get-Item -LiteralPath $finalItem -Force -ErrorAction Stop
        Assert-R1 (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0 -and -not $item.PSIsContainer) 'LOCAL_RECOVERY_FINAL_INVALID'
        $finalPresent = $true
    }
    $profiles = Resolve-ProfileStoreSnapshot
    $counts = Get-BoundedLocalArtifactCounts -RuntimeNames $runtimeNames -RuntimeKinds $runtimeKinds -RecoveryNames $recoveryNames -ProfileNames $profiles.Names
    return [pscustomobject]@{
        RuntimeCount=$counts.RuntimeCount; JournalCount=$counts.JournalCount; RecoveryFinal=$finalPresent
        PendingCount=$counts.PendingCount; ProfileCount=$profiles.Count; Known=($runtime.State -ne 'UNKNOWN' -and $recovery.State -ne 'UNKNOWN' -and $profiles.Known)
    }
}

function Resolve-ProfileStoreSnapshot {
    $roaming = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData)
    Assert-R1 (-not [string]::IsNullOrWhiteSpace($roaming)) 'PROFILE_STORE_ROOT_UNAVAILABLE'
    $roamingItem = Get-Item -LiteralPath $roaming -Force -ErrorAction Stop
    Assert-R1 (($roamingItem.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'PROFILE_STORE_ROOT_REPARSE_POINT'
    $roots = @(Get-ChildItem -LiteralPath $roaming -Directory -Force -ErrorAction Stop | Where-Object { $_.Name -match '(?i)(?:clash.*verge|verge.*clash)' })
    foreach ($rootItem in $roots) { if (($rootItem.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { return [pscustomobject]@{ Known=$false; Count='UNKNOWN'; Names=@() } } }
    $stores = @($roots | ForEach-Object { Join-Path $_.FullName 'profiles' } | Where-Object { Test-Path -LiteralPath $_ -PathType Container })
    if ($stores.Count -ne 1) { return [pscustomobject]@{ Known=$false; Count='UNKNOWN'; Names=@() } }
    $store = Get-Item -LiteralPath $stores[0] -Force -ErrorAction Stop
    if (($store.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { return [pscustomobject]@{ Known=$false; Count='UNKNOWN'; Names=@() } }
    $entries = @(Get-ChildItem -LiteralPath $store.FullName -Force -ErrorAction Stop)
    if ($entries.Count -gt 4096) { return [pscustomobject]@{ Known=$false; Count='UNKNOWN'; Names=@() } }
    $candidates = @($entries | Where-Object { $_.Name -match '(?i)^SELF-VPN-V1(?:[.-].*)?\.(?:yaml|yml)$' })
    if (@($candidates | Where-Object { ($_.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0 }).Count -gt 0) { return [pscustomobject]@{ Known=$false; Count='UNKNOWN'; Names=@() } }
    return [pscustomobject]@{ Known=$true; Count=$candidates.Count; Names=@($entries | ForEach-Object { [string]$_.Name }) }
}

function Test-PathWithin {
    param([string]$Path, [string]$Parent)
    $relative = [IO.Path]::GetRelativePath([IO.Path]::GetFullPath($Parent), [IO.Path]::GetFullPath($Path))
    return ($relative -ceq '.' -or (-not [IO.Path]::IsPathRooted($relative) -and $relative -notmatch '^\.\.(?:[\\/]|$)'))
}

function Assert-BaiduConfigAclMetadata {
    param([string]$ActualOwnerSid, [Security.Principal.SecurityIdentifier]$ExpectedOwnerSid, [object[]]$Rules, [bool]$IsDirectory)
    Assert-R1 ($ActualOwnerSid -ceq $ExpectedOwnerSid.Value) 'BAIDU_CONFIG_OWNER_MISMATCH'
    $allowedSids = @($ExpectedOwnerSid.Value, 'S-1-5-18', 'S-1-5-32-544')
    $ownerDirectRights = [long]0
    $ownerInheritedRights = [long]0
    foreach ($rule in $Rules) {
        Assert-R1 ($null -ne $rule) 'BAIDU_CONFIG_ACE_SHAPE_INVALID'
        $identityProperty = $rule.PSObject.Properties['IdentityReference']
        $typeProperty = $rule.PSObject.Properties['AccessControlType']
        $inheritedProperty = $rule.PSObject.Properties['IsInherited']
        $rightsProperty = $rule.PSObject.Properties['FileSystemRights']
        $propagationProperty = $rule.PSObject.Properties['PropagationFlags']
        Assert-R1 ($null -ne $identityProperty -and $null -ne $identityProperty.Value -and $null -ne $typeProperty -and $null -ne $inheritedProperty -and $null -ne $rightsProperty -and $null -ne $propagationProperty) 'BAIDU_CONFIG_ACE_SHAPE_INVALID'
        $sidProperty = $identityProperty.Value.PSObject.Properties['Value']
        Assert-R1 ($identityProperty.Value -is [Security.Principal.SecurityIdentifier] -and $null -ne $sidProperty -and $inheritedProperty.Value -is [bool] -and $typeProperty.Value -is [Security.AccessControl.AccessControlType] -and $rightsProperty.Value -is [Security.AccessControl.FileSystemRights] -and $propagationProperty.Value -is [Security.AccessControl.PropagationFlags]) 'BAIDU_CONFIG_ACE_SHAPE_INVALID'
        $ruleSid = [string]$sidProperty.Value
        if ($typeProperty.Value -eq [Security.AccessControl.AccessControlType]::Deny) { throw 'BAIDU_CONFIG_DENY_ACE' }
        Assert-R1 ($typeProperty.Value -eq [Security.AccessControl.AccessControlType]::Allow) 'BAIDU_CONFIG_ACE_SHAPE_INVALID'
        Assert-R1 ($ruleSid -in $allowedSids) 'BAIDU_CONFIG_UNAUTHORIZED_ALLOW'
        if ($ruleSid -ceq $ExpectedOwnerSid.Value -and (([long]$propagationProperty.Value -band [long][Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0)) {
            if ([bool]$inheritedProperty.Value) { $ownerInheritedRights = $ownerInheritedRights -bor [long]$rightsProperty.Value }
            else { $ownerDirectRights = $ownerDirectRights -bor [long]$rightsProperty.Value }
        }
    }
    if ($IsDirectory) {
        $required = [long]([Security.AccessControl.FileSystemRights]::ListDirectory -bor [Security.AccessControl.FileSystemRights]::ExecuteFile -bor [Security.AccessControl.FileSystemRights]::ReadAttributes -bor [Security.AccessControl.FileSystemRights]::ReadExtendedAttributes -bor [Security.AccessControl.FileSystemRights]::ReadPermissions)
    } else {
        $required = [long]([Security.AccessControl.FileSystemRights]::ReadData -bor [Security.AccessControl.FileSystemRights]::ReadAttributes -bor [Security.AccessControl.FileSystemRights]::ReadExtendedAttributes -bor [Security.AccessControl.FileSystemRights]::ReadPermissions)
    }
    $effective = $ownerDirectRights -bor $ownerInheritedRights
    Assert-R1 (($effective -band $required) -eq $required) 'BAIDU_CONFIG_OWNER_READ_RIGHTS_MISSING'
}

function Assert-SafeBaiduConfigDirectory {
    param([string]$ConfigDirectory, [string]$ProjectRoot, [Security.Principal.SecurityIdentifier]$OwnerSid)
    $config = [IO.Path]::GetFullPath($ConfigDirectory)
    Assert-R1 (-not $config.StartsWith('\\', [StringComparison]::OrdinalIgnoreCase)) 'BAIDU_CONFIG_NETWORK_PATH_FORBIDDEN'
    Assert-R1 (-not (Test-PathWithin -Path $config -Parent $ProjectRoot)) 'BAIDU_CONFIG_INSIDE_REPOSITORY'
    Assert-R1 ((Split-Path -Leaf $config) -ceq 'BaiduPCS-Go') 'BAIDU_CONFIG_LOCATION_INVALID'
    Assert-R1 (Test-Path -LiteralPath $config -PathType Container) 'BAIDU_CONFIG_NOT_DIRECTORY'
    $stack = [Collections.Generic.Stack[string]]::new()
    $stack.Push($config)
    $visited = 0
    while ($stack.Count -gt 0) {
        $directory = $stack.Pop()
        $item = Get-Item -LiteralPath $directory -Force -ErrorAction Stop
        Assert-R1 (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'BAIDU_CONFIG_REPARSE_POINT'
        $acl = Get-Acl -LiteralPath $directory -ErrorAction Stop
        $actualOwner = $acl.GetOwner([Security.Principal.SecurityIdentifier]).Value
        $rules = @($acl.GetAccessRules($true,$true,[Security.Principal.SecurityIdentifier]))
        Assert-BaiduConfigAclMetadata -ActualOwnerSid $actualOwner -ExpectedOwnerSid $OwnerSid -Rules $rules -IsDirectory $true
        $visited++
        if ($visited -gt 4096) { throw 'BAIDU_CONFIG_ENTRY_LIMIT_EXCEEDED' }
        foreach ($child in @(Get-ChildItem -LiteralPath $directory -Force -ErrorAction Stop)) {
            Assert-R1 (($child.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'BAIDU_CONFIG_REPARSE_POINT'
            $childAcl = Get-Acl -LiteralPath $child.FullName -ErrorAction Stop
            $childOwner = $childAcl.GetOwner([Security.Principal.SecurityIdentifier]).Value
            $childRules = @($childAcl.GetAccessRules($true,$true,[Security.Principal.SecurityIdentifier]))
            Assert-BaiduConfigAclMetadata -ActualOwnerSid $childOwner -ExpectedOwnerSid $OwnerSid -Rules $childRules -IsDirectory ([bool]$child.PSIsContainer)
            $visited++
            if ($visited -gt 4096) { throw 'BAIDU_CONFIG_ENTRY_LIMIT_EXCEEDED' }
            if ($child.PSIsContainer) { $stack.Push($child.FullName) }
        }
    }
}

function Assert-OwnerOnlyAcl {
    param([string]$Path, [Security.Principal.SecurityIdentifier]$OwnerSid)
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    Assert-R1 (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'BAIDU_CLI_REPARSE_POINT'
    $acl = Get-Acl -LiteralPath $Path -ErrorAction Stop
    Assert-R1 $acl.AreAccessRulesProtected 'BAIDU_CLI_ACL_INHERITANCE_ENABLED'
    Assert-R1 ($acl.GetOwner([Security.Principal.SecurityIdentifier]).Value -ceq $OwnerSid.Value) 'BAIDU_CLI_ACL_OWNER_MISMATCH'
    $rules = @($acl.GetAccessRules($true,$true,[Security.Principal.SecurityIdentifier]))
    $direct = [long]0
    foreach ($rule in $rules) {
        Assert-R1 (-not $rule.IsInherited -and $rule.IdentityReference.Value -ceq $OwnerSid.Value) 'BAIDU_CLI_ACL_UNAUTHORIZED_RULE'
        Assert-R1 ($rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow) 'BAIDU_CLI_ACL_DENY_RULE'
        if (($rule.PropagationFlags -band [Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0) { $direct = $direct -bor [long]$rule.FileSystemRights }
    }
    $full = [long][Security.AccessControl.FileSystemRights]::FullControl
    Assert-R1 (($direct -band $full) -eq $full) 'BAIDU_CLI_ACL_FULLCONTROL_MISSING'
}

function Get-PinnedBaiduExecutableHashFromArchive {
    param([Parameter(Mandatory=$true)][string]$ArchivePath)
    $archiveItem = Get-Item -LiteralPath $ArchivePath -Force -ErrorAction Stop
    Assert-R1 (-not $archiveItem.PSIsContainer -and ($archiveItem.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'BAIDU_ARCHIVE_METADATA_INVALID'
    Assert-R1 ($archiveItem.Length -gt 0 -and $archiveItem.Length -le 100MB) 'BAIDU_ARCHIVE_SIZE_INVALID'
    Assert-R1 ((Get-FileHash -LiteralPath $ArchivePath -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant() -ceq $script:archiveSha256) 'BAIDU_ARCHIVE_PIN_MISMATCH'
    [void][Reflection.Assembly]::Load('System.IO.Compression')
    [void][Reflection.Assembly]::Load('System.IO.Compression.FileSystem')
    $zip = [IO.Compression.ZipFile]::OpenRead($ArchivePath)
    try {
        $entries = @($zip.Entries | Where-Object { [IO.Path]::GetFileName($_.FullName) -ceq 'BaiduPCS-Go.exe' })
        Assert-R1 ($entries.Count -eq 1 -and $entries[0].Length -gt 0 -and $entries[0].Length -le 64MB -and $entries[0].FullName -notmatch '(^|[/\\])\.\.([/\\]|$)' -and -not [IO.Path]::IsPathRooted($entries[0].FullName)) 'BAIDU_ARCHIVE_ENTRY_INVALID'
        $entryStream = $entries[0].Open()
        $sha = [Security.Cryptography.SHA256]::Create()
        try { return ([BitConverter]::ToString($sha.ComputeHash($entryStream))).Replace('-','').ToLowerInvariant() }
        finally { $entryStream.Dispose(); $sha.Dispose() }
    }
    finally { $zip.Dispose() }
}

function Find-VerifiedBaiduCli {
    param([string]$ExecutablePath, [string]$ArchivePath)
    if ([string]::IsNullOrWhiteSpace($ExecutablePath) -or [string]::IsNullOrWhiteSpace($ArchivePath)) { return $null }
    $runtimeRoot = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'
    $recoveryRoot = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\recovery'
    foreach ($path in @($ExecutablePath,$ArchivePath)) {
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return $null }
        $item = Get-Item -LiteralPath $path -Force -ErrorAction Stop
        Assert-R1 (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'BAIDU_CLI_PATH_REPARSE_POINT'
        Assert-R1 (-not (Test-PathWithin -Path $item.FullName -Parent $script:projectRoot) -and -not (Test-PathWithin -Path $item.FullName -Parent $runtimeRoot) -and -not (Test-PathWithin -Path $item.FullName -Parent $recoveryRoot)) 'BAIDU_CLI_PATH_SCOPE_INVALID'
    }
    $archiveBinaryHash = Get-PinnedBaiduExecutableHashFromArchive -ArchivePath $ArchivePath
    $localBinaryHash = (Get-FileHash -LiteralPath $ExecutablePath -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant()
    if ($localBinaryHash -cne $archiveBinaryHash) { return $null }
    return (Get-Item -LiteralPath $ExecutablePath -Force -ErrorAction Stop).FullName
}

function Get-BaiduListingCounts {
    param([Parameter(Mandatory=$true)][string]$Listing)
    $lines = @($Listing -split "`r?`n")
    $header = '当前目录: ' + $script:recoveryDirectory
    $headerCount = @($lines | Where-Object { $_.Trim() -ceq $header }).Count
    if ($headerCount -ne 1) { return [pscustomobject]@{ Valid=$false; FinalCount='UNKNOWN'; PendingCount='UNKNOWN'; UnknownCount='UNKNOWN'; QuarantineCount='UNKNOWN' } }
    $final = 0; $pending = 0; $unknown = 0; $quarantine = 0
    foreach ($line in $lines) {
        $trimmed = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($trimmed) -or $trimmed -ceq $header) { continue }
        $nameMatch = [regex]::Match($trimmed, '(?<name>[^\s/]+)\s*$')
        if (-not $nameMatch.Success) { continue }
        $name = $nameMatch.Groups['name'].Value.TrimEnd('/')
        if ($name -ceq $script:recoveryFinalName) { $final++; continue }
        if ($name -match '^vpn-network-optimization-g4b-[0-9a-f]{32}\.vpr1\.pending$') { $pending++; continue }
        if ($name -match '^r17-quarantine-[0-9a-f]{32}\.vpr1\.pending$') { $quarantine++; continue }
        if ($name -match '^vpn-network-optimization-g4b[^\s/]*$') { $unknown++ }
    }
    return [pscustomobject]@{ Valid=$true; FinalCount=$final; PendingCount=$pending; UnknownCount=$unknown; QuarantineCount=$quarantine }
}

function Get-RealityClassification {
    param([Parameter(Mandatory=$true)][object]$Windows, [Parameter(Mandatory=$true)][object]$Local, [Parameter(Mandatory=$true)][object]$Vps, [Parameter(Mandatory=$true)][object]$Baidu)
    if (-not $Windows.Known -or -not $Windows.Healthy -or -not $Local.Known -or -not $Vps.Known -or -not $Baidu.Known) { return 'AMBIGUOUS_BASELINE' }
    if (-not $Vps.Healthy -or $Baidu.Identity -cne 'PASS' -or $Baidu.DirectoryReadable -cne 'YES') { return 'AMBIGUOUS_BASELINE' }
    if ($Local.RuntimeCount -gt 0 -or $Local.JournalCount -gt 0 -or $Local.RecoveryFinal -or $Local.PendingCount -gt 0 -or $Local.ProfileCount -gt 0 -or $Vps.Residual -or $Baidu.FinalCount -gt 0 -or $Baidu.PendingCount -gt 0 -or $Baidu.UnknownCount -gt 0) { return 'PROJECT_RESIDUAL_PRESENT' }
    return 'CLEAN_BASELINE'
}

function Format-R1MarkerLine {
    param([Parameter(Mandatory=$true)][string]$Name, [Parameter(Mandatory=$true)][string]$Value)
    $patterns = @{
        'G4B_TAKEOVER_REALITY_REBASE_READONLY'='PASS_CANDIDATE|FAIL_CLOSED'; 'FAILURE_CODE'='NONE|SOURCE_PREFLIGHT_FAILED|CHECKPOINT_READBACK_FAILED|ROUTE_OBJECT_SHAPE_INVALID|ROUTE_PREFIX_INVALID|WIREGUARD_ADAPTER_INVALID|WIREGUARD_SPLIT_ROUTE_INVALID|NATIVE_PROCESS_START_FAILED|NATIVE_PROCESS_TIMEOUT|NATIVE_PROCESS_OUTPUT_LIMIT|GIT_COMMAND_NOT_READ_ONLY|GIT_READBACK_FAILED|OUTPUT_CONTRACT_INVALID|PROVIDER_IDENTITY_CONFIRMATION_REQUIRED|PROVIDER_READ_ONLY_LISTING_FAILED|PROVIDER_READ_ONLY_LISTING_AMBIGUOUS'
        'WINDOWS_RUNTIME'='[0-9]+\.[0-9]+(\.[0-9]+){0,2}|UNKNOWN'; 'CANONICAL_SOURCE'='PASS|FAIL|UNKNOWN'; 'SOURCE_HEAD'='[0-9a-f]{40}|UNKNOWN'
        'WINDOWS_WG_HEALTHY'='YES|NO|UNKNOWN'; 'WINDOWS_CLASH_HEALTHY'='YES|NO|UNKNOWN'; 'SYSTEM_PROXY_OFF'='YES|NO|UNKNOWN'; 'TUN_OFF'='YES|NO|UNKNOWN'; 'ROUTES_UNCHANGED'='YES|NO|UNKNOWN'
        'LOCAL_G4B_RUNTIME_COUNT'='[0-9]{1,6}|UNKNOWN'; 'LOCAL_G4B_JOURNAL_COUNT'='[0-9]{1,6}|UNKNOWN'; 'LOCAL_REALITY_RECOVERY_FINAL_PRESENT'='YES|NO|UNKNOWN'; 'LOCAL_REALITY_RECOVERY_PENDING_COUNT'='[0-9]{1,6}|UNKNOWN'; 'SELF_VPN_V1_PROFILE_CANDIDATE_COUNT'='[0-9]{1,6}|UNKNOWN'
        'VPS_IDENTITY'='PASS|FAIL|UNKNOWN'; 'VPS_WG_HEALTHY'='YES|NO|UNKNOWN'; 'VPS_HY2_HEALTHY'='YES|NO|UNKNOWN'; 'VPS_TCP443_COUNT'='[0-9]{1,6}|UNKNOWN'; 'VPS_TCP443_OWNER_CLASS'='NONE|PROJECT_REALITY|OTHER_OR_UNKNOWN|UNKNOWN'
        'VPS_REALITY_SERVICE_LOAD'='loaded|not-found|error|masked|unknown|UNKNOWN'; 'VPS_REALITY_SERVICE_ACTIVE'='active|inactive|failed|activating|deactivating|unknown|UNKNOWN'; 'VPS_REALITY_SERVICE_ENABLE'='enabled|disabled|static|indirect|masked|generated|transient|linked|linked-runtime|alias|not-found|unknown|UNKNOWN'
        'VPS_REALITY_BINARY_PRESENT'='YES|NO|UNKNOWN'; 'VPS_REALITY_RUNTIME_PRESENT'='YES|NO|UNKNOWN'; 'VPS_REALITY_SECRET_CONFIG_PRESENT'='YES|NO|UNKNOWN'; 'VPS_REALITY_UNIT_PRESENT'='YES|NO|UNKNOWN'; 'VPS_REALITY_RUNTIME_USER_PRESENT'='YES|NO|UNKNOWN'; 'VPS_REALITY_RUNTIME_GROUP_PRESENT'='YES|NO|UNKNOWN'; 'VPS_G4B_TXN_COUNT'='[0-9]{1,6}|UNKNOWN'; 'VPS_G4B_TMP_COUNT'='[0-9]{1,6}|UNKNOWN'
        'BAIDU_IDENTITY_CHECK'='PASS|FAIL|UNKNOWN'; 'BAIDU_RECOVERY_DIRECTORY_READABLE'='YES|NO|UNKNOWN'; 'BAIDU_FINAL_COUNT'='[0-9]{1,6}|UNKNOWN'; 'BAIDU_PENDING_COUNT'='[0-9]{1,6}|UNKNOWN'; 'BAIDU_UNKNOWN_PROJECT_COUNT'='[0-9]{1,6}|UNKNOWN'; 'BAIDU_QUARANTINE_COUNT'='[0-9]{1,6}|UNKNOWN'
        'CURRENT_REALITY'='CLEAN_BASELINE|PROJECT_RESIDUAL_PRESENT|AMBIGUOUS_BASELINE'; 'LOCAL_MUTATION'='NO'; 'REMOTE_MUTATION'='NO'; 'PROVIDER_MUTATION'='NO'; 'SECRET_VALUES_EMITTED'='0'; 'STOP_AT_REVIEWER'='YES'
    }
    if (-not $patterns.ContainsKey($Name) -or $Value -notmatch ('^(?:' + $patterns[$Name] + ')$')) { throw 'OUTPUT_CONTRACT_INVALID' }
    return ($Name + '=' + $Value)
}

function Write-R1Marker {
    param([string]$Name, [string]$Value)
    [Console]::Out.WriteLine((Format-R1MarkerLine -Name $Name -Value $Value))
}

function Test-StrictSshArguments {
    param([string[]]$Arguments)
    $joined = $Arguments -join "`n"
    return ($joined -match '(?m)^-o$' -and $joined -match 'BatchMode=yes' -and $joined -match 'IdentitiesOnly=yes' -and $joined -match 'StrictHostKeyChecking=yes' -and $joined -match 'UpdateHostKeys=no' -and $joined -match ('HostKeyAlias=' + [regex]::Escape($script:hostKeyAlias)) -and $joined -match 'UserKnownHostsFile=' -and $joined -match '(?m)^root@10\.66\.21\.1$')
}

function Test-RemoteReadOnlyProbe {
    param([Parameter(Mandatory=$true)][string]$ScriptText)
    if ($ScriptText -match '(?im)\b(rm|mv|mkdir|touch|install|chmod|chown|apt|dpkg|iptables|ip6tables|nft|ufw|reboot|shutdown|curl|wget|nc|socat|python3?|perl|tee|dd|tar|bash|pwsh|powershell)\b') { return $false }
    if ($ScriptText -match '(?im)\bsystemctl\s+(?!show\b)[a-z-]+') { return $false }
    if ($ScriptText -match '(?im)\bip\s+(route|link|addr)\b') { return $false }
    return ($ScriptText -match 'systemctl show' -and $ScriptText -match 'ss -H' -and $ScriptText -match 'getent' -and $ScriptText -match 'find ')
}

function Test-ProviderActionAllowlist {
    param([string[]]$Actions)
    return (@($Actions | Where-Object { $_ -cnotin @('who','ls') }).Count -eq 0)
}

function Invoke-ReadOnlyNative {
    param([Parameter(Mandatory=$true)][string]$FileName, [Parameter(Mandatory=$true)][string[]]$Arguments, [int]$TimeoutMilliseconds=30000, [int]$OutputLimit=65536, [string]$WorkingDirectory=$script:projectRoot, [switch]$NonInteractiveGit, [switch]$SanitizeEnvironment)
    $psi = [Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $FileName
    $psi.WorkingDirectory = $WorkingDirectory
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    if ($SanitizeEnvironment) {
        $psi.Environment.Clear()
        foreach ($name in @('SystemRoot','WINDIR','PATH','USERPROFILE','HOME','HOMEDRIVE','HOMEPATH','TEMP','TMP')) {
            $value = [Environment]::GetEnvironmentVariable($name)
            if (-not [string]::IsNullOrWhiteSpace($value)) { $psi.Environment[$name] = $value }
        }
    }
    if ($NonInteractiveGit) { $psi.Environment['GIT_TERMINAL_PROMPT']='0'; $psi.Environment['GCM_INTERACTIVE']='Never' }
    foreach ($argument in $Arguments) { [void]$psi.ArgumentList.Add([string]$argument) }
    $process = [Diagnostics.Process]::new()
    try {
        $process.StartInfo = $psi
        if (-not $process.Start()) { throw 'NATIVE_PROCESS_START_FAILED' }
        $stdoutTask = $process.StandardOutput.ReadToEndAsync()
        $stderrTask = $process.StandardError.ReadToEndAsync()
        if (-not $process.WaitForExit($TimeoutMilliseconds)) {
            try { $process.Kill() } catch { }
            throw 'NATIVE_PROCESS_TIMEOUT'
        }
        $process.WaitForExit()
        $stdout = $stdoutTask.GetAwaiter().GetResult()
        $stderr = $stderrTask.GetAwaiter().GetResult()
        if ($stdout.Length -gt $OutputLimit -or $stderr.Length -gt $OutputLimit) { throw 'NATIVE_PROCESS_OUTPUT_LIMIT' }
        return [pscustomobject]@{ ExitCode=[int]$process.ExitCode; StdOut=[string]$stdout; StdErr=[string]$stderr }
    }
    finally { $process.Dispose() }
}

function Invoke-GitRead {
    param([Parameter(Mandatory=$true)][string[]]$Arguments, [string]$WorkingDirectory=$script:projectRoot)
    $allowed = @('rev-parse','remote','ls-remote','ls-files','status','branch')
    Assert-R1 ($Arguments.Count -ge 1 -and $Arguments[0] -cin $allowed) 'GIT_COMMAND_NOT_READ_ONLY'
    $git = (Get-Command git.exe -ErrorAction Stop).Source
    $result = Invoke-ReadOnlyNative -FileName $git -Arguments $Arguments -WorkingDirectory $WorkingDirectory -OutputLimit 131072 -NonInteractiveGit
    if ($result.ExitCode -ne 0) { throw 'GIT_READBACK_FAILED' }
    return [string]$result.StdOut
}

function Test-R1ReadOnlyReleaseContract {
    param([Parameter(Mandatory=$true)][string]$HandoffText, [Parameter(Mandatory=$true)][string]$GateText)
    $gateIds = [regex]::Matches($HandoffText,'(?m)^GATE_ID=([A-Z0-9_]+)\s*$')
    $readOnlyReleases = [regex]::Matches($HandoffText,'(?m)^R1_OWNER_READONLY_CHECKPOINT_RELEASED=(YES|NO)\s*$')
    $liveReleases = [regex]::Matches($HandoffText,'(?m)^FRESH_LIVE_GATE_RELEASED=(YES|NO)\s*$')
    return ($gateIds.Count -eq 1 -and $gateIds[0].Groups[1].Value -ceq 'G4B_TAKEOVER_REALITY_REBASE_READONLY_R1' -and
        $readOnlyReleases.Count -eq 1 -and $readOnlyReleases[0].Groups[1].Value -ceq 'YES' -and
        $liveReleases.Count -eq 1 -and $liveReleases[0].Groups[1].Value -ceq 'NO' -and
        $GateText.Contains('`G4B_TAKEOVER_REALITY_REBASE_READONLY_R1`',[StringComparison]::Ordinal))
}

function Get-SourceIdentity {
    $project = (Resolve-Path -LiteralPath $script:projectRoot -ErrorAction Stop).Path
    $handoff = [IO.File]::ReadAllText((Join-Path $project 'REVIEWER_HANDOFF.md'),[Text.Encoding]::UTF8)
    $gate = [IO.File]::ReadAllText((Join-Path $project 'docs/G4B_TAKEOVER_REALITY_REBASE_READONLY_R1.md'),[Text.Encoding]::UTF8)
    $released = Test-R1ReadOnlyReleaseContract -HandoffText $handoff -GateText $gate
    if (-not $released) { return [pscustomobject]@{ Known=$true; Pass=$false; Head='UNKNOWN'; Project=$project; Released=$false } }
    $root = (Invoke-GitRead -Arguments @('rev-parse','--show-toplevel') -WorkingDirectory $project).Trim()
    $prefix = (Invoke-GitRead -Arguments @('rev-parse','--show-prefix') -WorkingDirectory $project).Trim().TrimEnd([char]'/')
    $branch = (Invoke-GitRead -Arguments @('branch','--show-current') -WorkingDirectory $project).Trim()
    $head = (Invoke-GitRead -Arguments @('rev-parse','HEAD') -WorkingDirectory $project).Trim()
    $origin = (Invoke-GitRead -Arguments @('remote','get-url','origin') -WorkingDirectory $project).Trim()
    $gitExe = (Get-Command git.exe -ErrorAction Stop).Source
    $anchorCheck = Invoke-ReadOnlyNative -FileName $gitExe -Arguments @('-C',$project,'merge-base','--is-ancestor',$script:trustedAnchor,$head) -WorkingDirectory $project -OutputLimit 1024 -NonInteractiveGit
    $projectRelative = $prefix.TrimStart('/').TrimEnd('/')
    $helperRelative = $projectRelative + '/scripts/g4b-takeover-reality-rebase-readonly-r1.ps1'
    $handoffRelative = $projectRelative + '/REVIEWER_HANDOFF.md'
    $gateRelative = $projectRelative + '/docs/G4B_TAKEOVER_REALITY_REBASE_READONLY_R1.md'
    $tracked = @()
    foreach ($path in @($helperRelative,$handoffRelative,$gateRelative)) {
        $trackedPath = (Invoke-GitRead -Arguments @('ls-files','--full-name','--error-unmatch','--',$path) -WorkingDirectory $project).Trim()
        $tracked += ($trackedPath -ceq $path)
    }
    $dirty = (Invoke-GitRead -Arguments @('status','--porcelain','--untracked-files=no','--',$helperRelative,$handoffRelative,$gateRelative) -WorkingDirectory $project).Trim()
    $remoteLine = (Invoke-GitRead -Arguments @('ls-remote','--heads','origin','refs/heads/main') -WorkingDirectory $project).Trim()
    $remoteMatch = [regex]::Match($remoteLine,'^(?<sha>[0-9a-f]{40})\s+refs/heads/main$')
    $remoteHead = if ($remoteMatch.Success) { $remoteMatch.Groups['sha'].Value } else { '' }
    $rootFull = [IO.Path]::GetFullPath($root)
    $projectPrefixValid = ([IO.Path]::GetFileName($project) -ceq $script:projectName -and $projectRelative -match '(^|/)vpn-network-optimization$' -and (Test-PathWithin -Path $project -Parent $rootFull))
    $canonicalOrigin = ($origin -match '(?i)^(?:https://github\.com/entropy-student/project(?:\.git)?|git@github\.com:entropy-student/project(?:\.git)?)$')
    $sourcePass = ($projectPrefixValid -and $canonicalOrigin -and $branch -ceq 'main' -and $head -match '^[0-9a-f]{40}$' -and $head -ceq $remoteHead -and $anchorCheck.ExitCode -eq 0 -and $tracked -notcontains $false -and [string]::IsNullOrWhiteSpace($dirty) -and $released)
    return [pscustomobject]@{ Known=$true; Pass=$sourcePass; Head=$head; Project=$project; Released=$released }
}

$script:remoteProbe = @'
set -eu
host=$(/usr/bin/hostname)
os_id=$(/usr/bin/awk -F= '$1=="ID" {gsub(/\"/,"",$2); print $2}' /etc/os-release)
os_version=$(/usr/bin/awk -F= '$1=="VERSION_ID" {gsub(/\"/,"",$2); print $2}' /etc/os-release)
wg_state=$(/usr/bin/systemctl show -p ActiveState --value wg-quick@wg0)
hy_state=$(/usr/bin/systemctl show -p ActiveState --value hysteria2-vpn-network-optimization.service)
reality_load=$(/usr/bin/systemctl show -p LoadState --value mihomo-reality-vpn-network-optimization.service)
if [ "$reality_load" = not-found ]; then reality_active=inactive; reality_enable=not-found
else
  reality_active=$(/usr/bin/systemctl show -p ActiveState --value mihomo-reality-vpn-network-optimization.service)
  reality_enable=$(/usr/bin/systemctl show -p UnitFileState --value mihomo-reality-vpn-network-optimization.service)
fi
udp_count() { value=$(/usr/bin/ss -H -lun "sport = :$1"); printf '%s\n' "$value" | /usr/bin/awk 'NF {n++} END {print n+0}'; }
tcp443=$(/usr/bin/ss -H -ltnp 'sport = :443')
tcp443_count=$(printf '%s\n' "$tcp443" | /usr/bin/awk 'NF {n++} END {print n+0}')
if [ "$tcp443_count" -eq 0 ]; then tcp443_owner=NONE
elif printf '%s\n' "$tcp443" | /usr/bin/grep -Fq 'users:(("mihomo-reality"'; then tcp443_owner=PROJECT_REALITY
else tcp443_owner=OTHER_OR_UNKNOWN
fi
path_state() { if [ -L "$1" ]; then printf 'SYMLINK'; elif [ -e "$1" ]; then printf 'PRESENT'; else printf 'ABSENT'; fi; }
identity_state() { if /usr/bin/getent "$1" "$2" >/dev/null 2>&1; then printf 'YES'; else printf 'NO'; fi; }
count_prefix() { kinds=$(/usr/bin/find "$1" -mindepth 1 -maxdepth 1 -name "$2*" -printf '%y\n') || exit 41; printf '%s\n' "$kinds" | /usr/bin/awk 'NF {if ($0 == "d") d++; else u++} END {printf "%d|%d",d+0,u+0}'; }
txn=$(count_prefix /var/lib vpn-network-optimization-g4b-)
tmp=$(count_prefix /tmp vpn-network-optimization-g4b-)
printf 'HOST=%s\nOS_ID=%s\nOS_VERSION=%s\nWG_ACTIVE=%s\nHY2_ACTIVE=%s\nUDP51820=%s\nUDP8443=%s\nTCP443_COUNT=%s\nTCP443_OWNER=%s\nREALITY_LOAD=%s\nREALITY_ACTIVE=%s\nREALITY_ENABLE=%s\nREALITY_BINARY=%s\nREALITY_RUNTIME=%s\nREALITY_SECRET_CONFIG=%s\nREALITY_UNIT=%s\nRUNTIME_USER=%s\nRUNTIME_GROUP=%s\nG4B_TXN=%s\nG4B_TMP=%s\nG4B_TXN_NONDIR=%s\nG4B_TMP_NONDIR=%s\n' \
  "$host" "$os_id" "$os_version" "$wg_state" "$hy_state" "$(udp_count 51820)" "$(udp_count 8443)" "$tcp443_count" "$tcp443_owner" "$reality_load" "$reality_active" "$reality_enable" \
  "$(path_state /usr/local/lib/vpn-network-optimization/mihomo-reality)" "$(path_state /srv/apps/vpn-network-optimization/reality)" "$(path_state /srv/apps/vpn-network-optimization/secrets/reality-server.yaml)" "$(path_state /etc/systemd/system/mihomo-reality-vpn-network-optimization.service)" \
  "$(identity_state passwd reality-vpn-network-optimization)" "$(identity_state group reality-vpn-network-optimization)" "${txn%%|*}" "${tmp%%|*}" "${txn#*|}" "${tmp#*|}"
'@

function Test-RemoteReadOnlyOutput {
    param([Parameter(Mandatory=$true)][string]$Text)
    $allowed = @('HOST','OS_ID','OS_VERSION','WG_ACTIVE','HY2_ACTIVE','UDP51820','UDP8443','TCP443_COUNT','TCP443_OWNER','REALITY_LOAD','REALITY_ACTIVE','REALITY_ENABLE','REALITY_BINARY','REALITY_RUNTIME','REALITY_SECRET_CONFIG','REALITY_UNIT','RUNTIME_USER','RUNTIME_GROUP','G4B_TXN','G4B_TMP','G4B_TXN_NONDIR','G4B_TMP_NONDIR')
    $values = @{}
    foreach ($line in @($Text -split "`r?`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })) {
        $match = [regex]::Match($line,'^(?<key>[A-Z0-9_]+)=(?<value>[^\r\n]*)$')
        if (-not $match.Success -or $match.Groups['key'].Value -cnotin $allowed -or $values.ContainsKey($match.Groups['key'].Value)) { return $null }
        $values[$match.Groups['key'].Value] = $match.Groups['value'].Value
    }
    if ($values.Count -ne $allowed.Count) { return $null }
    $patterns = @{
        HOST='[a-zA-Z0-9.-]{1,128}'; OS_ID='[a-zA-Z0-9._-]{1,32}'; OS_VERSION='[0-9.]{1,16}'; WG_ACTIVE='active|inactive|failed|activating|deactivating|unknown'; HY2_ACTIVE='active|inactive|failed|activating|deactivating|unknown'
        UDP51820='[0-9]{1,6}'; UDP8443='[0-9]{1,6}'; TCP443_COUNT='[0-9]{1,6}'; TCP443_OWNER='NONE|PROJECT_REALITY|OTHER_OR_UNKNOWN'
        REALITY_LOAD='loaded|not-found|error|masked'; REALITY_ACTIVE='active|inactive|failed|activating|deactivating|unknown'; REALITY_ENABLE='enabled|disabled|static|indirect|masked|generated|transient|linked|linked-runtime|alias|not-found'
        REALITY_BINARY='PRESENT|ABSENT|SYMLINK'; REALITY_RUNTIME='PRESENT|ABSENT|SYMLINK'; REALITY_SECRET_CONFIG='PRESENT|ABSENT|SYMLINK'; REALITY_UNIT='PRESENT|ABSENT|SYMLINK'; RUNTIME_USER='YES|NO'; RUNTIME_GROUP='YES|NO'
        G4B_TXN='[0-9]{1,6}'; G4B_TMP='[0-9]{1,6}'; G4B_TXN_NONDIR='[0-9]{1,6}'; G4B_TMP_NONDIR='[0-9]{1,6}'
    }
    foreach ($key in $allowed) { if ($values[$key] -notmatch ('^(?:' + $patterns[$key] + ')$')) { return $null } }
    return $values
}

function Get-RemoteSnapshot {
    param([string]$IdentityPath, [string]$KnownHostsPath)
    if ([string]::IsNullOrWhiteSpace($IdentityPath) -or [string]::IsNullOrWhiteSpace($KnownHostsPath)) { return $null }
    foreach ($path in @($IdentityPath,$KnownHostsPath)) {
        if (-not [IO.Path]::IsPathRooted($path) -or $path.StartsWith('\\',[StringComparison]::OrdinalIgnoreCase)) { return $null }
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return $null }
        $item = Get-Item -LiteralPath $path -Force -ErrorAction Stop
        if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { return $null }
    }
    $ssh = (Get-Command ssh.exe -ErrorAction Stop).Source
    $arguments = @('-T','-i',$IdentityPath,'-o','BatchMode=yes','-o','IdentitiesOnly=yes','-o','StrictHostKeyChecking=yes','-o','UpdateHostKeys=no','-o',('HostKeyAlias=' + $script:hostKeyAlias),'-o',('UserKnownHostsFile=' + $KnownHostsPath),'-o','ConnectTimeout=10',$script:sshTarget,$script:remoteProbe)
    if (-not (Test-StrictSshArguments -Arguments $arguments) -or -not (Test-RemoteReadOnlyProbe -ScriptText $script:remoteProbe)) { throw 'SSH_CONTRACT_INVALID' }
    $result = Invoke-ReadOnlyNative -FileName $ssh -Arguments $arguments -TimeoutMilliseconds 45000 -OutputLimit 65536 -SanitizeEnvironment
    if ($result.ExitCode -ne 0) { return $null }
    return Test-RemoteReadOnlyOutput -Text $result.StdOut
}

function Get-RemoteRealityState {
    param([hashtable]$Data)
    if ($null -eq $Data) { return [pscustomobject]@{ Known=$false; Healthy=$false; Residual=$false; Values=@{} } }
    $identityPass = ($Data['HOST'] -ceq 'ubuntu-s-1vcpu-512mb-10gb-sfo3' -and $Data['OS_ID'] -ceq 'ubuntu' -and $Data['OS_VERSION'] -ceq '24.04')
    $wgUdp = 0; $hyUdp = 0
    $wgHealthy = ($Data['WG_ACTIVE'] -ceq 'active' -and [int]::TryParse($Data['UDP51820'],[ref]$wgUdp) -and $wgUdp -ge 1)
    $hyHealthy = ($Data['HY2_ACTIVE'] -ceq 'active' -and [int]::TryParse($Data['UDP8443'],[ref]$hyUdp) -and $hyUdp -ge 1)
    $tcpCount = 0
    $tcpValid = [int]::TryParse($Data['TCP443_COUNT'],[ref]$tcpCount)
    $pathValues = @($Data['REALITY_BINARY'],$Data['REALITY_RUNTIME'],$Data['REALITY_SECRET_CONFIG'],$Data['REALITY_UNIT'])
    $identityValues = @($Data['RUNTIME_USER'],$Data['RUNTIME_GROUP'])
    $txn = 0; $tmp = 0; $txnOther = 0; $tmpOther = 0
    $countsValid = ([int]::TryParse($Data['G4B_TXN'],[ref]$txn) -and [int]::TryParse($Data['G4B_TMP'],[ref]$tmp) -and [int]::TryParse($Data['G4B_TXN_NONDIR'],[ref]$txnOther) -and [int]::TryParse($Data['G4B_TMP_NONDIR'],[ref]$tmpOther))
    $serviceStateKnown = ($Data['REALITY_LOAD'] -in @('loaded','not-found','error','masked') -and $Data['REALITY_ACTIVE'] -in @('active','inactive','failed','activating','deactivating','unknown') -and $Data['REALITY_ENABLE'] -in @('enabled','disabled','static','indirect','masked','generated','transient','linked','linked-runtime','alias','not-found'))
    $known = ($tcpValid -and $countsValid -and $serviceStateKnown -and @($pathValues | Where-Object { $_ -notin @('PRESENT','ABSENT','SYMLINK') }).Count -eq 0 -and @($identityValues | Where-Object { $_ -notin @('YES','NO') }).Count -eq 0)
    $residual = ($tcpCount -gt 0 -or $Data['REALITY_LOAD'] -cne 'not-found' -or $Data['REALITY_ACTIVE'] -notin @('inactive','failed') -or $Data['REALITY_ENABLE'] -cne 'not-found' -or @($pathValues | Where-Object { $_ -cne 'ABSENT' }).Count -gt 0 -or @($identityValues | Where-Object { $_ -ceq 'YES' }).Count -gt 0 -or $txn -gt 0 -or $tmp -gt 0)
    $healthy = ($identityPass -and $wgHealthy -and $hyHealthy -and $tcpValid -and ($tcpCount -eq 0 -or $Data['TCP443_OWNER'] -ceq 'PROJECT_REALITY') -and $countsValid -and $serviceStateKnown -and $txnOther -eq 0 -and $tmpOther -eq 0 -and @($pathValues | Where-Object { $_ -ceq 'SYMLINK' }).Count -eq 0)
    return [pscustomobject]@{ Known=$known; Healthy=$healthy; WireGuardHealthy=$wgHealthy; Hy2Healthy=$hyHealthy; IdentityPass=$identityPass; Residual=$residual; Values=$Data }
}

function Get-VerifiedBaiduCli {
    try { return Find-VerifiedBaiduCli -ExecutablePath $BaiduCliPath -ArchivePath $BaiduCliArchivePath } catch { return $null }
}

function Invoke-BaiduReadOnlyAction {
    param([Parameter(Mandatory=$true)][ValidateSet('who','ls')][string]$Action, [Parameter(Mandatory=$true)][string]$Executable, [Parameter(Mandatory=$true)][string]$ConfigDirectory)
    $psi = [Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $Executable; $psi.UseShellExecute = $false; $psi.CreateNoWindow = $true
    $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true
    $utf8 = [Text.UTF8Encoding]::new($false)
    $psi.StandardOutputEncoding = $utf8; $psi.StandardErrorEncoding = $utf8
    $psi.Environment.Clear()
    foreach ($name in @('SystemRoot','WINDIR')) { $value=[Environment]::GetEnvironmentVariable($name); if (-not [string]::IsNullOrWhiteSpace($value)) { $psi.Environment[$name]=$value } }
    if (-not [string]::IsNullOrWhiteSpace($env:SystemRoot)) { $psi.Environment['PATH']=Join-Path $env:SystemRoot 'System32' }
    $psi.Environment['BAIDUPCS_GO_CONFIG_DIR']=$ConfigDirectory
    $psi.Environment['BAIDUPCS_GO_VERBOSE']='0'
    [void]$psi.ArgumentList.Add($Action)
    if ($Action -ceq 'ls') { [void]$psi.ArgumentList.Add('-l'); [void]$psi.ArgumentList.Add($script:recoveryDirectory) }
    $process = [Diagnostics.Process]::new()
    try {
        $process.StartInfo=$psi
        if (-not $process.Start()) { throw 'BAIDU_PROCESS_START_FAILED' }
        $stdoutTask=$process.StandardOutput.ReadToEndAsync(); $stderrTask=$process.StandardError.ReadToEndAsync()
        if (-not $process.WaitForExit(30000)) { try { $process.Kill() } catch { }; throw 'BAIDU_PROCESS_TIMEOUT' }
        $process.WaitForExit()
        $stdout=$stdoutTask.GetAwaiter().GetResult(); $stderr=$stderrTask.GetAwaiter().GetResult()
        if ($stdout.Length -gt 1048576 -or $stderr.Length -gt 65536) { throw 'BAIDU_PROCESS_OUTPUT_LIMIT' }
        return [pscustomobject]@{ ExitCode=[int]$process.ExitCode; StdOut=[string]$stdout; StdErr=[string]$stderr }
    }
    finally { $process.Dispose() }
}

function Get-BaiduRealityState {
    param([string]$Executable)
    $unknown = [pscustomobject]@{ Known=$false; Identity='UNKNOWN'; DirectoryReadable='UNKNOWN'; FinalCount='UNKNOWN'; PendingCount='UNKNOWN'; UnknownCount='UNKNOWN'; QuarantineCount='UNKNOWN'; FailureCode='PROVIDER_IDENTITY_CONFIRMATION_REQUIRED' }
    if ([string]::IsNullOrWhiteSpace($Executable)) { return $unknown }
    $config = Join-Path $env:APPDATA 'BaiduPCS-Go'
    $ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
    try { Assert-SafeBaiduConfigDirectory -ConfigDirectory $config -ProjectRoot $script:projectRoot -OwnerSid $ownerSid }
    catch { return $unknown }
    $secureUid = $null; $uidPtr = [IntPtr]::Zero; $expectedUid = $null; $who = $null; $listing = $null
    try {
        $secureUid = Read-Host 'Enter the intended account UID locally (hidden; it will not be displayed or recorded)' -AsSecureString
        $uidPtr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureUid)
        $expectedUid = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($uidPtr)
        if ($expectedUid -notmatch '^[1-9][0-9]{0,19}$') { return $unknown }
        $who = Invoke-BaiduReadOnlyAction -Action 'who' -Executable $Executable -ConfigDirectory $config
        if ($who.ExitCode -ne 0) { return $unknown }
        $uidMatches = [regex]::Matches($who.StdOut,'(?m)^当前帐号 uid:\s*([0-9]+),')
        if ($uidMatches.Count -ne 1 -or $uidMatches[0].Groups[1].Value -cne $expectedUid) { return [pscustomobject]@{ Known=$true; Identity='FAIL'; DirectoryReadable='UNKNOWN'; FinalCount='UNKNOWN'; PendingCount='UNKNOWN'; UnknownCount='UNKNOWN'; QuarantineCount='UNKNOWN'; FailureCode='PROVIDER_IDENTITY_CONFIRMATION_REQUIRED' } }
        $listing = Invoke-BaiduReadOnlyAction -Action 'ls' -Executable $Executable -ConfigDirectory $config
        if ($listing.ExitCode -ne 0) { return [pscustomobject]@{ Known=$false; Identity='PASS'; DirectoryReadable='NO'; FinalCount='UNKNOWN'; PendingCount='UNKNOWN'; UnknownCount='UNKNOWN'; QuarantineCount='UNKNOWN'; FailureCode='PROVIDER_READ_ONLY_LISTING_FAILED' } }
        $counts = Get-BaiduListingCounts -Listing $listing.StdOut
        if (-not $counts.Valid) { return [pscustomobject]@{ Known=$false; Identity='PASS'; DirectoryReadable='UNKNOWN'; FinalCount='UNKNOWN'; PendingCount='UNKNOWN'; UnknownCount='UNKNOWN'; QuarantineCount='UNKNOWN'; FailureCode='PROVIDER_READ_ONLY_LISTING_AMBIGUOUS' } }
        return [pscustomobject]@{ Known=$true; Identity='PASS'; DirectoryReadable='YES'; FinalCount=$counts.FinalCount; PendingCount=$counts.PendingCount; UnknownCount=$counts.UnknownCount; QuarantineCount=$counts.QuarantineCount; FailureCode='NONE' }
    }
    catch { return $unknown }
    finally {
        if ($uidPtr -ne [IntPtr]::Zero) { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($uidPtr) }
        if ($null -ne $secureUid) { $secureUid.Dispose() }
        $expectedUid=$null; $who=$null; $listing=$null
    }
}

function Get-UnknownRemoteState {
    return [pscustomobject]@{ Known=$false; Healthy=$false; Residual=$false; Values=@{} }
}

function Invoke-R1Checkpoint {
    $unknown = 'UNKNOWN'
    $source = $null; $windows = $null; $local = $null; $remote = $null; $baidu = $null
    $activeBefore = $null; $persistentBefore = $null; $routesUnchanged = 'UNKNOWN'
    $failure = 'NONE'
    try {
        $source = Get-SourceIdentity
        if (-not $source.Pass) { throw 'SOURCE_PREFLIGHT_FAILED' }
        $activeBefore = Get-RouteFingerprint -Store ActiveStore
        $persistentBefore = Get-RouteFingerprint -Store PersistentStore
        $windows = Get-WindowsBaseline
        $local = Get-LocalArtifactSnapshot
        if ($windows.Healthy) {
            $remoteData = $null
            try { $remoteData = Get-RemoteSnapshot -IdentityPath $SshIdentityFile -KnownHostsPath $KnownHostsFile } catch { $remoteData=$null }
            if ($null -ne $remoteData) { $remote = Get-RemoteRealityState -Data $remoteData } else { $remote = Get-UnknownRemoteState }
            $cli = Get-VerifiedBaiduCli
            $baidu = Get-BaiduRealityState -Executable $cli
        }
        else { $remote = Get-UnknownRemoteState; $baidu = [pscustomobject]@{ Known=$false; Identity='UNKNOWN'; DirectoryReadable='UNKNOWN'; FinalCount='UNKNOWN'; PendingCount='UNKNOWN'; UnknownCount='UNKNOWN'; QuarantineCount='UNKNOWN'; FailureCode='NONE' } }
        $activeAfter = Get-RouteFingerprint -Store ActiveStore
        $persistentAfter = Get-RouteFingerprint -Store PersistentStore
        $routesUnchanged = if (($activeBefore -join "`n") -ceq ($activeAfter -join "`n") -and ($persistentBefore -join "`n") -ceq ($persistentAfter -join "`n")) { 'YES' } else { 'NO' }
        if ($routesUnchanged -cne 'YES') { $windows.Healthy=$false }
    }
    catch {
        $message = [string]$_.Exception.Message
        $knownFailures = @('SOURCE_PREFLIGHT_FAILED','ROUTE_OBJECT_SHAPE_INVALID','ROUTE_PREFIX_INVALID','ROUTE_INTERFACE_METRIC_MISSING','ROUTE_INTERFACE_METRIC_INVALID','WIREGUARD_ADAPTER_INVALID','WIREGUARD_SPLIT_ROUTE_INVALID','NATIVE_PROCESS_START_FAILED','NATIVE_PROCESS_TIMEOUT','NATIVE_PROCESS_OUTPUT_LIMIT','GIT_COMMAND_NOT_READ_ONLY','GIT_READBACK_FAILED','OUTPUT_CONTRACT_INVALID')
        if ($message -cin $knownFailures) { $failure=$message } else { $failure='CHECKPOINT_READBACK_FAILED' }
        if ($null -ne $activeBefore -and $null -ne $persistentBefore) { try { $a=Get-RouteFingerprint -Store ActiveStore; $p=Get-RouteFingerprint -Store PersistentStore; $routesUnchanged=if (($activeBefore -join "`n") -ceq ($a -join "`n") -and ($persistentBefore -join "`n") -ceq ($p -join "`n")) {'YES'} else {'NO'} } catch { $routesUnchanged='UNKNOWN' } }
    }
    if ($null -eq $windows) { $windows=[pscustomobject]@{ Known=$false; Healthy=$false; WireGuardHealthy=$false; ClashHealthy=$false; ProxyOff=$false; TunOff=$false; TunCount='UNKNOWN' } }
    if ($null -eq $local -or -not $local.Known) { $local=[pscustomobject]@{ Known=$false; RuntimeCount='UNKNOWN'; JournalCount='UNKNOWN'; RecoveryFinal='UNKNOWN'; PendingCount='UNKNOWN'; ProfileCount='UNKNOWN' } }
    if ($null -eq $remote) { $remote=Get-UnknownRemoteState }
    if ($null -eq $baidu) { $baidu=[pscustomobject]@{ Known=$false; Identity='UNKNOWN'; DirectoryReadable='UNKNOWN'; FinalCount='UNKNOWN'; PendingCount='UNKNOWN'; UnknownCount='UNKNOWN'; QuarantineCount='UNKNOWN'; FailureCode='NONE' } }
    if ($failure -ceq 'NONE' -and $baidu.FailureCode -cne 'NONE') { $failure=[string]$baidu.FailureCode }
    $reality=Get-RealityClassification -Windows ([pscustomobject]@{Known=($windows.Known -and $null -ne $source -and $source.Pass); Healthy=$windows.Healthy}) -Local $local -Vps $remote -Baidu $baidu
    $markers=[ordered]@{
        G4B_TAKEOVER_REALITY_REBASE_READONLY=$(if ($failure -ceq 'NONE') {'PASS_CANDIDATE'} else {'FAIL_CLOSED'})
        FAILURE_CODE=$failure
        WINDOWS_RUNTIME=$(if ($PSVersionTable.PSVersion) {$PSVersionTable.PSVersion.ToString()} else {'UNKNOWN'})
        CANONICAL_SOURCE=$(if ($null -eq $source) {'UNKNOWN'} elseif ($source.Pass) {'PASS'} else {'FAIL'})
        SOURCE_HEAD=$(if ($null -ne $source -and $source.Head -match '^[0-9a-f]{40}$') {$source.Head} else {'UNKNOWN'})
        WINDOWS_WG_HEALTHY=$(if (-not $windows.Known) {'UNKNOWN'} elseif ($windows.WireGuardHealthy) {'YES'} else {'NO'})
        WINDOWS_CLASH_HEALTHY=$(if (-not $windows.Known) {'UNKNOWN'} elseif ($windows.ClashHealthy) {'YES'} else {'NO'})
        SYSTEM_PROXY_OFF=$(if (-not $windows.Known) {'UNKNOWN'} elseif ($windows.ProxyOff) {'YES'} else {'NO'})
        TUN_OFF=$(if (-not $windows.Known) {'UNKNOWN'} elseif ($windows.TunOff) {'YES'} else {'NO'})
        ROUTES_UNCHANGED=$routesUnchanged
        LOCAL_G4B_RUNTIME_COUNT=[string]$local.RuntimeCount
        LOCAL_G4B_JOURNAL_COUNT=[string]$local.JournalCount
        LOCAL_REALITY_RECOVERY_FINAL_PRESENT=$(if ($local.RecoveryFinal -is [bool]) {if ($local.RecoveryFinal) {'YES'} else {'NO'}} else {'UNKNOWN'})
        LOCAL_REALITY_RECOVERY_PENDING_COUNT=[string]$local.PendingCount
        SELF_VPN_V1_PROFILE_CANDIDATE_COUNT=[string]$local.ProfileCount
        VPS_IDENTITY=$(if ($remote.Known) {if ($remote.IdentityPass) {'PASS'} else {'FAIL'}} else {'UNKNOWN'})
        VPS_WG_HEALTHY=$(if ($remote.Known) {if ($remote.WireGuardHealthy) {'YES'} else {'NO'}} else {'UNKNOWN'})
        VPS_HY2_HEALTHY=$(if ($remote.Known) {if ($remote.Hy2Healthy) {'YES'} else {'NO'}} else {'UNKNOWN'})
        VPS_TCP443_COUNT=$(if ($remote.Known) {[string]$remote.Values['TCP443_COUNT']} else {'UNKNOWN'})
        VPS_TCP443_OWNER_CLASS=$(if ($remote.Known) {[string]$remote.Values['TCP443_OWNER']} else {'UNKNOWN'})
        VPS_REALITY_SERVICE_LOAD=$(if ($remote.Known) {[string]$remote.Values['REALITY_LOAD']} else {'UNKNOWN'})
        VPS_REALITY_SERVICE_ACTIVE=$(if ($remote.Known) {[string]$remote.Values['REALITY_ACTIVE']} else {'UNKNOWN'})
        VPS_REALITY_SERVICE_ENABLE=$(if ($remote.Known) {[string]$remote.Values['REALITY_ENABLE']} else {'UNKNOWN'})
        VPS_REALITY_BINARY_PRESENT=$(if ($remote.Known) {if ($remote.Values['REALITY_BINARY'] -ceq 'ABSENT') {'NO'} else {'YES'}} else {'UNKNOWN'})
        VPS_REALITY_RUNTIME_PRESENT=$(if ($remote.Known) {if ($remote.Values['REALITY_RUNTIME'] -ceq 'ABSENT') {'NO'} else {'YES'}} else {'UNKNOWN'})
        VPS_REALITY_SECRET_CONFIG_PRESENT=$(if ($remote.Known) {if ($remote.Values['REALITY_SECRET_CONFIG'] -ceq 'ABSENT') {'NO'} else {'YES'}} else {'UNKNOWN'})
        VPS_REALITY_UNIT_PRESENT=$(if ($remote.Known) {if ($remote.Values['REALITY_UNIT'] -ceq 'ABSENT') {'NO'} else {'YES'}} else {'UNKNOWN'})
        VPS_REALITY_RUNTIME_USER_PRESENT=$(if ($remote.Known) {[string]$remote.Values['RUNTIME_USER']} else {'UNKNOWN'})
        VPS_REALITY_RUNTIME_GROUP_PRESENT=$(if ($remote.Known) {[string]$remote.Values['RUNTIME_GROUP']} else {'UNKNOWN'})
        VPS_G4B_TXN_COUNT=$(if ($remote.Known) {[string]$remote.Values['G4B_TXN']} else {'UNKNOWN'})
        VPS_G4B_TMP_COUNT=$(if ($remote.Known) {[string]$remote.Values['G4B_TMP']} else {'UNKNOWN'})
        BAIDU_IDENTITY_CHECK=[string]$baidu.Identity
        BAIDU_RECOVERY_DIRECTORY_READABLE=[string]$baidu.DirectoryReadable
        BAIDU_FINAL_COUNT=[string]$baidu.FinalCount
        BAIDU_PENDING_COUNT=[string]$baidu.PendingCount
        BAIDU_UNKNOWN_PROJECT_COUNT=[string]$baidu.UnknownCount
        BAIDU_QUARANTINE_COUNT=[string]$baidu.QuarantineCount
        CURRENT_REALITY=$reality
        LOCAL_MUTATION='NO'; REMOTE_MUTATION='NO'; PROVIDER_MUTATION='NO'; SECRET_VALUES_EMITTED='0'; STOP_AT_REVIEWER='YES'
    }
    foreach ($entry in $markers.GetEnumerator()) { Write-R1Marker -Name $entry.Key -Value ([string]$entry.Value) }
}

if (-not $LibraryOnly) { Invoke-R1Checkpoint }
