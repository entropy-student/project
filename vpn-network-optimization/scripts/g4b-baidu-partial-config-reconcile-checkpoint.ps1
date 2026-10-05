[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:reconcileResult = 'FAIL_CLOSED'
$script:reconcileShape = 'NOT_CHECKED'
$script:reconcileRollback = 'NOT_STARTED'
$script:reconcileBaseline = 'NOT_VERIFIED'

. (Join-Path $PSScriptRoot 'g4b-baidu-auth-readiness-checkpoint.ps1')

function Assert-BaiduPartialConfig {
    param([bool]$Condition, [string]$Code)
    if (-not $Condition) { throw $Code }
}

function Get-OptionalBaiduPartialItem {
    param([string]$Path)
    try {
        return Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    } catch {
        $isExactNotFound = $_.CategoryInfo.Category -eq [System.Management.Automation.ErrorCategory]::ObjectNotFound -and
            $_.FullyQualifiedErrorId -ceq 'PathNotFound,Microsoft.PowerShell.Commands.GetItemCommand'
        if ($isExactNotFound) { return $null }
        throw 'BAIDU_PARTIAL_CONFIG_METADATA_QUERY_FAILED'
    }
}

function Get-BaiduPartialAclMetadata {
    param([string]$Path)
    try {
        $acl = Get-Acl -LiteralPath $Path -ErrorAction Stop
        $owner = $acl.GetOwner([Security.Principal.SecurityIdentifier]).Value
        $rules = @($acl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier]))
        return [pscustomobject]@{ OwnerSid = [string]$owner; Rules = $rules }
    } catch {
        throw 'BAIDU_PARTIAL_CONFIG_ACL_QUERY_FAILED'
    }
}

function Assert-BaiduPartialConfigAclMetadata {
    param([object[]]$Rules)
    $allowedSids = @(
        [Security.Principal.WindowsIdentity]::GetCurrent().User.Value,
        'S-1-5-18',
        'S-1-5-32-544'
    )
    foreach ($rule in $Rules) {
        Assert-BaiduPartialConfig ($null -ne $rule) 'BAIDU_PARTIAL_CONFIG_ACE_SHAPE_INVALID'
        $identity = $rule.PSObject.Properties['IdentityReference']
        $accessType = $rule.PSObject.Properties['AccessControlType']
        $inherited = $rule.PSObject.Properties['IsInherited']
        $rights = $rule.PSObject.Properties['FileSystemRights']
        Assert-BaiduPartialConfig ($null -ne $identity -and $null -ne $identity.Value -and
            $identity.Value -is [Security.Principal.SecurityIdentifier] -and
            $null -ne $accessType -and $accessType.Value -is [Security.AccessControl.AccessControlType] -and
            $null -ne $inherited -and $inherited.Value -is [bool] -and
            $null -ne $rights -and $rights.Value -is [Security.AccessControl.FileSystemRights]) 'BAIDU_PARTIAL_CONFIG_ACE_SHAPE_INVALID'
        if ($accessType.Value -eq [Security.AccessControl.AccessControlType]::Deny) {
            throw 'BAIDU_PARTIAL_CONFIG_DENY_ACE'
        }
        Assert-BaiduPartialConfig ($accessType.Value -eq [Security.AccessControl.AccessControlType]::Allow) 'BAIDU_PARTIAL_CONFIG_ACE_SHAPE_INVALID'
        Assert-BaiduPartialConfig ($identity.Value.Value -in $allowedSids) 'BAIDU_PARTIAL_CONFIG_FORBIDDEN_ALLOW_ACE'
    }
}

function Assert-BaiduPartialConfigStructure {
    param([object]$Snapshot, [string]$ProjectRoot)
    Assert-BaiduPartialConfig ($null -ne $Snapshot) 'BAIDU_PARTIAL_CONFIG_METADATA_INVALID'
    $required = @('Exists', 'Path', 'IsDirectory', 'IsReparsePoint', 'OwnerSid', 'Rules', 'Entries')
    foreach ($name in $required) {
        Assert-BaiduPartialConfig ($null -ne $Snapshot.PSObject.Properties[$name]) 'BAIDU_PARTIAL_CONFIG_METADATA_INVALID'
    }
    Assert-BaiduPartialConfig ($Snapshot.Exists -is [bool] -and $Snapshot.Exists) 'BAIDU_PARTIAL_CONFIG_NOT_PRESENT'
    $rootPath = Resolve-SafeBaiduConfigPath -ConfigDirectory ([string]$Snapshot.Path) -ProjectRoot $ProjectRoot
    Assert-BaiduPartialConfig ([IO.Path]::GetFileName($rootPath) -ceq 'BaiduPCS-Go') 'BAIDU_PARTIAL_CONFIG_LOCATION_INVALID'
    Assert-BaiduPartialConfig ($Snapshot.IsDirectory -is [bool] -and $Snapshot.IsDirectory -and $Snapshot.IsReparsePoint -is [bool] -and -not $Snapshot.IsReparsePoint) 'BAIDU_PARTIAL_CONFIG_ROOT_SHAPE_INVALID'
    $allowedOwners = @([Security.Principal.WindowsIdentity]::GetCurrent().User.Value, 'S-1-5-32-544')
    Assert-BaiduPartialConfig ([string]$Snapshot.OwnerSid -in $allowedOwners) 'BAIDU_PARTIAL_CONFIG_UNEXPECTED_OWNER'
    Assert-BaiduPartialConfig (($Snapshot.Entries -is [array]) -and $Snapshot.Entries.Count -eq 1) 'BAIDU_PARTIAL_CONFIG_ENTRY_COUNT_INVALID'
    Assert-BaiduPartialConfigMetadataEntry -Entry $Snapshot.Entries[0]
}

