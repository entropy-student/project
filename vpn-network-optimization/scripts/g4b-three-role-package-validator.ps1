[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$clashTemplate = Join-Path $projectRoot 'templates\clash\self-vpn-v1-three-role.yaml.template'
$serverTemplate = Join-Path $projectRoot 'templates\reality\mihomo-reality-server.yaml.template'
$serviceTemplate = Join-Path $projectRoot 'templates\systemd\mihomo-reality-vpn-network-optimization.service.template'
$gateDoc = Join-Path $projectRoot 'docs\G4B_PERSISTENT_THREE_ROLE_READINESS_GATE.md'
$planDoc = Join-Path $projectRoot 'docs\G4_FINAL_THREE_ROLE_VALIDATION_PLAN.md'

function Assert-G4B {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
}

foreach ($path in @($clashTemplate,$serverTemplate,$serviceTemplate,$gateDoc,$planDoc)) {
    Assert-G4B (Test-Path -LiteralPath $path -PathType Leaf) 'G4B_REQUIRED_FILE_MISSING'
}

$clashText = [IO.File]::ReadAllText($clashTemplate,[Text.Encoding]::UTF8)
$clash = ConvertFrom-Json -InputObject $clashText -AsHashtable -ErrorAction Stop

Assert-G4B ($clash['proxies'].Count -eq 3) 'G4B_CLASH_PROXY_CARDINALITY_INVALID'
Assert-G4B ($clash['proxies'][0]['name'] -ceq 'HY2-SFO3') 'G4B_PRIMARY_ORDER_INVALID'
Assert-G4B ($clash['proxies'][1]['name'] -ceq 'WG-BASELINE') 'G4B_BACKUP1_ORDER_INVALID'
Assert-G4B ($clash['proxies'][1]['type'] -ceq 'direct') 'G4B_WG_DIRECT_INVALID'
Assert-G4B ($clash['proxies'][2]['name'] -ceq 'REALITY-SFO3') 'G4B_BACKUP2_ORDER_INVALID'
Assert-G4B ($clash['proxy-groups'].Count -eq 1) 'G4B_GROUP_CARDINALITY_INVALID'
Assert-G4B ($clash['proxy-groups'][0]['name'] -ceq 'SELF-VPN-V1') 'G4B_GROUP_NAME_INVALID'
Assert-G4B ($clash['proxy-groups'][0]['type'] -ceq 'select') 'G4B_GROUP_NOT_MANUAL_SELECT'
Assert-G4B (($clash['proxy-groups'][0]['proxies'] -join '|') -ceq 'HY2-SFO3|WG-BASELINE|REALITY-SFO3') 'G4B_GROUP_ORDER_INVALID'
Assert-G4B ($clashText -notmatch '(?i)url-test|fallback|load-balance') 'G4B_AUTOMATIC_SELECTION_PRESENT'

foreach ($placeholder in @(
    '__HY2_AUTH_INJECT_PROTECTED_RUNTIME_ONLY__',
    '__HY2_CERT_SHA256__',
    '__REALITY_UUID_INJECT_PROTECTED_RUNTIME_ONLY__',
    '__REALITY_PUBLIC_KEY_INJECT_PROTECTED_RUNTIME_ONLY__',
    '__REALITY_SHORT_ID_INJECT_PROTECTED_RUNTIME_ONLY__',
    '__PHYSICAL_INTERFACE_NAME_RUNTIME_DISCOVERY__'
)) {
    Assert-G4B ($clashText.Contains($placeholder)) 'G4B_CLASH_PLACEHOLDER_MISSING'
}

$serverText = [IO.File]::ReadAllText($serverTemplate,[Text.Encoding]::UTF8)
foreach ($required in @(
    'listen: __VPS_PUBLIC_IP__',
    'port: 443',
    'type: vless',
    'flow: xtls-rprx-vision',
    'dest: www.microsoft.com:443',
    'private-key: __REALITY_PRIVATE_KEY_INJECT_PROTECTED_RUNTIME_ONLY__',
    'uuid: __REALITY_UUID_INJECT_PROTECTED_RUNTIME_ONLY__',
    '__REALITY_SHORT_ID_INJECT_PROTECTED_RUNTIME_ONLY__'
)) {
    Assert-G4B ($serverText.Contains($required)) 'G4B_REALITY_SERVER_CONTRACT_INVALID'
}

$serviceText = [IO.File]::ReadAllText($serviceTemplate,[Text.Encoding]::UTF8)
foreach ($required in @(
    '/usr/local/lib/vpn-network-optimization/mihomo-reality',
    '/srv/apps/vpn-network-optimization/reality',
    '/srv/apps/vpn-network-optimization/secrets/reality-server.yaml',
    'User=__REALITY_RUNTIME_USER__',
    'Group=__REALITY_RUNTIME_USER__',
    'Restart=on-failure',
    'NoNewPrivileges=true',
    'AmbientCapabilities=CAP_NET_BIND_SERVICE',
    'CapabilityBoundingSet=CAP_NET_BIND_SERVICE',
    'ProtectSystem=strict',
    'ProtectHome=true'
)) {
    Assert-G4B ($serviceText.Contains($required)) 'G4B_SYSTEMD_CONTRACT_INVALID'
}

$allText = $clashText + [Environment]::NewLine + $serverText + [Environment]::NewLine + $serviceText
Assert-G4B ($allText -notmatch '(?i)password:\s+[0-9a-f]{32,}|uuid:\s+[0-9a-f]{8}-[0-9a-f-]{27,}') 'G4B_REAL_SECRET_SHAPE_PRESENT'
Assert-G4B (([regex]::Matches($serverText, '(?m)^\s*private-key:')).Count -eq 1 -and $serverText.Contains('private-key: __REALITY_PRIVATE_KEY_INJECT_PROTECTED_RUNTIME_ONLY__')) 'G4B_REALITY_PRIVATE_KEY_PLACEHOLDER_INVALID'

function Invoke-R19SyntheticMihomoParse {
    param([string]$Executable,[string]$DataDirectory,[string]$ConfigPath)
    $process=$null; $stdoutTask=$null; $stderrTask=$null; $stdout=$null; $stderr=$null
    try {
        $psi=[Diagnostics.ProcessStartInfo]::new()
        $psi.FileName=$Executable; $psi.UseShellExecute=$false; $psi.CreateNoWindow=$true
        $psi.RedirectStandardOutput=$true; $psi.RedirectStandardError=$true
        foreach($argument in @('-t','-d',$DataDirectory,'-f',$ConfigPath)){[void]$psi.ArgumentList.Add($argument)}
        $process=[Diagnostics.Process]::new(); $process.StartInfo=$psi
        [void]$process.Start()
        $stdoutTask=$process.StandardOutput.ReadToEndAsync(); $stderrTask=$process.StandardError.ReadToEndAsync()
        if(-not $process.WaitForExit(30000)){
            try{$process.Kill($true)}catch{}
            throw 'R19R1_MIHOMO_PARSE_TIMEOUT'
        }
        $process.WaitForExit()
        $stdout=$stdoutTask.GetAwaiter().GetResult(); $stderr=$stderrTask.GetAwaiter().GetResult()
        $classification='NONE'
        if($process.ExitCode -ne 0){
            if(($stdout+"`n"+$stderr) -match '(?i)fingerprint'){$classification='HY2_FINGERPRINT_FIELD_VALIDATION'}
            else{$classification='CONFIG_SCHEMA_OR_DECODE'}
        }
        return [pscustomobject]@{ExitCode=[int]$process.ExitCode;ErrorClass=$classification}
    }
    finally {
        $stdout=$null; $stderr=$null
        if($null -ne $process){$process.Dispose()}
    }
}

$mihomoPath='C:\Program Files\Clash Verge\verge-mihomo.exe'
Assert-G4B (Test-Path -LiteralPath $mihomoPath -PathType Leaf) 'R19R1_MIHOMO_BINARY_UNAVAILABLE'
$runnerPath=Join-Path $PSScriptRoot 'g4b-persistent-three-role-live-runner.ps1'
$runnerTokens=$null; $runnerParseErrors=$null
$runnerAst=[System.Management.Automation.Language.Parser]::ParseFile($runnerPath,[ref]$runnerTokens,[ref]$runnerParseErrors)
Assert-G4B ($runnerParseErrors.Count -eq 0) 'R19R1_RUNNER_AST_INVALID'
$rendererAst=@($runnerAst.FindAll({param($node) $node -is [Management.Automation.Language.FunctionDefinitionAst] -and $node.Name -ceq 'Get-ProfileRenderedText'},$true))
Assert-G4B ($rendererAst.Count -eq 1) 'R19R1_RENDERER_FUNCTION_IDENTITY_INVALID'
$renderScript=@'
param([string]$Template,[string]$Hy2Fingerprint,[string]$InterfaceName)
Set-StrictMode -Version Latest
function Assert-G4B { param([bool]$Condition,[string]$Code) if(-not $Condition){throw $Code} }
$script:publicIp='203.0.113.10'
$script:hy2Auth='R19R1-SYNTHETIC-HY2-AUTH-NOT-A-CREDENTIAL'
$script:runId='R19R1-SYNTHETIC-RENDER'
__RENDERER_FUNCTION__
Get-ProfileRenderedText -Template $Template -Uuid '00000000-0000-4000-8000-000000000001' -PublicKey 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' -ShortId '0123456789abcdef' -InterfaceName $InterfaceName -Hy2Fingerprint $Hy2Fingerprint
'@
$renderScript=$renderScript.Replace('__RENDERER_FUNCTION__',$rendererAst[0].Extent.Text)
$renderBlock=[scriptblock]::Create($renderScript)
$syntheticFingerprint='AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99'
$physicalAdapters=@(Get-NetAdapter -Physical -ErrorAction Stop | Where-Object Status -eq 'Up')
Assert-G4B ($physicalAdapters.Count -gt 0 -and -not [string]::IsNullOrWhiteSpace([string]$physicalAdapters[0].Name)) 'R19R1_PHYSICAL_INTERFACE_FIXTURE_UNAVAILABLE'
$syntheticRendered=$null; $syntheticProfile=$null; $legacyProfile=$null; $parseRoot=$null; $parseRootCreated=$false
try {
    $syntheticRendered=[string](& $renderBlock -Template $clashText -Hy2Fingerprint $syntheticFingerprint -InterfaceName ([string]$physicalAdapters[0].Name))
    $jsonStart=$syntheticRendered.IndexOf("`n")
    Assert-G4B ($jsonStart -ge 0) 'R19R1_RENDERED_PROFILE_SHAPE_INVALID'
    $renderedJson=$syntheticRendered.Substring($jsonStart+1).Trim()
    $syntheticProfile=ConvertFrom-Json -InputObject $renderedJson -AsHashtable -ErrorAction Stop
    Assert-G4B ($syntheticProfile['proxies'][0]['fingerprint'] -ceq $syntheticFingerprint -and -not $syntheticRendered.Contains('__HY2_CERT_SHA256__')) 'R19R1_FINGERPRINT_RENDER_FIXTURE_FAILED'
    $parseRoot=Join-Path ([IO.Path]::GetTempPath()) ('g4b-r19r1-'+[Guid]::NewGuid().ToString('N'))
    Assert-G4B (-not (Test-Path -LiteralPath $parseRoot)) 'R19R1_TEMP_COLLISION'
    [void][IO.Directory]::CreateDirectory($parseRoot); $parseRootCreated=$true
    $repairedPath=Join-Path $parseRoot 'repaired.yaml'
    [IO.File]::WriteAllText($repairedPath,$syntheticRendered,[Text.UTF8Encoding]::new($false))
    $repairedParse=Invoke-R19SyntheticMihomoParse -Executable $mihomoPath -DataDirectory $parseRoot -ConfigPath $repairedPath
    Assert-G4B ($repairedParse.ExitCode -eq 0 -and $repairedParse.ErrorClass -ceq 'NONE') 'R19R1_REPAIRED_MIHOMO_PARSE_FAILED'
    $legacyProfile=$syntheticProfile.Clone()
    $legacyProfile['proxies'][0]['fingerprint']='__HY2_CERT_SHA256__'
    $legacyPath=Join-Path $parseRoot 'legacy-sentinel.yaml'
    $legacyText='# G4B_RUN_ID=R19R1-SYNTHETIC-RENDER'+[Environment]::NewLine+(ConvertTo-Json -InputObject $legacyProfile -Depth 20 -Compress)
    [IO.File]::WriteAllText($legacyPath,$legacyText,[Text.UTF8Encoding]::new($false))
    $legacyParse=Invoke-R19SyntheticMihomoParse -Executable $mihomoPath -DataDirectory $parseRoot -ConfigPath $legacyPath
    Assert-G4B ($legacyParse.ExitCode -ne 0 -and $legacyParse.ErrorClass -ceq 'HY2_FINGERPRINT_FIELD_VALIDATION') 'R19R1_LEGACY_FINGERPRINT_REJECTION_NOT_REPRODUCED'
}
finally {
    $syntheticRendered=$null; $syntheticProfile=$null; $legacyProfile=$null
    $renderedJson=$null; $legacyText=$null; $renderBlock=$null; $renderScript=$null
    if($parseRootCreated -and (Test-Path -LiteralPath $parseRoot -PathType Container)){Remove-Item -LiteralPath $parseRoot -Recurse -Force -ErrorAction Stop}
}
Assert-G4B (-not (Test-Path -LiteralPath $parseRoot)) 'R19R1_TEMP_CLEANUP_FAILED'
Write-Output 'R19R1_CURRENT_FAILURE_REPRODUCED=PASS'
Write-Output 'R19R1_SANITIZED_PARSE_ERROR_CLASS=HY2_FINGERPRINT_FIELD_VALIDATION'
Write-Output 'R19R1_SYNTHETIC_RENDERED_PROFILE_MIHOMO_PARSE=PASS'
Write-Output 'R19R1_SYNTHETIC_MIHOMO_PARSE_TEMP_CLEANUP=PASS'

Write-Output 'G4B_THREE_ROLE_ORDER=HY2_PRIMARY_WG_BACKUP1_REALITY_BACKUP2'
Write-Output 'G4B_MANUAL_SELECTOR_ONLY=PASS'
Write-Output 'G4B_CLASH_TEMPLATE=PASS'
Write-Output 'G4B_REALITY_SERVER_TEMPLATE=PASS'
Write-Output 'G4B_SYSTEMD_TEMPLATE=PASS'
Write-Output 'G4B_SECRET_PLACEHOLDERS_ONLY=PASS'
Write-Output 'G4B_OFFLINE_PACKAGE_VALIDATION=PASS'
Write-Output 'NETWORK_MUTATION=NO'
Write-Output 'SECRET_ACCESS=NO'
Write-Output 'OWNER_AUTHORIZATION_REQUIRED_FOR_LIVE_G4B=YES'
