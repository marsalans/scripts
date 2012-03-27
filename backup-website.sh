#!/bin/bash
# backup script for www-data files, mysql dbs with mail notification via sendmail

## config variables
# www-data & backup directories
BACKUPDIR="/root/backups"
WWWDIR="/var/www"
# mysql root pass & database
MYSQLPASS="changeme"
MYSQLDB="changeme_db"
# keep backups only newer than <define> days
HOWOLD="60"
# mail of the site owner
EMAIL="foo@bar.tld"

###################################################################
## gzip www-data files & mysql db
D=`date +'%d-%m-%Y'`
chown -R www-data:www-data $WWWDIR
mkdir /tmp/backup-$D
cd /tmp/backup-$D
tar -cf /tmp/backup-$D/www-data.tar $WWWDIR
mysqldump -u root -p$MYSQLPASS $MYSQLDB > /tmp/backup-$D/$MYSQLDB.sql
tar -czf $BACKUPDIR/backup-$D.tar.gz /tmp/backup-$D
rm -rf /tmp/backup-$D

## delete backup files older than $HOWOLD days
find $BACKUPDIR/* -mtime +$HOWOLD -exec rm {} \;

## mail the site owner
echo "From: backup@server.tld" > /tmp/backup.mail
echo "To: " $EMAIL >> /tmp/backup.mail
echo "Subject: ["$D"] Your weekly backup is ready." >> /tmp/backup.mail
echo "Your backup files are located in " $BACKUPDIR >> /tmp/backup.mail
sendmail -t root < /tmp/backup.mail


