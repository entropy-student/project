[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$started = [DateTimeOffset]::UtcNow
Write-Output ('ROUND_STARTED_AT=' + $started.ToString('o'))

function Assert-D8R1 {
    param([bool]$Condition,[string]$Code)
    if (-not $Condition) { throw $Code }
}

function Test-HighIntegrity {
    $groups = (& whoami.exe /groups 2>&1) -join [Environment]::NewLine
    $match = [regex]::Match($groups,'S-1-16-(\d+)')
    return ($match.Success -and [int]$match.Groups[1].Value -ge 12288)
}

try {
    Assert-D8R1 ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
    Assert-D8R1 (Test-HighIntegrity) 'HIGH_INTEGRITY_REQUIRED'

    $principal = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
    Assert-D8R1 ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 'ADMINISTRATOR_REQUIRED'
    Write-Output 'OWNER_RUNTIME=PASS'

    $roamingRoot = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData)
    $roots = @(
        Get-ChildItem -LiteralPath $roamingRoot -Directory -Force -ErrorAction Stop |
        Where-Object { $_.Name -match '(?i)(?:clash.*verge|verge.*clash)' }
    )
    $stores = @(
        $roots |
        ForEach-Object { Join-Path $_.FullName 'profiles' } |
        Where-Object { Test-Path -LiteralPath $_ -PathType Container }
    )

    Assert-D8R1 (@($stores).Count -eq 1) 'CLASH_PROFILE_STORE_AMBIGUOUS'
    $clashAppRoot = Split-Path -Parent $stores[0]

    $rootLocks = @(
        Get-ChildItem -LiteralPath $clashAppRoot -File -Force -ErrorAction Stop |
        Where-Object { $_.Extension -ieq '.lock' }
    )

    Write-Output ('CLASH_ROOT_LOCK_COUNT=' + @($rootLocks).Count)
    Assert-D8R1 (@($rootLocks).Count -eq 1) 'CLASH_ROOT_LOCK_CARDINALITY_INVALID'

    $lock = $rootLocks[0]

    $isReparse = (($lock.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)
    Write-Output ('CLASH_ROOT_LOCK_REPARSE=' + $(if ($isReparse) { 'YES' } else { 'NO' }))
    Assert-D8R1 (-not $isReparse) 'CLASH_ROOT_LOCK_REPARSE_POINT'

    Write-Output ('CLASH_ROOT_LOCK_LENGTH=' + [long]$lock.Length)
    Assert-D8R1 ([long]$lock.Length -eq 0) 'CLASH_ROOT_LOCK_NONZERO_LENGTH'

    $readable = $true
    $errorClass = 'NONE'
    $stream = $null
    try {
        $stream = [IO.FileStream]::new(
            $lock.FullName,
            [IO.FileMode]::Open,
            [IO.FileAccess]::Read,
            ([IO.FileShare]::ReadWrite -bor [IO.FileShare]::Delete)
        )
    }
    catch {
        $readable = $false
        $errorClass = $_.Exception.GetType().Name
    }
    finally {
        if ($null -ne $stream) { $stream.Dispose() }
    }

    Write-Output ('CLASH_ROOT_LOCK_READABLE=' + $(if ($readable) { 'YES' } else { 'NO' }))
    Write-Output ('CLASH_ROOT_LOCK_READ_ERROR_CLASS=' + $errorClass)

    Assert-D8R1 (-not $readable) 'CLASH_ROOT_LOCK_UNEXPECTEDLY_READABLE'

    Write-Output 'D8R1_ZERO_LENGTH_ROOT_LOCK_CONFIRMED=PASS'
}
catch {
    Write-Output 'D8R1_ZERO_LENGTH_ROOT_LOCK_CONFIRMED=RETURN'
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
    $finished=[DateTimeOffset]::UtcNow
    Write-Output ('ROUND_FINISHED_AT=' + $finished.ToString('o'))
    Write-Output ('ACTUAL_ELAPSED=' + ($finished-$started).ToString('c'))
    Write-Output 'FILE_CONTENT_READ=NO'
    Write-Output 'DPAPI_UNPROTECT=NO'
    Write-Output 'REAL_SECRET_READ=NO'
    Write-Output 'CLASH_PROFILE_MUTATION=NO'
    Write-Output 'NETWORK_REQUESTS=0'
    Write-Output 'NETWORK_CHANGED=NO'
    Write-Output 'SECRET_VALUES_EMITTED=0'
}
