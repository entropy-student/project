[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$SshIdentityFile,
    [string]$KnownHostsFile=(Join-Path $env:USERPROFILE '.ssh\known_hosts')
)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
function Assert-R20R3 { param([bool]$Condition,[string]$Code) if(-not $Condition){throw $Code} }

Assert-R20R3 ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
Assert-R20R3 (Test-Path -LiteralPath $SshIdentityFile -PathType Leaf) 'SSH_IDENTITY_FILE_INVALID'
Assert-R20R3 (Test-Path -LiteralPath $KnownHostsFile -PathType Leaf) 'SSH_KNOWN_HOSTS_MISSING'

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
    $candidates.Add([pscustomobject]@{RunId=$m.Groups['id'].Value;Journal=$item.FullName})
}
Assert-R20R3 ($candidates.Count -eq 1) 'R20R3_R20_JOURNAL_NOT_UNIQUE'
$runId=[string]$candidates[0].RunId
$journalPath=[string]$candidates[0].Journal

$python=@'
import json, pathlib, os, stat, subprocess, re
RUN_ID="__RUN_ID__"
SERVICE="mihomo-reality-vpn-network-optimization.service"
WG="wg-quick@wg0"
HY="hysteria2-vpn-network-optimization.service"
BIN=pathlib.Path("/usr/local/lib/vpn-network-optimization/mihomo-reality")
RUNTIME=pathlib.Path("/srv/apps/vpn-network-optimization/reality")
SECRETS=pathlib.Path("/srv/apps/vpn-network-optimization/secrets/reality-server.yaml")
UNIT=pathlib.Path("/etc/systemd/system/mihomo-reality-vpn-network-optimization.service")
TXN=pathlib.Path("/var/lib")/("vpn-network-optimization-g4b-"+RUN_ID)
TMP=pathlib.Path("/tmp")/("vpn-network-optimization-g4b-"+RUN_ID)
STATE=TXN/"state.json"
STAGED=TXN/"mihomo-reality-vpn-network-optimization.service"

def run(args):
    return subprocess.run(args,stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True,check=False,timeout=15)
def absent(p):
    try:p.lstat();return False
    except FileNotFoundError:return True
def active(name):
    r=run(["systemctl","is-active",name])
    return r.stdout.strip()
def count_ports():
    r=run(["ss","-H","-ltnup"])
    if r.returncode!=0: raise SystemExit(31)
    rows=r.stdout.splitlines()
    def c(port,proto):
        return sum(1 for x in rows if x.lower().startswith(proto) and re.search(r":"+str(port)+r"\b",x))
    return c(443,"tcp"),c(51820,"udp"),c(8443,"udp")
def process_count():
    n=0
    for p in pathlib.Path("/proc").iterdir():
        if not p.name.isdigit():continue
        comm=p/"comm"
        try:
            if comm.is_file() and "mihomo" in comm.read_text(errors="ignore").lower():n+=1
        except Exception:pass
    return n
def ge(kind,name):
    return run(["getent",kind,name]).returncode==0

# Exact ownership/shape preflight
x=TXN.lstat()
if not stat.S_ISDIR(x.st_mode) or stat.S_ISLNK(x.st_mode) or x.st_uid!=0 or x.st_gid!=0 or stat.S_IMODE(x.st_mode)!=0o700:
    raise SystemExit(40)
children=sorted(p.name for p in TXN.iterdir())
if children!=["mihomo-reality-vpn-network-optimization.service","state.json"]:
    raise SystemExit(41)
for p,mode in ((STATE,None),(STAGED,0o600)):
    s=p.lstat()
    if not stat.S_ISREG(s.st_mode) or stat.S_ISLNK(s.st_mode) or s.st_uid!=0 or s.st_gid!=0:
        raise SystemExit(42)
    if mode is not None and stat.S_IMODE(s.st_mode)!=mode:
        raise SystemExit(43)
state=json.loads(STATE.read_text(encoding="utf-8"))
if state.get("run_id")!=RUN_ID or state.get("pass_candidate") is not False:
    raise SystemExit(44)
for k in ("created_binary","created_user","created_group","created_runtime","created_secrets_dir","created_secret_config","created_unit","service_started"):
    if state.get(k) is not True:
        raise SystemExit(45)
line=STAGED.open("r",encoding="utf-8",errors="strict").readline().rstrip("\r\n")
if line!="# G4B_RUN_ID="+RUN_ID:
    raise SystemExit(46)

