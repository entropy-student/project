param(
  [Parameter(Mandatory=$true)][ValidateSet('landscape_24','portrait_30')][string]$FixtureId,
  [Parameter(Mandatory=$true)][string]$Work
)
$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'm2_media_guard.psm1') -Force
if(!(Test-Path -LiteralPath $Work -PathType Container)){New-Item -ItemType Directory -Path $Work | Out-Null}
$Work=(Resolve-Path -LiteralPath $Work).Path
$Assets=Join-Path $Work 'assets'
if(!(Test-Path -LiteralPath $Assets)){New-Item -ItemType Directory -Path $Assets | Out-Null}
$Source=Join-Path $Assets 'source.mp4'
$Poster=Join-Path $Assets 'poster.png'
$ReceiptPath=Join-Path $Assets 'fixture_generation.json'
$Log=Join-Path $Assets 'fixture_generation.log'
Assert-M2FreshPaths -Paths @($Source,$Poster,$ReceiptPath,$Log)

switch($FixtureId){
  'landscape_24' {
    $width=1280; $height=720; $fpsN=24; $fpsD=1; $seconds=8; $frames=192
    $overlaySizes=@('104x104','96x96','72x72')
    $overlayColors=@('0x53b7e4','0xf6d28b','0x84d6b1')
    $backgroundFilter='drawgrid=width=80:height=80:thickness=1:color=white@0.12,drawbox=x=18:y=18:w=84:h=84:color=white:t=6,drawbox=x=1178:y=618:w=84:h=84:color=white:t=6'
    $overlayPositions=@("x='40+128*t':y=116","x='1100-72*t':y=476","x=580:y='42+45*t'")
  }
  'portrait_30' {
    $width=1080; $height=1920; $fpsN=30; $fpsD=1; $seconds=9; $frames=270
    $overlaySizes=@('116x116','112x112','80x80')
    $overlayColors=@('0x53b7e4','0xf6d28b','0x84d6b1')
    $backgroundFilter='drawgrid=width=90:height=90:thickness=1:color=white@0.12,drawbox=x=18:y=18:w=84:h=84:color=white:t=6,drawbox=x=978:y=1818:w=84:h=84:color=white:t=6'
    $overlayPositions=@("x='55+96*t':y=280","x='810-62*t':y=1510","x=490:y='80+95*t'")
  }
}
$filterParts=@("[0:v]$backgroundFilter[bg]")
for($i=0;$i -lt 3;$i++){
  $inputIndex=$i+1
  $previous=if($i -eq 0){'bg'}else{"overlay$($i)"}
  $next="overlay$($i+1)"
  $filterParts+=('['+$inputIndex+':v]format=yuv420p[color'+$inputIndex+']')
  $filterParts+=('['+$previous+'][color'+$inputIndex+']overlay='+$overlayPositions[$i]+':eval=frame['+$next+']')
}
$filterParts+=('[overlay3]format=yuv420p[outv]')
$filterComplex=$filterParts -join ';'
$ffmpeg=(Get-Command ffmpeg -ErrorAction Stop).Source
$ffmpegSha=(Get-FileHash -LiteralPath $ffmpeg -Algorithm SHA256).Hash.ToLowerInvariant()
$version=(& $ffmpeg -version 2>&1 | Select-Object -First 1).ToString().Trim()
$ffmpegArgs=@('-hide_banner','-n','-f','lavfi','-i',"color=c=0x0d2038:s=${width}x${height}:r=${fpsN}/${fpsD}:d=$seconds")
for($i=0;$i -lt 3;$i++){$ffmpegArgs+=@('-f','lavfi','-i',("color=c={0}:s={1}:r={2}/{3}:d={4}" -f $overlayColors[$i],$overlaySizes[$i],$fpsN,$fpsD,$seconds))}
$ffmpegArgs+=@('-filter_complex',$filterComplex,'-map','[outv]','-an','-frames:v',"$frames",'-fps_mode','cfr','-r',"$fpsN/$fpsD",'-c:v','libx264','-preset','medium','-crf','18','-pix_fmt','yuv420p','-movflags','+faststart',$Source)
$generationOutput=& $ffmpeg @ffmpegArgs 2>&1
$generationExit=$LASTEXITCODE
$generationOutput | Set-Content -LiteralPath $Log -Encoding utf8NoBOM
if($generationExit -ne 0){throw "M2_FIXTURE_GENERATION_FAILED exit=$generationExit"}
$posterOutput=& $ffmpeg -hide_banner -loglevel error -n -i $Source -map 0:v:0 -an -frames:v 1 -update 1 $Poster 2>&1
$posterExit=$LASTEXITCODE
if($posterExit -ne 0){$posterOutput | Set-Content -LiteralPath $Log -Encoding utf8NoBOM; throw "M2_POSTER_GENERATION_FAILED exit=$posterExit"}
$motionCheckIndices=if($FixtureId -eq 'landscape_24'){@(1,24,72)}else{@(1,30,90)}
$selectExpression=($motionCheckIndices | ForEach-Object {"eq(n\,$_)"}) -join '+'
$motionLines=& $ffmpeg -hide_banner -loglevel error -i $Source -vf "select=$selectExpression" -fps_mode passthrough -frames:v 3 -pix_fmt rgb24 -f framemd5 - 2>&1
if($LASTEXITCODE -ne 0){throw 'M2_FIXTURE_MOTION_CHECK_DECODE_FAILED'}
$motionData=@($motionLines | Where-Object {$_ -and $_.ToString().Trim() -and !$_.ToString().StartsWith('#')})
$motionDigests=@($motionData | ForEach-Object {($_.ToString().Split(',')[-1]).Trim().ToLowerInvariant()})
if($motionDigests.Count -ne 3 -or @($motionDigests | Sort-Object -Unique).Count -ne 3){throw 'M2_FIXTURE_HAS_NO_RECOGNIZABLE_TIME_MOTION'}
$receipt=[ordered]@{
  schema='CWS_G1VA_M2_FIXTURE_RECEIPT_V1';fixture_id=$FixtureId;source_file='assets/source.mp4';poster_file='assets/poster.png'
  source_width=$width;source_height=$height;source_fps_numerator=$fpsN;source_fps_denominator=$fpsD;source_duration_ms=($seconds*1000);source_frame_count=$frames
  codec_name='h264';stream_count=1;audio_stream_count=0;rights_basis='self_generated_local_test_only';source_kind='ffmpeg_lavfi_overlay_motion';fit_policy='contain'
  generator='locally installed FFmpeg; lavfi colour layers and frame-evaluated overlay motion';generator_command=('ffmpeg '+($ffmpegArgs -join ' '));generator_exit_code=$generationExit
  motion_check_frame_indices=$motionCheckIndices;motion_check_rgb24_md5=$motionDigests
  ffmpeg_executable=$ffmpeg;ffmpeg_sha256=$ffmpegSha;ffmpeg_version=$version
  source_sha256=(Get-FileHash -LiteralPath $Source -Algorithm SHA256).Hash.ToLowerInvariant();poster_sha256=(Get-FileHash -LiteralPath $Poster -Algorithm SHA256).Hash.ToLowerInvariant()
}
$receipt | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $ReceiptPath -Encoding utf8NoBOM
"M2_FIXTURE=$FixtureId"; "SOURCE=$Source"; "POSTER=$Poster"; "RECEIPT=$ReceiptPath"; "GENERATION_EXIT=$generationExit"; "POSTER_EXIT=$posterExit"
