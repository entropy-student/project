[CmdletBinding(DefaultParameterSetName = 'TestFixture')]
param(
    [Parameter(Mandatory = $true, ParameterSetName = 'TestFixture')]
    [switch]$TestFixture,

    [Parameter(Mandatory = $true, ParameterSetName = 'CreatePending')]
    [switch]$CreatePending,

    [Parameter(Mandatory = $true, ParameterSetName = 'VerifyFinal')]
    [switch]$VerifyFinal
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Security.Cryptography.ProtectedData
Add-Type -AssemblyName System.IO.FileSystem.AccessControl

$projectDirectory = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization'
$recoveryDirectory = Join-Path $projectDirectory 'recovery'
$pendingPath = Join-Path $recoveryDirectory 'hy2-g2a.pending.dpapi'
$finalPath = Join-Path $recoveryDirectory 'hy2-g2a.dpapi'
$currentSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
if ($null -eq $currentSid) {
    throw 'DPAPI_OWNER_IDENTITY_UNAVAILABLE'
}

function Protect-AndRoundTrip {
    param([Parameter(Mandatory = $true)][byte[]]$Bytes)

    $ciphertext = [Security.Cryptography.ProtectedData]::Protect(
        $Bytes,
        $null,
        [Security.Cryptography.DataProtectionScope]::CurrentUser
    )
    $plaintext = [Security.Cryptography.ProtectedData]::Unprotect(
        $ciphertext,
        $null,
        [Security.Cryptography.DataProtectionScope]::CurrentUser
    )
    try {
        if (-not [Linq.Enumerable]::SequenceEqual[byte]($Bytes, $plaintext)) {
            throw 'DPAPI_BYTE_IDENTITY_MISMATCH'
        }
        return ,$ciphertext
    }
    finally {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($plaintext)
    }
}

function Read-ExactBytes {
    param(
        [Parameter(Mandatory = $true)][IO.BinaryReader]$Reader,
        [Parameter(Mandatory = $true)][int]$Count
    )

    $bytes = $Reader.ReadBytes($Count)
    if ($bytes.Length -ne $Count) {
        throw 'RECOVERY_FRAME_TRUNCATED'
    }
    return ,$bytes
}

function Read-RecoveryBundle {
    param([Parameter(Mandatory = $true)][byte[]]$Bytes)

    if ($Bytes.Length -gt 131072) {
        throw 'RECOVERY_FRAME_TOO_LARGE'
    }

    $stream = [IO.MemoryStream]::new($Bytes, $false)
    $reader = [IO.BinaryReader]::new($stream, [Text.Encoding]::UTF8, $true)
    $files = @{}
    try {
        $magic = [Text.Encoding]::ASCII.GetString((Read-ExactBytes $reader 8))
        if ($magic -ne 'VPNHY2R1') {
            throw 'RECOVERY_FRAME_MAGIC_INVALID'
        }

        while ($stream.Position -lt $stream.Length) {
            $nameLength = [int]$reader.ReadByte()
            if ($nameLength -lt 1 -or $nameLength -gt 32) {
                throw 'RECOVERY_FRAME_NAME_LENGTH_INVALID'
            }
            $lengthBytes = Read-ExactBytes $reader 4
            $dataLength = ([uint32]$lengthBytes[0] -shl 24) -bor
                          ([uint32]$lengthBytes[1] -shl 16) -bor
                          ([uint32]$lengthBytes[2] -shl 8) -bor
                          [uint32]$lengthBytes[3]
            if ($dataLength -lt 1 -or $dataLength -gt 65536) {
                throw 'RECOVERY_FRAME_DATA_LENGTH_INVALID'
            }

            $name = [Text.Encoding]::UTF8.GetString((Read-ExactBytes $reader $nameLength))
            if ($name -notin @('hy2-auth', 'server.key', 'server.crt') -or $files.ContainsKey($name)) {
                throw 'RECOVERY_FRAME_ALLOWLIST_INVALID'
            }
            $files[$name] = Read-ExactBytes $reader ([int]$dataLength)
        }

        if ($files.Count -ne 3) {
            throw 'RECOVERY_FRAME_CARDINALITY_INVALID'
        }
        $auth = $files['hy2-auth']
        if ($auth.Length -ne 64 -or @($auth | Where-Object { $_ -notin 48..57 -and $_ -notin 97..102 }).Count -gt 0) {
            throw 'RECOVERY_AUTH_FORMAT_INVALID'
        }
        $keyHeader = [Text.Encoding]::ASCII.GetBytes("-----BEGIN EC PRIVATE KEY-----`n")
        $certHeader = [Text.Encoding]::ASCII.GetBytes("-----BEGIN CERTIFICATE-----`n")
        $keyPrefix = [byte[]]$files['server.key'][0..($keyHeader.Length - 1)]
        $certPrefix = [byte[]]$files['server.crt'][0..($certHeader.Length - 1)]
        if ($files['server.key'].Length -gt 8192 -or $files['server.key'].Length -lt $keyHeader.Length -or
            -not [Linq.Enumerable]::SequenceEqual[byte]($keyHeader, $keyPrefix)) {
            throw 'RECOVERY_PRIVATE_KEY_FORMAT_INVALID'
        }
        if ($files['server.crt'].Length -gt 8192 -or $files['server.crt'].Length -lt $certHeader.Length -or
            -not [Linq.Enumerable]::SequenceEqual[byte]($certHeader, $certPrefix)) {
            throw 'RECOVERY_CERTIFICATE_FORMAT_INVALID'
        }

        $certificate = [Security.Cryptography.X509Certificates.X509Certificate2]::new($files['server.crt'])
        $ecKey = $null
        try {
            $ecKey = [Security.Cryptography.X509Certificates.ECDsaCertificateExtensions]::GetECDsaPublicKey($certificate)
            if ($null -eq $ecKey -or $ecKey.KeySize -ne 256) {
                throw 'RECOVERY_CERTIFICATE_KEY_TYPE_INVALID'
            }
            $curveOid = $ecKey.ExportParameters($false).Curve.Oid.Value
            if ($curveOid -ne '1.2.840.10045.3.1.7') {
                throw 'RECOVERY_CERTIFICATE_CURVE_INVALID'
            }
            $sanExtension = $certificate.Extensions | Where-Object { $_.Oid.Value -eq '2.5.29.17' } | Select-Object -First 1
            if ($null -eq $sanExtension) {
                throw 'RECOVERY_CERTIFICATE_SAN_MISSING'
            }
            $san = [Security.Cryptography.X509Certificates.X509SubjectAlternativeNameExtension]::new($sanExtension.RawData)
            $dnsNames = @($san.EnumerateDnsNames())
            if ($dnsNames.Count -ne 1 -or $dnsNames[0] -ne 'hy2.sfo3-a.invalid') {
                throw 'RECOVERY_CERTIFICATE_SAN_INVALID'
            }
            $fingerprint = [Convert]::ToHexString($certificate.GetCertHash([Security.Cryptography.HashAlgorithmName]::SHA256))
            $fingerprint = ($fingerprint -split '(..)' | Where-Object { $_ }) -join ':'
        }
        finally {
            if ($null -ne $ecKey) { $ecKey.Dispose() }
            $certificate.Dispose()
        }

        return [pscustomobject]@{ Files = $files; Fingerprint = $fingerprint }
    }
    catch {
        foreach ($value in $files.Values) {
            [Security.Cryptography.CryptographicOperations]::ZeroMemory($value)
        }
        throw
    }
    finally {
        $reader.Dispose()
        $stream.Dispose()
    }
}

function New-OwnerOnlyAcl {
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
        $currentSid,
        [Security.AccessControl.FileSystemRights]::FullControl,
        $inheritance,
        [Security.AccessControl.PropagationFlags]::None,
        [Security.AccessControl.AccessControlType]::Allow
    )
    [void]$acl.AddAccessRule($rule)
    return $acl
}

