[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$SshIdentityFile,
    [string]$KnownHostsFile = (Join-Path $env:USERPROFILE '.ssh\known_hosts')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Assert-R22R1 {
    param([bool]$Condition,[string]$Code)
    if(-not $Condition){ throw $Code }
}

Assert-R22R1 ($PSVersionTable.PSVersion -eq [version]'7.6.6') 'POWERSHELL_7_6_6_REQUIRED'
Assert-R22R1 (Test-Path -LiteralPath $SshIdentityFile -PathType Leaf) 'SSH_IDENTITY_FILE_INVALID'
Assert-R22R1 (Test-Path -LiteralPath $KnownHostsFile -PathType Leaf) 'SSH_KNOWN_HOSTS_MISSING'

$runtimeRoot=Join-Path $env:LOCALAPPDATA 'vpn-network-optimization\runtime'
Assert-R22R1 (Test-Path -LiteralPath $runtimeRoot -PathType Container) 'LOCAL_RUNTIME_ROOT_MISSING'

# R22 was executed around 2026-10-06 06:08Z. The bounded window excludes retained historical journals.
$windowStart=[DateTimeOffset]::Parse('2026-10-06T05:55:00Z')
$windowEnd=[DateTimeOffset]::Parse('2026-10-06T06:20:00Z')
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

    foreach($required in @(
        'profile_store','remote_drift_baseline',
        'recovery_pending_local','recovery_pending_cloud_local',
        'recovery_pending_external','recovery_final_local','recovery_final_external'
    )){
        Assert-R22R1 ($record.ContainsKey($required)) 'R22R1_JOURNAL_SHAPE_INVALID'
    }

    $baseline=$record['remote_drift_baseline']
    Assert-R22R1 ($baseline -is [System.Collections.IDictionary]) 'R22R1_REMOTE_BASELINE_SHAPE_INVALID'
    Assert-R22R1 (
        $baseline.Contains('routes_json') -and
        $baseline.Contains('firewall_json') -and
        $baseline.Contains('active_services')
    ) 'R22R1_REMOTE_BASELINE_SHAPE_INVALID'

    $candidates.Add([pscustomobject]@{
        Item=$item
        Record=$record
        RunId=$m.Groups['id'].Value
    })
}

Assert-R22R1 ($candidates.Count -eq 1) 'R22R1_R22_JOURNAL_NOT_UNIQUE'

$selected=$candidates[0]
$journal=$selected.Record
$runId=[string]$selected.RunId
Assert-R22R1 ($runId -match '^[0-9a-f]{32}$') 'R22R1_RUN_ID_INVALID'

$localRuntime=Join-Path $runtimeRoot ('g4b-'+$runId)
$baiduRuntime=Join-Path $runtimeRoot ('g4b-baidu-'+$runId)

$pendingLocal=[string]$journal['recovery_pending_local']
$pendingCloudLocal=[string]$journal['recovery_pending_cloud_local']
$finalLocal=[string]$journal['recovery_final_local']
$profileStore=[string]$journal['profile_store']

Assert-R22R1 (-not [string]::IsNullOrWhiteSpace($pendingLocal)) 'R22R1_PENDING_LOCAL_PATH_INVALID'
Assert-R22R1 (-not [string]::IsNullOrWhiteSpace($pendingCloudLocal)) 'R22R1_PENDING_CLOUD_LOCAL_PATH_INVALID'
Assert-R22R1 (-not [string]::IsNullOrWhiteSpace($finalLocal)) 'R22R1_FINAL_LOCAL_PATH_INVALID'
Assert-R22R1 (Test-Path -LiteralPath $profileStore -PathType Container) 'R22R1_PROFILE_STORE_MISSING'

$localRuntimePresent=Test-Path -LiteralPath $localRuntime
$baiduRuntimePresent=Test-Path -LiteralPath $baiduRuntime
$pendingLocalPresent=Test-Path -LiteralPath $pendingLocal -PathType Leaf
$pendingCloudLocalPresent=Test-Path -LiteralPath $pendingCloudLocal -PathType Leaf
$finalLocalPresent=Test-Path -LiteralPath $finalLocal -PathType Leaf

