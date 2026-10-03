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
$script:recoveryCiphertext = $null
$script:recoveryPlaintext = $null
$script:authBytes = $null
$script:hy2Auth = $null
$script:configTestOutput = $null
$script:failureClass = 'NONE'
$script:cleanupPassed = $false
$script:uiCleanupAcknowledged = $false
$script:cleanupErrors = [Collections.Generic.List[string]]::new()
$script:renderedText = $null
$script:configBytes = $null
$script:acceptedText = $null

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

function Read-C2BExactBytes {
    param([IO.BinaryReader]$Reader, [int]$Count)
    $value = $Reader.ReadBytes($Count)
    if ($value.Length -ne $Count) { throw 'RECOVERY_FRAME_TRUNCATED' }
    return ,$value
}

function Read-C2BRecoveryClientFields {
    param([byte[]]$Bytes)
    if ($Bytes.Length -lt 8 -or $Bytes.Length -gt 131072) { throw 'RECOVERY_FRAME_SIZE_INVALID' }
    $stream = [IO.MemoryStream]::new($Bytes, $false)
    $reader = [IO.BinaryReader]::new($stream, [Text.Encoding]::UTF8, $true)
    $seen = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $localAuth = $null
    $localCert = $null
    $cert = $null
    $authText = $null
    try {
        $magic = [Text.Encoding]::ASCII.GetString((Read-C2BExactBytes $reader 8))
        if ($magic -cne 'VPNHY2R1') { throw 'RECOVERY_FRAME_MAGIC_INVALID' }
        while ($stream.Position -lt $stream.Length) {
            $nameLength = [int]$reader.ReadByte()
            if ($nameLength -lt 1 -or $nameLength -gt 32) { throw 'RECOVERY_FRAME_NAME_LENGTH_INVALID' }
            $lengthBytes = Read-C2BExactBytes $reader 4
            $dataLength = ([uint32]$lengthBytes[0] -shl 24) -bor
                          ([uint32]$lengthBytes[1] -shl 16) -bor
                          ([uint32]$lengthBytes[2] -shl 8) -bor [uint32]$lengthBytes[3]
            if ($dataLength -lt 1 -or $dataLength -gt 65536) { throw 'RECOVERY_FRAME_DATA_LENGTH_INVALID' }
            $name = [Text.Encoding]::UTF8.GetString((Read-C2BExactBytes $reader $nameLength))
            if ($name -notin @('hy2-auth', 'server.key', 'server.crt') -or -not $seen.Add($name)) {
                throw 'RECOVERY_FRAME_ALLOWLIST_INVALID'
            }
            $value = Read-C2BExactBytes $reader ([int]$dataLength)
            if ($name -ceq 'hy2-auth') { $localAuth = $value }
            elseif ($name -ceq 'server.crt') { $localCert = $value }
            else { [Security.Cryptography.CryptographicOperations]::ZeroMemory($value) }
        }
        if ($seen.Count -ne 3 -or $null -eq $localAuth -or $null -eq $localCert) {
            throw 'RECOVERY_FRAME_CARDINALITY_INVALID'
        }
        $authText = [Text.Encoding]::ASCII.GetString($localAuth)
        if ($authText -cnotmatch '^[0-9a-f]{64}$') { throw 'RECOVERY_AUTH_FORMAT_INVALID' }
        $cert = [Security.Cryptography.X509Certificates.X509Certificate2]::new($localCert)
        $ecdsa = [Security.Cryptography.X509Certificates.ECDsaCertificateExtensions]::GetECDsaPublicKey($cert)
        try {
            if ($null -eq $ecdsa -or $ecdsa.KeySize -ne 256 -or
                $ecdsa.ExportParameters($false).Curve.Oid.Value -ne '1.2.840.10045.3.1.7') {
                throw 'RECOVERY_CERTIFICATE_KEY_TYPE_INVALID'
            }
        }
        finally { if ($null -ne $ecdsa) { $ecdsa.Dispose() } }
        $sanExtension = @($cert.Extensions | Where-Object { $_.Oid.Value -eq '2.5.29.17' })
        if ($sanExtension.Count -ne 1) { throw 'RECOVERY_CERTIFICATE_SAN_INVALID' }
        $san = [Security.Cryptography.X509Certificates.X509SubjectAlternativeNameExtension]::new($sanExtension[0].RawData)
        $dns = @($san.EnumerateDnsNames())
        if ($dns.Count -ne 1 -or $dns[0] -cne 'hy2.sfo3-a.invalid') { throw 'RECOVERY_CERTIFICATE_SAN_INVALID' }
        $fingerprint = [Convert]::ToHexString($cert.GetCertHash([Security.Cryptography.HashAlgorithmName]::SHA256))
        $fingerprint = ($fingerprint -split '(..)' | Where-Object { $_ }) -join ':'
        return [pscustomobject]@{ AuthBytes = $localAuth; Fingerprint = $fingerprint }
    }
    catch {
        if ($null -ne $localAuth) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($localAuth) }
        throw
    }
    finally {
        $authText = $null
        if ($null -ne $localCert) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($localCert) }
        if ($null -ne $cert) { $cert.Dispose() }
        $reader.Dispose()
        $stream.Dispose()
    }
}

