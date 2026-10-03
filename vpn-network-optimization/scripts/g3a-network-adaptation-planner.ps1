[CmdletBinding()]
param(
    [switch]$SelfTest,
    [switch]$ReadOnlySnapshot,
    [ValidateSet('HEALTHY','UNHEALTHY','UNKNOWN')]
    [string]$WireGuardHealth = 'UNKNOWN',
    [ValidateSet('HEALTHY','UNHEALTHY','UNKNOWN')]
    [string]$Hy2Health = 'UNKNOWN',
    [ValidateSet('HEALTHY','UNHEALTHY','UNKNOWN')]
    [string]$RealityHealth = 'UNKNOWN',
    [string]$VpsPublicIp = '24.199.118.137'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Assert-G3a {
    param(
        [Parameter(Mandatory = $true)][bool]$Condition,
        [Parameter(Mandatory = $true)][string]$Code
    )
    if (-not $Condition) { throw $Code }
}

function Test-G3aIPv4 {
    param([Parameter(Mandatory = $true)][string]$Value)
    $parsed = [Net.IPAddress]::None
    if (-not [Net.IPAddress]::TryParse($Value, [ref]$parsed)) { return $false }
    return $parsed.AddressFamily -eq [Net.Sockets.AddressFamily]::InterNetwork
}

function Resolve-G3aPhysicalEgress {
    param([Parameter(Mandatory = $true)][AllowEmptyCollection()][object[]]$Candidates)

    $valid = @(
        $Candidates | Where-Object {
            $null -ne $_ -and
            $_.PSObject.Properties.Name -contains 'Physical' -and
            $_.PSObject.Properties.Name -contains 'Status' -and
            $_.PSObject.Properties.Name -contains 'Alias' -and
            $_.PSObject.Properties.Name -contains 'InterfaceIndex' -and
            $_.PSObject.Properties.Name -contains 'Gateway' -and
            $_.PSObject.Properties.Name -contains 'SourceIPv4' -and
            $_.PSObject.Properties.Name -contains 'DefaultRouteMatch' -and
            [bool]$_.Physical -and
            [string]$_.Status -eq 'Up' -and
            [int]$_.InterfaceIndex -gt 0 -and
            -not [string]::IsNullOrWhiteSpace([string]$_.Alias) -and
            [string]$_.Alias -ne 'SFO2-A' -and
            [bool]$_.DefaultRouteMatch -and
            (Test-G3aIPv4 -Value ([string]$_.Gateway)) -and
            (Test-G3aIPv4 -Value ([string]$_.SourceIPv4)) -and
            [string]$_.Gateway -ne '0.0.0.0' -and
            [string]$_.SourceIPv4 -ne '0.0.0.0'
        }
    )

    if ($valid.Count -eq 0) { throw 'PHYSICAL_EGRESS_MISSING' }
    if ($valid.Count -ne 1) { throw 'PHYSICAL_EGRESS_AMBIGUOUS' }

    return [pscustomobject]@{
        Alias = [string]$valid[0].Alias
        InterfaceIndex = [int]$valid[0].InterfaceIndex
        Gateway = [string]$valid[0].Gateway
        SourceIPv4 = [string]$valid[0].SourceIPv4
    }
}

function Resolve-G3aRolePlan {
    param(
        [Parameter(Mandatory = $true)][object]$PhysicalEgress,
        [Parameter(Mandatory = $true)][ValidateSet('HEALTHY','UNHEALTHY','UNKNOWN')][string]$WireGuard,
        [Parameter(Mandatory = $true)][ValidateSet('HEALTHY','UNHEALTHY','UNKNOWN')][string]$Hy2,
        [Parameter(Mandatory = $true)][ValidateSet('HEALTHY','UNHEALTHY','UNKNOWN')][string]$Reality,
        [Parameter(Mandatory = $true)][string]$PublicIp
    )

    Assert-G3a (Test-G3aIPv4 -Value $PublicIp) 'VPS_PUBLIC_IP_INVALID'

    if ($WireGuard -eq 'UNKNOWN') { throw 'HEALTH_STATE_AMBIGUOUS_WIREGUARD' }

    if ($WireGuard -eq 'HEALTHY') {
        $selectedRole = 'WIREGUARD_BASELINE'
        $reason = 'CURRENT_PRODUCTION_BASELINE_HEALTHY'
    }
    else {
        if ($Hy2 -eq 'UNKNOWN') { throw 'HEALTH_STATE_AMBIGUOUS_HY2' }
        if ($Hy2 -eq 'HEALTHY') {
            $selectedRole = 'HY2_FALLBACK_CANDIDATE'
            $reason = 'WIREGUARD_UNHEALTHY_HY2_HEALTHY'
        }
        else {
            if ($Reality -eq 'UNKNOWN') { throw 'HEALTH_STATE_AMBIGUOUS_REALITY' }
            if ($Reality -eq 'HEALTHY') {
                $selectedRole = 'REALITY_FALLBACK_CANDIDATE'
                $reason = 'WIREGUARD_AND_HY2_UNHEALTHY_REALITY_HEALTHY'
            }
            else {
                throw 'NO_SAFE_ROLE_AVAILABLE'
            }
        }
    }

    $needsBypass = $selectedRole -in @('HY2_FALLBACK_CANDIDATE','REALITY_FALLBACK_CANDIDATE')
    if ($needsBypass) {
        $routeIntent = [ordered]@{
            Required = $true
            DestinationPrefix = "$PublicIp/32"
            InterfaceAlias = $PhysicalEgress.Alias
            InterfaceIndex = $PhysicalEgress.InterfaceIndex
            NextHop = $PhysicalEgress.Gateway
            ApplyAllowed = $false
        }
    }
    else {
        $routeIntent = [ordered]@{
            Required = $false
            DestinationPrefix = 'NONE'
            InterfaceAlias = 'NONE'
            InterfaceIndex = 0
            NextHop = 'NONE'
            ApplyAllowed = $false
        }
    }

    return [pscustomobject]@{
        PolicyMode = 'BASELINE_SAFE'
        AdvisoryOnly = $true
        ProductionDefaultChangeAllowed = $false
        SelectedRole = $selectedRole
        Reason = $reason
        PhysicalEgress = [ordered]@{
            Alias = $PhysicalEgress.Alias
            InterfaceIndex = $PhysicalEgress.InterfaceIndex
            Gateway = $PhysicalEgress.Gateway
            SourceIPv4 = $PhysicalEgress.SourceIPv4
        }
        RouteIntent = $routeIntent
        Health = [ordered]@{
            WireGuard = $WireGuard
            Hy2 = $Hy2
            Reality = $Reality
        }
    }
}

function Get-G3aReadOnlyPhysicalCandidates {
    $candidates = [Collections.Generic.List[object]]::new()

    foreach ($adapter in @(Get-NetAdapter -Physical -ErrorAction Stop)) {
        if ([string]$adapter.Status -ne 'Up') { continue }

        $ifIndex = [int]$adapter.ifIndex
        $cfg = Get-NetIPConfiguration -InterfaceIndex $ifIndex -ErrorAction Stop
        $gateways = @($cfg.IPv4DefaultGateway | Where-Object { $null -ne $_ -and -not [string]::IsNullOrWhiteSpace([string]$_.NextHop) })
        $addresses = @($cfg.IPv4Address | Where-Object { $null -ne $_ -and -not [string]::IsNullOrWhiteSpace([string]$_.IPAddress) })
        if ($gateways.Count -ne 1 -or $addresses.Count -ne 1) { continue }

        $gateway = [string]$gateways[0].NextHop
        $source = [string]$addresses[0].IPAddress
        $defaults = @(Get-NetRoute -AddressFamily IPv4 -PolicyStore ActiveStore -DestinationPrefix '0.0.0.0/0' -ErrorAction Stop |
            Where-Object { [int]$_.InterfaceIndex -eq $ifIndex -and [string]$_.NextHop -eq $gateway })

        $candidates.Add([pscustomobject]@{
            Physical = $true
            Status = [string]$adapter.Status
            Alias = [string]$adapter.Name
            InterfaceIndex = $ifIndex
            Gateway = $gateway
            SourceIPv4 = $source
            DefaultRouteMatch = ($defaults.Count -eq 1)
        })
    }

    return @($candidates)
}

function Invoke-G3aExpectedFailure {
    param(
        [Parameter(Mandatory = $true)][scriptblock]$Action,
        [Parameter(Mandatory = $true)][string]$ExpectedCode
    )
    try {
        & $Action
        throw "EXPECTED_FAILURE_NOT_RAISED_$ExpectedCode"
    }
    catch {
        if ([string]$_.Exception.Message -ne $ExpectedCode) { throw }
    }
}

function Invoke-G3aSelfTest {
    $passed = 0

    $valid = [pscustomobject]@{
        Physical = $true
        Status = 'Up'
        Alias = 'FixtureEthernet'
        InterfaceIndex = 41
        Gateway = '198.51.100.1'
        SourceIPv4 = '198.51.100.20'
        DefaultRouteMatch = $true
    }
    $egress = Resolve-G3aPhysicalEgress -Candidates @($valid)
    Assert-G3a ($egress.Alias -eq 'FixtureEthernet' -and $egress.InterfaceIndex -eq 41) 'SELFTEST_VALID_EGRESS_FAILED'
    $passed++

    $other = [pscustomobject]@{
        Physical = $true
        Status = 'Up'
        Alias = 'FixtureWifi'
        InterfaceIndex = 42
        Gateway = '203.0.113.1'
        SourceIPv4 = '203.0.113.20'
        DefaultRouteMatch = $true
    }
    Invoke-G3aExpectedFailure -ExpectedCode 'PHYSICAL_EGRESS_AMBIGUOUS' -Action {
        $null = Resolve-G3aPhysicalEgress -Candidates @($valid,$other)
    }
    $passed++

    Invoke-G3aExpectedFailure -ExpectedCode 'PHYSICAL_EGRESS_MISSING' -Action {
        $null = Resolve-G3aPhysicalEgress -Candidates @()
    }
    $passed++

    $wg = Resolve-G3aRolePlan -PhysicalEgress $egress -WireGuard HEALTHY -Hy2 HEALTHY -Reality HEALTHY -PublicIp '203.0.113.10'
    Assert-G3a ($wg.SelectedRole -eq 'WIREGUARD_BASELINE' -and -not $wg.RouteIntent.Required) 'SELFTEST_WG_BASELINE_FAILED'
    $passed++

    $hy2 = Resolve-G3aRolePlan -PhysicalEgress $egress -WireGuard UNHEALTHY -Hy2 HEALTHY -Reality HEALTHY -PublicIp '203.0.113.10'
    Assert-G3a ($hy2.SelectedRole -eq 'HY2_FALLBACK_CANDIDATE' -and $hy2.RouteIntent.Required -and -not $hy2.RouteIntent.ApplyAllowed) 'SELFTEST_HY2_FALLBACK_FAILED'
    $passed++

    $reality = Resolve-G3aRolePlan -PhysicalEgress $egress -WireGuard UNHEALTHY -Hy2 UNHEALTHY -Reality HEALTHY -PublicIp '203.0.113.10'
    Assert-G3a ($reality.SelectedRole -eq 'REALITY_FALLBACK_CANDIDATE' -and $reality.RouteIntent.Required -and -not $reality.RouteIntent.ApplyAllowed) 'SELFTEST_REALITY_FALLBACK_FAILED'
    $passed++

    Invoke-G3aExpectedFailure -ExpectedCode 'NO_SAFE_ROLE_AVAILABLE' -Action {
        $null = Resolve-G3aRolePlan -PhysicalEgress $egress -WireGuard UNHEALTHY -Hy2 UNHEALTHY -Reality UNHEALTHY -PublicIp '203.0.113.10'
    }
    $passed++

    Invoke-G3aExpectedFailure -ExpectedCode 'HEALTH_STATE_AMBIGUOUS_WIREGUARD' -Action {
        $null = Resolve-G3aRolePlan -PhysicalEgress $egress -WireGuard UNKNOWN -Hy2 HEALTHY -Reality HEALTHY -PublicIp '203.0.113.10'
    }
    $passed++

    Invoke-G3aExpectedFailure -ExpectedCode 'HEALTH_STATE_AMBIGUOUS_HY2' -Action {
        $null = Resolve-G3aRolePlan -PhysicalEgress $egress -WireGuard UNHEALTHY -Hy2 UNKNOWN -Reality HEALTHY -PublicIp '203.0.113.10'
    }
    $passed++

    Write-Output "G3A_SELFTEST_CASES=$passed"
    Write-Output 'G3A_SELFTEST_RESULT=PASS'
    Write-Output 'PLANNER_MODE=ADVISORY_ONLY'
    Write-Output 'NETWORK_MUTATION=NO'
    Write-Output 'SERVICE_MUTATION=NO'
    Write-Output 'SYSTEM_PROXY_MUTATION=NO'
    Write-Output 'TUN_MUTATION=NO'
    Write-Output 'VPS_MUTATION=NO'
    Write-Output 'SECRET_VALUES_READ=0'
    Write-Output 'SECRET_VALUES_EMITTED=0'
}

if ($SelfTest -and $ReadOnlySnapshot) { throw 'MODE_CONFLICT' }
if (-not $SelfTest -and -not $ReadOnlySnapshot) { throw 'MODE_REQUIRED' }

if ($SelfTest) {
    Invoke-G3aSelfTest
    exit 0
}

$candidates = Get-G3aReadOnlyPhysicalCandidates
$physicalEgress = Resolve-G3aPhysicalEgress -Candidates $candidates
$plan = Resolve-G3aRolePlan -PhysicalEgress $physicalEgress -WireGuard $WireGuardHealth -Hy2 $Hy2Health -Reality $RealityHealth -PublicIp $VpsPublicIp

$plan | ConvertTo-Json -Depth 6
Write-Output 'PLANNER_MODE=READ_ONLY_SNAPSHOT'
Write-Output 'NETWORK_MUTATION=NO'
Write-Output 'SERVICE_MUTATION=NO'
Write-Output 'SYSTEM_PROXY_MUTATION=NO'
Write-Output 'TUN_MUTATION=NO'
Write-Output 'VPS_MUTATION=NO'
Write-Output 'SECRET_VALUES_READ=0'
Write-Output 'SECRET_VALUES_EMITTED=0'