function Assert-BaiduPartialConfigMetadata {
    param([object]$Snapshot, [string]$ProjectRoot)
    Assert-BaiduPartialConfigStructure -Snapshot $Snapshot -ProjectRoot $ProjectRoot
    Assert-BaiduPartialConfigMetadataEntry -Entry $Snapshot.Entries[0] -RequireBoundedNonempty
    Assert-BaiduPartialConfigAclMetadata -Rules @($Snapshot.Rules)
    Assert-BaiduPartialConfigAclMetadata -Rules @($Snapshot.Entries[0].Rules)
}

function Assert-BaiduPartialConfigMetadataEntry {
    param([object]$Entry, [switch]$RequireBoundedNonempty)
    Assert-BaiduPartialConfig ($null -ne $Entry) 'BAIDU_PARTIAL_CONFIG_ENTRY_SHAPE_INVALID'
    foreach ($name in @('Name', 'IsDirectory', 'IsReparsePoint', 'Length', 'OwnerSid', 'Rules')) {
        Assert-BaiduPartialConfig ($null -ne $Entry.PSObject.Properties[$name]) 'BAIDU_PARTIAL_CONFIG_ENTRY_SHAPE_INVALID'
    }
    Assert-BaiduPartialConfig ($Entry.Name -is [string] -and $Entry.Name -ceq 'pcs_config.json') 'BAIDU_PARTIAL_CONFIG_ENTRY_NAME_INVALID'
    Assert-BaiduPartialConfig ($Entry.IsDirectory -is [bool] -and -not $Entry.IsDirectory -and $Entry.IsReparsePoint -is [bool] -and -not $Entry.IsReparsePoint) 'BAIDU_PARTIAL_CONFIG_ENTRY_TYPE_INVALID'
    if ($RequireBoundedNonempty) {
        Assert-BaiduPartialConfig ($Entry.Length -is [long] -and $Entry.Length -gt 0 -and $Entry.Length -le 1048576) 'BAIDU_PARTIAL_CONFIG_ENTRY_SIZE_INVALID'
    }
    $allowedOwners = @([Security.Principal.WindowsIdentity]::GetCurrent().User.Value, 'S-1-5-32-544')
    Assert-BaiduPartialConfig ([string]$Entry.OwnerSid -in $allowedOwners) 'BAIDU_PARTIAL_CONFIG_UNEXPECTED_OWNER'
}

