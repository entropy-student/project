param([Parameter(Mandatory=$true)][string]$OutputPath)
$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'm2_media_guard.psm1') -Force
$base=[ordered]@{
  profile='landscape_24';fixture_id='landscape_24';source_width=1280;source_height=720;source_fps_numerator=24;source_fps_denominator=1
  source_duration_ms=8000;source_frame_count=192;codec_name='h264';stream_count=1;audio_stream_count=0
  source_r_frame_rate='24/1';source_avg_frame_rate='24/1';source_sha256=('a'*64);poster_sha256=('b'*64)
  source_frame0_pixel_md5=('c'*32);poster_pixel_md5=('c'*32);rights_basis='self_generated_local_test_only';fit_policy='contain'
}
$cases=[System.Collections.Generic.List[object]]::new()
function Expect-Rejection([string]$Name,[scriptblock]$Action){
  $rejected=$false; $reason=''
  try{& $Action}catch{$rejected=$true;$reason=$_.Exception.Message}
  if(!$rejected){throw "M2_NEGATIVE_GUARD_FAILED: $Name was accepted"}
  $cases.Add([pscustomobject]@{case=$Name;rejected=$true;reason=$reason})
}
function Copy-BaseMetadata {
  $copy=[ordered]@{}
  foreach($key in $base.Keys){$copy[$key]=$base[$key]}
  return $copy
}
$missing=[ordered]@{}; foreach($key in $base.Keys){if($key -ne 'source_fps_numerator'){$missing[$key]=$base[$key]}}
Expect-Rejection 'missing_required_parameter' {Assert-M2AssetContract -Metadata ([pscustomobject]$missing)}
$badFps=Copy-BaseMetadata; $badFps.source_fps_numerator=0
Expect-Rejection 'fps_zero' {Assert-M2AssetContract -Metadata ([pscustomobject]$badFps)}
$unknownRights=Copy-BaseMetadata; $unknownRights.rights_basis='unknown'
Expect-Rejection 'rights_unknown' {Assert-M2AssetContract -Metadata ([pscustomobject]$unknownRights)}
$withAudio=Copy-BaseMetadata; $withAudio.audio_stream_count=1; $withAudio.stream_count=2
Expect-Rejection 'audio_stream_present' {Assert-M2AssetContract -Metadata ([pscustomobject]$withAudio)}
Expect-Rejection 'stage_collision' {Assert-M2FreshPaths -Paths @($PSScriptRoot)}
Expect-Rejection 'poster_mismatch' {Assert-M2PosterMatchesSource -SourceDigest ('c'*32) -PosterDigest ('d'*32)}
Assert-M2StageSlug -Profile 'landscape_24' -StageSlug 'cws-g1va-m2-landscape-24-x7k2p9'
if(Test-Path -LiteralPath $OutputPath){throw "M2_NEGATIVE_REPORT_EXISTS: $OutputPath"}
$parent=Split-Path -Parent $OutputPath
if(!(Test-Path -LiteralPath $parent)){New-Item -ItemType Directory -Path $parent | Out-Null}
$report=[ordered]@{schema='CWS_G1VA_M2_NEGATIVE_GUARDS_V1';result='PASS';negative_cases=$cases;positive_slug_validation='PASS'}
$report | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $OutputPath -Encoding utf8NoBOM
"M2_NEGATIVE_GUARDS=PASS"; "NEGATIVE_CASES=$($cases.Count)"; "REPORT=$OutputPath"
