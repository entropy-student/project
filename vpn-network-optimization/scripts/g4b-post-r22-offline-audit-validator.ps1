[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'

$runnerPath=Join-Path $PSScriptRoot 'g4b-persistent-three-role-live-runner.ps1'
$runner=[IO.File]::ReadAllText($runnerPath,[Text.Encoding]::UTF8)

function Assert-Audit {
    param([bool]$Condition,[string]$Name)
    if(-not $Condition){throw ('R22R6_AUDIT_FAILED_'+$Name)}
    Write-Output ('R22R6_'+$Name+'=PASS')
}

$tokens=$null;$errors=$null
$ast=[System.Management.Automation.Language.Parser]::ParseFile($runnerPath,[ref]$tokens,[ref]$errors)
Assert-Audit ($errors.Count -eq 0) 'RUNNER_AST'

$selfTokens=$null;$selfErrors=$null
[void][System.Management.Automation.Language.Parser]::ParseFile($PSCommandPath,[ref]$selfTokens,[ref]$selfErrors)
Assert-Audit ($selfErrors.Count -eq 0) 'AUDIT_VALIDATOR_AST'

$supervisorStart=$runner.IndexOf('function Get-RemoteSupervisor {',[StringComparison]::Ordinal)
$supervisorEnd=$runner.IndexOf("'@",$supervisorStart,[StringComparison]::Ordinal)
Assert-Audit ($supervisorStart -ge 0 -and $supervisorEnd -gt $supervisorStart) 'REMOTE_SUPERVISOR_FOUND'
$remote=$runner.Substring($supervisorStart,$supervisorEnd-$supervisorStart)

$readinessSource=(
    $remote.Contains('def get_reality_service_state():') -and
    $remote.Contains('def get_reality_listener_state():') -and
    $remote.Contains('def wait_reality_ready(timeout=15.0,interval=0.25):') -and
    $remote.Contains('deadline=time.monotonic()+timeout') -and
    $remote.Contains("if listener=='foreign': raise GateError('REALITY_LISTENER_OWNERSHIP_MISMATCH')") -and
    $remote.Contains("if service['ActiveState']=='failed': raise GateError('REALITY_SERVICE_FAILED')") -and
    $remote.Contains("if service['ActiveState']!='active': raise GateError('REALITY_SERVICE_READINESS_TIMEOUT')") -and
    $remote.Contains("raise GateError('REALITY_LISTENER_READINESS_TIMEOUT')") -and
    $remote.Contains("return wait_reality_ready()") -and
    ([regex]::Matches($remote,'return wait_reality_ready\(\)').Count -eq 2)
)
Assert-Audit $readinessSource 'READINESS_SOURCE_CONTRACT'

function Get-ReadinessFixtureResult {
    param([object[]]$Samples)
    foreach($sample in $Samples){
        if($sample.ActiveState -ceq 'active' -and $sample.Listener -ceq 'mihomo'){return 'PASS'}
        if($sample.Listener -ceq 'foreign'){return 'OWNERSHIP'}
    }
    $last=$Samples[-1]
    if($last.ActiveState -ceq 'failed'){return 'SERVICE_FAILED'}
    if($last.ActiveState -cne 'active'){return 'SERVICE_TIMEOUT'}
    return 'LISTENER_TIMEOUT'
}

Assert-Audit ((Get-ReadinessFixtureResult @(
    [pscustomobject]@{ActiveState='activating';Listener='absent'},
    [pscustomobject]@{ActiveState='active';Listener='absent'},
    [pscustomobject]@{ActiveState='active';Listener='mihomo'}
)) -ceq 'PASS') 'READINESS_DELAYED_LISTENER_POSITIVE'

Assert-Audit ((Get-ReadinessFixtureResult @(
    [pscustomobject]@{ActiveState='active';Listener='absent'},
    [pscustomobject]@{ActiveState='active';Listener='absent'}
)) -ceq 'LISTENER_TIMEOUT') 'READINESS_LISTENER_TIMEOUT_NEGATIVE'

Assert-Audit ((Get-ReadinessFixtureResult @(
    [pscustomobject]@{ActiveState='activating';Listener='absent'},
    [pscustomobject]@{ActiveState='failed';Listener='absent'}
)) -ceq 'SERVICE_FAILED') 'READINESS_SERVICE_FAILED_NEGATIVE'

Assert-Audit ((Get-ReadinessFixtureResult @(
    [pscustomobject]@{ActiveState='active';Listener='foreign'}
)) -ceq 'OWNERSHIP') 'READINESS_FOREIGN_LISTENER_NEGATIVE'

Assert-Audit ((Get-ReadinessFixtureResult @(
    [pscustomobject]@{ActiveState='activating';Listener='absent'}
)) -ceq 'SERVICE_TIMEOUT') 'READINESS_SERVICE_TIMEOUT_NEGATIVE'

$rollbackStart=$remote.IndexOf('def rollback():',[StringComparison]::Ordinal)
$rollbackEnd=$remote.IndexOf('def closeout():',$rollbackStart,[StringComparison]::Ordinal)
Assert-Audit ($rollbackStart -ge 0 -and $rollbackEnd -gt $rollbackStart) 'ROLLBACK_SOURCE_FOUND'
$rollback=$remote.Substring($rollbackStart,$rollbackEnd-$rollbackStart)
$rollbackContract=(
    $rollback.Contains("disable_result=subprocess.run(['systemctl','disable','--now',SERVICE]") -and
    $rollback.Contains("['systemctl','is-active',SERVICE]") -and
    $rollback.Contains("['systemctl','is-enabled',SERVICE]") -and
    $rollback.Contains("'ROLLBACK_SERVICE_STOP_UNVERIFIED'") -and
    $rollback.Contains("'ROLLBACK_SERVICE_DISABLE_UNVERIFIED'") -and
    $rollback.Contains("error_code='ROLLBACK_DAEMON_RELOAD_FAILED'") -and
    $rollback.Contains("error_code='ROLLBACK_USER_DELETE_FAILED'") -and
    $rollback.Contains("error_code='ROLLBACK_GROUP_DELETE_FAILED'") -and
    -not $rollback.Contains("run(['systemctl','disable','--now',SERVICE]")
)
Assert-Audit $rollbackContract 'ROLLBACK_SYSTEMD_POSTCONDITION_CONTRACT'

function Normalize-IptablesFixture {
    param([string[]]$Lines)
    $result=[Collections.Generic.List[string]]::new()
    foreach($raw in $Lines){
        if([string]::IsNullOrWhiteSpace($raw) -or $raw.StartsWith('#',[StringComparison]::Ordinal)){continue}
        $line=[regex]::Replace($raw.Trim(),'^\[\d+:\d+\](?=\s)','')
        if($line.StartsWith(':',[StringComparison]::Ordinal)){
            $line=[regex]::Replace($line,'\s+\[\d+:\d+\]\s*$','')
        }
        $result.Add($line)
    }
    return @($result)
}

$iptablesBase=@(':INPUT ACCEPT [0:0]',':FORWARD DROP [1:2]','[3:4] -A INPUT -p tcp --dport 22 -j ACCEPT')
$iptablesTelemetry=@(':INPUT ACCEPT [99:999]',':FORWARD DROP [7:8]','[100:200] -A INPUT -p tcp --dport 22 -j ACCEPT')
$iptablesSemantic=@(':INPUT DROP [99:999]',':FORWARD DROP [7:8]','[100:200] -A INPUT -p tcp --dport 22 -j ACCEPT')
$baseNormalized=(Normalize-IptablesFixture $iptablesBase) -join "`n"
$telemetryNormalized=(Normalize-IptablesFixture $iptablesTelemetry) -join "`n"
$semanticNormalized=(Normalize-IptablesFixture $iptablesSemantic) -join "`n"
Assert-Audit ($baseNormalized -ceq $telemetryNormalized) 'IPTABLES_COUNTER_ONLY_POSITIVE'
Assert-Audit ($baseNormalized -cne $semanticNormalized) 'IPTABLES_SEMANTIC_DRIFT_NEGATIVE'
Assert-Audit (
    $remote.Contains('def normalize_iptables_save(text):') -and
    $remote.Contains("line=re.sub(r'\s+\[\d+:\d+\]\s*$', '', line)") -and
    $remote.Contains('canonical_json(normalize_iptables_save(text))')
) 'IPTABLES_PRODUCTION_NORMALIZER'

$bindingNames=@('Assert-G4B','Assert-LiveHandoffContract')
$bindingAsts=@($ast.FindAll({param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $bindingNames -ccontains $node.Name},$true))
Assert-Audit ($bindingAsts.Count -eq 2) 'LIVE_BINDING_HELPER_IDENTITY'
$bindingText=@(foreach($name in $bindingNames){($bindingAsts|Where-Object{$_.Name -ceq $name}|Select-Object -First 1).Extent.Text}) -join "`r`n"
. ([ScriptBlock]::Create($bindingText))

$gate='G4B_FIXTURE_LIVE_R999'
$round='R999'
$required=@(
    'GATE_ID='+$gate,
    $round+'_LIVE_INVOCATIONS_CONSUMED=0',
    $round+'_LIVE_INVOCATIONS_AUTHORIZED=1',
    'SECOND_'+$round+'_LIVE_INVOCATION_AUTHORIZED=NO',
    'SECOND_FAILURE_DOMAIN_PROVIDER=BAIDU_NETDISK'
)
$positive=($required -join "`r`n")+"`r`n"
$positivePass=$false
try{Assert-LiveHandoffContract -Handoff $positive -GateId $gate -Round $round;$positivePass=$true}catch{}
Assert-Audit $positivePass 'LIVE_BINDING_POSITIVE'

$allMissingRejected=$true
for($i=0;$i -lt $required.Count;$i++){
    $candidate=@()
    for($j=0;$j -lt $required.Count;$j++){if($j -ne $i){$candidate+=$required[$j]}}
    try{Assert-LiveHandoffContract -Handoff (($candidate -join "`r`n")+"`r`n") -GateId $gate -Round $round;$allMissingRejected=$false}catch{}
}
Assert-Audit $allMissingRejected 'LIVE_BINDING_MISSING_FIELD_NEGATIVES'

$staleRejected=$false
try{
    Assert-LiveHandoffContract -Handoff ($positive.Replace($round+'_LIVE_INVOCATIONS_CONSUMED=0',$round+'_LIVE_INVOCATIONS_CONSUMED=1')) -GateId $gate -Round $round
}catch{$staleRejected=$true}
Assert-Audit $staleRejected 'LIVE_BINDING_STALE_CONSUMED_NEGATIVE'

Assert-Audit (
    $runner.Contains("Assert-LiveHandoffContract -Handoff `$handoff -GateId 'G4B_PERSISTENT_THREE_ROLE_LIVE_AFTER_R21R2_R6R2L_R22' -Round 'R22'")
) 'LIVE_BINDING_SINGLE_CALL_SITE'

Write-Output 'R22R6_EXTERNAL_ACTION=NO'
Write-Output 'R22R6_SSH_OR_VPS_ACTION=NO'
Write-Output 'R22R6_PROVIDER_ACTION=NO'
Write-Output 'R22R6_SECRET_OR_DPAPI_ACCESS=NO'
Write-Output 'R22R6_CLASH_OR_NETWORK_MUTATION=NO'
Write-Output 'R22R6_OFFLINE_AUDIT_VALIDATOR=PASS'
Write-Output 'STOP_AT_REVIEWER=YES'
