[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$started = [DateTimeOffset]::UtcNow
Write-Output ('ROUND_STARTED_AT=' + $started.ToString('o'))

$projectRoot = Split-Path -Parent $PSScriptRoot
$runtimeRoot = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'
$recoveryPath = Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\recovery\hy2-g2a.dpapi'
$templatePath = Join-Path $projectRoot 'templates\clash\c2c-real-hy2-canary.yaml.template'
$mihomoPath = 'C:\Program Files\Clash Verge\verge-mihomo.exe'
$ownerSid = [Security.Principal.WindowsIdentity]::GetCurrent().User

function Assert-D6 {
    param([bool]$Condition,[string]$Code)
    if (-not $Condition) { throw $Code }
}

function Test-HighIntegrity {
    $groups = (& whoami.exe /groups 2>&1) -join [Environment]::NewLine
    $match = [regex]::Match($groups,'S-1-16-(\d+)')
    return ($match.Success -and [int]$match.Groups[1].Value -ge 12288)
}

function Test-OwnerAclShape {
    param([string]$Path)

    $item = Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    $acl = Get-Acl -LiteralPath $Path -ErrorAction Stop

    Assert-D6 $acl.AreAccessRulesProtected 'OWNER_ACL_INHERITANCE_ENABLED'

    $owner = $acl.GetOwner([Security.Principal.SecurityIdentifier]).Value
    Assert-D6 ($owner -ceq $ownerSid.Value) 'OWNER_ACL_OWNER_MISMATCH'

    $rules = @($acl.GetAccessRules($true,$true,[Security.Principal.SecurityIdentifier]))
    Assert-D6 (@($rules).Count -gt 0) 'OWNER_ACL_RULES_MISSING'

    $direct = [long]0
    $container = [long]0
    $object = [long]0

    foreach ($rule in $rules) {
        Assert-D6 (-not $rule.IsInherited) 'OWNER_ACL_INHERITED_RULE_PRESENT'
        Assert-D6 ($rule.IdentityReference.Value -ceq $ownerSid.Value) 'OWNER_ACL_UNAUTHORIZED_PRINCIPAL'
        Assert-D6 ($rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow) 'OWNER_ACL_DENY_RULE_PRESENT'

        $rights = [long]$rule.FileSystemRights
        if (($rule.PropagationFlags -band [Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0) {
            $direct = $direct -bor $rights
        }
        if ($item.PSIsContainer) {
            if (($rule.InheritanceFlags -band [Security.AccessControl.InheritanceFlags]::ContainerInherit) -ne 0) {
                $container = $container -bor $rights
            }
            if (($rule.InheritanceFlags -band [Security.AccessControl.InheritanceFlags]::ObjectInherit) -ne 0) {
                $object = $object -bor $rights
            }
        }
    }

    $full = [long][Security.AccessControl.FileSystemRights]::FullControl
    Assert-D6 (($direct -band $full) -eq $full) 'OWNER_ACL_FULLCONTROL_MISSING'

    if ($item.PSIsContainer) {
        Assert-D6 ((($container -band $full) -eq $full) -and (($object -band $full) -eq $full)) 'OWNER_ACL_CHILD_INHERITANCE_MISSING'
    }
}

try {
    Assert-D6 ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
    Assert-D6 (Test-HighIntegrity) 'HIGH_INTEGRITY_REQUIRED'

    $principal = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
    Assert-D6 ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 'ADMINISTRATOR_REQUIRED'
    Assert-D6 ($null -ne $ownerSid) 'OWNER_SID_UNAVAILABLE'
    Write-Output 'OWNER_RUNTIME=PASS'

    Assert-D6 (Test-Path -LiteralPath $recoveryPath -PathType Leaf) 'HY2_RECOVERY_MISSING'
    Write-Output 'HY2_RECOVERY_EXISTS=YES'

    $recoveryRoot = Split-Path -Parent $recoveryPath
    Assert-D6 (Test-Path -LiteralPath $recoveryRoot -PathType Container) 'HY2_RECOVERY_ROOT_MISSING'

    Test-OwnerAclShape -Path $recoveryRoot
    Write-Output 'HY2_RECOVERY_ROOT_ACL=PASS'

    Test-OwnerAclShape -Path $recoveryPath
    Write-Output 'HY2_RECOVERY_FILE_ACL=PASS'

    if (Test-Path -LiteralPath $runtimeRoot -PathType Container) {
        Test-OwnerAclShape -Path $runtimeRoot
        Write-Output 'RUNTIME_ROOT_EXISTS=YES'
        Write-Output 'RUNTIME_ROOT_ACL=PASS'
    }
    else {
        Write-Output 'RUNTIME_ROOT_EXISTS=NO'
        Write-Output 'RUNTIME_ROOT_ACL=CREATE_PATH_NOT_TESTED'
    }

    $runtimeDirs = @()
    $runtimeProfiles = @()
    if (Test-Path -LiteralPath $runtimeRoot -PathType Container) {
        $runtimeDirs = @(
            Get-ChildItem -LiteralPath $runtimeRoot -Directory -Force -ErrorAction Stop |
            Where-Object { $_.Name -match '^c2c-[0-9a-f]{32}$' }
        )
        $runtimeProfiles = @(
            Get-ChildItem -LiteralPath $runtimeRoot -File -Recurse -Force -ErrorAction Stop |
            Where-Object { $_.Name -match '^c2c-real-hy2-canary-[0-9a-f]{8}\.yaml$' }
        )
    }

    Write-Output ('RUNTIME_C2C_DIRECTORY_COUNT=' + @($runtimeDirs).Count)
    Write-Output ('RUNTIME_C2C_PROFILE_COUNT=' + @($runtimeProfiles).Count)

    Assert-D6 (@($runtimeDirs).Count -eq 0) 'RUNTIME_C2C_DIRECTORY_RESIDUE_PRESENT'
    Assert-D6 (@($runtimeProfiles).Count -eq 0) 'RUNTIME_C2C_PROFILE_RESIDUE_PRESENT'

    $roamingRoot = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData)
    $roots = @(
        Get-ChildItem -LiteralPath $roamingRoot -Directory -Force -ErrorAction Stop |
        Where-Object { $_.Name -match '(?i)(?:clash.*verge|verge.*clash)' }
    )
    $stores = @(
        $roots |
        ForEach-Object { Join-Path $_.FullName 'profiles' } |
        Where-Object { Test-Path -LiteralPath $_ -PathType Container }
    )

    Write-Output ('CLASH_PROFILE_STORE_COUNT=' + @($stores).Count)
    Assert-D6 (@($stores).Count -eq 1) 'CLASH_PROFILE_STORE_AMBIGUOUS'

    $profileResidue = @(
        Get-ChildItem -LiteralPath $stores[0] -File -Recurse -Force -ErrorAction Stop |
        Where-Object { $_.Name -match '^c2c-real-hy2-canary-[0-9a-f]{8}\.yaml$' }
    )
    Write-Output ('CLASH_C2C_PROFILE_FILENAME_COUNT=' + @($profileResidue).Count)
    Assert-D6 (@($profileResidue).Count -eq 0) 'CLASH_C2C_PROFILE_FILENAME_RESIDUE_PRESENT'

    Assert-D6 (Test-Path -LiteralPath $templatePath -PathType Leaf) 'C2C_TEMPLATE_MISSING'
    $templateText = [IO.File]::ReadAllText($templatePath,[Text.Encoding]::UTF8)

    $nonAscii = @($templateText.ToCharArray() | Where-Object { [int][char]$_ -gt 127 })
    Assert-D6 (@($nonAscii).Count -eq 0) 'C2C_TEMPLATE_NON_ASCII'

    $placeholderCount = ([regex]::Matches($templateText,'__C2C_REAL_HY2_AUTH_INJECTION_ONLY__')).Count
    Assert-D6 ($placeholderCount -eq 1) 'C2C_TEMPLATE_SECRET_PLACEHOLDER_INVALID'

    $fp = [regex]::Match($templateText,'(?m)^\s+fingerprint:\s*(?<v>[0-9A-F]{2}(?::[0-9A-F]{2}){31})\s*$')
    Assert-D6 $fp.Success 'C2C_TEMPLATE_FINGERPRINT_INVALID'
    Write-Output 'C2C_TEMPLATE_STATIC_CHECK=PASS'

    Assert-D6 (Test-Path -LiteralPath $mihomoPath -PathType Leaf) 'MIHOMO_BINARY_MISSING'
    $mihomoVersion = @(& $mihomoPath -v 2>&1)
    Assert-D6 ($LASTEXITCODE -eq 0) 'MIHOMO_VERSION_READ_FAILED'
    Assert-D6 (($mihomoVersion -join ' ') -match '\bv1\.19\.32\b') 'MIHOMO_VERSION_MISMATCH'
    Write-Output 'MIHOMO_VERSION=v1.19.32'

    Add-Type -AssemblyName System.Security.Cryptography.ProtectedData
    Add-Type -AssemblyName System.IO.FileSystem.AccessControl
    Write-Output 'REQUIRED_DOTNET_ASSEMBLIES=PASS'

    Write-Output 'D6_PRESECRET_PREREQUISITES=PASS'
}
catch {
    Write-Output 'D6_PRESECRET_PREREQUISITES=RETURN'
    $code = [string]$_.Exception.Message
    if ($code -cmatch '^[A-Z][A-Z0-9_]{1,95}$') {
        Write-Output ('FAILURE_CODE=' + $code)
    }
    else {
        Write-Output ('FAILURE_CLASS=' + $_.Exception.GetType().Name)
        Write-Output 'FAILURE_CODE=UNCLASSIFIED'
    }
    exit 1
}
finally {
    $finished = [DateTimeOffset]::UtcNow
    Write-Output ('ROUND_FINISHED_AT=' + $finished.ToString('o'))
    Write-Output ('ACTUAL_ELAPSED=' + ($finished-$started).ToString('c'))
    Write-Output 'DPAPI_UNPROTECT=NO'
    Write-Output 'RECOVERY_FILE_CONTENT_READ=NO'
    Write-Output 'REAL_SECRET_READ=NO'
    Write-Output 'CLASH_PROFILE_MUTATION=NO'
    Write-Output 'NETWORK_REQUESTS=0'
    Write-Output 'NETWORK_CHANGED=NO'
    Write-Output 'SECRET_VALUES_EMITTED=0'
}