function Assert-OwnerOnlyAcl {
    param([Parameter(Mandatory = $true)][string]$Path)

    $acl = Get-Acl -LiteralPath $Path
    if (-not $acl.AreAccessRulesProtected) {
        throw 'RECOVERY_ACL_INHERITANCE_ENABLED'
    }
    $ownerSid = ([Security.Principal.NTAccount]::new($acl.Owner)).Translate([Security.Principal.SecurityIdentifier]).Value
    if ($ownerSid -ne $currentSid.Value) {
        throw 'RECOVERY_OWNER_MISMATCH'
    }
    $rules = @($acl.Access)
    if ($rules.Count -ne 1) {
        throw 'RECOVERY_ACL_PRINCIPAL_COUNT_INVALID'
    }
    $ruleSid = $rules[0].IdentityReference.Translate([Security.Principal.SecurityIdentifier]).Value
    if ($ruleSid -ne $currentSid.Value -or
        $rules[0].AccessControlType -ne [Security.AccessControl.AccessControlType]::Allow -or
        $rules[0].FileSystemRights -ne [Security.AccessControl.FileSystemRights]::FullControl) {
        throw 'RECOVERY_ACL_ALLOWLIST_INVALID'
    }
}

function Read-StandardInputBounded {
    $inputStream = [Console]::OpenStandardInput()
    $memory = [IO.MemoryStream]::new()
    $buffer = [byte[]]::new(8192)
    try {
        while (($count = $inputStream.Read($buffer, 0, $buffer.Length)) -gt 0) {
            if ($memory.Length + $count -gt 131072) {
                throw 'RECOVERY_INPUT_TOO_LARGE'
            }
            $memory.Write($buffer, 0, $count)
        }
        return ,$memory.ToArray()
    }
    finally {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($buffer)
        $memory.Dispose()
    }
}

