@echo off
setlocal
set "PY=C:\Users\34707\miniconda3\envs\GPTSoVits\python.exe"
set "SCRIPT=%~dp0API_DETERMINISM_SMOKE.py"

if not exist "%PY%" (
  echo RESULT=RETURN_PYTHON_NOT_FOUND
  exit /b 1
)

"%PY%" "%SCRIPT%"
set "RC=%ERRORLEVEL%"
echo EXIT_CODE=%RC%
pause
exit /b %RC%