$profileMatches=@(
    Get-ChildItem -LiteralPath $profileStore -File -Force -Recurse -ErrorAction Stop |
        Where-Object { $_.Name -match '(?i)^SELF-VPN-V1(?:\.[^\\/]*)?$' }
)
$profileCurrentMatchCount=$profileMatches.Count

$baselineJson=ConvertTo-Json -InputObject $journal['remote_drift_baseline'] -Depth 12 -Compress
$baselineB64=[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($baselineJson))

$python=@'
import base64, hashlib, json, pathlib, subprocess, re, os, shutil

RUN_ID="__RUN_ID__"
BASELINE=json.loads(base64.b64decode("__BASELINE_B64__").decode("utf-8"))

SERVICE="mihomo-reality-vpn-network-optimization.service"
WG="wg-quick@wg0"
HY="hysteria2-vpn-network-optimization.service"
USER="reality-vpn-network-optimization"
GROUP="reality-vpn-network-optimization"

BIN=pathlib.Path("/usr/local/lib/vpn-network-optimization/mihomo-reality")
RUNTIME=pathlib.Path("/srv/apps/vpn-network-optimization/reality")
SECRETS=pathlib.Path("/srv/apps/vpn-network-optimization/secrets/reality-server.yaml")
UNIT=pathlib.Path("/etc/systemd/system/mihomo-reality-vpn-network-optimization.service")
TXN=pathlib.Path("/var/lib")/("vpn-network-optimization-g4b-"+RUN_ID)
TMP=pathlib.Path("/tmp")/("vpn-network-optimization-g4b-"+RUN_ID)

def run(args, timeout=15):
    return subprocess.run(args,stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True,check=False,timeout=timeout)

def checked_text(args, code, timeout=15):
    r=run(args,timeout)
    if r.returncode!=0:
        raise RuntimeError(code)
    return r.stdout

def canonical_json(value):
    return json.dumps(value,separators=(",",":"),sort_keys=True)

def normalize_nft(value,parent=""):
    if isinstance(value,dict):
        result={}
        for key,item in value.items():
            if parent=="counter" and key in ("packets","bytes"):
                continue
            result[key]=normalize_nft(item,key)
        return result
    if isinstance(value,list):
        return [normalize_nft(item,parent) for item in value]
    return value

