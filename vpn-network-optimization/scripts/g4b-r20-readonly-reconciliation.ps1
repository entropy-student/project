[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$SshIdentityFile,
    [string]$KnownHostsFile = (Join-Path $env:USERPROFILE '.ssh\known_hosts')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Assert-R20R1 {
    param([bool]$Condition,[string]$Code)
    if(-not $Condition){ throw $Code }
}

Assert-R20R1 ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
Assert-R20R1 (Test-Path -LiteralPath $SshIdentityFile -PathType Leaf) 'SSH_IDENTITY_FILE_INVALID'
Assert-R20R1 (Test-Path -LiteralPath $KnownHostsFile -PathType Leaf) 'SSH_KNOWN_HOSTS_MISSING'

$runtimeRoot=Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'
Assert-R20R1 (Test-Path -LiteralPath $runtimeRoot -PathType Container) 'LOCAL_RUNTIME_ROOT_MISSING'

$windowStart=[DateTimeOffset]::Parse('2026-10-06T03:22:00Z')
$windowEnd=[DateTimeOffset]::Parse('2026-10-06T03:29:00Z')
$candidates=[Collections.Generic.List[object]]::new()

foreach($item in @(Get-ChildItem -LiteralPath $runtimeRoot -Filter 'g4b-*.rollback.json' -File -Force -ErrorAction Stop)){
    if($item.LastWriteTimeUtc -lt $windowStart.UtcDateTime -or $item.LastWriteTimeUtc -gt $windowEnd.UtcDateTime){ continue }
    $m=[regex]::Match($item.Name,'^g4b-(?<id>[0-9a-f]{32})\.rollback\.json$')
    if(-not $m.Success){ continue }
    $record=ConvertFrom-Json -InputObject ([IO.File]::ReadAllText($item.FullName,[Text.Encoding]::UTF8)) -AsHashtable -ErrorAction Stop
    if($record['format'] -cne 'G4B_OWNER_ROLLBACK_R1'){ continue }
    if($record['run_id'] -cne $m.Groups['id'].Value){ continue }
    if($record['status'] -cne 'IN_PROGRESS'){ continue }
    if(@($record['profile_created_paths']).Count -ne 0){ continue }
    $candidates.Add([pscustomobject]@{Item=$item;Record=$record;RunId=$m.Groups['id'].Value})
}

Assert-R20R1 ($candidates.Count -eq 1) 'R20R1_R20_JOURNAL_NOT_UNIQUE'
$selected=$candidates[0]
$runId=[string]$selected.RunId
Assert-R20R1 ($runId -match '^[0-9a-f]{32}$') 'R20R1_RUN_ID_INVALID'

$python=@'
import json, pathlib, subprocess, re, os

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

def run(args):
    return subprocess.run(args,stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True,check=False,timeout=15)

def is_active(name):
    r=run(["systemctl","is-active",name])
    return r.stdout.strip() if r.stdout.strip() else "unknown"

def unit_state(name):
    r=run(["systemctl","show",name,"--no-pager","--property=LoadState,ActiveState,SubState,UnitFileState"])
    out={"LoadState":"unknown","ActiveState":"unknown","SubState":"unknown","UnitFileState":"unknown"}
    if r.returncode not in (0,1):
        return out
    for line in r.stdout.splitlines():
        if "=" in line:
            k,v=line.split("=",1)
            if k in out: out[k]=v
    return out

def present(p):
    try:
        p.lstat()
        return True
    except FileNotFoundError:
        return False

def getent(kind,name):
    return run(["getent",kind,name]).returncode==0

state_present=False
state_run_id_match=False
created={}
state_path=TXN/"state.json"
if state_path.is_file() and not state_path.is_symlink():
    state_present=True
    try:
        s=json.loads(state_path.read_text(encoding="utf-8"))
        state_run_id_match=(s.get("run_id")==RUN_ID)
        for key in (
            "created_binary","created_user","created_group","created_runtime",
            "created_secrets_dir","created_secret_config","created_unit",
            "service_started","pass_candidate"
        ):
            created[key]=bool(s.get(key,False))
    except Exception:
        created={"state_decode_failed":True}

ss=run(["ss","-H","-ltnup"])
if ss.returncode!=0:
    raise SystemExit(20)
rows=ss.stdout.splitlines()
def count_port(port,proto):
    n=0
    for row in rows:
        low=row.lower()
        if proto=="tcp" and not low.startswith("tcp"): continue
        if proto=="udp" and not low.startswith("udp"): continue
        if re.search(r":"+str(port)+r"\b",row): n+=1
    return n

tcp443=[row for row in rows if row.lower().startswith("tcp") and re.search(r":443\b",row)]
tcp443_owned=bool(tcp443) and all("mihomo" in row.lower() for row in tcp443)

mihomo=0
for p in pathlib.Path("/proc").iterdir():
    if not p.name.isdigit(): continue
    comm=p/"comm"
    try:
        if comm.is_file() and "mihomo" in comm.read_text(errors="ignore").lower(): mihomo+=1
    except Exception:
        pass

result={
  "service":unit_state(SERVICE),
  "wg_active":is_active(WG),
  "hy_active":is_active(HY),
  "udp51820":count_port(51820,"udp"),
  "udp8443":count_port(8443,"udp"),
  "tcp443":len(tcp443),
  "tcp443_owned_by_mihomo":tcp443_owned,
  "mihomo_processes":mihomo,
  "binary_present":present(BIN),
  "runtime_present":present(RUNTIME),
  "secret_config_present":present(SECRETS),
  "unit_present":present(UNIT),
  "txn_present":present(TXN),
  "tmp_present":present(TMP),
  "txn_state_present":state_present,
  "txn_run_id_match":state_run_id_match,
  "txn_created_flags":created,
  "runtime_user_present":getent("passwd","reality-vpn-network-optimization"),
  "runtime_group_present":getent("group","reality-vpn-network-optimization")
}
print(json.dumps(result,separators=(",",":")))
'@
$python=$python.Replace('__RUN_ID__',$runId)

$ssh=(Get-Command ssh.exe -ErrorAction Stop).Source
$psi=[Diagnostics.ProcessStartInfo]::new()
$psi.FileName=$ssh
$psi.UseShellExecute=$false
$psi.CreateNoWindow=$true
$psi.RedirectStandardInput=$true
$psi.RedirectStandardOutput=$true
$psi.RedirectStandardError=$true
foreach($arg in @(
    '-T','-i',$SshIdentityFile,
    '-o','BatchMode=yes',
    '-o','IdentitiesOnly=yes',
    '-o','StrictHostKeyChecking=yes',
    '-o','HostKeyAlias=24.199.118.137',
    '-o',('UserKnownHostsFile='+$KnownHostsFile),
    '-o','ConnectTimeout=10',
    'root@10.66.21.1',
    'python3 -'
)){ [void]$psi.ArgumentList.Add($arg) }

$p=[Diagnostics.Process]::new()
try{
    $p.StartInfo=$psi
    Assert-R20R1 ($p.Start()) 'SSH_PROCESS_START_FAILED'
    $outTask=$p.StandardOutput.ReadToEndAsync()
    $errTask=$p.StandardError.ReadToEndAsync()
    $p.StandardInput.Write($python)
    $p.StandardInput.Close()
    if(-not $p.WaitForExit(60000)){
        try{$p.Kill($true)}catch{}
        throw 'R20R1_SSH_TIMEOUT'
    }
    $stdout=$outTask.GetAwaiter().GetResult()
    [void]$errTask.GetAwaiter().GetResult()
    Assert-R20R1 ($p.ExitCode -eq 0) 'R20R1_SSH_READONLY_FAILED'
    $remote=ConvertFrom-Json -InputObject $stdout -AsHashtable -ErrorAction Stop
}
finally{
    if($null -ne $p){$p.Dispose()}
    $python=$null
}

$service=$remote['service']
$targetPresent=(
    [bool]$remote['binary_present'] -or
    [bool]$remote['runtime_present'] -or
    [bool]$remote['secret_config_present'] -or
    [bool]$remote['unit_present']
)
$identityPresent=([bool]$remote['runtime_user_present'] -or [bool]$remote['runtime_group_present'])
$txnPresent=[bool]$remote['txn_present']
$tmpPresent=[bool]$remote['tmp_present']
$tcp443=[int]$remote['tcp443']
$mihomo=[int]$remote['mihomo_processes']
$wgHealthy=([string]$remote['wg_active'] -ceq 'active' -and [int]$remote['udp51820'] -gt 0)
$hyHealthy=([string]$remote['hy_active'] -ceq 'active' -and [int]$remote['udp8443'] -gt 0)

$serviceAbsent=(
    ([string]$service['LoadState'] -in @('not-found','masked')) -and
    ([string]$service['ActiveState'] -ne 'active')
)

$clean=(
    -not $targetPresent -and
    -not $identityPresent -and
    -not $txnPresent -and
    -not $tmpPresent -and
    $serviceAbsent -and
    $tcp443 -eq 0 -and
    $mihomo -eq 0 -and
    $wgHealthy -and
    $hyHealthy
)

$runMatch='NA'
if([bool]$remote['txn_state_present']){
    $runMatch=$(if([bool]$remote['txn_run_id_match']){'YES'}else{'NO'})
}

Write-Output 'R20R1_LOCAL_JOURNAL_IDENTITY=PASS'
Write-Output 'R20R1_REMOTE_READONLY_QUERY=PASS'
Write-Output ('R20R1_REALITY_SERVICE_LOAD='+[string]$service['LoadState'])
Write-Output ('R20R1_REALITY_SERVICE_ACTIVE='+[string]$service['ActiveState'])
Write-Output ('R20R1_REALITY_SERVICE_SUB='+[string]$service['SubState'])
Write-Output ('R20R1_REALITY_SERVICE_ENABLE='+[string]$service['UnitFileState'])
Write-Output ('R20R1_TCP443_COUNT='+$tcp443)
Write-Output ('R20R1_TCP443_OWNED_BY_MIHOMO='+$(if($tcp443 -eq 0){'NA'}elseif([bool]$remote['tcp443_owned_by_mihomo']){'YES'}else{'NO'}))
Write-Output ('R20R1_MIHOMO_PROCESS_COUNT='+$mihomo)
Write-Output ('R20R1_WG_HEALTHY='+$(if($wgHealthy){'YES'}else{'NO'}))
Write-Output ('R20R1_HY2_HEALTHY='+$(if($hyHealthy){'YES'}else{'NO'}))
Write-Output ('R20R1_BINARY_PRESENT='+$(if([bool]$remote['binary_present']){'YES'}else{'NO'}))
Write-Output ('R20R1_RUNTIME_PRESENT='+$(if([bool]$remote['runtime_present']){'YES'}else{'NO'}))
Write-Output ('R20R1_SECRET_CONFIG_PRESENT='+$(if([bool]$remote['secret_config_present']){'YES'}else{'NO'}))
Write-Output ('R20R1_UNIT_PRESENT='+$(if([bool]$remote['unit_present']){'YES'}else{'NO'}))
Write-Output ('R20R1_TRANSACTION_PRESENT='+$(if($txnPresent){'YES'}else{'NO'}))
Write-Output ('R20R1_TEMP_PRESENT='+$(if($tmpPresent){'YES'}else{'NO'}))
Write-Output ('R20R1_TRANSACTION_STATE_PRESENT='+$(if([bool]$remote['txn_state_present']){'YES'}else{'NO'}))
Write-Output ('R20R1_TRANSACTION_RUN_ID_MATCH='+$runMatch)
Write-Output ('R20R1_RUNTIME_USER_PRESENT='+$(if([bool]$remote['runtime_user_present']){'YES'}else{'NO'}))
Write-Output ('R20R1_RUNTIME_GROUP_PRESENT='+$(if([bool]$remote['runtime_group_present']){'YES'}else{'NO'}))
Write-Output ('R20R1_RECONCILIATION_STATE='+$(if($clean){'CLEAN'}elseif($wgHealthy -and $hyHealthy){'PROJECT_RESIDUAL_PRESENT'}else{'AMBIGUOUS_BASELINE'}))
Write-Output 'R20R1_REMOTE_MUTATION=NO'
Write-Output 'R20R1_SECRET_CONTENT_READ=NO'
Write-Output 'R20R1_LOCAL_MUTATION=NO'
Write-Output 'STOP_AT_REVIEWER=YES'
