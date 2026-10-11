param(
  [Parameter(Mandatory=$true)][ValidateSet('landscape_24','portrait_30','m1_regression')][string]$Profile,
  [Parameter(Mandatory=$true)][string]$Work,
  [Parameter(Mandatory=$true)][string]$PrototypeHtml,
  [Parameter(Mandatory=$true)][string]$StageSlug,
  [Parameter(Mandatory=$true)][string]$RuntimeRoot,
  [Parameter(Mandatory=$true)][string]$BrowserExecutable,
  [Parameter(Mandatory=$true)][string]$ApprovedBrowserCacheRoot,
  [string]$LegacySource,
  [string]$LegacyPoster,
  [string]$LegacyManifest
)
$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'm2_media_guard.psm1') -Force
$Work=(Resolve-Path -LiteralPath $Work).Path
$PrototypeHtml=(Resolve-Path -LiteralPath $PrototypeHtml).Path
$Composer=Join-Path $RuntimeRoot 'remotion-composer'
$Entry=Join-Path $PSScriptRoot 'entry.tsx'
$Component=Join-Path $PSScriptRoot 'ResearchAquaMediaAdapter.tsx'
$Assets=Join-Path $Work 'assets'
$Out=Join-Path $Work 'out'

switch($Profile){
  'landscape_24' {$fixtureId='landscape_24';$width=1280;$height=720;$fpsN=24;$fpsD=1;$durationMs=8000;$sourceFrames=192;$displayName='LANDSCAPE_24.mp4';$rights='self_generated_local_test_only'}
  'portrait_30' {$fixtureId='portrait_30';$width=1080;$height=1920;$fpsN=30;$fpsD=1;$durationMs=9000;$sourceFrames=270;$displayName='PORTRAIT_30.mp4';$rights='self_generated_local_test_only'}
  'm1_regression' {$fixtureId='m1_regression';$width=1920;$height=1080;$fpsN=30;$fpsD=1;$durationMs=6000;$sourceFrames=180;$displayName='LOCAL-DEMO.mp4';$rights='self_generated_local_test_only'}
}
Assert-M2StageSlug -Profile $Profile -StageSlug $StageSlug
$ProjectStage=Join-Path $Composer "projects\$StageSlug"
$MediaStage=Join-Path $Composer "public\$StageSlug"
Assert-M2FreshPaths -Paths @($Out,$ProjectStage,$MediaStage,(Join-Path $Work 'source_ffprobe.json'),(Join-Path $Work 'source_frame_pts.csv'),(Join-Path $Work 'poster_pixel_check.json'))
if(!(Test-Path -LiteralPath $Composer -PathType Container) -or !(Test-Path -LiteralPath $Entry -PathType Leaf) -or !(Test-Path -LiteralPath $Component -PathType Leaf)){throw 'M2_ISOLATED_RENDER_RUNTIME_OR_SOURCE_MISSING'}
$CliBin=Join-Path $Composer 'node_modules\.bin\remotion.cmd'
$RemotionPackage=Join-Path $Composer 'node_modules\remotion\package.json'
$CliPackage=Join-Path $Composer 'node_modules\@remotion\cli\package.json'
if(!(Test-Path -LiteralPath $CliBin -PathType Leaf) -or !(Test-Path -LiteralPath $RemotionPackage -PathType Leaf) -or !(Test-Path -LiteralPath $CliPackage -PathType Leaf)){throw 'M2_REMOTION_RUNTIME_MISSING'}
$remotionVersion=(Get-Content -LiteralPath $RemotionPackage -Raw | ConvertFrom-Json).version
$cliVersion=(Get-Content -LiteralPath $CliPackage -Raw | ConvertFrom-Json).version
if($remotionVersion -ne '4.0.484' -or $cliVersion -ne '4.0.484'){throw 'M2_REMOTION_VERSION_MISMATCH'}
if(!(Test-Path -LiteralPath $BrowserExecutable -PathType Leaf) -or !(Test-Path -LiteralPath $ApprovedBrowserCacheRoot -PathType Container)){throw 'M2_APPROVED_BROWSER_MISSING'}
$BrowserExecutable=(Resolve-Path -LiteralPath $BrowserExecutable).Path
$cache=(Resolve-Path -LiteralPath $ApprovedBrowserCacheRoot).Path.TrimEnd('\')+'\'
$shells=@(Get-ChildItem -LiteralPath $ApprovedBrowserCacheRoot -Recurse -File -Filter 'chrome-headless-shell.exe')
if($shells.Count -ne 1 -or !$BrowserExecutable.StartsWith($cache,[StringComparison]::OrdinalIgnoreCase) -or [IO.Path]::GetFileName($BrowserExecutable) -ne 'chrome-headless-shell.exe'){throw 'M2_BROWSER_MUST_BE_THE_UNIQUE_APPROVED_CACHED_SHELL'}
$BrowserSha=(Get-FileHash -LiteralPath $BrowserExecutable -Algorithm SHA256).Hash.ToLowerInvariant()
$BrowserVersion=(& $BrowserExecutable --version 2>&1 | Out-String).Trim()
if($LASTEXITCODE -ne 0 -or $BrowserVersion -notmatch '149\.0\.7790\.0' -or $BrowserSha -ne 'ec76dc3e69ffab9daddf0bbe7bf0a9e0a034b2d086741a0ae2ef6358a597537b'){throw 'M2_BROWSER_VERSION_OR_SHA_MISMATCH'}
if(!(Test-Path -LiteralPath $Assets -PathType Container)){throw 'M2_INPUT_ASSET_DIRECTORY_MISSING'}

if($Profile -eq 'm1_regression'){
  foreach($p in @($LegacySource,$LegacyPoster,$LegacyManifest)){if([string]::IsNullOrWhiteSpace($p) -or !(Test-Path -LiteralPath $p -PathType Leaf)){throw 'M2_M1_REGRESSION_INPUT_MISSING'}}
  $Source=(Resolve-Path -LiteralPath $LegacySource).Path; $Poster=(Resolve-Path -LiteralPath $LegacyPoster).Path
  $legacy=Get-Content -LiteralPath $LegacyManifest -Raw | ConvertFrom-Json
  $sourceSha=(Get-FileHash -LiteralPath $Source -Algorithm SHA256).Hash.ToLowerInvariant()
  $posterSha=(Get-FileHash -LiteralPath $Poster -Algorithm SHA256).Hash.ToLowerInvariant()
  if($sourceSha -ne 'bc6f92d9ad4e422e6bbcf432dc65bcf340c6fd30998e1211b773cc5a510403b3' -or $posterSha -ne '1889c527f22723313cfd90fac2079db75dc97f84abe7614a735b16e54a746aa7' -or $legacy.source_sha256 -ne $sourceSha -or $legacy.rights_basis -ne 'self_generated_local_test_only'){throw 'M2_M1_REGRESSION_BASELINE_MISMATCH'}
  $receipt=$legacy
}else{
  foreach($p in @($LegacySource,$LegacyPoster,$LegacyManifest)){if($p){throw 'M2_EXTERNAL_INPUTS_NOT_ALLOWED_FOR_NEW_FIXTURES'}}
  $Source=Join-Path $Assets 'source.mp4'; $Poster=Join-Path $Assets 'poster.png'
  $ReceiptPath=Join-Path $Assets 'fixture_generation.json'
  if(!(Test-Path -LiteralPath $ReceiptPath -PathType Leaf)){throw 'M2_FIXTURE_GENERATION_RECEIPT_MISSING'}
  $receipt=Get-Content -LiteralPath $ReceiptPath -Raw | ConvertFrom-Json
  if($receipt.schema -ne 'CWS_G1VA_M2_FIXTURE_RECEIPT_V1' -or $receipt.fixture_id -ne $FixtureId -or $receipt.rights_basis -ne 'self_generated_local_test_only'){throw 'M2_FIXTURE_PROVENANCE_NOT_ALLOWED'}
  if((Get-FileHash -LiteralPath $Source -Algorithm SHA256).Hash.ToLowerInvariant() -ne $receipt.source_sha256 -or (Get-FileHash -LiteralPath $Poster -Algorithm SHA256).Hash.ToLowerInvariant() -ne $receipt.poster_sha256){throw 'M2_FIXTURE_HASH_DOES_NOT_MATCH_GENERATOR_RECEIPT'}
}
if(!(Test-Path -LiteralPath $Source -PathType Leaf) -or !(Test-Path -LiteralPath $Poster -PathType Leaf)){throw 'M2_MEDIA_OR_POSTER_MISSING'}
function Get-FirstRgbMd5([string]$Path){
  $lines=& ffmpeg -hide_banner -loglevel error -i $Path -map 0:v:0 -frames:v 1 -pix_fmt rgb24 -f framemd5 - 2>&1
  if($LASTEXITCODE -ne 0){throw "M2_PIXEL_DECODE_FAILED: $Path"}
  $data=@($lines | Where-Object {$_ -and $_.ToString().Trim() -and !$_.ToString().StartsWith('#')})
  if($data.Count -ne 1){throw "M2_PIXEL_DIGEST_FRAME_COUNT_NOT_ONE: $Path"}
  return (($data[0].ToString().Split(',')[-1]).Trim().ToLowerInvariant())
}
$sourceFrame0Md5=Get-FirstRgbMd5 $Source
$posterMd5=Get-FirstRgbMd5 $Poster
$probeLines=& ffprobe -v error -count_frames -show_streams -show_format -of json $Source
if($LASTEXITCODE -ne 0){throw 'M2_INPUT_FFPROBE_FAILED'}
$probeText=$probeLines -join [Environment]::NewLine
$probe=$probeText | ConvertFrom-Json
$video=@($probe.streams | Where-Object codec_type -eq 'video')
$audio=@($probe.streams | Where-Object codec_type -eq 'audio')
$videoStreams=@($probe.streams | Where-Object codec_type -eq 'video')
$fpsText="$fpsN/$fpsD"
$sourceDurationMs=[int][math]::Round([double]$probe.format.duration*1000)
$readFrames=[int]$video[0].nb_read_frames
$sourceSha=(Get-FileHash -LiteralPath $Source -Algorithm SHA256).Hash.ToLowerInvariant()
$posterSha=(Get-FileHash -LiteralPath $Poster -Algorithm SHA256).Hash.ToLowerInvariant()
$metadata=[pscustomobject]@{
  profile=$Profile;fixture_id=$fixtureId;source_width=[int]$video[0].width;source_height=[int]$video[0].height
  source_fps_numerator=$fpsN;source_fps_denominator=$fpsD;source_duration_ms=$sourceDurationMs;source_frame_count=$readFrames
  codec_name=[string]$video[0].codec_name;stream_count=[int]$probe.streams.Count;audio_stream_count=[int]$audio.Count
  source_r_frame_rate=[string]$video[0].r_frame_rate;source_avg_frame_rate=[string]$video[0].avg_frame_rate
  source_sha256=$sourceSha;poster_sha256=$posterSha;source_frame0_pixel_md5=$sourceFrame0Md5;poster_pixel_md5=$posterMd5
  rights_basis=$rights;fit_policy='contain'
}
if($video.Count -ne 1 -or $videoStreams.Count -ne 1){throw 'M2_EXPECTS_EXACTLY_ONE_VIDEO_STREAM'}
Assert-M2AssetContract -Metadata $metadata
$frameTimeLines=& ffprobe -v error -select_streams v:0 -show_frames -show_entries frame=best_effort_timestamp_time -of csv=p=0 $Source
if($LASTEXITCODE -ne 0){throw 'M2_CFR_FRAME_TIMESTAMPS_UNREADABLE'}
$frameTimes=@($frameTimeLines | ForEach-Object {($_ -split ',')[0]} | Where-Object {$_ -match '^\d+(\.\d+)?$'} | ForEach-Object {[double]::Parse($_,[Globalization.CultureInfo]::InvariantCulture)})
if($frameTimes.Count -ne $readFrames){throw 'M2_CFR_TIMESTAMP_COUNT_MISMATCH'}
$frameDuration=$fpsD/$fpsN
$maxPtsDeviation=0.0
for($i=0;$i -lt $frameTimes.Count;$i++){
  $deviation=[math]::Abs($frameTimes[$i]-($i*$frameDuration))
  if($deviation -gt $maxPtsDeviation){$maxPtsDeviation=$deviation}
  if($deviation -gt 0.00002){throw "M2_VARIABLE_FRAME_PACING: frame=$i pts=$($frameTimes[$i])"}
}
$frameTimeLines | Set-Content -LiteralPath (Join-Path $Work 'source_frame_pts.csv') -Encoding utf8NoBOM
$ffprobeLines=& ffprobe -v error -count_frames -show_streams -show_format -of json $Source
$ffprobeLines | Set-Content -LiteralPath (Join-Path $Work 'source_ffprobe.json') -Encoding utf8NoBOM
$sourcePixelLog=[ordered]@{source_frame0_rgb24_md5=$sourceFrame0Md5;poster_rgb24_md5=$posterMd5;pixel_by_pixel_match=($sourceFrame0Md5 -ceq $posterMd5);pixel_format='rgb24 decoded pixel digest';source_file=$Source;poster_file=$Poster}
$sourcePixelLog | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $Work 'poster_pixel_check.json') -Encoding utf8NoBOM

