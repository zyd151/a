@echo off
REM =============================================================
REM  启动脚本
REM  用法:
REM    start.bat              启动后端 + 前端
REM    start.bat backend      只启动后端
REM    start.bat frontend     只启动前端
REM    start.bat all -i       启动全部，并强制重新 npm install
REM =============================================================
call "%~dp0_env.bat"

set "TARGET=%~1"
if "%TARGET%"=="" set "TARGET=all"
set "FORCE_INSTALL=%~2"

echo =============================================================
echo   Hooplab 开发环境 - 启动
echo =============================================================
echo   项目根目录: %ROOT%
echo   后端 Spring Boot  端口 %BACKEND_PORT%   %BACKEND_URL%
echo   前端 Vue + Vite   端口 %FRONTEND_PORT%   %FRONTEND_URL%
echo   日志目录    : %LOG_DIR%
echo =============================================================
echo.

if /i "%TARGET%"=="all" goto :DO_BACKEND
if /i "%TARGET%"=="backend" goto :DO_BACKEND
if /i "%TARGET%"=="be" goto :DO_BACKEND
if /i "%TARGET%"=="frontend" goto :DO_FRONTEND
if /i "%TARGET%"=="front" goto :DO_FRONTEND
if /i "%TARGET%"=="fe" goto :DO_FRONTEND
echo [错误] 未知参数 "%TARGET%"
echo        用法: start.bat [all^|backend^|frontend] [-i]
pause
exit /b 1

REM =========================== 后端 ===========================
:DO_BACKEND
echo ------------------------------------------------------------
echo [1] 后端 Spring Boot
echo ------------------------------------------------------------
call "%~dp0stop.bat" backend quiet

if not exist "%BACKEND_DIR%\pom.xml" goto :NO_POM
if not exist "%MVN_CMD%" goto :NO_MVN
java -version >nul 2>&1
if errorlevel 1 goto :NO_JAVA

echo   target 目录为空，本次将重新编译，耗时较长...
start "%BACKEND_TITLE%" /MIN "%COMSPEC%" /c "%~dp0_run-backend.bat"
echo   等待端口 %BACKEND_PORT% ...
call "%~dp0_wait-port.bat" %BACKEND_PORT% 180
if errorlevel 1 goto :BACKEND_TIMEOUT
echo   [完成] 后端已启动: %BACKEND_URL%
goto :AFTER_BACKEND

:NO_POM
echo   [错误] 找不到 pom.xml: %BACKEND_DIR%\pom.xml
goto :AFTER_BACKEND
:NO_MVN
echo   [错误] 找不到 Maven 包装脚本: %MVN_CMD%
goto :AFTER_BACKEND
:NO_JAVA
echo   [错误] 未检测到 java，请安装 JDK 17+ 或在 _env.bat 中配置 JAVA_HOME
goto :AFTER_BACKEND
:BACKEND_TIMEOUT
echo   [警告] 后端在 180 秒内未监听端口 %BACKEND_PORT%
echo          请查看日志: %BACKEND_LOG%
echo          常见原因: MySQL 未启动、依赖下载失败、端口被占用

:AFTER_BACKEND
if /i "%TARGET%"=="backend" goto :DONE
if /i "%TARGET%"=="be" goto :DONE

REM =========================== 前端 ===========================
:DO_FRONTEND
echo.
echo ------------------------------------------------------------
echo [2] 前端 Vue + Vite
echo ------------------------------------------------------------
call "%~dp0stop.bat" frontend quiet

if not exist "%FRONTEND_DIR%\package.json" goto :NO_PKG
where npm >nul 2>&1
if errorlevel 1 goto :NO_NPM
goto :CHECK_MODULES

:NO_PKG
echo   [错误] 找不到 package.json: %FRONTEND_DIR%\package.json
goto :DONE
:NO_NPM
echo   [错误] 未检测到 npm，请安装 Node.js 18+ 或在 _env.bat 中配置 NODE_HOME
goto :DONE

:CHECK_MODULES
set "NEED_INSTALL=0"
if /i "%FORCE_INSTALL%"=="-i" set "NEED_INSTALL=1"
if /i "%FORCE_INSTALL%"=="--install" set "NEED_INSTALL=1"
if not exist "%FRONTEND_DIR%\node_modules" set "NEED_INSTALL=1"
if "%NEED_INSTALL%"=="1" goto :NPM_INSTALL
echo   已存在 node_modules，跳过安装（如需强制重装请加 -i 参数）
goto :NPM_DONE

:NPM_INSTALL
echo   node_modules 不存在，正在执行 npm install ...
pushd "%FRONTEND_DIR%"
call npm install
popd
if errorlevel 1 goto :NPM_FAIL
goto :NPM_DONE
:NPM_FAIL
echo   [错误] npm install 失败，前端未启动
goto :DONE

:NPM_DONE
start "%FRONTEND_TITLE%" /MIN "%COMSPEC%" /c "%~dp0_run-frontend.bat"
echo   等待端口 %FRONTEND_PORT% ...
call "%~dp0_wait-port.bat" %FRONTEND_PORT% 90
if errorlevel 1 goto :FRONTEND_TIMEOUT
echo   [完成] 前端已启动: %FRONTEND_URL%
goto :DONE

:FRONTEND_TIMEOUT
echo   [警告] 前端在 90 秒内未监听端口 %FRONTEND_PORT%
echo          请查看日志: %FRONTEND_LOG%

:DONE
echo.
echo =============================================================
echo   启动流程结束
echo   服务运行在最小化窗口中，可用 status.bat 查看状态、stop.bat 停止
echo   日志文件目录: %LOG_DIR%
echo =============================================================
pause
