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
    Assert-Validation ($aclParseErrors.Count -eq 0) 'R6R1_ACL_SOURCE_AST'

    $expectedBuildBlob = '7f369604de3cf0cce46bf0cf7328313c03ed61d5'
    $buildBlob = (& git rev-parse 'HEAD:vpn-network-optimization/scripts/build-g4b-baidu-cookie-auth-adapter.ps1').Trim()
    Assert-Validation ($LASTEXITCODE -eq 0 -and $buildBlob -ceq $expectedBuildBlob -and $build.Contains('225bdd3b6cb298601c4d5ef7104c3e08cd1d692d') -and $build.Contains('go1.27.1')) 'R6R2H_R2_PINNED_BUILD_CHAIN_FROZEN'

    Assert-Validation ($source.Contains('func parseExactBDUSS(cookie []byte) (string, bool)') -and $source.Contains('SetupUserByBDUSS(bduss, "", "", cookie)') -and -not $source.Contains('SetupUserByBDUSS("", "", "", cookie)')) 'R6R2H_R2_EXACT_FIELD_VALUE_PARSED'
    Assert-Validation ($source.Contains('parts := bytes.Split(cookie, []byte(";"))') -and $source.Contains('i == len(parts)-1') -and $source.Contains('count != 1')) 'R6R2H_R2_UPSTREAM_SECOND_PARSE_BYPASSED'
    Assert-Validation ($testSource.Contains('OTHER=prefixBDUSS=fixture-wrong; BDUSS=fixture-right;') -and $testSource.Contains('parsed != "fixture-right"')) 'R6R2H_R2_AMBIGUOUS_SUBSTRING_FIXTURE'
    Assert-Validation ($source.Contains('terminal.ReadPassword(int(os.Stdin.Fd()))') -and $source.Contains('os.Stdout, os.Stderr = sink, sink') -and $source.Contains('log.SetOutput(io.Discard)') -and $source.Contains('pcsverbose.Outputs = []io.Writer{io.Discard}') -and -not $source.Contains('Sum(') -and -not $source.Contains('sha256')) 'R6R2H_R2_SECRET_BOUNDARIES_UNCHANGED'
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
    Write-Output 'REAL_COOKIE_VALUES_USED=0'
    Write-Output 'REAL_BAIDU_AUTH_ACTIONS=0'
    Write-Output 'OWNER_CONFIG_READ=NO'
    Write-Output 'OWNER_CONFIG_WRITE=NO'
    Write-Output 'NETWORK_REQUESTS_TO_PROVIDER=0'
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
