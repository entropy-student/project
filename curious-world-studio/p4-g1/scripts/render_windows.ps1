# Run ONLY on Owner Windows after the pilot has real source figures, a final narration WAV,
# reviewed rights.reviewed.json and actual human-listened captions.reviewed.json.
# All writes confined to an isolated work directory and ADDITIVE composer/cws-g1 directories.
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
if(!(Test-Path -LiteralPath $BrowserExecutable -PathType Leaf)){throw "G1_BROWSER_RUNTIME_MISSING: explicitly provide an Owner-approved existing Chrome Headless Shell executable; no auto download allowed."}
$BrowserExecutable=(Resolve-Path -LiteralPath $BrowserExecutable).Path
if(Test-Path -LiteralPath (Join-Path $Work "out")){throw "G1_OUT_EXISTS: preserve old evidence and create a fresh isolated work directory"}
$composer=Join-Path $OMRoot "remotion-composer"
$python=Join-Path $OMRoot ".venv\Scripts\python.exe"
$entry=Join-Path $PilotRoot "remotion\entry.tsx"
$comp=Join-Path $PilotRoot "remotion\ResearchEpisode.tsx"
$npm=Join-Path $composer "node_modules\remotion\package.json"
$cli=Join-Path $composer "node_modules\@remotion\cli\package.json"
if(!(Test-Path $python) -or !(Test-Path $entry) -or !(Test-Path $comp) -or !(Test-Path $npm) -or !(Test-Path $cli)){
  throw "G1_RUNTIME_BLOCKED: existing Python/Remotion runtime not present; no installs permitted."
}
# Generate all props in the isolated Work directory. This fails closed if alignment/rights are unreviewed.
& $python (Join-Path $PilotRoot "scripts\build_g1.py") --work $Work --stage-slug $StageSlug
if($LASTEXITCODE -ne 0){throw "G1_BUILD_REVIEW_GATE_BLOCKED"}
$out=Join-Path $Work "out"
$props=Join-Path $out "episode_props.json"
$localProject=Join-Path $composer "projects\$StageSlug"
$localMedia=Join-Path $composer "public\$StageSlug"
if((Test-Path $localProject) -or (Test-Path $localMedia)){throw "G1_STAGE_EXISTS: Existing staging paths cannot be overwritten; review before proceeding."}
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
  $cliBin=Join-Path $composer "node_modules\.bin\remotion.cmd"
  if(!(Test-Path -LiteralPath $cliBin)){ throw "G1_RUNTIME_BLOCKED: local remotion.cmd not installed (no npx remote fallback)" }
  & $cliBin render "projects/$StageSlug/entry.tsx" CWSG1 $dest "--props=$props" "--codec=h264" "--browser-executable=$BrowserExecutable"
  if($LASTEXITCODE -ne 0){throw "G1_RENDER_FAILED; do not auto-reinstall or switch engines"}
} finally { Pop-Location }
& ffprobe -v error -show_streams -show_format -of json (Join-Path $out "g1-j-b-preview.mp4") | Out-File -FilePath (Join-Path $out "ffprobe.json") -Encoding utf8NoBOM
if($LASTEXITCODE -ne 0){throw "G1_FFPROBE_FAILED"}
& ffmpeg -hide_banner -loglevel error -n -ss 1 -i (Join-Path $out "g1-j-b-preview.mp4") -frames:v 1 (Join-Path $out "frame-A.png")
& ffmpeg -hide_banner -loglevel error -n -ss 8 -i (Join-Path $out "g1-j-b-preview.mp4") -frames:v 1 (Join-Path $out "frame-B-08.png")
& ffmpeg -hide_banner -loglevel error -n -ss 18 -i (Join-Path $out "g1-j-b-preview.mp4") -frames:v 1 (Join-Path $out "frame-B-18.png")
Write-Host "G1_TECHNICAL_OUTPUT_CREATED=$out"
Write-Host "G1_NOT_FULL_PASS_UNTIL_OWNER_VISUAL_AND_AUDIO_REVIEW=YES"
Write-Host "G1_CLEANUP_MANUAL_ONLY: do not remove original installed tools or other projects"