tcp443,udp51820,udp8443=count_ports()
preclean=(
    absent(BIN) and absent(RUNTIME) and absent(SECRETS) and absent(UNIT) and absent(TMP)
    and not ge("passwd","reality-vpn-network-optimization")
    and not ge("group","reality-vpn-network-optimization")
    and active(WG)=="active" and active(HY)=="active"
    and udp51820>0 and udp8443>0 and tcp443==0 and process_count()==0
)
if not preclean:
    raise SystemExit(47)

# Exact cleanup: only the two proven transaction files, then empty TXN.
STAGED.unlink()
STATE.unlink()
TXN.rmdir()

tcp4432,udp518202,udp84432=count_ports()
postclean=(
    absent(TXN) and absent(BIN) and absent(RUNTIME) and absent(SECRETS) and absent(UNIT) and absent(TMP)
    and not ge("passwd","reality-vpn-network-optimization")
    and not ge("group","reality-vpn-network-optimization")
    and active(WG)=="active" and active(HY)=="active"
    and udp518202>0 and udp84432>0 and tcp4432==0 and process_count()==0
)
if not postclean:
    raise SystemExit(48)
print(json.dumps({"ok":True},separators=(",",":")))
'@.Replace('__RUN_ID__',$runId)

$psi=[Diagnostics.ProcessStartInfo]::new()
$psi.FileName=(Get-Command ssh.exe -ErrorAction Stop).Source
$psi.UseShellExecute=$false;$psi.CreateNoWindow=$true
$psi.RedirectStandardInput=$true;$psi.RedirectStandardOutput=$true;$psi.RedirectStandardError=$true
foreach($arg in @('-T','-i',$SshIdentityFile,'-o','BatchMode=yes','-o','IdentitiesOnly=yes','-o','StrictHostKeyChecking=yes','-o','HostKeyAlias=24.199.118.137','-o',('UserKnownHostsFile='+$KnownHostsFile),'-o','ConnectTimeout=10','root@10.66.21.1','python3 -')){[void]$psi.ArgumentList.Add($arg)}
$p=[Diagnostics.Process]::new()
try{
    $p.StartInfo=$psi
    Assert-R20R3 ($p.Start()) 'SSH_PROCESS_START_FAILED'
    $ot=$p.StandardOutput.ReadToEndAsync();$et=$p.StandardError.ReadToEndAsync()
    $p.StandardInput.Write($python);$p.StandardInput.Close()
    if(-not $p.WaitForExit(60000)){try{$p.Kill($true)}catch{};throw 'R20R3_SSH_TIMEOUT'}
    $out=$ot.GetAwaiter().GetResult();[void]$et.GetAwaiter().GetResult()
    Assert-R20R3 ($p.ExitCode -eq 0) 'R20R3_REMOTE_TRANSACTION_CLEANUP_FAILED'
    $result=ConvertFrom-Json -InputObject $out -AsHashtable -ErrorAction Stop
    Assert-R20R3 ($result['ok'] -eq $true) 'R20R3_REMOTE_READBACK_FAILED'
}finally{if($null -ne $p){$p.Dispose()};$python=$null}

Assert-R20R3 (Test-Path -LiteralPath $journalPath -PathType Leaf) 'R20R3_LOCAL_JOURNAL_LOST'
Write-Output 'R20R3_PREFLIGHT_OWNERSHIP=PASS'
Write-Output 'R20R3_STAGED_UNIT_RUN_ID_MARKER=PASS'
Write-Output 'R20R3_PRE_CLEAN_CONSEQUENTIAL_SURFACE=CLEAN'
Write-Output 'R20R3_REMOTE_TRANSACTION_CLEANUP=PASS'
Write-Output 'R20R3_POST_CLEAN_REMOTE_BASELINE=PASS'
Write-Output 'R20R3_WG_HEALTHY=YES'
Write-Output 'R20R3_HY2_HEALTHY=YES'
Write-Output 'R20R3_LOCAL_ROLLBACK_JOURNAL_RETAINED=YES'
Write-Output 'R20R3_RECOVERY_ARTIFACTS_TOUCHED=NO'
Write-Output 'R20R3_BAIDU_ACTION=NO'
Write-Output 'R20R3_CLASH_MUTATION=NO'
Write-Output 'R20R3_LOCAL_NETWORK_MUTATION=NO'
Write-Output 'STOP_AT_REVIEWER=YES'