function Get-BaiduPartialConfigMetadata {
    param([string]$ConfigDirectory, [string]$ProjectRoot)
    $configFull = Resolve-SafeBaiduConfigPath -ConfigDirectory $ConfigDirectory -ProjectRoot $ProjectRoot
    Assert-BaiduPartialConfig ([IO.Path]::GetFileName($configFull) -ceq 'BaiduPCS-Go') 'BAIDU_PARTIAL_CONFIG_LOCATION_INVALID'
    $root = Get-OptionalBaiduPartialItem -Path $configFull
    if ($null -eq $root) {
        return [pscustomobject]@{ Exists = $false; Path = $configFull; IsDirectory = $false; IsReparsePoint = $false; OwnerSid = ''; Rules = @(); Entries = @() }
    }
    $rootIsDirectory = [bool]$root.PSIsContainer
    $rootIsReparse = (($root.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)
    if (-not $rootIsDirectory -or $rootIsReparse) {
        return [pscustomobject]@{ Exists = $true; Path = $configFull; IsDirectory = $rootIsDirectory; IsReparsePoint = $rootIsReparse; OwnerSid = ''; Rules = @(); Entries = @() }
    }
    $rootAcl = Get-BaiduPartialAclMetadata -Path $configFull
    $children = @()
    try { $children = @(Get-ChildItem -LiteralPath $configFull -Force -ErrorAction Stop) }
    catch { throw 'BAIDU_PARTIAL_CONFIG_METADATA_QUERY_FAILED' }
    $entries = [Collections.Generic.List[object]]::new()
    foreach ($child in $children) {
        $isDirectory = [bool]$child.PSIsContainer
        $isReparse = (($child.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)
        $childAcl = if ($isReparse) { [pscustomobject]@{ OwnerSid = ''; Rules = @() } } else { Get-BaiduPartialAclMetadata -Path $child.FullName }
        $length = [long]-1
        if (-not $isDirectory) {
            try { $length = [long]$child.Length } catch { throw 'BAIDU_PARTIAL_CONFIG_METADATA_QUERY_FAILED' }
        }
        $entries.Add([pscustomobject]@{
            Name = [string]$child.Name
            IsDirectory = $isDirectory
            IsReparsePoint = $isReparse
            Length = $length
            OwnerSid = $childAcl.OwnerSid
            Rules = $childAcl.Rules
        })
    }
    return [pscustomobject]@{
        Exists = $true
        Path = $configFull
        IsDirectory = [bool]$root.PSIsContainer
        IsReparsePoint = (($root.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)
        OwnerSid = $rootAcl.OwnerSid
        Rules = $rootAcl.Rules
        Entries = @($entries.ToArray())
    }
}

function Remove-BaiduPartialConfigExactResidue {
    param([string]$ConfigDirectory, [string]$ProjectRoot)
    $configFull = Resolve-SafeBaiduConfigPath -ConfigDirectory $ConfigDirectory -ProjectRoot $ProjectRoot
    $snapshot = Get-BaiduPartialConfigMetadata -ConfigDirectory $configFull -ProjectRoot $ProjectRoot
    if (-not $snapshot.Exists) { return 'ALREADY_ABSENT' }
    Assert-BaiduPartialConfigMetadata -Snapshot $snapshot -ProjectRoot $ProjectRoot
    $configFile = Join-Path $configFull 'pcs_config.json'
    [IO.File]::Delete($configFile)
    Assert-BaiduPartialConfig ($null -eq (Get-OptionalBaiduPartialItem -Path $configFile)) 'BAIDU_PARTIAL_CONFIG_FILE_DELETE_UNVERIFIED'
    try {
        $remaining = @(Get-ChildItem -LiteralPath $configFull -Force -ErrorAction Stop)
    } catch { throw 'BAIDU_PARTIAL_CONFIG_POSTDELETE_QUERY_FAILED' }
    Assert-BaiduPartialConfig ($remaining.Count -eq 0) 'BAIDU_PARTIAL_CONFIG_DIRECTORY_NOT_EMPTY'
    [IO.Directory]::Delete($configFull, $false)
    Assert-BaiduPartialConfig ($null -eq (Get-OptionalBaiduPartialItem -Path $configFull)) 'BAIDU_PARTIAL_CONFIG_DIRECTORY_DELETE_UNVERIFIED'
    return 'REMOVED_EXACT_RESIDUE'
}

function Invoke-BaiduPartialConfigReconciliationCheckpoint {
    try {
        $appData = $env:APPDATA
        Assert-BaiduPartialConfig (-not [string]::IsNullOrWhiteSpace($appData)) 'BAIDU_PARTIAL_CONFIG_LOCATION_INVALID'
        $configDirectory = Join-Path $appData 'BaiduPCS-Go'
        $snapshot = Get-BaiduPartialConfigMetadata -ConfigDirectory $configDirectory -ProjectRoot $script:projectRoot
        if (-not $snapshot.Exists) {
            $script:reconcileShape = 'ABSENT'
            $script:reconcileRollback = 'NOT_REQUIRED'
            $script:reconcileBaseline = 'RESTORED'
        } else {
            Assert-BaiduPartialConfigMetadata -Snapshot $snapshot -ProjectRoot $script:projectRoot
            $script:reconcileShape = 'EXACT_FAILED_RUN_RESIDUE'
            $script:reconcileRollback = Remove-BaiduPartialConfigExactResidue -ConfigDirectory $configDirectory -ProjectRoot $script:projectRoot
            $after = Get-BaiduPartialConfigMetadata -ConfigDirectory $configDirectory -ProjectRoot $script:projectRoot
            Assert-BaiduPartialConfig (-not $after.Exists) 'BAIDU_PARTIAL_CONFIG_BASELINE_NOT_RESTORED'
            $script:reconcileBaseline = 'RESTORED'
        }
        $script:reconcileResult = 'PASS'
    } catch {
        $script:reconcileResult = 'FAIL_CLOSED'
        $script:reconcileBaseline = 'NOT_VERIFIED'
        $script:reconcileRollback = 'NOT_COMPLETED'
    }
    Write-Output ('BAIDU_PARTIAL_CONFIG_RECONCILIATION=' + $script:reconcileResult)
    Write-Output ('BAIDU_PARTIAL_CONFIG_SHAPE=' + $script:reconcileShape)
    Write-Output 'BAIDU_PARTIAL_CONFIG_CONTENT_READ=NO'
    Write-Output ('BAIDU_PARTIAL_CONFIG_ROLLBACK=' + $script:reconcileRollback)
    Write-Output ('BAIDU_PARTIAL_CONFIG_BASELINE_RESTORED=' + $script:reconcileBaseline)
}

if ($MyInvocation.InvocationName -ne '.') { Invoke-BaiduPartialConfigReconciliationCheckpoint }
