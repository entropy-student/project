@echo off
pwsh -NoProfile -File "%~dp0scripts\Publish-StaticSite.ps1"
if errorlevel 1 echo Deployment failed. Please keep this window open and check the error above.
pause
