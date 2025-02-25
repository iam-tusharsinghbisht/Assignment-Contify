#!/bin/bash

# Set variables
BACKUP_DIR="/var/backups/postgresql"
DB_NAME="app-db"
BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$(date +"%F-%H%M%S").sql"
S3_BUCKET="s3://app-bucket-123"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Create PostgreSQL database backup
PGPASSWORD="your_password" pg_dump -h "db_hostname" -p "5432" -U "db_username" -d $DB_NAME -F c -b -f "$BACKUP_FILE"

# Verify backup success
if [ $? -eq 0 ]; then
    echo "Backup created successfully: $BACKUP_FILE"
    
    # Upload backup to S3
    aws s3 cp "$BACKUP_FILE" "$S3_BUCKET/backups/"
    
    # Delete old backups (keep last 7 days)
    find "$BACKUP_DIR" -type f -mtime +7 -name "*.sql" -exec rm {} \;
else
    echo "Backup failed!"
    exit 1
fi
