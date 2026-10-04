[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$started = [DateTimeOffset]::UtcNow
Write-Output ('ROUND_STARTED_AT=' + $started.ToString('o'))

$ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
$base = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization'
$diagRoot = Join-Path $base ('acl-diag-' + [Guid]::NewGuid().ToString('N'))
$pathA = Join-Path $diagRoot 'extension-create'
$pathB = Join-Path $diagRoot 'create-then-setacl'
$createdRoot = $false
$methodAPass = $false
$methodBPass = $false

function New-OwnerOnlyAcl {
    $acl = [Security.AccessControl.DirectorySecurity]::new()
    $acl.SetAccessRuleProtection($true, $false)
    $acl.SetOwner($ownerSid)
    $inheritance = [Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [Security.AccessControl.InheritanceFlags]::ObjectInherit
    $rule = [Security.AccessControl.FileSystemAccessRule]::new(
        $ownerSid,
        [Security.AccessControl.FileSystemRights]::FullControl,
        $inheritance,
        [Security.AccessControl.PropagationFlags]::None,
        [Security.AccessControl.AccessControlType]::Allow
    )
    [void]$acl.SetAccessRule($rule)
    return $acl
}

function Measure-Acl {
    param([string]$Path)
    $acl = Get-Acl -LiteralPath $Path -ErrorAction Stop
    $owner = $acl.GetOwner([Security.Principal.SecurityIdentifier]).Value
    $rules = @($acl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier]))
    $inherited = @($rules | Where-Object { $_.IsInherited }).Count
    $unauthorized = @($rules | Where-Object { $_.IdentityReference.Value -ne $ownerSid.Value }).Count
    $ownerRules = @($rules | Where-Object { $_.IdentityReference.Value -eq $ownerSid.Value -and $_.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow })
    $full = [long][Security.AccessControl.FileSystemRights]::FullControl
    $directMask = [long]0
    $containerMask = [long]0
    $objectMask = [long]0
    foreach ($rule in $ownerRules) {
        $rights = [long]$rule.FileSystemRights
        if (($rule.PropagationFlags -band [Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0) { $directMask = $directMask -bor $rights }
        if (($rule.InheritanceFlags -band [Security.AccessControl.InheritanceFlags]::ContainerInherit) -ne 0) { $containerMask = $containerMask -bor $rights }
        if (($rule.InheritanceFlags -band [Security.AccessControl.InheritanceFlags]::ObjectInherit) -ne 0) { $objectMask = $objectMask -bor $rights }
    }
    $protected = [bool]$acl.AreAccessRulesProtected
    $ownerMatch = ($owner -ceq $ownerSid.Value)
    $directFull = (($directMask -band $full) -eq $full)
    $childFull = ((($containerMask -band $full) -eq $full) -and (($objectMask -band $full) -eq $full))
    return [pscustomobject]@{
        Protected = $protected
        OwnerMatch = $ownerMatch
        RuleCount = $rules.Count
        InheritedRuleCount = $inherited
        UnauthorizedRuleCount = $unauthorized
        OwnerDirectFullControl = $directFull
        OwnerChildFullControl = $childFull
        Pass = ($protected -and $ownerMatch -and $inherited -eq 0 -and $unauthorized -eq 0 -and $directFull -and $childFull)
    }
}

function Write-AclMeasurement {
    param([string]$Label, [object]$Measurement)
    Write-Output ($Label + '_PROTECTED=' + $Measurement.Protected)
    Write-Output ($Label + '_OWNER_MATCH=' + $Measurement.OwnerMatch)
    Write-Output ($Label + '_RULE_COUNT=' + $Measurement.RuleCount)
    Write-Output ($Label + '_INHERITED_RULE_COUNT=' + $Measurement.InheritedRuleCount)
    Write-Output ($Label + '_UNAUTHORIZED_RULE_COUNT=' + $Measurement.UnauthorizedRuleCount)
    Write-Output ($Label + '_OWNER_DIRECT_FULLCONTROL=' + $Measurement.OwnerDirectFullControl)
    Write-Output ($Label + '_OWNER_CHILD_FULLCONTROL=' + $Measurement.OwnerChildFullControl)
}
try {
    if (-not (Test-Path -LiteralPath $base -PathType Container)) {
        [void][IO.Directory]::CreateDirectory($base)
    }
    [void][IO.Directory]::CreateDirectory($diagRoot)
    $createdRoot = $true

    try {
        $aclA = New-OwnerOnlyAcl
        [void][System.IO.FileSystemAclExtensions]::CreateDirectory($aclA, $pathA)
        $measurementA = Measure-Acl -Path $pathA
        Write-AclMeasurement -Label 'METHOD_A_EXTENSION_CREATE' -Measurement $measurementA
        $methodAPass = [bool]$measurementA.Pass
        Write-Output ('METHOD_A_RESULT=' + $(if ($methodAPass) { 'PASS' } else { 'RETURN_INVARIANT' }))
    }
    catch {
        Write-Output 'METHOD_A_RESULT=RETURN_EXCEPTION'
        Write-Output ('METHOD_A_FAILURE_CLASS=' + $_.Exception.GetType().Name)
    }

    try {
        [void][IO.Directory]::CreateDirectory($pathB)
        $aclB = Get-Acl -LiteralPath $pathB -ErrorAction Stop
        $aclB.SetAccessRuleProtection($true, $false)
        $aclB.SetOwner($ownerSid)
        $inheritance = [Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [Security.AccessControl.InheritanceFlags]::ObjectInherit
        $ruleB = [Security.AccessControl.FileSystemAccessRule]::new(
            $ownerSid,
            [Security.AccessControl.FileSystemRights]::FullControl,
            $inheritance,
            [Security.AccessControl.PropagationFlags]::None,
            [Security.AccessControl.AccessControlType]::Allow
        )
        [void]$aclB.SetAccessRule($ruleB)
        Set-Acl -LiteralPath $pathB -AclObject $aclB -ErrorAction Stop
        $measurementB = Measure-Acl -Path $pathB
        Write-AclMeasurement -Label 'METHOD_B_CREATE_THEN_SETACL' -Measurement $measurementB
        $methodBPass = [bool]$measurementB.Pass
        Write-Output ('METHOD_B_RESULT=' + $(if ($methodBPass) { 'PASS' } else { 'RETURN_INVARIANT' }))
    }
    catch {
        Write-Output 'METHOD_B_RESULT=RETURN_EXCEPTION'
        Write-Output ('METHOD_B_FAILURE_CLASS=' + $_.Exception.GetType().Name)
    }

    if (-not ($methodAPass -or $methodBPass)) { throw 'NO_ACL_METHOD_SATISFIED_INVARIANT' }
    Write-Output 'ACL_DIAGNOSTIC=PASS'
}
catch {
    Write-Output 'ACL_DIAGNOSTIC=RETURN'
    $safe = [string]$_.Exception.Message
    if ($safe -cmatch '^[A-Z][A-Z0-9_]{1,79}$') { Write-Output ('FAILURE_CODE=' + $safe) }
    else { Write-Output 'FAILURE_CODE=UNCLASSIFIED' }
    exit 1
}
finally {
    if ($createdRoot -and (Test-Path -LiteralPath $diagRoot)) {
        Remove-Item -LiteralPath $diagRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
    $finished = [DateTimeOffset]::UtcNow
    Write-Output ('ROUND_FINISHED_AT=' + $finished.ToString('o'))
    Write-Output ('ACTUAL_ELAPSED=' + ($finished - $started).ToString('c'))
    Write-Output ('TEMP_ACL_DIAGNOSTIC_CLEANUP=' + $(if (-not (Test-Path -LiteralPath $diagRoot)) { 'PASS' } else { 'FAIL' }))
    Write-Output 'NETWORK_MUTATION=NONE'
    Write-Output 'SECRET_VALUES_EMITTED=0'
}