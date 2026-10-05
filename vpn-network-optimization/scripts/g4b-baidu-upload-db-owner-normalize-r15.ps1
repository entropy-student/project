[CmdletBinding()]
param(
    [ValidateSet('Validate','Run')]
    [string]$Mode='Validate',
    [switch]$OwnerAuthorized
)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'

$script:stage='BOOT'
$script:mutationStarted=$false
$script:rollbackReady=$false
$script:rollbackAttempted=$false
$script:rollbackResult='NOT_REQUIRED'
$script:result='FAIL_CLOSED'
$script:journalRetained='NO'

function Write-Stage {
    param([Parameter(Mandatory=$true)][string]$Name)
    $script:stage=$Name
    Write-Output ('R15_STAGE='+$Name)
}

function Assert-R15 {
    param([bool]$Condition,[Parameter(Mandatory=$true)][string]$Code)
    if(-not $Condition){throw $Code}
}

function New-OwnerOnlyAcl {
    param(
        [Parameter(Mandatory=$true)][Security.Principal.SecurityIdentifier]$OwnerSid,
        [switch]$Directory
    )

    if($Directory){
        $acl=[Security.AccessControl.DirectorySecurity]::new()
        $inheritance=[Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [Security.AccessControl.InheritanceFlags]::ObjectInherit
    }
    else {
        $acl=[Security.AccessControl.FileSecurity]::new()
        $inheritance=[Security.AccessControl.InheritanceFlags]::None
    }

    $acl.SetAccessRuleProtection($true,$false)
    $acl.SetOwner($OwnerSid)

    $rule=[Security.AccessControl.FileSystemAccessRule]::new(
        $OwnerSid,
        [Security.AccessControl.FileSystemRights]::FullControl,
        $inheritance,
        [Security.AccessControl.PropagationFlags]::None,
        [Security.AccessControl.AccessControlType]::Allow
    )

    [void]$acl.AddAccessRule($rule)
    return $acl
}

function Assert-OwnerOnlyAcl {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][Security.Principal.SecurityIdentifier]$OwnerSid
    )

    $item=Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    Assert-R15 (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'ROLLBACK_PATH_REPARSE_POINT'

    $acl=Get-Acl -LiteralPath $Path -ErrorAction Stop
    Assert-R15 $acl.AreAccessRulesProtected 'ROLLBACK_ACL_INHERITANCE_ENABLED'
    Assert-R15 ($acl.GetOwner([Security.Principal.SecurityIdentifier]).Value -ceq $OwnerSid.Value) 'ROLLBACK_OWNER_MISMATCH'

    $rules=@($acl.GetAccessRules($true,$true,[Security.Principal.SecurityIdentifier]))
    $direct=[long]0

    foreach($rule in $rules){
        Assert-R15 (-not $rule.IsInherited) 'ROLLBACK_ACL_INHERITED_RULE'
        Assert-R15 ($rule.IdentityReference.Value -ceq $OwnerSid.Value) 'ROLLBACK_ACL_UNAUTHORIZED_RULE'
        Assert-R15 ($rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow) 'ROLLBACK_ACL_DENY_RULE'

        if(($rule.PropagationFlags -band [Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0){
            $direct=$direct -bor [long]$rule.FileSystemRights
        }
    }

    $full=[long][Security.AccessControl.FileSystemRights]::FullControl
    Assert-R15 (($direct -band $full) -eq $full) 'ROLLBACK_ACL_FULLCONTROL_MISSING'
}

function Get-OwnerRole {
    param(
        [Parameter(Mandatory=$true)][string]$ActualOwnerSid,
        [Parameter(Mandatory=$true)][Security.Principal.SecurityIdentifier]$ExpectedOwnerSid
    )

    if($ActualOwnerSid -ceq $ExpectedOwnerSid.Value){return 'OWNER'}
    if($ActualOwnerSid -ceq 'S-1-5-32-544'){return 'ADMIN'}
    if($ActualOwnerSid -ceq 'S-1-5-18'){return 'SYSTEM'}
    return 'OTHER'
}

function Assert-R6R1AclPolicy {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][Security.Principal.SecurityIdentifier]$OwnerSid,
        [Parameter(Mandatory=$true)][bool]$IsDirectory,
        [Parameter(Mandatory=$true)][string]$ExpectedOwnerRole
    )

    $item=Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    Assert-R15 (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'R15_REPARSE_POINT'

    $acl=Get-Acl -LiteralPath $Path -ErrorAction Stop
    $actualOwnerSid=$acl.GetOwner([Security.Principal.SecurityIdentifier]).Value
    $ownerRole=Get-OwnerRole -ActualOwnerSid $actualOwnerSid -ExpectedOwnerSid $OwnerSid
    Assert-R15 ($ownerRole -ceq $ExpectedOwnerRole) 'R15_OWNER_ROLE_MISMATCH'

    $allowedSids=@($OwnerSid.Value,'S-1-5-18','S-1-5-32-544')
    $ownerDirectRights=[long]0
    $ownerInheritedRights=[long]0

    foreach($rule in @($acl.GetAccessRules($true,$true,[Security.Principal.SecurityIdentifier]))){
        Assert-R15 ($null -ne $rule) 'R15_ACE_SHAPE_INVALID'
        Assert-R15 ($rule.IdentityReference -is [Security.Principal.SecurityIdentifier]) 'R15_ACE_IDENTITY_INVALID'

        $ruleSid=[string]$rule.IdentityReference.Value

        if($rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Deny){
            throw 'R15_DENY_ACE'
        }

        Assert-R15 ($rule.AccessControlType -eq [Security.AccessControl.AccessControlType]::Allow) 'R15_ACE_TYPE_INVALID'
        Assert-R15 ($ruleSid -in $allowedSids) 'R15_UNAUTHORIZED_ALLOW'

        if(
            $ruleSid -ceq $OwnerSid.Value -and
            (([long]$rule.PropagationFlags -band [long][Security.AccessControl.PropagationFlags]::InheritOnly) -eq 0)
        ){
            if($rule.IsInherited){
                $ownerInheritedRights=$ownerInheritedRights -bor [long]$rule.FileSystemRights
            }
            else {
                $ownerDirectRights=$ownerDirectRights -bor [long]$rule.FileSystemRights
            }
        }
    }

    if($IsDirectory){
        $required=[long](
            [Security.AccessControl.FileSystemRights]::ListDirectory -bor
            [Security.AccessControl.FileSystemRights]::ExecuteFile -bor
            [Security.AccessControl.FileSystemRights]::ReadAttributes -bor
            [Security.AccessControl.FileSystemRights]::ReadExtendedAttributes -bor
            [Security.AccessControl.FileSystemRights]::ReadPermissions
        )
    }
    else {
        $required=[long](
            [Security.AccessControl.FileSystemRights]::ReadData -bor
            [Security.AccessControl.FileSystemRights]::ReadAttributes -bor
            [Security.AccessControl.FileSystemRights]::ReadExtendedAttributes -bor
            [Security.AccessControl.FileSystemRights]::ReadPermissions
        )
    }

    $effective=$ownerDirectRights -bor $ownerInheritedRights
    Assert-R15 (($effective -band $required) -eq $required) 'R15_OWNER_READ_RIGHTS_MISSING'
}

function Get-ExactShape {
    param([Parameter(Mandatory=$true)][string]$ConfigDir)

    $children=@(Get-ChildItem -LiteralPath $ConfigDir -Force -ErrorAction Stop)
    Assert-R15 ($children.Count -eq 2) 'R15_DIRECT_CHILD_COUNT_DRIFT'

    $config=$null
    $uploadDb=$null

    foreach($child in $children){
        Assert-R15 (-not $child.PSIsContainer) 'R15_UNEXPECTED_DIRECTORY'
        Assert-R15 (($child.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'R15_CHILD_REPARSE_POINT'

        $name=[IO.Path]::GetFileName($child.FullName)

        if($name -ceq 'pcs_config.json'){
            Assert-R15 ($null -eq $config) 'R15_DUPLICATE_CONFIG'
            $config=$child
            continue
        }

        if($name -ceq 'pcs_uploading.json'){
            Assert-R15 ($null -eq $uploadDb) 'R15_DUPLICATE_UPLOAD_DB'
            $uploadDb=$child
            continue
        }

        throw 'R15_UNEXPECTED_FILE'
    }

    Assert-R15 ($null -ne $config) 'R15_CONFIG_MISSING'
    Assert-R15 ($null -ne $uploadDb) 'R15_UPLOAD_DB_MISSING'

    return [pscustomobject]@{
        Config=$config
        UploadDb=$uploadDb
    }
}

function Restore-TargetAcl {
    param(
        [Parameter(Mandatory=$true)][string]$TargetPath,
        [Parameter(Mandatory=$true)][string]$JournalFile,
        [Parameter(Mandatory=$true)][Security.Principal.SecurityIdentifier]$OwnerSid
    )

    $script:rollbackAttempted=$true
    $script:rollbackResult='FAIL'

    Assert-OwnerOnlyAcl -Path ([IO.Path]::GetDirectoryName($JournalFile)) -OwnerSid $OwnerSid
    Assert-OwnerOnlyAcl -Path $JournalFile -OwnerSid $OwnerSid

    $journal=[IO.File]::ReadAllLines($JournalFile,[Text.Encoding]::UTF8)
    Assert-R15 ($journal.Count -eq 2) 'R15_ROLLBACK_JOURNAL_SHAPE_INVALID'
    Assert-R15 ($journal[0] -ceq 'VPNR15ACL1') 'R15_ROLLBACK_JOURNAL_VERSION_INVALID'
    Assert-R15 (-not [string]::IsNullOrWhiteSpace($journal[1])) 'R15_ROLLBACK_SDDL_MISSING'

    $restoreAcl=[Security.AccessControl.FileSecurity]::new()
    $restoreAcl.SetSecurityDescriptorSddlForm($journal[1])
    Set-Acl -LiteralPath $TargetPath -AclObject $restoreAcl -ErrorAction Stop

    $after=Get-Acl -LiteralPath $TargetPath -ErrorAction Stop
    $afterRole=Get-OwnerRole -ActualOwnerSid $after.GetOwner([Security.Principal.SecurityIdentifier]).Value -ExpectedOwnerSid $OwnerSid
    Assert-R15 ($afterRole -ceq 'ADMIN') 'R15_ROLLBACK_OWNER_READBACK_FAILED'

    $script:rollbackResult='PASS'
}

$ownerSid=$null
$configDir=$null
$shape=$null
$uploadDbPath=$null
$rollbackDir=$null
$journalFile=$null

try {
    Write-Stage 'OWNER_RUNTIME'

    Assert-R15 ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'

    $ownerSid=[Security.Principal.WindowsIdentity]::GetCurrent().User
    Assert-R15 ($null -ne $ownerSid) 'CURRENT_OWNER_SID_UNAVAILABLE'

    $configDir=Join-Path $env:APPDATA 'BaiduPCS-Go'
    Assert-R15 (-not [string]::IsNullOrWhiteSpace($configDir)) 'BAIDU_CONFIG_PATH_INVALID'
    Assert-R15 (-not $configDir.StartsWith('\\',[StringComparison]::OrdinalIgnoreCase)) 'BAIDU_CONFIG_NETWORK_PATH_FORBIDDEN'
    Assert-R15 (Test-Path -LiteralPath $configDir -PathType Container) 'BAIDU_CONFIG_DIRECTORY_MISSING'

    Write-Output 'OWNER_RUNTIME=PASS'

    Write-Stage 'PRECHECK'

    $root=Get-Item -LiteralPath $configDir -Force -ErrorAction Stop
    Assert-R15 (($root.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'R15_ROOT_REPARSE_POINT'

    $shape=Get-ExactShape -ConfigDir $configDir
    $uploadDbPath=$shape.UploadDb.FullName

    Assert-R6R1AclPolicy -Path $configDir -OwnerSid $ownerSid -IsDirectory $true -ExpectedOwnerRole 'OWNER'
    Assert-R6R1AclPolicy -Path $shape.Config.FullName -OwnerSid $ownerSid -IsDirectory $false -ExpectedOwnerRole 'OWNER'
    Assert-R6R1AclPolicy -Path $uploadDbPath -OwnerSid $ownerSid -IsDirectory $false -ExpectedOwnerRole 'ADMIN'

    Write-Output 'R15_PRECHECK=PASS'
    Write-Output 'R15_TARGET_OWNER_BEFORE=ADMIN'

    if($Mode -ceq 'Validate'){
        $script:result='VALIDATION_PASS'
        Write-Output 'R15_MODE=VALIDATE'
        Write-Output 'R15_MUTATION_AUTHORIZED=NO'
        Write-Output 'R15_RESULT=VALIDATION_PASS'
        return
    }

    Assert-R15 $OwnerAuthorized.IsPresent 'R15_OWNER_AUTHORIZATION_REQUIRED'
    Write-Output 'R15_MODE=RUN'
    Write-Output 'R15_MUTATION_AUTHORIZED=YES'

    Write-Stage 'ROLLBACK_PREPARE'

    $rollbackRoot=Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\rollback'

    if(-not (Test-Path -LiteralPath $rollbackRoot)){
        [void][IO.FileSystemAclExtensions]::CreateDirectory((New-OwnerOnlyAcl -OwnerSid $ownerSid -Directory),$rollbackRoot)
    }

    Assert-OwnerOnlyAcl -Path $rollbackRoot -OwnerSid $ownerSid

    $rollbackDir=Join-Path $rollbackRoot ('r15-'+[guid]::NewGuid().ToString('N'))
    [void][IO.FileSystemAclExtensions]::CreateDirectory((New-OwnerOnlyAcl -OwnerSid $ownerSid -Directory),$rollbackDir)
    Assert-OwnerOnlyAcl -Path $rollbackDir -OwnerSid $ownerSid

    $journalFile=Join-Path $rollbackDir 'upload-db-acl.sddl'

    $targetAcl=Get-Acl -LiteralPath $uploadDbPath -ErrorAction Stop
    $sections=[Security.AccessControl.AccessControlSections]::Owner -bor [Security.AccessControl.AccessControlSections]::Group -bor [Security.AccessControl.AccessControlSections]::Access
    $sddl=$targetAcl.GetSecurityDescriptorSddlForm($sections)

    [IO.File]::WriteAllLines(
        $journalFile,
        @('VPNR15ACL1',$sddl),
        [Text.UTF8Encoding]::new($false)
    )

    Set-Acl -LiteralPath $journalFile -AclObject (New-OwnerOnlyAcl -OwnerSid $ownerSid) -ErrorAction Stop
    Assert-OwnerOnlyAcl -Path $journalFile -OwnerSid $ownerSid

    $journalCheck=[IO.File]::ReadAllLines($journalFile,[Text.Encoding]::UTF8)
    Assert-R15 ($journalCheck.Count -eq 2 -and $journalCheck[0] -ceq 'VPNR15ACL1' -and -not [string]::IsNullOrWhiteSpace($journalCheck[1])) 'R15_ROLLBACK_JOURNAL_READBACK_FAILED'

    $script:rollbackReady=$true
    $script:journalRetained='YES'
    Write-Output 'R15_ROLLBACK_JOURNAL=READY'

    Write-Stage 'OWNER_MUTATION'

    $mutAcl=Get-Acl -LiteralPath $uploadDbPath -ErrorAction Stop
    $mutAcl.SetOwner($ownerSid)

    $script:mutationStarted=$true
    Set-Acl -LiteralPath $uploadDbPath -AclObject $mutAcl -ErrorAction Stop
    Write-Output 'R15_OWNER_MUTATION=PASS'

    Write-Stage 'POST_READBACK'

    $shapeAfter=Get-ExactShape -ConfigDir $configDir

    Assert-R6R1AclPolicy -Path $configDir -OwnerSid $ownerSid -IsDirectory $true -ExpectedOwnerRole 'OWNER'
    Assert-R6R1AclPolicy -Path $shapeAfter.Config.FullName -OwnerSid $ownerSid -IsDirectory $false -ExpectedOwnerRole 'OWNER'
    Assert-R6R1AclPolicy -Path $shapeAfter.UploadDb.FullName -OwnerSid $ownerSid -IsDirectory $false -ExpectedOwnerRole 'OWNER'

    Write-Output 'R15_TARGET_OWNER_AFTER=OWNER'
    Write-Output 'R15_R6R1_STRICT_ACL_READBACK=PASS'
    Write-Output 'R15_SHAPE_READBACK=PASS'

    $script:result='PASS_CANDIDATE'
    Write-Output 'R15_RESULT=PASS_CANDIDATE'
}
catch {
    $failureCode=[string]$_.Exception.Message

    if($script:mutationStarted -and $script:rollbackReady -and -not [string]::IsNullOrWhiteSpace($uploadDbPath) -and -not [string]::IsNullOrWhiteSpace($journalFile)){
        try {
            Write-Stage 'ROLLBACK'
            Restore-TargetAcl -TargetPath $uploadDbPath -JournalFile $journalFile -OwnerSid $ownerSid
            Write-Output 'R15_ROLLBACK=PASS'
            $script:result='ROLLED_BACK'
        }
        catch {
            Write-Output 'R15_ROLLBACK=FAIL'
            $script:result='ROLLBACK_FAILED'
        }
    }
    elseif($script:mutationStarted){
        $script:result='ROLLBACK_UNAVAILABLE'
    }
    else {
        $script:result='FAILED_PRE_MUTATION'
    }

    Write-Output ('R15_FAILED_STAGE='+$script:stage)
    Write-Output ('R15_FAILURE_CODE='+$(if($failureCode -match '^[A-Z][A-Z0-9_]{1,95}$'){$failureCode}else{'LOCAL_NORMALIZATION_EXCEPTION'}))
    Write-Output ('R15_RESULT='+$script:result)
}
finally {
    Write-Output ('ROLLBACK_JOURNAL_RETAINED='+$script:journalRetained)
    Write-Output 'CONFIG_CONTENT_READ=NO'
    Write-Output 'BAIDU_PROVIDER_ACTION=NO'
    Write-Output 'UID_INPUT=NO'
    Write-Output 'SECRET_OR_DPAPI_ACCESS=NO'
    Write-Output 'SSH_OR_VPS_ACTION=NO'
    Write-Output 'NETWORK_MUTATION=NO'
    Write-Output 'STOP_AT_REVIEWER=YES'
}
