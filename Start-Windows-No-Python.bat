@echo off
chcp 65001 >nul
cd /d "%~dp0"
title 空间几何实验室 - 无需 Python
where powershell.exe >nul 2>nul
if errorlevel 1 (
  echo 未找到 Windows PowerShell，无法使用免 Python 启动方式。
  echo 请运行 Start-Windows-AutoPython.bat。
  pause
  exit /b 1
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0local-server.ps1" -Port 8000
if errorlevel 1 (
  echo.
  echo PowerShell 本地服务启动失败，请尝试 Start-Windows-AutoPython.bat。
  pause
)
