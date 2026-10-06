[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$SshIdentityFile,
    [string]$KnownHostsFile=(Join-Path $env:USERPROFILE '.ssh\known_hosts')
)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
function Assert-R20R2 { param([bool]$Condition,[string]$Code) if(-not $Condition){throw $Code} }

Assert-R20R2 ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
Assert-R20R2 (Test-Path -LiteralPath $SshIdentityFile -PathType Leaf) 'SSH_IDENTITY_FILE_INVALID'
Assert-R20R2 (Test-Path -LiteralPath $KnownHostsFile -PathType Leaf) 'SSH_KNOWN_HOSTS_MISSING'

$runtimeRoot=Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'
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
    $candidates.Add([pscustomobject]@{RunId=$m.Groups['id'].Value})
}
Assert-R20R2 ($candidates.Count -eq 1) 'R20R2_R20_JOURNAL_NOT_UNIQUE'
$runId=[string]$candidates[0].RunId

$python=@'
import json, pathlib, os, stat, subprocess
RUN_ID="__RUN_ID__"
TXN=pathlib.Path("/var/lib")/("vpn-network-optimization-g4b-"+RUN_ID)
allowed={
 "/usr/local/lib/vpn-network-optimization":"BIN_PARENT",
 "/srv/apps/vpn-network-optimization":"APP_ROOT",
 "/srv/apps/vpn-network-optimization/reality":"RUNTIME",
 "/srv/apps/vpn-network-optimization/secrets":"SECRETS_PARENT"
}
def meta(p):
    try:
        x=p.lstat()
    except FileNotFoundError:
        return {"present":False}
    kind="dir" if stat.S_ISDIR(x.st_mode) and not stat.S_ISLNK(x.st_mode) else ("file" if stat.S_ISREG(x.st_mode) and not stat.S_ISLNK(x.st_mode) else "other")
    empty=None
    if kind=="dir":
        try: empty=next(p.iterdir(),None) is None
        except Exception: empty=False
    return {"present":True,"kind":kind,"uid":x.st_uid,"gid":x.st_gid,"mode":stat.S_IMODE(x.st_mode),"empty":empty}

state_path=TXN/"state.json"
if not state_path.is_file() or state_path.is_symlink():
    raise SystemExit(21)
s=json.loads(state_path.read_text(encoding="utf-8"))
if s.get("run_id")!=RUN_ID:
    raise SystemExit(22)
flags={}
for k in ("created_binary","created_user","created_group","created_runtime","created_secrets_dir","created_secret_config","created_unit","service_started","pass_candidate"):
    flags[k]=bool(s.get(k,False))

parents=[]
unknown=[]
for raw in s.get("created_parents",[]):
    label=allowed.get(raw)
    if label is None:
        unknown.append("UNKNOWN")
        continue
    parents.append({"label":label,"meta":meta(pathlib.Path(raw))})

children=[]
for p in sorted(TXN.iterdir(),key=lambda x:x.name):
    x=p.lstat()
    kind="file" if stat.S_ISREG(x.st_mode) and not stat.S_ISLNK(x.st_mode) else ("dir" if stat.S_ISDIR(x.st_mode) and not stat.S_ISLNK(x.st_mode) else "other")
    children.append({"name":p.name,"kind":kind,"mode":stat.S_IMODE(x.st_mode),"uid":x.st_uid,"gid":x.st_gid,"size":x.st_size})

print(json.dumps({
 "flags":flags,
 "parents":parents,
 "unknown_parent_count":len(unknown),
 "txn":meta(TXN),
 "children":children
},separators=(",",":")))
'@.Replace('__RUN_ID__',$runId)

