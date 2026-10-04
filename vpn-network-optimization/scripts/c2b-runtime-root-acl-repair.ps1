[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$started = [DateTimeOffset]::UtcNow
Write-Output ('ROUND_STARTED_AT=' + $started.ToString('o'))

$ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
$runtimeRoot = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'
$mutationApplied = $false

function Measure-C2BRootAcl {
    param([string]$Path)
    $acl = Get-Acl -LiteralPath $Path -ErrorAction Stop
    $owner = $acl.GetOwner([Security.Principal.SecurityIdentifier]).Value
    $rules = @($acl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier]))
    $inherited = @($rules | Where-Object { $_.IsInherited }).Count
    $unauthorized = @($rules | Where-Object { $_.IdentityReference.Value -ne $ownerSid.Value }).Count
    $explicitUnauthorized = @($rules | Where-Object {
        -not $_.IsInherited -and $_.IdentityReference.Value -ne $ownerSid.Value
    }).Count
    $ownerRules = @($rules | Where-Object {
        $_.IdentityReference.Value -eq $ownerSid.Value -and
        $_.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow
    })

    $full = [long][Security.AccessControl.FileSystemRights]::FullControl
    $directMask = [long]0
    $containerMask = [long]0
    $objectMask = [long]0

    foreach ($rule in $ownerRules) {
        $rights = [long]$rule.FileSystemRights
        if (($rule.PropagationFlags -band [Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0) {
            $directMask = $directMask -bor $rights
        }
        if (($rule.InheritanceFlags -band [Security.AccessControl.InheritanceFlags]::ContainerInherit) -ne 0) {
            $containerMask = $containerMask -bor $rights
        }
        if (($rule.InheritanceFlags -band [Security.AccessControl.InheritanceFlags]::ObjectInherit) -ne 0) {
            $objectMask = $objectMask -bor $rights
        }
    }

    return [pscustomobject]@{
        Protected = [bool]$acl.AreAccessRulesProtected
        OwnerMatch = ($owner -ceq $ownerSid.Value)
        RuleCount = $rules.Count
        InheritedRuleCount = $inherited
        UnauthorizedRuleCount = $unauthorized
        ExplicitUnauthorizedRuleCount = $explicitUnauthorized
        OwnerDirectFullControl = (($directMask -band $full) -eq $full)
        OwnerChildFullControl = ((($containerMask -band $full) -eq $full) -and (($objectMask -band $full) -eq $full))
    }
}

function Write-C2BRootAcl {
    param([string]$Prefix, [object]$Measurement)
    Write-Output ($Prefix + '_PROTECTED=' + $Measurement.Protected)
    Write-Output ($Prefix + '_OWNER_MATCH=' + $Measurement.OwnerMatch)
    Write-Output ($Prefix + '_RULE_COUNT=' + $Measurement.RuleCount)
    Write-Output ($Prefix + '_INHERITED_RULE_COUNT=' + $Measurement.InheritedRuleCount)
    Write-Output ($Prefix + '_UNAUTHORIZED_RULE_COUNT=' + $Measurement.UnauthorizedRuleCount)
    Write-Output ($Prefix + '_EXPLICIT_UNAUTHORIZED_RULE_COUNT=' + $Measurement.ExplicitUnauthorizedRuleCount)
    Write-Output ($Prefix + '_OWNER_DIRECT_FULLCONTROL=' + $Measurement.OwnerDirectFullControl)
    Write-Output ($Prefix + '_OWNER_CHILD_FULLCONTROL=' + $Measurement.OwnerChildFullControl)
}

function Test-C2BRootAclInvariant {
    param([object]$Measurement)
    return (
        $Measurement.Protected -and
        $Measurement.OwnerMatch -and
        $Measurement.InheritedRuleCount -eq 0 -and
        $Measurement.UnauthorizedRuleCount -eq 0 -and
        $Measurement.OwnerDirectFullControl -and
        $Measurement.OwnerChildFullControl
    )
}

try {
    if (-not (Test-Path -LiteralPath $runtimeRoot -PathType Container)) {
        throw 'RUNTIME_ROOT_MISSING'
    }

    $item = Get-Item -LiteralPath $runtimeRoot -Force -ErrorAction Stop
    if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
        throw 'RUNTIME_ROOT_REPARSE_POINT_PRESENT'
    }

    $children = @(Get-ChildItem -LiteralPath $runtimeRoot -Force -ErrorAction Stop)
    if ($children.Count -ne 0) {
        throw 'RUNTIME_ROOT_NOT_EMPTY'
    }

    Write-Output 'RUNTIME_ROOT_EMPTY=PASS'
    Write-Output 'RUNTIME_ROOT_REPARSE_POINT=NO'

    $before = Measure-C2BRootAcl -Path $runtimeRoot
    Write-C2BRootAcl -Prefix 'ACL_BEFORE' -Measurement $before

    if (Test-C2BRootAclInvariant -Measurement $before) {
        Write-Output 'RUNTIME_ROOT_ACL_REPAIR=NOT_NEEDED_ALREADY_COMPLIANT'
    }
    else {
        if ($before.ExplicitUnauthorizedRuleCount -ne 0) {
            throw 'EXPLICIT_UNAUTHORIZED_ACL_RULE_PRESENT'
        }

        $acl = Get-Acl -LiteralPath $runtimeRoot -ErrorAction Stop
        $acl.SetAccessRuleProtection($true, $false)
        $acl.SetOwner($ownerSid)

        foreach ($rule in @($acl.GetAccessRules($true, $false, [Security.Principal.SecurityIdentifier]))) {
            [void]$acl.RemoveAccessRuleSpecific($rule)
        }

        $inheritance = [Security.AccessControl.InheritanceFlags]::ContainerInherit -bor
                       [Security.AccessControl.InheritanceFlags]::ObjectInherit
        $ownerRule = [Security.AccessControl.FileSystemAccessRule]::new(
            $ownerSid,
            [Security.AccessControl.FileSystemRights]::FullControl,
            $inheritance,
            [Security.AccessControl.PropagationFlags]::None,
            [Security.AccessControl.AccessControlType]::Allow
        )
        [void]$acl.AddAccessRule($ownerRule)

        Set-Acl -LiteralPath $runtimeRoot -AclObject $acl -ErrorAction Stop
        $mutationApplied = $true
        Write-Output 'RUNTIME_ROOT_ACL_REPAIR=APPLIED'
    }

    $after = Measure-C2BRootAcl -Path $runtimeRoot
    Write-C2BRootAcl -Prefix 'ACL_AFTER' -Measurement $after

    if (-not (Test-C2BRootAclInvariant -Measurement $after)) {
        throw 'RUNTIME_ROOT_ACL_POST_REPAIR_INVARIANT_FAILED'
    }

    $childrenAfter = @(Get-ChildItem -LiteralPath $runtimeRoot -Force -ErrorAction Stop)
    if ($childrenAfter.Count -ne 0) {
        throw 'RUNTIME_ROOT_CHANGED_FROM_EMPTY'
    }

    Write-Output 'RUNTIME_ROOT_ACL_POST_REPAIR=PASS'
    Write-Output 'RUNTIME_ROOT_STILL_EMPTY=PASS'
    Write-Output 'RUNTIME_ROOT_RECONCILIATION=PASS'
}
catch {
    Write-Output 'RUNTIME_ROOT_RECONCILIATION=RETURN'
    $code = [string]$_.Exception.Message
    if ($code -cmatch '^[A-Z][A-Z0-9_]{1,79}$') {
        Write-Output ('FAILURE_CODE=' + $code)
    }
    else {
        Write-Output 'FAILURE_CODE=UNCLASSIFIED'
    }
    exit 1
}
finally {
    $finished = [DateTimeOffset]::UtcNow
    Write-Output ('ROUND_FINISHED_AT=' + $finished.ToString('o'))
    Write-Output ('ACTUAL_ELAPSED=' + ($finished - $started).ToString('c'))
    Write-Output ('ACL_MUTATION_APPLIED=' + $(if ($mutationApplied) { 'YES' } else { 'NO' }))
    Write-Output 'RUNTIME_ROOT_DELETE=NO'
    Write-Output 'NETWORK_MUTATION=NONE'
    Write-Output 'SECRET_VALUES_EMITTED=0'
}