$projectRoot=(git -C (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))) rev-parse --show-toplevel 2>$null).Trim()
if(!$projectRoot){throw 'M2_GIT_SOURCE_ROOT_UNREADABLE'}
$prototypeBlob=(git -C $projectRoot rev-parse 'HEAD:curious-world-studio/p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html').Trim()
$prototypeWorkHash=(git -C $projectRoot hash-object $PrototypeHtml).Trim()
if($prototypeBlob -ne 'acb0ee80264527bd11160e0ae277ce24528c4a03' -or $prototypeWorkHash -ne $prototypeBlob){throw 'M2_SELECTED_V2_REFERENCE_BLOB_MISMATCH'}

$playStartFrame=[int][math]::Ceiling((4760/1000)*30)
$playStartVideoMs=[int][math]::Round($playStartFrame*1000/30)
$scale=[math]::Min((1920.0/$width),(947.0/$height))
$drawWidth=[math]::Round($width*$scale,3);$drawHeight=[math]::Round($height*$scale,3)
$drawX=[math]::Round((1920-$drawWidth)/2,3);$drawY=[math]::Round((947-$drawHeight)/2,3)
$inputManifest=[ordered]@{
  schema='CWS_G1VA_M2_INPUT_MANIFEST_V2';fixture_id=$fixtureId;profile=$Profile;source_file=$Source;source_sha256=$sourceSha
  rights_basis=$rights;source_kind=if($Profile -eq 'm1_regression'){'previously_accepted_self_generated_m1_fixture'}else{'self_generated_ffmpeg_lavfi_overlay_motion'}
  evidence_label='示意画面';source_width=$width;source_height=$height;source_fps_numerator=$fpsN;source_fps_denominator=$fpsD
  source_fps=$fpsText;source_avg_fps=[string]$video[0].avg_frame_rate;source_frame_count=$readFrames;source_duration_ms=$sourceDurationMs
  source_codec=[string]$video[0].codec_name;audio_stream_count=[int]$audio.Count;stream_count=[int]$probe.streams.Count
  poster_file=$Poster;poster_sha256=$posterSha;poster_source='first_decoded_frame_of_same_source_file';poster_pixel_match=$sourcePixelLog.pixel_by_pixel_match
  source_frame0_rgb24_md5=$sourceFrame0Md5;poster_rgb24_md5=$posterMd5;output_fps='30/1';render_fps=30;render_play_frame=$playStartFrame
  asset_local_timestamp_ms=0;fit_policy='contain';fit_content_box=@{x=0;y=63;width=1920;height=947}
  fit_media_rect=@{x=$drawX;y=$drawY;width=$drawWidth;height=$drawHeight};display_filename=$displayName
  visual_reference='curious-world-studio/p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html'
  visual_reference_blob_sha=$prototypeBlob;remotion_version=$remotionVersion;remotion_cli_version=$cliVersion
  approved_browser_version=$BrowserVersion;approved_browser_sha256_pre=$BrowserSha;source_ffprobe_file='source_ffprobe.json'
}
$playSeconds=$playStartFrame/30.0
$samples=@()
foreach($offset in @(0,1,3)){
  $outputFrame=$playStartFrame+($offset*30)
  $outerMs=[int][math]::Round($outputFrame*1000/30)
  $sourceIndex=[int][math]::Round($offset*$fpsN/$fpsD)
  $samples+=@{offset_seconds=$offset;output_frame=$outputFrame;outer_time_ms=$outerMs;asset_local_timestamp_ms=($offset*1000);expected_source_frame=$sourceIndex;expected_progress=([math]::Round(($offset*1000)/$durationMs,6))}
}
$timeline=[ordered]@{
  schema='CWS_G1VA_M2_EPISODE_TIMELINE_V2';outer_duration_ms=9000;output_fps='30/1';frame_count=270
  play_click_event_ms=4670;play_start_frame=$playStartFrame;play_start_video_ms=$playStartVideoMs;asset_source_duration_ms=$sourceDurationMs
  source_fps=$fpsText;asset_local_clock='(output_frame - play_start_frame) / output_fps';samples=$samples
  events=@(
    @{id='desktop-hold';start_ms=0;end_ms=440;frame_range='0-13'}
    @{id='cursor-to-file';start_ms=440;end_ms=1300;frame_range='14-38'}
    @{id='file-select';start_ms=1470;end_ms=1480;frame_range='44'}
    @{id='double-click-open';start_ms=1480;end_ms=1750;frame_range='44-52'}
    @{id='window-open';start_ms=1920;end_ms=2600;frame_range='58-77'}
    @{id='green-button-click';start_ms=3150;end_ms=3230;frame_range='95-96'}
    @{id='fullscreen-transition';start_ms=3230;end_ms=3750;frame_range='97-112'}
    @{id='cursor-to-play';start_ms=3780;end_ms=4510;frame_range='114-135'}
    @{id='play-click';start_ms=4670;end_ms=4780;frame_range='140-143'}
    @{id='asset-playing';start_ms=$playStartVideoMs;end_ms=9000;frame_range='143-269'}
  )
}