def capture_remote_drift():
    routes={}
    queries=(
        ("ipv4_routes",["ip","-j","route","show","table","all"],"REMOTE_IPV4_ROUTE_BASELINE_FAILED"),
        ("ipv6_routes",["ip","-j","-6","route","show","table","all"],"REMOTE_IPV6_ROUTE_BASELINE_FAILED"),
        ("ipv4_rules",["ip","-j","rule","show"],"REMOTE_IPV4_RULE_BASELINE_FAILED"),
        ("ipv6_rules",["ip","-j","-6","rule","show"],"REMOTE_IPV6_RULE_BASELINE_FAILED")
    )
    for name,args,code in queries:
        try:
            records=json.loads(checked_text(args,code))
        except Exception:
            raise RuntimeError(code)
        if not isinstance(records,list) or any(not isinstance(item,dict) for item in records):
            raise RuntimeError("REMOTE_ROUTE_BASELINE_SHAPE_INVALID")
        normalized=[]
        for item in records:
            record=dict(item)
            record.pop("expires",None)
            normalized.append(record)
        routes[name]=sorted(normalized,key=canonical_json)

    firewall={}
    if shutil.which("ufw"):
        text=checked_text(["ufw","status"],"REMOTE_UFW_BASELINE_FAILED")
        firewall["ufw"]=canonical_json([line.strip() for line in text.splitlines() if line.strip()])

    if shutil.which("nft"):
        try:
            nft=json.loads(checked_text(["nft","--json","list","ruleset"],"REMOTE_NFT_BASELINE_FAILED"))
        except Exception:
            raise RuntimeError("REMOTE_NFT_BASELINE_INVALID")
        firewall["nft"]=canonical_json(normalize_nft(nft))

    for name,command,code in (
        ("iptables4","iptables-save","REMOTE_IPTABLES4_BASELINE_FAILED"),
        ("iptables6","ip6tables-save","REMOTE_IPTABLES6_BASELINE_FAILED")
    ):
        if shutil.which(command):
            text=checked_text([command],code)
            lines=[]
            for line in text.splitlines():
                if not line or line.startswith("#"):
                    continue
                lines.append(re.sub(r"^\[\d+:\d+\](?=\s)","",line.strip()))
            firewall[name]=canonical_json(lines)

    if not firewall:
        raise RuntimeError("REMOTE_FIREWALL_BASELINE_UNAVAILABLE")

    service_text=checked_text([
        "systemctl","list-units","--type=service","--state=active",
        "--no-legend","--no-pager","--plain","--full"
    ],"REMOTE_SERVICE_BASELINE_FAILED")
    services=[]
    for line in service_text.splitlines():
        fields=line.split(None,4)
        if len(fields)<4 or not fields[0].endswith(".service"):
            raise RuntimeError("REMOTE_SERVICE_BASELINE_SHAPE_INVALID")
        services.append(fields[0])

    return {
        "routes_json":canonical_json(routes),
        "firewall_json":canonical_json(firewall),
        "active_services":sorted(set(services))
    }

def present(path):
    try:
        path.lstat()
        return True
    except FileNotFoundError:
        return False

def first_line_matches(path, expected):
    if not path.is_file() or path.is_symlink():
        return False
    try:
        with path.open("r",encoding="utf-8",errors="strict") as f:
            return f.readline().rstrip("\r\n")==expected
    except Exception:
        return False

def unit_state():
    r=run(["systemctl","show",SERVICE,"--no-pager","--property=LoadState,ActiveState,SubState,UnitFileState"])
    out={"LoadState":"unknown","ActiveState":"unknown","SubState":"unknown","UnitFileState":"unknown"}
    if r.returncode not in (0,1):
        return out
    for line in r.stdout.splitlines():
        if "=" in line:
            key,value=line.split("=",1)
            if key in out:
                out[key]=value
    return out

def getent(kind,name):
    return run(["getent",kind,name]).returncode==0

state_present=False
state_decode_ok=False
state_run_id_match=False
created={}
binary_hash_match="NA"
txn_entries=[]

state_path=TXN/"state.json"
if present(TXN) and TXN.is_dir() and not TXN.is_symlink():
    try:
        txn_entries=sorted([p.name for p in TXN.iterdir()])
    except Exception:
        txn_entries=["<UNREADABLE>"]

if state_path.is_file() and not state_path.is_symlink():
    state_present=True
    try:
        state=json.loads(state_path.read_text(encoding="utf-8"))
        state_decode_ok=isinstance(state,dict)
        if state_decode_ok:
            state_run_id_match=(state.get("run_id")==RUN_ID)
            for key in (
                "created_binary","created_user","created_group","created_runtime",
                "created_secrets_dir","created_secret_config","created_unit",
                "service_started","pass_candidate"
            ):
                created[key]=bool(state.get(key,False))
            if present(BIN) and state.get("binary_sha256"):
                binary_hash_match="YES" if hashlib.sha256(BIN.read_bytes()).hexdigest()==state.get("binary_sha256") else "NO"
    except Exception:
        state_decode_ok=False

ss=run(["ss","-H","-ltnup"])
if ss.returncode!=0:
    raise SystemExit(20)
rows=ss.stdout.splitlines()

def count_port(port,proto):
    count=0
    for row in rows:
        low=row.lower()
        if proto=="tcp" and not low.startswith("tcp"):
            continue
        if proto=="udp" and not low.startswith("udp"):
            continue
        if re.search(r":"+str(port)+r"\b",row):
            count+=1
    return count

