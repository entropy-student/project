@echo off
setlocal
set "ROOT=C:\AI\GPT-SoVITS"
set "PY=C:\Users\34707\miniconda3\envs\GPTSoVits\python.exe"

if not exist "%PY%" (
  echo RESULT=RETURN_PYTHON_NOT_FOUND
  echo PY=%PY%
  exit /b 1
)

if not exist "%ROOT%\api_v2.py" (
  echo RESULT=RETURN_API_NOT_FOUND
  echo ROOT=%ROOT%
  exit /b 1
)

set "PYTHONNOUSERSITE=1"
set "NO_PROXY=localhost,127.0.0.1,0.0.0.0"
set "no_proxy=localhost,127.0.0.1,0.0.0.0"

cd /d "%ROOT%"
echo RESULT=STARTING_GPT_SOVITS_API
echo URL=http://127.0.0.1:9880
"%PY%" api_v2.py -a 127.0.0.1 -p 9880 -c GPT_SoVITS\configs\tts_infer.yaml
