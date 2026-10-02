[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:phase = 'PRECHECK'
$script:failed = $false
$script:promoted = $false
$script:createdProjectDirectory = $false
$script:createdRecoveryDirectory = $false
$script:createdPendingFile = $false
$script:sshProcessStarted = $false
$script:sshCleanupFailed = $false
$script:sshExitCode = $null
$script:remoteTransferCompleted = $false
$script:localFinalizationStarted = $false
$script:localFinalizationCompleted = $false
$script:failureReported = $false
$script:cleanupFailed = $false
$script:payloadBytes = $null
$script:protectedBytes = $null
$script:pendingCiphertext = $null
$script:pendingPlaintext = $null
$script:finalCiphertext = $null
$script:finalPlaintext = $null
$script:ownerIdentity = $null
$script:ownerSid = $null
$script:privateKey = $null
$script:certificate = $null

function Assert-Condition {
    param(
        [Parameter(Mandatory = $true)][bool]$Condition,
        [Parameter(Mandatory = $true)][string]$Code
    )
    if (-not $Condition) { throw $Code }
}

function Assert-NotReparsePoint {
    param([Parameter(Mandatory = $true)][string]$Path)
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
        throw 'RECOVERY_PATH_REPARSE_POINT'
    }
    return $item
}

function Assert-TargetAbsent {
    param([Parameter(Mandatory = $true)][string]$Path)
    $parent = [IO.Path]::GetDirectoryName($Path)
    if (-not [IO.Directory]::Exists($parent)) { return }
    foreach ($entry in [IO.Directory]::EnumerateFileSystemEntries($parent)) {
        if ([string]::Equals(
                [IO.Path]::GetFileName($entry),
                [IO.Path]::GetFileName($Path),
                [StringComparison]::OrdinalIgnoreCase
            )) {
            throw 'RECOVERY_TARGET_ALREADY_EXISTS'
        }
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
        $script:ownerSid,
        [Security.AccessControl.FileSystemRights]::FullControl,
        $inheritance,
        [Security.AccessControl.PropagationFlags]::None,
        [Security.AccessControl.AccessControlType]::Allow
    )
    [void]$acl.AddAccessRule($rule)
    return $acl
}

function Assert-OwnerOnlyAclRules {
    param(
        [Parameter(Mandatory = $true)][object[]]$Rules,
        [switch]$Directory
    )

    if ($Rules.Count -eq 0) { throw 'RECOVERY_ACL_RULES_MISSING' }
    $directRights = [long]0
    $containerRights = [long]0
    $objectRights = [long]0
    foreach ($rule in $Rules) {
        if ($rule.IsInherited) { throw 'RECOVERY_ACL_INHERITED_RULE_PRESENT' }
        $ruleSid = if ($rule.IdentityReference -is [Security.Principal.SecurityIdentifier]) {
            $rule.IdentityReference.Value
        }
        else {
            $rule.IdentityReference.Translate([Security.Principal.SecurityIdentifier]).Value
        }
        if ($ruleSid -ne $script:ownerSid.Value) { throw 'RECOVERY_ACL_ALLOWLIST_INVALID' }
        if ($rule.AccessControlType -ne [Security.AccessControl.AccessControlType]::Allow) {
            throw 'RECOVERY_ACL_DENY_RULE_PRESENT'
        }
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
            throw 'RECOVERY_ACL_FILE_INHERITANCE_FLAGS_INVALID'
        }
    }

    $fullControl = [long][Security.AccessControl.FileSystemRights]::FullControl
    if (($directRights -band $fullControl) -ne $fullControl) {
        throw 'RECOVERY_ACL_OWNER_FULLCONTROL_MISSING'
    }
    if ($Directory -and
        ((($containerRights -band $fullControl) -ne $fullControl) -or
         (($objectRights -band $fullControl) -ne $fullControl))) {
        throw 'RECOVERY_ACL_CHILD_FULLCONTROL_INHERITANCE_MISSING'
    }
}

