@echo off
REM =============================================================
REM  内部脚本：按端口杀掉占用进程（供 stop.bat 调用）
REM  用法: call _kill-port.bat 8081
REM  返回: 0=没有进程需要杀, 1=已杀掉进程
REM =============================================================
setlocal
set "PORT=%~1"
if "%PORT%"=="" exit /b 0

set "KILLED=0"
for /f "tokens=5" %%P in ('netstat -ano ^| findstr /C:":%PORT% " ^| findstr /C:"LISTENING"') do (
    if not "%%P"=="0" (
        taskkill /F /T /PID %%P >nul 2>&1
        set "KILLED=1"
    )
)
endlocal & exit /b %KILLED%
