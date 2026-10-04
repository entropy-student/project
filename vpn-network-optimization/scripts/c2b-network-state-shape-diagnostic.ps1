[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$started = [DateTimeOffset]::UtcNow
Write-Output ('ROUND_STARTED_AT=' + $started.ToString('o'))

function Test-PropertyShape {
    param(
        [string]$Label,
        [object[]]$Objects,
        [string[]]$Properties
    )

    $items = @($Objects)
    Write-Output ($Label + '_COUNT=' + $items.Count)

    foreach ($property in $Properties) {
        $missing = 0
        foreach ($item in $items) {
            if ($null -eq $item) {
                $missing++
                continue
            }
            $names = @($item.PSObject.Properties.Name)
            if ($names -cnotcontains $property) { $missing++ }
        }
        Write-Output ($Label + '_PROP_' + $property.ToUpperInvariant() + '_MISSING=' + $missing)
    }
}

try {
    Write-Output ('POWERSHELL_VERSION=' + $PSVersionTable.PSVersion.ToString())

    $principal = [Security.Principal.WindowsPrincipal](
        [Security.Principal.WindowsIdentity]::GetCurrent()
    )
    Write-Output ('ADMINISTRATOR=' + $principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    ))

    $groups = (& whoami.exe /groups 2>&1) -join [Environment]::NewLine
    $integrityMatch = [regex]::Match($groups, 'S-1-16-(\d+)')
    if ($integrityMatch.Success) {
        Write-Output ('INTEGRITY_RID=' + $integrityMatch.Groups[1].Value)
    }
    else {
        Write-Output 'INTEGRITY_RID=UNKNOWN'
    }

    $manager = @(Get-Service -Name 'WireGuardManager' -ErrorAction Stop)
    Test-PropertyShape -Label 'WG_MANAGER' -Objects $manager -Properties @('Status')

    $tunnel = @(Get-Service -Name 'WireGuardTunnel$SFO2-A' -ErrorAction Stop)
    Test-PropertyShape -Label 'WG_TUNNEL' -Objects $tunnel -Properties @('Status')

    $wgAdapter = @(Get-NetAdapter -Name 'SFO2-A' -ErrorAction Stop)
    Test-PropertyShape -Label 'WG_ADAPTER' -Objects $wgAdapter -Properties @('Status','Name','InterfaceDescription')

    $proxy = @(Get-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -ErrorAction Stop)
    Test-PropertyShape -Label 'INET_SETTINGS' -Objects $proxy -Properties @('ProxyEnable')

    $allAdapters = @(Get-NetAdapter -IncludeHidden -ErrorAction Stop)
    Test-PropertyShape -Label 'ALL_ADAPTERS' -Objects $allAdapters -Properties @('Status','Name','InterfaceDescription')

    $routes = @(Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -ErrorAction Stop)
    Test-PropertyShape -Label 'IPV4_ACTIVE_ROUTES' -Objects $routes -Properties @(
        'DestinationPrefix',
        'NextHop',
        'InterfaceIndex',
        'RouteMetric',
        'PolicyStore'
    )

    Write-Output 'DIAGNOSTIC_RESULT=PASS_READONLY_OBJECT_SHAPE_CAPTURED'
}
catch {
    Write-Output 'DIAGNOSTIC_RESULT=RETURN'
    Write-Output ('FAILURE_CLASS=' + $_.Exception.GetType().Name)
    $safe = [string]$_.Exception.Message
    if ($safe -cmatch '^[A-Za-z0-9_ .:$\\/-]{1,180}$') {
        Write-Output ('FAILURE_MESSAGE=' + $safe)
    }
    else {
        Write-Output 'FAILURE_MESSAGE=REDACTED_UNCLASSIFIED'
    }
    exit 1
}
finally {
    $finished = [DateTimeOffset]::UtcNow
    Write-Output ('ROUND_FINISHED_AT=' + $finished.ToString('o'))
    Write-Output ('ACTUAL_ELAPSED=' + ($finished - $started).ToString('c'))
    Write-Output 'NETWORK_MUTATION=NONE'
    Write-Output 'SECRET_VALUES_EMITTED=0'
}