function Assert-OwnerOnlyAcl {
    param([Parameter(Mandatory = $true)][string]$Path)

    $item = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    $acl = Get-Acl -LiteralPath $Path -ErrorAction Stop
    if (-not $acl.AreAccessRulesProtected) { throw 'RECOVERY_ACL_INHERITANCE_ENABLED' }
    $ownerSid = ([Security.Principal.NTAccount]::new($acl.Owner)).Translate(
        [Security.Principal.SecurityIdentifier]
    ).Value
    if ($ownerSid -ne $script:ownerSid.Value) { throw 'RECOVERY_ACL_OWNER_MISMATCH' }
    $rules = @($acl.GetAccessRules(
        $true,
        $true,
        [Security.Principal.SecurityIdentifier]
    ))
    Assert-OwnerOnlyAclRules -Rules $rules -Directory:$item.PSIsContainer
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

function Clear-RecoveryBundle {
    param([AllowNull()][object]$Bundle)
    if ($null -eq $Bundle) { return }
    foreach ($value in $Bundle.Files.Values) {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($value)
    }
}

function Read-RecoveryBundle {
    param([Parameter(Mandatory = $true)][byte[]]$Bytes)

    if ($Bytes.Length -gt 131072) { throw 'RECOVERY_FRAME_TOO_LARGE' }
    $stream = [IO.MemoryStream]::new($Bytes, $false)
    $reader = [IO.BinaryReader]::new($stream, [Text.Encoding]::UTF8, $true)
    $files = [Collections.Generic.Dictionary[string, byte[]]]::new([StringComparer]::Ordinal)
    $certificate = $null
    $privateKey = $null
    $keyText = $null
    try {
        $magic = [Text.Encoding]::ASCII.GetString((Read-ExactBytes $reader 8))
        if ($magic -cne 'VPNHY2R1') { throw 'RECOVERY_FRAME_MAGIC_INVALID' }

        while ($stream.Position -lt $stream.Length) {
            $nameLength = [int]$reader.ReadByte()
            if ($nameLength -lt 1 -or $nameLength -gt 32) {
                throw 'RECOVERY_FRAME_NAME_LENGTH_INVALID'
            }
            $lengthBytes = Read-ExactBytes $reader 4
            $dataLength = [uint64]$lengthBytes[0] * 16777216 +
                          [uint64]$lengthBytes[1] * 65536 +
                          [uint64]$lengthBytes[2] * 256 +
                          [uint64]$lengthBytes[3]
            if ($dataLength -lt 1 -or $dataLength -gt 65536) {
                throw 'RECOVERY_FRAME_DATA_LENGTH_INVALID'
            }
            $name = [Text.Encoding]::UTF8.GetString((Read-ExactBytes $reader $nameLength))
            if ($name -cnotin @('hy2-auth', 'server.key', 'server.crt') -or $files.ContainsKey($name)) {
                throw 'RECOVERY_FRAME_ALLOWLIST_INVALID'
            }
            $files.Add($name, (Read-ExactBytes $reader ([int]$dataLength)))
        }
        if ($files.Count -ne 3) { throw 'RECOVERY_FRAME_CARDINALITY_INVALID' }

        $auth = $files['hy2-auth']
        if ($auth.Length -ne 64) { throw 'RECOVERY_AUTH_FORMAT_INVALID' }
        foreach ($value in $auth) {
            if (($value -lt 48 -or $value -gt 57) -and ($value -lt 97 -or $value -gt 102)) {
                throw 'RECOVERY_AUTH_FORMAT_INVALID'
            }
        }

        $keyBytes = $files['server.key']
        $certBytes = $files['server.crt']
        $keyHeader = [Text.Encoding]::ASCII.GetBytes("-----BEGIN EC PRIVATE KEY-----`n")
        $certHeader = [Text.Encoding]::ASCII.GetBytes("-----BEGIN CERTIFICATE-----`n")
        if ($keyBytes.Length -lt $keyHeader.Length -or $keyBytes.Length -gt 8192 -or
            -not [Linq.Enumerable]::SequenceEqual[byte]($keyHeader, [byte[]]$keyBytes[0..($keyHeader.Length - 1)])) {
            throw 'RECOVERY_PRIVATE_KEY_FORMAT_INVALID'
        }
        if ($certBytes.Length -lt $certHeader.Length -or $certBytes.Length -gt 8192 -or
            -not [Linq.Enumerable]::SequenceEqual[byte]($certHeader, [byte[]]$certBytes[0..($certHeader.Length - 1)])) {
            throw 'RECOVERY_CERTIFICATE_FORMAT_INVALID'
        }

        $keyText = [Text.Encoding]::ASCII.GetString($keyBytes)
        $privateKey = [Security.Cryptography.ECDsa]::Create()
        $privateKey.ImportFromPem($keyText)
        if ($privateKey.KeySize -ne 256 -or
            $privateKey.ExportParameters($false).Curve.Oid.Value -ne '1.2.840.10045.3.1.7') {
            throw 'RECOVERY_PRIVATE_KEY_CURVE_INVALID'
        }

        $certificate = [Security.Cryptography.X509Certificates.X509Certificate2]::new($certBytes)
        $publicKey = [Security.Cryptography.X509Certificates.ECDsaCertificateExtensions]::GetECDsaPublicKey($certificate)
        if ($null -eq $publicKey -or $publicKey.KeySize -ne 256 -or
            $publicKey.ExportParameters($false).Curve.Oid.Value -ne '1.2.840.10045.3.1.7') {
            if ($null -ne $publicKey) { $publicKey.Dispose() }
            throw 'RECOVERY_CERTIFICATE_KEY_TYPE_INVALID'
        }
        try {
            $privatePublic = $privateKey.ExportParameters($false)
            $certificatePublic = $publicKey.ExportParameters($false)
            if (-not [Security.Cryptography.CryptographicOperations]::FixedTimeEquals(
                    $privatePublic.Q.X, $certificatePublic.Q.X
                ) -or -not [Security.Cryptography.CryptographicOperations]::FixedTimeEquals(
                    $privatePublic.Q.Y, $certificatePublic.Q.Y
                )) {
                throw 'RECOVERY_CERTIFICATE_PRIVATE_KEY_MISMATCH'
            }
        }
        finally {
            $publicKey.Dispose()
        }

        $sanExtension = $certificate.Extensions |
            Where-Object { $_.Oid.Value -eq '2.5.29.17' } |
            Select-Object -First 1
        if ($null -eq $sanExtension) { throw 'RECOVERY_CERTIFICATE_SAN_MISSING' }
        $san = [Security.Cryptography.X509Certificates.X509SubjectAlternativeNameExtension]::new(
            $sanExtension.RawData
        )
        $dnsNames = @($san.EnumerateDnsNames())
        if ($dnsNames.Count -ne 1 -or $dnsNames[0] -cne 'hy2.sfo3-a.invalid') {
            throw 'RECOVERY_CERTIFICATE_SAN_INVALID'
        }
        $fingerprint = [Convert]::ToHexString(
            $certificate.GetCertHash([Security.Cryptography.HashAlgorithmName]::SHA256)
        )
        $fingerprint = ($fingerprint -split '(..)' | Where-Object { $_ }) -join ':'

        return [pscustomobject]@{ Files = $files; Fingerprint = $fingerprint }
    }
    catch {
        foreach ($value in $files.Values) {
            [Security.Cryptography.CryptographicOperations]::ZeroMemory($value)
        }
        throw
    }
    finally {
        if ($null -ne $privateKey) { $privateKey.Dispose() }
        if ($null -ne $certificate) { $certificate.Dispose() }
        $keyText = $null
        $reader.Dispose()
        $stream.Dispose()
    }
}

function Receive-VpsRecoveryBundle {
    param(
        [Parameter(Mandatory = $true)][string]$SshPath,
        [Parameter(Mandatory = $true)][string]$IdentityPath,
        [Parameter(Mandatory = $true)][string]$KnownHostsPath
    )

    $pythonSource = @'
import os, stat, struct, sys
items = ((b"hy2-auth", b"/srv/data/vpn-network-optimization/secrets/hy2-auth", 0o600), (b"server.key", b"/srv/data/vpn-network-optimization/secrets/server.key", 0o640), (b"server.crt", b"/srv/data/vpn-network-optimization/secrets/server.crt", 0o644))
frame = bytearray(b"VPNHY2R1")
try:
    for name, path, expected_mode in items:
        fd = os.open(path, os.O_RDONLY | getattr(os, "O_NOFOLLOW", 0))
        with os.fdopen(fd, "rb") as source:
            info = os.fstat(source.fileno())
            if (not stat.S_ISREG(info.st_mode) or info.st_uid != 0 or
                    stat.S_IMODE(info.st_mode) != expected_mode or
                    info.st_size < 1 or info.st_size > 65536):
                raise ValueError()
            data = source.read(info.st_size + 1)
            if len(data) != info.st_size:
                raise ValueError()
        frame.extend(bytes((len(name),)))
        frame.extend(struct.pack(">I", len(data)))
        frame.extend(name)
        frame.extend(data)
    sys.stdout.buffer.write(frame)
    sys.stdout.buffer.flush()
except BaseException:
    sys.exit(73)
'@
    $sourceBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($pythonSource))
    $remoteCommand = 'python3 -c ''import base64;exec(compile(base64.b64decode("{0}"),"<memory>","exec"))''' -f $sourceBase64

    $process = [Diagnostics.Process]::new()
    $memory = [IO.MemoryStream]::new()
    $buffer = [byte[]]::new(8192)
    $stderrDrain = $null
    $processStarted = $false
    $readTask = $null
    try {
        $process.StartInfo.FileName = $SshPath
        $process.StartInfo.UseShellExecute = $false
        $process.StartInfo.RedirectStandardOutput = $true
        $process.StartInfo.RedirectStandardError = $true
        foreach ($argument in @(
            '-F', 'none', '-T', '-p', '22', '-i', $IdentityPath,
            '-o', 'BatchMode=yes',
            '-o', 'IdentitiesOnly=yes',
            '-o', 'PreferredAuthentications=publickey',
            '-o', 'StrictHostKeyChecking=yes',
            '-o', 'UpdateHostKeys=no',
            '-o', "UserKnownHostsFile=$KnownHostsPath",
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
            'root@10.66.21.1', $remoteCommand
        )) {
            [void]$process.StartInfo.ArgumentList.Add($argument)
        }
        if (-not $process.Start()) { throw 'SSH_PROCESS_START_FAILED' }
        $processStarted = $true
        $script:sshProcessStarted = $true
        $stderrDrain = $process.StandardError.BaseStream.CopyToAsync([IO.Stream]::Null)
        $deadline = [DateTimeOffset]::UtcNow.AddSeconds(60)
        while ($true) {
            $remaining = [int]($deadline - [DateTimeOffset]::UtcNow).TotalMilliseconds
            if ($remaining -le 0) { throw 'SSH_RECEIVE_TIMEOUT' }
            $readTask = $process.StandardOutput.BaseStream.ReadAsync($buffer, 0, $buffer.Length)
            if (-not $readTask.Wait($remaining)) { throw 'SSH_RECEIVE_TIMEOUT' }
            $count = $readTask.Result
            if ($count -eq 0) { break }
            if ($memory.Length + $count -gt 131072) { throw 'RECOVERY_FRAME_TOO_LARGE' }
            $memory.Write($buffer, 0, $count)
        }
        if (-not $process.WaitForExit(15000)) { throw 'SSH_PROCESS_TIMEOUT' }
        if ($null -ne $stderrDrain -and -not $stderrDrain.Wait(15000)) {
            throw 'SSH_STDERR_DRAIN_TIMEOUT'
        }
        $script:sshExitCode = $process.ExitCode
        if ($process.ExitCode -ne 0) { throw 'SSH_READ_OR_HOST_KEY_VALIDATION_FAILED' }
        if ($memory.Length -lt 8) { throw 'RECOVERY_FRAME_EMPTY' }
        $script:remoteTransferCompleted = $true
        return ,$memory.ToArray()
    }
    catch {
        if ($processStarted -and -not $process.HasExited) {
            try { $process.Kill(); $process.WaitForExit(5000) } catch { }
        }
        throw 'SSH_RECOVERY_TRANSFER_FAILED'
    }
    finally {
        if ($processStarted -and -not $process.HasExited) {
            try {
                $process.Kill()
                if (-not $process.WaitForExit(5000)) { $script:sshCleanupFailed = $true }
            }
            catch { $script:sshCleanupFailed = $true }
        }
        if ($null -ne $readTask -and -not $readTask.IsCompleted) {
            try { [void]$readTask.Wait(5000) } catch { }
        }
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($buffer)
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($memory.GetBuffer())
        $memory.Dispose()
        $process.Dispose()
    }
}

