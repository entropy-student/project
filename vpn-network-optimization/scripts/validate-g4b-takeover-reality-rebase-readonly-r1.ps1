[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$helperPath = Join-Path $PSScriptRoot 'g4b-takeover-reality-rebase-readonly-r1.ps1'
$validatorPath = $PSCommandPath
$failed = [Collections.Generic.List[string]]::new()
$fixtureRoot = Join-Path ([IO.Path]::GetTempPath()) ('g4b-rebase-r1-' + [guid]::NewGuid().ToString('N'))

function Assert-Fixture {
    param([bool]$Condition, [string]$Name)
    if ($Condition) { [Console]::Out.WriteLine(($Name + '=PASS')) }
    else { $script:failed.Add($Name) }
}

function Get-AstParseResult {
    param([string]$Path)
    $tokens = $null; $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($Path,[ref]$tokens,[ref]$errors)
    return [pscustomobject]@{ Ast=$ast; Errors=@($errors) }
}

function Test-ProviderSourceContract {
    param([string]$Text)
    $tokens = $null; $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($Text,[ref]$tokens,[ref]$errors)
    if (@($errors).Count -gt 0) { return $false }
    $function = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $node.Name -ceq 'Invoke-BaiduReadOnlyAction' },$true))
    if ($function.Count -ne 1) { return $false }
    $body = $function[0].Extent.Text
    $adds = [regex]::Matches($body,'ArgumentList\.Add\(')
    return ($body -match "ValidateSet\('who','ls'\)" -and $adds.Count -eq 3 -and $body -match 'ArgumentList\.Add\(\$Action\)' -and $body -match "ArgumentList\.Add\('-l'\)" -and $body -match 'ArgumentList\.Add\(\$script:recoveryDirectory\)')
}

function Test-ReleaseGuardOrder {
    param([string]$Text)
    $tokens = $null; $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($Text,[ref]$tokens,[ref]$errors)
    if (@($errors).Count -gt 0) { return $false }
    $function = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $node.Name -ceq 'Get-SourceIdentity' },$true))
    if ($function.Count -ne 1) { return $false }
    $body = $function[0].Extent.Text
    $releaseCall = $body.IndexOf('Test-R1ReadOnlyReleaseContract',[StringComparison]::Ordinal)
    $gitRead = $body.IndexOf('Invoke-GitRead',[StringComparison]::Ordinal)
    return ($releaseCall -ge 0 -and $gitRead -gt $releaseCall)
}

function Get-RemoteProbeSha256 {
    param([string]$Text)
    $sha = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($Text)))).Replace('-','').ToLowerInvariant() }
    finally { $sha.Dispose() }
}

