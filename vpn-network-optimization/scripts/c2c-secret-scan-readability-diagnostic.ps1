[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$started = [DateTimeOffset]::UtcNow
Write-Output ('ROUND_STARTED_AT=' + $started.ToString('o'))

$runtimeRoot = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'

function Assert-D8 {
    param([bool]$Condition,[string]$Code)
    if (-not $Condition) { throw $Code }
}

function Test-HighIntegrity {
    $groups = (& whoami.exe /groups 2>&1) -join [Environment]::NewLine
    $match = [regex]::Match($groups,'S-1-16-(\d+)')
    return ($match.Success -and [int]$match.Groups[1].Value -ge 12288)
}

function Get-SafeCategory {
    param([string]$Root,[string]$Path)

    $relative = [IO.Path]::GetRelativePath($Root,$Path).Replace('\','/')
    if ($relative -notmatch '/') { return 'ROOT_FILE' }

    $first = $relative.Split('/')[0]
    if ($first -cmatch '^[A-Za-z0-9._-]{1,32}$') { return $first }
    return 'OTHER'
}

function Test-ReadableToEnd {
    param([string]$Path)

    $stream = $null
    try {
        $stream = [IO.FileStream]::new(
            $Path,
            [IO.FileMode]::Open,
            [IO.FileAccess]::Read,
            ([IO.FileShare]::ReadWrite -bor [IO.FileShare]::Delete)
        )

        $buffer = [byte[]]::new(65536)
        while (($n = $stream.Read($buffer,0,$buffer.Length)) -gt 0) { }
        return [pscustomobject]@{ Pass=$true; ErrorClass='NONE' }
    }
    catch {
        return [pscustomobject]@{
            Pass=$false
            ErrorClass=$_.Exception.GetType().Name
        }
    }
    finally {
        if ($null -ne $stream) { $stream.Dispose() }
    }
}

function Invoke-RootReadability {
    param([string]$Label,[string]$Root)

    if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
        Write-Output ($Label + '_ROOT_PRESENT=NO')
        Write-Output ($Label + '_FILE_COUNT=0')
        Write-Output ($Label + '_READ_FAILURE_COUNT=0')
        return
    }

    Write-Output ($Label + '_ROOT_PRESENT=YES')

    $files = [Collections.Generic.List[object]]::new()
    $stack = [Collections.Generic.Stack[string]]::new()
    $stack.Push($Root)

    while ($stack.Count -gt 0) {
        $directory = $stack.Pop()

        foreach ($item in @(Get-ChildItem -LiteralPath $directory -Force -ErrorAction Stop)) {
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw ($Label + '_REPARSE_POINT_PRESENT')
            }

            if ($item.PSIsContainer) {
                $stack.Push($item.FullName)
            }
            else {
                $files.Add($item)
            }
        }
    }

    Write-Output ($Label + '_FILE_COUNT=' + $files.Count)

    $failures = [Collections.Generic.List[object]]::new()

    foreach ($file in $files) {
        $first = Test-ReadableToEnd -Path $file.FullName
        if (-not $first.Pass) {
            Start-Sleep -Milliseconds 100
            $second = Test-ReadableToEnd -Path $file.FullName

            $extension = [IO.Path]::GetExtension($file.Name)
            if ([string]::IsNullOrWhiteSpace($extension) -or $extension -notmatch '^\.[A-Za-z0-9]{1,12}$') {
                $extension = 'NONE_OR_OTHER'
            }

            $failures.Add([pscustomobject]@{
                Category = Get-SafeCategory -Root $Root -Path $file.FullName
                Extension = $extension
                FirstClass = $first.ErrorClass
                SecondClass = $second.ErrorClass
                Stable = (-not $second.Pass)
            })
        }
    }

    Write-Output ($Label + '_READ_FAILURE_COUNT=' + $failures.Count)

    $groups = @(
        $failures |
        Group-Object Category,Extension,FirstClass,SecondClass,Stable |
        Sort-Object Name
    )

    foreach ($group in $groups) {
        $sample = $group.Group[0]
        $stability = if ($sample.Stable) { 'STABLE' } else { 'TRANSIENT' }
        Write-Output (
            $Label + '_READ_FAILURE_CLASS=' +
            $sample.Category + '|' +
            $sample.Extension + '|' +
            $sample.FirstClass + '|' +
            $sample.SecondClass + '|' +
            $stability + '|COUNT=' + $group.Count
        )
    }
}

try {
    Assert-D8 ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
    Assert-D8 (Test-HighIntegrity) 'HIGH_INTEGRITY_REQUIRED'

    $principal = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
    Assert-D8 ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 'ADMINISTRATOR_REQUIRED'
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

    Assert-D8 (@($stores).Count -eq 1) 'CLASH_PROFILE_STORE_AMBIGUOUS'
    $clashAppRoot = Split-Path -Parent $stores[0]

    Invoke-RootReadability -Label 'CLASH_APP' -Root $clashAppRoot
    Invoke-RootReadability -Label 'PROJECT_RUNTIME' -Root $runtimeRoot

    Write-Output 'D8_SECRET_SCAN_READABILITY_DIAGNOSTIC=PASS'
}
catch {
    Write-Output 'D8_SECRET_SCAN_READABILITY_DIAGNOSTIC=RETURN'
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
    Write-Output 'DPAPI_UNPROTECT=NO'
    Write-Output 'REAL_SECRET_READ=NO'
    Write-Output 'FILE_CONTENT_EXPORTED=NO'
    Write-Output 'CLASH_PROFILE_MUTATION=NO'
    Write-Output 'NETWORK_REQUESTS=0'
    Write-Output 'NETWORK_CHANGED=NO'
    Write-Output 'SECRET_VALUES_EMITTED=0'
}
