#!/bin/bash

# Set variables
S3_BUCKET="s3://app-bucket-123"
LOCAL_BACKUP_DIR="/var/backups/postgresql"

# Ensure local backup directory exists
mkdir -p "$LOCAL_BACKUP_DIR"

# Restore the database
LATEST_FILE=$(aws s3 ls $S3_BUCKET/backups/ --recursive | sort | tail -n 1 | awk '{print $4}')
aws s3 cp $S3_BUCKET/$LATEST_FILE $LOCAL_BACKUP_DIR/

PGPASSWORD="your_password" pg_restore -h "db_hostname" -p "5432" -U "db_username" -d "db_name" -v "$LOCAL_BACKUP_DIR/$LATEST_BACKUP"

# Verify restore success
if [ $? -eq 0 ]; then
    echo "Database restored successfully from $LATEST_BACKUP"
else
    echo "Database restore failed!"
    exit 1
fi