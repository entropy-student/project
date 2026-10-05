[CmdletBinding()]
param([switch]$RetainBinary)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$upstreamCommit = '225bdd3b6cb298601c4d5ef7104c3e08cd1d692d'
$goVersion = 'go1.27.1'
$goArchive = 'go1.27.1.windows-amd64.zip'
$goSha256 = 'a3911b5e0e1b1053f25ed0675f4c1c6aad1e2bfcf253df2b9be4caabd2edd95d'
$sourceFiles = @{
    'README.md' = '0d07b9b27b989319a65c3c8979d896e02cabc340'
    'main.go' = 'ac5ace05fc860bc3f47fdaf9ddec126d06890630'
    'internal/pcscommand/login.go' = '8865962ac126053632beee750310b099e6b89e1d'
    'internal/pcsconfig/pcsconfig.go' = '2ab8f56647d70a903786db351c57308ee8bee69d'
    'internal/pcsconfig/maniper.go' = 'edefc8e422dc15938668935de06c4da34c377cbe'
}
$tempParent = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd([char]'\', [char]'/')
$tempRoot = Join-Path $tempParent ('g4b-cookie-adapter-' + [Guid]::NewGuid().ToString('N'))
$savedEnvironment = @{}
$environmentNames = @('GOCACHE', 'GOMODCACHE', 'GOPATH', 'GOTOOLCHAIN', 'GOFLAGS', 'GOOS', 'GOARCH', 'CGO_ENABLED', 'BAIDUPCS_GO_CONFIG_DIR')
$environmentCaptured = $false
$completed = $false
$runtimeBinaryCreated = $false
$runtimeBinaryPath = $null

function Invoke-CheckedNative {
    param([string]$FilePath, [string[]]$ArgumentList, [string]$FailureCode)
    & $FilePath @ArgumentList
    if ($LASTEXITCODE -ne 0) {
        throw $FailureCode
    }
}

function Initialize-OwnerBinaryRuntime {
    $localAppData = [IO.Path]::GetFullPath([Environment]::GetFolderPath([Environment+SpecialFolder]::LocalApplicationData))
    if ([string]::IsNullOrWhiteSpace($localAppData) -or -not (Test-Path -LiteralPath $localAppData -PathType Container)) {
        throw 'OWNER_RUNTIME_ROOT_UNAVAILABLE'
    }
    $ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
    $projectRuntimeRoot = Join-Path $localAppData 'vpn-network-optimization'
    $runtime = Join-Path $projectRuntimeRoot 'runtime'
    foreach ($directory in @($projectRuntimeRoot, $runtime)) {
        if (Test-Path -LiteralPath $directory) {
            $item = Get-Item -LiteralPath $directory -Force -ErrorAction Stop
            if (-not $item.PSIsContainer -or (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)) {
                throw 'OWNER_RUNTIME_DIRECTORY_INVALID'
            }
            Assert-OwnerOnlyAcl -Path $directory -OwnerSid $ownerSid
        } else {
            $acl = New-OwnerOnlyAcl -OwnerSid $ownerSid -Directory
            [void][IO.Directory]::CreateDirectory($directory, $acl)
            Assert-OwnerOnlyAcl -Path $directory -OwnerSid $ownerSid
        }
    }
    return (Join-Path $runtime 'BaiduPCS-Go-cookie-auth-adapter.exe')
}

function Copy-OwnerOnlyRetainedBinary {
    param(
        [string]$SourcePath,
        [string]$DestinationPath,
        [Security.Principal.SecurityIdentifier]$OwnerSid,
        [string]$ExpectedSha256,
        [ref]$Created
    )
    $Created.Value = $false
    $destinationStream = $null
    $sourceStream = $null
    try {
        try {
            if (Test-Path -LiteralPath $DestinationPath) { throw 'RETAINED_BINARY_CREATE_FAILED' }
            $fileSecurity = New-OwnerOnlyAcl -OwnerSid $OwnerSid
            $destinationStream = [System.IO.FileSystemAclExtensions]::Create(
                [IO.FileInfo]::new($DestinationPath),
                [IO.FileMode]::CreateNew,
                [IO.FileAccess]::Write,
                [IO.FileShare]::None,
                65536,
                [IO.FileOptions]::None,
                $fileSecurity
            )
        } catch {
            throw 'RETAINED_BINARY_CREATE_FAILED'
        }
        $Created.Value = $true

        $copyFailed = $false
        try {
            $sourceStream = [IO.File]::OpenRead($SourcePath)
            $sourceStream.CopyTo($destinationStream)
            $destinationStream.Flush($true)
        } catch {
            $copyFailed = $true
        } finally {
            if ($null -ne $sourceStream) {
                try { $sourceStream.Dispose() } catch { $copyFailed = $true }
            }
            if ($null -ne $destinationStream) {
                try { $destinationStream.Dispose() } catch { $copyFailed = $true }
            }
        }
        if ($copyFailed) { throw 'RETAINED_BINARY_COPY_FAILED' }

        try {
            Assert-OwnerOnlyAcl -Path $DestinationPath -OwnerSid $OwnerSid
        } catch {
            throw 'RETAINED_BINARY_ACL_VERIFY_FAILED'
        }

        try {
            $actualSha256 = (Get-FileHash -LiteralPath $DestinationPath -Algorithm SHA256).Hash.ToLowerInvariant()
            if ($actualSha256 -cne $ExpectedSha256.ToLowerInvariant()) { throw 'RETAINED_BINARY_HASH_MISMATCH' }
        } catch {
            throw 'RETAINED_BINARY_HASH_VERIFY_FAILED'
        }
    } finally {
        if ($null -ne $sourceStream) { try { $sourceStream.Dispose() } catch {} }
        if ($null -ne $destinationStream) { try { $destinationStream.Dispose() } catch {} }
    }
}

function Remove-RunCreatedRetainedBinary {
    param([string]$Path, [bool]$WasCreated)
    if (-not $WasCreated) { return $true }
    if ([string]::IsNullOrWhiteSpace($Path)) { return $false }
    try {
        if (Test-Path -LiteralPath $Path) {
            $item = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
            if ($item.PSIsContainer -or (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)) { return $false }
            [IO.File]::Delete($Path)
        }
        return (-not (Test-Path -LiteralPath $Path))
    } catch {
        return $false
    }
}

try {
    if ($RetainBinary) {
        try {
            $aclHelper = Join-Path $PSScriptRoot 'g4b-baidu-auth-readiness-checkpoint.ps1'
            if ((Get-FileHash -LiteralPath $aclHelper -Algorithm SHA256).Hash -cne 'AA28611D5C540F208A0DB40C0ED7D19E18B12180DE8437CCB54EA5A755D7F08F') {
                throw 'R6R1_ACL_HELPER_DRIFT'
            }
            . $aclHelper
            $runtimeBinaryPath = Initialize-OwnerBinaryRuntime
        } catch {
            throw 'OWNER_RUNTIME_PREPARE_FAILED'
        }
        try {
            if (Test-Path -LiteralPath $runtimeBinaryPath) { throw 'RETAINED_BINARY_CREATE_FAILED' }
        } catch {
            throw 'RETAINED_BINARY_CREATE_FAILED'
        }
    }
    if (Test-Path -LiteralPath $tempRoot) {
        throw 'TEMP_ROOT_COLLISION'
    }
    [void][IO.Directory]::CreateDirectory($tempRoot)
    $upstream = Join-Path $tempRoot 'upstream'
    $goZipPath = Join-Path $tempRoot $goArchive

    Invoke-CheckedNative -FilePath 'git' -ArgumentList @('clone', '--quiet', '--depth', '1', '--branch', 'v4.0.2', '--no-tags', 'https://github.com/qjfoidnh/BaiduPCS-Go.git', $upstream) -FailureCode 'UPSTREAM_FETCH_FAILED'
    $actualCommit = (& git -C $upstream rev-parse HEAD).Trim()
    if ($LASTEXITCODE -ne 0 -or $actualCommit -cne $upstreamCommit) {
        throw 'UPSTREAM_COMMIT_MISMATCH'
    }
    foreach ($relativePath in $sourceFiles.Keys) {
        $actualBlob = (& git -C $upstream rev-parse ('HEAD:' + $relativePath)).Trim()
        if ($LASTEXITCODE -ne 0 -or $actualBlob -cne $sourceFiles[$relativePath]) {
            throw 'UPSTREAM_SOURCE_BLOB_MISMATCH'
        }
    }

    $goUri = 'https://go.dev/dl/' + $goArchive
    Invoke-WebRequest -Uri $goUri -OutFile $goZipPath -TimeoutSec 300 -ErrorAction Stop
    $actualGoSha = (Get-FileHash -LiteralPath $goZipPath -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($actualGoSha -cne $goSha256) {
        throw 'GO_TOOLCHAIN_DIGEST_MISMATCH'
    }
    Expand-Archive -LiteralPath $goZipPath -DestinationPath $tempRoot -Force
    $goExe = Join-Path $tempRoot 'go\bin\go.exe'
    if (-not (Test-Path -LiteralPath $goExe -PathType Leaf)) {
        throw 'GO_TOOLCHAIN_MISSING'
    }

    $adapterDir = Join-Path $upstream 'cmd\vpn-network-optimization-cookie-auth'
    [void][IO.Directory]::CreateDirectory($adapterDir)
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'g4b-baidu-cookie-auth-adapter\main.go') -Destination (Join-Path $adapterDir 'main.go') -ErrorAction Stop
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'g4b-baidu-cookie-auth-adapter\main_test.go') -Destination (Join-Path $adapterDir 'main_test.go') -ErrorAction Stop

    foreach ($name in $environmentNames) {
        $savedEnvironment[$name] = [Environment]::GetEnvironmentVariable($name, [EnvironmentVariableTarget]::Process)
    }
    $environmentCaptured = $true
    $env:GOCACHE = Join-Path $tempRoot 'gocache'
    $env:GOMODCACHE = Join-Path $tempRoot 'gomodcache'
    $env:GOPATH = Join-Path $tempRoot 'gopath'
    $env:GOTOOLCHAIN = 'local'
    $env:GOFLAGS = '-mod=readonly'
    $env:GOOS = 'windows'
    $env:GOARCH = 'amd64'
    $env:CGO_ENABLED = '0'
    $env:BAIDUPCS_GO_CONFIG_DIR = Join-Path $tempRoot 'synthetic-config-not-created'

    Push-Location $upstream
    try {
        Invoke-CheckedNative -FilePath $goExe -ArgumentList @('test', './cmd/vpn-network-optimization-cookie-auth') -FailureCode 'GO_TEST_FAILED'
        $binary = Join-Path $tempRoot 'BaiduPCS-Go-cookie-auth-adapter.exe'
        Invoke-CheckedNative -FilePath $goExe -ArgumentList @('build', '-trimpath', '-buildvcs=false', '-ldflags', '-s -w -buildid=', '-o', $binary, './cmd/vpn-network-optimization-cookie-auth') -FailureCode 'GO_BUILD_FAILED'
        $binarySha = (Get-FileHash -LiteralPath $binary -Algorithm SHA256).Hash.ToLowerInvariant()

        if ($RetainBinary) {
            $ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
            Copy-OwnerOnlyRetainedBinary -SourcePath $binary -DestinationPath $runtimeBinaryPath -OwnerSid $ownerSid -ExpectedSha256 $binarySha -Created ([ref]$runtimeBinaryCreated)
        }

        $fixtureInfo = [Diagnostics.ProcessStartInfo]::new()
        $fixtureInfo.FileName = $binary
        $fixtureInfo.UseShellExecute = $false
        $fixtureInfo.CreateNoWindow = $true
        $fixtureInfo.RedirectStandardInput = $true
        $fixtureInfo.RedirectStandardOutput = $true
        $fixtureInfo.RedirectStandardError = $true
        $fixtureInfo.Environment.Clear()
        foreach ($name in @('SystemRoot', 'WINDIR', 'APPDATA')) {
            $value = [Environment]::GetEnvironmentVariable($name, [EnvironmentVariableTarget]::Process)
            if (-not [string]::IsNullOrWhiteSpace($value)) { $fixtureInfo.Environment[$name] = $value }
        }
        $fixtureInfo.Environment['BAIDUPCS_GO_CONFIG_DIR'] = $env:BAIDUPCS_GO_CONFIG_DIR
        $fixtureInfo.ArgumentList.Add('non-secret-invalid-argument-fixture')
        $fixtureProcess = [Diagnostics.Process]::new()
        try {
            $fixtureProcess.StartInfo = $fixtureInfo
            if (-not $fixtureProcess.Start()) { throw 'NATIVE_EXIT_FIXTURE_START_FAILED' }
            $fixtureStdout = $fixtureProcess.StandardOutput.ReadToEnd()
            $fixtureStderr = $fixtureProcess.StandardError.ReadToEnd()
            $fixtureProcess.WaitForExit()
            if ($fixtureProcess.ExitCode -eq 0 -or ($fixtureStdout + $fixtureStderr) -notmatch 'BAIDU_COOKIE_AUTH_FAILURE_CODE=ARGUMENTS_FORBIDDEN') {
                throw 'NATIVE_EXIT_FIXTURE_FAILED'
            }
        } finally {
            $fixtureProcess.Dispose()
        }
        Write-Output ('UPSTREAM_COMMIT=' + $actualCommit)
        Write-Output ('GO_VERSION=' + $goVersion)
        Write-Output ('GO_TOOLCHAIN_SHA256=' + $actualGoSha)
        Write-Output ('BUILD_TARGET=windows/amd64')
        Write-Output ('ADAPTER_BINARY_SHA256=' + $binarySha)
        if ($RetainBinary) { Write-Output 'OWNER_RUNTIME_BINARY=CREATED' }
        Write-Output 'GO_SOURCE_TESTS=PASS'
        Write-Output 'NATIVE_FAILURE_EXIT_FIXTURE=PASS'
    } finally {
        Pop-Location
    }
    $completed = $true
} catch {
    Write-Output 'BUILD_VALIDATION=FAIL_CLOSED'
    $safeFailureCodes = @(
        'OWNER_RUNTIME_PREPARE_FAILED',
        'RETAINED_BINARY_CREATE_FAILED',
        'RETAINED_BINARY_COPY_FAILED',
        'RETAINED_BINARY_ACL_VERIFY_FAILED',
        'RETAINED_BINARY_HASH_VERIFY_FAILED',
        'TEMP_ROOT_COLLISION',
        'UPSTREAM_FETCH_FAILED',
        'UPSTREAM_COMMIT_MISMATCH',
        'UPSTREAM_SOURCE_BLOB_MISMATCH',
        'GO_TOOLCHAIN_DIGEST_MISMATCH',
        'GO_TOOLCHAIN_MISSING',
        'GO_TEST_FAILED',
        'GO_BUILD_FAILED',
        'NATIVE_EXIT_FIXTURE_START_FAILED',
        'NATIVE_EXIT_FIXTURE_FAILED'
    )
    if ($_.Exception.Message -in $safeFailureCodes) {
        Write-Output ('FAILURE_CODE=' + $_.Exception.Message)
    } else {
        Write-Output 'FAILURE_CODE=BUILD_VALIDATION_FAILED'
    }
} finally {
    if ($environmentCaptured) {
        try {
            foreach ($name in $environmentNames) {
                $oldValue = $savedEnvironment[$name]
                if ($null -eq $oldValue) {
                    [Environment]::SetEnvironmentVariable($name, $null, [EnvironmentVariableTarget]::Process)
                } else {
                    [Environment]::SetEnvironmentVariable($name, $oldValue, [EnvironmentVariableTarget]::Process)
                }
            }
        } catch {
            Write-Output 'BUILD_ENVIRONMENT_CLEANUP=FAIL'
            $completed = $false
        }
    }
    $tempCleanupPass = $true
    try {
        if (Test-Path -LiteralPath $tempRoot) {
            $resolvedTempRoot = [IO.Path]::GetFullPath($tempRoot)
            $resolvedParent = [IO.Path]::GetFullPath([IO.Path]::GetDirectoryName($resolvedTempRoot)).TrimEnd([char]'\', [char]'/')
            if ($resolvedParent -cne $tempParent -or [IO.Path]::GetFileName($resolvedTempRoot) -notmatch '^g4b-cookie-adapter-[0-9a-f]{32}$') {
                throw 'TEMP_CLEANUP_SCOPE_INVALID'
            }
            Remove-Item -LiteralPath $resolvedTempRoot -Recurse -Force -ErrorAction Stop
        }
        $tempCleanupPass = -not (Test-Path -LiteralPath $tempRoot)
    } catch {
        $tempCleanupPass = $false
    }
    if (-not $tempCleanupPass) {
        Write-Output 'TEMP_BUILD_CLEANUP=FAIL'
        $completed = $false
    } else {
        Write-Output 'TEMP_BUILD_CLEANUP=PASS'
    }
    if (-not $completed -and $runtimeBinaryCreated -and $null -ne $runtimeBinaryPath) {
        if (Remove-RunCreatedRetainedBinary -Path $runtimeBinaryPath -WasCreated $runtimeBinaryCreated) {
            $runtimeBinaryCreated = $false
            Write-Output 'RETAINED_BINARY_CLEANUP=PASS'
        } else {
            Write-Output 'RETAINED_BINARY_CLEANUP=FAIL'
        }
    } elseif (-not $completed -and $RetainBinary -and -not $runtimeBinaryCreated) {
        Write-Output 'RETAINED_BINARY_CLEANUP=NOT_REQUIRED'
    }
}
if (-not $completed) {
    exit 1
}
