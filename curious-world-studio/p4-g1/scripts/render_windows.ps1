# Run ONLY on Owner Windows after the pilot has real source figures, a final narration WAV,
# reviewed rights.reviewed.json and actual human-listened captions.reviewed.json.
# All writes confined to a fresh isolated work directory and additive versioned Composer paths.
# Owner authorized reuse of the existing, previously downloaded Chrome Headless Shell for private G1-R2 ONLY.
# Never select system Edge or trigger browser auto-download.
param(
  [Parameter(Mandatory=$true)][string]$PilotRoot,
  [Parameter(Mandatory=$true)][string]$Work,
  [string]$OMRoot="C:\Users\34707\Tools\OpenMontage",
  [string]$StageSlug="cws-g1-r2",
  [Parameter(Mandatory=$true)][string]$BrowserExecutable
)
$ErrorActionPreference="Stop"
$PilotRoot=(Resolve-Path -LiteralPath $PilotRoot).Path
$Work=(Resolve-Path -LiteralPath $Work).Path
if($StageSlug -notmatch "^cws-g1-[A-Za-z0-9_-]+$"){throw "G1_BAD_STAGE_SLUG: use a new cws-g1-r2-like basename"}
$BrowserCacheRoot=Join-Path $OMRoot "remotion-composer\node_modules\.remotion\chrome-headless-shell"
if(!(Test-Path -LiteralPath $BrowserExecutable -PathType Leaf)){throw "G1_BROWSER_RUNTIME_MISSING: pass an existing local Chrome Headless Shell exe, no download allowed."}
if(!(Test-Path -LiteralPath $BrowserCacheRoot -PathType Container)){throw "G1_BROWSER_CACHE_MISSING: stop; no browser download allowed."}
$BrowserExecutable=(Resolve-Path -LiteralPath $BrowserExecutable).Path
$BrowserCacheRoot=(Resolve-Path -LiteralPath $BrowserCacheRoot).Path
$cachePrefix=$BrowserCacheRoot.TrimEnd('\')+'\'
if(-not $BrowserExecutable.StartsWith($cachePrefix,[StringComparison]::OrdinalIgnoreCase) -or [IO.Path]::GetFileName($BrowserExecutable) -ne "chrome-headless-shell.exe"){
  throw "G1_BROWSER_OUT_OF_SCOPE: only the already-downloaded dedicated Chrome Headless Shell cache is approved"
}
$browserSha=(Get-FileHash -LiteralPath $BrowserExecutable -Algorithm SHA256).Hash
$browserVersion=(& $BrowserExecutable --version 2>&1 | Out-String).Trim()
if($LASTEXITCODE -ne 0 -or $browserVersion -notmatch '149\.0\.7790\.0'){
  throw "G1_BROWSER_VERSION_UNEXPECTED: expected pre-existing Chrome Headless Shell 149.0.7790.0; stop rather than upgrade"
}
Write-Host "G1_BROWSER_EXISTING_SHA256=$browserSha"
Write-Host "G1_BROWSER_EXISTING_VERSION=$browserVersion"
Write-Host "G1_BROWSER_CACHE_REUSED=YES; NO_DOWNLOAD_REQUESTED=YES"
if(Test-Path -LiteralPath (Join-Path $Work "out")){throw "G1_OUT_EXISTS: preserve old evidence and create a fresh isolated work directory"}
$composer=Join-Path $OMRoot "remotion-composer"
$python=Join-Path $OMRoot ".venv\Scripts\python.exe"
$entry=Join-Path $PilotRoot "remotion\entry.tsx"
$comp=Join-Path $PilotRoot "remotion\ResearchEpisode.tsx"
$npm=Join-Path $composer "node_modules\remotion\package.json"
$cli=Join-Path $composer "node_modules\@remotion\cli\package.json"
$localProject=Join-Path $composer "projects\$StageSlug"
$localMedia=Join-Path $composer "public\$StageSlug"
if((Test-Path -LiteralPath $localProject) -or (Test-Path -LiteralPath $localMedia)){
  throw "G1_STAGE_EXISTS: preserve previous run; choose a genuinely unused stage slug"
}
$cliBin=Join-Path $composer "node_modules\.bin\remotion.cmd"
if(!(Test-Path $python) -or !(Test-Path $entry) -or !(Test-Path $comp) -or !(Test-Path $npm) -or !(Test-Path $cli) -or !(Test-Path $cliBin)){
  throw "G1_RUNTIME_BLOCKED: existing Python/Remotion runtime not present; no installs permitted."
}
# Generate all props in the isolated Work directory. This fails closed if alignment/rights are unreviewed.
& $python (Join-Path $PilotRoot "scripts\build_g1.py") --work $Work --stage-slug $StageSlug
if($LASTEXITCODE -ne 0){throw "G1_BUILD_REVIEW_GATE_BLOCKED"}
$out=Join-Path $Work "out"
$props=Join-Path $out "episode_props.json"
New-Item -ItemType Directory -Path $localProject,$localMedia | Out-Null
Copy-Item -LiteralPath $entry -Destination (Join-Path $localProject "entry.tsx")
Copy-Item -LiteralPath $comp -Destination (Join-Path $localProject "ResearchEpisode.tsx")
Copy-Item -LiteralPath (Join-Path $Work "assets\fig07.png") -Destination (Join-Path $localMedia "fig07.png")
Copy-Item -LiteralPath (Join-Path $Work "assets\fig08.png") -Destination (Join-Path $localMedia "fig08.png")
Copy-Item -LiteralPath (Join-Path $Work "audio\narration.wav") -Destination (Join-Path $localMedia "narration.wav")
Write-Host "G1_STAGED_PROJECT=$localProject"
Write-Host "G1_STAGED_ASSETS=$localMedia"
Push-Location $composer
try {
  $dest=Join-Path $out "g1-j-b-preview.mp4"
  if(Test-Path $dest){throw "Refusing overwrite: $dest"}
  # No packages are installed; launch the already installed Remotion CLI from node_modules.
  & $cliBin render "projects/$StageSlug/entry.tsx" CWSG1 $dest "--props=$props" "--codec=h264" "--browser-executable=$BrowserExecutable"
  if($LASTEXITCODE -ne 0){throw "G1_RENDER_FAILED; do not auto-reinstall or switch engines"}
} finally { Pop-Location }
& ffprobe -v error -show_streams -show_format -of json (Join-Path $out "g1-j-b-preview.mp4") | Out-File -FilePath (Join-Path $out "ffprobe.json") -Encoding utf8NoBOM
if($LASTEXITCODE -ne 0){throw "G1_FFPROBE_FAILED"}
& ffmpeg -hide_banner -loglevel error -n -ss 1 -i (Join-Path $out "g1-j-b-preview.mp4") -frames:v 1 (Join-Path $out "frame-A.png")
& ffmpeg -hide_banner -loglevel error -n -ss 8 -i (Join-Path $out "g1-j-b-preview.mp4") -frames:v 1 (Join-Path $out "frame-B-08.png")
& ffmpeg -hide_banner -loglevel error -n -ss 18 -i (Join-Path $out "g1-j-b-preview.mp4") -frames:v 1 (Join-Path $out "frame-B-18.png")
# Record exact executable SHA / version in isolated outputs only; do not upload private absolute paths.
$preflight=@{exe_sha256=$browserSha;exe_version=$browserVersion;stage_slug=$StageSlug;explicit_browser_flag=$true;browser_download_authorized=$false}
$preflight | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $out "browser_runtime_preflight.json") -Encoding utf8
Write-Host "G1_TECHNICAL_OUTPUT_CREATED=$out"
Write-Host "G1_NOT_FULL_PASS_UNTIL_OWNER_VISUAL_AND_AUDIO_REVIEW=YES"
Write-Host "G1_CLEANUP_MANUAL_ONLY: do not remove original installed tools or other projects"
