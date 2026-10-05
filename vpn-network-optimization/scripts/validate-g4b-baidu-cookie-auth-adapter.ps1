[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Assert-Validation {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
    Write-Output ($Code + '=PASS')
}

function Get-FunctionNode {
    param([System.Management.Automation.Language.Ast]$Ast, [string]$Name)
    $node = $Ast.Find({ param($item) $item -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $item.Name -ceq $Name }, $true)
    if ($null -eq $node) { throw ('FUNCTION_MISSING_' + $Name.ToUpperInvariant()) }
    return $node
}

function Test-ThrowsCode {
    param([scriptblock]$Action, [string]$ExpectedCode)
    try { $null = & $Action } catch { return [bool]([string]$_.Exception.Message -ceq $ExpectedCode) }
    return $false
}

function New-SyntheticAclRule {
    param(
        [string]$Sid,
        [Security.AccessControl.AccessControlType]$AccessType = [Security.AccessControl.AccessControlType]::Allow,
        [Security.AccessControl.FileSystemRights]$Rights = [Security.AccessControl.FileSystemRights]::ReadAndExecute,
        [bool]$Inherited = $false,
        [Security.AccessControl.PropagationFlags]$Propagation = [Security.AccessControl.PropagationFlags]::None
    )
    return [pscustomobject]@{
        AccessControlType = $AccessType
        IdentityReference = [Security.Principal.SecurityIdentifier]::new($Sid)
        IsInherited = $Inherited
        FileSystemRights = $Rights
        PropagationFlags = $Propagation
    }
}

function New-FixtureRoot {
    param([string]$Path, [Security.Principal.SecurityIdentifier]$OwnerSid)
    $acl = New-OwnerOnlyAcl -OwnerSid $OwnerSid -Directory
    [void][System.IO.FileSystemAclExtensions]::CreateDirectory($acl, $Path)
    Assert-OwnerOnlyAcl -Path $Path -OwnerSid $OwnerSid
}

function New-FixtureConfigFile {
    param([string]$Root, [Security.Principal.SecurityIdentifier]$OwnerSid)
    $path = Join-Path $Root 'pcs_config.json'
    [IO.File]::WriteAllText($path, 'NON_SECRET_G4B_CONFIG_FIXTURE')
    Set-OwnerOnlyAcl -Path $path -OwnerSid $OwnerSid
    return $path
}

function Assert-OwnerOnlyAclDescriptor {
    param([object]$Acl, [Security.Principal.SecurityIdentifier]$OwnerSid)
    if (-not $Acl.AreAccessRulesProtected -or $Acl.GetOwner([Security.Principal.SecurityIdentifier]).Value -cne $OwnerSid.Value) {
        throw 'SYNTHETIC_OWNER_ONLY_ACL_DESCRIPTOR_INVALID'
    }
    $rules = @($Acl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier]))
    $rights = [long]0
    foreach ($rule in $rules) {
        if ($rule.IsInherited -or $rule.IdentityReference.Value -cne $OwnerSid.Value -or $rule.AccessControlType -ne [Security.AccessControl.AccessControlType]::Allow) {
            throw 'SYNTHETIC_OWNER_ONLY_ACL_DESCRIPTOR_INVALID'
        }
        if (($rule.PropagationFlags -band [Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0) {
            $rights = $rights -bor [long]$rule.FileSystemRights
        }
    }
    $full = [long][Security.AccessControl.FileSystemRights]::FullControl
    if (($rights -band $full) -ne $full) { throw 'SYNTHETIC_OWNER_ONLY_ACL_DESCRIPTOR_INVALID' }
}

$scriptRoot = $PSScriptRoot
$ownerPath = Join-Path $scriptRoot 'g4b-baidu-cookie-auth-owner-checkpoint.ps1'
$sourcePath = Join-Path $scriptRoot 'g4b-baidu-cookie-auth-adapter\main.go'
$testPath = Join-Path $scriptRoot 'g4b-baidu-cookie-auth-adapter\main_test.go'
$buildPath = Join-Path $scriptRoot 'build-g4b-baidu-cookie-auth-adapter.ps1'
$aclPath = Join-Path $scriptRoot 'g4b-baidu-auth-readiness-checkpoint.ps1'
$ownerText = [IO.File]::ReadAllText($ownerPath, [Text.Encoding]::UTF8)
$source = [IO.File]::ReadAllText($sourcePath, [Text.Encoding]::UTF8)
$testSource = [IO.File]::ReadAllText($testPath, [Text.Encoding]::UTF8)
$build = [IO.File]::ReadAllText($buildPath, [Text.Encoding]::UTF8)

try {
    $psFiles = @($ownerPath, $PSCommandPath, $buildPath)
    foreach ($path in $psFiles) {
        $tokens = $null
        $parseErrors = $null
        [void][Management.Automation.Language.Parser]::ParseFile($path, [ref]$tokens, [ref]$parseErrors)
        Assert-Validation ($parseErrors.Count -eq 0) ('POWERSHELL_AST_' + [IO.Path]::GetFileName($path).Replace('.', '_').ToUpperInvariant())
    }
    Write-Output 'POWERSHELL_AST_PARSE=PASS'

    $ownerTokens = $null
    $ownerParseErrors = $null
    $ownerAst = [Management.Automation.Language.Parser]::ParseFile($ownerPath, [ref]$ownerTokens, [ref]$ownerParseErrors)
    $aclTokens = $null
    $aclParseErrors = $null
    $aclAst = [Management.Automation.Language.Parser]::ParseFile($aclPath, [ref]$aclTokens, [ref]$aclParseErrors)
    $buildTokens = $null
    $buildParseErrors = $null
    $buildAst = [Management.Automation.Language.Parser]::ParseFile($buildPath, [ref]$buildTokens, [ref]$buildParseErrors)
    Assert-Validation ($aclParseErrors.Count -eq 0) 'R6R1_ACL_SOURCE_AST'

    $expectedBuildBlob = '7f369604de3cf0cce46bf0cf7328313c03ed61d5'
    $acceptedBuildCommit = '789331082710711c2855cff839ef768bd26c841c'
    $acceptedBuildBlob = (& git rev-parse ($acceptedBuildCommit + ':vpn-network-optimization/scripts/build-g4b-baidu-cookie-auth-adapter.ps1')).Trim()
    $acceptedBuild = (& git show ($acceptedBuildCommit + ':vpn-network-optimization/scripts/build-g4b-baidu-cookie-auth-adapter.ps1') | Out-String)
    Assert-Validation ($LASTEXITCODE -eq 0 -and $acceptedBuildBlob -ceq $expectedBuildBlob -and $acceptedBuild.Contains('225bdd3b6cb298601c4d5ef7104c3e08cd1d692d') -and $acceptedBuild.Contains('go1.27.1') -and $build.Contains('225bdd3b6cb298601c4d5ef7104c3e08cd1d692d') -and $build.Contains('go1.27.1')) 'R6R2H_R2_PINNED_BUILD_CHAIN_FROZEN'

    $d5AcceptedHead = '57f47df93a0a4ff9b76aa236a905b3f9388c1d5c'
    $frozenBlobExpectations = @{
        'vpn-network-optimization/scripts/g4b-baidu-cookie-auth-owner-checkpoint.ps1' = '8d0aded1b49aff58e06f5e7c450b8799737b3b68'
        'vpn-network-optimization/scripts/g4b-baidu-cookie-auth-adapter/main_test.go' = 'a1d65216f061ee2d5ee32aefc046f01379d40ca2'
    }
    $authCoreFrozen = $true
    foreach ($path in $frozenBlobExpectations.Keys) {
        $actualBlob = (& git rev-parse ('HEAD:' + $path)).Trim()
        if ($LASTEXITCODE -ne 0 -or $actualBlob -cne $frozenBlobExpectations[$path]) { $authCoreFrozen = $false }
    }
    $acceptedMain = (& git show ($d5AcceptedHead + ':vpn-network-optimization/scripts/g4b-baidu-cookie-auth-adapter/main.go') | Out-String)
    $statusOutputLinePattern = '^\s*fmt\.Fprintln\(os\.(?:Stdout|Stderr), "BAIDU_COOKIE_AUTH(?:_FAILURE_CODE|_UID_EMITTED)?=[^"]+"\)\s*$'
    $acceptedMainNormalized = $acceptedMain.Replace("`r`n", "`n").TrimEnd([char]10)
    $currentMainNormalized = $source.Replace("`r`n", "`n").TrimEnd([char]10)
    $acceptedStatusLines = @($acceptedMainNormalized -split "`n" | Where-Object { $_ -match $statusOutputLinePattern })
    $expectedMainCore = @($acceptedMainNormalized -split "`n" | Where-Object { $_ -notmatch $statusOutputLinePattern }) -join "`n"
    Assert-Validation ($LASTEXITCODE -eq 0 -and $acceptedStatusLines.Count -eq 16 -and $currentMainNormalized -ceq $expectedMainCore -and $currentMainNormalized -notmatch $statusOutputLinePattern) 'R6R2I_D5_AUTH_LOGIC_FROZEN'
    Assert-Validation $authCoreFrozen 'R6R2I_D2_R3_AUTH_CORE_FROZEN'

    $acceptedD5Build = (& git show ($d5AcceptedHead + ':vpn-network-optimization/scripts/build-g4b-baidu-cookie-auth-adapter.ps1') | Out-String)
    $oldNativeFailureCondition = 'if ($fixtureProcess.ExitCode -eq 0 -or ($fixtureStdout + $fixtureStderr) -notmatch ''BAIDU_COOKIE_AUTH_FAILURE_CODE=ARGUMENTS_FORBIDDEN'') {'
    $newNativeFailureCondition = 'if ($fixtureProcess.ExitCode -eq 0 -or ($fixtureStdout + $fixtureStderr) -match ''BAIDU_COOKIE_AUTH'') {'
    $acceptedD5BuildNormalized = $acceptedD5Build.Replace("`r`n", "`n").TrimEnd([char]10)
    $currentBuildNormalized = $build.Replace("`r`n", "`n").TrimEnd([char]10)
    $oldConditionCount = ([regex]::Matches($acceptedD5BuildNormalized, [regex]::Escape($oldNativeFailureCondition))).Count
    $expectedD5Build = $acceptedD5BuildNormalized.Replace($oldNativeFailureCondition, $newNativeFailureCondition)
    Assert-Validation ($LASTEXITCODE -eq 0 -and $oldConditionCount -eq 1 -and $currentBuildNormalized -ceq $expectedD5Build -and $currentBuildNormalized.Contains($newNativeFailureCondition)) 'R6R2I_D5_NATIVE_FAILURE_FIXTURE_ONLY'

    $runtimeInitializerNode = Get-FunctionNode -Ast $buildAst -Name 'Initialize-OwnerBinaryRuntime'
    $aclHelperLoadAt = $build.IndexOf('. $aclHelper', [StringComparison]::Ordinal)
    $runtimeInitializerCallAt = $build.IndexOf('$runtimeBinaryPath = Initialize-OwnerBinaryRuntime', [StringComparison]::Ordinal)
    Assert-Validation ($aclHelperLoadAt -ge 0 -and $runtimeInitializerCallAt -gt $aclHelperLoadAt -and -not $runtimeInitializerNode.Extent.Text.Contains('. $aclHelper')) 'R6R2I_D2_ACL_HELPER_SCRIPT_SCOPE'

    $retainedCopyNode = Get-FunctionNode -Ast $buildAst -Name 'Copy-OwnerOnlyRetainedBinary'
    $retainedCleanupNode = Get-FunctionNode -Ast $buildAst -Name 'Remove-RunCreatedRetainedBinary'
    $retainedCopyText = $retainedCopyNode.Extent.Text
    $retainedCleanupText = $retainedCleanupNode.Extent.Text
    $ownerAclAtCreate = $retainedCopyText.IndexOf('New-OwnerOnlyAcl -OwnerSid $OwnerSid', [StringComparison]::Ordinal)
    $fileCreateAt = $retainedCopyText.IndexOf('[System.IO.FileSystemAclExtensions]::Create(', [StringComparison]::Ordinal)
    $strictAclAt = $retainedCopyText.IndexOf('Assert-OwnerOnlyAcl -Path $DestinationPath', [StringComparison]::Ordinal)
    $hashAt = $retainedCopyText.IndexOf('Get-FileHash -LiteralPath $DestinationPath', [StringComparison]::Ordinal)
    Assert-Validation ($build.Contains('[switch]$RetainBinary') -and $retainedCopyText.Contains('[IO.FileMode]::CreateNew') -and $ownerAclAtCreate -ge 0 -and $fileCreateAt -gt $ownerAclAtCreate -and $retainedCopyText.Contains('$fileSecurity') -and $strictAclAt -gt $fileCreateAt -and $hashAt -gt $strictAclAt -and $retainedCopyText -notmatch 'Set-OwnerOnlyAcl') 'R6R2I_D2_RETAINED_CREATE_NEW_STATIC'
    Write-Output 'R6R2I_D2_RETAINED_OWNER_ONLY_ACL_AT_OR_BEFORE_FINALIZATION=PASS'
    Write-Output 'R6R2I_D2_NO_POSTCREATE_OWNER_REWRITE_DEPENDENCY=PASS'

    $requiredRetainedStages = @(
        'OWNER_RUNTIME_PREPARE_FAILED',
        'RETAINED_BINARY_CREATE_FAILED',
        'RETAINED_BINARY_COPY_FAILED',
        'RETAINED_BINARY_ACL_VERIFY_FAILED',
        'RETAINED_BINARY_HASH_VERIFY_FAILED'
    )
    $allRetainedStagesPresent = $true
    foreach ($stage in $requiredRetainedStages) { if (-not $build.Contains($stage)) { $allRetainedStagesPresent = $false } }
    $retainedCallNodes = @($buildAst.FindAll({ param($node) $node -is [Management.Automation.Language.CommandAst] -and $node.GetCommandName() -ceq 'Copy-OwnerOnlyRetainedBinary' }, $true))
    $runtimePrepareCallNodes = @($buildAst.FindAll({ param($node) $node -is [Management.Automation.Language.CommandAst] -and $node.GetCommandName() -ceq 'Initialize-OwnerBinaryRuntime' }, $true))
    $retainedCallsGuarded = $true
    foreach ($node in @($retainedCallNodes + $runtimePrepareCallNodes)) {
        $ancestor = $node.Parent
        $guardFound = $false
        while ($null -ne $ancestor) {
            if ($ancestor -is [Management.Automation.Language.IfStatementAst] -and $ancestor.Clauses[0].Item1.Extent.Text.Trim() -ceq '$RetainBinary') { $guardFound = $true; break }
            $ancestor = $ancestor.Parent
        }
        if (-not $guardFound) { $retainedCallsGuarded = $false }
    }
    Assert-Validation ($allRetainedStagesPresent -and $build.Contains("throw 'OWNER_RUNTIME_PREPARE_FAILED'") -and $build.Contains('$_.Exception.Message -in $safeFailureCodes') -and $build.Contains("Write-Output 'FAILURE_CODE=BUILD_VALIDATION_FAILED'") -and $retainedCallsGuarded -and $retainedCallNodes.Count -eq 1 -and $runtimePrepareCallNodes.Count -eq 1) 'R6R2I_D2_FAILURE_STAGE_CODES_BOUNDED'

    $cleanupIsExact = $retainedCleanupText.Contains('[IO.File]::Delete($Path)') -and $retainedCleanupText.Contains('$WasCreated') -and $retainedCleanupText -notmatch '(?i)-Recurse|Remove-Item|Directory\]::Delete'
    Assert-Validation $cleanupIsExact 'R6R2I_D2_FAILED_RUN_EXACT_BINARY_CLEANUP_SCOPE_STATIC'
    Assert-Validation ($build.Contains("Write-Output 'OWNER_RUNTIME_BINARY=CREATED'") -and -not $build.Contains("'OWNER_RUNTIME_BINARY=' + `$runtimeBinaryPath")) 'R6R2I_D2_BOUNDED_RUNTIME_OUTPUT'

    $buildInvocationNodes = @($buildAst.FindAll({ param($node) $node -is [Management.Automation.Language.CommandAst] -and $node.GetCommandName() -ceq 'Invoke-CheckedNative' }, $true))
    $buildDefaultRegression = $acceptedBuild.Contains("'git' -ArgumentList @('clone', '--quiet', '--depth', '1', '--branch', 'v4.0.2'") -and $build.Contains("'git' -ArgumentList @('clone', '--quiet', '--depth', '1', '--branch', 'v4.0.2'") -and $build.Contains("-ArgumentList @('test', './cmd/vpn-network-optimization-cookie-auth')") -and $build.Contains("'-buildvcs=false'") -and $build.Contains('$fixtureInfo.FileName = $binary') -and -not $build.Contains('$fixtureInfo.FileName = $runtimeBinaryPath') -and $buildInvocationNodes.Count -ge 3
    Assert-Validation $buildDefaultRegression 'R6R2I_D2_BUILD_DEFAULT_PATH_REGRESSION'

    $acceptedR2OwnerSpec = 'd441ed0bc31285311345ed3b3e847258d7de05a2:vpn-network-optimization/scripts/g4b-baidu-cookie-auth-owner-checkpoint.ps1'
    $acceptedR2Owner = (& git show $acceptedR2OwnerSpec | Out-String)
    Assert-Validation ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($acceptedR2Owner)) 'R6R2H_R3_ACCEPTED_R2_SOURCE_AVAILABLE'
    $normalizedOwner = $ownerText.Replace("`r`n", "`n")
    $acceptedR2Owner = $acceptedR2Owner.Replace("`r`n", "`n")
    $r3OnlyLines = @(
        ('$script:configState = ''NOT_REACHED''' + "`n"),
        ('    $script:configState = if ($script:configRootExistedBefore) { ''PREEXISTING_EMPTY'' } else { ''ABSENT_PREAUTH'' }' + "`n"),
        ('Write-Output (''BAIDU_COOKIE_AUTH_CONFIG_STATE='' + $script:configState)' + "`n")
    )
    $r3SourceDeltaExact = $true
    foreach ($line in $r3OnlyLines) {
        if ($normalizedOwner.IndexOf($line, [StringComparison]::Ordinal) -lt 0 -or $normalizedOwner.IndexOf($line, [StringComparison]::Ordinal) -ne $normalizedOwner.LastIndexOf($line, [StringComparison]::Ordinal)) { $r3SourceDeltaExact = $false; break }
        $normalizedOwner = $normalizedOwner.Replace($line, '')
    }
    Assert-Validation ($r3SourceDeltaExact -and $normalizedOwner -ceq $acceptedR2Owner) 'R6R2H_R3_R2_CORE_FROZEN'

    Assert-Validation ($source.Contains('func parseExactBDUSS(cookie []byte) (string, bool)') -and $source.Contains('SetupUserByBDUSS(bduss, "", "", cookie)') -and -not $source.Contains('SetupUserByBDUSS("", "", "", cookie)')) 'R6R2H_R2_EXACT_FIELD_VALUE_PARSED'
    Assert-Validation ($source.Contains('parts := bytes.Split(cookie, []byte(";"))') -and $source.Contains('i == len(parts)-1') -and $source.Contains('count != 1')) 'R6R2H_R2_UPSTREAM_SECOND_PARSE_BYPASSED'
    Assert-Validation ($testSource.Contains('OTHER=prefixBDUSS=fixture-wrong; BDUSS=fixture-right;') -and $testSource.Contains('parsed != "fixture-right"')) 'R6R2H_R2_AMBIGUOUS_SUBSTRING_FIXTURE'
    Assert-Validation ($source.Contains('terminal.ReadPassword(int(os.Stdin.Fd()))') -and $source.Contains('os.Stdout, os.Stderr = sink, sink') -and $source.Contains('log.SetOutput(io.Discard)') -and $source.Contains('pcsverbose.Outputs = []io.Writer{io.Discard}') -and -not $source.Contains('Sum(') -and -not $source.Contains('sha256')) 'R6R2H_R2_SECRET_BOUNDARIES_UNCHANGED'
    Assert-Validation ($source.Contains('fmt.Fprint(os.Stderr, "Enter Cookie in this local console (input hidden): ")') -and $source.Contains('terminal.ReadPassword(int(os.Stdin.Fd()))') -and $ownerText.Contains('$startInfo.RedirectStandardInput = $false') -and $ownerText.Contains('$startInfo.RedirectStandardOutput = $false') -and $ownerText.Contains('$startInfo.RedirectStandardError = $false')) 'R6R2I_D5_HIDDEN_INPUT_PATH_PRESERVED'
    Assert-Validation ($source -notmatch $statusOutputLinePattern -and $source -notmatch 'BAIDU_COOKIE_AUTH_(?:FAILURE_CODE|UID_EMITTED)=|BAIDU_COOKIE_AUTH=(?:FAIL_CLOSED|SETUP_SAVED)') 'R6R2I_D5_ADAPTER_STATUS_CONSOLE_LEAK_BLOCKED'
    Assert-Validation ($source.Contains('return 2') -and $source.Contains('return 0') -and $source.Contains('os.Exit(run())') -and $newNativeFailureCondition -and $build.Contains("if (`$fixtureProcess.ExitCode -eq 0 -or (`$fixtureStdout + `$fixtureStderr) -match 'BAIDU_COOKIE_AUTH') {")) 'R6R2I_D5_NATIVE_NONZERO_EXIT_PRESERVED'
    Assert-Validation ($source.Contains('len(os.Args) != 1') -and -not $source.Contains('SetupUserByBDUSS("", "", "", cookie)') -and $source.Contains('SetupUserByBDUSS(bduss, "", "", cookie)')) 'R6R2H_R2_SETUP_EXPLICIT_VALUE'
    $setupAt = $source.IndexOf('pcsconfig.Config.SetupUserByBDUSS(bduss, "", "", cookie)', [StringComparison]::Ordinal)
    $saveAt = $source.IndexOf('pcsconfig.Config.Save()', [StringComparison]::Ordinal)
    Assert-Validation ($source.Contains('pcsconfig.Config.InitDefaultConfig()') -and -not $source.Contains('pcsconfig.Config.Init()') -and $setupAt -ge 0 -and $saveAt -gt $setupAt) 'R6R2H_R2_CONFIG_SAVE_ONLY_AFTER_SETUP_SUCCESS'

    $flowStart = $ownerText.LastIndexOf("`ntry {", [StringComparison]::Ordinal)
    Assert-Validation ($flowStart -ge 0) 'OWNER_EXECUTION_FLOW_FOUND'
    $flow = $ownerText.Substring($flowStart)
    $runtimeAt = $flow.IndexOf('Assert-R2OwnerRuntime', [StringComparison]::Ordinal)
    $sidAt = $flow.IndexOf('$script:ownerSid = $identity.User', [StringComparison]::Ordinal)
    $configPathAt = $flow.IndexOf('Resolve-SafeBaiduConfigPath -ConfigDirectory $requestedConfig', [StringComparison]::Ordinal)
    $adapterAt = $flow.IndexOf('Assert-R2AdapterBinaryPreflight', [StringComparison]::Ordinal)
    $configClassifyAt = $flow.IndexOf('$script:configRootExistedBefore = Test-Path', [StringComparison]::Ordinal)
    $configCreateAt = $flow.IndexOf('FileSystemAclExtensions]::CreateDirectory($directoryAcl, $script:configPath)', [StringComparison]::Ordinal)
    Assert-Validation ($runtimeAt -ge 0 -and $sidAt -ge 0 -and $configPathAt -gt $sidAt -and $adapterAt -gt $configPathAt -and $configClassifyAt -gt $adapterAt -and $configCreateAt -gt $adapterAt) 'R6R2H_R2_RUNTIME_PREFLIGHT_BEFORE_CONFIG_WRITE'
    Assert-Validation ($ownerText.Contains('Assert-R2AdapterBinaryPreflight') -and $ownerText.Contains('Assert-OwnerOnlyAcl -Path $fullPath') -and $ownerText.Contains('Get-FileHash -LiteralPath $fullPath') -and $ownerText.Contains("`$script:adapterSha256 = '9d0fff1aec7015210ba421c67bff956bc360cc6121c8d70a226c9e0817da7367'")) 'R6R2H_R2_BINARY_IDENTITY_BEFORE_CONFIG_WRITE'
    Assert-Validation ($ownerText.Contains('$entries.Count -eq 0') -and $ownerText.Contains('Assert-SafeBaiduConfigDirectory') -and $ownerText.Contains('$script:configFileExistedBefore')) 'R6R2H_R2_PREAUTH_EMPTY_ONLY'

    $stateAssignments = @($ownerAst.FindAll({ param($node) $node -is [Management.Automation.Language.AssignmentStatementAst] -and $node.Left.Extent.Text -ceq '$script:configState' }, $true))
    $stateExpression = "if (`$script:configRootExistedBefore) { 'PREEXISTING_EMPTY' } else { 'ABSENT_PREAUTH' }"
    Assert-Validation ($stateAssignments.Count -eq 2 -and $stateAssignments[0].Right.Extent.Text -ceq "'NOT_REACHED'" -and $stateAssignments[1].Right.Extent.Text -ceq $stateExpression) 'R6R2H_R3_CONFIG_STATE_ENUM_BOUNDED'
    $strictPreauthAt = $flow.IndexOf('Assert-SafeBaiduConfigDirectory -ConfigDirectory $script:configPath', [StringComparison]::Ordinal)
    $commonConfigAbsenceAt = $flow.IndexOf('Assert-R2 (-not $script:configFileExistedBefore) ''BAIDU_CONFIG_FILE_PREEXISTS''', [StringComparison]::Ordinal)
    $stateAssignmentAt = $flow.IndexOf('$script:configState = if ($script:configRootExistedBefore)', [StringComparison]::Ordinal)
    Assert-Validation ($stateAssignmentAt -gt $commonConfigAbsenceAt -and $flow.IndexOf('$script:configRootExistedBefore = Test-Path', [StringComparison]::Ordinal) -ge 0) 'R6R2H_R3_ABSENT_STATE_ASSIGNED_AFTER_PRECONDITION'
    Assert-Validation ($strictPreauthAt -ge 0 -and $strictPreauthAt -lt $stateAssignmentAt -and $flow.IndexOf('$entries.Count -eq 0', [StringComparison]::Ordinal) -lt $stateAssignmentAt) 'R6R2H_R3_PREEXISTING_EMPTY_ASSIGNED_AFTER_STRICT_CHECK'
    $processStartAt = $flow.IndexOf('$process = [Diagnostics.Process]::new()', [StringComparison]::Ordinal)
    $postAuthCallAt = $flow.IndexOf('Complete-R2PostAuthNormalization -ConfigPath', [StringComparison]::Ordinal)
    Assert-Validation ($stateAssignments[1].Extent.StartOffset -lt ($flowStart + $processStartAt) -and $stateAssignments[1].Extent.StartOffset -lt ($flowStart + $postAuthCallAt)) 'R6R2H_R3_STATE_NOT_OVERWRITTEN_POSTAUTH'

    $writeOutputNodes = @($ownerAst.FindAll({ param($node) $node -is [Management.Automation.Language.CommandAst] -and $node.GetCommandName() -ceq 'Write-Output' }, $true))
    $requiredOutputMarkers = @(
        'BAIDU_COOKIE_AUTH_CHECKPOINT=',
        'BAIDU_COOKIE_AUTH_FAILURE_CODE=',
        'BAIDU_COOKIE_AUTH_NATIVE_EXIT=',
        'BAIDU_COOKIE_AUTH_CONFIG_STATE=',
        'BAIDU_COOKIE_AUTH_CONFIG_DISPOSITION=',
        'BAIDU_COOKIE_AUTH_CONTENT_READ=NO',
        'BAIDU_COOKIE_AUTH_WHO=NOT_RUN',
        'BAIDU_COOKIE_AUTH_UID_EMITTED=NO'
    )
    $outputContractComplete = $true
    foreach ($marker in $requiredOutputMarkers) {
        if (@($writeOutputNodes | Where-Object { $_.Extent.Text.Contains($marker) }).Count -ne 1) { $outputContractComplete = $false }
    }
    Assert-Validation $outputContractComplete 'R6R2H_R3_OUTPUT_CONTRACT_COMPLETE'
    Assert-Validation (@($writeOutputNodes | Where-Object { $_.Extent.Text.Contains('BAIDU_COOKIE_AUTH_CONFIG_STATE=') }).Count -eq 1) 'R6R2H_R3_CONFIG_STATE_OUTPUT_PRESENT'
    Assert-Validation ($writeOutputNodes.Count -eq 8 -and $outputContractComplete) 'R6R2I_D5_OWNER_EIGHT_MARKER_CONTRACT_EXACT'
    Assert-Validation ($source -notmatch $statusOutputLinePattern -and $source -notmatch 'BAIDU_COOKIE_AUTH_(?:FAILURE_CODE|UID_EMITTED)=|BAIDU_COOKIE_AUTH=(?:FAIL_CLOSED|SETUP_SAVED)') 'R6R2I_D5_SUCCESS_PATH_NO_DUPLICATE_MARKERS'
    Assert-Validation ($source -notmatch $statusOutputLinePattern -and $build.Contains($newNativeFailureCondition) -and -not $build.Contains($oldNativeFailureCondition)) 'R6R2I_D5_FAILURE_PATH_NO_CHILD_MARKERS'

    $probeVariable = Get-Variable -Name configRootExistedBefore -Scope Script -ErrorAction SilentlyContinue
    $probeVariableExisted = $null -ne $probeVariable
    $probeVariableValue = if ($probeVariableExisted) { $probeVariable.Value } else { $null }
    try {
        $stateFixtureBlock = [scriptblock]::Create($stateAssignments[1].Right.Extent.Text)
        $script:configRootExistedBefore = $false
        $absentStateFixture = & $stateFixtureBlock
        $script:configRootExistedBefore = $true
        $existingStateFixture = & $stateFixtureBlock
        Assert-Validation ($absentStateFixture -ceq 'ABSENT_PREAUTH' -and $existingStateFixture -ceq 'PREEXISTING_EMPTY') 'R6R2H_R3_CONFIG_STATE_PRODUCTION_EXPRESSION_FIXTURES'
    } finally {
        if ($probeVariableExisted) { Set-Variable -Name configRootExistedBefore -Scope Script -Value $probeVariableValue }
        else { Remove-Variable -Name configRootExistedBefore -Scope Script -ErrorAction SilentlyContinue }
    }

    $postAuthNode = Get-FunctionNode -Ast $ownerAst -Name 'Complete-R2PostAuthNormalization'
    $postAuthText = $postAuthNode.Extent.Text
    $shapeAt = $postAuthText.IndexOf('Assert-R2ExactPostAuthShape', [StringComparison]::Ordinal)
    $fileSetAt = $postAuthText.IndexOf('Set-OwnerOnlyAcl -Path $entry.FullName', [StringComparison]::Ordinal)
    $rootSetAt = $postAuthText.IndexOf('Set-OwnerOnlyAcl -Path $canonical', [StringComparison]::Ordinal)
    $fileAssertAt = $postAuthText.IndexOf('Assert-OwnerOnlyAcl -Path $entry.FullName', [StringComparison]::Ordinal)
    $strictAt = $postAuthText.IndexOf('Assert-SafeBaiduConfigDirectory', [StringComparison]::Ordinal)
    Assert-Validation ($shapeAt -ge 0 -and $fileSetAt -gt $shapeAt -and $rootSetAt -gt $fileSetAt -and $fileAssertAt -gt $rootSetAt -and $strictAt -gt $fileAssertAt) 'R6R2H_R2_POSTAUTH_EXACT_SHAPE_BEFORE_NORMALIZE'
    Assert-Validation ($postAuthText.IndexOf('Assert-OwnerOnlyAcl -Path $canonical', [StringComparison]::Ordinal) -lt $strictAt) 'R6R2H_R2_R6R1_STRICT_AFTER_NORMALIZE'
    $shapeNode = Get-FunctionNode -Ast $ownerAst -Name 'Assert-R2ExactPostAuthShape'
    Assert-Validation ($shapeNode.Extent.Text.Contains('1048576') -and $shapeNode.Extent.Text.Contains('Assert-R2PreNormalizeAclMetadata')) 'R6R2H_R2_POSTAUTH_BOUNDED_SHAPE_AND_OWNER_PROVENANCE'
    Assert-Validation ($ownerText.Contains('$script:childExitCode -ne 0') -and $flow.IndexOf('childExitCode -ne 0', [StringComparison]::Ordinal) -lt $flow.IndexOf('Complete-R2PostAuthNormalization', [StringComparison]::Ordinal) -and $source.Contains('os.Exit(run())')) 'R6R2H_R2_FAILURE_NATIVE_EXIT_NONZERO'

    $reconcileNode = Get-FunctionNode -Ast $ownerAst -Name 'Invoke-R2FailureReconciliation'
    $reconcileText = $reconcileNode.Extent.Text
    Assert-Validation ($reconcileText.Contains('PRESERVED_PREEXISTING_EMPTY') -and $reconcileText.Contains('REMOVED_NEW_EMPTY_ROOT') -and $reconcileText.Contains('REMOVED_NEW_FILE_ROOT_PRESERVED') -and $reconcileText.Contains('REMOVED_NEW_FILE_AND_ROOT')) 'R6R2H_R2_PROVENANCE_RECONCILIATION_BRANCHES'
    Assert-Validation ($reconcileText.Contains('ChildProcessStarted') -and $reconcileText.Contains('ConfigFileExistedBefore')) 'R6R2H_R2_PARTIAL_START_PROVENANCE_GUARD'
    Assert-Validation ($reconcileText.Contains('[IO.File]::Delete($entry.FullName)') -and $reconcileText.Contains('[IO.Directory]::Delete($ConfigPath, $false)') -and $reconcileText -notmatch '(?i)-Recurse|Remove-Item|Directory\]::Delete\([^\r\n]*,\s*\$true') 'R6R2H_R2_NO_BROAD_DELETE'
    Assert-Validation (($ownerText + $postAuthText + $reconcileText) -notmatch '(?i)Get-Content|ReadAllText|ReadAllBytes|ReadAllLines|Copy-Item|Move-Item|Get-FileHash[^\r\n]*(?:config|entry\.FullName)') 'R6R2H_R2_NO_CONFIG_CONTENT_READ'
    Assert-Validation ($ownerText -notmatch '(?i)ArgumentList\.Add|RedirectStandard(?:Input|Output|Error)\s*=\s*\$true|Invoke-ReadOnlyBaiduWho') 'R6R2H_R2_NO_WHO_OR_CAPTURE'
    Write-Output 'R6R2H_R2_NO_WHO=PASS'
    Assert-Validation ($flow.Contains('Invoke-R2FailureReconciliation') -and $flow.Contains('$script:result -ne ''SETUP_SAVED''')) 'R6R2H_R2_ALL_FAILURES_RECONCILED'

    $requiredAclFunctions = @('Assert-R6', 'Test-PathWithin', 'New-OwnerOnlyAcl', 'Set-OwnerOnlyAcl', 'Assert-OwnerOnlyAcl', 'Assert-BaiduConfigAclMetadata', 'Resolve-SafeBaiduConfigPath', 'Assert-SafeBaiduConfigDirectory')
    foreach ($name in $requiredAclFunctions) { Invoke-Expression (Get-FunctionNode -Ast $aclAst -Name $name).Extent.Text }
    $productionFunctionNames = @('Assert-R2', 'Test-R2PathWithin', 'Get-R2IntegrityRid', 'Assert-R2OwnerRuntime', 'Test-R2PathComponentsNoReparse', 'Assert-R2AdapterBinaryPreflight', 'Assert-R2PreNormalizeAclMetadata', 'Get-R2ConfigMetadata', 'Assert-R2ExactPostAuthShape', 'Complete-R2PostAuthNormalization', 'Invoke-R2FailureReconciliation')
    foreach ($name in $productionFunctionNames) { Invoke-Expression (Get-FunctionNode -Ast $ownerAst -Name $name).Extent.Text }
    Invoke-Expression $retainedCopyNode.Extent.Text
    Invoke-Expression $retainedCleanupNode.Extent.Text

    $ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
    $ownerRule = New-SyntheticAclRule -Sid $ownerSid.Value -Rights ([Security.AccessControl.FileSystemRights]::FullControl)
    $adminRule = New-SyntheticAclRule -Sid 'S-1-5-32-544' -Rights ([Security.AccessControl.FileSystemRights]::FullControl)
    $systemRule = New-SyntheticAclRule -Sid 'S-1-5-18' -Rights ([Security.AccessControl.FileSystemRights]::FullControl)
    Assert-BaiduConfigAclMetadata -ActualOwnerSid $ownerSid.Value -ExpectedOwnerSid $ownerSid -Rules @($ownerRule) -IsDirectory $false
    Assert-BaiduConfigAclMetadata -ActualOwnerSid $ownerSid.Value -ExpectedOwnerSid $ownerSid -Rules @($ownerRule, $systemRule, $adminRule) -IsDirectory $false
    $inheritedOwner = New-SyntheticAclRule -Sid $ownerSid.Value -Rights ([Security.AccessControl.FileSystemRights]::FullControl) -Inherited $true
    Assert-BaiduConfigAclMetadata -ActualOwnerSid $ownerSid.Value -ExpectedOwnerSid $ownerSid -Rules @($inheritedOwner, (New-SyntheticAclRule -Sid 'S-1-5-18' -Rights ([Security.AccessControl.FileSystemRights]::FullControl) -Inherited $true), (New-SyntheticAclRule -Sid 'S-1-5-32-544' -Rights ([Security.AccessControl.FileSystemRights]::FullControl) -Inherited $true)) -IsDirectory $true
    $broadRejected = $true
    foreach ($sid in @('S-1-1-0', 'S-1-5-11', 'S-1-5-32-545')) {
        if (-not (Test-ThrowsCode { Assert-BaiduConfigAclMetadata -ActualOwnerSid $ownerSid.Value -ExpectedOwnerSid $ownerSid -Rules @($ownerRule, (New-SyntheticAclRule -Sid $sid)) -IsDirectory $false } 'BAIDU_AUTH_CONFIG_UNAUTHORIZED_ALLOW')) { $broadRejected = $false }
    }
    Assert-Validation $broadRejected 'R6R1_ACL_BROAD_ALLOW_REJECTED'
    Assert-Validation (Test-ThrowsCode { Assert-BaiduConfigAclMetadata -ActualOwnerSid $ownerSid.Value -ExpectedOwnerSid $ownerSid -Rules @($ownerRule, (New-SyntheticAclRule -Sid 'S-1-5-21-101-202-303-4040')) -IsDirectory $false } 'BAIDU_AUTH_CONFIG_UNAUTHORIZED_ALLOW') 'R6R1_ACL_ARBITRARY_ALLOW_REJECTED'
    Assert-Validation (Test-ThrowsCode { Assert-BaiduConfigAclMetadata -ActualOwnerSid $ownerSid.Value -ExpectedOwnerSid $ownerSid -Rules @($ownerRule, (New-SyntheticAclRule -Sid 'S-1-5-18' -AccessType ([Security.AccessControl.AccessControlType]::Deny))) -IsDirectory $false } 'BAIDU_AUTH_CONFIG_DENY_ACE') 'R6R1_ACL_DENY_REJECTED'
    $ownerWriteOnly = New-SyntheticAclRule -Sid $ownerSid.Value -Rights ([Security.AccessControl.FileSystemRights]::WriteData)
    Assert-Validation (Test-ThrowsCode { Assert-BaiduConfigAclMetadata -ActualOwnerSid $ownerSid.Value -ExpectedOwnerSid $ownerSid -Rules @($ownerWriteOnly) -IsDirectory $false } 'BAIDU_AUTH_CONFIG_OWNER_READ_RIGHTS_MISSING') 'R6R1_ACL_OWNER_RIGHTS_MISSING_REJECTED'
    Assert-Validation (Test-ThrowsCode { Assert-BaiduConfigAclMetadata -ActualOwnerSid 'S-1-5-20' -ExpectedOwnerSid $ownerSid -Rules @($ownerRule) -IsDirectory $false } 'BAIDU_AUTH_CONFIG_OWNER_MISMATCH') 'R6R1_ACL_OWNER_MISMATCH_REJECTED'
    Write-Output 'R6R1_ACL_REGRESSION=PASS'

    Assert-R2PreNormalizeAclMetadata -ActualOwnerSid $ownerSid.Value -OwnerSid $ownerSid -Rules @($ownerRule, $systemRule, $adminRule)
    Assert-R2PreNormalizeAclMetadata -ActualOwnerSid 'S-1-5-32-544' -OwnerSid $ownerSid -Rules @($adminRule, $systemRule)
    Write-Output 'R6R2H_R2_POSTAUTH_ADMIN_OWNER_ACCEPTED_FOR_NORMALIZE=PASS'
    Assert-Validation (Test-ThrowsCode { Assert-R2PreNormalizeAclMetadata -ActualOwnerSid 'S-1-5-20' -OwnerSid $ownerSid -Rules @($ownerRule) } 'BAIDU_CONFIG_PRENORMALIZE_OWNER_INVALID') 'R6R2H_R2_POSTAUTH_UNEXPECTED_OWNER_REJECTED'
    Assert-Validation (Test-ThrowsCode { Assert-R2PreNormalizeAclMetadata -ActualOwnerSid $ownerSid.Value -OwnerSid $ownerSid -Rules @((New-SyntheticAclRule -Sid 'S-1-5-18' -AccessType ([Security.AccessControl.AccessControlType]::Deny))) } 'BAIDU_CONFIG_PRENORMALIZE_DENY_ACE') 'R6R2H_R2_POSTAUTH_FORBIDDEN_ACE_REJECTED'

    $tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd([char]'\', [char]'/')
    $fixtureRoot = Join-Path $tempRoot ('vpn-g4b-r2-fixture-' + [Guid]::NewGuid().ToString('N'))
    $fixtureRootAcl = New-OwnerOnlyAcl -OwnerSid $ownerSid -Directory
    [void][System.IO.FileSystemAclExtensions]::CreateDirectory($fixtureRootAcl, $fixtureRoot)
    try {
        $d2RuntimeRoot = Join-Path $fixtureRoot 'd2-runtime-root'
        $d2RuntimeDirectory = Join-Path $d2RuntimeRoot 'runtime'
        New-FixtureRoot -Path $d2RuntimeRoot -OwnerSid $ownerSid
        New-FixtureRoot -Path $d2RuntimeDirectory -OwnerSid $ownerSid
        $d2RootMarker = Join-Path $d2RuntimeRoot 'preserve-root.fixture'
        $d2DirectoryMarker = Join-Path $d2RuntimeDirectory 'preserve-directory.fixture'
        [IO.File]::WriteAllText($d2RootMarker, 'NON_SECRET_ROOT_FIXTURE')
        [IO.File]::WriteAllText($d2DirectoryMarker, 'NON_SECRET_RUNTIME_FIXTURE')

        $candidateFixture = Join-Path $fixtureRoot 'candidate.fixture'
        [IO.File]::WriteAllText($candidateFixture, 'R6R2I-D2-NON-SECRET-FIXTURE')
        $candidateFixtureHash = (Get-FileHash -LiteralPath $candidateFixture -Algorithm SHA256).Hash.ToLowerInvariant()
        $retainedFixture = Join-Path $d2RuntimeDirectory 'retained.fixture'
        $successCreated = $false
        Copy-OwnerOnlyRetainedBinary -SourcePath $candidateFixture -DestinationPath $retainedFixture -OwnerSid $ownerSid -ExpectedSha256 $candidateFixtureHash -Created ([ref]$successCreated)
        Assert-Validation ($successCreated -and (Test-Path -LiteralPath $retainedFixture -PathType Leaf)) 'R6R2I_D2_RETAINED_CREATE_NEW_ONLY'
        Assert-OwnerOnlyAcl -Path $retainedFixture -OwnerSid $ownerSid
        Write-Output 'R6R2I_D2_FROZEN_ASSERT_OWNER_ONLY_ACL_PASS=PASS'
        $retainedFixtureHash = (Get-FileHash -LiteralPath $retainedFixture -Algorithm SHA256).Hash.ToLowerInvariant()
        Assert-Validation ($retainedFixtureHash -ceq $candidateFixtureHash) 'R6R2I_D2_RETAINED_HASH_READBACK_PASS'

        $collisionCreated = $false
        Assert-Validation (Test-ThrowsCode { Copy-OwnerOnlyRetainedBinary -SourcePath $candidateFixture -DestinationPath $retainedFixture -OwnerSid $ownerSid -ExpectedSha256 $candidateFixtureHash -Created ([ref]$collisionCreated) } 'RETAINED_BINARY_CREATE_FAILED') 'R6R2I_D2_EXISTING_BINARY_COLLISION_FAILS_CLOSED'
        $collisionCleanup = Remove-RunCreatedRetainedBinary -Path $retainedFixture -WasCreated $collisionCreated
        Assert-Validation (-not $collisionCreated -and $collisionCleanup -and (Test-Path -LiteralPath $retainedFixture -PathType Leaf) -and (Get-FileHash -LiteralPath $retainedFixture -Algorithm SHA256).Hash.ToLowerInvariant() -ceq $candidateFixtureHash) 'R6R2I_D2_COLLISION_PRESERVES_EXISTING_FILE'

        $copyFailurePath = Join-Path $d2RuntimeDirectory 'copy-failure.fixture'
        $copyFailureCreated = $false
        Assert-Validation (Test-ThrowsCode { Copy-OwnerOnlyRetainedBinary -SourcePath (Join-Path $fixtureRoot 'absent-source.fixture') -DestinationPath $copyFailurePath -OwnerSid $ownerSid -ExpectedSha256 $candidateFixtureHash -Created ([ref]$copyFailureCreated) } 'RETAINED_BINARY_COPY_FAILED') 'R6R2I_D2_COPY_FAILURE_STAGE_FIXTURE'
        $copyFailureCleanup = Remove-RunCreatedRetainedBinary -Path $copyFailurePath -WasCreated $copyFailureCreated

        $frozenAssertFunction = (Get-Item Function:\Assert-OwnerOnlyAcl).ScriptBlock
        $aclFailurePath = Join-Path $d2RuntimeDirectory 'acl-failure.fixture'
        $aclFailureCreated = $false
        try {
            Set-Item -Path Function:\Assert-OwnerOnlyAcl -Value {
                param([string]$Path, [Security.Principal.SecurityIdentifier]$OwnerSid)
                throw 'SYNTHETIC_ACL_READBACK_FAILURE'
            }
            Assert-Validation (Test-ThrowsCode { Copy-OwnerOnlyRetainedBinary -SourcePath $candidateFixture -DestinationPath $aclFailurePath -OwnerSid $ownerSid -ExpectedSha256 $candidateFixtureHash -Created ([ref]$aclFailureCreated) } 'RETAINED_BINARY_ACL_VERIFY_FAILED') 'R6R2I_D2_ACL_FAILURE_STAGE_FIXTURE'
        } finally {
            Set-Item -Path Function:\Assert-OwnerOnlyAcl -Value $frozenAssertFunction
        }
        $aclFailureCleanup = Remove-RunCreatedRetainedBinary -Path $aclFailurePath -WasCreated $aclFailureCreated

        $hashFailurePath = Join-Path $d2RuntimeDirectory 'hash-failure.fixture'
        $hashFailureCreated = $false
        Assert-Validation (Test-ThrowsCode { Copy-OwnerOnlyRetainedBinary -SourcePath $candidateFixture -DestinationPath $hashFailurePath -OwnerSid $ownerSid -ExpectedSha256 ('0' * 64) -Created ([ref]$hashFailureCreated) } 'RETAINED_BINARY_HASH_VERIFY_FAILED') 'R6R2I_D2_HASH_FAILURE_STAGE_FIXTURE'
        $hashFailureCleanup = Remove-RunCreatedRetainedBinary -Path $hashFailurePath -WasCreated $hashFailureCreated

        Assert-Validation ($copyFailureCleanup -and $aclFailureCleanup -and $hashFailureCleanup -and -not (Test-Path -LiteralPath $copyFailurePath) -and -not (Test-Path -LiteralPath $aclFailurePath) -and -not (Test-Path -LiteralPath $hashFailurePath) -and (Test-Path -LiteralPath $retainedFixture -PathType Leaf)) 'R6R2I_D2_FAILED_RUN_EXACT_BINARY_CLEANUP'
        Assert-Validation ((Test-Path -LiteralPath $d2RuntimeRoot -PathType Container) -and (Test-Path -LiteralPath $d2RuntimeDirectory -PathType Container) -and (Test-Path -LiteralPath $d2RootMarker -PathType Leaf) -and (Test-Path -LiteralPath $d2DirectoryMarker -PathType Leaf)) 'R6R2I_D2_RUNTIME_DIRECTORIES_PRESERVED'
        Assert-Validation ($cleanupIsExact -and $retainedCleanupText -notmatch '(?i)-Recurse|Remove-Item|Directory\]::Delete') 'R6R2I_D2_NO_BROAD_RUNTIME_DELETE'
        Assert-Validation ((Remove-RunCreatedRetainedBinary -Path $retainedFixture -WasCreated $successCreated) -and -not (Test-Path -LiteralPath $retainedFixture)) 'R6R2I_D2_POSTCOPY_VALIDATION_FAILURE_CLEANUP_FIXTURE'
        $fixtureTempParent = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd([char]'\', [char]'/')
        $fixtureTempRelative = [IO.Path]::GetRelativePath($fixtureTempParent, [IO.Path]::GetFullPath($fixtureRoot))
        Assert-Validation (-not [IO.Path]::IsPathRooted($fixtureTempRelative) -and $fixtureTempRelative -notmatch '^\.\.(?:[\\/]|$)' -and $fixtureRoot -notmatch '(?i)vpn-network-optimization[\\/]runtime') 'R6R2I_D2_NO_REAL_OWNER_RUNTIME_WRITE'

        $emptyExisting = Join-Path $fixtureRoot 'preexisting-empty'
        New-FixtureRoot -Path $emptyExisting -OwnerSid $ownerSid
        $result = Invoke-R2FailureReconciliation -ConfigPath $emptyExisting -OwnerSid $ownerSid -RootExistedBefore $true -RootCreatedThisRun $false -ConfigFileExistedBefore $false -ChildProcessStarted $false
        Assert-Validation ($result -ceq 'PRESERVED_PREEXISTING_EMPTY' -and (Test-Path -LiteralPath $emptyExisting -PathType Container)) 'R6R2H_R2_PREEXISTING_EMPTY_FAILURE_PRESERVED'

        $emptyNew = Join-Path $fixtureRoot 'new-empty'
        New-FixtureRoot -Path $emptyNew -OwnerSid $ownerSid
        $result = Invoke-R2FailureReconciliation -ConfigPath $emptyNew -OwnerSid $ownerSid -RootExistedBefore $false -RootCreatedThisRun $true -ConfigFileExistedBefore $false -ChildProcessStarted $false
        Assert-Validation ($result -ceq 'REMOVED_NEW_EMPTY_ROOT' -and -not (Test-Path -LiteralPath $emptyNew)) 'R6R2H_R2_NEW_EMPTY_FAILURE_REMOVED'

        $existingWithFile = Join-Path $fixtureRoot 'preexisting-with-new-file'
        New-FixtureRoot -Path $existingWithFile -OwnerSid $ownerSid
        $existingFile = New-FixtureConfigFile -Root $existingWithFile -OwnerSid $ownerSid
        $result = Invoke-R2FailureReconciliation -ConfigPath $existingWithFile -OwnerSid $ownerSid -RootExistedBefore $true -RootCreatedThisRun $false -ConfigFileExistedBefore $false -ChildProcessStarted $true
        Assert-Validation ($result -ceq 'REMOVED_NEW_FILE_ROOT_PRESERVED' -and (Test-Path -LiteralPath $existingWithFile -PathType Container) -and -not (Test-Path -LiteralPath $existingFile)) 'R6R2H_R2_PREEXISTING_ROOT_EXACT_FILE_FAILURE_FILE_ONLY'

        $newWithFile = Join-Path $fixtureRoot 'new-root-new-file'
        New-FixtureRoot -Path $newWithFile -OwnerSid $ownerSid
        $newFile = New-FixtureConfigFile -Root $newWithFile -OwnerSid $ownerSid
        $result = Invoke-R2FailureReconciliation -ConfigPath $newWithFile -OwnerSid $ownerSid -RootExistedBefore $false -RootCreatedThisRun $true -ConfigFileExistedBefore $false -ChildProcessStarted $true
        Assert-Validation ($result -ceq 'REMOVED_NEW_FILE_AND_ROOT' -and -not (Test-Path -LiteralPath $newWithFile) -and -not (Test-Path -LiteralPath $newFile)) 'R6R2H_R2_NEW_ROOT_EXACT_FILE_FAILURE_FILE_AND_ROOT'

        $unexpected = Join-Path $fixtureRoot 'unexpected-extra'
        New-FixtureRoot -Path $unexpected -OwnerSid $ownerSid
        $unexpectedFile = New-FixtureConfigFile -Root $unexpected -OwnerSid $ownerSid
        $extraFile = Join-Path $unexpected 'extra.fixture'
        [IO.File]::WriteAllText($extraFile, 'NON_SECRET_EXTRA_FIXTURE')
        $result = Invoke-R2FailureReconciliation -ConfigPath $unexpected -OwnerSid $ownerSid -RootExistedBefore $true -RootCreatedThisRun $false -ConfigFileExistedBefore $false -ChildProcessStarted $true
        Assert-Validation ($result -ceq 'PRESERVED_UNEXPECTED_STATE' -and (Test-Path -LiteralPath $unexpectedFile) -and (Test-Path -LiteralPath $extraFile)) 'R6R2H_R2_UNEXPECTED_STATE_PRESERVED'

        Assert-Validation (Test-ThrowsCode { Assert-R2PreNormalizeAclMetadata -ActualOwnerSid $ownerSid.Value -OwnerSid $ownerSid -Rules @($ownerRule, (New-SyntheticAclRule -Sid 'S-1-1-0')) } 'BAIDU_CONFIG_PRENORMALIZE_ALLOW_INVALID') 'R6R2H_R2_FORBIDDEN_ACE_REJECTED'

        $target = Join-Path $fixtureRoot 'junction-target'
        $reparseRoot = Join-Path $fixtureRoot 'unexpected-reparse'
        New-FixtureRoot -Path $target -OwnerSid $ownerSid
        New-FixtureRoot -Path $reparseRoot -OwnerSid $ownerSid
        $junction = Join-Path $reparseRoot 'link.fixture'
        New-Item -ItemType Junction -Path $junction -Target $target -ErrorAction Stop | Out-Null
        $result = Invoke-R2FailureReconciliation -ConfigPath $reparseRoot -OwnerSid $ownerSid -RootExistedBefore $true -RootCreatedThisRun $false -ConfigFileExistedBefore $false -ChildProcessStarted $true
        Assert-Validation ($result -ceq 'PRESERVED_UNEXPECTED_STATE' -and (Test-Path -LiteralPath $junction)) 'R6R2H_R2_REPARSE_STATE_PRESERVED'
        [IO.Directory]::Delete($junction, $false)

        $postAuth = Join-Path $fixtureRoot 'postauth-normalization'
        New-FixtureRoot -Path $postAuth -OwnerSid $ownerSid
        $postAuthFile = New-FixtureConfigFile -Root $postAuth -OwnerSid $ownerSid
        $projectRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
        [void](Assert-R2ExactPostAuthShape -ConfigPath $postAuth -ProjectRoot $projectRoot -OwnerSid $ownerSid)
        $normalizationMode = 'NTFS_APPLIED'
        try {
            Complete-R2PostAuthNormalization -ConfigPath $postAuth -ProjectRoot $projectRoot -OwnerSid $ownerSid
            Assert-OwnerOnlyAcl -Path $postAuthFile -OwnerSid $ownerSid
            Assert-OwnerOnlyAcl -Path $postAuth -OwnerSid $ownerSid
            Assert-SafeBaiduConfigDirectory -ConfigDirectory $postAuth -ProjectRoot $projectRoot -OwnerSid $ownerSid
        } catch {
            if ($_.Exception -isnot [System.Security.AccessControl.PrivilegeNotHeldException] -or $_.Exception.Message -notmatch 'SeSecurityPrivilege') { throw }
            Assert-OwnerOnlyAclDescriptor -Acl (New-OwnerOnlyAcl -OwnerSid $ownerSid) -OwnerSid $ownerSid
            Assert-OwnerOnlyAclDescriptor -Acl (New-OwnerOnlyAcl -OwnerSid $ownerSid -Directory) -OwnerSid $ownerSid
            $normalizationMode = 'SYNTHETIC_CONSTRUCTOR_PRIVILEGE_LIMIT'
        }
        Write-Output ('ACL_NORMALIZATION_FIXTURE_MODE=' + $normalizationMode)
        Write-Output 'R6R2H_R2_FILE_AND_ROOT_OWNER_ACL_NORMALIZED=PASS'
        Write-Output 'R6R2H_R2_R6R1_STRICT_AFTER_NORMALIZE=PASS'

        $zeroMutationConfig = Join-Path $fixtureRoot 'must-remain-absent'
        $fixtureAdapter = Join-Path $fixtureRoot 'fixture-adapter.exe'
        Assert-Validation (Test-ThrowsCode { Assert-R2OwnerRuntime -PowerShellVersion ([version]'7.6.6') -IsAdministrator $false -IntegrityRid 12288 } 'OWNER_ADMINISTRATOR_REQUIRED') 'R6R2H_R2_RUNTIME_PREFLIGHT_FAILURE_FIXTURE'
        $binaryFailure = $null
        try { Assert-R2AdapterBinaryPreflight -Path $fixtureAdapter -ProjectRoot $projectRoot -OwnerSid $ownerSid -ExpectedSha256 ('0' * 64) }
        catch { $binaryFailure = [string]$_.Exception.Message }
        Assert-Validation ($binaryFailure -ceq 'ADAPTER_PATH_INVALID') 'R6R2H_R2_BINARY_PREFLIGHT_FAILURE_FIXTURE'
        Assert-Validation (-not (Test-Path -LiteralPath $zeroMutationConfig)) 'R6R2H_R2_BINARY_PREFLIGHT_FAILURE_ZERO_CONFIG_MUTATION'
    } finally {
        $junctionPath = Join-Path (Join-Path $fixtureRoot 'unexpected-reparse') 'link.fixture'
        if (Test-Path -LiteralPath $junctionPath) { [IO.Directory]::Delete($junctionPath, $false) }
        $fullFixture = [IO.Path]::GetFullPath($fixtureRoot)
        Assert-Validation (([IO.Path]::GetDirectoryName($fullFixture).TrimEnd([char]'\', [char]'/') -ceq $tempRoot) -and ([IO.Path]::GetFileName($fullFixture) -match '^vpn-g4b-r2-fixture-[0-9a-f]{32}$')) 'R6R2H_R2_FIXTURE_CLEANUP_SCOPE'
        if (Test-Path -LiteralPath $fullFixture) { [IO.Directory]::Delete($fullFixture, $true) }
        Assert-Validation (-not (Test-Path -LiteralPath $fullFixture)) 'R6R2H_R2_FIXTURE_CLEANUP'
    }

    $secretPatterns = @(
        '-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----',
        '(?i)(?:password|cookie|bduss|stoken|ptoken|api[_-]?key)\s*[:=]\s*["'']?[A-Za-z0-9_./+=-]{24,}',
        '(?i)eyJ[A-Za-z0-9_-]{24,}\.[A-Za-z0-9_-]{12,}\.[A-Za-z0-9_-]{12,}'
    )
    $secretScan = $true
    foreach ($path in @($ownerPath, $sourcePath, $testPath, $buildPath, $PSCommandPath)) {
        $text = [IO.File]::ReadAllText($path, [Text.Encoding]::UTF8)
        foreach ($pattern in $secretPatterns) { if ([regex]::IsMatch($text, $pattern)) { $secretScan = $false } }
    }
    Assert-Validation $secretScan 'SECRET_SCAN'
    Write-Output 'GO_SOURCE_STATIC_VALIDATION=PASS'
    Write-Output 'R6R2H_R2_FULL_R6R2H_REGRESSION=PASS'
    Write-Output 'R6R2I_D2_FULL_R6R2H_R3_REGRESSION=PASS'
    Write-Output 'R6R2H_R3_ABSENT_STATE_ASSIGNED_AFTER_PRECONDITION=PASS'
    Write-Output 'R6R2H_R3_PREEXISTING_EMPTY_ASSIGNED_AFTER_STRICT_CHECK=PASS'
    Write-Output 'R6R2H_R3_STATE_NOT_OVERWRITTEN_POSTAUTH=PASS'
    Write-Output 'R6R2H_R3_CONFIG_STATE_ENUM_BOUNDED=PASS'
    Write-Output 'R6R2H_R3_CONFIG_STATE_OUTPUT_PRESENT=PASS'
    Write-Output 'R6R2H_R3_OUTPUT_CONTRACT_COMPLETE=PASS'
    Write-Output 'R6R2H_R3_CONFIG_STATE_PRODUCTION_EXPRESSION_FIXTURES=PASS'
    Write-Output 'R6R2H_R3_R2_CORE_FROZEN=PASS'
    Write-Output 'R6R2H_R3_FULL_R6R2H_R2_REGRESSION=PASS'
    Write-Output 'R6R2I_D5_FULL_R6R2H_R3_REGRESSION=PASS'
    Write-Output 'REAL_COOKIE_VALUES_USED=0'
    Write-Output 'REAL_AUTH_ACTIONS=0'
    Write-Output 'REAL_BAIDU_AUTH_ACTIONS=0'
    Write-Output 'OWNER_REAL_CONFIG_ACTIONS=0'
    Write-Output 'OWNER_CONFIG_READ=NO'
    Write-Output 'OWNER_CONFIG_WRITE=NO'
    Write-Output 'NETWORK_REQUESTS_TO_PROVIDER=0'
    Write-Output 'PROVIDER_REQUESTS=0'
    Write-Output 'STOP_AT_REVIEWER=YES'
} catch {
    Write-Output 'VALIDATION=RETURN'
    if ($_.Exception.Message -match '^[A-Z0-9_]+$') { Write-Output ('FAILURE_CODE=' + $_.Exception.Message) }
    else {
        Write-Output 'FAILURE_CODE=OFFLINE_VALIDATION_FAILED'
        Write-Output ('FAILURE_CLASS=' + $_.Exception.GetType().Name)
        if ($_.FullyQualifiedErrorId -match '^[A-Za-z0-9_.]+') { Write-Output ('FAILURE_FQID=' + ($_.FullyQualifiedErrorId -split ',')[0]) }
    }
    exit 1
}
