@echo off
setlocal EnableExtensions
title GPT-SoVITS Environment Check

set "GPT_HOME=C:\AI\GPT-SoVITS"
set "PYTHON_EXE=C:\Users\34707\miniconda3\envs\GPTSoVits\python.exe"
set "REPORT=%~dp0GPT_SoVITS_env_check.txt"

set "PYTHONNOUSERSITE=1"
set "NO_PROXY=localhost,127.0.0.1,0.0.0.0,::1"
set "no_proxy=localhost,127.0.0.1,0.0.0.0,::1"
set "ALL_PROXY="
set "all_proxy="

> "%REPORT%" echo GPT-SoVITS Environment Check
>>"%REPORT%" echo ============================================
>>"%REPORT%" echo GPT_HOME=%GPT_HOME%
>>"%REPORT%" echo PYTHON_EXE=%PYTHON_EXE%
>>"%REPORT%" echo.

call :check "%GPT_HOME%" "GPT_HOME"
call :check "%GPT_HOME%\webui.py" "webui.py"
call :check "%GPT_HOME%\tools\i18n\locale\zh_CN.json" "zh_CN locale"
call :check "%PYTHON_EXE%" "env python"

>>"%REPORT%" echo.
>>"%REPORT%" echo ===== Port 9874 =====
netstat -ano | findstr ":9874" >>"%REPORT%" 2>&1
if errorlevel 1 >>"%REPORT%" echo no listener on 9874

if not exist "%PYTHON_EXE%" goto :done

>>"%REPORT%" echo.
>>"%REPORT%" echo ===== Python =====
"%PYTHON_EXE%" --version >>"%REPORT%" 2>&1
"%PYTHON_EXE%" -c "import sys,site; print('exe=',sys.executable); print('prefix=',sys.prefix); print('ENABLE_USER_SITE=',site.ENABLE_USER_SITE)" >>"%REPORT%" 2>&1

>>"%REPORT%" echo.
>>"%REPORT%" echo ===== CUDA =====
"%PYTHON_EXE%" -c "import torch; print('torch=',torch.__version__); print('cuda=',torch.cuda.is_available()); print('cuda_runtime=',torch.version.cuda); print('gpu=',torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'N/A')" >>"%REPORT%" 2>&1

>>"%REPORT%" echo.
>>"%REPORT%" echo ===== Imports =====
"%PYTHON_EXE%" -c "import gradio; print('gradio PASS',gradio.__version__)" >>"%REPORT%" 2>&1
"%PYTHON_EXE%" -c "import fastapi; print('fastapi PASS',fastapi.__version__)" >>"%REPORT%" 2>&1
"%PYTHON_EXE%" -c "import starlette; print('starlette PASS',starlette.__version__)" >>"%REPORT%" 2>&1
"%PYTHON_EXE%" -c "import shellingham; print('shellingham PASS')" >>"%REPORT%" 2>&1
"%PYTHON_EXE%" -c "import rapidfuzz; print('rapidfuzz PASS',rapidfuzz.__version__)" >>"%REPORT%" 2>&1
"%PYTHON_EXE%" -c "import platformdirs; print('platformdirs PASS',platformdirs.__version__)" >>"%REPORT%" 2>&1
"%PYTHON_EXE%" -c "import onnxruntime; print('onnxruntime PASS',onnxruntime.__version__)" >>"%REPORT%" 2>&1
"%PYTHON_EXE%" -c "import jieba; print('jieba PASS')" >>"%REPORT%" 2>&1
"%PYTHON_EXE%" -c "import opencc; print('opencc PASS')" >>"%REPORT%" 2>&1
"%PYTHON_EXE%" -c "import pyopenjtalk; print('pyopenjtalk PASS')" >>"%REPORT%" 2>&1

>>"%REPORT%" echo.
>>"%REPORT%" echo ===== pip check =====
"%PYTHON_EXE%" -m pip check >>"%REPORT%" 2>&1

>>"%REPORT%" echo.
>>"%REPORT%" echo ===== GPT config =====
cd /d "%GPT_HOME%"
"%PYTHON_EXE%" -c "import config; print('config PASS'); print('main_port=',getattr(config,'webui_port_main','UNKNOWN')); print('device=',getattr(config,'infer_device','UNKNOWN'))" >>"%REPORT%" 2>&1

>>"%REPORT%" echo.
>>"%REPORT%" echo ===== i18n =====
"%PYTHON_EXE%" -c "from tools.i18n.i18n import scan_language_list; x=scan_language_list(); print('zh_CN=', 'zh_CN' in x); print(x)" >>"%REPORT%" 2>&1

:done
>>"%REPORT%" echo.
>>"%REPORT%" echo ===== END =====

echo.
echo Done.
echo Report:
echo %REPORT%
echo.
start "" notepad.exe "%REPORT%"
pause
exit /b 0

:check
if exist "%~1" (
  >>"%REPORT%" echo [PASS] %~2 = %~1
) else (
  >>"%REPORT%" echo [FAIL] %~2 = %~1
)
exit /b 0
