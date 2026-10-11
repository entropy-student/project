Set-StrictMode -Version Latest

function Assert-M2AssetContract {
  param([Parameter(Mandatory=$true)][object]$Metadata)

  $required=@('profile','fixture_id','source_width','source_height','source_fps_numerator','source_fps_denominator','source_duration_ms','source_frame_count','codec_name','stream_count','audio_stream_count','source_sha256','poster_sha256','source_frame0_pixel_md5','poster_pixel_md5','rights_basis','fit_policy')
  foreach($name in $required){
    if($Metadata.PSObject.Properties.Name -notcontains $name -or $null -eq $Metadata.$name){throw "M2_REQUIRED_FIELD_MISSING: $name"}
  }
  foreach($name in @('source_width','source_height','source_fps_numerator','source_fps_denominator','source_duration_ms','source_frame_count')){
    if([int64]$Metadata.$name -le 0){throw "M2_POSITIVE_INTEGER_REQUIRED: $name"}
  }
  if($Metadata.rights_basis -ne 'self_generated_local_test_only'){throw 'M2_RIGHTS_BASIS_NOT_ALLOWED'}
  if($Metadata.fit_policy -ne 'contain'){throw 'M2_FIT_POLICY_MUST_BE_CONTAIN'}
  if($Metadata.codec_name -ne 'h264' -or [int]$Metadata.stream_count -ne 1 -or [int]$Metadata.audio_stream_count -ne 0){throw 'M2_EXPECTS_ONE_H264_VIDEO_STREAM_WITHOUT_AUDIO'}
  foreach($name in @('source_sha256','poster_sha256')){if([string]$Metadata.$name -notmatch '^[0-9a-f]{64}$'){throw "M2_BAD_SHA256: $name"}}
  Assert-M2PosterMatchesSource -SourceDigest $Metadata.source_frame0_pixel_md5 -PosterDigest $Metadata.poster_pixel_md5

  switch([string]$Metadata.profile){
    'landscape_24' {$expected=@{fixture_id='landscape_24';width=1280;height=720;fpsN=24;fpsD=1;duration=8000;frames=192}}
    'portrait_30' {$expected=@{fixture_id='portrait_30';width=1080;height=1920;fpsN=30;fpsD=1;duration=9000;frames=270}}
    'm1_regression' {$expected=@{fixture_id='m1_regression';width=1920;height=1080;fpsN=30;fpsD=1;duration=6000;frames=180}}
    default {throw 'M2_PROFILE_NOT_ALLOWED'}
  }
  if([string]$Metadata.fixture_id -ne $expected.fixture_id -or [int]$Metadata.source_width -ne $expected.width -or [int]$Metadata.source_height -ne $expected.height -or [int]$Metadata.source_fps_numerator -ne $expected.fpsN -or [int]$Metadata.source_fps_denominator -ne $expected.fpsD -or [int]$Metadata.source_duration_ms -ne $expected.duration -or [int]$Metadata.source_frame_count -ne $expected.frames){throw 'M2_PROFILE_METADATA_MISMATCH'}
  if([string]$Metadata.source_r_frame_rate -ne "$($expected.fpsN)/$($expected.fpsD)" -or [string]$Metadata.source_avg_frame_rate -ne "$($expected.fpsN)/$($expected.fpsD)"){throw 'M2_CFR_METADATA_MISMATCH'}
}

function Assert-M2PosterMatchesSource {
  param([Parameter(Mandatory=$true)][string]$SourceDigest,[Parameter(Mandatory=$true)][string]$PosterDigest)
  if($SourceDigest -notmatch '^[0-9a-f]{32}$' -or $PosterDigest -notmatch '^[0-9a-f]{32}$'){throw 'M2_BAD_POSTER_PIXEL_DIGEST'}
  if($SourceDigest -cne $PosterDigest){throw 'M2_POSTER_DOES_NOT_MATCH_SOURCE_FRAME_ZERO'}
}

function Assert-M2FreshPaths {
  param([Parameter(Mandatory=$true)][string[]]$Paths)
  foreach($path in $Paths){if(Test-Path -LiteralPath $path){throw "M2_STAGE_PATH_ALREADY_EXISTS: $path"}}
}

function Assert-M2StageSlug {
  param([Parameter(Mandatory=$true)][string]$Profile,[Parameter(Mandatory=$true)][string]$StageSlug)
  $profilePart=$Profile.Replace('_','-')
  if($StageSlug -notmatch "^cws-g1va-m2-$([regex]::Escape($profilePart))-[a-z0-9-]+$"){throw 'M2_BAD_STAGE_SLUG'}
}

Export-ModuleMember -Function Assert-M2AssetContract,Assert-M2PosterMatchesSource,Assert-M2FreshPaths,Assert-M2StageSlug
