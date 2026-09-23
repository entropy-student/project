@echo off
setlocal
set "PY=C:\Users\34707\miniconda3\envs\GPTSoVits\python.exe"
set "SCRIPT=%~dp0PATCH_API_TORCHCODEC.py"

if not exist "%PY%" (
  echo RESULT=RETURN_PYTHON_NOT_FOUND
  echo PY=%PY%
  exit /b 1
)

"%PY%" "%SCRIPT%"
set "RC=%ERRORLEVEL%"
echo EXIT_CODE=%RC%
exit /b %RC%
