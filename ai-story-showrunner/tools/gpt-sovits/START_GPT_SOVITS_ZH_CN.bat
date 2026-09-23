@echo off
setlocal EnableExtensions
chcp 65001 >nul

title GPT-SoVITS 中文启动器

rem ============================================================
rem GPT-SoVITS Chinese Launcher
rem Default project path: C:\AI\GPT-SoVITS
rem Conda env: GPTSoVits
rem UI locale: zh_CN
rem ============================================================

set "GPT_SOVITS_HOME=C:\AI\GPT-SoVITS"
set "ENV_NAME=GPTSoVits"
set "UI_LANG=zh_CN"

set "PYTHONNOUSERSITE=1"
set "NO_PROXY=localhost,127.0.0.1,0.0.0.0,::1"
set "no_proxy=localhost,127.0.0.1,0.0.0.0,::1"
set "ALL_PROXY="
set "all_proxy="
set "PIP_DISABLE_PIP_VERSION_CHECK=1"

echo.
echo ==========================================
echo   GPT-SoVITS 中文启动器
echo ==========================================
echo 项目目录: %GPT_SOVITS_HOME%
echo Conda 环境: %ENV_NAME%
echo 界面语言: 简体中文 (%UI_LANG%)
echo.

if not exist "%GPT_SOVITS_HOME%\webui.py" (
    echo [错误] 找不到 GPT-SoVITS:
    echo   %GPT_SOVITS_HOME%\webui.py
    echo.
    echo 如果你以后移动了目录，请编辑本文件顶部 GPT_SOVITS_HOME。
    echo.
    pause
    exit /b 1
)

if not exist "%GPT_SOVITS_HOME%\tools\i18n\locale\zh_CN.json" (
    echo [错误] 当前 GPT-SoVITS 目录缺少官方简体中文语言包:
    echo   tools\i18n\locale\zh_CN.json
    echo.
    echo 建议先更新 GPT-SoVITS 源码，再重试。
    echo.
    pause
    exit /b 1
)

set "CONDA_BAT="

for /f "delims=" %%I in ('where conda.bat 2^>nul') do (
    if not defined CONDA_BAT set "CONDA_BAT=%%I"
)

if not defined CONDA_BAT if exist "%USERPROFILE%\miniconda3\condabin\conda.bat" set "CONDA_BAT=%USERPROFILE%\miniconda3\condabin\conda.bat"
if not defined CONDA_BAT if exist "%USERPROFILE%\anaconda3\condabin\conda.bat" set "CONDA_BAT=%USERPROFILE%\anaconda3\condabin\conda.bat"
if not defined CONDA_BAT if exist "%LOCALAPPDATA%\miniconda3\condabin\conda.bat" set "CONDA_BAT=%LOCALAPPDATA%\miniconda3\condabin\conda.bat"
if not defined CONDA_BAT if exist "C:\ProgramData\miniconda3\condabin\conda.bat" set "CONDA_BAT=C:\ProgramData\miniconda3\condabin\conda.bat"
if not defined CONDA_BAT if exist "C:\ProgramData\anaconda3\condabin\conda.bat" set "CONDA_BAT=C:\ProgramData\anaconda3\condabin\conda.bat"

if not defined CONDA_BAT (
    echo [错误] 没有找到 conda.bat。
    echo.
    echo 请确认 Miniconda/Anaconda 已安装。
    echo 如果安装在自定义位置，可在本文件中手动设置 CONDA_BAT。
    echo.
    pause
    exit /b 1
)

echo [1/4] Conda:
echo   %CONDA_BAT%
echo.

pushd "%GPT_SOVITS_HOME%" || (
    echo [错误] 无法进入项目目录。
    pause
    exit /b 1
)

echo [2/4] 检查 GPTSoVits 环境...
call "%CONDA_BAT%" run -n "%ENV_NAME%" python -c "import sys; print(sys.executable)" >nul 2>&1
if errorlevel 1 (
    echo [错误] Conda 环境 "%ENV_NAME%" 不存在或无法启动。
    echo.
    echo 当前项目记录的环境名应为 GPTSoVits。
    echo.
    popd
    pause
    exit /b 1
)
echo   PASS
echo.

echo [3/4] 检查已知 WebUI 依赖...
call "%CONDA_BAT%" run -n "%ENV_NAME%" python -c "import shellingham, rapidfuzz, platformdirs" >nul 2>&1
if errorlevel 1 (
    echo   检测到缺失依赖，自动补齐 shellingham / rapidfuzz / platformdirs...
    call "%CONDA_BAT%" run -n "%ENV_NAME%" --no-capture-output python -m pip install shellingham "rapidfuzz>=3.0.0" "platformdirs>=2.5.0"
    if errorlevel 1 (
        echo.
        echo [错误] 自动补依赖失败。请检查网络或 pip 输出。
        popd
        pause
        exit /b 1
    )
) else (
    echo   PASS
)
echo.

echo [4/4] 启动 GPT-SoVITS 简体中文 WebUI...
echo.
echo 浏览器正常情况下会自动打开。
echo 默认主界面地址: http://127.0.0.1:9874
echo.
echo 关闭本窗口会结束当前 GPT-SoVITS 主进程。
echo ==========================================
echo.

call "%CONDA_BAT%" run -n "%ENV_NAME%" --no-capture-output python webui.py %UI_LANG%
set "EXIT_CODE=%ERRORLEVEL%"

echo.
if not "%EXIT_CODE%"=="0" (
    echo [启动结束 / 异常退出] ExitCode=%EXIT_CODE%
    echo 请保留本窗口报错信息用于排查。
) else (
    echo GPT-SoVITS 已正常退出。
)

popd
echo.
pause
exit /b %EXIT_CODE%
