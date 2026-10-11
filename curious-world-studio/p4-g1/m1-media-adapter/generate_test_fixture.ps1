param(
  [Parameter(Mandatory=$true)][string]$OutputPath
)
$ErrorActionPreference = 'Stop'
if(Test-Path -LiteralPath $OutputPath){ throw "Refusing to overwrite existing fixture: $OutputPath" }
$parent = Split-Path -Parent $OutputPath
if(!(Test-Path -LiteralPath $parent)){ New-Item -ItemType Directory -Path $parent | Out-Null }
$posterPath = Join-Path $parent 'source-frame-000.png'
if(Test-Path -LiteralPath $posterPath){ throw "Refusing to overwrite existing poster: $posterPath" }
$filter = "[0:v][1:v]overlay=x='80+150*t':y=250:shortest=1[moveA];[moveA][2:v]overlay=x='1550-130*t':y=600:shortest=1[moveB];[moveB][3:v]overlay=x=860:y='60+110*t':shortest=1"
& ffmpeg -hide_banner -n -f lavfi -i "color=c=0x0d2038:s=1920x1080:r=30:d=6" -f lavfi -i "color=c=0x53b7e4:s=230x230:r=30:d=6" -f lavfi -i "color=c=0xf6d28b:s=220x220:r=30:d=6" -f lavfi -i "color=c=0x84d6b1:s=180x180:r=30:d=6" -filter_complex $filter -an -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -movflags +faststart $OutputPath
if($LASTEXITCODE -ne 0){ throw "FFmpeg fixture generation failed: $LASTEXITCODE" }
& ffmpeg -hide_banner -n -i $OutputPath -frames:v 1 -fps_mode passthrough $posterPath
if($LASTEXITCODE -ne 0){ throw "FFmpeg poster extraction failed: $LASTEXITCODE" }
