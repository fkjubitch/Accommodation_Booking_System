@echo off
REM Quick database fix script - just drop and recreate database

setlocal enabledelayedexpansion

set DB_NAME=camping_db
set DB_USER=postgres
set DB_HOST=localhost

echo.
echo ===================================================
echo  Quick Database Fix
echo ===================================================
echo.

REM Set password
set PGPASSWORD=yangxy

echo Step 1: Dropping existing database...
psql -h %DB_HOST% -U %DB_USER% -d postgres -c "DROP DATABASE IF EXISTS %DB_NAME%;" 2>nul
echo Done.
echo.

echo Step 2: Creating new UTF-8 database...
psql -h %DB_HOST% -U %DB_USER% -d postgres -c "CREATE DATABASE %DB_NAME% ENCODING 'UTF8';" 2>nul
if errorlevel 1 (
    echo Error: Failed to create database
    pause
    exit /b 1
)
echo Done.
echo.

echo Step 3: Loading schema...
cd /d "%~dp0"
psql -h %DB_HOST% -U %DB_USER% -d %DB_NAME% -f schema_utf8.sql 2>nul
echo Done.
echo.

echo Step 4: Loading views and triggers...
psql -h %DB_HOST% -U %DB_USER% -d %DB_NAME% -f views_triggers.sql 2>nul
echo Done.
echo.

echo Step 5: Loading sample data...
psql -h %DB_HOST% -U %DB_USER% -d %DB_NAME% -f data.sql 2>nul
echo Done.
echo.

echo ===================================================
echo Database successfully reset!
echo ===================================================
pause
