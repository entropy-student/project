[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$started = [DateTimeOffset]::UtcNow
Write-Output ('ROUND_STARTED_AT=' + $started.ToString('o'))

$ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User
$runtimeRoot = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'

try {
    Write-Output ('RUNTIME_ROOT_EXISTS=' + (Test-Path -LiteralPath $runtimeRoot -PathType Container))

    if (-not (Test-Path -LiteralPath $runtimeRoot -PathType Container)) {
        Write-Output 'RUNTIME_ROOT_STATE=MISSING'
        Write-Output 'RUNTIME_ROOT_DIAGNOSTIC=PASS'
        exit 0
    }

    $item = Get-Item -LiteralPath $runtimeRoot -Force -ErrorAction Stop
    $isReparse = (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)
    Write-Output ('RUNTIME_ROOT_REPARSE_POINT=' + $isReparse)
    if ($isReparse) { throw 'RUNTIME_ROOT_REPARSE_POINT_PRESENT' }

    $children = @(Get-ChildItem -LiteralPath $runtimeRoot -Force -ErrorAction Stop)
    Write-Output ('RUNTIME_ROOT_CHILD_COUNT=' + $children.Count)
    Write-Output ('RUNTIME_ROOT_EMPTY=' + ($children.Count -eq 0))

    $acl = Get-Acl -LiteralPath $runtimeRoot -ErrorAction Stop
    $owner = $acl.GetOwner([Security.Principal.SecurityIdentifier]).Value
    $rules = @($acl.GetAccessRules($true, $true, [Security.Principal.SecurityIdentifier]))
    $inherited = @($rules | Where-Object { $_.IsInherited }).Count
    $unauthorized = @($rules | Where-Object { $_.IdentityReference.Value -ne $ownerSid.Value }).Count
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

    Write-Output ('RUNTIME_ROOT_ACL_PROTECTED=' + $acl.AreAccessRulesProtected)
    Write-Output ('RUNTIME_ROOT_OWNER_MATCH=' + ($owner -ceq $ownerSid.Value))
    Write-Output ('RUNTIME_ROOT_RULE_COUNT=' + $rules.Count)
    Write-Output ('RUNTIME_ROOT_INHERITED_RULE_COUNT=' + $inherited)
    Write-Output ('RUNTIME_ROOT_UNAUTHORIZED_RULE_COUNT=' + $unauthorized)
    Write-Output ('RUNTIME_ROOT_OWNER_DIRECT_FULLCONTROL=' + (($directMask -band $full) -eq $full))
    Write-Output ('RUNTIME_ROOT_OWNER_CHILD_FULLCONTROL=' + ((($containerMask -band $full) -eq $full) -and (($objectMask -band $full) -eq $full)))
    Write-Output 'RUNTIME_ROOT_DIAGNOSTIC=PASS'
}
catch {
    Write-Output 'RUNTIME_ROOT_DIAGNOSTIC=RETURN'
    $code = [string]$_.Exception.Message
    if ($code -cmatch '^[A-Z][A-Z0-9_]{1,79}$') { Write-Output ('FAILURE_CODE=' + $code) }
    else { Write-Output 'FAILURE_CODE=UNCLASSIFIED' }
    exit 1
}
finally {
    $finished = [DateTimeOffset]::UtcNow
    Write-Output ('ROUND_FINISHED_AT=' + $finished.ToString('o'))
    Write-Output ('ACTUAL_ELAPSED=' + ($finished - $started).ToString('c'))
    Write-Output 'RUNTIME_ROOT_MUTATION=NONE'
    Write-Output 'NETWORK_MUTATION=NONE'
    Write-Output 'SECRET_VALUES_EMITTED=0'
}