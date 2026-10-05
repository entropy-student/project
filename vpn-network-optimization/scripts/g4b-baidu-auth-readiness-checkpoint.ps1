[CmdletBinding()]
param(
    [string]$ExpectedBaiduUid,
    [string]$BaiduCliArchivePath,
    [string]$BaiduConfigDirectory = (Join-Path $env:APPDATA 'BaiduPCS-Go')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:archiveUrl = 'https://github.com/qjfoidnh/BaiduPCS-Go/releases/download/v4.0.2/BaiduPCS-Go-v4.0.2-windows-x64.zip'
$script:archiveSha256 = 'ce72b3155a710b7c4a2b15611c3aebd11a057d7cccf0529e7703bdde04f0aa30'
$script:projectRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$script:ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
$script:runtimeDirectory = $null
$script:archivePath = $null
$script:downloadedArchive = $false
$script:binaryPath = $null
$script:result = 'FAIL_CLOSED'
$script:failureCode = 'CHECKPOINT_FAILED'
$script:loginReady = 'NO'
$script:accountMatch = 'NOT_CHECKED'
$script:cleanup = 'NOT_REQUIRED'

function Assert-R6 {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
}

function Test-PathWithin {
    param([string]$Path, [string]$Parent)
    $relative = [IO.Path]::GetRelativePath([IO.Path]::GetFullPath($Parent), [IO.Path]::GetFullPath($Path))
    return ($relative -ceq '.' -or (-not [IO.Path]::IsPathRooted($relative) -and $relative -notmatch '^\.\.(?:[\\/]|$)'))
}

function New-OwnerOnlyAcl {
    param([Security.Principal.SecurityIdentifier]$OwnerSid, [switch]$Directory)
    if ($Directory) {
        $acl = [Security.AccessControl.DirectorySecurity]::new()
        $inheritance = [Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [Security.AccessControl.InheritanceFlags]::ObjectInherit
    } else {
        $acl = [Security.AccessControl.FileSecurity]::new()
        $inheritance = [Security.AccessControl.InheritanceFlags]::None
    }
    $acl.SetAccessRuleProtection($true, $false)
    $acl.SetOwner($OwnerSid)
    $rule = [Security.AccessControl.FileSystemAccessRule]::new($OwnerSid, [Security.AccessControl.FileSystemRights]::FullControl, $inheritance, [Security.AccessControl.PropagationFlags]::None, [Security.AccessControl.AccessControlType]::Allow)
    [void]$acl.AddAccessRule($rule)
    return $acl
}

function Set-OwnerOnlyAcl {
    param([string]$Path, [Security.Principal.SecurityIdentifier]$OwnerSid, [switch]$Directory)
    Set-Acl -LiteralPath $Path -AclObject (New-OwnerOnlyAcl -OwnerSid $OwnerSid -Directory:$Directory) -ErrorAction Stop
}

function Assert-OwnerOnlyAcl {
    param([string]$Path, [Security.Principal.SecurityIdentifier]$OwnerSid)
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    Assert-R6 (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'OWNER_RUNTIME_REPARSE_POINT'
    $acl = Get-Acl -LiteralPath $Path -ErrorAction Stop
    Assert-R6 $acl.AreAccessRulesProtected 'OWNER_RUNTIME_ACL_INHERITANCE_ENABLED'
    Assert-R6 ($acl.GetOwner([Security.Principal.SecurityIdentifier]).Value -ceq $OwnerSid.Value) 'OWNER_RUNTIME_ACL_OWNER_MISMATCH'
    $rules = @($acl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier]))
    $direct = [long]0
    foreach ($rule in $rules) {
        Assert-R6 (-not $rule.IsInherited -and $rule.IdentityReference.Value -ceq $OwnerSid.Value) 'OWNER_RUNTIME_ACL_UNAUTHORIZED_RULE'
        Assert-R6 ($rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow) 'OWNER_RUNTIME_ACL_DENY_RULE'
        if (($rule.PropagationFlags -band [Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0) { $direct = $direct -bor [long]$rule.FileSystemRights }
    }
    $full = [long][Security.AccessControl.FileSystemRights]::FullControl
    Assert-R6 (($direct -band $full) -eq $full) 'OWNER_RUNTIME_ACL_FULLCONTROL_MISSING'
}

function Assert-BaiduConfigAclMetadata {
    param([string]$ActualOwnerSid, [Security.Principal.SecurityIdentifier]$ExpectedOwnerSid, [object[]]$Rules, [bool]$IsDirectory)
    Assert-R6 ($ActualOwnerSid -ceq $ExpectedOwnerSid.Value) 'BAIDU_AUTH_CONFIG_OWNER_MISMATCH'
    $allowedSids = @($ExpectedOwnerSid.Value, 'S-1-5-18', 'S-1-5-32-544')
    $ownerDirectRights = [long]0
    $ownerInheritedRights = [long]0
    foreach ($rule in $Rules) {
        Assert-R6 ($null -ne $rule) 'BAIDU_AUTH_CONFIG_ACE_SHAPE_INVALID'
        $identityProperty = $rule.PSObject.Properties['IdentityReference']
        $typeProperty = $rule.PSObject.Properties['AccessControlType']
        $inheritedProperty = $rule.PSObject.Properties['IsInherited']
        $rightsProperty = $rule.PSObject.Properties['FileSystemRights']
        $propagationProperty = $rule.PSObject.Properties['PropagationFlags']
        Assert-R6 ($null -ne $identityProperty -and $null -ne $identityProperty.Value -and $null -ne $typeProperty -and $null -ne $inheritedProperty -and $null -ne $rightsProperty -and $null -ne $propagationProperty) 'BAIDU_AUTH_CONFIG_ACE_SHAPE_INVALID'
        $sidProperty = $identityProperty.Value.PSObject.Properties['Value']
        Assert-R6 ($identityProperty.Value -is [Security.Principal.SecurityIdentifier] -and $null -ne $sidProperty -and -not [string]::IsNullOrWhiteSpace([string]$sidProperty.Value) -and $inheritedProperty.Value -is [bool] -and $typeProperty.Value -is [Security.AccessControl.AccessControlType] -and $rightsProperty.Value -is [Security.AccessControl.FileSystemRights] -and $propagationProperty.Value -is [Security.AccessControl.PropagationFlags]) 'BAIDU_AUTH_CONFIG_ACE_SHAPE_INVALID'
        $ruleSid = [string]$sidProperty.Value
        $isInherited = [bool]$inheritedProperty.Value
        if ($typeProperty.Value -eq [Security.AccessControl.AccessControlType]::Deny) { throw 'BAIDU_AUTH_CONFIG_DENY_ACE' }
        Assert-R6 ($typeProperty.Value -eq [Security.AccessControl.AccessControlType]::Allow) 'BAIDU_AUTH_CONFIG_ACE_SHAPE_INVALID'
        Assert-R6 ($ruleSid -in $allowedSids) 'BAIDU_AUTH_CONFIG_UNAUTHORIZED_ALLOW'
        if ($ruleSid -ceq $ExpectedOwnerSid.Value -and (([long]$propagationProperty.Value -band [long][Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0)) {
            if ($isInherited) {
                $ownerInheritedRights = $ownerInheritedRights -bor [long]$rightsProperty.Value
            } else {
                $ownerDirectRights = $ownerDirectRights -bor [long]$rightsProperty.Value
            }
        }
    }
    if ($IsDirectory) {
        $requiredReadRights = [long]([Security.AccessControl.FileSystemRights]::ListDirectory -bor [Security.AccessControl.FileSystemRights]::ExecuteFile -bor [Security.AccessControl.FileSystemRights]::ReadAttributes -bor [Security.AccessControl.FileSystemRights]::ReadExtendedAttributes -bor [Security.AccessControl.FileSystemRights]::ReadPermissions)
    } else {
        $requiredReadRights = [long]([Security.AccessControl.FileSystemRights]::ReadData -bor [Security.AccessControl.FileSystemRights]::ReadAttributes -bor [Security.AccessControl.FileSystemRights]::ReadExtendedAttributes -bor [Security.AccessControl.FileSystemRights]::ReadPermissions)
    }
    $effectiveOwnerRights = $ownerDirectRights -bor $ownerInheritedRights
    Assert-R6 (($effectiveOwnerRights -band $requiredReadRights) -eq $requiredReadRights) 'BAIDU_AUTH_CONFIG_OWNER_READ_RIGHTS_MISSING'
}

function Resolve-SafeBaiduConfigPath {
    param([string]$ConfigDirectory, [string]$ProjectRoot)
    Assert-R6 (-not [string]::IsNullOrWhiteSpace($ConfigDirectory)) 'BAIDU_CONFIG_PATH_INVALID'
    $config = [IO.Path]::GetFullPath($ConfigDirectory)
    Assert-R6 (-not $config.StartsWith('\\', [StringComparison]::OrdinalIgnoreCase)) 'BAIDU_CONFIG_NETWORK_PATH_FORBIDDEN'
    Assert-R6 (-not (Test-PathWithin -Path $config -Parent $ProjectRoot)) 'BAIDU_CONFIG_INSIDE_REPOSITORY'
    return $config
}

function Resolve-BaiduConfigPresence {
    param([bool]$PathExists, [bool]$IsDirectory)
    if (-not $PathExists) { return [pscustomobject]@{ State = 'OWNER_ACTION_REQUIRED'; Code = 'RETURN_OWNER_ACTION_REQUIRED' } }
    if (-not $IsDirectory) { return [pscustomobject]@{ State = 'FAIL_CLOSED'; Code = 'BAIDU_AUTH_CONFIG_NOT_DIRECTORY' } }
    return [pscustomobject]@{ State = 'INSPECT'; Code = 'NONE' }
}

function Assert-SafeBaiduConfigDirectory {
    param([string]$ConfigDirectory, [string]$ProjectRoot, [Security.Principal.SecurityIdentifier]$OwnerSid)
    $config = Resolve-SafeBaiduConfigPath -ConfigDirectory $ConfigDirectory -ProjectRoot $ProjectRoot
    Assert-R6 (Test-Path -LiteralPath $config -PathType Container) 'BAIDU_AUTH_CONFIG_NOT_DIRECTORY'
    $items = [Collections.Generic.List[IO.FileSystemInfo]]::new()
    $rootItem = Get-Item -LiteralPath $config -Force -ErrorAction Stop
    $items.Add($rootItem)
    foreach ($child in @(Get-ChildItem -LiteralPath $config -Force -Recurse -ErrorAction Stop)) { $items.Add($child) }
    Assert-R6 ($items.Count -le 4096) 'BAIDU_CONFIG_ENTRY_LIMIT_EXCEEDED'
    foreach ($item in $items) {
        Assert-R6 (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'BAIDU_AUTH_CONFIG_REPARSE_POINT'
        $acl = Get-Acl -LiteralPath $item.FullName -ErrorAction Stop
        $actualOwnerSid = $acl.GetOwner([Security.Principal.SecurityIdentifier]).Value
        $rules = @($acl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier]))
        Assert-BaiduConfigAclMetadata -ActualOwnerSid $actualOwnerSid -ExpectedOwnerSid $OwnerSid -Rules $rules -IsDirectory ([bool]$item.PSIsContainer)
    }
}

function Assert-PinnedArchiveDigest {
    param([string]$ActualSha256)
    Assert-R6 ($ActualSha256 -ceq $script:archiveSha256) 'BAIDU_CLI_ARCHIVE_HASH_INVALID'
}

function Get-PinnedBaiduExecutableBytes {
    param([string]$Archive)
    $item = Get-Item -LiteralPath $Archive -Force -ErrorAction Stop
    Assert-R6 (-not ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) 'BAIDU_CLI_ARCHIVE_REPARSE_POINT'
    Assert-R6 ($item.Length -gt 0 -and $item.Length -le 100MB) 'BAIDU_CLI_ARCHIVE_SIZE_INVALID'
    $actualHash = (Get-FileHash -LiteralPath $Archive -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant()
    Assert-PinnedArchiveDigest -ActualSha256 $actualHash
    Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop
    $zip = $null
    $entryStream = $null
    $memory = $null
    try {
        $zip = [IO.Compression.ZipFile]::OpenRead($Archive)
        $entries = @($zip.Entries | Where-Object { [IO.Path]::GetFileName($_.FullName) -ceq 'BaiduPCS-Go.exe' })
        Assert-R6 ($entries.Count -eq 1) 'BAIDU_CLI_ARCHIVE_ENTRY_INVALID'
        $entry = $entries[0]
        Assert-R6 ($entry.Length -gt 0 -and $entry.Length -le 64MB) 'BAIDU_CLI_ARCHIVE_ENTRY_SIZE_INVALID'
        Assert-R6 ($entry.FullName -notmatch '(^|[/\\])\.\.([/\\]|$)' -and -not [IO.Path]::IsPathRooted($entry.FullName)) 'BAIDU_CLI_ARCHIVE_ENTRY_TRAVERSAL'
        $entryStream = $entry.Open()
        $memory = [IO.MemoryStream]::new()
        $entryStream.CopyTo($memory)
        $bytes = $memory.ToArray()
        Assert-R6 ($bytes.Length -eq $entry.Length) 'BAIDU_CLI_EXTRACT_LENGTH_INVALID'
        return ,$bytes
    } finally {
        if ($null -ne $memory) { $memory.Dispose() }
        if ($null -ne $entryStream) { $entryStream.Dispose() }
        if ($null -ne $zip) { $zip.Dispose() }
    }
}

function Write-OwnerOnlyBinary {
    param([string]$Path, [byte[]]$Bytes, [Security.Principal.SecurityIdentifier]$OwnerSid)
    Assert-R6 (-not (Test-Path -LiteralPath $Path)) 'OWNER_RUNTIME_FILE_COLLISION'
    $stream = [IO.File]::Open($Path, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
    try { $stream.Write($Bytes, 0, $Bytes.Length) } finally { $stream.Dispose() }
    Set-OwnerOnlyAcl -Path $Path -OwnerSid $OwnerSid
    Assert-OwnerOnlyAcl -Path $Path -OwnerSid $OwnerSid
}

function New-ReadOnlyWhoStartInfo {
    param([string]$ExecutablePath, [string]$ConfigDirectory)
    $psi = [Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $ExecutablePath
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    [void]$psi.ArgumentList.Add('who')
    $psi.Environment.Clear()
    foreach ($name in @('SystemRoot', 'WINDIR')) {
        $value = [Environment]::GetEnvironmentVariable($name)
        if (-not [string]::IsNullOrWhiteSpace($value)) { $psi.Environment[$name] = $value }
    }
    if (-not [string]::IsNullOrWhiteSpace($env:SystemRoot)) { $psi.Environment['PATH'] = Join-Path $env:SystemRoot 'System32' }
    $psi.Environment['BAIDUPCS_GO_CONFIG_DIR'] = $ConfigDirectory
    $psi.Environment['BAIDUPCS_GO_VERBOSE'] = '0'
    return $psi
}

function Invoke-ReadOnlyBaiduWho {
    param([string]$ExecutablePath, [string]$ConfigDirectory)
    $process = [Diagnostics.Process]::new()
    $stdoutTask = $null
    $stderrTask = $null
    $stdout = $null
    $stderr = $null
    try {
        $process.StartInfo = New-ReadOnlyWhoStartInfo -ExecutablePath $ExecutablePath -ConfigDirectory $ConfigDirectory
        if (-not $process.Start()) { throw 'BAIDU_WHO_START_FAILED' }
        $stdoutTask = $process.StandardOutput.ReadToEndAsync()
        $stderrTask = $process.StandardError.ReadToEndAsync()
        if (-not $process.WaitForExit(120000)) {
            try { $process.Kill($true); [void]$process.WaitForExit(5000) } catch { }
            throw 'BAIDU_WHO_TIMEOUT'
        }
        $stdout = $stdoutTask.GetAwaiter().GetResult()
        $stderr = $stderrTask.GetAwaiter().GetResult()
        return [pscustomobject]@{ ExitCode = [int]$process.ExitCode; StdOut = [string]$stdout; StdErr = [string]$stderr }
    } catch {
        $message = [string]$_.Exception.Message
        if ($message -match '^BAIDU_WHO_[A-Z0-9_]+$') { throw $message }
        throw 'BAIDU_WHO_EXECUTION_FAILED'
    } finally {
        $stdout = $null
        $stderr = $null
        $stdoutTask = $null
        $stderrTask = $null
        $process.Dispose()
    }
}

function Resolve-BaiduWhoOutcome {
    param([int]$ExitCode, [string]$StdOut, [string]$StdErr, [string]$ExpectedUid)
    Assert-R6 ($ExpectedUid -match '^[1-9][0-9]{0,19}$') 'BAIDU_EXPECTED_ACCOUNT_ID_INVALID'
    if ($ExitCode -ne 0) { return [pscustomobject]@{ State = 'OWNER_ACTION_REQUIRED'; Code = 'RETURN_OWNER_ACTION_REQUIRED' } }
    $matches = [regex]::Matches($StdOut, '(?m)^当前帐号 uid:\s*([0-9]+),')
    if ($matches.Count -gt 1) { return [pscustomobject]@{ State = 'FAIL_CLOSED'; Code = 'BAIDU_WHO_OUTPUT_AMBIGUOUS' } }
    if ($matches.Count -eq 0) {
        if (($StdOut + [Environment]::NewLine + $StdErr) -match '(?i)\buid\b|帐号\s*uid') { return [pscustomobject]@{ State = 'FAIL_CLOSED'; Code = 'BAIDU_WHO_OUTPUT_AMBIGUOUS' } }
        return [pscustomobject]@{ State = 'OWNER_ACTION_REQUIRED'; Code = 'RETURN_OWNER_ACTION_REQUIRED' }
    }
    if ($matches[0].Groups[1].Value -cne $ExpectedUid) { return [pscustomobject]@{ State = 'FAIL_CLOSED'; Code = 'BAIDU_ACCOUNT_MISMATCH' } }
    return [pscustomobject]@{ State = 'READY'; Code = 'NONE' }
}

function Invoke-R6Checkpoint {
    $exeBytes = $null
    try {
        Assert-R6 ($ExpectedBaiduUid -match '^[1-9][0-9]{0,19}$') 'BAIDU_EXPECTED_ACCOUNT_ID_INVALID'
        $configFull = Resolve-SafeBaiduConfigPath -ConfigDirectory $BaiduConfigDirectory -ProjectRoot $script:projectRoot
        $configPresence = Resolve-BaiduConfigPresence -PathExists (Test-Path -LiteralPath $configFull) -IsDirectory (Test-Path -LiteralPath $configFull -PathType Container)
        if ($configPresence.State -ceq 'OWNER_ACTION_REQUIRED') {
            $script:result = 'RETURN_OWNER_ACTION_REQUIRED'
            $script:failureCode = $configPresence.Code
        } elseif ($configPresence.State -ceq 'FAIL_CLOSED') {
            throw $configPresence.Code
        } else {
            Assert-SafeBaiduConfigDirectory -ConfigDirectory $configFull -ProjectRoot $script:projectRoot -OwnerSid $script:ownerSid
            $localAppData = [Environment]::GetFolderPath([Environment+SpecialFolder]::LocalApplicationData)
            Assert-R6 (-not [string]::IsNullOrWhiteSpace($localAppData) -and (Test-Path -LiteralPath $localAppData -PathType Container)) 'OWNER_RUNTIME_ROOT_UNAVAILABLE'
            $runtimeName = 'vpn-network-optimization-baidu-readiness-' + [Guid]::NewGuid().ToString('N')
            $script:runtimeDirectory = Join-Path $localAppData $runtimeName
            Assert-R6 (-not (Test-Path -LiteralPath $script:runtimeDirectory)) 'OWNER_RUNTIME_COLLISION'
            [void][IO.Directory]::CreateDirectory($script:runtimeDirectory)
            Set-OwnerOnlyAcl -Path $script:runtimeDirectory -OwnerSid $script:ownerSid -Directory
            Assert-OwnerOnlyAcl -Path $script:runtimeDirectory -OwnerSid $script:ownerSid
            if ([string]::IsNullOrWhiteSpace($BaiduCliArchivePath)) {
                $script:archivePath = Join-Path $script:runtimeDirectory 'BaiduPCS-Go-v4.0.2-windows-x64.zip'
                $script:downloadedArchive = $true
                $oldProgress = $ProgressPreference
                try {
                    $ProgressPreference = 'SilentlyContinue'
                    [void](Invoke-WebRequest -Uri $script:archiveUrl -OutFile $script:archivePath -TimeoutSec 120 -ErrorAction Stop)
                } catch { throw 'BAIDU_CLI_RELEASE_DOWNLOAD_FAILED' }
                finally { $ProgressPreference = $oldProgress }
            } else {
                $script:archivePath = [IO.Path]::GetFullPath($BaiduCliArchivePath)
                Assert-R6 (-not (Test-PathWithin -Path $script:archivePath -Parent $script:projectRoot)) 'BAIDU_CLI_ARCHIVE_INSIDE_REPOSITORY'
                Assert-R6 (Test-Path -LiteralPath $script:archivePath -PathType Leaf) 'BAIDU_CLI_ARCHIVE_MISSING'
            }
            $exeBytes = Get-PinnedBaiduExecutableBytes -Archive $script:archivePath
            $script:binaryPath = Join-Path $script:runtimeDirectory 'BaiduPCS-Go.exe'
            Write-OwnerOnlyBinary -Path $script:binaryPath -Bytes $exeBytes -OwnerSid $script:ownerSid
            [Security.Cryptography.CryptographicOperations]::ZeroMemory($exeBytes)
            $exeBytes = $null
            $who = Invoke-ReadOnlyBaiduWho -ExecutablePath $script:binaryPath -ConfigDirectory $configFull
            try {
                $decision = Resolve-BaiduWhoOutcome -ExitCode $who.ExitCode -StdOut $who.StdOut -StdErr $who.StdErr -ExpectedUid $ExpectedBaiduUid
                switch ($decision.State) {
                    'READY' { $script:result = 'READY'; $script:loginReady = 'YES'; $script:accountMatch = 'YES'; $script:failureCode = 'NONE' }
                    'OWNER_ACTION_REQUIRED' { $script:result = 'RETURN_OWNER_ACTION_REQUIRED'; $script:failureCode = $decision.Code }
                    default { $script:result = 'FAIL_CLOSED'; $script:failureCode = $decision.Code }
                }
            } finally { $who = $null; $decision = $null }
        }
    } catch {
        $message = [string]$_.Exception.Message
        if ($message -match '^(?:BAIDU|OWNER)_[A-Z0-9_]+$') { $script:failureCode = $message } else { $script:failureCode = 'CHECKPOINT_FAILED' }
        $script:result = 'FAIL_CLOSED'
    } finally {
        if ($null -ne $exeBytes) { [Security.Cryptography.CryptographicOperations]::ZeroMemory($exeBytes); $exeBytes = $null }
        if ($null -ne $script:runtimeDirectory -and (Test-Path -LiteralPath $script:runtimeDirectory -PathType Container)) {
            try {
                $runtimeFull = [IO.Path]::GetFullPath($script:runtimeDirectory)
                $localAppData = [IO.Path]::GetFullPath([Environment]::GetFolderPath([Environment+SpecialFolder]::LocalApplicationData))
                Assert-R6 ((Test-PathWithin -Path $runtimeFull -Parent $localAppData) -and ([IO.Path]::GetFileName($runtimeFull) -match '^vpn-network-optimization-baidu-readiness-[0-9a-f]{32}$')) 'OWNER_RUNTIME_CLEANUP_SCOPE_INVALID'
                foreach ($path in @($script:binaryPath, $(if ($script:downloadedArchive) { $script:archivePath } else { $null }))) {
                    if ($null -ne $path -and (Test-Path -LiteralPath $path -PathType Leaf)) { Remove-Item -LiteralPath $path -Force -ErrorAction Stop }
                }
                Remove-Item -LiteralPath $script:runtimeDirectory -Force -ErrorAction Stop
                Assert-R6 (-not (Test-Path -LiteralPath $script:runtimeDirectory)) 'OWNER_RUNTIME_CLEANUP_UNVERIFIED'
                $script:cleanup = 'PASS'
            } catch {
                $script:cleanup = 'FAIL'
                $script:result = 'FAIL_CLOSED'
                $script:failureCode = 'OWNER_RUNTIME_CLEANUP_FAILED'
            }
        }
    }
    Write-Output ('BAIDU_AUTH_READINESS=' + $script:result)
    Write-Output ('BAIDU_FAILURE_CODE=' + $script:failureCode)
    Write-Output ('BAIDU_LOGIN_READY=' + $script:loginReady)
    Write-Output ('BAIDU_ACCOUNT_MATCH=' + $script:accountMatch)
    Write-Output ('BAIDU_PROVIDER_MUTATION=NO')
    Write-Output ('BAIDU_RAW_PROVIDER_OUTPUT_EMITTED=NO')
    Write-Output ('BAIDU_UID_EMITTED=NO')
    Write-Output ('BAIDU_TEMP_RUNTIME_CLEANUP=' + $script:cleanup)
}

if ($MyInvocation.InvocationName -ne '.') { Invoke-R6Checkpoint }
