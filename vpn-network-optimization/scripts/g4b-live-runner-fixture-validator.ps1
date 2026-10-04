[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$runnerPath = Join-Path $PSScriptRoot 'g4b-persistent-three-role-live-runner.ps1'
$packageValidatorPath = Join-Path $PSScriptRoot 'g4b-three-role-package-validator.ps1'
$clashTemplatePath = Join-Path $projectRoot 'templates\clash\self-vpn-v1-three-role.yaml.template'
$serverTemplatePath = Join-Path $projectRoot 'templates\reality\mihomo-reality-server.yaml.template'
$serviceTemplatePath = Join-Path $projectRoot 'templates\systemd\mihomo-reality-vpn-network-optimization.service.template'
$runner = [IO.File]::ReadAllText($runnerPath,[Text.Encoding]::UTF8)
$clashTemplate = [IO.File]::ReadAllText($clashTemplatePath,[Text.Encoding]::UTF8)
$serverTemplate = [IO.File]::ReadAllText($serverTemplatePath,[Text.Encoding]::UTF8)
$serviceTemplate = [IO.File]::ReadAllText($serviceTemplatePath,[Text.Encoding]::UTF8)

function Assert-Fixture {
    param([bool]$Condition,[string]$Name)
    if (-not $Condition) { throw ('G4B_FIXTURE_FAILED_' + $Name) }
    Write-Output ('G4B_FIXTURE_' + $Name + '=PASS')
}

function Test-PowerShellText {
    param([string]$Text)
    $tokens=$null; $errors=$null
    [void][System.Management.Automation.Language.Parser]::ParseInput($Text,[ref]$tokens,[ref]$errors)
    return ($errors.Count -eq 0)
}

function Test-RunnerContract {
    param([string]$Text)
    $phaseNames=@(
        'P0_CANONICAL_SOURCE','P1_OWNER_HOST_AND_NETWORK_PREFLIGHT','P2_STRICT_TARGET_IDENTITY',
        'P3_WG_HY2_TCP443_BASELINE','P4_REALITY_RUNTIME_IDENTITY_AND_PATH_PREFLIGHT',
        'P5_SECRET_AND_RECOVERY_PREPARE','P6_SERVER_CONFIG_PARSE','P7_SERVICE_ENABLE_AND_LISTENER_READBACK',
        'P8_PUBLIC_REALITY_READINESS','P9_OWNER_THREE_ROLE_PROFILE_PREPARE',
        'P10_OWNER_UI_IMPORT_AND_VISIBILITY','P11_RESTART_PERSISTENCE','P12_FINAL_BASELINE_READBACK'
    )
    $phaseMatches=[regex]::Matches($Text,"(?m)^\s*Write-Phase '([^']+)'\s*$")
    $observed=@($phaseMatches | ForEach-Object { $_.Groups[1].Value })
    $phaseOrder=($observed.Count -eq $phaseNames.Count -and (($observed -join '|') -ceq ($phaseNames -join '|')))
    $mutationAt=$Text.IndexOf('$script:remoteMutationStarted=$true',[StringComparison]::Ordinal)
    $authAt=$Text.IndexOf("OwnerAuthorization -ceq 'OWNER_G4B_LIVE_AUTHORIZATION=APPROVED'",[StringComparison]::Ordinal)
    $targetAt=$Text.IndexOf('$remote[''hostname''] -ceq ''ubuntu-s-1vcpu-512mb-10gb-sfo3''',[StringComparison]::Ordinal)
    $secondPathAt=$Text.IndexOf('$SecondFailureDomainPath -and (Test-Path',[StringComparison]::Ordinal)
    $secondAckAt=$Text.IndexOf("SecondFailureDomainAcknowledgement -ceq 'SECOND_FAILURE_DOMAIN_DISTINCT_ENCRYPTED=CONFIRMED'",[StringComparison]::Ordinal)
    $firstMutationAt=$mutationAt
    $authBeforeMutation=($authAt -ge 0 -and $mutationAt -gt $authAt)
    $targetBeforeMutation=($targetAt -ge 0 -and $mutationAt -gt $targetAt)
    $secondRecovery=($secondPathAt -ge 0 -and $secondAckAt -ge 0 -and $mutationAt -gt $secondPathAt -and $mutationAt -gt $secondAckAt)
    $outputs=@($Text -split "`r?`n" | Where-Object { $_ -match '(?i)\bWrite-(?:Output|Host|Verbose|Information|Warning|Error)\b' })
    $secretOutput=(@($outputs | Where-Object { $_ -match '(?i)\$(?:script:)?(?:hy2Auth|remoteCredentials|credentials|recoveryJson|serverRendered|rendered)|private_key|secret_bundle_b64' }).Count -gt 0)
    $routeWriter=($Text -match '(?im)\b(?:New-NetRoute|Remove-NetRoute|Set-NetRoute)\b|\broute(?:\.exe)?\s+(?:add|delete|change)\b')
    $firewallWriter=($Text -match '(?im)\b(?:ufw\s+(?:allow|deny|delete|reset|enable|disable)|nft\s+(?:add|delete|flush|insert|replace)|iptables\s+-[A-Z])\b')
    $wgHy2Mutation=($Text -match '(?im)\b(?:systemctl|service)\s+(?:stop|restart|disable|enable\s+--now)\s+(?:wg-quick@wg0|hysteria2-vpn-network-optimization(?:\.service)?)\b')
    $rollbackStart=$Text.IndexOf('def rollback():',[StringComparison]::Ordinal)
    $rollbackEnd=$Text.IndexOf('def main():',$rollbackStart,[StringComparison]::Ordinal)
    $rollback=if($rollbackStart -ge 0 -and $rollbackEnd -gt $rollbackStart){$Text.Substring($rollbackStart,$rollbackEnd-$rollbackStart)}else{''}
    $rollbackScoped=($rollback.Contains("s.get('run_id')!=RUN_ID") -and $rollback.Contains('ROLLBACK_OWNERSHIP_MISMATCH') -and $rollback.Contains('ROLLBACK_UNIT_OWNERSHIP_UNPROVEN') -and $rollback.Contains('ROLLBACK_CONFIG_OWNERSHIP_UNPROVEN') -and $rollback.Contains('ROLLBACK_RUNTIME_OWNERSHIP_UNPROVEN') -and $rollback.Contains('ROLLBACK_BINARY_OWNERSHIP_UNPROVEN') -and $rollback.Contains("s.get('created_user')") -and $rollback.Contains("s.get('created_group')"))
    $localGuard=($Text.Contains('$settings.PSObject.Properties[''ProxyEnable'']') -and $Text.Contains('SYSTEM_PROXY_NOT_OFF') -and $Text.Contains('TUN_NOT_OFF') -and $Text.Contains('Assert-SameLocalBaseline -Before $script:baseline -After $final'))
    $targetIdentity=($Text.Contains('$remote[''hostname''] -ceq ''ubuntu-s-1vcpu-512mb-10gb-sfo3''') -and $Text.Contains('$remote[''os_id''] -ceq ''ubuntu''') -and $Text.Contains('$remote[''os_version''] -ceq ''24.04'''))
    $targetCollision=($Text.Contains('$remote[''target_paths_absent''] -eq $true') -and $Text.Contains('REALITY_TARGET_PATH_COLLISION') -and $Text.Contains('THREE_ROLE_PROFILE_COLLISION') -and $Text.Contains('SELF-VPN-V1(?:\.[^/]*)?') -and $Text.Contains('LOCAL_RUNTIME_COLLISION') -and $Text.Contains('REALITY_RECOVERY_COLLISION'))
    $noAutoSelection=$Text.Contains('$groups[0][''type''] -ceq ''select''') -and $Text.Contains('$cfg[''proxy-groups''][0][''type''] -ceq ''select''')
    $roleOrder=($Text.Contains('$cfg[''proxies''][0][''name''] -ceq ''HY2-SFO3''') -and $Text.Contains('$cfg[''proxies''][1][''name''] -ceq ''WG-BASELINE''') -and $Text.Contains('$cfg[''proxies''][2][''name''] -ceq ''REALITY-SFO3''') -and $Text.Contains('HY2-SFO3|WG-BASELINE|REALITY-SFO3'))
    $restartCheck=($Text.Contains("Write-Phase 'P11_RESTART_PERSISTENCE'") -and $Text.Contains("Invoke-Remote -Action 'restart'") -and $Text.Contains('Restart-Service -Name ''clash_verge_service''') -and $Text.Contains('REALITY_RESTART_PERSISTENCE_FAILED'))
    $recoveryStart=$Text.IndexOf('function Write-EncryptedRecovery {',[StringComparison]::Ordinal); $recoveryEnd=$Text.IndexOf('function Promote-RecoveryArtifacts {',$recoveryStart,[StringComparison]::Ordinal)
    $recoveryBody=if($recoveryStart -ge 0 -and $recoveryEnd -gt $recoveryStart){$Text.Substring($recoveryStart,$recoveryEnd-$recoveryStart)}else{''}
    $portableCodec=($Text.Contains('VPNG4BP1') -and $Text.Contains('[Security.Cryptography.Rfc2898DeriveBytes]::Pbkdf2') -and $Text.Contains('[Security.Cryptography.HashAlgorithmName]::SHA256') -and $Text.Contains('[Security.Cryptography.AesGcm]::new($key,16)') -and $Text.Contains('GetBytes(16)') -and $Text.Contains('GetBytes(12)') -and $Text.Contains('[byte[]]::new(16)') -and $Text.Contains("'hy2_auth','reality_uuid','reality_private_key','reality_public_key','reality_short_id'") -and $Text.Contains('$added=$seen.Add($property.Name)') -and $recoveryBody.Contains('Write-OwnerOnlyFile -Path $script:recoveryPendingLocal -Bytes $dpapi') -and $recoveryBody.Contains('Write-OwnerOnlyFile -Path $script:recoveryPendingExternal -Bytes $portable') -and -not $recoveryBody.Contains('Write-OwnerOnlyFile -Path $script:recoveryPendingExternal -Bytes $dpapi'))
    $pendingAt=$Text.IndexOf('Write-EncryptedRecovery -PayloadBytes',[StringComparison]::Ordinal)
    $stageMutationAt=$Text.IndexOf('$script:remoteMutationStarted=$true',[StringComparison]::Ordinal)
    $stageAt=$Text.IndexOf("Invoke-Remote -Action 'stage'",[StringComparison]::Ordinal)
    $pendingOrdering=($pendingAt -ge 0 -and $stageMutationAt -gt $pendingAt -and $stageAt -gt $stageMutationAt -and $Text.Contains('$script:recoveryPendingLocal') -and $Text.Contains('.pending') -and $Text.Contains('vpn-network-optimization-g4b.vpr1'))
    $promotionAt=$Text.IndexOf('Promote-RecoveryArtifacts -PayloadBytes',[StringComparison]::Ordinal)
    $remoteFinalAt=$Text.IndexOf('$remoteFinal=Invoke-Remote -Action ''status''',[StringComparison]::Ordinal)
    $candidateAt=$Text.IndexOf('$remoteCandidate=Invoke-Remote -Action ''candidate''',[StringComparison]::Ordinal)
    $promotionOrdering=($remoteFinalAt -ge 0 -and $candidateAt -gt $remoteFinalAt -and $promotionAt -gt $candidateAt -and $Text.Contains('FINAL_REALITY_READBACK_FAILED') -and $Text.Contains('Assert-SameLocalBaseline -Before $script:baseline -After $final') -and $Text.Contains('Write-RollbackJournal -Status ''PASS_CANDIDATE'''))
    $accessProof=($Text.Contains('def ensure_directory(') -and $Text.Contains('stat.S_IMODE(info.st_mode)!=mode') -and $Text.Contains('os.chown(path,uid,gid); os.chmod(path,mode)') -and $Text.Contains('ensure_directory(RUNTIME,0o750,uid,gid,s)') -and $Text.Contains('ensure_directory(SECRETS.parent,0o710,0,gid,s)') -and $Text.Contains('write_new(SECRETS,config,0o640,0,gid)') -and $Text.Contains('access_as(USER,RUNTIME,os.W_OK|os.X_OK)') -and $Text.Contains('access_as(USER,SECRETS,os.R_OK)') -and $Text.Contains("access_as('nobody',SECRETS,os.R_OK)"))
    $restartReadbackAt=$Text.IndexOf('[void](Get-ProfileSemanticState -Path $importedProfilePath)',$Text.IndexOf("Restart-Service -Name 'clash_verge_service'",[StringComparison]::Ordinal),[StringComparison]::Ordinal)
    $profileRestartReadback=($restartReadbackAt -gt $Text.IndexOf("Restart-Service -Name 'clash_verge_service'",[StringComparison]::Ordinal) -and $Text.Contains('$profileAfterRestart=Get-ProfileSnapshot') -and $Text.Contains('RESTART_PROFILE_NOT_PERSISTED') -and $Text.Contains('RESTART_PROFILE_SELECTOR_INVALID'))
    $candidateStart=$Text.IndexOf('def candidate():',[StringComparison]::Ordinal); $candidateEnd=$Text.IndexOf('def main():',$candidateStart,[StringComparison]::Ordinal)
    $candidateBody=if($candidateStart -ge 0 -and $candidateEnd -gt $candidateStart){$Text.Substring($candidateStart,$candidateEnd-$candidateStart)}else{''}
    $closeoutGuard=($Text.Contains('ReviewerDecision -ceq ''FORMAL_PASS_G4B_PERSISTENT_THREE_ROLE_READINESS''') -and $Text.Contains('reviewer_decision=$ReviewerDecision') -and $Text.Contains('CLOSEOUT_REVIEWER_PASS_REQUIRED'))
    $canonicalGateStart=$Text.IndexOf("if (`$Mode -eq 'Run') {",[StringComparison]::Ordinal)
    $canonicalGateEnd=if($canonicalGateStart -ge 0){$Text.IndexOf("if(`$Mode -eq 'Rollback')",$canonicalGateStart,[StringComparison]::Ordinal)}else{-1}
    $canonicalGateBlock=if($canonicalGateStart -ge 0 -and $canonicalGateEnd -gt $canonicalGateStart){$Text.Substring($canonicalGateStart,$canonicalGateEnd-$canonicalGateStart)}else{''}
    $canonicalGateModeBound=($canonicalGateBlock.Contains('LIVE_G4B_GATE_NOT_CURRENT') -and $canonicalGateBlock.Contains('REVIEWER_LIVE_AUTHORIZATION_MISSING') -and $canonicalGateBlock.Contains('REVIEWER_RECOVERY_DESTINATION_NOT_APPROVED'))
    $journalRetention=($Text.Contains('/var/lib') -and $Text.Contains("'G4B_OWNER_ROLLBACK_R1'") -and $Text.Contains("Write-RollbackJournal -Status 'PASS_CANDIDATE'") -and $Text.Contains('G4B_ROLLBACK_JOURNAL_RETAINED=YES') -and $Text -notmatch "(?m)^\s*if ACTION=='complete':")
    $candidateRetains=($candidateBody.Contains("s['pass_candidate']=True; save_state(s)") -and -not ($candidateBody -match 'shutil\.rmtree|\.unlink\(') -and -not $Text.Contains("Invoke-Remote -Action 'complete'"))
    $successMarkers=@('G4B_RECOVERY_PENDING_VERIFIED=YES','G4B_RECOVERY_FINAL_PROMOTED=YES','G4B_REALITY_RUNTIME_ACCESS=PASS','G4B_REALITY_SERVICE_READY=YES','G4B_PUBLIC_TCP443_READY=YES','G4B_THREE_ROLE_PROFILE_IMPORTED=YES','G4B_THREE_ROLE_PROFILE_RESTART_PERSISTENCE=PASS','G4B_ROLE_ORDER=HY2_PRIMARY_WG_BACKUP1_REALITY_BACKUP2','G4B_AUTO_SWITCHING=OFF','G4B_WIREGUARD_PRESERVED=YES','G4B_HY2_PRESERVED=YES','G4B_SYSTEM_PROXY_FINAL=OFF','G4B_TUN_FINAL=OFF','G4B_ROLLBACK_JOURNAL_RETAINED=YES','SECRET_VALUES_EMITTED=0','STOP_AT_REVIEWER=YES')
    $sanitizedMarkers=(@($successMarkers | Where-Object { -not $Text.Contains($_) }).Count -eq 0)
    $runtimeIdentity=($Text.Contains("useradd','--system'") -and $Text.Contains("'--shell','/usr/sbin/nologin'") -and $Text.Contains('$script:runtimeUser = ''reality-vpn-network-optimization'''))
    $stopAtReviewer=$Text.Contains("Write-Output 'STOP_AT_REVIEWER=YES'")
    $liveGuardAt=$Text.IndexOf('if (-not $Live)',[StringComparison]::Ordinal)
    $mainTryAt=if($liveGuardAt -ge 0){$Text.IndexOf('try {',$liveGuardAt,[StringComparison]::Ordinal)}else{-1}
    $defaultLiveGuard=($Text.Contains('if (-not $Live) { Write-Output ''G4B_RUNNER_LIVE_MODE=NOT_REQUESTED''; return }') -and $liveGuardAt -ge 0 -and $mainTryAt -gt $liveGuardAt)
    $noG4C=($Text -notmatch '(?i)api\.openai\.com|curl\.exe|G4C_|benchmark')
    [pscustomobject]@{
        PhaseOrder=$phaseOrder
        OwnerAuthorizationBeforeMutation=$authBeforeMutation
        SecondFailureDomain=$secondRecovery
        TargetIdentity=$targetIdentity -and $targetBeforeMutation
        TargetCollision=$targetCollision
        RouteWritersAbsent=(-not $routeWriter)
        FirewallWritersAbsent=(-not $firewallWriter)
        WireGuardHy2DestructiveActionsAbsent=(-not $wgHy2Mutation)
        SecretOutputAbsent=(-not $secretOutput)
        RollbackScoped=$rollbackScoped
        ProxyTunGuards=$localGuard
        ManualRoles=$roleOrder -and $noAutoSelection
        RestartPersistence=$restartCheck
        PortableRecovery=$portableCodec -and $pendingOrdering -and $promotionOrdering
        RuntimeFilesystem=$accessProof
        ProfileRestartReadback=$profileRestartReadback
        RollbackJournalRetention=$journalRetention -and $candidateRetains -and $closeoutGuard -and $canonicalGateModeBound
        SanitizedMarkers=$sanitizedMarkers
        NonRootCapability=$runtimeIdentity
        StopAtReviewer=$stopAtReviewer
        NoG4C=$noG4C
        OfflineDefault=$defaultLiveGuard
    }
}

$runnerTokens=$null; $runnerParseErrors=$null
[void][System.Management.Automation.Language.Parser]::ParseFile($runnerPath,[ref]$runnerTokens,[ref]$runnerParseErrors)
Assert-Fixture ($runnerParseErrors.Count -eq 0) 'RUNNER_AST'
$validatorTokens=$null; $validatorParseErrors=$null
$validatorAst=[System.Management.Automation.Language.Parser]::ParseFile($PSCommandPath,[ref]$validatorTokens,[ref]$validatorParseErrors)
Assert-Fixture ($validatorParseErrors.Count -eq 0) 'VALIDATOR_AST'

$packageOutput=@(& $packageValidatorPath 2>&1 | ForEach-Object { [string]$_ })
Assert-Fixture (($packageOutput -contains 'G4B_OFFLINE_PACKAGE_VALIDATION=PASS') -and ($packageOutput -contains 'NETWORK_MUTATION=NO') -and ($packageOutput -contains 'SECRET_ACCESS=NO')) 'EXISTING_PACKAGE_VALIDATOR'

$contract=Test-RunnerContract $runner
Assert-Fixture $contract.PhaseOrder 'PHASES_P0_P12_ORDERED_ONCE'
Assert-Fixture ($contract.OwnerAuthorizationBeforeMutation -and $contract.TargetIdentity -and $contract.SecondFailureDomain) 'AUTH_IDENTITY_AND_RECOVERY_PRECEDE_MUTATION'
Assert-Fixture $contract.SecondFailureDomain 'SECOND_FAILURE_DOMAIN_FAIL_CLOSED'
Assert-Fixture $contract.TargetCollision 'UNKNOWN_PERSISTENT_PATHS_FAIL_CLOSED'
Assert-Fixture $contract.TargetIdentity 'STRICT_SFO3_IDENTITY'
Assert-Fixture $contract.RouteWritersAbsent 'NO_ROUTE_WRITES'
Assert-Fixture $contract.FirewallWritersAbsent 'NO_BROAD_FIREWALL_WRITES'
Assert-Fixture $contract.WireGuardHy2DestructiveActionsAbsent 'WG_HY2_PRESERVED'
$secretShape=($clashTemplate.Contains('__HY2_AUTH_INJECT_PROTECTED_RUNTIME_ONLY__') -and $clashTemplate.Contains('__REALITY_UUID_INJECT_PROTECTED_RUNTIME_ONLY__') -and $serverTemplate.Contains('__REALITY_PRIVATE_KEY_INJECT_PROTECTED_RUNTIME_ONLY__'))
Assert-Fixture ($contract.SecretOutputAbsent -and $secretShape) 'SECRET_OUTPUT_AND_TEMPLATE_PLACEHOLDER_POLICY'
Assert-Fixture $contract.RollbackScoped 'ROLLBACK_CREATION_OWNERSHIP_SCOPED'
Assert-Fixture $contract.ProxyTunGuards 'FINAL_PROXY_TUN_GUARDS'
Assert-Fixture $contract.ManualRoles 'THREE_ROLE_MANUAL_ORDER'
Assert-Fixture $contract.RestartPersistence 'RESTART_PERSISTENCE_READBACK'
Assert-Fixture $contract.PortableRecovery 'PORTABLE_PENDING_RECOVERY_ORDER_AND_PROMOTION'
Assert-Fixture $contract.RuntimeFilesystem 'RUNTIME_AND_SECRET_FILESYSTEM_ACCESS_CONTRACT'
Assert-Fixture $contract.ProfileRestartReadback 'POST_RESTART_PROFILE_SEMANTICS_READBACK'
Assert-Fixture $contract.RollbackJournalRetention 'PASS_CANDIDATE_RETAINS_BOUNDED_ROLLBACK_JOURNAL'
Assert-Fixture $contract.SanitizedMarkers 'SANITIZED_LIVE_EVIDENCE_MARKERS'
Assert-Fixture ($contract.NonRootCapability -and $serviceTemplate.Contains('User=__REALITY_RUNTIME_USER__') -and $serviceTemplate.Contains('Group=__REALITY_RUNTIME_USER__') -and $serviceTemplate.Contains('AmbientCapabilities=CAP_NET_BIND_SERVICE') -and $serviceTemplate.Contains('CapabilityBoundingSet=CAP_NET_BIND_SERVICE')) 'DEDICATED_NONROOT_AND_SINGLE_BIND_CAPABILITY'
Assert-Fixture $contract.StopAtReviewer 'STOP_AT_REVIEWER_MARKER'
Assert-Fixture $contract.NoG4C 'NO_G4C_WORKLOAD_OR_BENCHMARK'
Assert-Fixture $contract.OfflineDefault 'LIVE_RUNNER_NOT_INVOKED_BY_DEFAULT'
$validatorCommands=@($validatorAst.FindAll({param($node) $node -is [System.Management.Automation.Language.CommandAst]},$true) | ForEach-Object { $_.GetCommandName() })
$forbiddenCommands=@($validatorCommands | Where-Object { $_ -match '(?i)^(?:Start-Process|ssh(?:\.exe)?|Invoke-WebRequest|Invoke-RestMethod|curl(?:\.exe)?|New-NetRoute|Remove-NetRoute|Set-NetRoute|Start-Service|Stop-Service|Restart-Service|Invoke-Expression)$' })
Assert-Fixture ($forbiddenCommands.Count -eq 0) 'FIXTURE_VALIDATOR_NO_LIVE_ACTIONS'

$offlineRunnerOutput=@(. $runnerPath 2>&1 | ForEach-Object { [string]$_ })
Assert-Fixture ($offlineRunnerOutput -contains 'G4B_RUNNER_LIVE_MODE=NOT_REQUESTED') 'LIVE_RUNNER_DEFAULT_REFUSES_EXECUTION'
$fixturePayloadJson=$null; $fixturePayloadBytes=$null; $fixtureBlob=$null; $fixtureRestored=$null; $fixtureTampered=$null; $fixtureExtraBytes=$null; $fixtureDuplicateBytes=$null
$fixturePass=ConvertTo-SecureString 'fixture-only-portable-passphrase-2026' -AsPlainText -Force
$fixtureWrongPass=ConvertTo-SecureString 'fixture-only-wrong-passphrase-2026' -AsPlainText -Force
try {
    $fixturePayloadJson=ConvertTo-Json -InputObject @{format='VPNG4BR1';hy2_auth=('a'*64);reality_uuid='00000000-0000-4000-8000-000000000001';reality_private_key=('A'*43);reality_public_key=('B'*43);reality_short_id='0123456789abcdef'} -Compress
    $fixturePayloadBytes=[Text.Encoding]::UTF8.GetBytes($fixturePayloadJson)
    Assert-Fixture (Test-G4BRecoveryPayload -PayloadBytes $fixturePayloadBytes) 'PORTABLE_SYNTHETIC_PAYLOAD_PARSE'
    $fixtureExtraBytes=[Text.Encoding]::UTF8.GetBytes($fixturePayloadJson.Substring(0,$fixturePayloadJson.Length-1)+',"unexpected":"fixture"}')
    Assert-Fixture (-not (Test-G4BRecoveryPayload -PayloadBytes $fixtureExtraBytes)) 'PORTABLE_SYNTHETIC_UNKNOWN_FIELD_REJECTED'
    $fixtureDuplicateJson='{"format":"VPNG4BR1","hy2_auth":"'+('a'*64)+'","hy2_auth":"'+('b'*64)+'","reality_uuid":"00000000-0000-4000-8000-000000000001","reality_private_key":"'+('A'*43)+'","reality_public_key":"'+('B'*43)+'","reality_short_id":"0123456789abcdef"}'
    $fixtureDuplicateBytes=[Text.Encoding]::UTF8.GetBytes($fixtureDuplicateJson)
    Assert-Fixture (-not (Test-G4BRecoveryPayload -PayloadBytes $fixtureDuplicateBytes)) 'PORTABLE_SYNTHETIC_DUPLICATE_FIELD_REJECTED'
    $fixtureBlob=ConvertTo-PortableRecoveryBytes -PayloadBytes $fixturePayloadBytes -Passphrase $fixturePass
    $fixtureRestored=ConvertFrom-PortableRecoveryBytes -Blob $fixtureBlob -Passphrase $fixturePass
    Assert-Fixture ([Linq.Enumerable]::SequenceEqual[byte]($fixturePayloadBytes,$fixtureRestored)) 'PORTABLE_SYNTHETIC_ROUNDTRIP'
    $fixtureTampered=[byte[]]::new($fixtureBlob.Length); [Array]::Copy($fixtureBlob,$fixtureTampered,$fixtureBlob.Length); $fixtureTampered[44]=$fixtureTampered[44] -bxor 1
    $tamperRejected=$false; try { $unexpected=ConvertFrom-PortableRecoveryBytes -Blob $fixtureTampered -Passphrase $fixturePass; [Security.Cryptography.CryptographicOperations]::ZeroMemory($unexpected) } catch { $tamperRejected=$true }
    Assert-Fixture $tamperRejected 'PORTABLE_SYNTHETIC_AUTHENTICATION_FAILURE'
    $wrongRejected=$false; try { $unexpected=ConvertFrom-PortableRecoveryBytes -Blob $fixtureBlob -Passphrase $fixtureWrongPass; [Security.Cryptography.CryptographicOperations]::ZeroMemory($unexpected) } catch { $wrongRejected=$true }
    Assert-Fixture $wrongRejected 'PORTABLE_SYNTHETIC_WRONG_PASSPHRASE'
}
finally {
    foreach($buffer in @($fixturePayloadBytes,$fixtureBlob,$fixtureRestored,$fixtureTampered,$fixtureExtraBytes,$fixtureDuplicateBytes)){if($null -ne $buffer){[Security.Cryptography.CryptographicOperations]::ZeroMemory([byte[]]$buffer)}}
    $fixturePass.Dispose(); $fixtureWrongPass.Dispose(); $fixturePayloadJson=$null; $fixtureDuplicateJson=$null
}

$negative=@(
    @{Name='NO_OWNER_AUTH'; Source=$runner.Replace('Assert-G4B ($OwnerAuthorization -ceq ''OWNER_G4B_LIVE_AUTHORIZATION=APPROVED'') ''OWNER_G4B_AUTHORIZATION_REQUIRED''','# OWNER AUTH FIXTURE REMOVAL'); Check='OwnerAuthorizationBeforeMutation'},
    @{Name='NO_SECOND_FAILURE_DOMAIN'; Source=[regex]::Replace($runner,'(?m)^\s*Assert-G4B \(\$SecondFailureDomainPath -and \(Test-Path -LiteralPath \$SecondFailureDomainPath -PathType Container\)\).*(?:\r?\n)?$',''); Check='SecondFailureDomain'},
    @{Name='WRONG_TARGET_IDENTITY'; Source=$runner.Replace('ubuntu-s-1vcpu-512mb-10gb-sfo3','fixture-wrong-host'); Check='TargetIdentity'},
    @{Name='PREEXISTING_TARGET_PATH'; Source=$runner.Replace('$remote[''target_paths_absent''] -eq $true', '$remote[''target_paths_unknown''] -eq $true'); Check='TargetCollision'},
    @{Name='SECRET_OUTPUT'; Source=$runner.Replace("    Write-Phase 'P0_CANONICAL_SOURCE'", "    Write-Output `$script:hy2Auth`r`n    Write-Phase 'P0_CANONICAL_SOURCE'"); Check='SecretOutputAbsent'},
    @{Name='ROUTE_WRITE'; Source=$runner.Replace("    Write-Phase 'P0_CANONICAL_SOURCE'", "    New-NetRoute -DestinationPrefix '0.0.0.0/0'`r`n    Write-Phase 'P0_CANONICAL_SOURCE'"); Check='RouteWritersAbsent'},
    @{Name='AUTO_SELECTOR'; Source=$runner.Replace('$cfg[''proxy-groups''][0][''type''] -ceq ''select''', '$cfg[''proxy-groups''][0][''type''] -ceq ''url-test'''); Check='ManualRoles'},
    @{Name='ROLE_ORDER'; Source=$runner.Replace('$cfg[''proxies''][0][''name''] -ceq ''HY2-SFO3''', '$cfg[''proxies''][0][''name''] -ceq ''WG-BASELINE'''); Check='ManualRoles'},
    @{Name='ROLLBACK_GUARD_REMOVED'; Source=[regex]::Replace($runner,"(?m)^\s*if s\.get\('run_id'\)!=RUN_ID: raise GateError\('ROLLBACK_OWNERSHIP_MISMATCH'\)\s*$",''); Check='RollbackScoped'},
    @{Name='FINAL_PROXY_TUN_GUARD_REMOVED'; Source=$runner.Replace('SYSTEM_PROXY_NOT_OFF','SYSTEM_PROXY_GUARD_REMOVED').Replace('TUN_NOT_OFF','TUN_GUARD_REMOVED'); Check='ProxyTunGuards'},
    @{Name='DPAPI_AS_PORTABLE_COPY'; Source=$runner.Replace('Write-OwnerOnlyFile -Path $script:recoveryPendingExternal -Bytes $portable -RecoveryArtifact','Write-OwnerOnlyFile -Path $script:recoveryPendingExternal -Bytes $dpapi -RecoveryArtifact'); Check='PortableRecovery'},
    @{Name='PARSER_SUCCESS_STREAM_POLLUTION'; Source=$runner.Replace('$added=$seen.Add($property.Name)','$seen.Add($property.Name)'); Check='PortableRecovery'},
    @{Name='RECOVERY_AFTER_MUTATION'; Source=$runner.Replace('Write-EncryptedRecovery -PayloadBytes $recoveryBytes -Passphrase $script:portablePassphrase','# pending recovery omitted'); Check='PortableRecovery'},
    @{Name='PROMOTION_BEFORE_FINAL_READBACK'; Source=$runner.Replace('$remoteFinal=Invoke-Remote -Action ''status''','# final remote readback omitted'); Check='PortableRecovery'},
    @{Name='RUNTIME_ACCESS_NOT_PROVEN'; Source=$runner.Replace('access_as(USER,RUNTIME,os.W_OK|os.X_OK)','True'); Check='RuntimeFilesystem'},
    @{Name='SECRET_UNRELATED_ACCESS_NOT_PROVEN'; Source=$runner.Replace("access_as('nobody',SECRETS,os.R_OK)",'False'); Check='RuntimeFilesystem'},
    @{Name='NO_POST_RESTART_PROFILE_READBACK'; Source=$runner.Replace('[void](Get-ProfileSemanticState -Path $importedProfilePath)','# profile semantic readback omitted'); Check='ProfileRestartReadback'},
    @{Name='CANDIDATE_DELETES_REMOTE_JOURNAL'; Source=$runner.Replace("s['pass_candidate']=True; save_state(s)","shutil.rmtree(TXN)`n    s['pass_candidate']=True; save_state(s)"); Check='RollbackJournalRetention'},
    @{Name='CLOSEOUT_WITHOUT_REVIEWER_PASS'; Source=$runner.Replace('Assert-G4B ($ReviewerDecision -ceq ''FORMAL_PASS_G4B_PERSISTENT_THREE_ROLE_READINESS'') ''CLOSEOUT_REVIEWER_PASS_REQUIRED''','# reviewer decision guard removed'); Check='RollbackJournalRetention'},
    @{Name='POST_REVIEW_MODE_REQUIRES_CURRENT_LIVE_GATE'; Source=$runner.Replace("if (`$Mode -eq 'Run') {",'if ($true) {'); Check='RollbackJournalRetention'},
    @{Name='LIVE_MARKER_MISSING'; Source=$runner.Replace('G4B_REALITY_RUNTIME_ACCESS=PASS','G4B_RUNTIME_MARKER_MISSING'); Check='SanitizedMarkers'}
)
foreach($fixture in $negative){
    $result=Test-RunnerContract $fixture.Source
    Assert-Fixture (-not [bool]$result.($fixture.Check)) ('NEGATIVE_'+$fixture.Name)
}

Write-Output 'G4B_LIVE_RUNNER_FIXTURES=PASS'
Write-Output 'NEGATIVE_FIXTURES=PASS'
Write-Output 'SSH_OR_VPS_ACTION=NO'
Write-Output 'DPAPI_OR_REAL_SECRET_ACCESS=NO'
Write-Output 'EXTERNAL_REQUESTS=0'
Write-Output 'NETWORK_MUTATION=NO'
Write-Output 'CLASH_PROFILE_MUTATION=NO'
Write-Output 'SYSTEM_PROXY_CHANGE=NO'
Write-Output 'TUN_CHANGE=NO'
Write-Output 'SERVICE_MUTATION=NO'
Write-Output 'ROUTE_MUTATION=NO'
Write-Output 'REALITY_LIVE_DEPLOYMENT=NO'
Write-Output 'G4C_EXECUTION=NO'
