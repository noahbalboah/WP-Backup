#!/bin/bash

#This is setup for a logfile in the $WEB_ROOT
LOG_FILE="/home/$user/wp_backup.log"
exec > $LOG_FILE 2>&1

WEB_ROOT="/home/$user"
WP_DIR="public_html"
DATE=`date +%Y-%m-%d`
DB_USER="$DATABASE_USER"
DB_PWD="$DATABASE_PASSWORD"
DB_HOST="$HOSTNAME"
DB="$DATABASE_NAME"
EMAIL="$EMAIL_ADDRESS_HERE"

#Backup $DB to the $WEB_ROOT directory.
cd "$WEB_ROOT"
mysqldump -h "$DB_HOST" -P 3306 -u "$DB_USER" -p"$DB_PWD" "$DB" > "$DB"-"$DATE".sql
echo "Database $DB backup complete."

#Backup $WP_DIR to the $WEB_ROOT directory.
cd "$WEB_ROOT"
tar -czf "$WP_DIR"-"$DATE".tgz "$WP_DIR"
echo "Backup of "$WEB_ROOT"/"$WP_DIR" is complete."

#Sends an email to the $EMAIL defined on line #14
/bin/mail -s "WordPress Backup Completed!" $EMAIL <<< "The backup of "$WEB_ROOT"/"$WP_DIR" is now completed. You can find your .sql and .tgz file in $WEB_ROOT. See $LOG_FILE for more details."
