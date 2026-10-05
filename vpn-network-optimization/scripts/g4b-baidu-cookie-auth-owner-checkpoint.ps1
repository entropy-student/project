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
$process = $null
$script:adapterSha256 = '5c6ad2fdbcb9bee1b3b2fdc789b07e061bd89cc64350c750298b682b717e7955'

function Stop-CookieCheckpoint {
    param([string]$Code)
    throw $Code
}

try {
    if ([Console]::IsInputRedirected -or [Console]::IsOutputRedirected -or [Console]::IsErrorRedirected) {
        Stop-CookieCheckpoint 'OWNER_LIVE_CONSOLE_REQUIRED'
    }
    if ([string]::IsNullOrWhiteSpace($env:APPDATA)) {
        Stop-CookieCheckpoint 'OWNER_CONFIG_ROOT_UNAVAILABLE'
    }

    $projectRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
    $aclHelper = Join-Path $PSScriptRoot 'g4b-baidu-auth-readiness-checkpoint.ps1'
    if (-not (Test-Path -LiteralPath $aclHelper -PathType Leaf)) {
        Stop-CookieCheckpoint 'R6R1_ACL_HELPER_MISSING'
    }
    $aclHelperHash = (Get-FileHash -LiteralPath $aclHelper -Algorithm SHA256 -ErrorAction Stop).Hash
    if ($aclHelperHash -cne 'AA28611D5C540F208A0DB40C0ED7D19E18B12180DE8437CCB54EA5A755D7F08F') {
        Stop-CookieCheckpoint 'R6R1_ACL_HELPER_DRIFT'
    }
    . $aclHelper

    $ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
    if ($null -eq $ownerSid) {
        Stop-CookieCheckpoint 'OWNER_SID_UNAVAILABLE'
    }
    $requestedConfig = Join-Path $env:APPDATA 'BaiduPCS-Go'
    $configPath = Resolve-SafeBaiduConfigPath -ConfigDirectory $requestedConfig -ProjectRoot $projectRoot
    if (Test-Path -LiteralPath $configPath) {
        $root = Get-Item -LiteralPath $configPath -Force -ErrorAction Stop
        if (-not $root.PSIsContainer -or (($root.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)) {
            Stop-CookieCheckpoint 'BAIDU_CONFIG_ROOT_INVALID'
        }
        if (@(Get-ChildItem -LiteralPath $configPath -Force -ErrorAction Stop).Count -ne 0) {
            Stop-CookieCheckpoint 'BAIDU_CONFIG_NOT_EMPTY'
        }
    } else {
        $directoryAcl = New-OwnerOnlyAcl -OwnerSid $ownerSid -Directory
        [void][IO.Directory]::CreateDirectory($configPath, $directoryAcl)
        $root = Get-Item -LiteralPath $configPath -Force -ErrorAction Stop
        if (-not $root.PSIsContainer -or (($root.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)) {
            Stop-CookieCheckpoint 'BAIDU_CONFIG_ROOT_INVALID'
        }
        if (@(Get-ChildItem -LiteralPath $configPath -Force -ErrorAction Stop).Count -ne 0) {
            Stop-CookieCheckpoint 'BAIDU_CONFIG_NOT_EMPTY'
        }
    }
    Assert-SafeBaiduConfigDirectory -ConfigDirectory $configPath -ProjectRoot $projectRoot -OwnerSid $ownerSid

    $binary = [IO.Path]::GetFullPath($AdapterPath)
    if (Test-PathWithin -Path $binary -Parent $projectRoot -or -not (Test-Path -LiteralPath $binary -PathType Leaf)) {
        Stop-CookieCheckpoint 'ADAPTER_PATH_INVALID'
    }
    Assert-OwnerOnlyAcl -Path $binary -OwnerSid $ownerSid
    if ((Get-FileHash -LiteralPath $binary -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant() -cne $script:adapterSha256) {
        Stop-CookieCheckpoint 'ADAPTER_BINARY_HASH_MISMATCH'
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
        if (-not [string]::IsNullOrWhiteSpace($value)) {
            $startInfo.Environment[$name] = $value
        }
    }
    $startInfo.Environment['BAIDUPCS_GO_CONFIG_DIR'] = $configPath

    $process = [Diagnostics.Process]::new()
    $process.StartInfo = $startInfo
    if (-not $process.Start()) {
        Stop-CookieCheckpoint 'ADAPTER_START_FAILED'
    }
    $process.WaitForExit()
    $script:childExitCode = [int]$process.ExitCode

    Assert-SafeBaiduConfigDirectory -ConfigDirectory $configPath -ProjectRoot $projectRoot -OwnerSid $ownerSid
    $entries = @(Get-ChildItem -LiteralPath $configPath -Force -ErrorAction Stop)
    if ($script:childExitCode -eq 0) {
        if ($entries.Count -ne 1) {
            Stop-CookieCheckpoint 'BAIDU_CONFIG_POSTAUTH_SHAPE_INVALID'
        }
        $entry = $entries[0]
        if ($entry.PSIsContainer -or $entry.Name -cne 'pcs_config.json' -or (($entry.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) -or $entry.Length -le 0) {
            Stop-CookieCheckpoint 'BAIDU_CONFIG_POSTAUTH_SHAPE_INVALID'
        }
        $script:result = 'SETUP_SAVED'
        $script:failureCode = 'NONE'
    } else {
        $script:failureCode = 'ADAPTER_NATIVE_EXIT_NONZERO'
    }
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
}

Write-Output ('BAIDU_COOKIE_AUTH_CHECKPOINT=' + $script:result)
Write-Output ('BAIDU_COOKIE_AUTH_FAILURE_CODE=' + $script:failureCode)
Write-Output ('BAIDU_COOKIE_AUTH_NATIVE_EXIT=' + $script:childExitCode)
Write-Output 'BAIDU_COOKIE_AUTH_WHO=NOT_RUN'
Write-Output 'BAIDU_COOKIE_AUTH_UID_EMITTED=NO'
