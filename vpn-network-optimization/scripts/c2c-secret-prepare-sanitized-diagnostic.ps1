[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$PSNativeCommandUseErrorActionPreference = $false

$started = [DateTimeOffset]::UtcNow
Write-Output ('ROUND_STARTED_AT=' + $started.ToString('o'))

$secretHelper = Join-Path $PSScriptRoot 'c2c-secret-profile-helper.ps1'
$runtimeRoot = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'
$profilePath = $null

function Assert-D7 {
    param([bool]$Condition,[string]$Code)
    if (-not $Condition) { throw $Code }
}

function Test-HighIntegrity {
    $groups = (& whoami.exe /groups 2>&1) -join [Environment]::NewLine
    $match = [regex]::Match($groups,'S-1-16-(\d+)')
    return ($match.Success -and [int]$match.Groups[1].Value -ge 12288)
}

function Get-RuntimeResidueState {
    $dirs = @()
    $profiles = @()

    if (Test-Path -LiteralPath $runtimeRoot -PathType Container) {
        $dirs = @(
            Get-ChildItem -LiteralPath $runtimeRoot -Directory -Force -ErrorAction Stop |
            Where-Object { $_.Name -match '^c2c-[0-9a-f]{32}$' }
        )
        $profiles = @(
            Get-ChildItem -LiteralPath $runtimeRoot -File -Recurse -Force -ErrorAction Stop |
            Where-Object { $_.Name -match '^c2c-real-hy2-canary-[0-9a-f]{8}\.yaml$' }
        )
    }

    return [pscustomobject]@{
        DirectoryCount = @($dirs).Count
        ProfileCount = @($profiles).Count
    }
}

function Get-OneMarker {
    param([object[]]$Output,[string]$Pattern,[string]$MissingCode,[string]$AmbiguousCode)

    $matches = @(
        $Output |
        ForEach-Object { [string]$_ } |
        Where-Object { $_ -cmatch $Pattern }
    )

    Assert-D7 (@($matches).Count -gt 0) $MissingCode
    Assert-D7 (@($matches).Count -eq 1) $AmbiguousCode
    return [string]$matches[0]
}

function Write-PrepareSafeEvidence {
    param([object[]]$Output)

    $allowExact = @(
        'DPAPI_UNPROTECT=PASS',
        'REAL_HY2_AUTH_FORMAT=PASS',
        'CERTIFICATE_FINGERPRINT_MATCH=PASS',
        'CLASH_REAL_AUTH_PREEXISTING=NO',
        'OWNER_ONLY_REAL_PROFILE=PASS',
        'MIHOMO_REAL_PROFILE_PARSE=PASS',
        'C2C_SECRET_PREPARE=PASS',
        'C2C_SECRET_HELPER_RESULT=PASS',
        'C2C_SECRET_HELPER_RESULT=RETURN',
        'SECRET_VALUES_EMITTED=0'
    )

    foreach ($line in $Output) {
        $text = [string]$line
        if ($allowExact -ccontains $text) {
            Write-Output $text
        }
        elseif ($text -cmatch '^FAILURE_CODE=[A-Z][A-Z0-9_]{1,95}$') {
            Write-Output $text
        }
    }
}

function Write-CleanupSafeEvidence {
    param([object[]]$Output)

    $allowExact = @(
        'CLASH_REAL_AUTH_RESIDUE=ABSENT',
        'PROJECT_RUNTIME_REAL_AUTH_RESIDUE=ABSENT',
        'REAL_PROFILE_RUNTIME_CLEANUP=PASS',
        'C2C_SECRET_CLEANUP_VERIFY=PASS',
        'C2C_SECRET_HELPER_RESULT=PASS',
        'C2C_SECRET_HELPER_RESULT=RETURN',
        'SECRET_VALUES_EMITTED=0'
    )

    foreach ($line in $Output) {
        $text = [string]$line
        if ($allowExact -ccontains $text) {
            Write-Output $text
        }
        elseif ($text -cmatch '^FAILURE_CODE=[A-Z][A-Z0-9_]{1,95}$') {
            Write-Output $text
        }
    }
}

try {
    Assert-D7 ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
    Assert-D7 (Test-HighIntegrity) 'HIGH_INTEGRITY_REQUIRED'

    $principal = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
    Assert-D7 ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 'ADMINISTRATOR_REQUIRED'
    Assert-D7 (Test-Path -LiteralPath $secretHelper -PathType Leaf) 'C2C_SECRET_HELPER_MISSING'

    Write-Output 'OWNER_RUNTIME=PASS'

    $before = Get-RuntimeResidueState
    Write-Output ('PREPARE_BASELINE_C2C_DIRECTORY_COUNT=' + $before.DirectoryCount)
    Write-Output ('PREPARE_BASELINE_C2C_PROFILE_COUNT=' + $before.ProfileCount)
    Assert-D7 ($before.DirectoryCount -eq 0 -and $before.ProfileCount -eq 0) 'PREPARE_BASELINE_RUNTIME_RESIDUE_PRESENT'

    $pwsh = (Get-Command pwsh.exe -ErrorAction Stop).Source

    Write-Output 'SECRET_PREPARE_REPLAY_STARTED=YES'
    $prepareOutput = @(& $pwsh -NoProfile -File $secretHelper -Prepare 2>&1)
    $prepareExit = $LASTEXITCODE

    Write-PrepareSafeEvidence -Output $prepareOutput

    [void](Get-OneMarker -Output $prepareOutput -Pattern '^SECRET_VALUES_EMITTED=0$' -MissingCode 'SECRET_EMISSION_MARKER_MISSING' -AmbiguousCode 'SECRET_EMISSION_MARKER_AMBIGUOUS')

    if ($prepareExit -ne 0) {
        [void](Get-OneMarker -Output $prepareOutput -Pattern '^C2C_SECRET_HELPER_RESULT=RETURN$' -MissingCode 'PREPARE_RETURN_MARKER_MISSING' -AmbiguousCode 'PREPARE_RETURN_MARKER_AMBIGUOUS')
        [void](Get-OneMarker -Output $prepareOutput -Pattern '^FAILURE_CODE=[A-Z][A-Z0-9_]{1,95}$' -MissingCode 'PREPARE_FAILURE_CODE_MISSING' -AmbiguousCode 'PREPARE_FAILURE_CODE_AMBIGUOUS')

        Write-Output 'SECRET_PREPARE_CHILD_RESULT=RETURN'

        $afterFailure = Get-RuntimeResidueState
        Write-Output ('POST_RETURN_C2C_DIRECTORY_COUNT=' + $afterFailure.DirectoryCount)
        Write-Output ('POST_RETURN_C2C_PROFILE_COUNT=' + $afterFailure.ProfileCount)
        Assert-D7 ($afterFailure.DirectoryCount -eq 0 -and $afterFailure.ProfileCount -eq 0) 'POST_RETURN_RUNTIME_RESIDUE_PRESENT'

        Write-Output 'D7_SECRET_PREPARE_DIAGNOSTIC=RETURN_CLASSIFIED'
        exit 0
    }

    [void](Get-OneMarker -Output $prepareOutput -Pattern '^C2C_SECRET_HELPER_RESULT=PASS$' -MissingCode 'PREPARE_PASS_MARKER_MISSING' -AmbiguousCode 'PREPARE_PASS_MARKER_AMBIGUOUS')
    $pathMarker = Get-OneMarker -Output $prepareOutput -Pattern '^TEMP_REAL_PROFILE_PATH=.+$' -MissingCode 'TEMP_REAL_PROFILE_PATH_MISSING' -AmbiguousCode 'TEMP_REAL_PROFILE_PATH_AMBIGUOUS'

    $profilePath = $pathMarker.Substring('TEMP_REAL_PROFILE_PATH='.Length)
    Assert-D7 (Test-Path -LiteralPath $profilePath -PathType Leaf) 'TEMP_REAL_PROFILE_NOT_FOUND_AFTER_PREPARE'

    Write-Output 'SECRET_PREPARE_CHILD_RESULT=PASS'
    Write-Output 'TEMP_REAL_PROFILE_CREATED=YES'
    Write-Output 'CLEANUP_AFTER_UNEXPECTED_PREPARE_PASS=STARTED'

    $cleanupOutput = @(& $pwsh -NoProfile -File $secretHelper -VerifyCleanup -ProfilePath $profilePath 2>&1)
    $cleanupExit = $LASTEXITCODE

    Write-CleanupSafeEvidence -Output $cleanupOutput

    Assert-D7 ($cleanupExit -eq 0) 'DIAGNOSTIC_CLEANUP_HELPER_FAILED'
    [void](Get-OneMarker -Output $cleanupOutput -Pattern '^C2C_SECRET_HELPER_RESULT=PASS$' -MissingCode 'CLEANUP_PASS_MARKER_MISSING' -AmbiguousCode 'CLEANUP_PASS_MARKER_AMBIGUOUS')
    [void](Get-OneMarker -Output $cleanupOutput -Pattern '^C2C_SECRET_CLEANUP_VERIFY=PASS$' -MissingCode 'CLEANUP_VERIFY_MARKER_MISSING' -AmbiguousCode 'CLEANUP_VERIFY_MARKER_AMBIGUOUS')
    [void](Get-OneMarker -Output $cleanupOutput -Pattern '^SECRET_VALUES_EMITTED=0$' -MissingCode 'CLEANUP_SECRET_MARKER_MISSING' -AmbiguousCode 'CLEANUP_SECRET_MARKER_AMBIGUOUS')

    $afterCleanup = Get-RuntimeResidueState
    Write-Output ('POST_CLEANUP_C2C_DIRECTORY_COUNT=' + $afterCleanup.DirectoryCount)
    Write-Output ('POST_CLEANUP_C2C_PROFILE_COUNT=' + $afterCleanup.ProfileCount)
    Assert-D7 ($afterCleanup.DirectoryCount -eq 0 -and $afterCleanup.ProfileCount -eq 0) 'POST_CLEANUP_RUNTIME_RESIDUE_PRESENT'

    Write-Output 'D7_SECRET_PREPARE_DIAGNOSTIC=UNEXPECTED_PREPARE_PASS_CLEANED'
}
catch {
    Write-Output 'D7_SECRET_PREPARE_DIAGNOSTIC=RETURN'
    $code = [string]$_.Exception.Message
    if ($code -cmatch '^[A-Z][A-Z0-9_]{1,95}$') {
        Write-Output ('FAILURE_CODE=' + $code)
    }
    else {
        Write-Output ('FAILURE_CLASS=' + $_.Exception.GetType().Name)
        Write-Output 'FAILURE_CODE=UNCLASSIFIED'
    }
    exit 1
}
finally {
    $finished = [DateTimeOffset]::UtcNow
    Write-Output ('ROUND_FINISHED_AT=' + $finished.ToString('o'))
    Write-Output ('ACTUAL_ELAPSED=' + ($finished-$started).ToString('c'))
    Write-Output 'CLASH_PROFILE_IMPORT=NO'
    Write-Output 'TEMP_OUTER_ROUTE_CREATED=NO'
    Write-Output 'EXTERNAL_NETWORK_REQUESTS=0'
    Write-Output 'SYSTEM_PROXY_MUTATION=NO'
    Write-Output 'TUN_MUTATION=NO'
    Write-Output 'WIREGUARD_MUTATION=NO'
    Write-Output 'SECRET_VALUES_EMITTED=0'
}
