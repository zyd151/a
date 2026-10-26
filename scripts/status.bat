@echo off
REM =============================================================
REM  状态查看脚本: status.bat
REM =============================================================
setlocal EnableDelayedExpansion
call "%~dp0_env.bat"

echo =============================================================
echo   Hooplab 开发环境 - 运行状态
echo =============================================================
echo   项目根目录: %ROOT%
echo.

call :CHECK "后端 Spring Boot" %BACKEND_PORT% "%BACKEND_URL%" "%BACKEND_LOG%"
call :CHECK "前端 Vue + Vite " %FRONTEND_PORT% "%FRONTEND_URL%" "%FRONTEND_LOG%"

echo.
echo   日志目录: %LOG_DIR%
echo =============================================================
pause
exit /b 0

:CHECK
set "NAME=%~1"
set "PORT=%~2"
set "URL=%~3"
set "LOG=%~4"
set "PID="
netstat -ano | findstr /C:":%PORT% " | findstr /C:"LISTENING" >nul 2>&1
if not errorlevel 1 (
    for /f "tokens=5" %%P in ('netstat -ano ^| findstr /C:":%PORT% " ^| findstr /C:"LISTENING"') do set "PID=%%P"
)
if defined PID (
    echo   %NAME%  运行中   端口 %PORT%   PID !PID!   %URL%
) else (
    echo   %NAME%  已停止   端口 %PORT%               %URL%
)
exit /b 0