function Test-StaticBoundaries {
    param([string]$Text, [string]$RemoteScript)
    $tokens = $null; $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($Text,[ref]$tokens,[ref]$errors)
    if (@($errors).Count -gt 0) { return $false }
    $forbidden = @('New-NetRoute','Remove-NetRoute','Set-NetRoute','New-NetFirewallRule','Set-NetFirewallRule','Start-Service','Stop-Service','Restart-Service','Set-Service','Set-Acl','Remove-Item','New-Item','Set-Content','Add-Content','Out-File','Clear-Content','Copy-Item','Move-Item','Invoke-WebRequest','Invoke-RestMethod','curl.exe')
    $commands = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.CommandAst] },$true))
    $allowed = @('Assert-BaiduConfigAclMetadata','Assert-R1','Assert-SafeBaiduConfigDirectory','Find-VerifiedBaiduCli','ForEach-Object','Format-R1MarkerLine','Get-Acl','Get-BaiduListingCounts','Get-BaiduRealityState','Get-BoundedLocalArtifactCounts','Get-ChildItem','Get-Command','Get-DirectMetadataItems','Get-FileHash','Get-IPv4PrefixLength','Get-Item','Get-ItemProperty','Get-LocalArtifactSnapshot','Get-NetAdapter','Get-NetIPInterface','Get-NetRoute','Get-OptionalPropertyValue','Get-PinnedBaiduExecutableHashFromArchive','Get-RealityClassification','Get-RemoteRealityState','Get-RemoteSnapshot','Get-RouteFingerprint','Get-RouteState','Get-SelectedRouteForIPv4','Get-Service','Get-SourceIdentity','Get-TunAdapterCount','Get-UnknownRemoteState','Get-VerifiedBaiduCli','Get-WindowsBaseline','Invoke-BaiduReadOnlyAction','Invoke-GitRead','Invoke-R1Checkpoint','Invoke-ReadOnlyNative','Join-Path','Measure-Object','Read-Host','Resolve-Path','Resolve-ProfileStoreSnapshot','Set-StrictMode','Sort-Object','Split-Path','Test-IPv4PrefixContains','Test-Path','Test-PathWithin','Test-RemoteReadOnlyOutput','Test-RemoteReadOnlyProbe','Test-R1ReadOnlyReleaseContract','Test-StrictSshArguments','Where-Object','Write-R1Marker')
    if (@($commands | Where-Object { $_.GetCommandName() -cnotin $allowed }).Count -gt 0) { return $false }
    if (@($commands | Where-Object { $_.GetCommandName() -cin $forbidden }).Count -gt 0) { return $false }
    $outputWriters = @('Write-Output','Write-Host','Write-Information','Write-Warning','Write-Error','Write-Verbose','Write-Debug')
    if (@($commands | Where-Object { $_.GetCommandName() -cin $outputWriters }).Count -gt 0) { return $false }
    $consoleWrites = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.InvokeMemberExpressionAst] -and $node.Member.Extent.Text -ceq 'WriteLine' },$true))
    if ($consoleWrites.Count -ne 1 -or $consoleWrites[0].Arguments.Count -ne 1 -or $consoleWrites[0].Arguments[0].Extent.Text -notmatch 'Format-R1MarkerLine') { return $false }
    $parent = $consoleWrites[0].Parent
    while ($null -ne $parent -and $parent -isnot [System.Management.Automation.Language.FunctionDefinitionAst]) { $parent=$parent.Parent }
    if ($null -eq $parent -or $parent.Name -cne 'Write-R1Marker') { return $false }
    if ($Text -match '(?i)\[(?:io\.)?file\]::(?:Write|Create|Delete|Move)|\[(?:io\.)?directory\]::(?:Create|Delete|Move)|FileSystemAclExtensions\]::Create') { return $false }
    if (-not (Test-RemoteReadOnlyProbe -ScriptText $RemoteScript)) { return $false }
    if (-not (Test-ProviderActionAllowlist -Actions @('who','ls'))) { return $false }
    if (-not (Test-ProviderSourceContract -Text $Text)) { return $false }
    return $true
}

function New-SyntheticAce {
    param([string]$Sid, [Security.AccessControl.FileSystemRights]$Rights, [Security.AccessControl.AccessControlType]$Type=[Security.AccessControl.AccessControlType]::Allow, [bool]$Inherited=$false, [Security.AccessControl.PropagationFlags]$Propagation=[Security.AccessControl.PropagationFlags]::None)
    return [pscustomobject]@{
        IdentityReference=[Security.Principal.SecurityIdentifier]::new($Sid)
        AccessControlType=$Type
        IsInherited=$Inherited
        FileSystemRights=$Rights
        PropagationFlags=$Propagation
    }
}

function Test-AclFixture {
    param([string]$OwnerSid, [object[]]$Rules, [string]$ExpectedOwnerSid=$OwnerSid)
    try {
        Assert-BaiduConfigAclMetadata -ActualOwnerSid $ExpectedOwnerSid -ExpectedOwnerSid ([Security.Principal.SecurityIdentifier]::new($OwnerSid)) -Rules $Rules -IsDirectory $false
        return $true
    }
    catch { return $false }
}

