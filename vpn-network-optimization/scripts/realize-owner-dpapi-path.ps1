[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Security.Cryptography.ProtectedData

$sourcePath = 'C:\Users\34707\AppData\Local\Packages\OpenAI.Codex_2p2nqsd0c76g0\LocalCache\Local\vpn-network-optimization\recovery\hy2-g2a.dpapi'
$localRoot = 'C:\Users\34707\AppData\Local'
$projectDirectory = Join-Path $localRoot 'vpn-network-optimization'
$recoveryDirectory = Join-Path $projectDirectory 'recovery'
$pendingPath = Join-Path $recoveryDirectory 'hy2-g2a.realize.pending.dpapi'
$targetPath = Join-Path $recoveryDirectory 'hy2-g2a.dpapi'
$acceptedFingerprint = '8A:8D:50:5F:DF:80:DB:76:C6:76:39:5A:86:E4:9D:81:8E:A1:5B:76:64:ED:70:30:8C:29:60:9C:23:74:1F:18'

$phase = 'PRECHECK'
$failureCode = $null
$succeeded = $false
$cleanupFailed = $false
$createdPending = $false
$createdTarget = $false
$ownerIdentity = $null
$ownerSid = $null
$sourceCiphertext = $null
$sourcePlaintext = $null
$pendingCiphertext = $null
$pendingPlaintext = $null
$targetCiphertext = $null
$targetPlaintext = $null
$sourceBundle = $null
$pendingBundle = $null
$targetBundle = $null

function Assert-PathNotReparsePoint {
    param([Parameter(Mandatory = $true)][string]$Path)

    $item = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
        throw 'PATH_REPARSE_POINT'
    }
    return $item
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
    $acl.SetOwner($script:ownerSid)
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

    if ($Rules.Count -eq 0) { throw 'OWNER_ACL_RULES_MISSING' }
    $directRights = [long]0
    $containerRights = [long]0
    $objectRights = [long]0
    foreach ($rule in $Rules) {
        if ($rule.IsInherited) { throw 'OWNER_ACL_INHERITED_RULE_PRESENT' }
        $ruleSid = if ($rule.IdentityReference -is [Security.Principal.SecurityIdentifier]) {
            $rule.IdentityReference.Value
        }
        else {
            $rule.IdentityReference.Translate([Security.Principal.SecurityIdentifier]).Value
        }
        if ($ruleSid -ne $script:ownerSid.Value) { throw 'OWNER_ACL_ALLOWLIST_INVALID' }
        if ($rule.AccessControlType -ne [Security.AccessControl.AccessControlType]::Allow) {
            throw 'OWNER_ACL_DENY_RULE_PRESENT'
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
            throw 'OWNER_ACL_FILE_INHERITANCE_FLAGS_INVALID'
        }
    }

    $fullControl = [long][Security.AccessControl.FileSystemRights]::FullControl
    if (($directRights -band $fullControl) -ne $fullControl) {
        throw 'OWNER_ACL_OWNER_FULLCONTROL_MISSING'
    }
    if ($Directory -and
        ((($containerRights -band $fullControl) -ne $fullControl) -or
         (($objectRights -band $fullControl) -ne $fullControl))) {
        throw 'OWNER_ACL_CHILD_FULLCONTROL_INHERITANCE_MISSING'
    }
}

function Assert-OwnerOnlyAcl {
    param([Parameter(Mandatory = $true)][string]$Path)

    $item = Assert-PathNotReparsePoint -Path $Path
    $acl = Get-Acl -LiteralPath $Path -ErrorAction Stop
    if (-not $acl.AreAccessRulesProtected) { throw 'OWNER_ACL_INHERITANCE_ENABLED' }
    $actualOwner = ([Security.Principal.NTAccount]::new($acl.Owner)).Translate(
        [Security.Principal.SecurityIdentifier]
    ).Value
    if ($actualOwner -ne $script:ownerSid.Value) { throw 'OWNER_ACL_OWNER_MISMATCH' }
    $rules = @($acl.GetAccessRules(
        $true,
        $true,
        [Security.Principal.SecurityIdentifier]
    ))
    Assert-OwnerOnlyAclRules -Rules $rules -Directory:$item.PSIsContainer
}