$psi=[Diagnostics.ProcessStartInfo]::new()
$psi.FileName=(Get-Command ssh.exe -ErrorAction Stop).Source
$psi.UseShellExecute=$false;$psi.CreateNoWindow=$true
$psi.RedirectStandardInput=$true;$psi.RedirectStandardOutput=$true;$psi.RedirectStandardError=$true
foreach($arg in @('-T','-i',$SshIdentityFile,'-o','BatchMode=yes','-o','IdentitiesOnly=yes','-o','StrictHostKeyChecking=yes','-o','HostKeyAlias=24.199.118.137','-o',('UserKnownHostsFile='+$KnownHostsFile),'-o','ConnectTimeout=10','root@10.66.21.1','python3 -')){[void]$psi.ArgumentList.Add($arg)}
$p=[Diagnostics.Process]::new()
try{
    $p.StartInfo=$psi
    Assert-R20R2 ($p.Start()) 'SSH_PROCESS_START_FAILED'
    $ot=$p.StandardOutput.ReadToEndAsync();$et=$p.StandardError.ReadToEndAsync()
    $p.StandardInput.Write($python);$p.StandardInput.Close()
    if(-not $p.WaitForExit(60000)){try{$p.Kill($true)}catch{};throw 'R20R2_SSH_TIMEOUT'}
    $out=$ot.GetAwaiter().GetResult();[void]$et.GetAwaiter().GetResult()
    Assert-R20R2 ($p.ExitCode -eq 0) 'R20R2_SSH_READONLY_FAILED'
    $x=ConvertFrom-Json -InputObject $out -AsHashtable -ErrorAction Stop
}finally{if($null-ne$p){$p.Dispose()};$python=$null}

Write-Output 'R20R2_LOCAL_JOURNAL_IDENTITY=PASS'
Write-Output 'R20R2_REMOTE_READONLY_QUERY=PASS'
foreach($k in @('created_binary','created_user','created_group','created_runtime','created_secrets_dir','created_secret_config','created_unit','service_started','pass_candidate')){
    Write-Output ('R20R2_STATE_'+$k.ToUpper()+'='+$(if([bool]$x['flags'][$k]){'YES'}else{'NO'}))
}
Write-Output ('R20R2_CREATED_PARENT_UNKNOWN_COUNT='+[int]$x['unknown_parent_count'])
$parents=@($x['parents'])
Write-Output ('R20R2_CREATED_PARENT_COUNT='+$parents.Count)
foreach($pstate in $parents){
    $m=$pstate['meta'];$label=[string]$pstate['label']
    $status=$(if(-not [bool]$m['present']){'ABSENT'}elseif([string]$m['kind'] -ne 'dir'){'PRESENT_NONDIR'}elseif([bool]$m['empty']){'PRESENT_EMPTY'}else{'PRESENT_NONEMPTY'})
    Write-Output ('R20R2_PARENT_'+$label+'='+$status)
}
$children=@($x['children'])
Write-Output ('R20R2_TXN_CHILD_COUNT='+$children.Count)
$allowedNames=@('state.json','mihomo-reality-vpn-network-optimization.service')
$unknownChildren=@($children|Where-Object{[string]$_['name'] -notin $allowedNames})
Write-Output ('R20R2_TXN_UNKNOWN_CHILD_COUNT='+$unknownChildren.Count)
foreach($name in $allowedNames){
    $c=@($children|Where-Object{[string]$_['name'] -ceq $name})
    if($c.Count -eq 0){Write-Output ('R20R2_TXN_'+$name.ToUpper().Replace('.','_').Replace('-','_')+'=ABSENT')}
    elseif($c.Count -eq 1 -and [string]$c[0]['kind'] -ceq 'file'){Write-Output ('R20R2_TXN_'+$name.ToUpper().Replace('.','_').Replace('-','_')+'=FILE_PRESENT')}
    else{Write-Output ('R20R2_TXN_'+$name.ToUpper().Replace('.','_').Replace('-','_')+'=UNEXPECTED')}
}
$txn=$x['txn']
$txnContract=([bool]$txn['present'] -and [string]$txn['kind'] -ceq 'dir' -and [int]$txn['uid'] -eq 0 -and [int]$txn['gid'] -eq 0 -and [int]$txn['mode'] -eq 448)
Write-Output ('R20R2_TXN_METADATA_CONTRACT='+$(if($txnContract){'PASS'}else{'FAIL'}))
Write-Output 'R20R2_REMOTE_MUTATION=NO'
Write-Output 'R20R2_SECRET_CONTENT_READ=NO'
Write-Output 'R20R2_LOCAL_MUTATION=NO'
Write-Output 'STOP_AT_REVIEWER=YES'
