@echo off
REM =============================================================
REM  内部脚本：后端启动器（由 start.bat 在最小化窗口中拉起）
REM  target 目录每次都会被清空，这里用 mvnw + spring-boot:run 重新编译运行，
REM  不读取 target 下任何已有内容。
REM =============================================================
chcp 936 >nul 2>&1
title hooplab-backend

set "LOGDIR=%~dp0..\.run\logs"
if not exist "%LOGDIR%" mkdir "%LOGDIR%" >nul 2>&1

cd /d "%~dp0..\springBootTest"

echo 后端启动中，首次启动需重新编译，请耐心等待...
echo 日志文件: %LOGDIR%\backend.log
echo.

call "%~dp0..\springBootTest\mvnw.cmd" -Dspring-boot.run.profiles=dev spring-boot:run > "%LOGDIR%\backend.log" 2>&1

echo.
echo 后端进程已退出，按任意键关闭窗口...
pause >nul