function Assert-PathAbsent {
    param([Parameter(Mandatory = $true)][string]$Path)

    if ([IO.File]::Exists($Path) -or [IO.Directory]::Exists($Path)) {
        throw 'TARGET_PATH_ALREADY_EXISTS'
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

function Clear-ByteArray {
    param([AllowNull()][byte[]]$Bytes)

    if ($null -ne $Bytes) {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($Bytes)
    }
}

function Assert-RecoveryPayload {
    param([Parameter(Mandatory = $true)][byte[]]$Bytes)

    $bundle = $null
    $certificate = $null
    try {
        $bundle = Read-RecoveryBundle -Bytes $Bytes
        if ($bundle.Files.Count -ne 3 -or $bundle.Fingerprint -cne $acceptedFingerprint) {
            throw 'RECOVERY_BUNDLE_ALLOWLIST_OR_FINGERPRINT_INVALID'
        }
        $certificate = [Security.Cryptography.X509Certificates.X509Certificate2]::new(
            [byte[]]$bundle.Files['server.crt']
        )
        $now = [DateTime]::UtcNow
        if ($certificate.NotBefore.ToUniversalTime() -gt $now -or
            $certificate.NotAfter.ToUniversalTime() -lt $now) {
            throw 'RECOVERY_CERTIFICATE_NOT_CURRENTLY_VALID'
        }
        return $bundle.Fingerprint
    }
    finally {
        if ($null -ne $bundle) { Clear-RecoveryBundle -Bundle $bundle }
        if ($null -ne $certificate) { $certificate.Dispose() }
    }
}

try {
    if ($PSVersionTable.PSVersion -ne [version]'7.6.6') { throw 'POWERSHELL_7_6_6_REQUIRED' }
    $ownerIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $ownerSid = $ownerIdentity.User
    if ($null -eq $ownerSid) { throw 'OWNER_SID_UNAVAILABLE' }
    $principal = [Security.Principal.WindowsPrincipal]::new($ownerIdentity)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw 'ADMINISTRATOR_TOKEN_REQUIRED'
    }
    if (-not ('OwnerDpapiPathIntegrityNative' -as [type])) {
        Add-Type -TypeDefinition @'
using System;
using System.ComponentModel;
using System.Runtime.InteropServices;

public static class OwnerDpapiPathIntegrityNative {
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
        if (tokenHandle == IntPtr.Zero) throw new ArgumentException("TOKEN_HANDLE_INVALID");
        int requiredLength = 0;
        GetTokenInformation(tokenHandle, TokenIntegrityLevel, IntPtr.Zero, 0, out requiredLength);
        if (requiredLength < IntPtr.Size) throw new Win32Exception(Marshal.GetLastWin32Error());

        IntPtr buffer = Marshal.AllocHGlobal(requiredLength);
        try {
            if (!GetTokenInformation(tokenHandle, TokenIntegrityLevel, buffer,
                                     requiredLength, out requiredLength)) {
                throw new Win32Exception(Marshal.GetLastWin32Error());
            }

            IntPtr sid = Marshal.ReadIntPtr(buffer);
            if (sid == IntPtr.Zero || !IsValidSid(sid))
                throw new InvalidOperationException("TOKEN_INTEGRITY_SID_INVALID");

            IntPtr countPointer = GetSidSubAuthorityCount(sid);
            if (countPointer == IntPtr.Zero)
                throw new InvalidOperationException("TOKEN_INTEGRITY_SID_INVALID");
            byte count = Marshal.ReadByte(countPointer);
            if (count == 0)
                throw new InvalidOperationException("TOKEN_INTEGRITY_SID_INVALID");

            IntPtr ridPointer = GetSidSubAuthority(sid, (uint)(count - 1));
            if (ridPointer == IntPtr.Zero)
                throw new InvalidOperationException("TOKEN_INTEGRITY_SID_INVALID");
            return Marshal.ReadInt32(ridPointer);
        }
        finally {
            Marshal.FreeHGlobal(buffer);
        }
    }
}
'@ -ErrorAction Stop
    }
    $integrityRid = [OwnerDpapiPathIntegrityNative]::GetIntegrityRid($ownerIdentity.Token)
    if ($integrityRid -lt 12288) {
        throw 'HIGH_INTEGRITY_TOKEN_REQUIRED'
    }
    if (-not [string]::Equals(
            $env:LOCALAPPDATA.TrimEnd('\'),
            $localRoot,
            [StringComparison]::OrdinalIgnoreCase
        )) {
        throw 'OWNER_WINDOWS_TARGET_MISMATCH'
    }

    $phase = 'PRECHECK_PATHS'
    if ([IO.File]::Exists($projectDirectory)) { throw 'PROJECT_PATH_NOT_DIRECTORY' }
    if ([IO.Directory]::Exists($projectDirectory)) { Assert-OwnerOnlyAcl -Path $projectDirectory }
    if ([IO.File]::Exists($recoveryDirectory)) { throw 'RECOVERY_PATH_NOT_DIRECTORY' }
    if ([IO.Directory]::Exists($recoveryDirectory)) { Assert-OwnerOnlyAcl -Path $recoveryDirectory }
    Assert-PathAbsent -Path $pendingPath
    Assert-PathAbsent -Path $targetPath

    $phase = 'LOAD_CANONICAL_PARSER'
    $parserPath = Join-Path $PSScriptRoot 'repair-owner-dpapi-recovery.ps1'
    $parserText = [IO.File]::ReadAllText($parserPath)
    $tokens = $null
    $parseErrors = $null
    $parserAst = [Management.Automation.Language.Parser]::ParseInput(
        $parserText,
        [ref]$tokens,
        [ref]$parseErrors
    )
    if ($parseErrors.Count -ne 0) { throw 'CANONICAL_PARSER_SYNTAX_INVALID' }
    foreach ($functionName in @('Read-ExactBytes', 'Read-RecoveryBundle', 'Clear-RecoveryBundle')) {
        $definitions = @($parserAst.FindAll({
            param($node)
            $node -is [Management.Automation.Language.FunctionDefinitionAst] -and
                $node.Name -ceq $functionName
        }, $true))
        if ($definitions.Count -ne 1) { throw 'CANONICAL_PARSER_FUNCTION_INVALID' }
        $helperBlock = [scriptblock]::Create($definitions[0].Extent.Text)
        . $helperBlock
    }

    $phase = 'VALIDATE_SOURCE'
    if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) { throw 'SOURCE_ARTIFACT_MISSING' }
    $sourceItem = Assert-PathNotReparsePoint -Path $sourcePath
    if ($sourceItem.Length -ne 1206) { throw 'SOURCE_ARTIFACT_LENGTH_INVALID' }
    Assert-OwnerOnlyAcl -Path $sourcePath
    $sourceCiphertext = [IO.File]::ReadAllBytes($sourcePath)
    $sourcePlaintext = [Security.Cryptography.ProtectedData]::Unprotect(
        $sourceCiphertext,
        $null,
        [Security.Cryptography.DataProtectionScope]::CurrentUser
    )
    $sourceBundle = Read-RecoveryBundle -Bytes $sourcePlaintext
    if ($sourceBundle.Fingerprint -cne $acceptedFingerprint) {
        throw 'SOURCE_CERTIFICATE_FINGERPRINT_MISMATCH'
    }
    [void](Assert-RecoveryPayload -Bytes $sourcePlaintext)
    Clear-RecoveryBundle -Bundle $sourceBundle
    $sourceBundle = $null

    if (-not ('OwnerDpapiPathRealizationNative' -as [type])) {
        Add-Type -TypeDefinition @'
using System;
using System.ComponentModel;
using System.Runtime.InteropServices;
public static class OwnerDpapiPathRealizationNative {
    [DllImport("kernel32.dll", CharSet=CharSet.Unicode, SetLastError=true)]
    private static extern bool CreateDirectoryW(string path, IntPtr securityAttributes);
    public static void CreateDirectoryExclusive(string path) {
        if (!CreateDirectoryW(path, IntPtr.Zero))
            throw new Win32Exception(Marshal.GetLastWin32Error());
    }
}
'@ -ErrorAction Stop
    }

    $phase = 'CREATE_OWNER_ONLY_DIRECTORIES'
    if (-not [IO.Directory]::Exists($projectDirectory)) {
        [OwnerDpapiPathRealizationNative]::CreateDirectoryExclusive($projectDirectory)
        Set-Acl -LiteralPath $projectDirectory -AclObject (New-OwnerOnlyAcl -Directory)
        Assert-OwnerOnlyAcl -Path $projectDirectory
    }
    if (-not [IO.Directory]::Exists($recoveryDirectory)) {
        [OwnerDpapiPathRealizationNative]::CreateDirectoryExclusive($recoveryDirectory)
        Set-Acl -LiteralPath $recoveryDirectory -AclObject (New-OwnerOnlyAcl -Directory)
        Assert-OwnerOnlyAcl -Path $recoveryDirectory
    }
    Assert-OwnerOnlyAcl -Path $projectDirectory
    Assert-OwnerOnlyAcl -Path $recoveryDirectory

    $phase = 'CREATE_PENDING_EXCLUSIVE'
    Assert-PathAbsent -Path $pendingPath
    Assert-PathAbsent -Path $targetPath
    $pendingStream = [IO.File]::Open(
        $pendingPath,
        [IO.FileMode]::CreateNew,
        [IO.FileAccess]::Write,
        [IO.FileShare]::None
    )
    $createdPending = $true
    try {
        $pendingStream.Write($sourceCiphertext, 0, $sourceCiphertext.Length)
        $pendingStream.Flush($true)
    }
    finally {
        $pendingStream.Dispose()
    }
    Set-Acl -LiteralPath $pendingPath -AclObject (New-OwnerOnlyAcl)
    Assert-OwnerOnlyAcl -Path $pendingPath

    $phase = 'VERIFY_PENDING'
    $pendingCiphertext = [IO.File]::ReadAllBytes($pendingPath)
    if (-not (Test-ByteIdentity -Expected $sourceCiphertext -Actual $pendingCiphertext)) {
        throw 'PENDING_CIPHERTEXT_MISMATCH'
    }
    $pendingPlaintext = [Security.Cryptography.ProtectedData]::Unprotect(
        $pendingCiphertext,
        $null,
        [Security.Cryptography.DataProtectionScope]::CurrentUser
    )
    if (-not (Test-ByteIdentity -Expected $sourcePlaintext -Actual $pendingPlaintext)) {
        throw 'PENDING_PLAINTEXT_MISMATCH'
    }
    $pendingBundle = Read-RecoveryBundle -Bytes $pendingPlaintext
    if ($pendingBundle.Fingerprint -cne $acceptedFingerprint) {
        throw 'PENDING_CERTIFICATE_FINGERPRINT_MISMATCH'
    }
    [void](Assert-RecoveryPayload -Bytes $pendingPlaintext)
    Clear-RecoveryBundle -Bundle $pendingBundle
    $pendingBundle = $null

    $phase = 'ATOMIC_PROMOTION'
    Assert-PathAbsent -Path $targetPath
    [IO.File]::Move($pendingPath, $targetPath)
    $createdPending = $false
    $createdTarget = $true

    $phase = 'FRESH_TARGET_READBACK'
    if (-not (Test-Path -LiteralPath $targetPath -PathType Leaf)) {
        throw 'TARGET_ARTIFACT_NOT_FOUND'
    }
    $targetItem = Assert-PathNotReparsePoint -Path $targetPath
    if ($targetItem.Length -ne $sourceItem.Length) { throw 'TARGET_ARTIFACT_LENGTH_MISMATCH' }
    Assert-OwnerOnlyAcl -Path $projectDirectory
    Assert-OwnerOnlyAcl -Path $recoveryDirectory
    Assert-OwnerOnlyAcl -Path $targetPath
    $targetCiphertext = [IO.File]::ReadAllBytes($targetPath)
    if (-not (Test-ByteIdentity -Expected $sourceCiphertext -Actual $targetCiphertext)) {
        throw 'TARGET_CIPHERTEXT_MISMATCH'
    }
    $targetPlaintext = [Security.Cryptography.ProtectedData]::Unprotect(
        $targetCiphertext,
        $null,
        [Security.Cryptography.DataProtectionScope]::CurrentUser
    )
    if (-not (Test-ByteIdentity -Expected $sourcePlaintext -Actual $targetPlaintext) -or
        -not (Test-ByteIdentity -Expected $pendingPlaintext -Actual $targetPlaintext)) {
        throw 'TARGET_PLAINTEXT_MISMATCH'
    }
    $targetBundle = Read-RecoveryBundle -Bytes $targetPlaintext
    if ($targetBundle.Fingerprint -cne $acceptedFingerprint) {
        throw 'TARGET_CERTIFICATE_FINGERPRINT_MISMATCH'
    }
    [void](Assert-RecoveryPayload -Bytes $targetPlaintext)
    Clear-RecoveryBundle -Bundle $targetBundle
    $targetBundle = $null

    $sourceReadback = [IO.File]::ReadAllBytes($sourcePath)
    try {
        if (-not (Test-ByteIdentity -Expected $sourceCiphertext -Actual $sourceReadback)) {
            throw 'SOURCE_ARTIFACT_CHANGED'
        }
    }
    finally {
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($sourceReadback)
    }
    if ([IO.File]::Exists($pendingPath)) { throw 'PENDING_ARTIFACT_REMAINS' }
    $succeeded = $true
}
catch {
    $message = $_.Exception.Message
    $failureCode = if ($message -match '^[A-Z0-9_]{1,96}$') {
        $message
    }
    else {
        $_.Exception.GetType().Name
    }
}
finally {
    if (-not $succeeded) {
        if ($createdPending -and [IO.File]::Exists($pendingPath)) {
            try { [IO.File]::Delete($pendingPath) } catch { $cleanupFailed = $true }
        }
        if ($createdTarget -and [IO.File]::Exists($targetPath)) {
            try { [IO.File]::Delete($targetPath) } catch { $cleanupFailed = $true }
        }
    }
    Clear-ByteArray -Bytes $sourceCiphertext
    Clear-ByteArray -Bytes $sourcePlaintext
    Clear-ByteArray -Bytes $pendingCiphertext
    Clear-ByteArray -Bytes $pendingPlaintext
    Clear-ByteArray -Bytes $targetCiphertext
    Clear-ByteArray -Bytes $targetPlaintext
    foreach ($bundle in @($sourceBundle, $pendingBundle, $targetBundle)) {
        if ($null -ne $bundle) {
            try { Clear-RecoveryBundle -Bundle $bundle } catch { $cleanupFailed = $true }
        }
    }
    if ($null -ne $ownerIdentity) { $ownerIdentity.Dispose() }
}