function New-FixtureFrame {
    $ecdsa = [Security.Cryptography.ECDsa]::Create(
        [Security.Cryptography.ECCurve]::CreateFromValue('1.2.840.10045.3.1.7')
    )
    $certificate = $null
    $stream = [IO.MemoryStream]::new()
    $writer = [IO.BinaryWriter]::new($stream, [Text.Encoding]::UTF8, $true)
    $auth = [Text.Encoding]::ASCII.GetBytes(('a' * 64))
    $keyBytes = $null
    $certBytes = $null
    try {
        $request = [Security.Cryptography.X509Certificates.CertificateRequest]::new(
            'CN=hy2.sfo3-a.invalid',
            $ecdsa,
            [Security.Cryptography.HashAlgorithmName]::SHA256
        )
        $sanBuilder = [Security.Cryptography.X509Certificates.SubjectAlternativeNameBuilder]::new()
        $sanBuilder.AddDnsName('hy2.sfo3-a.invalid')
        $request.CertificateExtensions.Add($sanBuilder.Build())
        $certificate = $request.CreateSelfSigned([DateTimeOffset]::UtcNow.AddMinutes(-1), [DateTimeOffset]::UtcNow.AddDays(1))

        $keyBase64 = [Convert]::ToBase64String($ecdsa.ExportECPrivateKey())
        $keyLines = [regex]::Matches($keyBase64, '.{1,64}') | ForEach-Object { $_.Value }
        $keyPem = "-----BEGIN EC PRIVATE KEY-----`n$($keyLines -join "`n")`n-----END EC PRIVATE KEY-----`n"
        $keyBytes = [Text.Encoding]::ASCII.GetBytes($keyPem)
        $certBytes = [Text.Encoding]::ASCII.GetBytes($certificate.ExportCertificatePem())

        $writer.Write([Text.Encoding]::ASCII.GetBytes('VPNHY2R1'))
        foreach ($entry in @(
            [pscustomobject]@{ Name = 'hy2-auth'; Bytes = $auth },
            [pscustomobject]@{ Name = 'server.key'; Bytes = $keyBytes },
            [pscustomobject]@{ Name = 'server.crt'; Bytes = $certBytes }
        )) {
            $nameBytes = [Text.Encoding]::UTF8.GetBytes($entry.Name)
            $writer.Write([byte]$nameBytes.Length)
            $lengthBytes = [BitConverter]::GetBytes([uint32]$entry.Bytes.Length)
            if ([BitConverter]::IsLittleEndian) { [Array]::Reverse($lengthBytes) }
            $writer.Write($lengthBytes)
            $writer.Write($nameBytes)
            $writer.Write($entry.Bytes)
        }
        return ,$stream.ToArray()
    }
    finally {
        $writer.Dispose()
        $stream.Dispose()
        $ecdsa.Dispose()
        if ($null -ne $certificate) { $certificate.Dispose() }
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($auth)
        if ($null -ne $keyBytes) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($keyBytes) }
        if ($null -ne $certBytes) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($certBytes) }
    }
}

if ($TestFixture) {
    $fixture = $null
    $protected = $null
    $bundle = $null
    try {
        $fixture = New-FixtureFrame
        $bundle = Read-RecoveryBundle $fixture
        $protected = Protect-AndRoundTrip $fixture
        'DPAPI_FIXTURE_BUNDLE_VALIDATION=PASS'
        'DPAPI_FIXTURE_ROUNDTRIP=PASS'
    }
    finally {
        if ($null -ne $bundle) {
            foreach ($value in $bundle.Files.Values) {
                [Security.Cryptography.CryptographicOperations]::ZeroMemory($value)
            }
        }
        if ($null -ne $fixture) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($fixture) }
        if ($null -ne $protected) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($protected) }
    }
    'DPAPI_SCOPE=CurrentUser'
    'PLAINTEXT_FILE_CREATED=NO'
    exit 0
}

if ($VerifyFinal) {
    if (-not (Test-Path -LiteralPath $finalPath -PathType Leaf)) {
        throw 'RECOVERY_FINAL_MISSING'
    }
    Assert-OwnerOnlyAcl $recoveryDirectory
    Assert-OwnerOnlyAcl $finalPath
    $ciphertext = [IO.File]::ReadAllBytes($finalPath)
    $plaintext = [Security.Cryptography.ProtectedData]::Unprotect(
        $ciphertext,
        $null,
        [Security.Cryptography.DataProtectionScope]::CurrentUser
    )
    try {
        $bundle = Read-RecoveryBundle $plaintext
        foreach ($value in $bundle.Files.Values) {
            [Security.Cryptography.CryptographicOperations]::ZeroMemory($value)
        }
        "FINAL_EXISTS=YES"
        "FINAL_BYTES=$($ciphertext.Length)"
        "OWNER_ONLY_ACL=PASS"
        "FINAL_DPAPI_ROUNDTRIP=PASS"
        "CERT_SHA256_FINGERPRINT=$($bundle.Fingerprint)"
        'SECRET_VALUES_EMITTED=0'
    }
    finally {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($ciphertext)
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($plaintext)
    }
    exit 0
}

$phase = 'READ_INPUT'
$createdProjectDirectory = $false
$createdRecoveryDirectory = $false
$createdPendingFile = $false
$frame = $null
$ciphertext = $null
$verifyBytes = $null
try {
    if ((Test-Path -LiteralPath $projectDirectory) -or
        (Test-Path -LiteralPath $recoveryDirectory) -or
        (Test-Path -LiteralPath $pendingPath) -or
        (Test-Path -LiteralPath $finalPath)) {
        throw 'RECOVERY_TARGET_EXISTS'
    }

    $frame = Read-StandardInputBounded
    $bundle = Read-RecoveryBundle $frame
    foreach ($value in $bundle.Files.Values) {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($value)
    }

    $phase = 'DPAPI_ROUNDTRIP'
    $ciphertext = Protect-AndRoundTrip $frame

    $phase = 'CREATE_PROJECT_DIRECTORY'
    [void][IO.Directory]::CreateDirectory($projectDirectory)
    $createdProjectDirectory = $true
    Set-Acl -LiteralPath $projectDirectory -AclObject (New-OwnerOnlyAcl -Directory)
    Assert-OwnerOnlyAcl $projectDirectory

    $phase = 'CREATE_RECOVERY_DIRECTORY'
    [void][IO.Directory]::CreateDirectory($recoveryDirectory)
    $createdRecoveryDirectory = $true
    Set-Acl -LiteralPath $recoveryDirectory -AclObject (New-OwnerOnlyAcl -Directory)
    Assert-OwnerOnlyAcl $projectDirectory
    Assert-OwnerOnlyAcl $recoveryDirectory

    $phase = 'CREATE_PENDING_EXCLUSIVE'
    $fileStream = [IO.File]::Open(
        $pendingPath,
        [IO.FileMode]::CreateNew,
        [IO.FileAccess]::Write,
        [IO.FileShare]::None
    )
    $createdPendingFile = $true
    try {
        $fileStream.Write($ciphertext, 0, $ciphertext.Length)
        $fileStream.Flush($true)
    }
    finally {
        $fileStream.Dispose()
    }
    Set-Acl -LiteralPath $pendingPath -AclObject (New-OwnerOnlyAcl)
    Assert-OwnerOnlyAcl $pendingPath

    $phase = 'PENDING_READBACK'
    $verifyCiphertext = [IO.File]::ReadAllBytes($pendingPath)
    $verifyBytes = [Security.Cryptography.ProtectedData]::Unprotect(
        $verifyCiphertext,
        $null,
        [Security.Cryptography.DataProtectionScope]::CurrentUser
    )
    if (-not [Linq.Enumerable]::SequenceEqual[byte]($frame, $verifyBytes)) {
        throw 'RECOVERY_PENDING_BYTE_IDENTITY_MISMATCH'
    }
    [Security.Cryptography.CryptographicOperations]::ZeroMemory($verifyCiphertext)

    "PENDING_CREATED=YES"
    "PENDING_BYTES=$($ciphertext.Length)"
    "OWNER_ONLY_ACL=PASS"
    "ACL_INHERITANCE=DISABLED"
    "DPAPI_SCOPE=CurrentUser"
    "DPAPI_ROUNDTRIP=PASS"
    "CERT_SHA256_FINGERPRINT=$($bundle.Fingerprint)"
    'PLAINTEXT_FILES_CREATED=0'
    'SECRET_VALUES_EMITTED=0'
}
catch {
    $failurePhase = $phase
    $failureType = $_.Exception.GetType().Name
    "DPAPI_PENDING_FAILED_AT=$failurePhase"
    "DPAPI_FAILURE_TYPE=$failureType"
    if ($createdPendingFile) { Remove-Item -LiteralPath $pendingPath -Force -ErrorAction SilentlyContinue }
    if ($createdRecoveryDirectory) {
        try { [IO.Directory]::Delete($recoveryDirectory, $false) } catch { }
    }
    if ($createdProjectDirectory) {
        try { [IO.Directory]::Delete($projectDirectory, $false) } catch { }
    }
    throw "DPAPI_PENDING_FAILED_AT=$failurePhase"
}
finally {
    if ($null -ne $frame) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($frame) }
    if ($null -ne $ciphertext) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($ciphertext) }
    if ($null -ne $verifyBytes) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($verifyBytes) }
}
