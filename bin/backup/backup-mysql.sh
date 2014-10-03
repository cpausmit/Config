#!/bin/bash
#----------------------------------------------------------------------------------------------------
# Backup all mysql databases. Careful, this has to be run as root!
#
#                                                                          C.Paus V 1.0 (Oct 02,2014)
#----------------------------------------------------------------------------------------------------

# Definitions
BACKUP_SOURCE=/var/lib/mysql        # mysql base directory
BACKUP_TARGET=/home/system/backup   # target directory for backup

# Timestamp to keep track of versions
timeStamp=`date +"%Y-%m-%d@%H:%M:%S"`
echo ""
echo " Performing backup for myssql databases: $timeStamp"
echo ""

# Make sure target area exists
mkdir -p $BACKUP_TARGET
if [ "$?" != "0" ]
then
  echo " ERROR - target area did not exist and cannot be created."
  exit
fi

# Setup database backup
echo " -> backing up database to: ${BACKUP_TARGET}/mysql_db_${timeStamp}.tgz"
path=`dirname $BACKUP_SOURCE`
dir=`basename $BACKUP_SOURCE`

# Create tar ball
cd  $path
tar fzc ${BACKUP_TARGET}/mysql_db_${timeStamp}.tgz --exclude mysql/mysql.sock $dir
if [ "$?" != "0" ]
then
  echo "    ERROR - target area did not exist and cannot be created."
  exit
else
  echo "    INFO - tar command finished successfully."  
  echo ""
fi

exit 0;
