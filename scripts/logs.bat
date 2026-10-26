@echo off
REM =============================================================
REM  日志查看脚本（用记事本打开）
REM  用法: logs.bat [backend|frontend]
REM =============================================================
call "%~dp0_env.bat"

set "WHICH=%~1"
if "%WHICH%"=="" set "WHICH=backend"

if /i "%WHICH%"=="backend" goto :OPEN_BACKEND
if /i "%WHICH%"=="be" goto :OPEN_BACKEND
if /i "%WHICH%"=="frontend" goto :OPEN_FRONTEND
if /i "%WHICH%"=="front" goto :OPEN_FRONTEND
if /i "%WHICH%"=="fe" goto :OPEN_FRONTEND
echo [错误] 未知参数 "%WHICH%"
echo        用法: logs.bat [backend^|frontend]
pause
exit /b 1

:OPEN_BACKEND
start "" notepad "%BACKEND_LOG%"
exit /b 0

:OPEN_FRONTEND
start "" notepad "%FRONTEND_LOG%"
exit /b 0