try {
    $helperParse = Get-AstParseResult -Path $helperPath
    $validatorParse = Get-AstParseResult -Path $validatorPath
    Assert-Fixture ($helperParse.Errors.Count -eq 0 -and $validatorParse.Errors.Count -eq 0) 'POWERSHELL_AST_PARSE'

    . $helperPath -LibraryOnly

    $releaseGateText = '`G4B_TAKEOVER_REALITY_REBASE_READONLY_R1`'
    $releaseHandoffLines = @('GATE_ID=G4B_TAKEOVER_REALITY_REBASE_READONLY_R1','R1_OWNER_READONLY_CHECKPOINT_RELEASED=YES','FRESH_LIVE_GATE_RELEASED=NO')
    $releaseHandoff = $releaseHandoffLines -join "`n"
    Assert-Fixture (Test-R1ReadOnlyReleaseContract -HandoffText $releaseHandoff -GateText $releaseGateText) 'READONLY_RELEASE_POSITIVE'
    $notReleased = ($releaseHandoff -replace '(?m)^R1_OWNER_READONLY_CHECKPOINT_RELEASED=YES$','R1_OWNER_READONLY_CHECKPOINT_RELEASED=NO')
    Assert-Fixture (-not (Test-R1ReadOnlyReleaseContract -HandoffText $notReleased -GateText $releaseGateText)) 'READONLY_RELEASE_NOT_RELEASED_NEGATIVE'
    $missingRelease = @('GATE_ID=G4B_TAKEOVER_REALITY_REBASE_READONLY_R1','FRESH_LIVE_GATE_RELEASED=NO') -join "`n"
    Assert-Fixture (-not (Test-R1ReadOnlyReleaseContract -HandoffText $missingRelease -GateText $releaseGateText)) 'READONLY_RELEASE_MISSING_NEGATIVE'
    $liveReleaseConflict = ($releaseHandoff -replace '(?m)^FRESH_LIVE_GATE_RELEASED=NO$','FRESH_LIVE_GATE_RELEASED=YES')
    Assert-Fixture (-not (Test-R1ReadOnlyReleaseContract -HandoffText $liveReleaseConflict -GateText $releaseGateText)) 'LIVE_GATE_RELEASE_CONFLICT_NEGATIVE'
    $gateMismatch = ($releaseHandoff -replace '(?m)^GATE_ID=.*$','GATE_ID=G4B_OTHER_GATE')
    Assert-Fixture (-not (Test-R1ReadOnlyReleaseContract -HandoffText $gateMismatch -GateText $releaseGateText)) 'GATE_ID_MISMATCH_NEGATIVE'
    Assert-Fixture (Test-ReleaseGuardOrder -Text ([IO.File]::ReadAllText($helperPath,[Text.Encoding]::UTF8))) 'READONLY_RELEASE_GUARD_BEFORE_SOURCE_READ'

    $empty = Get-BoundedLocalArtifactCounts -RuntimeNames @() -RuntimeKinds @() -RecoveryNames @() -ProfileNames @()
    Assert-Fixture ($empty.RuntimeCount -eq 0 -and $empty.JournalCount -eq 0 -and $empty.PendingCount -eq 0 -and $empty.ProfileCount -eq 0 -and -not $empty.RecoveryFinal) 'EMPTY_METADATA_FIXTURE'
    $local = Get-BoundedLocalArtifactCounts -RuntimeNames @('g4b-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa') -RuntimeKinds @('DIR') -RecoveryNames @('reality-g4b.dpapi','vpn-network-optimization-g4b-bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb.vpr1.pending') -ProfileNames @('SELF-VPN-V1.yaml','other.yaml')
    Assert-Fixture ($local.RuntimeCount -eq 1 -and $local.PendingCount -eq 1 -and $local.RecoveryFinal -and $local.ProfileCount -eq 1) 'LOCAL_METADATA_FIXTURE'
    $journal = Get-BoundedLocalArtifactCounts -RuntimeNames @('g4b-cccccccccccccccccccccccccccccccc.rollback.json') -RuntimeKinds @('FILE') -RecoveryNames @() -ProfileNames @()
    Assert-Fixture ($journal.JournalCount -eq 1) 'JOURNAL_METADATA_FIXTURE'

    $wgRoutes = @([pscustomobject]@{ DestinationPrefix='0.0.0.0/1'; InterfaceIndex=13; RouteMetric=5 })
    $selectedWg = Get-SelectedRouteForIPv4 -Routes $wgRoutes -InterfaceMetrics @{13=10} -Address '10.66.21.1'
    Assert-Fixture ($null -ne $selectedWg -and $selectedWg.InterfaceIndex -eq 13) 'CONTROL_ROUTE_WIREGUARD_FIXTURE'
    $wrongRoute = $wgRoutes + @([pscustomobject]@{ DestinationPrefix='10.66.21.0/24'; InterfaceIndex=18; RouteMetric=1 })
    $selectedWrong = Get-SelectedRouteForIPv4 -Routes $wrongRoute -InterfaceMetrics @{13=10;18=1} -Address '10.66.21.1'
    Assert-Fixture ($null -ne $selectedWrong -and $selectedWrong.InterfaceIndex -eq 18) 'CONTROL_ROUTE_MISMATCH_FIXTURE'
    $ambiguousRoutes = $wgRoutes + @([pscustomobject]@{ DestinationPrefix='10.66.21.0/24'; InterfaceIndex=13; RouteMetric=1 },[pscustomobject]@{ DestinationPrefix='10.66.21.0/24'; InterfaceIndex=18; RouteMetric=1 })
    $selectedAmbiguous = Get-SelectedRouteForIPv4 -Routes $ambiguousRoutes -InterfaceMetrics @{13=10;18=10} -Address '10.66.21.1'
    Assert-Fixture ($null -eq $selectedAmbiguous) 'CONTROL_ROUTE_AMBIGUOUS_FAIL_CLOSED'

    $listing = @"
当前目录: /vpn-network-optimization-g4b-recovery
-rw------- 1 user group 100 vpn-network-optimization-g4b.vpr1
-rw------- 1 user group 100 vpn-network-optimization-g4b-dddddddddddddddddddddddddddddddd.vpr1.pending
-rw------- 1 user group 100 vpn-network-optimization-g4b-unrecognized-object
-rw------- 1 user group 100 r17-quarantine-eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee.vpr1.pending
"@
    $listingCounts = Get-BaiduListingCounts -Listing $listing
    Assert-Fixture ($listingCounts.Valid -and $listingCounts.FinalCount -eq 1 -and $listingCounts.PendingCount -eq 1 -and $listingCounts.UnknownCount -eq 1 -and $listingCounts.QuarantineCount -eq 1) 'BAIDU_LISTING_COUNTS_FIXTURE'
    $badListing = Get-BaiduListingCounts -Listing 'provider raw output must not be accepted'
    Assert-Fixture (-not $badListing.Valid -and $badListing.FinalCount -ceq 'UNKNOWN') 'BAIDU_LISTING_INVALID_FAIL_CLOSED'

    $cleanWindows = [pscustomobject]@{ Known=$true; Healthy=$true }
    $cleanLocal = [pscustomobject]@{ Known=$true; RuntimeCount=0; JournalCount=0; RecoveryFinal=$false; PendingCount=0; ProfileCount=0 }
    $cleanVps = [pscustomobject]@{ Known=$true; Healthy=$true; Residual=$false }
    $cleanBaidu = [pscustomobject]@{ Known=$true; Identity='PASS'; DirectoryReadable='YES'; FinalCount=0; PendingCount=0; UnknownCount=0; QuarantineCount=2 }
    Assert-Fixture ((Get-RealityClassification -Windows $cleanWindows -Local $cleanLocal -Vps $cleanVps -Baidu $cleanBaidu) -ceq 'CLEAN_BASELINE') 'CLEAN_CLASSIFICATION_FIXTURE'
    $residualLocal = [pscustomobject]@{ Known=$true; RuntimeCount=1; JournalCount=0; RecoveryFinal=$false; PendingCount=0; ProfileCount=0 }
    Assert-Fixture ((Get-RealityClassification -Windows $cleanWindows -Local $residualLocal -Vps $cleanVps -Baidu $cleanBaidu) -ceq 'PROJECT_RESIDUAL_PRESENT') 'RESIDUAL_CLASSIFICATION_FIXTURE'
    $unknownBaidu = [pscustomobject]@{ Known=$false; Identity='UNKNOWN'; DirectoryReadable='UNKNOWN'; FinalCount='UNKNOWN'; PendingCount='UNKNOWN'; UnknownCount='UNKNOWN'; QuarantineCount='UNKNOWN' }
    Assert-Fixture ((Get-RealityClassification -Windows $cleanWindows -Local $cleanLocal -Vps $cleanVps -Baidu $unknownBaidu) -ceq 'AMBIGUOUS_BASELINE') 'AMBIGUOUS_CLASSIFICATION_FIXTURE'

    $ownerSid = 'S-1-5-21-101-202-303-1001'
    $readRights = [Security.AccessControl.FileSystemRights]::ReadData -bor [Security.AccessControl.FileSystemRights]::ReadAttributes -bor [Security.AccessControl.FileSystemRights]::ReadExtendedAttributes -bor [Security.AccessControl.FileSystemRights]::ReadPermissions
    $ownerOnly = @(New-SyntheticAce -Sid $ownerSid -Rights ([Security.AccessControl.FileSystemRights]::FullControl))
    Assert-Fixture (Test-AclFixture -OwnerSid $ownerSid -Rules $ownerOnly) 'ACL_OWNER_ONLY_FIXTURE'
    $ownerSystemAdmins = @($ownerOnly) + @((New-SyntheticAce -Sid 'S-1-5-18' -Rights ([Security.AccessControl.FileSystemRights]::ReadAndExecute)),(New-SyntheticAce -Sid 'S-1-5-32-544' -Rights ([Security.AccessControl.FileSystemRights]::ReadAndExecute)))
    Assert-Fixture (Test-AclFixture -OwnerSid $ownerSid -Rules $ownerSystemAdmins) 'ACL_ALLOWED_SYSTEM_ADMINS_FIXTURE'
    $inheritedSafe = @((New-SyntheticAce -Sid $ownerSid -Rights ([Security.AccessControl.FileSystemRights]::FullControl) -Inherited $true))
    Assert-Fixture (Test-AclFixture -OwnerSid $ownerSid -Rules $inheritedSafe) 'ACL_INHERITED_ALLOWLIST_FIXTURE'
    $broad = @($ownerOnly) + @((New-SyntheticAce -Sid 'S-1-5-32-545' -Rights ([Security.AccessControl.FileSystemRights]::ReadData)))
    Assert-Fixture (-not (Test-AclFixture -OwnerSid $ownerSid -Rules $broad)) 'ACL_BROAD_ALLOW_REJECTED'
    $arbitrary = @($ownerOnly) + @((New-SyntheticAce -Sid 'S-1-5-21-5-6-7-8' -Rights ([Security.AccessControl.FileSystemRights]::ReadData)))
    Assert-Fixture (-not (Test-AclFixture -OwnerSid $ownerSid -Rules $arbitrary)) 'ACL_ARBITRARY_ALLOW_REJECTED'
    $deny = @($ownerOnly) + @((New-SyntheticAce -Sid 'S-1-5-18' -Rights ([Security.AccessControl.FileSystemRights]::ReadData) -Type ([Security.AccessControl.AccessControlType]::Deny)))
    Assert-Fixture (-not (Test-AclFixture -OwnerSid $ownerSid -Rules $deny)) 'ACL_DENY_REJECTED'
    $missingOwnerRights = @((New-SyntheticAce -Sid $ownerSid -Rights ([Security.AccessControl.FileSystemRights]::WriteData)))
    Assert-Fixture (-not (Test-AclFixture -OwnerSid $ownerSid -Rules $missingOwnerRights)) 'ACL_OWNER_READ_RIGHTS_REJECTED'
    Assert-Fixture (-not (Test-AclFixture -OwnerSid $ownerSid -ExpectedOwnerSid 'S-1-5-21-9-8-7-6' -Rules $ownerOnly)) 'ACL_OWNER_MISMATCH_REJECTED'

    $sshArgs = @('-T','-i','fixture-key','-o','BatchMode=yes','-o','IdentitiesOnly=yes','-o','StrictHostKeyChecking=yes','-o','UpdateHostKeys=no','-o','HostKeyAlias=24.199.118.137','-o','UserKnownHostsFile=fixture-known-hosts','-o','ConnectTimeout=10','root@10.66.21.1',$script:remoteProbe)
    Assert-Fixture (Test-StrictSshArguments -Arguments $sshArgs) 'SSH_STRICT_TRUST_FIXTURE'
    $sshUnsafe = @($sshArgs | ForEach-Object { if ($_ -ceq 'StrictHostKeyChecking=yes') { 'StrictHostKeyChecking=no' } else { $_ } })
    Assert-Fixture (-not (Test-StrictSshArguments -Arguments $sshUnsafe)) 'SSH_TRUST_NEGATIVE_FIXTURE'
    Assert-Fixture (Test-RemoteReadOnlyProbe -ScriptText $script:remoteProbe) 'REMOTE_READONLY_ALLOWLIST_FIXTURE'
    Assert-Fixture (-not (Test-RemoteReadOnlyProbe -ScriptText ($script:remoteProbe + "`nrm -rf /"))) 'REMOTE_DELETE_NEGATIVE_FIXTURE'
    Assert-Fixture (-not (Test-RemoteReadOnlyProbe -ScriptText ($script:remoteProbe + "`nsystemctl restart wg-quick@wg0"))) 'REMOTE_SERVICE_MUTATION_NEGATIVE_FIXTURE'
    Assert-Fixture (-not (Test-RemoteReadOnlyProbe -ScriptText ($script:remoteProbe + "`n/usr/bin/curl https://example.invalid"))) 'REMOTE_UNLISTED_COMMAND_NEGATIVE_FIXTURE'
    Assert-Fixture (Test-ProviderActionAllowlist -Actions @('who','ls')) 'PROVIDER_READONLY_ALLOWLIST_FIXTURE'
    Assert-Fixture (-not (Test-ProviderActionAllowlist -Actions @('who','rm'))) 'PROVIDER_MUTATION_NEGATIVE_FIXTURE'

    $validMarker = Format-R1MarkerLine -Name 'BAIDU_IDENTITY_CHECK' -Value 'PASS'
    $secretMarkerRejected = $false
    try { [void](Format-R1MarkerLine -Name 'BAIDU_IDENTITY_CHECK' -Value 'SYNTHETIC_SECRET_SHOULD_NOT_EMIT') } catch { $secretMarkerRejected=$true }
    Assert-Fixture ($validMarker -ceq 'BAIDU_IDENTITY_CHECK=PASS' -and $secretMarkerRejected -and $validMarker -notmatch 'SYNTHETIC_SECRET') 'LOCAL_SECRET_OUTPUT_NEGATIVE'

    $sourceText = [IO.File]::ReadAllText($helperPath,[Text.Encoding]::UTF8)
    Assert-Fixture (Test-StaticBoundaries -Text $sourceText -RemoteScript $script:remoteProbe) 'READONLY_COMMAND_ALLOWLIST'
    Assert-Fixture (-not (Test-StaticBoundaries -Text ($sourceText + "`nNew-NetRoute -DestinationPrefix '203.0.113.7/32' -NextHop '192.0.2.1' -PolicyStore ActiveStore") -RemoteScript $script:remoteProbe)) 'WRITE_COMMAND_NEGATIVE_SCAN'
    Assert-Fixture (-not (Test-StaticBoundaries -Text ($sourceText + "`nWrite-Host `$cookie") -RemoteScript $script:remoteProbe)) 'SECRET_OUTPUT_NEGATIVE_MUTATION'
    $sourceTokens = $null; $sourceErrors = $null
    $sourceAst = [System.Management.Automation.Language.Parser]::ParseInput($sourceText,[ref]$sourceTokens,[ref]$sourceErrors)
    $providerDefinition = @($sourceAst.FindAll({ param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $node.Name -ceq 'Invoke-BaiduReadOnlyAction' },$true))[0]
    $providerMutated = $providerDefinition.Extent.Text.Replace('ArgumentList.Add($Action)',"ArgumentList.Add('rm')")
    Assert-Fixture (-not (Test-ProviderSourceContract -Text $providerMutated)) 'PROVIDER_ARGUMENT_MUTATION_NEGATIVE'
    Assert-Fixture (-not (Test-RemoteReadOnlyProbe -ScriptText ($script:remoteProbe.Replace('systemctl show','systemctl set-property')))) 'REMOTE_MUTATION_NEGATIVE_SCAN'
    $remoteProbeSha = Get-RemoteProbeSha256 -Text $script:remoteProbe
    Assert-Fixture ($remoteProbeSha -ceq 'cff82a5708b63f8ce6b7d0ba171eee04ec73229723e51bd7e1118a05a57dd23a') 'REMOTE_PROBE_IDENTITY_FIXTURE'
    $consoleMutation = $sourceText + "`n[Console]::Out.WriteLine(`$cookie)"
    Assert-Fixture (-not (Test-StaticBoundaries -Text $consoleMutation -RemoteScript $script:remoteProbe)) 'RAW_CONSOLE_SECRET_NEGATIVE_MUTATION'

    [void](New-Item -ItemType Directory -Path $fixtureRoot -ErrorAction Stop)
    [IO.File]::WriteAllText((Join-Path $fixtureRoot 'fixture.txt'),'NONSECRET-G4B-R1-FIXTURE',[Text.Encoding]::ASCII)
    Assert-Fixture (Test-Path -LiteralPath (Join-Path $fixtureRoot 'fixture.txt') -PathType Leaf) 'FIXTURE_CREATE'
}
catch {
    $failed.Add('VALIDATOR_RUNTIME_FAILURE')
}
finally {
    if (Test-Path -LiteralPath $fixtureRoot) {
        try { Remove-Item -LiteralPath $fixtureRoot -Recurse -Force -ErrorAction Stop } catch { $failed.Add('FIXTURE_CLEAN') }
    }
}

