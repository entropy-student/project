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

function Assert-R20R5 { param([bool]$Condition,[string]$Code) if(-not $Condition){throw $Code} }

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
    Assert-R20R5 (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'OWNER_ACL_REPARSE_POINT'
    $acl=Get-Acl -LiteralPath $Path -ErrorAction Stop
    Assert-R20R5 $acl.AreAccessRulesProtected 'OWNER_ACL_INHERITANCE_ENABLED'
    Assert-R20R5 ($acl.GetOwner([Security.Principal.SecurityIdentifier]).Value -ceq $script:ownerSid.Value) 'OWNER_ACL_OWNER_MISMATCH'
}

function Assert-LocalRecoveryFile {
    param([string]$Path)
    Assert-R20R5 (Test-Path -LiteralPath $Path -PathType Leaf) 'LOCAL_RECOVERY_PENDING_MISSING'
    $item=Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    Assert-R20R5 (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'LOCAL_RECOVERY_REPARSE_POINT'
    Assert-R20R5 ($item.Length -gt 0 -and $item.Length -le 1048576) 'LOCAL_RECOVERY_SIZE_INVALID'
    Assert-OwnerAcl -Path $Path
}

Assert-R20R5 ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
Assert-R20R5 (Test-Path -LiteralPath $runtimeRoot -PathType Container) 'RUNTIME_ROOT_MISSING'
Assert-R20R5 (Test-Path -LiteralPath $recoveryRoot -PathType Container) 'RECOVERY_ROOT_MISSING'
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
    $candidates.Add([pscustomobject]@{RunId=$m.Groups['id'].Value;Record=$record;Journal=$item.FullName})
}
Assert-R20R5 ($candidates.Count -eq 1) 'R20R5_R20_JOURNAL_NOT_UNIQUE'

$runId=[string]$candidates[0].RunId
$record=$candidates[0].Record
$journalPath=[string]$candidates[0].Journal
Assert-OwnerAcl -Path $journalPath

$pendingLocal=[string]$record['recovery_pending_local']
$pendingPortable=[string]$record['recovery_pending_cloud_local']
$pendingRemote=[string]$record['recovery_pending_external']
$finalLocal=[string]$record['recovery_final_local']
$finalRemote=[string]$record['recovery_final_external']

Assert-R20R5 ([IO.Path]::GetFullPath($pendingLocal) -ceq [IO.Path]::GetFullPath((Join-Path $recoveryRoot 'reality-g4b.dpapi.pending'))) 'R20R5_PENDING_LOCAL_PATH_INVALID'
Assert-R20R5 ([IO.Path]::GetFileName($pendingPortable) -ceq ('vpn-network-optimization-g4b-'+$runId+'.vpr1.pending')) 'R20R5_PENDING_PORTABLE_PATH_INVALID'
Assert-R20R5 ($pendingRemote -ceq ($remoteDir+'/vpn-network-optimization-g4b-'+$runId+'.vpr1.pending')) 'R20R5_PENDING_REMOTE_PATH_INVALID'
Assert-R20R5 ([IO.Path]::GetFullPath($finalLocal) -ceq [IO.Path]::GetFullPath((Join-Path $recoveryRoot 'reality-g4b.dpapi'))) 'R20R5_FINAL_LOCAL_PATH_INVALID'
Assert-R20R5 ($finalRemote -ceq ($remoteDir+'/vpn-network-optimization-g4b.vpr1')) 'R20R5_FINAL_REMOTE_PATH_INVALID'

Assert-LocalRecoveryFile -Path $pendingLocal
Assert-LocalRecoveryFile -Path $pendingPortable
Assert-R20R5 (-not (Test-Path -LiteralPath $finalLocal)) 'R20R5_LOCAL_FINAL_COLLISION'

$diagRoot=Join-Path $runtimeRoot ('g4b-r20r5-baidu-'+[guid]::NewGuid().ToString('N'))
$archive=Join-Path $diagRoot 'BaiduPCS-Go-v4.0.2-windows-x64.zip'
$exe=Join-Path $diagRoot 'BaiduPCS-Go.exe'
$readbackDir=Join-Path $diagRoot 'readback'
$cleanupPass=$false
$remoteDeleted=$false
$localDeleted=$false
$who=$null
$ls=$null

