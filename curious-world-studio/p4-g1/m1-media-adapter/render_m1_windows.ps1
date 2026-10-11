param(
  [Parameter(Mandatory=$true)][string]$Work,
  [Parameter(Mandatory=$true)][string]$PrototypeHtml,
  [Parameter(Mandatory=$true)][string]$StageSlug,
  [Parameter(Mandatory=$true)][string]$BrowserExecutable,
  [string]$OMRoot='C:\Users\34707\Tools\OpenMontage'
)
$ErrorActionPreference='Stop'
$Work=(Resolve-Path -LiteralPath $Work).Path
$PrototypeHtml=(Resolve-Path -LiteralPath $PrototypeHtml).Path
$AdapterRoot=(Split-Path -Parent $MyInvocation.MyCommand.Path)
$Assets=Join-Path $Work 'assets'
$Out=Join-Path $Work 'out'
$Fixture=Join-Path $Assets 'local-demo.mp4'
$Poster=Join-Path $Assets 'source-frame-000.png'
$Entry=Join-Path $AdapterRoot 'entry.tsx'
$Component=Join-Path $AdapterRoot 'ResearchAquaMediaAdapter.tsx'
$Composer=Join-Path $OMRoot 'remotion-composer'
$BrowserCacheRoot=Join-Path $Composer 'node_modules\.remotion\chrome-headless-shell'
$CliBin=Join-Path $Composer 'node_modules\.bin\remotion.cmd'
$BrowserExecutable=(Resolve-Path -LiteralPath $BrowserExecutable).Path
if($StageSlug -notmatch '^cws-g1va-v2-media-m1-[a-z0-9-]+$'){throw 'G1VA_M1_BAD_STAGE_SLUG'}
if(Test-Path -LiteralPath $Out){throw "G1VA_M1_OUT_EXISTS: preserve prior evidence: $Out"}
if(!(Test-Path -LiteralPath $Fixture -PathType Leaf) -or !(Test-Path -LiteralPath $Poster -PathType Leaf)){throw 'G1VA_M1_INPUT_MISSING'}
if(!(Test-Path -LiteralPath $Entry -PathType Leaf) -or !(Test-Path -LiteralPath $Component -PathType Leaf)){throw 'G1VA_M1_SOURCE_MISSING'}
$cacheCandidates=@(Get-ChildItem -LiteralPath $BrowserCacheRoot -Recurse -File -Filter 'chrome-headless-shell.exe')
if($cacheCandidates.Count -ne 1){throw 'G1VA_M1_BROWSER_CACHE_MUST_CONTAIN_EXACTLY_ONE_SHELL'}
$cachePrefix=(Resolve-Path -LiteralPath $BrowserCacheRoot).Path.TrimEnd('\')+'\'
if(!$BrowserExecutable.StartsWith($cachePrefix,[StringComparison]::OrdinalIgnoreCase) -or [IO.Path]::GetFileName($BrowserExecutable) -ne 'chrome-headless-shell.exe'){throw 'G1VA_M1_BROWSER_OUT_OF_APPROVED_CACHE'}
$BrowserSha=(Get-FileHash -LiteralPath $BrowserExecutable -Algorithm SHA256).Hash.ToLowerInvariant()
$BrowserVersion=(& $BrowserExecutable --version 2>&1 | Out-String).Trim()
if($LASTEXITCODE -ne 0 -or $BrowserVersion -notmatch '149\.0\.7790\.0' -or $BrowserSha -ne 'ec76dc3e69ffab9daddf0bbe7bf0a9e0a034b2d086741a0ae2ef6358a597537b'){throw 'G1VA_M1_BROWSER_VERSION_OR_SHA_MISMATCH'}
if(!(Test-Path -LiteralPath $CliBin -PathType Leaf) -or !(Test-Path -LiteralPath (Join-Path $Composer 'node_modules\remotion\package.json')) -or !(Test-Path -LiteralPath (Join-Path $Composer 'node_modules\@remotion\cli\package.json'))){throw 'G1VA_M1_REMOTION_RUNTIME_MISSING'}
$ProjectStage=Join-Path $Composer "projects\$StageSlug"
$MediaStage=Join-Path $Composer "public\$StageSlug"
if((Test-Path -LiteralPath $ProjectStage) -or (Test-Path -LiteralPath $MediaStage)){throw 'G1VA_M1_STAGE_EXISTS'}
$probeLines=& ffprobe -v error -count_frames -show_streams -show_format -of json $Fixture
if($LASTEXITCODE -ne 0){throw 'G1VA_M1_INPUT_FFPROBE_FAILED'}
$probeText=$probeLines -join [Environment]::NewLine
$probe=$probeText | ConvertFrom-Json
$video=@($probe.streams | Where-Object codec_type -eq 'video')
$audio=@($probe.streams | Where-Object codec_type -eq 'audio')
if($video.Count -ne 1 -or $audio.Count -ne 0){throw 'G1VA_M1_EXPECTS_ONE_VIDEO_STREAM_AND_NO_AUDIO'}
$v=$video[0]
$fpsParts=$v.r_frame_rate.Split('/')
$fpsNumerator=[int]$fpsParts[0]
$fpsDenominator=[int]$fpsParts[1]
$durationMs=[int][math]::Round([double]$v.duration*1000)
$frameCount=[int]$v.nb_read_frames
$renderFps=30
$playClickMs=4670
$playThresholdMs=4760
$playStartFrame=[int][math]::Ceiling(($playThresholdMs/1000)*$renderFps)
$playStartVideoMs=[int][math]::Round($playStartFrame*1000/$renderFps)
$fixtureSha=(Get-FileHash -LiteralPath $Fixture -Algorithm SHA256).Hash.ToLowerInvariant()
$posterSha=(Get-FileHash -LiteralPath $Poster -Algorithm SHA256).Hash.ToLowerInvariant()
$prototypeBlobSha=(& git hash-object $PrototypeHtml).Trim()
if($prototypeBlobSha -ne 'acb0ee80264527bd11160e0ae277ce24528c4a03'){throw 'G1VA_M1_REFERENCE_HTML_NOT_THE_SELECTED_MAIN_BLOB'}
$remotionVersion=(Get-Content -LiteralPath (Join-Path $Composer 'node_modules\remotion\package.json') -Raw | ConvertFrom-Json).version
$cliVersion=(Get-Content -LiteralPath (Join-Path $Composer 'node_modules\@remotion\cli\package.json') -Raw | ConvertFrom-Json).version
New-Item -ItemType Directory -Path $Out | Out-Null
$Qa=Join-Path $Out 'qa'; $Keyframes=Join-Path $Out 'keyframes'
New-Item -ItemType Directory -Path $Qa,$Keyframes | Out-Null
$manifest=[ordered]@{
  schema='CWS_G1VA_MEDIA_ADAPTER_V1'; asset_id='OWNER_APPROVED_LOCAL_FIXTURE'; source_file='assets/local-demo.mp4'; source_sha256=$fixtureSha
  rights_basis='self_generated_local_test_only'; source_kind='self_generated_synthetic_geometry'; reuse_rights='self_generated_local_test_only'
  evidence_label='示意画面'; source_width=[int]$v.width; source_height=[int]$v.height
  source_fps=$v.r_frame_rate; source_avg_fps=$v.avg_frame_rate; source_frame_count=$frameCount; source_duration_ms=$durationMs
  source_codec=$v.codec_name; source_pixel_format=$v.pix_fmt; audio_stream_count=$audio.Count
  poster_file='assets/source-frame-000.png'; poster_sha256=$posterSha; poster_source='first_decoded_frame_of_same_source_file'
  play_click_event_ms=$playClickMs; play_start_threshold_ms=$playThresholdMs; asset_play_start_video_ms=$playStartVideoMs; play_start_frame=$playStartFrame
  render_fps=$renderFps; audio_policy='muted_visual_gate'; fit_mode='contain'
  visual_reference='curious-world-studio/p4-g1/visual-reference/g1va_v2_research_aqua_prototype.html'
  visual_reference_main_commit='43651dcff9bbccd66cf4406b34bbb36b3411fd2b'; visual_reference_git_blob_sha=$prototypeBlobSha
  remotion_version=$remotionVersion; remotion_cli_version=$cliVersion; approved_browser_version=$BrowserVersion; approved_browser_sha256=$BrowserSha
}
$manifestPath=Join-Path $Out 'input_manifest.json'
$manifest | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $manifestPath -Encoding utf8NoBOM
$timeline=[ordered]@{
  schema='CWS_G1VA_M1_TIMELINE_V1'; outer_video_duration_ms=9000; render_fps=$renderFps; frame_count=270
  visual_reference='ASSISTANT_V2_RESEARCH_AQUA'; play_click_event_video_ms=$playClickMs; asset_play_start_video_ms=$playStartVideoMs; asset_source_duration_ms=$durationMs
  events=@(
    @{id='desktop-hold';start_ms=0;end_ms=440;action='Research Aqua desktop rests';frame_range='0-13'}
    @{id='cursor-to-file';start_ms=440;end_ms=1300;action='visible cursor moves to LOCAL-DEMO.mp4 source icon';frame_range='14-38'}
    @{id='file-select';start_ms=1470;end_ms=1480;action='file becomes selected';frame_range='44'}
    @{id='double-click-open';start_ms=1480;end_ms=1750;action='two visible click pulses on the file';frame_range='44-52'}
    @{id='window-open';start_ms=1920;end_ms=2600;action='QuickTime window expands from file position';frame_range='58-77'}
    @{id='green-button-click';start_ms=3150;end_ms=3230;action='visible cursor clicks green maximize button';frame_range='95-96'}
    @{id='fullscreen-transition';start_ms=3230;end_ms=3750;action='window expands to fullscreen';frame_range='97-112'}
    @{id='cursor-to-play';start_ms=3780;end_ms=4510;action='visible cursor moves to play control';frame_range='114-135'}
    @{id='play-click';start_ms=$playClickMs;end_ms=4780;action='cursor click starts same source MP4 at local frame zero';frame_range='140-143'}
    @{id='asset-playing';start_ms=$playStartVideoMs;end_ms=9000;action='source media and duration-based player progress advance from one frame clock';frame_range='143-269'}
  )
  clock_samples=@(
    @{frame=132;outer_time_ms=4400;asset_local_time_ms=0;progress=0;state='first-frame-paused'}
    @{frame=142;outer_time_ms=4733;asset_local_time_ms=0;progress=0;state='first-frame-paused'}
    @{frame=143;outer_time_ms=4767;asset_local_time_ms=0;progress=0;state='playing-from-source-frame-zero'}
    @{frame=173;outer_time_ms=5767;asset_local_time_ms=1000;progress=([math]::Round(1000/$durationMs,6));state='playing-one-second'}
  )
}
$timelinePath=Join-Path $Out 'episode_timeline.json'
$timeline | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $timelinePath -Encoding utf8NoBOM
New-Item -ItemType Directory -Path $ProjectStage,$MediaStage | Out-Null
Copy-Item -LiteralPath $Entry -Destination (Join-Path $ProjectStage 'entry.tsx')
Copy-Item -LiteralPath $Component -Destination (Join-Path $ProjectStage 'ResearchAquaMediaAdapter.tsx')
Copy-Item -LiteralPath $Fixture -Destination (Join-Path $MediaStage 'local-demo.mp4')
Copy-Item -LiteralPath $Poster -Destination (Join-Path $MediaStage 'source-frame-000.png')
Copy-Item -LiteralPath $PrototypeHtml -Destination (Join-Path $MediaStage 'g1va_v2_research_aqua_prototype.html')
$props=[ordered]@{
  assetPath="$StageSlug/local-demo.mp4"; posterPath="$StageSlug/source-frame-000.png"; prototypePath="$StageSlug/g1va_v2_research_aqua_prototype.html"
  assetDurationMs=$durationMs; assetFrameCount=$frameCount; assetWidth=[int]$v.width; assetHeight=[int]$v.height
  assetFpsNumerator=$fpsNumerator; assetFpsDenominator=$fpsDenominator; playStartFrame=$playStartFrame
}
$propsPath=Join-Path $Out 'render_props.json'
$props | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $propsPath -Encoding utf8NoBOM
$preflight=[ordered]@{browser_version=$BrowserVersion;browser_sha256=$BrowserSha;explicit_browser_executable=$BrowserExecutable;browser_cache_reuse='YES';browser_download_requested='NO';stage_slug=$StageSlug;stage_project=$ProjectStage;stage_media=$MediaStage;remotion_version=$remotionVersion;remotion_cli_version=$cliVersion}
$preflight | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $Out 'browser_runtime_preflight.json') -Encoding utf8NoBOM
$RenderOriginal=Join-Path $Qa 'remotion-render-original.mp4'
$Final=Join-Path $Out 'cws-g1va-v2-media-m1.mp4'
$RenderLog=Join-Path $Qa 'render.log'
$RenderCommand="$CliBin render projects/$StageSlug/entry.tsx CWSG1VAM1 $RenderOriginal --props=$propsPath --codec=h264 --browser-executable=$BrowserExecutable"
Push-Location $Composer
try {
  & $CliBin render "projects/$StageSlug/entry.tsx" CWSG1VAM1 $RenderOriginal "--props=$propsPath" '--codec=h264' "--browser-executable=$BrowserExecutable" *> $RenderLog
  $renderExit=$LASTEXITCODE
} finally { Pop-Location }
if($renderExit -ne 0){Get-Content -LiteralPath $RenderLog; throw "G1VA_M1_RENDER_FAILED exit=$renderExit; no browser fallback or install attempted"}
& ffmpeg -hide_banner -n -i $RenderOriginal -map 0:v:0 -c:v copy -an -movflags +faststart $Final *> (Join-Path $Qa 'remux.log')
if($LASTEXITCODE -ne 0){throw 'G1VA_M1_VIDEO_ONLY_REMUX_FAILED'}
$probeFinalLines=& ffprobe -v error -count_frames -show_streams -show_format -of json $Final
if($LASTEXITCODE -ne 0){throw 'G1VA_M1_FINAL_FFPROBE_FAILED'}
$probeFinalText=$probeFinalLines -join [Environment]::NewLine
$probeFinal=$probeFinalText | ConvertFrom-Json
$probeFinalText | Set-Content -LiteralPath (Join-Path $Out 'ffprobe.json') -Encoding utf8NoBOM
$finalVideo=@($probeFinal.streams | Where-Object codec_type -eq 'video')
$finalAudio=@($probeFinal.streams | Where-Object codec_type -eq 'audio')
if($finalVideo.Count -ne 1 -or $finalAudio.Count -ne 0 -or [int]$finalVideo[0].width -ne 1920 -or [int]$finalVideo[0].height -ne 1080 -or $finalVideo[0].avg_frame_rate -ne '30/1' -or [int]$finalVideo[0].nb_read_frames -ne 270){throw 'G1VA_M1_FINAL_MEDIA_SPEC_MISMATCH'}
$decodeLog=Join-Path $Qa 'full_decode.log'
& ffmpeg -hide_banner -v error -i $Final -f null - 2> $decodeLog
$decodeExit=$LASTEXITCODE
$blackLog=Join-Path $Qa 'blackdetect.log'
& ffmpeg -hide_banner -i $Final -vf 'blackdetect=d=0.03:pix_th=0.10' -an -f null - *> $blackLog
$blackExit=$LASTEXITCODE
if($decodeExit -ne 0 -or $blackExit -ne 0){throw 'G1VA_M1_DECODE_OR_BLACKDETECT_FAILED'}
$keyframeTimes=@(
  @{name='01-desktop-initial';time=0.300}
  @{name='02-cursor-moving';time=0.933}
  @{name='03-file-selected';time=1.500}
  @{name='04-double-click-feedback';time=1.733}
  @{name='05-player-window-opening';time=2.200}
  @{name='06-green-button-fullscreen-transition';time=3.500}
  @{name='07-fullscreen-paused-first-frame';time=4.400}
  @{name='08-paused-before-play';time=4.733}
  @{name='09-first-play-frame-zero';time=4.767}
  @{name='10-playing-one-second';time=5.767}
  @{name='11-playing-later';time=8.800}
)
foreach($shot in $keyframeTimes){
  $png=Join-Path $Keyframes ($shot.name+'.png')
  & ffmpeg -hide_banner -loglevel error -n -i $Final -ss ([string]::Format([cultureinfo]::InvariantCulture,'{0:0.000}',$shot.time)) -frames:v 1 -update 1 $png
  if($LASTEXITCODE -ne 0){throw "G1VA_M1_KEYFRAME_FAILED: $($shot.name)"}
}
$crop1=Join-Path $Qa 'paused-content-4.400.png'; $crop2=Join-Path $Qa 'paused-content-4.733.png'; $cropPlay=Join-Path $Qa 'playing-content-5.767.png'
foreach($crop in @(@{t='4.400';p=$crop1},@{t='4.733';p=$crop2},@{t='5.767';p=$cropPlay})){
  & ffmpeg -hide_banner -loglevel error -n -i $Final -ss $crop.t -vf 'crop=1684:947:118:63' -frames:v 1 -update 1 $crop.p
  if($LASTEXITCODE -ne 0){throw "G1VA_M1_CONTENT_CROP_FAILED: $($crop.t)"}
}
$sourceAtOneSec=Join-Path $Qa 'source-content-1.000.png'
& ffmpeg -hide_banner -loglevel error -n -i $Fixture -ss '1.000' -frames:v 1 -update 1 $sourceAtOneSec
if($LASTEXITCODE -ne 0){throw 'G1VA_M1_SOURCE_FRAME_1S_EXTRACTION_FAILED'}
function Get-Ssim([string]$Reference,[string]$Candidate,[string]$LogPath,[bool]$ScaleReference){
  if($ScaleReference){$filter='[1:v]scale=1684:946:flags=bicubic[ref];[0:v][ref]ssim'}else{$filter='[0:v][1:v]ssim'}
  $lines=& ffmpeg -hide_banner -i $Candidate -i $Reference -filter_complex $filter -frames:v 1 -f null - 2>&1
  $lines | Set-Content -LiteralPath $LogPath -Encoding utf8NoBOM
  $match=([string]($lines -join ' ')) -match 'All:([0-9.]+)'
  if(!$match){return $null}; return [double]$Matches[1]
}
$pausedFreezeSsim=Get-Ssim $crop1 $crop2 (Join-Path $Qa 'ssim-paused-frame-stability.log') $false
$pausedPosterSsim=Get-Ssim $Poster $crop1 (Join-Path $Qa 'ssim-paused-vs-source-frame0.log') $true
$playingOneSecSsim=Get-Ssim $sourceAtOneSec $cropPlay (Join-Path $Qa 'ssim-playing-1s-vs-source.log') $true
$pausedHash1=(Get-FileHash -LiteralPath $crop1 -Algorithm SHA256).Hash.ToLowerInvariant()
$pausedHash2=(Get-FileHash -LiteralPath $crop2 -Algorithm SHA256).Hash.ToLowerInvariant()
$playingHash=(Get-FileHash -LiteralPath $cropPlay -Algorithm SHA256).Hash.ToLowerInvariant()
$frameMd5Path=Join-Path $Qa 'framemd5.txt'
& ffmpeg -hide_banner -loglevel error -i $Final -map 0:v:0 -f framemd5 $frameMd5Path
if($LASTEXITCODE -ne 0){throw 'G1VA_M1_FRAME_HASH_FAILED'}
$frameDigests=@(Get-Content -LiteralPath $frameMd5Path | Where-Object {$_ -and $_[0] -ne '#'} | ForEach-Object {($_ -split ',')[-1].Trim()})
$browserShaPost=(Get-FileHash -LiteralPath $BrowserExecutable -Algorithm SHA256).Hash.ToLowerInvariant()
if($browserShaPost -ne $BrowserSha){throw 'G1VA_M1_BROWSER_SHA_CHANGED_DURING_RENDER'}
$qa=[ordered]@{
  status='MACHINE_QA_COMPLETE_OWNER_REVIEW_PENDING_G1_NOT_PASS'; output_mp4=$Final; output_sha256=(Get-FileHash -LiteralPath $Final -Algorithm SHA256).Hash.ToLowerInvariant()
  output_bytes=(Get-Item -LiteralPath $Final).Length; duration_seconds=[double]$probeFinal.format.duration; width=[int]$finalVideo[0].width; height=[int]$finalVideo[0].height
  fps=$finalVideo[0].avg_frame_rate; decoded_frames=[int]$finalVideo[0].nb_read_frames; codec=$finalVideo[0].codec_name; audio_stream_count=$finalAudio.Count
  full_decode_exit_code=$decodeExit; full_decode_log=$decodeLog; blackdetect_exit_code=$blackExit; blackdetect_hits=@(Select-String -LiteralPath $blackLog -Pattern 'black_start' | ForEach-Object Line)
  input_sha256=$fixtureSha; source_frame0_sha256=$posterSha; paused_4_400_content_sha256=$pausedHash1; paused_4_733_content_sha256=$pausedHash2
  paused_content_stability_ssim=$pausedFreezeSsim; paused_content_stability_threshold=0.995; paused_content_stable=($pausedFreezeSsim -ge 0.995)
  paused_vs_source_frame0_ssim=$pausedPosterSsim; paused_vs_source_frame0_minimum=0.97; paused_matches_source_frame0=($pausedPosterSsim -ge 0.97); playing_5_767_content_sha256=$playingHash
  playing_content_changed_after_start=($playingHash -ne $pausedHash1); playing_1s_vs_source_frame1s_ssim=$playingOneSecSsim; playing_source_frame1s_minimum=0.97; playing_matches_source_frame1s=($playingOneSecSsim -ge 0.97)
  unique_decoded_frames=@($frameDigests | Sort-Object -Unique).Count; keyframe_count=$keyframeTimes.Count
  browser_version=$BrowserVersion; browser_sha256_pre=$BrowserSha; browser_sha256_post=$browserShaPost; render_command=$RenderCommand
  stage_slug=$StageSlug; stage_project=$ProjectStage; stage_media=$MediaStage; keyframes_directory=$Keyframes; visual_reference_git_blob_sha=$prototypeBlobSha
}
$qa | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $Out 'machine_qa.json') -Encoding utf8NoBOM
Write-Output "G1VA_M1_RENDERED=$Final"
Write-Output "G1VA_M1_SHA256=$($qa.output_sha256)"
Write-Output "G1VA_M1_QA=$(Join-Path $Out 'machine_qa.json')"
Write-Output "G1VA_M1_STATUS=OWNER_REVIEW_PENDING_G1_NOT_PASS"