$fixtureClean = -not (Test-Path -LiteralPath $fixtureRoot)
Assert-Fixture $fixtureClean 'FIXTURE_CLEAN'
if ($failed.Count -eq 0) {
    [Console]::Out.WriteLine('G4B_TAKEOVER_R1_OFFLINE_VALIDATOR=PASS')
    [Console]::Out.WriteLine('POWERSHELL_AST=PASS')
    [Console]::Out.WriteLine('READONLY_RELEASE_POSITIVE=PASS')
    [Console]::Out.WriteLine('READONLY_RELEASE_NOT_RELEASED_NEGATIVE=PASS')
    [Console]::Out.WriteLine('READONLY_RELEASE_MISSING_NEGATIVE=PASS')
    [Console]::Out.WriteLine('LIVE_GATE_RELEASE_CONFLICT_NEGATIVE=PASS')
    [Console]::Out.WriteLine('GATE_ID_MISMATCH_NEGATIVE=PASS')
    [Console]::Out.WriteLine('READONLY_COMMAND_ALLOWLIST=PASS')
    [Console]::Out.WriteLine('WRITE_COMMAND_NEGATIVE_SCAN=PASS')
    [Console]::Out.WriteLine('SSH_STRICT_TRUST_CONTRACT=PASS')
    [Console]::Out.WriteLine('LOCAL_SECRET_OUTPUT_NEGATIVE=PASS')
    [Console]::Out.WriteLine('PROVIDER_MUTATION_NEGATIVE=PASS')
    [Console]::Out.WriteLine('REMOTE_MUTATION_NEGATIVE=PASS')
    [Console]::Out.WriteLine('FIXTURE_CLEAN=PASS')
    [Console]::Out.WriteLine('OWNER_CHECKPOINT_EXECUTED=NO')
    [Console]::Out.WriteLine('SECRET_OR_DPAPI_ACCESSED=NO')
    [Console]::Out.WriteLine('SSH_VPS_PROVIDER_ACTIONS=0')
    [Console]::Out.WriteLine('NETWORK_OR_CLASH_MUTATION=NO')
    [Console]::Out.WriteLine('STOP_AT_REVIEWER=YES')
    exit 0
}

[Console]::Out.WriteLine('G4B_TAKEOVER_R1_OFFLINE_VALIDATOR=FAIL')
foreach ($name in $failed) { [Console]::Out.WriteLine(('FAILED_FIXTURE=' + $name)) }
exit 1
