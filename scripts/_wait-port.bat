@echo off
REM =============================================================
REM  内部脚本：等待某个端口进入 LISTENING 状态
REM  用法: call _wait-port.bat 8081 120
REM  返回: 0=端口已就绪, 1=超时
REM =============================================================
setlocal EnableDelayedExpansion
set "PORT=%~1"
set "MAX=%~2"
if "%PORT%"=="" exit /b 1
if "%MAX%"=="" set "MAX=90"

for /L %%i in (1,1,%MAX%) do (
    netstat -ano | findstr /C:":%PORT% " | findstr /C:"LISTENING" >nul 2>&1
    if !errorlevel!==0 exit /b 0
    ping -n 2 127.0.0.1 >nul 2>&1
)
exit /b 1
