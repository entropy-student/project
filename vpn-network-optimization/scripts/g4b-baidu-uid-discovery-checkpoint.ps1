[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:uidDiscoveryState = 'FAIL_CLOSED'
$script:uidDiscoveryFailure = 'UID_HELPER_NOT_RUN'
$script:uidDiscoveryValue = $null
$script:uidDiscoveryCleanup = 'NOT_REQUIRED'
$script:uidDiscoveryRuntime = $null
$script:uidDiscoveryArchive = $null
$script:uidDiscoveryBinary = $null
$script:uidDiscoveryBytes = $null
$script:uidDiscoveryWho = $null

function Assert-UidHelper {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
}

function Resolve-BaiduUidDiscoveryOutcome {
    param([int]$ExitCode, [string]$StdOut, [string]$StdErr)
    $uidPattern = '(?m)^当前帐号 uid:\s*([0-9]+),'
    $uidMatches = [regex]::Matches($StdOut, $uidPattern)
    $uidMentionPattern = '(?i)\buid\b|帐号\s*uid'
    if ($ExitCode -ne 0) {
        if ($uidMatches.Count -gt 0 -or ($StdOut + [Environment]::NewLine + $StdErr) -match $uidMentionPattern) {
            return [pscustomobject]@{ State = 'FAIL_CLOSED'; Uid = $null; Code = 'BAIDU_UID_OUTPUT_AMBIGUOUS' }
        }
        return [pscustomobject]@{ State = 'OWNER_ACTION_REQUIRED'; Uid = $null; Code = 'RETURN_OWNER_ACTION_REQUIRED' }
    }
    if ($uidMatches.Count -gt 1) {
        return [pscustomobject]@{ State = 'FAIL_CLOSED'; Uid = $null; Code = 'BAIDU_UID_OUTPUT_AMBIGUOUS' }
    }
    if ($uidMatches.Count -eq 0) {
        if (($StdOut + [Environment]::NewLine + $StdErr) -match $uidMentionPattern) {
            return [pscustomobject]@{ State = 'FAIL_CLOSED'; Uid = $null; Code = 'BAIDU_UID_OUTPUT_AMBIGUOUS' }
        }
        return [pscustomobject]@{ State = 'OWNER_ACTION_REQUIRED'; Uid = $null; Code = 'RETURN_OWNER_ACTION_REQUIRED' }
    }
    $uid = $uidMatches[0].Groups[1].Value
    if ($uid -notmatch '^[1-9][0-9]{0,19}$') {
        return [pscustomobject]@{ State = 'FAIL_CLOSED'; Uid = $null; Code = 'BAIDU_UID_OUTPUT_AMBIGUOUS' }
    }
    return [pscustomobject]@{ State = 'READY'; Uid = $uid; Code = 'NONE' }
}

function Remove-BaiduUidRuntime {
    param([string]$RuntimeDirectory, [string]$AllowedParent)
    $runtimeFull = [IO.Path]::GetFullPath($RuntimeDirectory)
    $parentFull = [IO.Path]::GetFullPath($AllowedParent)
    Assert-UidHelper (([IO.Path]::GetDirectoryName($runtimeFull) -ceq $parentFull) -and ([IO.Path]::GetFileName($runtimeFull) -match '^vpn-network-optimization-baidu-uid-[0-9a-f]{32}$')) 'UID_RUNTIME_CLEANUP_SCOPE_INVALID'
    if (-not (Test-Path -LiteralPath $runtimeFull)) { return }
    $directory = Get-Item -LiteralPath $runtimeFull -Force -ErrorAction Stop
    Assert-UidHelper ($directory.PSIsContainer -and (($directory.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0)) 'UID_RUNTIME_CLEANUP_PATH_INVALID'
    $allowedNames = @('BaiduPCS-Go-v4.0.2-windows-x64.zip', 'BaiduPCS-Go.exe')
    $children = @(Get-ChildItem -LiteralPath $runtimeFull -Force -ErrorAction Stop)
    foreach ($child in $children) {
        Assert-UidHelper (-not $child.PSIsContainer -and (($child.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) -and $child.Name -in $allowedNames) 'UID_RUNTIME_CLEANUP_CONTENT_INVALID'
    }
    foreach ($child in $children) { Remove-Item -LiteralPath $child.FullName -Force -ErrorAction Stop }
    [IO.Directory]::Delete($runtimeFull, $false)
    Assert-UidHelper (-not (Test-Path -LiteralPath $runtimeFull)) 'UID_RUNTIME_CLEANUP_UNVERIFIED'
}

function Invoke-BaiduUidDiscoveryCheckpoint {
    $outcome = $null
    $localAppData = $null
    try {
        $acceptedCheckpoint = Join-Path $PSScriptRoot 'g4b-baidu-auth-readiness-checkpoint.ps1'
        Assert-UidHelper (Test-Path -LiteralPath $acceptedCheckpoint -PathType Leaf) 'UID_HELPER_ACCEPTED_CHECKPOINT_MISSING'
        . $acceptedCheckpoint

        $ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
        $projectRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
        $configDirectory = Join-Path $env:APPDATA 'BaiduPCS-Go'
        $configFull = Resolve-SafeBaiduConfigPath -ConfigDirectory $configDirectory -ProjectRoot $projectRoot
        $configPresence = Resolve-BaiduConfigPresence -PathExists (Test-Path -LiteralPath $configFull) -IsDirectory (Test-Path -LiteralPath $configFull -PathType Container)
        if ($configPresence.State -ceq 'OWNER_ACTION_REQUIRED') {
            $script:uidDiscoveryState = 'OWNER_ACTION_REQUIRED'
            $script:uidDiscoveryFailure = 'RETURN_OWNER_ACTION_REQUIRED'
        } elseif ($configPresence.State -ceq 'FAIL_CLOSED') {
            throw $configPresence.Code
        } else {
            Assert-SafeBaiduConfigDirectory -ConfigDirectory $configFull -ProjectRoot $projectRoot -OwnerSid $ownerSid
            $localAppData = [Environment]::GetFolderPath([Environment+SpecialFolder]::LocalApplicationData)
            Assert-UidHelper (-not [string]::IsNullOrWhiteSpace($localAppData) -and (Test-Path -LiteralPath $localAppData -PathType Container)) 'UID_RUNTIME_ROOT_UNAVAILABLE'
            $runtimeName = 'vpn-network-optimization-baidu-uid-' + [Guid]::NewGuid().ToString('N')
            $script:uidDiscoveryRuntime = Join-Path $localAppData $runtimeName
            Assert-UidHelper (-not (Test-Path -LiteralPath $script:uidDiscoveryRuntime)) 'UID_RUNTIME_COLLISION'
            [void][IO.Directory]::CreateDirectory($script:uidDiscoveryRuntime)
            Set-OwnerOnlyAcl -Path $script:uidDiscoveryRuntime -OwnerSid $ownerSid -Directory
            Assert-OwnerOnlyAcl -Path $script:uidDiscoveryRuntime -OwnerSid $ownerSid

            $script:uidDiscoveryArchive = Join-Path $script:uidDiscoveryRuntime 'BaiduPCS-Go-v4.0.2-windows-x64.zip'
            Assert-UidHelper (-not (Test-Path -LiteralPath $script:uidDiscoveryArchive)) 'UID_ARCHIVE_COLLISION'
            $oldProgress = $ProgressPreference
            try {
                $ProgressPreference = 'SilentlyContinue'
                [void](Invoke-WebRequest -Uri $script:archiveUrl -OutFile $script:uidDiscoveryArchive -TimeoutSec 120 -ErrorAction Stop)
            } catch { throw 'UID_HELPER_DOWNLOAD_FAILED' }
            finally { $ProgressPreference = $oldProgress }

            $script:uidDiscoveryBytes = Get-PinnedBaiduExecutableBytes -Archive $script:uidDiscoveryArchive
            $script:uidDiscoveryBinary = Join-Path $script:uidDiscoveryRuntime 'BaiduPCS-Go.exe'
            Write-OwnerOnlyBinary -Path $script:uidDiscoveryBinary -Bytes $script:uidDiscoveryBytes -OwnerSid $ownerSid
            [Security.Cryptography.CryptographicOperations]::ZeroMemory($script:uidDiscoveryBytes)
            $script:uidDiscoveryBytes = $null

            $script:uidDiscoveryWho = Invoke-ReadOnlyBaiduWho -ExecutablePath $script:uidDiscoveryBinary -ConfigDirectory $configFull
            $outcome = Resolve-BaiduUidDiscoveryOutcome -ExitCode $script:uidDiscoveryWho.ExitCode -StdOut $script:uidDiscoveryWho.StdOut -StdErr $script:uidDiscoveryWho.StdErr
            $script:uidDiscoveryState = $outcome.State
            $script:uidDiscoveryFailure = $outcome.Code
            if ($outcome.State -ceq 'READY') { $script:uidDiscoveryValue = $outcome.Uid }
        }
    } catch {
        $message = [string]$_.Exception.Message
        if ($message -match '^(?:BAIDU_AUTH_CONFIG|BAIDU_CONFIG|BAIDU_CLI|BAIDU_WHO|OWNER_RUNTIME|UID)_[A-Z0-9_]+$') {
            $script:uidDiscoveryFailure = $message
        } else {
            $script:uidDiscoveryFailure = 'UID_HELPER_FAILED_CLOSED'
        }
        $script:uidDiscoveryState = 'FAIL_CLOSED'
    } finally {
        if ($null -ne $script:uidDiscoveryBytes) {
            [Security.Cryptography.CryptographicOperations]::ZeroMemory($script:uidDiscoveryBytes)
            $script:uidDiscoveryBytes = $null
        }
        $script:uidDiscoveryCleanup = 'NOT_REQUIRED'
        if ($null -ne $script:uidDiscoveryRuntime) {
            try {
                Remove-BaiduUidRuntime -RuntimeDirectory $script:uidDiscoveryRuntime -AllowedParent $localAppData
                $script:uidDiscoveryCleanup = 'PASS'
            } catch {
                $script:uidDiscoveryCleanup = 'FAIL'
                $script:uidDiscoveryState = 'FAIL_CLOSED'
                $script:uidDiscoveryFailure = 'UID_RUNTIME_CLEANUP_FAILED'
                $script:uidDiscoveryValue = $null
            }
        }
        if ($null -ne $script:uidDiscoveryWho) {
            $script:uidDiscoveryWho.StdOut = $null
            $script:uidDiscoveryWho.StdErr = $null
            $script:uidDiscoveryWho = $null
        }
        $outcome = $null
    }

    Write-Output ('BAIDU_UID_DISCOVERY=' + $script:uidDiscoveryState)
    if ($script:uidDiscoveryState -ceq 'READY' -and $script:uidDiscoveryCleanup -ceq 'PASS') {
        Write-Output ('BAIDU_OWNER_LOCAL_UID=' + $script:uidDiscoveryValue)
        Write-Output 'BAIDU_UID_NOT_FOR_CHAT_OR_GITHUB=YES'
    }
    Write-Output ('BAIDU_UID_FAILURE_CODE=' + $script:uidDiscoveryFailure)
    Write-Output ('BAIDU_UID_RUNTIME_CLEANUP=' + $script:uidDiscoveryCleanup)
    Write-Output 'OWNER_REMINDER=Keep any displayed UID local; do not paste it or provider output into chat or GitHub.'
    $script:uidDiscoveryValue = $null
}

if ($MyInvocation.InvocationName -ne '.') { Invoke-BaiduUidDiscoveryCheckpoint }
