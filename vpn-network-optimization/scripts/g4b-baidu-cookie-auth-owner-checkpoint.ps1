[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$AdapterPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:result = 'FAIL_CLOSED'
$script:failureCode = 'CHECKPOINT_FAILED'
$script:childExitCode = -1
$script:configDisposition = 'NOT_REQUIRED'
$script:configState = 'NOT_REACHED'
$script:adapterSha256 = '9d0fff1aec7015210ba421c67bff956bc360cc6121c8d70a226c9e0817da7367'
$script:configPath = $null
$script:ownerSid = $null
$script:configStateCaptured = $false
$script:configMutationEligible = $false
$script:configRootExistedBefore = $false
$script:configRootCreatedThisRun = $false
$script:configFileExistedBefore = $false
$script:adapterStarted = $false
$process = $null

function Assert-R2 {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
}

function Test-R2PathWithin {
    param([string]$Path, [string]$Parent)
    $relative = [IO.Path]::GetRelativePath([IO.Path]::GetFullPath($Parent), [IO.Path]::GetFullPath($Path))
    return ($relative -ceq '.' -or (-not [IO.Path]::IsPathRooted($relative) -and $relative -notmatch '^\.\.(?:[\\/]|$)'))
}

function Get-R2IntegrityRid {
    if ($null -eq ('VpnG4BR2TokenIntegrityProbe' -as [type])) {
        $source = @'
using System;
using System.ComponentModel;
using System.Globalization;
using System.Runtime.InteropServices;
using System.Security.Principal;
public static class VpnG4BR2TokenIntegrityProbe {
    private const int TokenQuery = 0x0008;
    private const int TokenIntegrityLevel = 25;
    [StructLayout(LayoutKind.Sequential)] private struct SidAndAttributes { public IntPtr Sid; public uint Attributes; }
    [DllImport("kernel32.dll")] private static extern IntPtr GetCurrentProcess();
    [DllImport("kernel32.dll", SetLastError = true)] private static extern bool CloseHandle(IntPtr handle);
    [DllImport("advapi32.dll", SetLastError = true)] private static extern bool OpenProcessToken(IntPtr process, int access, out IntPtr token);
    [DllImport("advapi32.dll", SetLastError = true)] private static extern bool GetTokenInformation(IntPtr token, int infoClass, IntPtr info, int length, out int returnLength);
    public static int GetCurrentIntegrityRid() {
        IntPtr token = IntPtr.Zero;
        IntPtr buffer = IntPtr.Zero;
        try {
            if (!OpenProcessToken(GetCurrentProcess(), TokenQuery, out token)) throw new Win32Exception(Marshal.GetLastWin32Error());
            int required;
            GetTokenInformation(token, TokenIntegrityLevel, IntPtr.Zero, 0, out required);
            if (required <= 0) throw new Win32Exception(Marshal.GetLastWin32Error());
            buffer = Marshal.AllocHGlobal(required);
            if (!GetTokenInformation(token, TokenIntegrityLevel, buffer, required, out required)) throw new Win32Exception(Marshal.GetLastWin32Error());
            var label = (SidAndAttributes)Marshal.PtrToStructure(buffer, typeof(SidAndAttributes));
            var sid = new SecurityIdentifier(label.Sid);
            var parts = sid.Value.Split('-');
            return Int32.Parse(parts[parts.Length - 1], CultureInfo.InvariantCulture);
        } finally {
            if (buffer != IntPtr.Zero) Marshal.FreeHGlobal(buffer);
            if (token != IntPtr.Zero) CloseHandle(token);
        }
    }
}
'@
        Add-Type -TypeDefinition $source -Language CSharp -ErrorAction Stop
    }
    return [int][VpnG4BR2TokenIntegrityProbe]::GetCurrentIntegrityRid()
}

function Assert-R2OwnerRuntime {
    param([version]$PowerShellVersion, [bool]$IsAdministrator, [int]$IntegrityRid)
    Assert-R2 ($PowerShellVersion -eq [version]'7.6.6') 'OWNER_POWERSHELL_RUNTIME_UNSUPPORTED'
    Assert-R2 $IsAdministrator 'OWNER_ADMINISTRATOR_REQUIRED'
    Assert-R2 ($IntegrityRid -ge 12288) 'OWNER_HIGH_INTEGRITY_REQUIRED'
}

function Test-R2PathComponentsNoReparse {
    param([string]$Path)
    $current = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    while ($null -ne $current) {
        Assert-R2 (($current.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'ADAPTER_PATH_REPARSE_POINT'
        $parent = [IO.Directory]::GetParent($current.FullName)
        if ($null -eq $parent) { break }
        $current = Get-Item -LiteralPath $parent.FullName -Force -ErrorAction Stop
    }
}

function Assert-R2AdapterBinaryPreflight {
    param(
        [string]$Path,
        [string]$ProjectRoot,
        [Security.Principal.SecurityIdentifier]$OwnerSid,
        [string]$ExpectedSha256
    )
    Assert-R2 (-not [string]::IsNullOrWhiteSpace($Path)) 'ADAPTER_PATH_INVALID'
    $fullPath = [IO.Path]::GetFullPath($Path)
    Assert-R2 (-not $fullPath.StartsWith('\\', [StringComparison]::OrdinalIgnoreCase)) 'ADAPTER_NETWORK_PATH_FORBIDDEN'
    Assert-R2 (-not (Test-R2PathWithin -Path $fullPath -Parent $ProjectRoot)) 'ADAPTER_PATH_INSIDE_PROJECT'
    Assert-R2 (Test-Path -LiteralPath $fullPath -PathType Leaf) 'ADAPTER_PATH_INVALID'
    Test-R2PathComponentsNoReparse -Path $fullPath
    Assert-OwnerOnlyAcl -Path $fullPath -OwnerSid $OwnerSid
    $actual = (Get-FileHash -LiteralPath $fullPath -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant()
    Assert-R2 ($actual -ceq $ExpectedSha256.ToLowerInvariant()) 'ADAPTER_BINARY_HASH_MISMATCH'
    return $fullPath
}

function Assert-R2PreNormalizeAclMetadata {
    param([string]$ActualOwnerSid, [Security.Principal.SecurityIdentifier]$OwnerSid, [object[]]$Rules)
    $adminSid = 'S-1-5-32-544'
    $allowedSids = @($OwnerSid.Value, 'S-1-5-18', $adminSid)
    Assert-R2 ($ActualOwnerSid -ceq $OwnerSid.Value -or $ActualOwnerSid -ceq $adminSid) 'BAIDU_CONFIG_PRENORMALIZE_OWNER_INVALID'
    foreach ($rule in $Rules) {
        Assert-R2 ($null -ne $rule -and $rule.IdentityReference -is [Security.Principal.SecurityIdentifier]) 'BAIDU_CONFIG_PRENORMALIZE_ACE_INVALID'
        if ($rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Deny) { throw 'BAIDU_CONFIG_PRENORMALIZE_DENY_ACE' }
        Assert-R2 ($rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow) 'BAIDU_CONFIG_PRENORMALIZE_ACE_INVALID'
        Assert-R2 ($rule.IdentityReference.Value -in $allowedSids) 'BAIDU_CONFIG_PRENORMALIZE_ALLOW_INVALID'
    }
}

function Get-R2ConfigMetadata {
    param([string]$ConfigPath)
    $root = Get-Item -LiteralPath $ConfigPath -Force -ErrorAction Stop
    $rootAcl = Get-Acl -LiteralPath $ConfigPath -ErrorAction Stop
    $rootRules = @($rootAcl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier]))
    $entries = [Collections.Generic.List[object]]::new()
    foreach ($child in @(Get-ChildItem -LiteralPath $ConfigPath -Force -ErrorAction Stop)) {
        $item = Get-Item -LiteralPath $child.FullName -Force -ErrorAction Stop
        $acl = Get-Acl -LiteralPath $item.FullName -ErrorAction Stop
        $rules = @($acl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier]))
        $length = [long]0
        if (-not $item.PSIsContainer) { $length = [long]$item.Length }
        $entries.Add([pscustomobject]@{
            Name = [string]$item.Name
            FullName = [string]$item.FullName
            IsDirectory = [bool]$item.PSIsContainer
            IsReparsePoint = (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)
            Length = $length
            OwnerSid = [string]$acl.GetOwner([Security.Principal.SecurityIdentifier]).Value
            Rules = $rules
        })
    }
    return [pscustomobject]@{
        Root = $root
        RootIsReparsePoint = (($root.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)
        RootOwnerSid = [string]$rootAcl.GetOwner([Security.Principal.SecurityIdentifier]).Value
        RootRules = $rootRules
        Entries = $entries.ToArray()
    }
}

function Assert-R2ExactPostAuthShape {
    param([string]$ConfigPath, [string]$ProjectRoot, [Security.Principal.SecurityIdentifier]$OwnerSid)
    $canonical = Resolve-SafeBaiduConfigPath -ConfigDirectory $ConfigPath -ProjectRoot $ProjectRoot
    Assert-R2 ($canonical -ceq [IO.Path]::GetFullPath($ConfigPath)) 'BAIDU_CONFIG_PATH_CHANGED'
    Assert-R2 (Test-Path -LiteralPath $canonical -PathType Container) 'BAIDU_CONFIG_ROOT_INVALID'
    $metadata = Get-R2ConfigMetadata -ConfigPath $canonical
    Assert-R2 (-not $metadata.RootIsReparsePoint) 'BAIDU_CONFIG_ROOT_REPARSE_POINT'
    Assert-R2 ($metadata.Entries.Count -eq 1) 'BAIDU_CONFIG_POSTAUTH_SHAPE_INVALID'
    $entry = $metadata.Entries[0]
    Assert-R2 (-not $entry.IsDirectory -and -not $entry.IsReparsePoint -and $entry.Name -ceq 'pcs_config.json') 'BAIDU_CONFIG_POSTAUTH_SHAPE_INVALID'
    Assert-R2 ($entry.Length -gt 0 -and $entry.Length -le 1048576) 'BAIDU_CONFIG_POSTAUTH_SIZE_INVALID'
    Assert-R2PreNormalizeAclMetadata -ActualOwnerSid $metadata.RootOwnerSid -OwnerSid $OwnerSid -Rules $metadata.RootRules
    Assert-R2PreNormalizeAclMetadata -ActualOwnerSid $entry.OwnerSid -OwnerSid $OwnerSid -Rules $entry.Rules
    return $entry
}

function Complete-R2PostAuthNormalization {
    param([string]$ConfigPath, [string]$ProjectRoot, [Security.Principal.SecurityIdentifier]$OwnerSid)
    $canonical = Resolve-SafeBaiduConfigPath -ConfigDirectory $ConfigPath -ProjectRoot $ProjectRoot
    $entry = Assert-R2ExactPostAuthShape -ConfigPath $canonical -ProjectRoot $ProjectRoot -OwnerSid $OwnerSid
    Set-OwnerOnlyAcl -Path $entry.FullName -OwnerSid $OwnerSid
    Set-OwnerOnlyAcl -Path $canonical -OwnerSid $OwnerSid -Directory
    Assert-OwnerOnlyAcl -Path $entry.FullName -OwnerSid $OwnerSid
    Assert-OwnerOnlyAcl -Path $canonical -OwnerSid $OwnerSid
    Assert-SafeBaiduConfigDirectory -ConfigDirectory $canonical -ProjectRoot $ProjectRoot -OwnerSid $OwnerSid
}

function Invoke-R2FailureReconciliation {
    param(
        [string]$ConfigPath,
        [Security.Principal.SecurityIdentifier]$OwnerSid,
        [bool]$RootExistedBefore,
        [bool]$RootCreatedThisRun,
        [bool]$ConfigFileExistedBefore,
        [bool]$ChildProcessStarted
    )
    if ($ConfigFileExistedBefore -or ($RootExistedBefore -and $RootCreatedThisRun) -or (-not $RootExistedBefore -and -not $RootCreatedThisRun)) {
        return 'PRESERVED_UNPROVEN_PROVENANCE'
    }
    if (-not (Test-Path -LiteralPath $ConfigPath)) { return 'ABSENT' }

    try {
        $metadata = Get-R2ConfigMetadata -ConfigPath $ConfigPath
        if (-not $metadata.Root.PSIsContainer -or $metadata.RootIsReparsePoint) { return 'PRESERVED_UNEXPECTED_STATE' }
        if ($metadata.Entries.Count -eq 0) {
            if ($RootExistedBefore) { return 'PRESERVED_PREEXISTING_EMPTY' }
            Assert-R2PreNormalizeAclMetadata -ActualOwnerSid $metadata.RootOwnerSid -OwnerSid $OwnerSid -Rules $metadata.RootRules
            Assert-OwnerOnlyAcl -Path $ConfigPath -OwnerSid $OwnerSid
            [IO.Directory]::Delete($ConfigPath, $false)
            if (Test-Path -LiteralPath $ConfigPath) { return 'PRESERVED_DELETE_UNVERIFIED' }
            return 'REMOVED_NEW_EMPTY_ROOT'
        }
        if (-not $ChildProcessStarted -or $metadata.Entries.Count -ne 1) { return 'PRESERVED_UNEXPECTED_STATE' }

        $entry = $metadata.Entries[0]
        if ($entry.IsDirectory -or $entry.IsReparsePoint -or $entry.Name -cne 'pcs_config.json' -or $entry.Length -le 0 -or $entry.Length -gt 1048576) {
            return 'PRESERVED_UNEXPECTED_STATE'
        }
        Assert-R2PreNormalizeAclMetadata -ActualOwnerSid $metadata.RootOwnerSid -OwnerSid $OwnerSid -Rules $metadata.RootRules
        Assert-R2PreNormalizeAclMetadata -ActualOwnerSid $entry.OwnerSid -OwnerSid $OwnerSid -Rules $entry.Rules
        [IO.File]::Delete($entry.FullName)
        $afterDelete = @(Get-ChildItem -LiteralPath $ConfigPath -Force -ErrorAction Stop)
        if ($afterDelete.Count -ne 0) { return 'PRESERVED_ROOT_NOT_EMPTY_AFTER_FILE_DELETE' }
        if ($RootExistedBefore) { return 'REMOVED_NEW_FILE_ROOT_PRESERVED' }

        Assert-R2PreNormalizeAclMetadata -ActualOwnerSid $metadata.RootOwnerSid -OwnerSid $OwnerSid -Rules $metadata.RootRules
        [IO.Directory]::Delete($ConfigPath, $false)
        if (Test-Path -LiteralPath $ConfigPath) { return 'PRESERVED_ROOT_DELETE_UNVERIFIED' }
        return 'REMOVED_NEW_FILE_AND_ROOT'
    } catch {
        return 'PRESERVED_UNVERIFIED_STATE'
    }
}

try {
    if ([Console]::IsInputRedirected -or [Console]::IsOutputRedirected -or [Console]::IsErrorRedirected) {
        throw 'OWNER_LIVE_CONSOLE_REQUIRED'
    }
    Assert-R2 ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'OWNER_POWERSHELL_RUNTIME_UNSUPPORTED'
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $script:ownerSid = $identity.User
    Assert-R2 ($null -ne $script:ownerSid) 'OWNER_SID_UNAVAILABLE'
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    $integrityRid = Get-R2IntegrityRid
    Assert-R2OwnerRuntime -PowerShellVersion $PSVersionTable.PSVersion -IsAdministrator ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) -IntegrityRid $integrityRid

    $projectRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
    $aclHelper = Join-Path $PSScriptRoot 'g4b-baidu-auth-readiness-checkpoint.ps1'
    Assert-R2 (Test-Path -LiteralPath $aclHelper -PathType Leaf) 'R6R1_ACL_HELPER_MISSING'
    Assert-R2 ((Get-FileHash -LiteralPath $aclHelper -Algorithm SHA256 -ErrorAction Stop).Hash -ceq 'AA28611D5C540F208A0DB40C0ED7D19E18B12180DE8437CCB54EA5A755D7F08F') 'R6R1_ACL_HELPER_DRIFT'
    . $aclHelper

    Assert-R2 (-not [string]::IsNullOrWhiteSpace($env:APPDATA)) 'OWNER_CONFIG_ROOT_UNAVAILABLE'
    $requestedConfig = Join-Path $env:APPDATA 'BaiduPCS-Go'
    $script:configPath = Resolve-SafeBaiduConfigPath -ConfigDirectory $requestedConfig -ProjectRoot $projectRoot
    $binary = Assert-R2AdapterBinaryPreflight -Path $AdapterPath -ProjectRoot $projectRoot -OwnerSid $script:ownerSid -ExpectedSha256 $script:adapterSha256

    # No canonical config root is inspected or mutated until all runtime, identity, path, ACL and binary checks pass.
    $script:configRootExistedBefore = Test-Path -LiteralPath $script:configPath
    if ($script:configRootExistedBefore) {
        $root = Get-Item -LiteralPath $script:configPath -Force -ErrorAction Stop
        Assert-R2 ($root.PSIsContainer -and (($root.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0)) 'BAIDU_CONFIG_ROOT_INVALID'
        $entries = @(Get-ChildItem -LiteralPath $script:configPath -Force -ErrorAction Stop)
        Assert-R2 ($entries.Count -eq 0) 'BAIDU_CONFIG_NOT_EMPTY'
        Assert-SafeBaiduConfigDirectory -ConfigDirectory $script:configPath -ProjectRoot $projectRoot -OwnerSid $script:ownerSid
    } else {
        Assert-R2 (-not (Test-Path -LiteralPath (Join-Path $script:configPath 'pcs_config.json'))) 'BAIDU_CONFIG_FILE_PREEXISTS'
    }
    $script:configFileExistedBefore = Test-Path -LiteralPath (Join-Path $script:configPath 'pcs_config.json')
    Assert-R2 (-not $script:configFileExistedBefore) 'BAIDU_CONFIG_FILE_PREEXISTS'
    $script:configState = if ($script:configRootExistedBefore) { 'PREEXISTING_EMPTY' } else { 'ABSENT_PREAUTH' }
    $script:configStateCaptured = $true
    $script:configMutationEligible = $true

    if (-not $script:configRootExistedBefore) {
        $directoryAcl = New-OwnerOnlyAcl -OwnerSid $script:ownerSid -Directory
        [void][System.IO.FileSystemAclExtensions]::CreateDirectory($directoryAcl, $script:configPath)
        $script:configRootCreatedThisRun = $true
        Assert-OwnerOnlyAcl -Path $script:configPath -OwnerSid $script:ownerSid
        Assert-R2 (@(Get-ChildItem -LiteralPath $script:configPath -Force -ErrorAction Stop).Count -eq 0) 'BAIDU_CONFIG_NOT_EMPTY'
    }

    $startInfo = [Diagnostics.ProcessStartInfo]::new()
    $startInfo.FileName = $binary
    $startInfo.WorkingDirectory = [IO.Path]::GetDirectoryName($binary)
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $false
    $startInfo.RedirectStandardInput = $false
    $startInfo.RedirectStandardOutput = $false
    $startInfo.RedirectStandardError = $false
    $startInfo.Environment.Clear()
    foreach ($name in @('SystemRoot', 'WINDIR', 'APPDATA')) {
        $value = [Environment]::GetEnvironmentVariable($name, [EnvironmentVariableTarget]::Process)
        if (-not [string]::IsNullOrWhiteSpace($value)) { $startInfo.Environment[$name] = $value }
    }
    $startInfo.Environment['BAIDUPCS_GO_CONFIG_DIR'] = $script:configPath

    $process = [Diagnostics.Process]::new()
    $process.StartInfo = $startInfo
    if (-not $process.Start()) { throw 'ADAPTER_START_FAILED' }
    $script:adapterStarted = $true
    $process.WaitForExit()
    $script:childExitCode = [int]$process.ExitCode
    if ($script:childExitCode -ne 0) { throw 'ADAPTER_NATIVE_EXIT_NONZERO' }

    Complete-R2PostAuthNormalization -ConfigPath $script:configPath -ProjectRoot $projectRoot -OwnerSid $script:ownerSid
    $script:result = 'SETUP_SAVED'
    $script:failureCode = 'NONE'
    $script:configDisposition = 'PRESERVED_AUTHENTICATED_CONFIG'
} catch {
    $message = [string]$_.Exception.Message
    if ($message -match '^(?:OWNER|R6R1|BAIDU|ADAPTER)_[A-Z0-9_]+$') {
        $script:failureCode = $message
    } else {
        $script:failureCode = 'CHECKPOINT_FAILED'
    }
    $script:result = 'FAIL_CLOSED'
} finally {
    if ($null -ne $process) {
        $process.Dispose()
        $process = $null
    }
    if ($script:result -ne 'SETUP_SAVED' -and $script:configStateCaptured -and $script:configMutationEligible) {
        $script:configDisposition = Invoke-R2FailureReconciliation -ConfigPath $script:configPath -OwnerSid $script:ownerSid -RootExistedBefore $script:configRootExistedBefore -RootCreatedThisRun $script:configRootCreatedThisRun -ConfigFileExistedBefore $script:configFileExistedBefore -ChildProcessStarted $script:adapterStarted
        if ($script:configDisposition -in @('PRESERVED_UNPROVEN_PROVENANCE', 'PRESERVED_UNEXPECTED_STATE', 'PRESERVED_DELETE_UNVERIFIED', 'PRESERVED_ROOT_NOT_EMPTY_AFTER_FILE_DELETE', 'PRESERVED_ROOT_DELETE_UNVERIFIED', 'PRESERVED_UNVERIFIED_STATE')) {
            if ($script:failureCode -eq 'NONE') { $script:failureCode = 'BAIDU_CONFIG_RECONCILIATION_UNVERIFIED' }
        }
    }
}

Write-Output ('BAIDU_COOKIE_AUTH_CHECKPOINT=' + $script:result)
Write-Output ('BAIDU_COOKIE_AUTH_FAILURE_CODE=' + $script:failureCode)
Write-Output ('BAIDU_COOKIE_AUTH_NATIVE_EXIT=' + $script:childExitCode)
Write-Output ('BAIDU_COOKIE_AUTH_CONFIG_STATE=' + $script:configState)
Write-Output ('BAIDU_COOKIE_AUTH_CONFIG_DISPOSITION=' + $script:configDisposition)
Write-Output 'BAIDU_COOKIE_AUTH_CONTENT_READ=NO'
Write-Output 'BAIDU_COOKIE_AUTH_WHO=NOT_RUN'
Write-Output 'BAIDU_COOKIE_AUTH_UID_EMITTED=NO'