New-Item -ItemType Directory -Path $Out | Out-Null
$Qa=Join-Path $Out 'qa';$Keyframes=Join-Path $Out 'keyframes'
New-Item -ItemType Directory -Path $Qa,$Keyframes,$ProjectStage,$MediaStage | Out-Null
Copy-Item -LiteralPath $Entry -Destination (Join-Path $ProjectStage 'entry.tsx')
Copy-Item -LiteralPath $Component -Destination (Join-Path $ProjectStage 'ResearchAquaMediaAdapter.tsx')
Copy-Item -LiteralPath $Source -Destination (Join-Path $MediaStage $displayName)
Copy-Item -LiteralPath $Poster -Destination (Join-Path $MediaStage 'source-frame-000.png')
Copy-Item -LiteralPath $PrototypeHtml -Destination (Join-Path $MediaStage 'g1va_v2_research_aqua_prototype.html')
$props=[ordered]@{
  assetPath="$StageSlug/$displayName";posterPath="$StageSlug/source-frame-000.png";prototypePath="$StageSlug/g1va_v2_research_aqua_prototype.html"
  assetDurationMs=$sourceDurationMs;assetFrameCount=$readFrames;assetWidth=$width;assetHeight=$height
  assetFpsNumerator=$fpsN;assetFpsDenominator=$fpsD;playStartFrame=$playStartFrame;assetFileName=$displayName;assetRightsBasis=$rights
}
$manifestPath=Join-Path $Out 'input_manifest.json';$timelinePath=Join-Path $Out 'episode_timeline.json';$propsPath=Join-Path $Out 'render_props.json'
$inputManifest | ConvertTo-Json -Depth 7 | Set-Content -LiteralPath $manifestPath -Encoding utf8NoBOM
$timeline | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $timelinePath -Encoding utf8NoBOM
$props | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $propsPath -Encoding utf8NoBOM
$preflight=[ordered]@{
  branch=(git -C $projectRoot branch --show-current).Trim();source_head=(git -C $projectRoot rev-parse HEAD).Trim();source_status=(git -C $projectRoot status --short --branch)
  runtime_root=$RuntimeRoot;runtime_composer=$Composer;remotion_version=$remotionVersion;remotion_cli_version=$cliVersion
  browser_executable=$BrowserExecutable;browser_version=$BrowserVersion;browser_sha256_pre=$BrowserSha;browser_cache_reused=$true;browser_download_requested=$false
  node_version=(& node --version 2>&1 | Out-String).Trim();ffmpeg_version=(& ffmpeg -version 2>&1 | Select-Object -First 1).ToString().Trim()
  ffmpeg_sha256=(Get-FileHash -LiteralPath (Get-Command ffmpeg).Source -Algorithm SHA256).Hash.ToLowerInvariant()
  software_installed=$false;cloud_service_called=$false;external_research_media_used=$false;stage_slug=$StageSlug;project_stage=$ProjectStage;media_stage=$MediaStage
}
$preflight | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $Out 'browser_runtime_preflight.json') -Encoding utf8NoBOM
$RenderOriginal=Join-Path $Qa 'remotion-render-original.mp4';$Final=Join-Path $Out "cws-g1va-m2-$Profile.mp4"
$RenderLog=Join-Path $Qa 'render.log'
$RenderCommand="$CliBin render projects/$StageSlug/entry.tsx CWSG1VAM1 $RenderOriginal --props=$propsPath --codec=h264 --browser-executable=$BrowserExecutable"
Push-Location $Composer
try{
  $renderOutput=& $CliBin render "projects/$StageSlug/entry.tsx" CWSG1VAM1 $RenderOriginal "--props=$propsPath" '--codec=h264' "--browser-executable=$BrowserExecutable" 2>&1
  $renderExit=$LASTEXITCODE
}finally{Pop-Location}
$renderOutput | Set-Content -LiteralPath $RenderLog -Encoding utf8NoBOM
if($renderExit -ne 0){throw "M2_RENDER_FAILED exit=$renderExit; no browser fallback or install attempted"}
$remuxLog=Join-Path $Qa 'remux.log'
$remuxOutput=& ffmpeg -hide_banner -n -i $RenderOriginal -map 0:v:0 -c:v copy -an -movflags +faststart $Final 2>&1
$remuxExit=$LASTEXITCODE
$remuxOutput | Set-Content -LiteralPath $remuxLog -Encoding utf8NoBOM
if($remuxExit -ne 0){throw "M2_VIDEO_ONLY_REMUX_FAILED exit=$remuxExit"}
$finalProbeLines=& ffprobe -v error -count_frames -show_streams -show_format -of json $Final
$finalProbeExit=$LASTEXITCODE
if($finalProbeExit -ne 0){throw 'M2_FINAL_FFPROBE_FAILED'}
$finalProbeText=$finalProbeLines -join [Environment]::NewLine
$finalProbeText | Set-Content -LiteralPath (Join-Path $Out 'ffprobe.json') -Encoding utf8NoBOM
$finalProbe=$finalProbeText | ConvertFrom-Json
$finalVideo=@($finalProbe.streams | Where-Object codec_type -eq 'video')
$finalAudio=@($finalProbe.streams | Where-Object codec_type -eq 'audio')
if($finalVideo.Count -ne 1 -or $finalAudio.Count -ne 0 -or $finalProbe.streams.Count -ne 1 -or $finalVideo[0].codec_name -ne 'h264' -or [int]$finalVideo[0].width -ne 1920 -or [int]$finalVideo[0].height -ne 1080 -or $finalVideo[0].avg_frame_rate -ne '30/1' -or [int]$finalVideo[0].nb_read_frames -ne 270 -or [math]::Abs(([double]$finalProbe.format.duration)-9.0) -gt 0.001){throw 'M2_OUTPUT_MEDIA_SPEC_MISMATCH'}
$decodeLog=Join-Path $Qa 'full_decode.log'
$decodeOutput=& ffmpeg -hide_banner -v error -i $Final -f null - 2>&1
$decodeExit=$LASTEXITCODE
$decodeOutput | Set-Content -LiteralPath $decodeLog -Encoding utf8NoBOM
$blackLog=Join-Path $Qa 'blackdetect.log'
$blackOutput=& ffmpeg -hide_banner -i $Final -vf 'blackdetect=d=0.03:pix_th=0.10' -an -f null - 2>&1
$blackExit=$LASTEXITCODE
$blackOutput | Set-Content -LiteralPath $blackLog -Encoding utf8NoBOM
if($decodeExit -ne 0 -or $blackExit -ne 0){throw 'M2_DECODE_OR_BLACKDETECT_FAILED'}
$keyframeTimes=@(
  @{name='01-desktop-initial';time=0.300},@{name='02-cursor-moving';time=0.933},@{name='03-file-selected';time=1.500},@{name='04-double-click-feedback';time=1.733},
  @{name='05-player-window-opening';time=2.200},@{name='06-green-button-fullscreen-transition';time=3.500},@{name='07-fullscreen-paused-first-frame';time=4.400},
  @{name='08-paused-before-play';time=4.733333},@{name='09-first-play-frame-zero';time=4.766667},@{name='10-playing-one-second';time=5.766667},@{name='11-playing-three-seconds';time=7.766667},@{name='12-playing-later';time=8.800}
)
foreach($shot in $keyframeTimes){
  $png=Join-Path $Keyframes ($shot.name+'.png');$timeText=[string]::Format([Globalization.CultureInfo]::InvariantCulture,'{0:0.000000}',$shot.time)
  $shotOutput=& ffmpeg -hide_banner -loglevel error -n -i $Final -ss $timeText -frames:v 1 -update 1 $png 2>&1
  if($LASTEXITCODE -ne 0){throw "M2_KEYFRAME_CAPTURE_FAILED: $($shot.name)"}
}
$sampleRecords=@();$comparisonRecords=@()
foreach($offset in @(0,1,3)){
  $sourceIndex=[int][math]::Round($offset*$fpsN/$fpsD)
  $sourceFrame=Join-Path $Qa "expected-source-frame-$offset-sec.png"
  $sourceExtractOutput=& ffmpeg -hide_banner -loglevel error -n -i $Source -vf "select=eq(n\,$sourceIndex)" -fps_mode passthrough -frames:v 1 -update 1 $sourceFrame 2>&1
  if($LASTEXITCODE -ne 0){throw "M2_EXPECTED_SOURCE_FRAME_FAILED index=$sourceIndex"}
  $outputTime=$playSeconds+$offset
  $outputFrame=$playStartFrame+($offset*30)
  $outputTimeText=[string]::Format([Globalization.CultureInfo]::InvariantCulture,'{0:0.000000}',$outputTime)
  $contentPng=Join-Path $Qa "output-content-$offset-sec.png"
  $contentOutput=& ffmpeg -hide_banner -loglevel error -n -i $Final -ss $outputTimeText -vf 'format=rgb24,crop=1920:947:0:63:exact=1' -frames:v 1 -update 1 $contentPng 2>&1
  if($LASTEXITCODE -ne 0){throw "M2_OUTPUT_CONTENT_FRAME_FAILED offset=$offset"}
  $filter='[0:v]format=yuv444p,crop=1920:947:0:63[candidate];[1:v]scale=1920:947:force_original_aspect_ratio=decrease:flags=bicubic,pad=1920:947:(ow-iw)/2:(oh-ih)/2:color=0x08151e,format=yuv444p[reference];[candidate][reference]ssim'
  $candidateComparisons=@();$bestSsim=-1.0;$bestSourceFrame=-1
  for($candidateIndex=[math]::Max(0,$sourceIndex-1);$candidateIndex -le [math]::Min($readFrames-1,$sourceIndex+1);$candidateIndex++){
    if($candidateIndex -eq $sourceIndex){$candidateFrame=$sourceFrame}else{$candidateFrame=Join-Path $Qa "source-frame-$offset-sec-index-$candidateIndex.png"}
    if($candidateIndex -ne $sourceIndex){
      $candidateFilter="select=eq(n\,$candidateIndex)"
      $candidateOutput=& ffmpeg -hide_banner -loglevel error -n -i $Source -vf $candidateFilter -fps_mode passthrough -frames:v 1 -update 1 $candidateFrame 2>&1
      if($LASTEXITCODE -ne 0){throw "M2_NEIGHBOR_SOURCE_FRAME_FAILED index=$candidateIndex"}
    }
    $comparisonLog=Join-Path $Qa "ssim-output-vs-source-$offset-sec-frame-$candidateIndex.log"
    $compareOutput=& ffmpeg -hide_banner -ss $outputTimeText -i $Final -i $candidateFrame -filter_complex $filter -frames:v 1 -f null - 2>&1
    $compareExit=$LASTEXITCODE
    $compareOutput | Set-Content -LiteralPath $comparisonLog -Encoding utf8NoBOM
    if($compareExit -ne 0){throw "M2_SOURCE_FRAME_COMPARISON_FAILED offset=$offset source_frame=$candidateIndex"}
    $ssimMatch=[regex]::Match(($compareOutput -join ' '),'All:([0-9.]+)')
    if(!$ssimMatch.Success){throw "M2_SOURCE_FRAME_SSIM_MISSING offset=$offset source_frame=$candidateIndex"}
    $candidateSsim=[double]::Parse($ssimMatch.Groups[1].Value,[Globalization.CultureInfo]::InvariantCulture)
    $candidateComparisons+=@{source_frame_index=$candidateIndex;offset_from_expected=($candidateIndex-$sourceIndex);ssim=$candidateSsim;ssim_log=$comparisonLog;comparison_exit_code=$compareExit}
    if($candidateSsim -gt $bestSsim){$bestSsim=$candidateSsim;$bestSourceFrame=$candidateIndex}
  }
  if([math]::Abs($bestSourceFrame-$sourceIndex) -gt 1 -or $bestSsim -lt 0.90){throw "M2_SOURCE_TIME_SAMPLE_OUTSIDE_TOLERANCE offset=$offset best_frame=$bestSourceFrame expected=$sourceIndex ssim=$bestSsim"}
  $sampleRecords+=@{offset_seconds=$offset;output_frame=$outputFrame;output_time_seconds=$outputTime;asset_local_timestamp_ms=($offset*1000);expected_source_frame_index=$sourceIndex;best_matching_source_frame_index=$bestSourceFrame;source_frame_offset=($bestSourceFrame-$sourceIndex);source_frame_tolerance=1;source_frame_file=$sourceFrame;player_progress=([math]::Round(($offset*1000)/$durationMs,6));best_matching_ssim=$bestSsim}
  $comparisonRecords+=@{offset_seconds=$offset;expected_source_frame_index=$sourceIndex;output_content_crop=$contentPng;expected_source_reference_frame=$sourceFrame;comparison_filter=$filter;neighbor_comparisons=$candidateComparisons}
}
$freeze1=Join-Path $Qa 'paused-content-4.400.png';$freeze2=Join-Path $Qa 'paused-content-4.733.png'
foreach($item in @(@{time='4.400';path=$freeze1},@{time='4.733333';path=$freeze2})){
  $freezeOutput=& ffmpeg -hide_banner -loglevel error -n -i $Final -ss $item.time -vf 'format=rgb24,crop=1920:947:0:63:exact=1' -frames:v 1 -update 1 $item.path 2>&1
  if($LASTEXITCODE -ne 0){throw "M2_PAUSE_FRAME_EXTRACTION_FAILED: $($item.time)"}
}
$freezeSha1=(Get-FileHash -LiteralPath $freeze1 -Algorithm SHA256).Hash.ToLowerInvariant()
$freezeSha2=(Get-FileHash -LiteralPath $freeze2 -Algorithm SHA256).Hash.ToLowerInvariant()
$freezeLog=Join-Path $Qa 'pause-freeze-ssim.log'
$freezeCompare=& ffmpeg -hide_banner -i $freeze1 -i $freeze2 -filter_complex '[0:v]format=yuv444p[candidate];[1:v]format=yuv444p[reference];[candidate][reference]ssim' -frames:v 1 -f null - 2>&1
$freezeCompareExit=$LASTEXITCODE
$freezeCompare | Set-Content -LiteralPath $freezeLog -Encoding utf8NoBOM
if($freezeCompareExit -ne 0){throw 'M2_PAUSE_FREEZE_COMPARISON_FAILED'}
$freezeSsimMatch=[regex]::Match(($freezeCompare -join ' '),'All:([0-9.]+)')
if(!$freezeSsimMatch.Success){throw 'M2_PAUSE_FREEZE_SSIM_MISSING'}
$freezeSsim=[double]::Parse($freezeSsimMatch.Groups[1].Value,[Globalization.CultureInfo]::InvariantCulture)
if($freezeSsim -lt 0.99){throw "M2_FIRST_FRAME_MOVED_DURING_PAUSE ssim=$freezeSsim threshold=0.99"}
$pausePosterReference=Join-Path $Qa 'poster-frame0-contain-reference.png'
$pausePosterOutput=& ffmpeg -hide_banner -loglevel error -n -i $Poster -vf 'scale=1920:947:force_original_aspect_ratio=decrease:flags=bicubic,pad=1920:947:(ow-iw)/2:(oh-ih)/2:color=0x08151e,format=rgb24' -frames:v 1 -update 1 $pausePosterReference 2>&1
if($LASTEXITCODE -ne 0){throw 'M2_PAUSE_POSTER_REFERENCE_GENERATION_FAILED'}
$pauseSourceComparisons=@()
foreach($item in @(@{time='4.400';path=$freeze1},@{time='4.733333';path=$freeze2})){
  $pauseLog=Join-Path $Qa ("paused-vs-source-frame0-$($item.time).log")
  $pauseCompare=& ffmpeg -hide_banner -i $item.path -i $pausePosterReference -filter_complex '[0:v]format=yuv444p[candidate];[1:v]format=yuv444p[reference];[candidate][reference]ssim' -frames:v 1 -f null - 2>&1
  $pauseCompareExit=$LASTEXITCODE
  $pauseCompare | Set-Content -LiteralPath $pauseLog -Encoding utf8NoBOM
  if($pauseCompareExit -ne 0){throw "M2_PAUSE_VS_SOURCE_FRAME0_COMPARISON_FAILED time=$($item.time)"}
  $pauseSsimMatch=[regex]::Match(($pauseCompare -join ' '),'All:([0-9.]+)')
  if(!$pauseSsimMatch.Success){throw "M2_PAUSE_VS_SOURCE_FRAME0_SSIM_MISSING time=$($item.time)"}
  $pauseSsim=[double]::Parse($pauseSsimMatch.Groups[1].Value,[Globalization.CultureInfo]::InvariantCulture)
  if($pauseSsim -lt 0.98){throw "M2_PAUSED_IMAGE_DIFFERS_FROM_SOURCE_FRAME0 time=$($item.time) ssim=$pauseSsim"}
  $pauseSourceComparisons+=@{pause_time=$item.time;paused_content_crop=$item.path;source_poster=$Poster;contain_reference=$pausePosterReference;comparison_log=$pauseLog;comparison_exit_code=$pauseCompareExit;comparison='SSIM; 1920x947 media content crop; bicubic contain+pad reference';ssim=$pauseSsim;minimum_ssim=0.98}
}
$browserShaPost=(Get-FileHash -LiteralPath $BrowserExecutable -Algorithm SHA256).Hash.ToLowerInvariant()
if($browserShaPost -ne $BrowserSha){throw 'M2_BROWSER_SHA_CHANGED_DURING_RENDER'}
$qa=[ordered]@{
  schema='CWS_G1VA_M2_MACHINE_QA_V2';status='PASS_CANDIDATE_M2';profile=$Profile;output_mp4=$Final
  output_sha256=(Get-FileHash -LiteralPath $Final -Algorithm SHA256).Hash.ToLowerInvariant();output_bytes=(Get-Item -LiteralPath $Final).Length
  output_codec=[string]$finalVideo[0].codec_name;width=[int]$finalVideo[0].width;height=[int]$finalVideo[0].height
  output_fps=[string]$finalVideo[0].avg_frame_rate;output_duration_seconds=[double]$finalProbe.format.duration;decoded_frames=[int]$finalVideo[0].nb_read_frames
  audio_stream_count=$finalAudio.Count;full_decode_exit_code=$decodeExit;full_decode_log=$decodeLog
  blackdetect_exit_code=$blackExit;blackdetect_hits=@(Select-String -LiteralPath $blackLog -Pattern 'black_start' | ForEach-Object Line)
  source_mp4=$Source;source_sha256=$sourceSha;source_probe=$probe;source_probe_exit_code=0
  source_fps=$fpsText;source_frame_count=$readFrames;source_duration_ms=$sourceDurationMs;source_rights_basis=$rights;source_cfr_timestamp_count=$frameTimes.Count;source_max_pts_deviation_ms=($maxPtsDeviation*1000);source_frame_pts_file=(Join-Path $Work 'source_frame_pts.csv')
  poster_png=$Poster;poster_sha256=$posterSha;source_frame0_rgb24_md5=$sourceFrame0Md5;poster_rgb24_md5=$posterMd5;poster_pixel_by_pixel_match=($sourceFrame0Md5 -ceq $posterMd5)
  fit_policy='contain';fit_content_box=@{x=0;y=63;width=1920;height=947};fit_media_rect=@{x=$drawX;y=$drawY;width=$drawWidth;height=$drawHeight}
  play_start_frame=$playStartFrame;play_start_seconds=$playSeconds;pause_content_sha256_4_400=$freezeSha1;pause_content_sha256_4_733=$freezeSha2
  pause_freeze_crop_sha256_identical=($freezeSha1 -ceq $freezeSha2);pause_freeze_ssim=$freezeSsim;pause_freeze_minimum_ssim=0.99;pause_freeze_comparison_log=$freezeLog;pause_source_frame0_comparisons=$pauseSourceComparisons;samples=$sampleRecords;source_frame_comparisons=$comparisonRecords
  keyframe_count=$keyframeTimes.Count;keyframes_directory=$Keyframes;render_exit_code=$renderExit;render_command=$RenderCommand;render_log=$RenderLog
  remux_exit_code=$remuxExit;remux_log=$remuxLog;browser_version=$BrowserVersion;browser_sha256_pre=$BrowserSha;browser_sha256_post=$browserShaPost
  stage_slug=$StageSlug;project_stage=$ProjectStage;media_stage=$MediaStage;manifest=$manifestPath;timeline=$timelinePath;runtime_preflight=(Join-Path $Out 'browser_runtime_preflight.json')
  software_installed=$false;browser_download_requested=$false;cloud_service_called=$false;external_research_media_used=$false
}
$qa | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath (Join-Path $Out 'machine_qa.json') -Encoding utf8NoBOM
"M2_PROFILE=$Profile";"M2_OUTPUT=$Final";"M2_SHA256=$($qa.output_sha256)";"M2_QA=$(Join-Path $Out 'machine_qa.json')";"M2_STATUS=PASS_CANDIDATE_M2"
