[CmdletBinding()]
param(
    [switch]$SelfTest,
    [switch]$RunReadOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$collectorPath = Join-Path $PSScriptRoot 'g3a-health-readiness-readonly.ps1'
$plannerPath = Join-Path $PSScriptRoot 'g3a-network-adaptation-planner.ps1'

function Assert-H4 {
    param(
        [Parameter(Mandatory = $true)][bool]$Condition,
        [Parameter(Mandatory = $true)][string]$Code
    )
    if (-not $Condition) { throw $Code }
}

function Convert-H4KeyValueOutput {
    param([Parameter(Mandatory = $true)][AllowEmptyCollection()][object[]]$Output)

    $values = @{}
    foreach ($item in $Output) {
        if ($null -eq $item) { continue }
        foreach ($line in ([string]$item -split "\r?\n")) {
            if ($line -match '^([A-Z0-9_]+)=(.*)$') {
                $values[$Matches[1]] = $Matches[2]
            }
        }
    }
    return $values
}

function Get-H4CollectorState {
    param([Parameter(Mandatory = $true)][AllowEmptyCollection()][object[]]$Output)

    $values = Convert-H4KeyValueOutput -Output $Output

    Assert-H4 ($values.ContainsKey('G3A_H2_READONLY_RESULT')) 'H2_COMPLETE_MARKER_MISSING'
    Assert-H4 ($values['G3A_H2_READONLY_RESULT'] -eq 'COMPLETE') 'H2_NOT_COMPLETE'

    foreach ($key in @(
        'WIREGUARD_CURRENT_HEALTH',
        'HY2_READINESS',
        'REALITY_READINESS',
        'EXTERNAL_WORKLOAD_REQUEST_COUNT',
        'NETWORK_MUTATION',
        'SERVICE_MUTATION',
        'SYSTEM_PROXY_MUTATION',
        'TUN_MUTATION',
        'VPS_MUTATION',
        'VPN_APPLICATION_SECRET_VALUES_READ',
        'SECRET_VALUES_EMITTED'
    )) {
        Assert-H4 ($values.ContainsKey($key)) "H2_REQUIRED_KEY_MISSING_$key"
    }

    Assert-H4 ($values['WIREGUARD_CURRENT_HEALTH'] -in @('HEALTHY','UNHEALTHY','UNKNOWN')) 'H2_WG_ENUM_INVALID'
    Assert-H4 ($values['HY2_READINESS'] -in @('READY_FOR_SEPARATE_ACTIVATION','NOT_READY','UNKNOWN')) 'H2_HY2_ENUM_INVALID'
    Assert-H4 ($values['REALITY_READINESS'] -in @('READY_FOR_SEPARATE_ACTIVATION','NOT_READY','UNKNOWN')) 'H2_REALITY_ENUM_INVALID'

    Assert-H4 ($values['EXTERNAL_WORKLOAD_REQUEST_COUNT'] -eq '0') 'H2_EXTERNAL_REQUEST_OCCURRED'
    foreach ($key in @('NETWORK_MUTATION','SERVICE_MUTATION','SYSTEM_PROXY_MUTATION','TUN_MUTATION','VPS_MUTATION')) {
        Assert-H4 ($values[$key] -eq 'NO') "H2_MUTATION_MARKER_INVALID_$key"
    }
    Assert-H4 ($values['VPN_APPLICATION_SECRET_VALUES_READ'] -eq '0') 'H2_APPLICATION_SECRET_READ_OCCURRED'
    Assert-H4 ($values['SECRET_VALUES_EMITTED'] -eq '0') 'H2_SECRET_EMISSION_OCCURRED'

    return [pscustomobject]@{
        WireGuardCurrentHealth = [string]$values['WIREGUARD_CURRENT_HEALTH']
        Hy2Readiness = [string]$values['HY2_READINESS']
        RealityReadiness = [string]$values['REALITY_READINESS']
    }
}

function Get-H4PlannerDecision {
    param([Parameter(Mandatory = $true)][AllowEmptyCollection()][object[]]$Output)

    $jsonCandidate = $null
    foreach ($item in $Output) {
        if ($null -eq $item) { continue }
        $text = [string]$item
        if ($text.TrimStart().StartsWith('{')) {
            $jsonCandidate = $text
            break
        }
    }
    Assert-H4 (-not [string]::IsNullOrWhiteSpace($jsonCandidate)) 'PLANNER_JSON_MISSING'

    try {
        $plan = $jsonCandidate | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        throw 'PLANNER_JSON_INVALID'
    }

    Assert-H4 ($plan.AdvisoryOnly -eq $true) 'PLANNER_NOT_ADVISORY_ONLY'
    Assert-H4 ($plan.ProductionDefaultChangeAllowed -eq $false) 'PLANNER_DEFAULT_CHANGE_ALLOWED'
    Assert-H4 ($null -ne $plan.RouteIntent) 'PLANNER_ROUTE_INTENT_MISSING'
    Assert-H4 ($plan.RouteIntent.ApplyAllowed -eq $false) 'PLANNER_ROUTE_APPLY_ALLOWED'
    Assert-H4 ($plan.SelectedRole -in @('WIREGUARD_BASELINE','HY2_FALLBACK_CANDIDATE','REALITY_FALLBACK_CANDIDATE')) 'PLANNER_ROLE_INVALID'

    return $plan
}

function Invoke-H4ExpectedFailure {
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

function Invoke-H4SelfTest {
    $passed = 0

    $complete = @(
        'WIREGUARD_CURRENT_HEALTH=HEALTHY',
        'HY2_READINESS=READY_FOR_SEPARATE_ACTIVATION',
        'REALITY_READINESS=READY_FOR_SEPARATE_ACTIVATION',
        'EXTERNAL_WORKLOAD_REQUEST_COUNT=0',
        'NETWORK_MUTATION=NO',
        'SERVICE_MUTATION=NO',
        'SYSTEM_PROXY_MUTATION=NO',
        'TUN_MUTATION=NO',
        'VPS_MUTATION=NO',
        'VPN_APPLICATION_SECRET_VALUES_READ=0',
        'SECRET_VALUES_EMITTED=0',
        'G3A_H2_READONLY_RESULT=COMPLETE'
    )
    $state = Get-H4CollectorState -Output $complete
    Assert-H4 ($state.WireGuardCurrentHealth -eq 'HEALTHY') 'SELFTEST_COMPLETE_STATE_FAILED'
    $passed++

    $missing = @($complete | Where-Object { $_ -notlike 'HY2_READINESS=*' })
    Invoke-H4ExpectedFailure -ExpectedCode 'H2_REQUIRED_KEY_MISSING_HY2_READINESS' -Action {
        $null = Get-H4CollectorState -Output $missing
    }
    $passed++

    $incomplete = @($complete | Where-Object { $_ -ne 'G3A_H2_READONLY_RESULT=COMPLETE' })
    Invoke-H4ExpectedFailure -ExpectedCode 'H2_COMPLETE_MARKER_MISSING' -Action {
        $null = Get-H4CollectorState -Output $incomplete
    }
    $passed++

    $invalid = @($complete | ForEach-Object {
        if ($_ -like 'REALITY_READINESS=*') { 'REALITY_READINESS=READYISH' } else { $_ }
    })
    Invoke-H4ExpectedFailure -ExpectedCode 'H2_REALITY_ENUM_INVALID' -Action {
        $null = Get-H4CollectorState -Output $invalid
    }
    $passed++

    $goodPlan = @(
        @'
{
  "PolicyMode": "BASELINE_SAFE",
  "AdvisoryOnly": true,
  "ProductionDefaultChangeAllowed": false,
  "SelectedRole": "WIREGUARD_BASELINE",
  "Reason": "CURRENT_PRODUCTION_BASELINE_HEALTHY",
  "PhysicalEgress": {
    "Alias": "FixtureEthernet",
    "InterfaceIndex": 41,
    "Gateway": "198.51.100.1",
    "SourceIPv4": "198.51.100.20"
  },
  "RouteIntent": {
    "Required": false,
    "DestinationPrefix": "NONE",
    "InterfaceAlias": "NONE",
    "InterfaceIndex": 0,
    "NextHop": "NONE",
    "ApplyAllowed": false
  }
}
'@,
        'PLANNER_MODE=READ_ONLY_SNAPSHOT',
        'NETWORK_MUTATION=NO'
    )
    $plan = Get-H4PlannerDecision -Output $goodPlan
    Assert-H4 ($plan.SelectedRole -eq 'WIREGUARD_BASELINE') 'SELFTEST_GOOD_PLAN_FAILED'
    $passed++

    $unsafePlan = @(
        @'
{
  "PolicyMode": "BASELINE_SAFE",
  "AdvisoryOnly": false,
  "ProductionDefaultChangeAllowed": false,
  "SelectedRole": "WIREGUARD_BASELINE",
  "RouteIntent": {
    "ApplyAllowed": false
  }
}
'@
    )
    Invoke-H4ExpectedFailure -ExpectedCode 'PLANNER_NOT_ADVISORY_ONLY' -Action {
        $null = Get-H4PlannerDecision -Output $unsafePlan
    }
    $passed++

    Write-Output "H4_SELFTEST_CASES=$passed"
    Write-Output 'H4_SELFTEST_RESULT=PASS'
    Write-Output 'NETWORK_MUTATION=NO'
    Write-Output 'SERVICE_MUTATION=NO'
    Write-Output 'SYSTEM_PROXY_MUTATION=NO'
    Write-Output 'TUN_MUTATION=NO'
    Write-Output 'VPS_MUTATION=NO'
    Write-Output 'EXTERNAL_WORKLOAD_REQUEST_COUNT=0'
    Write-Output 'SECRET_VALUES_READ=0'
    Write-Output 'SECRET_VALUES_EMITTED=0'
}

if ($SelfTest -and $RunReadOnly) { throw 'MODE_CONFLICT' }
if (-not $SelfTest -and -not $RunReadOnly) { throw 'MODE_REQUIRED' }

Assert-H4 (Test-Path -LiteralPath $collectorPath -PathType Leaf) 'H2_COLLECTOR_MISSING'
Assert-H4 (Test-Path -LiteralPath $plannerPath -PathType Leaf) 'H3_PLANNER_MISSING'

if ($SelfTest) {
    Invoke-H4SelfTest
    exit 0
}

Write-Output 'PHASE=H2_COLLECT'
$collectorOutput = @(& $collectorPath -ValidateAndCollect)
$state = Get-H4CollectorState -Output $collectorOutput

Write-Output 'PHASE=H3_PLAN'
$plannerArgs = @{
    ReadOnlySnapshot = $true
    WireGuardHealth = $state.WireGuardCurrentHealth
    Hy2Readiness = $state.Hy2Readiness
    RealityReadiness = $state.RealityReadiness
}
$plannerOutput = @(& $plannerPath @plannerArgs)
$plan = Get-H4PlannerDecision -Output $plannerOutput

Write-Output 'PHASE=INTEGRATED_RESULT'
Write-Output "INTEGRATED_WIREGUARD_CURRENT_HEALTH=$($state.WireGuardCurrentHealth)"
Write-Output "INTEGRATED_HY2_READINESS=$($state.Hy2Readiness)"
Write-Output "INTEGRATED_REALITY_READINESS=$($state.RealityReadiness)"
Write-Output "ADVISORY_SELECTED_ROLE=$($plan.SelectedRole)"
Write-Output "ADVISORY_REASON=$($plan.Reason)"
Write-Output "ADVISORY_ROUTE_REQUIRED=$($plan.RouteIntent.Required.ToString().ToUpperInvariant())"
Write-Output "ADVISORY_ROUTE_APPLY_ALLOWED=$($plan.RouteIntent.ApplyAllowed.ToString().ToUpperInvariant())"
Write-Output "ADVISORY_ONLY=$($plan.AdvisoryOnly.ToString().ToUpperInvariant())"
Write-Output "PRODUCTION_DEFAULT_CHANGE_ALLOWED=$($plan.ProductionDefaultChangeAllowed.ToString().ToUpperInvariant())"
Write-Output 'EXTERNAL_WORKLOAD_REQUEST_COUNT=0'
Write-Output 'NETWORK_MUTATION=NO'
Write-Output 'SERVICE_MUTATION=NO'
Write-Output 'SYSTEM_PROXY_MUTATION=NO'
Write-Output 'TUN_MUTATION=NO'
Write-Output 'VPS_MUTATION=NO'
Write-Output 'VPN_APPLICATION_SECRET_VALUES_READ=0'
Write-Output 'SECRET_VALUES_EMITTED=0'
Write-Output 'G3A_H4_INTEGRATED_RESULT=COMPLETE'
