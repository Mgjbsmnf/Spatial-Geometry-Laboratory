@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title 空间几何实验室

echo ========================================
echo        空间几何实验室 - 启动器
echo ========================================
echo.
echo 正在使用默认浏览器打开网页...
echo 本方式不需要 Python，也不需要 PowerShell 本地服务器。
echo.

if not exist "%~dp0index.html" (
  echo [错误] 当前文件夹中没有找到 index.html
  echo 请确认 ZIP 已完整解压后再运行。
  echo.
  pause
  exit /b 1
)

start "" "%~dp0index.html"
if errorlevel 1 (
  echo [错误] 无法调用默认浏览器。
  echo 请手动双击当前文件夹中的 index.html。
  echo.
  pause
  exit /b 1
)

echo 已发送打开指令。
echo 如果浏览器没有自动出现，请直接双击 index.html。
echo.
echo 你现在可以关闭此窗口。
timeout /t 3 /nobreak >nul
exit /b 0
