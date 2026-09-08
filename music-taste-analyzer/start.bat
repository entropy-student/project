@echo off
setlocal
cd /d "%~dp0"

if exist "dist\music-taste.exe" (
  "dist\music-taste.exe"
  goto :eof
)

if not defined GOPROXY set "GOPROXY=https://goproxy.cn,direct"
if exist ".tools\go\bin\go.exe" (
  set "GO=.tools\go\bin\go.exe"
) else (
  where go >nul 2>nul
  if errorlevel 1 (
    echo [ERROR] Go was not found.
    echo Keep your existing .tools\go folder in this project, or install Go 1.23+.
    pause
    exit /b 1
  )
  set "GO=go"
)

"%GO%" run .\cmd\music-taste
if errorlevel 1 pause
