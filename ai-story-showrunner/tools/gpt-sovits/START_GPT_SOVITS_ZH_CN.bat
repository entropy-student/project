@echo off
setlocal EnableExtensions
title GPT-SoVITS Launcher

set "GPT_HOME=C:\AI\GPT-SoVITS"
set "PYTHON_EXE=C:\Users\34707\miniconda3\envs\GPTSoVits\python.exe"

set "PYTHONNOUSERSITE=1"
set "NO_PROXY=localhost,127.0.0.1,0.0.0.0,::1"
set "no_proxy=localhost,127.0.0.1,0.0.0.0,::1"
set "ALL_PROXY="
set "all_proxy="

echo ============================================
echo GPT-SoVITS Launcher
echo ============================================
echo GPT_HOME   = %GPT_HOME%
echo PYTHON_EXE = %PYTHON_EXE%
echo UI_LANG    = zh_CN
echo.

if not exist "%GPT_HOME%\webui.py" (
  echo [FAIL] webui.py not found:
  echo %GPT_HOME%\webui.py
  goto :fail
)

if not exist "%PYTHON_EXE%" (
  echo [FAIL] Python not found:
  echo %PYTHON_EXE%
  goto :fail
)

if not exist "%GPT_HOME%\tools\i18n\locale\zh_CN.json" (
  echo [FAIL] zh_CN locale not found.
  goto :fail
)

cd /d "%GPT_HOME%"
if errorlevel 1 (
  echo [FAIL] Cannot enter GPT-SoVITS directory.
  goto :fail
)

echo [INFO] Checking Python...
"%PYTHON_EXE%" -c "import sys; print(sys.executable); print(sys.version)"
if errorlevel 1 goto :fail

echo.
echo [INFO] Starting GPT-SoVITS...
echo [INFO] Browser URL: http://127.0.0.1:9874
echo [INFO] Keep this window open while using GPT-SoVITS.
echo.

"%PYTHON_EXE%" "%GPT_HOME%\webui.py" zh_CN
set "EXITCODE=%ERRORLEVEL%"

echo.
echo GPT-SoVITS exited. ExitCode=%EXITCODE%
pause
exit /b %EXITCODE%

:fail
echo.
echo [FAIL] Startup check failed.
echo Run CHECK_GPT_SOVITS_ENV.bat and inspect the report.
pause
exit /b 1
