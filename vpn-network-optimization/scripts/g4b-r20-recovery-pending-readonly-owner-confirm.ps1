[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'

$script:ownerSid=[Security.Principal.WindowsIdentity]::GetCurrent().User
$runtimeRoot=Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'
$recoveryRoot=Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\recovery'
$configDir=Join-Path $env:APPDATA 'BaiduPCS-Go'
$remoteDir='/vpn-network-optimization-g4b-recovery'

$archiveUrl='https://github.com/qjfoidnh/BaiduPCS-Go/releases/download/v4.0.2/BaiduPCS-Go-v4.0.2-windows-x64.zip'
$archiveSha='ce72b3155a710b7c4a2b15611c3aebd11a057d7cccf0529e7703bdde04f0aa30'
$binarySha='e44769b49156fa3f094431da87231021e6874b6519ea82da4b8af0637662576d'

function Assert-R20R4R1 { param([bool]$Condition,[string]$Code) if(-not $Condition){throw $Code} }
function New-OwnerAcl {
    param([switch]$Directory)
    if($Directory){
        $acl=[Security.AccessControl.DirectorySecurity]::new()
        $inherit=[Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [Security.AccessControl.InheritanceFlags]::ObjectInherit
    } else {
        $acl=[Security.AccessControl.FileSecurity]::new()
        $inherit=[Security.AccessControl.InheritanceFlags]::None
    }
    $acl.SetAccessRuleProtection($true,$false)
    $acl.SetOwner($script:ownerSid)
    [void]$acl.AddAccessRule([Security.AccessControl.FileSystemAccessRule]::new(
        $script:ownerSid,[Security.AccessControl.FileSystemRights]::FullControl,$inherit,
        [Security.AccessControl.PropagationFlags]::None,[Security.AccessControl.AccessControlType]::Allow))
    return $acl
}
function Assert-OwnerAcl {
    param([string]$Path)
    $item=Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    Assert-R20R4R1 (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'OWNER_ACL_REPARSE_POINT'
    $acl=Get-Acl -LiteralPath $Path -ErrorAction Stop
    Assert-R20R4R1 $acl.AreAccessRulesProtected 'OWNER_ACL_INHERITANCE_ENABLED'
    Assert-R20R4R1 ($acl.GetOwner([Security.Principal.SecurityIdentifier]).Value -ceq $script:ownerSid.Value) 'OWNER_ACL_OWNER_MISMATCH'
}
function Get-LocalState {
    param([string]$Path)
    if(-not (Test-Path -LiteralPath $Path)){return 'ABSENT'}
    $item=Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    Assert-R20R4R1 (-not $item.PSIsContainer) 'LOCAL_RECOVERY_PATH_NOT_FILE'
    Assert-R20R4R1 (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'LOCAL_RECOVERY_REPARSE_POINT'
    Assert-OwnerAcl -Path $Path
    Assert-R20R4R1 ($item.Length -gt 0 -and $item.Length -le 1048576) 'LOCAL_RECOVERY_SIZE_INVALID'
    return 'FILE'
}

Assert-R20R4R1 ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
Assert-R20R4R1 (Test-Path -LiteralPath $runtimeRoot -PathType Container) 'RUNTIME_ROOT_MISSING'
Assert-R20R4R1 (Test-Path -LiteralPath $recoveryRoot -PathType Container) 'RECOVERY_ROOT_MISSING'
Assert-OwnerAcl -Path $recoveryRoot

$windowStart=[DateTimeOffset]::Parse('2026-10-06T03:22:00Z')
$windowEnd=[DateTimeOffset]::Parse('2026-10-06T03:29:00Z')
$candidates=[Collections.Generic.List[object]]::new()
foreach($item in @(Get-ChildItem -LiteralPath $runtimeRoot -Filter 'g4b-*.rollback.json' -File -Force -ErrorAction Stop)){
    if($item.LastWriteTimeUtc -lt $windowStart.UtcDateTime -or $item.LastWriteTimeUtc -gt $windowEnd.UtcDateTime){continue}
    $m=[regex]::Match($item.Name,'^g4b-(?<id>[0-9a-f]{32})\.rollback\.json$')
    if(-not $m.Success){continue}
    $record=ConvertFrom-Json -InputObject ([IO.File]::ReadAllText($item.FullName,[Text.Encoding]::UTF8)) -AsHashtable -ErrorAction Stop
    if($record['format'] -cne 'G4B_OWNER_ROLLBACK_R1' -or $record['run_id'] -cne $m.Groups['id'].Value -or $record['status'] -cne 'IN_PROGRESS'){continue}
    if(@($record['profile_created_paths']).Count -ne 0){continue}
    $candidates.Add([pscustomobject]@{RunId=$m.Groups['id'].Value;Record=$record})
}
Assert-R20R4R1 ($candidates.Count -eq 1) 'R20R4R1_R20_JOURNAL_NOT_UNIQUE'
$runId=[string]$candidates[0].RunId
$record=$candidates[0].Record

$pendingLocal=[string]$record['recovery_pending_local']
$pendingPortable=[string]$record['recovery_pending_cloud_local']
$pendingRemote=[string]$record['recovery_pending_external']
$finalLocal=[string]$record['recovery_final_local']
$finalRemote=[string]$record['recovery_final_external']

Assert-R20R4R1 ([IO.Path]::GetFullPath($pendingLocal) -ceq [IO.Path]::GetFullPath((Join-Path $recoveryRoot 'reality-g4b.dpapi.pending'))) 'R20R4R1_PENDING_LOCAL_PATH_INVALID'
Assert-R20R4R1 ([IO.Path]::GetFileName($pendingPortable) -ceq ('vpn-network-optimization-g4b-'+$runId+'.vpr1.pending')) 'R20R4R1_PENDING_PORTABLE_PATH_INVALID'
Assert-R20R4R1 ($pendingRemote -ceq ($remoteDir+'/vpn-network-optimization-g4b-'+$runId+'.vpr1.pending')) 'R20R4R1_PENDING_REMOTE_PATH_INVALID'
Assert-R20R4R1 ([IO.Path]::GetFullPath($finalLocal) -ceq [IO.Path]::GetFullPath((Join-Path $recoveryRoot 'reality-g4b.dpapi'))) 'R20R4R1_FINAL_LOCAL_PATH_INVALID'
Assert-R20R4R1 ($finalRemote -ceq ($remoteDir+'/vpn-network-optimization-g4b.vpr1')) 'R20R4R1_FINAL_REMOTE_PATH_INVALID'

$pendingLocalState=Get-LocalState -Path $pendingLocal
$pendingPortableState=Get-LocalState -Path $pendingPortable
$finalLocalState=Get-LocalState -Path $finalLocal
$baiduRuntime=Join-Path $runtimeRoot ('g4b-baidu-'+$runId)
$baiduRuntimeState=$(if(Test-Path -LiteralPath $baiduRuntime){'PRESENT'}else{'ABSENT'})

$diagRoot=Join-Path $runtimeRoot ('g4b-r20r4r1-baidu-readonly-'+[guid]::NewGuid().ToString('N'))
$archive=Join-Path $diagRoot 'BaiduPCS-Go-v4.0.2-windows-x64.zip'
$exe=Join-Path $diagRoot 'BaiduPCS-Go.exe'
$cleanupPass=$false
$who=$null;$ls=$null;$currentUid=$null
try{
    Assert-R20R4R1 (Test-Path -LiteralPath $configDir -PathType Container) 'BAIDU_AUTH_CONFIG_MISSING'
    [void][IO.FileSystemAclExtensions]::CreateDirectory((New-OwnerAcl -Directory),$diagRoot)
    Assert-OwnerAcl -Path $diagRoot

    $old=$ProgressPreference
    try{
        $ProgressPreference='SilentlyContinue'
        [void](Invoke-WebRequest -Uri $archiveUrl -OutFile $archive -TimeoutSec 120 -ErrorAction Stop)
    } finally {$ProgressPreference=$old}
    Assert-R20R4R1 ((Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant() -ceq $archiveSha) 'BAIDU_ARCHIVE_HASH_INVALID'

    Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop
    $zip=$null;$entryStream=$null;$outStream=$null
    try{
        $zip=[IO.Compression.ZipFile]::OpenRead($archive)
        $entries=@($zip.Entries|Where-Object{[IO.Path]::GetFileName($_.FullName) -ceq 'BaiduPCS-Go.exe'})
        Assert-R20R4R1 ($entries.Count -eq 1) 'BAIDU_ARCHIVE_ENTRY_INVALID'
        $entryStream=$entries[0].Open()
        $outStream=[IO.File]::Open($exe,[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::None)
        $entryStream.CopyTo($outStream)
    } finally {
        if($outStream){$outStream.Dispose()};if($entryStream){$entryStream.Dispose()};if($zip){$zip.Dispose()}
    }
    Set-Acl -LiteralPath $exe -AclObject (New-OwnerAcl) -ErrorAction Stop
    Assert-R20R4R1 ((Get-FileHash -LiteralPath $exe -Algorithm SHA256).Hash.ToLowerInvariant() -ceq $binarySha) 'BAIDU_BINARY_HASH_INVALID'

    function Invoke-BaiduRead {
        param([ValidateSet('who','ls')][string]$Action,[string[]]$Arguments=@())
        $psi=[Diagnostics.ProcessStartInfo]::new()
        $psi.FileName=$exe;$psi.UseShellExecute=$false;$psi.CreateNoWindow=$true
        $psi.RedirectStandardOutput=$true;$psi.RedirectStandardError=$true
        [void]$psi.ArgumentList.Add($Action)
        foreach($arg in $Arguments){[void]$psi.ArgumentList.Add($arg)}
        foreach($key in @($psi.Environment.Keys)){
            if([string]$key -match '(?i)bduss|stoken|ptoken|cookie|password|credential|auth|secret|token'){[void]$psi.Environment.Remove([string]$key)}
        }
        $psi.Environment['BAIDUPCS_GO_CONFIG_DIR']=$configDir
        $psi.Environment['BAIDUPCS_GO_VERBOSE']='0'
        $p=[Diagnostics.Process]::new()
        try{
            $p.StartInfo=$psi
            Assert-R20R4R1 ($p.Start()) 'BAIDU_PROCESS_START_FAILED'
            $ot=$p.StandardOutput.ReadToEndAsync();$et=$p.StandardError.ReadToEndAsync()
            if(-not $p.WaitForExit(120000)){try{$p.Kill($true)}catch{};throw 'BAIDU_PROCESS_TIMEOUT'}
            return @{ExitCode=[int]$p.ExitCode;StdOut=[string]$ot.GetAwaiter().GetResult();StdErr=[string]$et.GetAwaiter().GetResult()}
        } finally {$p.Dispose()}
    }

    $who=Invoke-BaiduRead -Action 'who'
    Assert-R20R4R1 ([int]$who['ExitCode'] -eq 0) 'BAIDU_WHO_FAILED'
    $uidMatches=[regex]::Matches([string]$who['StdOut'],'(?m)^当前帐号 uid:\s*([0-9]+),')
    Assert-R20R4R1 ($uidMatches.Count -eq 1) 'BAIDU_UID_PARSE_OR_UNIQUENESS_FAILED'
    $currentUid=$uidMatches[0].Groups[1].Value

    Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
    $nl=[Environment]::NewLine
    $message='当前 BaiduPCS-Go 登录 UID：'+$currentUid+$nl+$nl+'请仅在本机核对：这是否就是本项目一直使用的百度网盘账号？'+$nl+'UID 不会写入 GitHub，也不会输出到终端证据。'
    $choice=[System.Windows.Forms.MessageBox]::Show(
        $message,
        'R20R4R1 本地账号身份确认',
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question
    )
    Assert-R20R4R1 ($choice -eq [System.Windows.Forms.DialogResult]::Yes) 'OWNER_BAIDU_ACCOUNT_CONFIRMATION_DECLINED'
    Write-Output 'R20R4R1_OWNER_BAIDU_ACCOUNT_CONFIRMATION=PASS'

    $ls=Invoke-BaiduRead -Action 'ls' -Arguments @('-l',$remoteDir)
    Assert-R20R4R1 ([int]$ls['ExitCode'] -eq 0) 'BAIDU_LS_FAILED'
    $listing=[string]$ls['StdOut']
    Assert-R20R4R1 ([regex]::IsMatch($listing,'(?m)^当前目录:\s*'+[regex]::Escape($remoteDir)+'\s*(?=\r?\n|\z)')) 'BAIDU_DIRECTORY_HEADER_INVALID'

    $pendingName=[IO.Path]::GetFileName($pendingRemote)
    $finalName=[IO.Path]::GetFileName($finalRemote)
    $pendingPattern='(?m)^(?:[^\r\n]*[ \t])?'+[regex]::Escape($pendingName)+'(?<dir>/)?[ \t]*(?=\r?\n|\z)'
    $finalPattern='(?m)^(?:[^\r\n]*[ \t])?'+[regex]::Escape($finalName)+'(?<dir>/)?[ \t]*(?=\r?\n|\z)'
    $pm=[regex]::Matches($listing,$pendingPattern)
    $fm=[regex]::Matches($listing,$finalPattern)
    Assert-R20R4R1 ($pm.Count -le 1 -and $fm.Count -le 1) 'BAIDU_OBJECT_LISTING_AMBIGUOUS'
    $remotePendingState=$(if($pm.Count -eq 0){'ABSENT'}elseif($pm[0].Groups['dir'].Success){'DIRECTORY'}else{'FILE'})
    $remoteFinalState=$(if($fm.Count -eq 0){'ABSENT'}elseif($fm[0].Groups['dir'].Success){'DIRECTORY'}else{'FILE'})

    Write-Output 'R20R4R1_LOCAL_JOURNAL_IDENTITY=PASS'
    Write-Output ('R20R4R1_LOCAL_DPAPI_PENDING='+$pendingLocalState)
    Write-Output ('R20R4R1_LOCAL_PORTABLE_PENDING='+$pendingPortableState)
    Write-Output ('R20R4R1_LOCAL_FINAL='+$finalLocalState)
    Write-Output ('R20R4R1_LOCAL_BAIDU_RUNTIME='+$baiduRuntimeState)
    Write-Output ('R20R4R1_REMOTE_PENDING='+$remotePendingState)
    Write-Output ('R20R4R1_REMOTE_FINAL='+$remoteFinalState)
    $expected=(
        $pendingLocalState -ceq 'FILE' -and
        $pendingPortableState -ceq 'FILE' -and
        $finalLocalState -ceq 'ABSENT' -and
        $remotePendingState -ceq 'FILE' -and
        $remoteFinalState -ceq 'ABSENT'
    )
    Write-Output ('R20R4R1_RECOVERY_STATE='+$(if($expected){'EXPECTED_FAILED_RUN_PENDING_SET'}else{'UNEXPECTED_REQUIRES_REVIEW'}))
}
finally{
    $currentUid=$null;$who=$null;$ls=$null
    if(Test-Path -LiteralPath $diagRoot -PathType Container){
        try{Assert-OwnerAcl -Path $diagRoot;Remove-Item -LiteralPath $diagRoot -Recurse -Force -ErrorAction Stop;$cleanupPass=(-not(Test-Path -LiteralPath $diagRoot))}
        catch{$cleanupPass=$false}
    } else {$cleanupPass=$true}
    Write-Output ('R20R4R1_TEMP_RUNTIME_CLEANUP='+$(if($cleanupPass){'PASS'}else{'FAIL'}))
    Write-Output 'R20R4R1_UID_EMITTED_TO_TERMINAL=NO'
    Write-Output 'R20R4R1_RECOVERY_CONTENT_READ=NO'
    Write-Output 'R20R4R1_RECOVERY_MUTATION=NO'
    Write-Output 'R20R4R1_BAIDU_MUTATION=NO'
    Write-Output 'R20R4R1_SSH_OR_VPS_ACTION=NO'
    Write-Output 'R20R4R1_NETWORK_MUTATION=NO'
    Write-Output 'STOP_AT_REVIEWER=YES'
}