if ($succeeded -and -not $cleanupFailed) {
    Write-Output 'OWNER_WINDOWS_TARGET=CONFIRMED'
    Write-Output 'DPAPI_SCOPE=CurrentUser'
    Write-Output 'SOURCE_RETAINED=YES'
    Write-Output 'SOURCE_TARGET_ENCRYPTED_BYTES=BYTE_IDENTICAL'
    Write-Output 'TARGET_OWNER_ONLY_ACL=PASS'
    Write-Output 'TARGET_DPAPI_ROUNDTRIP=PASS'
    Write-Output 'TARGET_VPNHY2R1_VALIDATION=PASS'
    Write-Output 'PENDING_EXISTS=NO'
    Write-Output 'PLAINTEXT_TEMP_FILES_CREATED=0'
    Write-Output 'SECRET_VALUES_EMITTED=0'
    Write-Output "CERTIFICATE_SHA256_FINGERPRINT=$acceptedFingerprint"
}
else {
    Write-Output "RUNNER_FAILED_PHASE=$phase"
    Write-Output "RUNNER_FAILURE_CLASS=$(if ($cleanupFailed) { 'FAILURE_CLEANUP_FAILED' } elseif ($failureCode) { $failureCode } else { 'UNKNOWN_FAILURE' })"
    Write-Output "PENDING_EXISTS=$(if ([IO.File]::Exists($pendingPath)) { 'YES' } else { 'NO' })"
    Write-Output "TARGET_EXISTS=$(if ([IO.File]::Exists($targetPath)) { 'YES' } else { 'NO' })"
}