function Test-ByteIdentity {
    param(
        [Parameter(Mandatory = $true)][byte[]]$Expected,
        [Parameter(Mandatory = $true)][byte[]]$Actual
    )
    return $Expected.Length -eq $Actual.Length -and
        [Security.Cryptography.CryptographicOperations]::FixedTimeEquals($Expected, $Actual)
}

try {
    $script:phase = 'PRECHECK_OWNER_TOKEN'
    if ($PSVersionTable.PSVersion -lt [version]'7.6.6') { throw 'POWERSHELL_7_6_6_REQUIRED' }
    $script:ownerIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $script:ownerSid = $script:ownerIdentity.User
    if ($null -eq $script:ownerSid) { throw 'OWNER_SID_UNAVAILABLE' }
    $principal = [Security.Principal.WindowsPrincipal]::new($script:ownerIdentity)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw 'ADMINISTRATOR_TOKEN_REQUIRED'
    }

    if (-not ('OwnerDpapiRepairNative' -as [type])) {
        Add-Type -TypeDefinition @'
using System;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Security.Principal;
public static class OwnerDpapiRepairNative {
    [DllImport("advapi32.dll", SetLastError=true)]
    private static extern bool GetTokenInformation(IntPtr token, int informationClass,
        IntPtr information, int informationLength, out int returnLength);
    [DllImport("advapi32.dll", SetLastError=true)]
    private static extern bool IsValidSid(IntPtr sid);
    [DllImport("advapi32.dll", SetLastError=true)]
    private static extern IntPtr GetSidSubAuthorityCount(IntPtr sid);
    [DllImport("advapi32.dll", SetLastError=true)]
    private static extern IntPtr GetSidSubAuthority(IntPtr sid, uint index);
    [DllImport("kernel32.dll", CharSet=CharSet.Unicode, SetLastError=true)]
    private static extern bool CreateDirectoryW(string path, IntPtr securityAttributes);

    public static int GetIntegrityRid(IntPtr token) {
        const int TokenIntegrityLevel = 25;
        int length = 0;
        GetTokenInformation(token, TokenIntegrityLevel, IntPtr.Zero, 0, out length);
        if (length <= 0) throw new Win32Exception(Marshal.GetLastWin32Error());
        IntPtr buffer = Marshal.AllocHGlobal(length);
        try {
            if (!GetTokenInformation(token, TokenIntegrityLevel, buffer, length, out length))
                throw new Win32Exception(Marshal.GetLastWin32Error());
            IntPtr sid = Marshal.ReadIntPtr(buffer);
            if (sid == IntPtr.Zero || !IsValidSid(sid)) throw new InvalidOperationException();
            IntPtr countPointer = GetSidSubAuthorityCount(sid);
            if (countPointer == IntPtr.Zero) throw new InvalidOperationException();
            byte count = Marshal.ReadByte(countPointer);
            if (count == 0) throw new InvalidOperationException();
            IntPtr ridPointer = GetSidSubAuthority(sid, (uint)(count - 1));
            if (ridPointer == IntPtr.Zero) throw new InvalidOperationException();
            return Marshal.ReadInt32(ridPointer);
        }
        finally { Marshal.FreeHGlobal(buffer); }
    }

    public static void CreateDirectoryExclusive(string path) {
        if (!CreateDirectoryW(path, IntPtr.Zero))
            throw new Win32Exception(Marshal.GetLastWin32Error());
    }
}
'@ -ErrorAction Stop
    }
    $integrityRid = [OwnerDpapiRepairNative]::GetIntegrityRid($script:ownerIdentity.Token)
    if ($integrityRid -lt 12288) { throw 'HIGH_INTEGRITY_TOKEN_REQUIRED' }
    if (-not [string]::Equals(
            $env:LOCALAPPDATA.TrimEnd('\'),
            'C:\Users\34707\AppData\Local',
            [StringComparison]::OrdinalIgnoreCase
        )) {
        throw 'OWNER_WINDOWS_TARGET_MISMATCH'
    }
    $script:phase = 'PRECHECK_PATHS_AND_SSH'
    $projectRoot = Split-Path -Parent $PSScriptRoot
    $clientFragmentPath = Join-Path $projectRoot 'config\clash\sfo3-a-hy2.yaml'
    if (-not (Test-Path -LiteralPath $clientFragmentPath -PathType Leaf)) {
        throw 'ACCEPTED_CLIENT_FRAGMENT_MISSING'
    }
    $clientText = Get-Content -LiteralPath $clientFragmentPath -Raw
    $fingerprintMatches = [regex]::Matches(
        $clientText,
        '(?im)^\s*fingerprint:\s*(?<value>(?:[0-9A-F]{2}:){31}[0-9A-F]{2})\s*$'
    )
    if ($fingerprintMatches.Count -ne 1) { throw 'ACCEPTED_FINGERPRINT_AMBIGUOUS' }
    $expectedFingerprint = $fingerprintMatches[0].Groups['value'].Value.ToUpperInvariant()

    $projectLocalDirectory = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization'
    $recoveryDirectory = Join-Path $projectLocalDirectory 'recovery'
    $pendingPath = Join-Path $recoveryDirectory 'hy2-g2a.pending.dpapi'
    $finalPath = Join-Path $recoveryDirectory 'hy2-g2a.dpapi'
    if ([IO.Directory]::Exists($projectLocalDirectory)) {
        [void](Assert-NotReparsePoint $projectLocalDirectory)
    }
    elseif ([IO.File]::Exists($projectLocalDirectory)) {
        throw 'RECOVERY_PARENT_NOT_DIRECTORY'
    }
    if ([IO.Directory]::Exists($recoveryDirectory)) {
        [void](Assert-NotReparsePoint $recoveryDirectory)
        Assert-OwnerOnlyAcl $recoveryDirectory
    }
    elseif ([IO.File]::Exists($recoveryDirectory)) {
        throw 'RECOVERY_DIRECTORY_COLLISION'
    }
    Assert-TargetAbsent $pendingPath
    Assert-TargetAbsent $finalPath

    $identityPath = Join-Path $env:USERPROFILE '.ssh\digitalocean_ed25519'
    $knownHostsPath = Join-Path $env:USERPROFILE '.ssh\known_hosts'
    if (-not (Test-Path -LiteralPath $identityPath -PathType Leaf) -or
        -not (Test-Path -LiteralPath $knownHostsPath -PathType Leaf)) {
        throw 'ACCEPTED_SSH_IDENTITY_OR_KNOWN_HOSTS_MISSING'
    }
    $sshPath = (Get-Command ssh.exe -CommandType Application -ErrorAction Stop).Source
    $wgAdapter = Get-NetAdapter -Name 'SFO2-A' -ErrorAction Stop
    if ($wgAdapter.Status -ne 'Up') { throw 'WIREGUARD_CONTROL_ADAPTER_NOT_UP' }
    $route = @(Find-NetRoute -RemoteIPAddress '10.66.21.1' -ErrorAction Stop |
        Where-Object {
            $_.PSObject.Properties.Name -contains 'DestinationPrefix' -and
            $_.PSObject.Properties.Name -contains 'InterfaceIndex'
        })
    if ($route.Count -ne 1 -or [int]$route[0].InterfaceIndex -ne [int]$wgAdapter.InterfaceIndex) {
        throw 'SSH_CONTROL_ROUTE_NOT_WIREGUARD'
    }

    $script:phase = 'SSH_READ_EXACT_SECRET_FILES'
    $script:payloadBytes = Receive-VpsRecoveryBundle `
        -SshPath $sshPath `
        -IdentityPath $identityPath `
        -KnownHostsPath $knownHostsPath
    $script:phase = 'LOCAL_VALIDATE_RECOVERY_BUNDLE'
    $bundle = $null
    try {
        $bundle = Read-RecoveryBundle $script:payloadBytes
        if ($bundle.Fingerprint -cne $expectedFingerprint) {
            throw 'RECOVERY_CERTIFICATE_FINGERPRINT_MISMATCH'
        }
        $certificateFingerprint = $bundle.Fingerprint
    }
    finally {
        Clear-RecoveryBundle $bundle
    }
    $script:phase = 'LOCAL_FINALIZATION'
    $script:localFinalizationStarted = $true
    Add-Type -AssemblyName System.Security.Cryptography.ProtectedData
    $script:protectedBytes = [Security.Cryptography.ProtectedData]::Protect(
        $script:payloadBytes,
        $null,
        [Security.Cryptography.DataProtectionScope]::CurrentUser
    )

    if (-not [IO.Directory]::Exists($projectLocalDirectory)) {
        [OwnerDpapiRepairNative]::CreateDirectoryExclusive($projectLocalDirectory)
        $script:createdProjectDirectory = $true
        Set-Acl -LiteralPath $projectLocalDirectory -AclObject (New-OwnerOnlyAcl -Directory)
        Assert-OwnerOnlyAcl $projectLocalDirectory
    }
    if (-not [IO.Directory]::Exists($recoveryDirectory)) {
        [OwnerDpapiRepairNative]::CreateDirectoryExclusive($recoveryDirectory)
        $script:createdRecoveryDirectory = $true
        Set-Acl -LiteralPath $recoveryDirectory -AclObject (New-OwnerOnlyAcl -Directory)
    }
    Assert-OwnerOnlyAcl $recoveryDirectory
    Assert-TargetAbsent $pendingPath
    Assert-TargetAbsent $finalPath

    $script:phase = 'DPAPI_CREATE_PENDING_EXCLUSIVE'
    $pendingStream = [IO.File]::Open(
        $pendingPath,
        [IO.FileMode]::CreateNew,
        [IO.FileAccess]::Write,
        [IO.FileShare]::None
    )
    $script:createdPendingFile = $true
    try {
        $pendingStream.Write($script:protectedBytes, 0, $script:protectedBytes.Length)
        $pendingStream.Flush($true)
    }
    finally {
        $pendingStream.Dispose()
    }
    Set-Acl -LiteralPath $pendingPath -AclObject (New-OwnerOnlyAcl)
    Assert-OwnerOnlyAcl $pendingPath

    $script:phase = 'DPAPI_PENDING_ROUNDTRIP'
    $script:pendingCiphertext = [IO.File]::ReadAllBytes($pendingPath)
    $script:pendingPlaintext = [Security.Cryptography.ProtectedData]::Unprotect(
        $script:pendingCiphertext,
        $null,
        [Security.Cryptography.DataProtectionScope]::CurrentUser
    )
    if (-not (Test-ByteIdentity $script:payloadBytes $script:pendingPlaintext)) {
        throw 'DPAPI_PENDING_BYTE_IDENTITY_MISMATCH'
    }
    $pendingBundle = $null
    try {
        $pendingBundle = Read-RecoveryBundle $script:pendingPlaintext
        if ($pendingBundle.Fingerprint -cne $expectedFingerprint) {
            throw 'DPAPI_PENDING_CERTIFICATE_FINGERPRINT_MISMATCH'
        }
    }
    finally {
        Clear-RecoveryBundle $pendingBundle
    }

    $script:phase = 'DPAPI_ATOMIC_PROMOTION'
    Assert-TargetAbsent $finalPath
    [IO.File]::Move($pendingPath, $finalPath)
    $script:promoted = $true
    $script:createdPendingFile = $false

    $script:phase = 'DPAPI_FINAL_FRESH_READBACK'
    if (-not (Test-Path -LiteralPath $finalPath -PathType Leaf)) {
        throw 'DPAPI_FINAL_NOT_FOUND_AFTER_PROMOTION'
    }
    $finalItem = Get-Item -LiteralPath $finalPath -Force -ErrorAction Stop
    if (($finalItem.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
        throw 'DPAPI_FINAL_REPARSE_POINT'
    }
    Assert-OwnerOnlyAcl $recoveryDirectory
    Assert-OwnerOnlyAcl $finalPath
    $script:finalCiphertext = [IO.File]::ReadAllBytes($finalPath)
    $script:finalPlaintext = [Security.Cryptography.ProtectedData]::Unprotect(
        $script:finalCiphertext,
        $null,
        [Security.Cryptography.DataProtectionScope]::CurrentUser
    )
    if (-not (Test-ByteIdentity $script:payloadBytes $script:finalPlaintext)) {
        throw 'DPAPI_FINAL_BYTE_IDENTITY_MISMATCH'
    }
    $finalBundle = $null
    try {
        $finalBundle = Read-RecoveryBundle $script:finalPlaintext
        if ($finalBundle.Fingerprint -cne $expectedFingerprint) {
            throw 'DPAPI_FINAL_CERTIFICATE_FINGERPRINT_MISMATCH'
        }
    }
    finally {
        Clear-RecoveryBundle $finalBundle
    }
    Assert-TargetAbsent $pendingPath

    $script:localFinalizationCompleted = $true
    Write-Output 'OWNER_WINDOWS_TARGET=CONFIRMED'
    Write-Output 'SSH_CONTROL_PATH=10.66.21.1'
    Write-Output 'SSH_HOST_KEY_TRUST=PASS'
    Write-Output 'SSH_NATIVE_EXIT_STATUS=PASS'
    Write-Output 'SSH_PROCESS_CLEANUP=PASS'
    Write-Output 'DPAPI_SCOPE=CurrentUser'
    Write-Output 'DPAPI_PENDING_ROUNDTRIP=PASS'
    Write-Output 'DPAPI_FINAL_EXISTS=YES'
    Write-Output "DPAPI_FINAL_BYTES=$($finalItem.Length)"
    Write-Output 'DPAPI_FINAL_OWNER_ONLY_ACL=PASS'
    Write-Output 'DPAPI_FINAL_ROUNDTRIP=PASS'
    Write-Output "CERTIFICATE_SHA256_FINGERPRINT=$certificateFingerprint"
    Write-Output 'DPAPI_PENDING_EXISTS=NO'
    Write-Output 'PLAINTEXT_FILES_CREATED=0'
    Write-Output 'SECRET_VALUES_EMITTED=0'
}
catch {
    $script:failed = $true
    $script:failureReported = $true
    $failureMessage = $_.Exception.Message
    if ($failureMessage -match '^[A-Z0-9_]{1,96}$') {
        $failureClass = $failureMessage
    }
    else {
        $failureClass = $_.Exception.GetType().Name
    }
    Write-Output "RUNNER_FAILED_PHASE=$script:phase"
    Write-Output "RUNNER_FAILURE_CLASS=$failureClass"
    Write-Output "SSH_PROCESS_STARTED=$([bool]$script:sshProcessStarted)"
    Write-Output "SSH_NATIVE_EXIT_CODE=$($script:sshExitCode)"
    Write-Output "SSH_PROCESS_CLEANUP=$(if ($script:sshCleanupFailed) { 'FAILED' } elseif ($script:sshProcessStarted) { 'PASS' } else { 'NOT_REQUIRED' })"
    Write-Output "REMOTE_TRANSFER_RESULT=$(if ($script:remoteTransferCompleted) { 'PASS' } elseif ($script:sshProcessStarted) { 'FAILED' } else { 'NOT_STARTED' })"
    Write-Output "LOCAL_FINALIZATION_RESULT=$(if ($script:localFinalizationCompleted) { 'PASS' } elseif ($script:localFinalizationStarted) { 'FAILED' } else { 'NOT_STARTED' })"
    Write-Output "FINAL_PROMOTION_RESULT=$(if ($script:promoted) { 'PROMOTED_READBACK_FAILED' } else { 'NOT_PROMOTED' })"
}
finally {
    if (-not $script:promoted -and $script:createdPendingFile) {
        try {
            if ([IO.File]::Exists($pendingPath)) { [IO.File]::Delete($pendingPath) }
        }
        catch { $script:cleanupFailed = $true; $script:failed = $true }
    }
    if (-not $script:promoted -and $script:createdRecoveryDirectory) {
        try {
            if ([IO.Directory]::Exists($recoveryDirectory) -and
                [IO.Directory]::GetFileSystemEntries($recoveryDirectory).Length -eq 0) {
                [IO.Directory]::Delete($recoveryDirectory, $false)
            }
            elseif ([IO.Directory]::Exists($recoveryDirectory)) {
                $script:cleanupFailed = $true
                $script:failed = $true
            }
        }
        catch { $script:cleanupFailed = $true; $script:failed = $true }
    }
    if (-not $script:promoted -and $script:createdProjectDirectory) {
        try {
            if ([IO.Directory]::Exists($projectLocalDirectory) -and
                [IO.Directory]::GetFileSystemEntries($projectLocalDirectory).Length -eq 0) {
                [IO.Directory]::Delete($projectLocalDirectory, $false)
            }
            elseif ([IO.Directory]::Exists($projectLocalDirectory)) {
                $script:cleanupFailed = $true
                $script:failed = $true
            }
        }
        catch { $script:cleanupFailed = $true; $script:failed = $true }
    }

    foreach ($bytes in @(
        $script:payloadBytes,
        $script:protectedBytes,
        $script:pendingCiphertext,
        $script:pendingPlaintext,
        $script:finalCiphertext,
        $script:finalPlaintext
    )) {
        if ($null -ne $bytes) {
            [Security.Cryptography.CryptographicOperations]::ZeroMemory($bytes)
        }
    }
    if ($null -ne $script:ownerIdentity) { $script:ownerIdentity.Dispose() }
}

if ($script:cleanupFailed -and -not $script:failureReported) {
    Write-Output 'RUNNER_FAILED_PHASE=CLEANUP'
    Write-Output 'RUNNER_FAILURE_CLASS=CLEANUP_FAILED'
    $script:failureReported = $true
}
if ($script:failed) {
    Write-Output "FAILURE_CLEANUP=$(if ($script:cleanupFailed) { 'FAILED' } else { 'PASS_OR_NOT_REQUIRED' })"
}
if ($script:failed) { throw 'OWNER_DPAPI_RECOVERY_REPAIR_FAILED' }
