#!/bin/bash

logfile="/home/$user/wp_backup.log"
exec > $logfile 2>&1

WEB_ROOT="/home/$user"
WP_DIR="public_html"
DATE=`date +%Y-%m-%d`
DB_USER="$DATABASE_USER"
DB_PWD="$DATABASE_PASSWORD"
DB_HOST="$HOSTNAME"
DB="$DATABASE_NAME"
EMAILED_TO="$EMAIL_ADDRESS_HERE"

echo "This is an automated email from your WordPress backup script located at $WEB_ROOT."
#Backup database to the $WEB_ROOT directory.
cd "$WEB_ROOT"
mysqldump -h "$DB_HOST" -P 3306 -u "$DB_USER" -p"$DB_PWD" "$DB" > "$DB"-"$DATE".sql
echo "Database $DB backup complete."

#Backup $WP_DIR to the $WEB_ROOT directory.
cd "$WEB_ROOT"
tar -czf "$WP_DIR"-"$DATE".tgz "$WP_DIR"
echo "Backup of "$WEB_ROOT"/"$WP_DIR" is complete."
echo "Backups can be found in your $WEB_ROOT"

/bin/mail -s "WordPress Backup Completed!" $EMAILED_TO <<< "The backup of "$WEB_ROOT"/"$WP_DIR" is now completed. You can find your .sql and .tgz file in $WEB_ROOT. See $logfile for more details."
