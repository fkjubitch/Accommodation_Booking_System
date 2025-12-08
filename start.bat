@echo off
REM 快速启动脚本 (Windows 版本)
REM Quick Start Script (Windows Version)

setlocal enabledelayedexpansion

echo.
echo ==========================================
echo 露营营地预订系统 - 快速启动 (Windows)
echo ==========================================
echo.

REM 检查前置工具
echo [1/6] 检查前置工具...

java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 未找到 Java，请先安装 JDK 11+
    pause
    exit /b 1
)

where psql >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 未找到 PostgreSQL 客户端，请先安装 PostgreSQL
    pause
    exit /b 1
)

where mvn >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 未找到 Maven，请先安装 Maven 3.6+
    pause
    exit /b 1
)

echo ✓ 所有必要工具已安装
echo.

REM 设置数据库连接参数
set DB_HOST=localhost
set DB_PORT=5432
set DB_NAME=camping_db
set DB_USER=postgres
set DB_PASSWORD=postgres

REM 初始化数据库
echo [2/6] 初始化数据库...

psql -h %DB_HOST% -U %DB_USER% -d postgres -f sql\schema.sql >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 数据库初始化失败
    echo 请检查 PostgreSQL 是否运行，以及连接参数是否正确
    pause
    exit /b 1
)

psql -h %DB_HOST% -U %DB_USER% -d %DB_NAME% -f sql\views_triggers.sql >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 视图和触发器创建失败
    pause
    exit /b 1
)

psql -h %DB_HOST% -U %DB_USER% -d %DB_NAME% -f sql\data.sql >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 初始数据插入失败
    pause
    exit /b 1
)

echo ✓ 数据库初始化完成
echo.

REM 构建后端
echo [3/6] 构建后端项目...

cd backend

call mvn clean package -DskipTests >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 后端构建失败
    cd ..
    pause
    exit /b 1
)

echo ✓ 后端构建完成
echo.

cd ..

REM 启动后端
echo [4/6] 启动后端服务...

start "Camping Backend API" cmd /k ^
java -jar backend\target\camping-booking-system-1.0.0.jar ^
  --spring.datasource.url=jdbc:postgresql://%DB_HOST%:%DB_PORT%/%DB_NAME% ^
  --spring.datasource.username=%DB_USER% ^
  --spring.datasource.password=%DB_PASSWORD%

timeout /t 10 /nobreak

echo ✓ 后端服务已启动
echo   API 地址: http://localhost:8080/api
echo.

REM 构建前端
echo [5/6] 构建前端项目...

cd frontend

call npm install >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 前端依赖安装失败
    cd ..
    pause
    exit /b 1
)

echo ✓ 前端依赖安装完成
echo.

REM 启动前端
echo [6/6] 启动前端开发服务器...

start "Camping Frontend" cmd /k npm run dev

timeout /t 5 /nobreak

cd ..

echo.
echo ==========================================
echo ✓ 应用启动完成！
echo ==========================================
echo.
echo 访问地址:
echo   - 前端应用: http://localhost:5173
echo   - 后端 API: http://localhost:8080/api
echo   - 数据库: localhost:5432/camping_db
echo.
echo 测试账号:
echo   - 用户名: user1
echo   - 密码: (空字符串)
echo.
echo 停止应用: 关闭对应的命令窗口或按 Ctrl+C
echo.

pause
