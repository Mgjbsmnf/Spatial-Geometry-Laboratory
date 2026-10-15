@echo off
setlocal EnableExtensions
chcp 65001 >nul
cd /d "%~dp0"
title 空间几何实验室 - 启动诊断

echo ===== 空间几何实验室启动诊断 =====
echo 当前目录：%CD%
echo.

if exist "%~dp0index.html" (
  echo [OK] 找到 index.html
) else (
  echo [FAIL] 没有找到 index.html
)

echo.
echo 尝试调用系统默认浏览器...
start "" "%~dp0index.html"
set "ERR=%ERRORLEVEL%"
echo start 返回代码：%ERR%
echo.
echo 如果浏览器没有打开：
echo 1. 手动双击 index.html
echo 2. 确认电脑已经安装 Chrome / Edge / Firefox 等浏览器
echo 3. 确认文件已经从 ZIP 中解压，而不是直接在压缩包预览窗口里运行
echo 4. 如果网页能打开但三维模型为空，请确认电脑当前能够访问互联网，网页需要加载 Three.js CDN
echo.
pause
