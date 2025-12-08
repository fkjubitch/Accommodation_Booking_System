@echo off
setlocal enabledelayedexpansion

echo.
echo ==========================================
echo Camping Booking System - Quick Start
echo ==========================================
echo.

REM Check Java
echo Checking Java...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Java not found. Please install JDK 11+
    pause
    exit /b 1
)

REM Check PostgreSQL
echo Checking PostgreSQL...
where psql >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: PostgreSQL client not found. Please install PostgreSQL
    pause
    exit /b 1
)

REM Check Maven
echo Checking Maven...
where mvn >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Maven not found. Please install Maven 3.6+
    pause
    exit /b 1
)

echo OK: All tools found
echo.

REM Database settings
set DB_HOST=localhost
set DB_PORT=5432
set DB_NAME=camping_db
set DB_USER=postgres
set DB_PASSWORD=postgres

REM Initialize database
echo [1/4] Initializing database...
psql -h %DB_HOST% -U %DB_USER% -d postgres -f sql\schema.sql
if %errorlevel% neq 0 (
    echo ERROR: Database initialization failed
    echo Please check if PostgreSQL is running
    pause
    exit /b 1
)

psql -h %DB_HOST% -U %DB_USER% -d %DB_NAME% -f sql\views_triggers.sql
psql -h %DB_HOST% -U %DB_USER% -d %DB_NAME% -f sql\data.sql
echo OK: Database initialized
echo.

REM Build backend
echo [2/4] Building backend...
cd backend
call mvn clean package -DskipTests
if %errorlevel% neq 0 (
    echo ERROR: Backend build failed
    cd ..
    pause
    exit /b 1
)
cd ..
echo OK: Backend built
echo.

REM Start backend
echo [3/4] Starting backend service...
start "Camping Backend" cmd /k ^
java -jar backend\target\camping-booking-system-1.0.0.jar ^
  --spring.datasource.url=jdbc:postgresql://%DB_HOST%:%DB_PORT%/%DB_NAME% ^
  --spring.datasource.username=%DB_USER% ^
  --spring.datasource.password=%DB_PASSWORD%

timeout /t 10 /nobreak
echo OK: Backend started at http://localhost:8080/api
echo.

REM Start frontend
echo [4/4] Starting frontend...
cd frontend
start "Camping Frontend" cmd /k npm run dev
cd ..

timeout /t 5 /nobreak

echo.
echo ==========================================
echo SUCCESS: Application started!
echo ==========================================
echo.
echo Frontend: http://localhost:5173
echo Backend:  http://localhost:8080/api
echo Database: localhost:5432/camping_db
echo.
echo Test account:
echo   Username: user1
echo   Password: (empty)
echo.
echo Close console windows to stop services
echo.

pause