tcp443=[row for row in rows if row.lower().startswith("tcp") and re.search(r":443\b",row)]
tcp443_owned=bool(tcp443) and all("mihomo" in row.lower() for row in tcp443)

mihomo=0
for p in pathlib.Path("/proc").iterdir():
    if not p.name.isdigit():
        continue
    comm=p/"comm"
    try:
        if comm.is_file() and "mihomo" in comm.read_text(errors="ignore").lower():
            mihomo+=1
    except Exception:
        pass

drift=capture_remote_drift()
route_match=(drift["routes_json"]==BASELINE.get("routes_json"))
firewall_match=(drift["firewall_json"]==BASELINE.get("firewall_json"))
before_services=set(BASELINE.get("active_services",[]))
after_services=set(drift["active_services"])

if after_services==before_services:
    service_class="EXACT"
elif SERVICE not in before_services and after_services==before_services|{SERVICE}:
    service_class="REALITY_ONLY_EXTRA"
else:
    service_class="DRIFT"

result={
    "service":unit_state(),
    "wg_active":run(["systemctl","is-active",WG]).stdout.strip() or "unknown",
    "hy_active":run(["systemctl","is-active",HY]).stdout.strip() or "unknown",
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
    "txn_state_decode_ok":state_decode_ok,
    "txn_run_id_match":state_run_id_match,
    "txn_created_flags":created,
    "txn_entries":txn_entries[:16],
    "runtime_user_present":getent("passwd",USER),
    "runtime_group_present":getent("group",GROUP),
    "runtime_marker_match":first_line_matches(RUNTIME/".g4b-owner",RUN_ID) if present(RUNTIME) else None,
    "secret_marker_match":first_line_matches(SECRETS,"# G4B_RUN_ID="+RUN_ID) if present(SECRETS) else None,
    "unit_marker_match":first_line_matches(UNIT,"# G4B_RUN_ID="+RUN_ID) if present(UNIT) else None,
    "binary_hash_match":binary_hash_match,
    "route_baseline_match":route_match,
    "firewall_baseline_match":firewall_match,
    "service_baseline_class":service_class
}
print(json.dumps(result,separators=(",",":")))
'@

$python=$python.Replace('__RUN_ID__',$runId).Replace('__BASELINE_B64__',$baselineB64)

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
    Assert-R22R1 ($p.Start()) 'R22R1_SSH_PROCESS_START_FAILED'
    $outTask=$p.StandardOutput.ReadToEndAsync()
    $errTask=$p.StandardError.ReadToEndAsync()
    $p.StandardInput.Write($python)
    $p.StandardInput.Close()

    if(-not $p.WaitForExit(60000)){
        try{$p.Kill($true)}catch{}
        throw 'R22R1_SSH_TIMEOUT'
    }

    $stdout=$outTask.GetAwaiter().GetResult()
    [void]$errTask.GetAwaiter().GetResult()

    Assert-R22R1 ($p.ExitCode -eq 0) 'R22R1_SSH_READONLY_FAILED'
    $remote=ConvertFrom-Json -InputObject $stdout -AsHashtable -ErrorAction Stop
}
finally{
    if($null -ne $p){$p.Dispose()}
    $python=$null
    $baselineJson=$null
    $baselineB64=$null
}

$service=$remote['service']
$targetPresent=(
    [bool]$remote['binary_present'] -or
    [bool]$remote['runtime_present'] -or
    [bool]$remote['secret_config_present'] -or
    [bool]$remote['unit_present']
)

$identityPresent=(
    [bool]$remote['runtime_user_present'] -or
    [bool]$remote['runtime_group_present']
)

$txnPresent=[bool]$remote['txn_present']
$tmpPresent=[bool]$remote['tmp_present']
$tcp443=[int]$remote['tcp443']
$mihomo=[int]$remote['mihomo_processes']

$wgHealthy=(
    [string]$remote['wg_active'] -ceq 'active' -and
    [int]$remote['udp51820'] -gt 0
)