try{
    Assert-R20R5 (Test-Path -LiteralPath $configDir -PathType Container) 'BAIDU_AUTH_CONFIG_MISSING'
    [void][IO.FileSystemAclExtensions]::CreateDirectory((New-OwnerAcl -Directory),$diagRoot)
    Assert-OwnerAcl -Path $diagRoot

    $old=$ProgressPreference
    try{
        $ProgressPreference='SilentlyContinue'
        [void](Invoke-WebRequest -Uri $archiveUrl -OutFile $archive -TimeoutSec 120 -ErrorAction Stop)
    } finally {$ProgressPreference=$old}

    Assert-R20R5 ((Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant() -ceq $archiveSha) 'BAIDU_ARCHIVE_HASH_INVALID'

    Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop
    $zip=$null;$entryStream=$null;$outStream=$null
    try{
        $zip=[IO.Compression.ZipFile]::OpenRead($archive)
        $entries=@($zip.Entries|Where-Object{[IO.Path]::GetFileName($_.FullName) -ceq 'BaiduPCS-Go.exe'})
        Assert-R20R5 ($entries.Count -eq 1) 'BAIDU_ARCHIVE_ENTRY_INVALID'
        $entryStream=$entries[0].Open()
        $outStream=[IO.File]::Open($exe,[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::None)
        $entryStream.CopyTo($outStream)
    } finally {
        if($outStream){$outStream.Dispose()}
        if($entryStream){$entryStream.Dispose()}
        if($zip){$zip.Dispose()}
    }

    Set-Acl -LiteralPath $exe -AclObject (New-OwnerAcl) -ErrorAction Stop
    Assert-R20R5 ((Get-FileHash -LiteralPath $exe -Algorithm SHA256).Hash.ToLowerInvariant() -ceq $binarySha) 'BAIDU_BINARY_HASH_INVALID'

    function Invoke-Baidu {
        param(
            [ValidateSet('who','ls','download','rm')][string]$Action,
            [string[]]$Arguments=@()
        )
        switch($Action){
            'who' { Assert-R20R5 ($Arguments.Count -eq 0) 'BAIDU_ARGUMENT_SHAPE_INVALID' }
            'ls' { Assert-R20R5 ($Arguments.Count -eq 2 -and $Arguments[0] -ceq '-l' -and $Arguments[1] -ceq $remoteDir) 'BAIDU_ARGUMENT_SHAPE_INVALID' }
            'download' {
                Assert-R20R5 (
                    $Arguments.Count -eq 3 -and
                    $Arguments[0] -ceq $pendingRemote -and
                    $Arguments[1] -ceq '--saveto' -and
                    [IO.Path]::GetFullPath($Arguments[2]) -ceq [IO.Path]::GetFullPath($readbackDir)
                ) 'BAIDU_ARGUMENT_SHAPE_INVALID'
            }
            'rm' { Assert-R20R5 ($Arguments.Count -eq 1 -and $Arguments[0] -ceq $pendingRemote) 'BAIDU_ARGUMENT_SHAPE_INVALID' }
        }

        $psi=[Diagnostics.ProcessStartInfo]::new()
        $psi.FileName=$exe
        $psi.UseShellExecute=$false
        $psi.CreateNoWindow=$true
        $psi.RedirectStandardOutput=$true
        $psi.RedirectStandardError=$true
        $utf8=[Text.UTF8Encoding]::new($false)
        $psi.StandardOutputEncoding=$utf8
        $psi.StandardErrorEncoding=$utf8
        [void]$psi.ArgumentList.Add($Action)
        foreach($arg in $Arguments){[void]$psi.ArgumentList.Add([string]$arg)}
        foreach($key in @($psi.Environment.Keys)){
            if([string]$key -match '(?i)bduss|stoken|ptoken|cookie|password|credential|auth|secret|token'){
                [void]$psi.Environment.Remove([string]$key)
            }
        }
        $psi.Environment['BAIDUPCS_GO_CONFIG_DIR']=$configDir
        $psi.Environment['BAIDUPCS_GO_VERBOSE']='0'

        $p=[Diagnostics.Process]::new()
        try{
            $p.StartInfo=$psi
            Assert-R20R5 ($p.Start()) 'BAIDU_PROCESS_START_FAILED'
            $ot=$p.StandardOutput.ReadToEndAsync()
            $et=$p.StandardError.ReadToEndAsync()
            if(-not $p.WaitForExit(120000)){
                try{$p.Kill($true)}catch{}
                throw 'BAIDU_PROCESS_TIMEOUT'
            }
            $stdout=[string]$ot.GetAwaiter().GetResult()
            $stderr=[string]$et.GetAwaiter().GetResult()
            Assert-R20R5 ($p.ExitCode -eq 0) ('BAIDU_'+$Action.ToUpper()+'_FAILED')
            return @{StdOut=$stdout;StdErr=$stderr}
        }
        finally{$p.Dispose()}
    }

    $who=Invoke-Baidu -Action 'who'
    $uidMatches=[regex]::Matches([string]$who['StdOut'],'(?m)^当前帐号 uid:\s*([0-9]+),')
    Assert-R20R5 ($uidMatches.Count -eq 1) 'BAIDU_UID_PARSE_OR_UNIQUENESS_FAILED'
    $currentUid=$uidMatches[0].Groups[1].Value

    Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
    $nl=[Environment]::NewLine
    $message='当前 BaiduPCS-Go 登录 UID：'+$currentUid+$nl+$nl+'请确认这仍是本项目使用的百度网盘账号。'+$nl+'确认后将删除本轮 R20 的 exact pending 对象；UID 不会写入终端或 GitHub。'
    $choice=[System.Windows.Forms.MessageBox]::Show(
        $message,
        'R20R5 百度账号本地确认',
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )
    $currentUid=$null
    Assert-R20R5 ($choice -eq [System.Windows.Forms.DialogResult]::Yes) 'OWNER_BAIDU_ACCOUNT_CONFIRMATION_DECLINED'
    Write-Output 'R20R5_OWNER_BAIDU_ACCOUNT_CONFIRMATION=PASS'

    $ls=Invoke-Baidu -Action 'ls' -Arguments @('-l',$remoteDir)
    $listing=[string]$ls['StdOut']
    Assert-R20R5 ([regex]::IsMatch($listing,'(?m)^当前目录:\s*'+[regex]::Escape($remoteDir)+'\s*(?=\r?\n|\z)')) 'BAIDU_DIRECTORY_HEADER_INVALID'

    $pendingName=[IO.Path]::GetFileName($pendingRemote)
    $finalName=[IO.Path]::GetFileName($finalRemote)
    $pm=[regex]::Matches($listing,'(?m)^(?:[^\r\n]*[ \t])?'+[regex]::Escape($pendingName)+'(?<dir>/)?[ \t]*(?=\r?\n|\z)')
    $fm=[regex]::Matches($listing,'(?m)^(?:[^\r\n]*[ \t])?'+[regex]::Escape($finalName)+'(?<dir>/)?[ \t]*(?=\r?\n|\z)')
    Assert-R20R5 ($pm.Count -eq 1 -and -not $pm[0].Groups['dir'].Success) 'BAIDU_PENDING_NOT_EXACT_FILE'
    Assert-R20R5 ($fm.Count -eq 0) 'BAIDU_FINAL_COLLISION'

    [void][IO.FileSystemAclExtensions]::CreateDirectory((New-OwnerAcl -Directory),$readbackDir)
    Assert-OwnerAcl -Path $readbackDir

    [void](Invoke-Baidu -Action 'download' -Arguments @($pendingRemote,'--saveto',$readbackDir))
    $downloaded=Join-Path $readbackDir $pendingName
    Assert-R20R5 (Test-Path -LiteralPath $downloaded -PathType Leaf) 'BAIDU_PENDING_READBACK_MISSING'
    $downloadedItem=Get-Item -LiteralPath $downloaded -Force -ErrorAction Stop
    Assert-R20R5 (($downloadedItem.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0) 'BAIDU_PENDING_READBACK_REPARSE_POINT'
    Assert-R20R5 ($downloadedItem.Length -gt 0 -and $downloadedItem.Length -le 1048576) 'BAIDU_PENDING_READBACK_SIZE_INVALID'

    $localHash=(Get-FileHash -LiteralPath $pendingPortable -Algorithm SHA256).Hash.ToLowerInvariant()
    $remoteHash=(Get-FileHash -LiteralPath $downloaded -Algorithm SHA256).Hash.ToLowerInvariant()
    Assert-R20R5 ($localHash -ceq $remoteHash) 'BAIDU_PENDING_CIPHERTEXT_OWNERSHIP_UNPROVEN'
    Write-Output 'R20R5_REMOTE_PENDING_CIPHERTEXT_MATCH=PASS'

    [void](Invoke-Baidu -Action 'rm' -Arguments @($pendingRemote))
    $remoteDeleted=$true

    $lsAfter=Invoke-Baidu -Action 'ls' -Arguments @('-l',$remoteDir)
    $listingAfter=[string]$lsAfter['StdOut']
    $pmAfter=[regex]::Matches($listingAfter,'(?m)^(?:[^\r\n]*[ \t])?'+[regex]::Escape($pendingName)+'(?<dir>/)?[ \t]*(?=\r?\n|\z)')
    $fmAfter=[regex]::Matches($listingAfter,'(?m)^(?:[^\r\n]*[ \t])?'+[regex]::Escape($finalName)+'(?<dir>/)?[ \t]*(?=\r?\n|\z)')
    Assert-R20R5 ($pmAfter.Count -eq 0 -and $fmAfter.Count -eq 0) 'BAIDU_PENDING_REMOVE_READBACK_FAILED'
    Write-Output 'R20R5_REMOTE_PENDING_REMOVE=PASS'

    Assert-LocalRecoveryFile -Path $pendingLocal
    Assert-LocalRecoveryFile -Path $pendingPortable
    Assert-R20R5 (-not (Test-Path -LiteralPath $finalLocal)) 'R20R5_LOCAL_FINAL_COLLISION_AFTER_REMOTE_REMOVE'

    Remove-Item -LiteralPath $pendingPortable -Force -ErrorAction Stop
    Remove-Item -LiteralPath $pendingLocal -Force -ErrorAction Stop
    $localDeleted=$true

    Assert-R20R5 (-not (Test-Path -LiteralPath $pendingPortable)) 'R20R5_LOCAL_PORTABLE_PENDING_REMOVE_FAILED'
    Assert-R20R5 (-not (Test-Path -LiteralPath $pendingLocal)) 'R20R5_LOCAL_DPAPI_PENDING_REMOVE_FAILED'
    Assert-R20R5 (-not (Test-Path -LiteralPath $finalLocal)) 'R20R5_LOCAL_FINAL_CREATED_UNEXPECTEDLY'
    Write-Output 'R20R5_LOCAL_PENDING_REMOVE=PASS'

    Assert-R20R5 (Test-Path -LiteralPath $journalPath -PathType Leaf) 'R20R5_ROLLBACK_JOURNAL_LOST'
    Assert-OwnerAcl -Path $journalPath

    Write-Output 'R20R5_EXACT_PENDING_SET_CLEAN=PASS'
}
finally{
    $who=$null
    $ls=$null

    if(Test-Path -LiteralPath $diagRoot -PathType Container){
        try{
            Assert-OwnerAcl -Path $diagRoot
            Remove-Item -LiteralPath $diagRoot -Recurse -Force -ErrorAction Stop
            $cleanupPass=(-not(Test-Path -LiteralPath $diagRoot))
        }
        catch{$cleanupPass=$false}
    }
    else{$cleanupPass=$true}

    Write-Output ('R20R5_TEMP_RUNTIME_CLEANUP='+$(if($cleanupPass){'PASS'}else{'FAIL'}))
    Write-Output ('R20R5_REMOTE_PENDING_MUTATION_STARTED='+$(if($remoteDeleted){'YES'}else{'NO'}))
    Write-Output ('R20R5_LOCAL_PENDING_MUTATION_STARTED='+$(if($localDeleted){'YES'}else{'NO'}))
    Write-Output 'R20R5_RECOVERY_DECRYPT=NO'
    Write-Output 'R20R5_RECOVERY_FINAL_MUTATION=NO'
    Write-Output 'R20R5_SSH_OR_VPS_ACTION=NO'
    Write-Output 'R20R5_CLASH_MUTATION=NO'
    Write-Output 'R20R5_NETWORK_MUTATION=NO'
    Write-Output 'R20R5_ROLLBACK_JOURNAL_RETAINED=YES'
    Write-Output 'STOP_AT_REVIEWER=YES'
}
