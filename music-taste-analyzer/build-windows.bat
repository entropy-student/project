@echo off
setlocal
cd /d "%~dp0"
if not defined GOPROXY set "GOPROXY=https://goproxy.cn,direct"

if exist ".tools\go\bin\go.exe" (
  set "GO=.tools\go\bin\go.exe"
) else (
  where go >nul 2>nul
  if errorlevel 1 (
    echo [ERROR] Go was not found.
    pause
    exit /b 1
  )
  set "GO=go"
)

if not exist dist mkdir dist
"%GO%" mod download
if errorlevel 1 goto :fail
"%GO%" build -trimpath -ldflags="-s -w" -o dist\music-taste.exe .\cmd\music-taste
if errorlevel 1 goto :fail

echo.
echo Build complete: dist\music-taste.exe
pause
exit /b 0

:fail
echo.
echo Build failed. Check the error above.
pause
exit /b 1
