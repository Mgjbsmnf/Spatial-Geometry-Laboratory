@echo off
setlocal EnableExtensions
chcp 65001 >nul
title 空间几何实验室 - 安装 Python

echo 正在检查 Python...
py -3 --version >nul 2>nul && goto :already
python --version >nul 2>nul && goto :already

where winget.exe >nul 2>nul
if not errorlevel 1 (
  echo 未检测到 Python，正在通过 winget 安装 Python 3.12（当前用户）...
  winget install -e --id Python.Python.3.12 --scope user --silent --accept-package-agreements --accept-source-agreements
  if not errorlevel 1 goto :done
  echo winget 安装失败，将尝试官方下载方式...
)

echo 正在从 Python 官方网站下载安装程序...
set "PYINSTALLER=%TEMP%\python-3.12.10-amd64.exe"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -UseBasicParsing 'https://www.python.org/ftp/python/3.12.10/python-3.12.10-amd64.exe' -OutFile '%PYINSTALLER%'"
if errorlevel 1 goto :fail

"%PYINSTALLER%" /quiet InstallAllUsers=0 PrependPath=1 Include_test=0 Include_launcher=1
if errorlevel 1 goto :fail

echo Python 安装程序已执行完成。
goto :done

:already
echo 已检测到 Python，无需安装。
goto :done

:fail
echo.
echo 自动安装 Python 失败。
echo 你仍可直接运行 Start-Windows-No-Python.bat，它不要求安装 Python。
pause
exit /b 1

:done
echo.
echo 完成。现在可以运行 Start-Windows-AutoPython.bat 或 Start-Windows-No-Python.bat。
pause
endlocal
