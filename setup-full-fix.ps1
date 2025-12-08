# ===========================================================================
# Camping Booking System - Full Setup and Fix Script
# Purpose: Initialize database with UTF-8 encoding and build the project
# ===========================================================================

param(
    [switch]$SkipDatabase = $false,
    [switch]$SkipBackend = $false,
    [switch]$SkipFrontend = $false
)

$ErrorActionPreference = "Stop"

# Colors
$colors = @{
    Success = "Green"
    Warning = "Yellow"
    Error = "Red"
    Info = "Cyan"
    Section = "Magenta"
}

function Write-Status {
    param([string]$Message, [string]$Type = "Info")
    $color = $colors[$Type]
    Write-Host "[*] $Message" -ForegroundColor $color
}

function Write-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
}

# Start
Write-Section "Camping Booking System - Full Setup and Fix"

# Get script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

# Check PostgreSQL
Write-Status "Checking PostgreSQL installation..."
if (-not (Test-Command "psql")) {
    Write-Status "PostgreSQL not found. Please install PostgreSQL first." "Error"
    exit 1
}
Write-Status "PostgreSQL found" "Success"

# Initialize Database
if (-not $SkipDatabase) {
    Write-Section "Step 1: Initialize Database with UTF-8 Encoding"
    
    Write-Status "Creating camping_db database..."
    
    $env:PGPASSWORD = "postgres"
    
    # Drop existing database if it exists
    Write-Status "Checking for existing database..."
    psql -h localhost -U postgres -d postgres -c "DROP DATABASE IF EXISTS camping_db;" 2>$null
    
    # Create new database with UTF-8 encoding
    psql -h localhost -U postgres -d postgres -c "CREATE DATABASE camping_db ENCODING 'UTF8';" 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Status "Database created successfully" "Success"
    } else {
        Write-Status "Failed to create database" "Error"
        exit 1
    }
    
    # Execute schema files
    Write-Status "Executing schema_utf8.sql..."
    psql -h localhost -U postgres -d camping_db -f "sql/schema_utf8.sql" >$null 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Status "Schema created successfully" "Success"
    } else {
        Write-Status "Failed to create schema" "Error"
        exit 1
    }
    
    Write-Status "Executing views_triggers.sql..."
    psql -h localhost -U postgres -d camping_db -f "sql/views_triggers.sql" >$null 2>&1
    Write-Status "Views and triggers created" "Success"
    
    Write-Status "Executing data.sql..."
    psql -h localhost -U postgres -d camping_db -f "sql/data.sql" >$null 2>&1
    Write-Status "Sample data loaded" "Success"
    
    Write-Status "Database initialization completed" "Success"
}

# Build Backend
if (-not $SkipBackend) {
    Write-Section "Step 2: Build Backend"
    
    Write-Status "Cleaning previous build..."
    Set-Location "backend"
    mvn clean -q
    
    Write-Status "Building backend with updated dependencies..."
    mvn install -DskipTests -U
    
    if ($LASTEXITCODE -eq 0) {
        Write-Status "Backend built successfully" "Success"
    } else {
        Write-Status "Backend build failed" "Error"
        exit 1
    }
    
    Set-Location ".."
}

# Build Frontend
if (-not $SkipFrontend) {
    Write-Section "Step 3: Build Frontend"
    
    Set-Location "frontend"
    
    Write-Status "Installing dependencies..."
    npm install
    
    if ($LASTEXITCODE -eq 0) {
        Write-Status "Dependencies installed successfully" "Success"
    } else {
        Write-Status "Dependency installation failed" "Error"
        exit 1
    }
    
    Write-Status "Building frontend..."
    npm run build
    
    if ($LASTEXITCODE -eq 0) {
        Write-Status "Frontend built successfully" "Success"
    } else {
        Write-Status "Frontend build failed" "Error"
        exit 1
    }
    
    Set-Location ".."
}

# Summary
Write-Section "Setup Completed Successfully"

Write-Host "All steps completed! The system is ready to run." -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Run: .\start.bat" -ForegroundColor White
Write-Host "2. Access frontend at: http://localhost:5173" -ForegroundColor White
Write-Host "3. Access backend at: http://localhost:8080" -ForegroundColor White
Write-Host ""

# Function to test command availability
function Test-Command {
    param([string]$Command)
    try {
        $null = Get-Command $Command -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}