function Get-C2BPhysicalEgress {
    $adapters = @(Get-NetAdapter -Physical -ErrorAction Stop | Where-Object { $_.Status -eq 'Up' })
    $routes = @(Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -DestinationPrefix '0.0.0.0/0' -ErrorAction Stop)
    $candidates = @()
    foreach ($route in $routes) {
        $adapter = @($adapters | Where-Object { $_.ifIndex -eq $route.InterfaceIndex })
        if ($adapter.Count -ne 1) { continue }
        $ip = Get-NetIPConfiguration -InterfaceIndex $adapter[0].ifIndex -ErrorAction Stop
        $gateway = @($ip.IPv4DefaultGateway | Where-Object { $_.NextHop })
        $source = @($ip.IPv4Address | Where-Object { $_.IPAddress -and $_.IPAddress -notmatch '^169\.254\.' })
        if ($gateway.Count -ne 1 -or $source.Count -lt 1) { continue }
        $ipInterface = Get-NetIPInterface -InterfaceIndex $adapter[0].ifIndex -AddressFamily IPv4 -ErrorAction Stop
        $cost = [long]$route.RouteMetric + [long]$ipInterface.InterfaceMetric
        $candidates += [pscustomobject]@{
            Name = [string]$adapter[0].Name
            IfIndex = [int]$adapter[0].ifIndex
            Gateway = [string]$gateway[0].NextHop
            SourceIPv4 = [string]$source[0].IPAddress
            Cost = $cost
        }
    }
    if ($candidates.Count -eq 0) { throw 'PHYSICAL_EGRESS_NOT_FOUND' }
    $minimum = ($candidates | Measure-Object -Property Cost -Minimum).Minimum
    $best = @($candidates | Where-Object { $_.Cost -eq $minimum } | Group-Object IfIndex)
    if ($best.Count -ne 1) { throw 'PHYSICAL_EGRESS_AMBIGUOUS' }
    return $best[0].Group[0]
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

try {
    $script:phase = 'PRECHECK_RUNTIME'
    Assert-C2B ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
    Assert-C2B ($null -ne $script:ownerSid) 'OWNER_SID_UNAVAILABLE'
    $baseProject = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization'
    $recoveryPath = Join-Path $baseProject 'recovery\hy2-g2a.dpapi'
    $templatePath = Join-Path $PSScriptRoot '..\templates\clash\c2b-wg-hy2-canary.yaml.template'
    $acceptedHy2Path = Join-Path $PSScriptRoot '..\config\clash\sfo3-a-hy2.yaml'
    $mihomoPath = 'C:\Program Files\Clash Verge\verge-mihomo.exe'
    Assert-C2B (Test-Path -LiteralPath $recoveryPath -PathType Leaf) 'DPAPI_RECOVERY_ARTIFACT_MISSING'
    Assert-C2B (Test-Path -LiteralPath $templatePath -PathType Leaf) 'CANARY_TEMPLATE_MISSING'
    Assert-C2B (Test-Path -LiteralPath $acceptedHy2Path -PathType Leaf) 'ACCEPTED_HY2_METADATA_MISSING'
    Assert-C2B (Test-Path -LiteralPath $mihomoPath -PathType Leaf) 'MIHOMO_BINARY_MISSING'
    Assert-C2BOwnerAcl -Path $recoveryPath
    $mihomoVersion = @(& $mihomoPath -v 2>&1)
    if ($LASTEXITCODE -ne 0 -or ($mihomoVersion -join ' ') -notmatch '\bv1\.19\.32\b') { throw 'MIHOMO_VERSION_MISMATCH' }

    $script:phase = 'PRECHECK_NETWORK_STATE'
    $script:before = Get-C2BState
    Assert-C2BState -State $script:before
    $physical = Get-C2BPhysicalEgress

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

    $script:phase = 'DPAPI_UNPROTECT_IN_MEMORY'
    Add-Type -AssemblyName System.Security.Cryptography.ProtectedData
    $script:recoveryCiphertext = [IO.File]::ReadAllBytes($recoveryPath)
    $script:recoveryPlaintext = [Security.Cryptography.ProtectedData]::Unprotect(
        $script:recoveryCiphertext, $null, [Security.Cryptography.DataProtectionScope]::CurrentUser
    )
    $recoveryFields = Read-C2BRecoveryClientFields -Bytes $script:recoveryPlaintext
    $script:authBytes = $recoveryFields.AuthBytes
    $script:hy2Auth = [Text.Encoding]::ASCII.GetString($script:authBytes)
    $script:acceptedText = [IO.File]::ReadAllText($acceptedHy2Path)
    $acceptedMatches = [regex]::Matches($script:acceptedText, '(?im)^\s*fingerprint:\s*(?<value>(?:[0-9A-F]{2}:){31}[0-9A-F]{2})\s*$')
    if ($acceptedMatches.Count -ne 1 -or $acceptedMatches[0].Groups['value'].Value -cne $recoveryFields.Fingerprint) {
        throw 'HY2_CERTIFICATE_FINGERPRINT_MISMATCH'
    }

    $script:phase = 'RENDER_AND_CONFIG_TEST'
    $script:renderedText = [IO.File]::ReadAllText($templatePath)
    $script:renderedText = $script:renderedText.Replace('__HY2_AUTH_INJECTED_IN_OWNER_RUNTIME__', $script:hy2Auth)
    $script:renderedText = $script:renderedText.Replace('__HY2_FINGERPRINT_INJECTED_IN_OWNER_RUNTIME__', $recoveryFields.Fingerprint)
    $script:renderedText = $script:renderedText.Replace('__PHYSICAL_INTERFACE_RUNTIME_DISCOVERY__', $physical.Name)
    $null = ConvertFrom-Json -InputObject $script:renderedText -AsHashtable -ErrorAction Stop
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
    Write-Output ('PHYSICAL_INTERFACE=' + $physical.Name)
    Write-Output ('TEMP_PROFILE_PATH=' + $script:runtimeConfigPath)
    Write-Output 'OWNER_UI_STEP=Only after C2B authorization: import the temporary profile, keep WG connected and proxy/TUN off, perform only the authorized UI check, remove the imported profile, then return here.'
    $ack = Read-Host 'After removing the temporary profile in Clash Verge, type PROFILE_REMOVED'
    if ($ack -cne 'PROFILE_REMOVED') { throw 'OWNER_UI_CLEANUP_NOT_ACKNOWLEDGED' }
    $script:uiCleanupAcknowledged = $true

    $script:phase = 'POST_UI_READBACK'
    $after = Get-C2BState
    Assert-C2BState -State $after
    Assert-C2BSameState -Before $script:before -After $after
    Write-Output 'POST_UI_NETWORK_READBACK=PASS'
}
catch {
    $script:failureClass = $_.Exception.GetType().Name
    Write-Output ('C2B_FAILED_PHASE=' + $script:phase)
    Write-Output ('C2B_FAILURE_CLASS=' + $script:failureClass)
}
finally {
    $script:completionPhase = $script:phase
    $script:phase = 'CLEANUP'
    if ($null -ne $script:configTestOutput) { $script:configTestOutput = $null }
    if ($null -ne $script:authBytes) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($script:authBytes) }
    if ($null -ne $script:recoveryPlaintext) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($script:recoveryPlaintext) }
    if ($null -ne $script:recoveryCiphertext) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($script:recoveryCiphertext) }
    if ($null -ne $script:configBytes) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($script:configBytes) }
    $script:hy2Auth = $null
    $script:renderedText = $null
    $script:acceptedText = $null
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
