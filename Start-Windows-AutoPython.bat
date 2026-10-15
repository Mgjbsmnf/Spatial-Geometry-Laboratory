@echo off
setlocal EnableExtensions
chcp 65001 >nul
cd /d "%~dp0"
title 空间几何实验室 - 自动 Python 启动

set "PY_CMD="
py -3 --version >nul 2>nul && set "PY_CMD=py -3"
if not defined PY_CMD python --version >nul 2>nul && set "PY_CMD=python"

if not defined PY_CMD (
  echo 未检测到 Python，将启动自动安装脚本。
  call "%~dp0Install-Python-Windows.bat"

  py -3 --version >nul 2>nul && set "PY_CMD=py -3"
  if not defined PY_CMD python --version >nul 2>nul && set "PY_CMD=python"
  if not defined PY_CMD if exist "%LocalAppData%\Programs\Python\Python312\python.exe" set "PY_CMD=%LocalAppData%\Programs\Python\Python312\python.exe"
)

if not defined PY_CMD (
  echo.
  echo 自动安装后仍未检测到 Python，将改用 Windows PowerShell 免 Python 模式。
  call "%~dp0Start-Windows-No-Python.bat"
  exit /b %errorlevel%
)

echo 正在启动本地网页服务：http://127.0.0.1:8000/
start "" "http://127.0.0.1:8000/"
%PY_CMD% -m http.server 8000 --bind 127.0.0.1

endlocal
