# Owner Windows G1: OPTIONAL local Mandarin voice only (no cloud/fees/installation).
# Run in Windows PowerShell 5.1 as it may include System.Speech; if no zh voice exists, STOP.
param([Parameter(Mandatory=$true)][string]$Work,[Parameter(Mandatory=$true)][string]$PilotRoot)
$ErrorActionPreference="Stop"
$audioDir=Join-Path $Work "audio"
New-Item -Path $audioDir -ItemType Directory -Force | Out-Null
$out=Join-Path $audioDir "narration.wav"
if(Test-Path -LiteralPath $out){ throw "Refusing to overwrite an existing master narration audio: $out" }
Add-Type -AssemblyName System.Speech
$synth=[System.Speech.Synthesis.SpeechSynthesizer]::new()
try {
  $v=@($synth.GetInstalledVoices() | Where-Object { $_.Enabled -and $_.VoiceInfo.Culture.Name -like "zh-*" })
  if($v.Count -eq 0){ throw "G1_AUDIO_BLOCKED: No installed Mandarin SAPI voice. No download, no cloud TTS fallback authorized." }
  $synth.SelectVoice($v[0].VoiceInfo.Name)
  $synth.Rate=0
  $script=([System.IO.File]::ReadAllText((Join-Path $PilotRoot "fixture_script.txt"))).Trim()
  $synth.SetOutputToWaveFile($out)
  $synth.Speak($script)
  $synth.SetOutputToNull()
  Write-Host "G1_MANDARIN_SAPI_WAV_CREATED=$out"
  Write-Host "VOICE=$($v[0].VoiceInfo.Name)"
} finally { $synth.Dispose() }