$hyHealthy=(
    [string]$remote['hy_active'] -ceq 'active' -and
    [int]$remote['udp8443'] -gt 0
)

$serviceAbsent=(
    ([string]$service['LoadState'] -in @('not-found','masked')) -and
    ([string]$service['ActiveState'] -ne 'active')
)

$runMatch='NA'
if([bool]$remote['txn_state_present']){
    $runMatch=$(if([bool]$remote['txn_run_id_match']){'YES'}else{'NO'})
}

$txnEntriesSafe=$true
if($txnPresent){
    $allowedTxnEntries=@('state.json','mihomo-reality-vpn-network-optimization.service')
    foreach($entry in @($remote['txn_entries'])){
        if([string]$entry -notin $allowedTxnEntries){ $txnEntriesSafe=$false }
    }
}

$ownershipAmbiguous=$false
if($txnPresent -and (-not [bool]$remote['txn_state_present'] -or -not [bool]$remote['txn_state_decode_ok'] -or -not [bool]$remote['txn_run_id_match'] -or -not $txnEntriesSafe)){ $ownershipAmbiguous=$true }
if([bool]$remote['runtime_present'] -and $remote['runtime_marker_match'] -ne $true){ $ownershipAmbiguous=$true }
if([bool]$remote['secret_config_present'] -and $remote['secret_marker_match'] -ne $true){ $ownershipAmbiguous=$true }
if([bool]$remote['unit_present'] -and $remote['unit_marker_match'] -ne $true){ $ownershipAmbiguous=$true }
if([bool]$remote['binary_present'] -and [string]$remote['binary_hash_match'] -eq 'NO'){ $ownershipAmbiguous=$true }

$routeMatch=[bool]$remote['route_baseline_match']
$firewallMatch=[bool]$remote['firewall_baseline_match']
$serviceClass=[string]$remote['service_baseline_class']

$remoteResidue=(
    $targetPresent -or
    $identityPresent -or
    $txnPresent -or
    $tmpPresent -or
    -not $serviceAbsent -or
    $tcp443 -gt 0 -or
    $mihomo -gt 0
)

$localResidue=(
    $localRuntimePresent -or
    $baiduRuntimePresent
)

$localUnsafeUnexpected=(
    $finalLocalPresent -or
    $profileCurrentMatchCount -ne 0
)

$recoveryPendingAmbiguous=(
    -not $pendingLocalPresent -or
    -not $pendingCloudLocalPresent
)

$clean=(
    -not $remoteResidue -and
    -not $localResidue -and
    -not $localUnsafeUnexpected -and
    -not $recoveryPendingAmbiguous -and
    $wgHealthy -and
    $hyHealthy -and
    $routeMatch -and
    $firewallMatch -and
    $serviceClass -ceq 'EXACT'
)

$safeResidual=(
    ($remoteResidue -or $localResidue) -and
    -not $ownershipAmbiguous -and
    -not $localUnsafeUnexpected -and
    -not $recoveryPendingAmbiguous -and
    $wgHealthy -and
    $hyHealthy -and
    $routeMatch -and
    $firewallMatch -and
    $serviceClass -in @('EXACT','REALITY_ONLY_EXTRA')
)

$state=if($clean){
    'CLEAN'
}
elseif($safeResidual){
    'PROJECT_RESIDUAL_PRESENT'
}
else{
    'AMBIGUOUS_BASELINE'
}

