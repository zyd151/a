@echo off
REM =============================================================
REM  内部脚本：前端启动器（由 start.bat 在最小化窗口中拉起）
REM  node_modules 每次都会被清空，这里用 npm run dev，
REM  由 npm 自行解析依赖，不直接引用 node_modules 下的可执行文件。
REM =============================================================
chcp 936 >nul 2>&1
title hooplab-frontend

set "LOGDIR=%~dp0..\.run\logs"
if not exist "%LOGDIR%" mkdir "%LOGDIR%" >nul 2>&1

cd /d "%~dp0..\hooplab-login"

echo 前端启动中...
echo 日志文件: %LOGDIR%\frontend.log
echo.

call npm run dev > "%LOGDIR%\frontend.log" 2>&1

echo.
echo 前端进程已退出，按任意键关闭窗口...
pause >nul
