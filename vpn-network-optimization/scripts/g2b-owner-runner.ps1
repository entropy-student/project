[CmdletBinding()]
param(
    [switch]$PreflightOnly,
    [switch]$HandshakeOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$PSNativeCommandUseErrorActionPreference = $false

if ($PreflightOnly -and $HandshakeOnly) { throw 'PREFLIGHT_ONLY_AND_HANDSHAKE_ONLY_ARE_MUTUALLY_EXCLUSIVE' }

Add-Type -AssemblyName System.Security.Cryptography.ProtectedData

$projectRoot = Split-Path -Parent $PSScriptRoot
$resultsDirectory = Join-Path $projectRoot 'results'
$localProjectDirectory = 'C:\Users\34707\AppData\Local\vpn-network-optimization'
$recoveryDirectory = Join-Path $localProjectDirectory 'recovery'
$dpapiPath = Join-Path $recoveryDirectory 'hy2-g2a.dpapi'
$runtimeDirectory = Join-Path $localProjectDirectory 'runtime'
$runtimeConfigPath = Join-Path $runtimeDirectory 'g2b-mihomo.yaml'
$clientFragmentPath = Join-Path $projectRoot 'config\clash\sfo3-a-hy2.yaml'
$mihomoPath = 'C:\Program Files\Clash Verge\verge-mihomo.exe'
$publicVpsIp = '24.199.118.137'
$apiEndpoint = 'https://api.openai.com/v1/models'
$exitEndpoint = 'https://api.ipify.org'
$expectedExit = '24.199.118.137'
$routePrefix = '24.199.118.137/32'
$wlanIndex = 18
$wlanAddress = '192.168.1.4'
$wlanGateway = '192.168.1.1'
$proxyPort = 17890
$sampleCount = 60
$sampleIntervalSeconds = 5
$timestamp = [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ', [Globalization.CultureInfo]::InvariantCulture)
$wgCsvPath = Join-Path $resultsDirectory "g2b-$timestamp-wg.csv"
$hy2CsvPath = Join-Path $resultsDirectory "g2b-$timestamp-hy2.csv"
$summaryPath = Join-Path $resultsDirectory "g2b-$timestamp-summary.json"

$phase = 'INITIALIZE'
$cleanupEligible = $false
$runFailed = $false
$failurePhase = $null
$failureType = $null
$failureSubcheck = $null
$cleanupFailures = [Collections.Generic.List[string]]::new()
$resultWriteFailures = [Collections.Generic.List[string]]::new()
$wgRows = [Collections.Generic.List[object]]::new()
$hy2Rows = [Collections.Generic.List[object]]::new()
$wgStats = $null
$hy2Stats = $null
$comparison = 'INCONCLUSIVE'
$handshakeAuth = 'NO'
$handshakePin = 'NO'
$outerRoute = 'NOT_PROVEN'
$hy2PublicExit = 'NOT_PROVEN'
$mihomoProcess = $null
$mihomoStarted = $false
$runtimeDirectoryCreated = $false
$runtimeFileCreated = $false
$mihomoStopped = 'NOT_STARTED'
$runtimeDeleted = 'NOT_CREATED'
$plaintextArtifactsRemaining = $null
$routeRemoved = 'NO'
$productionWgRestored = 'NO'
$systemProxyChanged = 'UNKNOWN'
$globalTunEnabled = 'UNKNOWN'
$baselineSnapshot = $null
$curlPath = $null
$ownerIdentity = $null
$ownerSid = $null
$recoveryFiles = $null
$protectedBytes = $null
$bundleBytes = $null
$authBytes = $null
$runtimeConfigBytes = $null

function Assert-Condition {
    param(
        [Parameter(Mandatory = $true)][bool]$Condition,
        [Parameter(Mandatory = $true)][string]$Code
    )
    if (-not $Condition) { throw $Code }
}

function Invoke-PrecheckQuery {
    param(
        [Parameter(Mandatory = $true)][string]$Subcheck,
        [Parameter(Mandatory = $true)][scriptblock]$Query,
        [string[]]$EmptyResultErrorIds = @()
    )

    try {
        $items = @(& $Query)
        return ,$items
    }
    catch {
        if ($_.CategoryInfo.Category -eq [System.Management.Automation.ErrorCategory]::ObjectNotFound -and
            $EmptyResultErrorIds -contains $_.FullyQualifiedErrorId) {
            return ,@()
        }
        $script:failureSubcheck = $Subcheck
        $script:failureType = $_.Exception.GetType().Name
        throw "PRECHECK_${Subcheck}"
    }
}

function Assert-PrecheckCondition {
    param(
        [Parameter(Mandatory = $true)][bool]$Condition,
        [Parameter(Mandatory = $true)][string]$Subcheck,
        [Parameter(Mandatory = $true)][string]$Code
    )

    if (-not $Condition) {
        $script:failureSubcheck = $Subcheck
        $script:failureType = 'ValidationFailure'
        throw $Code
    }
}

function Get-PrecheckPropertyValue {
    param(
        [Parameter(Mandatory = $true)][object]$InputObject,
        [Parameter(Mandatory = $true)][string]$PropertyName,
        [Parameter(Mandatory = $true)][string]$ShapeSubcheck,
        [string]$ExtractionSubcheck = 'PROPERTY_EXTRACTION_FAILED',
        [switch]$RequiredValue
    )

    try {
        $propertyNames = @($InputObject.PSObject.Properties.Name)
    }
    catch {
        $script:failureSubcheck = $ExtractionSubcheck
        $script:failureType = $_.Exception.GetType().Name
        throw "PRECHECK_$ExtractionSubcheck"
    }
    if ($propertyNames -notcontains $PropertyName) {
        $script:failureSubcheck = $ShapeSubcheck
        $script:failureType = 'CimObjectShapeInvalid'
        throw 'CIM_OBJECT_SHAPE_INVALID'
    }

    try {
        $value = $InputObject.$PropertyName
    }
    catch {
        $script:failureSubcheck = $ExtractionSubcheck
        $script:failureType = $_.Exception.GetType().Name
        throw "PRECHECK_$ExtractionSubcheck"
    }
    if ($RequiredValue -and $null -eq $value) {
        $script:failureSubcheck = $ShapeSubcheck
        $script:failureType = 'CimObjectShapeInvalid'
        throw 'CIM_OBJECT_SHAPE_INVALID'
    }
    return $value
}

function Get-OptionalSnapshotString {
    param(
        [Parameter(Mandatory = $true)][object]$InputObject,
        [Parameter(Mandatory = $true)][string]$PropertyName
    )

    try {
        $propertyNames = @($InputObject.PSObject.Properties.Name)
    }
    catch {
        $script:failureSubcheck = 'CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED'
        $script:failureType = $_.Exception.GetType().Name
        throw 'PRECHECK_CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED'
    }
    if ($propertyNames -notcontains $PropertyName) { return '' }

    $previousError = if ($Error.Count -gt 0) { $Error[0] } else { $null }
    try {
        $value = $InputObject.$PropertyName
        $stringValue = if ($null -eq $value) { '' } else { [string]$value }
    }
    catch {
        $script:failureSubcheck = 'CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED'
        $script:failureType = $_.Exception.GetType().Name
        throw 'PRECHECK_CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED'
    }
    if ($Error.Count -gt 0 -and
        -not [object]::ReferenceEquals($Error[0], $previousError)) {
        $script:failureSubcheck = 'CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED'
        $script:failureType = $Error[0].Exception.GetType().Name
        throw 'PRECHECK_CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED'
    }
    return $stringValue
}

function Get-ClientSnapshotSingleResult {
    param(
        [Parameter(Mandatory = $true)][string]$QuerySubcheck,
        [Parameter(Mandatory = $true)][string]$ShapeSubcheck,
        [Parameter(Mandatory = $true)][string]$CardinalityCode,
        [Parameter(Mandatory = $true)][scriptblock]$Query,
        [string[]]$EmptyResultErrorIds = @()
    )

    $items = Invoke-PrecheckQuery -Subcheck $QuerySubcheck `
        -EmptyResultErrorIds $EmptyResultErrorIds -Query $Query
    Assert-PrecheckCondition -Condition ($items.Count -eq 1) `
        -Subcheck $ShapeSubcheck -Code $CardinalityCode
    return $items[0]
}

function Assert-OwnerOnlyAclRules {
    param(
        [Parameter(Mandatory = $true)][object[]]$Rules,
        [switch]$Directory
    )

    Assert-Condition ($Rules.Count -gt 0) 'OWNER_ACL_RULES_MISSING'
    $directRights = [long]0
    $containerRights = [long]0
    $objectRights = [long]0
    foreach ($rule in $Rules) {
        Assert-Condition (-not $rule.IsInherited) 'OWNER_ACL_INHERITED_RULE_PRESENT'
        $ruleSid = if ($rule.IdentityReference -is [Security.Principal.SecurityIdentifier]) {
            $rule.IdentityReference.Value
        }
        else {
            $rule.IdentityReference.Translate([Security.Principal.SecurityIdentifier]).Value
        }
        Assert-Condition ($ruleSid -eq $script:ownerSid.Value) 'OWNER_ACL_ALLOWLIST_INVALID'
        Assert-Condition (
            $rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow
        ) 'OWNER_ACL_DENY_RULE_PRESENT'

        $rights = [long]$rule.FileSystemRights
        if (($rule.PropagationFlags -band [Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0) {
            $directRights = $directRights -bor $rights
        }
        if ($Directory) {
            if (($rule.InheritanceFlags -band [Security.AccessControl.InheritanceFlags]::ContainerInherit) -ne 0) {
                $containerRights = $containerRights -bor $rights
            }
            if (($rule.InheritanceFlags -band [Security.AccessControl.InheritanceFlags]::ObjectInherit) -ne 0) {
                $objectRights = $objectRights -bor $rights
            }
        }
        elseif ($rule.InheritanceFlags -ne [Security.AccessControl.InheritanceFlags]::None -or
                $rule.PropagationFlags -ne [Security.AccessControl.PropagationFlags]::None) {
            throw 'OWNER_ACL_FILE_INHERITANCE_FLAGS_INVALID'
        }
    }

    $fullControl = [long][Security.AccessControl.FileSystemRights]::FullControl
    Assert-Condition (($directRights -band $fullControl) -eq $fullControl) 'OWNER_ACL_OWNER_FULLCONTROL_MISSING'
    if ($Directory) {
        Assert-Condition (
            ($containerRights -band $fullControl) -eq $fullControl -and
            ($objectRights -band $fullControl) -eq $fullControl
        ) 'OWNER_ACL_CHILD_FULLCONTROL_INHERITANCE_MISSING'
    }
}

function Assert-OwnerOnlyAcl {
    param([Parameter(Mandatory = $true)][string]$Path)

    $item = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    Assert-Condition (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'OWNER_ACL_REPARSE_POINT'
    $acl = Get-Acl -LiteralPath $Path -ErrorAction Stop
    Assert-Condition $acl.AreAccessRulesProtected 'OWNER_ACL_INHERITANCE_ENABLED'
    $actualOwner = ([Security.Principal.NTAccount]::new($acl.Owner)).Translate(
        [Security.Principal.SecurityIdentifier]
    ).Value
    Assert-Condition ($actualOwner -eq $script:ownerSid.Value) 'OWNER_ACL_OWNER_MISMATCH'
    $rules = @($acl.GetAccessRules(
        $true,
        $true,
        [Security.Principal.SecurityIdentifier]
    ))
    Assert-OwnerOnlyAclRules -Rules $rules -Directory:$item.PSIsContainer
}

function Test-DirectoryWriteAccess {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][bool]$CreateDirectory
    )

    $acl = Get-Acl -LiteralPath $Path -ErrorAction Stop
    $principal = [Security.Principal.WindowsPrincipal]::new($script:ownerIdentity)
    $tokenSids = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    [void]$tokenSids.Add($script:ownerSid.Value)
    foreach ($groupSid in $script:ownerIdentity.Groups) {
        try {
            if ($principal.IsInRole($groupSid)) { [void]$tokenSids.Add($groupSid.Value) }
        } catch {
            throw 'RESULTS_ACCESS_CHECK_FAILED'
        }
    }
    [void]$tokenSids.Add('S-1-1-0')
    [void]$tokenSids.Add('S-1-5-11')

    $requiredRight = if ($CreateDirectory) {
        [int][Security.AccessControl.FileSystemRights]::CreateDirectories
    } else {
        [int][Security.AccessControl.FileSystemRights]::CreateFiles
    }
    $allowed = $false
    $rules = $acl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier])
    foreach ($rule in $rules) {
        if (-not $tokenSids.Contains($rule.IdentityReference.Value)) { continue }
        $hasRequiredRight = (([int]$rule.FileSystemRights -band $requiredRight) -ne 0)
        if (-not $hasRequiredRight) { continue }
        if ($rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Deny) {
            return $false
        }
        if ($rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow) {
            $allowed = $true
        }
    }
    return $allowed
}

function Read-ExactBytes {
    param(
        [Parameter(Mandatory = $true)][IO.BinaryReader]$Reader,
        [Parameter(Mandatory = $true)][int]$Count
    )
    $bytes = $Reader.ReadBytes($Count)
    if ($bytes.Length -ne $Count) { throw 'RECOVERY_FRAME_TRUNCATED' }
    return ,$bytes
}

function Read-RecoveryBundle {
    param([Parameter(Mandatory = $true)][byte[]]$Bytes)

    if ($Bytes.Length -gt 131072) { throw 'RECOVERY_FRAME_TOO_LARGE' }
    $stream = [IO.MemoryStream]::new($Bytes, $false)
    $reader = [IO.BinaryReader]::new($stream, [Text.Encoding]::UTF8, $true)
    $files = @{}
    try {
        $magic = [Text.Encoding]::ASCII.GetString((Read-ExactBytes $reader 8))
        if ($magic -ne 'VPNHY2R1') { throw 'RECOVERY_FRAME_MAGIC_INVALID' }
        while ($stream.Position -lt $stream.Length) {
            $nameLength = [int]$reader.ReadByte()
            if ($nameLength -lt 1 -or $nameLength -gt 32) { throw 'RECOVERY_FRAME_NAME_LENGTH_INVALID' }
            $lengthBytes = Read-ExactBytes $reader 4
            $dataLength = ([uint32]$lengthBytes[0] -shl 24) -bor
                          ([uint32]$lengthBytes[1] -shl 16) -bor
                          ([uint32]$lengthBytes[2] -shl 8) -bor
                          [uint32]$lengthBytes[3]
            if ($dataLength -lt 1 -or $dataLength -gt 65536) { throw 'RECOVERY_FRAME_DATA_LENGTH_INVALID' }
            $name = [Text.Encoding]::UTF8.GetString((Read-ExactBytes $reader $nameLength))
            if ($name -notin @('hy2-auth', 'server.key', 'server.crt') -or $files.ContainsKey($name)) {
                throw 'RECOVERY_FRAME_ALLOWLIST_INVALID'
            }
            $files[$name] = Read-ExactBytes $reader ([int]$dataLength)
        }
        if ($files.Count -ne 3) { throw 'RECOVERY_FRAME_CARDINALITY_INVALID' }

        $auth = [byte[]]$files['hy2-auth']
        if ($auth.Length -ne 64 -or
            @($auth | Where-Object { $_ -notin 48..57 -and $_ -notin 97..102 }).Count -gt 0) {
            throw 'RECOVERY_AUTH_FORMAT_INVALID'
        }

        $keyBytes = [byte[]]$files['server.key']
        $keyHeader = [Text.Encoding]::ASCII.GetBytes("-----BEGIN EC PRIVATE KEY-----`n")
        if ($keyBytes.Length -lt $keyHeader.Length -or $keyBytes.Length -gt 8192) {
            throw 'RECOVERY_PRIVATE_KEY_FORMAT_INVALID'
        }
        for ($i = 0; $i -lt $keyHeader.Length; $i++) {
            if ($keyBytes[$i] -ne $keyHeader[$i]) { throw 'RECOVERY_PRIVATE_KEY_FORMAT_INVALID' }
        }

        $certBytes = [byte[]]$files['server.crt']
        $certHeader = [Text.Encoding]::ASCII.GetBytes("-----BEGIN CERTIFICATE-----`n")
        if ($certBytes.Length -lt $certHeader.Length -or $certBytes.Length -gt 8192) {
            throw 'RECOVERY_CERTIFICATE_FORMAT_INVALID'
        }
        for ($i = 0; $i -lt $certHeader.Length; $i++) {
            if ($certBytes[$i] -ne $certHeader[$i]) { throw 'RECOVERY_CERTIFICATE_FORMAT_INVALID' }
        }

        $certificate = [Security.Cryptography.X509Certificates.X509Certificate2]::new($certBytes)
        $ecKey = $null
        try {
            $ecKey = [Security.Cryptography.X509Certificates.ECDsaCertificateExtensions]::GetECDsaPublicKey($certificate)
            if ($null -eq $ecKey -or $ecKey.KeySize -ne 256) { throw 'RECOVERY_CERTIFICATE_KEY_TYPE_INVALID' }
            if ($ecKey.ExportParameters($false).Curve.Oid.Value -ne '1.2.840.10045.3.1.7') {
                throw 'RECOVERY_CERTIFICATE_CURVE_INVALID'
            }
            $sanExtension = $certificate.Extensions |
                Where-Object { $_.Oid.Value -eq '2.5.29.17' } |
                Select-Object -First 1
            if ($null -eq $sanExtension) { throw 'RECOVERY_CERTIFICATE_SAN_MISSING' }
            $san = [Security.Cryptography.X509Certificates.X509SubjectAlternativeNameExtension]::new(
                $sanExtension.RawData
            )
            $dnsNames = @($san.EnumerateDnsNames())
            if ($dnsNames.Count -ne 1 -or $dnsNames[0] -ne 'hy2.sfo3-a.invalid') {
                throw 'RECOVERY_CERTIFICATE_SAN_INVALID'
            }
            $hex = [Convert]::ToHexString($certificate.GetCertHash([Security.Cryptography.HashAlgorithmName]::SHA256))
            $fingerprint = [string]::Join(':', [regex]::Matches($hex, '..').Value)
        }
        finally {
            if ($null -ne $ecKey) { $ecKey.Dispose() }
            $certificate.Dispose()
        }

        return [pscustomobject]@{ Files = $files; Fingerprint = $fingerprint }
    }
    catch {
        foreach ($value in $files.Values) {
            [Security.Cryptography.CryptographicOperations]::ZeroMemory([byte[]]$value)
        }
        throw
    }
    finally {
        $reader.Dispose()
        $stream.Dispose()
    }
}

function Get-ClientSettings {
    $text = [IO.File]::ReadAllText($script:clientFragmentPath, [Text.Encoding]::UTF8)
    $server = [regex]::Match($text, '(?m)^\s+server:\s*(?<v>\d{1,3}(?:\.\d{1,3}){3})\s*$')
    $port = [regex]::Match($text, '(?m)^\s+port:\s*(?<v>\d{1,5})\s*$')
    $sni = [regex]::Match($text, '(?m)^\s+sni:\s*(?<v>[A-Za-z0-9.-]+)\s*$')
    $fingerprint = [regex]::Match($text, '(?m)^\s+fingerprint:\s*(?<v>[0-9A-F]{2}(?::[0-9A-F]{2}){31})\s*$')
    $secretPlaceholder = [regex]::IsMatch($text, '(?m)^\s+password:\s*__LOCAL_SECRET_INJECTION_REQUIRED__\s*$')
    $skipVerify = [regex]::IsMatch($text, '(?m)^\s+skip-cert-verify:\s*true\s*$')
    if (-not $server.Success -or -not $port.Success -or -not $sni.Success -or
        -not $fingerprint.Success -or -not $secretPlaceholder -or -not $skipVerify) {
        throw 'CLIENT_FRAGMENT_NOT_ACCEPTED_NONSECRET_TEMPLATE'
    }
    if ($server.Groups['v'].Value -ne $script:publicVpsIp -or
        [int]$port.Groups['v'].Value -ne 8443 -or
        $sni.Groups['v'].Value -ne 'hy2.sfo3-a.invalid') {
        throw 'CLIENT_FRAGMENT_TARGET_MISMATCH'
    }
    return [pscustomobject]@{
        Server = $server.Groups['v'].Value
        Port = [int]$port.Groups['v'].Value
        Sni = $sni.Groups['v'].Value
        Fingerprint = $fingerprint.Groups['v'].Value
    }
}

function Get-RouteRows {
    param([switch]$ExcludeOwnerTemporaryRoute)
    $routes = Invoke-PrecheckQuery -Subcheck 'CLIENT_SNAPSHOT_ROUTE_QUERY_FAILED' -Query {
        Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -ErrorAction Stop
    }
    $routeFields = @('DestinationPrefix', 'NextHop', 'InterfaceIndex', 'RouteMetric', 'State', 'Store')
    foreach ($route in $routes) {
        foreach ($propertyName in $routeFields) {
            [void](Get-PrecheckPropertyValue -InputObject $route -PropertyName $propertyName `
                -ShapeSubcheck 'CIM_OBJECT_SHAPE_INVALID' `
                -ExtractionSubcheck 'CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED' -RequiredValue)
        }
    }
    if ($ExcludeOwnerTemporaryRoute) {
        $routes = @($routes | Where-Object { $_.DestinationPrefix -ne $script:routePrefix })
    }
    return @($routes | Sort-Object DestinationPrefix, NextHop, InterfaceIndex, RouteMetric |
        ForEach-Object {
            "$($_.DestinationPrefix)|$($_.NextHop)|$($_.InterfaceIndex)|$($_.RouteMetric)|$($_.State)|$($_.Store)"
        })
}

function Get-WinHttpProxyState {
    $lines = & netsh.exe winhttp show proxy 2>$null
    $nativeExit = $LASTEXITCODE
    if ($nativeExit -ne 0) { throw 'WINHTTP_READBACK_FAILED' }
    return (($lines -join [Environment]::NewLine).Trim())
}

function Get-ClientSnapshot {
    $manager = Get-ClientSnapshotSingleResult -QuerySubcheck 'WG_SERVICE_QUERY_FAILED' `
        -ShapeSubcheck 'WG_SERVICE_STATE_INVALID' -CardinalityCode 'WIREGUARD_MANAGER_CARDINALITY_INVALID' -Query {
            Get-Service -Name 'WireGuardManager' -ErrorAction Stop
        }
    $tunnel = Get-ClientSnapshotSingleResult -QuerySubcheck 'WG_SERVICE_QUERY_FAILED' `
        -ShapeSubcheck 'WG_SERVICE_STATE_INVALID' -CardinalityCode 'WIREGUARD_TUNNEL_SERVICE_CARDINALITY_INVALID' -Query {
            Get-Service -Name 'WireGuardTunnel$SFO2-A' -ErrorAction Stop
        }
    $clashService = Get-ClientSnapshotSingleResult -QuerySubcheck 'CLASH_SERVICE_QUERY_FAILED' `
        -ShapeSubcheck 'CLASH_SERVICE_STATE_INVALID' -CardinalityCode 'CLASH_SERVICE_CARDINALITY_INVALID' -Query {
            Get-Service -Name 'clash_verge_service' -ErrorAction Stop
        }
    $wgAdapter = Get-ClientSnapshotSingleResult -QuerySubcheck 'WG_ADAPTER_QUERY_FAILED' `
        -ShapeSubcheck 'WG_ADAPTER_STATE_INVALID' -CardinalityCode 'WG_ADAPTER_CARDINALITY_INVALID' -Query {
            Get-NetAdapter -Name 'SFO2-A' -ErrorAction Stop
        }
    $internet = Get-ClientSnapshotSingleResult -QuerySubcheck 'INTERNET_SETTINGS_QUERY_FAILED' `
        -ShapeSubcheck 'INTERNET_SETTINGS_SHAPE_INVALID' -CardinalityCode 'INTERNET_SETTINGS_CARDINALITY_INVALID' -Query {
            Get-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -ErrorAction Stop
        }

    $managerStatus = Get-PrecheckPropertyValue -InputObject $manager -PropertyName 'Status' `
        -ShapeSubcheck 'WG_SERVICE_STATE_INVALID' -ExtractionSubcheck 'CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED' -RequiredValue
    $tunnelStatus = Get-PrecheckPropertyValue -InputObject $tunnel -PropertyName 'Status' `
        -ShapeSubcheck 'WG_SERVICE_STATE_INVALID' -ExtractionSubcheck 'CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED' -RequiredValue
    $clashStatus = Get-PrecheckPropertyValue -InputObject $clashService -PropertyName 'Status' `
        -ShapeSubcheck 'CLASH_SERVICE_STATE_INVALID' -ExtractionSubcheck 'CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED' -RequiredValue
    $wgStatus = Get-PrecheckPropertyValue -InputObject $wgAdapter -PropertyName 'Status' `
        -ShapeSubcheck 'WG_ADAPTER_STATE_INVALID' -ExtractionSubcheck 'CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED' -RequiredValue
    $wgIfIndex = Get-PrecheckPropertyValue -InputObject $wgAdapter -PropertyName 'InterfaceIndex' `
        -ShapeSubcheck 'WG_ADAPTER_STATE_INVALID' -ExtractionSubcheck 'CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED' -RequiredValue
    $proxyEnableValue = Get-PrecheckPropertyValue -InputObject $internet -PropertyName 'ProxyEnable' `
        -ShapeSubcheck 'INTERNET_SETTINGS_SHAPE_INVALID' -ExtractionSubcheck 'CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED' -RequiredValue
    try { $proxyEnable = [int]$proxyEnableValue }
    catch {
        $script:failureSubcheck = 'INTERNET_SETTINGS_SHAPE_INVALID'
        $script:failureType = $_.Exception.GetType().Name
        throw 'INTERNET_SETTINGS_PROXYENABLE_INVALID'
    }
    $proxyServer = Get-OptionalSnapshotString -InputObject $internet -PropertyName 'ProxyServer'
    $proxyOverride = Get-OptionalSnapshotString -InputObject $internet -PropertyName 'ProxyOverride'
    $autoConfigUrl = Get-OptionalSnapshotString -InputObject $internet -PropertyName 'AutoConfigURL'

    $tunAdapters = Invoke-PrecheckQuery -Subcheck 'CLIENT_SNAPSHOT_TUN_QUERY_FAILED' -Query {
        Get-NetAdapter -IncludeHidden -ErrorAction Stop
    }
    try {
        $tun = @($tunAdapters |
            Where-Object { $_.Name -match 'Clash|Mihomo|Meta' -or $_.InterfaceDescription -match 'Clash|Mihomo|Meta' } |
            Sort-Object Name |
            ForEach-Object { "$($_.Name)|$($_.InterfaceDescription)|$($_.InterfaceIndex)|$($_.Status)" })
    }
    catch {
        $script:failureSubcheck = 'CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED'
        $script:failureType = $_.Exception.GetType().Name
        throw 'PRECHECK_CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED'
    }
    $cores = @(Get-Process -Name 'mihomo', 'verge-mihomo', 'verge-mihomo-alpha' -ErrorAction SilentlyContinue |
        Sort-Object ProcessName, Id |
        ForEach-Object { "$($_.ProcessName)|$($_.Id)" })
    $winHttp = try {
        Get-WinHttpProxyState
    }
    catch {
        $script:failureSubcheck = 'WINHTTP_READBACK_FAILED'
        $script:failureType = $_.Exception.GetType().Name
        throw 'PRECHECK_WINHTTP_READBACK_FAILED'
    }
    return [pscustomobject]@{
        RoutesWithoutOwnerRoute = (Get-RouteRows -ExcludeOwnerTemporaryRoute) -join ';'
        WireGuardManager = $managerStatus.ToString()
        WireGuardTunnel = $tunnelStatus.ToString()
        WireGuardAdapter = "$wgStatus|$wgIfIndex"
        WireGuardIfIndex = [int]$wgIfIndex
        ClashService = $clashStatus.ToString()
        ProxyEnable = $proxyEnable
        ProxyServer = $proxyServer
        ProxyOverride = $proxyOverride
        AutoConfigURL = $autoConfigUrl
        WinHttp = $winHttp
        TunAdapters = $tun -join ';'
        MihomoProcesses = $cores -join ';'
    }
}

function Get-ExactTemporaryRoute {
    $routes = Invoke-PrecheckQuery -Subcheck 'OWNER_ROUTE_QUERY_FAILED' `
        -EmptyResultErrorIds @('CmdletizationQuery_NotFound,Get-NetRoute') -Query {
            Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore `
                -DestinationPrefix $script:routePrefix -ErrorAction Stop
        }
    return ,$routes
}

function Assert-OwnerRouteAndWlan {
    $noRouteMatch = @('CmdletizationQuery_NotFound,Get-NetRoute')
    $routes = Invoke-PrecheckQuery -Subcheck 'ROUTE_QUERY_FAILED' `
        -EmptyResultErrorIds $noRouteMatch -Query {
            Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore `
                -DestinationPrefix $script:routePrefix -ErrorAction Stop
        }
    Assert-PrecheckCondition -Condition ($routes.Count -eq 1) `
        -Subcheck 'ROUTE_CARDINALITY_INVALID' -Code 'OWNER_ROUTE_CARDINALITY_INVALID'

    $route = $routes[0]
    try {
        $routePrefix = [string](Get-PrecheckPropertyValue -InputObject $route -PropertyName 'DestinationPrefix' -ShapeSubcheck 'ROUTE_SHAPE_INVALID')
        $routeNextHop = [string](Get-PrecheckPropertyValue -InputObject $route -PropertyName 'NextHop' -ShapeSubcheck 'ROUTE_SHAPE_INVALID')
        $routeAlias = [string](Get-PrecheckPropertyValue -InputObject $route -PropertyName 'InterfaceAlias' -ShapeSubcheck 'ROUTE_SHAPE_INVALID')
        $routeIfIndex = [int](Get-PrecheckPropertyValue -InputObject $route -PropertyName 'InterfaceIndex' -ShapeSubcheck 'ROUTE_SHAPE_INVALID')
    }
    catch {
        if ($null -eq $script:failureSubcheck) {
            $script:failureSubcheck = 'PROPERTY_EXTRACTION_FAILED'
            $script:failureType = $_.Exception.GetType().Name
        }
        throw
    }
    Assert-PrecheckCondition -Condition (
        $routePrefix -eq $script:routePrefix -and
        $routeNextHop -eq $script:wlanGateway -and
        $routeAlias -eq 'WLAN' -and
        $routeIfIndex -eq $script:wlanIndex
    ) -Subcheck 'ROUTE_SHAPE_INVALID' -Code 'OWNER_ROUTE_TARGET_MISMATCH'

    $persistent = Invoke-PrecheckQuery -Subcheck 'PERSISTENT_ROUTE_QUERY_FAILED' `
        -EmptyResultErrorIds $noRouteMatch -Query {
            Get-NetRoute -AddressFamily IPv4 -PolicyStore PersistentStore `
                -DestinationPrefix $script:routePrefix -ErrorAction Stop
        }
    Assert-PrecheckCondition -Condition ($persistent.Count -eq 0) `
        -Subcheck 'ROUTE_CARDINALITY_INVALID' -Code 'PERSISTENT_OWNER_ROUTE_UNEXPECTED'

    $wlanAdapters = Invoke-PrecheckQuery -Subcheck 'WLAN_ADAPTER_QUERY_FAILED' `
        -EmptyResultErrorIds @('CmdletizationQuery_NotFound_InterfaceIndex,Get-NetAdapter') -Query {
            Get-NetAdapter -InterfaceIndex $script:wlanIndex -ErrorAction Stop
        }
    Assert-PrecheckCondition -Condition ($wlanAdapters.Count -eq 1) `
        -Subcheck 'WLAN_ADAPTER_STATE_INVALID' -Code 'WLAN_ADAPTER_CARDINALITY_INVALID'
    $wlan = $wlanAdapters[0]
    $wlanName = [string](Get-PrecheckPropertyValue -InputObject $wlan -PropertyName 'Name' -ShapeSubcheck 'WLAN_ADAPTER_STATE_INVALID')
    $wlanStatus = [string](Get-PrecheckPropertyValue -InputObject $wlan -PropertyName 'Status' -ShapeSubcheck 'WLAN_ADAPTER_STATE_INVALID')
    $wlanIfIndex = [int](Get-PrecheckPropertyValue -InputObject $wlan -PropertyName 'InterfaceIndex' -ShapeSubcheck 'WLAN_ADAPTER_STATE_INVALID')
    Assert-PrecheckCondition -Condition (
        $wlanName -eq 'WLAN' -and $wlanStatus -eq 'Up' -and $wlanIfIndex -eq $script:wlanIndex
    ) -Subcheck 'WLAN_ADAPTER_STATE_INVALID' -Code 'WLAN_INTERFACE_NOT_UP'

    $configurations = Invoke-PrecheckQuery -Subcheck 'WLAN_IP_QUERY_FAILED' -Query {
        Get-NetIPConfiguration -InterfaceIndex $script:wlanIndex -ErrorAction Stop
    }
    Assert-PrecheckCondition -Condition ($configurations.Count -eq 1) `
        -Subcheck 'WLAN_IP_QUERY_FAILED' -Code 'WLAN_IP_CONFIGURATION_CARDINALITY_INVALID'
    $configuration = $configurations[0]
    $addressObjects = @(Get-PrecheckPropertyValue -InputObject $configuration -PropertyName 'IPv4Address' -ShapeSubcheck 'CIM_OBJECT_SHAPE_INVALID')
    $addresses = [Collections.Generic.List[string]]::new()
    foreach ($addressObject in $addressObjects) {
        $addresses.Add([string](Get-PrecheckPropertyValue -InputObject $addressObject -PropertyName 'IPAddress' -ShapeSubcheck 'CIM_OBJECT_SHAPE_INVALID'))
    }
    Assert-PrecheckCondition -Condition ($addresses.Contains($script:wlanAddress)) `
        -Subcheck 'WLAN_IPV4_INVALID' -Code 'WLAN_IPV4_MISMATCH'

    $gatewayObjects = @(Get-PrecheckPropertyValue -InputObject $configuration -PropertyName 'IPv4DefaultGateway' -ShapeSubcheck 'CIM_OBJECT_SHAPE_INVALID')
    $gateways = [Collections.Generic.List[string]]::new()
    foreach ($gatewayObject in $gatewayObjects) {
        $gateways.Add([string](Get-PrecheckPropertyValue -InputObject $gatewayObject -PropertyName 'NextHop' -ShapeSubcheck 'CIM_OBJECT_SHAPE_INVALID'))
    }
    Assert-PrecheckCondition -Condition ($gateways.Contains($script:wlanGateway)) `
        -Subcheck 'WLAN_GATEWAY_INVALID' -Code 'WLAN_GATEWAY_MISMATCH'

    $routeSelections = Invoke-PrecheckQuery -Subcheck 'VPS_ROUTE_SELECTION_QUERY_FAILED' -Query {
        Find-NetRoute -RemoteIPAddress $script:publicVpsIp -ErrorAction Stop
    }
    $selected = @($routeSelections | Where-Object {
        $_.PSObject.Properties.Name -contains 'DestinationPrefix' -and
        $_.PSObject.Properties.Name -contains 'InterfaceIndex' -and
        $_.PSObject.Properties.Name -contains 'NextHop'
    })
    Assert-PrecheckCondition -Condition ($selected.Count -eq 1) `
        -Subcheck 'CIM_OBJECT_SHAPE_INVALID' -Code 'VPS_ROUTE_SELECTION_AMBIGUOUS'
    $selectedIfIndex = [int](Get-PrecheckPropertyValue -InputObject $selected[0] -PropertyName 'InterfaceIndex' -ShapeSubcheck 'CIM_OBJECT_SHAPE_INVALID')
    $selectedNextHop = [string](Get-PrecheckPropertyValue -InputObject $selected[0] -PropertyName 'NextHop' -ShapeSubcheck 'CIM_OBJECT_SHAPE_INVALID')
    Assert-PrecheckCondition -Condition (
        $selectedIfIndex -eq $script:wlanIndex -and $selectedNextHop -eq $script:wlanGateway
    ) -Subcheck 'ROUTE_SHAPE_INVALID' -Code 'VPS_OUTER_ROUTE_NOT_WLAN_DIRECT'
}

function Get-PublicExit {
    param([AllowNull()][string]$ProxyUrl)
    $curlArgs = @('-q', '-4', '--silent', '--max-time', '12', '--connect-timeout', '8', '--noproxy', '*')
    if (-not [string]::IsNullOrEmpty($ProxyUrl)) {
        $curlArgs = @('-q', '-4', '--silent', '--max-time', '12', '--connect-timeout', '8',
            '--proxy', $ProxyUrl, '--noproxy', '')
    }
    $curlArgs += $script:exitEndpoint
    $bodyLines = & $script:curlPath @curlArgs 2>$null
    $nativeExit = $LASTEXITCODE
    if ($nativeExit -ne 0) { throw 'PUBLIC_EXIT_CURL_FAILED' }
    return (($bodyLines -join '').Trim())
}

function Format-TimeValue {
    param([AllowNull()][object]$Value)
    if ($null -eq $Value) { return '' }
    return ([double]$Value).ToString('0.000000', [Globalization.CultureInfo]::InvariantCulture)
}

function Invoke-CurlSample {
    param(
        [Parameter(Mandatory = $true)][DateTime]$TimestampUtc,
        [AllowNull()][string]$ProxyUrl
    )
    $writeOut = '__G2B__%{http_code}|%{time_namelookup}|%{time_connect}|%{time_appconnect}|%{time_starttransfer}|%{time_total}|%{remote_ip}|%{proxy_used}'
    $curlArgs = @('-q', '-4', '--silent', '--max-time', '12', '--connect-timeout', '8',
        '--output', 'NUL', '--write-out', $writeOut)
    if ([string]::IsNullOrEmpty($ProxyUrl)) {
        $curlArgs += @('--noproxy', '*')
    } else {
        $curlArgs += @('--proxy', $ProxyUrl, '--noproxy', '')
    }
    $curlArgs += $script:apiEndpoint
    $outputLines = & $script:curlPath @curlArgs 2>$null
    $curlExit = [int]$LASTEXITCODE
    $line = ($outputLines -join '').Trim()
    $status = '000'
    $nameLookup = $null
    $connect = $null
    $appConnect = $null
    $startTransfer = $null
    $total = $null
    $remoteIp = ''
    $proxyUsed = $null
    if ($line.StartsWith('__G2B__', [StringComparison]::Ordinal)) {
        $fields = $line.Substring(7) -split '\|', 8
        if ($fields.Count -eq 8) {
            $status = $fields[0]
            $nameLookup = Convert-TimeField $fields[1]
            $connect = Convert-TimeField $fields[2]
            $appConnect = Convert-TimeField $fields[3]
            $startTransfer = Convert-TimeField $fields[4]
            $total = Convert-TimeField $fields[5]
            $remoteIp = $fields[6]
            if ($fields[7] -eq '1') { $proxyUsed = 1 }
            elseif ($fields[7] -eq '0') { $proxyUsed = 0 }
        }
    }
    $errorCode = 'NONE'
    if ($curlExit -eq 28) { $errorCode = 'TIMEOUT' }
    elseif ($curlExit -in @(52, 56)) { $errorCode = 'CONNECTION_RESET' }
    elseif ($curlExit -eq 35) { $errorCode = 'TLS_ERROR' }
    elseif ($curlExit -ne 0) { $errorCode = "CURL_EXIT_$curlExit" }
    elseif ($status -ne '401') { $errorCode = "HTTP_STATUS_$status" }
    $success = ($curlExit -eq 0 -and $status -eq '401')
    return [pscustomobject]@{
        Timestamp = $TimestampUtc.ToString('o', [Globalization.CultureInfo]::InvariantCulture)
        CurlExit = $curlExit
        HttpStatus = $status
        TimeNameLookup = $(Format-TimeValue $nameLookup)
        TimeConnect = $(Format-TimeValue $connect)
        TimeAppConnect = $(Format-TimeValue $appConnect)
        TimeStartTransfer = $(Format-TimeValue $startTransfer)
        TimeTotal = $(Format-TimeValue $total)
        RemoteIp = $remoteIp
        ProxyUsed = $proxyUsed
        TotalSeconds = $total
        Error = $errorCode
        Success = $success
    }
}

function Convert-TimeField {
    param([Parameter(Mandatory = $true)][string]$Text)
    $value = 0.0
    $parsed = [double]::TryParse(
        $Text,
        [Globalization.NumberStyles]::Float,
        [Globalization.CultureInfo]::InvariantCulture,
        [ref]$value
    )
    if (-not $parsed -or [double]::IsNaN($value) -or [double]::IsInfinity($value)) { return $null }
    return $value
}

function Invoke-Benchmark {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][AllowEmptyCollection()][Collections.Generic.List[object]]$Rows,
        [AllowNull()][string]$ProxyUrl
    )
    for ($sample = 1; $sample -le $script:sampleCount; $sample++) {
        $started = [DateTime]::UtcNow
        $sampleResult = Invoke-CurlSample -TimestampUtc $started -ProxyUrl $ProxyUrl
        if ([string]::IsNullOrEmpty($ProxyUrl) -and $sampleResult.ProxyUsed -ne 0) {
            throw "$($Name)_UNEXPECTED_PROXY_PATH"
        }
        if (-not [string]::IsNullOrEmpty($ProxyUrl) -and $sampleResult.ProxyUsed -ne 1) {
            throw "$($Name)_LOCAL_PROXY_NOT_USED"
        }
        $Rows.Add($sampleResult)
        Write-Host ("{0}_SAMPLE={1}/{2}" -f $Name, $sample, $script:sampleCount)
        $nextStart = $started.AddSeconds($script:sampleIntervalSeconds)
        while ($sample -lt $script:sampleCount -and [DateTime]::UtcNow -lt $nextStart) {
            $remainingMs = [int][Math]::Max(1, ($nextStart - [DateTime]::UtcNow).TotalMilliseconds)
            Start-Sleep -Milliseconds ([int][Math]::Min(250, $remainingMs))
        }
    }
    if ($Rows.Count -ne $script:sampleCount) { throw "$($Name)_SAMPLE_COUNT_INCOMPLETE" }
    return Get-BenchmarkStats $Rows
}

function Get-Percentile {
    param([double[]]$Values, [double]$Percentile)
    if ($Values.Count -eq 0) { return $null }
    $sorted = @($Values | Sort-Object)
    if ($Percentile -eq 0.5 -and ($sorted.Count % 2) -eq 0) {
        return ([double]$sorted[($sorted.Count / 2) - 1] + [double]$sorted[$sorted.Count / 2]) / 2.0
    }
    $rank = [int][Math]::Ceiling($Percentile * $sorted.Count)
    return [double]$sorted[[Math]::Max(0, $rank - 1)]
}

function Get-BenchmarkStats {
    param([Parameter(Mandatory = $true)][Collections.Generic.List[object]]$Rows)
    $successes = @($Rows | Where-Object { $_.Success })
    $failures = $Rows.Count - $successes.Count
    $times = @($Rows | Where-Object { $null -ne $_.TotalSeconds } | ForEach-Object { [double]$_.TotalSeconds })
    $longest = 0
    $streak = 0
    foreach ($row in $Rows) {
        if ($row.Success) { $streak = 0 } else { $streak++; $longest = [Math]::Max($longest, $streak) }
    }
    return [pscustomobject]@{
        Samples = $Rows.Count
        Success = $successes.Count
        Failures = $failures
        Median = $(Get-Percentile $times 0.50)
        P90 = $(Get-Percentile $times 0.90)
        P95 = $(Get-Percentile $times 0.95)
        P99 = $(Get-Percentile $times 0.99)
        GT1 = @($times | Where-Object { $_ -gt 1.0 }).Count
        GT1_5 = @($times | Where-Object { $_ -gt 1.5 }).Count
        GT2 = @($times | Where-Object { $_ -gt 2.0 }).Count
        LongestFailureStreak = $longest
        Timeouts = @($Rows | Where-Object { $_.Error -eq 'TIMEOUT' }).Count
        Resets = @($Rows | Where-Object { $_.Error -eq 'CONNECTION_RESET' }).Count
        LatencyPopulation = 'all samples with a parsed curl time_total'
    }
}

function Test-Dominates {
    param([Parameter(Mandatory = $true)]$Candidate, [Parameter(Mandatory = $true)]$Other)
    $keys = @('Failures', 'Timeouts', 'Resets', 'LongestFailureStreak', 'Median', 'P90', 'P95', 'P99', 'GT1', 'GT1_5', 'GT2')
    $strict = $false
    foreach ($key in $keys) {
        $a = $Candidate.$key
        $b = $Other.$key
        if ($null -eq $a -or $null -eq $b) { return $false }
        if ([double]$a -gt [double]$b) { return $false }
        if ([double]$a -lt [double]$b) { $strict = $true }
    }
    return $strict
}

function Test-ApproximatelyEquivalent {
    param([Parameter(Mandatory = $true)]$A, [Parameter(Mandatory = $true)]$B)
    if ($A.Failures -ne $B.Failures -or $A.Timeouts -ne $B.Timeouts -or $A.Resets -ne $B.Resets) { return $false }
    foreach ($key in @('Median', 'P90', 'P95', 'P99')) {
        if ($null -eq $A.$key -or $null -eq $B.$key) { return $false }
        $scale = [Math]::Max([Math]::Max([double]$A.$key, [double]$B.$key), 0.001)
        if ([Math]::Abs([double]$A.$key - [double]$B.$key) / $scale -gt 0.05) { return $false }
    }
    foreach ($key in @('GT1', 'GT1_5', 'GT2', 'LongestFailureStreak')) {
        if ([Math]::Abs([double]$A.$key - [double]$B.$key) -gt 1) { return $false }
    }
    return $true
}

function Get-WindowComparison {
    param($WireGuard, $Hysteria)
    if ($null -eq $WireGuard -or $null -eq $Hysteria -or
        $WireGuard.Samples -ne $script:sampleCount -or $Hysteria.Samples -ne $script:sampleCount) {
        return 'INCONCLUSIVE'
    }
    $hy2Dominates = Test-Dominates $Hysteria $WireGuard
    $wgDominates = Test-Dominates $WireGuard $Hysteria
    if ($hy2Dominates -and -not $wgDominates) { return 'HY2_BETTER_THIS_WINDOW' }
    if ($wgDominates -and -not $hy2Dominates) { return 'WG_BETTER_THIS_WINDOW' }
    if (Test-ApproximatelyEquivalent $WireGuard $Hysteria) { return 'APPROXIMATELY_EQUIVALENT' }
    return 'INCONCLUSIVE'
}

function Get-ComparisonTable {
    $metrics = @(
        @{ Label = 'Success'; Property = 'Success' }
        @{ Label = 'Failures'; Property = 'Failures' }
        @{ Label = 'Median'; Property = 'Median' }
        @{ Label = 'P90'; Property = 'P90' }
        @{ Label = 'P95'; Property = 'P95' }
        @{ Label = 'P99'; Property = 'P99' }
        @{ Label = '>1s'; Property = 'GT1' }
        @{ Label = '>1.5s'; Property = 'GT1_5' }
        @{ Label = '>2s'; Property = 'GT2' }
        @{ Label = 'Longest failure streak'; Property = 'LongestFailureStreak' }
        @{ Label = 'Timeouts'; Property = 'Timeouts' }
        @{ Label = 'Resets'; Property = 'Resets' }
    )
    foreach ($metric in $metrics) {
        [pscustomobject]@{
            Metric = $metric.Label
            WG = $(Get-NullableMetric $script:wgStats $metric.Property)
            HY2 = $(Get-NullableMetric $script:hy2Stats $metric.Property)
        }
    }
}

function New-OwnerOnlyDirectoryAcl {
    $acl = [Security.AccessControl.DirectorySecurity]::new()
    $acl.SetOwner($script:ownerSid)
    $acl.SetAccessRuleProtection($true, $false)
    $inheritance = [Security.AccessControl.InheritanceFlags]::ContainerInherit -bor
                   [Security.AccessControl.InheritanceFlags]::ObjectInherit
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

function New-OwnerOnlyFileAcl {
    $acl = [Security.AccessControl.FileSecurity]::new()
    $acl.SetOwner($script:ownerSid)
    $acl.SetAccessRuleProtection($true, $false)
    $rule = [Security.AccessControl.FileSystemAccessRule]::new(
        $script:ownerSid,
        [Security.AccessControl.FileSystemRights]::FullControl,
        [Security.AccessControl.InheritanceFlags]::None,
        [Security.AccessControl.PropagationFlags]::None,
        [Security.AccessControl.AccessControlType]::Allow
    )
    [void]$acl.AddAccessRule($rule)
    return $acl
}

function New-ExclusiveDirectory {
    param([Parameter(Mandatory = $true)][string]$Path)
    if (-not [G2bOwnerRunnerNative]::CreateDirectory($Path, [IntPtr]::Zero)) {
        throw 'RUNTIME_DIRECTORY_CREATE_EXCLUSIVE_FAILED'
    }
    $script:runtimeDirectoryCreated = $true
    Set-Acl -LiteralPath $Path -AclObject (New-OwnerOnlyDirectoryAcl) -ErrorAction Stop
    Assert-OwnerOnlyAcl $Path
}

function New-ExclusiveFile {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][byte[]]$Bytes,
        [switch]$SecretFile
    )
    $stream = [IO.File]::Open($Path, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
    if ($SecretFile) { $script:runtimeFileCreated = $true }
    try {
        $stream.Write($Bytes, 0, $Bytes.Length)
        $stream.Flush($true)
    } finally {
        $stream.Dispose()
    }
    if ($SecretFile) {
        Set-Acl -LiteralPath $Path -AclObject (New-OwnerOnlyFileAcl) -ErrorAction Stop
        Assert-OwnerOnlyAcl $Path
    }
}

function Test-ContainsBytes {
    param([byte[]]$Haystack, [byte[]]$Needle)
    if ($null -eq $Haystack -or $null -eq $Needle -or $Needle.Length -eq 0 -or
        $Haystack.Length -lt $Needle.Length) { return $false }
    for ($start = 0; $start -le $Haystack.Length - $Needle.Length; $start++) {
        $match = $true
        for ($offset = 0; $offset -lt $Needle.Length; $offset++) {
            if ($Haystack[$start + $offset] -ne $Needle[$offset]) { $match = $false; break }
        }
        if ($match) { return $true }
    }
    return $false
}

function Get-PlaintextAuthArtifactPaths {
    param([Parameter(Mandatory = $true)][byte[]]$AuthPattern)
    $matches = [Collections.Generic.List[string]]::new()
    $utf16Pattern = [byte[]]::new($AuthPattern.Length * 2)
    $privateKeyMarkers = [Collections.Generic.List[byte[]]]::new()
    foreach ($markerText in @(
        '-----BEGIN EC PRIVATE KEY-----'
        '-----BEGIN PRIVATE KEY-----'
        '-----BEGIN RSA PRIVATE KEY-----'
        '-----BEGIN OPENSSH PRIVATE KEY-----'
    )) {
        [void]$privateKeyMarkers.Add([Text.Encoding]::ASCII.GetBytes($markerText))
    }
    for ($index = 0; $index -lt $AuthPattern.Length; $index++) {
        $utf16Pattern[$index * 2] = $AuthPattern[$index]
        $utf16Pattern[($index * 2) + 1] = 0
    }
    try {
        if (-not (Test-Path -LiteralPath $script:runtimeDirectory -PathType Container)) { return $matches.ToArray() }
        $items = @(Get-ChildItem -LiteralPath $script:runtimeDirectory -Force -Recurse -ErrorAction Stop)
        foreach ($item in $items) {
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw 'RUNTIME_REPARSE_POINT_UNEXPECTED'
            }
            if ($item.PSIsContainer) { continue }
            if ($item.Length -gt 67108864) { throw 'RUNTIME_ARTIFACT_TOO_LARGE_TO_VERIFY' }
            $bytes = [IO.File]::ReadAllBytes($item.FullName)
            try {
                $hasSensitiveMarker = (Test-ContainsBytes -Haystack $bytes -Needle $AuthPattern) -or
                    (Test-ContainsBytes -Haystack $bytes -Needle $utf16Pattern)
                foreach ($privateKeyMarker in $privateKeyMarkers) {
                    if (Test-ContainsBytes -Haystack $bytes -Needle $privateKeyMarker) {
                        $hasSensitiveMarker = $true
                        break
                    }
                }
                if ($hasSensitiveMarker) {
                    $matches.Add($item.FullName)
                }
            } finally {
                [Security.Cryptography.CryptographicOperations]::ZeroMemory($bytes)
            }
        }
    } finally {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($utf16Pattern)
    }
    return $matches.ToArray()
}

function Start-MihomoCommand {
    param(
        [Parameter(Mandatory = $true)][string[]]$Arguments,
        [Parameter(Mandatory = $true)][int]$TimeoutMilliseconds
    )
    $process = [Diagnostics.Process]::new()
    $process.StartInfo.FileName = $script:mihomoPath
    $process.StartInfo.WorkingDirectory = $script:runtimeDirectory
    $process.StartInfo.UseShellExecute = $false
    $process.StartInfo.RedirectStandardOutput = $true
    $process.StartInfo.RedirectStandardError = $true
    foreach ($argument in $Arguments) { [void]$process.StartInfo.ArgumentList.Add($argument) }
    $started = $false
    try {
        $started = $process.Start()
        if (-not $started) { throw 'MIHOMO_COMMAND_START_FAILED' }
        $stdoutDrain = $process.StandardOutput.BaseStream.CopyToAsync([IO.Stream]::Null)
        $stderrDrain = $process.StandardError.BaseStream.CopyToAsync([IO.Stream]::Null)
        if (-not $process.WaitForExit($TimeoutMilliseconds)) { throw 'MIHOMO_COMMAND_TIMEOUT' }
        [void]$stdoutDrain.Wait(5000)
        [void]$stderrDrain.Wait(5000)
        return $process.ExitCode
    } finally {
        try {
            if ($started -and -not $process.HasExited) {
                $process.Kill()
                if (-not $process.WaitForExit(10000)) { throw 'MIHOMO_COMMAND_STOP_TIMEOUT' }
            }
        } catch {
            $process.Dispose()
            throw 'MIHOMO_COMMAND_CLEANUP_FAILED'
        }
        $process.Dispose()
    }
}

function Test-MihomoProxyReady {
    param([Parameter(Mandatory = $true)][int]$Port)
    for ($attempt = 0; $attempt -lt 40; $attempt++) {
        if ($null -ne $script:mihomoProcess -and $script:mihomoProcess.HasExited) {
            throw 'TEST_MIHOMO_EXITED_BEFORE_LISTENER'
        }
        $client = [Net.Sockets.TcpClient]::new()
        try {
            $connect = $client.ConnectAsync('127.0.0.1', $Port)
            if ($connect.Wait(250) -and $client.Connected) { return $true }
        } catch { } finally { $client.Dispose() }
        Start-Sleep -Milliseconds 250
    }
    return $false
}

function Write-RowsCsv {
    param([Parameter(Mandatory = $true)][string]$Path, [Parameter(Mandatory = $true)][object[]]$Rows)
    if ($Rows.Count -eq 0) { return }
    $safeRows = @($Rows | Select-Object Timestamp, CurlExit, HttpStatus, TimeNameLookup,
        TimeConnect, TimeAppConnect, TimeStartTransfer, TimeTotal, RemoteIp, ProxyUsed, Error)
    $text = (@($safeRows | ConvertTo-Csv -NoTypeInformation) -join [Environment]::NewLine) + [Environment]::NewLine
    $bytes = [Text.UTF8Encoding]::new($false).GetBytes($text)
    try { New-ExclusiveFile -Path $Path -Bytes $bytes }
    finally { [Security.Cryptography.CryptographicOperations]::ZeroMemory($bytes) }
}

function Write-NewJson {
    param([Parameter(Mandatory = $true)][string]$Path, [Parameter(Mandatory = $true)]$Value)
    $text = ConvertTo-Json -InputObject $Value -Depth 8
    $bytes = [Text.UTF8Encoding]::new($false).GetBytes($text + [Environment]::NewLine)
    try { New-ExclusiveFile -Path $Path -Bytes $bytes }
    finally { [Security.Cryptography.CryptographicOperations]::ZeroMemory($bytes) }
}

function Add-CleanupFailure {
    param([Parameter(Mandatory = $true)][string]$Code)
    $script:cleanupFailures.Add($Code)
    Write-Output "CLEANUP_FAILED=$Code"
}

function Get-NullableMetric {
    param($Stats, [Parameter(Mandatory = $true)][string]$Name)
    if ($null -eq $Stats) { return $null }
    return $Stats.$Name
}

function New-RunSummary {
    return [ordered]@{
        GATE = $(if ($HandshakeOnly) { 'G2B_HY2_HANDSHAKE_ONLY_DIAGNOSTIC' } else { 'G2B_SAFE_WINDOW_COMPARATIVE_VALIDATION' })
        TARGET_PUBLIC_IP = $script:publicVpsIp
        HANDSHAKE_ONLY_MODE = [bool]$HandshakeOnly
        WG_G2B_WITH_OWNER_HOST_ROUTE = $(if ($HandshakeOnly) { 'NO' } else { 'YES' })
        WG_BASELINE_TESTED = [bool]($null -ne $script:wgStats -and $script:wgStats.Samples -eq $script:sampleCount)
        WG_SUCCESS = $(Get-NullableMetric $script:wgStats 'Success')
        WG_FAILURES = $(Get-NullableMetric $script:wgStats 'Failures')
        WG_MEDIAN = $(Get-NullableMetric $script:wgStats 'Median')
        WG_P90 = $(Get-NullableMetric $script:wgStats 'P90')
        WG_P95 = $(Get-NullableMetric $script:wgStats 'P95')
        WG_P99 = $(Get-NullableMetric $script:wgStats 'P99')
        WG_GT_1S = $(Get-NullableMetric $script:wgStats 'GT1')
        WG_GT_1_5S = $(Get-NullableMetric $script:wgStats 'GT1_5')
        WG_GT_2S = $(Get-NullableMetric $script:wgStats 'GT2')
        WG_LONGEST_FAILURE_STREAK = $(Get-NullableMetric $script:wgStats 'LongestFailureStreak')
        WG_TIMEOUTS = $(Get-NullableMetric $script:wgStats 'Timeouts')
        WG_RESETS = $(Get-NullableMetric $script:wgStats 'Resets')
        HY2_TESTED = [bool]($null -ne $script:hy2Stats -and $script:hy2Stats.Samples -eq $script:sampleCount)
        HY2_SUCCESS = $(Get-NullableMetric $script:hy2Stats 'Success')
        HY2_FAILURES = $(Get-NullableMetric $script:hy2Stats 'Failures')
        HY2_MEDIAN = $(Get-NullableMetric $script:hy2Stats 'Median')
        HY2_P90 = $(Get-NullableMetric $script:hy2Stats 'P90')
        HY2_P95 = $(Get-NullableMetric $script:hy2Stats 'P95')
        HY2_P99 = $(Get-NullableMetric $script:hy2Stats 'P99')
        HY2_GT_1S = $(Get-NullableMetric $script:hy2Stats 'GT1')
        HY2_GT_1_5S = $(Get-NullableMetric $script:hy2Stats 'GT1_5')
        HY2_GT_2S = $(Get-NullableMetric $script:hy2Stats 'GT2')
        HY2_LONGEST_FAILURE_STREAK = $(Get-NullableMetric $script:hy2Stats 'LongestFailureStreak')
        HY2_TIMEOUTS = $(Get-NullableMetric $script:hy2Stats 'Timeouts')
        HY2_RESETS = $(Get-NullableMetric $script:hy2Stats 'Resets')
        COMPARISON_TABLE = @(Get-ComparisonTable)
        CURRENT_WINDOW_RESULT = $script:comparison
        HY2_TIMING_NOTE = 'Compare end-to-end time_total; localhost-proxy TCP/DNS sub-stage timings are not directly comparable to WireGuard direct mode.'
        PEAK_HOUR_SUPERIORITY_PROVEN = 'NO'
        HY2_AUTH = $script:handshakeAuth
        TLS_CERTIFICATE_PINNING = $script:handshakePin
        HY2_OUTER_ROUTE = $script:outerRoute
        PUBLIC_EXIT_THROUGH_HY2 = $script:hy2PublicExit
        TEST_MIHOMO_STOPPED = $script:mihomoStopped
        CLIENT_SECRET_RUNTIME_DELETED = $script:runtimeDeleted
        PLAINTEXT_SECRET_ARTIFACTS_REMAINING = $script:plaintextArtifactsRemaining
        OWNER_TEMP_ROUTE_REMOVED = $script:routeRemoved
        PRODUCTION_WG_RESTORED = $script:productionWgRestored
        SECRET_VALUES_EMITTED = 0
        SECRET_VALUES_COMMITTED = 0
        G2B_EXTRA_TUNING_RUN = 'NO'
        SYSTEM_PROXY_CHANGED = $script:systemProxyChanged
        GLOBAL_TUN_ENABLED = $script:globalTunEnabled
        LIVE_SYSTEM_TUNING_APPLIED = 'NO'
        WG_CSV = $(if ($script:wgRows.Count -gt 0) { Split-Path -Leaf $script:wgCsvPath } else { $null })
        HY2_CSV = $(if ($script:hy2Rows.Count -gt 0) { Split-Path -Leaf $script:hy2CsvPath } else { $null })
        RESULT_WRITE_FAILURES = @($script:resultWriteFailures)
        CLEANUP_FAILURES = @($script:cleanupFailures)
        FAILURE_PHASE = $script:failurePhase
        FAILURE_TYPE = $script:failureType
    }
}

try {
    $phase = 'PRECHECK_POWERSHELL_VERSION'
    Assert-Condition (
        $PSVersionTable.PSVersion.Major -ge 7 -and
        ($PSVersionTable.PSVersion.Major -gt 7 -or $PSVersionTable.PSVersion.Minor -ge 3)
    ) 'POWERSHELL_7_3_OR_NEWER_REQUIRED'

    $phase = 'PRECHECK_ADMIN_TOKEN'
    if (-not ('G2bTokenIntegrityNative' -as [type])) {
        $integrityType = @'
using System;
using System.ComponentModel;
using System.Runtime.InteropServices;

public static class G2bTokenIntegrityNative {
    private const int TokenIntegrityLevel = 25;

    [DllImport("advapi32.dll", SetLastError = true)]
    private static extern bool GetTokenInformation(
        IntPtr tokenHandle, int informationClass, IntPtr information,
        int informationLength, out int returnLength);

    [DllImport("advapi32.dll", SetLastError = true)]
    private static extern bool IsValidSid(IntPtr sid);

    [DllImport("advapi32.dll", SetLastError = true)]
    private static extern IntPtr GetSidSubAuthorityCount(IntPtr sid);

    [DllImport("advapi32.dll", SetLastError = true)]
    private static extern IntPtr GetSidSubAuthority(IntPtr sid, uint index);

    public static int GetIntegrityRid(IntPtr tokenHandle) {
        int requiredLength;
        GetTokenInformation(tokenHandle, TokenIntegrityLevel, IntPtr.Zero, 0, out requiredLength);
        if (requiredLength < IntPtr.Size) {
            throw new InvalidOperationException("TOKEN_INTEGRITY_QUERY_SIZE_INVALID");
        }

        IntPtr buffer = Marshal.AllocHGlobal(requiredLength);
        try {
            if (!GetTokenInformation(tokenHandle, TokenIntegrityLevel, buffer,
                                     requiredLength, out requiredLength)) {
                throw new Win32Exception(Marshal.GetLastWin32Error());
            }

            IntPtr sid = Marshal.ReadIntPtr(buffer);
            if (sid == IntPtr.Zero || !IsValidSid(sid)) {
                throw new InvalidOperationException("TOKEN_INTEGRITY_SID_INVALID");
            }

            IntPtr countPointer = GetSidSubAuthorityCount(sid);
            if (countPointer == IntPtr.Zero) {
                throw new InvalidOperationException("TOKEN_INTEGRITY_SID_INVALID");
            }
            byte count = Marshal.ReadByte(countPointer);
            if (count == 0) {
                throw new InvalidOperationException("TOKEN_INTEGRITY_SID_INVALID");
            }

            IntPtr ridPointer = GetSidSubAuthority(sid, (uint)(count - 1));
            if (ridPointer == IntPtr.Zero) {
                throw new InvalidOperationException("TOKEN_INTEGRITY_SID_INVALID");
            }
            return Marshal.ReadInt32(ridPointer);
        }
        finally {
            Marshal.FreeHGlobal(buffer);
        }
    }
}
'@
        Add-Type -TypeDefinition $integrityType -ErrorAction Stop
    }

    $script:ownerIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $script:ownerSid = $script:ownerIdentity.User
    Assert-Condition ($null -ne $script:ownerSid) 'WINDOWS_OWNER_SID_UNAVAILABLE'
    $principal = [Security.Principal.WindowsPrincipal]::new($script:ownerIdentity)
    Assert-Condition ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 'ADMINISTRATOR_TOKEN_REQUIRED'
    $integrityRid = [G2bTokenIntegrityNative]::GetIntegrityRid($script:ownerIdentity.Token)
    Assert-Condition ($integrityRid -ge 12288) 'HIGH_INTEGRITY_TOKEN_REQUIRED'
    Write-Output 'ADMINISTRATOR_TOKEN=YES'
    Write-Output "INTEGRITY_RID=$integrityRid"

    $phase = 'PRECHECK_PATHS_AND_OUTPUT_COLLISIONS'
    Assert-Condition (Test-Path -LiteralPath $dpapiPath -PathType Leaf) 'DPAPI_RECOVERY_ARTIFACT_MISSING'
    Assert-OwnerOnlyAcl $localProjectDirectory
    Assert-OwnerOnlyAcl $recoveryDirectory
    Assert-OwnerOnlyAcl $dpapiPath
    Assert-Condition (Test-DirectoryWriteAccess -Path $localProjectDirectory -CreateDirectory:$true) 'RUNTIME_PARENT_NOT_WRITABLE'
    Assert-Condition (-not (Test-Path -LiteralPath $runtimeDirectory)) 'RUNTIME_DIRECTORY_COLLISION'
    Assert-Condition (-not (Test-Path -LiteralPath $runtimeConfigPath)) 'RUNTIME_CONFIG_COLLISION'
    Assert-Condition (Test-Path -LiteralPath $clientFragmentPath -PathType Leaf) 'CLIENT_FRAGMENT_MISSING'
    Assert-Condition (Test-Path -LiteralPath $mihomoPath -PathType Leaf) 'MIHOMO_BINARY_MISSING'
    Assert-Condition (Test-Path -LiteralPath $projectRoot -PathType Container) 'PROJECT_DIRECTORY_MISSING'
    if (Test-Path -LiteralPath $resultsDirectory) {
        Assert-Condition (Test-Path -LiteralPath $resultsDirectory -PathType Container) 'RESULTS_PATH_NOT_DIRECTORY'
        Assert-Condition (Test-DirectoryWriteAccess -Path $resultsDirectory -CreateDirectory:$false) 'RESULTS_DIRECTORY_NOT_WRITABLE'
    } else {
        Assert-Condition (Test-DirectoryWriteAccess -Path $projectRoot -CreateDirectory:$true) 'RESULTS_PARENT_NOT_WRITABLE'
    }
    foreach ($resultPath in @($wgCsvPath, $hy2CsvPath, $summaryPath)) {
        Assert-Condition (-not (Test-Path -LiteralPath $resultPath)) 'RESULT_FILE_COLLISION'
    }
    $script:curlPath = (Get-Command curl.exe -ErrorAction Stop).Source
    $tcpPortUse = @(Get-NetTCPConnection -LocalPort $proxyPort -State Listen -ErrorAction SilentlyContinue)
    $udpPortUse = @(Get-NetUDPEndpoint -LocalPort $proxyPort -ErrorAction SilentlyContinue)
    Assert-Condition ($tcpPortUse.Count -eq 0 -and $udpPortUse.Count -eq 0) 'TEST_PROXY_PORT_ALREADY_IN_USE'

    $phase = 'PRECHECK_ROUTE_AND_ADAPTERS'
    Assert-OwnerRouteAndWlan

    $phase = 'PRECHECK_WIREGUARD_AND_CLIENT_STATE'
    $manager = Get-ClientSnapshotSingleResult -QuerySubcheck 'WG_SERVICE_QUERY_FAILED' `
        -ShapeSubcheck 'WG_SERVICE_STATE_INVALID' -CardinalityCode 'WIREGUARD_MANAGER_CARDINALITY_INVALID' -Query {
            Get-Service -Name 'WireGuardManager' -ErrorAction Stop
        }
    $tunnel = Get-ClientSnapshotSingleResult -QuerySubcheck 'WG_SERVICE_QUERY_FAILED' `
        -ShapeSubcheck 'WG_SERVICE_STATE_INVALID' -CardinalityCode 'WIREGUARD_TUNNEL_SERVICE_CARDINALITY_INVALID' -Query {
            Get-Service -Name 'WireGuardTunnel$SFO2-A' -ErrorAction Stop
        }
    $wgAdapter = Get-ClientSnapshotSingleResult -QuerySubcheck 'WG_ADAPTER_QUERY_FAILED' `
        -ShapeSubcheck 'WG_ADAPTER_STATE_INVALID' -CardinalityCode 'WG_ADAPTER_CARDINALITY_INVALID' `
        -EmptyResultErrorIds @('CmdletizationQuery_NotFound_Name,Get-NetAdapter') -Query {
            Get-NetAdapter -Name 'SFO2-A' -ErrorAction Stop
        }
    $wgName = [string](Get-PrecheckPropertyValue -InputObject $wgAdapter -PropertyName 'Name' `
        -ShapeSubcheck 'WG_ADAPTER_STATE_INVALID' -ExtractionSubcheck 'CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED' -RequiredValue)
    $wgStatus = [string](Get-PrecheckPropertyValue -InputObject $wgAdapter -PropertyName 'Status' `
        -ShapeSubcheck 'WG_ADAPTER_STATE_INVALID' -ExtractionSubcheck 'CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED' -RequiredValue)
    $wgIfIndex = [int](Get-PrecheckPropertyValue -InputObject $wgAdapter -PropertyName 'InterfaceIndex' `
        -ShapeSubcheck 'WG_ADAPTER_STATE_INVALID' -ExtractionSubcheck 'CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED' -RequiredValue)
    $managerStatus = [string](Get-PrecheckPropertyValue -InputObject $manager -PropertyName 'Status' `
        -ShapeSubcheck 'WG_SERVICE_STATE_INVALID' -ExtractionSubcheck 'CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED' -RequiredValue)
    $tunnelStatus = [string](Get-PrecheckPropertyValue -InputObject $tunnel -PropertyName 'Status' `
        -ShapeSubcheck 'WG_SERVICE_STATE_INVALID' -ExtractionSubcheck 'CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED' -RequiredValue)
    Assert-PrecheckCondition -Condition ($managerStatus -eq 'Running') `
        -Subcheck 'WG_SERVICE_STATE_INVALID' -Code 'WIREGUARD_MANAGER_NOT_RUNNING'
    Assert-PrecheckCondition -Condition ($tunnelStatus -eq 'Running') `
        -Subcheck 'WG_SERVICE_STATE_INVALID' -Code 'WIREGUARD_TUNNEL_SERVICE_NOT_RUNNING'
    Assert-PrecheckCondition -Condition (
        $wgName -eq 'SFO2-A' -and $wgStatus -eq 'Up' -and $wgIfIndex -eq 13
    ) -Subcheck 'WG_ADAPTER_STATE_INVALID' -Code 'WIREGUARD_ADAPTER_NOT_UP'
    $clashService = Get-ClientSnapshotSingleResult -QuerySubcheck 'CLASH_SERVICE_QUERY_FAILED' `
        -ShapeSubcheck 'CLASH_SERVICE_STATE_INVALID' -CardinalityCode 'CLASH_SERVICE_CARDINALITY_INVALID' -Query {
            Get-Service -Name 'clash_verge_service' -ErrorAction Stop
        }
    $clashStatus = [string](Get-PrecheckPropertyValue -InputObject $clashService -PropertyName 'Status' `
        -ShapeSubcheck 'CLASH_SERVICE_STATE_INVALID' -ExtractionSubcheck 'CLIENT_SNAPSHOT_PROPERTY_EXTRACTION_FAILED' -RequiredValue)
    Assert-PrecheckCondition -Condition ($clashStatus -eq 'Running') `
        -Subcheck 'CLASH_SERVICE_STATE_INVALID' -Code 'CLASH_VERGE_SERVICE_NOT_RUNNING'
    $script:baselineSnapshot = Get-ClientSnapshot

    $phase = 'PRECHECK_PUBLIC_EXIT_AND_CONFIG_METADATA'
    $precheckExit = Get-PublicExit
    Assert-Condition ($precheckExit -eq $expectedExit) 'PUBLIC_EXIT_NOT_ACCEPTED_VPS'
    $clientSettings = Get-ClientSettings

    $phase = 'PRECHECK_COMPLETE'
    Write-Output 'ROUTE_QUERY=PASS'
    Write-Output 'WLAN_ADAPTER_QUERY=PASS'
    Write-Output 'WLAN_IP_QUERY=PASS'
    Write-Output 'WG_ADAPTER_QUERY=PASS'
    if ($PreflightOnly) {
        Write-Output 'G2B_PREFLIGHT_ONLY=PASS'
        Write-Output 'SECRET_ACCESSED=NO'
        Write-Output 'MIHOMO_STARTED=NO'
        Write-Output 'BENCHMARK_STARTED=NO'
        Write-Output 'NETWORK_CHANGED=NO'
        return
    }
    $cleanupEligible = $true
    Write-Output 'PHASE=PRECHECK_PASS'

    if ($HandshakeOnly) {
        Write-Output 'HANDSHAKE_ONLY_MODE=YES'
        Write-Output 'WG_BENCHMARK_SKIPPED=YES'
    }
    else {
        $phase = 'WIREGUARD_BASELINE'
        Write-Output 'PHASE=WG_BENCHMARK_START'
        $script:wgStats = Invoke-Benchmark -Name 'WG' -Rows $wgRows -ProxyUrl $null
        if ($wgStats.Samples -ne $sampleCount) { throw 'WG_BASELINE_INCOMPLETE' }
        Write-Output 'WG_BASELINE_TESTED=YES'
    }

    $phase = 'DPAPI_CLIENT_SECRET_PARSE'
    $protectedBytes = [IO.File]::ReadAllBytes($dpapiPath)
    $bundleBytes = [Security.Cryptography.ProtectedData]::Unprotect(
        $protectedBytes,
        $null,
        [Security.Cryptography.DataProtectionScope]::CurrentUser
    )
    [Security.Cryptography.CryptographicOperations]::ZeroMemory($protectedBytes)
    $protectedBytes = $null
    $recoveryFiles = Read-RecoveryBundle $bundleBytes
    if ($recoveryFiles.Fingerprint -ne $clientSettings.Fingerprint) { throw 'CERTIFICATE_FINGERPRINT_MISMATCH' }
    $authBytes = [byte[]]$recoveryFiles.Files['hy2-auth'].Clone()
    foreach ($name in @('hy2-auth', 'server.key', 'server.crt')) {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory([byte[]]$recoveryFiles.Files[$name])
    }
    $recoveryFiles = $null
    [Security.Cryptography.CryptographicOperations]::ZeroMemory($bundleBytes)
    $bundleBytes = $null

    $phase = 'CREATE_OWNER_ONLY_RUNTIME_CONFIG'
    $nativeType = @'
using System;
using System.Runtime.InteropServices;
public static class G2bOwnerRunnerNative {
    [DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    public static extern bool CreateDirectory(string path, IntPtr securityAttributes);
}
'@
    if (-not ('G2bOwnerRunnerNative' -as [type])) {
        Add-Type -TypeDefinition $nativeType -ErrorAction Stop
    }
    New-ExclusiveDirectory -Path $runtimeDirectory
    $lf = [char]10
    $prefix = @(
        'mixed-port: 17890'
        'bind-address: 127.0.0.1'
        'allow-lan: false'
        'mode: rule'
        'log-level: silent'
        'ipv6: false'
        'proxies:'
        '  - name: SFO3-A-HY2'
        '    type: hysteria2'
        "    server: $($clientSettings.Server)"
        "    port: $($clientSettings.Port)"
    ) -join $lf
    $prefix += $lf + '    password: '
    $suffix = @(
        "    sni: $($clientSettings.Sni)"
        '    skip-cert-verify: true'
        "    fingerprint: $($clientSettings.Fingerprint)"
        '    alpn:'
        '      - h3'
        'proxy-groups:'
        '  - name: G2B-TEST'
        '    type: select'
        '    proxies:'
        '      - SFO3-A-HY2'
        'rules:'
        '  - MATCH,G2B-TEST'
        ''
    ) -join $lf
    $prefixBytes = [Text.Encoding]::ASCII.GetBytes($prefix)
    $suffixBytes = [Text.Encoding]::ASCII.GetBytes($lf + $suffix)
    $runtimeConfigBytes = [byte[]]::new($prefixBytes.Length + $authBytes.Length + $suffixBytes.Length)
    [Buffer]::BlockCopy($prefixBytes, 0, $runtimeConfigBytes, 0, $prefixBytes.Length)
    [Buffer]::BlockCopy($authBytes, 0, $runtimeConfigBytes, $prefixBytes.Length, $authBytes.Length)
    [Buffer]::BlockCopy($suffixBytes, 0, $runtimeConfigBytes, $prefixBytes.Length + $authBytes.Length, $suffixBytes.Length)
    [Security.Cryptography.CryptographicOperations]::ZeroMemory($prefixBytes)
    [Security.Cryptography.CryptographicOperations]::ZeroMemory($suffixBytes)
    New-ExclusiveFile -Path $runtimeConfigPath -Bytes $runtimeConfigBytes -SecretFile
    [Security.Cryptography.CryptographicOperations]::ZeroMemory($runtimeConfigBytes)
    $runtimeConfigBytes = $null
    Write-Output 'CLIENT_SECRET_RUNTIME_CREATED=YES'
    Write-Output 'CLIENT_SECRET_RUNTIME_OWNER_ONLY_ACL=PASS'

    $phase = 'MIHOMO_CONFIG_PARSE'
    $parseExit = Start-MihomoCommand -Arguments @('-t', '-f', $runtimeConfigPath) -TimeoutMilliseconds 30000
    Assert-Condition ($parseExit -eq 0) 'MIHOMO_RUNTIME_CONFIG_PARSE_FAILED'
    $phase = 'START_TEST_ONLY_MIHOMO'
    $process = [Diagnostics.Process]::new()
    $process.StartInfo.FileName = $mihomoPath
    $process.StartInfo.WorkingDirectory = $runtimeDirectory
    $process.StartInfo.UseShellExecute = $false
    $process.StartInfo.RedirectStandardOutput = $true
    $process.StartInfo.RedirectStandardError = $true
    [void]$process.StartInfo.ArgumentList.Add('-f')
    [void]$process.StartInfo.ArgumentList.Add($runtimeConfigPath)
    $started = $process.Start()
    if (-not $started) {
        $process.Dispose()
        throw 'TEST_MIHOMO_START_FAILED'
    }
    $mihomoProcess = $process
    $mihomoStarted = $true
    $mihomoStopped = 'NO'
    $stdoutDrain = $process.StandardOutput.BaseStream.CopyToAsync([IO.Stream]::Null)
    $stderrDrain = $process.StandardError.BaseStream.CopyToAsync([IO.Stream]::Null)
    Assert-Condition (Test-MihomoProxyReady -Port $proxyPort) 'MIHOMO_LOCAL_PROXY_NOT_READY'
    Write-Output 'MIHOMO_TEST_PROXY_READY=YES'

    $phase = 'HY2_OUTER_ROUTE_AND_HANDSHAKE'
    Assert-OwnerRouteAndWlan
    $outerRoute = 'WLAN_DIRECT'
    $proxyUrl = "http://127.0.0.1:$proxyPort"
    $handshake = Invoke-CurlSample -TimestampUtc ([DateTime]::UtcNow) -ProxyUrl $proxyUrl
    Write-Output "HY2_HANDSHAKE_PROXY_USED=$($handshake.ProxyUsed)"
    Write-Output "HY2_HANDSHAKE_CURL_EXIT=$($handshake.CurlExit)"
    Write-Output "HY2_HANDSHAKE_HTTP_STATUS=$($handshake.HttpStatus)"
    Write-Output "HY2_HANDSHAKE_ERROR=$($handshake.Error)"
    Write-Output "HY2_HANDSHAKE_TIME_TOTAL=$($handshake.TimeTotal)"
    Write-Output "HY2_HANDSHAKE_TIME_CONNECT=$($handshake.TimeConnect)"
    Write-Output "HY2_HANDSHAKE_TIME_APPCONNECT=$($handshake.TimeAppConnect)"
    Assert-Condition ($handshake.ProxyUsed -eq 1) 'HY2_HANDSHAKE_DID_NOT_USE_LOCAL_PROXY'
    Assert-Condition ($handshake.Success) 'HY2_HANDSHAKE_OR_AUTH_FAILED'
    $handshakeAuth = 'PASS'
    $handshakePin = 'PASS'
    Write-Output 'HY2_AUTH=PASS'
    Write-Output 'TLS_CERTIFICATE_PINNING=PASS'
    Write-Output 'HY2_OUTER_ROUTE=WLAN_DIRECT'

    if ($HandshakeOnly) {
        Write-Output 'HY2_BENCHMARK_SKIPPED=YES'
        $phase = 'TESTS_COMPLETE_CLEANUP_PENDING'
        Write-Output 'HY2_HANDSHAKE_ONLY_COMPLETE=YES'
    }
    else {
        $exitViaHy2 = Get-PublicExit -ProxyUrl $proxyUrl
        Assert-Condition ($exitViaHy2 -eq $expectedExit) 'HY2_PUBLIC_EXIT_MISMATCH'
        $hy2PublicExit = $exitViaHy2
        Write-Output "PUBLIC_EXIT_THROUGH_HY2=$hy2PublicExit"

        $phase = 'HY2_BENCHMARK'
        Assert-OwnerRouteAndWlan
        Write-Output 'PHASE=HY2_BENCHMARK_START'
        $script:hy2Stats = Invoke-Benchmark -Name 'HY2' -Rows $hy2Rows -ProxyUrl $proxyUrl
        Assert-Condition ($hy2Stats.Samples -eq $sampleCount) 'HY2_BENCHMARK_INCOMPLETE'
        $script:comparison = Get-WindowComparison $wgStats $hy2Stats

        $phase = 'TESTS_COMPLETE_CLEANUP_PENDING'
        Write-Output 'G2B_NETWORK_TEST_COMPLETE=YES'
    }
} catch {
    $runFailed = $true
    $failurePhase = $phase
    if ($null -eq $failureType) { $failureType = $_.Exception.GetType().Name }
    Write-Output "RUNNER_FAILED_PHASE=$failurePhase"
    if ($failurePhase -like 'PRECHECK_*') {
        if ($null -eq $failureSubcheck) { $failureSubcheck = $failurePhase }
        Write-Output "PHASE=$failurePhase"
        Write-Output "SUBCHECK=$failureSubcheck"
        Write-Output "NON_SECRET_ERROR_CLASS=$failureType"
        Write-Output 'CONSEQUENTIAL_MUTATION_STARTED=NO'
    }
    $safeFailureCode = [string]$_.Exception.Message
    if ($safeFailureCode -match '^[A-Z][A-Z0-9_]*$') {
        Write-Output "RUNNER_FAILURE_CODE=$safeFailureCode"
    } else {
        Write-Output "RUNNER_FAILURE_TYPE=$failureType"
    }
} finally {
    if ($cleanupEligible) {
        Write-Output 'PHASE=FINALLY_CLEANUP'

        try {
            if ($null -ne $mihomoProcess) {
                if (-not $mihomoProcess.HasExited) {
                    $mihomoProcess.Kill()
                    if (-not $mihomoProcess.WaitForExit(10000)) { throw 'TEST_MIHOMO_STOP_TIMEOUT' }
                }
                $mihomoProcess.Refresh()
                if (-not $mihomoProcess.HasExited) { throw 'TEST_MIHOMO_STILL_RUNNING' }
                $mihomoStopped = 'YES'
            } elseif (-not $mihomoStarted) {
                $mihomoStopped = 'NOT_STARTED'
            }
        } catch { Add-CleanupFailure 'TEST_MIHOMO_STOP_FAILED' }

        try {
            if ($runtimeFileCreated -and (Test-Path -LiteralPath $runtimeConfigPath -PathType Leaf)) {
                Remove-Item -LiteralPath $runtimeConfigPath -Force -ErrorAction Stop
            }
            if (Test-Path -LiteralPath $runtimeConfigPath) { throw 'RUNTIME_CONFIG_STILL_EXISTS' }
            if ($runtimeFileCreated) { $runtimeDeleted = 'YES' } else { $runtimeDeleted = 'NOT_CREATED' }
        } catch { Add-CleanupFailure 'RUNTIME_CONFIG_DELETE_FAILED' }

        try {
            if ($null -ne $authBytes) {
                if ($runtimeFileCreated -and (Test-Path -LiteralPath $runtimeConfigPath -PathType Leaf)) {
                    Remove-Item -LiteralPath $runtimeConfigPath -Force -ErrorAction Stop
                }
                $artifactPaths = @(Get-PlaintextAuthArtifactPaths -AuthPattern $authBytes)
                $plaintextArtifactsRemaining = $artifactPaths.Count
                if ($artifactPaths.Count -gt 0) { throw 'UNEXPECTED_RUNTIME_SECRET_ARTIFACT' }
            } elseif ($runtimeDirectoryCreated) {
                $plaintextArtifactsRemaining = 0
            } else {
                $plaintextArtifactsRemaining = 0
            }
            if ($plaintextArtifactsRemaining -ne 0) { throw 'RUNTIME_SECRET_ARTIFACT_REMAINS' }
            if ($runtimeDirectoryCreated -and (Test-Path -LiteralPath $runtimeDirectory -PathType Container) -and
                @(Get-ChildItem -LiteralPath $runtimeDirectory -Force -ErrorAction Stop).Count -eq 0) {
                [IO.Directory]::Delete($runtimeDirectory, $false)
            }
            if ($null -eq $runtimeDeleted -or $runtimeDeleted -eq 'YES' -or $runtimeDeleted -eq 'NOT_CREATED') {
                if (-not (Test-Path -LiteralPath $runtimeConfigPath)) { $runtimeDeleted = if ($runtimeFileCreated) { 'YES' } else { 'NOT_CREATED' } }
            }
        } catch { Add-CleanupFailure 'RUNTIME_SECRET_SCAN_FAILED' }

        $activeRoutes = $null
        try {
            $activeRoutes = Get-ExactTemporaryRoute
        } catch {
            Add-CleanupFailure 'OWNER_ROUTE_QUERY_FAILED'
        }
        if ($null -ne $activeRoutes) {
            if ($activeRoutes.Count -eq 0) {
                $routeRemoved = 'YES'
            } else {
                $expectedRoute = $false
                $routeStateRead = $false
                try {
                    $expectedRoute = $activeRoutes.Count -eq 1 -and
                        [int]$activeRoutes[0].InterfaceIndex -eq $wlanIndex -and
                        [string]$activeRoutes[0].NextHop -eq $wlanGateway
                    $routeStateRead = $true
                } catch {
                    Add-CleanupFailure 'OWNER_ROUTE_STATE_INVALID'
                }
                if ($routeStateRead -and -not $expectedRoute) {
                    Add-CleanupFailure 'OWNER_ROUTE_STATE_INVALID'
                }
                if ($expectedRoute) {
                    $removeSucceeded = $false
                    try {
                        Remove-NetRoute -InputObject $activeRoutes[0] -Confirm:$false -ErrorAction Stop
                        $removeSucceeded = $true
                    } catch {
                        Add-CleanupFailure 'OWNER_ROUTE_REMOVE_FAILED'
                    }
                    if ($removeSucceeded) {
                        $remainingRoutes = $null
                        try {
                            $remainingRoutes = Get-ExactTemporaryRoute
                        } catch {
                            Add-CleanupFailure 'OWNER_ROUTE_POSTREMOVE_VERIFY_FAILED'
                        }
                        if ($null -ne $remainingRoutes) {
                            if ($remainingRoutes.Count -eq 0) {
                                $routeRemoved = 'YES'
                            } else {
                                Add-CleanupFailure 'OWNER_ROUTE_POSTREMOVE_VERIFY_FAILED'
                            }
                        }
                    }
                }
            }
        }

        try {
            if ($null -eq $baselineSnapshot) { throw 'BASELINE_SNAPSHOT_MISSING' }
            $finalSnapshot = Get-ClientSnapshot
            Assert-Condition ($finalSnapshot.WireGuardManager -eq 'Running') 'WIREGUARD_MANAGER_NOT_RUNNING_AFTER_TEST'
            Assert-Condition ($finalSnapshot.WireGuardTunnel -eq 'Running') 'WIREGUARD_TUNNEL_NOT_RUNNING_AFTER_TEST'
            Assert-Condition ($finalSnapshot.WireGuardAdapter -eq $baselineSnapshot.WireGuardAdapter) 'WIREGUARD_ADAPTER_DRIFT'
            Assert-Condition ($finalSnapshot.ClashService -eq $baselineSnapshot.ClashService) 'CLASH_SERVICE_DRIFT'
            Assert-Condition ($finalSnapshot.ProxyEnable -eq $baselineSnapshot.ProxyEnable -and
                $finalSnapshot.ProxyServer -eq $baselineSnapshot.ProxyServer -and
                $finalSnapshot.ProxyOverride -eq $baselineSnapshot.ProxyOverride -and
                $finalSnapshot.AutoConfigURL -eq $baselineSnapshot.AutoConfigURL) 'SYSTEM_PROXY_CHANGED'
            Assert-Condition ($finalSnapshot.WinHttp -eq $baselineSnapshot.WinHttp) 'WINHTTP_PROXY_CHANGED'
            Assert-Condition ($finalSnapshot.TunAdapters -eq $baselineSnapshot.TunAdapters) 'TUN_STATE_CHANGED'
            Assert-Condition ($finalSnapshot.MihomoProcesses -eq $baselineSnapshot.MihomoProcesses) 'MIHOMO_PROCESS_STATE_CHANGED'
            Assert-Condition ($finalSnapshot.RoutesWithoutOwnerRoute -eq $baselineSnapshot.RoutesWithoutOwnerRoute) 'NON_OWNER_ROUTE_STATE_CHANGED'
            Assert-Condition ((Get-ExactTemporaryRoute).Count -eq 0) 'OWNER_ROUTE_STILL_PRESENT'
            $restoredRoute = @(Find-NetRoute -RemoteIPAddress $publicVpsIp -ErrorAction Stop |
                Where-Object {
                    $_.PSObject.Properties.Name -contains 'DestinationPrefix' -and
                    $_.PSObject.Properties.Name -contains 'InterfaceIndex'
                })
            Assert-Condition ($restoredRoute.Count -eq 1 -and
                [int]$restoredRoute[0].InterfaceIndex -eq $baselineSnapshot.WireGuardIfIndex) 'PRODUCTION_WG_ROUTE_NOT_RESTORED'
            $finalExit = Get-PublicExit
            Assert-Condition ($finalExit -eq $expectedExit) 'PUBLIC_EXIT_CHANGED_AFTER_TEST'
            $systemProxyChanged = 'NO'
            $globalTunEnabled = 'NO'
            $productionWgRestored = 'YES'
        } catch { Add-CleanupFailure 'FINAL_NETWORK_READBACK_FAILED' }

        if ($mihomoStopped -eq 'YES' -or $mihomoStopped -eq 'NOT_STARTED') {
            Write-Output "TEST_MIHOMO_STOPPED=$mihomoStopped"
        }
        Write-Output "CLIENT_SECRET_RUNTIME_DELETED=$runtimeDeleted"
        Write-Output "PLAINTEXT_SECRET_ARTIFACTS_REMAINING=$plaintextArtifactsRemaining"
        Write-Output "OWNER_TEMP_ROUTE_REMOVED=$routeRemoved"
        Write-Output "PRODUCTION_WG_RESTORED=$productionWgRestored"

        $comparison = Get-WindowComparison $wgStats $hy2Stats
        try {
            if (-not (Test-Path -LiteralPath $resultsDirectory -PathType Container)) {
                [void][IO.Directory]::CreateDirectory($resultsDirectory)
            }
            if ($wgRows.Count -gt 0) { Write-RowsCsv -Path $wgCsvPath -Rows $wgRows.ToArray() }
        } catch { $resultWriteFailures.Add('WG_CSV_WRITE_FAILED') }
        try {
            if ($hy2Rows.Count -gt 0) { Write-RowsCsv -Path $hy2CsvPath -Rows $hy2Rows.ToArray() }
        } catch { $resultWriteFailures.Add('HY2_CSV_WRITE_FAILED') }
        try {
            $summary = New-RunSummary
            Write-NewJson -Path $summaryPath -Value $summary
        } catch { $resultWriteFailures.Add('SUMMARY_JSON_WRITE_FAILED') }
    }

    foreach ($sensitiveArray in @($authBytes, $runtimeConfigBytes, $bundleBytes, $protectedBytes)) {
        if ($null -ne $sensitiveArray) {
            [Security.Cryptography.CryptographicOperations]::ZeroMemory([byte[]]$sensitiveArray)
        }
    }
    if ($null -ne $recoveryFiles) {
        foreach ($value in $recoveryFiles.Files.Values) {
            [Security.Cryptography.CryptographicOperations]::ZeroMemory([byte[]]$value)
        }
    }
    if ($null -ne $mihomoProcess) { $mihomoProcess.Dispose() }
}

if ($cleanupFailures.Count -gt 0 -or $resultWriteFailures.Count -gt 0) { $runFailed = $true }
if ($null -ne $wgStats) {
    Write-Output "WG_SUCCESS=$($wgStats.Success)"
    Write-Output "WG_FAILURES=$($wgStats.Failures)"
    Write-Output "WG_MEDIAN=$(Format-TimeValue $wgStats.Median)"
    Write-Output "WG_P90=$(Format-TimeValue $wgStats.P90)"
    Write-Output "WG_P95=$(Format-TimeValue $wgStats.P95)"
    Write-Output "WG_P99=$(Format-TimeValue $wgStats.P99)"
    Write-Output "WG_GT_1S=$($wgStats.GT1)"
    Write-Output "WG_GT_1_5S=$($wgStats.GT1_5)"
    Write-Output "WG_GT_2S=$($wgStats.GT2)"
}
if ($null -ne $hy2Stats) {
    Write-Output "HY2_SUCCESS=$($hy2Stats.Success)"
    Write-Output "HY2_FAILURES=$($hy2Stats.Failures)"
    Write-Output "HY2_MEDIAN=$(Format-TimeValue $hy2Stats.Median)"
    Write-Output "HY2_P90=$(Format-TimeValue $hy2Stats.P90)"
    Write-Output "HY2_P95=$(Format-TimeValue $hy2Stats.P95)"
    Write-Output "HY2_P99=$(Format-TimeValue $hy2Stats.P99)"
    Write-Output "HY2_GT_1S=$($hy2Stats.GT1)"
    Write-Output "HY2_GT_1_5S=$($hy2Stats.GT1_5)"
    Write-Output "HY2_GT_2S=$($hy2Stats.GT2)"
}
Write-Output "CURRENT_WINDOW_RESULT=$comparison"
Write-Output 'PEAK_HOUR_SUPERIORITY_PROVEN=NO'
Write-Host 'Metric | WG | HY2'
foreach ($row in @(Get-ComparisonTable)) {
    Write-Host ("{0} | {1} | {2}" -f $row.Metric, $row.WG, $row.HY2)
}
Write-Output 'SECRET_VALUES_EMITTED=0'
Write-Output 'SECRET_VALUES_COMMITTED=0'
if ($runFailed) {
    Write-Output 'G2B_OWNER_RUNNER_RESULT=FAIL_CLOSED'
    throw 'G2B_OWNER_RUNNER_FAILED_CLOSED'
}
Write-Output 'G2B_OWNER_RUNNER_RESULT=COMPLETE'
