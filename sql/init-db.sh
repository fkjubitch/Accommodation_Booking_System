#!/bin/bash
# Database initialization script for PostgreSQL
# This script initializes the camping booking system database

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DB_NAME="camping_db"
DB_USER="postgres"
DB_HOST="localhost"
DB_PORT="5432"

echo -e "${YELLOW}=== Camping Booking System - Database Initialization ===${NC}\n"

# Function to execute SQL file
execute_sql_file() {
    local file=$1
    local description=$2
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}Error: File not found: $file${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}Executing: $description${NC}"
    PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f "$file"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ $description completed${NC}\n"
        return 0
    else
        echo -e "${RED}✗ $description failed${NC}\n"
        return 1
    fi
}

# Check if PostgreSQL is running
echo "Checking PostgreSQL connection..."
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d postgres -c "SELECT 1" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Cannot connect to PostgreSQL${NC}"
    echo "Please ensure PostgreSQL is running and credentials are correct"
    exit 1
fi

echo -e "${GREEN}✓ PostgreSQL connection successful${NC}\n"

# Drop existing database if it exists (optional)
read -p "Drop existing database (if exists)? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Dropping existing database..."
    PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d postgres -c "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null
fi

# Create database
echo "Creating database: $DB_NAME"
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d postgres -c "CREATE DATABASE $DB_NAME ENCODING 'UTF8';"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Database created${NC}\n"
else
    echo -e "${RED}✗ Database creation failed${NC}"
    exit 1
fi

# Execute schema files
execute_sql_file "sql/schema_utf8.sql" "Database schema" || exit 1
execute_sql_file "sql/views_triggers.sql" "Views and triggers" || exit 1
execute_sql_file "sql/data.sql" "Sample data" || exit 1

echo -e "${GREEN}=== Database initialization completed successfully ===${NC}"
