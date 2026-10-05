[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:interactiveAuthResult = 'FAIL_CLOSED'
$script:interactiveAuthFailure = 'BAIDU_AUTH_CHECKPOINT_NOT_RUN'
$script:interactiveAuthRuntime = $null
$script:interactiveAuthRuntimeCreated = $false
$script:interactiveAuthArchive = $null
$script:interactiveAuthBinary = $null
$script:interactiveAuthBytes = $null
$script:interactiveAuthWho = $null
$script:interactiveAuthConfigPath = $null
$script:interactiveAuthConfigCreated = $false
$script:interactiveAuthConfigSafe = $false
$script:interactiveAuthConfigState = 'NOT_CHECKED'
$script:interactiveAuthConfigDisposition = 'NOT_REQUIRED'
$script:interactiveAuthLoginExitCode = -1
$script:interactiveAuthWhoState = 'NOT_RUN'
$script:interactiveAuthUid = $null
$script:interactiveAuthRuntimeCleanup = 'NOT_REQUIRED'

function Assert-InteractiveAuth {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
}

function Resolve-InteractiveConfigState {
    param(
        [bool]$Exists,
        [bool]$IsDirectory,
        [bool]$IsReparsePoint,
        [int]$EntryCount
    )
    if ($EntryCount -lt 0) { return [pscustomobject]@{ State = 'FAIL_CLOSED'; Code = 'BAIDU_AUTH_CONFIG_METADATA_INVALID' } }
    if (-not $Exists) {
        if ($IsDirectory -or $IsReparsePoint -or $EntryCount -ne 0) { return [pscustomobject]@{ State = 'FAIL_CLOSED'; Code = 'BAIDU_AUTH_CONFIG_METADATA_INVALID' } }
        return [pscustomobject]@{ State = 'ABSENT_INITIALIZABLE'; Code = 'NONE' }
    }
    if (-not $IsDirectory) { return [pscustomobject]@{ State = 'FAIL_CLOSED'; Code = 'BAIDU_AUTH_CONFIG_NOT_DIRECTORY' } }
    if ($IsReparsePoint) { return [pscustomobject]@{ State = 'FAIL_CLOSED'; Code = 'BAIDU_AUTH_CONFIG_REPARSE_POINT' } }
    if ($EntryCount -eq 0) { return [pscustomobject]@{ State = 'EMPTY_INITIALIZABLE'; Code = 'NONE' } }
    return [pscustomobject]@{ State = 'UNKNOWN_NONEMPTY'; Code = 'BAIDU_AUTH_CONFIG_UNKNOWN_NONEMPTY' }
}

function Get-OptionalInteractiveConfigItem {
    param([string]$Path)
    try {
        return Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    } catch {
        $isExactNotFound = $_.CategoryInfo.Category -eq [System.Management.Automation.ErrorCategory]::ObjectNotFound -and
            $_.FullyQualifiedErrorId -ceq 'PathNotFound,Microsoft.PowerShell.Commands.GetItemCommand'
        if ($isExactNotFound) { return $null }
        throw 'BAIDU_AUTH_CONFIG_METADATA_QUERY_FAILED'
    }
}

function Test-DirectoryHasEntry {
    param([string]$Path)
    $enumerator = $null
    try {
        $enumerator = [IO.Directory]::EnumerateFileSystemEntries($Path).GetEnumerator()
        return [bool]$enumerator.MoveNext()
    } catch {
        throw 'BAIDU_AUTH_CONFIG_METADATA_QUERY_FAILED'
    } finally {
        if ($null -ne $enumerator -and $enumerator -is [IDisposable]) { $enumerator.Dispose() }
    }
}

function Initialize-BaiduInteractiveConfigDirectory {
    param(
        [string]$ConfigDirectory,
        [string]$ProjectRoot,
        [Security.Principal.SecurityIdentifier]$OwnerSid
    )
    $configFull = Resolve-SafeBaiduConfigPath -ConfigDirectory $ConfigDirectory -ProjectRoot $ProjectRoot
    $script:interactiveAuthConfigPath = $configFull
    Assert-InteractiveAuth ([IO.Path]::GetFileName($configFull) -ceq 'BaiduPCS-Go') 'BAIDU_AUTH_CONFIG_LOCATION_INVALID'
    $parentPath = [IO.Path]::GetDirectoryName($configFull)
    $parent = Get-Item -LiteralPath $parentPath -Force -ErrorAction Stop
    Assert-InteractiveAuth ($parent.PSIsContainer -and (($parent.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0)) 'BAIDU_AUTH_CONFIG_PARENT_INVALID'

    $item = Get-OptionalInteractiveConfigItem -Path $configFull
    $exists = $null -ne $item
    $isDirectory = $exists -and [bool]$item.PSIsContainer
    $isReparse = $exists -and (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)
    $entryCount = 0
    if ($exists -and $isDirectory -and -not $isReparse) {
        if (Test-DirectoryHasEntry -Path $configFull) { $entryCount = 1 }
    }
    $state = Resolve-InteractiveConfigState -Exists $exists -IsDirectory $isDirectory -IsReparsePoint $isReparse -EntryCount $entryCount
    $script:interactiveAuthConfigState = $state.State
    if ($state.State -ceq 'UNKNOWN_NONEMPTY' -or $state.State -ceq 'FAIL_CLOSED') { throw $state.Code }

    if ($state.State -ceq 'ABSENT_INITIALIZABLE') {
        try { [void][IO.Directory]::CreateDirectory($configFull) } catch { throw 'BAIDU_AUTH_CONFIG_CREATE_FAILED' }
        $script:interactiveAuthConfigCreated = $true
        $script:interactiveAuthConfigState = 'NEW_INITIALIZED'
    } else {
        $script:interactiveAuthConfigState = 'EXISTING_EMPTY_INITIALIZED'
    }

    Set-OwnerOnlyAcl -Path $configFull -OwnerSid $OwnerSid -Directory
    Assert-OwnerOnlyAcl -Path $configFull -OwnerSid $OwnerSid
    Assert-SafeBaiduConfigDirectory -ConfigDirectory $configFull -ProjectRoot $ProjectRoot -OwnerSid $OwnerSid
    $script:interactiveAuthConfigPath = $configFull
    $script:interactiveAuthConfigSafe = $true
    return [pscustomobject]@{ Path = $configFull; State = $script:interactiveAuthConfigState; CreatedThisRun = $script:interactiveAuthConfigCreated }
}

function New-BaiduInteractiveLoginStartInfo {
    param([string]$ExecutablePath, [string]$ConfigDirectory)
    $psi = [Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $ExecutablePath
    $psi.WorkingDirectory = [IO.Path]::GetDirectoryName($ExecutablePath)
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $false
    $psi.RedirectStandardInput = $false
    $psi.RedirectStandardOutput = $false
    $psi.RedirectStandardError = $false
    [void]$psi.ArgumentList.Add('login')
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

function Invoke-BaiduInteractiveLogin {
    param([string]$ExecutablePath, [string]$ConfigDirectory)
    $process = [Diagnostics.Process]::new()
    try {
        $process.StartInfo = New-BaiduInteractiveLoginStartInfo -ExecutablePath $ExecutablePath -ConfigDirectory $ConfigDirectory
        if (-not $process.Start()) { throw 'BAIDU_AUTH_LOGIN_START_FAILED' }
        if (-not $process.WaitForExit(600000)) {
            try { $process.Kill($true); [void]$process.WaitForExit(5000) } catch { }
            throw 'BAIDU_AUTH_LOGIN_TIMEOUT'
        }
        return [pscustomobject]@{ ExitCode = [int]$process.ExitCode }
    } catch {
        $message = [string]$_.Exception.Message
        if ($message -match '^BAIDU_AUTH_LOGIN_[A-Z0-9_]+$') { throw $message }
        throw 'BAIDU_AUTH_LOGIN_EXECUTION_FAILED'
    } finally {
        $process.Dispose()
    }
}

function Remove-BaiduInteractiveRuntime {
    param([string]$RuntimeDirectory, [string]$AllowedParent, [Security.Principal.SecurityIdentifier]$OwnerSid)
    $runtimeFull = [IO.Path]::GetFullPath($RuntimeDirectory)
    $parentFull = [IO.Path]::GetFullPath($AllowedParent)
    Assert-InteractiveAuth (([IO.Path]::GetDirectoryName($runtimeFull) -ceq $parentFull) -and ([IO.Path]::GetFileName($runtimeFull) -match '^vpn-network-optimization-baidu-interactive-auth-[0-9a-f]{32}$')) 'BAIDU_AUTH_RUNTIME_CLEANUP_SCOPE_INVALID'
    if (-not (Test-Path -LiteralPath $runtimeFull -PathType Container)) { return }
    Assert-OwnerOnlyAcl -Path $runtimeFull -OwnerSid $OwnerSid
    $children = @(Get-ChildItem -LiteralPath $runtimeFull -Force -ErrorAction Stop)
    $allowedNames = @('BaiduPCS-Go-v4.0.2-windows-x64.zip', 'BaiduPCS-Go.exe')
    foreach ($child in $children) {
        Assert-InteractiveAuth (-not $child.PSIsContainer -and (($child.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) -and $child.Name -in $allowedNames) 'BAIDU_AUTH_RUNTIME_CLEANUP_CONTENT_INVALID'
        Assert-OwnerOnlyAcl -Path $child.FullName -OwnerSid $OwnerSid
    }
    foreach ($child in $children) { Remove-Item -LiteralPath $child.FullName -Force -ErrorAction Stop }
    [IO.Directory]::Delete($runtimeFull, $false)
    Assert-InteractiveAuth (-not (Test-Path -LiteralPath $runtimeFull)) 'BAIDU_AUTH_RUNTIME_CLEANUP_UNVERIFIED'
}

function Remove-NewEmptyBaiduConfigDirectory {
    param([string]$ConfigDirectory, [Security.Principal.SecurityIdentifier]$OwnerSid)
    $item = Get-OptionalInteractiveConfigItem -Path $ConfigDirectory
    if ($null -eq $item) { return 'ALREADY_ABSENT' }
    Assert-InteractiveAuth ($item.PSIsContainer -and (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0)) 'BAIDU_AUTH_CONFIG_ROLLBACK_PATH_INVALID'
    if (Test-DirectoryHasEntry -Path $ConfigDirectory) { return 'PRESERVED_NONEMPTY' }
    Assert-OwnerOnlyAcl -Path $ConfigDirectory -OwnerSid $OwnerSid
    [IO.Directory]::Delete($ConfigDirectory, $false)
    Assert-InteractiveAuth ($null -eq (Get-OptionalInteractiveConfigItem -Path $ConfigDirectory)) 'BAIDU_AUTH_CONFIG_ROLLBACK_UNVERIFIED'
    return 'REMOVED_EMPTY_NEW'
}

function Test-BaiduInteractiveAuthReady {
    param(
        [int]$LoginExitCode,
        [bool]$ConfigSafe,
        [string]$WhoState,
        [string]$Uid,
        [string]$RuntimeCleanup
    )
    return [bool]($LoginExitCode -eq 0 -and $ConfigSafe -and $WhoState -ceq 'READY' -and $Uid -match '^[1-9][0-9]{0,19}$' -and $RuntimeCleanup -ceq 'PASS')
}

function Invoke-BaiduOwnerInteractiveAuthCheckpoint {
    $ownerSid = $null
    $localAppData = $null
    $loginOutcome = $null
    $whoOutcome = $null
    $candidateReady = $false
    try {
        $acceptedCheckpoint = Join-Path $PSScriptRoot 'g4b-baidu-auth-readiness-checkpoint.ps1'
        $acceptedUidHelper = Join-Path $PSScriptRoot 'g4b-baidu-uid-discovery-checkpoint.ps1'
        Assert-InteractiveAuth (Test-Path -LiteralPath $acceptedCheckpoint -PathType Leaf) 'BAIDU_AUTH_ACCEPTED_R6R1_SOURCE_MISSING'
        Assert-InteractiveAuth (Test-Path -LiteralPath $acceptedUidHelper -PathType Leaf) 'BAIDU_AUTH_ACCEPTED_R6R2A_SOURCE_MISSING'
        . $acceptedCheckpoint
        . $acceptedUidHelper

        $ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
        $appData = $env:APPDATA
        Assert-InteractiveAuth (-not [string]::IsNullOrWhiteSpace($appData)) 'BAIDU_AUTH_CONFIG_LOCATION_INVALID'
        $configInfo = Initialize-BaiduInteractiveConfigDirectory -ConfigDirectory (Join-Path $appData 'BaiduPCS-Go') -ProjectRoot $script:projectRoot -OwnerSid $ownerSid

        $localAppData = [Environment]::GetFolderPath([Environment+SpecialFolder]::LocalApplicationData)
        Assert-InteractiveAuth (-not [string]::IsNullOrWhiteSpace($localAppData) -and (Test-Path -LiteralPath $localAppData -PathType Container)) 'BAIDU_AUTH_RUNTIME_ROOT_UNAVAILABLE'
        $runtimeName = 'vpn-network-optimization-baidu-interactive-auth-' + [Guid]::NewGuid().ToString('N')
        $script:interactiveAuthRuntime = Join-Path $localAppData $runtimeName
        Assert-InteractiveAuth (-not (Test-Path -LiteralPath $script:interactiveAuthRuntime)) 'BAIDU_AUTH_RUNTIME_COLLISION'
        try { [void][IO.Directory]::CreateDirectory($script:interactiveAuthRuntime) } catch { throw 'BAIDU_AUTH_RUNTIME_CREATE_FAILED' }
        $script:interactiveAuthRuntimeCreated = $true
        Set-OwnerOnlyAcl -Path $script:interactiveAuthRuntime -OwnerSid $ownerSid -Directory
        Assert-OwnerOnlyAcl -Path $script:interactiveAuthRuntime -OwnerSid $ownerSid

        $script:interactiveAuthArchive = Join-Path $script:interactiveAuthRuntime 'BaiduPCS-Go-v4.0.2-windows-x64.zip'
        $script:interactiveAuthBinary = Join-Path $script:interactiveAuthRuntime 'BaiduPCS-Go.exe'
        Assert-InteractiveAuth (-not (Test-Path -LiteralPath $script:interactiveAuthArchive) -and -not (Test-Path -LiteralPath $script:interactiveAuthBinary)) 'BAIDU_AUTH_RUNTIME_FILE_COLLISION'
        $oldProgress = $ProgressPreference
        try {
            $ProgressPreference = 'SilentlyContinue'
            [void](Invoke-WebRequest -Uri $script:archiveUrl -OutFile $script:interactiveAuthArchive -TimeoutSec 120 -ErrorAction Stop)
        } catch { throw 'BAIDU_AUTH_ARCHIVE_DOWNLOAD_FAILED' }
        finally { $ProgressPreference = $oldProgress }
        Set-OwnerOnlyAcl -Path $script:interactiveAuthArchive -OwnerSid $ownerSid
        Assert-OwnerOnlyAcl -Path $script:interactiveAuthArchive -OwnerSid $ownerSid

        $script:interactiveAuthBytes = Get-PinnedBaiduExecutableBytes -Archive $script:interactiveAuthArchive
        Write-OwnerOnlyBinary -Path $script:interactiveAuthBinary -Bytes $script:interactiveAuthBytes -OwnerSid $ownerSid
        [Security.Cryptography.CryptographicOperations]::ZeroMemory($script:interactiveAuthBytes)
        $script:interactiveAuthBytes = $null

        $loginOutcome = Invoke-BaiduInteractiveLogin -ExecutablePath $script:interactiveAuthBinary -ConfigDirectory $configInfo.Path
        $script:interactiveAuthLoginExitCode = [int]$loginOutcome.ExitCode
        $loginOutcome = $null
        $loginSucceeded = $script:interactiveAuthLoginExitCode -eq 0
        Assert-SafeBaiduConfigDirectory -ConfigDirectory $configInfo.Path -ProjectRoot $script:projectRoot -OwnerSid $ownerSid
        $script:interactiveAuthConfigSafe = $true
        if (-not $loginSucceeded) { throw 'BAIDU_AUTH_LOGIN_EXIT_NONZERO' }

        $script:interactiveAuthWho = Invoke-ReadOnlyBaiduWho -ExecutablePath $script:interactiveAuthBinary -ConfigDirectory $configInfo.Path
        $whoOutcome = Resolve-BaiduUidDiscoveryOutcome -ExitCode $script:interactiveAuthWho.ExitCode -StdOut $script:interactiveAuthWho.StdOut -StdErr $script:interactiveAuthWho.StdErr
        $script:interactiveAuthWhoState = [string]$whoOutcome.State
        if ($whoOutcome.State -ceq 'READY') {
            $script:interactiveAuthUid = [string]$whoOutcome.Uid
            $candidateReady = $true
        } elseif ($whoOutcome.State -ceq 'OWNER_ACTION_REQUIRED') {
            $script:interactiveAuthResult = 'OWNER_ACTION_REQUIRED'
            $script:interactiveAuthFailure = 'RETURN_OWNER_ACTION_REQUIRED'
        } else {
            throw 'BAIDU_AUTH_WHO_OUTPUT_AMBIGUOUS'
        }
    } catch {
        $message = [string]$_.Exception.Message
        if ($message -match '^(?:BAIDU_AUTH|BAIDU_WHO|BAIDU_UID|BAIDU_CONFIG|OWNER_RUNTIME)_[A-Z0-9_]+$') {
            $script:interactiveAuthFailure = $message
        } else {
            $script:interactiveAuthFailure = 'BAIDU_AUTH_CHECKPOINT_FAILED_CLOSED'
        }
        $script:interactiveAuthResult = 'FAIL_CLOSED'
    } finally {
        if ($null -ne $script:interactiveAuthBytes) {
            [Security.Cryptography.CryptographicOperations]::ZeroMemory($script:interactiveAuthBytes)
            $script:interactiveAuthBytes = $null
        }
        if ($null -ne $script:interactiveAuthWho) {
            $script:interactiveAuthWho.StdOut = $null
            $script:interactiveAuthWho.StdErr = $null
            $script:interactiveAuthWho = $null
        }
        if ($null -ne $whoOutcome) { $whoOutcome.Uid = $null; $whoOutcome = $null }
        $loginOutcome = $null
        if ($script:interactiveAuthRuntimeCreated -and $null -ne $script:interactiveAuthRuntime) {
            try {
                Remove-BaiduInteractiveRuntime -RuntimeDirectory $script:interactiveAuthRuntime -AllowedParent $localAppData -OwnerSid $ownerSid
                $script:interactiveAuthRuntimeCleanup = 'PASS'
            } catch {
                $script:interactiveAuthRuntimeCleanup = 'FAIL'
                $script:interactiveAuthResult = 'FAIL_CLOSED'
                $script:interactiveAuthFailure = 'BAIDU_AUTH_RUNTIME_CLEANUP_FAILED'
                $candidateReady = $false
            }
        }
        if ($script:interactiveAuthConfigCreated -and -not $candidateReady) {
            try {
                $script:interactiveAuthConfigDisposition = Remove-NewEmptyBaiduConfigDirectory -ConfigDirectory $script:interactiveAuthConfigPath -OwnerSid $ownerSid
            } catch {
                $script:interactiveAuthConfigDisposition = 'ROLLBACK_FAILED'
                $script:interactiveAuthResult = 'FAIL_CLOSED'
                $script:interactiveAuthFailure = 'BAIDU_AUTH_CONFIG_ROLLBACK_FAILED'
                $candidateReady = $false
            }
        } elseif ($script:interactiveAuthConfigCreated -and $candidateReady) {
            $script:interactiveAuthConfigDisposition = 'PRESERVED_AUTHENTICATED'
        } elseif ($script:interactiveAuthConfigState -ceq 'EXISTING_EMPTY_INITIALIZED') {
            $script:interactiveAuthConfigDisposition = 'PRESERVED_PREEXISTING'
        }
        $script:interactiveAuthUid = if ($candidateReady) { $script:interactiveAuthUid } else { $null }
    }

    if (Test-BaiduInteractiveAuthReady -LoginExitCode $script:interactiveAuthLoginExitCode -ConfigSafe $script:interactiveAuthConfigSafe -WhoState $script:interactiveAuthWhoState -Uid $script:interactiveAuthUid -RuntimeCleanup $script:interactiveAuthRuntimeCleanup) {
        $script:interactiveAuthResult = 'READY'
        $script:interactiveAuthFailure = 'NONE'
    } elseif ($script:interactiveAuthRuntimeCleanup -ceq 'FAIL') {
        $script:interactiveAuthResult = 'FAIL_CLOSED'
        $script:interactiveAuthUid = $null
    } elseif ($script:interactiveAuthResult -ceq 'READY') {
        $script:interactiveAuthResult = 'FAIL_CLOSED'
        $script:interactiveAuthFailure = 'BAIDU_AUTH_SUCCESS_INVARIANT_NOT_MET'
        $script:interactiveAuthUid = $null
    } else {
        $script:interactiveAuthUid = $null
    }

    Write-Output ('BAIDU_INTERACTIVE_AUTH=' + $script:interactiveAuthResult)
    Write-Output ('BAIDU_INTERACTIVE_AUTH_FAILURE_CODE=' + $script:interactiveAuthFailure)
    Write-Output ('BAIDU_INTERACTIVE_AUTH_CONFIG_STATE=' + $script:interactiveAuthConfigState)
    Write-Output ('BAIDU_INTERACTIVE_AUTH_CONFIG_DISPOSITION=' + $script:interactiveAuthConfigDisposition)
    Write-Output ('BAIDU_INTERACTIVE_AUTH_RUNTIME_CLEANUP=' + $script:interactiveAuthRuntimeCleanup)
    Write-Output 'BAIDU_INTERACTIVE_LOGIN_OUTPUT_CAPTURED=NO'
    Write-Output 'BAIDU_WHO_RAW_OUTPUT_EMITTED=NO'
    Write-Output 'BAIDU_UID_EMITTED=NO'
    Write-Output 'OWNER_REMINDER=Enter authentication only in the local interactive prompts; do not share prompts, provider output, or credentials.'
}

if ($MyInvocation.InvocationName -ne '.') { Invoke-BaiduOwnerInteractiveAuthCheckpoint }
