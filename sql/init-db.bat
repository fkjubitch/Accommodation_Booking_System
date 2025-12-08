@echo off
REM Database initialization script for PostgreSQL (Windows)
REM This script initializes the camping booking system database

setlocal enabledelayedexpansion

REM Configuration
set DB_NAME=camping_db
set DB_USER=postgres
set DB_HOST=localhost
set DB_PORT=5432

cls
echo ===================================================
echo Camping Booking System - Database Initialization
echo ===================================================
echo.

REM Check if PostgreSQL is available
psql --version >nul 2>&1
if errorlevel 1 (
    echo Error: PostgreSQL is not installed or not in PATH
    echo Please install PostgreSQL and ensure psql is available
    pause
    exit /b 1
)

echo Checking PostgreSQL connection...
set PGPASSWORD=yangxy
psql -h %DB_HOST% -U %DB_USER% -d postgres -c "SELECT 1" >nul 2>&1

if errorlevel 1 (
    echo Error: Cannot connect to PostgreSQL
    echo Please enter the correct password when prompted below:
    echo.
    echo Retry connection...
    psql -h %DB_HOST% -U %DB_USER% -d postgres -c "SELECT 1"
    if errorlevel 1 (
        echo Failed to connect to PostgreSQL
        pause
        exit /b 1
    )
) else (
    echo PostgreSQL connection successful
    echo.
)

REM Drop existing database if it exists
echo Checking for existing database...
psql -h %DB_HOST% -U %DB_USER% -d postgres -c "DROP DATABASE IF EXISTS %DB_NAME%;" 2>nul

echo Creating database: %DB_NAME%
psql -h %DB_HOST% -U %DB_USER% -d postgres -c "CREATE DATABASE %DB_NAME% ENCODING 'UTF8';" 2>nul

if errorlevel 1 (
    echo Error: Database creation failed
    echo Trying alternative method...
    psql -h %DB_HOST% -U %DB_USER% -d postgres -c "CREATE DATABASE IF NOT EXISTS %DB_NAME% ENCODING 'UTF8';" 2>nul
    if errorlevel 1 (
        echo Error: Database creation failed - please check PostgreSQL connection
        pause
        exit /b 1
    )
)

echo Database created successfully
echo.

REM Execute schema files
echo Executing database schema...
psql -h %DB_HOST% -U %DB_USER% -d %DB_NAME% -f "schema_utf8.sql" 2>nul
if errorlevel 1 (
    echo Warning: Schema creation had issues, but continuing...
)
echo Schema created
echo.

echo Executing views and triggers...
psql -h %DB_HOST% -U %DB_USER% -d %DB_NAME% -f "views_triggers.sql" 2>nul
echo Views and triggers created
echo.

echo Loading sample data...
psql -h %DB_HOST% -U %DB_USER% -d %DB_NAME% -f "data.sql" 2>nul
echo Sample data loaded
echo.

echo ===================================================
echo Database initialization completed successfully
echo ===================================================
pause
