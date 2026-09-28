@echo off
setlocal EnableExtensions
title GPT-SoVITS SRT1 to SRT2 Batch Executor

set "PY=C:\Users\34707\miniconda3\envs\GPTSoVits\python.exe"
set "SCRIPT=%~dp0GPT_SOVITS_SRT_BATCH_EXECUTOR.py"

if not exist "%PY%" (
  echo RESULT=RETURN_PYTHON_NOT_FOUND
  echo PY=%PY%
  pause
  exit /b 1
)

if not exist "%SCRIPT%" (
  echo RESULT=RETURN_EXECUTOR_SCRIPT_NOT_FOUND
  echo SCRIPT=%SCRIPT%
  pause
  exit /b 1
)

set "PYTHONNOUSERSITE=1"
set "NO_PROXY=localhost,127.0.0.1,0.0.0.0"
set "no_proxy=localhost,127.0.0.1,0.0.0.0"

echo ============================================
echo GPT-SoVITS SRT1 to SRT2 Batch Executor
echo ============================================
echo API must already be running on:
echo http://127.0.0.1:9880
echo.
echo Each input SRT cue is treated as one TTS unit.
echo Existing matching PASS units are resumed automatically.
echo.

if "%~1"=="" (
  "%PY%" "%SCRIPT%"
) else (
  "%PY%" "%SCRIPT%" --srt "%~1"
)

set "RC=%ERRORLEVEL%"
echo.
echo EXIT_CODE=%RC%
pause
exit /b %RC%
