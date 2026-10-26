@echo off
REM =============================================================
REM  公共环境配置（供其它脚本 call 调用，请勿直接双击运行）
REM  编码：GBK
REM =============================================================
chcp 936 >nul 2>&1

REM ---- 可选：如果 java / npm 不在系统 PATH 中，取消下面的 REM 并改成你的实际路径 ----
REM set "JAVA_HOME=C:\Program Files\Zulu\zulu-21"
REM set "NODE_HOME=D:\Program Files\nodejs"

if defined JAVA_HOME set "PATH=%JAVA_HOME%\bin;%PATH%"
if defined NODE_HOME set "PATH=%NODE_HOME%;%PATH%"

REM ---- 所有路径都相对脚本自身位置推导，脚本目录整体搬家也能用 ----
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "ROOT=%%~fI"

set "BACKEND_DIR=%ROOT%\springBootTest"
set "FRONTEND_DIR=%ROOT%\hooplab-login"

REM ---- 端口（与 application-dev.properties / vite.config.js 保持一致）----
set "BACKEND_PORT=8081"
set "FRONTEND_PORT=5173"

REM ---- 运行期文件（日志）统一放到 .run 目录，不污染源码 ----
set "RUN_DIR=%ROOT%\.run"
set "LOG_DIR=%RUN_DIR%\logs"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1

set "BACKEND_LOG=%LOG_DIR%\backend.log"
set "FRONTEND_LOG=%LOG_DIR%\frontend.log"

set "BACKEND_TITLE=hooplab-backend"
set "FRONTEND_TITLE=hooplab-frontend"
set "BACKEND_URL=http://localhost:%BACKEND_PORT%"
set "FRONTEND_URL=http://localhost:%FRONTEND_PORT%"

REM ---- 启动命令：只依赖源码目录，不依赖 node_modules / target ----
set "MVN_CMD=%BACKEND_DIR%\mvnw.cmd"
set "NPM_CMD=npm"
