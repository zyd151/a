@echo off
REM =============================================================
REM  停止脚本
REM  用法:
REM    stop.bat              停止后端 + 前端
REM    stop.bat backend      只停止后端
REM    stop.bat frontend     只停止前端
REM  说明: 通过端口 + 窗口标题定位进程，不依赖任何运行期文件
REM =============================================================
call "%~dp0_env.bat"

set "TARGET=%~1"
if "%TARGET%"=="" set "TARGET=all"
set "QUIET=%~2"

if /i "%QUIET%"=="quiet" goto :CHECK_TARGET
echo =============================================================
echo   Hooplab 开发环境 - 停止
echo =============================================================

:CHECK_TARGET
if /i "%TARGET%"=="all" goto :STOP_BACKEND
if /i "%TARGET%"=="backend" goto :STOP_BACKEND
if /i "%TARGET%"=="be" goto :STOP_BACKEND
if /i "%TARGET%"=="frontend" goto :STOP_FRONTEND
if /i "%TARGET%"=="front" goto :STOP_FRONTEND
if /i "%TARGET%"=="fe" goto :STOP_FRONTEND
echo [错误] 未知参数 "%TARGET%"
echo        用法: stop.bat [all^|backend^|frontend]
pause
exit /b 1

REM =========================== 后端 ===========================
:STOP_BACKEND
if /i not "%QUIET%"=="quiet" echo [1] 停止后端 (端口 %BACKEND_PORT%) ...
call "%~dp0_kill-port.bat" %BACKEND_PORT%
taskkill /F /FI "WINDOWTITLE eq %BACKEND_TITLE%" >nul 2>&1
if /i not "%QUIET%"=="quiet" echo   [完成] 后端已停止
if /i "%TARGET%"=="backend" goto :DONE
if /i "%TARGET%"=="be" goto :DONE

REM =========================== 前端 ===========================
:STOP_FRONTEND
if /i not "%QUIET%"=="quiet" echo [2] 停止前端 (端口 %FRONTEND_PORT%) ...
call "%~dp0_kill-port.bat" %FRONTEND_PORT%
taskkill /F /FI "WINDOWTITLE eq %FRONTEND_TITLE%" >nul 2>&1
if /i not "%QUIET%"=="quiet" echo   [完成] 前端已停止

:DONE
if /i "%QUIET%"=="quiet" exit /b 0
echo.
echo =============================================================
echo   已全部停止
echo =============================================================
pause