Write-Output 'R22R1_LOCAL_JOURNAL_IDENTITY=PASS'
Write-Output 'R22R1_REMOTE_READONLY_QUERY=PASS'
Write-Output ('R22R1_REALITY_SERVICE_LOAD='+[string]$service['LoadState'])
Write-Output ('R22R1_REALITY_SERVICE_ACTIVE='+[string]$service['ActiveState'])
Write-Output ('R22R1_REALITY_SERVICE_SUB='+[string]$service['SubState'])
Write-Output ('R22R1_REALITY_SERVICE_ENABLE='+[string]$service['UnitFileState'])
Write-Output ('R22R1_TCP443_COUNT='+$tcp443)
Write-Output ('R22R1_TCP443_OWNED_BY_MIHOMO='+$(if($tcp443 -eq 0){'NA'}elseif([bool]$remote['tcp443_owned_by_mihomo']){'YES'}else{'NO'}))
Write-Output ('R22R1_MIHOMO_PROCESS_COUNT='+$mihomo)
Write-Output ('R22R1_WG_HEALTHY='+$(if($wgHealthy){'YES'}else{'NO'}))
Write-Output ('R22R1_HY2_HEALTHY='+$(if($hyHealthy){'YES'}else{'NO'}))
Write-Output ('R22R1_BINARY_PRESENT='+$(if([bool]$remote['binary_present']){'YES'}else{'NO'}))
Write-Output ('R22R1_RUNTIME_PRESENT='+$(if([bool]$remote['runtime_present']){'YES'}else{'NO'}))
Write-Output ('R22R1_SECRET_CONFIG_PRESENT='+$(if([bool]$remote['secret_config_present']){'YES'}else{'NO'}))
Write-Output ('R22R1_UNIT_PRESENT='+$(if([bool]$remote['unit_present']){'YES'}else{'NO'}))
Write-Output ('R22R1_TRANSACTION_PRESENT='+$(if($txnPresent){'YES'}else{'NO'}))
Write-Output ('R22R1_TEMP_PRESENT='+$(if($tmpPresent){'YES'}else{'NO'}))
Write-Output ('R22R1_TRANSACTION_STATE_PRESENT='+$(if([bool]$remote['txn_state_present']){'YES'}else{'NO'}))
Write-Output ('R22R1_TRANSACTION_RUN_ID_MATCH='+$runMatch)
Write-Output ('R22R1_TRANSACTION_ENTRIES_SAFE='+$(if($txnEntriesSafe){'YES'}else{'NO'}))
Write-Output ('R22R1_RUNTIME_USER_PRESENT='+$(if([bool]$remote['runtime_user_present']){'YES'}else{'NO'}))
Write-Output ('R22R1_RUNTIME_GROUP_PRESENT='+$(if([bool]$remote['runtime_group_present']){'YES'}else{'NO'}))
Write-Output ('R22R1_ROUTE_BASELINE_MATCH='+$(if($routeMatch){'YES'}else{'NO'}))
Write-Output ('R22R1_FIREWALL_BASELINE_MATCH='+$(if($firewallMatch){'YES'}else{'NO'}))
Write-Output ('R22R1_SERVICE_BASELINE_CLASS='+$serviceClass)
Write-Output ('R22R1_LOCAL_RUNTIME_PRESENT='+$(if($localRuntimePresent){'YES'}else{'NO'}))
Write-Output ('R22R1_BAIDU_RUNTIME_PRESENT='+$(if($baiduRuntimePresent){'YES'}else{'NO'}))
Write-Output ('R22R1_RECOVERY_PENDING_LOCAL_PRESENT='+$(if($pendingLocalPresent){'YES'}else{'NO'}))
Write-Output ('R22R1_RECOVERY_PENDING_CLOUD_LOCAL_PRESENT='+$(if($pendingCloudLocalPresent){'YES'}else{'NO'}))
Write-Output ('R22R1_RECOVERY_FINAL_LOCAL_PRESENT='+$(if($finalLocalPresent){'YES'}else{'NO'}))
Write-Output ('R22R1_PROFILE_CREATED_COUNT='+$profileCurrentMatchCount)
Write-Output ('R22R1_RECONCILIATION_STATE='+$state)
Write-Output 'R22R1_REMOTE_MUTATION=NO'
Write-Output 'R22R1_SECRET_CONTENT_READ=NO'
Write-Output 'R22R1_LOCAL_MUTATION=NO'
Write-Output 'STOP_AT_REVIEWER=YES'
